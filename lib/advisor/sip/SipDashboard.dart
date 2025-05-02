import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/advisor/dashboard/BrokerageCard.dart';
import 'package:mymfbox2_0/advisor/sip/BranchRmAssociateSip.dart';
import 'package:mymfbox2_0/advisor/sip/BroadCategorySip.dart';
import 'package:mymfbox2_0/advisor/sip/ClientWiseSipExposure.dart';
import 'package:mymfbox2_0/advisor/sip/FamilyWiseSipExposure.dart';
import 'package:mymfbox2_0/advisor/sip/SchemeWiseSip.dart';
import 'package:mymfbox2_0/advisor/sip/TopAmc.dart';
import 'package:mymfbox2_0/advisor/sip/activeSip/ActiveSipHome.dart';
import 'package:mymfbox2_0/advisor/stp/ActiveStpHome.dart';
import 'package:mymfbox2_0/advisor/swp/ActiveSwpHome.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/rp_widgets/AmcChip.dart';
import 'package:mymfbox2_0/rp_widgets/SelectedAmcChip.dart';
import 'package:mymfbox2_0/rp_widgets/ViewAllBtn.dart';

class SipDashboard extends StatefulWidget {
  const SipDashboard({super.key});

  @override
  State<SipDashboard> createState() => _SipDashboardState();
}

class _SipDashboardState extends State<SipDashboard> {
  late double devHeight, devWidth;
  int user_id = GetStorage().read("mfd_id");
  String client_name = GetStorage().read("client_name");
  int type_id = GetStorage().read('type_id');

  List<Color> colorPalate = [
    Color(0xFF2caffe),
    Color(0xFF544fc5),
    Color(0xFF008744),
    Color(0xFF6b8abc),
    Color(0xFFaa53c8),
    Color(0xFF2ee0ca),
    Color(0xFFfeb56a),
    Color(0xFF91e8e1),
    Color(0xFF009626),
    Color(0xFF3C9AB6),
  ];

  late Widget spacing;
  List<String> headings = ["Broad Category", "Top 10 Categories", "Ratings"];
  int selectedIndex = 0;
  Map sipData = {}, swpData = {}, stpData = {};
  List amcWiseSipDetails = [];
  List broadCategoryDetails = [];
  List top10CategoryDetails = [];
  bool isLoading = true;

  List branchList = [], rmList = [], associateList = [];

  Map branchData = {};

  List branchBtnList = [
    "Branch",
    "RM",
  ];

  bool isFirst = true;
  Future getDatas() async {
    if (!isFirst) return 0;

    await Future.wait([
      getSipStpSwpSummaryDetails(),
      getAmcWiseSipDetails(),
      getBroadCategoryWiseSipDetails(),
      getCategoryWiseSipDetails(),
      getBranchWiseAUM(),
      getRatingsData(),
    ]);

    isLoading = false;
    isFirst = false;
    return 0;
  }

  RxBool summaryLoading = true.obs;
  RxString summaryError = "".obs;
  Future getSipStpSwpSummaryDetails() async {
    summaryLoading.value = true;

    Map data = await Api.getSipStpSwpSummaryDetails(
        client_name: client_name, user_id: user_id);

    if (data['status'] != 200) {
      summaryError.value = data['msg'];
      summaryLoading.value = false;
      return -1;
    }

    sipData = data['sip'];
    swpData = data['swp'];
    stpData = data['stp'];

    summaryLoading.value = false;
    return 0;
  }

  RxBool amcLoading = true.obs;
  RxString amcError = "".obs;
  Future getAmcWiseSipDetails() async {
    amcLoading.value = true;

    try {
      Map data = await Api.getAmcWiseSipDetails(
          user_id: user_id, client_name: client_name, maxCount: '5');

      if (data['status'] != 200) {
        amcError.value = data['msg'] ?? "null error";
        amcLoading.value = false;
        // Utils.showError(context, data['msg']);
        return -1;
      }

      amcWiseSipDetails = data['list'];
    } catch (e) {
      print("getAmcWiseSipDetails exception = $e");
      amcError.value = "Exception Occured";
    }

    amcLoading.value = false;
    return 0;
  }

