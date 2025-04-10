import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'package:mymfbox2_0/api/ReportApi.dart';

import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DayChange.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';

import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import '../../../pojo/OnlineTransactionRestrictionPojo.dart';
import '../../../pojo/familyCurrentPortfolioPojo.dart';
import '../../../pojo/familyCurrentPortfolioPojo.dart';
import '../../../rp_widgets/BottomSheetTitle.dart';
import '../../../rp_widgets/NoData.dart';
import '../../../rp_widgets/PlainButton.dart';
import '../../../rp_widgets/RpButton.dart';
import '../../../rp_widgets/RpListTile.dart';
import '../../../utils/AppColors.dart';
import 'SipSchemeSummary.dart';

class FamilyCurrentPortfolio extends StatefulWidget {
  const FamilyCurrentPortfolio({Key? key}) : super(key: key);

  @override
  State<FamilyCurrentPortfolio> createState() => _FamilyCurrentPortfolioState();
}

class _FamilyCurrentPortfolioState extends State<FamilyCurrentPortfolio> {
  late double devHeight, devWidth;
  int user_id = GetStorage().read("family_id");
  String client_name = GetStorage().read("client_name");
  String user_name = GetStorage().read("user_name") ?? '';
  String user_mobile = GetStorage().read("user_mobile") ?? "";
  String user_email = GetStorage().read("user_email") ?? "";
  num oneDayChange = 0;
  Iterable keys = GetStorage().getKeys();
  String selectedDate = " ";

  Map folioMap = {
    "All Folios": "All",
    "Live Folio": "Live",
    "Non segregated Folios": "NonSegregated",
    "MF bought in our code": "MF Without other ARN",
    "MF bought from others": "MF bought from others",
  };
  String selectedFolioType = "Live";

  ExpansionTileController controller1 = ExpansionTileController();
  ExpansionTileController controller2 = ExpansionTileController();

  String selectedSort = "";

  int currentIndex = 0;

  bool isLoading = true;

  MfSummary mfSummary = MfSummary();
  SipSummary sipSummary = SipSummary();
  List<FamilyCurrentPortfolioPojo> schemeList = [];
  List<MfSchemeSummary> mfSchemeSummaryList = [];
  List<SipSchemeSummaryPojo> sipSchemeSummaryList = [];

  String formatDate(DateTime date) {
    String day =
        date.day.toString().padLeft(2, '0'); // Ensure two digits for day
    String month =
        date.month.toString().padLeft(2, '0'); // Ensure two digits for month
    String year = date.year.toString(); // Year
    return '$day-$month-$year'; // Return formatted date
  }

  Future<void> getfamilyCurrentPortfolio() async {
    if (schemeList.isNotEmpty) {
      print("Scheme list is not empty, skipping API call.");
      return;
    }
    String formattedDate = formatDate(selectedFolioDate);
    Map data = await ReportApi.familyCurrentPortfolio(
      user_id: user_id,
      client_name: client_name,
      folio_type: selectedFolioType,
      selected_date: formattedDate,
    );

    if (data['status'] != 200) {
      print("Error: ${data['msg']}");
      Utils.showError(context, data['msg']);
      return;
    }
    mfSummary = MfSummary.fromJson(data['mf_summary']);
    sipSummary = SipSummary.fromJson(data['sip_summary']);
    List mflist = data['mf_scheme_summary'];
    List siplist = data['sip_scheme_summary'];
    convertListToObj(mflist, siplist);

    //
  }

  void convertListToObj(List mflist, List siplist) {
    mfSchemeSummaryList =
        mflist.map((item) => MfSchemeSummary.fromJson(item)).toList();
    sipSchemeSummaryList =
        siplist.map((item) => SipSchemeSummaryPojo.fromJson(item)).toList();
  }

  Future getDatas() async {
    isLoading = true;
    await getfamilyCurrentPortfolio();
    isLoading = false;
    return 0;
  }

