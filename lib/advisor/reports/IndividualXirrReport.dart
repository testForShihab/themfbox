import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/pojo/IndividualXirrResponse.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:mymfbox2_0/rp_widgets/NoData.dart';

import '../../api/ReportApi.dart';

class IndividualXirrReport extends StatefulWidget {
  const IndividualXirrReport({super.key});

  @override
  State<IndividualXirrReport> createState() => _IndividualXirrReportState();
}

class _IndividualXirrReportState extends State<IndividualXirrReport> {
  late double devWidth, devHeight;
  int userId = getUserId();
  String clientName = GetStorage().read("client_name");
  String userName = GetStorage().read("user_name") ?? "";
  String pan = GetStorage().read("pan") ?? "";
  String name = GetStorage().read("name") ?? "";
  bool isLoading = true;
  bool isPageLoad = true;
  List investorList = [];
  String selectedSort = "";
  List equityList = [];
  List debtList = [];
  List hybridList = [];
  List solutionList = [];
  List othersList = [];

  num totalInvCost = 0;
  num totalCurrVal = 0;
  num invCostAsOn = 0;
  num currValAsOn = 0;
  num gainLoss = 0;
  num totalXirr = 0;
  num purchase = 0;
  num redemption = 0;
  num divPay = 0;

  num equityStartValue = 0;
  num equityEndValue = 0;
  num equityStartDate = 0;
  num equityEndDate = 0;
  num equityCagr = 0;
  num equityabsRtn = 0;

  num debtStartValue = 0;
  num debtEndValue = 0;
  num debtStartDate = 0;
  num debtEndDate = 0;
  num debtCagr = 0;
  num debtabsRtn = 0;

  num hybridStartValue = 0;
  num hybridEndValue = 0;
  num hybridStartDate = 0;
  num hybridEndDate = 0;
  num hybridCagr = 0;
  num hybridabsRtn = 0;

  num solutionStartValue = 0;
  num solutionEndValue = 0;
  num solutionStartDate = 0;
  num solutionEndDate = 0;
  num solutionCagr = 0;
  num solutionabsRtn = 0;

  num othersStartValue = 0;
  num othersEndValue = 0;
  num othersStartDate = 0;
  num othersEndDate = 0;
  num othersCagr = 0;
  num othersabsRtn = 0;

  List<Color> colorList = [
    Colors.purple,
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.red,
  ];

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

  DateTime selectedStartDate = DateTime.now().subtract(Duration(days: 1));
  DateTime selectedEndDate = DateTime.now().subtract(Duration(days: 1));
  ExpansionTileController startDatecontroller = ExpansionTileController();
  ExpansionTileController endDateController = ExpansionTileController();
  List summaryTypeList = [
    "All",
    "MF without other ARN",
    "MF bought from others"
  ];
  Map reportActionData = {
    "Download PDF Report ": ["", "", "assets/pdf.png"],
    "Download Excel Report": ["", "", "assets/excel.png"],
    "Email Report": ["", null, "assets/email.png"],
  };
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

