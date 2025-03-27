import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

class TaxReportDetails extends StatefulWidget {
  const TaxReportDetails({super.key, required this.summary});

  final Map summary;

  @override
  State<TaxReportDetails> createState() => _TaxReportDetailsState();
}

class _TaxReportDetailsState extends State<TaxReportDetails> {
  late double devWidth, devHeight;
  String selectedFinancialYear = "";

  List financialYearList = [];

  Map summary = {};

  int expandedIndex = -1;

  @override
  void initState() {
    super.initState();
    summary = widget.summary;
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
    String folioNumber = summary['folio'] ?? "";
    String isinNo = summary['isin_no'] ?? '';
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
    String folioNumber = summary['folio'] ?? "";
    String isinNo = summary['isin_no'] ?? '';

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
    DateTime? dateTime = DateTime.parse(dateString);
    if (dateTime == null) {
      return "Invalid Date";
    }
    String formattedDate =
        DateFormat('dd MMM yyyy hh:mm a').format(dateTime.toLocal());
    return formattedDate;
  }

  Widget listCard() {
    List trnxList = summary['transaction_list'];
    if (trnxList.isEmpty) return NoData();

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: trnxList.length,
      separatorBuilder: (context, index) {
        return DottedLine(verticalPadding: 8);
      },
      itemBuilder: (context, index) {
        Map data = trnxList[index];

        String transType = data['sold_transaction_type'] ?? "";
        num sellAmount = data['sold_amount'] ?? 0;
        num stt = data['stt'] ?? 0;
        num tds = data['total_tax'] ?? 0;

        num indexedGain = data['indexed_gain'] ?? 0;
        String? soldDate = data['sold_date'] ?? null;
        num soldUnits = data['sold_units'] ?? 0;
        num soldNav = data['sold_nav'] ?? 0;


        String purchaseTransType = data['purchase_transaction_type'] ?? "";
        String? purchaseDate = data['purchase_date'] ?? null;
        num purchaseNav = data['purchase_nav'] ?? 0;
        num purchaseUnits = data['purchase_units'] ?? 0;
        num purchaseamount = data['purchase_amount'] ?? 0;
        num redeemedunits = data['redeemed_units'] ?? 0;
        num indexed_nav = data['indexed_nav'] ?? 0;

        num grandfathered_units = data['grandfathered_units'] ?? 0;
        num grandfathered_amount = data['grandfathered_amount'] ?? 0;

        num noofDays = data['no_of_days'] ?? "";
        num shortTermGain = data['stg_gain'] ?? 0;
        num longTermGain = data['ltg_gain'] ?? 0;
        num indexCost = data['indexed_cost'] ?? 0;

        String shortLongGainText = "";
        num shortLongGainFinalValue = 0;

        if (shortTermGain > longTermGain) {
          shortLongGainText = "STCG";
          shortLongGainFinalValue = data['stg_gain'] ?? 0;
        } else {
          shortLongGainText = "LTCG";
          shortLongGainFinalValue = data['ltg_gain'] ?? 0;
        }

        return Container(
          margin: EdgeInsets.only(right:16,left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset("assets/vector_bg.png", height: 32),
                  Text(
                    soldDate != null
                        ? DateFormat('dd MMM yyyy').format(
                            DateTime.tryParse(soldDate ?? '')?.toLocal() ??
                                DateTime(2000, 1, 1))
                        : '',
                    style: AppFonts.f50014Theme,
                  ),
                  Spacer(),
                  RpChip(label: transType),
                ],
              ),
              Text(
                "${Utils.formatNumber(soldUnits)} Units @ $soldNav NAV",
                style: AppFonts.f40013.copyWith(color: Colors.black),
              ),
              SizedBox(height: 16),
              //2nd row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ColumnText(
                    title: "Sell Amount",
                    value:
                        "$rupee ${Utils.formatNumber(sellAmount.round(), isAmount: false)}",
                    alignment: CrossAxisAlignment.start,
                  ),
                  ColumnText(
                    title: "STT",
                    value: "$rupee ${Utils.formatNumber(stt.round())}",
                    alignment: CrossAxisAlignment.center,
                  ),
                  ColumnText(
                    title: "TDS",
                    value: "$rupee ${Utils.formatNumber(tds.round())}",
                    valueStyle: AppFonts.f50014Black,
                    alignment: CrossAxisAlignment.end,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                ],
              ),
              if (expandedIndex == index)
                transExpansionTile(
                    purchaseTransType,
                    purchaseDate!,
                    purchaseNav,
                    purchaseUnits,
                    purchaseamount,
                    redeemedunits,
                    indexed_nav,
                    grandfathered_units,
                    grandfathered_amount,
                    noofDays,
                    shortTermGain,
                    longTermGain,
                    indexCost,
                    shortLongGainText,
                    shortLongGainFinalValue)
            ],
          ),
        );
      },
    );
  }

  Widget transExpansionTile(
      String purchaseTransType,
      String purchaseDate,
      num purchaseNav,
      num purchaseUnits,
      num purchaseamount,
      num redeemedunits,
      num indexed_nav,
      num grandfathered_units,
      num grandfathered_amount,
      num noofDays,
      num shortTermGain,
      num longTermGain,
      num indexCost,
      String shortLongGainText,
      num shortLongGainFinalValue) {
    return Container(
      color: Config.appTheme.mainBgColor,
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "B: Corresponding Purchase Transactions",
              style: AppFonts.f50012.copyWith(color: Colors.black),
              textAlign: TextAlign.start,
            ),
          ),
          Container(
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
                        Image.asset("assets/vector_bg_green.png", height: 30),
                        Text(
                          purchaseDate != null
                              ? DateFormat('dd MMM yyyy').format(
                                  DateTime.tryParse(purchaseDate ?? '')
                                          ?.toLocal() ??
                                      DateTime(2000, 1, 1))
                              : '',
                          style: AppFonts.f50014Black
                              .copyWith(color: Config.appTheme.themeColor),
                          textAlign: TextAlign.start,
                        ),
                        Spacer(),
                        RpChip(label: purchaseTransType)
                      ],
                    ),
                  ),
                  DottedLine(),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ColumnText(
                          title: "Pur Units",
                          value: "$purchaseUnits",
                          alignment: CrossAxisAlignment.start,
                        ),
                        ColumnText(
                          title: "Pur NAV",
                          value: "$purchaseNav",
                          alignment: CrossAxisAlignment.center,
                        ),
                        ColumnText(
                          title: "Pur Amt",
                          value: "$purchaseamount",
                          alignment: CrossAxisAlignment.end,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ColumnText(
                          title: "Redeemed Units",
                          value: "$redeemedunits",
                          alignment: CrossAxisAlignment.start,
                        ),
                        ColumnText(
                          title: "Indexed NAV",
                          value: "$indexed_nav",
                          alignment: CrossAxisAlignment.end,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "C: Grandfathered Investments",
              style: AppFonts.f50012.copyWith(color: Colors.black),
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 8),
            child: Card(
              elevation: 0,
              margin: EdgeInsets.all(8),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 16, top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ColumnText(
                          title: "Units",
                          value: "$grandfathered_units",
                          alignment: CrossAxisAlignment.end,
                        ),
                        ColumnText(
                          title: "NAV",
                          value:
                              Utils.formatNumber(indexed_nav.round()),
                        ),
                        ColumnText(
                          title: "Market Value",
                          value:
                              "$rupee ${Utils.formatNumber(grandfathered_amount)}",
                          alignment: CrossAxisAlignment.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              "D: Capital Gains / (Losses)",
              style: AppFonts.f50012.copyWith(color: Colors.black),
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 8),
            child: Card(
              elevation: 0,
              margin: EdgeInsets.all(8),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 16, top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ColumnText(
                          title: "Days",
                          value: "$noofDays",
                          alignment: CrossAxisAlignment.start,
                        ),
                        ColumnText(
                          title: "Short Term",
                          value:
                              Utils.formatNumber(shortTermGain),
                          alignment: CrossAxisAlignment.end,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ColumnText(
                          title: "Long Term",
                          value:
                              Utils.formatNumber(longTermGain),
                          alignment: CrossAxisAlignment.start,
                        ),
                        ColumnText(
                          title: "Indexed",
                          value: "$indexCost",
                          alignment: CrossAxisAlignment.end,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ListView.builder(
          //   shrinkWrap: true,
          //   physics: NeverScrollableScrollPhysics(),
          //   itemCount: trnxList.length,
          //   itemBuilder: (context, index) {
          //     Map data = trnxList[index];
          //     return trnxCard(data);
          //   },
          // ),
        ],
      ),
    );
  }

  // Widget trnxCard(Map data) {
  //   String purchaseTransType = data['purchase_transaction_type'] ?? "";
  //   String purchaseDate = data['purchase_date'] ?? "";
  //   num purchaseUnits = data['purchase_units'] ?? 0;
  //   num soldUnits = data['sold_units'] ?? 0;
  //   num purchaseNav = data['purchase_nav'] ?? 0;
  //   num noofDays = data['no_of_days'] ?? "";
  //   num indexCost = data['indexed_cost'] ?? 0;
  //
  //   String shortLongGainText = "";
  //   num shortLongGainFinalValue = 0;
  //   num shortTermGain = data['stg_gain'] ?? 0;
  //   num longTermGain = data['ltg_gain'] ?? 0;
  //   if (shortTermGain > longTermGain) {
  //     shortLongGainText = "STCG";
  //     shortLongGainFinalValue = data['stg_gain'] ?? 0;
  //   } else {
  //     shortLongGainText = "LTCG";
  //     shortLongGainFinalValue = data['ltg_gain'] ?? 0;
  //   }
  //   String formattedPurchseDate = "";
  //
  //   formattedPurchseDate = formatDate(purchaseDate);
  //   return GestureDetector(
  //     onTap: () {},
  //     child: Container(
  //       margin: EdgeInsets.only(right: 8),
  //       child: Card(
  //         elevation: 0,
  //         margin: EdgeInsets.all(8),
  //         color: Colors.white,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.only(left: 8, right: 8),
  //               child: Row(
  //                 children: [
  //                   Image.asset("assets/vector_bg_green.png", height: 30),
  //                   Text(
  //                     formattedPurchseDate,
  //                     style: AppFonts.f50014Black
  //                         .copyWith(color: Config.appTheme.themeColor),
  //                     textAlign: TextAlign.start,
  //                   ),
  //                   Spacer(),
  //                   RpChip(label: purchaseTransType)
  //                 ],
  //               ),
  //             ),
  //             DottedLine(),
  //             Padding(
  //               padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   ColumnText(
  //                     title: "Units",
  //                     value: "$purchaseUnits",
  //                   ),
  //                   ColumnText(
  //                     title: "NAV",
  //                     value: "$purchaseNav",
  //                     alignment: CrossAxisAlignment.center,
  //                   ),
  //                   ColumnText(
  //                     title: "Sold Units",
  //                     value: "$soldUnits",
  //                     alignment: CrossAxisAlignment.end,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   ColumnText(
  //                     title: "COST",
  //                     value: "$rupee ${Utils.formatNumber(indexCost.round())}",
  //                   ),
  //                   ColumnText(
  //                     title: shortLongGainText,
  //                     value:
  //                         "$rupee ${Utils.formatNumber(shortLongGainFinalValue)}",
  //                     alignment: CrossAxisAlignment.center,
  //                   ),
  //                   ColumnText(
  //                     title: "Days",
  //                     value: "$noofDays",
  //                     alignment: CrossAxisAlignment.end,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget blackCard() {
    num longTermSoldAmt = summary['ltg_sold_amount'] ?? 0;
    num shortTermSoldAmt = summary['stg_sold_amount'] ?? 0;
    num longTermPuchaseAmt = summary['ltg_purchase_amount'] ?? 0;
    num shortTermPurchaseAmt = summary['stg_purchase_amount'] ?? 0;

    num longGain = summary['ltg_gain'] ?? 0;
    num shortGain = summary['stg_gain'] ?? 0;
    num longLoss = summary['ltg_loss'] ?? 0;
    num shortLoss = summary['stg_loss'] ?? 0;
    num indexedGain = summary['indexed_gain'] ?? 0;

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
          DottedLine(verticalPadding: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Gain',
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(longGain.round())}",
                    style:
                        AppFonts.f50012.copyWith(color: AppColors.textGreen)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(shortGain.round())}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text('Loss',
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
              ),
              Expanded(
                child: Text("$rupee ${Utils.formatNumber(longLoss.round())}",
                    style:
                        AppFonts.f50012.copyWith(color: AppColors.textGreen)),
              ),
              Expanded(
                child: Text("$rupee ${Utils.formatNumber(shortLoss.round())}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
