import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/pojo/MfSummaryPojo.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DayChange.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../rp_widgets/PercentageBar.dart';

class PortfolioAnalysis extends StatefulWidget {
  const PortfolioAnalysis(
      {super.key, required this.mfSummary, this.oneDayChange = 0});

  final MfSummaryPojo mfSummary;
  final num oneDayChange;

  @override
  State<PortfolioAnalysis> createState() => _PortfolioAnalysisState();
}

class _PortfolioAnalysisState extends State<PortfolioAnalysis> {
  bool isLoading = true;
  late double devWidth, devHeight;
  late List broadCategoryList = [];
  late List categoryList = [];
  late List topSectorList = [];
  late List topHoldingList = [];
  List amcList = [];

  int user_id = getUserId();
  String client_name = GetStorage().read('client_name');
  String selectedCategory = "All";
  String selectedBroadCategory = "All";
  String selectedSectorHolding = "Top Sectors";

  List<String> sectorholdingList = [
    "Top Sectors",
    "Top Holdings",
  ];

  List holdingDtList = ["Equity Market Cap", "Debt Credit Quality"];
  String holdingDt = "Equity Market Cap";

  List sortList = ["A to Z", "AUM (High to Low)"];

  String selectedSort = "AUM (High to Low)";

  late num oneDayChange;
  Iterable keys = GetStorage().getKeys();

  Future getDatas() async {
    EasyLoading.isShow;

    await getBroadCategoryWisePortfolio();
    await getCategoryWisePortfolio();
    await getTopSectors();
    await getTopHoldings();
    await getAmcWisePortfolio();
    await getPortfolioAnalysisGraphData();

    EasyLoading.dismiss();
    isLoading = false;
    return 0;
  }

  Future getBroadCategoryWisePortfolio() async {
    if (broadCategoryList.isNotEmpty) return 0;
    Map data = await InvestorApi.getBroadCategoryWisePortfolio(
        user_id: user_id, client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['status_msg']);
      return -1;
    }
    broadCategoryList = data['broad_category_list'];

