import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/Family/FamilyReportMenu.dart';
import 'package:mymfbox2_0/Investor/InvestorDashboard.dart';
import 'package:mymfbox2_0/Investor/reports/InvestorInvestmentSummary.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/api/FamilyApi.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/family/FamilyMasterPortfolio.dart';
import 'package:mymfbox2_0/family/FamilyMenu.dart';
import 'package:mymfbox2_0/pojo/FamilyDataPojo.dart';
import 'package:mymfbox2_0/pojo/OnlineTransactionRestrictionPojo.dart';
import 'package:mymfbox2_0/pojo/SipPojo.dart';
import 'package:mymfbox2_0/rp_widgets/AmcChip.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DayChange.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/PercentageBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile2.dart';
import 'package:mymfbox2_0/rp_widgets/SelectedAmcChip.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/rp_widgets/SipRoundIcon.dart';
import 'package:mymfbox2_0/rp_widgets/UpdateBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../api/ReportApi.dart';
import '../common/MFInvestPerformanceResponse.dart';
import '../pojo/familyCurrentPortfolioPojo.dart';

class FamilyDashboard extends StatefulWidget {
  const FamilyDashboard({super.key});

  @override
  State<FamilyDashboard> createState() => _FamilyDashboardState();
}

class _FamilyDashboardState extends State<FamilyDashboard> {
  final InvestPerformanceController controller =
      Get.put(InvestPerformanceController());

  late double devWidth, devHeight;
  String familyEmail = "";
  List<Widget> pages = [
    FamilyDashboard(),
    FamilyMasterPortfolio(showAppBar: false),
    FamilyReportMenu(memberList: []),
    FamilyMenu(memberList: [])
  ];
  int selectedPage = 0;
  int user_id = GetStorage().read("family_id");
  String client_name = GetStorage().read("client_name");
  String mobile = GetStorage().read("family_mobile") ?? "";
  String email = "";
  Map summary = {};

  List sipSummaryList = [];
  bool isOpen = false;
  String name = "";
  List memberList = [];
  List<Color> colorList = [
    Colors.purple,
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.red,
  ];

  double sliderMaxValue = 100.0;
  double sliderMinValue = 0.0;

  double mfReturn = 0.0;
  double mfValue = 0.0;

  double niftyReturn = 0.0;
  double niftyValue = 0.0;

  double goldReturn = 0.0;
  double goldValue = 0.0;

  double fdReturn = 0.0;
  double fdValue = 0.0;

  String spinnerAmount = "10000";

  List<String> spinnerAmountList = [
    "10000",
    "20000",
    "30000",
    "40000",
    "50000",
    "100000",
  ];

  String getFirst13(String text) {
    String s = text.split(":").last;
    if (s.length > 13) s = s.substring(0, 13);
    return s;
  }

  String selectedSort = "Returns";
  late List broadCategoryList = [];
  late List categoryList = [];
  String selectedCategory = "All";

  Map folioMap = {
    "Live Folio": "Live",
    "Portfolio with Live Transactions": "",
    "All Folios": "All",
    "Non segregated Folios": "NonSegregated",
    "MF bought in our code": "MF Without other ARN",
    "MF bought from others": "MF bought from others"
  };
  String selectedFolioType = "Live";
  DateTime selectedFolioDate = DateTime.now();
  ExpansionTileController controller1 = ExpansionTileController();
  ExpansionTileController controller2 = ExpansionTileController();

  RxBool summaryDetailsLoading = true.obs;

