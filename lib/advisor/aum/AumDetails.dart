// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/advisor/aum/AmcWiseAum.dart';
import 'package:mymfbox2_0/advisor/aum/BranchRmAssociateAum.dart';
import 'package:mymfbox2_0/advisor/aum/BroadCategoryAum.dart';
import 'package:mymfbox2_0/advisor/aum/SchemeWiseAum.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/pojo/aum/AmcWiseAumPojo.dart';
import 'package:mymfbox2_0/pojo/aum/RiskWiseAumPojo.dart';
import 'package:mymfbox2_0/pojo/aum/SchemeWiseAumPojo.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpSelectableChip.dart';
import 'package:mymfbox2_0/rp_widgets/ViewAllBtn.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../pojo/aum/CategoryWiseAum.dart';
import '../../rp_widgets/NoData.dart';

class AumDetails extends StatefulWidget {
  const AumDetails({super.key});

  @override
  State<AumDetails> createState() => _AumDetailsState();
}

class _AumDetailsState extends State<AumDetails> {
  final GlobalKey<RefreshIndicatorState> refreshIndicator =
      GlobalKey<RefreshIndicatorState>();

  Key pageKey = UniqueKey();

  late double devWidth, devHeight;
  int mfd_id = getUserId();
  late String client_name;

  String selectedMonths = "12 Months";
  List<String> monthList = ["12 Months", "24 Months", "36 Months"];
  List<AmcWiseAumPojo> amcListPojo = [];
  int type_id = GetStorage().read("type_id");

  List schemeList = [];
  List<SchemeWiseAumPojo> schemeListPojo = [];

  Map riskColors = {
    "Very High": Color(0xffBF0305),
    "High": Color(0xffFE5502),
    "Moderately High": Color(0xffFF9104),
    "Moderate": Color(0xFFFFD507),
    "Low to Moderate": Color(0xffBDD527),
    "Low": Color(0xff5EC214),
  };

  List broadCategoryList = [];
  var selectedBroadCategory = "All";

  List categoryList = [];

  List branchDataList = [];
  List branchTypeList = [];

  String selectedBranchType = "";

  List aumData = [];
  String aumWiseTitle = "";

  RxBool aumLoading = true.obs;
  RxString aumError = "".obs;

  List<CategoryWiseAumPojo> categoryPojoList = [];

  /*Future getAumData() async {
    aumLoading.value = true;
    try{
      Map data =await AdminApi.getAumSummaryDetails(user_id: "$mfd_id", client_name: client_name);
      if(data['status'] != 200){
        Utils.showError(context, data['msg']);
        return 0;
      }
      aumData = data['list'];
      totalAum = data['aum_total'];
      aumChanges = data['aum_change_value'];
      aumpercentage = data['aum_change_percentage'];
      auminvested = data['aum_invested_amount'];
    }catch(e){
      aumError.value = "Exception Occured";
    }
    aumLoading.value = false;
   return 0;
  }*/

  Future<Map> getAumData() async {
    return await AdminApi.getAumSummaryDetails(
        user_id: "$mfd_id", client_name: client_name);
  }

  RxBool isBroadCategoryLoading = true.obs;
  RxString isBroadCategoryError = "".obs;
  Future fetchBroadCategoryData() async {
    isBroadCategoryLoading.value = true;
    try {
      Map data = await Api.getBroadCategoryWiseAUM(
          user_id: "$mfd_id", client_name: client_name);
      if (data['status'] != 200) {
        isBroadCategoryLoading.value = false;
        isBroadCategoryError.value = data['msg'];
        return -1;
      }
      broadCategoryList = data['list'];
    } catch (e) {
      isBroadCategoryError.value = "Exception Occured";
    }
    isBroadCategoryLoading.value = false;
    return 0;
  }

  Future fetchCategoryData(String selectedCategory) async {
    isBroadCategoryLoading.value = true;
    try {
      Map data = await Api.getCategoryWiseAUM(
          user_id: "$mfd_id",
          client_name: client_name,
          broad_category: selectedCategory,
          max_count: "5");
      if (data['status'] != 200) {
        isBroadCategoryLoading.value = false;
        isBroadCategoryError.value = data['msg'];
        return -1;
      }
      categoryList = data['list'];
      convertListCategoryToObj();

    } catch (e) {
      isBroadCategoryError.value = "Exception Occured";
    }
    isBroadCategoryLoading.value = false;
    return 0;
  }