    return 0;
  }

  Future getCategoryWisePortfolio() async {
    if (categoryList.isNotEmpty) return 0;

    Map data = await InvestorApi.getCategoryWisePortfolio(
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

  Future getTopSectors() async {
    if (topSectorList.isNotEmpty) return 0;

    Map data = await InvestorApi.getTopSectors(
      user_id: user_id,
      client_name: client_name,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['status_msg']);
      return -1;
    }
    topSectorList = data['list'];
    return 0;
  }

  Future getTopHoldings() async {
    if (topHoldingList.isNotEmpty) return 0;

    Map data = await InvestorApi.getTopHoldings(
      user_id: user_id,
      client_name: client_name,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['status_msg']);
      return -1;
    }
    topHoldingList = data['list'];
    return 0;
  }

  Future getAmcWisePortfolio() async {
    if (amcList.isNotEmpty) return 0;

    Map data = await InvestorApi.getAmcWisePortfolio(
        user_id: user_id, client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['status_msg']);
      return -1;
    }

    amcList = data['amc_list'];
    sortOptions();
    return 0;
  }

  List<ChartData> chartData = [];

  Future getPortfolioAnalysisGraphData() async {
    if (chartData.isNotEmpty) return 0;

    Map data = await InvestorApi.getPortfolioAnalysisGraphData(
        user_id: user_id,
        client_name: client_name,
        frequency: "Last $selectedMonth Months");

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    List list = data['list'];

    list.forEach((element) {
      chartData.add(ChartData.fromJson(element));
    });

    return 0;
  }

  @override
  void initState() {
    // implement initState
    super.initState();
    oneDayChange = widget.oneDayChange;
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
          appBar: rpAppBar(
              title: "Portfolio Analysis",
              bgColor: Config.appTheme.themeColor,
              actions: [
                // IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
              ],
              foregroundColor: Colors.white),
          body: SideBar(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Fixed header (mfSummaryCard)
                mfSummaryCard(widget.mfSummary),

                // Expanded widget to fill remaining space
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        chartArea(),
                        // rpChart(chartData: chartDataList),
                        broadCategoryCard(),
                        SizedBox(height: 16),
                        sectorHoldingsCard(),
                        SizedBox(height: 16),
                        // holdingDistributionCard(),
                        // SizedBox(height: 16),
                        amcOverviewCard(),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // child: SingleChildScrollView(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       SizedBox(height: 16),
            //       chartArea(),
            //       // rpChart(chartData: chartDataList),
            //       broadCategoryCard(),
            //       SizedBox(height: 16),
            //       sectorHoldingsCard(),
            //       SizedBox(height: 16),
            //       // holdingDistributionCard(),
            //       // SizedBox(height: 16),
            //       amcOverviewCard(),
            //       SizedBox(height: 16),
            //     ],
            //   ),
            // ),
          ),
        );
      },
    );
  }

  List<int> monthList = [12, 24, 36, 48, 60];
  int selectedMonth = 12;

  Widget chartArea() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
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
                          "Current Cost",
                          style: AppFonts.f40013.copyWith(),
                        ),
                      ],
                    ),
                    /*ColumnText(
                        title: DateFormat('dd MMM yyyy').format(DateTime.now()),
                        value: "$rupee ${Utils.formatNumber(0)}",
                        valueStyle: AppFonts.f50014Grey
                            .copyWith(color: Config.appTheme.themeProfit)),
                    ColumnText(
                        title: "Current Cost",
                        value: "$rupee ${Utils.formatNumber(0)}",
                        alignment: CrossAxisAlignment.end,
                        valueStyle: AppFonts.f50014Grey
                            .copyWith(color: Config.appTheme.themeColor))*/
                  ],
                ),
              ),
              rpChart()
            ],
          ),
          SizedBox(height: 16),
          Center(
            child: ToggleSwitch(
              minWidth: 100,
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
    if (chartData.isEmpty) return Utils.shimmerWidget(200);
    
    // Create TrackballBehavior instance outside the chart
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
      width: devWidth,
      height: 250,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(top: 16),
      child: SfCartesianChart(
        margin: EdgeInsets.all(0),
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
          isVisible: false,
          majorGridLines: MajorGridLines(width: 0),
          rangePadding: ChartRangePadding.none
        ),
        primaryYAxis: NumericAxis(
          isVisible: false,
          numberFormat: NumberFormat.decimalPattern(),
          rangePadding: ChartRangePadding.additional,
        ),
        trackballBehavior: trackballBehavior, // Use the trackball instance
        series: <CartesianSeries<ChartData, String>>[
          SplineAreaSeries(
            name: "Current Value",
            xValueMapper: (ChartData sales, _) => sales.month,
            yValueMapper: (ChartData sales, _) => sales.currValue?.toInt(),
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
            name: "Current Cost",
            xValueMapper: (ChartData sales, _) => sales.month,
            yValueMapper: (ChartData sales, _) => sales.currCost?.toInt(),
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

  double categoryPercentageMultiplier = 1;

  Widget broadCategoryCard() {
    if (categoryList.isEmpty) return Utils.shimmerWidget(300);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Broad Category Allocation", style: AppFonts.f40016),
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

                if (title != 'All')
                  title = title.substring(0, title.length - 8);

                double percentage = category['category_percent'];

                String amount = Utils.formatNumber(category['category_value'],
                    isAmount: true);

                if (index == 0)
                  categoryPercentageMultiplier =
                      Utils.getMultiplier(percentage);

                return (selectedCategory.contains(title))
                    ? selectedAmcChip(title,
                        "${percentage.toStringAsFixed(2)} % ($rupee $amount)")
                    : amcChip(title,
                        "${percentage.toStringAsFixed(2)} % ($rupee $amount)");
              },
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Category",
                style: AppFonts.f40013,
              ),
              Text(
                "Allocation",
                style: AppFonts.f40013,
              ),
            ],
          ),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: categoryList.length,
            itemBuilder: (context, index) {
              Map data = categoryList[index];
              String title = data['category_name'];
              title = title.split(":").last.trim();
              double percent = data['category_percent'];
              num? amount = data['category_value'];

              return Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title,
                            style: TextStyle(fontWeight: FontWeight.bold)),
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
          if (broadCategoryList.length > 5)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Text("Show More ",
                            style: AppFonts.appBarTitle.copyWith(
                                fontSize: 14,
                                color: Config.appTheme.themeColor)),
                      ],
                    )),
              ],
            ),
        ],
      ),
    );
  }

  Widget sectorHoldingsCard() {
    if (isLoading) return Utils.shimmerWidget(300);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sectors & Holdings",
            style: AppFonts.f40016,
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sectorholdingList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                String sectorholding = sectorholdingList[index];

                bool isSelected = (selectedSectorHolding == sectorholding);

                if (isSelected)
                  return selectedHoldingTitleChip(sectorholding, index);
                else
                  return amcHoldingChip(sectorholding, index);
              },
            ),
          ),
          SizedBox(height: 16),
          Row(
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
          SizedBox(height: 8),
          if (selectedSectorHolding == "Top Sectors") topSectorsData(),
          if (selectedSectorHolding == "Top Holdings") topHoldingsData(),
        ],
      ),
    );
  }

  String sectorShowMode = "More";

  toggleShowMode(String mode) {
    if (mode == 'Less') return 'More';
    if (mode == 'More') return 'Less';
  }

  int getShowLength(String mode, List list) {
    if (mode == 'More') {
      return (list.length > 5) ? 5 : list.length;
    } else
      return list.length;
  }

  String holdingShowMode = "More";

  double sectorPercentageMultiplier = 1;

  Widget topSectorsData() {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: getShowLength(sectorShowMode, topSectorList),
          itemBuilder: (context, index) {
            Map data = topSectorList[index];
            String title = data['name'];
            double percent = data["value"];

            if (index == 0)
              sectorPercentageMultiplier = Utils.getMultiplier(percent);

            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(title, style: AppFonts.f50014Black)),
                      Text('$percent %', style: AppFonts.f50014Black)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      PercentageBar(
                        percent,
                        width: devWidth * 0.8,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 16),
        if (topSectorList.length > 5)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    sectorShowMode = toggleShowMode(sectorShowMode);
                    setState(() {});
                  },
                  child: Text("Show $sectorShowMode",
                      style: AppFonts.appBarTitle.copyWith(
                          fontSize: 14, color: Config.appTheme.themeColor)))
            ],
          ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget topHoldingsData() {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: getShowLength(holdingShowMode, topHoldingList),
          itemBuilder: (context, index) {
            Map data = topHoldingList[index];
            String title = data['name'];
            double percent = data["value"]; //data['percent'];
            //  num amount = 250000; //data['aum_amount'];
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(title, style: AppFonts.f50014Black)),
                      Text("$percent %", style: AppFonts.f50014Black)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      PercentageBar(
                        percent.abs(),
                        width: devWidth * 0.80,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  holdingShowMode = toggleShowMode(holdingShowMode);
                  setState(() {});
                },
                child: Text("Show $holdingShowMode",
                    style: AppFonts.f50014Black.copyWith(
                        fontSize: 14, color: Config.appTheme.themeColor))),
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget holdingDistributionCard() {
    if (isLoading) return Utils.shimmerWidget(200);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        width: devWidth,
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Holding Distribution",
              style: AppFonts.f40016,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: holdingDtList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  holdingDt = holdingDtList[index];

                  // double amount = category['category_value'] ;
                  // double percentage = category['category_percent'];

                  bool isSelected = (selectedSectorHolding == index);

                  if (isSelected)
                    return selectedAmcTitleChip(holdingDt, index);
                  else
                    return amcTitleChip(holdingDt);
                },
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: topSectorList.length,
                itemBuilder: (context, index) {
                  Map data = topSectorList[index];
                  String title = data['name'];
                  title = title.split(":").last.trim();
                  double percent = data["value"]; //data['percent'];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(title, style: AppFonts.f50014Black),
                            Text('$percent %', style: AppFonts.f50014Black)
                          ],
                        ),
                        DottedLine(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getFirst13(String text) {
    String s = text.split(":").last;
    if (s.length > 13) s = s.substring(0, 13);
    return s;
  }

  showSortFilter() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        builder: (context) {
          return StatefulBuilder(builder: (_, bottomState) {
            return Container(
              height: devHeight * 0.35,
              padding: EdgeInsets.all(7),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("  Sort By",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close))
                    ],
                  ),
                  Divider(),
                  ListView.builder(
                    itemCount: sortList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          selectedSort = sortList[index];

                          sortOptions();
                          bottomState(() {});
                          setState(() {});
                          Get.back();
                        },
                        child: Row(
                          children: [
                            Radio(
                                value: sortList[index],
                                groupValue: selectedSort,
                                activeColor: Config.appTheme.themeColor,
                                onChanged: (val) {
                                  selectedSort = sortList[index];
                                  sortOptions();
                                  bottomState(() {});
                                  setState(() {});
                                  Get.back();
                                }),
                            Text(sortList[index])
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          });
        });
  }

  sortOptions() {
    if (selectedSort.contains("AUM")) {
      amcList.sort((a, b) => b['percent']!.compareTo(a['percent']));
    }

    if (selectedSort == "A to Z") {
      amcList.sort((a, b) => a['amc_name']!.compareTo(b['amc_name']));
    }
  }

  String amcShowMode = 'More';

  Widget amcOverviewCard() {
    if (isLoading) return Utils.shimmerWidget(300);

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "AMC Overview",
                style: AppFonts.f40016,
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  showSortFilter();
                },
                child: appBarColumn(selectedSort),
              ),
            ],
          ),
          SizedBox(height: 16),
          ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: getShowLength(amcShowMode, amcList),
              itemBuilder: (context, index) {
                Map amc = amcList[index];
                String logo = amc['logo'];
                String name = amc['amc_name'];

                String percent = amc['percent'].toStringAsFixed(2);
                String amount =
                    Utils.formatNumber(amc['value'], isAmount: true);

                return Row(
                  children: [
                    Image.network(logo, height: 32),
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
                  amcShowMode = toggleShowMode(amcShowMode);
                  setState(() {});
                },
                child: Text("Show $amcShowMode",
                    style: AppFonts.f50014Black.copyWith(
                        fontSize: 14, color: Config.appTheme.themeColor)),
              ),
            )
        ],
      ),
    );
  }

  Widget appBarColumn(String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Config.appTheme.themeColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Row(
              children: [
                Text(value,
                    style: TextStyle(
                        color: Config.appTheme.themeColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                // Spacer(),
                //  suffix
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget selectedAmcTitleChip(String title, int index) {
    return Container(
      width: devWidth * 0.4,
      padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
      margin: EdgeInsets.fromLTRB(0, 0, 14, 0),
      decoration: BoxDecoration(
          color: Config.appTheme.themeColor,
          borderRadius: BorderRadius.circular(8)),
      child: Text(title,
          textAlign: TextAlign.center,
          style: AppFonts.f50014Black.copyWith(color: Colors.white)),
    );
  }

  Widget amcTitleChip(String title) {
    return InkWell(
      onTap: () {
        selectedSectorHolding = title;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
        margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
        decoration: BoxDecoration(
            color: Color(0XFFF1F1F1), borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Text(
              title,
              style: AppFonts.f50014Black.copyWith(color: Colors.black),
            )
          ],
        ),
      ),
    );
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
    return InkWell(
      onTap: () {
        selectedCategory = title;
        if (selectedCategory != "All")
          selectedCategory = "$selectedCategory Schemes";
        categoryList = [];
        setState(() {});
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

  Widget mfSummaryCard(MfSummaryPojo pojo) {
    String value = Utils.formatNumber(pojo.totalCurrValue);
    String cost = Utils.formatNumber(pojo.totalCurrCost);
    String gain = Utils.formatNumber(pojo.totalUnrealisedGain);
    String date = Utils.getFormattedDate();

    return Container(
      color: Config.appTheme.themeColor,
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 10, 16, 16),
        decoration: BoxDecoration(
            color: Config.appTheme.overlay85,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Current Value as on $date",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: AppColors.readableGrey,
                  )),
              SizedBox(height: 10),
              Text(
                "$rupee $value",
                style:
                    AppFonts.f70024.copyWith(color: Config.appTheme.themeColor),
              ),

              if (oneDayChange == 1 ||
                  ((keys.contains("adminAsInvestor")) ||
                      (keys.contains("adminAsFamily")) != false))
                //day change
                DayChange(
                    change_value: pojo.dayChangeValue ?? 0,
                    percentage: pojo.dayChangePercentage ?? 0),
              //

              SizedBox(height: 5),
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
                      value: "${pojo.totalXirr}",
                      valueStyle: TextStyle(
                          color: ((pojo.totalXirr)! > 0)
                              ? Config.appTheme.defaultProfit
                              : Config.appTheme.defaultLoss,
                          fontWeight: FontWeight.w500),
                      alignment: CrossAxisAlignment.end),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectedHoldingTitleChip(String title, int index) {
    return InkWell(
      onTap: () {
        getDatas();
      },
      child: Container(
        width: devWidth * 0.4,
        padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
        margin: EdgeInsets.fromLTRB(0, 0, 14, 0),
        decoration: BoxDecoration(
            color: Config.appTheme.themeColor,
            borderRadius: BorderRadius.circular(8)),
        child: Text(title,
            textAlign: TextAlign.center,
            style: AppFonts.f50014Black.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget amcHoldingChip(String title, int index) {
    return InkWell(
      onTap: () {
        selectedSectorHolding = title;
        setState(() {});
      },
      child: Container(
        width: devWidth * 0.4,
        padding: EdgeInsets.fromLTRB(0, 8, 10, 8),
        margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
        decoration: BoxDecoration(
            color: Color(0XFFF1F1F1), borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Text(
              title,
              style: AppFonts.f50014Black.copyWith(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}

class ChartData {
  String? month;
  num? currCost;
  num? currValue;

  ChartData({this.month, this.currCost, this.currValue});

  ChartData.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    currCost = json['curr_cost'];
    currValue = json['curr_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['month'] = month;
    data['curr_cost'] = currCost;
    data['curr_value'] = currValue;
    return data;
  }
}
