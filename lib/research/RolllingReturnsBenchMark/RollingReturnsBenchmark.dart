import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/api/ResearchApi.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:mymfbox2_0/rp_widgets/NoData.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RollingReturnsBenchMark extends StatefulWidget {
  const RollingReturnsBenchMark({super.key});

  @override
  State<RollingReturnsBenchMark> createState() =>
      _RollingReturnsBenchMarkState();
}

class _RollingReturnsBenchMarkState extends State<RollingReturnsBenchMark> {
  String client_name = GetStorage().read("client_name");
  late double devWidth, devHeight;
  List allCategories = [];

  TextEditingController startDateController = TextEditingController();
  String startDate = "17-04-2019";
  int selectedRadioIndex = -1;
  String selectedCategory = "Equity Schemes";
  String selectedSubCategory = "Equity: Flexi Cap";
  String selectedFund = "ICICI Pru Small Cap Gr";
  String selectedRollingPeriod = "3 Years";
  String rollingPeriods = "3 Year";
  String scheme = "ICICI Prudential Smallcap Fund - Growth";
  String btnNo = "";
  int percentage = 0;
  String shortName = "";
  String benchMarkName = "";
  double startingPoint = 0;
  List<ChartData> schemeData = [];
  List<ChartData> benchMarkData = [];
  ValueNotifier<String> tooltipDateNotifier =
      ValueNotifier<String>("13-12-2022 to 13-11-2023");
  ValueNotifier<String> tooltipFundNotifier = ValueNotifier<String>("15.50");
  ValueNotifier<String> tooltipValueBenchMarkNotifier =
      ValueNotifier<String>("14.54");
  String tooltipDate = "";
  String tooltipValue = "";
  bool isFirst = true;
  List<List<ChartData>> multipleSeriesData = [];
  List<String> rollingPeriod = [
    "1 Month",
    "1 Year",
    "2 Years",
    "3 Years",
    "5 Years",
    "7 Years",
    "10 Years",
    "15 Years"
  ];
  final List<FlSpot> data = [
    FlSpot(0, 3),
    FlSpot(1, 4),
    FlSpot(2, 3.5),
    FlSpot(3, 5),
    FlSpot(4, 4.5),
    FlSpot(5, 6),
  ];
  List subCategoryList = [];
  List originalRollingReturnBenchmarkList = [];
  List rollingReturnBenchmarkList = [];
  List newRollingReturnBenchmarkList = [];
  List chartRollingReturnBenchmarkList = [];
  final List<String> months = [];
  List<double> series1Data = [];
  List<double> series2Data = [];
  List fundList = [];

  bool isLoading = true;

  String selectedInvType = "Return Statistics\n(%)";
  int? selectedIndex;
  num minimum = 0;
  num maximum = 0;
  num average = 0;

  num lessThan0 = 0;
  num lessThan5 = 0;
  num lessThan10 = 0;
  num lessThan20 = 0;
  num greaterThan7 = 0;
  num greaterThan_20 = 0;
  num between8To10 = 0;
  num between10To12 = 0;
  num lessThan15 = 0;

  Future getDatas() async {
    isLoading = true;
    await getTopLumpsumFunds();
    await getRollingReturnsVsBenchmark();
    isLoading = false;
    return 0;
  }

  Future getTopLumpsumFunds() async {
    if (fundList.isNotEmpty) return 0;
    Map data = await ResearchApi.getTopLumpsumFunds(
      amount: '',
      category: '',
      period: '',
      amc: "",
      client_name: client_name,
    );
    List<dynamic> list = data['list'];
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    list.forEach((fund) {
      Map<String, dynamic> fundData = {
        'scheme_amfi': fund['scheme_amfi'],
        'scheme_amfi_short_name': fund['scheme_amfi_short_name']
      };
      fundList.add(fundData);
    });
    return 0;
  }

  Future getRollingReturnsVsBenchmark() async {
    if (rollingReturnBenchmarkList.isNotEmpty) return 0;
    Map data = await ResearchApi.getRollingReturnsVsBenchmark(
        scheme_name: scheme,
        start_date: startDate,
        period: rollingPeriods,
        client_name: client_name);
    if (rollingReturnBenchmarkList != null &&
        rollingReturnBenchmarkList is List<dynamic>) {
      newRollingReturnBenchmarkList = data['rollingReturnsTable'];
    } else {
      newRollingReturnBenchmarkList = [];
    }

    if (data['list'] != null) {
      chartRollingReturnBenchmarkList = data['list'];
    } else {
      chartRollingReturnBenchmarkList = [];
    }

    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }

    // Extract scheme_nav values from the first list

    rollingReturnBenchmarkList = List.from(data['rollingReturnsTable']);
    originalRollingReturnBenchmarkList = data['rollingReturnsTable'];
    // Remove items where scheme_name is "Equity: Flexi Cap"
    rollingReturnBenchmarkList
        .removeWhere((item) => item['scheme_name'] == scheme);

