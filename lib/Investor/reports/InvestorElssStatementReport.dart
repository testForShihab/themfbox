import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/ReportApi.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/NoData.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import 'InvestorElssStatementDetails.dart';

class InvestorElssStatementReport extends StatefulWidget {
  const InvestorElssStatementReport({Key? key}) : super(key: key);

  @override
  State<InvestorElssStatementReport> createState() =>
      _InvestorElssStatementReportState();
}

class _InvestorElssStatementReportState
    extends State<InvestorElssStatementReport> {
  late double devWidth, devHeight;
  int user_id = getUserId();
  String clientName = GetStorage().read("client_name");
  String selectedFinancialYear = "";
  List financialYearList = [];
  List scheme_list = [];
  bool isDateRange = false;
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  bool isLoading = true;
  double investedamount = 0;
  num transactions = 0;

  Future getDatas() async {
    isLoading = true;
    await getInvestorFinancialYears();
    await getElssStatementReport();
    isLoading = false;
    return 0;
  }

  Future getInvestorFinancialYears() async {
    if (financialYearList.isNotEmpty) return 0;

    Map data = await ReportApi.getInvestorFinancialYears(
      user_id: user_id,
      client_name: clientName,
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    financialYearList = data['list'];
    if (financialYearList.isNotEmpty) {
      selectedFinancialYear = financialYearList[0];
    }
    return 0;
  }

  Future getElssStatementReport() async {
    if (scheme_list.isNotEmpty) return 0;
    Map data = await ReportApi.getElssStatementReport(
      user_id: user_id,
      client_name: clientName,
      financial_year: selectedFinancialYear,
      option: 'fy',
      start_date: '',
      end_date: '',
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    investedamount = data['invested_amount'];
    transactions = data['no_of_transactions'];
    scheme_list = data['investorSchemeWisePortfolioResponseList'];
    return 0;
  }

  Map BottomSheetdata = {
    "Download PDF Report ": ["", "", "assets/pdf.png"],
    /*"Download Excel Report": ["", "", "assets/excel.png"],*/
  };

  @override
  Widget build(BuildContext context) {
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
                          "ELSS Statement",
                          style: AppFonts.f50014Black
                              .copyWith(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          showReportActionBottomSheet();
                        },
                        child: Icon(Icons.more_vert),
                      )
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
            body: financialYearList.isNotEmpty
                ? displayPage()
                : SizedBox(height: 120, child: NoData()),
          );
        });
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
              height: 30,
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
    if (scheme_list.isEmpty) return NoData();
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: scheme_list.length,
      itemBuilder: (context, index) {
        Map scheme = scheme_list[index];
        return trnxCard(scheme);
      },
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
                title: "Amount Invested",
                value:
                    "$rupee ${Utils.formatNumber(investedamount, isAmount: false)}",
                titleStyle: AppFonts.f40013.copyWith(
                  color: AppColors.lineColor,
                ),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title: "Transactions",
                value: "$transactions",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.lineColor),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  GestureDetector trnxCard(Map scheme) {
    List amtList = scheme['inv_transaction_list'];
    print("amtList ${amtList.length}");
    num? amount = scheme['totalInvestedAmount'] ?? 0;
    num units = scheme['totalUnits'] ?? 0;
    print('scheme length ${scheme.length}');
    print('amount $amount');
    print('units $units');

    return GestureDetector(
      onTap: () {
        Get.to(() => InvestorElssStatementDetails(
            schemeItem: scheme,
            investedamount: investedamount,
            transactions: transactions));
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        margin: EdgeInsets.fromLTRB(8, 16, 8, 0),
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
                  title: "Amount Invested",
                  value: "$rupee ${Utils.formatNumber(amount)}",
                ),
                ColumnText(
                  title: "Units",
                  value: units.toStringAsFixed(3),
                  alignment: CrossAxisAlignment.center,
                ),
                ColumnText(
                  title: "Transactions",
                  value: "${amtList.length}",
                  alignment: CrossAxisAlignment.end,
                ),
              ],
            ),
            /* ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: amtList.length,
              itemBuilder: (context, index) {
                Map scheme = amtList[index];
                return transactCard(scheme);
              },
            ),
            SizedBox(height: 15,),*/
            DottedLine(),
          ],
        ),
      ),
    );
  }

  Row transactCard(scheme) {
    num amount = scheme['amount'];
    num units = scheme['units'];
    print('scheme length ${scheme.length}');
    print('amount $amount');
    print('units $units');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ColumnText(
          title: "Amount Invested",
          value: "$rupee ${Utils.formatNumber(amount)}",
        ),
        ColumnText(
          title: "Units",
          value: "$units",
          alignment: CrossAxisAlignment.center,
        ),
        ColumnText(
          title: "Transactions",
          value: "${scheme.length}",
          alignment: CrossAxisAlignment.end,
        ),
      ],
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
                                  scheme_list = [];
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
                                        scheme_list = [];
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

/*
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
          String msgUrl = "";
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () async {
                EasyLoading.show();
                if (index == 0) {
                  String url =
                      "${ApiConfig.apiUrl}/investor/download/downloadElssStatementPdf?key=${ApiConfig.apiKey}&client_name=$clientName&user_id=$user_id&type=pdf&financial_year=$selectedFinancialYear";
                  http.Response response = await http.post(Uri.parse(url));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  String resUrl = data['msg'];
                  print("download $url");
                  rpDownloadFile(url: resUrl, context: context, index: index);
                  Get.back();
                } else if (index == 1) {}
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

  List reportActions = [
    {
      'title': "Download PDF Report",
      'img': "assets/pdf.png",
      'type': ReportType.DOWNLOAD,
    },
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
                Map data = await ReportApi.downloadElssStatementPdf(
                    user_id: user_id,
                    client_name: clientName,
                    financial_year: selectedFinancialYear);
                if (data['status'] != 200) {
                  Utils.showError(context, data['msg']);
                  return;
                }
                EasyLoading.dismiss();
                Get.back();
                rpDownloadFile(url: data['msg'], index: index);
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
}