  convertListCategoryToObj() {
    categoryPojoList = [];
    for (var element in categoryList) {
      String name = element['category_name'];
      // convert debt: name --> name
      if (name.contains(":")) {
        element['category_name'] = name.split(":").last.trim();
        element['broadCategory'] = name.split(":").first.trim();
      }

      categoryPojoList.add(CategoryWiseAumPojo.fromJson(element));
    }
    categoryPojoList.sort((a, b) => b.aumAmount!.compareTo(a.aumAmount!));
  }

  RxBool chartLoading = true.obs;
  RxString chartError = "".obs;

  Future fetchChartData() async {
    chartLoading.value = true;
    try {
      Map data = await Api.getAumHistoryByMonths(
        user_id: mfd_id,
        client_name: client_name,
        frequency: selectedMonths,
        type: "",
        type_user_name: "",
      );

      if (data['status'] != 200) {
        chartLoading.value = false;
        chartError.value = data['msg'];
        return [];
      }
      List list = data['list'];
      convertToChartObj(list);
    } catch (e) {
      chartError.value = "Exception Occured";
    }
    chartLoading.value = false;
    return 0;
  }

  convertToChartObj(List list) {
    chartData = [];
    for (var element in list) {
      chartData.add(ChartData.fromJson(element));
    }
  }

  num itemCount = 0;
  num totalAum = 0;
  num aumChanges = 0;
  double aumpercentage = 0;
  num auminvested = 0;
  num totalMarketValue = 0;

  List<RiskWiseAumPojo> riskData = [];
  List selectedRiskList = [];

  RxBool topAmcLoading = true.obs;
  RxString topAmcError = "".obs;
  List topAmcList = [];
  List<AmcWiseAumPojo> topAmcListPojo = [];

  Future getTopAmc() async {
    topAmcLoading.value = true;
    try {
      Map data = await Api.getAMCWiseAum(
          user_id: "$mfd_id",
          client_name: client_name,
          max_count: "",
          broker_code: "All",
          sort_by: "aum");

      if (data['status'] != 200) {
        topAmcLoading.value = false;
        topAmcError.value = data['msg'];
        return 0;
      }
      topAmcList = data['list'];
      convertListToObj(topAmcList);
    } catch (e) {
      print("getTopAmc exception = $e");
    }
    topAmcLoading.value = false;
    return 0;
  }

  convertListToObj(List list) {
    amcListPojo = [];
    for (var element in list) {
      amcListPojo.add(AmcWiseAumPojo.fromJson(element));
    }
  }

  RxBool schemeLoading = true.obs;
  RxString schemeError = "".obs;
  Future getSchemeList() async {
    schemeLoading.value = true;
    try {
      Map data = await Api.getSchemesWiseAUM(
          user_id: mfd_id,
          max_count: "",
          client_name: client_name,
          sort_by: "aum",
          amc: "",
          broad_category: "",
          category: "",
          riskometer: "");
      if (data['status'] != 200) {
        schemeLoading.value = false;
        schemeError.value = data['msg'];
        return 0;
      }
      schemeList = data['list'];
      totalMarketValue = data['total_aum'] ?? 0;
      itemCount = data['total_count'];
    } catch (e) {
      schemeError.value = "Exception Occurred";
    }
    schemeLoading.value = false;
    return 0;
  }

  RxBool riskLoading = true.obs;
  RxString riskError = "".obs;
  Future getRikOMeterWiseAUM() async {
    riskLoading.value = true;
    try {
      Map data = await Api.getRikOMeterWiseAUM(
          user_id: mfd_id, client_name: client_name);
      if (data['status'] != 200) {
        riskLoading.value = false;
        riskError.value = data['msg'];
        return 0;
      }
      selectedRiskList = data['risk'];
    } catch (e) {
      riskError.value = "Exception occured";
    }
    riskLoading.value = false;
    return 0;
  }

