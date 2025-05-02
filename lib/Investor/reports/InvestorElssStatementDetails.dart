 import 'package:flutter/cupertino.dart';
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

import 'package:mymfbox2_0/rp_widgets/RpChip.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';

class InvestorElssStatementDetails extends StatefulWidget {
  InvestorElssStatementDetails(
      {super.key,
      required this.schemeItem,
      required this.investedamount,
      required this.transactions});
  final Map schemeItem;
  num investedamount;
  num transactions;
  @override
  State<InvestorElssStatementDetails> createState() =>
      _InvestorElssStatementDetailsState();
}

class _InvestorElssStatementDetailsState
    extends State<InvestorElssStatementDetails> {
  Map schemeItem = {};
  late double devWidth, devHeight;
  List tranxList = [];

  num investedamount = 0;
  num transactions = 0;

  bool isLoading = true;

  Map BottomSheetdata = {
    "Download PDF Report ": ["", "", "assets/pdf.png"],
    /*"Download Excel Report": ["", "", "assets/excel.png"],*/
    "Email Report": ["", null, "assets/email.png"],
  };

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
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          reportacton();
                        },
                        child: Icon(Icons.pending_outlined)),
                  ],
                ),
              ],
            ),
          ),
          body: displayPage(),
        );
      },
    );
  }

  reportacton() {
    showModalBottomSheet(
      backgroundColor: Config.appTheme.mainBgColor,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SizedBox(
              height: devHeight * 0.310,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: devWidth * 0.05),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: Text(
                            "Report Actions",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        listContainer(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget listContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: BottomSheetdata.length,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 16,
            child: DottedLine(),
          );
        },
        itemBuilder: (context, index) {
          String title = BottomSheetdata.keys.elementAt(index);
          List stitle = BottomSheetdata.values.elementAt(index);
          String imagePath = stitle[2];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () {},
              child: RpListTile(
                title: SizedBox(
                  width: 220,
                  child: Text(
                    title,
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor),
                  ),
                ),
                subTitle: Visibility(
                  visible: stitle[0].isNotEmpty,
                  child: Text(stitle[0], style: AppFonts.f40013),
                ),
                leading: Image.asset(
                  imagePath,
                  color: Config.appTheme.themeColor,
                  width: 32,
                  height: 32,
                ),
                showArrow: false,
              ),
            ),
          );
        },
      ),
    );
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
    tranxList = schemeItem['inv_transaction_list'];
    String schemeName = schemeItem['scheme'].toString();
    String folioNumber = schemeItem['foliono'] ?? '';

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
                        schemeItem["amc_logo"],
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
    double transAmt = data['amount'] ?? 0;
    double transUnits = data['units'] ?? 0;
    double cumulativeUnits = data['purprice'] ?? 0;
    String dateString = data['traddate_str'] ?? "";
    String formattedTransDate = "";
    String tranxType = data['trxntype'];

    if (dateString.isNotEmpty) {
      DateTime parsedDate = DateFormat('yyyy-MM-DD').parse(dateString);
      formattedTransDate = DateFormat('dd MMM yyyy').format(parsedDate);
      print(formattedTransDate);
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
                    RpChip(label: tranxType)
                  ],
                ),
              ),
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
                      value: "${data['purprice']}",
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
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget blackCard() {
    investedamount = widget.investedamount;
    transactions = widget.transactions;

    print("investedamount $investedamount");

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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ColumnText(
                title: "Amount Invested",
                value:
                    "$rupee ${Utils.formatNumber(investedamount, isAmount: false)}",
                titleStyle: AppFonts.f40013.copyWith(
                  color: AppColors.lineColor,
                ),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              Spacer(),
              ColumnText(
                title: "Transactions",
                value: "$transactions",
                alignment: CrossAxisAlignment.start,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.lineColor),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
