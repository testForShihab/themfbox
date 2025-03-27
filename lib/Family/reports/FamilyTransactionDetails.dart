import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class FamilyTransactionDetails extends StatefulWidget {
  const FamilyTransactionDetails({super.key, required this.schemeItem});

  final Map schemeItem;

  @override
  State<FamilyTransactionDetails> createState() =>
      _FamilyAllTransactionDetailsState();
}

class _FamilyAllTransactionDetailsState
    extends State<FamilyTransactionDetails> {
  Map schemeItem = {};
  late double devWidth, devHeight;
  List tranxList = [];

  bool isLoading = true;

  Future getDatas() async {
    isLoading = true;
    isLoading = false;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    schemeItem = widget.schemeItem;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: AppBar(
              backgroundColor: Config.appTheme.themeColor,
              leadingWidth: 0,
              toolbarHeight: 40,
              foregroundColor: Colors.white,
              elevation: 0,
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
                    ],
                  ),
                ],
              ),
            ),
            body: displayPage(),
          );
        });
  }

  Widget appBarNewColumn(String title, String value, Widget suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14)),
        Container(
          width: devWidth * 0.91,
          padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Config.appTheme.overlay85,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Row(
              children: [
                Text(value,
                    style: TextStyle(
                        color: Config.appTheme.themeColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Spacer(),
                suffix
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget displayPage() {
    schemeItem = widget.schemeItem;

    String schemeName = schemeItem['scheme_amfi'].toString();
    String folioNumber = schemeItem['folio_no'] ?? '';
    double currentValue = schemeItem['curr_value'] ?? 0.0;
    double balanceUnits = schemeItem['balance_unit'] ?? 0.0;
    tranxList = schemeItem['tranx_list'];

    return SideBar(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              color: Config.appTheme.themeColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        schemeItem["logo"],
                        height: 32,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ColumnText(
                          title: schemeName,
                          value: "Folio: $folioNumber",
                          titleStyle: AppFonts.f50014Black
                              .copyWith(fontSize: 18, color: Colors.white),
                          valueStyle:
                              AppFonts.f40013.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  DottedLine(verticalPadding: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 180,
                        child: ColumnText(
                          title: "Current Value",
                          titleStyle: AppFonts.f40013
                              .copyWith(color: Config.appTheme.overlay85),
                          value:
                              "$rupee ${Utils.formatNumber(currentValue.round(), isAmount: false)}",
                          valueStyle: AppFonts.f50014Black
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      ColumnText(
                        title: "Balance Units",
                        titleStyle: AppFonts.f40013
                            .copyWith(color: Config.appTheme.overlay85),
                        value: "${balanceUnits.toStringAsFixed(4)} ",
                        valueStyle:
                            AppFonts.f50014Black.copyWith(color: Colors.white),
                        alignment: CrossAxisAlignment.start,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isLoading
                      ? Utils.shimmerWidget(devHeight,
                          margin: EdgeInsets.all(16))
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

  Widget listCard() {
    if (tranxList.isEmpty) return Center(child: Text("No Data Available"));
    return Container(
      color: Config.appTheme.mainBgColor,
      padding: EdgeInsets.only(top: 8),
      child: ListView.builder(
        itemCount: tranxList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          Map data = tranxList[index];
          return transactionCard(data);
        },
      ),
    );
  }

  Widget transactionCard(Map data) {
    double transAmt = data['tranx_amount'] ?? 0;
    double transUnits = data['tranx_units'] ?? 0;
    double cumulativeUnits = data['tranx_cumulative_units'] ?? 0;
    String dateString = data['tranx_date'] ?? "";
    String formattedTransDate = "";

    if (dateString.isNotEmpty) {
      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(dateString);
      formattedTransDate = DateFormat('dd MMM yyyy').format(parsedDate);
      //print(formattedTransDate);
    } else {
      formattedTransDate = "";
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: GestureDetector(
        onTap: () {},
        child: Card(
          elevation: 0,
          color: Colors.white,
          child: Column(
            children: [
              //1st row
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedTransDate,
                      style: AppFonts.f50014Black
                          .copyWith(color: Config.appTheme.themeColor),
                      textAlign: TextAlign.start,
                    ),
                    Container(
                      width: devWidth * 0.5, // Adjust the width as needed
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Config.appTheme.overlay85,
                      ),
                      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                      child: Text(
                        "${data['tranx_type']}",
                        style: AppFonts.f40013
                            .copyWith(color: Config.appTheme.themeColor),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
              //2nd row
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColumnText(
                      title: "Amount",
                      value:
                          "$rupee ${Utils.formatNumber(transAmt.round(), isAmount: false)}",
                    ),
                    ColumnText(
                      title: "NAV",
                      value: "${data['tranx_nav']}",
                      alignment: CrossAxisAlignment.center,
                    ),
                    ColumnText(
                      title: "Units",
                      value: Utils.formatNumber(transUnits),
                      alignment: CrossAxisAlignment.end,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: DottedLine(),
              ),
              //3rd row
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            "Balance Units: ${Utils.formatNumber(cumulativeUnits)}",
                            style: AppFonts.f50012
                                .copyWith(color: Config.appTheme.themeColor)),
                        SizedBox(
                          width: 6,
                        ),
                      ],
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

  Widget blackCard() {
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
              Text("Transaction Summary",
                  style: AppFonts.f50014Grey.copyWith(color: Colors.white)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Inflow",
                value: "$rupee ${Utils.formatNumber(450000, isAmount: false)}",
                titleStyle: AppFonts.f40013.copyWith(
                  color: AppColors.lineColor,
                ),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title: "Outflow",
                value: "$rupee ${Utils.formatNumber(450000, isAmount: false)}",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.lineColor),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Dividend Paid",
                value: "$rupee ${Utils.formatNumber(450000, isAmount: false)}",
                titleStyle: AppFonts.f40013.copyWith(
                  color: AppColors.lineColor,
                ),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title: "Dividend Reinvest",
                value: "$rupee ${Utils.formatNumber(450000, isAmount: false)}",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.lineColor),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}
