import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/advisor/WebViewContent.dart';
import 'package:mymfbox2_0/api/ResearchApi.dart';
import 'package:mymfbox2_0/pojo/SchemeInfoPojo.dart';
import 'package:mymfbox2_0/rp_widgets/AmcChip.dart';
import 'package:mymfbox2_0/rp_widgets/AppBarColumn.dart';
import 'package:mymfbox2_0/rp_widgets/PercentageBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/SelectedAmcChip.dart';
import 'package:mymfbox2_0/rp_widgets/ViewAllBtn.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';

// ignore: must_be_immutable
class SchemeInfo extends StatefulWidget {
  SchemeInfo(
      {super.key, this.schemeName, this.schemeShortName, this.schemeLogo});

  String? schemeName;
  String? schemeShortName;
  String? schemeLogo;

  @override
  State<SchemeInfo> createState() => _SchemeInfoState();
}

class _SchemeInfoState extends State<SchemeInfo> {
  final SchemeInfoController schemeInfoController =
      Get.put(SchemeInfoController());

  String client_name = GetStorage().read('client_name');

  int user_id = getUserId();

  late double devWidth, devHeight;

  List allCategories = [];

  String schemeName = "";
  String schemeShortName = "";
  late String schemeLogo;

  TextEditingController startDateController = TextEditingController();
  String startDate = "15-04-2019";

  String factsheetName = "";
  String portfolioName = "";
  String factsheetLink = "";
  String portfolioLink = "";

  num returnsLumpsumProfitLoss = 0;
  num returnsLumpsumCurrValue = 0;
  num returnsSipProfitLoss = 0;
  num returnsSipCurrValue = 0;

  String formattedChartDate = "";
  String schemeChartName = "";
  int noOfMonths = 30;

  List chartRollingReturnBenchmarkList = [];
  final List<String> months = [];
  List<double> series1Data = [];
  List<double> series2Data = [];

  bool isLoading = false;
  bool isLoadingLumpsumSip = false;

  TextStyle underlineText = TextStyle(
      color: Config.appTheme.themeColor,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w500,
      fontSize: 14);
  late TextEditingController lumpsumAmountController;

  List<Map<String, dynamic>> historicalTableData = [];
  List<Map<String, dynamic>> peerComparisionTableData = [];
  List lumpsumReturnsList = [];
  List sipReturnsList = [];
  Map assetAllocationMap = {};
  Map schemeMap = {};
  List creditRateList = [];
  Map<String, dynamic> amcDetails = {};

  List<Map<String, dynamic>> percentageData = [
    {"percent": 20.0, "color": Colors.red},
    {"percent": 30.0, "color": Colors.blue},
    {"percent": 15.0, "color": Colors.green},
    {"percent": 25.0, "color": Colors.orange},
    {"percent": 10.0, "color": Colors.purple},
  ];

  List<Color> colorPalate = [
    Color(0XFF4155B9),
    Color(0xFFE79C23),
    Color(0xFF3C9AB6),
    Color(0xFF5DB25D),
    Color(0xFFDE5E2F),
    Colors.redAccent,
    Colors.greenAccent,
    Colors.deepPurple,
    Colors.black,
    Colors.teal
  ];

  /*Map portfolioAnalysis = {};
  Future getPortfolioAnalysis() async {
    if (portfolioAnalysis.isNotEmpty) return 0;

    Map data = await ResearchApi.getPortfolioAnalysis(
      user_id: user_id,
      client_name: client_name,
      scheme: schemeName,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    portfolioAnalysis = data;

    return 0;
  }*/

  @override
  void initState() {
    super.initState();

    lumpsumAmountController = TextEditingController(text: "10000");
    schemeName = widget.schemeName!;
    schemeShortName = widget.schemeShortName ?? "";
    schemeLogo = widget.schemeLogo!;

    getDatas();
  }

  String convertDateFormat(String inputDateStr) {
    DateFormat inputFormat = DateFormat("dd-MMM-yyyy");
    DateFormat outputFormat = DateFormat("dd-MM-yyyy");

    DateTime inputDate = inputFormat.parse(inputDateStr);
    String outputDateStr = outputFormat.format(inputDate);

    return outputDateStr;
  }

  Future getDatas() async {
    await Future.wait([
      schemeInfoController.getSchemeInfo(
        userId: user_id,
        clientName: client_name,
        schemeShortName: schemeShortName,
      ),
      schemeInfoController.getNavMovementGraph(
        userId: user_id,
        clientName: client_name,
        schemeName: schemeName,
      ),
      schemeInfoController.getPortfolioAnalysis(
        // Add this
        userId: user_id,
        clientName: client_name,
        schemeName: schemeName,
      ),
    ]);

    await Future.wait([
      schemeInfoController.getLumpsumReturnsPeriodAndAmount(
        userId: user_id,
        clientName: client_name,
        schemeName: schemeName,
      ),
      schemeInfoController.getSipReturnsPeriodAndAmount(
        userId: user_id,
        clientName: client_name,
        schemeName: schemeName,
      ),
    ]);

    schemeInfoController.getReturnsTableCalc(schemeName);
  }

  formatDate(DateTime dt) {
    return DateFormat("dd MMM yyyy").format(dt);
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: AppBar(
        backgroundColor: Config.appTheme.themeColor,
        leadingWidth: 0,
        toolbarHeight: 120,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: SizedBox(),
        title: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Icon(Icons.arrow_back),
                  onTap: () {
                    Get.back();
                  },
                ),
                /*Spacer(),
                GestureDetector(
                  onTap: () {
                    showReportActionBottomSheet();
                  },
                  child: Icon(Icons.pending_outlined),
                ),*/
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                //Image.network(schemeLogo, height: 32),
                SizedBox(width: 8),
                Expanded(
                  child: Obx(
                    () => ColumnText(
                      title: schemeShortName.replaceAll("%26", "&"),
                      value:
                          "${schemeInfoController.category.replaceAll(":", " •")} • ${schemeInfoController.scheme_status}",
                      titleStyle: AppFonts.f50014Black
                          .copyWith(fontSize: 18, color: Colors.white),
                      valueStyle: AppFonts.f40013.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      body: Obx(() => displayPage()),
      //body: Container(),
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
                /* if (type == ReportType.DOWNLOAD) {
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
                  rpDownloadFile(
                      url: data['msg'], context: context, index: index);
                } */
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

  List reportActions = [
    {
      'title': "Download Fund Card",
      'img': "assets/pdf.png",
      'type': ReportType.DOWNLOAD,
    },
  ];

  Widget displayPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Stack(
              children: [
                Obx(() => schemeInfoController.isSchemeInfoLoading.value
                    ? Utils.shimmerWidget(50,
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 16))
                    : navDateAndReturns()),
                Obx(() => schemeInfoController.isLoadingNavGraph.value
                    ? Utils.shimmerWidget(200,
                        margin: EdgeInsets.fromLTRB(16, 64, 16, 16))
                    : rpChart(funChartData: schemeInfoController.chartData)),
              ],
            ),
            SizedBox(height: 0),
            chartToggleCard(),
            Container(
              margin: EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //SizedBox(height: 12),
                  Text(
                    "Historical Returns",
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.readableGreyTitle),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 12),

                  Obx(() => schemeInfoController.isSchemeInfoLoading.value
                      ? Utils.shimmerWidget(devHeight * 0.2,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0))
                      : historicalDataTable()),

                  SizedBox(height: 12),

                  Text(
                    "Scheme Details",
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.readableGreyTitle),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 12),

                  Obx(() => schemeInfoController.isSchemeInfoLoading.value
                      ? Utils.shimmerWidget(devHeight * 0.2,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0))
                      : schemeSummaryCard()),