  RxBool isBranchLoading = true.obs;
  RxString isBranchError = "".obs;
  Future fetchBranchData() async {
    isBranchLoading.value = true;
    try {
      Map data = await AdminApi.getBranchWiseAUM(
          user_id: mfd_id, client_name: client_name, page_id: 1, sort_by: '');
      if (data['status'] != 200) {
        isBranchLoading.value = false;
        isBranchError.value = data['msg'];
        return 0;
      }
      branchDataList = data['list'];
    } catch (e) {
      isBranchError.value = "Exception Occured";
    }
    isBranchLoading.value = false;
    return 0;
  }

  Future fetchRmData() async {
    isBranchLoading.value = true;
    try {
      Map data = await AdminApi.getRMWiseAUM(
        user_id: mfd_id,
        client_name: client_name,
        page_id: 1,
        sort_by: '',
      );
      if (data['status'] != 200) {
        isBranchLoading.value = false;
        isBranchError.value = data['msg'];
        return 0;
      }
      branchDataList = data['list'];
    } catch (e) {
      isBranchError.value = "Exception Occured";
    }
    isBranchLoading.value = false;
    return 0;
  }

  Future fetchAssociateData() async {
    isBranchLoading.value = true;
    try {
      Map data = await AdminApi.getAssociateAum(
          user_id: mfd_id, client_name: client_name, page_id: 1, sort_by: "");
      if (data['status'] != 200) {
        isBranchLoading.value = false;
        isBranchError.value = data['msg'];
        return 0;
      }
      branchDataList = data['list'];
    } catch (e) {
      isBranchError.value = "Exception Occured";
    }
    isBranchLoading.value = false;
    return 0;
  }




  bool isFirst = true;
  bool isLoading = true;

  Future getDatas() async {
    if (!isFirst) return 0;
    await Future.wait([
      fetchBroadCategoryData(),
      fetchCategoryData(selectedBroadCategory),
      getAumData(),
      fetchChartData(),
      getSchemeList(),
      getTopAmc(),
      getRikOMeterWiseAUM(),
      // fetchRmData(),
      // fetchAssociateData(),
    ]);
    isLoading = false;
    isFirst = false;
    return 0;
  }


  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;
    client_name = GetStorage().read("client_name");

    if (type_id == 5) {
      aumWiseTitle = "Branch/RM/Associate Wise AUM";
      branchTypeList = ['Branch', 'RM', 'Associate'];
      selectedBranchType = "Branch";
      fetchBranchData();
    } else if (type_id == 7) {
      aumWiseTitle = "RM/Associate Wise AUM";
      branchTypeList = ['RM', 'Associate'];
      selectedBranchType = "RM";
      fetchRmData();
    } else if (type_id == 2) {
      aumWiseTitle = "Associate Wise AUM";
      branchTypeList = ['Associate'];
      selectedBranchType = "Associate";
      fetchAssociateData();
    } else {
      aumWiseTitle = "Branch/RM/Associate Wise AUM";
      branchTypeList = ['Branch', 'RM', 'Associate'];
      selectedBranchType = "Branch";
      fetchBranchData();
    }