  Future getIndividualXIRR() async {
    if (totalInvCost != 0) return 0;

    Map<String, dynamic> data = await AdminApi.getIndividualXIRR(
      user_id: investorId,
      client_name: clientName,
      pan: investorPan,
      name: selectedInvestor,
      start_date: formatDate(selectedStartDate),
      end_date: formatDate(selectedEndDate),
      option: selectedSummaryType,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    List<dynamic> availableData = data['available'];
    typeList = [];
    typeList.add('All Schemes');
    availableData.forEach((item) {
      if (item['count'] > 0) {
        typeList.add('${item['name']} (${item['count']})');
      }
    });

    totalInvCost = data['total_inv_cost'] ?? 0;
    totalCurrVal = data['total_curr_val'] ?? 0;
    invCostAsOn = data['inv_cost_as_on'] ?? 0;
    currValAsOn = data['curr_val_as_on'] ?? 0;
    gainLoss = data['total_gain_loss'] ?? 0;
    totalXirr = data['total_xirr'] ?? 0;
    purchase = data['total_purchase'] ?? 0;
    redemption = data['total_redemption'] ?? 0;
    divPay = data['total_div_pay'] ?? 0;

    equityStartValue = data['equity']['start_value'] ?? 0;
    equityEndValue = data['equity']['end_value'] ?? 0;
    equityStartDate = data['equity']['start_date'] ?? 0;
    equityEndDate = data['equity']['end_date'] ?? 0;
    equityabsRtn = data['equity']['abs_return'] ?? 0;
    equityCagr = data['equity']['cagr'] ?? 0;

    debtStartValue = data['debt']['start_value'] ?? 0;
    debtEndValue = data['debt']['end_value'] ?? 0;
    debtStartDate = data['debt']['start_date'] ?? 0;
    debtEndDate = data['debt']['end_date'] ?? 0;
    debtabsRtn = data['debt']['abs_return'] ?? 0;
    debtCagr = data['debt']['cagr'] ?? 0;

    hybridStartValue = data['hybrid']['start_value'] ?? 0;
    hybridEndValue = data['hybrid']['end_value'] ?? 0;
    hybridStartDate = data['hybrid']['start_date'] ?? 0;
    hybridEndDate = data['hybrid']['end_date'] ?? 0;
    hybridabsRtn = data['hybrid']['abs_return'] ?? 0;
    hybridCagr = data['hybrid']['cagr'] ?? 0;

    solutionStartValue = data['solution']['start_value'] ?? 0;
    solutionEndValue = data['solution']['end_value'] ?? 0;
    solutionStartDate = data['solution']['start_date'] ?? 0;
    solutionEndDate = data['solution']['end_date'] ?? 0;
    solutionabsRtn = data['solution']['abs_return'] ?? 0;
    solutionCagr = data['solution']['cagr'] ?? 0;

    othersStartValue = data['others']['start_value'] ?? 0;
    othersEndValue = data['others']['end_value'] ?? 0;
    othersStartDate = data['others']['start_date'] ?? 0;
    othersEndDate = data['others']['end_date'] ?? 0;
    othersabsRtn = data['others']['abs_return'] ?? 0;
    othersCagr = data['others']['cagr'] ?? 0;

    equityList = data['equity']['list'];
    debtList = data['debt']['list'];
    hybridList = data['hybrid']['list'];
    solutionList = data['solution']['list'];
    othersList = data['others']['list'];

    individualXirrResponse = IndividualXirrResponse.fromJson(data);
    return 0;
  }

  @override
  void initState() {
    super.initState();
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
              backgroundColor: Config.appTheme.themeColor,
              foregroundColor: Colors.white,
              title: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_back),
                    SizedBox(width: 10),
                    Text(
                        "Point to Point \nIndividual XIRR Report" ,
                        style: AppFonts.appBarTitle),
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
              ),
            ),
            body: SingleChildScrollView(
              child: getBody(),
            ),
          );
        });
  }

  getBody() {
    if (investorId == 0) return initialContainer();
    if (totalInvCost == 0 && investorId != 0 && invCostAsOn == 0) return NoData();
    return contentContainer();
  }

  getKeyByValue(Map map, String value) {
    return map.keys.firstWhere((element) => map[element] == value);
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

  Widget initialContainer() {
    return Center(
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please click the filter button and select the input to get the results.",
              style: AppFonts.f40013.copyWith(
                color: Config.appTheme.themeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget contentContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            color: Config.appTheme.themeColor,
            child: Column(
              children: [
                topArea(),
                middleArea(),
              ],
            )),
        SizedBox(height: 16),
        countArea(),
        SizedBox(height: 4),
        bottomArea(),
      ],
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
                if (investorId != 0) {
                  if (index == 0) {
                    String url =
                        "${ApiConfig.apiUrl}/admin/download/individualXirrReport?key=${ApiConfig.apiKey}&user_id=$investorId&client_name=$clientName&type=pdf&start_date=$startDate&end_date=$endDate&option=$selectedSummaryType";

                    http.Response response = await http.post(Uri.parse(url));
                    msgUrl = response.body;
                    Map data = jsonDecode(msgUrl);
                    String resUrl = data['msg'];
                    print("download $url");
                    rpDownloadFile(url: resUrl, context: context, index: index);
                    EasyLoading.dismiss();
                    Get.back();
                  } else if (index == 1) {
                    EasyLoading.show();
                    String url =
                        "${ApiConfig.apiUrl}/admin/download/individualXirrReport?key=${ApiConfig.apiKey}&user_id=$investorId&client_name=$clientName&type=excel&start_date=$startDate&end_date=$endDate&option=$selectedSummaryType";
                    http.Response response = await http.post(Uri.parse(url));
                    msgUrl = response.body;
                    Map data = jsonDecode(msgUrl);
                    String resUrl = data['msg'];
                    print("email $url");
                    rpDownloadFile(url: resUrl, context: context, index: index);
                    EasyLoading.dismiss();
                    Get.back();
                  } else if (index == 2) {
                    EasyLoading.show();
                    String url =
                        "${ApiConfig.apiUrl}/admin/download/individualXirrReport?key=${ApiConfig.apiKey}&user_id=$investorId&client_name=$clientName&type=email&start_date=$startDate&end_date=$endDate&option=$selectedSummaryType";
                    http.Response response = await http.post(Uri.parse(url));
                    msgUrl = response.body;
                    Map data = jsonDecode(msgUrl);
                    String resUrl = data['msg'];
                    print("email $url");
                    rpDownloadFile(url: resUrl, context: context, index: index);
                    EasyLoading.dismiss();
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
    },
    {
      'title': "Email Report",
      'img': "assets/email.png",
      'type': ReportType.EMAIL,
    }
  ];

  Widget reportActionContainer() {
    String startDate = formatDate(selectedStartDate);
    String endDate = formatDate(selectedEndDate);
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
                if (investorId != 0) {
                  EasyLoading.show();
                  Map data = await ReportApi.individualXirrReport(
                      user_id: investorId,
                      client_name: clientName,
                      type: type,
                      start_date: startDate,
                      end_date: endDate,
                      option: selectedSummaryType);
                  if (data['status'] != 200) {
                    Utils.showError(context, data['msg']);
                    return;
                  }
                  EasyLoading.dismiss();
                  Get.back();
                  if (type == ReportType.DOWNLOAD) {
                    rpDownloadFile(
                        url: data['msg'], context: context, index: index);
                  } else if (type == ReportType.EXCEL) {
                    rpDownloadFile(
                        url: data['msg'], context: context, index: index);
                  } else if (type == ReportType.EMAIL) {
                    EasyLoading.showToast("${data['msg']}");
                  }
                } else {
                  Utils.showError(context, "Please Select the Investor");
                  return;
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
    print("selectedInvestor $selectedInvestor");

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
          return Container(
            height: devHeight * 0.93,
            decoration: BoxDecoration(
              color: Config.appTheme.mainBgColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BottomSheetTitle(title: "Customize Report"),
                  SizedBox(height: 10),
                  investorSearchCard(context, bottomState),
                  SizedBox(height: 10),
                  startDateExpansionTile(context, bottomState),
                  SizedBox(height: 10),
                  endDateExpansionTile(context, bottomState),
                  SizedBox(height: 10),
                  summaryExpansionTile(context, bottomState),
                  SizedBox(height: 10),
                  buttonCard(),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  bool bottomSheetShowDetails = false;
  showXirrReportBottomSheet(
      String shortName,
      String folioNo,
      String amcLogo,
      String startValue,
      DateTime selectedStartDate,
      String invCostStartDate,
      String currValueStartDate,
      DateTime selectedEndDate,
      String invCostEndDate,
      String currValueEndDate,
      num realisedGainLoss,
      totalInflow,
      totalOutflow,
      dividendPaid,
      absoluteReturn,
      xirr) {
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
          return Container(
            height: devHeight * 0.78,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "XIRR Report",
                        style: AppFonts.f50014Black.copyWith(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(amcLogo, height: 32),
                              SizedBox(width: 8),
                              Expanded(
                                child: ColumnText(
                                  title: shortName,
                                  value: "Folio : $folioNo",
                                  titleStyle: AppFonts.f50014Black,
                                  valueStyle: AppFonts.f40013
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            "As on ${Utils.getFormattedDate(date: selectedStartDate)}",
                            style: AppFonts.f40013,
                          ),
                          SizedBox(height: 10),
                          summaryRowBlack(
                              initial: "A",
                              bgColor: Color(0xFF4155B9),
                              title: "Investment Cost",
                              value: Utils.formatNumber(
                                  double.parse(invCostStartDate).round())),
                          SizedBox(
                            height: 5,
                          ),
                          summaryRowBlack(
                              initial: "B",
                              bgColor: Color(0xFF4155B9),
                              title: "Investment Value",
                              value: Utils.formatNumber(
                                  double.parse(currValueStartDate).round())),
                          DottedLine(),
                          Text(
                            "As on ${Utils.getFormattedDate(date: selectedEndDate)}",
                            style: AppFonts.f40013,
                          ),
                          SizedBox(height: 5),
                          summaryRowBlack(
                              initial: "C",
                              bgColor: Color(0xFFFF6F61),
                              title: "Investment Cost",
                              value: Utils.formatNumber(
                                  double.parse(invCostEndDate).round())),
                          summaryRowBlack(
                              initial: "D",
                              bgColor: Color(0xFFFF6F61),
                              title: "Current Value",
                              value: Utils.formatNumber(
                                  double.parse(currValueEndDate).round())),
                          SizedBox(height: 5),
                          DottedLine(),
                          Row(
                            children: [
                              InitialCard(
                                bgColor: Color(0xFF3C9AB6),
                                title: "E",
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  blackText("Purchase"),
                                ],
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  blackText(
                                      "$rupee ${Utils.formatNumber(
                                          totalInflow.round())}"),
                                  GestureDetector(
                                    onTap: () {
                                      bottomSheetShowDetails =
                                          !bottomSheetShowDetails;
                                      bottomState(() {});
                                    },
                                    child: Text(
                                      "${(bottomSheetShowDetails) ? "Hide" : "View"} details",
                                      style: AppFonts.f40013.copyWith(
                                          color: Colors.blue,
                                          decorationColor: Colors.blue,
                                          decoration: TextDecoration.underline),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 16),
                          Visibility(
                              visible: bottomSheetShowDetails,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  summaryRowBlack(
                                      initial: "F",
                                      bgColor: Color(0xFF5DB25D),
                                      title: "Redemption",
                                      value: Utils.formatNumber(
                                          totalOutflow.round())),
                                  summaryRowBlack(
                                      initial: "G",
                                      bgColor: Color(0xFFE79C23),
                                      title: "Dividend Pay",
                                      value: Utils.formatNumber(
                                          dividendPaid.round())),
                                  summaryRowBlack(
                                      initial: "H",
                                      bgColor: Color(0xFFE79C23),
                                      title: "Gain/Loss \n(D-B)-(E)+F+G",
                                      value: Utils.formatNumber(realisedGainLoss)),
                                ],
                              )),
                          DottedLine(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ColumnText(
                                  title: "Absolute Return",
                                  value:
                                      "${absoluteReturn.toStringAsFixed(2)}%",
                                  alignment: CrossAxisAlignment.start,
                                  titleStyle: AppFonts.f40013
                                      .copyWith(color: Colors.black),
                                  valueStyle: AppFonts.f50014Black.copyWith(
                                      color: (absoluteReturn > 0)
                                          ? Config.appTheme.defaultProfit
                                          : Config.appTheme.defaultLoss)),
                              ColumnText(
                                  title: "XIRR",
                                  value: "${xirr.toStringAsFixed(2)}%",
                                  alignment: CrossAxisAlignment.end,
                                  titleStyle: AppFonts.f40013
                                      .copyWith(color: Colors.black),
                                  valueStyle: AppFonts.f50014Black.copyWith(
                                      color: (xirr > 0)
                                          ? Config.appTheme.defaultProfit
                                          : Config.appTheme.defaultLoss)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }

  Widget buttonCard() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: 45,
        child: ElevatedButton(
          onPressed: () async {
            selectedInvestor = investorName;
            print("investorName $investorName");
            if (investorId == 0) {
              Utils.showError(context, "Please Select the Investor");
              return;
            }
            isPageLoad = false;
            EasyLoading.show();
            totalInvCost = 0;
            await getIndividualXIRR();
            EasyLoading.dismiss();
            setState(() {});

            Get.back();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Config.appTheme.buttonColor,
            foregroundColor: Colors.white,
          ),
          child: Text("SUBMIT"),
        ),
      ),
    );
  }

  Widget endDateExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: endDateController,
            onExpansionChanged: (val) {},
            title: Text("End Date", style: AppFonts.f50014Black),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Utils.getFormattedDate(date: selectedEndDate),
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
                  selectedDate: selectedEndDate,
                  maximumDate: DateTime.now().subtract(Duration(days: 1)),
                  onDateTimeChanged: (value) {
                    selectedEndDate = value;
                    bottomState(() {});
                  },
                ),
              ),
            ],
          )),
    );
  }

  Widget startDateExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: startDatecontroller,
            title: Text("Start Date", style: AppFonts.f50014Black),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Utils.getFormattedDate(date: selectedStartDate),
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
                  selectedDate: selectedStartDate,
                  maximumDate: DateTime.now().subtract(Duration(days: 1)),
                  onDateTimeChanged: (value) {
                    selectedStartDate = value;
                    bottomState(() {});
                  },
                ),
              ),
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
                          print("investorId $investorId");
                          investorName = name;
                          investorPan = pan;
                          investorNameController.text = investorName;
                          bottomState(() {});
                        },
                        child: ListTile(
                          leading:
                              InitialCard(title: (name == "") ? "." : name),
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
            //             leading: InitialCard(title: (name == "") ? "." : name)
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
        color: Config.appTheme.buttonColor,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        text: "CLEAR ALL",
        onPressed: () {},
      );
    else
      return RpFilledButton(
        color: Config.appTheme.buttonColor,
        text: "APPLY",
        onPressed: () {
          individualXirrResponse.msg = null;
          Get.back();
          setState(() {});
        },
      );
  }

  int length = 0;
  Widget countArea() {
    if (selectedScheme == "All")
      length = equityList.length +
          debtList.length +
          hybridList.length +
          solutionList.length +
          othersList.length;

    if (selectedScheme == "Equity") length = equityList.length;
    if (selectedScheme == "Debt") length = debtList.length;
    if (selectedScheme == "Hybrid") length = hybridList.length;
    if (selectedScheme == "Solution") length = solutionList.length;
    if (selectedScheme == "Others") length = othersList.length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            "$length items",
            style: TextStyle(color: Colors.grey),
          ),
          Spacer(),
          SortButton(
            onTap: () {
              sortBottomSheet();
            },
            title: " Sort By",
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Image.asset(
                "assets/mobile_data.png",
                height: 14,
                color: Config.appTheme.themeColor,
              ),
            ),
          ),
          SizedBox(width: 16),
          SortButton(
            onTap: () {
              if (xirrType == 'cagr')
                xirrType = 'absolute_return';
              else
                xirrType = 'cagr';
              setState(() {});
            },
            title: xirrMap[xirrType],
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Image.asset(
                "assets/mobile_sort.png",
                height: 10,
                color: Config.appTheme.themeColor,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 4),
          )
        ],
      ),
    );
  }

  List sortOptions = ["Current Value", "Current Cost", "A to Z", "XIRR"];

  sortBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, bottomState) {
          return Column(
            children: [
              BottomSheetTitle(title: "Sort & Filter"),
              ListView.builder(
                shrinkWrap: true,
                itemCount: sortOptions.length,
                itemBuilder: (context, index) {
                  String option = sortOptions[index];

                  return InkWell(
                    onTap: () {
                      selectedSort = option;
                      bottomState(() {});
                      applySort();
                      Get.back();
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        Radio(
                          value: option,
                          groupValue: selectedSort,
                          onChanged: (value) {
                            selectedSort = option;
                            bottomState(() {});
                            applySort();
                            Get.back();
                            setState(() {});
                          },
                        ),
                        Text(option),
                      ],
                    ),
                  );
                },
              )
            ],
          );
        });
      },
    );
  }

  applySort() {
    if (selectedScheme == "All") {
      print("selectedSchemes+++ $selectedScheme");
      return allSort();
    }
    if (selectedScheme == "Equity") return equitySort();
    if (selectedScheme == "Debt") return debtSort();
    if (selectedScheme == "Hybrid") return hybridSort();
    if (selectedScheme == "Solution") return solutionSort();
    if (selectedScheme == "Others") return othersSort();
  }

  allSort() {
    equitySort();
    debtSort();
    hybridSort();
    solutionSort();
    othersSort();
  }

  equitySort() {
    print("equitySort $equitySort");
    if (selectedSort == 'Current Value')
      equityList.sort((a, b) {
        double valueA = double.parse(a['currValueStartDate']);
        double valueB = double.parse(b['currValueStartDate']);
        return valueB.compareTo(valueA);
      });
    if (selectedSort == 'Current Cost')
      equityList.sort((a, b) {
        double valueA = double.parse(a['currValueEndDate']);
        double valueB = double.parse(b['currValueEndDate']);
        return valueB.compareTo(valueA);
      });
    if (selectedSort == 'A to Z')
      equityList.sort((a, b) =>
          a['scheme_amfi_short_name'].compareTo(b['scheme_amfi_short_name']));
    if (selectedSort == "XIRR")
      equityList.sort((a, b) => b['cagr']!.compareTo(a['cagr']));
  }

  debtSort() {
    if (selectedSort == 'Current Value')
      debtList.sort((a, b) {
        double valueA = double.parse(a['currValueStartDate']);
        double valueB = double.parse(b['currValueStartDate']);
        return valueB.compareTo(valueA);
      });
    if (selectedSort == 'Current Cost')
      debtList.sort((a, b) {
        double valueA = double.parse(a['currValueEndDate']);
        double valueB = double.parse(b['currValueEndDate']);
        return valueB.compareTo(valueA);
      });
    if (selectedSort == 'A to Z')
      debtList.sort((a, b) =>
          a['scheme_amfi_short_name'].compareTo(b['scheme_amfi_short_name']));
    if (selectedSort == "XIRR")
      debtList.sort((a, b) => b['cagr']!.compareTo(a['cagr']));
  }

  hybridSort() {
    if (selectedSort == 'Current Value')
      hybridList.sort((a, b) {
        double valueA = double.parse(a['currValueStartDate']);
        double valueB = double.parse(b['currValueStartDate']);
        return valueB.compareTo(valueA);
      });
    if (selectedSort == 'Current Cost')
      hybridList.sort((a, b) {
        double valueA = double.parse(a['currValueEndDate']);
        double valueB = double.parse(b['currValueEndDate']);
        return valueB.compareTo(valueA);
      });
    if (selectedSort == 'A to Z')
      hybridList.sort((a, b) =>
          a['scheme_amfi_short_name'].compareTo(b['scheme_amfi_short_name']));
    if (selectedSort == "XIRR")
      hybridList.sort((a, b) => b['cagr']!.compareTo(a['cagr']));
  }

  solutionSort() {
    if (selectedSort == 'Current Value')
      solutionList.sort((a, b) {
        double valueA = double.parse(a['currValueStartDate']);
        double valueB = double.parse(b['currValueStartDate']);
        return valueB.compareTo(valueA);
      });
    if (selectedSort == 'Current Cost')
      solutionList.sort((a, b) {
        double valueA = double.parse(a['currValueEndDate']);
        double valueB = double.parse(b['currValueEndDate']);
        return valueB.compareTo(valueA);
      });
    if (selectedSort == 'A to Z')
      solutionList.sort((a, b) =>
          a['scheme_amfi_short_name'].compareTo(b['scheme_amfi_short_name']));
    if (selectedSort == "XIRR")
      solutionList.sort((a, b) => b['cagr']!.compareTo(a['cagr']));
  }

  othersSort() {
    if (selectedSort == 'Current Value')
      othersList.sort((a, b) {
        double valueA = double.parse(a['currValueStartDate']);
        double valueB = double.parse(b['currValueStartDate']);
        return valueB.compareTo(valueA);
      });
    if (selectedSort == 'Current Cost')
      othersList.sort((a, b) {
        double valueA = double.parse(a['currValueEndDate']);
        double valueB = double.parse(b['currValueEndDate']);
        return valueB.compareTo(valueA);
      });
    if (selectedSort == 'A to Z')
      othersList.sort((a, b) =>
          a['scheme_amfi_short_name'].compareTo(b['scheme_amfi_short_name']));
    if (selectedSort == "XIRR")
      othersList.sort((a, b) => b['cagr']!.compareTo(a['cagr']));
  }

  Widget bottomArea() {
    if (selectedScheme == "All") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (equityList.isNotEmpty) equityArea(),
          if (debtList.isNotEmpty) debtArea(),
          if (hybridList.isNotEmpty) hybridArea(),
          if (solutionList.isNotEmpty) solutionArea(),
          if (othersList.isNotEmpty) othersArea(),
        ],
      );
    }
    if (selectedScheme == "Equity") return equityArea();
    if (selectedScheme == "Debt") return debtArea();
    if (selectedScheme == "Hybrid") return hybridArea();
    if (selectedScheme == "Solution") return solutionArea();
    if (selectedScheme == "Others") return othersArea();
    return Text("Invalid Option");
  }

  Widget equityArea() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          equityBlackCard(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: equityList.length,
            itemBuilder: (context, index) {
              Map data = equityList[index];
              return equityCard(data);
            },
          ),
        ],
      ),
    );
  }

  Widget equityCard(Map data) {
    String shortName = data['scheme_amfi_short_name'] ?? "";
    String folioNo = data['foliono'] ?? "";
    String amcLogo = data['amc_logo'] ?? "";
    String startValue = data['currValueStartDate'] ?? "0";
    String endValue = data['currValueEndDate'] ?? "0";

    String invCostStartDate = data['invCostStartDate'] ?? "0";
    String currValueStartDate = data['currValueStartDate'] ?? "0";
    String invCostEndDate = data['invCostEndDate'] ?? "0";
    String currValueEndDate = data['currValueEndDate'] ?? "0";

    num realisedGainLoss = data['realisedGainLoss'] ?? 0;
    num totalInflow = data['totalInflow'] ?? 0;
    num totalOutflow = data['totalOutflow'] ?? 0;
    num dividendPaid = data['dividendPaid'] ?? 0;

    num absoluteReturn = data['absolute_return'] ?? 0;
    num xirr = data['cagr'] ?? 0;

    return InkWell(
      onTap: () {
        showXirrReportBottomSheet(
            shortName,
            folioNo,
            amcLogo,
            startValue,
            selectedStartDate,
            invCostStartDate,
            currValueStartDate,
            selectedEndDate,
            invCostEndDate,
            currValueEndDate,
            realisedGainLoss,
            totalInflow,
            totalOutflow,
            dividendPaid,
            absoluteReturn,
            xirr);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(amcLogo, height: 32),
                SizedBox(width: 8),
                Expanded(
                  child: ColumnText(
                    title: shortName,
                    value: "Folio : $folioNo",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Config.appTheme.placeHolderInputTitleAndArrow,
                )
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnText(
                    title: "Start Value",
                    value:
                        "$rupee ${Utils.formatNumber(double.parse(startValue).round(), isAmount: false)}"),
                ColumnText(
                  title: "End Value",
                  value:
                      "$rupee ${Utils.formatNumber(double.parse(endValue).round(), isAmount: false)}",
                  alignment: CrossAxisAlignment.center,
                ),
                ColumnText(
                  title: "${xirrMap[xirrType]}",
                  value: "${(data[xirrType] ?? 0.0).toStringAsFixed(2)}%",
                  alignment: CrossAxisAlignment.end,
                  valueStyle: AppFonts.f50014Black.copyWith(
                      color: (data[xirrType] > 0)
                          ? Config.appTheme.defaultProfit
                          : Config.appTheme.defaultLoss),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Container equityBlackCard() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Color(0xffF8DFD5),
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(Icons.bar_chart, color: Colors.red, size: 20)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Equity Schemes (${equityList.length})",
                  style: AppFonts.f50014Black.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title:
                    "Inv. Cost as ${Utils.getFormattedDate(date: selectedStartDate)}",
                value:
                    "$rupee ${Utils.formatNumber(equityStartValue.round(), isAmount: false)}",
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title:
                    " Value as on ${Utils.getFormattedDate(date: selectedStartDate)}",
                value:
                    "$rupee ${Utils.formatNumber(equityStartDate.round(), isAmount: false)}",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title:
                    "Inv. Cost as ${Utils.getFormattedDate(date: selectedEndDate)}",
                value:
                    "$rupee ${Utils.formatNumber(equityEndValue.round(), isAmount: false)}",
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title:
                    " Value as on ${Utils.getFormattedDate(date: selectedEndDate)}",
                value:
                    "$rupee ${Utils.formatNumber(equityEndDate.round(), isAmount: false)}",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "XIRR",
                value: "${equityCagr.toStringAsFixed(2)}%",
                alignment: CrossAxisAlignment.start,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: (equityCagr > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
              ),
              ColumnText(
                title: "Abs Rtn",
                value: "${equityabsRtn.toStringAsFixed(2)}%",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: (equityabsRtn > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget debtArea() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (selectedScheme == "Debt") ? SizedBox(height: 16) : SizedBox(),
          debtBlackCard(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: debtList.length,
            itemBuilder: (context, index) {
              Map data = debtList[index];
              return debtCard(data);
            },
          ),
        ],
      ),
    );
  }

  Container debtBlackCard() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Color(0xffF8DFD5),
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(Icons.bar_chart, color: Colors.red, size: 20)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Debt Schemes (${debtList.length})",
                  style: AppFonts.f50014Black.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title:
                    "Inv. Cost as ${Utils.getFormattedDate(date: selectedStartDate)}",
                value:
                    "$rupee ${Utils.formatNumber(debtStartValue.round(), isAmount: false)}",
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title:
                    " Value as on ${Utils.getFormattedDate(date: selectedStartDate)}",
                value:
                    "$rupee ${Utils.formatNumber(debtStartDate.round(), isAmount: false)}",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title:
                    "Inv. Cost as ${Utils.getFormattedDate(date: selectedEndDate)}",
                value:
                    "$rupee ${Utils.formatNumber(debtEndValue.round(), isAmount: false)}",
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title:
                    " Value as on ${Utils.getFormattedDate(date: selectedEndDate)}",
                value:
                    "$rupee ${Utils.formatNumber(debtEndDate.round(), isAmount: false)}",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "XIRR",
                value: "${debtCagr.toStringAsFixed(2)}%",
                alignment: CrossAxisAlignment.start,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: (debtCagr > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
              ),
              ColumnText(
                title: "Abs Rtn",
                value: "${debtabsRtn.toStringAsFixed(2)}%",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: (debtabsRtn > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget debtCard(Map data) {
    String shortName = data['scheme_amfi_short_name'] ?? "";
    String folioNo = data['foliono'] ?? "";
    String amcLogo = data['amc_logo'] ?? "";
    String startValue = data['currValueStartDate'] ?? "0";
    String endValue = data['currValueEndDate'] ?? "0";

    String invCostStartDate = data['invCostStartDate'] ?? "0";
    String currValueStartDate = data['currValueStartDate'] ?? "0";
    String invCostEndDate = data['invCostEndDate'] ?? "0";
    String currValueEndDate = data['currValueEndDate'] ?? "0";

    num realisedGainLoss = data['realisedGainLoss'] ?? 0;
    num totalInflow = data['totalInflow'] ?? 0;
    num totalOutflow = data['totalOutflow'] ?? 0;
    num dividendPaid = data['dividendPaid'] ?? 0;

    num absoluteReturn = data['absolute_return'] ?? 0;
    num xirr = data['cagr'] ?? 0;

    return InkWell(
      onTap: () {
        showXirrReportBottomSheet(
            shortName,
            folioNo,
            amcLogo,
            startValue,
            selectedStartDate,
            invCostStartDate,
            currValueStartDate,
            selectedEndDate,
            invCostEndDate,
            currValueEndDate,
            realisedGainLoss,
            totalInflow,
            totalOutflow,
            dividendPaid,
            absoluteReturn,
            xirr);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(amcLogo, height: 32),
                SizedBox(width: 8),
                Expanded(
                  child: ColumnText(
                    title: shortName,
                    value: "Folio : $folioNo",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Config.appTheme.placeHolderInputTitleAndArrow,
                )
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnText(
                    title: "Start Value",
                    value:
                        "$rupee ${Utils.formatNumber(double.parse(startValue).round(), isAmount: false)}"),
                ColumnText(
                  title: "End Value",
                  value:
                      "$rupee ${Utils.formatNumber(double.parse(endValue).round(), isAmount: false)}",
                  alignment: CrossAxisAlignment.center,
                ),
                ColumnText(
                  title: "${xirrMap[xirrType]}",
                  value: "${(data[xirrType] ?? 0.0).toStringAsFixed(2)}%",
                  alignment: CrossAxisAlignment.end,
                  valueStyle: AppFonts.f50014Black.copyWith(
                      color: (data[xirrType] > 0)
                          ? Config.appTheme.defaultProfit
                          : Config.appTheme.defaultLoss),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget hybridArea() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (selectedScheme == "Hybrid") ? SizedBox(height: 16) : SizedBox(),
          hybridBlackCard(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: hybridList.length,
            itemBuilder: (context, index) {
              Map data = hybridList[index];
              return hybridCard(data);
            },
          ),
        ],
      ),
    );
  }

  Container hybridBlackCard() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Color(0xffF8DFD5),
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(Icons.bar_chart, color: Colors.red, size: 20)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Hybrid Schemes (${hybridList.length})",
                  style: AppFonts.f50014Black.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title:
                    "Inv. Cost as ${Utils.getFormattedDate(date: selectedStartDate)}",
                value:
                    "$rupee ${Utils.formatNumber(hybridStartValue.round(), isAmount: false)}",
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title:
                    " Value as on ${Utils.getFormattedDate(date: selectedStartDate)}",
                value:
                    "$rupee ${Utils.formatNumber(hybridStartDate.round(), isAmount: false)}",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title:
                    "Inv. Cost as ${Utils.getFormattedDate(date: selectedEndDate)}",
                value:
                    "$rupee ${Utils.formatNumber(hybridEndValue.round(), isAmount: false)}",
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title:
                    " Value as on ${Utils.getFormattedDate(date: selectedEndDate)}",
                value:
                    "$rupee ${Utils.formatNumber(hybridEndDate.round(), isAmount: false)}",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "XIRR",
                value: "${hybridCagr.toStringAsFixed(2)}%",
                alignment: CrossAxisAlignment.start,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: (hybridCagr > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
              ),
              ColumnText(
                title: "Abs Rtn",
                value: "${hybridabsRtn.toStringAsFixed(2)}%",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: (hybridabsRtn > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget hybridCard(Map data) {
    String shortName = data['scheme_amfi_short_name'] ?? "";
    String folioNo = data['foliono'] ?? "";
    String amcLogo = data['amc_logo'] ?? "";
    String startValue = data['currValueStartDate'] ?? "0";
    String endValue = data['currValueEndDate'] ?? "0";

    String invCostStartDate = data['invCostStartDate'] ?? "0";
    String currValueStartDate = data['currValueStartDate'] ?? "0";
    String invCostEndDate = data['invCostEndDate'] ?? "0";
    String currValueEndDate = data['currValueEndDate'] ?? "0";

    num realisedGainLoss = data['realisedGainLoss'] ?? "0";
    num totalInflow = data['totalInflow'] ?? 0;
    num totalOutflow = data['totalOutflow'] ?? 0;
    num dividendPaid = data['dividendPaid'] ?? 0;

    num absoluteReturn = data['absolute_return'] ?? 0;
    num xirr = data['cagr'] ?? 0;

    return InkWell(
      onTap: () {
        showXirrReportBottomSheet(
            shortName,
            folioNo,
            amcLogo,
            startValue,
            selectedStartDate,
            invCostStartDate,
            currValueStartDate,
            selectedEndDate,
            invCostEndDate,
            currValueEndDate,
            realisedGainLoss,
            totalInflow,
            totalOutflow,
            dividendPaid,
            absoluteReturn,
            xirr);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(amcLogo, height: 32),
                SizedBox(width: 8),
                Expanded(
                  child: ColumnText(
                    title: shortName,
                    value: "Folio : $folioNo",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Config.appTheme.placeHolderInputTitleAndArrow,
                )
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnText(
                    title: "Start Value",
                    value:
                        "$rupee ${Utils.formatNumber(double.parse(startValue).round(), isAmount: false)}"),
                ColumnText(
                  title: "End Value",
                  value:
                      "$rupee ${Utils.formatNumber(double.parse(endValue).round(), isAmount: false)}",
                  alignment: CrossAxisAlignment.center,
                ),
                ColumnText(
                  title: "${xirrMap[xirrType]}",
                  value: "${(data[xirrType] ?? 0.0).toStringAsFixed(2)}%",
                  alignment: CrossAxisAlignment.end,
                  valueStyle: AppFonts.f50014Black.copyWith(
                      color: (data[xirrType] > 0)
                          ? Config.appTheme.defaultProfit
                          : Config.appTheme.defaultLoss),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget solutionArea() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          solutionBlackCard(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: solutionList.length,
            itemBuilder: (context, index) {
              Map data = solutionList[index];
              return solutionCard(data);
            },
          ),
        ],
      ),
    );
  }

  Container solutionBlackCard() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Color(0xffF8DFD5),
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(Icons.bar_chart, color: Colors.red, size: 20)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Solution (${solutionList.length})",
                  style: AppFonts.f50014Black.copyWith(color: Colors.white),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Config.appTheme.placeHolderInputTitleAndArrow,
              )
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title:
                    "Inv. Cost as ${Utils.getFormattedDate(date: selectedStartDate)}",
                value:
                    "$rupee ${Utils.formatNumber(solutionStartValue.round(), isAmount: false)}",
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title:
                    " Value as on ${Utils.getFormattedDate(date: selectedStartDate)}",
                value:
                    "$rupee ${Utils.formatNumber(solutionStartDate.round(), isAmount: false)}",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title:
                    "Inv. Cost as ${Utils.getFormattedDate(date: selectedEndDate)}",
                value:
                    "$rupee ${Utils.formatNumber(solutionEndValue.round(), isAmount: false)}",
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title:
                    " Value as on ${Utils.getFormattedDate(date: selectedEndDate)}",
                value:
                    "$rupee ${Utils.formatNumber(solutionEndDate.round(), isAmount: false)}",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "XIRR",
                value: "${solutionCagr.toStringAsFixed(2)}%",
                alignment: CrossAxisAlignment.start,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: (solutionCagr > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
              ),
              ColumnText(
                title: "Abs Rtn",
                value: "${solutionabsRtn.toStringAsFixed(2)}%",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: (solutionabsRtn > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget solutionCard(Map data) {
    String shortName = data['scheme_amfi_short_name'] ?? "";
    String folioNo = data['foliono'] ?? "";
    String amcLogo = data['amc_logo'] ?? "";
    String startValue = data['currValueStartDate'] ?? "0";
    String endValue = data['currValueEndDate'] ?? "0";
    String invCostStartDate = data['invCostStartDate'] ?? "0";
    String currValueStartDate = data['currValueStartDate'] ?? "0";
    String invCostEndDate = data['invCostEndDate'] ?? "0";
    String currValueEndDate = data['currValueEndDate'] ?? "0";

    num realisedGainLoss = data['realisedGainLoss'] ?? 0;
    num totalInflow = data['totalInflow'] ?? 0;
    num totalOutflow = data['totalOutflow'] ?? 0;
    num dividendPaid = data['dividendPaid'] ?? 0;

    num absoluteReturn = data['absolute_return'] ?? 0;
    num xirr = data['cagr'] ?? 0;

    return InkWell(
      onTap: () {
        showXirrReportBottomSheet(
            shortName,
            folioNo,
            amcLogo,
            startValue,
            selectedStartDate,
            invCostStartDate,
            currValueStartDate,
            selectedEndDate,
            invCostEndDate,
            currValueEndDate,
            realisedGainLoss,
            totalInflow,
            totalOutflow,
            dividendPaid,
            absoluteReturn,
            xirr);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(amcLogo, height: 32),
                SizedBox(width: 8),
                Expanded(
                  child: ColumnText(
                    title: shortName,
                    value: "Folio : $folioNo",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Config.appTheme.placeHolderInputTitleAndArrow,
                )
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnText(
                    title: "Start Value",
                    value:
                        "$rupee ${Utils.formatNumber(double.parse(startValue).round(), isAmount: false)}"),
                ColumnText(
                  title: "End Value",
                  value:
                      "$rupee ${Utils.formatNumber(double.parse(endValue).round(), isAmount: false)}",
                  alignment: CrossAxisAlignment.center,
                ),
                ColumnText(
                  title: "${xirrMap[xirrType]}",
                  value: "${(data[xirrType] ?? 0.0).toStringAsFixed(2)}%",
                  alignment: CrossAxisAlignment.end,
                  valueStyle: AppFonts.f50014Black.copyWith(
                      color: (data[xirrType] > 0)
                          ? Config.appTheme.defaultProfit
                          : Config.appTheme.defaultLoss),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget othersArea() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          othersBlackCard(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: othersList.length,
            itemBuilder: (context, index) {
              Map data = othersList[index];
              return othersCard(data);
            },
          ),
        ],
      ),
    );
  }

  Container othersBlackCard() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Color(0xffF8DFD5),
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(Icons.bar_chart, color: Colors.red, size: 20)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Others Schemes (${othersList.length})",
                  style: AppFonts.f50014Black.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title:
                    "Inv. Cost as ${Utils.getFormattedDate(date: selectedStartDate)}",
                value:
                    "$rupee ${Utils.formatNumber(othersStartValue.round(), isAmount: false)}",
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title:
                    " Value as on ${Utils.getFormattedDate(date: selectedStartDate)}",
                value:
                    "$rupee ${Utils.formatNumber(othersStartDate.round(), isAmount: false)}",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title:
                    "Inv.Cost as ${Utils.getFormattedDate(date: selectedEndDate)}",
                value:
                    "$rupee ${Utils.formatNumber(othersEndValue.round(), isAmount: false)}",
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title:
                    " Value as on ${Utils.getFormattedDate(date: selectedEndDate)}",
                value:
                    "$rupee ${Utils.formatNumber(othersEndDate.round(), isAmount: false)}",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "XIRR",
                value: "${othersCagr.toStringAsFixed(2)}%",
                alignment: CrossAxisAlignment.start,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: (othersCagr > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
              ),
              ColumnText(
                title: "Abs Rtn",
                value: "${othersabsRtn.toStringAsFixed(2)}%",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: (othersabsRtn > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget othersCard(Map data) {
    String shortName = data['scheme_amfi_short_name'] ?? "";
    String folioNo = data['foliono'] ?? "";
    String amcLogo = data['amc_logo'] ?? "";
    String startValue = data['currValueStartDate'] ?? "0";
    String endValue = data['currValueEndDate'] ?? "0";
    String invCostStartDate = data['invCostStartDate'] ?? "0";
    String currValueStartDate = data['currValueStartDate'] ?? "0";
    String invCostEndDate = data['invCostEndDate'] ?? "0";
    String currValueEndDate = data['currValueEndDate'] ?? "0";

    num realisedGainLoss = data['realisedGainLoss'] ?? 0;
    num totalInflow = data['totalInflow'] ?? 0;
    num totalOutflow = data['totalOutflow'] ?? 0;
    num dividendPaid = data['dividendPaid'] ?? 0;

    num absoluteReturn = data['absolute_return'] ?? 0;
    num xirr = data['cagr'] ?? 0;

    return InkWell(
      onTap: () {
        showXirrReportBottomSheet(
            shortName,
            folioNo,
            amcLogo,
            startValue,
            selectedStartDate,
            invCostStartDate,
            currValueStartDate,
            selectedEndDate,
            invCostEndDate,
            currValueEndDate,
            realisedGainLoss,
            totalInflow,
            totalOutflow,
            dividendPaid,
            absoluteReturn,
            xirr);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(amcLogo, height: 32),
                SizedBox(width: 8),
                Expanded(
                  child: ColumnText(
                    title: shortName,
                    value: "Folio : $folioNo",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Config.appTheme.placeHolderInputTitleAndArrow,
                )
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnText(
                    title: "Start Value",
                    value:
                        "$rupee ${Utils.formatNumber(double.parse(startValue).round(), isAmount: false)}"),
                ColumnText(
                  title: "End Value",
                  value:
                      "$rupee ${Utils.formatNumber(double.parse(endValue).round(), isAmount: false)}",
                  alignment: CrossAxisAlignment.center,
                ),
                ColumnText(
                  title: "${xirrMap[xirrType]}",
                  value: "${(data[xirrType] ?? 0.0).toStringAsFixed(2)}%",
                  alignment: CrossAxisAlignment.end,
                  valueStyle: AppFonts.f50014Black.copyWith(
                      color: (data[xirrType] > 0)
                          ? Config.appTheme.defaultProfit
                          : Config.appTheme.defaultLoss),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget topArea() {
    return Container(
      //color: Config.appTheme.themeColor,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Investor: ",
                  style: AppFonts.f40013
                      .copyWith(color: Colors.white, fontSize: 13),
                ),
                TextSpan(
                  text: investorName,
                  style: AppFonts.f50012.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: typeList.length,
              itemBuilder: (context, index) {
                String type = typeList[index];
                if (selectedType == type)
                  return getButton(text: type, type: ButtonType.filled);
                return getButton(text: type, type: ButtonType.plain);
              },
              separatorBuilder: (BuildContext context, int index) => SizedBox(
                width: 16,
                height: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map xirrMap = {'cagr': "XIRR", 'absolute_return': "Abs Return"};
  String xirrType = "cagr";

  Widget getButton({required String text, required ButtonType type}) {
    EdgeInsets padding = EdgeInsets.symmetric(horizontal: 16);
    if (type == ButtonType.plain) {
      return PlainRButton(
        text: text,
        padding: padding,
        onPressed: () {
          selectedType = text;
          int indexOfSpace = text.indexOf(' ');
          selectedScheme = text.substring(0, indexOfSpace);
          print("selectedScheme $selectedScheme");
          selectedSort = "";
          setState(() {});
        },
      );
    } else {
      return RpFilledRButton(text: text, padding: padding);
    }
  }

  bool showDetails = false;

  Widget middleArea() {
    return Container(
      // color: Config.appTheme.themeColor,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "As on ${Utils.getFormattedDate(date: selectedStartDate)}",
            style: AppFonts.f40013.copyWith(color: Config.appTheme.overlay85),
          ),
          SizedBox(height: 10),
          summaryRow(
              initial: "A",
              bgColor: Color(0xFF4155B9),
              title: "Investment Cost",
              value: Utils.formatNumber(totalInvCost)),
          SizedBox(
            height: 5,
          ),
          summaryRow(
              initial: "B",
              bgColor: Color(0xFF4155B9),
              title: "Investment Value",
              value: Utils.formatNumber(totalCurrVal)),
          DottedLine(
            verticalPadding: 4,
          ),
          Text(
            "As on ${Utils.getFormattedDate(date: selectedEndDate)}",
            style: AppFonts.f40013.copyWith(color: Config.appTheme.overlay85),
          ),
          SizedBox(height: 5),
          summaryRow(
              initial: "C",
              bgColor: Color(0xFFFF6F61),
              title: "Investment Cost",
              value: Utils.formatNumber(invCostAsOn)),
          summaryRow(
              initial: "D",
              bgColor: Color(0xFFFF6F61),
              title: "Current Value",
              value: Utils.formatNumber(currValAsOn)),
          DottedLine(
            verticalPadding: 4,
          ),
          Row(
            children: [
              InitialCard(
                bgColor: Color(0xFF3C9AB6),
                title: "E",
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  whiteText("Purchase"),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  whiteText("$rupee ${Utils.formatNumber(purchase.round())}"),
                  GestureDetector(
                    onTap: () {
                      showDetails = !showDetails;
                      setState(() {});
                    },
                    child: Text(
                      "${(showDetails) ? "Hide" : "View"} Details",
                      style: AppFonts.f40013.copyWith(
                          color: Colors.yellow,
                          decorationColor: Colors.yellow,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 12),
          Visibility(
              visible: showDetails,
              child: Column(
                children: [
                  summaryRow(
                      initial: "F",
                      bgColor: Color(0xFF5DB25D),
                      title: "Redemption",
                      value: Utils.formatNumber(redemption.round())),
                  summaryRow(
                      initial: "G",
                      bgColor: Color(0xFFE79C23),
                      title: "Dividend Pay",
                      value: Utils.formatNumber(divPay.round())),
                  summaryRow(
                      initial: "H",
                      bgColor: Color(0xFFE79C23),
                      title: "Gain/Loss \n(D-B)-(E)+F+G",
                      value: Utils.formatNumber(gainLoss)),
                ],
              )),
          DottedLine(
            verticalPadding: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Absolute Return",
                value:
                    "${individualXirrResponse.totalAbsRet?.toStringAsFixed(2) ?? 0}%",
                alignment: CrossAxisAlignment.start,
                titleStyle: AppFonts.f40013.copyWith(color: Colors.white),
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: (individualXirrResponse.totalAbsRet != null &&
                            individualXirrResponse.totalAbsRet! > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
              ),
              ColumnText(
                title: "XIRR",
                value:
                    "${individualXirrResponse.totalXirr?.toStringAsFixed(2) ?? 0}%",
                alignment: CrossAxisAlignment.end,
                titleStyle: AppFonts.f40013.copyWith(color: Colors.white),
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: (individualXirrResponse.totalXirr != null &&
                            individualXirrResponse.totalXirr! > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget summaryRow({
    required String initial,
    required Color bgColor,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          InitialCard(title: (initial == "") ? "." : initial, bgColor: bgColor),
          SizedBox(width: 10),
          whiteText(title),
          Spacer(),
          whiteText("$rupee $value")
        ],
      ),
    );
  }

  Widget whiteText(String text) {
    return Text(
      text,
      style: AppFonts.f50014Black.copyWith(color: Colors.white),
    );
  }

  Widget summaryRowBlack({
    required String initial,
    required Color bgColor,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          InitialCard(title: (initial == "") ? "." : initial, bgColor: bgColor),
          SizedBox(width: 10),
          blackText(title),
          Spacer(),
          blackText("$rupee $value")
        ],
      ),
    );
  }

  Widget blackText(String text) {
    return Text(
      text,
      style: AppFonts.f50014Black.copyWith(color: Colors.black),
    );
  }
}

class PlainRButton extends StatelessWidget {
  const PlainRButton(
      {super.key, required this.text, this.onPressed, this.padding});
  final String text;
  final Function()? onPressed;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.sizeOf(context).width;

    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: padding ??
            EdgeInsets.symmetric(horizontal: devWidth * 0.15, vertical: 2),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppFonts.f50014Black.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class RpFilledRButton extends StatelessWidget {
  const RpFilledRButton(
      {super.key, this.onPressed, required this.text, this.padding});

  final Function()? onPressed;
  final EdgeInsets? padding;
  final String text;
  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.sizeOf(context).width;

    return InkWell(
      onTap: onPressed,
      child: Container(
          padding: padding ??
              EdgeInsets.symmetric(horizontal: devWidth * 0.15, vertical: 2),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppFonts.f50014Black
                .copyWith(color: Config.appTheme.themeColor),
          ))),
    );
  }
}
