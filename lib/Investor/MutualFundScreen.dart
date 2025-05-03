import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/Investor/FundDetails.dart';
import 'package:mymfbox2_0/Investor/PortfolioAnalysis.dart';
import 'package:mymfbox2_0/Investor/sipPortfolioSummary/SipPortfolioSummary.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/api/ReportApi.dart';
import 'package:mymfbox2_0/pojo/MfSchemeSummaryPojo.dart';
import 'package:mymfbox2_0/pojo/MfSummaryPojo.dart';
import 'package:mymfbox2_0/research/SchemeInfo.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DayChange.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../advisor/Investor/AllInvestor.dart';
import '../pojo/OnlineTransactionRestrictionPojo.dart';
import '../rp_widgets/CalculateButton.dart';
import '../rp_widgets/RpButton.dart';
import '../rp_widgets/RpListTile.dart';

class MutualFundScreen extends StatefulWidget {
  const MutualFundScreen({Key? key}) : super(key: key);

  @override
  State<MutualFundScreen> createState() => _MutualFundScreenState();
}

class _MutualFundScreenState extends State<MutualFundScreen> {
  late double devHeight, devWidth;
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  String user_name = GetStorage().read("user_name");
  String user_mobile = GetStorage().read("user_mobile") ?? "";
  String user_email = GetStorage().read("user_email") ?? "";
  num oneDayChange = 0;
  Iterable keys = GetStorage().getKeys();
  String selectedDate = " ";

  Map folioMap = {
    "All Folios": "All",
    "Live Folio": "Live",
    "Portfolio with Live Transactions": "",
    "Non segregated Folios": "NonSegregated",
    "MF bought in our code": "MF Without other ARN",
    "MF bought from others": "MF bought from others",
    "NRO Folios": " ",
  };
  String selectedFolioType = "Live";
  DateTime selectedFolioDate = DateTime.now();
  ExpansionTileController controller1 = ExpansionTileController();
  ExpansionTileController controller2 = ExpansionTileController();

  Map sipSummary = {};
  MfSummaryPojo mfSummary = MfSummaryPojo();
  List<MfSchemeSummaryPojo> schemeList = [];

  List sortOptions = [
    "Current Value",
    "Current Cost",
    "A to Z",
    "XIRR",
    "Absolute Return",
    "Gain/Loss"
  ];
  String selectedSort = "";

  Map viewOptions = {
    "XIRR": 'xirr',
    "Gain/Loss": 'realisedGainLoss',
    "Abs Return": 'absolute_return'
  };
  String selectedView = "XIRR";

  int currentIndex = 0;

  bool isLoading = true;

  Future getMutualFundPortfolio() async {
    if (schemeList.isNotEmpty) return 0;

    Map data = await InvestorApi.getMutualFundPortfolio(
      user_id: user_id,
      client_name: client_name,
      folio_type: selectedFolioType,
      selected_date: selectedFolioDate,
      broker_code: "",
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }

    Map<String, dynamic> map = data['mf_summary'];
    sipSummary = data['sip_summary'];
    List list = data['mf_scheme_summary'];

    mfSummary = MfSummaryPojo.fromJson(map);
    convertListToObj(list);
    return 0;
  }

  String shareURl = "";

  Future getWhatsappShareLink() async {
    Map data = await InvestorApi.getWhatsappShareLink(
        user_id: user_id, client_name: client_name);
    shareURl = data['msg'];
    print("share url $shareURl");
    return 0;
  }

  Map swpSummary = {};

  Future getSwpSummary() async {
    Map data = await InvestorApi.getStpSwpSummary(
        user_id: user_id, client_name: client_name, summary_type: 'SWP');

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    swpSummary = data['summary'];
  }

  Map stpSummary = {};

  Future getStpSummary() async {
    Map data = await InvestorApi.getStpSwpSummary(
        user_id: user_id, client_name: client_name, summary_type: 'STP');

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    stpSummary = data['summary'];
  }

  convertListToObj(List list) {
    list.forEach((element) {
      schemeList.add(MfSchemeSummaryPojo.fromJson(element));
    });
  }

  List investorList = [];
  late Map<String, dynamic> datas;
  bool isFirst = true;
  OnlineTransactionRestrictionPojo userData =
      OnlineTransactionRestrictionPojo();