    return FutureBuilder(
      future: getDatas(),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Config.appTheme.mainBgColor,
          appBar: adminAppBar(title: "AUM Details", hasAction: false),
          body: RefreshIndicator(
            key: refreshIndicator,
            onRefresh: () async {
              Future<void>.delayed(const Duration(seconds: 3));
              isFirst = true;
              setState(() {});
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    FutureBuilder<Map>(
                      future: getAumData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Utils.shimmerWidget(170,
                              margin: EdgeInsets.all(0));
                        } else if (snapshot.hasError) {
                          return Utils.shimmerWidget(170,
                              margin: EdgeInsets.all(0));
                        } else {
                          return aumCard(snapshot.data!);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    chartArea(),
                    SizedBox(height: 16),
                    broadCategoryData(),
                    SizedBox(height: 16),
                    topAmc(title: "Top 5 AMCs"),
                    SizedBox(height: 16),
                    topSchemes(title: "Top 5 Schemes"),
                    SizedBox(height: 16),
                    if (type_id == UserType.ADMIN)
                      riskAum(title: "Risk-O-Meter Wise AUM"),
                    SizedBox(height: 16),
                    if (type_id != UserType.ASSOCIATE)
                      branchAum(title: "$aumWiseTitle"),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget broadCategoryData() {
    return Obx(
      () {
        if (isBroadCategoryLoading.isTrue)
          return Utils.shimmerWidget(200, margin: EdgeInsets.zero);
        if (isBroadCategoryError.isNotEmpty)
          return Utils.showBoxError(
              height: 200, msg: isBroadCategoryError.value);
        return SizedBox(
          width: devWidth,
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 16, 0, 6),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                      String amount = Utils.formatNumber(category['category_value']);
                      double percentage = category['category_percent'];

                      //print("selectedBroadCategory = ${controller.selectedBroadCategory}");

                      return RpSelectableChip(
                          isSelected: selectedBroadCategory == title,
                          title: "$title ($percentage %)",
                        value: "$rupee $amount",
                        onTap: () async {
                          selectedBroadCategory = title;
                          await fetchCategoryData(selectedBroadCategory);
                          setState(() {});
                        },
                      );

                      /*return (selectedBroadCategory == title)
                          ? selectedAmcChip("$title ($percentage %)", "$rupee $amount")
                          : amcChip("$title ($percentage %)", "$rupee $amount");*/
                    },
                  ),
                ),
                SizedBox(height: 22),
                Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) {
                      Map data = categoryList[index];
                      String title = data['category_name'];
                      title = title.split(":").last.trim();
                      double percent = data['percent'];
                      num amount = data['aum_amount'];

                      return Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(title,
                                    style: cardHeadingSmall),
                                Text("${percent.toStringAsFixed(2)} %",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
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
                ViewAllBtn(onTap: () {
                  Get.to(() => BroadCategoryAum(
                      selectedCategory: selectedBroadCategory,
                      broadCategoryList: broadCategoryList));
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  List<ChartData> chartData = [];
  Widget chartArea() {
    return Obx(
      () {
        if (chartLoading.isTrue)
          return Utils.shimmerWidget(200, margin: EdgeInsets.zero);
        if (chartError.isNotEmpty)
          return Utils.showBoxError(height: 200, msg: chartError.value);
        List<ChartData> legends = getChartLegends(chartData);
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("AUM History", style: AppFonts.f40016),
                  ),
                  rpChart(funChartData: chartData),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(legends.length, (index) {
                  ChartData curr = legends[index];
                  return Text("${curr.aum_month}");
                }),
              ),
              SizedBox(height: 16),
              Center(
                child: ToggleSwitch(
                  minWidth: 100,
                  initialLabelIndex: monthList.indexOf(selectedMonths),
                  onToggle: (val) async {
                    selectedMonths = monthList[val ?? 0];
                    await fetchChartData();
                  },
                  labels: monthList,
                  activeBgColor: [Config.appTheme.buttonColor,],
                  inactiveBgColor: Colors.white,
                  borderColor: [Colors.grey.shade300],
                  borderWidth: 1,
                  dividerColor: Colors.grey.shade300,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget rpChart({required List<ChartData> funChartData}) {

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
        trackballBehavior: trackballBehavior,
        series: <CartesianSeries<ChartData, String>>[
          SplineAreaSeries(
            name: "AUM",
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Config.appTheme.themeColorDark.withOpacity(0.8),
                Config.appTheme.mainBgColor.withOpacity(0.2)
              ],
              tileMode: TileMode.mirror,
            ),
            borderColor: Config.appTheme.themeColor,
            borderWidth: 2,
            dataSource: funChartData,
            xValueMapper: (ChartData sales, _) => sales.aum_month,
            yValueMapper: (ChartData sales, _) => sales.current_value?.toInt() ?? 0,
            dataLabelSettings: DataLabelSettings(isVisible: false),
          ),
        ],
      ),
    );
  }



  List<ChartData> getChartLegends(List<ChartData> chartData) {
    if (chartData.isEmpty) return [];
    int length = chartData.length;

    ChartData first = chartData.first;
    ChartData mid = chartData[length ~/ 2];
    ChartData last = chartData.last;
    return [first, mid, last];
  }

  Widget riskAum({required String title}) {

    Map<String, int> riskPriority = {
      "Very High": 1,
      "High": 2,
      "Moderately High": 3,
      "Moderate": 4,
      "Low to Moderate": 5,
      "Low": 6,
    };



    riskData.clear();

    // Sort the selectedRiskList based on the custom priority order
    selectedRiskList.sort((a, b) {
      int priorityA = riskPriority[a['risk']] ?? 6; // Default to 7 if not found
      int priorityB = riskPriority[b['risk']] ?? 6; // Default to 7 if not found

      return priorityA.compareTo(priorityB);
    });

    for (var element in selectedRiskList) {
      riskData.add(RiskWiseAumPojo.fromJson(element));
    }

    return Obx(() {
      if (riskLoading.isTrue)
        return Utils.shimmerWidget(200, margin: EdgeInsets.zero);
      if (riskError.isNotEmpty)
        return Utils.showBoxError(height: 200, msg: riskError.value);
      return Container(
        padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                itemCount: (riskData.length > 6) ? 6 : riskData.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  RiskWiseAumPojo risk = riskData[index];
                  String key = riskColors.keys.elementAt(index);

                  String riskName = risk.risk ?? "";
                  num amount = risk.aumAmount ?? 0;
                  num percentage = risk.returns ?? 0;

                  return InkWell(
                    onTap: () {
                      Get.to(SchemeWiseAum(selectedRisk: [key]));
                    },
                    splashColor: riskColors[key],
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 6, top: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: riskColors[key],
                            radius: 5,
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                              width: 120,
                              child: Text(riskName, style: cardHeadingSmall)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "$rupee ${Utils.formatNumber(amount, isAmount: true)} (${percentage.toStringAsFixed(2)}%)",
                              style: cardHeadingSmall,
                              textAlign: TextAlign.end,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.arrow_forward_ios,
                              size: 15, color: Color(0xffB4B4B4)),
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
                      itemBuilder: (context, index) =>
                          Text("-", style: TextStyle(color: Colors.grey[300])),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

    Widget branchAum({required String title, Widget? goTo}) {
      return Obx(
        () {
          if (isBranchLoading.isTrue)
            return Utils.shimmerWidget(200, margin: EdgeInsets.zero);
          if (isBranchError.isNotEmpty)
            return Utils.showBoxError(height: 200, msg: isBranchError.value);
          return Container(
            padding: EdgeInsets.fromLTRB(16, 16, 0, 6),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFonts.f40016,
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 45,
                  child: ListView.builder(
                    itemCount: branchTypeList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      String title = branchTypeList[index];

                      return (selectedBranchType == title)
                          ? selectedBranchChip(title)
                          : branchChip(title);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 16, 16),
                  child: (branchDataList.isEmpty)
                      ? NoData(text: "No $selectedBranchType Available",)
                      : ListView.separated(
                          itemCount: (branchDataList.length > 3)
                              ? 3
                              : branchDataList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Map data = branchDataList[index];
                            String title = "";
                            String amount = "";

                            if (selectedBranchType == 'Branch'){
                              title = data['branch'];
                              amount = Utils.formatNumber(data['net_brokerage'], isAmount: true);
                            }

                            if (selectedBranchType == 'RM'){
                              title = data['rm_name'] ?? "";
                              amount = Utils.formatNumber(data['net_brokerage'], isAmount: true);
                            }

                            if (selectedBranchType == 'Associate'){
                              title = data['subbroker_name'] ?? "";
                              amount = Utils.formatNumber(data['net_brokerage'], isAmount: true) ;
                            }


                            return Padding(
                              padding: EdgeInsets.only(bottom: 6, top: 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: 100,
                                      child: Text(
                                        title,
                                        style: cardHeadingSmall,
                                      )),
                                  Text(
                                    "$rupee $amount",
                                    style: cardHeadingSmall,
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 20,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: devWidth.floor(),
                                itemBuilder: (context, index) => Text(
                                  "-",
                                  style: TextStyle(color: Colors.grey[300]),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                if(branchDataList.isNotEmpty)
                ViewAllBtn(onTap: () {
                  Get.to(() =>
                      //  Backup(selectedBranch: apiController.selectedBranchType.value)
                      BranchRmAssociateAum(selectedBranch: selectedBranchType));
                })
              ],
            ),
          );
        },
      );
    }

  Widget topAmc({required String title}) {
    topAmcListPojo.clear();
    for (var element in topAmcList) {
      topAmcListPojo.add(AmcWiseAumPojo.fromJson(element));
    }
    topAmcListPojo.sort((a, b) => b.aumAmount!.compareTo(a.aumAmount!));

    return Obx(() {
      if (topAmcLoading.isTrue)
        return Utils.shimmerWidget(200, margin: EdgeInsets.zero);
      if (topAmcError.isNotEmpty)
        return Utils.showBoxError(height: 200, msg: topAmcError.value);
      return Container(
        padding: EdgeInsets.fromLTRB(16, 16, 0, 6),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                itemCount:
                    (topAmcListPojo.length > 5) ? 5 : topAmcListPojo.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  AmcWiseAumPojo data = topAmcListPojo[index];
                  num amount = data.aumAmount ?? 0;
                  String percent = data.aumPercentage ?? "null";

                  return Padding(
                    padding: EdgeInsets.only(bottom: 6, top: 6),
                    child: Row(
                      children: [
                        //Image.network(data.amcLogo ?? "", height: setImageSize(28)),
                        Utils.getImage(data.amcLogo ?? "", setImageSize(28)),

                        SizedBox(width: 10),
                        SizedBox(
                            width: 90,
                            child: Text("${data.amcShortName}",
                                style: cardHeadingSmall)),
                        Spacer(),
                        Text(
                          "$rupee ${Utils.formatNumber(amount, isAmount: true)}",
                          style: cardHeadingSmall,
                        ),
                        Text(" ($percent%)")
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 20,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: devWidth.floor(),
                      itemBuilder: (context, index) =>
                          Text("-", style: TextStyle(color: Colors.grey[300])),
                    ),
                  );
                },
              ),
            ),
            ViewAllBtn(onTap: () {
              Get.to(() => AmcWiseAum());
            })
          ],
        ),
      );
    });
  }

  Widget topSchemes({
    required String title,
  }) {
    return Obx(() {
      if (schemeLoading.isTrue)
        return Utils.shimmerWidget(200, margin: EdgeInsets.zero);
      if (schemeError.isNotEmpty)
        return Utils.showBoxError(height: 200, msg: schemeError.value);
      return Container(
        padding: EdgeInsets.fromLTRB(16, 16, 0, 6),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                itemCount: (schemeList.length > 5) ? 5 : schemeList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  Map data = schemeList[index];
                  double amount = data['market_value'];

                  return Padding(
                    padding: EdgeInsets.only(bottom: 6, top: 6),
                    child: Row(
                      children: [
                        // Image.network(data['logo'], height: setImageSize(28)),
                        Utils.getImage(data['logo'], setImageSize(28)),
                        SizedBox(width: 10),
                        Expanded(
                            child: Text("${data['scheme_amfi_short_name']}",
                                style: cardHeadingSmall)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "$rupee ${Utils.formatNumber(amount, isAmount: true)}",
                              style: cardHeadingSmall,
                            ),
                            Text("(${data['returns']}%)")
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 20,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: devWidth.floor(),
                      itemBuilder: (context, index) =>
                          Text("-", style: TextStyle(color: Colors.grey[300])),
                    ),
                  );
                },
              ),
            ),
            ViewAllBtn(onTap: () {
              Get.to(() => SchemeWiseAum());
            }),
          ],
        ),
      );
    });
  }

  double multiplier = 10;

  Widget percentageBar(double percent, int index) {
    double total = devWidth * 0.55;
    percent = (total * percent) / 100;

    if (index == 0) multiplier = Utils.getMultiplier(percent);
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

  /*Widget aumCard() {
    print("aum error------> aum");
    //if (isLoading)return Utils.shimmerWidget(devHeight * 0.18, margin: EdgeInsets.zero);

     // if (aumLoading.isTrue) return Utils.shimmerWidget(200, margin: EdgeInsets.zero);
    // if (aumError.isNotEmpty) return Utils.showBoxError(height: 200,msg: aumError.value);

      String aum = Utils.formatNumber(totalAum, isShortAmount: true);
      print("aum error $aum aum");
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage("assets/aumCardBg.png"),
              fit: BoxFit.cover,
              colorFilter:
                  ColorFilter.mode(Config.appTheme.themeColor, BlendMode.color),
            )),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Mutual Fund AUM",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: devHeight * 0.02),
              Text(
                "$rupee 10000",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 32),
              ),
              SizedBox(height: 5),
              dayChangeTitle(),
              SizedBox(height: 4),
              //dayChange(),
            ],
          ),
        ),
    );
  }*/

  Widget aumCard(Map aumData) {
    //if (isLoading)return Utils.shimmerWidget(devHeight * 0.18, margin: EdgeInsets.zero);

    String aum = Utils.formatNumber(aumData['aum_total'], isShortAmount: false);

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: (Config.app_client_name != "vbuildwealth")
                ? AssetImage("assets/aumCardBg.png")
                : AssetImage("assets/aumOrangeBg.png"),
            fit: BoxFit.cover,
            colorFilter:
                ColorFilter.mode(Config.appTheme.themeColor, BlendMode.color),
          )),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Mutual Fund AUM",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: devHeight * 0.02),
            Text(
              "$rupee $aum",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 25),
            ),
            if (type_id == UserType.ADMIN) ...[
              SizedBox(height: 5),
              dayChangeTitle(),
              SizedBox(height: 4),
              dayChange(aumData),
            ]
          ],
        ),
      ),
    );
  }

  Widget selectedAmcChip(String title, String value) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
      margin: EdgeInsets.fromLTRB(0, 0, 14, 0),
      decoration: BoxDecoration(
          color: Config.appTheme.themeColor,
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: Colors.white)),
          Text(value, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget amcChip(String title, String value) {
    print("title = $title");
    return InkWell(
      onTap: () {
        print("amcChip $title");
        selectedBroadCategory = title;
        fetchCategoryData(title);
        //selectedCategory = title;
        categoryList = [];
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        margin: EdgeInsets.fromLTRB(0, 0, 14, 0),
        decoration: BoxDecoration(
            color: Color(0XFFF1F1F1), borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [Text(title), Text(value)],
        ),
      ),
    );
  }

  Widget selectedBranchChip(String title) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.fromLTRB(0, 2, 16, 2),
      decoration: BoxDecoration(
          color: Config.appTheme.themeColor,
          borderRadius: BorderRadius.circular(8)),
      child: Text(title, style: TextStyle(color: Colors.white)),
    );
  }

  Widget branchChip(String title) {
    return InkWell(
      onTap: () {
        print("branchChip $title");

        selectedBranchType = title;

        if (selectedBranchType == 'Branch') fetchBranchData();
        if (selectedBranchType == 'RM') fetchRmData();
        if (selectedBranchType == 'Associate') fetchAssociateData();

        //update(['branch']);
      },
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.fromLTRB(0, 2, 16, 2),
        decoration: BoxDecoration(
            color: Color(0XFFF1F1F1), borderRadius: BorderRadius.circular(8)),
        child: Text(title),
      ),
    );
  }

  Widget dayChangeTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "1 Day Change:",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        Text(
          "Invested",
          style: TextStyle(color: Colors.white, fontSize: 12),
        )
      ],
    );
  }

  /*Widget dayChange() {
    String change =
        Utils.formatNumber(aumChanges, isAmount: true);
    double percentage = aumpercentage;
    String invested = Utils.formatNumber(auminvested, isShortAmount: true);
    print("change $change");
    print("percentange $percentage");
    print("invested $invested");
    return Row(
      children: [
        Text(
          "$rupee $change ",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Text(" ($percentage%)",
            style: TextStyle(
                color: percentage.isNegative
                    ? Config.appTheme.defaultLoss
                    : Config.appTheme.themeProfit,
                fontWeight: FontWeight.bold)),
        Spacer(),
        Text(
          "$rupee $invested",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )
      ],
    );
  }*/

  Widget dayChange(Map aumData) {
    String change =
        Utils.formatNumber(aumData['aum_change_value'], isAmount: false);
    double percentage = aumData['aum_change_percentage'] ?? 0;
    String invested =
        Utils.formatNumber(aumData['aum_invested_amount'], isShortAmount: false);
    return Row(
      children: [
        Text(
          "$rupee $change ",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Text(" ($percentage%)",
            style: TextStyle(
                color: percentage.isNegative
                    ? Config.appTheme.defaultLoss
                    : Config.appTheme.themeProfit,
                fontWeight: FontWeight.bold)),
        Spacer(),
        Text(
          "$rupee $invested",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}

class ChartData {
  String? aum_month;
  num? current_value;
  ChartData({this.aum_month, this.current_value});

  ChartData.fromJson(Map<String, dynamic> json) {
    aum_month = json['aum_month'];
    current_value = json['current_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aum_month'] = aum_month;
    data['current_value'] = current_value;

    return data;
  }
}
/*class ApiController extends GetxController {
  var chartData = Map<String, dynamic>().obs;
  var isChartDataLoading = false.obs;
  var isChartAreaLoading = false.obs;

  var isBroadCategoryLoading = false.obs;
  List broadCategoryList = [].obs;

  var isCategoryLoading = false.obs;
  List categoryList = [].obs;

  var selectedBroadCategory = "All".obs;

  List branchDataList = [].obs;
  List branchTypeList = ['Branch', 'RM', 'Associate'].obs;

  var selectedBranchType = "Branch".obs;
  var isBranchLoading = false.obs;

  String client_name = GetStorage().read("client_name");
  int mfd_id = GetStorage().read("mfd_id");

  @override
  void onInit() {
    super.onInit();
    fetchChartData(loadChartOnly: false);
    fetchBroadCategoryData();
    fetchBranchData();
  }

  Future<void> fetchChartData(
      {String selectedMonths = '12 Months',
      required bool loadChartOnly}) async {
    if (loadChartOnly) {
      isChartAreaLoading.value = true;
    } else {
      isChartDataLoading.value = true;
    }

    chartData.value = await Api.getAumHistoryByMonths(
        user_id: mfd_id, client_name: client_name, frequency: selectedMonths);

    if (loadChartOnly) {
      isChartAreaLoading.value = false;
    } else {
      isChartDataLoading.value = false;
    }
  }

  Future<void> fetchBroadCategoryData() async {
    isBroadCategoryLoading.value = true;
    Map data = await Api.getBroadCategoryWiseAUM(
        user_id: "$mfd_id", client_name: client_name);
    broadCategoryList = data['list'];
    isBroadCategoryLoading.value = false;
    fetchCategoryData("All");
  }

  Future<void> fetchCategoryData(String selectedCategory) async {
    print("calleelldd = $selectedCategory");
    isCategoryLoading.value = true;
    Map data = await Api.getCategoryWiseAUM(
        user_id: "$mfd_id",
        client_name: client_name,
        broad_category: selectedCategory,
        max_count: "5");
    categoryList = data['list'];
    isCategoryLoading.value = false;
  }

  Future<void> fetchBranchData() async {
    isBranchLoading.value = true;
    Map data = await AdminApi.getBranchWiseAUM(
        user_id: mfd_id, client_name: client_name, page_id: 1, sort_by: '');
    branchDataList = data['list'];
    isBranchLoading.value = false;
  }

  Future<void> fetchRmData() async {
    isBranchLoading.value = true;
    Map data = await AdminApi.getRMWiseAUM(
      user_id: mfd_id,
      client_name: client_name,
      page_id: 1,
      sort_by: '',
    );
    branchDataList = data['list'];
    isBranchLoading.value = false;
  }

  Future<void> fetchAssociateData() async {
    isBranchLoading.value = true;
    Map data = await AdminApi.getAssociateAum(
        user_id: mfd_id, client_name: client_name, page_id: 1, sort_by: "");
    branchDataList = data['list'];
    isBranchLoading.value = false;
  }
}*/
