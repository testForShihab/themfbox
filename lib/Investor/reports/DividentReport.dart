import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/ReportApi.dart';
import 'package:mymfbox2_0/pojo/invreport/DividentReportResponse.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/NoData.dart';
import 'package:mymfbox2_0/rp_widgets/RpAboutIcon.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class DividendReport extends StatefulWidget {
  const DividendReport({super.key});

  @override
  State<DividendReport> createState() => _DividendReportState();
}

class _DividendReportState extends State<DividendReport> {
  late double devWidth, devHeight;
  int userId = getUserId();
  String clientName = GetStorage().read("client_name");

  bool isLoading = true;
  num? portfolioDividendPaid;
  num? portfolioDividendReinv;
  num? portfolioDividend;

  SchemeWisePortfolioResponses schemeWisePortfolioPojo =
      SchemeWisePortfolioResponses();
  DividendReportResponse dividendReportResponse = DividendReportResponse();
  String selectedFinancialYear = "";
  List financialYearList = [];
  String trxnType = "";
  Map reportActionData = {
    "Download PDF Report ": ["", "", "assets/pdf.png"],
    /*"Download Excel Report": ["", "", "assets/excel.png"],*/
    "Email Report": ["", null, "assets/email.png"],
  };

  List<SchemeWisePortfolioResponses> dividendList = [];