  RxBool broadCategoryLoading = true.obs;
  RxString broadCategoryError = "".obs;
  Future getBroadCategoryWiseSipDetails() async {
    broadCategoryLoading.value = true;
    try {
      Map data = await Api.getBroadCategoryWiseSipDetails(
          user_id: user_id, client_name: client_name);
      broadCategoryDetails = data['list'];
    } catch (e) {
      broadCategoryError.value = "Exception Occured";
    }
    broadCategoryLoading.value = false;
    return 0;
  }

  Future getCategoryWiseSipDetails() async {
    broadCategoryLoading.value = true;
    try {
      Map data = await Api.getCategoryWiseSipDetails(
        user_id: user_id,
        client_name: client_name,
        maxCount: '10',
        broad_category: "All",
      );
      if (data['status'] != 200) {
        Utils.showError(context, data['msg']);
        return -1;
      }
      top10CategoryDetails = data['list'];
    } catch (e) {
      broadCategoryError.value = "Exception occured";
    }
    broadCategoryLoading.value = false;
    return 0;
  }

  RxBool branchLoading = true.obs;
  RxString branchError = "".obs;
  Future getBranchWiseAUM() async {
    branchLoading.value = true;

    try {
      user_id = GetStorage().read("mfd_id");
      if (branchData.containsKey('Branch')) return 0;

      Map data = await AdminApi.getBranchWiseSipDetails(
        user_id: user_id,
        client_name: client_name,
        page_id: 1,
        sort_by: 'AUM',
      );
      if (data['status'] != 200) {
        branchError.value = data['msg'];
        branchLoading.value = false;
        return -1;
      }
      branchList = data['list'];
    } catch (e) {
      print("exception getBranchWiseAUM = $e");
      branchError.value = "Exception Occured";
    }

    branchLoading.value = false;
    return 0;
  }

  String rm_name = "";
  Future getRMWiseAUM() async {
    branchLoading.value = true;
    try {
      user_id = GetStorage().read("mfd_id");
      String client_name = GetStorage().read("client_name");

      if (branchData.containsKey('RM')) return 0;

      Map data = await AdminApi.getRmWiseSipDetails(
        user_id: user_id,
        client_name: client_name,
        page_id: 1,
        sort_by: 'AUM',
      );
      if (data['status'] != 200) {
        Utils.showError(context, data['msg']);
        return 0;
      }
      rmList = data['list'];
    } catch (e) {
      branchError.value = "Exception Occurred";
    }
    branchLoading.value = false;
    return 0;
  }

  Future getAssociateWiseAum() async {
    branchLoading.value = true;
    try {
      user_id = GetStorage().read("mfd_id");
      String client_name = GetStorage().read("client_name");

      if (branchData.containsKey('Associate')) return 0;

      Map data = await AdminApi.getSubBrokerWiseSipDetails(
          user_id: user_id,
          client_name: client_name,
          rm_name: rm_name,
          sort_by: '',
          page_id: 1);
      if (data['status'] != 200) {
        Utils.showError(context, data['msg']);
        return 0;
      }
      associateList = data['list'];
    } catch (e) {
      branchError.value = "Exception Occured";
    }
    branchLoading.value = false;
    return 0;
  }

  List ratings = [];
  Future getRatingsData() async {
    broadCategoryLoading.value = false;
    try {
      Map data = await AdminApi.getRatingWiseSipDetails(
          user_id: user_id, client_name: client_name, max_count: "All");

      if (data['status'] != 200) {
        Utils.showError(context, data['msg']);
        return -1;
      }

      ratings = data['list'];
    } catch (e) {
      broadCategoryError.value = "Exception Occured";
    }
    broadCategoryLoading.value = false;
    return 0;
  }

  @override
  void initState() {
    //  implement initState
    super.initState();
  }

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    spacing = SizedBox(height: 16);

