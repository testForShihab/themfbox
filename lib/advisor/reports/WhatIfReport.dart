import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/pojo/IndividualXirrResponse.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:http/http.dart' as http;

class WhatIfReport extends StatefulWidget {
  const WhatIfReport({super.key});

  @override
  State<WhatIfReport> createState() => _WhatIfReportState();
}

class _WhatIfReportState extends State<WhatIfReport> {
  late double devWidth, devHeight;
  int userId = getUserId();
  String clientName = GetStorage().read("client_name");
  String userName = GetStorage().read("user_name") ?? "";
  String pan = GetStorage().read("pan") ?? "";
  String name = GetStorage().read("name") ?? "";
  bool isLoading = true;
  bool isPageLoad = true;
  List investorList = [];
  List whatIfReportList = [];
  String selectedSort = "";

  ScrollController scrollController = ScrollController();

  Map<String, bool> isCheckedMap = {};
  List<String> checkedSchemes = [];

  bool isAllSelected = false;

  String getFirst20(String text) {
    String s = text.split(":").first;
    if (s.length > 25) s = '${s.substring(0, 25)}...';
    return s;
  }

  int expandedIndex = -1;
  bool isExpanded = false;

  TextStyle underlineText = TextStyle(
      color: Config.appTheme.themeColor,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w600,
      fontSize: 14);

  int pageId = 1;
  String searchKey = "";
  bool isFirst = true;
  int investorId = 0;
  String selectedInvestor = "";
  String selectedSummaryType = "All";
  String investorName = 'Search and Select Investor';

  String investorPan = '';
  Timer? searchOnStop;
  String selectedEndValue = "XIRR";
  List typeList = [];

  String selectedType = "All Schemes";
  String selectedScheme = "All";
  DateTime selectedFolioDate = DateTime.now();

  IndividualXirrResponse individualXirrResponse = IndividualXirrResponse();
  ExpansionTileController nameController = ExpansionTileController();
  TextEditingController investorNameController = TextEditingController();
  DateFormat format = DateFormat('dd-MM-yyyy');
  DateTime selectedDate = DateTime.now().subtract(Duration(days: 1));
  DateTime selectedEndDate = DateTime.now().subtract(Duration(days: 1));
  ExpansionTileController startDatecontroller = ExpansionTileController();
  ExpansionTileController endDateController = ExpansionTileController();
  bool whatIfFetching = false;
  List summaryTypeList = [
    "All",
    "MF without other ARN",
    "MF bought from others"
  ];
  Map reportActionData = {
    "Download PDF Report ": ["", "", "assets/pdf.png"],
    "Download Excel Report": ["", "", "assets/excel.png"],
  };

  searchWhatIfHandler(String search) {
    searchKey = search;
    pageId = 1;
    const duration = Duration(milliseconds: 1000);
    if (searchOnStop != null) {
      setState(() {
        searchOnStop!.cancel();
      });
    }
    setState(() {
      searchOnStop = Timer(duration, () async {
        await getWhatIfReport(search: search);
      });
    });
  }

  Future searchInvestor(StateSetter bottomState) async {
    investorList = [];
    EasyLoading.show(status: "Searching for `$searchKey`");
    Map data = await AdminApi.getInvestors(
        page_id: pageId,
        client_name: clientName,
        user_id: userId,
        search: searchKey,
        branch: "",
        rmList: []);
    EasyLoading.dismiss();

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    List list = data['list'];
    bottomState(() {
      investorList = List.from(list);
    });

    return 0;
  }

  Future fetchMoreInvestor() async {
    pageId++;
    Map data = await AdminApi.getInvestors(
        page_id: pageId,
        client_name: clientName,
        user_id: userId,
        branch: "",
        rmList: []);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    List list = data['list'];

    investorList.addAll(list);
    investorList = investorList.toSet().toList();

    setState(() {});
    return 0;
  }

  Future getInitialInvestor() async {
    if (!isFirst) return 0;

    Map data = await AdminApi.getInvestors(
        page_id: pageId,
        client_name: clientName,
        user_id: userId,
        branch: "",
        rmList: []);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    investorList = data['list'];
    print("investorList ${investorList.length}");
    setState(() {});
    isFirst = false;
    return 0;
  }

  searchHandler(StateSetter bottomState) {
    const duration = Duration(milliseconds: 1000);
    if (searchOnStop != null) {
      setState(() {
        searchOnStop!.cancel();
      });
    }
    setState(() {
      searchOnStop = Timer(duration, () async {
        await searchInvestor(bottomState);
      });
    });
  }

