import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DayChange.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/NoData.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class FundDetails extends StatefulWidget {
  const FundDetails({
    super.key,
    required this.schemeName,
    required this.schemeCategory,
    required this.schemeAmfiCode,
    required this.currCost,
    required this.currValue,
    required this.xirr,
    required this.schemeAmcLogo,
    required this.folio,
    required this.folioType,
    this.oneDayChange = 0
  });

  final String schemeName,
      schemeCategory,
      xirr,
      schemeAmcLogo,
      folio,
      schemeAmfiCode,folioType;
  final num currCost, currValue ,oneDayChange;

  @override
  State<FundDetails> createState() => _FundDetailsState();
}

class _FundDetailsState extends State<FundDetails> {
  late double devWidth;
  late num oneDayChange;
  Iterable keys = GetStorage().getKeys();

  //same screen used for inv & family
  int userId = GetStorage().read('user_id') ?? GetStorage().read("family_id");
  Map result = {};
  String clientName = GetStorage().read("client_name");

  bool isLoading = true;
  List<dynamic> transctionData = [];
  Future getSchemeTransactions() async {
    try {
      isLoading = true;
      Map data = await InvestorApi.getSchemeTransactions(
          user_id: userId,
          client_name: clientName,
          folio: widget.folio,
          scheme_code: widget.schemeAmfiCode, folio_type: widget.folioType);

      if (data['status'] != 200) {
        Utils.showError(context, data['msg']);
        return -1;
      }

      result = data['scheme_details'];
      transctionData = data['transaction_list'];
      print("folio no = ${result['folio_no']}");
    } catch (e) {
      print("getSchemeTransactions exception = $e");
    } finally {
      isLoading = false;
    }
  }

  Future getDatas() async {
    isLoading = true;
    try {
      await getSchemeTransactions();
    } catch (e) {
      print("getDatas exception = $e");
    }
    isLoading = false;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    oneDayChange= widget.oneDayChange;
  }