  Future getAllOnlineRestrictions() async {
    if (!isFirst) return 0;
    Map data = await InvestorApi.getOnlineRestrictionsByUserId(
      user_id: user_id,
      client_name: client_name,
    );

    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      return 0;
    }
    investorList = data['list'];
    datas = investorList[0];
    userData = OnlineTransactionRestrictionPojo.fromJson(datas);
    return 0;
  }

  applySort() {
    if (selectedSort == "Current Cost") {
      schemeList.sort(
        (a, b) => b.currCost!.compareTo(a.currCost!),
      );
    }
    if (selectedSort == "Current Value") {
      schemeList.sort(
        (a, b) => b.currValue!.compareTo(a.currValue!),
      );
    }
    if (selectedSort == "A to Z") {
      schemeList.sort(
        (a, b) => a.schemeAmfiShortName!.compareTo(b.schemeAmfiShortName!),
      );
    }
    if (selectedSort == "XIRR") {
      schemeList.sort(
        (a, b) => b.xirr!.compareTo(a.xirr!),
      );
    }
    if (selectedSort == "Absolute Return") {
      schemeList.sort(
        (a, b) => b.absoluteReturn!.compareTo(a.absoluteReturn!),
      );
    }
    if (selectedSort == "Gain/Loss") {
      schemeList.sort(
        (a, b) => b.unrealisedProfitLoss!.compareTo(a.unrealisedProfitLoss!),
      );
    }
  }

  Future getDatas() async {
    isLoading = true;
    await getMutualFundPortfolio();
    await getStpSummary();
    await getSwpSummary();
    await getAllOnlineRestrictions();
    isLoading = false;
    return 0;
  }

  @override
  void initState() {
    // implement initState
    super.initState();
    numberController = TextEditingController(text: user_mobile);
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
                title: "My Mutual Fund",
                bgColor: Config.appTheme.themeColor,
                actions: [
                  if (((keys.contains("adminAsInvestor")) ||
                      (keys.contains("adminAsFamily")) != false))
                    /*IconButton(
                      onPressed: () {
                        whatsappshare();
                      },
                      icon: Image.asset("assets/whatsapp.png", width: 32),
                    ),*/

                    InkWell(
                      onTap: () {
                        if (mfSummary.totalCurrValue != 0) {
                          whatsappshare();
                        } else {
                          Fluttertoast.showToast(
                              msg: "Member contains 0 value",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Config.appTheme.themeColor,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          // Get.back();
                        }
                      },
                      child: WhatsappIcon(
                        color: Colors.white,
                        height: 20.0,
                        width: 20.0,
                      ),
                    ),
                  SizedBox(width: 8),
                  GestureDetector(
                      onTap: () {
                        showReportActionBottomSheet();
                      },
                      child: Icon(Icons.pending_outlined)),
                  SizedBox(width: 32),
                ],
                foregroundColor: Colors.white),
            body: SideBar(
                child: Column(
                  children: [
                    mfSummaryCard(mfSummary),
                    Container(
                      color: Config.appTheme.themeColor,
                      margin: EdgeInsets.only(top: 0),
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          title: Text("View Systematic Details", style: AppFonts.f50014Black.copyWith(color: Colors.white)),
                          textColor: Colors.white,
                          iconColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          children: [
                            Container(
                              height: 125,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  SizedBox(width: 16),
                                  sipSummaryCard(),
                                  stpSummaryCard(),
                                  swpSummaryCard(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Row(
                        children: [
                          Text("${schemeList.length} Items", style: f40012),
                          Spacer(),
                          SortButton(onTap: () {
                            showSortFilter();
                          }),
                          /*SizedBox(width: 10),
                          SortButton(
                            onTap: () {
                              currentIndex++;
                              if (currentIndex > 2) currentIndex = 0;
                              selectedView =
                                  viewOptions.keys.elementAt(currentIndex);
                              setState(() {});
                            },
                            title: selectedView,
                          ),*/
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: schemeList.length,
                        itemBuilder: (context, index) {
                          return schemeCard(schemeList[index]);
                        },
                      ),
                    ),
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
      'title': "Download Summary Portfolio PDF",
      'img': "assets/pdf.png",
      'type': ReportType.DOWNLOAD,
    },
    {
      'title': "Download Transaction Portfolio PDF",
      'img': "assets/pdf.png",
      'type': ReportType.DOWNLOAD,
    },
    {
      'title': "Email Summary Portfolio Report",
      'img': "assets/email.png",
      'type': ReportType.EMAIL,
    },
    {
      'title': "Email Transaction Portfolio Report",
      'img': "assets/email.png",
      'type': ReportType.EMAIL,
    },
  ];

  Widget reportActionContainer() {
    String formattedDateForInvestment =
        DateFormat('dd-MM-yyyy').format(selectedFolioDate);
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
                if (type == ReportType.EMAIL) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return Container(
                        height: 250,
                        child: Column(
                          children: [
                            BottomSheetTitle(title: "Confirm"),
                            Container(
                              width: double.maxFinite,
                              margin: EdgeInsets.all(16),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Config.appTheme.themeColor)),
                              child: ColumnText(
                                title: "You are about to send the mail",
                                value: "Please check all the details carefully",
                                titleStyle: AppFonts.f50014Black,
                                valueStyle: AppFonts.f40013,
                              ),
                            ),
                            CalculateButton(
                                onPress: () async {
                                  Get.back();
                                  EasyLoading.show();
                                  Map data =
                                      await ReportApi.getInvestorSummaryPdf(
                                    email: user_email,
                                    user_id: user_id,
                                    user_mobile: user_mobile,
                                    type: type,
                                    client_name: client_name,
                                    folio_type: selectedFolioType,
                                    selected_date: formattedDateForInvestment,
                                    report_type: (title ==
                                            "Email Summary Portfolio Report")
                                        ? "Summary"
                                        : "Transaction",
                                  );
                                  if (data['status'] != 200) {
                                    Utils.showError(context, data['msg']);
                                    return;
                                  }
                                  EasyLoading.dismiss();
                                  Get.back();
                                  EasyLoading.showToast("${data['msg']}");
                                  /*showCupertinoDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('Success'),
                                content: Text("Mail sent successfully"),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      "Ok",
                                    ),
                                    onPressed: () async {
                                      Get.back();
                                    },
                                  )
                                ],
                              ));*/
                                  //Get.back();
                                  setState(() {});
                                },
                                text: "Email Report"),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  EasyLoading.show();
                  Map data = await ReportApi.getInvestorSummaryPdf(
                    email: user_email,
                    user_id: user_id,
                    user_mobile: user_mobile,
                    type: type,
                    client_name: client_name,
                    folio_type: selectedFolioType,
                    selected_date: formattedDateForInvestment,
                    report_type: (title == "Download Summary Portfolio PDF")
                        ? "Summary"
                        : "Transaction",
                  );
                  if (data['status'] != 200) {
                    Utils.showError(context, data['msg']);
                    return;
                  }
                  EasyLoading.dismiss();
                  Get.back();

                  if (type == ReportType.DOWNLOAD) {
                    rpDownloadFile(url: data['msg'], index: index);
                  }
                }
              },
              child: RpListTile(
                title: SizedBox(
                  width: devWidth * 0.70,
                  child: Text(
                    textAlign: TextAlign.start,
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

  bool isOpen = false;

  showSortFilter() {
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
              height: devHeight * 0.5,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Sort & Filter",
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
                  Divider(),
                  ListView.builder(
                    itemCount: sortOptions.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      String title = sortOptions[index];
                      return InkWell(
                        onTap: () {
                          selectedSort = title;
                          applySort();
                          setState(() {});
                          Get.back();
                        },
                        child: Row(
                          children: [
                            Radio(
                              value: title,
                              groupValue: selectedSort,
                              onChanged: (value) {
                                selectedSort = title;
                                applySort();
                                setState(() {});
                                Get.back();
                              },
                            ),
                            Text(title)
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

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
              height: devHeight * 0.9,
              decoration: BoxDecoration(
                  color: Config.appTheme.mainBgColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: Column(
                children: [
                  // title & closeBtn
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
                  //to select folio type
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

                  //to select date
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
            );
          },
        );
      },
    );
  }

  Widget plainButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: devWidth * 0.15, vertical: 2),
      decoration: BoxDecoration(
          border: Border.all(color: Config.appTheme.buttonColor),
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(
          "Cancel",
          style:
              AppFonts.f50014Black.copyWith(color: Config.appTheme.buttonColor),
        ),
      ),
    );
  }

  Widget filledButton() {
    return InkWell(
      onTap: () {
        schemeList = [];
        Get.back();
        setState(() {});
      },
      child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: devWidth * 0.10, vertical: 25),
          decoration: BoxDecoration(
              color: Config.appTheme.buttonColor,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            "Apply",
            style: AppFonts.f50014Black.copyWith(color: Colors.white),
          ))),
    );
  }

  getKeyByValue(Map map, String value) {
    return map.keys.firstWhere((element) => map[element] == value);
  }

  String value = "";
  String cost = "",
      gain = "",
      regain = "",
      totalDivReinv = "",
      totalDivPaidt = "",
      absRtn = "",
      date = "";
  num xirr = 0;

  Widget mfSummaryCard(MfSummaryPojo pojo) {
    value = Utils.formatNumber(pojo.totalCurrValue);
    cost = Utils.formatNumber(pojo.totalCurrCost);
    gain = Utils.formatNumber(pojo.totalUnrealisedGain);
    regain = Utils.formatNumber(pojo.totalRealisedGain);
    totalDivReinv = Utils.formatNumber(pojo.totalDivReinv);
    totalDivPaidt = Utils.formatNumber(pojo.totalDivPaid);
    absRtn = Utils.formatNumber(pojo.total_abs_rtn);

    date = Utils.getFormattedDate();
    xirr = pojo.totalXirr ?? 0;

    print("selectedFolioDate $selectedFolioDate");
    return Container(
      color: Config.appTheme.themeColor,
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
        decoration: BoxDecoration(
            color: Config.appTheme.whiteOverlay,
            borderRadius: BorderRadius.circular(10)),
        child: (isLoading)
            ? Utils.shimmerWidget(220, margin: EdgeInsets.zero)
            : Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Current Value as on ${Utils.getFormattedDate(date: selectedFolioDate)}",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: AppColors.readableGrey,
                            )),
                        InkWell(
                            onTap: () {
                              showCustomizedFilter();
                            },
                            child: Icon(Icons.more_vert))
                      ],
                    ),
                   // SizedBox(height: 5),
                    Text(
                      "$rupee $value",
                      style: AppFonts.f70024
                          .copyWith(color: Config.appTheme.themeColor),
                    ),
                    if (userData.oneDayChange == 1 ||
                        ((keys.contains("adminAsInvestor")) ||
                            (keys.contains("adminAsFamily")) != false))
                      DayChange(
                          change_value: pojo.dayChangeValue ?? 0,
                          percentage: pojo.dayChangePercentage ?? 0),
                   // SizedBox(height: 5),
                    DottedLine(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ColumnText(title: "Cost", value: "$rupee $cost"),
                        ColumnText(
                            title: "Unrealised Gain",
                            value: "$rupee $gain",
                            alignment: CrossAxisAlignment.center),
                        ColumnText(
                            title: "XIRR (%)",
                            value: "$xirr",
                            alignment: CrossAxisAlignment.end,
                            valueStyle: AppFonts.f50014Black.copyWith(
                                color: (xirr > 0)
                                    ? Config.appTheme.defaultProfit
                                    : Config.appTheme.defaultLoss)),
                      ],
                    ),
                    DottedLine(),
                    Row(
                      children: [
                        ColumnText( title: 'Abs Rtn (%)', value: absRtn,),
                        Spacer(),
                        InkWell(
                          onTap: (){
                            Get.to(() => PortfolioAnalysis(
                              mfSummary: pojo,
                              oneDayChange: oneDayChange,
                            ));
                          },
                          child: Text("View Portfolio Analysis",
                              style: AppFonts.f50014Grey
                                  .copyWith(color: Config.appTheme.themeColor)),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget sipSummaryCard() {
    String value = Utils.formatNumber(sipSummary['sip_curr_value']);
    String amount = Utils.formatNumber(sipSummary['sip_amount']);

    return InkWell(
      onTap: () {
        Get.to(() => SipPortfolioSummary(
              selectType: 'SIP',
            ));
      },
      child: Container(
        width: 218,
        margin: EdgeInsets.fromLTRB(0, 0, 16, 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Config.appTheme.whiteOverlay,
            borderRadius: BorderRadius.circular(10)),
        child: (isLoading)
            ? Utils.shimmerWidget(100, margin: EdgeInsets.zero)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("SIP Portfolio Summary", style: AppFonts.f40013),
                      Icon(Icons.arrow_forward,
                          color: Config.appTheme.themeColor),
                    ],
                  ),
                  Text(
                    "$rupee $value",
                    style: AppFonts.f70024
                        .copyWith(color: Config.appTheme.themeColor),
                  ),
                  Row(
                    children: [
                      Text(
                        "Total SIP Amount : ",
                        style: TextStyle(
                            color: AppColors.readableGrey,
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                      ),
                      Text(
                        "$rupee $amount",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget stpSummaryCard() {
    String value = Utils.formatNumber(stpSummary['currentvalue_total']);
    String amount = Utils.formatNumber(stpSummary['currentcost_total']);

    return InkWell(
      onTap: () {
        Get.to(() => SipPortfolioSummary(
              selectType: 'STP',
            ));
      },
      child: Container(
        width: 218,
        margin: EdgeInsets.fromLTRB(0, 0, 16, 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Config.appTheme.whiteOverlay,
            borderRadius: BorderRadius.circular(10)),
        child: (isLoading)
            ? Utils.shimmerWidget(100, margin: EdgeInsets.zero)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("STP Portfolio Summary", style: AppFonts.f40013),
                      Icon(Icons.arrow_forward,
                          color: Config.appTheme.themeColor),
                    ],
                  ),
                  Text(
                    "$rupee $value",
                    style: AppFonts.f70024
                        .copyWith(color: Config.appTheme.themeColor),
                  ),
                  Row(
                    children: [
                      Text(
                        "Total STP Amount : ",
                        style: TextStyle(
                            color: AppColors.readableGrey,
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                      ),
                      Text(
                        "$rupee $amount",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget swpSummaryCard() {
    String value = Utils.formatNumber(swpSummary['currentcost_total']);
    String amount = Utils.formatNumber(swpSummary['currentvalue_total']);

    return InkWell(
      onTap: () {
        Get.to(() => SipPortfolioSummary(
              selectType: 'SWP',
            ));
      },
      child: Container(
        width: 220,
        margin: EdgeInsets.fromLTRB(0, 0, 16, 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Config.appTheme.whiteOverlay,
            borderRadius: BorderRadius.circular(10)),
        child: (isLoading)
            ? Utils.shimmerWidget(100, margin: EdgeInsets.zero)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("SWP Portfolio Summary", style: AppFonts.f40013),
                      Icon(Icons.arrow_forward,
                          color: Config.appTheme.themeColor),
                    ],
                  ),
                  Text(
                    "$rupee $value",
                    style: AppFonts.f70024
                        .copyWith(color: Config.appTheme.themeColor),
                  ),
                  Row(
                    children: [
                      Text(
                        "Total SWP Amount : ",
                        style: TextStyle(
                            color: AppColors.readableGrey,
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                      ),
                      Text(
                        "$rupee $amount",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget schemeCard(MfSchemeSummaryPojo scheme) {
    String cost = Utils.formatNumber(scheme.currCost);
    String value = Utils.formatNumber(scheme.currValue);
    Map data = scheme.toJson();
    String? amfi_scheme_name = scheme.schemeAmfi;
    String encodedName = amfi_scheme_name!.replaceAll("&", "%26");

    String? scheme_name = scheme.schemeAmfiShortName;
    String encodedSchemeName = scheme_name!.replaceAll("&", "%26");

    double? dayChange = scheme.dayChangeValue ?? 0.0;

    return InkWell(
      onTap: () {
        Get.to(() => FundDetails(
              schemeAmfiCode: "${scheme.schemeAmfiCode}",
              schemeName: "${scheme.schemeAmfi}",
              schemeCategory: "${scheme.schemeCategory}",
              schemeAmcLogo: "${scheme.schemeAmcLogo}",
              currCost: scheme.currCost ?? 0,
              currValue: scheme.currValue ?? 0,
              xirr: "${scheme.xirr}",
              folio: "${scheme.folio}",
              folioType: selectedFolioType,
            ));
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
                Get.to(SchemeInfo(
                    schemeName: encodedName,
                    schemeLogo: scheme.schemeAmcLogo,
                    schemeShortName: encodedSchemeName));
              },
              child: MFRpListTile(
                showArrow: true,
                subTitle: Row(
                  children: [
                    Text("Folio : ${scheme.folio}",
                        style: f40012.copyWith(color: Colors.black)),
                   SizedBox(width: 8,),
                   if(scheme.isManualEntry == true) Text("(${scheme.manualEntryVal})",
                        style: f40012.copyWith(color: Colors.blue)),
                  ],
                ),
                /*leading: Image.network(
                  scheme.schemeAmcLogo ?? "",
                  height: 32,
                ),*/
                title: Text(
                  "${scheme.schemeAmfiShortName}",
                  style: AppFonts.f50014Grey.copyWith(color: Colors.blue),
                  maxLines: 3,
                ),
              ),
            ),
            Column(
              //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 16,
                ),
                rpRow(
                    lhead: "Units",
                    lSubHead: Utils.formatNumber(scheme.units),
                    rhead: "Current Cost",
                    rSubHead: "$rupee $cost",
                    chead: "Current Value",
                    cSubHead: "$rupee $value"),
                SizedBox(
                  height: 16,
                ),
                rpRow(
                    lhead: "Unrealised Gain",
                    lSubHead:
                        "$rupee ${Utils.formatNumber(scheme.unrealisedProfitLoss)}",
                    rhead: "Realised Gain",
                    rSubHead:
                        "$rupee ${Utils.formatNumber(scheme.realisedProfitLoss)}",
                    chead: "Abs Rtn (%)",
                    cSubHead: Utils.formatNumber(scheme.absoluteReturn)),
                SizedBox(
                  height: 16,
                ),
                rpRow(
                    lhead: "XIRR (%)",
                    lSubHead: Utils.formatNumber(scheme.xirr),
                    lvalueStyle: AppFonts.f50016Grey.copyWith(
                        color: (scheme.xirr! < 0)
                            ? Config.appTheme.defaultLoss
                            : Config.appTheme.defaultProfit),

                    rhead: (userData.oneDayChange == 1 ||
                            ((keys.contains("adminAsInvestor")) ||
                                (keys.contains("adminAsFamily")) != false))
                        ? "1 Day Change"
                        : "",
                    rSubHead: (userData.oneDayChange == 1 ||
                            ((keys.contains("adminAsInvestor")) ||
                                (keys.contains("adminAsFamily")) != false))
                        ? "$rupee ${Utils.formatNumber(dayChange)}"
                        : " ",
                    titleStyle: AppFonts.f40014,
                    valueStyle: AppFonts.f50016Grey.copyWith(
                        color: (dayChange < 0)
                            ? Config.appTheme.defaultLoss
                            : Config.appTheme.defaultProfit),
                    chead: "",
                    cSubHead: "",
                    // rhead: '', rSubHead: ''
                )
              ],
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
    final TextStyle? lvalueStyle,
  }) {
    return Row(
      children: [
        Expanded(
            child: ColumnText(
                title: lhead,
                value: lSubHead,
                valueStyle: lvalueStyle,
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

  TextEditingController? numberController;

  Future<void> whatsappshare() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Mobile Number'),
          content: TextFormField(
              controller: numberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => numberController?.clear(),
              ))),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String? phoneNumber = numberController?.text;
                _sendMessage(phoneNumber!);
                Navigator.of(context).pop();
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

  // String formattedDateForInvestment = DateFormat('dd-MM-yyyy').format(selectedFolioDate);
  // EasyLoading.show();
  // Map pdfData = await ReportApi.getInvestorSummaryPdf(
  // email: user_email,
  // user_id: user_id,
  // user_mobile: user_mobile,
  // type: ReportType.DOWNLOAD,
  // client_name: client_name,
  // folio_type: selectedFolioType,
  // selected_date: formattedDateForInvestment, report_type: '',
  // );
  // EasyLoading.dismiss();
  //
  // if (pdfData['status'] != 200) {
  // Utils.showError(context, pdfData['msg']);
  // return;
  // }

  Future<void> _sendMessage(String phoneNumber) async {
    await getWhatsappShareLink();

    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    var websiteUrl = '''Dear ${user_name.toUpperCase()},
    
Greetings for the Day!

Below 👇 is the snapshot of your Mutual Fund Investments as on $formattedDate

📌 *Current Cost : RS.$cost*
📌 *Current Value : RS.$value*
📌 *Dividend Paid : RS.$totalDivPaidt*
📌 *Dividend Reinvestment : RS.$totalDivReinv*
📌 *Unrealized Gain/Loss : RS.$gain*
📌 *Realized Gain/Loss : RS.$regain*
📌 *XIRR(%) : $xirr*

To view the detailed portfolio, please login using the link below.
$shareURl


Please call us for more details.

Assuring you of our best services always!

*Thank you!*
${client_name.toUpperCase()}''';
    var whatsappUrl =
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(websiteUrl)}";
    if (await canLaunch(whatsappUrl) != null) {
      await launch(whatsappUrl);
      print("Url" + whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }
}