  Future getDatas() async {
    isLoading = true;
    await getInitialInvestor();
    isLoading = false;
    return 0;
  }

  formatDate(DateTime dt) {
    return DateFormat("dd-MM-yyyy").format(dt);
  }

  xirrFormatDate(DateTime dt) {
    return DateFormat("dd MMM yyyy").format(dt);
  }
  Map totalList ={};

  Future getWhatIfReport({String search = "", bool merge = false}) async {
    if (!merge) whatIfReportList = [];
    if (!isFirst) EasyLoading.show();
    Map data = await Api.getWhatIfReport(
      user_id: investorId,
      client_name: clientName,
      selected_date: format.format(selectedDate),
    );
    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      return 0;
    }
    if (merge) {
      List newWhatIfList = data['list'];
      whatIfReportList.addAll(newWhatIfList);
    } else {
      whatIfReportList = data['list'];
    }
    
    totalList = data['total'];
    setState(() {});
    isPageLoad = false;
    whatIfFetching = false;
    if (!isFirst) EasyLoading.dismiss();
    return 0;
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  Future scrollListener() async {
    double extentAfter = scrollController.position.extentAfter;
    if (searchKey.isNotEmpty) return;
    if (extentAfter < 100.0 && whatIfFetching == false) {
      whatIfFetching = true;
      pageId += 1;
      await getWhatIfReport(merge: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: AppBar(
              leading: SizedBox(),
              leadingWidth: 0,
              toolbarHeight: 60,
              backgroundColor: Config.appTheme.themeColor,
              foregroundColor: Colors.white,
              title: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.arrow_back),
                        SizedBox(width: 10),
                        Text("What If Report", style: AppFonts.appBarTitle),
                        Spacer(),
                        GestureDetector(
                            onTap: () {
                              showCustomizedSummaryBottomSheet();
                            },
                            child: Icon(Icons.filter_alt_outlined)),
                        SizedBox(width: 12),
                        GestureDetector(
                            onTap: () {
                              showReportActionBottomSheet();
                            },
                            child: Icon(Icons.pending_outlined)),
                      ],
                    ),
                    // SizedBox(height: 16),
                    // Row(
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () {},
                    //       child: SearchText(
                    //         hintText: "Search",
                    //         onChange: (val) => searchWhatIfHandler(val),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: isPageLoad
                  ? Center(
                      child: Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.all(16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "Please click the filter button and select the input to get the results.",
                                style: AppFonts.f40013.copyWith(
                                    color: Config.appTheme.themeColor)),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.fromLTRB(0, 16, 16, 0),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              topArea(),
                              countArea(),
                              SizedBox(height: 16),
                              bottomArea(),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          );
        });
  }

  getKeyByValue(Map map, String value) {
    return map.keys.firstWhere((element) => map[element] == value);
  }

  topArea(){

    return Container(
      decoration: BoxDecoration(
          color: Config.appTheme.Bg2Color, borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(16),
      child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColumnText(title: "Total Inflow", value: Utils.formatNumber(totalList['total_inflow'].round() as num)),
                    ColumnText(title: "Total Outflow", value: Utils.formatNumber(totalList['total_outflow'].round() as num),alignment: CrossAxisAlignment.end),
                  ],
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColumnText(title: "Total Current Value", value: Utils.formatNumber(totalList['total_current_value'].round() as num)),
                    ColumnText(title: "Total Gain Loss", value: "${Utils.formatNumber(totalList['total_gain_loss'].round() as num)}",alignment: CrossAxisAlignment.end),
                  ],
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColumnText(title: "Total Abs Rtn",
                        value: "${(totalList['total_abs_return']).toStringAsFixed(2)}"
                    ),
                    ColumnText(title: "Total Whatif", value: Utils.formatNumber(totalList['total_whatif'].round() as num),alignment: CrossAxisAlignment.end),
                  ],
                ),
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [0
                    ColumnText(title: "Total Whatif Abs Rtn", value: '${totalList['total_whatif_abs_return']}'),
                  ],
                ),*/
              ],
            ),


    );
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

  List<String> schemeFolioCode = [];
  Widget whatIfTile(Map data, int index) {
    String scheme = data['scheme'];
    String schemeShortName = data['scheme_amfi_short_name'] ?? "";
    String folioNo = data['folio_no'] ?? "";
    String schemeCode = data['scheme_code'] ?? "";

    num inflow = data['inflow'] ?? 0;
    num outflow = data['outflow'] ?? 0;
    num holdingUnits = data['holding_units'] ?? 0;
    num currentValue = data['current_value'] ?? 0;

    String startDate = data['start_date'] ?? "";
    num latestNavVal = data['latest_nav'] ?? 0;
    String latestNavDate = data['latest_nav_date'] ?? "";

    num redGainLoss = data['red_gain_loss'] ?? 0;
    num redAbsReturn = data['red_abs_return'] ?? 0;
    num whatIfGainLoss = data['what_if_gain_loss'] ?? 0;
    num whatIfAbsReturn = data['what_abs_return'] ?? 0;

    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: isCheckedMap[scheme] ?? false,
                onChanged: (newValue) {
                  setState(() {
                    isCheckedMap[scheme] = newValue ?? false;
                    if (newValue == true) {
                      checkedSchemes.add("$folioNo|$schemeCode");
                      schemeFolioCode.add("$folioNo|$schemeCode");
                      print("schemeNames $schemeFolioCode");
                    } else {
                      checkedSchemes.remove("$folioNo|$schemeCode");
                      schemeFolioCode.remove("$folioNo|$schemeCode");
                      print("checkedSchemes $checkedSchemes");
                      print("schemeNames $checkedSchemes");
                    }
                  });
                },
              ),
              Expanded(
                child: Container(
                  width: devWidth,
                  padding: EdgeInsets.fromLTRB(16, 16, 8, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ColumnText(
                              title: schemeShortName,
                              value: "Folio : $folioNo",
                              titleStyle: AppFonts.f50014Black,
                              valueStyle: AppFonts.f40013,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      whatIfExpansionTile(redGainLoss, redAbsReturn,
                          whatIfGainLoss, whatIfAbsReturn),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                if (expandedIndex == index) {
                                  isExpanded = !isExpanded;
                                } else {
                                  isExpanded = true;
                                  expandedIndex = index;
                                }
                              });
                            },
                            child: Text(
                              expandedIndex == index
                                  ? (isExpanded
                                  ? "Hide Details"
                                  : "View Details")
                                  : "View Details",
                              style: underlineText,

                            ),
                          ),
                        ],
                      ),
                      if (isExpanded && expandedIndex == index)
                      ...[
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ColumnText(
                              title: "Inflow",
                              value:
                                  "$rupee ${Utils.formatNumber(inflow.round(), isAmount: false)}"),
                          ColumnText(
                            title: "Outflow",
                            value:
                                "$rupee ${Utils.formatNumber(outflow.round(), isAmount: false)}",
                            alignment: CrossAxisAlignment.center,
                          ),
                          ColumnText(
                            title: "Holding Units",
                            value:
                                "${Utils.formatNumber(holdingUnits.round(), isAmount: false)}",
                            alignment: CrossAxisAlignment.end,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ColumnText(
                              title: "Curr Value",
                              value:
                                  "$rupee ${Utils.formatNumber(currentValue.round(), isAmount: false)}"),
                          ColumnText(
                            title: "Start Date",
                            value: startDate,
                            alignment: CrossAxisAlignment.center,
                          ),
                          ColumnText(
                            title: "Latest Nav Date",
                            value: "$latestNavDate",
                            alignment: CrossAxisAlignment.end,
                          ),
                        ],
                      ),
                      ]

                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget whatIfExpansionTile(num redGainLoss, num redAbsReturn,
      num whatIfGainLoss, num whatIfAbsReturn) {
    return Container(
      padding: EdgeInsets.only(bottom:1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Redemption Details", style: AppFonts.f50014Black),
            ],
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Gain/Loss",
                  value:
                      "$rupee ${Utils.formatNumber(redGainLoss.round(), isAmount: false)}"),
              ColumnText(
                title: "Abs Ret(%)",
                value: "$redAbsReturn",
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("What If Details", style: AppFonts.f50014Black),
            ],
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Gain/Loss",
                  value:
                      "$rupee ${Utils.formatNumber(whatIfGainLoss.round(), isAmount: false)}"),
              ColumnText(
                title: "Abs Ret(%)",
                value: "$whatIfAbsReturn",
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget reportActionContainer() {
    String selectedWhatIfDate = formatDate(selectedDate);
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
                if (investorId != 0) {
                  String commaSeparatedschemeFolioCode = schemeFolioCode.join(',');
                  // Print or use the comma-separated string
                  print("commaSeparatedschemeFolioCode $commaSeparatedschemeFolioCode");
                  if(commaSeparatedschemeFolioCode.isEmpty)
                  {
                    Utils.showError(context, "Please Select the Scheme");
                    return;
                  }
                  if (index == 0) {
                    String url =
                        "${ApiConfig.apiUrl}/admin/download/downloadWhatIFReport?key=${ApiConfig.apiKey}&user_id=$investorId&client_name=$clientName&report_type=pdf&selected_date=$selectedWhatIfDate&id_array=$commaSeparatedschemeFolioCode";
                    http.Response response = await http.post(Uri.parse(url));
                    msgUrl = response.body;
                    Map data = jsonDecode(msgUrl);
                    String resUrl = data['msg'];
                    print("pdf $url");
                    rpDownloadFile(url: resUrl, context: context, index: index);
                    EasyLoading.dismiss();
                    Get.back();
                  } else if (index == 1) {
                    EasyLoading.show();
                    String url =
                        "${ApiConfig.apiUrl}/admin/download/downloadWhatIFReport?key=${ApiConfig.apiKey}&user_id=$investorId&client_name=$clientName&report_type=excel&selected_date=$selectedWhatIfDate&id_array=$commaSeparatedschemeFolioCode";
                    http.Response response = await http.post(Uri.parse(url));
                    msgUrl = response.body;
                    Map data = jsonDecode(msgUrl);
                    String resUrl = data['msg'];
                    print("excel $url");
                    rpDownloadFile(url: resUrl, context: context, index: index);
                    EasyLoading.dismiss();
                    Get.back();
                  }
                } else {
                  Utils.showError(context, "Please Select the Scheme");
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

  void showError() {
    Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Config.appTheme.themeColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  showCustomizedSummaryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (_, bottomState) {
          return SizedBox(
            height: devHeight * 0.72,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BottomSheetTitle(title: "Customize Report"),
                SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          padding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              investorSearchCard(context, bottomState),
                              SizedBox(height: 10),
                              selectDateExpansionTile(context, bottomState),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 75,
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getCancelApplyButton(ButtonType.plain),
                      SizedBox(width: 48),
                      getCancelApplyButton(ButtonType.filled),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget selectDateExpansionTile(
      BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: startDatecontroller,
            title: Text("Select Date", style: AppFonts.f50014Black),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Utils.getFormattedDate(date: selectedDate),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Config.appTheme.themeColor)),
              ],
            ),
            children: [
              SizedBox(
                height: 180,
                child: ScrollDatePicker(
                  selectedDate: selectedDate,
                  maximumDate: DateTime.now().subtract(Duration(days: 1)),
                  onDateTimeChanged: (value) {
                    selectedDate = value;
                    bottomState(() {});
                  },
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                    "* select the date equivalent/less than the redemption date.",
                    style: TextStyle(
                      color: Config.appTheme.defaultLoss,
                    )),
              )
            ],
          )),
    );
  }

  Widget investorSearchCard(BuildContext context, StateSetter bottomState) {
    double maxHeight = MediaQuery.of(context).size.height * 0.8;
    // double cardHeight = maxHeight < 564 ? maxHeight : 564;

    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          controller: nameController,
          title: Text("Investor", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                investorName,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Config.appTheme.themeColor,
                ),
              ),
              DottedLine(),
            ],
          ),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: SizedBox(
                height: 40,
                child: TextFormField(
                  controller: investorNameController,
                  onChanged: (val) {
                    searchKey = val;
                    searchHandler(bottomState);
                  },
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.search,
                      color: Config.appTheme.themeColor,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(10, 2, 12, 2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 116,
                  child: ListView.builder(
                    itemCount: investorList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      String name = investorList[index]['name'];
                      String pan = investorList[index]['pan'];

                      return InkWell(
                        onTap: () {
                          investorId = investorList[index]['id'];
                          investorName = investorList[index]['name'];
                          investorPan = investorList[index]['pan'];
                          print("investorId $investorId");
                          investorName = name;
                          investorPan = pan;
                          investorNameController.text = investorName;
                          bottomState(() {});
                        },
                        child: ListTile(
                          leading: InitialCard(title: (name == "") ? "." : name),
                          title: Text(name),
                        ),
                      );
                    },
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (searchKey.isNotEmpty) return;
                    EasyLoading.show();
                    await fetchMoreInvestor();
                    bottomState(() {});
                    EasyLoading.dismiss();
                  },
                  child: Text(
                    "Load More Results",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Config.appTheme.themeColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
            // Column(
            //   children: [
            //     ListView.builder(
            //       physics: NeverScrollableScrollPhysics(),
            //       itemCount: investorList.length,
            //       shrinkWrap: true,
            //       itemBuilder: (context, index) {
            //         String name = investorList[index]['name'];
            //         String pan = investorList[index]['pan'];

            //         return InkWell(
            //           onTap: () {
            //             bottomState(() {
            //               investorId = investorList[index]['id'];
            //               print("investorId $investorId");
            //               investorName = name;
            //               investorPan = pan;
            //             });
            //           },
            //           child: ListTile(
            //             leading: InitialCard(title: (name == "") ? "." : name),
            //             title: Text(name),
            //           ),
            //         );
            //       },
            //     ),
            //     InkWell(
            //       onTap: () async {
            //         if (searchKey.isNotEmpty) return;
            //         EasyLoading.show();
            //         await fetchMoreInvestor();
            //         bottomState(() {});
            //         EasyLoading.dismiss();
            //       },
            //       child: Text(
            //         "Load More Results",
            //         style: TextStyle(
            //           decoration: TextDecoration.underline,
            //           color: Config.appTheme.themeColor,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //     ),
            //     SizedBox(height: 16),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Map folioMap = {
    "Live Folios": "Live",
    "All Folios": "All",
    "Non segregated Folios": "NonSegregated",
  };
  String selectedFolioType = "Live";
  ExpansionTileController folioController = ExpansionTileController();
  Widget folioExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: folioController,
          title: Text("Folio Type", style: AppFonts.f50014Black),
          tilePadding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${getKeyByValue(folioMap, selectedFolioType)}",
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
                String key = folioMap.keys.elementAt(index);
                String value = folioMap.values.elementAt(index);

                return InkWell(
                  onTap: () {
                    selectedFolioType = value;
                    folioController.collapse();
                    bottomState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: value,
                        groupValue: selectedFolioType,
                        onChanged: (temp) {
                          selectedFolioType = value;
                          folioController.collapse();
                          bottomState(() {});
                        },
                      ),
                      Text(key),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ExpansionTileController summaryController = ExpansionTileController();
  Widget summaryExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: summaryController,
          title: Text("Folio Option", style: AppFonts.f50014Black),
          tilePadding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedSummaryType,
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
              itemCount: summaryTypeList.length,
              itemBuilder: (context, index) {
                String title = summaryTypeList[index];

                return InkWell(
                  onTap: () {
                    selectedSummaryType = title;
                    bottomState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: title,
                        groupValue: selectedSummaryType,
                        onChanged: (temp) {
                          selectedSummaryType = title;
                          bottomState(() {});
                        },
                      ),
                      Text(title),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget getCancelApplyButton(ButtonType type) {
    if (type == ButtonType.plain)
      return PlainButton(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        text: "CANCEL ALL",
        onPressed: () {
          Get.back();
        },
      );
    else
      return RpFilledButton(
        text: "APPLY",
        onPressed: () async {
          print("investorId = $investorId");
          if (investorId == 0) {
            Utils.showError(context, "Please Select the Scheme");
            return;
          }
          whatIfReportList = [];
          await getWhatIfReport();
          setState(() {});
          Get.back();
        },
      );
  }

  int length = 0;
  Widget countArea() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            "${whatIfReportList.length} items",
            style: TextStyle(color: Colors.grey),
          ),
          Spacer(),
          if (whatIfReportList.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    selectAll();
                  },
                  child: Text(
                    isAllSelected ? 'Unselect All' : 'Select All',
                    style: underlineText,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void selectAll() {
    setState(() {
      if (isAllSelected) {
        // Unselect All
        isCheckedMap.forEach((key, _) {
          isCheckedMap[key] = false;
        });
        isCheckedMap.clear();
        checkedSchemes.clear();
        schemeFolioCode.clear();
      } else {
        // Select All
        schemeFolioCode = [];
        for (var data in whatIfReportList) {
          String scheme = data['scheme'];
          String folioNo = data['folio_no'];
          String schemeCode = data['scheme_code'];
          isCheckedMap[scheme] = true;
          if (!checkedSchemes.contains(scheme)) {
            checkedSchemes.add(scheme);
            schemeFolioCode.add("$folioNo|$schemeCode");
          }
        }
      }
      print("schemeNames $schemeFolioCode");
      isAllSelected = !isAllSelected;
    });
  }

  Widget bottomArea() {
    return (whatIfReportList.isEmpty)
        ? NoData()
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: whatIfReportList.length,
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    Map data = whatIfReportList[index];
                    return GestureDetector(
                      onTap: () async {},
                      child: whatIfTile(data, index),
                    );
                  },
                ),
              ],
            ),
          );
  }
}