  late Map transactionList;

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: AppBar(
              backgroundColor: Config.appTheme.themeColor,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            body: SideBar(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    greenArea(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Folio Details", style: AppFonts.f50014Grey),
                          folioDetails(),
                          Text("Gain/Loss Details", style: AppFonts.f50014Grey),
                          gainLossDetails(),
                          Text("Transactions", style: AppFonts.f50014Grey),
                          trnxArea(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget trnxArea() {
    if (transctionData.isEmpty) return NoData(margin: EdgeInsets.only(top: 16));

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: transctionData.length,
      itemBuilder: (context, index) {
        return transactionTile(index);
      },
    );
  }

  Widget transactionTile(int index) {
    double transNav = transctionData[index]['tranx_nav'];
    double tranxUnits = transctionData[index]['tranx_units'];
    return Container(
      width: devWidth,
      margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
      padding: EdgeInsets.all(16.0), // Add padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffECFFFF), // Background color
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                padding: EdgeInsets.all(8), // Adjust padding as needed
                child: Text(
                  '${transctionData[index]['tranx_type']}',
                  style: AppFonts.f50014Black
                      .copyWith(color: Config.appTheme.themeColor),
                ),
              ),
              Text(
                "$rupee ${Utils.formatNumber(transctionData[index]['tranx_amount'], isAmount: false)}",
                style:
                    AppFonts.f50014Black.copyWith(color: AppColors.textGreen),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Date",
                  value: transctionData[index]['tranx_date'],
                  titleStyle:
                      AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                  valueStyle: AppFonts.f50014Black),
              ColumnText(
                title: "NAV",
                value: '$transNav',
                alignment: CrossAxisAlignment.center,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black,
              ),
              ColumnText(
                title: "Units",
                value: '${Utils.formatNumber(tranxUnits)}',
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget folioDetails() {
    String folioNo = result['folio_no'] ?? '';
    String startDate = result['start_date'] ?? '';
    double totalUnits = result['total_units'] ?? 0.0;
    double navUnits = result['nav_units'] ?? 0.0;
    int avgDays = result['avg_days'] ?? 0;
    double navAvg = result['nav_avg'] ?? 0.0;
    String navDate = result['nav_date'] ?? '';
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          rpRow(
              lhead: "Folio",
              lSubHead: folioNo,
              rhead: "Start Date",
              rSubHead: startDate),
          rpDottedLine(),
          rpRow(
            lhead: "Total Units",
            lSubHead: "$totalUnits",
            rhead: "NAV as on $navDate",
            rSubHead: "$navUnits",
          ),
          rpDottedLine(),
          rpRow(
            lhead: "Avg Days",
            lSubHead: "$avgDays days",
            rhead: "Avg NAV",
            rSubHead: "${navAvg.toStringAsFixed(3)}",
          ),
        ],
      ),
    );
  }

  Widget gainLossDetails() {
    double unrealisedGain = result['unrealised_gain'] ?? 0.0;
    double realisedGain = result['realised_gain'] ?? 0.0;
    double divReinv = result['div_reinv'] ?? 0.0;
    double divPaid = result['div_paid'] ?? 0.0;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          rpRow(
            lhead: "Unrealised Gain",
            lSubHead:
                "$rupee ${Utils.formatNumber(unrealisedGain, isAmount: false)}",
            rhead: "Realised Gain",
            rSubHead:
                "$rupee ${Utils.formatNumber(realisedGain, isAmount: false)}",
          ),
          rpDottedLine(),
          rpRow(
              lhead: "Dividend Reinvestment",
              lSubHead:
                  "$rupee ${Utils.formatNumber(divReinv, isAmount: false)}",
              rhead: "Dividend Payout",
              rSubHead:
                  "$rupee ${Utils.formatNumber(divPaid, isAmount: false)}"),
        ],
      ),
    );
  }

  Widget greenArea() {
    double currentValue = result['curr_value'] ?? 0.0;
    double dayChangeValue = result['day_change_value'] ?? 0.0;
    double dayChangePercentage = result['day_change_percentage'] ?? 0.0;
    double gainOrLoss = result['realised_gain'] ?? 0.0;
    String schemeName = result['scheme_amfi_short_name'] ?? "";
    String schemeCategory = result['scheme_category'] ?? "";
    return Container(
      color: Config.appTheme.themeColor,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.schemeAmcLogo, height: 34),
              SizedBox(width: 10),
              Expanded(
                child: ColumnText(
                  title: schemeName,
                  value: schemeCategory,
                  titleStyle:
                      AppFonts.appBarTitle.copyWith(color: Colors.white),
                  valueStyle: AppFonts.f40013.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          DottedLine(verticalPadding: 2),
          Text("$rupee ${Utils.formatNumber(currentValue, isAmount: false)}",
              style: AppFonts.f70024.copyWith(color: Colors.white)),

          if(oneDayChange == 1 || ((keys.contains("adminAsInvestor")) || (keys.contains("adminAsFamily")) != false))
          DayChange(
            change_value: dayChangeValue,
            percentage: dayChangePercentage,
            textColor: Colors.white,
            titleColor: Color(0XFFDEE6E6),
          ),
          DottedLine(verticalPadding: 2),
          //current cost, current value, xirr
          Row(
            children: [
              Expanded(
                child: ColumnText(
                  title: "Current Cost",
                  value:
                      "$rupee ${Utils.formatNumber(widget.currCost, isAmount: false)}",
                  titleStyle:
                      AppFonts.f40013.copyWith(color: Color(0XFFDEE6E6)),
                  valueStyle: AppFonts.f50014Grey.copyWith(color: Colors.white),
                ),
              ),
              Expanded(
                child: ColumnText(
                  title: "Gain/Loss",
                  value:
                      "$rupee ${Utils.formatNumber(gainOrLoss, isAmount: false)}",
                  alignment: CrossAxisAlignment.center,
                  titleStyle:
                      AppFonts.f40013.copyWith(color: Color(0XFFDEE6E6)),
                  valueStyle: AppFonts.f50014Grey.copyWith(color: Colors.white),
                ),
              ),
              Expanded(
                child: ColumnText(
                  title: "XIRR",
                  value: "${widget.xirr}%",
                  alignment: CrossAxisAlignment.end,
                  titleStyle:
                      AppFonts.f40013.copyWith(color: Color(0XFFDEE6E6)),
                  valueStyle: AppFonts.f50014Grey.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget rpRow({
    required String lhead,
    required String lSubHead,
    required String rhead,
    required String rSubHead,
  }) {
    return Row(
      children: [
        Expanded(child: ColumnText(title: lhead, value: lSubHead)),
        Expanded(child: ColumnText(title: rhead, value: rSubHead)),
      ],
    );
  }

  Widget rpDottedLine() {
    return Column(
      children: [
        SizedBox(height: 5),
        DottedLine(),
        SizedBox(height: 5),
      ],
    );
  }
}