    for (int i = 0; i < newRollingReturnBenchmarkList.length; i++) {
      if (newRollingReturnBenchmarkList[i]['scheme_name'] == scheme) {
        selectedIndex = i;
        break;
      }
    }
    if (newRollingReturnBenchmarkList.isNotEmpty) {
      var blackboxIndex = selectedIndex ?? 0;
      var item = newRollingReturnBenchmarkList[blackboxIndex];

      if (blackboxIndex >= 0) {
        String scheme = item['scheme_name'];
        minimum = item['minimum'] ?? 0;
        maximum = item['maximum'] ?? 0;
        average = item['average'] ?? 0;

        lessThan0 = item['less_than_0'] ?? 0;
        lessThan5 = item['less_than_5'] ?? 0;
        lessThan10 = item['less_than_10'] ?? 0;
        lessThan15 = item['less_than_15'] ?? 0;
        lessThan20 = item['less_than_20'] ?? 0;
        greaterThan7 = item['greater_than_7'] ?? 0;
        greaterThan_20 = item['greater_than_20'] ?? 0;
        between8To10 = item['between_8_10'] ?? 0;
        between10To12 = item['between_10_12'] ?? 0;
      }
    }
    if (data['list'] != null) {
      if (chartRollingReturnBenchmarkList.isNotEmpty &&
          chartRollingReturnBenchmarkList[0].isNotEmpty) {
        for (final monthList in chartRollingReturnBenchmarkList[0]) {
          String navDate = monthList['nav_date'];
          String forwardDate = monthList['scheme_forward_date'];

          DateTime formatNavDate = DateTime.parse(navDate);
          DateTime formatForwardDate = DateTime.parse(forwardDate);

          String newNavDate = DateFormat('MMM yyyy').format(formatNavDate);
          String newForwardDate =
              DateFormat('MMM yyyy').format(formatForwardDate);
          String finalDate = "$newNavDate -\n$newForwardDate";
          months.add(finalDate);
        }
        multipleSeriesData = [];
        schemeData = [];
        benchMarkData = [];
        if (chartRollingReturnBenchmarkList.isNotEmpty &&
            chartRollingReturnBenchmarkList[0] != null) {
          List list = chartRollingReturnBenchmarkList[0];
          for (var element in list) {
            schemeData.add(ChartData.fromJson(element));
          }
        }
        if (chartRollingReturnBenchmarkList.length > 1 &&
            chartRollingReturnBenchmarkList[1] != null) {
          List list = chartRollingReturnBenchmarkList[1];
          for (var element in list) {
            benchMarkData.add(ChartData.fromJson(element));
          }
        }
      }
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    btnNo = "1";
    startDateController.text = startDate;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Color(0XFFECF0F0),
            appBar: AppBar(
              backgroundColor: Config.appTheme.themeColor,
              leadingWidth: 0,
              toolbarHeight: 200,
              foregroundColor: Colors.white,
              elevation: 0,
              leading: SizedBox(),
              title: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: Icon(Icons.arrow_back),
                        onTap: () {
                          Get.back();
                        },
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Rolling Return vs Benchmark",
                        style: AppFonts.f50014Black
                            .copyWith(fontSize: 18, color: Colors.white),
                      ),
                      //Spacer(),
                      //MfAboutIcon(context: context),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showSchemeBottomSheet();
                        },
                        child: appBarNewColumn(
                            "Scheme Name",
                            getFirst34(selectedFund),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showRollingPeriodBottomSheet();
                        },
                        child: appBarColumn(
                            "Rolling Period",
                            getFirst13(selectedRollingPeriod),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDatePickerDialog(context);
                        },
                        child: appBarColumn(
                            "Start Date",
                            getFirst13(startDateController.text),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: displayPage(),
          );
        });
  }

  Widget navDateAndReturns() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ValueListenableBuilder<String>(
            valueListenable: tooltipDateNotifier,
            builder: (context, tooltipDate, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 88,
                    child: Text(tooltipDate, style: AppFonts.f40013),
                  ),
                ],
              );
            },
          ),
          ValueListenableBuilder<String>(
            valueListenable: tooltipFundNotifier,
            builder: (context, tooltipValue, child) {
              return ColumnText(
                title: "Fund",
                value: "$tooltipValue%",
                valueStyle: AppFonts.f50012.copyWith(
                    color: (double.parse(tooltipValue) > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
                alignment: CrossAxisAlignment.center,
              );
            },
          ),
          ValueListenableBuilder<String>(
            valueListenable: tooltipValueBenchMarkNotifier,
            builder: (context, tooltipValue, child) {
              return ColumnText(
                title: "Benchmark",
                value: "$tooltipValue%",
                valueStyle: AppFonts.f50012.copyWith(
                    color: (double.parse(tooltipValue) > 0)
                        ? Config.appTheme.themeColor
                        : Config.appTheme.defaultLoss),
                alignment: CrossAxisAlignment.end,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget chartArea(List<ChartData> schemeData, List<ChartData> benchMarkData) {
    List<ChartData> legends = getChartLegends(schemeData);

    multipleSeriesData = [
      schemeData,
      benchMarkData,
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          navDateAndReturns(),
          Stack(
            children: [
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16),
              //   child: Text("", style: AppFonts.f40016),
              // ),
              rpChart(funChartData: multipleSeriesData),
            ],
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(legends.length, (index) {
                ChartData curr = legends[index];
                return Text("${curr.nav_date}", style: AppFonts.f40013);
              }),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget rpChart({required List<List<ChartData>> funChartData}) {
    // Calculate min and max values for Y axis
    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    
    for (var series in funChartData) {
      for (var data in series) {
        final value = data.scheme_rolling_returns?.toDouble() ?? 0;
        minY = min(minY, value);
        maxY = max(maxY, value);
      }
    }

    // Add some padding to min/max values
    final yPadding = (maxY - minY) * 0.1;
    minY -= yPadding;
    maxY += yPadding;

    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          clipData: FlClipData.all(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 5,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: ((maxY - minY) / 4).roundToDouble(),
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (funChartData[0].length / 5).floor().toDouble(),
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= funChartData[0].length) return const Text('');
                  final date = funChartData[0][value.toInt()].nav_date?.split('\n')[0] ?? '';
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Transform.rotate(
                      angle: -0.5,
                      child: Text(date, style: TextStyle(fontSize: 10)),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: funChartData[0].asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(),
                    entry.value.scheme_rolling_returns?.toDouble() ?? 0);
              }).toList(),
              isCurved: true,
              color: Config.appTheme.defaultProfit,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Config.appTheme.defaultProfit.withOpacity(0.3),
                    Config.appTheme.defaultProfit.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            if (funChartData.length > 1)
              LineChartBarData(
                spots: funChartData[1].asMap().entries.map((entry) {
                  return FlSpot(entry.key.toDouble(),
                      entry.value.scheme_rolling_returns?.toDouble() ?? 0);
                }).toList(),
                isCurved: true,
                color: Config.appTheme.themeColor,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      Config.appTheme.themeColor.withOpacity(0.3),
                      Config.appTheme.themeColor.withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
          ],
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.white,
              tooltipBorder: BorderSide(color: Colors.grey.withOpacity(0.2)),
              tooltipRoundedRadius: 8,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  final data = funChartData[spot.barIndex][spot.x.toInt()];
                  
                  // Update tooltip values
                  Future.microtask(() {
                    tooltipDateNotifier.value = data.dateFormatNav ?? '';
                    if (spot.barIndex == 0) {
                      tooltipFundNotifier.value = spot.y.toStringAsFixed(2);
                    } else {
                      tooltipValueBenchMarkNotifier.value = spot.y.toStringAsFixed(2);
                    }
                  });

                  return LineTooltipItem(
                    '',
                    const TextStyle(color: Colors.transparent),
                  );
                }).toList();
              },
            ),
          ),
        ),
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

  Widget displayPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: devHeight * 0.02),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: getButton("Return Statistics\n(%)", "1"),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: getButton("Return Distribution\n(% of times)", "2"),
                  )
                ],
              ),
            ),
          ),
          btnNo == "1"
              ? (isLoading
                  ? Utils.shimmerWidget(devHeight * 0.2,
                      margin: EdgeInsets.all(20))
                  : (originalRollingReturnBenchmarkList.isEmpty)
                      ? NoData()
                      : Column(
                          children: [
                            ListView.builder(
                              itemCount: rollingReturnBenchmarkList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                Map data = rollingReturnBenchmarkList[index];

                                return returnsStaticsCard(data);
                              },
                            ),
                            SizedBox(height: devHeight * 0.01),
                            blackBoxStatistics(),
                          ],
                        ))
              : (isLoading
                  ? Utils.shimmerWidget(devHeight * 0.2,
                      margin: EdgeInsets.all(20))
                  : (rollingReturnBenchmarkList.isEmpty)
                      ? NoData()
                      : Column(
                          children: [
                            ListView.builder(
                              itemCount: rollingReturnBenchmarkList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                Map data = rollingReturnBenchmarkList[index];
                                if (data['scheme_name'] !=
                                    selectedSubCategory) {
                                  return returnsDistributionCard(data);
                                }
                              },
                            ),
                            SizedBox(height: devHeight * 0.01),
                            blackBoxDistribution(),
                          ],
                        )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text(
                  "Rolling Return Timeline",
                  style: AppFonts.f50014Grey,
                ),
              ),
              SizedBox(height: 16),
              isLoading
                  ? Utils.shimmerWidget(
                      230,
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    )
                  : chartRollingReturnBenchmarkList.isEmpty
                      ? NoData()
                      : chartArea(schemeData, benchMarkData)
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

  String getFirst34(String text) {
    String s = text.split(":").last;
    if (s.length > 34) s = s.substring(0, 34);
    return s;
  }

  Widget blackBoxStatistics() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(horizontal: devWidth * 0.04),
      padding: EdgeInsets.symmetric(horizontal: devWidth * 0.04, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white),
                    color: Colors.white),
                child: Icon(
                  Icons.bar_chart,
                  size: 18,
                  color: Config.appTheme.themeColor,
                ),
              ),
              SizedBox(
                  width: 264,
                  child: Text(selectedFund,
                      style:
                          AppFonts.f50014Black.copyWith(color: Colors.white))),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Min",
                value: "${minimum.toStringAsFixed(2)}%",
                titleStyle: AppFonts.f40013.copyWith(
                    color: Config.appTheme.placeHolderInputTitleAndArrow),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                  title: "Max",
                  value: "${maximum.toStringAsFixed(2)}%",
                  titleStyle: AppFonts.f40013.copyWith(
                      color: Config.appTheme.placeHolderInputTitleAndArrow),
                  valueStyle:
                      AppFonts.f50014Black.copyWith(color: Colors.white),
                  alignment: CrossAxisAlignment.center),
              ColumnText(
                  title: "Average",
                  value: "${average.toStringAsFixed(2)}%",
                  titleStyle: AppFonts.f40013.copyWith(
                      color: Config.appTheme.placeHolderInputTitleAndArrow),
                  valueStyle: AppFonts.f50014Black.copyWith(
                      color: (average > 0)
                          ? Config.appTheme.defaultProfit
                          : Config.appTheme.defaultLoss),
                  alignment: CrossAxisAlignment.end),
            ],
          ),
        ],
      ),
    );
  }

  Widget blackBoxDistribution() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(horizontal: devWidth * 0.04),
      padding: EdgeInsets.symmetric(horizontal: devWidth * 0.04, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white),
                    color: Colors.white),
                child: Icon(
                  Icons.bar_chart,
                  size: 16,
                  color: Config.appTheme.themeColor,
                ),
              ),
              SizedBox(
                  width: 264,
                  child: Text(selectedFund,
                      style:
                          AppFonts.f50014Black.copyWith(color: Colors.white))),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Negative",
                value: lessThan0.toStringAsFixed(2),
                titleStyle: AppFonts.f40013.copyWith(
                    color: Config.appTheme.placeHolderInputTitleAndArrow),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                  title: "Above 20%",
                  value: greaterThan_20.toStringAsFixed(2),
                  titleStyle: AppFonts.f40013.copyWith(
                      color: Config.appTheme.placeHolderInputTitleAndArrow),
                  valueStyle:
                      AppFonts.f50014Black.copyWith(color: Colors.white),
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          DottedLine(
            verticalPadding: 5,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColumnText(
                        title: "0-8%",
                        titleStyle: AppFonts.f40013.copyWith(
                            color:
                                Config.appTheme.placeHolderInputTitleAndArrow),
                        value: lessThan5.toStringAsFixed(2),
                        valueStyle:
                            AppFonts.f50012.copyWith(color: Colors.white),
                        alignment: CrossAxisAlignment.center),
                    ColumnText(
                        title: "8-10%",
                        titleStyle: AppFonts.f40013.copyWith(
                            color:
                                Config.appTheme.placeHolderInputTitleAndArrow),
                        value: between8To10.toStringAsFixed(2),
                        valueStyle:
                            AppFonts.f50012.copyWith(color: Colors.white),
                        alignment: CrossAxisAlignment.center),
                    ColumnText(
                        title: "10-12%",
                        titleStyle: AppFonts.f40013.copyWith(
                            color:
                                Config.appTheme.placeHolderInputTitleAndArrow),
                        value: between10To12.toStringAsFixed(2),
                        valueStyle:
                            AppFonts.f50012.copyWith(color: Colors.white),
                        alignment: CrossAxisAlignment.center),
                    ColumnText(
                        title: "12-15%",
                        titleStyle: AppFonts.f40013.copyWith(
                            color:
                                Config.appTheme.placeHolderInputTitleAndArrow),
                        value: lessThan15.toStringAsFixed(2),
                        valueStyle:
                            AppFonts.f50012.copyWith(color: Colors.white),
                        alignment: CrossAxisAlignment.center),
                    ColumnText(
                        title: "15-20%",
                        titleStyle: AppFonts.f40013.copyWith(
                            color:
                                Config.appTheme.placeHolderInputTitleAndArrow),
                        value: lessThan20.toStringAsFixed(2),
                        valueStyle:
                            AppFonts.f50012.copyWith(color: Colors.white),
                        alignment: CrossAxisAlignment.center),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  showRollingPeriodBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (_, bottomState) {
            return Container(
              height: devHeight * 0.7,
              padding: EdgeInsets.all(7),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Select Rolling Period",
                          style: AppFonts.f50014Grey.copyWith(
                              fontSize: 16, color: Color(0xff242424))),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close)),
                    ],
                  ),
                  Divider(
                    color: Color(0XFFDFDFDF),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            itemCount: rollingPeriod.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  selectedRollingPeriod = rollingPeriod[index];
                                  if (rollingPeriod[index] == "1 Month") {
                                    rollingPeriods = "1 Month";
                                  } else if (rollingPeriod[index] == "1 Year") {
                                    rollingPeriods = "1 Year";
                                  } else if (rollingPeriod[index] ==
                                      "2 Years") {
                                    rollingPeriods = "2 Year";
                                  } else if (rollingPeriod[index] ==
                                      "3 Years") {
                                    rollingPeriods = "3 Year";
                                  } else if (rollingPeriod[index] ==
                                      "5 Years") {
                                    rollingPeriods = "5 Year";
                                  } else if (rollingPeriod[index] ==
                                      "7 Years") {
                                    rollingPeriods = "7 Year";
                                  } else if (rollingPeriod[index] ==
                                      "10 Years") {
                                    rollingPeriods = "10 Year";
                                  } else if (rollingPeriod[index] ==
                                      "15 Years") {
                                    rollingPeriods = "15 Years";
                                  } else {
                                    selectedRollingPeriod =
                                        rollingPeriod[index];
                                  }
                                  rollingReturnBenchmarkList = [];
                                  chartRollingReturnBenchmarkList = [];
                                  bottomState(() {});
                                  //  await getRollingReturnsVsBenchmark();

                                  Get.back();
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: selectedRollingPeriod,
                                      value: rollingPeriod[index],
                                      onChanged: (val) async {
                                        Get.back();
                                        setState(() {
                                          selectedRollingPeriod =
                                              rollingPeriod[index];
                                          if (rollingPeriod[index] ==
                                              "1 Month") {
                                            rollingPeriods = "1 Month";
                                          } else if (rollingPeriod[index] ==
                                              "1 Year") {
                                            rollingPeriods = "1 Year";
                                          } else if (rollingPeriod[index] ==
                                              "2 Years") {
                                            rollingPeriods = "2 Year";
                                          } else if (rollingPeriod[index] ==
                                              "3 Years") {
                                            rollingPeriods = "3 Year";
                                          } else if (rollingPeriod[index] ==
                                              "5 Years") {
                                            rollingPeriods = "5 Year";
                                          } else if (rollingPeriod[index] ==
                                              "7 Years") {
                                            rollingPeriods = "7 Year";
                                          } else if (rollingPeriod[index] ==
                                              "10 Years") {
                                            rollingPeriods = "10 Year";
                                          } else if (rollingPeriod[index] ==
                                              "15 Years") {
                                            rollingPeriods = "15 Year";
                                          } else {
                                            selectedRollingPeriod =
                                                rollingPeriod[index];
                                          }

                                          rollingReturnBenchmarkList = [];
                                          chartRollingReturnBenchmarkList = [];
                                          bottomState(() {});
                                          getRollingReturnsVsBenchmark();
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          rollingPeriod[index],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })),
                  ),
                ],
              ),
            );
          });
        });
  }

  showCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      builder: (context) {
        return StatefulBuilder(builder: (_, bottomState) {
          return Container(
            height: devHeight * 0.7,
            padding: EdgeInsets.all(7),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("  Select Category",
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
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allCategories.length,
                    itemBuilder: (context, index) {
                      Map temp = allCategories[index];

                      return (selectedCategory == temp['name'])
                          ? selectedCategoryChip(
                              "${temp['name']}", "${temp['count']}")
                          : InkWell(
                              onTap: () async {
                                selectedCategory = temp['name'];
                                subCategoryList = [];
                                EasyLoading.show();
                                await getTopLumpsumFunds();
                                EasyLoading.dismiss();
                                bottomState(() {});
                              },
                              child: categoryChip(
                                  "${temp['name']}", "${temp['count']}"));
                    },
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: subCategoryList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      String temp = subCategoryList[index].split(":").last;
                      return InkWell(
                        onTap: () async {
                          selectedSubCategory = subCategoryList[index];
                          EasyLoading.show();
                          fundList = [];
                          await getTopLumpsumFunds();
                          EasyLoading.dismiss();
                          rollingReturnBenchmarkList = [];
                          chartRollingReturnBenchmarkList = [];
                          bottomState(() {});
                          // await getRollingReturnsVsBenchmark();

                          Get.back();
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Radio(
                                value: subCategoryList[index],
                                groupValue: selectedSubCategory,
                                activeColor: Config.appTheme.themeColor,
                                onChanged: (val) async {
                                  selectedSubCategory = subCategoryList[index];
                                  fundList = [];
                                  rollingReturnBenchmarkList = [];
                                  chartRollingReturnBenchmarkList = [];
                                  bottomState(() {});
                                  await getTopLumpsumFunds();
                                  if (fundList.isNotEmpty) {
                                    setState(() {
                                      scheme = fundList[0]['scheme_amfi'];
                                    });
                                  }
                                  rollingReturnBenchmarkList = [];
                                  chartRollingReturnBenchmarkList = [];
                                  //  await getRollingReturnsVsBenchmark();
                                  Get.back();
                                  setState(() {});
                                }),
                            Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Color(0xffF8DFD5),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Icon(Icons.bar_chart,
                                    color: Colors.red, size: 20)),
                            Expanded(child: Text(" $temp")),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }

  showSchemeBottomSheet() {
    TextEditingController searchController = TextEditingController();

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
            height: devHeight * 0.7,
            padding: EdgeInsets.all(7),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select Scheme",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.close),
                    )
                  ],
                ),
                Divider(),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search Fund...',
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Config.appTheme.themeColor,
                    ),
                    onChanged: (value) {
                      bottomState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: fundList.length,
                    itemBuilder: (context, index) {
                      if (searchController.text.isNotEmpty &&
                          !fundList[index]['scheme_amfi_short_name']
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase())) {
                        return SizedBox.shrink();
                      }
                      return RadioListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(fundList[index]['scheme_amfi_short_name']),
                        value: index,
                        groupValue: selectedRadioIndex,
                        onChanged: (int? value) async {
                          if (value != null) {
                            selectedRadioIndex = value;
                            selectedFund =
                                fundList[value]['scheme_amfi_short_name'];
                            scheme = fundList[value]['scheme_amfi'];
                            rollingReturnBenchmarkList = [];
                            chartRollingReturnBenchmarkList = [];

                            //  await getRollingReturnsVsBenchmark();
                            setState(() {});
                            Get.back();
                          }
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }

  Widget selectedCategoryChip(String name, String count) {
    List l = name.split(" ");
    if (l.length > 2)
      name = "${l[0]} ${l[1]}";
    else
      name = "${l[0]}";

    return Container(
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          color: Config.appTheme.themeColor,
          borderRadius: BorderRadius.circular(8)),
      child: Text("$name ($count)", style: TextStyle(color: Colors.white)),
    );
  }

  Widget categoryChip(String name, String count) {
    List l = name.split(" ");
    if (l.length > 2)
      name = "${l[0]} ${l[1]}";
    else
      name = "${l[0]}";

    return Container(
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          color: Color(0XFFF1F1F1), borderRadius: BorderRadius.circular(8)),
      child: Text("$name ($count)"),
    );
  }

  Widget appBarColumn(String title, String value, Widget suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14)),
        Container(
          width: devWidth * 0.42,
          padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Color(0XFFDEE6E6),
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
                Spacer(),
                suffix
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget appBarNewColumn(String title, String value, Widget suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14)),
        Container(
          width: devWidth * 0.91,
          padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Color(0XFFDEE6E6),
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
                Spacer(),
                suffix
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget returnsStaticsCard(Map data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Column(
          children: [
            //1st row
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 0, 14),
              child: Row(
                children: [
                  Image.network(data["logo"] ?? "", height: 30),
                  SizedBox(width: 5),
                  SizedBox(
                      width: 200,
                      child: Text(data["scheme_name"],
                          style: AppFonts.f50014Black
                              .copyWith(color: Config.appTheme.themeColor))),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Color(0xffEDFFFF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        )),
                    child: Row(children: [
                      Text(data["scheme_rating"],
                          style: TextStyle(color: Config.appTheme.themeColor)),
                      Icon(Icons.star, color: Config.appTheme.themeColor)
                    ]),
                  )
                ],
              ),
            ),
            //2nd row
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ColumnText(
                        title: "Min",
                        value: data['minimum'] != null
                            ? "${data['minimum'].toStringAsFixed(2)}%"
                            : "0.00%",
                      ),
                      ColumnText(
                          title: "Max",
                          value: data['maximum'] != null
                              ? "${data['maximum'].toStringAsFixed(2)}%"
                              : "0.00%",
                          alignment: CrossAxisAlignment.center),
                      ColumnText(
                          title: "Average",
                          value: data['average'] != null
                              ? "${data['average'].toStringAsFixed(2)}%"
                              : "0.00%",
                          valueStyle: AppFonts.f50014Black.copyWith(
                              color: (average > 0)
                                  ? Config.appTheme.defaultProfit
                                  : Config.appTheme.defaultLoss),
                          alignment: CrossAxisAlignment.end),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget returnsDistributionCard(Map data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Column(
          children: [
            //1st row
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 0, 14),
              child: Row(
                children: [
                  Image.network(data["logo"] ?? "", height: 30),
                  SizedBox(width: 10),
                  SizedBox(
                      width: 200,
                      child: Text(data["scheme_name"],
                          style: AppFonts.f50014Black
                              .copyWith(color: Config.appTheme.themeColor))),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Color(0xffEDFFFF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        )),
                    child: Row(children: [
                      Text(data["scheme_rating"],
                          style: TextStyle(color: Config.appTheme.themeColor)),
                      Icon(Icons.star, color: Config.appTheme.themeColor)
                    ]),
                  )
                ],
              ),
            ),
            //2nd row
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ColumnText(
                        title: "Negative",
                        value: data['less_than_0'] != null
                            ? "${data['less_than_0'].toStringAsFixed(2)}"
                            : "0.00",
                      ),
                      ColumnText(
                          title: "Above 20%",
                          value: data['greater_than_20'] != null
                              ? "${data['greater_than_20'].toStringAsFixed(2)}"
                              : "0.00",
                          alignment: CrossAxisAlignment.end),
                    ],
                  ),
                ],
              ),
            ),
            DottedLine(
              verticalPadding: 4,
            ),
            //3rd row
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 25, 14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ColumnText(
                          title: "0-8%",
                          value: data['less_than_5'] != null
                              ? "${data['less_than_5'].toStringAsFixed(2)}"
                              : "0.00",
                          valueStyle:
                              AppFonts.f50012.copyWith(color: Colors.black),
                          alignment: CrossAxisAlignment.center),
                      ColumnText(
                          title: "8-10%",
                          value: data['less_than_10'] != null
                              ? "${data['less_than_10'].toStringAsFixed(2)}"
                              : "0.00",
                          valueStyle:
                              AppFonts.f50012.copyWith(color: Colors.black),
                          alignment: CrossAxisAlignment.center),
                      ColumnText(
                          title: "10-12%",
                          value: data['between_10_12'] != null
                              ? "${data['between_10_12'].toStringAsFixed(2)}"
                              : "0.00",
                          valueStyle:
                              AppFonts.f50012.copyWith(color: Colors.black),
                          alignment: CrossAxisAlignment.center),
                      ColumnText(
                          title: "12-15%",
                          value: data['less_than_15'] != null
                              ? "${data['less_than_15'].toStringAsFixed(2)}"
                              : "0.00",
                          valueStyle:
                              AppFonts.f50012.copyWith(color: Colors.black),
                          alignment: CrossAxisAlignment.center),
                      ColumnText(
                          title: "15-20%",
                          value: data['less_than_20'] != null
                              ? "${data['less_than_20'].toStringAsFixed(2)}"
                              : "0.00",
                          valueStyle:
                              AppFonts.f50012.copyWith(color: Colors.black),
                          alignment: CrossAxisAlignment.center),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getButton(String flow, String selectedBtnNo) {
    String tempFlow = flow.capitalizeFirst ?? "";

    if (btnNo == selectedBtnNo)
      return RpFilledButton(
        text: tempFlow,
        padding: EdgeInsets.zero,
      );
    else
      return PlainButton(
        text: tempFlow,
        padding: EdgeInsets.zero,
        onPressed: () {
          setState(() {
            btnNo = selectedBtnNo;
          });
        },
      );
  }

  Widget lineChart() {
    return Column(
      children: [
        // Enable horizontal scrolling
        SizedBox(
          width: MediaQuery.of(context)
              .size
              .width, // Set the width to match the screen width
          height: 400,
          child: LineChart(
            LineChartData(
              // minX: 0,
              minX: startingPoint, // Set the starting point for x-axis
              maxX: startingPoint + months.length.toDouble() - 1,
              // minY: 0,
              // maxY: 100,
              borderData: FlBorderData(
                show: false, // Set to false to hide the outer border
              ),
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int skipInterval = 10;
                      String month = "";
                      // Only show labels for every skipInterval-th value
                      if (value % skipInterval == 0) {
                        month = months.isNotEmpty
                            ? months[value.toInt() % months.length]
                            : '';
                      }

                      return Expanded(
                        child: Center(
                          child: Text(
                            month,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 6,
                            ),
                            textAlign: TextAlign.center, // Align text center
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    getTitlesWidget: (value, meta) {
                      int percentage = (value + 5).toInt();
                      return Expanded(
                        child: Text(
                          '$percentage%',
                          style: TextStyle(
                            color: Config.appTheme.themeColor,
                            fontSize: 9,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  // spots: List.generate(months.length, (index) {
                  //   return FlSpot(index.toDouble(), series1Data[index]);
                  // }),

                  spots: List.generate(months.length, (index) {
                    if (index < series1Data.length) {
                      return FlSpot(index.toDouble(), series1Data[index]);
                    } else {
                      // Handle case where index exceeds series1Data length
                      // This could be logging an error, returning a default value, etc.
                      return FlSpot(index.toDouble(),
                          0); // For example, returning 0 if index is out of range
                    }
                  }),

                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 1.5,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(
                    show: true,
                    color: Config.appTheme.themeColor.withOpacity(
                        0.09), // Adjust opacity and color as needed
                  ),
                  dotData: FlDotData(show: false),
                ),
                LineChartBarData(
                  spots: List.generate(months.length, (index) {
                    if (index < series2Data.length) {
                      return FlSpot(index.toDouble(), series2Data[index]);
                    } else {
                      return FlSpot(index.toDouble(), 0);
                    }
                  }),
                  isCurved: true,
                  color: Config.appTheme.themeColor,
                  barWidth: 1.5,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(
                    show: true,
                    color: Config.appTheme.themeColorDark.withOpacity(
                        0.09), // Adjust opacity and color as needed
                  ),
                  // belowBarData: BarAreaData(
                  //     show: true,
                  //     gradient: LinearGradient(
                  //         begin: Alignment.bottomRight,
                  //         stops: [
                  //           0.5,
                  //           0.9
                  //         ],
                  //         colors: [
                  //           Config.appTheme.themeColor.withOpacity(.5),
                  //           Config.appTheme.themeColorDark.withOpacity(.6),
                  //         ])),
                  dotData: FlDotData(show: false),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.blue.withOpacity(0.8),
                  tooltipRoundedRadius: 6,
                  maxContentWidth: 400,
                  tooltipPadding: EdgeInsets.all(8),
                  getTooltipItems: (List<LineBarSpot> touchedSpots) {
                    return touchedSpots.map((LineBarSpot touchedSpot) {
                      final TextStyle textStyle = TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                      );

                      // Concatenate month, series1 data, and series2 data
                      String tooltipText = '';
                      String month = months.isNotEmpty
                          ? months[touchedSpot.x.toInt() % months.length]
                          : '';
                      month = month.replaceAll('\n', ' ');
                      String series1Text = touchedSpot.barIndex == 0
                          ? '$shortName ${touchedSpot.y}'
                          : '';
                      String series2Text = touchedSpot.barIndex == 1
                          ? '$benchMarkName ${touchedSpot.y}'
                          : '';
                      tooltipText =
                          '$month\n$series1Text${touchedSpot.barIndex == 1 ? series2Text : ''}';

                      return LineTooltipItem(
                        tooltipText,
                        textStyle,
                        textAlign: TextAlign.left,
                      );
                    }).toList();
                  },
                ),
                handleBuiltInTouches: true,
                touchSpotThreshold: 16,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12,
              height: 12,
              color: Colors.blue,
            ),
            Expanded(
              child: Text(
                shortName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: 12,
              height: 12,
              color: Config.appTheme.themeColor,
            ),
            Expanded(
              child: Text(
                benchMarkName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  void showDatePickerDialog(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      startDateController.text = formattedDate;
      startDate = formattedDate;
      setState(() {
        startDate = formattedDate;
      });
      rollingReturnBenchmarkList = [];
      chartRollingReturnBenchmarkList = [];

      // await getRollingReturnsVsBenchmark();
    }
  }
}

class ChartData {
  String? nav_date;
  String? dateFormatNav;
  String? scheme_forward_date;
  num? scheme_rolling_returns;

  ChartData(
      {this.nav_date, this.scheme_forward_date, this.scheme_rolling_returns});

  ChartData.fromJson(Map<String, dynamic> json) {
    String navDate = json['nav_date'];
    String forwardDate = json['scheme_forward_date'];

    DateTime formatNavDate = DateTime.parse(navDate);
    DateTime formatForwardDate = DateTime.parse(forwardDate);

    String newNavDate = DateFormat('MMM yyyy').format(formatNavDate);
    String newForwardDate = DateFormat('MMM yyyy').format(formatForwardDate);
    String finalDate = "$newNavDate-\n$newForwardDate";

    nav_date = finalDate;

    String topNewNavDate = DateFormat('dd-MM-yyyy').format(formatNavDate);
    String topNewForwardDate =
        DateFormat('dd-MM-yyyy').format(formatForwardDate);

    dateFormatNav = "$topNewNavDate to\n$topNewForwardDate";

    scheme_forward_date = json['scheme_forward_date'];
    scheme_rolling_returns = json['scheme_rolling_returns'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nav_date'] = nav_date;
    data['scheme_forward_date'] = scheme_forward_date;
    data['scheme_rolling_returns'] = scheme_rolling_returns;

    return data;
  }
}

class ChartData1 {
  String? nav_date;
  String? dateFormatNav;
  String? scheme_forward_date;
  num? scheme_rolling_returns;

  ChartData1(
      {this.nav_date, this.scheme_forward_date, this.scheme_rolling_returns});

  ChartData1.fromJson(Map<String, dynamic> json) {
    String navDate = json['nav_date'];
    String forwardDate = json['scheme_forward_date'];

    DateTime formatNavDate = DateTime.parse(navDate);
    DateTime formatForwardDate = DateTime.parse(forwardDate);

    String newNavDate = DateFormat('MMM yyyy').format(formatNavDate);
    String newForwardDate = DateFormat('MMM yyyy').format(formatForwardDate);
    String finalDate = "$newNavDate -\n$newForwardDate";
    String topNewNavDate = DateFormat('dd-MM-yyyy').format(formatNavDate);
    String topNewForwardDate =
        DateFormat('dd-MM-yyyy').format(formatForwardDate);

    dateFormatNav = "$topNewNavDate to\n$topNewForwardDate";
    nav_date = finalDate;
    scheme_forward_date = json['scheme_forward_date'];
    scheme_rolling_returns = json['scheme_rolling_returns'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nav_date'] = nav_date;
    data['scheme_forward_date'] = scheme_forward_date;
    data['scheme_rolling_returns'] = scheme_rolling_returns;

    return data;
  }
}
