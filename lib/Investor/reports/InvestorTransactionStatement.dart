import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/Investor/reports/InvestorTrnxStmtDetails.dart';
import 'package:mymfbox2_0/api/ReportApi.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class InvestorTransactionStatement extends StatefulWidget {
  const InvestorTransactionStatement({super.key});

  @override
  State<InvestorTransactionStatement> createState() =>
      _InvestorTransactionStatementState();
}

class _InvestorTransactionStatementState
    extends State<InvestorTransactionStatement> {
  int user_id = getUserId();
  String clientName = GetStorage().read("client_name");

  String selectedFinancialYear = "";
  double startingPoint = 0;

  List financialYearList = [];

  List scheme_list = [];

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  String startDate = DateFormat('dd-MM-yyyy')
      .format(DateTime.now().subtract(Duration(days: 30)));
  String endDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  int checkDateDialog = 0;

  Future getMfTransactionReport() async {
    // if (scheme_list.isNotEmpty) return 0;

    Map data = await ReportApi.getMfTransactionReport(
      user_id: user_id,
      client_name: clientName,
      financial_year: '',
      transaction_type: "Transaction Statement",
      start_date: startDate,
      end_date: endDate,
      purchase_type: '',
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    scheme_list = data['scheme_list'];

    return 0;
  }

  Future getInvestorFinancialYears() async {
    // if (financialYearList.isNotEmpty) return 0;

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

  bool isLoading = true;

  late Future future;

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
    startDateController.text = startDate;
    endDateController.text = endDate;
    future = getDatas();
  }

  refreshState() {
    setState(() {
      future = getDatas();
    });
  }

  late double devWidth, devHeight;

  bool isValidDateRange() {
    final st = convertStrToDt(startDate);
    final ed = convertStrToDt(endDate);
    if (st.isAfter(ed) || st.isAtSameMomentAs(ed)) {
      Utils.showError(
          context, 'Please choose an end date that comes after the start date');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          return SideBar(
            child: Scaffold(
              backgroundColor: financialYearList.isEmpty
                  ? Config.appTheme.mainBgColor
                  : Colors.white,
              appBar: AppBar(
                backgroundColor: Config.appTheme.themeColor,
                leadingWidth: 0,
                toolbarHeight: 140,
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
                            "Transaction Statement",
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
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              startDateController.text =
                                  startDateController.text;
                              checkDateDialog = 0;
                              showDatePickerDialog(context, 0);
                            },
                            child: appBarColumn(
                                "Start Date",
                                getFirst13(startDateController.text),
                                Icon(Icons.keyboard_arrow_down,
                                    color: Config.appTheme.themeColor)),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              endDateController.text = endDateController.text;
                              checkDateDialog = 1;
                              showDatePickerDialog(context, 1);
                            },
                            child: appBarColumn(
                                "End Date",
                                getFirst13(endDateController.text),
                                Icon(Icons.keyboard_arrow_down,
                                    color: Config.appTheme.themeColor)),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          height: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Config.appTheme.overlay85,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            onPressed: () {
                              if (isValidDateRange()) {
                                refreshState();
                              }
                            },
                            child: Text('Apply'),
                          ),
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

  void showDatePickerDialog(BuildContext context, int dateType) async {
    DateTime initialDateTime;
    if (dateType == 0 && startDate.isNotEmpty) {
      initialDateTime = DateFormat('dd-MM-yyyy').parse(startDate);
    } else if (dateType == 1 && endDate.isNotEmpty) {
      initialDateTime = DateFormat('dd-MM-yyyy').parse(endDate);
    } else {
      initialDateTime = DateTime.now();
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      if (dateType == 0 && startDate != formattedDate) {
        startDateController.text = formattedDate;
        startDate = formattedDate;
        setState(() {});
      } else if (dateType == 1 && endDate != formattedDate) {
        endDateController.text = formattedDate;
        endDate = formattedDate;
        setState(() {});
      }

      if (startDate.isNotEmpty && endDate.isNotEmpty) {
        // scheme_list = [];
        setState(() {});
      }
    }
  }

  Widget appBarColumn(String title, String value, Widget suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14)),
        Container(
          width: devWidth * 0.42,
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
                      "${ApiConfig.apiUrl}/investor/download/downloadMonthlyTransactionPdf?key=${ApiConfig.apiKey}&client_name=$clientName&user_id=$user_id&type=pdf&financial_year=&transaction_type=Transaction Statement&purchase_type=&start_date=$startDate&end_date=$endDate";
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
                      "${ApiConfig.apiUrl}/investor/download/downloadMonthlyTransactionPdf?key=${ApiConfig.apiKey}&client_name=$clientName&user_id=$user_id&type=email&financial_year=&transaction_type=Transaction Statement&purchase_type=&start_date=$startDate&end_date=$endDate";
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
                    user_id: user_id,
                    client_name: clientName,
                    selectedFinancialYear: selectedFinancialYear,
                    type: type,
                    transaction_type: 'Transaction Statement',
                    start_date: startDate,
                    end_date: endDate);
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
          SizedBox(
            height: 20,
          ),
          isLoading
              ? Utils.shimmerWidget(devHeight, margin: EdgeInsets.all(16))
              : listCard(),
        ],
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

  GestureDetector trnxCard(Map scheme) {
    String? currValue = scheme['totalCurrentValue_str'] ?? "";
    String balanceUnit = scheme['totalUnits_str'];
    List trnxList = scheme['investorSchemeWiseTransactionResponses'];
    String logo = scheme['amc_logo'];

    return GestureDetector(
      onTap: () {
        Get.to(() => InvestorTrnxStmtDetails(schemeItem: scheme));
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  logo,
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
                  title: "Current Value",
                  value:
                      "$rupee ${double.tryParse(currValue?.split(',').join() ?? '0')?.round()}",
                ),
                ColumnText(
                  title: "Balance Units",
                  value: balanceUnit,
                  alignment: CrossAxisAlignment.center,
                ),
                ColumnText(
                  title: "Transactions",
                  value: "${trnxList.length}",
                  alignment: CrossAxisAlignment.end,
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
}
