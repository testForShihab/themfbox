import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/Investor/Insurance_boho.dart';
import 'package:mymfbox2_0/Investor/InvestorContactUs.dart';
import 'package:mymfbox2_0/Investor/Registration/ChoosePlatform.dart';
import 'package:mymfbox2_0/Investor/Registration/OnboardingStatus.dart';
import 'package:mymfbox2_0/Investor/ekyc/ekyc.dart';
import 'package:mymfbox2_0/Investor/sipPortfolioSummary/SipPortfolioSummary.dart';
import 'package:mymfbox2_0/advisor/dashboard/ResearchCard.dart';
import 'package:mymfbox2_0/api/onBoarding/CommonOnBoardApi.dart';
import 'package:mymfbox2_0/Investor/InvestorMasterPortfolio.dart';
import 'package:mymfbox2_0/Investor/investorMenu/InvestorMenu.dart';
import 'package:mymfbox2_0/Investor/transact/TransactMenu.dart';
import 'package:mymfbox2_0/Investor/MutualFundScreen.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/pojo/MasterPortfolioPojo.dart';
import 'package:mymfbox2_0/pojo/OnlineTransactionRestrictionPojo.dart';
import 'package:mymfbox2_0/pojo/SipPojo.dart';
import 'package:mymfbox2_0/pojo/UserDataPojo.dart';
import 'package:mymfbox2_0/research/MfResearch.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile2.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:mymfbox2_0/rp_widgets/SipRoundIcon.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../api/Api.dart';
import '../common/MFInvestPerformanceResponse.dart';
import '../common/goal/Goal1.dart';
import '../research/Calculators.dart';
import '../Family/FamilyDashboard.dart';
import '../rp_widgets/BottomSheetTitle.dart';
import '../rp_widgets/UpdateBar.dart';
import 'InvestorMenu/InvestorReportMenu.dart';
import 'InvestorMenu/RiskProfile/RiskProfile.dart';

class InvestorDashboardBoho extends StatefulWidget {
  const InvestorDashboardBoho({super.key});
  static String? user_name;
  @override
  State<InvestorDashboardBoho> createState() => _InvestorDashboardBohoState();
}

class _InvestorDashboardBohoState extends State<InvestorDashboardBoho> {
  final BohoInvestorPerformanceController controller = Get.put(BohoInvestorPerformanceController());
  late double devHeight, devWidth;
  late String name;
  bool isFirst = true;
  num total = 0;
  List<SipPojo> sipList = [];
  List<SipPojo> transactionList = [];
  bool isLoading = true;
  int selectedPage = 0;

  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  int type_id = GetStorage().read("type_id");

  MutualFund mutualFund = MutualFund();
  UserDataPojo userDataPojo = UserDataPojo();
  MasterPostfolioPojo masterPostfolioPojo = MasterPostfolioPojo();

  num sip_total_count = 0;
  num sip_total_amount = 0;

  List masterSummaryList = [];
  Future getMasterPortfolio() async {
    if (!isFirst) return 0;
    Map<String, dynamic> data = await InvestorApi.getMasterPortfolio(
        user_id: user_id, client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }

    masterPostfolioPojo = MasterPostfolioPojo.fromJson(data);
    total = masterPostfolioPojo.totalCurrentValue ?? 0;
    masterSummaryList = data['master_summary_list'];

    mutualFund = masterPostfolioPojo.mutualFund ?? MutualFund();

    return 0;
  }

  Future getSipList() async {
    if (!isFirst) return 0;

    Map data = await InvestorApi.getSipMasterDetails(
        user_id: user_id, client_name: client_name, max_count: '5');
    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      return 0;
    }