                  SizedBox(height: 12),

                  Text(
                    "Returns Calculator",
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.readableGreyTitle),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 12),
                  returnsCalculatorCard(),
                  SizedBox(height: 12),
                  if (client_name != 'shreetrustcapital') ...[
                    Text(
                      "Peer Comparison",
                      style: AppFonts.f50014Black
                          .copyWith(color: Config.appTheme.readableGreyTitle),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 12),
                    Obx(() => schemeInfoController.isSchemeInfoLoading.value
                        ? Utils.shimmerWidget(devHeight * 0.3,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0))
                        : peerDataTable()),
                  ],
                  SizedBox(height: 12),
                  Text(
                    "Sectors & Holdings",
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.readableGreyTitle),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 12),

                  Obx(() => schemeInfoController.isSchemeInfoLoading.value
                      ? Utils.shimmerWidget(devHeight * 0.3,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0))
                      : sectorHoldingsCard()),

                  SizedBox(height: 12),

                  Text(
                    "Holdings Distribution",
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.readableGreyTitle),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 12),

                  Obx(() => schemeInfoController.isSchemeInfoLoading.value
                      ? Utils.shimmerWidget(devHeight * 0.3,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0))
                      : holdingsDistributionCard()),

                  SizedBox(height: 12),

                  Text(
                    "Investment Objective",
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.readableGreyTitle),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 12),

                  investmentObjectiveCard(),

                  SizedBox(height: 12),

                  Text(
                    "Risk-O-Meter",
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.readableGreyTitle),
                    textAlign: TextAlign.left,
                  ),

                  SizedBox(height: 12),

                  riskometerCard(),

                 /* SizedBox(height: 12),

                  Text(
                    "AMC Details",
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.readableGreyTitle),
                    textAlign: TextAlign.left,
                  ),

                  SizedBox(height: 12),

                  schemeInfoController.amcDetailsCard(),*/

                  SizedBox(height: 12),

                  disclaimersCard(),

                  SizedBox(height: 32)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chartToggleCard() {
    return Center(
      child: ToggleSwitch(
        minWidth: 100,
        minHeight: 50,
        initialLabelIndex: schemeInfoController.chartFilterList
            .indexOf(schemeInfoController.selectedChartPeriod.value),
        onToggle: (val) async {
          if (val != null) {
            schemeInfoController.updateChartPeriod(
                schemeInfoController.chartFilterList[val], schemeName);
          }
        },
        labels: schemeInfoController.chartFilterList,
        activeBgColor: [Colors.black],
        inactiveBgColor: Colors.white,
        borderColor: [Colors.grey.shade300],
        borderWidth: 1,
        dividerColor: Colors.grey.shade300,
      ),
    );
  }

  Widget navDateAndReturns() {
    if (schemeInfoController.schemeInfoPojo.value.navChangePercentage == null)
      return Utils.shimmerWidget(250);

    num? navChangePercentage =
        schemeInfoController.schemeInfoPojo.value.navChangePercentage;
    bool isNegative = navChangePercentage!.isNegative;

    bool isReturnsNegative = schemeInfoController.chartReturns.isNegative;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Nav as on ${schemeInfoController.schemeInfoPojo.value.navDate}",
                  style: AppFonts.f40013),
              Row(
                children: [
                  Text(
                      "$rupee ${schemeInfoController.schemeInfoPojo.value.nav}",
                      style: AppFonts.f50014Black),
                  Text(" ($navChangePercentage%)",
                      style: AppFonts.f50014Black.copyWith(
                        color: (isNegative)
                            ? Config.appTheme.defaultLoss
                            : Config.appTheme.defaultProfit,
                      )),
                ],
              ),
            ],
          ),
          ColumnText(
            title: "${schemeInfoController.selectedChartPeriod} Returns",
            value: "${schemeInfoController.chartReturns}%",
            valueStyle: AppFonts.f50014Black.copyWith(
              color: (isReturnsNegative)
                  ? Config.appTheme.defaultLoss
                  : Config.appTheme.defaultProfit,
            ),
          )
        ],
      ),
    );
  }

  Widget riskometerCard() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Image.network(
            schemeInfoController.riskometerImage.value,
            height: 220,
          ),
        ],
      ),
    );
  }

  String sectorHoldings = "Top 10 Sectors";

  Widget sectorHoldingsCard() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            width: devWidth,
            child: Row(
              children: [
                Expanded(
                    child: localAmcChip(
                  value: "Top 10 Sectors",
                  groupValue: schemeInfoController.sectorHoldings.value,
                  onTap: () {
                    schemeInfoController.updateSectorHoldings("Top 10 Sectors");
                  },
                )),
                SizedBox(width: 16),
                Expanded(
                    child: localAmcChip(
                  value: "Top 10 Stocks",
                  groupValue: schemeInfoController.sectorHoldings.value,
                  onTap: () {
                    schemeInfoController.updateSectorHoldings("Top 10 Stocks");
                  },
                ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sectors",
                  style: AppFonts.f40013,
                ),
                Text(
                  "Allocation",
                  style: AppFonts.f40013,
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          sectorHoldingsArea(schemeInfoController.sectorHoldings.value),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ViewAllBtn(
                text:
                    "View ${(schemeInfoController.viewAllSector.value) ? "Less" : "More"}",
                onTap: () {
                  schemeInfoController.toggleViewAllSector();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool viewAllSector = false;

  Widget sectorHoldingsArea(String title) {
    double totalWidth = devWidth - 64;
    String key = schemeInfoController.getKeyFromTitle(title);
    if(key == 'top_10_sectors'){
      key = 'top_sectors';
    }else{
      key = 'top_holdings';
    }
    List list = schemeInfoController.portfolioAnalysis[key] ?? [];
    if (list.isEmpty) return SizedBox();

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: (schemeInfoController.viewAllSector.value) ? list.length : 5,
      itemBuilder: (context, index) {
        Map map = list[index];
        String? temp = map['title'];
        double percentage = map['value'];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text("$temp", style: AppFonts.f40013)),
                Text("$percentage %", style: AppFonts.f40013)
              ],
            ),
            PercentageBar(percentage, width: totalWidth)
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(height: 16),
    );
  }

  String getKeyFromTitle(String title) {
    title = title.toLowerCase();
    return title.replaceAll(" ", "_");
  }

  localAmcChip({
    required String value,
    Function()? onTap,
    required String groupValue,
  }) {
    bool isSelected = groupValue == value;
    Color bgColor =
        (isSelected) ? Config.appTheme.themeColor : Config.appTheme.Bg2Color;
    Color fgColor = (isSelected) ? Colors.white : Colors.black;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            value,
            style: AppFonts.f50014Black.copyWith(color: fgColor),
          ),
        ),
      ),
    );
  }

  Widget holdingsDistributionCard() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.fromLTRB(16, 16, 8, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: schemeInfoController.holdingsDistributionList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                String title =
                    schemeInfoController.holdingsDistributionList[index];

                return (schemeInfoController.holdingsDistribution == title)
                    ? SelectedAmcChip(title: title, value: "", hasValue: false)
                    : AmcChip(
                        title: title,
                        value: "",
                        hasValue: false,
                        onTap: () {
                          //holdingsDistribution = title;

                          schemeInfoController
                              .updateHoldingsDistribution(title);
                        },
                      );
              },
            ),
          ),
          SizedBox(height: 16),
          holdingDistributionBar(
              schemeInfoController.holdingsDistribution.value),
          SizedBox(height: 16),
          holdingsDistributionArea(
              schemeInfoController.holdingsDistribution.value),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget holdingDistributionBar(String title) {
    String key = getKeyFromTitle(title);
    List list = schemeInfoController.portfolioAnalysis[key] ?? [];
    num totalWidth = devWidth - 65;
    print("totalWidth $totalWidth");

    return SizedBox(
      height: 40,
      child: ListView.builder(
        itemCount: list.length,
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          Map map = list[index];
          num percentage = map['value'];
          print("percentange $percentage");
          int colorIndex = index;
          if (index > colorPalate.length)
            colorIndex = index % colorPalate.length;

          return Container(
            width: (percentage * totalWidth) / 100,
            height: 40,
            color: colorPalate[colorIndex],
            margin: EdgeInsets.only(right: 1),
          );
        },
      ),
    );
  }

  Widget holdingsDistributionArea(String title) {
    String key = getKeyFromTitle(title);
    List list = schemeInfoController.portfolioAnalysis[key] ?? [];

    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          Map map = list[index];
          String? temp = map['title'];
          num percentage = map['value'];

          int colorIndex = index;
          if (index > colorPalate.length)
            colorIndex = index % colorPalate.length;

          return Row(
            children: [
              Icon(Icons.circle, size: 12, color: colorPalate[colorIndex]),
              SizedBox(width: 8),
              Text("$temp", style: AppFonts.f50014Black),
              Spacer(),
              Text("${percentage.toStringAsFixed(2)}%",
                  style: AppFonts.f50014Black)
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            DottedLine(verticalPadding: 4),
      ),
    );
  }

  Widget schemeSummaryCard() {
    num totalAsset = schemeInfoController.aum.value as num;
    print("total Asset $totalAsset");
    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 4,
                  child: ColumnText(
                      title:
                          "Age (Since ${schemeInfoController.formattedschemeInceptionDate})",
                      value: schemeInfoController.formattedYearsMonth.value)),
              Expanded(
                  flex: 3,
                  child: ColumnText(
                      title: "Asset Class",
                      value: schemeInfoController.assetClass.value,
                      alignment: CrossAxisAlignment.start)),
            ],
          ),
          DottedLine(verticalPadding: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 4,
                  child: ColumnText(
                    alignment: CrossAxisAlignment.start,
                    title: "Min Investment",
                    value:
                        "$rupee ${Utils.formatNumber(schemeInfoController.minimumInvestment.round(), isAmount: false)}",
                  )),
              Expanded(
                  flex: 3,
                  child: ColumnText(
                      title: "Min Topup",
                      value:
                          "$rupee ${Utils.formatNumber(schemeInfoController.minimumTopup.round(), isAmount: false)}",
                      alignment: CrossAxisAlignment.center)),
              Expanded(
                  flex: 4,
                  child: ColumnText(
                    alignment: CrossAxisAlignment.end,
                    title: "TER",
                    value: "${schemeInfoController.ter}%",
                  )),
            ],
          ),
          DottedLine(
            verticalPadding: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 4,
                  child: ColumnText(
                      title: "Total Assets",
                      value:
                          "$rupee ${Utils.formatNumber(totalAsset)} Cr As on ${schemeInfoController.assetDate} (Source:AMFI)")),
            ],
          ),
          DottedLine(
            verticalPadding: 4,
          ),
          /* Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ColumnText(title: "Turnover", value: "$schemeTurnover%"),
                  ],
                ),
                DottedLine(
                  verticalPadding: 4,
                ),*/
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: ColumnText(
                  title: "Benchmark",
                  value: schemeInfoController.schemeBenchmark.value,
                  valueStyle:
                      AppFonts.f50014Black.copyWith(color: Colors.black),
                ),
              ),
            ],
          ),
          DottedLine(
            verticalPadding: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 3,
                  child: ColumnText(
                      title: "Exit Load",
                      value: schemeInfoController.exit1.value,
                      valueStyle: AppFonts.f40013.copyWith(color: Colors.black),
                      alignment: CrossAxisAlignment.start)),
            ],
          ),
          /* DottedLine(verticalPadding: 4,),
          Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 250,
                        child: ColumnText(
                            title: "Fund Managers", value: schemeInfoController.schemeManager.value)),
                    */ /*ColumnText(
                        title: "Nav History",
                        value: "Click Here",
                        valueStyle: underlineText,
                        alignment: CrossAxisAlignment.start),*/ /*
                  ],
                ),*/
        ],
      ),
    );
  }

  Widget disclaimersCard() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Config.appTheme.lineColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: devWidth * 0.800,
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Disclaimers: ",
                            style: AppFonts.f50014Black,
                          ),
                          TextSpan(
                            text:
                                "Products compared like fixed deposits may provide fixed guaranteed returns. Mutual Funds investments are subject to market risk. Read all scheme related documents carefully. Past performance is not an indicator of future returns.",
                            style:
                                AppFonts.f40013.copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget investmentObjectiveCard() {
    return isLoading
        ? Utils.shimmerWidget(devHeight * 0.3)
        : Container(
            width: devWidth,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               /* SizedBox(height: 8),
                Text(
                  "Investment Objective",
                  style: AppFonts.f40013,
                ),*/
                Text(
                  schemeInfoController.schemeObjective.value,
                  style: AppFonts.f40013.copyWith(
                    fontSize: 14,
                    color:Colors.black,
                  ),
                  textAlign: TextAlign.justify,
                ),
                /* DottedLine(
                  verticalPadding: 2,
                ),
                Text("Scheme Documents", style: AppFonts.f40013),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    rpDownloadFile(url: factsheetLink, context: context);
                  },
                  child: Text(
                    factsheetName,
                    style: underlineText,
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Get.to(WebviewContent(
                      webViewTitle: schemeName,
                      disqusUrl: portfolioLink,
                    ));
                  },
                  child: Text(
                    portfolioName,
                    style: underlineText,
                  ),
                ),
                SizedBox(height: 16),*/
              ],
            ),
          );
  }

  void showError() {
    Fluttertoast.showToast(
        msg: "Please allow permission to download the file.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Config.appTheme.themeColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> rpDownloadFile(
      {required String url, required BuildContext context}) async {
    EasyLoading.show(status: 'loading...');
    String dirloc = "";

    if (Platform.isIOS) {
      if (await Permission.storage.request().isGranted)
        dirloc = (await getTemporaryDirectory()).path;
      else
        showError();
    }
    // android
    else if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted)
        dirloc = (await getExternalStorageDirectory())?.path ?? "";
      else
        showError();
    }
    EasyLoading.dismiss();
    try {
      final dir = await getExternalStorageDirectory();
      final filename = url.substring(url.lastIndexOf("/") + 1);
      final filePath = '${dir!.path}/$filename';
      final dio = Dio();
      await dio.download(url, filePath);
      final _result = await OpenFile.open(filePath);
      print("Result: $_result");
    } catch (e) {
      print('Error opening PDF: $e');
    }
  }

  String selectedReturns = "Lumpsum";

  Widget returnsCalculatorCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          rcGreenArea(),
          SizedBox(height: 16),
        /*  Obx(() => schemeInfoController.isLoadingReturns.value
              ? Utils.shimmerWidget(100)
              : rcMidGreyArea()),
          SizedBox(height: 16),*/
          Obx(() => schemeInfoController.isLoadingReturns.value
              ? Utils.shimmerWidget(200)
              : rcBottomArea()),
        ],
      ),
    );
  }

  Widget rcGreenArea() {
    return Container(
      padding: EdgeInsets.only(bottom: 24, top: 16),
      decoration: BoxDecoration(
          color: Config.appTheme.themeColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
      child: Column(
        children: [
          // #region radio area
          Row(
            children: [
              Obx(() => Radio(
                    value: "Lumpsum",
                    groupValue: schemeInfoController.selectedReturns.value,
                    onChanged: (value) {
                      schemeInfoController.updateSelectedReturns(
                          value!, schemeName);
                    },
                    activeColor: Colors.white,
                    fillColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                  )),
              Text(
                'Lumpsum',
                style: AppFonts.f50014Black
                    .copyWith(color: Colors.white, fontSize: 18),
              ),
              SizedBox(width: 30),
              Obx(() => Radio(
                    value: "SIP",
                    groupValue: schemeInfoController.selectedReturns.value,
                    onChanged: (value) {
                      schemeInfoController.updateSelectedReturns(
                          value!, schemeName);
                    },
                    activeColor: Colors.white,
                    fillColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                  )),
              Text(
                'SIP',
                style: AppFonts.f50014Black
                    .copyWith(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          // #endregion

          // #region amount & period
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => AppBarColumn(
                      title:
                          "${schemeInfoController.selectedReturns.value} Amount",
                      value: "${schemeInfoController.rcAmount.value}",
                      onTap: () {
                        rcAmountBottomSheet();
                      })),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Obx(() => AppBarColumn(
                      title:
                          "${schemeInfoController.selectedReturns.value} Period",
                      value: "${schemeInfoController.rcPeriod.value} Year",
                      onTap: () {
                        rcPeriodBottomSheet();
                      })),
                ),
              ],
            ),
          ),
          // #endregion
        ],
      ),
    );
  }

  Widget rcMidGreyArea() {
    List list = [];

    list = (schemeInfoController.selectedReturns.value == "Lumpsum")
        ? list = schemeInfoController.lumpsumReturnsList.value
        : list = schemeInfoController.sipReturnsList.value;

    if (list.isEmpty) return SizedBox();
    num profitLoss = list[0]['profit'];
    num currValue = list[0]['current_value'];

    num amount = num.parse(schemeInfoController.rcAmount.value);

    return Container(
      color: Config.appTheme.overlay85,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ColumnText(
              title: "Invested",
              value: "$rupee ${Utils.formatNumber(amount, isAmount: true)}"),
          //roundedIcon("+"),
          ColumnText(
            title: "Profit/Loss",
            value: "$rupee ${Utils.formatNumber(profitLoss, isAmount: true)}",
            valueStyle: AppFonts.f50014Black
                .copyWith(color: Config.appTheme.defaultProfit),
            alignment: CrossAxisAlignment.center,
          ),
          //roundedIcon("="),
          ColumnText(
            title: "Current Value",
            value: "$rupee ${Utils.formatNumber(currValue, isAmount: true)}",
            valueStyle: AppFonts.f50014Theme,
            alignment: CrossAxisAlignment.center,
          ),
        ],
      ),
    );
  }

  Widget roundedIcon(String icon) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: Center(
          child: Text(
        icon,
        style: TextStyle(color: Config.appTheme.themeColor, fontSize: 28),
      )),
    );
  }

  Widget rcBottomArea() {
    List list = [];

    list = (schemeInfoController.selectedReturns.value == "Lumpsum")
        ? schemeInfoController.lumpsumReturnsList.value
        : schemeInfoController.sipReturnsList.value;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          Map map = list[index];
          String title = map['scheme'];
          num percent = map['ann_growth'];

          num amount = map['current_value'];
          //title = Utils.getFirst13(title, count: 20);

          print("title = ${title} ,amount = ${amount} , percent $percent");

          return Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppFonts.f40013,
                        softWrap: true,
                      ),
                    ),
                    Text(
                      "$rupee ${Utils.formatNumber(amount.round())}",
                      style: AppFonts.f40013,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    percentageBar(percent, index),
                    Text(
                      "${percent.toStringAsFixed(2)} %",
                      style: AppFonts.f40013,
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  double multiplier = 10;

  Widget percentageBar(num percent, int index) {
    double total = devWidth * 0.60;
    percent = (total * percent) / 100;
    print("total $total");
    print("percent $percent");

    if (index == 0) multiplier = Utils.getMultiplier(percent.toDouble());

    double multiplierPercent = percent.toDouble();
    // double multiplierPercent = 100.0;
    print("multiplierPercent $multiplierPercent");
    if (multiplierPercent < 0) multiplierPercent = 0;

    return Stack(
      children: [
        Container(
          height: 7,
          width: total,
          decoration: BoxDecoration(
              color: Color(0xffDFDFDF),
              borderRadius: BorderRadius.circular(10)),
        ),
        Container(
          height: 7,
          width: multiplierPercent,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(10)),
        ),
      ],
    );
  }

  Widget returnsCalculatorListArea(
      String title, int index, num currVal, num absGrowth) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(title,
                      style: TextStyle(fontWeight: FontWeight.bold))),
              Text(
                  "$rupee ${Utils.formatNumber(currVal.round(), isAmount: false)}",
                  style: AppFonts.f40013.copyWith(
                      color: index == 0
                          ? Config.appTheme.themeColor
                          : Colors.black,
                      fontWeight: FontWeight.bold))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PercentageBar(double.parse(absGrowth.toString())),
              Text("${absGrowth.toStringAsFixed(2)}%",
                  style: AppFonts.f40013.copyWith(
                      color: index == 0
                          ? Config.appTheme.themeColor
                          : Colors.black)),
            ],
          ),
        ],
      ),
    );
  }

  String getFirst13(String text) {
    String s = text.split(":").last;
    if (s.length > 13) s = s.substring(0, 13);
    return s;
  }

  Widget peerDataTable() {
    return Column(
      children: [
        Scrollbar(
          radius: Radius.circular(10),
          thickness: 5.0,
          thumbVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: devHeight * 0.30,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: DataTable(
                        horizontalMargin: 10,
                        headingRowHeight: 35,
                        headingRowColor:
                            MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            return Config.appTheme.themeColor;
                          },
                        ),
                        columns: [
                          DataColumn(
                            label: SizedBox(
                              width: 50,
                              child: Text(
                                'Fund',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                         /* DataColumn(
                            label: SizedBox(
                              width: 60,
                              child: Text(
                                'Aum (Cr)',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),*/
                          DataColumn(
                            label: SizedBox(
                              width: 100,
                              child: Text(
                                'Inception Date',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: 50,
                              child: Text(
                                '1Y',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: 30,
                              child: Text(
                                '2Y',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: 30,
                              child: Text(
                                '3Y',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: 30,
                              child: Text(
                                '5Y',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: 30,
                              child: Text(
                                '10Y',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                            schemeInfoController
                                .peerComparisionTableData.length, (index) {
                          final rowData = schemeInfoController.peerComparisionTableData[index];
                          String schemeShort =
                              rowData['scheme_amfi_short_name'] ?? "";
                          String amcLogo = rowData['amc_logo'] ?? "";
                          num aum = rowData['scheme_assets'] ?? 0;
                          num oneYear = rowData['returns_abs_1year'] ?? 0;
                          num twoYear = rowData['returns_cmp_2year'] ?? 0;
                          num threeYear = rowData['returns_cmp_3year'] ?? 0;
                          num fiveYear = rowData['returns_cmp_5year'] ?? 0;
                          num tenYear = rowData['returns_cmp_10year'] ?? 0;
                          String inceptiondate = rowData['inception_date_str'] ?? "";
                          final color = index == 0
                              ? Config.appTheme.themeColor.withOpacity(0.1)
                              : Colors.white;
                          return DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                              return color;
                            }),
                            cells: [
                              DataCell(
                                Row(
                                  children: [
                                    (amcLogo.isNotEmpty &&
                                            Uri.parse(amcLogo).isAbsolute
                                        ? Image.network(
                                            amcLogo,
                                            height: 28,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return SizedBox(
                                                width: 32,
                                                height: 32,
                                              );
                                            },
                                          )
                                        : SizedBox(
                                            width: 32,
                                            height: 32,
                                          )),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: SizedBox(
                                        width: 160,
                                        child: Text(
                                          schemeShort,
                                          maxLines: 2,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppFonts.f40013
                                              .copyWith(color: Colors.black),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                             // DataCell(Text("$rupee ${Utils.formatNumber(aum)}", textAlign: TextAlign.center)),
                              DataCell(Text("$inceptiondate", textAlign: TextAlign.center)),
                              DataCell(Text("$oneYear%",
                                  textAlign: TextAlign.center)),
                              DataCell(Text("$twoYear%",
                                  textAlign: TextAlign.center)),
                              DataCell(Text("$threeYear%",
                                  textAlign: TextAlign.center)),
                              DataCell(Text("$fiveYear%",
                                  textAlign: TextAlign.center)),
                              DataCell(Text("$tenYear%",
                                  textAlign: TextAlign.center)),
                            ],
                          );
                        })),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List colorList = [
    Color(0xffDE5E2F),
    Color(0xff5DB25D),
    Color(0xff4155B9),
    Color(0xff3C9AB6)
  ];

  Widget historicalDataTable() {
    return Scrollbar(
      thickness: 5.0,
      thumbVisibility: true,
      radius: Radius.circular(10),
      controller: ScrollController(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: ScrollController(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: DataTable(
              headingRowHeight: 35,
              horizontalMargin: 12,
              headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  return Config.appTheme.themeColor;
                },
              ),
              columns: [
                DataColumn(
                  label: SizedBox(
                    width: 50,
                    child: Text(
                      'Fund',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 50,
                    child: Text(
                      '1Y',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 30,
                    child: Text(
                      '3Y',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 30,
                    child: Text(
                      '5Y',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 30,
                    child: Text(
                      '10Y',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
              rows: List<DataRow>.generate(
                  schemeInfoController.historicalTableData.length, (index) {
                final rowData = schemeInfoController.historicalTableData[index];

                Color colors = (index >= colorList.length)
                    ? colorList[index % 4]
                    : colorList[index];

                String schemeAmfi = rowData['scheme_name'] ?? "";
                //String logo = rowData['logo'] ?? Icon(Icons.bar_chart, color: colors);

                num oneYearReturn = rowData['one_year_return'] ?? 0;
                num threeYearReturn = rowData['three_year_return'] ?? 0;
                num fiveYearReturn = rowData['five_year_return'] ?? 0;
                num tenYearReturn = rowData['ten_year_return'] ?? 0;

                Color rowColor =
                    index == 0 ? Config.appTheme.overlay85 : Colors.white;
                return DataRow(
                  color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    return rowColor;
                  }),
                  cells: [
                    DataCell(
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          (rowData['logo'] != null &&
                                  Uri.parse(rowData['logo']!).isAbsolute)
                              ? Image.network(
                                  rowData['logo'],
                                  height: 28,
                                )
                              : Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                    color: colors.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Icon(
                                    Icons.bar_chart,
                                    color: colors,
                                  )),
                          SizedBox(width: 8),
                          Expanded(
                            child: SizedBox(
                              width: 160,
                              child: Text(
                                schemeAmfi,
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: AppFonts.f40013
                                    .copyWith(color: Colors.black),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                        Text("$oneYearReturn", textAlign: TextAlign.center)),
                    DataCell(
                        Text("$threeYearReturn", textAlign: TextAlign.center)),
                    DataCell(
                        Text("$fiveYearReturn", textAlign: TextAlign.center)),
                    DataCell(
                        Text("$tenYearReturn", textAlign: TextAlign.center)),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  rcPeriodBottomSheet() {
    //List list =
    //(schemeInfoController.selectedReturns.value == "Lumpsum") ? lumpsumPeriodList : sipPeriodList;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: cornerBorder,
        ),
        builder: (context) {
          return StatefulBuilder(builder: (_, bottomState) {
            return SizedBox(
              height: devHeight * 0.7,
              child: Column(
                children: [
                  BottomSheetTitle(
                      title:
                          "Select ${schemeInfoController.selectedReturns.value} Period"),
                  Divider(height: 0),
                  SizedBox(height: 16),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Obx(() {
                        final list =
                            schemeInfoController.selectedReturns.value ==
                                    "Lumpsum"
                                ? schemeInfoController.lumpsumPeriodList
                                : schemeInfoController.sipPeriodList;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            String curr = list[index];
                            return InkWell(
                              onTap: () {
                                schemeInfoController.rcPeriod.value = curr;
                                schemeInfoController
                                    .getReturnsTableCalc(schemeName);
                                Get.back();
                              },
                              child: Row(
                                children: [
                                  Radio(
                                      value: curr,
                                      groupValue:
                                          schemeInfoController.rcPeriod.value,
                                      onChanged: (val) {
                                        schemeInfoController.rcPeriod.value =
                                            curr;
                                        schemeInfoController
                                            .getReturnsTableCalc(schemeName);
                                        Get.back();
                                      }),
                                  Text("$curr Year")
                                ],
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  )
                ],
              ),
            );
          });
        });
  }

  rcAmountBottomSheet() {
    List list = (schemeInfoController.selectedReturns.value == "Lumpsum")
        ? schemeInfoController.lumpsumAmountList
        : schemeInfoController.sipAmountList;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: cornerBorder,
        ),
        builder: (context) {
          return StatefulBuilder(builder: (_, bottomState) {
            return SizedBox(
              height: devHeight * 0.7,
              child: Column(
                children: [
                  BottomSheetTitle(
                      title:
                          "Select ${schemeInfoController.selectedReturns.value} Amount"),
                  Divider(height: 0),
                  SizedBox(height: 16),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          String curr = list[index];
                          num tempNum = num.parse(curr);
                          return InkWell(
                            onTap: () {
                              schemeInfoController.rcAmount.value = curr;
                              if (schemeInfoController.selectedReturns.value ==
                                  "Lumpsum")
                                schemeInfoController.lumpsumReturnsList.clear();
                              else
                                schemeInfoController.sipReturnsList.clear();
                              schemeInfoController
                                  .getReturnsTableCalc(schemeName);

                              Get.back();
                            },
                            child: Row(
                              children: [
                                Radio(
                                    value: curr,
                                    groupValue:
                                        schemeInfoController.rcAmount.value,
                                    onChanged: (val) {
                                      schemeInfoController.rcAmount.value =
                                          curr;
                                      if (schemeInfoController
                                              .selectedReturns.value ==
                                          "Lumpsum")
                                        schemeInfoController.lumpsumReturnsList
                                            .clear();
                                      else
                                        schemeInfoController.sipReturnsList
                                            .clear();
                                      // schemeInfoController.rcPeriod.value = curr;
                                      // schemeInfoController
                                      //     .getReturnsTableCalc(schemeName);
                                      Get.back();
                                      //setState(() {});
                                    }),
                                Text("$rupee ${Utils.formatNumber(tempNum)}")
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          });
        });
  }

  String formatTimestamp(String timestamp) {
    int millisecondsSinceEpoch = int.parse(timestamp);
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    return DateFormat('EEEE, MMM d, y').format(dateTime);
  }

  Widget rpChart({required List<ChartData> funChartData}) {
    if (funChartData.isEmpty) return Utils.shimmerWidget(200);

    TrackballBehavior trackballBehavior = TrackballBehavior(
      enable: true,
      lineColor: Colors.red,
      lineWidth: 1,
      activationMode: ActivationMode.singleTap,
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
      shouldAlwaysShow: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (funChartData.isNotEmpty) {
        trackballBehavior.show(
          funChartData.length - 1, // Show for last data point
          0, // First series (Current Value)
        );
      }
    });
    return Container(
      width: double.infinity,
      height: 264,
      //decoration: BoxDecoration(border: Border.all()),
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(top: 16),
      child: SfCartesianChart(
        margin: EdgeInsets.all(0),
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
            isVisible: false,
            majorGridLines: MajorGridLines(width: 0),
            rangePadding: ChartRangePadding.none),
        primaryYAxis: NumericAxis(
          isVisible: false,
          numberFormat: NumberFormat.decimalPattern(),
          rangePadding: ChartRangePadding.additional,
        ),
        // tooltipBehavior: TooltipBehavior(enable: true),
        trackballBehavior: trackballBehavior,
        series: <CartesianSeries<ChartData, String>>[
          SplineAreaSeries(
            name: "Nav Movement",
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Config.appTheme.defaultProfit.withOpacity(0.8),
                Config.appTheme.mainBgColor.withOpacity(0.2)
              ],
              tileMode: TileMode.mirror,
            ),
            borderColor: Config.appTheme.themeColor,
            borderWidth: 2,
            dataSource: funChartData,
            xValueMapper: (ChartData sales, _) => formatTimestamp(sales.x!),
            yValueMapper: (ChartData sales, _) => sales.y,
            dataLabelSettings: DataLabelSettings(isVisible: false),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  String? x;
  num? y;

  ChartData({this.x, this.y});

  ChartData.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['x'] = x;
    data['y'] = y;

    return data;
  }
}

class SchemeInfoController extends GetxController {
  var isSchemeInfoLoading = false.obs;

  var schemeInfoPojo = SchemeInfoPojo().obs;
  var historicalTableData = <Map<String, dynamic>>[].obs;
  var peerComparisionTableData = <Map<String, dynamic>>[].obs;

  var assetClass = "".obs;
  var schemeInceptionDate = "".obs;
  var category = "".obs;
  var scheme_status = "".obs;
  var formattedschemeInceptionDate = "".obs;
  var formattedYearsMonth = "".obs;
  var minimumInvestment = 0.obs;
  var minimumTopup = 0.obs;
  var minSip = 0.obs;
  RxDouble aum = 0.0.obs;
  RxDouble ter = 0.0.obs;
  var schemeTurnover = 0.obs;
  var schemeBenchmark = "".obs;
  var exit1 = "".obs;
  var schemeObjective = "".obs;
  var schemeManager = "".obs;
  var factsheetName = "".obs;
  var portfolioName = "".obs;
  var factsheetLink = "".obs;
  var portfolioLink = "".obs;
  var amcDetails = <String, dynamic>{}.obs;
  var amcName = "".obs;
  var riskometerImage = "".obs;
  var amcLogo = "".obs;
  var amcAum = "0".obs;
  var finalAmcAum = 0.0.obs;
  var aumShare = "".obs;
  var activeFunds = "0".obs;
  var amcStartDate = "".obs;
  var assetDate = "".obs;
  var amcAddress1 = "".obs;
  var amcAddress2 = "".obs;
  var amcAddress3 = "".obs;
  var city = "".obs;
  var pincode = "".obs;
  var phone = "".obs;
  var schemeMap = {}.obs;
  var creditRateList = [].obs;
  RxDouble marketLargeCap = 0.0.obs;
  RxDouble marketMidCap = 0.0.obs;
  RxDouble marketSmallCap = 0.0.obs;
  RxInt marketOthers = 0.obs;

  var chartData = <ChartData>[].obs;
  var chartReturns = 0.0.obs;
  var isLoadingNavGraph = false.obs;
  final chartFilterList = ["1M", "3M", "6M", "1Y", "3Y", "5Y", "All"];
  var selectedChartPeriod = "1M".obs;

  Future<int> getSchemeInfo({
    required int userId,
    required String clientName,
    required String schemeShortName,
  }) async {
    isSchemeInfoLoading.value = true;

    final data = await ResearchApi.getSchemeInfo(
      user_id: userId,
      client_name: clientName,
      scheme: schemeShortName,
    );

    if (data.status != 200) {
      Utils.showError(Get.context!, data.msg ?? '');
      isSchemeInfoLoading.value = false;
      return -1;
    }

    schemeInfoPojo.value = data;
    historicalTableData.value =
        data.schemePerformanceList?.map((e) => e.toJson()).toList() ?? [];
    peerComparisionTableData.value =
        data.peerComparisonResponse?.map((e) => e.toJson()).toList() ?? [];

    assetClass.value = data.assetClass ?? "";
    schemeInceptionDate.value = data.schemeInceptionDate ?? "";
    category.value = data.schemeCategory ?? '';
    scheme_status.value = data.schemeStatus ?? '';

    if (schemeInceptionDate.value.isNotEmpty) {
      DateTime dateTime = DateTime.parse(schemeInceptionDate.value);
      dateTime = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day + 1,
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
      );
      formattedschemeInceptionDate.value =
          DateFormat("MMM dd yyyy").format(dateTime);

      String endDateString = DateTime.now().toIso8601String();
      DateTime startDate = DateTime.parse(schemeInceptionDate.value);
      DateTime endDate = DateTime.parse(endDateString);

      int yearsDifference = endDate.year - startDate.year;
      int monthsDifference = endDate.month - startDate.month;

      if (monthsDifference < 0) {
        yearsDifference--;
        monthsDifference += 12;
      }
      formattedYearsMonth.value =
          "$yearsDifference yrs ${monthsDifference.toString()}m";
    }

    minimumInvestment.value = (data.minimumInvestment ?? 0).toInt();
    minimumTopup.value = (data.minimumTopup ?? 0).toInt();
    minSip.value = data.schemeMapping?.sipMinimumAmount?.toInt() ?? 0;
    aum.value = data.schemeAssets?.toDouble() ?? 0;
    assetDate.value = data.schemeAssetDate ?? "";
    ter.value = data.schemeMapping?.ter?.toDouble() ?? 0;
    schemeTurnover.value = int.tryParse(data.schemeTurnover ?? '0') ?? 0;
    schemeBenchmark.value = data.schemeBenchmark ?? "";
    exit1.value = data.schemeMapping?.exit1 ?? "";
    schemeObjective.value = data.schemeMapping?.schemeObjective ?? '';
    schemeManager.value = data.schemeManager ?? '';
    factsheetName.value = data.factsheetName ?? '';
    portfolioName.value = data.portfolioName ?? '';
    factsheetLink.value = data.factsheetLink ?? '';
    portfolioLink.value = data.portfolioLink ?? '';
    amcDetails.value = data.amcDetails?.toJson() ?? {};
    amcName.value = data.amcDetails?.amcName ?? '';
    riskometerImage.value = data.riskometerImage ?? '';
    amcLogo.value = data.amcLogo ?? '';
    amcAum.value = data.amcDetails?.aum ?? '0';
    finalAmcAum.value = double.parse(amcAum.value.replaceAll(',', ''));
    aumShare.value = data.amcDetails?.aumShare ?? '';
    activeFunds.value = data.amcDetails?.activeFunds ?? '0';
    // amcStartDate.value = convertDateFormat(data['amc_details']['start_date']);
    amcAddress1.value = data.amcDetails?.address1 ?? '';
    amcAddress2.value = data.amcDetails?.address2 ?? '';
    amcAddress3.value = data.amcDetails?.address3 ?? '';
    city.value = data.amcDetails?.city ?? '';
    pincode.value = data.amcDetails?.pincode ?? '';
    phone.value = data.amcDetails?.phone ?? '';
    schemeMap.value = data.schemeMapping?.toJson() ?? {};
    creditRateList.value = data.creditRatings ?? [];

    marketLargeCap.value =
        data.schemeMapping?.marketCapLargecapPercent?.toDouble() ?? 0;
    marketMidCap.value =
        data.schemeMapping?.marketCapMidcapPercent?.toDouble() ?? 0;
    marketSmallCap.value =
        data.schemeMapping?.marketCapSmallcapPercent?.toDouble() ?? 0;
    marketOthers.value = (100.0 -
            (marketLargeCap.value + marketMidCap.value + marketSmallCap.value))
        .toInt();

    isSchemeInfoLoading.value = false;
    return 1;
  }

  String convertDateFormat(String inputDateStr) {
    DateFormat inputFormat = DateFormat("dd-MMM-yyyy");
    DateFormat outputFormat = DateFormat("dd-MM-yyyy");

    DateTime inputDate = inputFormat.parse(inputDateStr);
    String outputDateStr = outputFormat.format(inputDate);

    return outputDateStr;
  }

  Future getNavMovementGraph({
    required int userId,
    required String clientName,
    required String schemeName,
  }) async {
    isLoadingNavGraph.value = true;
    //if (chartData.isNotEmpty) return 0;

    Map data = await ResearchApi.getNavMovementGraph(
      user_id: userId,
      client_name: clientName,
      scheme: schemeName,
      period:
          (selectedChartPeriod.value == "All") ? "" : selectedChartPeriod.value,
    );

    if (data['status'] != 200) {
      Utils.showError(Get.context!, data['msg']);
      return -1;
    }

    chartReturns.value = data['returns'];
    Map graphData = data['graph_data'][0];
    List chartDataList = graphData['data'];
    convertToChartObj(chartDataList);

    isLoadingNavGraph.value = false;
  }

  void convertToChartObj(List list) {
    chartData.clear();
    for (var element in list) {
      chartData.add(ChartData.fromJson(element));
    }
  }

  void updateChartPeriod(String period, String schemeName) {
    selectedChartPeriod.value = period;
    chartData.clear();
    getNavMovementGraph(
        userId: getUserId(),
        clientName: GetStorage().read('client_name'),
        schemeName: schemeName);
  }

  var selectedReturns = "Lumpsum".obs;
  var rcPeriod = "".obs;
  var rcAmount = "".obs;
  var lumpsumPeriodList = [].obs;
  var lumpsumAmountList = [].obs;
  var sipPeriodList = [].obs;
  var sipAmountList = [].obs;
  var lumpsumReturnsList = [].obs;
  var sipReturnsList = [].obs;
  var isLoadingReturns = false.obs;

  Future getLumpsumReturnsPeriodAndAmount({
    required int userId,
    required String clientName,
    required String schemeName,
  }) async {
    if (lumpsumPeriodList.isNotEmpty) return 0;

    Map data = await ResearchApi.getLumpsumReturnsPeriodAndAmount(
      user_id: userId,
      client_name: clientName,
      scheme_name: schemeName,
    );

    if (data['status'] != 200) {
      Utils.showError(Get.context!, data['msg']);
      return -1;
    }
    Map result = data['result'];
    lumpsumPeriodList.value = result['period_list'];
    lumpsumAmountList.value = result['amount_list'];
    if (lumpsumPeriodList.isNotEmpty) rcPeriod.value = lumpsumPeriodList.first;
    if (lumpsumAmountList.isNotEmpty) rcAmount.value = "50000";

    return 0;
  }

  Future getSipReturnsPeriodAndAmount({
    required int userId,
    required String clientName,
    required String schemeName,
  }) async {
    if (sipPeriodList.isNotEmpty) return 0;

    Map data = await ResearchApi.getSipReturnsPeriodAndAmount(
      user_id: userId,
      client_name: clientName,
      scheme_name: schemeName,
    );

    if (data['status'] != 200) {
      Utils.showError(Get.context!, data['msg']);
      return -1;
    }
    Map result = data['result'];
    sipPeriodList.value = result['period_list'];
    sipAmountList.value = result['amount_list'];
    return 0;
  }

  Future getLumpsumReturnsTableCalc({
    required int userId,
    required String clientName,
    required String schemeName,
  }) async {
    isLoadingReturns.value = true;

    Map data = await ResearchApi.getLumpsumReturnsTableCalc(
      user_id: userId,
      client_name: clientName,
      scheme: schemeName,
      amount: rcAmount.value,
      period: rcPeriod.value,
    );

    if (data['status'] != 200) {
      Utils.showError(Get.context!, data['msg']);
      isLoadingReturns.value = false;
      return -1;
    }
    lumpsumReturnsList.value = data['list'];
    isLoadingReturns.value = false;
    return 0;
  }

  Future getSIPReturnsTableCalc({
    required int userId,
    required String clientName,
    required String schemeName,
  }) async {
    isLoadingReturns.value = true;
    Map data = await ResearchApi.getSIPReturnsTableCalc(
      user_id: userId,
      client_name: clientName,
      scheme: schemeName,
      amount: rcAmount.value,
      period: rcPeriod.value,
    );

    if (data['status'] != 200) {
      Utils.showError(Get.context!, data['msg']);
      isLoadingReturns.value = false;
      return -1;
    }
    sipReturnsList.value = data['list'];
    isLoadingReturns.value = false;
    return 0;
  }

  void updateSelectedReturns(String value, String schemeName) {
    selectedReturns.value = value;
    if (value == "Lumpsum") {
      lumpsumReturnsList.clear();
      if (lumpsumPeriodList.isNotEmpty)
        rcPeriod.value = lumpsumPeriodList.first;
      rcAmount.value = "50000";
    } else {
      sipReturnsList.clear();
      if (sipPeriodList.isNotEmpty) rcPeriod.value = sipPeriodList.first;
      if (sipAmountList.isNotEmpty) rcAmount.value = sipAmountList.first;
    }
    getReturnsTableCalc(schemeName);
  }

  void getReturnsTableCalc(String schemeName) {
    print("selectedReturns.value = ${selectedReturns.value}");

    if (selectedReturns.value == "Lumpsum") {
      getLumpsumReturnsTableCalc(
        userId: getUserId(),
        clientName: GetStorage().read('client_name'),
        schemeName: schemeName,
      );
    } else {
      getSIPReturnsTableCalc(
        userId: getUserId(),
        clientName: GetStorage().read('client_name'),
        schemeName: schemeName,
      );
    }
  }

  var sectorHoldings = "Top 10 Sectors".obs;
  var viewAllSector = false.obs;
  var portfolioAnalysis = {}.obs;

  Future getPortfolioAnalysis({
    required int userId,
    required String clientName,
    required String schemeName,
  }) async {
    if (portfolioAnalysis.isNotEmpty) return 0;

    Map data = await ResearchApi.getPortfolioAnalysis(
      user_id: userId,
      client_name: clientName,
      scheme: schemeName,
    );

    if (data['status'] != 200) {
      Utils.showError(Get.context!, data['msg']);
      return -1;
    }
    portfolioAnalysis.value = data;
    return 0;
  }

  void toggleViewAllSector() {
    viewAllSector.value = !viewAllSector.value;
  }

  void updateSectorHoldings(String value) {
    sectorHoldings.value = value;
  }

  String getKeyFromTitle(String title) {
    title = title.toLowerCase();
    return title.replaceAll(" ", "_");
  }

  String getSectorsKeyFromTitle(String title) {
    title = title.toLowerCase();
    return title.replaceAll(" ", "_");
  }

  var holdingsDistribution = "Asset Allocation".obs;
  var holdingsDistributionList = [
    "Asset Allocation",
    "Market Caps",
   // "Credit Ratings",
  ].obs;

  void updateHoldingsDistribution(String value) {
    holdingsDistribution.value = value;
  }

  Widget amcDetailsCard() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              (amcLogo.value.isNotEmpty && Uri.parse(amcLogo.value).isAbsolute
                  ? Image.network(
                      amcLogo.value,
                      height: 32,
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox(
                          width: 32,
                          height: 32,
                        );
                      },
                    )
                  : SizedBox(
                      width: 32,
                      height: 32,
                    )),
              SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  width: 160,
                  child: Text(
                    amcName.value,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.f50014Black,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "AUM",
                  value:
                      "$rupee ${Utils.formatNumber(finalAmcAum.value.round(), isAmount: false)} Cr"),
              Spacer(),
              ColumnText(
                  title: "AUM Share",
                  value: "${aumShare.value}%",
                  alignment: CrossAxisAlignment.start),
              Spacer(),
            ],
          ),
          DottedLine(
            verticalPadding: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Active Schemes",
                value: activeFunds.value,
              ),
              Spacer(),
              ColumnText(
                  title: "Start Date",
                  value: amcStartDate.value,
                  alignment: CrossAxisAlignment.start),
              Spacer(),
            ],
          ),
          DottedLine(
            verticalPadding: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: ColumnText(
                  title: "Address",
                  value:
                      "${amcAddress1.value}\n${amcAddress2.value}\n${amcAddress3.value}\n${city.value} - ${pincode.value}",
                  valueStyle:
                      AppFonts.f50014Black.copyWith(color: Colors.black),
                ),
              ),
            ],
          ),
          DottedLine(
            verticalPadding: 4,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Phone Number",
                    style: AppFonts.f40013,
                  ),
                  SizedBox(
                    width: 260,
                    child: Text(
                      phone.value,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.f50014Black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
