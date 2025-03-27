import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/api/ReportApi.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/NoData.dart';
import 'package:mymfbox2_0/rp_widgets/RpChip.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class FamilyDateWiseTransactionReport extends StatefulWidget {
  const FamilyDateWiseTransactionReport({super.key});

  @override
  State<FamilyDateWiseTransactionReport> createState() =>
      _FamilyDateWiseTransactionReportState();
}

class _FamilyDateWiseTransactionReportState
    extends State<FamilyDateWiseTransactionReport> {
  late double devWidth, devHeight;
  String selectedTransactionType = "";
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  String startDate = DateFormat('dd-MM-yyyy')
      .format(DateTime.now().subtract(Duration(days: 30)));
  String endDate = DateFormat('dd-MM-yyyy')
      .format(DateTime.now().subtract(Duration(days: 1)));
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
  List masterList = [];
  List familyList = [];
  int userId = GetStorage().read('family_id');
  String clientName = GetStorage().read("client_name");

  Future getTransanctions() async {
    if (masterList.isNotEmpty) return 0;

    Map data = await ReportApi.getTrasanctions(
      user_id: userId,
      client_name: clientName,
      financial_year: "",
      transaction_type: "Date",
      purchase_type: selectedTransactionType,
      start_date: startDate,
      end_date: endDate,
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    masterList = data['master_list'];
    familyList = masterList[0]['family_list'];

    return 0;
  }

  bool isLoading = true;

  Future getDatas() async {
    isLoading = true;
    await getTransanctions();
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
          return SideBar(
            child: Scaffold(
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
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back),
                          SizedBox(width: 5),
                          Text(
                            "Family Date Wise Transaction...",
                            style: AppFonts.f50014Black
                                .copyWith(fontSize: 18, color: Colors.white),
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
  Map reportActionData = {
    "Download PDF Report ": ["", "", "assets/pdf.png"],
    "Download Excel Report": ["", "", "assets/excel.png"],
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
                      "${ApiConfig.apiUrl}/admin/family/downloadFamilyPortfolioTransactionPdf?key=${ApiConfig.apiKey}&client_name=$clientName&user_id=$userId&financial_year=&transaction_type=Date&purchase_type=$selectedTransactionType&start_date=$startDate&end_date=$endDate";

                  http.Response response = await http.post(Uri.parse(url));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  String resUrl = data['msg'];
                  print("download $url");
                  rpDownloadFile(url: resUrl, context: context, index: index);
                  Get.back();
                } else if (index == 1) {
                  String url =
                      "${ApiConfig.apiUrl}/admin/family/downloadFamilyPortfolioTransactionExcel?key=${ApiConfig.apiKey}&user_id=$userId&client_name=$clientName"
                      "&financial_year=&start_date=$startDate&end_date=$endDate&report_type=Date&purchase_type=$selectedTransactionType";
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
                          user_id: userId,
                          client_name: clientName,
                          transaction_type: 'Date',
                          start_date: startDate,
                          end_date: endDate,
                          purchase_type: selectedTransactionType,
                          financial_year: '');
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
                          user_id: userId,
                          client_name: clientName,
                          report_type: 'Date',
                          financial_year: selectedTransactionType,
                          start_date: startDate,
                          end_date: endDate,
                          purchase_type: selectedTransactionType);
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
              : //blackCard(),
              listCard(),
        ],
      ),
    );
  }

  bool isOpen = false;

  Widget listCard() {
    if (familyList.isEmpty) return NoData();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: familyList.length,
      itemBuilder: (context, index) {
        Map mainItem = familyList[index];

        return familyExpansionTile(mainItem, index);
      },
    );
  }

  Widget familyExpansionTile(Map mainItem, int index) {
    String name = mainItem['name'] ?? "";
    num trnxCount = mainItem['investor_transaction_count'];
    List schemeList = mainItem['list'] ?? [];

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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: AppFonts.f50014Black),
                        Text(
                          "$trnxCount Transacted Funds",
                          style: AppFonts.f50012,
                        ),
                      ],
                    ),
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
    num tranxAmount = scheme['tranx_amount'];
    num transNav = scheme['tranx_nav'];
    num tranxUnits = scheme['tranx_units'];

    String dateStr = scheme['tranx_date'] ?? " ";
    String trnxType = scheme['tranx_type'] ?? " ";

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
                    title: "${scheme['scheme']}",
                    value: "Folio : ${scheme['folio_no']}",
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
                Text(dateStr, style: AppFonts.f50014Theme),
                RpChip(label: trnxType)
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnText(
                  title: "Amount",
                  value: "$rupee ${Utils.formatNumber(tranxAmount.round())}",
                ),
                ColumnText(
                  title: "NAV",
                  value: "$transNav",
                  alignment: CrossAxisAlignment.center,
                ),
                ColumnText(
                  title: "Units",
                  value: Utils.formatNumber(tranxUnits),
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
                                  masterList = [];
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
                                        masterList = [];
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
        masterList = [];
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
