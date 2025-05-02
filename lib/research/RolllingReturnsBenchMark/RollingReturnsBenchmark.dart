import 'dart:async';

import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
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
  final RollingReturnsController controller =
      Get.put(RollingReturnsController());

  String client_name = GetStorage().read("client_name") ?? '';
  late double devWidth, devHeight;
  List allCategories = [];

  TextEditingController startDateController = TextEditingController();

  // String startDate = "26-04-2020";
  int selectedRadioIndex = -1;

  // String selectedCategory = "Equity Schemes";
  String selectedSubCategory = "Equity: Flexi Cap";

  //String selectedFund = "ICICI Pru BlueChip Gr";
  //String selectedRollingPeriod = "3 Years";
  //String rollingPeriods = "3 Year";
  //String scheme = "ICICI Pru BlueChip Gr";
  String btnNo = "";
  int percentage = 0;
  String shortName = "";
  String benchMarkName = "";
  double startingPoint = 0;
  List<ChartData> schemeData = [];
  List<ChartData> benchMarkData = [];
  ValueNotifier<String> tooltipDateNotifier = ValueNotifier<String>("");
  ValueNotifier<String> tooltipFundNotifier = ValueNotifier<String>("");
  ValueNotifier<String> tooltipValueBenchMarkNotifier =
      ValueNotifier<String>("");
  String tooltipDate = "";
  String tooltipValue = "";
  bool isFirst = true;
  List<List<ChartData>> multipleSeriesData = [];

  List<String> rollingPeriodList = [
    "1 Month",
    "1 Year",
    "2 Year",
    "3 Year",
    "5 Year",
    "7 Year",
    "10 Year",
    "15 Year"
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

  bool isInvalidDate = false;

  Future getDatas() async {
    isLoading = true;
    await getRollingReturnsSchemes();
    await getRollingReturnsVsBenchmark();
    isLoading = false;
    controller.shouldRefresh.value = false;
    return 0;
  }

  List schemeNameList = [];

  Future getRollingReturnsSchemes() async {
    if (fundList.isNotEmpty) return 0;
    Map data =
        await ResearchApi.getRollingReturnsSchemes(client_name: client_name);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    schemeNameList = data['scheme_list'];
    return 0;
  }

  String SchemeStartdate = '';

  Future getSchemeInceptionAndLatestNavDate(String formattedDate) async {
    Map data = await ResearchApi.getSchemeInceptionAndLatestNavDate(
        scheme_name: controller.selectedFund.value,
        start_date: formattedDate,
        clientName: client_name);

    if (data['status'] != SUCCESS) {
      if (context.mounted) {
        Utils.showError(context, data['msg']);
      }
      isInvalidDate = true;
      return false;
    }

    SchemeStartdate = data['scheme_start_date'];
    DateTime schemeStart = DateFormat('dd-MM-yyyy').parse(SchemeStartdate);
    DateTime selectedStart =
        DateFormat('dd-MM-yyyy').parse(controller.startDate.value);

    if (selectedStart.isBefore(schemeStart)) {
      String formattedSchemeDate = DateFormat('dd-MM-yyyy').format(schemeStart);
      if (context.mounted) {
        Utils.showError(
            context,
            ' ${controller.selectedFund.value} inception date is $formattedSchemeDate. '
            'Please select a start date greater than or equal to the scheme inception date.');
      }
      rollingReturnBenchmarkList = [];
      chartRollingReturnBenchmarkList = [];
      isInvalidDate = true;
      setState(() {});
      return false;
    }

    isInvalidDate = false;
    return true;
  }

  List rollingReturnsTable = [];

  Future getRollingReturnsVsBenchmark() async {
    Map data = await ResearchApi.getRollingReturnsVsBenchmark(
        scheme_name: controller.selectedFund.value,
        start_date: controller.startDate.value,
        period: controller.selectedRollingPeriod.value,
        client_name: client_name);

    if (rollingReturnBenchmarkList != null &&
        rollingReturnBenchmarkList is List<dynamic>) {
      newRollingReturnBenchmarkList = data['rollingReturnsTable'];
    }
    // else {
    //   newRollingReturnBenchmarkList = [];
    // }

    rollingReturnsTable = data['rollingReturnsTable'];

    if (rollingReturnsTable.isEmpty) {
      Utils.showError(context,
          "Choose a period lesser than ${controller.selectedRollingPeriod.value} or change the start date to ${controller.selectedRollingPeriod.value} back from now.");
      return 0;
    } else {
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
      rollingReturnBenchmarkList.removeWhere(
          (item) => item['scheme_name'] == controller.selectedFund.value);

      for (int i = 0; i < newRollingReturnBenchmarkList.length; i++) {
        if (newRollingReturnBenchmarkList[i]['scheme_name'] ==
            controller.selectedFund.value) {
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
            if (schemeData.isNotEmpty) {
              tooltipDateNotifier.value = schemeData[0].nav_date ?? '';
              tooltipFundNotifier.value =
                  schemeData[0].scheme_rolling_returns?.toStringAsFixed(2) ??
                      '0.00';
            }
          }
          if (chartRollingReturnBenchmarkList.length > 1 &&
              chartRollingReturnBenchmarkList[1] != null) {
            List list = chartRollingReturnBenchmarkList[1];
            for (var element in list) {
              benchMarkData.add(ChartData.fromJson(element));
            }
            if (benchMarkData.isNotEmpty) {
              tooltipDateNotifier.value = benchMarkData[0].nav_date ?? '';
              tooltipValueBenchMarkNotifier.value =
                  benchMarkData[0].scheme_rolling_returns?.toStringAsFixed(2) ??
                      '0.00';
            }
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
    startDateController.text = controller.startDate.value;
    // Set initial refresh to true to load data
    controller.shouldRefresh.value = true;
    isInvalidDate = false;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
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
                    showSchemeBottomSheet(context);
                  },
                  child: Obx(() => appBarNewColumn(
                      "Scheme Name",
                      getFirst34(controller.selectedFund.value),
                      Icon(Icons.keyboard_arrow_down,
                          color: Config.appTheme.themeColor))),
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
                  child: Obx(() => appBarColumn(
                        "Rolling Period",
                        getFirst13(controller.selectedRollingPeriod.value),
                        Icon(Icons.keyboard_arrow_down,
                            color: Config.appTheme.themeColor),
                        devWidth * 0.3,
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    showDatePickerDialog(context);
                  },
                  child: Obx(() => appBarColumn(
                        "Start Date",
                        getFirst13(controller.startDate.value),
                        Icon(Icons.keyboard_arrow_down,
                            color: Config.appTheme.themeColor),
                        devWidth * 0.33,
                      )),
                ),
                GestureDetector(
                  onTap: () async {
                    bool isValid = await getSchemeInceptionAndLatestNavDate(
                        controller.startDate.value);
                    if (isValid) {
                      // Only set refresh flag if date is valid
                      controller.shouldRefresh.value = true;
                      setState(() {});
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 22),
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                    decoration: BoxDecoration(
                      color: Config.appTheme.universalTitle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text("Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      body: Obx(() => controller.shouldRefresh.value
          ? FutureBuilder(
              future: getDatas(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Utils.shimmerWidget(devHeight,
                      margin: EdgeInsets.all(20));
                }
                return displayPage();
              })
          : displayPage()),
    );
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
                    width: 80,
                    child: Text(tooltipDate,
                        style: AppFonts.f40013.copyWith(fontSize: 12)),
                  ),
                ],
              );
            },
          ),
          ValueListenableBuilder<String>(
            valueListenable: tooltipFundNotifier,
            builder: (context, tooltipValue, child) {
              final double? value = double.tryParse(tooltipValue);
              return ColumnText(
                title: "Fund",
                value: value != null ? "$value%" : "-",
                valueStyle: AppFonts.f50012.copyWith(
                  color: (value != null && value > 0)
                      ? Config.appTheme.defaultProfit
                      : Config.appTheme.defaultLoss,
                ),
                alignment: CrossAxisAlignment.center,
              );
            },
          ),
          ValueListenableBuilder<String>(
            valueListenable: tooltipValueBenchMarkNotifier,
            builder: (context, tooltipValue, child) {
              final double? value = double.tryParse(tooltipValue);
              return ColumnText(
                title: "Benchmark",
                value: value != null ? "$value%" : "-", // Handle invalid values
                valueStyle: AppFonts.f50012.copyWith(
                  color: (value != null && value > 0)
                      ? Config.appTheme.themeColor
                      : Config.appTheme.defaultLoss,
                ),
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
          SizedBox(height: 16),
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
        ],
      ),
    );
  }

  // Widget rpChart({required List<List<ChartData>> funChartData}) {
  //   // Calculate min and max values for Y axis
  //   double minY = double.infinity;
  //   double maxY = double.negativeInfinity;
  //
  //   // if (minY == double.infinity || maxY == double.negativeInfinity) {
  //   //   minY = 0;
  //   //   maxY = double.negativeInfinity;
  //   // }
  //
  //   for (var series in funChartData) {
  //     for (var data in series) {
  //       final value = data.scheme_rolling_returns?.toDouble() ?? 0;
  //       minY = min(minY, value);
  //       maxY = max(maxY, value);
  //     }
  //   }
  //
  //   // Add some padding to min/max values
  //   final yPadding = (maxY - minY) * 0.1;
  //   minY -= yPadding;
  //   maxY += yPadding;
  //
  //   return Container(
  //     height: 300,
  //     padding: EdgeInsets.all(16),
  //     child: LineChart(
  //       LineChartData(
  //         minY: minY,
  //         maxY: maxY,
  //         clipData: FlClipData.all(),
  //         gridData: FlGridData(
  //           show: true,
  //           drawVerticalLine: false,
  //           horizontalInterval: 5,
  //           getDrawingHorizontalLine: (value) {
  //             return FlLine(
  //               color: Colors.grey.withOpacity(0.2),
  //               strokeWidth: 1,
  //             );
  //           },
  //         ),
  //         titlesData: FlTitlesData(
  //           rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //           topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //           leftTitles: AxisTitles(
  //             sideTitles: SideTitles(
  //               showTitles: true,
  //               reservedSize: 40,
  //               interval: ((maxY - minY) / 4).roundToDouble(),
  //               getTitlesWidget: (value, meta) {
  //                 return Text(
  //                   '${value.toInt()}%',
  //                   style: TextStyle(fontSize: 10),
  //                 );
  //               },
  //             ),
  //           ),
  //           bottomTitles: AxisTitles(
  //             sideTitles: SideTitles(
  //               showTitles: true,
  //               interval: max((funChartData[0].length / 10).floor().toDouble(), 1),
  //               getTitlesWidget: (value, meta) {
  //                 if (value.toInt() >= funChartData[0].length)
  //                   return const SizedBox.shrink();
  //
  //                 final dataPoint = funChartData[0][value.toInt()];
  //                 final navDate = dataPoint.nav_date?.split('\n')[0] ?? '';
  //                 final schemeForwardDateRaw =
  //                     dataPoint.scheme_forward_date ?? '';
  //                 String formattedNavDate = navDate.replaceAll('-', '');
  //                 String formattedSchemeDate = '';
  //                 try {
  //                   DateTime parsedSchemeDate =
  //                       DateTime.parse(schemeForwardDateRaw);
  //                   formattedSchemeDate =
  //                       DateFormat('MMM yyyy').format(parsedSchemeDate);
  //                 } catch (e) {
  //                   print("Date parsing error: $e");
  //                   formattedSchemeDate = schemeForwardDateRaw;
  //                 }
  //                 return Padding(
  //                   padding: const EdgeInsets.only(top: 4.0),
  //                   child: SizedBox(
  //                     width: 40,
  //                     child: Transform.rotate(
  //                       angle: -1.55,
  //                       child: FittedBox(
  //                         fit: BoxFit.scaleDown,
  //                         child: Column(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             Text(formattedNavDate,
  //                                 style: const TextStyle(
  //                                     fontSize: 16,
  //                                     fontWeight: FontWeight.bold)),
  //                             Text(
  //                               formattedSchemeDate,
  //                               style: const TextStyle(
  //                                   fontSize: 16, fontWeight: FontWeight.bold),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //         ),
  //         borderData: FlBorderData(show: false),
  //         lineBarsData: [
  //           LineChartBarData(
  //             spots: funChartData[0].asMap().entries.map((entry) {
  //               return FlSpot(entry.key.toDouble(),
  //                   entry.value.scheme_rolling_returns?.toDouble() ?? 0);
  //             }).toList(),
  //             isCurved: true,
  //             color: Config.appTheme.defaultProfit,
  //             barWidth: 1.5,
  //             isStrokeCapRound: true,
  //             dotData: FlDotData(show: false),
  //             belowBarData: BarAreaData(
  //               show: true,
  //               gradient: LinearGradient(
  //                 colors: [
  //                   Config.appTheme.defaultProfit.withOpacity(0.3),
  //                   Config.appTheme.defaultProfit.withOpacity(0.0),
  //                 ],
  //                 begin: Alignment.topCenter,
  //                 end: Alignment.bottomCenter,
  //               ),
  //             ),
  //           ),
  //           if (funChartData.length > 1)
  //             LineChartBarData(
  //               spots: funChartData[1].asMap().entries.map((entry) {
  //                 return FlSpot(entry.key.toDouble(),
  //                     entry.value.scheme_rolling_returns?.toDouble() ?? 0);
  //               }).toList(),
  //               isCurved: true,
  //               color: Config.appTheme.themeColor,
  //               barWidth: 1.5,
  //               isStrokeCapRound: true,
  //               dotData: FlDotData(show: false),
  //               belowBarData: BarAreaData(
  //                 show: true,
  //                 gradient: LinearGradient(
  //                   colors: [
  //                     Config.appTheme.themeColor.withOpacity(0.3),
  //                     Config.appTheme.themeColor.withOpacity(0.0),
  //                   ],
  //                   begin: Alignment.topCenter,
  //                   end: Alignment.bottomCenter,
  //                 ),
  //               ),
  //             ),
  //         ],
  //         lineTouchData: LineTouchData(
  //           touchCallback:
  //               (FlTouchEvent event, LineTouchResponse? touchResponse) {
  //             if (event is FlTapUpEvent || event is FlPanUpdateEvent) {
  //               if (touchResponse != null &&
  //                   touchResponse.lineBarSpots != null) {
  //                 for (var touchedSpot in touchResponse.lineBarSpots!) {
  //                   final int barIndex = touchedSpot.barIndex;
  //                   final int dataIndex = touchedSpot.x.toInt();
  //                   if (barIndex < funChartData.length &&
  //                       dataIndex < funChartData[barIndex].length) {
  //                     final data = funChartData[barIndex][dataIndex];
  //                     tooltipDateNotifier.value = data.dateFormatNav ?? '';
  //                     if (barIndex == 0) {
  //                       tooltipFundNotifier.value =
  //                           touchedSpot.y.toStringAsFixed(2);
  //                     } else if (barIndex == 1) {
  //                       tooltipValueBenchMarkNotifier.value =
  //                           touchedSpot.y.toStringAsFixed(2);
  //                     }
  //                   }
  //                 }
  //               }
  //             }
  //           },
  //           handleBuiltInTouches: true,
  //           getTouchLineStart: (barData, index) => double.infinity,
  //           getTouchLineEnd: (barData, index) => 0,
  //           touchTooltipData: LineTouchTooltipData(
  //             tooltipBgColor: Colors.white,
  //             tooltipBorder: BorderSide(color: Colors.grey.withOpacity(0.2)),
  //             tooltipRoundedRadius: 8,
  //             getTooltipItems: (List<LineBarSpot> touchedSpots) {
  //               return touchedSpots.map((spot) {
  //                 final data = funChartData[spot.barIndex][spot.x.toInt()];
  //                 final isFund = spot.barIndex == 0;
  //
  //                 // Define names and colors for Fund & Benchmark
  //                 final String label = isFund ? 'Fund' : 'Benchmark';
  //                 final Color labelColor = isFund
  //                     ? Config.appTheme.defaultProfit
  //                     : Config.appTheme.themeColor;
  //                 final Color valueColor =
  //                     labelColor; // Use same color for value
  //
  //                 return LineTooltipItem(
  //                   '${data.dateFormatNav ?? ''}\n', // Display Date
  //                   const TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 12,
  //                       fontWeight: FontWeight.bold),
  //                   children: [
  //                     TextSpan(
  //                       text: '$label: ',
  //                       style: TextStyle(
  //                         color: labelColor,
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     TextSpan(
  //                       text: '${spot.y.toStringAsFixed(2)}%',
  //                       style: TextStyle(
  //                         color: valueColor, // Color-coded value
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ],
  //                 );
  //               }).toList();
  //             },
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget rpChart({required List<List<ChartData>> funChartData}) {
    // Handle empty data case
    if (funChartData.isEmpty) {
      return Container(
        height: 300,
        padding: EdgeInsets.all(16),
        child: Center(child: Text("No chart data available")),
      );
    }

    // Calculate min and max values for Y axis across ALL series
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    for (var series in funChartData) {
      if (series.isEmpty) continue; // Skip empty series

      for (var data in series) {
        final value = data.scheme_rolling_returns?.toDouble() ?? 0;
        minY = min(minY, value);
        maxY = max(maxY, value);
      }
    }

    // Handle case where all values are zero or no valid data
    if (minY == double.infinity || maxY == double.negativeInfinity) {
      minY = 0;
      maxY = 1;
    }

    // Ensure we have some visible range
    if (minY == maxY) {
      minY -= 1;
      maxY += 1;
    }

    // Add padding that works for both series
    final yRange = maxY - minY;
    final yPadding = yRange > 0
        ? yRange * 0.1
        : 1; // At least 1 unit padding if all values same
    minY -= yPadding;
    maxY += yPadding;

    // Calculate bottom titles interval - ensure it's never zero
    final dataLength = funChartData[0].length;
    final bottomInterval = max((dataLength / 10).floorToDouble(), 1);

    return Container(
        height: 300,
        padding: EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            minY: minY,
            maxY: maxY,
            clipData: FlClipData.none(),
            // Changed from .all() to prevent clipping
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: max((maxY - minY) / 5, 0.1),
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.withOpacity(0.2),
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: max((maxY - minY) / 4, 0.1),
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toStringAsFixed(1)}%', // More precise display
                      style: TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: max((dataLength / 10).floorToDouble(), 1),
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= funChartData[0].length) {
                      return const SizedBox.shrink();
                    }

                    final dataPoint = funChartData[0][value.toInt()];
                    final navDate = dataPoint.nav_date ?? '';
                    return Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Transform.rotate(
                        angle: -1.55,
                        child: Text(
                          navDate,
                          style: TextStyle(fontSize: 8, color: Colors.black),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: funChartData.asMap().entries.map((entry) {
              final index = entry.key;
              final series = entry.value;

              return LineChartBarData(
                spots: series.asMap().entries.map((spotEntry) {
                  return FlSpot(
                    spotEntry.key.toDouble(),
                    spotEntry.value.scheme_rolling_returns?.toDouble() ?? 0,
                  );
                }).toList(),
                isCurved: true,
                color: index == 0
                    ? Config.appTheme.defaultProfit
                    : Config.appTheme.themeColor,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: index == 0,
                  // Only show area for first series if desired
                  gradient: LinearGradient(
                    colors: [
                      (index == 0
                              ? Config.appTheme.defaultProfit
                              : Config.appTheme.themeColor)
                          .withOpacity(0.3),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              );
            }).toList(),
            lineTouchData: LineTouchData(
              touchCallback:
                  (FlTouchEvent event, LineTouchResponse? touchResponse) {
                if (event is FlTapUpEvent || event is FlPanUpdateEvent) {
                  if (touchResponse != null &&
                      touchResponse.lineBarSpots != null) {
                    for (var touchedSpot in touchResponse.lineBarSpots!) {
                      final int barIndex = touchedSpot.barIndex;
                      final int dataIndex = touchedSpot.x.toInt();
                      if (barIndex < funChartData.length &&
                          dataIndex < funChartData[barIndex].length) {
                        final data = funChartData[barIndex][dataIndex];
                        tooltipDateNotifier.value = data.nav_date ?? '';
                        if (barIndex == 0) {
                          tooltipFundNotifier.value = touchedSpot.y.toStringAsFixed(2);
                        } else if (barIndex == 1) {
                          tooltipValueBenchMarkNotifier.value =
                              touchedSpot.y.toStringAsFixed(2);
                        }
                      }
                    }
                  }
                }
              },
              handleBuiltInTouches: true,
              getTouchLineStart: (barData, index) => double.infinity,
              getTouchLineEnd: (barData, index) => 0,
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.white,
                tooltipBorder: BorderSide(color: Colors.grey.withOpacity(0.2)),
                tooltipRoundedRadius: 8,
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  return touchedSpots.map((spot) {
                    final data = funChartData[spot.barIndex][spot.x.toInt()];
                    final isFund = spot.barIndex == 0;

                    // Define names and colors for Fund & Benchmark
                    final String label = isFund ? 'Fund' : 'Benchmark';
                    final Color labelColor = isFund
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.themeColor;
                    final Color valueColor =
                        labelColor; // Use same color for value


                    return LineTooltipItem(
                        spot.barIndex == 0 ? '${data.dateFormatNav ?? ''}\n' : '', // Display Date
                      const TextStyle(
                          color: Colors.black,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: '$label: ',
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '${spot.y.toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: valueColor, // Color-coded value
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ));
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
    if (isInvalidDate) {
      return NoData();
    }

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
              ? (originalRollingReturnBenchmarkList.isEmpty ||
                      rollingReturnsTable.isEmpty ||
                      isInvalidDate)
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
                        //blackBoxStatistics(chartRollingReturnBenchmarkList),
                      ],
                    )
              : (rollingReturnBenchmarkList.isEmpty ||
                      rollingReturnsTable.isEmpty ||
                      isInvalidDate)
                  ? NoData()
                  : Column(
                      children: [
                        ListView.builder(
                          itemCount: rollingReturnBenchmarkList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Map data = rollingReturnBenchmarkList[index];
                            if (data['scheme_name'] != selectedSubCategory) {
                              return returnsDistributionCard(data);
                            }
                          },
                        ),
                        SizedBox(height: devHeight * 0.01),
                        // blackBoxDistribution(),
                      ],
                    ),
         /* Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text(
                  "Rolling Return vs Benchmark",
                  style: AppFonts.f50014Grey,
                ),
              ),
              SizedBox(height: 16),
              isLoading
                  ? Utils.shimmerWidget(
                      230,
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    )
                  : (chartRollingReturnBenchmarkList.isEmpty ||
                          rollingReturnsTable.isEmpty)
                      ? NoData()
                      : chartArea(schemeData, benchMarkData)
            ],
          ),*/
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

  Widget blackBoxStatistics(List chartRollingReturnBenchmarkList) {
    var firstItem = chartRollingReturnBenchmarkList[0][0];

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
                  child: Text(firstItem['scheme_amfi_short_name'] ?? '',
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
                value: "${minimum.toStringAsFixed(2)}",
                titleStyle: AppFonts.f40013.copyWith(
                    color: Config.appTheme.placeHolderInputTitleAndArrow),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                  title: "Max",
                  value: "${maximum.toStringAsFixed(2)}",
                  titleStyle: AppFonts.f40013.copyWith(
                      color: Config.appTheme.placeHolderInputTitleAndArrow),
                  valueStyle:
                      AppFonts.f50014Black.copyWith(color: Colors.white),
                  alignment: CrossAxisAlignment.center),
              ColumnText(
                  title: "Average",
                  value: "${average.toStringAsFixed(2)}",
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
                  child: Obx(() => Text(controller.selectedFund.value,
                      style:
                          AppFonts.f50014Black.copyWith(color: Colors.white)))),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Less than 0%",
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
                            itemCount: rollingPeriodList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  controller.selectedRollingPeriod.value =
                                      rollingPeriodList[index];
                                  updateStartDate();
                                  Get.back();
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: controller
                                          .selectedRollingPeriod.value,
                                      value: rollingPeriodList[index],
                                      onChanged: (val) async {
                                        Get.back();
                                        controller.selectedRollingPeriod.value =
                                            rollingPeriodList[index];
                                        updateStartDate();
                                      },
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          rollingPeriodList[index],
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

  showSchemeBottomSheet(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    List filteredSchemes = List.from(schemeNameList);

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
                      "  Select Scheme",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
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
                      prefixIcon: Icon(Icons.search, color: Colors.white),
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
                      bottomState(() {
                        filteredSchemes = schemeNameList
                            .where((scheme) => scheme
                                .toString()
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredSchemes.length,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(filteredSchemes[index]),
                        value: schemeNameList.indexOf(filteredSchemes[index]),
                        groupValue: selectedRadioIndex,
                        onChanged: (int? value) {
                          if (value != null) {
                            // Use the controller method to handle selection
                            controller.selectScheme(
                                filteredSchemes[index], value);
                            Navigator.of(context).pop();
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

  Widget appBarColumn(String title, String value, Widget suffix, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14)),
        Container(
          width: width,
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
                  data["logo"] == "https://api.mymfbox.com/images/amc/empty.png"
                      ? Container(
                          margin: EdgeInsets.only(right:2),
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
                        )
                      : Image.network(data["logo"], height: 30),
                  SizedBox(width: 5),
                  SizedBox(
                      width: 200,
                      child: Text(data["scheme_name"],
                          style: AppFonts.f50014Black
                              .copyWith(color: Config.appTheme.themeColor))),
                  // Spacer(),
                  // Container(
                  //   padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  //   decoration: BoxDecoration(
                  //       color: Color(0xffEDFFFF),
                  //       borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(10),
                  //         bottomLeft: Radius.circular(10),
                  //       )),
                  //   child: Row(children: [
                  //     Text(data["scheme_rating"],
                  //         style: TextStyle(color: Config.appTheme.themeColor)),
                  //     Icon(Icons.star, color: Config.appTheme.themeColor)
                  //   ]),
                  // )
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
                          title: "Average",
                          value: data['average'] != null
                              ? "${data['average'].toStringAsFixed(2)}"
                              : "0.00",
                          alignment: CrossAxisAlignment.start),
                      ColumnText(
                          title: "Median",
                          value: data['median'] != null
                              ? "${data['median'].toStringAsFixed(2)}"
                              : "0.00"),
                      ColumnText(
                          title: "Max",
                          value: data['maximum'] != null
                              ? "${data['maximum'].toStringAsFixed(2)}"
                              : "0.00",
                          alignment: CrossAxisAlignment.center),
                      ColumnText(
                        title: "Min",
                        value: data['minimum'] != null
                            ? "${data['minimum'].toStringAsFixed(2)}"
                            : "0.00",
                      ),
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
                  data["logo"] == "https://api.mymfbox.com/images/amc/empty.png"
                      ? Container(
                          margin: EdgeInsets.only(right: 2),
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
                        )
                      : Image.network(data["logo"], height: 30),
                  SizedBox(width: 10),
                  Expanded(
                      child: Text(data["scheme_name"],
                          style: AppFonts.f50014Black
                              .copyWith(color: Config.appTheme.themeColor))),
                  // Spacer(),
                  // Container(
                  //   padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  //   decoration: BoxDecoration(
                  //       color: Color(0xffEDFFFF),
                  //       borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(10),
                  //         bottomLeft: Radius.circular(10),
                  //       )),
                  //   child: Row(children: [
                  //     Text(data["scheme_rating"],
                  //         style: TextStyle(color: Config.appTheme.themeColor)),
                  //     Icon(Icons.star, color: Config.appTheme.themeColor)
                  //   ]),
                  // )
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
                        title: "Less than 0%",
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
                          title: "8-12%",
                          value: data['less_than_10'] != null
                              ? "${data['less_than_10'].toStringAsFixed(2)}"
                              : "0.00",
                          valueStyle:
                              AppFonts.f50012.copyWith(color: Colors.black),
                          alignment: CrossAxisAlignment.center),
                      /*ColumnText(
                          title: "10-12%",
                          value: data['between_10_12'] != null
                              ? "${data['between_10_12'].toStringAsFixed(2)}"
                              : "0.00",
                          valueStyle:
                              AppFonts.f50012.copyWith(color: Colors.black),
                          alignment: CrossAxisAlignment.center),*/
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
    return Column(children: [
      // Enable horizontal scrolling
      SizedBox(
        width: MediaQuery.of(context)
            .size
            .width, // Set the width to match the screen width
        height: 400,
        child: LineChart(
          LineChartData(
            // minX: 0,
            minX: startingPoint,
            // Set the starting point for x-axis
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
                  color: Config.appTheme.themeColor
                      .withOpacity(0.09), // Adjust opacity and color as needed
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
                  color: Config.appTheme.themeColorDark
                      .withOpacity(0.09), // Adjust opacity and color as needed
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
    ]);
  }

  DateTime getStartDatePastLimit() {
    DateTime now = DateTime.now();
    DateTime pastDate = DateTime.now();
    dev.log(controller.selectedRollingPeriod.value);
    switch (controller.selectedRollingPeriod.value) {
      case '1 Month':
        pastDate = DateTime(
          now.year,
          now.month - 1,
          now.day - 7,
          now.hour,
          now.minute,
          now.second,
        );
      case '1 Year':
        pastDate = DateTime(
          now.year - 1,
          now.month,
          now.day - 7,
          now.hour,
          now.minute,
          now.second,
        );
      case '2 Year':
        pastDate = DateTime(
          now.year - 2,
          now.month,
          now.day - 7,
          now.hour,
          now.minute,
          now.second,
        );
      case '3 Year':
        pastDate = DateTime(
          now.year - 3,
          now.month,
          now.day - 7,
          now.hour,
          now.minute,
          now.second,
        );

      case '5 Year':
        pastDate = DateTime(
          now.year - 5,
          now.month,
          now.day - 8,
          now.hour,
          now.minute,
          now.second,
        );

      case '7 Year':
        pastDate = DateTime(
          now.year - 7,
          now.month,
          now.day - 7,
          now.hour,
          now.minute,
          now.second,
        );

      case '10 Year':
        pastDate = DateTime(
          now.year - 10,
          now.month,
          now.day - 10,
          now.hour,
          now.minute,
          now.second,
        );

      case '15 Year':
        pastDate = DateTime(
          now.year - 15,
          now.month,
          now.day - 7,
          now.hour,
          now.minute,
          now.second,
        );
    }
    return pastDate;
  }

  updateStartDate() {
    final pastDate = getStartDatePastLimit();
    try {
      if (convertStrToDt(controller.startDate.value).isAfter(pastDate)) {
        controller.startDate.value = convertDtToStr(pastDate.copyWith(
          day: pastDate.day - 7,
        ));
        print(controller.startDate.value);
      } else {
        controller.startDate.value = convertDtToStr(pastDate);
      }
    } catch (e) {
      print(e);
    }
  }

  void showDatePickerDialog(BuildContext context) async {
    final pastDate = getStartDatePastLimit();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: convertStrToDt(controller.startDate.value),
      firstDate: DateTime(1947),
      lastDate: pastDate,
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      startDateController.text = formattedDate;
      controller.startDate.value = formattedDate;
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

    String topNewNavDate = DateFormat('dd MMM yyyy').format(formatNavDate);
    String topNewForwardDate =
        DateFormat('dd MMM yyyy').format(formatForwardDate);

    dateFormatNav = "$topNewNavDate - $topNewForwardDate";

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

class RollingReturnsController extends GetxController {
  final selectedRadioIndex = RxInt(-1);
  var selectedFund = "ICICI Pru BlueChip Gr".obs;
  var scheme = "ICICI Pru BlueChip Gr".obs;
  var shouldRefresh = false.obs;

  var selectedRollingPeriod = "3 Year".obs;
  var startDate = "".obs;

  final _debouncer = Debouncer(milliseconds: 300);
  var isProcessingSelection = false.obs;

  @override
  void onInit() {
    super.onInit();
    final today = DateTime.now();
    final calculatedDate = DateTime(
      today.year - 4,
      today.month - 11,
      today.day - 1,
    );

    final formattedDate = DateFormat("dd-MM-yyyy").format(calculatedDate);
    startDate.value = formattedDate;
    shouldRefresh.value = true;
  }

  void selectScheme(String schemeName, int index) {
    if (isProcessingSelection.value) return;

    _debouncer.run(() {
      isProcessingSelection.value = true;
      selectedRadioIndex.value = index;
      selectedFund.value = schemeName;
      scheme.value = schemeName;
      isProcessingSelection.value = false;
      // Don't set shouldRefresh here
    });
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
