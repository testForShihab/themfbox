import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/ShareWidget.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:mymfbox2_0/advisor/sip/SipDashboard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import 'package:mymfbox2_0/api/ApiConfig.dart';

import '../../../Investor/sipPortfolioSummary/SipPortfolioSummary.widgets.dart';
import '../../../pojo/UserDataPojo.dart';

class NetworthCalculatorOutput extends StatefulWidget {
  const NetworthCalculatorOutput({
    super.key,
    required this.networthCalculatorResult,
    required this.shares_equity,
    required this.fixed_income,
    required this.cash_value,
    required this.property_value,
    required this.gold_value,
    required this.other_assets_value,
    required this.home_loan_value,
    required this.personal_other_loan_value,
    required this.income_tax_value,
    required this.outstanding_bill_value,
    required this.credit_card_due_value,
    required this.other_liabilities_value,
  });
  final Map networthCalculatorResult;
  final num shares_equity,
      fixed_income,
      cash_value,
      property_value,
      gold_value,
      other_assets_value,
      home_loan_value,
      personal_other_loan_value,
      income_tax_value,
      outstanding_bill_value,
      credit_card_due_value,
      other_liabilities_value;

  @override
  State<NetworthCalculatorOutput> createState() =>
      _NetworthCalculatorOutputState();
}

class _NetworthCalculatorOutputState extends State<NetworthCalculatorOutput> {
  late double devHeight, devWidth;
  late Map networthCalculatorResult;
  String client_name = GetStorage().read("client_name");
  int type_id = GetStorage().read("type_id");
  UserDataPojo userDataPojo = UserDataPojo();

  @override
  void initState() {
    //  implement initState
    super.initState();
    networthCalculatorResult = widget.networthCalculatorResult;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Networth Calculator",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white,
          actions: [
            if ((type_id == UserType.ADMIN) && (!keys.contains("adminAsInvestor")))
            GestureDetector(
                onTap: () {
                  String url =
                      "${ApiConfig.apiUrl}/download/downloadNetworthCalcResult?key=${ApiConfig.apiKey}"
                      "&shares_equity_value=${widget.shares_equity}"
                      "&fixed_income_value=${widget.fixed_income}"
                      "&cash_value=${widget.cash_value}"
                      "&property_value=${widget.property_value}"
                      "&gold_value=${widget.gold_value}"
                      "&other_assets_value=${widget.other_assets_value}"
                      "&home_loan_value=${widget.home_loan_value}"
                      "&personal_other_loan_value=${widget.personal_other_loan_value}"
                      "&income_tax_value=${widget.income_tax_value}"
                      "&outstanding_bill_value=${widget.outstanding_bill_value}"
                      "&credit_card_due_value=${widget.credit_card_due_value}"
                      "&other_liabilities_value=${widget.other_liabilities_value}"
                      "&client_name=$client_name";
                  print("downloadNetworthCalcResult $url");
                  SharedWidgets().shareBottomSheet(context, url);
                },
                child: Container(
                    margin: EdgeInsets.only(right: 15),
                    child: Icon(Icons.share))),
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              width: devWidth,
              margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
              padding: EdgeInsets.all(4.0), // Add padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [getBroadCategory()],
              ),
            ),
            Container(
              width: devWidth,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: EdgeInsets.all(16.0), // Add padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Your Networth",
                      style: AppFonts.f50014Black,
                    ),
                  ),
                  Text(
                    "$rupee ${Utils.formatNumber(networthCalculatorResult['total_networth'], isAmount: false)}",
                    style: AppFonts.f70018Green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getBroadCategory() {
    List<SipData> chartData = [];

    chartData.add(SipData(
      category: 'Total Assets',
      percentage: networthCalculatorResult['total_assets'].toDouble(),
    ));

    chartData.add(SipData(
      category: 'Total Liabilities',
      percentage: networthCalculatorResult['total_liabillities'].toDouble(),
    ));

    print("chartData $chartData");

    List<Color> colorPalate = [
      Color(0XFF4155B9),
      Color(0XFF67C587),
      Color(0xFFE79C23),
      Color(0xFF5DB25D),
      Color(0xFFDE5E2F),
      Colors.redAccent,
      Colors.greenAccent,
      Colors.deepPurple,
      Colors.black,
      Colors.teal
    ];

    return Column(
      children: [
        SfCircularChart(
          series: <CircularSeries>[
            PieSeries<SipData, String>(
              dataSource: chartData,
              xValueMapper: (data, _) => data.category,
              yValueMapper: (data, _) => data.percentage,
            ),
          ],
          palette: colorPalate,
          legend: Legend(
              isVisible: false,
              overflowMode: LegendItemOverflowMode.scroll,
              position: LegendPosition.bottom),
        ),
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: chartData.length,
          itemBuilder: (BuildContext context, int index) {
            SipData sipData = chartData.elementAt(index);

            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: colorPalate[index], radius: 6),
                  SizedBox(width: 7),
                  SizedBox(
                    width: 150,
                    child: RichText(
                      text: TextSpan(
                        style: AppFonts.f50014Black, // Default text style
                        children: [
                          TextSpan(
                            text: "${sipData.category}  ",
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    "$rupee ${Utils.formatNumber(sipData.percentage, isAmount: false)}",
                    style: AppFonts.f50014Black,
                    textAlign: TextAlign.end,
                  )),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return DottedLine();
          },
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
