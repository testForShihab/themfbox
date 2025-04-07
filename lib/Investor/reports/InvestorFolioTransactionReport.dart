import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/api/ReportApi.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/NoData.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../rp_widgets/RpChip.dart';
import '../../rp_widgets/RpListTile.dart';

class InvestorFolioTransactionReport extends StatefulWidget {
  const InvestorFolioTransactionReport({super.key});

  @override
  State<InvestorFolioTransactionReport> createState() =>
      _InvestorFolioTransactionReportState();
}

class _InvestorFolioTransactionReportState
    extends State<InvestorFolioTransactionReport> {
  late double devWidth, devHeight;
  String selectedFinancialYear = "";
  double startingPoint = 0;

  List financialYearList = [];

  List folioList = [];

  int user_id = GetStorage().read('user_id');
  String client_name = GetStorage().read("client_name");

  Future getMfTransactionReport() async {
    if (folioList.isNotEmpty) return 0;

    Map data = await ReportApi.getMfTransactionReport(
      user_id: user_id,
      client_name: client_name,
      financial_year: selectedFinancialYear,
      transaction_type: "folio",
      start_date: "",
      end_date: "",
      purchase_type: '',
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    folioList = data['fol_tran_list'];
    // invTrnxList = data['investorSchemeWiseTransactionResponses'];
    return 0;
  }

  Future getInvestorFinancialYears() async {
    if (financialYearList.isNotEmpty) return 0;

    Map data = await ReportApi.getInvestorFinancialYears(
        user_id: user_id, client_name: client_name, all_flag: "Y");
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

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return SideBar(
            child: Scaffold(
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
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back),
                          SizedBox(width: 5),
                          Text(
                            "Folio Wise Transaction",
                            style: AppFonts.f50014Black
                                .copyWith(fontSize: 18, color: Colors.white),
                          ),
                          Spacer(),
                          GestureDetector(
                              onTap: () {
                                showReportActionBottomSheet();
                              },
                              child: Icon(Icons.pending_outlined)),
                        ],
                      ),
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
            ),
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
                      "${ApiConfig.apiUrl}/investor/download/downloadMonthlyTransactionPdf?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id&type=pdf&financial_year=$selectedFinancialYear&transaction_type=Folio&purchase_type=&start_date=&end_date=";
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
                      "${ApiConfig.apiUrl}/investor/download/downloadMonthlyTransactionPdf?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id&type=email&financial_year=$selectedFinancialYear&transaction_type=Folio&purchase_type=&start_date=&end_date=";
                  http.Response response = await http.post(Uri.parse(url));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  String resUrl = data['msg'];
                  print("Email $url");
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
                    user_id: user_id,
                    client_name: client_name,
                    selectedFinancialYear: selectedFinancialYear,
                    type: type,
                    transaction_type: 'Folio',
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
    if (folioList.isEmpty) return NoData();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0XFFECF0F0),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: folioList.length,
        itemBuilder: (context, index) {
          Map mainItem = folioList[index];
          String month = mainItem['folio_no'] ?? "";
          List portfolio_list =
              mainItem['investorSchemeWisePortfolioResponses'];
          int trnxCount = portfolio_list.length;

          return Container(
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              child: Theme(
                data: ThemeData(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  title: expansionTitle(month, trnxCount),
                  children: [
                    Container(
                      color: Config.appTheme.mainBgColor,
                      padding: EdgeInsets.all(16),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: portfolio_list.length,
                        itemBuilder: (context, index) {
                          int colorIndex = index;
                          int totalColors = AppColors.colorPalate.length;
                          if (index > totalColors)
                            colorIndex = totalColors % index;
                          Map scheme = portfolio_list[index];
                          return schemeCard(scheme);
                        },
                      ),
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

  Widget schemeCard(Map scheme) {
    String logo = scheme['amc_logo'];
    String name = scheme['scheme_amfi_short_name'];
    List invTrnxList = scheme['investorSchemeWiseTransactionResponses'];

    print("logo $name");
    print("inv trnx ${invTrnxList.length}");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.network(logo, height: 32),
            SizedBox(width: 10),
            Expanded(
                child: Text(
              name,
              maxLines: 4,
              style: AppFonts.f50014Black,
            )),
          ],
        ),
        SizedBox(height: 10),
        Container(
          color: Config.appTheme.mainBgColor,
          padding: EdgeInsets.all(0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: invTrnxList.length,
            itemBuilder: (context, index) {
              Map scheme = invTrnxList[index];
              return transactCard(scheme);
            },
          ),
        )
      ],
    );
  }

  Widget transactCard(Map scheme) {
    String dateStr = scheme['traddate_str'] ?? "";
    if (dateStr.isNotEmpty) {
      DateFormat inputFormat = DateFormat('dd MMM yyyy', 'en_US');
      DateFormat outputFormat = DateFormat('dd MMM yyyy', 'en_US');

      // Parse the input date string
      DateTime date = inputFormat.parse(dateStr);

      // Format the parsed date to the desired output format
      dateStr = outputFormat.format(date);
    }

    num? trnxAmount = scheme['amount'].round() ?? 0;
    num nav = scheme['purprice'] ?? 0;
    num units = scheme['units'] ?? 0;
    String trnxType = scheme['trxn_TYPE_'] ?? '';
    num stampDuty = scheme['stamp_DUTY'];
    num tds = scheme['total_TAX'];
    double loadAmt = scheme['loads'] ?? 0;
    num stt = scheme['stt'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(dateStr, style: AppFonts.f50014Theme),
                      RpChip(label: trnxType),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ColumnText(
                          hasRightPadding: true,
                          title: "Amount",
                          value: "$rupee ${Utils.formatNumber(trnxAmount)}",
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ColumnText(
                          hasRightPadding: true,
                          title: "NAV",
                          value: Utils.formatNumber(nav),
                          alignment: CrossAxisAlignment.start,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ColumnText(
                          hasRightPadding: true,
                          title: "Units",
                          value: Utils.formatNumber(units),
                          alignment: CrossAxisAlignment.start,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ColumnText(
                          title: "Stamp Duty",
                          value: stampDuty.toString(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ColumnText(
                          title: "TDS",
                          value: Utils.formatNumber(tds),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ColumnText(
                          title: "STT",
                          value: stt.round().toString(),
                          alignment: CrossAxisAlignment.start,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ColumnText(
                          title: 'Load Amt',
                          value: loadAmt.toString(),
                          alignment: CrossAxisAlignment.start,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ],
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
              Text("Folio: $month", style: AppFonts.f50014Black),
              Text(
                "$trnxCount Transactions",
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
                              folioList = [];
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
                                    folioList = [];
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
