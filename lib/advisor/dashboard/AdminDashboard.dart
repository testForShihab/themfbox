import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/advisor/BirthdayAnniversary.dart';
import 'package:mymfbox2_0/advisor/Investor/AllFamilies.dart';
import 'package:mymfbox2_0/advisor/Investor/AllInvestor.dart';
import 'package:mymfbox2_0/advisor/Investor/AllRM.dart';
import 'package:mymfbox2_0/advisor/Investor/AllSubBroker.dart';
import 'package:mymfbox2_0/advisor/Investor/CreateClient.dart';
import 'package:mymfbox2_0/advisor/adminprofile/AdminProfile.dart';
import 'package:mymfbox2_0/advisor/blogs/Blogs.dart';
import 'package:mymfbox2_0/advisor/Investor/AboutInvestors.dart';
import 'package:mymfbox2_0/advisor/news/News.dart';
import 'package:mymfbox2_0/advisor/brokerage/BrokerageDashboard.dart';
import 'package:mymfbox2_0/advisor/dashboard/AumCard.dart';
import 'package:mymfbox2_0/advisor/aum/AumDetails.dart';
import 'package:mymfbox2_0/advisor/dashboard/ResearchCard.dart';
import 'package:mymfbox2_0/advisor/reports/TansactionReport.dart';
import 'package:mymfbox2_0/advisor/sip/activeSip/ActiveSip.dart';
import 'package:mymfbox2_0/advisor/sip/activeSip/ActiveSipHome.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/advisor/AdminMenu.dart';
import 'package:mymfbox2_0/login/CheckAuth.dart';
import 'package:mymfbox2_0/login/CheckUserType.dart';
import 'package:mymfbox2_0/research/Calculators.dart';
import 'package:mymfbox2_0/advisor/sip/SipDashboard.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/UpdateBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Restrictions.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../rp_widgets/SortButton.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late double devHeight, devWidth;
  String mfd_name = GetStorage().read('mfd_name');
  String client_name = GetStorage().read("client_name");
  int mfd_id = getUserId();
  int type_id = GetStorage().read("type_id");
  //testing

  List headings = ["3", "7", "10", "30"];
  String selectedHeading = "3";
  num monthAmount = 0;
  num yearAmount = 0;
  bool brokerage_flag = true;

  @override
  void initState() {
    super.initState();
  }

  Map dashboardData = {};
  Map get30DayData = {};
  bool isLoading = true;
  int selectedPage = 0;

  Future getDatas() async {
    await getDashboardData();
    await getPurchaseRedeemDetail();
    /*try {
      await getLatestVersion();
    } catch (e) {
      print("getDatas Exception = $e");
    }*/
    isLoading = false;
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

  Future getDashboardData() async {
    if (dashboardData.isNotEmpty) return 0;
    try {
      String client_name = GetStorage().read("client_name");
      dashboardData = await AdminApi.getDashboardData(
          user_id: "$mfd_id", client_name: client_name);
      print("dashboardData = $dashboardData");
      monthAmount = dashboardData['brokerage_amount'] ?? 0;
      yearAmount = dashboardData['brokerage_cfy_value'] ?? 0;
      brokerage_flag = dashboardData['brokerage_flag'];
      if (dashboardData['status'] != 200)
        EasyLoading.showError(dashboardData['message']);
      return 0;
    } catch (e) {
      print("Exception on read = $e");
    }
  }

  String getFirst13(String text) {
    String s = text.split(":").first;
    if (s.length > 13) s = '${s.substring(0, 13)}...';
    return s;
  }

  RxBool summaryLoading = true.obs;
  RxString summaryError = "".obs;
  Future getPurchaseRedeemDetail() async {
    if (get30DayData.isNotEmpty) return 0;
    summaryLoading.value = true;

    try {
      String client_name = GetStorage().read("client_name");
      Map data = await Api.getPurchaseAndRedemptionDetails(
          client_name: client_name, days: selectedHeading);
      if (data['status'] != 200) {
        EasyLoading.showError(data['message']);
        summaryLoading.value = false;
        return -1;
      }
      get30DayData = data['summary'];
    } catch (e) {
      summaryError.value = "Exception";
    }

    summaryLoading.value = false;
    return 0;
  }

  List pages = [
    AdminDashboard(),
    AboutInvestors(showAppBar: false, scrollToFamilies: false),
    AdminMenu()
  ];
  int todayDate = DateTime.now().year;
  Key pageKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: adminAppBar(
              leading: GestureDetector(
                onTap: () {
                  if (Restrictions.isBranchApiAllowed) Get.to(AdminProfile());
                },
                child: CircleAvatar(
                  backgroundColor: Config.appTheme.themeColor,
                  child: Text(
                    mfd_name[0],
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              title: "Hello ${getFirst13(mfd_name)} 👋🏻",
              subTitle: Utils.greeting(),
              hasAction: false,
              suffix: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Get.to(() => BirthdayAnniversary());
                      },
                      child: Image.asset("assets/cake.png",
                          height: 40 * Utils.getImageScaler)),
                  // if (type_id == 9)
                  if (GetStorage().read("superAdminAsAdmin") == true)
                    InkWell(
                        onTap: () async {
                          await GetStorage().remove("superAdminAsAdmin");
                          await GetStorage().write("type_id", 9);
                          Get.offAll(() => CheckUserType());
                        },
                        child:
                            Icon(Icons.power_settings_new, color: Colors.red))
                ],
              ),
            ),
            bottomNavigationBar: (liveVersion > localVersion)
                ? updateBottomSheet()
                : normalBottomSheet(),
            body: (selectedPage != 0)
                ? pages[selectedPage]
                : SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            SizedBox(height: 12),
                            (isLoading)
                                ? Utils.shimmerWidget(130,
                                    margin: EdgeInsets.all(0))
                                : GestureDetector(
                                    onTap: () {
                                      Get.to(() => AumDetails());
                                    },
                                    child:
                                        AumCard(dashboardData: dashboardData)),

                           if(brokerage_flag == true)SizedBox(height: 20),

                            (isLoading)
                                ? Utils.shimmerWidget(130,
                                    margin: EdgeInsets.all(0))
                                : (brokerage_flag == false)
                                    ? Container()
                                    : brokerageSummary(),
                            // if (Restrictions.isBranchApiAllowed)
                            SizedBox(height: 20),
                            (isLoading)
                                ? Utils.shimmerWidget(130,
                                    margin: EdgeInsets.all(0))
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: investorSummary("Investors")),
                                      SizedBox(width: 12),
                                      Expanded(
                                          child: investorSummary("Families")),
                                    ],
                                  ),
                            if (type_id == UserType.RM) SizedBox(height: 20),
                            if (type_id == UserType.RM)
                              (isLoading) ? Utils.shimmerWidget(130,
                                  margin: EdgeInsets.all(0))
                                  : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: investorSummary("Associate")),
                                ],
                              ),

                            if (type_id == UserType.BRANCH)SizedBox(height: 20),
                            if (type_id == UserType.BRANCH) (isLoading)
                                  ? Utils.shimmerWidget(130,
                                      margin: EdgeInsets.all(0))
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: investorSummary("RM")),
                                        SizedBox(width: 12),
                                        Expanded(
                                            child:
                                                investorSummary("Associate")),
                                      ],
                                    ),
                            if (type_id != UserType.ASSOCIATE ||
                                type_id != UserType.BRANCH)
                              SizedBox(height: 20),

                            if (type_id == UserType.ADMIN ||
                                type_id == UserType.RM ||
                                type_id == UserType.ASSOCIATE)
                              (isLoading)
                                  ? Utils.shimmerWidget(50,
                                      margin: EdgeInsets.all(0))
                                  : InkWell(
                                      onTap: () {
                                        Get.to(() => CreateClient());
                                      },
                                      child: extraButton(
                                        image: "assets/add_contact.png",
                                        text: "Sign up New Investor",
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Color(0Xff333333),
                                          border: Border.all(
                                              color: Config
                                                  .appTheme.universalTitle),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/noise.png")),
                                        ),
                                      ),
                                    ),
                            if (type_id == UserType.ADMIN ||
                                type_id == UserType.RM ||
                                type_id == UserType.ASSOCIATE)
                              SizedBox(height: 16),
                            /*  (isLoading)
                              ? Utils.shimmerWidget(50,
                                  margin: EdgeInsets.all(0))
                              : InkWell(
                                  onTap: () async {
                                    // EasyLoading.showInfo("Under Development");
                                    // String url =
                                    //     "http://10.14.14.219:3000/set-cookie";
                                    
                                    // http.Response response =
                                    //     await http.post(Uri.parse(url));
                                    
                                    Map<String, String> headers = {
                                      "connection": "keep-alive",
                                      "x-powered-by": "Express",
                                      "access-control-allow-credentials":
                                          "true",
                                      "keep-alive": "timeout=5",
                                      "set-cookie": "name=Prabhu; Path=/",
                                      "date": "Wed, 28 Aug 2024 06:41:04 GMT",
                                      "vary": "Origin",
                                      "content-length": "11",
                                      "etag":
                                          "W/\"b-YrvnAL06DHRnWauEaUpuqKsBZfs\"",
                                      "content-type":
                                          "text/html; charset=utf-8"
                                    };
                                    String url =
                                        "http://10.14.14.219:3000/get-cookie";
                                    
                                    http.Response response = await http.post(
                                        Uri.parse(url),
                                        headers: headers);
                                  },
                                  child: Text(""),
                                  /*child: extraButton(
                                      image: "assets/contacts.png",
                                      text: "Help 15 Investors in KYC",
                                      isArrowWhite: false,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Config
                                                  .appTheme.universalTitle))),*/
                                ),*/
                            // SizedBox(height: 20),
                            /*if (type_id == UserType.ADMIN ||
                              type_id == UserType.RM)*/
                            (isLoading)
                                ? Utils.shimmerWidget(130,
                                    margin: EdgeInsets.all(0))
                                : sipSummary(),
                            SizedBox(height: 20),
                            // oldCard(),
                            if (Restrictions.isBranchApiAllowed) newCard(),
                            if (Restrictions.isBranchApiAllowed)
                              SizedBox(height: 18),
                            SizedBox(
                              height: 222,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  ResearchCard(
                                    image: 'assets/research_Tools.png',
                                    title: "Mutual Fund Research",
                                    subTitle: "15+ research tools",
                                    isWhite: true,
                                    color: Config.appTheme.themeColor,
                                  ),
                                  ResearchCard(
                                    image: 'assets/tools_Calculators.png',
                                    title: "Tools & Calculators",
                                    subTitle: "10+ calculators",
                                    isWhite: false,
                                    color: Config.appTheme.universalTitle,
                                    goTo: Calculators(),
                                  ),
                                  ResearchCard(
                                    image: 'assets/Blogs.png',
                                    title: "Blogs",
                                    subTitle: "Latest articles",
                                    isWhite: true,
                                    color: Config.appTheme.themeColor,
                                    goTo: Blogs(),
                                  ),
                                  ResearchCard(
                                    image: 'assets/News.png',
                                    title: 'News',
                                    subTitle: 'Latest industry news and update',
                                    isWhite: false,
                                    color: Config.appTheme.universalTitle,
                                    goTo: News(),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            /* Text(
                            "Copyright Mymfbox $todayDate. All Rights Reserved",
                            style: TextStyle(
                                color: Color(0xff959595), fontSize: 12),
                          ),
                          SizedBox(height: 16),*/
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        });
  }

  Widget normalBottomSheet({BorderRadius? borderRadius}) {
    return ClipRRect(
      borderRadius: borderRadius ??
          BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
      child: BottomNavigationBar(
        selectedItemColor: Config.appTheme.themeColor,
        currentIndex: selectedPage,
        onTap: (index) {
          selectedPage = index;
          setState(() {});
        },
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "Investors"),
          BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz_rounded), label: "More"),
        ],
      ),
    );
  }

  Widget updateBottomSheet() {
    return SizedBox(
      height: 107,
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

  Widget newCard() {

    return Obx(() {
      if (summaryLoading.isTrue)
        return Utils.shimmerWidget(200, margin: EdgeInsets.zero);
      if (summaryError.isNotEmpty) return Text(summaryError.value);
      DateTime? transactStartDate = DateTime.parse(get30DayData['start_date']);
      DateTime? transactEndDate = DateTime.parse(get30DayData['end_date']);
      return InkWell(
        onTap: () async {

        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppFonts.last30Background,
            // Background color
            border: Border.all(
              color: AppFonts.last30Border,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Last $selectedHeading Days Transactions",
                    style:
                        AppFonts.f40016.copyWith(fontWeight: FontWeight.w500),
                  ),
                  SortButton(
                    padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                    onTap: () {
                      showMonthBottomSheet(
                        groupValue: selectedHeading,
                        monthList: headings,
                        onChanged: (val) async {
                          selectedHeading = val ?? "null";
                          Get.back();
                          get30DayData = {};
                          await getPurchaseRedeemDetail();
                          setState(() {});
                        },
                      );
                    },
                    title: " $selectedHeading Days",
                  ),
                ],
              ),
              SizedBox(height: 8,),
              InkWell(
                onTap: (){
                  Get.to(AllInvestor(
                    branch: [], rm: [], associate: [],
                    startDate: transactStartDate,
                    endDate: transactEndDate,
                    totalInvestors: 0,));
                },
                child: Row(
                  children: [
                    Text("No of new investors : ", style: AppFonts.f50014Grey),
                    Text(
                      "${get30DayData['new_investors_count']}",
                      style: AppFonts.f70024
                          .copyWith(fontSize: 14, color: Colors.black),
                    )
                  ],
                ),
              ),
              SizedBox(height: 8,),
              InkWell(
                onTap: (){
                  Get.to(ActiveSipHome(startDate: transactStartDate,end_date: transactEndDate,));
                },
                child: Row(
                  children: [
                    Text("No of new SIP investments : ", style: AppFonts.f50014Grey),
                    Text(
                      "${get30DayData['new_sip_count']}",
                      style: AppFonts.f70024
                          .copyWith(fontSize: 14, color: Colors.black),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      Get.to(TransactionReport(
                          selectStartDate: transactStartDate,
                          selectEndDate: transactEndDate,
                          type: "Purchase"));

                    },
                    child: AdminColumnText(
                      title:
                          "$rupee ${Utils.formatNumber(get30DayData['purchase_amount'],isShortAmount: true)}",
                      value: "Purchases (${get30DayData['purchase_count']})",
                      titleStyle: AppFonts.f70024,
                      valueStyle: AppFonts.f50014Grey,
                    ),
                  ),
                  InkWell(
                     onTap: (){

                       Get.to(TransactionReport(
                           selectStartDate: transactStartDate,
                           selectEndDate: transactEndDate,
                           type: "Redemption"));
                     },
                    child: AdminColumnText(
                      title:
                          "$rupee ${Utils.formatNumber(get30DayData['redemption_amount'],isShortAmount: true)}",
                      alignment: CrossAxisAlignment.end,
                      value: "Redemptions(${get30DayData['redemption_count']})",
                      titleStyle: AppFonts.f70024,
                      valueStyle: AppFonts.f50014Grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      Get.to(TransactionReport(
                          selectStartDate: transactStartDate,
                          selectEndDate: transactEndDate,
                          type: "SIP"));
                    },
                    child: AdminColumnText(
                      title:
                          "$rupee ${Utils.formatNumber(get30DayData['sip_amount'],isShortAmount: true)}",
                      value: "SIP (${get30DayData['sip_count']})",
                      titleStyle: AppFonts.f70024,
                      valueStyle: AppFonts.f50014Grey,
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Get.to(TransactionReport(
                          selectStartDate: transactStartDate,
                          selectEndDate: transactEndDate,
                          type: "Rejection"));
                    },
                    child: AdminColumnText(
                      title:
                          "$rupee ${Utils.formatNumber(get30DayData['rejection_amount'],isShortAmount: true)}",
                      alignment: CrossAxisAlignment.end,
                      value: "Rejection (${get30DayData['rejection_count']})",
                      titleStyle: AppFonts.f70024,
                      valueStyle: AppFonts.f50014Grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget oldCard() {
    return Obx(() {
      if (summaryLoading.isTrue)
        return Utils.shimmerWidget(200, margin: EdgeInsets.zero);
      if (summaryError.isNotEmpty) return Text(summaryError.value);

      return Container(
        padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
        decoration: BoxDecoration(
          color: AppFonts.last30Background,
          // Background color
          border: Border.all(
            color: AppFonts.last30Border, // Border color
            width: 1.0, // Border width
          ),
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  infoRow(
                    lHead: "Last $selectedHeading Days Transactions",
                    lHStyle:
                        AppFonts.f40016.copyWith(fontWeight: FontWeight.w500),
                  ),
                  SortButton(
                    padding: EdgeInsets.all(1),
                    onTap: () {
                      showMonthBottomSheet(
                        groupValue: selectedHeading,
                        monthList: headings,
                        onChanged: (val) async {
                          selectedHeading = val ?? "null";
                          Get.back();
                          get30DayData = {};
                          await getPurchaseRedeemDetail();
                          setState(() {});
                        },
                      );
                    },
                    title: " $selectedHeading Days",
                  ),
                ],
              ),
            ),
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        style: AppFonts.f50014Grey.copyWith(fontSize: 14),
                        text: "No of new investors : ",
                      ),
                      TextSpan(
                          text:
                              " ${get30DayData['new_investors_count'] ?? "0"}",
                          style: AppFonts.f70024
                              .copyWith(fontSize: 14, color: Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            gettrnxCount(
              lHead:
                  '$rupee ${Utils.formatNumber(get30DayData['purchase_amount'], isShortAmount: true)}',
              lSubHead: "Purchases (${get30DayData['purchase_count']})",
              rHead:
                  '$rupee ${Utils.formatNumber(get30DayData['redemption_amount'], isShortAmount: true)}',
              rSubHead: "Redemptions (${get30DayData['redemption_count']})",
            ),
            SizedBox(
              height: 8,
            ),
            gettrnxCount(
              lHead:
                  '$rupee ${Utils.formatNumber(get30DayData['sip_amount'], isShortAmount: true)}',
              lSubHead: "SIP (${get30DayData['sip_count']})",
              rHead:
                  '$rupee ${Utils.formatNumber(get30DayData['rejection_amount'], isShortAmount: true)}',
              rSubHead: "Rejection (${get30DayData['rejection_count']})",
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      );
    });
  }

  Widget infoRow({
    required String lHead,
    String? lSubHead,
    TextStyle? lHStyle,
    TextStyle? lStyle,
    String rHead = "",
    String rSubHead = "",
    TextStyle? rStyle,
  }) {
    return Container(
      width: devWidth * 0.6,
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lHead,
                  style: lHStyle ?? AppFonts.f70024.copyWith(fontSize: 22)),
              SizedBox(
                height: 8,
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget gettrnxCount({
    required String lHead,
    required String lSubHead,
    TextStyle? lHStyle,
    TextStyle? lStyle,
    String rHead = "",
    String rSubHead = "",
    TextStyle? rStyle,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 0, bottom: 8, right: 16),
      child: Column(
        children: [
          SizedBox(height: 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(lHead, style: AppFonts.f70024.copyWith(fontSize: 22)),
              Text(rHead, style: AppFonts.f70024.copyWith(fontSize: 22)),
            ],
          ),
          SizedBox(height: 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(lSubHead, style: AppFonts.f50014Grey),
              Text(rSubHead, style: AppFonts.f50014Grey),
            ],
          ),
        ],
      ),
    );
  }

  GestureDetector brokerageSummary() {
    String month = dashboardData['brokerage_month'] == null
        ? ""
        : dashboardData['brokerage_month'].replaceAll("-", " ");
    //monthAmount = dashboardData['brokerage_amount'] ?? 0;
    // yearAmount = dashboardData['brokerage_cfy_value'] ?? 0;
    print('Month Amount: $monthAmount');
    print('Year Amount: $yearAmount');

    return GestureDetector(
      onTap: () {
        Get.to(() => BrokerageDashboard(
              month: month,
              monthAmount: monthAmount,
              yearAmount: yearAmount,
            ));
      },
      child: AdminCard(
          title: "Brokerage",
          lHead:
              "$rupee ${Utils.formatNumber(monthAmount, isShortAmount: true)}",
          rHead:
              "$rupee ${Utils.formatNumber(yearAmount, isShortAmount: true)}",
          lSubHead: "For $month",
          rSubHead: "Current FY",
          borderColor: AppFonts.brokerageBorder,
          brokerageBackground: AppFonts.brokerageBackground),
    );
  }

  GestureDetector investorSummary(String title) {
    num totalInvestors = dashboardData['total_investors'] ?? 0;
    num totalFamilies = dashboardData['total_family_investors'] ?? 0;
    num totalRM = dashboardData['rm_count'] ?? 0;
    num totalAssociate = dashboardData['subBroker_count'] ?? 0;

    String lHead = "";
    if (title == "Investors") {
      lHead = Utils.formatNumber(totalInvestors);
    } else if (title == "Families") {
      lHead = Utils.formatNumber(totalFamilies);
    } else if (title == "RM") {
      lHead = Utils.formatNumber(totalRM);
    } else if (title == "Associate") {
      lHead = Utils.formatNumber(totalAssociate);
    }

    return GestureDetector(
      onTap: () {
        if (title == "Families") {
          if (Config.app_client_name == 'vbuildwealth' ||
              client_name == 'counton')
            directlyGoToFamilies(totalFamilies);
          else
            Get.to(AboutInvestors(showAppBar: true, scrollToFamilies: true));
        } else if (title == "Investors") {
          if (Config.app_client_name == 'vbuildwealth' ||
              client_name == 'counton')
            directlyGoToInvestors(totalInvestors);
          else
            Get.to(AboutInvestors(scrollToFamilies: false));
        }

        if (title == "RM") {
          Get.to(AllRM());
        } else if (title == "Associate") {
          Get.to(AllSubBroker());
        }
      },
      child: AdminCard(
        title: title,
        lHead: lHead,
        rHead: "",
        lSubHead: "",
        rSubHead: "",
        borderColor: AppFonts.investorBorder,
        brokerageBackground: AppFonts.investorBackground,
        isSubVisible: false,
        isRightVisible: false,
      ),
    );
  }

  directlyGoToInvestors(num totalInvestors) {
    Get.to(() => AllInvestor(
        totalInvestors: totalInvestors, branch: [], rm: [], associate: []));
  }

  directlyGoToFamilies(num totalFamilies) {
    Get.to(() => AllFamilies(totalFamilies: totalFamilies));
  }

  GestureDetector sipSummary() {
    return GestureDetector(
      onTap: () {
        Get.to(SipDashboard());
      },
      child: AdminCard(
          title: "SIP/STP/SWP Summary",
          lHead: Utils.formatNumber(dashboardData['sip_total_count']),
          lSubHead: "Number of SIPs",
          rHead:
              "$rupee ${Utils.formatNumber(dashboardData['sip_total_amount'], isShortAmount: true)}",
          rSubHead: "Average $rupee ${Utils.formatNumber(dashboardData['sip_avg_amount'])}",
          borderColor: AppFonts.sipBorder,
          brokerageBackground: AppFonts.sipBackground),
    );
  }

  GestureDetector last30Summary() {
    return GestureDetector(
      onTap: () {
        Get.to(SipDashboard());
      },
      child: AdminCard(
          title: "SIP Summary",
          lHead: Utils.formatNumber(dashboardData['sip_total_count']),
          lSubHead: "Number of SIPs",
          rHead:
              "$rupee ${Utils.formatNumber(dashboardData['sip_total_amount'], isShortAmount: true)}",
          rSubHead: "Average $rupee ${dashboardData['sip_avg_amount']}",
          borderColor: AppFonts.sipBorder,
          brokerageBackground: AppFonts.sipBackground),
    );
  }

  Widget extraButton(
      {required String image,
      Decoration? decoration,
      String? text,
      bool isArrowWhite = true}) {
    return Container(
      width: devWidth,
      height: 50,
      decoration: decoration,
      child: Center(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Image.asset(image, height: setImageSize(30)),
            SizedBox(width: 10),
            Text(text ?? "null",
                style: TextStyle(
                    color: (isArrowWhite) ? Colors.white : null,
                    fontSize: 16,
                    fontWeight: FontWeight.w500)),
            Spacer(),
            Icon(Icons.arrow_forward,
                color: (isArrowWhite)
                    ? Colors.white
                    : Config.appTheme.universalTitle)
          ],
        ),
      )),
    );
  }

  showMonthBottomSheet(
      {required String groupValue,
      Function(String?)? onChanged,
      required List monthList}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(borderRadius: cornerBorder),
                child: Column(
                  children: [
                    BottomSheetTitle(title: "Select days"),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: monthList.length,
                      itemBuilder: (context, index) {
                        String title = monthList[index];

                        return InkWell(
                          onTap: () async {
                            onChanged!(title);
                          },
                          child: Row(
                            children: [
                              Radio(
                                  value: title,
                                  groupValue: groupValue,
                                  onChanged: onChanged),
                              SizedBox(width: 5),
                              Text("$title Days"),
                            ],
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

class AdminCard extends StatelessWidget {
  const AdminCard(
      {super.key,
      required this.title,
      required this.lHead,
      required this.lSubHead,
      required this.rHead,
      required this.rSubHead,
      this.borderColor = const Color(0xFFFFFFFF),
      this.brokerageBackground = const Color(0xFFFFFFFF),
      this.isSubVisible = true,
      this.isRightVisible = true,
      this.extraWidgets = const []});

  final dynamic lHead, rHead;
  final dynamic lSubHead, rSubHead;
  final String title;
  final List<Widget> extraWidgets;
  final Color borderColor;
  final Color brokerageBackground;
  final bool isSubVisible;
  final bool isRightVisible;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: brokerageBackground, // Background color
        border: Border.all(
          color: borderColor, // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppFonts.f40016.copyWith(fontWeight: FontWeight.w500),
                ),
                Icon(Icons.arrow_forward, color: Config.appTheme.universalTitle)
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$lHead", style: AppFonts.f70024.copyWith(fontSize: 22)),
                if (isSubVisible)
                  Text("$rHead", style: AppFonts.f70024.copyWith(fontSize: 22)),
              ],
            ),
            SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isRightVisible)
                  Text("$lSubHead", style: AppFonts.f50014Grey),
                if (isSubVisible) Text("$rSubHead", style: AppFonts.f50014Grey),
              ],
            ),
            ...extraWidgets
          ],
        ),
      ),
    );
  }
}