    return FutureBuilder(
      future: getDatas(),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Config.appTheme.mainBgColor,
          appBar: adminAppBar(title: "SIP/STP/SWP"),
          body: RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: () async {
              isFirst = true;
              setState(() {});
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    sipSummaryCard(),
                    spacing,
                    if (type_id == UserType.ADMIN) ...[
                      topAmc(title: "Top 5 AMCs"),
                      spacing,
                      branchRmCard(),
                      spacing,
                      sipCategoryRating(),
                      spacing,
                    ],
                    Obx(() {
                      if (summaryLoading.isTrue)
                        return Utils.shimmerWidget(200,
                            margin: EdgeInsets.zero);
                      if (summaryError.isNotEmpty)
                        return Utils.showBoxError(
                            height: 200, msg: summaryError.value);

                      return InkWell(
                        onTap: () {
                          // Get.to(ProductInfo());

                          Get.to(ActiveStpHome());
                        },
                        child: BrokerageCard(
                          title: "STP Summary",
                          lHead: stpData['total_stp_count'],
                          lSubHead: "STPs",
                          rHead:
                              "$rupee ${Utils.formatNumber(stpData['total_stp_amount'], isShortAmount: false)}",
                          rSubHead: "STP Amount",
                          padding: EdgeInsets.zero,
                          titleArrow: false,
                        ),
                      );
                    }),
                    spacing,
                    Obx(() {
                      if (summaryLoading.isTrue)
                        return Utils.shimmerWidget(200,
                            margin: EdgeInsets.zero);
                      if (summaryError.isNotEmpty)
                        return Utils.showBoxError(
                            height: 200, msg: summaryError.value);

                      return InkWell(
                        onTap: () {
                          // Get.to(ProductInfo());
                          Get.to(ActiveSwpHome());
                        },
                        child: BrokerageCard(
                          title: "SWP Summary",
                          lHead: swpData['total_swp_count'],
                          lSubHead: "SWPs",
                          rHead:
                              "$rupee ${Utils.formatNumber(swpData['total_swp_amount'].round(), isShortAmount: false)}",
                          rSubHead: "SWP Amount",
                          padding: EdgeInsets.zero,
                          titleArrow: false,
                        ),
                      );
                    }),
                    spacing,
                    Obx(() {
                      if (summaryLoading.isTrue)
                        return Utils.shimmerWidget(200,
                            margin: EdgeInsets.zero);
                      if (summaryError.isNotEmpty)
                        return Utils.showBoxError(
                            height: 200, msg: summaryError.value);

                      return Row(
                        children: [
                          Expanded(
                              child: bottomCard(
                                color: Config.appTheme.themeColor,
                            title: "Expiring\nSIPs",
                            value: "${sipData['sip_expiring_shortly']}",
                            goTo: ActiveSipHome(
                              defaultSelection: "SIPs Expiring Shortly",
                            ),
                          )),
                          SizedBox(width: 16),
                          Expanded(
                            child: bottomCard(
                              color: Config.appTheme.buttonColor,
                              value: "${sipData['sip_starting_shortly']}",
                              title: "SIPs Starting\nShortly",
                              goTo: ActiveSipHome(
                                  defaultSelection: "SIPs Starting Shortly"),
                            ),
                          ),
                        ],
                      );
                    }),
                    spacing,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget sipSummaryCard() {
    return Obx(() {
      if (summaryLoading.isTrue)
        return Utils.shimmerWidget(200, margin: EdgeInsets.zero);
      if (summaryError.isNotEmpty)
        return Utils.showBoxError(height: 200, msg: summaryError.value);

      return Container(
        width: devWidth,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: (Config.app_client_name != "vbuildwealth")
                    ? AssetImage("assets/aumCardBg.png")
                    : AssetImage("assets/aumOrangeBg.png"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Config.appTheme.themeColor, BlendMode.color))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 12, 5),
              child: Text("SIP Summary",
                  style: AppFonts.f40016
                      .copyWith(color: Colors.white, fontSize: 20)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                summaryCard(
                  heading: Utils.formatNumber(sipData['total_sip_count']),
                  subHeading: "SIP Count",
                  goTo: ActiveSipHome(),
                ),
                summaryCard(
                    hasArrow: false,
                    heading:
                        '$rupee ${Utils.formatNumber(sipData['total_sip_amount'].round(), isShortAmount: false)}',
                    subHeading:
                        "SIP Amount"),
              //   Avg $rupee ${Utils.formatNumber(sipData['average_sip_amount'], isShortAmount: true)}
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                summaryCard(
                  heading: Utils.formatNumber(
                    sipData['total_sip_investors'],
                  ),
                  subHeading: "SIP Investors",
                  goTo: ClientWiseSipExposure(),
                ),
                if (type_id == UserType.ADMIN)
                  summaryCard(
                    heading: sipData['total_sip_families'],
                    subHeading: "SIP Families",
                    goTo: FamilyWiseSipExposure(),
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget sipCategoryRating() {
    return Obx(() {
      if (broadCategoryLoading.isTrue)
        return Utils.shimmerWidget(200, margin: EdgeInsets.zero);
      if (broadCategoryError.isNotEmpty)
        return Utils.showBoxError(height: 200, msg: broadCategoryError.value);

      return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Text("SIP Category and Ratings", style: AppFonts.f40016),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: headings.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          selectedIndex = index;
                          setState(() {});
                        },
                        child: (index == selectedIndex)
                            ? selectedCard(headings[index])
                            : chartTopCard(headings[index]));
                  },
                ),
              ),
            ),
            if (selectedIndex == 0) getBroadCategory(),
            if (selectedIndex == 1) getTopCategory(),
            if (selectedIndex == 2) getRatingsChart(),
          ],
        ),
      );
    });
  }

  Widget branchRmCard() {
    return Obx(() {
      if (branchLoading.isTrue)
        return Utils.shimmerWidget(300, margin: EdgeInsets.zero);
      if (branchError.isNotEmpty)
        return Utils.showBoxError(height: 300, msg: branchError.value);

      return Container(
        padding: EdgeInsets.fromLTRB(16, 16, 0, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Branch/RM Wise SIP",
              style: AppFonts.f50014Black.copyWith(fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 16),
            branchBtnChipArea(),
            SizedBox(height: 16),
            if (selectedBranchType == "Branch") branchArea(),
            if (selectedBranchType == "RM") rmArea(),
           // if (selectedBranchType == "Associate") associateArea(),
            SizedBox(height: 12),
            ViewAllBtn(
              onTap: () {
                Get.to(BranchRmAssociateSip(selectedChip: selectedBranchType));
              },
            )
          ],
        ),
      );
    });
  }

  Widget branchArea() {
    int length = branchList.length;

    return (branchList.isEmpty)
        ? noData(selectedBranchType)
        : ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: (length > 5) ? 5 : length,
            itemBuilder: (context, index) {
              Map data = branchList[index];
              return branchRmAssociateTile(data);
            },
            separatorBuilder: (BuildContext context, int index) =>
                DottedLine(verticalPadding: 5),
          );
  }

  Widget rmArea() {
    int length = rmList.length;

    return rmList.isEmpty
        ? noData(selectedBranchType)
        : ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: (length > 5) ? 5 : length,
            itemBuilder: (context, index) {
              Map data = rmList[index];
              return rmAssociateTile(data);
            },
            separatorBuilder: (BuildContext context, int index) =>
                DottedLine(verticalPadding: 5),
          );
  }

  Widget associateArea() {
    int length = associateList.length;

    return associateList.isEmpty
        ? noData(selectedBranchType)
        : ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: (length > 5) ? 5 : length,
            itemBuilder: (context, index) {
              Map data = associateList[index];
              return associateTile(data);
            },
            separatorBuilder: (BuildContext context, int index) =>
                DottedLine(verticalPadding: 5),
          );
  }

  Widget noData(String selectedBranchType) {
    return Padding(
      padding: EdgeInsets.only(top: devHeight * 0.02, left: devWidth * 0.28),
      child: Column(
        children: [
          Text("No $selectedBranchType Available"),
          SizedBox(height: devHeight * 0.01),
        ],
      ),
    );
  }

  Widget branchRmAssociateTile(Map data) {
    String name = data["branch"];
    num amount = data["current_value"];
    num sipAmount = data["amount"] ?? 0;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
      child: Row(
        children: [
          SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: AppFonts.f50014Black,
            ),
          ),
          SizedBox(width: 5),
          Text(
            "$rupee ${Utils.formatNumber(sipAmount.round(), isAmount: true)}",
            style: AppFonts.f50014Black,
          ),
          /*ColumnText(
            title: "$rupee ${Utils.formatNumber(amount, isAmount: true)}",
            value: "(SIP Amount - $rupee ${Utils.formatNumber(sipAmount, isAmount: true)})",
            alignment: CrossAxisAlignment.end,
            titleStyle: AppFonts.f50014Black,
          valueStyle: AppFonts.f40016.copyWith(
              fontSize: 13,
              color: Color(0XFF646C6C))),*/
          // Text at the end with image
        ],
      ),
    );
  }

  Widget rmAssociateTile(Map data) {
    String name = data["rm_name"];
    num amount = data["current_value"];
    num sipAmount = data["amount"] ?? 0;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
      child: Row(
        children: [
          // Text in the middle
          SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: AppFonts.f50014Black,
            ),
          ),
          SizedBox(width: 5),
          Text(
            "$rupee ${Utils.formatNumber(sipAmount.round(), isAmount: true)}",
            style: AppFonts.f50014Black,
          ),

          /*ColumnText(
              title: "$rupee ${Utils.formatNumber(amount, isAmount: true)}",
              value: "(SIP Amount - $rupee ${Utils.formatNumber(sipAmount, isAmount: true)})",
              alignment: CrossAxisAlignment.end,
              titleStyle: AppFonts.f50014Black,
              valueStyle: AppFonts.f40016.copyWith(
                  fontSize: 13,
                  color: Color(0XFF646C6C))),*/
          // Text at the end with image
        ],
      ),
    );
  }

  Widget associateTile(Map data) {
    String name = data["name"];
    num amount = data["current_value"];
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
      child: Row(
        children: [
          // Text in the middle
          SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: AppFonts.f50014Black,
            ),
          ),
          SizedBox(width: 5),
          Text(
            "$rupee ${Utils.formatNumber(amount, isAmount: true)}",
            style: AppFonts.f50014Black,
          ),
          // Text at the end with image
        ],
      ),
    );
  }

  String selectedBranchType = "Branch";
  Widget branchBtnChipArea() {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        itemCount: branchBtnList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          String title = branchBtnList[index];
          bool isSelectedBranch = (selectedBranchType == title);

          if (isSelectedBranch)
            return SelectedAmcChip(
              title: title,
              value: "",
              hasValue: false,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            );
          else
            return AmcChip(
              title: title,
              value: '',
              hasValue: false,
              onTap: () async {
                if (title == 'RM') await getRMWiseAUM();
                //if (title == 'Associate') await getAssociateWiseAum();

                selectedBranchType = title;
                setState(() {});
              },
              titleStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            );
        },
      ),
    );
  }

  Widget getBroadCategory() {
    print(
        "broad category = $broadCategoryDetails + ${broadCategoryDetails.length}");
    List<SipData> chartData = [];
    broadCategoryDetails.forEach((element) {
      chartData.add(SipData(
          category: element['scheme_broad_category'],
          percentage: element['percentage']));
    });
    chartData.removeWhere((element) => element.category.isEmpty);

    return Column(
      children: [
        SfCircularChart(
          series: <CircularSeries>[
            PieSeries<SipData, String>(
              dataSource: chartData,
              xValueMapper: (data, _) => data.category,
              yValueMapper: (data, _) => data.percentage,
            ),
          ],
          palette: colorPalate,
          legend: Legend(
              isVisible: false,
              overflowMode: LegendItemOverflowMode.scroll,
              position: LegendPosition.bottom),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: chartData.length,
            itemBuilder: (BuildContext context, int index) {
              SipData sipData = chartData.elementAt(index);

              return InkWell(
                splashColor: colorPalate[index],
                onTap: () {
                  Get.to(() => BroadCategorySip(
                      broadCategoryList: broadCategoryDetails,
                      selectedBroadCategory: sipData.category));
                },
                child: Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: colorPalate[index], radius: 6),
                    SizedBox(width: 10),
                    Expanded(
                        child: Text(
                      sipData.category,
                      style: AppFonts.f50014Black,
                    )),
                    Text(
                      sipData.percentage.toStringAsFixed(2) + "%",
                      style: AppFonts.f50014Black,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Config.appTheme.placeHolderInputTitleAndArrow,
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return DottedLine(verticalPadding: 4);
            },
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget getTopCategory() {
    List<SipData> chartData = [];

    top10CategoryDetails
        .sort((a, b) => b['percentage'].compareTo(a['percentage']));

    List top10Categories = top10CategoryDetails.take(10).toList();

    top10Categories.forEach((element) {
      chartData.add(SipData(
        category: element['scheme_category'],
        percentage: element['percentage'],
        amount: element['amount'],
      ));
    });

    return Column(
      children: [
        SfCircularChart(
          series: <CircularSeries>[
            PieSeries<SipData, String>(
              dataSource: chartData,
              xValueMapper: (data, _) => data.category,
              yValueMapper: (data, _) => data.percentage,
            ),
          ],
          palette: colorPalate,
          legend: Legend(
            isVisible: false,
            overflowMode: LegendItemOverflowMode.scroll,
            position: LegendPosition.bottom,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: chartData.length,
            itemBuilder: (BuildContext context, int index) {
              SipData sipData = chartData[index];

              return InkWell(
                onTap: () {
                  Get.to(() => SchemeWiseSip(
                        amc: "",
                        category: sipData.category,
                      ));
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: colorPalate[index % colorPalate.length],
                      radius: 6,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        sipData.category,
                        style: AppFonts.f50014Black,
                      ),
                    ),
                    ColumnText(
                      title: "${sipData.percentage.toStringAsFixed(2)} %",
                      value: "$rupee ${Utils.formatNumber(sipData.amount)}",
                      alignment: CrossAxisAlignment.end,
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return DottedLine(verticalPadding: 4);
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget getRatingsChart() {
    List<SipData> chartData = [];
    ratings.forEach((element) {
      chartData.add(SipData(
          category: "${element['rating_value']}",
          percentage: element['percentage']));
    });

    return Column(
      children: [
        SfCircularChart(
          series: <CircularSeries>[
            PieSeries<SipData, String>(
              dataSource: chartData,
              xValueMapper: (data, _) => data.category,
              yValueMapper: (data, _) => data.percentage,
            ),
          ],
          palette: colorPalate,
          legend: Legend(
              isVisible: false,
              overflowMode: LegendItemOverflowMode.scroll,
              position: LegendPosition.bottom),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: chartData.length,
            itemBuilder: (BuildContext context, int index) {
              SipData sipData = chartData.elementAt(index);
              int starCount = int.tryParse(sipData.category) ?? 0;

              return Row(
                children: [
                  for (int i = 0; i < starCount; i++)
                    Icon(
                      Icons.star,
                      color: colorPalate[index],
                    ),
                  if (starCount == 0)
                    Text("Not Rated", style: AppFonts.f50014Black),
                  Spacer(),
                  Text(
                    "${sipData.percentage.toStringAsFixed(2)} %",
                    style: AppFonts.f50014Black,
                    textAlign: TextAlign.center,
                  )
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return DottedLine(verticalPadding: 4);
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget chartTopCard(String title) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Color(0xffEBEEEE), borderRadius: BorderRadius.circular(7)),
      child: Center(child: Text(title)),
    );
  }

  Widget selectedCard(String title) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Config.appTheme.themeColor,
          borderRadius: BorderRadius.circular(7)),
      child: Center(
          child: Text(title,
              style: AppFonts.f40016.copyWith(color: Colors.white))),
    );
  }

  Widget bottomCard({
    //Color color = const Color(0xff2e2e2e),
    Color color = const Color(0xff18a899),
    //Color color = const Color(Config.appTheme.universalTitle),
    required String title,
    required String value,
    required Widget goTo,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Get.to(goTo);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: AppFonts.f40016
                        .copyWith(color: Colors.white, fontSize: 16)),
                Icon(Icons.arrow_forward, color: Colors.white)
              ],
            ),
            SizedBox(height: 10),
            Text(
              value,
              style:
                  AppFonts.f70024.copyWith(color: Colors.white, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }

  List<SipData> getSipData() {
    final List<SipData> chartData = [
      SipData(category: "Equity", percentage: 35),
      SipData(category: "Hybrid", percentage: 25),
      SipData(category: "Debt", percentage: 20),
      SipData(category: "Solution", percentage: 15),
      SipData(category: "Other", percentage: 5),
    ];

    return chartData;
  }

  Widget topAmc({required String title}) {
    return Obx(() {
      if (amcLoading.isTrue)
        return Utils.shimmerWidget(400, margin: EdgeInsets.zero);
      if (amcError.isNotEmpty) return Text(amcError.value);

      return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 0, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppFonts.f40016,
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: ListView.separated(
                  itemCount: (amcWiseSipDetails.length < 5)
                      ? amcWiseSipDetails.length
                      : 5,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    Map data = amcWiseSipDetails[index] ?? "";
                    num amount = data['total_sip_amount'] ?? 0;
                    double percent = data['percentage'] ?? "null";
                    String amcName = data['amc_name'] ?? "";

                    return InkWell(
                      splashColor: Colors.white,
                      onTap: () {
                        Get.to(SchemeWiseSip(amc: amcName));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 6, top: 6),
                        child: Row(
                          children: [
                            // Image.network(data['amc_logo'] ?? "", height: 28),
                            Utils.getImage(data['amc_logo'] ?? "", 28),
                            SizedBox(width: 10),
                            Column(
                              children: [
                                SizedBox(
                                    width: 90,
                                    child: Text("${data['amc_short_name']}",
                                        style: AppFonts.f50014Black.copyWith(
                                            color: Color(0XFF242424),
                                            fontSize: 15))),
                                SizedBox(
                                    width: 90,
                                    child: Text(
                                      "(${data['total_sip']}" + " SIPS)",
                                      style: AppFonts.f40016.copyWith(
                                          fontSize: 13,
                                          color: Color(0XFF646C6C)),
                                    )),
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Text(
                                    "$rupee ${Utils.formatNumber(amount, isAmount: true)}",
                                    style: AppFonts.f50014Black.copyWith(
                                        color: Color(0XFF242424),
                                        fontSize: 15)),
                                Text(" (${percent.toStringAsFixed(2)}%)",
                                    style: AppFonts.f40016.copyWith(
                                        fontSize: 13,
                                        color: Color(0XFF646C6C))),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Color(0XFFB4B4B4),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 20,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: devWidth.floor(),
                        itemBuilder: (context, index) => Text("-",
                            style: TextStyle(color: Colors.grey[300])),
                      ),
                    );
                  },
                ),
              ),
              viewAllBtn(TopAmc()),
            ],
          ),
        ),
      );
    });
  }

  Widget viewAllBtn(Widget goTo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
            onPressed: () {
              Get.to(goTo);
            },
            child: Row(
              children: [
                Text("View All ",
                    style: AppFonts.appBarTitle.copyWith(
                        fontSize: 15, color: Config.appTheme.themeColor)),
                Icon(
                  Icons.arrow_forward,
                  size: 20,
                  color: Config.appTheme.themeColor,
                )
              ],
            )),
      ],
    );
  }

  Widget summaryCard(
      {required var heading,
      required String subHeading,
      Widget? goTo,
      bool hasArrow = true}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (goTo != null) Get.to(goTo);
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("$heading",
                      style: AppFonts.f70024.copyWith(fontSize: 18)),
                  if (hasArrow)
                    Icon(
                      Icons.arrow_forward,
                      color: Config.appTheme.themeColor,
                    )
                ],
              ),
              SizedBox(height: 4),
              Text(subHeading,
                  style: cardHeadingSmall.copyWith(
                      fontWeight: FontWeight.w400, color: Color(0xff646C6C)))
            ],
          ),
        ),
      ),
    );
  }
}

class SipData {
  SipData({
    required this.category,
    required this.percentage,
    this.amount,
  });

  final String category;
  final double percentage;
  num? amount;
}
