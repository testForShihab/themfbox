import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class PortfolioAnalysisDetails extends StatefulWidget {
  const PortfolioAnalysisDetails(
      {super.key, required this.summary, required this.nextSummary});
  final Map summary;
  final Map nextSummary;
  @override
  State<PortfolioAnalysisDetails> createState() =>
      _PortfolioAnalysisDetailsState();
}

class _PortfolioAnalysisDetailsState extends State<PortfolioAnalysisDetails> {
  late double devWidth, devHeight;
  late Map summary;
  late Map nextSummary;
  TextStyle underlineText = TextStyle(
      color: Config.appTheme.themeColor,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w500,
      fontSize: 13);

  bool isLoading = true;

  Future getDatas() async {
    isLoading = true;
    isLoading = false;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    summary = widget.summary;
    nextSummary = widget.nextSummary;
  }

  String formatDate(String dateString) {
    if (dateString.isEmpty) {
      return '';
    }
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    return formattedDate;
  }

  String changeDateFormat(String inputDate) {
    if (inputDate.isEmpty) {
      return '';
    }
    DateTime dateTime = DateTime.parse(inputDate);

    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Color(0XFFECF0F0),
            appBar: AppBar(
              backgroundColor: Color(0XFFECF0F0),
              leadingWidth: 0,
              toolbarHeight: 40,
              foregroundColor: Colors.black,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              leading: SizedBox(),
              title: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: Icon(Icons.arrow_back),
                        onTap: () {
                          Get.back();
                        },
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Performance vs Benchmark",
                        style: AppFonts.f50014Black.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: displayPage(),
          );
        });
  }

  Widget displayPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isLoading
              ? Utils.shimmerWidget(devHeight * 0.2, margin: EdgeInsets.all(20))
              : Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      schemeSummaryCard(),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  String getFirst13(String text) {
    String s = text.split(":").last;
    if (s.length > 12) s = s.substring(0, 12);
    return s;
  }

  Widget schemeSummaryCard() {
    String schemeName = summary['scheme_amfi_short_name'] ?? "";
    num totalUnits = summary['totalUnits'] ?? 0;
    String folio = summary['foliono'] ?? "";
    String startDate = summary['investmentStartDate_str'] ?? "";
    num avgNav = summary['purchaseNav'] ?? 0;

    String navOn = summary['latestNavDate'] ?? "";
    String navAsOn = formatDate(navOn);

    num latestNav = summary['latestNav'] ?? 0;
    num currentCost = summary['currentCostOfInvestment'] ?? 0;
    num dividendReinvestment = summary['dividendReinvestment'] ?? 0;
    num dividendPaid = summary['dividendPaid'] ?? 0;
    num totalCurrentValue = summary['totalCurrentValue'] ?? 0;
    num unrealisedGain = summary['unrealisedProfitLoss'] ?? 0;
    num realisedGain = summary['realisedGainLoss'] ?? 0;
    num absoluteReturn = summary['absolute_return'] ?? 0;
    num xirr = summary['cagr'] ?? 0;

    String nextSchemeName = nextSummary['scheme_amfi_short_name'] ?? "";
    num nextTotalUnits = nextSummary['totalUnits'] ?? 0;
    String nextFolio = nextSummary['foliono'] ?? "";
    String nextStartDate = nextSummary['investmentStartDate_str'] ?? "";
    num nextAvgNav = nextSummary['purchaseNav'] ?? 0;

    String nextNavOn = nextSummary['latestNavDate'] ?? "";
    String nextNavAsOn = formatDate(nextNavOn);

    num nextLatestNav = nextSummary['latestNav'] ?? 0;
    num nextCurrentCost = nextSummary['currentCostOfInvestment'] ?? 0;
    num nextDividendReinvestment = nextSummary['dividendReinvestment'] ?? 0;
    num nextDividendPaid = nextSummary['dividendPaid'] ?? 0;
    num nextTotalCurrentValue = nextSummary['totalCurrentValue'] ?? 0;
    num nextUnrealisedGain = nextSummary['unrealisedProfitLoss'] ?? 0;
    num nextRealisedGain = nextSummary['realisedGainLoss'] ?? 0;
    num nextAbsoluteReturn = nextSummary['absolute_return'] ?? 0;
    num nextXirr = nextSummary['cagr'] ?? 0;

    num extraReturn = double.parse((xirr - nextXirr).toStringAsFixed(2));

    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(
                summary["amc_logo"],
                height: 32,
              ),
              Container(
                height: 26,
                width: 26,
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(Icons.bar_chart, color: Colors.purple),
              ),
            ],
          ),
          SizedBox(height: 8),*/
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  schemeName,
                  style: AppFonts.f50014Black
                      .copyWith(color: Config.appTheme.themeColor),
                ),
              ),
              SizedBox(width: 16),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Config.appTheme.themeColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 6, vertical: 0), // Adjust padding as needed
                    child: Text(
                      "vs",
                      style: AppFonts.f40013
                          .copyWith(color: Config.appTheme.themeColor),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  nextSchemeName,
                  style: AppFonts.f50014Black
                      .copyWith(color: Config.appTheme.themeColor),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Folio: $folio",
                  style: AppFonts.f40013.copyWith(color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Start Date", value: changeDateFormat(startDate)),
              ColumnText(
                  title: "Start Date",
                  value: changeDateFormat(nextStartDate),
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(title: "Units", value: Utils.formatNumber(totalUnits)),
              ColumnText(
                  title: "Units",
                  value: Utils.formatNumber(nextTotalUnits),
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(title: "Average NAV", value: "$avgNav"),
              ColumnText(
                  title: "Average NAV",
                  value: "$nextAvgNav",
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(title: "NAV on $navAsOn", value: "$latestNav"),
              ColumnText(
                  title: "NAV on $nextNavAsOn",
                  value: "$nextLatestNav",
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Current Cost",
                  value:
                      "$rupee ${Utils.formatNumber(currentCost.round(), isAmount: false)}"),
              ColumnText(
                  title: "Current Cost",
                  value:
                      "$rupee ${Utils.formatNumber(nextCurrentCost.round(), isAmount: false)}",
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Dividend Reinvest",
                  value:
                      "$rupee ${Utils.formatNumber(dividendReinvestment.round(), isAmount: false)}"),
              ColumnText(
                  title: "Dividend Reinvest",
                  value:
                      "$rupee ${Utils.formatNumber(nextDividendReinvestment.round(), isAmount: false)}",
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Dividend Paid",
                  value:
                      "$rupee ${Utils.formatNumber(dividendPaid.round(), isAmount: false)}"),
              ColumnText(
                  title: "Dividend Paid",
                  value:
                      "$rupee ${Utils.formatNumber(nextDividendPaid.round(), isAmount: false)}",
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Current Value",
                  value:
                      "$rupee ${Utils.formatNumber(totalCurrentValue.round(), isAmount: false)}"),
              ColumnText(
                  title: "Current Value",
                  value:
                      "$rupee ${Utils.formatNumber(nextTotalCurrentValue.round(), isAmount: false)}",
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Unrealised Gain",
                  value:
                      "$rupee ${Utils.formatNumber(unrealisedGain.round(), isAmount: false)}"),
              ColumnText(
                  title: "Unrealised Gain",
                  value:
                      "$rupee ${Utils.formatNumber(nextUnrealisedGain.round(), isAmount: false)}",
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Realised Gain",
                  value:
                      "$rupee ${Utils.formatNumber(realisedGain.round(), isAmount: false)}"),
              ColumnText(
                  title: "Realised Gain",
                  value:
                      "$rupee ${Utils.formatNumber(nextRealisedGain.round(), isAmount: false)}",
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(title: "Absolute Return", value: "$absoluteReturn%"),
              ColumnText(
                  title: "Absolute Return",
                  value: "$nextAbsoluteReturn%",
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "XIRR",
                value: "$xirr%",
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: (xirr > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
              ),
              ColumnText(
                  title: "XIRR",
                  value: "$nextXirr%",
                  valueStyle: AppFonts.f50014Black.copyWith(
                      color: (nextXirr > 0)
                          ? Config.appTheme.defaultProfit
                          : Config.appTheme.defaultLoss),
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          DottedLine(verticalPadding: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Extra Return",
                  style: AppFonts.f50014Black.copyWith(fontSize: 16)),
              Text(
                "$extraReturn%",
                style: AppFonts.f50014Black.copyWith(
                    fontSize: 16,
                    color: (extraReturn > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