    sip_total_count = data['total_count'];
    sip_total_amount = data['total_amount'];
    sipList.clear();
    List list = data['list'];
    list.forEach((element) {
      sipList.add(SipPojo.fromJson(element));
    });
    return 0;
  }

  Future getUser() async {
    if (!isFirst) return 0;

    Map data =
        await InvestorApi.getUser(user_id: user_id, client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    Map<String, dynamic> user = data['user'];
    userDataPojo = UserDataPojo.fromJson(user);

    await GetStorage().write('marketType', userDataPojo.bseNseMfu);
    await GetStorage().write('nseIinNumber', userDataPojo.nseIinNumber);
    await GetStorage().write("tax_status", user['tax_status']);
    await GetStorage().write("mfresearch_flag", userDataPojo.mfresearchFlag);
    await GetStorage().write("calculator_flag", userDataPojo.calculatorFlag);

    return 0;
  }

  Future getTransactionList() async {
    if (!isFirst) return 0;
    Map data = await InvestorApi.getTransactionDetails(
        user_id: user_id, client_name: client_name, max_count: '5');
    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      return 0;
    }
    List list = data['list'];
    list.forEach((element) {
      transactionList.add(SipPojo.fromJson(element));
    });

    return 0;
  }

  Map regStatus = {};
  Future getUserRegStatus() async {
    if (regStatus.isNotEmpty) return 0;

    Map data = await CommonOnBoardApi.getUserRegStatus(
        user_id: user_id, client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    regStatus = data['result'];

    return 0;
  }

  Future getCartCount(BuildContext context) async {
    if (!isFirst) return 0;

    return 0;
  }

  Iterable keys = GetStorage().getKeys();
  List investorList = [];
  late Map<String, dynamic> datas;
  OnlineTransactionRestrictionPojo userData =
      OnlineTransactionRestrictionPojo();
  Future getAllOnlineRestrictions() async {
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

  List chartList = [];
  List<ChartData> chartData = [];
  Future getMfPortfolioHistory() async {
    if (chartList.isNotEmpty) return 0;

    Map data = await InvestorApi.getMfPortfolioHistory(
      user_id: user_id,
      client_name: client_name,
      frequency: "Last $selectedMonth Months",
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    List list = data['list'];
    chartData = [];
    list.forEach((element) {
      chartData.add(ChartData.fromJson(element));
    });

    return 0;
  }

  /// Fetches all required dashboard data
  Future<void> getDatas(BuildContext context) async {
    try {
      await Future.wait([
        controller.getInvestPerformance(),
        getMasterPortfolio(),
        getSipList(),
        getTransactionList(),
        getUser(),
        getUserRegStatus(),
        getCartCount(context),
        getAllOnlineRestrictions(),
        getMfPortfolioHistory(),
        getLatestVersion()
      ]);

      generatePopularTools();

      isFirst = false;
      isLoading = false;
    } catch (e) {
      print('Error fetching dashboard data: $e');
      Utils.showError(context, 'Error loading dashboard data');
    }
  }

  List pages = [
    InvestorDashboardBoho(),
    InvestorMasterPortfolio(showAppBar: false),
    InvestorMenu()
  ];

  bool isvisible = true;

  @override
  void initState() {
    //  implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    name = InvestorDashboardBoho.user_name ??
        Utils.getFirst13(GetStorage().read("user_name"));
    //if(isvisible)checkForUpdate();
  }

  Color appBarColor = Config.appTheme.themeColor;
  Color fgColor = Colors.white;

  List popularTools = [];
  bool anyToolsAvailable = false;

  void generatePopularTools() {
    if (!isFirst) return;
    List<bool?> list = [
      userDataPojo.mfresearchFlag ?? false,
      userDataPojo.calculatorFlag ?? false,
      userDataPojo.goalFlag ?? false,
      userDataPojo.riskprofileFlag ?? false,
    ];

    // Check if any tools are available by filtering out null and false values
    anyToolsAvailable = list.any((flag) => flag == true);

    if (list[0] == true)
      popularTools.add({
        'image': 'assets/research_Tools.png',
        'title': "Mutual Fund Research",
        'subTitle': "15+ Research tools",
        'goTo': MfResearch(),
      });
    if (list[1] == true)
      popularTools.add({
        'image': 'assets/tools_Calculators.png',
        'title': "Tools & Calculators",
        'subTitle': "10+ Calculators",
        'goTo': Calculators(),
      });
    if (list[2] == true)
      popularTools.add({
        'image': 'assets/goalbased_lumpsum.png',
        'title': "Goals",
        'subTitle': "Create your goals",
        'goTo': Goal1(),
      });
    if (list[3] == true)
      popularTools.add({
        'image': 'assets/risk_profile.png',
        'title': "Risk Profile",
        'subTitle': (userDataPojo.userRisk?.isNotEmpty == true)
            ? "Retake risk profile"
            : "Take Risk Profile",
        'extraText': "${userDataPojo.userRisk ?? ''}",
        'goTo': RiskProfile(),
      });
  }

  Version localVersion = Version(1, 0, 0);
  Version liveVersion = Version(1, 0, 0);
  String appUrl = "";

  Future getLatestVersion() async {
    if (appUrl.isNotEmpty) return 0;

    Map data = await Api.getLatestVersion(client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    PackageInfo pl = await PackageInfo.fromPlatform();
    String temp = convertTo3Digit(pl.version);
    localVersion = Version.parse(temp);

    if (Platform.isAndroid) {
      String play_store_version = data['play_store_version'];
      if (play_store_version.isEmpty) return 0;
      liveVersion = Version.parse(play_store_version);
      appUrl = data['play_store_link'];
    }
    if (Platform.isIOS) {
      String app_store_version = data['app_store_version'];
      if (app_store_version.isEmpty) return 0;
      liveVersion = Version.parse(app_store_version);
      appUrl = data['app_store_link'];
    }
    return 0;
  }

  convertTo3Digit(String s) {
    List verList = s.split(".");
    if (verList.length == 2) s = "$s.0";
    return s;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        await _showConfirmationDialog(context);
      },
      child: FutureBuilder(
          future: getDatas(context),
          builder: (context, snapshot) {
            return Scaffold(
              appBar: invAppBar(
                toolbarHeight: 58,
                bgColor: appBarColor,
                fgColor: fgColor,
                systemUiOverlayStyle: SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.light),
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.orange,
                  child: Text(
                    name[0],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                title: "Hello $name",
              ),
              // appBar: appBar(),
              backgroundColor: Config.appTheme.mainBgColor,
              // body: (selectedPage == 0) ? invDashboard() : pages[selectedPage],
              body: IndexedStack(
                index: selectedPage,
                children: [
                  // InvestorDashboard(),
                  invDashboard(),
                  TransactMenu(),
                  InvestorReportMenu(),
                  // InvestorMasterPortfolio(showAppBar: false),
                  InvestorMenu(),
                ],
              ),
            bottomNavigationBar: (liveVersion > localVersion) ? updateBottomSheet() : normalBottomSheet(),
            );
              /*bottomNavigationBar: SizedBox(
                height: 91,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  child: BottomNavigationBar(
                    onTap: (val) {
                      selectedPage = val;
                      if (val == 3) {
                        appBarColor = Colors.transparent;
                        fgColor = Config.appTheme.themeColor;
                      } else {
                        appBarColor = Config.appTheme.themeColor;
                        fgColor = Colors.white;
                      }

                      setState(() {});
                    },
                    selectedItemColor: Config.appTheme.themeColor,
                    unselectedItemColor: Colors.grey,
                    currentIndex: selectedPage,
                    showUnselectedLabels: true,
                    selectedLabelStyle: TextStyle(
                        // fontSize: 14,
                        // fontWeight: FontWeight.w700,
                        ),
                    items: [
                      BottomNavigationBarItem(
                        icon: Image.asset(
                          'assets/dashboard.png',
                          width: 20,
                          color: getColor(0),
                        ),
                        label: "Mutual Funds",
                      ),
                      BottomNavigationBarItem(
                          icon: Image.asset(
                            'assets/transact_bottomsheet.png',
                            width: 20,
                            color: getColor(1),
                          ),
                          label: "Transact"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.assessment,), label: "Reports"),
                      *//* BottomNavigationBarItem(
                        icon: Icon(Icons.assessment), label: "Multi Assets"),*//*
                      BottomNavigationBarItem(
                          icon: Icon(Icons.account_circle), label: "Profile"),
                    ],
                  ),
                ),
              ),
            );*/
          }),
    );
  }

  Widget normalBottomSheet({BorderRadius? borderRadius}) {
    return SizedBox(
      height: 81,
      child: ClipRRect(
        borderRadius: borderRadius ??
            BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (val) {
            selectedPage = val;
            if (val == 3) {
              appBarColor = Colors.transparent;
              fgColor = Config.appTheme.themeColor;
            } else {
              appBarColor = Config.appTheme.themeColor;
              fgColor = Colors.white;
            }
            setState(() {});
          },
          selectedItemColor: Config.appTheme.themeColor,
          unselectedItemColor: Colors.grey,
          currentIndex: selectedPage,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(
            color: Config.appTheme.themeColor, // Color of selected label
          ),
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/dashboard.png',
                width: 20,
                color: getColor(0),
              ),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/transact_bottomsheet.png',
                  width: 20,
                  color: getColor(1),
                ),
                label: "Transact"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.assessment,
                ),
                label: "Reports"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                ),
                label: "Profile"),
          ],
        ),
      ),
    );
  }

  Widget updateBottomSheet() {
    return SizedBox(
      height: 128,
      child: Column(
        children: [
          UpdateBar(
            onUpdate: () async {
              await launchUrlString(appUrl);
            },
            onClose: () {
              liveVersion = localVersion;
              setState(() {});
            },
          ),
          Divider(height: 0),
          normalBottomSheet(borderRadius: BorderRadius.zero),
        ],
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    bool shouldExit = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm'),
              content: Text('Do you really want to exit?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text('Exit'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
    if (shouldExit) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      });
    }
    return shouldExit;
  }

  Widget invDashboard() {
    return SideBar(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            investmentCard(),
            (isFirst)
                ? Utils.shimmerWidget(220, margin: EdgeInsets.all(16))
                : InkWell(
                    onTap: () {
                      Get.to(MutualFundScreen());
                    },
                    child: summaryCard()),
            openCard(),
            talkToExpert(),
            if (sipList.isNotEmpty) SizedBox(height: 16),
            if (sipList.isNotEmpty)sideHeading("My SIPs"),
            if (sipList.isNotEmpty) SizedBox(height: 16),
            if (sipList.isNotEmpty) sipAreaNew(),
            if (sipList.isNotEmpty)
              viewAllBtn(
                  title: "View All SIPs",
                  onPressed: () {
                    Get.to(SipPortfolioSummary(
                      selectType: 'SIP',
                    ));
                    // Get.to(SipDetails());
                  }),
             SizedBox(height: 16),
            if (chartData.length > 1)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: chartArea(),
              ),
            if (anyToolsAvailable) sideHeading("Explore Popular Tools"),
            if (anyToolsAvailable)SizedBox(height:8),
            if (anyToolsAvailable)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 222,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      SizedBox(height: 16),
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: popularTools.length,
                          itemBuilder: (context, index) {
                            Map data = popularTools[index];

                            String image = data['image'];
                            String title = data['title'];
                            String subTitle = data['subTitle'];
                            bool isWhite = (index % 2 == 0) ? true : false;
                            Color color = (index % 2 == 0)
                                ? Config.appTheme.themeColor
                                : Colors.black;
                            Widget goTo = data['goTo'];
                            String extraText = data['extraText'] ?? "";

                            return ResearchCard(
                              image: image,
                              title: title,
                              subTitle: subTitle,
                              isWhite: isWhite,
                              color: color,
                              goTo: goTo,
                              extraText: extraText,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            performanceComparisonCard(),
          ],
        ),
      ),
    );
  }

  List<int> monthList = [12, 24, 36, 48, 60];
  int selectedMonth = 12;
  Widget chartArea() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "MF Portfolio History",
              style: AppFonts.f40016,
            ),
          ),
          SizedBox(height: 10),
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                            backgroundColor: Config.appTheme.themeProfit,
                            radius: 6),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Current Value",
                          style: AppFonts.f40013.copyWith(),
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        CircleAvatar(
                            backgroundColor: Config.appTheme.themeColor,
                            radius: 6),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Invested Amount",
                          style: AppFonts.f40013.copyWith(),
                        ),
                      ],
                    ),
                    /*ColumnText(
                        title: Utils.getFormattedDate(),
                        value: "$rupee ${Utils.formatNumber(0)}",
                        valueStyle: AppFonts.f50014Grey
                            .copyWith(color: Config.appTheme.themeProfit)),
                    ColumnText(
                        title: "Current Cost",
                        value: "$rupee ${Utils.formatNumber(0)}",
                        alignment: CrossAxisAlignment.end,
                        valueStyle: AppFonts.f50014Theme)*/
                  ],
                ),
              ),
              rpChart()
            ],
          ),
          SizedBox(height: 16),
          Center(
            child: ToggleSwitch(
              minWidth: devWidth * 0.17,
              initialLabelIndex: monthList.indexOf(selectedMonth),
              onToggle: (val) {
                selectedMonth = monthList[val ?? 0];
                chartData = [];
                setState(() {});
              },
              labels: monthList.map((e) => "$e M").toList(),
              activeBgColor: [Colors.black],
              inactiveBgColor: Colors.white,
              borderColor: [Colors.grey.shade300],
              borderWidth: 1,
              dividerColor: Colors.grey.shade300,
            ),
          )
        ],
      ),
    );
  }

  Widget rpChart() {
    if (chartData.isEmpty) return Utils.shimmerWidget(250);

    TrackballBehavior trackballBehavior = TrackballBehavior(
      enable: true,
      lineColor: Colors.red,
      lineWidth: 1,
      activationMode: ActivationMode.singleTap,
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
      // Show trackball initially
      shouldAlwaysShow: true,
    );

    // Add post-frame callback to trigger trackball at last point
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chartData.isNotEmpty) {
        trackballBehavior.show(
          chartData.length - 1, // Show for last data point
          0, // First series (Current Value)
        );
      }
    });

    return Container(
      width: double.infinity,
      height: 250,
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
          numberFormat: NumberFormat.decimalPattern(),
          isVisible: false,
          rangePadding: ChartRangePadding.additional,
        ),
       // tooltipBehavior: TooltipBehavior(enable: true),
        trackballBehavior: trackballBehavior,

        series: <CartesianSeries<ChartData, String>>[
          SplineAreaSeries(
            name: "Current Value",
            xValueMapper: (ChartData sales, _) => sales.aumMonthStr,
            yValueMapper: (ChartData sales, _) => sales.currValue,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Config.appTheme.themeProfit.withOpacity(0.8),
                Config.appTheme.mainBgColor.withOpacity(0.2)
              ],
              tileMode: TileMode.mirror,
            ),
            borderColor: Config.appTheme.themeProfit,
            borderWidth: 2,
            dataSource: chartData,
            dataLabelSettings: DataLabelSettings(isVisible: false),
          ),
          SplineAreaSeries(
            name: "Invested Amount",
            xValueMapper: (ChartData sales, _) => sales.aumMonthStr,
            yValueMapper: (ChartData sales, _) => sales.investedAmount,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Config.appTheme.themeColor.withOpacity(0.8),
                Config.appTheme.mainBgColor.withOpacity(0.2)
              ],
              tileMode: TileMode.mirror,
            ),
            borderColor: Config.appTheme.themeColor,
            borderWidth: 2,
            dataSource: chartData,
            dataLabelSettings: DataLabelSettings(isVisible: false),
          ),
        ],
      ),
    );
  }

  // Widget invDashboard() {
  //   return Stack(
  //     children: [
  //       SingleChildScrollView(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             InkWell(
  //                 onTap: () {
  //                   Get.to(InvestorMasterPortfolio(showAppBar: true));
  //                 },
  //                 child: investmentCard()),
  //             (isFirst)
  //                 ? Utils.shimmerWidget(220, margin: EdgeInsets.all(16))
  //                 : InkWell(
  //                     onTap: () {
  //                       Get.to(MutualFundScreen());
  //                     },
  //                     child: summaryCard()),
  //             openCard(),
  //             talkToExpert(),
  //             SizedBox(height: 16),
  //             sideHeading("My SIPs"),
  //             SizedBox(height: 16),
  //             sipArea(),
  //             if (sipList.isNotEmpty)
  //               viewAllBtn(title: "View All SIPs", onPressed: () async {}),
  //             sideHeading("Recent Transactions"),
  //             SizedBox(height: 16),
  //             trnxArea(),
  //             viewAllBtn(
  //                 title: "View All Transactions",
  //                 onPressed: () {
  //                   EasyLoading.showInfo("Design Pending");
  //                 }),
  //             SizedBox(height: 16),
  //           ],
  //         ),
  //       ),
  //       adminSideBar(),
  //       familySideBar(),
  //     ],
  //   );
  // }

  Color getColor(int index) {
    if (selectedPage == index)
      return Config.appTheme.themeColor;
    else
      return Colors.grey;
  }

  Widget sipArea() {
    /*if (sipList.isEmpty)
      return nothingCard(
        "You Currently have No SIP.\nInvest in best SIP Mutual Funds of India",
      );*/

    return ListView.builder(
      itemCount: (sipList.length > 5) ? 5 : sipList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return sipCard(sipList[index]);
      },
    );
  }

  Widget sipAreaNew() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ExpansionTile(
        collapsedBackgroundColor: Colors.white,
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        title: RpListTile2(
          padding: EdgeInsets.zero,
          leading: InitialCard(title: name),
          l1: name,
          l2: "Individual",
          r1: "$sip_total_amount",
          r2: " $sip_total_count SIPs",
          hasArrow: false,
          gap: 0,
        ),
        childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          (sipList.isEmpty)
              ? Text("No SIP Available")
              : ListView.separated(
                  itemCount: sipList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    SipPojo sip = sipList[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            //Image.network("${sip.logo}", height: 32),
                            Utils.getImage("${sip.logo}", 32),
                            SizedBox(width: 5),
                            SizedBox(
                              width: devWidth * 0.55,
                              child: Text("${sip.schemeAmfiShortName}",
                                  softWrap: true, style: AppFonts.f50014Black),
                            ),
                            Spacer(),
                            Text(
                                "$rupee ${Utils.formatNumber(sip.sipAmount?.round())}",
                                style: AppFonts.f50014Black)
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            SizedBox(width: 5),
                            Text("Folio : ${sip.folio}",
                                style:
                                    TextStyle(color: AppColors.readableGrey)),
                            Spacer(),
                            Text("${sip.sipDateWithFrequency}",
                                style: TextStyle(color: AppColors.readableGrey))
                          ],
                        )
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      DottedLine(),
                )
        ],
      ),
    );
  }

  Widget sipCard(SipPojo sip) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            children: [
              Image.network("${sip.logo}", height: 32),
              SizedBox(width: 10),
              SizedBox(
                width: devWidth * 0.4,
                child: Text("${sip.schemeAmfiShortName}",
                    style: AppFonts.f50014Black),
              ),
              Spacer(),
              Text("$rupee ${Utils.formatNumber(sip.sipAmount)}",
                  style: AppFonts.f50014Black),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Folio : ${sip.folio}", style: AppFonts.f40013),
              Text("${sip.sipDateWithFrequency}", style: AppFonts.f40013),
            ],
          ),
          SizedBox(height: 10),
          /*  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Start Date : ${Utils.getFormattedDate()}", style: AppFonts.f40013),
              Text("End Date : ${Utils.getFormattedDate()}", style: AppFonts.f40013),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Units : ${sip.sipDate}", style: AppFonts.f40013),
              Text("XIRR : ${sip.sipDate}%", style: AppFonts.f40013),
            ],
          ),*/
        ],
      ),
    );
  }

  Widget trnxArea() {
    if (transactionList.isEmpty)
      return nothingCard(
        "You Currently have No transaction.\nInvest in best schemes in Mutual Funds of India",
      );

    return ListView.builder(
      itemCount: (transactionList.length > 5) ? 5 : transactionList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return trnxCard(transactionList[index]);
      },
    );
  }

  Widget trnxCard(SipPojo trnx) {
    String amount = Utils.formatNumber((trnx.trnxAmount)!.round());
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            children: [
              Image.network("${trnx.logo}", height: 32),
              SizedBox(width: 10),
              Expanded(
                // width: devWidth * 0.4,
                child: Text("${trnx.schemeAmfiShortName}",
                    style: AppFonts.f50014Black),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${trnx.trnxDate}", style: AppFonts.f40013),
              Text("Folio : ${trnx.folio}", style: AppFonts.f40013),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                label: Text("${trnx.trnxType}",
                    style: TextStyle(color: Config.appTheme.themeColor)),
                backgroundColor: Color(0XFFECFFFF),
              ),
              Text(
                "$rupee $amount",
                style: AppFonts.f50014Grey.copyWith(color: AppColors.textGreen),
              )
            ],
          )
        ],
      ),
    );
  }

  appBar() {
    return AppBar(
      leadingWidth: 0,
      toolbarHeight: 60,
      backgroundColor: Config.appTheme.themeColor,
      leading: SizedBox(),
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.orange,
            child: Text(
              name[0],
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10),
          Text("Hello $name",
              style: AppFonts.appBarTitle.copyWith(color: Colors.white)),
          Spacer(),
          Icon(Icons.notifications_none, color: Colors.white),
        ],
      ),
    );
  }

  Widget investmentCard() {
    return Column(
      children: [
        Container(
          color: Config.appTheme.themeColor,
          width: devWidth,
          child: (isLoading)
              ? Utils.shimmerWidget(130, margin: EdgeInsets.all(16))
              : InkWell(
                  onTap: () {
                    Get.to(InvestorMasterPortfolio(showAppBar: true));
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16, 10, 16, 16),
                    decoration: BoxDecoration(
                      color: Config.appTheme.overlay85,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "My Investments",
                                style: TextStyle(
                                    color: Config.appTheme.themeColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16),
                              ),
                              Icon(Icons.arrow_forward,
                                  color: Config.appTheme.themeColor)
                            ],
                          ),
                          SizedBox(height: devHeight * 0.02),
                          Text(
                            "$rupee ${Utils.formatNumber(total)}",
                            style: TextStyle(
                                color: Config.appTheme.themeColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 32),
                          ),
                          Text(
                            "As on ${Utils.getFormattedDate()}",
                            style: TextStyle(
                                color: AppColors.readableGrey,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
        if (masterSummaryList.length > 1) investmentRow(),
      ],
    );
  }

  Widget investmentRow() {
    return Container(
      height: 115,
      color: Config.appTheme.themeColor,
      padding: EdgeInsets.only(top: 8),
      child: ListView.builder(
        itemCount: masterSummaryList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          Map map = masterSummaryList[index];

          if (isLoading) return roundShimmer();

          String title = map['title'];
          num value = map['value'];

          return InkWell(
              onTap: () {
                if (title.contains("Mutual Fund"))
                  Get.to(() => MutualFundScreen());
                else if (title.contains("Insurance"))
                  Get.to(() => InsuranceBoho(showAppBar: true));
                else
                  Get.to(InvestorMasterPortfolio(showAppBar: true));
              },
              child: rowIcon(title, value));
        },
      ),
    );
  }

  Widget rowIcon(String title, num? value) {
    return Visibility(
      visible: value != 0,
      child: Container(
        color: Config.appTheme.themeColor,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SipRoundIcon(),
            SizedBox(height: 5),
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xffDEE6E6))),
            Text("$rupee ${Utils.formatNumber(value, isAmount: true)}",
                style: cardHeadingSmall.copyWith(color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget roundShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      direction: ShimmerDirection.ltr,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
        height: 70,
        width: 70,
      ),
    );
  }

  Widget summaryCard() {
    String cost =
        Utils.formatNumber(mutualFund.mutualFundInvestedValue, isAmount: true);
    String gainLoss =
        Utils.formatNumber(mutualFund.mutualFundUnrealised, isAmount: true);
    num xirr = mutualFund.mutualFundCagr ?? 0;

    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
          border: Border.all(color: Config.appTheme.themeColor, width: 1.2),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SipRoundIcon(),
              SizedBox(width: 5),
              Text("Mutual Fund",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  )),
              Spacer(),
              Icon(Icons.arrow_forward, color: Config.appTheme.themeColor)
            ],
          ),
          SizedBox(height: 16),
          Text(
            "$rupee ${Utils.formatNumber(mutualFund.mutualFundCurrentValue)}",
            style: AppFonts.f70024
                .copyWith(fontSize: 32, color: Config.appTheme.themeColor),
          ),
          if (userData.oneDayChange == 1 ||
              ((keys.contains("adminAsInvestor")) ||
                  (keys.contains("adminAsFamily")) != false))
            dayChange(),
          SizedBox(height: 5),
          SizedBox(
            height: 20,
            child: ListView.builder(
                itemCount: 100,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) =>
                    Text("-", style: TextStyle(color: Colors.grey[400]))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              columnText("Cost", "$rupee $cost"),
              columnText("Gain/Loss", "$rupee $gainLoss",
                  alignment: CrossAxisAlignment.center),
              columnText("XIRR", "${mutualFund.mutualFundCagr}%",
                  alignment: CrossAxisAlignment.end,
                  valueColor: (xirr > 0)
                      ? Config.appTheme.defaultProfit
                      : Config.appTheme.defaultLoss),
            ],
          ),
        ],
      ),
    );
  }

  Widget columnText(String title, String value,
      {CrossAxisAlignment? alignment, Color? valueColor}) {
    return Column(
      crossAxisAlignment: alignment ?? CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.f40013,
        ),
        Text(value,
            style:
                AppFonts.f50014Grey.copyWith(color: valueColor ?? Colors.black))
      ],
    );
  }

  Widget dayChange() {
    String value = Utils.formatNumber(mutualFund.mutualFundOneDayChangeValue);
    String percentage =
        Utils.formatNumber(mutualFund.mutualFundOneDayChangePercentage);
    num percentagevalue = mutualFund.mutualFundOneDayChangePercentage ?? 0.0;
    return Row(
      children: [
        Text(
          "1 Day Change",
          style: TextStyle(
              color: AppColors.readableGrey,
              fontWeight: FontWeight.w500,
              fontSize: 12),
        ),
        Text(
          "$rupee $value",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        Text(
          " ($percentage%)",
          style: TextStyle(
              color: (percentagevalue > 0)
                  ? Config.appTheme.defaultProfit
                  : Config.appTheme.defaultLoss,
              fontSize: 13,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget openCard() {
    bool showCard = regStatus['showCard'] ?? false;
    if (!showCard) return SizedBox();
    String callBackUrl = regStatus['call_back_url'];
    String buttonText = regStatus['button_text'];
    String title = regStatus['title'];

    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SipRoundIcon(),
              SizedBox(width: 10),
              Text(
                title,
                style: AppFonts.f40016.copyWith(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            "${regStatus['description']}",
            style: f40012.copyWith(fontSize: 14),
          ),
          SizedBox(height: 16),
          if (buttonText != "")
            TextButton(
              onPressed: () async {
                if (callBackUrl.isNotEmpty) {
                  http.Response response =
                      await http.post(Uri.parse(callBackUrl));
                  Map data = jsonDecode(response.body);

                  if (data['status'] == 200) {
                    EasyLoading.showToast(data['msg']);
                    await Future.delayed(Duration(milliseconds: 500));
                    await getUserRegStatus();
                    regStatus = {};

                    setState(() {});
                  } else {
                    Utils.showError(context, data['msg']);
                  }
                  return;
                }

                if (title.contains("eKYC"))
                  Get.to(() => Ekyc());
                else
                  await onBoardingFlow();
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 38)),
              child: Text(
                "$buttonText",
                style: cardHeadingSmall.copyWith(
                    color: Config.appTheme.themeColor),
              ),
            )
        ],
      ),
    );
  }

  Future<void> checkForUpdate() async {
    // final response = await http.get(Uri.parse('https://yourserver.com/version.json'));

    //final Map<String, dynamic> versionInfo = json.decode('latest_version' : '');
    String latestVersion = '119.0.0';
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    if (currentVersion != latestVersion) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Update Available"),
              content: Text("New update is available"),
              actions: [
                ElevatedButton(
                    onPressed: () async {
                      await launchUrlString(
                          "https://play.google.com/store/apps/details?id=in.mymfbox");
                      Get.back();
                    },
                    child: Text('Update Now')),
                ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Update Later")),
                ElevatedButton(
                    onPressed: () {
                      isvisible = false;
                      Get.back();
                    },
                    child: Text("Updated")),
              ],
            );
          });
    }
  }

  Future onBoardingFlow() async {
    Map data = await CommonOnBoardApi.getOnBoardingStatus(
      user_id: user_id,
      client_name: client_name,
      bse_nse_mfu_flag: "",
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return;
    }
    Map result = data['result'];
    String vendor = result['vendor'];
    if (vendor.isEmpty)
      Get.to(() => ChoosePlatform());
    else {
      Get.to(() => OnboardingStatus(bse_nse_mfu: vendor));
    }
  }

  Widget talkToExpert() {
    return Visibility(
      visible: total == 0,
      child: Container(
        width: devWidth,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: BoxDecoration(
          color: Config.appTheme.themeColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SipRoundIcon(),
                SizedBox(width: 10),
                Text(
                  "New to Investment ?",
                  style: AppFonts.f40016.copyWith(color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
                "Investing in Mutual Fund is easier than you think.\nNeed help ?",
                style: f40012.copyWith(color: Colors.white, fontSize: 14)),
            SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                Get.to(() => InvestorContactUs());
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 38)),
              child: Text("Talk to Our Expert",
                  style: cardHeadingSmall.copyWith()),
            )
          ],
        ),
      ),
    );
  }

  Widget sideHeading(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 24),
      child: Text(text, style: AppFonts.f50014Grey),
    );
  }

  Widget viewAllBtn({required String title, required Function() onPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: TextButton(
              onPressed: onPressed,
              child: Row(
                children: [
                  Text(title,
                      style: AppFonts.f50014Black
                          .copyWith(color: Config.appTheme.themeColor)),
                  SizedBox(width: 5),
                  Icon(Icons.arrow_forward, size: 20)
                ],
              )),
        ),
      ],
    );
  }

  Widget nothingCard(String title) {
    return Container(
      width: devWidth,
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Image.asset("assets/sipFund.png",
              color: Colors.grey[400], height: 32),
          SizedBox(height: 16),
          Text(title, textAlign: TextAlign.center, style: AppFonts.f40013)
        ],
      ),
    );
  }

  List<bool> isSelected = [false, false, true, false, false, false];
  Color txtcolor = Color(0xFF6F828E);
  String togglePeriod = "3Y";

  Widget performanceComparisonCard() {
    print("MF Value: ${controller.mfValue.value}");
    print("niftyReturn Value: ${controller.niftyReturn.value}");
    print("goldValue Value: ${controller.goldValue.value}");
    print("sliderMinValue Value: ${controller.sliderMinValue.value}");

    return Obx(() {
      return Container(
        padding: EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0XFFF5F8FC),
            border: Border.all(color: Config.appTheme.themeColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(5)),),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Config.appTheme.whiteOverlay,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(6))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Performance Comparison of Different Assets",
                        style: AppFonts.f40016),
                    SizedBox(height: 15),
                    Text("Investment Amount",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6F828E))),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: () async {
                        showAmountBottomSheet(context,
                            groupValue: controller.spinnerAmount.value,
                            monthList: controller.spinnerAmountList);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0XFFFFFFFF),
                          shape: BoxShape.rectangle,
                          border: Border.all(color: Colors.black12, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(1)),
                        ),
                        height: 40.0,
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          focusColor: Config.appTheme.themeColor,
                          underline: SizedBox(),
                          value: controller.spinnerAmount.value,
                          style:
                          TextStyle(color: Color(0xFF6F85A6), fontSize: 16),
                          icon: const Icon(Icons.keyboard_arrow_down_sharp,
                              size: 28),
                          iconEnabledColor: Color(0xFF6F85A6),
                          items: controller.spinnerAmountList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: null,
                          onTap: () {
                            showAmountBottomSheet(context,
                                groupValue: controller.spinnerAmount.value,
                                monthList: controller.spinnerAmountList);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Mutual Funds",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF6F828E))),
                              Text("(Average CAGR of top 5 FlexiCap Funds)",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF6F828E))),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        margin:
                                        EdgeInsets.symmetric(vertical: 10),
                                        width: 160,
                                        height: 10,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 0,
                                                top: 0,
                                                right: 0,
                                                bottom: 0),
                                            child: SliderTheme(
                                              data: SliderTheme.of(context)
                                                  .copyWith(
                                                activeTickMarkColor:
                                                Colors.transparent,
                                                inactiveTickMarkColor:
                                                Colors.transparent,
                                                activeTrackColor:
                                                Color(0XFF50B432),
                                                inactiveTrackColor:
                                                Color(0xFFF6F7F9),
                                                trackHeight: 5,
                                                thumbColor: Colors.transparent,
                                                thumbShape:
                                                RoundSliderThumbShape(
                                                    enabledThumbRadius:
                                                    0.0),
                                                overlayShape:
                                                RoundSliderOverlayShape(
                                                    overlayRadius: 0.0),
                                              ),
                                              child: Slider(
                                                  value: controller
                                                      .mfReturn.value
                                                      .round()
                                                      .toDouble(),
                                                  min: controller
                                                      .sliderMinValue.value,
                                                  max: controller
                                                      .sliderMaxValue.value,
                                                  label:
                                                  '${controller.mfReturn.value}',
                                                  onChanged: (values) {}),
                                            ),
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                            "\u{20B9} ${Utils.formatNumber(controller.mfValue.value)} (${controller.mfReturn.value}%)",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF1FC094))),
                                      )),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("NIFTY",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF6F828E))),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin:
                                        EdgeInsets.symmetric(vertical: 10),
                                        width: 160,
                                        height: 10,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 0,
                                                top: 0,
                                                right: 0,
                                                bottom: 0),
                                            child: SliderTheme(
                                              data: SliderTheme.of(context)
                                                  .copyWith(
                                                activeTickMarkColor:
                                                Colors.transparent,
                                                inactiveTickMarkColor:
                                                Colors.transparent,
                                                activeTrackColor:
                                                Colors.lightBlueAccent,
                                                inactiveTrackColor:
                                                Color(0xFFF6F7F9),
                                                trackHeight: 5,
                                                thumbColor: Colors.transparent,
                                                thumbShape:
                                                RoundSliderThumbShape(
                                                    enabledThumbRadius:
                                                    0.0),
                                                overlayShape:
                                                RoundSliderOverlayShape(
                                                    overlayRadius: 0.0),
                                              ),
                                              child: Slider(
                                                  value: controller
                                                      .niftyReturn.value
                                                      .round()
                                                      .toDouble(),
                                                  min: controller
                                                      .sliderMinValue.value,
                                                  max: controller
                                                      .sliderMaxValue.value,
                                                  label:
                                                  '${controller.niftyReturn.value}',
                                                  onChanged: (values) {}),
                                            ),
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                            "\u{20B9} ${Utils.formatNumber(controller.niftyValue.value)} (${controller.niftyReturn.value}%)",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF6F828E))),
                                      )),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Gold",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF6F828E))),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin:
                                        EdgeInsets.symmetric(vertical: 10),
                                        width: 160,
                                        height: 10,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 0,
                                                top: 0,
                                                right: 0,
                                                bottom: 0),
                                            child: SliderTheme(
                                              data: SliderTheme.of(context)
                                                  .copyWith(
                                                activeTickMarkColor:
                                                Colors.transparent,
                                                inactiveTickMarkColor:
                                                Colors.transparent,
                                                activeTrackColor:
                                                Color(0XFFDDDF00),
                                                inactiveTrackColor:
                                                Color(0xFFF6F7F9),
                                                trackHeight: 5,
                                                thumbColor: Colors.transparent,
                                                thumbShape:
                                                RoundSliderThumbShape(
                                                    enabledThumbRadius:
                                                    0.0),
                                                overlayShape:
                                                RoundSliderOverlayShape(
                                                    overlayRadius: 0.0),
                                              ),
                                              child: Slider(
                                                  value: controller
                                                      .goldReturn.value
                                                      .round()
                                                      .toDouble(),
                                                  min: controller
                                                      .sliderMinValue.value,
                                                  max: controller
                                                      .sliderMaxValue.value,
                                                  label:
                                                  '${controller.goldReturn.value}',
                                                  onChanged: (values) {}),
                                            ),
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                            "\u{20B9} ${Utils.formatNumber(controller.goldValue.value)} (${controller.goldReturn.value}%)",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF6F828E))),
                                      )),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("FD",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF6F828E))),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin:
                                        EdgeInsets.symmetric(vertical: 10),
                                        width: 160,
                                        height: 10,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 0,
                                                top: 0,
                                                right: 0,
                                                bottom: 0),
                                            child: SliderTheme(
                                              data: SliderTheme.of(context)
                                                  .copyWith(
                                                activeTickMarkColor:
                                                Colors.transparent,
                                                inactiveTickMarkColor:
                                                Colors.transparent,
                                                activeTrackColor:
                                                Color(0XFF24CBE5),
                                                inactiveTrackColor:
                                                Color(0xFFF6F7F9),
                                                trackHeight: 5,
                                                thumbColor: Colors.transparent,
                                                thumbShape:
                                                RoundSliderThumbShape(
                                                    enabledThumbRadius:
                                                    0.0),
                                                overlayShape:
                                                RoundSliderOverlayShape(
                                                    overlayRadius: 0.0),
                                              ),
                                              child: Slider(
                                                  value: controller
                                                      .fdReturn.value
                                                      .round()
                                                      .toDouble(),
                                                  min: controller
                                                      .sliderMinValue.value,
                                                  max: controller
                                                      .sliderMaxValue.value,
                                                  label:
                                                  '${controller.fdReturn.value}',
                                                  onChanged: (values) {}),
                                            ),
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                            "\u{20B9} ${Utils.formatNumber(controller.fdValue.value)} (${controller.fdReturn.value}%)",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF6F828E))),
                                      )),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Investment Period",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF9099A7))),
                    SizedBox(height: 10),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ToggleButtons(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: Text("6M",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: txtcolor)),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: Text("1Y",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: txtcolor)),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: Text("3Y",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: txtcolor)),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: Text("5Y",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: txtcolor)),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: Text("10Y",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: txtcolor)),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 14, right: 16),
                                child: Text("20Y",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: txtcolor)),
                              ),
                            ],
                            borderColor: Color(0xFFD9DFE7),
                            selectedBorderColor: Config.appTheme.themeColor,
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(3),
                            borderWidth: 1.2,
                            isSelected: controller.isSelected,
                            onPressed: (int index) {
                              for (int buttonIndex = 0;
                              buttonIndex < controller.isSelected.length;
                              buttonIndex++) {
                                controller.isSelected[buttonIndex] =
                                (buttonIndex == index);
                              }
                              switch (index) {
                                case 0:
                                  controller.togglePeriod.value = "6M";
                                  break;
                                case 1:
                                  controller.togglePeriod.value = "1Y";
                                  break;
                                case 2:
                                  controller.togglePeriod.value = "3Y";
                                  break;
                                case 3:
                                  controller.togglePeriod.value = "5Y";
                                  break;
                                case 4:
                                  controller.togglePeriod.value = "10Y";
                                  break;
                                case 5:
                                  controller.togglePeriod.value = "20Y";
                                  break;
                              }
                              controller.getInvestPerformance();
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  void showAmountBottomSheet(BuildContext context,
      {required String groupValue,
        Function(String?)? onChanged,
        required List monthList}) {
    final BohoInvestorPerformanceController controller = Get.find();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SingleChildScrollView(
              child: Container(
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    BottomSheetTitle(title: "Select Amount"),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.spinnerAmountList.length,
                      itemBuilder: (context, index) {
                        String title = controller.spinnerAmountList[index];

                        return InkWell(
                          onTap: () async {
                            controller.spinnerAmount.value =
                            controller.spinnerAmountList[index];
                            controller.getInvestPerformance();
                            Get.back();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: 1.0,
                                  color: Color(0XFFE8F1FF),
                                ),
                              ),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              children: [
                                Obx(() {
                                  return Radio(
                                    activeColor: Colors.blue,
                                    groupValue: controller.spinnerAmount.value,
                                    value: controller.spinnerAmountList[index],
                                    onChanged: (val) async {
                                      controller.spinnerAmount.value = val!;
                                      controller.getInvestPerformance();
                                      Get.back();
                                    },
                                  );
                                }),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      controller.spinnerAmountList[index],
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Mulish',
                                        fontWeight: FontWeight.w600,
                                        color: Color(0XFF9099A7),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

}


class BohoInvestorPerformanceController extends GetxController {
  // MARK: - Observable Properties
  final isSelected = [false, false, true, false, false, false].obs;
  final togglePeriod = "3Y".obs;
  final spinnerAmount = "10000".obs;
  final spinnerAmountList =
      ["10000", "20000", "30000", "40000", "50000", "100000"].obs;

  // Performance metrics
  final mfValue = 0.0.obs;
  final mfReturn = 0.0.obs;
  final niftyValue = 0.0.obs;
  final niftyReturn = 0.0.obs;
  final goldValue = 0.0.obs;
  final goldReturn = 0.0.obs;
  final fdValue = 0.0.obs;
  final fdReturn = 0.0.obs;

  // Slider values
  final sliderMaxValue = 100.0.obs;
  final sliderMinValue = 0.0.obs;

  // MARK: - Methods
  /// Fetches and updates investment performance data
  Future<void> getInvestPerformance() async {
    try {
      final response = await httpInvestmentPerformance(
          togglePeriod.value, spinnerAmount.value);

      _updatePerformanceValues(response);
      _updateSliderRange();
    } catch (e) {
      print('Error getting investment performance: $e');
      Utils.showError(Get.context!, 'Error loading performance data');
    }
  }

  /// Updates all performance values from API response
  void _updatePerformanceValues(MFInvestPerformanceResponse response) {
    mfValue.value = response.mfValue ?? 0.0;
    mfReturn.value = response.mfReturn ?? 0.0;
    niftyReturn.value = response.benchmarkReturn ?? 0.0;
    niftyValue.value = response.benchmarkValue ?? 0.0;
    goldReturn.value = response.goldReturn ?? 0.0;
    goldValue.value = response.goldValue ?? 0.0;
    fdReturn.value = response.fdReturn ?? 0.0;
    fdValue.value = response.fdValue ?? 0.0;
    print("response.mfValue = ${response.mfValue}");
    print("response.fdReturn = ${response.fdReturn}");
  }

  /// Updates slider range based on return values
  void _updateSliderRange() {
    final returns = [
      mfReturn.value,
      niftyReturn.value,
      goldReturn.value,
      fdReturn.value
    ];
    returns.sort();
    sliderMaxValue.value = returns.last + 1;
    sliderMinValue.value = returns.first - 1;
  }

  Future httpInvestmentPerformance(
      String togglePeriod, String spinnerAmount) async {
    Map data = await InvestorApi.getMfInvestmentPerformance(
      period: togglePeriod,
      amount: spinnerAmount,
      client_name: client_name,
    );
    if (data['status'] != 200) {
      Utils.showError(Get.context!, data['msg']);
      return;
    }
    return MFInvestPerformanceResponse.fromJson(data['result']);
  }
}
