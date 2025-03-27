import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/api/ReportApi.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/NoData.dart';
import 'package:mymfbox2_0/rp_widgets/RpChip.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class InvestorDateWiseTransactionReport extends StatefulWidget {
  const InvestorDateWiseTransactionReport({super.key});

  @override
  State<InvestorDateWiseTransactionReport> createState() =>
      _InvestorDateWiseTransactionReportState();
}

class _InvestorDateWiseTransactionReportState
    extends State<InvestorDateWiseTransactionReport> {
  late double devWidth, devHeight;
  String selectedTransactionType = "";
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  String startDate = DateFormat('dd-MM-yyyy')
      .format(DateTime.now().subtract(Duration(days: 30)));
  String endDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  List transactionTypeList = [
    "All",
    "Purchase",
    "Redemption",
    "Switch In",
    "Switch Out",
    "Transfer",
    "SIP",
    "STP In",
    "STP Out",
    "SWP",
    "Dividend Payout",
    "Dividend Reinvest"
  ];
  int checkDateDialog = 0;
  List tran_list = [];
  List familyList = [];
  int user_id = getUserId();
  String clientName = GetStorage().read("client_name");
  num? divReinv = 0,
      divPaid = 0,
      purchase = 0,
      redemption = 0,
      swithIn = 0,
      switchOut = 0,
      transfer = 0;

  Future getMfTransactionReport() async {
    if (tran_list.isNotEmpty) return 0;

    Map data = await ReportApi.getMfTransactionReport(
      user_id: user_id,
      client_name: clientName,
      financial_year: "",
      transaction_type: "Date",
      start_date: startDate,
      end_date: endDate,
      purchase_type: selectedTransactionType,
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    tran_list = data['tran_list'];

    divReinv = data['trnx_div_reinv']!.round();
    divPaid = data['trnx_divpayout']!.round();
    purchase = data['trnx_purchase']!.round();
    redemption = data['trnx_redemption']!.round();
    swithIn = data['trnx_switchin']!.round();
    switchOut = data['trnx_switchout']!.round();
    transfer = data['trnx_transfer']!.round();

    EasyLoading.dismiss();
    return 0;
  }

  bool isLoading = true;

  Future getDatas() async {
    isLoading = true;
    await getMfTransactionReport();
    isLoading = false;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    startDateController.text = startDate;
    endDateController.text = endDate;
    selectedTransactionType = transactionTypeList[0];
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
              toolbarHeight: 200,
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
                          "Date Wise Transaction Report...",
                          style: AppFonts.f50014Black
                              .copyWith(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          showReportActionBottomSheet();
                        },
                        child: Icon(Icons.pending_outlined),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showTransactionTypeBottomSheet();
                        },
                        child: appBarNewColumn(
                            "Transaction Type",
                            getFirst13(selectedTransactionType),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          startDateController.text = startDateController.text;
                          checkDateDialog = 0;
                          showDatePickerDialog(context, 0);
                        },
                        child: appBarColumn(
                            "Start Date",
                            getFirst13(startDateController.text),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
                      ),
                      GestureDetector(
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
    return SideBar(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLoading
                ? Utils.shimmerWidget(330, margin: EdgeInsets.all(16))
                : blackCard(),
            SizedBox(
              height: 10,
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
    if (tran_list.isEmpty) return NoData();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: tran_list.length,
      itemBuilder: (context, index) {
        Map mainItem = tran_list[index];
        //print("transaction length ${mainItem.length}");
        return trnxCard(mainItem);
      },
    );
  }

  GestureDetector trnxCard(Map scheme) {
    num tranxAmount = scheme['amount'];
    num transNav = scheme['purprice'];
    num tranxUnits = scheme['units'];
    double stampDuty = scheme['stamp_DUTY'];
    double stt = scheme['stt'];
    double tds = scheme['total_TAX'];
    double loadAmt = scheme['loads'] ?? 0;

    String dateStr = scheme['traddate_str'];
    String formattedTransDate = "";
    if (dateStr.isNotEmpty) {
      DateTime parsedDate = DateFormat('yyyy-MM-DD').parse(dateStr);
      formattedTransDate = DateFormat('dd MMM yyyy').format(parsedDate);
    }

    String trnxType = scheme['trxn_TYPE_'];

    return GestureDetector(
      onTap: () {},
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
                    value: "Folio : ${scheme['folio_NO']}",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formattedTransDate, style: AppFonts.f50014Theme),
                RpChip(label: trnxType)
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
                    value: "$rupee ${Utils.formatNumber(tranxAmount.round())}",
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ColumnText(
                    hasRightPadding: true,
                    title: "NAV",
                    value: "$transNav",
                    alignment: CrossAxisAlignment.start,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ColumnText(
                    hasRightPadding: true,
                    title: "Units",
                    value: Utils.formatNumber(tranxUnits),
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
                    value: tds.round().toString(),
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
            ),
          ],
        ),
      ),
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

  Map reportActionData = {
    "Download PDF Report ": ["", "", "assets/pdf.png"],
    "Email Report": ["", null, "assets/email.png"],
    /*"Download Excel Report": ["", "", "assets/excel.png"],*/
  };

  Widget reportActionContainers() {
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
                      "${ApiConfig.apiUrl}/investor/download/downloadDatewiseTransactionPdf?key=${ApiConfig.apiKey}&client_name=$clientName&user_id=$user_id&type=pdf&transaction_type=Date&purchase_type=All&start_date=$startDate&end_date=$endDate";

                  http.Response response = await http.post(Uri.parse(url));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  String resUrl = data['msg'];
                  print("download $url");
                  rpDownloadFile(url: resUrl, index: index);
                  Get.back();
                } else if (index == 1) {
                  String url =
                      "${ApiConfig.apiUrl}/investor/download/downloadDatewiseTransactionPdf?key=${ApiConfig.apiKey}&client_name=$clientName&user_id=$user_id&type=email&transaction_type=Date&purchase_type=All&start_date=$startDate&end_date=$endDate";

                  http.Response response = await http.post(Uri.parse(url));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  String resUrl = data['msg'];
                  print("email $url");
                  rpDownloadFile(url: resUrl, index: index);
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
                Map data = await ReportApi.downloadDatewiseTransactionPdf(
                    user_id: user_id,
                    client_name: clientName,
                    type: type,
                    startDate: startDate,
                    endDate: endDate);
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
                title: "Purchase",
                value:
                    "$rupee ${Utils.formatNumber(purchase, isAmount: false)}",
                titleStyle: AppFonts.f40013.copyWith(
                  color: AppColors.lineColor,
                ),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title: "Redemption",
                value:
                    "$rupee ${Utils.formatNumber(redemption, isAmount: false)}",
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
                title: "Switch In",
                value: "$rupee ${Utils.formatNumber(swithIn, isAmount: false)}",
                titleStyle: AppFonts.f40013.copyWith(
                  color: AppColors.lineColor,
                ),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title: "Switch Out",
                value:
                    "$rupee ${Utils.formatNumber(switchOut, isAmount: false)}",
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
                title: "Dividend Payout",
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
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Transfer",
                value:
                    "$rupee ${Utils.formatNumber(transfer, isAmount: false)}",
                titleStyle: AppFonts.f40013.copyWith(
                  color: AppColors.lineColor,
                ),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  showTransactionTypeBottomSheet() {
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
                  BottomSheetTitle(title: "Select Transaction Type"),
                  Divider(height: 0),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            itemCount: transactionTypeList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              String transType = transactionTypeList[index];
                              return GestureDetector(
                                onTap: () {
                                  selectedTransactionType = transType;
                                  tran_list = [];
                                  Get.back();
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: selectedTransactionType,
                                      value: transactionTypeList[index],
                                      onChanged: (val) {
                                        selectedTransactionType = transType;
                                        tran_list = [];
                                        Get.back();
                                        setState(() {});
                                      },
                                    ),
                                    Expanded(
                                      child: Text(
                                        transactionTypeList[index],
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
        tran_list = [];
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
}
