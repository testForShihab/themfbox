import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/InvestorContactUs.dart';
import 'package:mymfbox2_0/Investor/InvestorDashboard_boho.dart';
import 'package:mymfbox2_0/Investor/InvestorMenu/InvestorReportMenu.dart';
import 'package:mymfbox2_0/Investor/InvestorMenu/RiskProfile/RiskProfile.dart';
import 'package:mymfbox2_0/Investor/Registration/ChoosePlatform.dart';
import 'package:mymfbox2_0/Investor/Registration/OnboardingStatus.dart';
import 'package:mymfbox2_0/Investor/ekyc/ekyc.dart';
import 'package:mymfbox2_0/Investor/sipPortfolioSummary/SipPortfolioSummary.dart';
import 'package:mymfbox2_0/advisor/dashboard/ResearchCard.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/api/onBoarding/CommonOnBoardApi.dart';
import 'package:mymfbox2_0/Investor/InvestorMasterPortfolio.dart';
import 'package:mymfbox2_0/Investor/investorMenu/InvestorMenu.dart';
import 'package:mymfbox2_0/Investor/transact/TransactMenu.dart';
import 'package:mymfbox2_0/Investor/MutualFundScreen.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/common/goal/Goal1.dart';
import 'package:mymfbox2_0/pojo/MasterPortfolioPojo.dart';
import 'package:mymfbox2_0/pojo/OnlineTransactionRestrictionPojo.dart';
import 'package:mymfbox2_0/pojo/SipPojo.dart';
import 'package:mymfbox2_0/pojo/UserDataPojo.dart';
import 'package:mymfbox2_0/research/MfResearch.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/rp_widgets/UpdateBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:mymfbox2_0/rp_widgets/SipRoundIcon.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../api/ReportApi.dart';
import '../common/MFInvestPerformanceResponse.dart';
import '../research/Calculators.dart';
import '../rp_widgets/BottomSheetTitle.dart';
import 'package:http/http.dart' as http;

/// InvestorDashboard displays the main dashboard screen for investors
/// Shows portfolio summary, SIPs, transactions and other investment details
class InvestorDashboard extends StatefulWidget {
  const InvestorDashboard({super.key});

  static String? user_name;

  @override
  State<InvestorDashboard> createState() => _InvestorDashboardState();
}

class _InvestorDashboardState extends State<InvestorDashboard> {
  // MARK: - Controllers
  final InvestorPerformanceController controller =
      Get.put(InvestorPerformanceController());

  // MARK: - Properties
  late double devHeight, devWidth;
  late String name;
  bool isFirst = true;
  bool isLoading = true;
  int selectedPage = 0;
  Color appBarColor = Config.appTheme.themeColor;
  Color fgColor = Colors.white;

  // Investment data
  num total = 0;
  List<SipPojo> sipList = [];
  List<SipPojo> transactionList = [];
  List masterSummaryList = [];
  Map regStatus = {};

  // User data
  final int user_id = GetStorage().read("user_id");
  final String client_name = GetStorage().read("client_name");
  final int type_id = GetStorage().read("type_id");

  MutualFund mutualFund = MutualFund();
  UserDataPojo userDataPojo = UserDataPojo();

  String spinnerAmount = "10000";

  List<String> spinnerAmountList = [
    "10000",
    "20000",
    "30000",
    "40000",
    "50000",
    "100000",
  ];

  MasterPostfolioPojo masterPostfolioPojo = MasterPostfolioPojo();

  List<Color> chartColorList = [];

  List clientCodeList = [];