  Future getMfDividendReport() async {
    if (portfolioDividendPaid != null) return 0;

    Map<String, dynamic> data = await ReportApi.getMfDividendReport(
      user_id: userId,
      client_name: clientName,
      start_date: '',
      end_date: '',
      financial_year: selectedFinancialYear,
      filterType: 'year',
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    dividendReportResponse = DividendReportResponse.fromJson(data);
    portfolioDividendPaid = dividendReportResponse.portfolioDividendPaid;
    portfolioDividendReinv = dividendReportResponse.portfolioDividendReinv;
    portfolioDividend = dividendReportResponse.portfolioDividend;
    dividendList = dividendReportResponse.schemeWisePortfolioResponses!;
    return 0;
  }

  Future getInvestorFinancialYears() async {
    if (financialYearList.isNotEmpty) return 0;

    Map data = await ReportApi.getInvestorFinancialYears(
      user_id: userId,
      client_name: clientName,
      all_flag: 'Y',
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    financialYearList = data['list'];
    if (financialYearList.isNotEmpty) {
      selectedFinancialYear = financialYearList[1];
    }
    return 0;
  }

  Future getDatas() async {
    isLoading = true;
    await getInvestorFinancialYears();
    await getMfDividendReport();
    isLoading = false;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: AppBar(
              backgroundColor: Config.appTheme.themeColor,
              leadingWidth: 0,
              toolbarHeight: 50,
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
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          "Dividend Report",
                          style: AppFonts.f50014Black
                              .copyWith(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Spacer(),
                      if (financialYearList.isNotEmpty) ...[
                        IconButton(
                            icon: Icon(
                              Icons.filter_alt_outlined,
                              size: 25,
                            ),
                            onPressed: () {
                              showFinancialYearBottomSheet();
                            }),
                        IconButton(
                            icon: Icon(Icons.pending_outlined),
                            onPressed: () {
                              showReportActionBottomSheet();
                            }),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            body: financialYearList.isEmpty
                ? SizedBox(height: 120, child: NoData())
                : SideBar(
                    child: Container(
                      color: Config.appTheme.mainBgColor,
                      height: devHeight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Fixed header (mfSummaryCard)
                          topCard(),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      isLoading
                                          ? Utils.shimmerWidget(devHeight,
                                              margin: EdgeInsets.all(16))
                                          : (dividendReportResponse
                                                  .schemeWisePortfolioResponses!
                                                  .isEmpty)
                                              ? Column(
                                                  children: [
                                                    NoData(),
                                                    SizedBox(
                                                        height:
                                                            devHeight * 0.01),
                                                  ],
                                                )
                                              : ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: dividendReportResponse
                                                          .schemeWisePortfolioResponses
                                                          ?.length ??
                                                      0,
                                                  itemBuilder:
                                                      (context, index) {
                                                    SchemeWisePortfolioResponses?
                                                        investorSchemeWiseTransactionResponses =
                                                        dividendReportResponse
                                                                .schemeWisePortfolioResponses?[
                                                            index];
                                                    return schemeWisePortfolioCard(
                                                        investorSchemeWiseTransactionResponses!);
                                                  },
                                                ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        });
  }

  List reportActions = [
    {
      'title': "Download PDF Report",
      'img': "assets/pdf.png",
      'type': ReportType.DOWNLOAD,
    },
    {
      'title': "Email Report",
      'img': "assets/email.png",
      'type': ReportType.EMAIL,
    }
  ];

  Widget reportActionContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: reportActions.length,
        separatorBuilder: (context, index) {
          return DottedLine(verticalPadding: 4);
        },
        itemBuilder: (context, index) {
          Map data = reportActions[index];

          String title = data['title'];
          String img = data['img'];
          String type = data['type'];

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () async {
                EasyLoading.show();
                Map data = await ReportApi.downloadDividendReportPdf(
                    user_id: userId,
                    client_name: clientName,
                    type: type,
                    startDate: '',
                    endDate: '',
                    selectedFinancialYear: selectedFinancialYear);
                if (data['status'] != 200) {
                  Utils.showError(context, data['msg']);
                  return;
                }
                EasyLoading.dismiss();
                Get.back();

                if (type == ReportType.DOWNLOAD) {
                  rpDownloadFile(url: data['msg'], index: index);
                } else {
                  EasyLoading.showToast("${data['msg']}");
                }
              },
              child: RpListTile(
                title: SizedBox(
                  width: 220,
                  child: Text(
                    title,
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor),
                  ),
                ),
                subTitle: SizedBox(),
                leading: Image.asset(
                  img,
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

  showReportActionBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Config.appTheme.mainBgColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  BottomSheetTitle(title: "Report Actions"),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: reportActionContainer(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

/*

  Widget reportActionContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: reportActionData.length,
        separatorBuilder: (context, index) {
          return DottedLine(verticalPadding: 4);
        },
        itemBuilder: (context, index) {
          String title = reportActionData.keys.elementAt(index);
          List stitle = reportActionData.values.elementAt(index);
          String imagePath = stitle[2];
          String msgUrl = "";
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () async {
                EasyLoading.show();
                print("investorIddd $userId");
                if (userId != 0) {
                  if (index == 0) {
                    String url =
                        "${ApiConfig.apiUrl}/investor/download/downloadDividendReportPdf?key=${ApiConfig.apiKey}&user_id=$userId&client_name=$clientName&type=pdf&financial_year=$selectedFinancialYear&start_date="
                        "&end_date="
                        "&filterType=";

                    http.Response response = await http.post(Uri.parse(url));
                    msgUrl = response.body;
                    Map data = jsonDecode(msgUrl);
                    String resUrl = data['msg'];
                    print("download $url");
                    rpDownloadFile(url: resUrl, context: context, index: index);
                    Get.back();
                  } /*else if (index == 1) {
                    //   String url =
                    //       "${ApiConfig.apiUrl}/admin/download/portfolioAnalysisReport?key=${ApiConfig.apiKey}&user_id=$investorId&client_name=$client_name&type=excel&start_date="
                    //       "&end_date="
                    //       "&option=$selectedBenchMarkType"
                    //       "";
                    //   http.Response response = await http.post(Uri.parse(url));
                    //   msgUrl = response.body;
                    //   Map data = jsonDecode(msgUrl);
                    //   String resUrl = data['msg'];
                    //   print("email $url");
                    //   rpDownloadFile(url: resUrl, context: context, index: index);
                    //   Get.back();
                  }*/
                  else if (index == 2) {
                    String url =
                        "${ApiConfig.apiUrl}/investor/download/downloadDividendReportPdf?key=${ApiConfig.apiKey}&user_id=$userId&client_name=$clientName&type=email&financial_year=$selectedFinancialYear&start_date="
                        "&end_date="
                        "&filterType=";

                    http.Response response = await http.post(Uri.parse(url));
                    msgUrl = response.body;
                    Map data = jsonDecode(msgUrl);
                    String resUrl = data['msg'];
                    print("Email $url");
                    rpDownloadFile(url: resUrl, context: context, index: index);
                    Get.back();
                  }
                } else {
                  Utils.showError(context, "Please Select the Investor");
                  return;
                }
                EasyLoading.dismiss();
              },
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

*/

  Widget topCard() {
    TextStyle titleStyle =
        AppFonts.f50014Black.copyWith(fontSize: 18, color: Colors.grey);
    TextStyle valueStyle = AppFonts.f50014Black.copyWith(
      color: Config.appTheme.themeColor,
      fontSize: 18,
    );
    return Container(
      color: Config.appTheme.themeColor,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: (isLoading)
          ? Utils.shimmerWidget(200, margin: EdgeInsets.zero)
          : Column(
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "For FY $selectedFinancialYear",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Config.appTheme.overlay85,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ColumnText(
                          title: "Total Dividend",
                          value:
                              "$rupee ${Utils.formatNumber(portfolioDividend)}",
                          titleStyle: titleStyle,
                          valueStyle: valueStyle),
                      DottedLine(),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ColumnText(
                              title: "Dividend Paid",
                              value:
                                  "$rupee ${Utils.formatNumber(portfolioDividendPaid)}",
                              titleStyle: titleStyle,
                              valueStyle: valueStyle),
                          ColumnText(
                              title: "Dividend Reinvest",
                              value:
                                  "$rupee ${Utils.formatNumber(portfolioDividendReinv)}",
                              alignment: CrossAxisAlignment.end,
                              titleStyle: titleStyle,
                              valueStyle: valueStyle),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget schemeWisePortfolioCard(
      SchemeWisePortfolioResponses investorSchemeWiseTransactionResponses) {
    String? transactionType =
        investorSchemeWiseTransactionResponses.transactionType;
    if (transactionType == "Dividend Payout" ||
        transactionType == "DRO" ||
        transactionType == "Gross Dividend" ||
        transactionType == "Dividend Sweep Out" ||
        transactionType == "DP" ||
        transactionType == "DTPO") {
      trxnType = "Div paid";
    }
    if (transactionType == "Dividend Reinvest" ||
        transactionType == "Div. Reinvestment" ||
        transactionType == "Dividend Sweep In" ||
        transactionType == "DIR" ||
        transactionType == "DTPIN") {
      trxnType = "Div Reinvest";
    }

    return InkWell(
        onTap: () {
          showTransactionDetails(investorSchemeWiseTransactionResponses);
        },
        child: (isLoading)
            ? Utils.shimmerWidget(devHeight, margin: EdgeInsets.all(16))
            : Container(
                width: devWidth,
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: (isLoading)
                    ? Utils.shimmerWidget(130, margin: EdgeInsets.zero)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Row(
                              children: [
                                Image.network(
                                  "${investorSchemeWiseTransactionResponses.amcLogo}",
                                  height: 28,
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: devWidth * 0.6,
                                      child: Text(
                                        "${investorSchemeWiseTransactionResponses.scheme}",
                                        style: AppFonts.f50014Black,
                                      ),
                                    ),
                                    Text(
                                      "Folio: ${investorSchemeWiseTransactionResponses.folio}",
                                      style: AppFonts.f40013
                                          .copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios,
                                    size: 18, color: AppColors.arrowGrey)
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                columnText(
                                  "Dividend Date",
                                  " ${investorSchemeWiseTransactionResponses.dividendDateStr?.substring(0, 10)}",
                                ),
                                columnText("NAV",
                                    "${investorSchemeWiseTransactionResponses.nav}",
                                    alignment: CrossAxisAlignment.center),
                                columnText(
                                  trxnType,
                                  Utils.formatNumber(
                                      investorSchemeWiseTransactionResponses
                                          .amount
                                          ?.round()),
                                  alignment: CrossAxisAlignment.end,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            DottedLine(),
                          ]),
              ));
  }

  Widget columnText(String title, String value,
      {CrossAxisAlignment? alignment}) {
    return Column(
      crossAxisAlignment: alignment ?? CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.f40013,
        ),
        Text(
          value,
          style: AppFonts.f50014Grey.copyWith(color: Colors.black),
          maxLines: 3,
        )
      ],
    );
  }

  showTransactionDetails(
      SchemeWisePortfolioResponses investorSchemeWiseTransactionResponses) {
    String? transaction_type =
        investorSchemeWiseTransactionResponses.transactionType;

    if (transaction_type == "Dividend Payout" ||
        transaction_type == "DRO" ||
        transaction_type == "Gross Dividend" ||
        transaction_type == "Dividend Sweep Out" ||
        transaction_type == "DP" ||
        transaction_type == "DTPO") {
      trxnType = "Div paid";
    }
    if (transaction_type == "Dividend Reinvest" ||
        transaction_type == "Div. Reinvestment" ||
        transaction_type == "Dividend Sweep In" ||
        transaction_type == "DIR" ||
        transaction_type == "DTPIN") {
      trxnType = "Div Reinvest";
    }

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        builder: (context) {
          return StatefulBuilder(builder: (context, bottomState) {
            return Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              height: devHeight * 0.56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Column(
                children: [
                  BottomSheetTitle(title: "Divident Details"),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Utils.getImage(
                                  "${investorSchemeWiseTransactionResponses.amcLogo}",
                                  32),
                              SizedBox(width: 10),
                              Column(
                                children: [
                                  SizedBox(
                                    width: devWidth * 0.6,
                                    child: Text(
                                      "${investorSchemeWiseTransactionResponses.scheme}",
                                      style: AppFonts.f50014Black,
                                    ),
                                  ),
                                  SizedBox(
                                    width: devWidth * 0.5,
                                    child: Text(
                                      "Folio: ${investorSchemeWiseTransactionResponses.folio}",
                                      style: AppFonts.f40013
                                          .copyWith(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  columnText("Divident Date",
                                      "${investorSchemeWiseTransactionResponses.dividendDate?.substring(0, 10)}",
                                      alignment: CrossAxisAlignment.start),
                                  SizedBox(
                                    width: devWidth * 0.18,
                                  ),
                                  columnText("NAV",
                                      "${investorSchemeWiseTransactionResponses.nav}",
                                      alignment: CrossAxisAlignment.start),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  columnText(
                                    trxnType,
                                    Utils.formatNumber(
                                        investorSchemeWiseTransactionResponses
                                            .amount),
                                    alignment: CrossAxisAlignment.start,
                                  ),
                                  SizedBox(
                                    width: devWidth * 0.20,
                                  ),
                                  columnText(
                                    "Divident units",
                                    "${investorSchemeWiseTransactionResponses.divUnits}",
                                    alignment: CrossAxisAlignment.start,
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              DottedLine(),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  columnText(
                                    "Divident yield",
                                    "${investorSchemeWiseTransactionResponses.dividendYield?.toStringAsFixed(2)}",
                                    alignment: CrossAxisAlignment.start,
                                  ),
                                  SizedBox(
                                    width: devWidth * 0.20,
                                  ),
                                  columnText(
                                    "Divident Rate / Units",
                                    "${investorSchemeWiseTransactionResponses.divUnits}",
                                    alignment: CrossAxisAlignment.start,
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              DottedLine(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  columnText("TDS",
                                      "${investorSchemeWiseTransactionResponses.tds}"),
                                  SizedBox(
                                    width: devWidth * 0.35,
                                  ),
                                  columnText("STT",
                                      "${investorSchemeWiseTransactionResponses.stt}"),
                                ],
                              ),
                            ],
                          ),
                        ]),
                  ),
                ],
              ),
            );
          });
        });
  }

  PreferredSizeWidget appBar() {
    Widget? leading;
    return PreferredSize(
        preferredSize: Size(devWidth, 60),
        child: Container(
          //   color: Config.appTheme.themeColor,
          padding: EdgeInsets.fromLTRB(16, 44, 16, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: leading ??
                        GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(Utils.getFirst13("Dividend Report", count: 22),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white)),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      showFinancialYearBottomSheet();
                    },
                    child: Image.asset(
                      'assets/filter_alt.png',
                      height: 25,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  RpAboutIcon(
                    context: context,
                  ),
                ],
              )
            ],
          ),
        ));
  }

  showFinancialYearBottomSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (context, bottomState) {
            return Container(
              height: devHeight * 0.66,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  BottomSheetTitle(title: "Select Financial Year"),
                  Divider(height: 0),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            itemCount: financialYearList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              String year = financialYearList[index];
                              return GestureDetector(
                                onTap: () {
                                  selectedFinancialYear = year;
                                  portfolioDividendPaid = null;
                                  setState(() {});
                                  Get.back();
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: selectedFinancialYear,
                                      value: financialYearList[index],
                                      onChanged: (val) {
                                        selectedFinancialYear = year;
                                        portfolioDividendPaid = null;
                                        setState(() {});
                                        Get.back();
                                      },
                                    ),
                                    Expanded(
                                      child: Text(
                                        financialYearList[index],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })),
                  ),
                ],
              ),
            );
          });
        });
  }
}