  Future getSummaryDetails() async {
    if (summary.isNotEmpty) return 0;
    summaryDetailsLoading.value = true;
    Map data = await FamilyApi.getSummaryDetails(
      user_id: user_id,
      client_name: client_name,
      folio_type: selectedFolioType,
      selected_date: selectedFolioDate,
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['status_msg']);
      return -1;
    }
    summary = data['summary'];
    summaryDetailsLoading.value = false;
    return 0;
  }

  RxBool memberDetailsLoading = true.obs;

  Future getMemberDetails() async {
    if (memberList.isNotEmpty) return 0;
    memberDetailsLoading.value = true;
    Map data = await FamilyApi.getMembersDetails(
      user_id: user_id,
      client_name: client_name,
      folio_type: selectedFolioType,
      selected_date: selectedFolioDate,
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['status_msg']);
      return -1;
    }
    memberList = data['member_list'];
    email = data['member_list'][0]['email'];

    var familyHead = memberList.firstWhere(
      (member) => member['relation'] == 'Family Head',
      orElse: () => null,
    );

    if (familyHead != null) {
      email = familyHead['email'];
      mobile = familyHead['mobile'];
      mobile = familyHead['mobile'];
      print("Family Head Email: $mobile");
      await GetStorage().write("family_email", email);
    } else {
      Utils.showError(context, "No Family Head found in the member list.");
      return -1;
    }
    memberDetailsLoading.value = false;
    return 0;
  }

  String formatDate(DateTime date) {
    String day =
        date.day.toString().padLeft(2, '0'); // Ensure two digits for day
    String month =
        date.month.toString().padLeft(2, '0'); // Ensure two digits for month
    String year = date.year.toString(); // Year
    return '$day-$month-$year'; // Return formatted date
  }

  MfSummary mfSummary = MfSummary();
  List<FamilyCurrentPortfolioPojo> schemeList = [];
  List<MfSchemeSummary> mfSchemeSummaryList = [];

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
    List mflist = data['mf_scheme_summary'];
    convertListToObj(mflist);
    return;
  }

  void convertListToObj(List mflist) {
    mfSchemeSummaryList =
        mflist.map((item) => MfSchemeSummary.fromJson(item)).toList();
  }

  List chartList = [];
  List<ChartData> chartData = [];

  Future getMfPortfolioHistory() async {
    if (chartList.isNotEmpty) return 0;

    Map data = await FamilyApi.getMfPortfolioHistory(
      user_id: user_id,
      client_name: client_name,
      frequency: "Last $selectedMonth Months",
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['status_msg']);
      return -1;
    }

    List list = data['list'];
    chartData = [];
    list.forEach((element) {
      chartData.add(ChartData.fromJson(element));
    });

    return 0;
  }

  RxBool sipSummaryDetailsLoading = true.obs;

  Future getSipMasterDetails() async {
    if (sipSummaryList.isNotEmpty) return 0;
    sipSummaryDetailsLoading.value = true;
    Map data = await FamilyApi.getSipMasterDetails(
        user_id: user_id, client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['status_msg']);
      return -1;
    }
    sipSummaryList = data['list'];
    sipSummaryDetailsLoading.value = true;
    return 0;
  }

  Future getBroadCategoryWisePortfolio() async {
    if (broadCategoryList.isNotEmpty) return 0;
    Map data = await FamilyApi.getBroadCategoryWisePortfolio(
        user_id: user_id,
        client_name: client_name,
        folio_type: selectedFolioType,
        selected_date: selectedFolioDate);
    if (data['status'] != 200) {
      Utils.showError(context, data['status_msg']);
      return -1;
    }
    broadCategoryList = data['broad_category_list'];
    return 0;
  }

  Future getCategoryWisePorfolio() async {
    if (categoryList.isNotEmpty) return 0;
    Map data = await FamilyApi.getCategoryWisePorfolio(
        user_id: user_id,
        client_name: client_name,
        broad_category: selectedCategory);

    if (data['status'] != 200) {
      Utils.showError(context, data['status_msg']);
      return -1;
    }
    categoryList = data['category_list'];
    return 0;
  }

  List amcList = [];

  Future getAmcWisePortfolio() async {
    if (amcList.isNotEmpty) return 0;

    Map data = await FamilyApi.getAmcWisePortfolio(
        user_id: user_id, client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['status_msg']);
      return -1;
    }
    amcList = data['amc_list'];
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

  String appUrl = "";
  Version localVersion = Version(1, 0, 0);
  Version liveVersion = Version(1, 0, 0);

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
      String app_store_version = data['play_store_version'];
      if (app_store_version.isEmpty) return 0;
      liveVersion = Version.parse(app_store_version);
      appUrl = data['app_store_link'];
    }
    return 0;
  }

  convertTo3Digit(String s) {
    List versList = s.split(".");
    if (versList.length == 2) s = "$s.0";
    return s;
  }

  Future getDatas() async {
    await Future.wait(
        [getSummaryDetails(), getMemberDetails(), getSipMasterDetails()]);
    await getfamilyCurrentPortfolio();
    await getBroadCategoryWisePortfolio();
    await getCategoryWisePorfolio();
    await getAmcWisePortfolio();
    await getMfPortfolioHistory();
    await getAllOnlineRestrictions();
    await getLatestVersion();
    controller.getInvestPerformance();
    return 0;
  }

  Color appBarColor = Config.appTheme.themeColor;
  Color fgColor = Colors.white;

  @override
  void initState() {
    //  implement initState
    super.initState();
    name = Utils.getFirst13(GetStorage().read("family_name"));
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        await _showConfirmationDialog(context);
      },
      child: FutureBuilder(
          future: getDatas(),
          builder: (context, snapshot) {
            return Scaffold(
                backgroundColor: Config.appTheme.mainBgColor,
                appBar: (selectedPage != 1)
                    ? invAppBar(
                        toolbarHeight: 58,
                        bgColor: appBarColor,
                        fgColor: fgColor,
                        showCartIcon: false,
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
                        title: "Family of $name",
                        actions: [
                          if (selectedPage == 0) ...[
                            if (((keys.contains("adminAsInvestor")) ||
                                (keys.contains("adminAsFamily")) != false))
                              InkWell(
                                onTap: () {
                                  String value =
                                      Utils.formatNumber(summary['curr_value']);
                                  print("$value");
                                  if (value != "0") {
                                    whatsappshare(mobile);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Member contains 0 value",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor:
                                            Config.appTheme.themeColor,
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
                            SizedBox(width: 20),
                          ],
                        ],
                      )
                    : rpAppBar(
                        bgColor: Config.appTheme.themeColor,
                        title: "Family of $name",
                        foregroundColor: Colors.white,
                      ),
                body: (selectedPage != 0)
                    ? pages[selectedPage]
                    : SideBar(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              familySummaryCard(),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 16),
                                    membersArea(),
                                    //talkToExpert(),
                                    SizedBox(height: 16),
                                    Text("Family SIPs"),
                                    SizedBox(height: 16),
                                    sipSummaryArea(),
                                    SizedBox(height: 16),
                                    broadCategory(),
                                    SizedBox(height: 16),
                                    if (chartData.length > 1) chartArea(),
                                    SizedBox(height: 16),

                                    amcOverviewCard(),
                                    SizedBox(height: 16),
                                    performanceComparisonCard(),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                bottomNavigationBar: (liveVersion > localVersion)
                    ? updateBottomSheet()
                    : normalBottomSheet());
          }),
    );
  }

  // TextEditingController? numberController;

  Future<void> whatsappshare(String mobile) {
    TextEditingController numberController =
        TextEditingController(text: mobile);
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
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Send WhatsApp Message',
                          style: AppFonts.f40016
                              .copyWith(color: Colors.black, fontSize: 20)),
                      content: Text(
                          "Are you sure, you want to Send the Message?",
                          style: AppFonts.f40016.copyWith(
                              color: Config.appTheme.themeColor, fontSize: 16)),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text('Cancel',
                              style: AppFonts.f40016.copyWith(
                                  color: Config.appTheme.defaultLoss,
                                  fontSize: 16)),
                        ),
                        TextButton(
                          onPressed: () {
                            String? mobile = numberController!.text;
                            _sendMessage(
                                mobile, mfSummary, mfSchemeSummaryList);
                            Get.back();
                          },
                          child: Text('Send',
                              style: AppFonts.f40016.copyWith(
                                  color: Config.appTheme.themeColor,
                                  fontSize: 16)),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Confirm',
                  style: AppFonts.f40016.copyWith(
                      color: Config.appTheme.themeColor, fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  String shareURl = "";

  Future getWhatsappShareLink({required int faminvestorId}) async {
    Map data = await InvestorApi.getWhatsappShareLink(
        user_id: faminvestorId, client_name: client_name);
    shareURl = data['msg'];
    print("ALL Family share url $shareURl");
    return 0;
  }

  Future<void> _sendMessage(String mobile, MfSummary mfSummary,
      List<MfSchemeSummary> mfSchemeSummary) async {
    String value = Utils.formatNumber(mfSummary.totalCurrValue ?? 0);
    String cost = Utils.formatNumber(mfSummary.totalCurrCost ?? 0);
    String unrealgain = Utils.formatNumber(mfSummary.totalUnrealisedGain ?? 0);
    String realgain = Utils.formatNumber(mfSummary.totalRealisedGain ?? 0);
    String AbsRtn = Utils.formatNumber(mfSummary.totalAbsRtn ?? 0);

    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    // Accumulate scheme details
    String schemeDetails = '';
    for (var scheme in mfSchemeSummary) {
      final investorName = scheme.investorName ?? '';
      final currentCost = Utils.formatNumber(scheme.currentCost ?? 0);
      final currentValue = Utils.formatNumber(scheme.currentValue ?? 0);
      final unrealisedGain = Utils.formatNumber(scheme.unrealisedGain ?? 0);
      final realisedGain = Utils.formatNumber(scheme.realisedGain ?? 0);
      final absRtn = Utils.formatNumber(scheme.absRtn ?? 0.0);
      final xirr = Utils.formatNumber(scheme.xirr ?? 0.0);

      // 📌 *Realized Gain/Loss : RS.$realisedGain*
      // 📌 *Realized Gain/Loss : RS.$realgain*
      schemeDetails += '''
      
  *$investorName*

📌 *Current Cost : Rs $currentCost*
📌 *Current Value : Rs $currentValue*
📌 *Unrealized Gain/Loss : Rs $unrealisedGain*
📌 *Absolute Return : $absRtn%*
📌 *XIRR : $xirr%*     
''';
    }
    int faminvestorId = user_id ?? 0;
    await getWhatsappShareLink(faminvestorId: faminvestorId);

    String websiteUrl = '''Dear ${name.toUpperCase()},
    
Greetings for the Day!

Below 👇 is the snapshot of your Mutual Fund Investments as on $formattedDate

*Family's Total*

📌 *Current Cost : Rs $cost*
📌 *Current Value : Rs $value*
📌 *Unrealized Gain/Loss : Rs $unrealgain*
📌 *Absolute Return : $AbsRtn%*
$schemeDetails
To view the detailed portfolio, please login using the link below.
$shareURl

Please call us for more details.

Assuring you of our best services always!

*Thank you!*
${client_name.toUpperCase()}''';

    var whatsappUrl =
        "https://wa.me/$mobile?text=${Uri.encodeComponent(websiteUrl)}";
    if (await canLaunch(whatsappUrl) != null) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  Widget updateBottomSheet() {
    return SizedBox(
      height: 128,
      child: Column(
        children: [
          UpdateBar(onUpdate: () async {
            await launchUrlString(appUrl);
          }, onClose: () {
            liveVersion = localVersion;
            setState(() {});
          }),
          Divider(
            height: 0,
          ),
          normalBottomSheet(borderRadius: BorderRadius.zero),
        ],
      ),
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
              pages[3] = FamilyMenu(memberList: memberList);
              appBarColor = Colors.transparent;
              fgColor = Config.appTheme.themeColor;
            } else {
              appBarColor = Config.appTheme.themeColor;
              fgColor = Colors.white;
            }

            setState(() {});
          },
          currentIndex: selectedPage,
          selectedItemColor: Config.appTheme.themeColor,
          unselectedItemColor: Colors.grey,
          //unselectedLabelStyle: TextStyle(color: Colors.black),

          selectedLabelStyle: TextStyle(
            color: Config.appTheme.themeColor, // Color of selected label
          ),
          showUnselectedLabels: true,

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
                'assets/database.png',
                width: 20,
                color: getColor(1),
              ),
              label: "Multi Assets",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.assessment,
                color: getColor(2),
              ),
              label: "Reports",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                color: getColor(3),
              ),
              label: "Profile",
            ),
          ],
        ),
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

  Widget membersArea() {
    return Obx(
      () {
        if (memberDetailsLoading.value)
          return Utils.shimmerWidget(300,
              margin: EdgeInsets.symmetric(vertical: 16));

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: memberList.length,
          itemBuilder: (context, index) {
            return investorSummaryCard(index);
          },
        );
      },
    );
  }

  Widget sipSummaryArea() {
    return Obx(
      () {
        if (summaryDetailsLoading.value)
          return Utils.shimmerWidget(300,
              margin: EdgeInsets.symmetric(vertical: 16));

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: sipSummaryList.length,
          itemBuilder: (context, index) {
            Map map = sipSummaryList[index];
            return sipTile(map);
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

  List sectorList = ["Top Sector", "Top Holdings"];

  Widget sectorCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Sector & Holdings", style: AppFonts.f40016),
          SizedBox(height: 16),
          //top chip
          SizedBox(
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (context, index) {
                return AmcChip(
                  title: "Top Sector",
                  hasValue: false,
                  value: "",
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 22),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sectors", style: AppFonts.f40013),
              Text("Allocation", style: AppFonts.f40013),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Financial", style: AppFonts.f50014Black),
                        Text("34.44%", style: AppFonts.f50014Black),
                      ],
                    ),
                    PercentageBar(30),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget holdingCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Holding Distribution", style: AppFonts.f40016),
          SizedBox(height: 16),
          //top chip
          SizedBox(
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (context, index) {
                return AmcChip(
                  title: "Equity Market Cap",
                  hasValue: false,
                  value: "",
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 22),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Large Cap", style: AppFonts.f50014Black),
                  Text("35%", style: AppFonts.f50014Black),
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                DottedLine(verticalPadding: 4),
          )
        ],
      ),
    );
  }

  bool showFullAmc = false;

  Widget amcOverviewCard() {
    if (memberList.isEmpty)
      return Utils.shimmerWidget(200, margin: EdgeInsets.zero);
    int displayLength = amcList.length;

    if (amcList.length > 5) {
      displayLength = (showFullAmc) ? amcList.length : 5;
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Amc Overview",
            style: AppFonts.f40016,
          ),
          SizedBox(height: 16),
          ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: displayLength,
              itemBuilder: (context, index) {
                Map amc = amcList[index];
                String logo = amc['logo'];
                String name = amc['amc_name'];

                String percent = amc['percent'].toStringAsFixed(2);
                String amount =
                    Utils.formatNumber(amc['value'], isAmount: true);

                return Row(
                  children: [
                    // Image.network(logo, height: 32),
                    Utils.getImage(logo, 32),
                    SizedBox(width: 10),
                    Expanded(child: Text(name, style: AppFonts.f50014Black)),
                    SizedBox(width: 5),
                    ColumnText(
                      title: "$percent %",
                      value: "(₹ $amount)",
                      titleStyle: AppFonts.f50014Black,
                      valueStyle: AppFonts.f40013,
                      alignment: CrossAxisAlignment.end,
                    ),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  DottedLine(verticalPadding: 4)),
          SizedBox(height: 16),
          if (amcList.length > 5)
            Center(
              child: TextButton(
                onPressed: () async {
                  showFullAmc = !showFullAmc;
                  setState(() {});
                },
                child: Text(showFullAmc ? "Show Less" : "Show More",
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor)),
              ),
            )
        ],
      ),
    );
  }

  double multiplier = 1;

  Widget percentageBar(double percent, int index) {
    double total = devWidth * 0.55;
    percent = (total * percent) / 100;

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
          width: percent * multiplier,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(10)),
        ),
      ],
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
              height: devHeight * 0.8,
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
                                selectedFolioDate = DateTime.now();
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
                                summary = {};
                                memberList = [];
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

  getKeyByValue(Map map, String value) {
    return map.keys.firstWhere((element) => map[element] == value);
  }

  Widget familySummaryCard() {
    return InkWell(
      onTap: () {
        Get.to(() => FamilyMasterPortfolio(showAppBar: true));
      },
      child: Obx(
        () {
          if (summaryDetailsLoading.value) {
            return Container(
              decoration: BoxDecoration(
                color: Config.appTheme.themeColor,
                borderRadius: BorderRadius.circular(0),
              ),
              child: Utils.shimmerWidget(160,
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 16)),
            );
          }

          // Extract summary details
          String value = Utils.formatNumber(summary['curr_value']);
          String cost = Utils.formatNumber(summary['curr_cost']);
          String gain = Utils.formatNumber(summary['unrealised_gain']);
          String xirr = "0";
          if (summary.isNotEmpty) {
            xirr = summary['portfolio_return'].toStringAsFixed(2);
          }
          double xirrvalue = double.tryParse(xirr) ?? 0.0;

          return Container(
            color: Config.appTheme.themeColor,
            child: Container(
              width: devWidth,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.fromLTRB(16, 10, 16, 16),
              decoration: BoxDecoration(
                color: Config.appTheme.whiteOverlay,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${getKeyByValue(folioMap, selectedFolioType)} as on ${Utils.getFormattedDate(date: selectedFolioDate)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: AppColors.readableGrey,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showCustomizedFilter();
                        },
                        child: Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "$rupee $value",
                    style: AppFonts.f70024
                        .copyWith(color: Config.appTheme.themeColor),
                  ),
                  if (userData.oneDayChange == 1 ||
                      (keys.contains("adminAsInvestor") ||
                          keys.contains("adminAsFamily") != false))
                    DayChange(
                      change_value: summary['day_change_value'],
                      percentage: summary['day_change_percentage'] ?? 0,
                    ),
                  SizedBox(height: 5),
                  DottedLine(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ColumnText(title: "Cost", value: "$rupee $cost"),
                      ColumnText(
                        title: "Unrealised Gain",
                        value: "$rupee $gain",
                        alignment: CrossAxisAlignment.center,
                      ),
                      ColumnText(
                        title: "XIRR",
                        value: "$xirr%",
                        valueStyle: TextStyle(
                          color: (xirrvalue > 0)
                              ? Config.appTheme.defaultProfit
                              : Config.appTheme.defaultLoss,
                          fontWeight: FontWeight.w500,
                        ),
                        alignment: CrossAxisAlignment.end,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget investorSummaryCard(int index) {
    FamilyDataPojo member = FamilyDataPojo.fromJson(memberList[index]);
    int colorIndex = index % colorList.length;
    familyEmail = member.email!;

    String currentValue = Utils.formatNumber(member.currentValue);
    String relation = member.relation ?? "";
    String mfHoldings = Utils.formatNumber(member.familyMfHoldings);
    relation = (relation.isEmpty) ? "Family Member" : "Member - $relation";
    num xirr = member.portfolioReturn ?? 0;

    return InkWell(
      onTap: () async {
        await loginAsInvestor(member);
      },
      child: Container(
        width: devWidth,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
        decoration: BoxDecoration(
            border: Border.all(color: Config.appTheme.themeColor, width: 1.2),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InitialCard(
                  bgColor: colorList[colorIndex],
                  title: member.name![0],
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${member.name}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          )),
                      Text(relation, style: AppFonts.f40013)
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward, color: Config.appTheme.themeColor)
              ],
            ),
            SizedBox(height: 16),
            Text(
              "$rupee $currentValue",
              style: AppFonts.f70024
                  .copyWith(fontSize: 32, color: Config.appTheme.themeColor),
            ),
            if (userData.oneDayChange == 1 ||
                ((keys.contains("adminAsInvestor")) ||
                    (keys.contains("adminAsFamily")) != false))
              DayChange(
                  change_value: member.dayChangeValue ?? 0,
                  percentage: member.dayChangePercentage ?? 0),
            SizedBox(height: 10),
            PercentageBar(member.familyMfHoldings!.toDouble()),
            SizedBox(height: 5),
            Text("($mfHoldings% of Family MF Holdings)",
                style: AppFonts.f40013),
            SizedBox(height: 5),
            DottedLine(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnText(
                    title: "Cost",
                    value: "$rupee ${Utils.formatNumber(member.currentCost)}"),
                ColumnText(
                    title: "Unrealised Gain",
                    value:
                        "$rupee ${Utils.formatNumber(member.unRealisedGain)}",
                    alignment: CrossAxisAlignment.center),
                ColumnText(
                    title: "XIRR",
                    value: "${member.portfolioReturn}%",
                    valueStyle: TextStyle(
                        color: (xirr > 0)
                            ? Config.appTheme.defaultProfit
                            : Config.appTheme.defaultLoss,
                        fontWeight: FontWeight.w500),
                    alignment: CrossAxisAlignment.end),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget talkToExpert() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(0, 16, 0, 16),
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
              style: AppFonts.f40013.copyWith(color: Colors.white)),
          SizedBox(height: 16),
          TextButton(
            onPressed: () {
              EasyLoading.showInfo("Design Pending");
            },
            style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 38)),
            child: Text("Talk to Our Expert", style: cardHeadingSmall),
          )
        ],
      ),
    );
  }

  bool expanded = false;

  Widget sipTile(Map map) {
    String name = map['investor_name'];
    List sipMaster = map['sip_master'];
    String relation = map['relation'] ?? "";

    return Padding(
      padding: EdgeInsets.only(bottom: 16),
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
          l2: relation,
          r1: "$rupee ${getSipTotal(sipMaster)}",
          r2: " ${map['sip_count']} SIPs",
          hasArrow: false,
          gap: 0,
        ),
        childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          (sipMaster.isEmpty)
              ? Text("No SIP Available")
              : ListView.separated(
                  itemCount: sipMaster.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    SipPojo sip = SipPojo.fromJson(sipMaster[index]);
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

  Future<void> loginAsInvestor(FamilyDataPojo userData) async {
    await GetStorage().write('familyAsInvestor', true);
    await GetStorage().write("user_id", userData.id);
    await GetStorage().write("user_name", userData.name);
    await GetStorage().write("user_pan", userData.pan);
    await GetStorage().write("user_mobile", userData.mobile);
    await GetStorage().write('user_email', userData.email);

    Get.off(() => InvestorDashboard());
  }

  getSipTotal(List sipMaster) {
    num total = 0;
    sipMaster.forEach((element) {
      total += element['sip_amount'];
    });
    return Utils.formatNumber(total);
  }

  bool showFullCategory = false;

  Widget broadCategory() {
    if (memberList.isEmpty)
      return Utils.shimmerWidget(200, margin: EdgeInsets.zero);

    int displayCategoryLength = categoryList.length;
    if (categoryList.length > 5) {
      displayCategoryLength = (showFullCategory) ? categoryList.length : 5;
    }
    return SizedBox(
      width: devWidth,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 0, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Broad Category Wise AUM", style: AppFonts.f40016),
              SizedBox(height: 16),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: broadCategoryList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    Map category = broadCategoryList[index];
                    String title = category['category_name'];
                    if (title.length > 4)
                      title = title.substring(0, title.length - 8);
                    double amount = category['category_value'] / 10000000;
                    double temp = category['category_percent'];
                    String percentage = temp.toStringAsFixed(2);
                    if (title.isEmpty || amount == 0) return SizedBox();

                    return (selectedCategory == title)
                        ? SelectedAmcChip(
                            title: title,
                            valueStyle: TextStyle(color: Colors.white),
                            value:
                                "$percentage % ($rupee ${amount.toStringAsFixed(2)} Cr)",
                          )
                        : AmcChip(
                            title: title,
                            value:
                                "$percentage % ($rupee ${amount.toStringAsFixed(2)} Cr)",
                            onTap: () {
                              selectedCategory = title;
                              categoryList = [];
                              setState(() {});
                            },
                          );
                  },
                ),
              ),
              SizedBox(height: 22),
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: displayCategoryLength,
                  itemBuilder: (context, index) {
                    Map data = categoryList[index];
                    String title = data['category_name'];
                    title = title.split(":").last.trim();
                    double percent = data['category_percent'];
                    num amount = data['category_value'];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(title,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Text("${percent.toStringAsFixed(2)} %",
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              percentageBar(percent, index),
                              Text(
                                  "($rupee ${Utils.formatNumber(amount, isAmount: true)})"),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (categoryList.length > 5)
                Center(
                  child: TextButton(
                    onPressed: () async {
                      showFullCategory = !showFullCategory;
                      setState(() {});
                    },
                    child: Text(showFullCategory ? "Show Less" : "Show More",
                        style: AppFonts.f50014Black
                            .copyWith(color: Config.appTheme.themeColor)),
                  ),
                )
            ],
          ),
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
              "Family MF Portfolio History",
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
              activeBgColor: [Config.appTheme.buttonColor],
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
          isVisible: false,
          rangePadding: ChartRangePadding.additional,
        ),
        trackballBehavior: trackballBehavior,
        series: <CartesianSeries<ChartData, String>>[
          SplineAreaSeries(
            name: "Current Value",
            enableTooltip: true,
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
            borderColor: Color(0xFF388E3C),
            borderWidth: 2,
            dataSource: chartData,
            dataLabelSettings: DataLabelSettings(isVisible: false),
          ),
          SplineAreaSeries(
            name: "Invested Amount",
            enableTooltip: true,
            xValueMapper: (ChartData sales, _) => sales.aumMonthStr,
            yValueMapper: (ChartData sales, _) => sales.investedAmount,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0xFF64B5F6).withOpacity(0.8),
                Color(0xFF64B5F6).withOpacity(0.2)
              ],
              tileMode: TileMode.mirror,
            ),
            borderColor: Color(0xFF2196F3),
            borderWidth: 2,
            dataSource: chartData,
            dataLabelSettings: DataLabelSettings(isVisible: false),
          ),
        ],
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
    "Download Current portfolio PDF": ["", "", "assets/pdf.png"],
    "Email Current portfolio Report": ["", null, "assets/email.png"],
  };

  Widget reportActionContainer() {
    InvestorDetails investorDetails =
        InvestorDetails(userId: user_id, email: email);
    List<InvestorDetails> investorDetailsList = [];
    investorDetailsList.add(investorDetails);

    String investor_details = jsonEncode(investorDetailsList);
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
                      "${ApiConfig.apiUrl}/admin/family/getFamilySummary?key=${ApiConfig.apiKey}"
                      "&investor_details=$investor_details&mobile=$mobile&type=download&client_name=$client_name";

                  http.Response response = await http.post(Uri.parse(url));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  String resUrl = data['msg'];
                  print("download $url");
                  rpDownloadFile(url: resUrl, index: index);
                  Get.back();
                } else if (index == 1) {
                  String url =
                      "${ApiConfig.apiUrl}/admin/family/getFamilySummary?key=${ApiConfig.apiKey}"
                      "&investor_details=$investor_details&mobile=$mobile&type=download&client_name=$client_name";
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

  List<bool> isSelected = [false, false, true, false, false, false];
  Color txtcolor = Color(0xFF6F828E);
  String togglePeriod = "3Y";

  Widget performanceComparisonCard() {
    print("MF Value: ${controller.mfValue.value}");
    print("niftyReturn Value: ${controller.niftyReturn.value}");
    print("goldValue Value: ${controller.goldValue.value}");

    return Obx(() {
      return Container(
        //padding: EdgeInsets.all(16),
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
    final InvestPerformanceController controller = Get.find();

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

class ChartData {
  num? currValue;
  num? investedAmount;
  String? aumMonthStr;

  ChartData({
    this.currValue,
    this.investedAmount,
    this.aumMonthStr,
  });

  ChartData.fromJson(Map<String, dynamic> json) {
    currValue = json['curr_value'];
    investedAmount = json['invested_amount'];
    aumMonthStr = json['aum_month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['curr_value'] = currValue;
    data['invested_amount'] = investedAmount;
    data['aum_month'] = aumMonthStr;

    return data;
  }
}

class InvestPerformanceController extends GetxController {
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
