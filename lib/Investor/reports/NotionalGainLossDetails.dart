import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/NoData.dart';
import 'package:mymfbox2_0/rp_widgets/RpChip.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class NotionalGainLossDetails extends StatefulWidget {
  const NotionalGainLossDetails({super.key, required this.summary, required this.reportType});
  final Map summary;
  final String reportType;
  @override
  State<NotionalGainLossDetails> createState() =>
      _NotionalGainLossDetailsState();
}

class _NotionalGainLossDetailsState extends State<NotionalGainLossDetails> {
  late double devWidth, devHeight;
  String selectedFinancialYear = "";
  String reportType = "";

  List financialYearList = [];

  Map summary = {};

  int expandedIndex = -1;

  @override
  void initState() {
    super.initState();
    summary = widget.summary;
    reportType = widget.reportType;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Config.appTheme.themeColor,
        leadingWidth: 0,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: SizedBox(),
        title: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: displayPage(),
    );
  }

  Widget topArea() {
    String schemeName = summary['scheme_amfi_short_name'] ?? "";
    String folioNumber = summary['folio_no'] ?? "";
    print("folioNumber = $folioNumber");
    String isinNo = summary['isin'] ?? '';
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      color: Config.appTheme.themeColor,
      child: Row(
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
              value: "Folio: $folioNumber . ISIN: $isinNo",
              titleStyle: AppFonts.f50014Black
                  .copyWith(fontSize: 18, color: Colors.white),
              valueStyle: AppFonts.f40013.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget displayPage() {
    String schemeName = summary['scheme_amfi_short_name'] ?? "";
    String folioNumber = summary['folio_no'] ?? "";
    String isinNo = summary['isin'] ?? '';

    return SideBar(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            color: Config.appTheme.themeColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                        valueStyle:
                            AppFonts.f40013.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  blackCard(),
                  SizedBox(height: 16),
                  listCard(),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle underlineText = TextStyle(
      color: Config.appTheme.themeColor,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w400,
      fontSize: 13);

  Widget listCard() {
    List trnxList = summary['transaction_list'];
    if (trnxList.isEmpty) return NoData();

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: trnxList.length,
      separatorBuilder: (context, index) {
        return DottedLine(verticalPadding: 4);
      },
      itemBuilder: (context, index) {
        Map data = trnxList[index];

        String transactionDate = data['transaction_date'] ?? "";
        String transactionType = data['transaction_type'] ?? "";
        num purchaseUnits = data['purchase_units'] ?? 0;
        num purchaseNav = data['purchase_price'] ?? 0;
        num purchaseAmt = data['purchase_amount'] ?? 0;
        num purchaseDays = data['days'] ?? 0;

        //redemption
        String redemptionDate = data['redemption_date'] ?? "";
        num redemptionUnits = data['redemption_units'] ?? 0;
        num redemptionNav = data['redemption_price'] ?? 0;
        num redemptionAmt = data['redemption_amount'] ?? 0;
        num indexedNav = data['indexed_nav'] ?? 0;

        //grandfather
        num grandFatherUnits = data['grandfathered_units'] ?? 0;
        num grandFatherAmt = data['grandfathered_amount'] ?? 0;
        num grandFatherNav = data['grandfathered_nav'] ?? 0;
        String grandFatherInvestedDate = data['current_date'] ?? "";

        String shortLongGainText = "";
        num shortLongGainFinalValue = 0;
        num shortTermGain = data['stg_gain'] ?? 0;
        num longTermGain = data['ltg_gain'] ?? 0;
        if (shortTermGain > longTermGain) {
          shortLongGainText = "STCG";
          shortLongGainFinalValue = data['stg_gain'] ?? 0;
        } else {
          shortLongGainText = "LTCG";
          shortLongGainFinalValue = data['ltg_gain'] ?? 0;
        }

        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset("assets/vector_bg_green.png", height: 32),
                  Text(
                    transactionDate,
                    style: AppFonts.f50014Theme,
                  ),
                  Spacer(),
                  RpChip(label: transactionType),
                ],
              ),
              Text(
                "${Utils.formatNumber(purchaseUnits)} Units @ $purchaseNav NAV",
                style: AppFonts.f40013.copyWith(color: Colors.black),
              ),
              SizedBox(height: 16),
              //2nd row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ColumnText(
                    title: "Purchase Amt",
                    value:
                        "$rupee ${Utils.formatNumber(purchaseAmt.round(), isAmount: false)}",
                  ),
                  ColumnText(
                    title: "Days",
                    value: "$purchaseDays",
                    alignment: CrossAxisAlignment.center,
                  ),
                  ColumnText(
                    title: shortLongGainText,
                    value:
                        "$rupee ${Utils.formatNumber(shortLongGainFinalValue.round())}",
                    valueStyle: AppFonts.f50014Black.copyWith(
                        color: (shortLongGainFinalValue >= 0)
                            ? Config.appTheme.defaultProfit
                            : Config.appTheme.defaultLoss),
                    alignment: CrossAxisAlignment.end,
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    if (expandedIndex == index) {
                      expandedIndex = -1;
                    } else {
                      expandedIndex = index;
                    }
                  });
                },
                child: Text(
                  (expandedIndex == index) ? "Hide Details" : "View Details",
                  style: underlineText,
                ),
              ),
              if (expandedIndex == index)
                transExpansionTile(
                    redemptionDate,
                    redemptionUnits,
                    redemptionNav,
                    redemptionAmt,
                    indexedNav,
                    grandFatherUnits,
                    grandFatherAmt,
                    grandFatherNav,
                    grandFatherInvestedDate)
            ],
          ),
        );
      },
    );
  }

  Widget transExpansionTile(
      String redemptionDate,
      num redemptionUnits,
      num redemptionNav,
      num redemptionAmt,
      num indexedNav,
      num grandFatherUnits,
      num grandFatherAmt,
      num grandFatherNav,
      String grandFatherInvestedDate) {
    return Container(
      color: Config.appTheme.mainBgColor,
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "Expected Redemption (Without Indexation)",
              style: AppFonts.f50012.copyWith(color: Colors.black),
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            color: Config.appTheme.mainBgColor,
            //    padding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
            child: Container(
              margin: EdgeInsets.only(right: 8),
              child: Card(
                elevation: 0,
                margin: EdgeInsets.all(8),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        children: [
                          Image.asset("assets/vector_bg.png", height: 30),
                          Text(
                            redemptionDate,
                            style: AppFonts.f50014Black
                                .copyWith(color: Config.appTheme.themeColor),
                            textAlign: TextAlign.start,
                          ),
                          Spacer(),
                          RpChip(label: "Exp. Redemption")
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                        "${Utils.formatNumber(redemptionUnits)} Units @ $redemptionNav NAV",
                        style: AppFonts.f40013.copyWith(color: Colors.black),
                      ),
                    ),
                    DottedLine(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ColumnText(
                            title: "Sold Amt",
                            value:
                                "$rupee ${Utils.formatNumber(redemptionAmt.round())}",
                          ),
                          ColumnText(
                            title: "Indexed NAV",
                            value: "$indexedNav",
                            alignment: CrossAxisAlignment.end,
                          ),
                        ],
                      ),
                    ),
                   if(reportType != 'Simple')
                   ... [DottedLine(),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: Text(
                        "Grandfathered Investments as on 31-01-2018",
                        style: AppFonts.f50012,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 6, right: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ColumnText(
                            title: "Units",
                            value: "$grandFatherUnits",
                          ),
                          ColumnText(
                            title: "NAV",
                            value: "$grandFatherNav",
                            alignment: CrossAxisAlignment.end,
                          ),
                          ColumnText(
                            title: "Market Value",
                            value:
                                "$rupee ${Utils.formatNumber(grandFatherAmt.round())}",
                            alignment: CrossAxisAlignment.end,
                          ),
                        ],
                      ),
                    ),]
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget blackCard() {
    double longTermSoldAmt = summary['long_term_sold_amount'] ?? 0;
    double shortTermSoldAmt = summary['short_term_sold_amount'] ?? 0;
    double longTermPuchaseAmt = summary['long_term_purchase_amount'] ?? 0;
    double shortTermPurchaseAmt = summary['short_term_purchase_amount'] ?? 0;
    double longTermUnits = summary['long_term_units'] ?? 0;
    double shortTermUnits = summary['short_term_units'] ?? 0;

    double longGainLoss = summary['long_term_gain'] ?? 0;
    double shortGainLoss = summary['short_term_gain'] ?? 0;

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
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
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
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
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
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Units',
                    style:
                        AppFonts.f40013.copyWith(color: AppColors.lineColor)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(longTermUnits.round())}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(shortTermUnits.round())}",
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
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
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