  @override
  void initState() {
    // implement initState
    super.initState();
    // numberController = TextEditingController(text: user_mobile);
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
            appBar: rpAppBar(
                title: "Family Current Portfolio",
                bgColor: Config.appTheme.themeColor,
                actions: [
                  // if (((keys.contains("adminAsInvestor")) ||
                  //     (keys.contains("adminAsFamily")) != false))
                  //   IconButton(
                  //     onPressed: () {
                  //       // whatsappshare();
                  //     },
                  //     icon: Image.asset("assets/whatsapp.png", width: 32),
                  //   ),
                  GestureDetector(
                      onTap: () {
                        showReportActionBottomSheet();
                      },
                      child: Icon(Icons.pending_outlined)),
                  SizedBox(width: 32),
                ],
                foregroundColor: Colors.white),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  mfSummaryCard(mfSummary),
                  Container(
                    // height: devHeight*0.133,
                    color: Config.appTheme.themeColor,
                    child: sipSummaryCard(sipSummary),
                  ),
                  SizedBox(height: 10),
                  (isLoading)
                      ? Utils.shimmerWidget(devHeight*0.06,
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 0))
                      :middleArea(mfSchemeSummaryList),
                  SizedBox(height: 16),
                  (isLoading)
                      ? Utils.shimmerWidget(devHeight,
                          margin: EdgeInsets.fromLTRB(16, 0, 16, 0))
                      : investorCard(mfSchemeSummaryList, selectedInvestorName),
                  ..._buildSchemeListForSelectedInvestor(
                      mfSchemeSummaryList, selectedInvestorName),
                  SizedBox(height: 16),
                ],
              ),
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
    },
    {
      'title': "Excel Report",
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
                EasyLoading.show();
                Map data = await ReportApi.downloadFamilyCurrentPortfolio(
                    user_id: user_id,
                    client_name: client_name,
                    type: type,
                    folio_type: selectedFolioType);
                if (data['status'] != 200) {
                  Utils.showError(context, data['msg']);
                  return;
                }
                EasyLoading.dismiss();
                Get.back();
                if (type == ReportType.DOWNLOAD) {
                  rpDownloadFile(
                      url: data['msg'], context: context, index: index);
                }
                if (type == ReportType.EMAIL) {
                  Fluttertoast.showToast(
                      msg: data['msg'],
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor:
                      Config.appTheme.themeColor,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
                if (type == ReportType.EXCEL) {
                  rpDownloadExcelFile(
                      url: data['msg'], context: context, index: index);
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

  List<Widget> _buildSchemeListForSelectedInvestor(
      List<MfSchemeSummary> mfSchemeSummaryList, String selectedInvestorName) {
    final mfSchemeSummary = mfSchemeSummaryList.firstWhere(
      (element) => element.investorName == selectedInvestorName,
      orElse: () => MfSchemeSummary(),
    );

    final schemeList = mfSchemeSummary.schemeList ?? [];
    if (schemeList.isEmpty) {
      return [NoData(text: 'No data Available')];
    }
    return schemeList.map((scheme) {
      return categoryCard(scheme);
    }).toList();
  }

  Widget categoryCard(SchemeList scheme) {
    final schemeAmfi = scheme.schemeAmfi ?? '';
    final schemeAmfiCode = scheme.schemeAmfiCode ?? '';
    final schemeAmfiShortName = scheme.schemeAmfiShortName ?? '';
    final schemeAmc = scheme.schemeAmc ?? '';
    final schemeAmcCode = scheme.schemeAmcCode ?? '';
    final schemeAmcLogo = scheme.schemeAmcLogo ?? '';
    final schemeBroadCategory = scheme.schemeBroadCategory ?? '';
    final schemeCategory = scheme.schemeCategory ?? '';
    final folio = scheme.folio ?? '';
    final brokerCode = scheme.brokerCode ?? '';
    final currCost = scheme.currCost ?? 0;
    final currValue = scheme.currValue ?? 0;
    final units = scheme.units ?? 0;
    final unrealisedProfitLoss = scheme.unrealisedProfitLoss ?? 0;
    final realisedProfitLoss = scheme.realisedProfitLoss ?? 0;
    final realisedGainLoss = scheme.realisedGainLoss ?? 0;
    final dayChangeValue = scheme.dayChangeValue ?? 0;
    final dayChangePercentage = scheme.dayChangePercentage ?? 0;
    final absoluteReturn = scheme.absoluteReturn ?? 0;
    final xirr = scheme.xirr ?? 0;
    final isSip = scheme.isSip ?? false;

    return InkWell(
      onTap: () {
        // Get.to(FamilyPortfolioAssetCategoryAllocationDetails(
        //     schemeList: schemeList, folioType: selectedFolioType,categoryName:categoryName));
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                // Get.to(SchemeInfo(
                //     schemeName: encodedName,
                //     schemeLogo: scheme.schemeAmcLogo,
                //     schemeShortName: encodedSchemeName));
              },
              child: RpListTile(
                showArrow: false,
                subTitle: Text("Folio : $folio",
                    style: f40012.copyWith(color: Colors.black)),
                leading: Image.network(
                  schemeAmcLogo ?? "",
                  height: 32,
                ),
                title: Text(
                  schemeAmfiShortName,
                  style: AppFonts.f50014Grey.copyWith(color: Colors.blue),
                  maxLines: 3,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  rpRow(
                      lhead: "Units",
                      lSubHead: Utils.formatNumber(units),
                      rhead: "Current Cost",
                      rSubHead: "$rupee ${Utils.formatNumber(currCost)}",
                      chead: "Current Value",
                      cSubHead: "$rupee ${Utils.formatNumber(currValue)}"),
                  SizedBox(
                    height: 16,
                  ),
                  rpRow(
                      lhead: "Unrealised Gain",
                      lSubHead:
                          "$rupee ${Utils.formatNumber(unrealisedProfitLoss)}",
                      rhead: "Realised Gain",
                      rSubHead:
                          "$rupee ${Utils.formatNumber(realisedProfitLoss)}",
                      chead: "Abs Rtn (%)",
                      cSubHead: Utils.formatNumber(absoluteReturn)),
                  SizedBox(
                    height: 16,
                  ),
                  rpRow(
                      lhead: "XIRR (%)",
                      lSubHead: Utils.formatNumber(xirr),
                      rhead: "",
                      rSubHead: '',
                      titleStyle: AppFonts.f40014,
                      valueStyle: AppFonts.f50016Grey,
                      chead: "",
                      cSubHead: "")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String selectedInvestorName = '';

  Widget investorCard(
      List<MfSchemeSummary> mfSchSumList, String selectedInvestorName) {
    final mfSchemeSummary = mfSchSumList.firstWhere(
      (element) => element.investorName == selectedInvestorName,
      orElse: () => MfSchemeSummary(),
    );

    final investorName = mfSchemeSummary.investorName ?? '';
    final familyStatus = mfSchemeSummary.familyStatus ?? '';
    final pan = mfSchemeSummary.pan ?? '';
    final salutation = mfSchemeSummary.salutation ?? '';
    final currentCost = mfSchemeSummary.currentCost ?? 0;
    final currentValue = mfSchemeSummary.currentValue ?? 0;
    final unrealisedGain = mfSchemeSummary.unrealisedGain ?? 0;
    final realisedGain = mfSchemeSummary.realisedGain ?? 0;
    final absRtn = mfSchemeSummary.absRtn ?? 0.0;
    final xirr = mfSchemeSummary.xirr ?? 0.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: devWidth,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Expanded(
              //       child: Text("$salutation $investorName",
              //           style: AppFonts.f50014Black.copyWith(color: Colors.white)),
              //     ),
              //   ],
              // ),
              // // SizedBox(height: 8),
              // if(familyStatus.isEmpty  || familyStatus != null)
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       child: Text("$familyStatus",
              //           style: AppFonts.f50014Black.copyWith(color: Colors.white,fontSize: 12)),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ColumnText(
                    title: "Current Cost",
                    value: "$rupee ${Utils.formatNumber(currentCost)}",
                    valueStyle: AppFonts.f40013.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  ColumnText(
                    title: "Current Value",
                    value: "$rupee ${Utils.formatNumber(currentValue)}",
                    alignment: CrossAxisAlignment.center,
                    valueStyle: AppFonts.f40013.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  ColumnText(
                    title: "Unrealised Gain",
                    value: "$rupee ${Utils.formatNumber(unrealisedGain)}",
                    alignment: CrossAxisAlignment.end,
                    valueStyle: AppFonts.f40013.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ColumnText(
                    title: "Realised Gain",
                    value: "$rupee ${Utils.formatNumber(realisedGain)}",
                    valueStyle: AppFonts.f40013.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    alignment: CrossAxisAlignment.start,
                  ),
                  ColumnText(
                    title: "Absolute Return",
                    value: "${absRtn.toStringAsFixed(2)} $percentage",
                    valueStyle: AppFonts.f40013.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    alignment: CrossAxisAlignment.center,
                  ),
                  ColumnText(
                    title: "XIRR",
                    value: "${Utils.formatNumber(xirr)} $percentage",
                    valueStyle: AppFonts.f40013.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    alignment: CrossAxisAlignment.end,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget middleArea(List<MfSchemeSummary> mfSchSumList) {
    if (selectedInvestorName.isEmpty && mfSchSumList.isNotEmpty) {
      selectedInvestorName = mfSchSumList.first.investorName ?? '';
    }
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 16, right: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: mfSchSumList.length ?? 0,
        itemBuilder: (context, index) {
          final category = mfSchSumList[index];
          String broadCategory = category.investorName ?? '';
          String status = category.familyStatus ?? '';
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedInvestorName = broadCategory;
              });
            },
            child: getButton(
              text: broadCategory,
              status: status,
              type: selectedInvestorName == broadCategory
                  ? ButtonType.filled
                  : ButtonType.plain,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(width: 16),
      ),
    );
  }

  Widget getButton(
      {required String text,
      required ButtonType type,
      required String status}) {
    EdgeInsets padding = EdgeInsets.symmetric(horizontal: 16);
    if (type == ButtonType.plain) {
      return GestureDetector(
        onTap: () {
          selectedInvestorName = text;
          selectedSort = "";
          setState(() {});
        },
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
              border: Border.all(color: Config.appTheme.themeColor),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: AppFonts.f50014Black.copyWith(
                        color: Config.appTheme.themeColor, fontSize: 14),
                  ),
                ],
              ),
              if (status != null && status.isNotEmpty)
                Row(
                  children: [
                    Text(
                      "($status)",
                      textAlign: TextAlign.center,
                      style: AppFonts.f50014Black.copyWith(
                          color: Config.appTheme.themeColor, fontSize: 10),
                    ),
                  ],
                ),
            ],
          ),
        ),
      );
    } else {
      return Container(
          padding: padding,
          decoration: BoxDecoration(
              color: Config.appTheme.themeColor,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: AppFonts.f50014Black
                        .copyWith(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
              if (status != null && status.isNotEmpty)
                Row(
                  children: [
                    Text(
                      "($status)",
                      textAlign: TextAlign.center,
                      style: AppFonts.f50014Black
                          .copyWith(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
            ],
          ));
    }
  }

  getKeyByValue(Map map, String value) {
    return map.keys.firstWhere((element) => map[element] == value);
  }

  DateTime selectedFolioDate = DateTime.now();

  showCustomizedFilter() {
    Duration diff = selectedFolioDate.difference(DateTime.now());
    bool isToday = (diff.inDays == 0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return Container(
              height: devHeight * 0.85,
              decoration: BoxDecoration(
                  color: Config.appTheme.mainBgColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: SingleChildScrollView(
                child:  ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: devHeight * 0.85, // Adjust to allow scrolling
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("View Customized Portfolio",
                                style: AppFonts.f40016
                                    .copyWith(fontWeight: FontWeight.w500)),
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(Icons.close),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            controller: controller1,
                            onExpansionChanged: (val) {
                              if (val) controller2.collapse();
                            },
                            title: Text("Folio Type", style: AppFonts.f50014Black),
                            tilePadding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "${getKeyByValue(folioMap, selectedFolioType)}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Config.appTheme.themeColor)),
                                DottedLine(),
                              ],
                            ),
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: folioMap.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      selectedFolioType =
                                          folioMap.values.elementAt(index);
                                      bottomState(() {});
                                    },
                                    child: Row(
                                      children: [
                                        Radio(
                                          value: folioMap.values.elementAt(index),
                                          groupValue: selectedFolioType,
                                          onChanged: (value) {
                                            selectedFolioType =
                                                folioMap.values.elementAt(index);
                                            bottomState(() {});
                                          },
                                        ),
                                        Text("${folioMap.keys.elementAt(index)}"),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              controller: controller2,
                              onExpansionChanged: (val) {
                                if (val) controller1.collapse();
                              },
                              title: Text("Portfolio Date",
                                  style: AppFonts.f50014Black),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      (isToday)
                                          ? "Today"
                                          : selectedFolioDate
                                              .toString()
                                              .split(" ")[0],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: Config.appTheme.themeColor)),
                                  DottedLine(),
                                ],
                              ),
                              children: [
                                InkWell(
                                  onTap: () {
                                    isToday = true;
                                    selectedFolioDate = DateTime.now();
                                    bottomState(() {});
                                  },
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: true,
                                        groupValue: isToday,
                                        onChanged: (value) {
                                          isToday = true;
                                          selectedFolioDate = DateTime.now();
                                          bottomState(() {});
                                        },
                                      ),
                                      Text("Today"),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    isToday = false;
                                    bottomState(() {});
                                  },
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: false,
                                        groupValue: isToday,
                                        onChanged: (value) {
                                          isToday = false;
                                          bottomState(() {});
                                        },
                                      ),
                                      Text("Select Specific Date"),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: !isToday,
                                  child: SizedBox(
                                    height: 200,
                                    child: ScrollDatePicker(
                                      selectedDate: selectedFolioDate,
                                      onDateTimeChanged: (value) {
                                        selectedFolioDate = value;
                                        bottomState(() {});
                                      },
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ),
                      Spacer(),
                      Container(
                          height: 70,
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                RpButton(
                                  isFilled: false,
                                  onTap: () => Get.back(),
                                ),
                                RpButton(
                                  isFilled: true,
                                  onTap: () {
                                    schemeList = [];
                                    Get.back();
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  OnlineTransactionRestrictionPojo userData =
      OnlineTransactionRestrictionPojo();
  bool isOpen = false;

  String date = "";

  Widget mfSummaryCard(MfSummary mf) {
    String value = Utils.formatNumber(mf.totalCurrValue ?? 0);
    String cost = Utils.formatNumber(mf.totalCurrCost ?? 0);
    String unrealgain = Utils.formatNumber(mf.totalUnrealisedGain ?? 0);
    String regain = Utils.formatNumber(mf.totalRealisedGain ?? 0);
    String AbsRtn = Utils.formatNumber(mf.totalAbsRtn ?? 0);
    String totalDivReinv = Utils.formatNumber(mf.totalDivReinv ?? 0);
    String totalDivPaidt = Utils.formatNumber(mf.totalDivPaid ?? 0);
    num xirr = mf.totalXirr ?? 0.0;

    date = Utils.getFormattedDate();

    return Container(
        color: Config.appTheme.themeColor,
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
          decoration: BoxDecoration(
              color: Config.appTheme.overlay85,
              borderRadius: BorderRadius.circular(10)),
          child: (isLoading)
              ? Utils.shimmerWidget(devHeight * 0.243, margin: EdgeInsets.zero)
              : Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                // ${Utils.getFormattedDate(date: selectedFolioDate)}
                                "Current Value",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: AppColors.readableGrey,
                                )),
                            InkWell(
                                onTap: () {
                                  showCustomizedFilter();
                                },
                                child: Icon(Icons.more_vert))
                          ],
                        ),
                        // SizedBox(height: 8),
                        Text(
                          "$rupee $value",
                          style: AppFonts.f70024
                              .copyWith(color: Config.appTheme.themeColor),
                        ),
                        // if (userData.oneDayChange == 1 ||
                        //     ((keys.contains("adminAsInvestor")) ||
                        //         (keys.contains("adminAsFamily")) != false))
                        //   DayChange(
                        //       change_value: mf.dayChangeValue ?? 0,
                        //       percentage: mf.dayChangePercentage ?? 0),
                        SizedBox(height: 5),
                        DottedLine(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ColumnText(
                                  title: "Current Cost",
                                  value: "$rupee $cost",
                                  alignment: CrossAxisAlignment.start),
                              ColumnText(
                                  title: "Unrealised Gain",
                                  value: "$rupee $unrealgain",
                                  alignment: CrossAxisAlignment.center),
                              ColumnText(
                                title: "Realised Gain",
                                value: "$rupee $regain",
                                alignment: CrossAxisAlignment.end,
                              ),
                            ]),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ColumnText(
                                title: "Abs. Return",
                                value: " $AbsRtn $percentage",
                                alignment: CrossAxisAlignment.start),
                            ColumnText(
                                title: "XIRR",
                                value: "$xirr $percentage",
                                alignment: CrossAxisAlignment.end,
                                valueStyle: AppFonts.f50014Black.copyWith(
                                    color: (xirr > 0)
                                        ? Config.appTheme.defaultProfit
                                        : Config.appTheme.defaultLoss)),
                          ],
                        ),
                      ]),
                ),
        ));
  }

  Widget sipSummaryCard(SipSummary sip) {
    String amount = Utils.formatNumber(sip.sipAmount);

    return InkWell(
      onTap: () {
        Get.to(
            () => SipSchemeSummary(sipSchemeSummaryList: sipSchemeSummaryList));
      },
      child: (isLoading)
          ? Utils.shimmerWidget(devHeight * 0.12,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16))
          : Container(
              height: devHeight * 0.12,
              width: devWidth,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
              decoration: BoxDecoration(
                  color: Config.appTheme.overlay85,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Family SIP Summary", style: AppFonts.f40013),
                      Icon(Icons.arrow_forward,
                          color: Config.appTheme.themeColor),
                    ],
                  ),
                  Text(
                    "$rupee $amount",
                    style: AppFonts.f70024
                        .copyWith(color: Config.appTheme.themeColor),
                  ),
                  Text(
                    "SIP Grand Total",
                    style: TextStyle(
                        color: AppColors.readableGrey,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
    );
  }

  Widget rpRow({
    required String lhead,
    required String lSubHead,
    required String rhead,
    required String rSubHead,
    required String chead,
    required String cSubHead,
    final TextStyle? valueStyle,
    final TextStyle? titleStyle,
  }) {
    return Row(
      children: [
        Expanded(
            child: ColumnText(
                title: lhead,
                value: lSubHead,
                alignment: CrossAxisAlignment.start)),
        Expanded(
            child: ColumnText(
          title: rhead,
          value: rSubHead,
          alignment: CrossAxisAlignment.center,
          valueStyle: valueStyle,
          titleStyle: titleStyle,
        )),
        Expanded(
            child: ColumnText(
                title: chead,
                value: cSubHead,
                alignment: CrossAxisAlignment.end)),
      ],
    );
  }
}
