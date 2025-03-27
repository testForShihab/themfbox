import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/ReportApi.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpChip.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class FamilyMonthlyTransactionReport extends StatefulWidget {
  const FamilyMonthlyTransactionReport({super.key});

  @override
  State<FamilyMonthlyTransactionReport> createState() =>
      _FamilyMonthlyTransactionReportState();
}

class _FamilyMonthlyTransactionReportState
    extends State<FamilyMonthlyTransactionReport> {
  late double devWidth, devHeight;
  String selectedFinancialYear = "";
  double startingPoint = 0;

  List financialYearList = [];

  List masterList = [];
  int user_id = GetStorage().read('family_id');
  String client_name = GetStorage().read("client_name");
  Map reportActionData = {
    "Download PDF Report ": ["", "", "assets/pdf.png"],
    "Download Excel Report": ["", "", "assets/excel.png"],
  };

  Future getTrasanctions() async {
    if (masterList.isNotEmpty) return 0;

    Map data = await ReportApi.getTrasanctions(
      user_id: user_id,
      client_name: client_name,
      financial_year: selectedFinancialYear,
      transaction_type: "Monthly",
      purchase_type: "All",
      start_date: "",
      end_date: "",
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    masterList = data['master_list'];

    return 0;
  }

  Future getInvestorFinancialYears() async {
    if (financialYearList.isNotEmpty) return 0;

    Map data = await ReportApi.getInvestorFinancialYears(
      user_id: user_id,
      client_name: client_name,
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    financialYearList = data['list'];
    selectedFinancialYear = financialYearList[0];

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
                            "Family Monthly Transaction...",
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
                        "${ApiConfig.apiUrl}/admin/family/downloadFamilyPortfolioTransactionPdf?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&financial_year=$selectedFinancialYear&transaction_type=Monthly&purchase_type=&start_date=&end_date=";

                    http.Response response = await http.post(Uri.parse(url));
                    msgUrl = response.body;
                    Map data = jsonDecode(msgUrl);
                    String resUrl = data['msg'];
                    print("download $url");
                    rpDownloadFile(url: resUrl, context: context, index: index);
                    Get.back();
                  } else if (index == 1) {
                    String url =
                        "${ApiConfig.apiUrl}/admin/family/downloadFamilyPortfolioTransactionExcel?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&financial_year=$selectedFinancialYear&report_type=Monthly";
                    http.Response response = await http.post(Uri.parse(url));
                    msgUrl = response.body;
                    Map data = jsonDecode(msgUrl);
                    String resUrl = data['msg'];
                    print("email $url");
                    rpDownloadFile(url: resUrl, context: context, index: index);
                    Get.back();
                  } else {}
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
                          client_name: client_name,
                          transaction_type: 'Monthly',
                          start_date: '',
                          end_date: '',
                          purchase_type: '',
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
                          client_name: client_name,
                          financial_year: selectedFinancialYear,
                          report_type: 'Monthly',
                          start_date: '',
                          end_date: '',
                          purchase_type: '');
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isLoading
              ? Utils.shimmerWidget(devHeight, margin: EdgeInsets.all(16))
              : listCard(),
        ],
      ),
    );
  }

  bool isOpen = false;

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

  Widget listCard() {
    if (masterList.isEmpty) return NoData();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0XFFECF0F0),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: masterList.length,
        itemBuilder: (context, index) {
          Map mainItem = masterList[index];

          String month = mainItem['month'] ?? "";
          int familyTrnxCount = mainItem['family_transaction_count'];
          List familyList = mainItem['family_list'];

          return Container(
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              child: Theme(
                data: ThemeData(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  title: expansionTitle(month, familyTrnxCount),
                  children: [
                    Container(
                      color: Config.appTheme.mainBgColor,
                      padding: EdgeInsets.all(16),
                      child: totalFamilyCard(familyList),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget totalFamilyCard(List<dynamic> familyList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: familyList.length,
      itemBuilder: (context, index) {
        Map member = familyList[index];

        String name = member['name'];
        int invTrnxCount = member['investor_transaction_count'];
        List schemeList = member['list'];
        int colorIndex = index;
        int totalColors = AppColors.colorPalate.length;
        if (index > totalColors) colorIndex = totalColors % index;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InitialCard(
                  title: name,
                  bgColor: AppColors.colorPalate[colorIndex],
                ),
                SizedBox(width: 10),
                ColumnText(
                  title: name,
                  value: "$invTrnxCount Transactions",
                  titleStyle: AppFonts.f50014Theme,
                  valueStyle: AppFonts.f40013,
                )
              ],
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: schemeList.length,
              itemBuilder: (context, index) {
                Map scheme = schemeList[index];
                return schemeCard(scheme);
              },
            )
          ],
        );
      },
    );
  }

  Widget schemeCard(Map scheme) {
    String logo = scheme['logo'] ?? "";
    String name = scheme['scheme'] ?? "";
    String folio = scheme['folio_no'] ?? "";
    String dateStr = scheme['tranx_date'] ?? "";
    num trnxAmount = scheme['tranx_amount'] ?? 0;
    num nav = scheme['tranx_nav'] ?? 0;
    num units = scheme['tranx_units'] ?? 0;
    String trnxType = scheme['tranx_type'] ?? "";

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.white),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(logo, height: 32),
              SizedBox(width: 10),
              Expanded(
                child: ColumnText(
                  title: name,
                  value: "Folio : $folio",
                  titleStyle: AppFonts.f50014Black,
                  valueStyle: AppFonts.f40013,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // #region date & trnxType
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dateStr, style: AppFonts.f50014Theme),
              RpChip(label: trnxType)
            ],
          ),
          // #endregion
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Amount",
                  value: "$rupee ${Utils.formatNumber(trnxAmount.round())}"),
              ColumnText(
                title: "NAV",
                value: Utils.formatNumber(nav),
                alignment: CrossAxisAlignment.center,
              ),
              ColumnText(
                title: "Units",
                value: Utils.formatNumber(units),
                alignment: CrossAxisAlignment.end,
              ),
            ],
          )
        ],
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
                "$trnxCount Transacted Funds",
                style: AppFonts.f50012,
              ),
            ],
          ),
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
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                        itemCount: financialYearList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          String year = financialYearList[index];

                          return InkWell(
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
                                  child: Text(year),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            );
          });
        });
  }
}
