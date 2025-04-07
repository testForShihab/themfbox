import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Family/reports/FamilyTransactionDetails.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/ReportApi.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class FamilyAllTransactionReport extends StatefulWidget {
  const FamilyAllTransactionReport({super.key});

  @override
  State<FamilyAllTransactionReport> createState() =>
      _FamilyAllTransactionReportState();
}

class _FamilyAllTransactionReportState
    extends State<FamilyAllTransactionReport> {
  int user_id = GetStorage().read("family_id");
  String clientName = GetStorage().read("client_name");

  String selectedFinancialYear = "";
  double startingPoint = 0;

  List financialYearList = [];

  List masterList = [];
  Map reportActionData = {
    "Download PDF Report ": ["", "", "assets/pdf.png"],
    "Download Excel Report": ["", "", "assets/excel.png"],
  };

  Future getTrasanctions() async {
    if (masterList.isNotEmpty) return 0;

    Map data = await ReportApi.getTrasanctions(
      user_id: user_id,
      client_name: clientName,
      financial_year: selectedFinancialYear,
      transaction_type: "All",
      purchase_type: "All",
      start_date: "",
      end_date: "",
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    masterList = data['master_list'];

    print("length ${masterList.length}");
    return 0;
  }

  Future getInvestorFinancialYears() async {
    if (financialYearList.isNotEmpty) return 0;

    Map data = await ReportApi.getInvestorFinancialYears(
      user_id: user_id,
      client_name: clientName,
      all_flag: 'Y'
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    financialYearList = data['list'];
    selectedFinancialYear = financialYearList[1];
    print("length ${financialYearList.length}");
    return 0;
  }

  bool isLoading = true;

  Future getDatas() async {
    isLoading = true;
    await getInvestorFinancialYears();
    await getTrasanctions();
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
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return SideBar(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Config.appTheme.themeColor,
                leadingWidth: 0,
                toolbarHeight: 140,
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
                          Icon(Icons.arrow_back),
                          SizedBox(width: 5),
                          Text(
                            "Family All Transaction Report",
                            style: AppFonts.f50014Black
                                .copyWith(fontSize: 18, color: Colors.white),
                          ),
                          Spacer(),
                          IconButton(
                              icon: Icon(Icons.pending_outlined),
                              onPressed: () {
                                showReportActionBottomSheet();
                              }),
                        ],
                      ),
                    ),
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
                    SizedBox(height: 16),
                  ],
                ),
              ),
              body: displayPage(),
              /*body: SideBar(
                child: SingleChildScrollView(
                  child: isLoading
                      ? Utils.shimmerWidget(devHeight,
                          margin: EdgeInsets.all(16))
                      : //blackCard(),
                      listCard(),
                ),
              ),*/
            ),
          );
        });
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
                print("investorIddd $user_id");
                if (user_id != 0) {
                  if (index == 0) {
                    print("donwload $selectedFinancialYear");

                    String url =
                        "${ApiConfig.apiUrl}/admin/family/downloadFamilyPortfolioTransactionPdf?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$clientName&financial_year=$selectedFinancialYear&transaction_type=All&purchase_type=&start_date=&end_date=";

                    http.Response response = await http.post(Uri.parse(url));
                    msgUrl = response.body;
                    Map data = jsonDecode(msgUrl);
                    String resUrl = data['msg'];
                    print("download $url");
                    rpDownloadFile(url: resUrl, context: context, index: index);
                    Get.back();
                  } else if (index == 1) {
                    String url =
                        "${ApiConfig.apiUrl}/admin/family/downloadFamilyPortfolioTransactionExcel?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$clientName"
                        "&financial_year=$selectedFinancialYear&report_type=All";
                    http.Response response = await http.post(Uri.parse(url));
                    msgUrl = response.body;
                    Map data = jsonDecode(msgUrl);
                    String resUrl = data['msg'];
                    print("email $url");
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

  List reportActions = [
    {
      'title': "Download PDF Report",
      'img': "assets/pdf.png",
      'type': ReportType.DOWNLOAD,
    },
    {
      'title': "Download Excel Report",
      'img': "assets/excel.png",
      'type': ReportType.EXCEL,
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
                if (type == ReportType.DOWNLOAD) {
                  EasyLoading.show();
                  Map data =
                      await ReportApi.downloadFamilyPortfolioTransactionPdf(
                          user_id: user_id,
                          client_name: clientName,
                          transaction_type: 'All',
                          start_date: '',
                          end_date: '',
                          purchase_type: 'All',
                          financial_year: selectedFinancialYear);
                  if (data['status'] != 200) {
                    Utils.showError(context, data['msg']);
                    return;
                  }
                  EasyLoading.dismiss();
                  Get.back();
                  rpDownloadFile(url: data['msg'], index: index);
                } else {
                  EasyLoading.show();
                  Map data =
                      await ReportApi.downloadFamilyPortfolioTransactionExcel(
                          user_id: user_id,
                          client_name: clientName,
                          report_type: 'All',
                          financial_year: selectedFinancialYear,
                          start_date: '',
                          end_date: '',
                          purchase_type: 'All');
                  if (data['status'] != 200) {
                    Utils.showError(context, data['msg']);
                    return;
                  }
                  EasyLoading.dismiss();
                  Get.back();
                  rpDownloadFile(url: data['msg'], index: index);
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

  Widget displayPage() {
    return SingleChildScrollView(
      child: isLoading
          ? Utils.shimmerWidget(devHeight, margin: EdgeInsets.all(16))
          : //blackCard(),
          listCard(),
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

  Widget listCard() {
    if (masterList.isEmpty) return NoData();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: masterList.length,
      itemBuilder: (context, index) {
        Map mainItem = masterList[index];

        return familyExpansionTile(mainItem, index);
      },
    );
  }

  Widget familyExpansionTile(Map mainItem, int index) {
    String name = mainItem['name'] ?? "";
    num trnxCount = mainItem['trnx_count'];
    List schemeList = mainItem['scheme_details'] ?? [];

    return Container(
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        child: Theme(
          data: ThemeData(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            title: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  InitialCard(
                    title: name[0],
                    bgColor: AppColors.colorPalate[index],
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getFirst20(name), style: AppFonts.f50014Black),
                      Text(
                        "$trnxCount Transacted Funds",
                        style: AppFonts.f50012,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            children: [
              Container(
                color: Config.appTheme.mainBgColor,
                padding: EdgeInsets.only(top: 16),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: schemeList.length,
                  itemBuilder: (context, index) {
                    Map scheme = schemeList[index];

                    return trnxCard(scheme);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector trnxCard(Map scheme) {
    num currValue = scheme['curr_value'];
    num balanceUnit = scheme['balance_unit'];
    List trnxList = scheme['tranx_list'];

    return GestureDetector(
      onTap: () {
        Get.to(() => FamilyTransactionDetails(schemeItem: scheme));
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                  scheme["logo"],
                  height: 32,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ColumnText(
                    title: "${scheme['scheme_amfi_short_name']}",
                    value: "Folio : ${scheme['folio_no']}",
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
                  title: "Current Value",
                  value: "$rupee ${Utils.formatNumber(balanceUnit)}",
                ),
                ColumnText(
                  title: "Balance Units",
                  value: Utils.formatNumber(currValue),
                  alignment: CrossAxisAlignment.center,
                ),
                ColumnText(
                  title: "Transactions",
                  value: "${trnxList.length}",
                  alignment: CrossAxisAlignment.end,
                ),
              ],
            ),
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

  String getFirst20(String text) {
    String s = text.split(":").first;
    if (s.length > 20) s = s.substring(0, 20);
    return s;
  }

  String getFirst24(String text) {
    String s = text.split(":").last;
    if (s.length > 24) s = '${s.substring(0, 24)}...';
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
                                  masterList = [];
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
                                        masterList = [];
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