  Future getInvestorClientCode() async {
    if (clientCodeList.isNotEmpty) return 0;

    Map data = await ReportApi.getInvestorCode(
        user_id: user_id, client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    clientCodeList = data['client_code_list'];
    if ((keys.contains("adminAsInvestor")) ||
        (keys.contains("adminAsFamily")) != true)
      await getAllOnlineRestrictions();
    return 0;
  }

  // MARK: - Data Fetching Methods

  /// Fetches all required dashboard data
  Future<void> getDatas(BuildContext context) async {
    try {
      await Future.wait([
        getInvestorClientCode(),
        controller.getInvestPerformance(),
        getMasterPortfolio(),
        getSipList(),
        getTransactionList(),
        getUser(),
        getUserRegStatus(),
        getCartCount(context),
        getAllOnlineRestrictions(),
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

  /// Fetches master portfolio data with caching
  Future<void> getMasterPortfolio() async {
    if (!isFirst) return;

    try {
      final data = await InvestorApi.getMasterPortfolio(
          user_id: user_id, client_name: client_name);

      if (data['status'] != 200) {
        throw Exception(data['msg']);
      }

      masterPostfolioPojo = MasterPostfolioPojo.fromJson(data);
      total = masterPostfolioPojo.totalCurrentValue ?? 0;
      masterSummaryList = data['master_summary_list'];
      mutualFund = masterPostfolioPojo.mutualFund ?? MutualFund();
    } catch (e) {
      print('Error fetching portfolio: $e');
      rethrow;
    }
  }

  Future getSipList() async {
    if (!isFirst) return 0;

    Map data = await InvestorApi.getSipMasterDetails(
        user_id: user_id, client_name: client_name, max_count: '5');
    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      return 0;
    }
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
    await GetStorage().write("goals_flag", userDataPojo.goalFlag);
    await GetStorage().write("risk_profile_flag", userDataPojo.riskprofileFlag);

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

    Map data =
        await Api.getCartCounts(user_id: user_id, client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    Map result = data['result'];
    cartCount.value = result['total_count'];

    return 0;
  }

  Iterable keys = GetStorage().getKeys();
  List investorList = [];
  late Map<String, dynamic> datas;
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

  List pages = [
    InvestorDashboard(),
    InvestorMasterPortfolio(showAppBar: false),
    InvestorReportMenu(),
    InvestorMenu(),
  ];

  bool isvisible = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    // Initialize user name
    name = InvestorDashboard.user_name ??
        Utils.getFirst13(GetStorage().read("user_name"));
  }

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

  @override
  Widget build(BuildContext context) {
    if (client_name == 'bohofinserv') return InvestorDashboardBoho();

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
                showCartIcon:
                    clientCodeList != null && clientCodeList.isNotEmpty,
              ),
              // appBar: appBar(),
              backgroundColor: Config.appTheme.mainBgColor,
              // body: (selectedPage == 0) ? invDashboard() : pages[selectedPage],
              body: IndexedStack(
                index: selectedPage,
                children: [
                  // InvestorDashboard(),
                  invDashboard(),
                  if (clientCodeList != null && clientCodeList.isNotEmpty)
                    TransactMenu(),
                  InvestorReportMenu(),
                  // InvestorMasterPortfolio(showAppBar: false),
                  InvestorMenu(),
                ],
              ),
              // bottomNavigationBar: normalBottomSheet(),
              bottomNavigationBar: (liveVersion > localVersion)
                  ? updateBottomSheet()
                  : normalBottomSheet(),
            );
          }),
    );
  }

  Widget normalBottomSheet({BorderRadius? borderRadius}) {
    return SizedBox(
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
            if (clientCodeList != null && clientCodeList.isNotEmpty)
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
    return Column(
      mainAxisSize: MainAxisSize.min,
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
            InkWell(
                onTap: () {
                  Get.to(InvestorMasterPortfolio(showAppBar: true));
                },
                child: investmentCard()),
            (isFirst)
                ? Utils.shimmerWidget(220, margin: EdgeInsets.all(16))
                : InkWell(
                    onTap: () {
                      Get.to(MutualFundScreen());
                    },
                    child: summaryCard()),
            openCard(),
            talkToExpert(),
            SizedBox(height: 16),
            if (sipList.isNotEmpty) sideHeading("My SIPs"),
            if (sipList.isNotEmpty) SizedBox(height: 16),
            if (sipList.isNotEmpty) sipArea(),
            if (sipList.isNotEmpty)
              viewAllBtn(
                  title: "View All SIPs",
                  onPressed: () {
                    Get.to(SipPortfolioSummary(
                      selectType: 'SIP',
                    ));
                    // Get.to(SipDetails());
                  }),
            //exploreCard(),
            if (anyToolsAvailable) sideHeading("Explore Popular Tools"),
            if (anyToolsAvailable) SizedBox(height: 8),
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
                                : Config.appTheme.universalTitle;
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
            if (anyToolsAvailable)
              SizedBox(
                height: 16,
              ),
            sideHeading("Recent Transactions"),
            SizedBox(height: 16),
            trnxArea(),
            if (transactionList.isNotEmpty)
              viewAllBtn(
                  title: "View All Transactions",
                  onPressed: () {
                    Get.to(MutualFundScreen());
                    // EasyLoading.showInfo("Design Pending");
                  }),
            performanceComparisonCard(),
            /*if ((userDataPojo.mfresearchFlag == true ||
                userDataPojo.calculatorFlag == true))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 222,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      if (userDataPojo.mfresearchFlag == true)
                        ResearchCard(
                          image: 'assets/research_Tools.png',
                          title: "Mutual Fund Research",
                          subTitle: "15+ research tools",
                          isWhite: true,
                          color: Config.appTheme.themeColor,
                          goTo: MfResearch(),
                        ),
                      if (userDataPojo.calculatorFlag == true)
                        ResearchCard(
                          image: 'assets/tools_Calculators.png',
                          title: "Tools & Calculators",
                          subTitle: "10+ calculators",
                          isWhite: false,
                          color: Config.appTheme.universalTitle,
                          goTo: Calculators(),
                        ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),*/
          ],
        ),
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
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
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
    final InvestorPerformanceController controller = Get.find();

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Start Date : ${sip.startdate}", style: AppFonts.f40013),
              Text("End Date : ${sip.enddate}", style: AppFonts.f40013),
            ],
          ),
          SizedBox(height: 10),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text("Units : ${sip.sipDate}", style: AppFonts.f40013),
          //     Text("XIRR : ${sip.sipDate}%", style: AppFonts.f40013),
          //   ],
          // ),
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
              : Container(
                  margin: EdgeInsets.fromLTRB(16, 10, 16, 16),
                  decoration: BoxDecoration(
                    color: Config.appTheme.whiteOverlay,
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
                              "Current Value",
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
                              fontSize: 25),
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

          return rowIcon(title, value);
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
                .copyWith(fontSize: 25, color: Config.appTheme.themeColor),
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

  Widget exploreCard() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
          border: Border.all(color: Config.appTheme.themeColor, width: 1.2),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Explore Popular Tools", style: AppFonts.f50014Grey),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              getCircleCard("Calculators", "calculator.png"),
              getCircleCard("Goals", "goalbased_lumpsum.png"),
              getCircleCard("Risk Profile", "risk_profile.png")
            ],
          ),
        ],
      ),
    );
  }

  Column getCircleCard(String heading, String image) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            if (heading == "Calculators") {
              Get.to(Calculators());
            } else if (heading == "Goals") {
              //Get.to(Goal1());
            } else if (heading == "Risk Profile") {
              Get.to(RiskProfile());
            }
          },
          child: Container(
            padding: EdgeInsets.all(16.0),
            height: 60,
            width: 60,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            /*decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/home_ellipse.png"),
                    fit: BoxFit.cover)
            ),*/
            decoration: BoxDecoration(
              color: Color(0xFFF5F8FC),
              shape: BoxShape.circle,
              border: Border.all(color: Color(0XFFF5F8FC), width: 1),
            ),
            child: Image.asset(
              "assets/$image",
              alignment: Alignment.center,
              color: Config.appTheme.themeColor,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          heading,
          style: AppFonts.f40013,
        ),
        SizedBox(
          height: 10,
        ),
      ],
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
          "1 Day Change ",
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
          padding: EdgeInsets.only(right: 16, bottom: 0, top: 0),
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
}

class InvestorPerformanceController extends GetxController {
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
