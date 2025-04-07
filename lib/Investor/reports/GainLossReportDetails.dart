import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/RpChip.dart';

class GainLossReportDetails extends StatefulWidget {
  const GainLossReportDetails({Key? key, required this.summary})
      : super(key: key);
  final Map summary;
  @override
  State<GainLossReportDetails> createState() => _GainLossReportDetailsState();
}

class _GainLossReportDetailsState extends State<GainLossReportDetails> {
  late double devWidth, devHeight;
  String selectedFinancialYear = "";
  double startingPoint = 0;

  List financialYearList = [];

  bool isLoading = true;
  Map summary = {};

  int expandedIndex = -1;
  bool isExpanded = false;

  Future getDatas() async {
    isLoading = true;

    isLoading = false;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    summary = widget.summary;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Config.appTheme.themeColor,
              leadingWidth: 0,
              toolbarHeight: 40,
              foregroundColor: Colors.white,
              elevation: 0,
              leading: SizedBox(),
              title: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(Icons.arrow_back)),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: displayPage(),
          );
        });
  }

  Widget displayPage() {
    String schemeName = summary['scheme_amfi_short_name'] ?? "";
    String folioNumber = summary['folio'] ?? "";
    String isinNo = summary['isin_no'] ?? '';
    return SideBar(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            color: Config.appTheme.themeColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      summary["amc_logo"],
                      height: 32,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ColumnText(
                        title: schemeName,
                        value: "Folio: $folioNumber ISIN:$isinNo",
                        titleStyle: AppFonts.f50014Black
                            .copyWith(fontSize: 18, color: Colors.white),
                        valueStyle: AppFonts.f40013.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isLoading
                      ? Utils.shimmerWidget(devHeight, margin: EdgeInsets.all(16))
                      : blackCard(),
                  isLoading
                      ? Utils.shimmerWidget(devHeight, margin: EdgeInsets.all(16))
                      : listCard(),
                  SizedBox(height: 150),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget noData() {
    return Padding(
      padding: EdgeInsets.only(top: devHeight * 0.02, left: devWidth * 0.34),
      child: Column(
        children: [
          Text("No Data Available"),
          SizedBox(height: devHeight * 0.01),
        ],
      ),
    );
  }

  TextStyle underlineText = TextStyle(
      color: Config.appTheme.themeColor,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w400,
      fontSize: 13);

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    return formattedDate;
  }

  Widget listCard() {
    List trnxList = summary['transaction_list'];
    if (trnxList.isEmpty) return noData();

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: trnxList.length,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 16,
          child: DottedLine(),
        );
      },
      itemBuilder: (context, index) {
        Map data = trnxList[index];
        String transType = data['sold_transaction_type'] ?? "";
        num sellAmount = data['sold_amount'] ?? 0;
        num shortTermGain = data['stg_gain'] ?? 0;
        num longTermGain = data['ltg_gain'] ?? 0;
        String soldDate = data['sold_date'] ?? "";
        num soldUnits = data['sold_units'] ?? 0;
        num soldNav = data['sold_nav'] ?? 0;
        String formattedSoldDate = "";
        formattedSoldDate = formatDate(soldDate);
        List subTrnxList = data['transaction_list'] ?? [];

        return GestureDetector(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Image.asset("assets/vector_bg.png", height: 30),
                    Text(
                      formattedSoldDate,
                      style: AppFonts.f50014Theme,
                      textAlign: TextAlign.start,
                    ),
                    Spacer(),
                    RpChip(label: transType),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "${Utils.formatNumber(soldUnits)} Units @ $soldNav NAV",
                  style: AppFonts.f40013.copyWith(color: Colors.black),
                ),
              ),
              SizedBox(height: 16),
              //2nd row
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColumnText(
                      title: "Sell Amt",
                      value:
                          "$rupee ${Utils.formatNumber(sellAmount.round(), isAmount: false)}",
                    ),
                    ColumnText(
                      title: "STCG",
                      value:
                          "$rupee ${Utils.formatNumber(shortTermGain.round())}",
                      valueStyle: AppFonts.f50014Black.copyWith(
                          color: (shortTermGain >= 0)
                              ? Config.appTheme.defaultProfit
                              : Config.appTheme.defaultLoss),
                      alignment: CrossAxisAlignment.center,
                    ),
                    ColumnText(
                      title: "LTCG",
                      value:
                          "$rupee ${Utils.formatNumber(longTermGain.round())}",
                      valueStyle: AppFonts.f50014Black.copyWith(
                          color: (longTermGain >= 0)
                              ? Config.appTheme.defaultProfit
                              : Config.appTheme.defaultLoss),
                      alignment: CrossAxisAlignment.end,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          if (expandedIndex == index) {
                            isExpanded = !isExpanded;
                          } else {
                            isExpanded = true;
                            expandedIndex = index;
                          }
                        });
                      },
                      child: Text(
                        expandedIndex == index
                            ? (isExpanded ? "Hide Details" : "View Details")
                            : "View Details",
                        style: underlineText,
                      ),
                    ),
                  ],
                ),
              ),
              if (isExpanded && expandedIndex == index)
                transExpansionTile(subTrnxList)
            ],
          ),
        );
      },
    );
  }

  Widget transExpansionTile(subTrnxList) {
    if (subTrnxList.isEmpty) {
      return noData();
    }
    return Container(
      color: Config.appTheme.mainBgColor,
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "Corresponding Purchase Transactions (${subTrnxList.length})",
              style: AppFonts.f50012.copyWith(color: Colors.black),
              textAlign: TextAlign.start,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: subTrnxList.length,
            itemBuilder: (context, index) {
              Map data = subTrnxList[index];
              return trnxCard(data);
            },
          ),
        ],
      ),
    );
  }

  Widget trnxCard(Map data) {
    String purchaseTransType = data['purchase_transaction_type'] ?? "";
    double purchaseAmount = data['purchase_amount'] ?? 0;
    String purchaseDate = data['purchase_date'] ?? "";
    double purchaseUnits = data['purchase_units'] ?? 0;
    double soldUnits = data['sold_units'] ?? 0;
    double purchaseNav = data['purchase_nav'] ?? 0;
    num noofDays = data['no_of_days'] ?? "";

    String shortLongGainText = "";
    double shortLongGainFinalValue = 0;
    double shortTermGain = data['stg_gain'] ?? 0;
    double longTermGain = data['ltg_gain'] ?? 0;
    if (shortTermGain > longTermGain) {
      shortLongGainText = "STCG";
      shortLongGainFinalValue = data['stg_gain'] ?? 0;
    } else {
      shortLongGainText = "LTCG";
      shortLongGainFinalValue = data['ltg_gain'] ?? 0;
    }
    String formattedPurchseDate = "";
    formattedPurchseDate = formatDate(purchaseDate);

    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(left: 8, right: 8),
        child: Card(
          elevation: 0,
          margin: EdgeInsets.all(8),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Row(
                  children: [
                    Image.asset("assets/vector_bg_green.png", height: 30),
                    Text(
                      formattedPurchseDate,
                      style: AppFonts.f50014Black
                          .copyWith(color: Config.appTheme.themeColor),
                      textAlign: TextAlign.start,
                    ),
                    Spacer(),
                    RpChip(label: purchaseTransType)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Text(
                  "$purchaseUnits Units @ $purchaseNav NAV",
                  style: AppFonts.f40013.copyWith(color: Colors.black),
                ),
              ),
              DottedLine(),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Text(
                  "Invested for $noofDays Days",
                  style: AppFonts.f50012,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColumnText(
                      title: "Sold Units",
                      value: "$soldUnits",
                    ),
                    ColumnText(
                      title: "Cost",
                      value:
                          "$rupee ${Utils.formatNumber(purchaseAmount.round())}",
                      alignment: CrossAxisAlignment.center,
                    ),
                    ColumnText(
                      title: shortLongGainText,
                      value:
                          "$rupee ${Utils.formatNumber(shortLongGainFinalValue.round())}",
                      alignment: CrossAxisAlignment.end,
                      valueStyle: AppFonts.f50014Black.copyWith(
                          color: (shortLongGainFinalValue >= 0)
                              ? Config.appTheme.defaultProfit
                              : Config.appTheme.defaultLoss),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget expansionTitle(String month, num trnxCount) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(month, style: AppFonts.f50014Black),
              Text(
                "$trnxCount Transactions",
                style: AppFonts.f50012,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget blackCard() {
    double longTermSoldAmt = summary['ltg_sold_amount'] ?? 0;
    double shortTermSoldAmt = summary['stg_sold_amount'] ?? 0;
    double longTermPuchaseAmt = summary['ltg_purchase_amount'] ?? 0;
    double shortTermPurchaseAmt = summary['stg_purchase_amount'] ?? 0;

    double longGainLoss = summary['ltg_gain'] ?? 0;
    double shortGainLoss = summary['stg_gain'] ?? 0;

    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text("",
                    style: AppFonts.f50014Grey.copyWith(color: Colors.white)),
              ),
              Expanded(
                child: Text("Long Term",
                    style: AppFonts.f50014Grey.copyWith(color: Colors.white)),
              ),
              Expanded(
                child: Text("Short Term",
                    style: AppFonts.f50014Grey.copyWith(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Sell',
                    style:
                        AppFonts.f40013.copyWith(color: AppColors.lineColor)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(longTermSoldAmt.round())}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(shortTermSoldAmt.round())}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Purchase',
                    style:
                        AppFonts.f40013.copyWith(color: AppColors.lineColor)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(longTermPuchaseAmt.round())}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(shortTermPurchaseAmt.round())}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
            ],
          ),
          DottedLine(verticalPadding: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Gain/Loss',
                    style:
                        AppFonts.f40013.copyWith(color: AppColors.lineColor)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(longGainLoss.round())}",
                    style:
                        AppFonts.f50012.copyWith(color: AppColors.textGreen)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(shortGainLoss.round())}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
