import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/ReportApi.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import 'InvestorTransactionDetails.dart';

class InvestorAllTransactionReport extends StatefulWidget {
  const InvestorAllTransactionReport({super.key});

  @override
  State<InvestorAllTransactionReport> createState() =>
      _InvestorAllTransactionReportState();
}

class _InvestorAllTransactionReportState
    extends State<InvestorAllTransactionReport> {
  int userId = getUserId();
  String clientName = GetStorage().read("client_name");

  String selectedFinancialYear = "";
  double startingPoint = 0;

  List financialYearList = [];

  List schemeList = [];
  num? inflow = 0, outflow = 0, divReinv = 0, divPaid = 0;

  Future getMfTransactionReport() async {
    if (schemeList.isNotEmpty) return 0;

    Map data = await ReportApi.getMfTransactionReport(
      user_id: userId,
      client_name: clientName,
      financial_year: selectedFinancialYear,
      transaction_type: "All",
      start_date: "",
      end_date: "",
      purchase_type: '',
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    schemeList = data['scheme_list'];
    inflow = data['trnx_purchase']!.round();
    outflow = data['trnx_redemption']!.round();
    divReinv = data['trnx_div_reinv']!.round();
    divPaid = data['trnx_divpayout']!.round();

    return 0;
  }

  Future getInvestorFinancialYears() async {
    if (financialYearList.isNotEmpty) return 0;

    Map data = await ReportApi.getInvestorFinancialYears(
        user_id: userId, client_name: clientName, all_flag: 'Y');
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

  bool isLoading = true;

  Future getDatas() async {
    isLoading = true;
    await getInvestorFinancialYears();
    await getMfTransactionReport();
    isLoading = false;
    return 0;
  }

  @override
  void initState() {
    super.initState();
  }

  late double devWidth, devHeight;

  @override
  Widget build(BuildContext context) {
    print("user id $userId");
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: financialYearList.isEmpty
                ? Config.appTheme.mainBgColor
                : Colors.white,
            appBar: AppBar(
              backgroundColor: Config.appTheme.themeColor,
              leadingWidth: 0,
              toolbarHeight: financialYearList.isNotEmpty ? 140 : 50,
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
                          "All Transaction",
                          style: AppFonts.f50014Black
                              .copyWith(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                          onTap: () {
                            showReportActionBottomSheet();
                          },
                          child: Icon(Icons.pending_outlined)),
                    ],
                  ),
                  if (financialYearList.isNotEmpty) ...[
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showFinancialYearBottomSheet();
                          },
                          child: appBarNewColumn(
                              "Financial Year",
                              selectedFinancialYear,
                              Icon(Icons.keyboard_arrow_down,
                                  color: Config.appTheme.themeColor)),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: 16),
                ],
              ),
            ),
            body: displayPage(),
          );
        });
  }

  showReportActionBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Config.appTheme.mainBgColor,
      context: context,
      // isScrollControlled: true,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        reportActionContainer(),
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

/*
  Map reportActionData = {
    "Download PDF Report ": ["", "", "assets/pdf.png"],
    /*"Download Excel Report": ["", "", "assets/excel.png"],*/
    "Email Report": ["", null, "assets/email.png"],
  };

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
                if (index == 0) {
                  String url =
                      "${ApiConfig.apiUrl}/investor/download/downloadMonthlyTransactionPdf?key=${ApiConfig.apiKey}&client_name=$clientName&user_id=$userId&type=pdf&financial_year=$selectedFinancialYear&transaction_type=All&purchase_type=All&start_date&end_date&folio&scheme_code";
                  http.Response response = await http.post(Uri.parse(url));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  String resUrl = data['msg'];
                  print("download $url");
                  rpDownloadFile(url: resUrl, context: context, index: index);
                  Get.back();
                } else if (index == 1) {
                } else if (index == 2) {
                  String url =
                      "${ApiConfig.apiUrl}/investor/download/downloadMonthlyTransactionPdf?key=${ApiConfig.apiKey}&client_name=$clientName&user_id=$userId&type=email&financial_year=$selectedFinancialYear&transaction_type=All&purchase_type=All&start_date&end_date&folio&scheme_code";
                  http.Response response = await http.post(Uri.parse(url));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  String resUrl = data['msg'];
                  print("email $url");
                  rpDownloadFile(url: resUrl, context: context, index: index);
                  Get.back();
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
                Map data = await ReportApi.downloadMonthlyTransactionPdf(
                    user_id: userId,
                    client_name: clientName,
                    selectedFinancialYear: selectedFinancialYear,
                    type: type,
                    transaction_type: 'All',
                    start_date: '',
                    end_date: '');
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
    return SideBar(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLoading
                ? Utils.shimmerWidget(130, margin: EdgeInsets.all(16))
                : blackCard(),
            SizedBox(
              height: 20,
            ),
            isLoading
                ? Utils.shimmerWidget(devHeight, margin: EdgeInsets.all(16))
                : listCard(),
          ],
        ),
      ),
    );
  }

  Widget listCard() {
    if (schemeList.isEmpty) return NoData();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: schemeList.length,
      itemBuilder: (context, index) {
        Map scheme = schemeList[index];
        return trnxCard(scheme);
      },
    );
  }

  GestureDetector trnxCard(Map scheme) {
    num currValue = scheme['totalCurrentValue'];
    String balanceUnit = scheme['totalUnits_str'];
    List trnxList = scheme['investorSchemeWiseTransactionResponses'];

    return GestureDetector(
      onTap: () {
        Get.to(() => InvestorTransactionDetails(schemeItem: scheme));
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  scheme["amc_logo"],
                  height: 32,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ColumnText(
                    title: "${scheme['scheme_amfi_short_name']}",
                    value: "Folio : ${scheme['foliono']}",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Config.appTheme.placeHolderInputTitleAndArrow,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnText(
                  hasRightPadding: true,
                  title: "Current Value",
                  value: "$rupee ${Utils.formatNumber(currValue.round())}",
                ),
                ColumnText(
                  hasRightPadding: true,
                  title: "Balance Units",
                  value: balanceUnit,
                  alignment: CrossAxisAlignment.start,
                ),
                ColumnText(
                  title: "Transactions",
                  value: "${trnxList.length}",
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            DottedLine(),
          ],
        ),
      ),
    );
  }

  String getFirst13(String text) {
    String s = text.split(":").last;
    if (s.length > 12) s = s.substring(0, 12);
    return s;
  }

  String getFirst24(String text) {
    String s = text.split(":").last;
    if (s.length > 24) s = s.substring(0, 24);
    return s;
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
                value: "$rupee ${Utils.formatNumber(inflow, isAmount: false)}",
                titleStyle: AppFonts.f40013.copyWith(
                  color: AppColors.lineColor,
                ),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title: "Outflow",
                value: "$rupee ${Utils.formatNumber(outflow, isAmount: false)}",
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
                value: "$rupee ${Utils.formatNumber(divPaid, isAmount: false)}",
                titleStyle: AppFonts.f40013.copyWith(
                  color: AppColors.lineColor,
                ),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title: "Dividend Reinvest",
                value:
                    "$rupee ${Utils.formatNumber(divReinv, isAmount: false)}",
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
                                  schemeList = [];
                                  Get.back();
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: selectedFinancialYear,
                                      value: financialYearList[index],
                                      onChanged: (val) {
                                        selectedFinancialYear = year;
                                        schemeList = [];
                                        Get.back();
                                        setState(() {});
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
