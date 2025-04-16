import 'dart:developer';
import 'dart:math' as math;
import 'dart:developer' as dev;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/api/ResearchApi.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import 'package:mymfbox2_0/rp_widgets/NoData.dart';

import '../RolllingReturnsBenchMark/RollingReturnsBenchmark.dart';

class RollingReturnsCategory extends StatefulWidget {
  const RollingReturnsCategory({super.key});

  @override
  State<RollingReturnsCategory> createState() => _RollingReturnsCategoryState();
}

class _RollingReturnsCategoryState extends State<RollingReturnsCategory> {
  final RollingReturnsController controller =
      Get.put(RollingReturnsController());

  late double devWidth, devHeight;
  List allCategories = [];
  int user_id = getUserId();
  String client_name = GetStorage().read("client_name") ?? '';

  TextEditingController startDateController = TextEditingController();

  // String startDate = "30-04-2020";

  String btnNo = "";

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

  List subCategoryList = [];
  List rollingReturnCategoryList = [];
  List originalRollingReturnCategoryList = [];
  List newRollingReturnCategoryList = [];
  List fundList = [];
  bool isLoading = true;

  String selectedInvType = "Return Statistics\n(%)";
  int? selectedIndex;

  String scheme = "";
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
    await getBroadCategoryList();
    await getCategoryList();
    await getTopLumpsumFunds();
    await getRollingReturnsVsCategory();
    await autoSuggestAllMfSchemesShortNames();
    // await getRollingReturnsVsBenchmark();
    isLoading = false;
    return 0;
  }

  Future getBroadCategoryList() async {
    if (allCategories.isNotEmpty) return 0;
    Map data =
        await Api.getBroadCategoryList(client_name: client_name, flag: 1);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    allCategories = data['list'];

    return 0;
  }

  List categoriesList = [];

  Future autoSuggestAllMfSchemesShortNames() async {
    if (categoriesList.isNotEmpty) return 0;
    Map data = await ResearchApi.autoSuggestAllMfSchemesShortNames(
      userId: user_id,
      category: controller.selectedSubCategory.value,
      clientName: client_name,
    );
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    categoriesList = data['list'];

    return 0;
  }

  Future getCategoryList() async {
    if (subCategoryList.isNotEmpty) return 0;

    Map data = await Api.getCategoryList(
      category: controller.selectedCategory.value,
      client_name: client_name,
    );
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    subCategoryList = data['list'];
    return 0;
  }

  Future getTopLumpsumFunds() async {
    if (fundList.isNotEmpty) return 0;
    Map data = await ResearchApi.getTopLumpsumFunds(
        amount: '',
        category: controller.selectedSubCategory.value,
        period: '',
        amc: "",
        client_name: client_name);
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

  Future getRollingReturnsVsCategory() async {
    if (rollingReturnCategoryList.isNotEmpty) return 0;

    Map data = await ResearchApi.getRollingReturnsVsCategory(
        schemes: controller.schemes.value,
        category: controller.selectedSubCategory.value,
        start_date: controller.startDate.value,
        period: controller.rollingPeriods.value,
        client_name: client_name);
    newRollingReturnCategoryList = data['rollingReturnsTable'];
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    originalRollingReturnCategoryList = data['rollingReturnsTable'];

    rollingReturnCategoryList = List.from(data['rollingReturnsTable']);

    rollingReturnCategoryList.removeWhere(
        (item) => item['scheme_name'] == controller.selectedSubCategory.value);

    for (int i = 0; i < newRollingReturnCategoryList.length; i++) {
      if (newRollingReturnCategoryList[i]['scheme_name'] ==
          controller.selectedSubCategory.value) {
        selectedIndex = i;
        break;
      }
    }
    if (originalRollingReturnCategoryList.isEmpty) {
      Utils.showError(context,
          "Choose a period lesser than ${controller.rollingPeriods.value} or change the start date to ${controller.rollingPeriods.value} Year back from now.");
      return;
    } else {
      if (newRollingReturnCategoryList.isNotEmpty) {
        var blackboxIndex = selectedIndex ?? 0;
        var item = newRollingReturnCategoryList[blackboxIndex];

        if (blackboxIndex >= 0) {
          scheme = item['scheme_name'];
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

      // if (data['list'] != null) {
      //   chartRollingReturnCategoryList = data['list'];
      // } else {
      //   chartRollingReturnCategoryList = [];
      // }
      //
      // if (data['list'] != null) {
      //   if (chartRollingReturnCategoryList.isNotEmpty &&
      //       chartRollingReturnCategoryList[0].isNotEmpty) {
      //     for (final monthList in chartRollingReturnCategoryList[0]) {
      //       String navDate = monthList['nav_date'];
      //       String forwardDate = monthList['scheme_forward_date'];
      //
      //       DateTime formatNavDate = DateTime.parse(navDate);
      //       DateTime formatForwardDate = DateTime.parse(forwardDate);
      //
      //       String newNavDate = DateFormat('MMM yyyy').format(formatNavDate);
      //       String newForwardDate =
      //           DateFormat('MMM yyyy').format(formatForwardDate);
      //       String finalDate = "$newNavDate -\n$newForwardDate";
      //       months.add(finalDate);
      //     }
      //
      //     multipleSeriesData = [];
      //     schemeData = [];
      //     categoryData = [];
      //     if (chartRollingReturnCategoryList.isNotEmpty &&
      //         chartRollingReturnCategoryList[0] != null) {
      //       List list = chartRollingReturnCategoryList[0];
      //       for (var element in list) {
      //         schemeData.add(ChartData.fromJson(element));
      //       }
      //       if (schemeData.isNotEmpty) {
      //         tooltipDateNotifier.value = schemeData[0].dateFormatNav ?? '';
      //         tooltipFundNotifier.value =
      //             schemeData[0].scheme_rolling_returns?.toStringAsFixed(2) ??
      //                 '0.00';
      //       }
      //     }
      //
      //     try {
      //       if (chartRollingReturnCategoryList.length > 1 &&
      //           chartRollingReturnCategoryList[1] != null) {
      //         List list = chartRollingReturnCategoryList[1];
      //         print(list);
      //         for (var element in list) {
      //           categoryData.add(ChartData.fromJson(element));
      //         }
      //         if (categoryData.isNotEmpty) {
      //           tooltipDateNotifier.value = categoryData[0].dateFormatNav ?? '';
      //           tooltipValueBenchMarkNotifier.value = categoryData[0]
      //                   .scheme_rolling_returns
      //                   ?.toStringAsFixed(2) ??
      //               '0.00';
      //         }
      //       }
      //     } catch (e) {
      //       print(e);
      //     }
      //   }
      // }
    }
    return 0;
  }

  List chartRollingReturnCategoryList = [];

  final List<String> months = [];
  List<ChartData> schemeData = [];
  List<ChartData> categoryData = [];

  String schemeStartDate = '';

  Future getSchemeInceptionAndLatestNavDate(String formattedDate) async {
    if (schemeStartDate.isNotEmpty) return 0;
    Map data = await ResearchApi.getSchemeInceptionAndLatestNavDate(
        scheme_name: controller.schemes.value,
        start_date: formattedDate,
        clientName: client_name);
    schemeStartDate = data['scheme_start_date'];
    return;
  }

  @override
  void initState() {
    super.initState();
    btnNo = "1";
    startDateController.text = controller.startDate.value;
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
                        "Rolling Return vs Category",
                        style: AppFonts.f50014Black
                            .copyWith(fontSize: 18, color: Colors.white),
                      ),
                      //Spacer(),
                      //MfAboutIcon(context: context),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          showCategoryBottomSheet();
                        },
                        child: Obx(() => appBarColumn(
                            "Category",
                            getFirst13(controller.selectedSubCategory.value),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor))),
                      ),
                      GestureDetector(
                        onTap: () {
                          showSchemeBottomSheet();
                        },
                        child: Obx(() => appBarColumn(
                            "Select Up To 5 Funds",
                            getFirst16(controller.selectedFund.value),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor))),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            showRollingPeriodBottomSheet();
                          },
                          child: Obx(
                            () => appBarColumn(
                                "Rolling Period",
                                getFirst13(
                                    controller.selectedRollingPeriod.value),
                                Icon(Icons.keyboard_arrow_down,
                                    color: Config.appTheme.themeColor)),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () {
                            showDatePickerDialog(context);
                          },
                          child: Obx(
                            () => appBarColumn(
                                "Start Date",
                                getFirst13(controller.startDate.value),
                                Icon(Icons.keyboard_arrow_down,
                                    color: Config.appTheme.themeColor)),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          try {
                            EasyLoading.show();
                            DateTime startDate =
                                convertStrToDt(controller.startDate.value);
                            DateTime todayDate = DateTime.now();
                            // convertStrToDt(DateTime.now().toString());
                            DateTime schemeStart =
                                convertStrToDt(schemeStartDate);
                            getSchemeInceptionAndLatestNavDate(
                                controller.startDate.value);

                            if (controller.schemes.value.isEmpty) {
                              Utils.showError(context,
                                  "Please select a scheme to proceed.");
                              return;
                            }
                            getRollingPeriodDate(
                                controller.rollingPeriods.value, todayDate);

                            if (startDate.isBefore(schemeStart)) {
                              String formattedSchemeDate =
                                  DateFormat('dd-MM-yyyy').format(schemeStart);
                              if (context.mounted) {
                                Utils.showError(
                                    context,
                                    ' ${controller.schemes.value} inception date is $formattedSchemeDate. '
                                    'Please select a start date greater than or equal to the scheme inception date.');
                              }
                              return;
                            }

                            fundList = [];
                            rollingReturnCategoryList = [];
                            // await getCategoryList();
                            // await getTopLumpsumFunds();
                            setState(() {});
                            EasyLoading.dismiss();
                          } catch (e) {
                            EasyLoading.dismiss();
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 22),
                          padding:
                              EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text("Submit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
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

  DateTime getRollingPeriodDate(String period, DateTime todayDate) {
    switch (period) {
      case "1 Month":
        return DateTime(todayDate.year, todayDate.month - 1, todayDate.day)
            .subtract(Duration(days: 7));
      case "1 Year":
        return DateTime(todayDate.year - 1, todayDate.month, todayDate.day)
            .subtract(Duration(days: 7));
      case "2 Year":
        return DateTime(todayDate.year - 2, todayDate.month, todayDate.day)
            .subtract(Duration(days: 7));
      case "3 Year":
        return DateTime(todayDate.year - 3, todayDate.month, todayDate.day)
            .subtract(Duration(days: 7));
      case "5 Year":
        return DateTime(todayDate.year - 5, todayDate.month, todayDate.day)
            .subtract(Duration(days: 7));
      case "7 Year":
        return DateTime(todayDate.year - 7, todayDate.month, todayDate.day)
            .subtract(Duration(days: 7));
      case "10 Year":
        return DateTime(todayDate.year - 10, todayDate.month, todayDate.day)
            .subtract(Duration(days: 7));
      case "15 Year":
        return DateTime(todayDate.year - 15, todayDate.month, todayDate.day)
            .subtract(Duration(days: 7));
      default:
        return todayDate;
    }
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
                  ? Utils.shimmerWidget(devHeight,
                      margin: EdgeInsets.all(20))
                  : (originalRollingReturnCategoryList.isEmpty)
                      ? NoData()
                      : Column(
                          children: [
                            ListView.builder(
                              itemCount: rollingReturnCategoryList.length,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                Map data = rollingReturnCategoryList[index];

                                // if (data['scheme_name'] !=
                                //     selectedSubCategory) {
                                return returnsStaticsCard(data);
                                // }
                              },
                            ),
                            SizedBox(height: devHeight * 0.01),
                            blackBoxStatistics(),
                          ],
                        ))
              : (isLoading
                  ? Utils.shimmerWidget(devHeight,
                      margin: EdgeInsets.all(20))
                  : (rollingReturnCategoryList.isEmpty)
                      ? NoData()
                      : Column(
                          children: [
                            ListView.builder(
                              itemCount: rollingReturnCategoryList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                Map data = rollingReturnCategoryList[index];
                                if (data['scheme_name'] !=
                                    controller.selectedSubCategory.value) {
                                  return returnsDistributionCard(data);
                                }
                              },
                            ),
                            SizedBox(height: devHeight * 0.01),
                            blackBoxDistribution(),
                          ],
                        )),
          SizedBox(height: 20),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Padding(
          //       padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          //       child: Text(
          //         "Rolling Return Timeline",
          //         style: AppFonts.f50014Grey,
          //       ),
          //     ),
          //     SizedBox(height: 16),
          //     isLoading
          //         ? Utils.shimmerWidget(
          //             230,
          //             margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          //           )
          //         : (rollingReturnCategoryList.isEmpty
          //             // ||
          //             //         rollingReturnsTable.isEmpty
          //             )
          //             ? NoData()
          //             : chartArea(schemeData, categoryData)
          //   ],
          // ),
        ],
      ),
    );
  }

  var multipleSeriesData = <List<ChartData>>[];

  Widget chartArea(List<ChartData> schemeData, List<ChartData> benchMarkData) {
    // List<ChartData> legends = getChartLegends(schemeData);

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

  Widget rpChart({required List<List<ChartData>> funChartData}) {
    // Calculate min and max values for Y axis
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    // if (minY == double.infinity || maxY == double.negativeInfinity) {
    //   minY = 0;
    //   maxY = double.negativeInfinity;
    // }

    // final tempList = [
    //   ChartData(
    //     scheme_rolling_returns: 10,
    //   ),
    // ];
    //
    for (var series in funChartData) {
      for (var data in series) {
        final value = data.scheme_rolling_returns?.toDouble() ?? 0;
        minY = math.min(minY, value);
        maxY = math.max(maxY, value);
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
                    '${value.toInt()}%',
                    style: TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (funChartData[0].length / 10).floor().toDouble(),
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= funChartData[0].length)
                    return const SizedBox.shrink();

                  final dataPoint = funChartData[0][value.toInt()];
                  final navDate = dataPoint.nav_date?.split('\n')[0] ?? '';
                  final schemeForwardDateRaw =
                      dataPoint.scheme_forward_date ?? '';
                  String formattedNavDate = navDate.replaceAll('-', '');
                  String formattedSchemeDate = '';
                  try {
                    DateTime parsedSchemeDate =
                        DateTime.parse(schemeForwardDateRaw);
                    formattedSchemeDate =
                        DateFormat('MMM yyyy').format(parsedSchemeDate);
                  } catch (e) {
                    print("Date parsing error: $e");
                    formattedSchemeDate = schemeForwardDateRaw;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: SizedBox(
                      width: 40,
                      child: Transform.rotate(
                        angle: -1.55,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(formattedNavDate,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                formattedSchemeDate,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
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
              barWidth: 1.5,
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
                barWidth: 1.5,
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
                      tooltipDateNotifier.value = data.dateFormatNav ?? '';
                      if (barIndex == 0) {
                        tooltipFundNotifier.value =
                            touchedSpot.y.toStringAsFixed(2);
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
                    '${data.dateFormatNav ?? ''}\n', // Display Date
                    const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
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
      ),
    );
  }

  ValueNotifier<String> tooltipDateNotifier = ValueNotifier<String>("");
  ValueNotifier<String> tooltipFundNotifier = ValueNotifier<String>("");
  ValueNotifier<String> tooltipValueBenchMarkNotifier =
      ValueNotifier<String>("");

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

  String getFirst13(String text) {
    String s = text.split(":").last;
    if (s.length > 13) s = s.substring(0, 13);
    return s;
  }

  String getFirst16(String text) {
    String s = text.split(":").last;
    if (s.length > 16) s = s.substring(0, 16);
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
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
              Expanded(
                  child: Text(scheme,
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(6),
                margin: EdgeInsets.only(right: 10),
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
              Expanded(
                  child: Text(scheme,
                      style:
                          AppFonts.f50014Black.copyWith(color: Colors.white))),
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
              height: devHeight * 0.64,
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
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  Get.back();
                                  controller.selectedRollingPeriod.value =
                                      rollingPeriod[index];
                                  DateTime todayDate = DateTime.now();

                                  if (rollingPeriod[index] == "1 Month") {
                                    controller.rollingPeriods.value = "1 Month";
                                    DateTime oneMonthBeforeDate = DateTime(
                                        todayDate.year,
                                        todayDate.month - 1,
                                        todayDate.day - 7);
                                    controller.startDate.value =
                                        convertDtToStr(oneMonthBeforeDate);
                                  } else if (rollingPeriod[index] == "1 Year") {
                                    controller.rollingPeriods.value = "1 Year";
                                    DateTime oneMonthBeforeDate = DateTime(
                                        todayDate.year - 1,
                                        todayDate.month,
                                        todayDate.day - 7);
                                    controller.startDate.value =
                                        convertDtToStr(oneMonthBeforeDate);
                                  } else if (rollingPeriod[index] == "2 Years") {
                                    controller.rollingPeriods.value = "2 Year";
                                    DateTime oneMonthBeforeDate = DateTime(
                                        todayDate.year - 2,
                                        todayDate.month,
                                        todayDate.day - 7);
                                    controller.startDate.value =
                                        convertDtToStr(oneMonthBeforeDate);
                                  } else if (rollingPeriod[index] == "3 Years") {
                                    controller.rollingPeriods.value = "3 Year";
                                    DateTime oneMonthBeforeDate = DateTime(
                                        todayDate.year - 3,
                                        todayDate.month,
                                        todayDate.day - 7);
                                    controller.startDate.value =
                                        convertDtToStr(oneMonthBeforeDate);
                                  } else if (rollingPeriod[index] == "5 Years") {
                                    controller.rollingPeriods.value = "5 Year";
                                    DateTime oneMonthBeforeDate = DateTime(
                                        todayDate.year - 5,
                                        todayDate.month,
                                        todayDate.day - 8);
                                    controller.startDate.value =
                                        convertDtToStr(oneMonthBeforeDate);
                                  } else if (rollingPeriod[index] == "7 Years") {
                                    controller.rollingPeriods.value = "7 Year";
                                    DateTime oneMonthBeforeDate = DateTime(
                                        todayDate.year - 7,
                                        todayDate.month,
                                        todayDate.day - 7);
                                    controller.startDate.value =
                                        convertDtToStr(oneMonthBeforeDate);
                                  } else if (rollingPeriod[index] ==
                                      "10 Year") {
                                    controller.rollingPeriods.value = "10 Years";
                                    DateTime oneMonthBeforeDate = DateTime(
                                        todayDate.year - 10,
                                        todayDate.month,
                                        todayDate.day - 10);
                                    controller.startDate.value =
                                        convertDtToStr(oneMonthBeforeDate);
                                  } else if (rollingPeriod[index] ==
                                      "15 Year") {
                                    controller.rollingPeriods.value = "15 Years";
                                    DateTime oneMonthBeforeDate = DateTime(
                                        todayDate.year - 15,
                                        todayDate.month,
                                        todayDate.day - 7);
                                    controller.startDate.value =
                                        convertDtToStr(oneMonthBeforeDate);
                                  } else {
                                    controller.selectedRollingPeriod.value =
                                        rollingPeriod[index];
                                  }
                                  rollingReturnCategoryList = [];
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: controller
                                          .selectedRollingPeriod.value,
                                      value: rollingPeriod[index],
                                      onChanged: (val) async {
                                        Get.back();
                                        controller.selectedRollingPeriod.value =
                                            rollingPeriod[index];

                                        DateTime todayDate = DateTime.now();

                                        if (rollingPeriod[index] == "1 Month") {
                                          controller.rollingPeriods.value =
                                              "1 Month";
                                          DateTime oneMonthBeforeDate =
                                              DateTime(
                                                  todayDate.year,
                                                  todayDate.month - 1,
                                                  todayDate.day - 7);
                                          controller.startDate.value =
                                              convertDtToStr(
                                                  oneMonthBeforeDate);
                                        } else if (rollingPeriod[index] ==
                                            "1 Year") {
                                          controller.rollingPeriods.value =
                                              "1 Year";
                                          DateTime oneMonthBeforeDate =
                                              DateTime(
                                                  todayDate.year - 1,
                                                  todayDate.month,
                                                  todayDate.day - 7);
                                          controller.startDate.value =
                                              convertDtToStr(
                                                  oneMonthBeforeDate);
                                        } else if (rollingPeriod[index] ==
                                            "2 Years") {
                                          controller.rollingPeriods.value =
                                              "2 Year";
                                          DateTime oneMonthBeforeDate =
                                              DateTime(
                                                  todayDate.year - 2,
                                                  todayDate.month,
                                                  todayDate.day - 7);
                                          controller.startDate.value =
                                              convertDtToStr(
                                                  oneMonthBeforeDate);
                                        } else if (rollingPeriod[index] ==
                                            "3 Years") {
                                          controller.rollingPeriods.value =
                                              "3 Year";
                                          DateTime oneMonthBeforeDate =
                                              DateTime(
                                                  todayDate.year - 3,
                                                  todayDate.month,
                                                  todayDate.day - 7);
                                          controller.startDate.value =
                                              convertDtToStr(
                                                  oneMonthBeforeDate);
                                        } else if (rollingPeriod[index] ==
                                            "5 Years") {
                                          controller.rollingPeriods.value =
                                              "5 Year";
                                          DateTime oneMonthBeforeDate =
                                              DateTime(
                                                  todayDate.year - 5,
                                                  todayDate.month,
                                                  todayDate.day - 8);
                                          controller.startDate.value =
                                              convertDtToStr(
                                                  oneMonthBeforeDate);
                                        } else if (rollingPeriod[index] ==
                                            "7 Years") {
                                          controller.rollingPeriods.value =
                                              "7 Year";
                                          DateTime oneMonthBeforeDate =
                                              DateTime(
                                                  todayDate.year - 7,
                                                  todayDate.month,
                                                  todayDate.day - 7);
                                          controller.startDate.value =
                                              convertDtToStr(
                                                  oneMonthBeforeDate);
                                        } else if (rollingPeriod[index] ==
                                            "10 Years") {
                                          controller.rollingPeriods.value =
                                              "10 Year";
                                          DateTime oneMonthBeforeDate =
                                              DateTime(
                                                  todayDate.year - 10,
                                                  todayDate.month,
                                                  todayDate.day - 10);
                                          controller.startDate.value =
                                              convertDtToStr(
                                                  oneMonthBeforeDate);
                                        } else if (rollingPeriod[index] ==
                                            "15 Years") {
                                          controller.rollingPeriods.value =
                                              "15 Year";
                                          DateTime oneMonthBeforeDate =
                                              DateTime(
                                                  todayDate.year - 15,
                                                  todayDate.month,
                                                  todayDate.day - 7);
                                          controller.startDate.value =
                                              convertDtToStr(
                                                  oneMonthBeforeDate);
                                        } else {
                                          controller.selectedRollingPeriod
                                              .value = rollingPeriod[index];
                                        }
                                        rollingReturnCategoryList = [];
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

                      return (controller.selectedCategory.value == temp['name'])
                          ? selectedCategoryChip(
                              "${temp['name']}", "${temp['count']}")
                          : InkWell(
                              onTap: () async {
                                EasyLoading.show();
                                controller.selectedCategory.value =
                                    temp['name'];
                                subCategoryList = [];
                                await getCategoryList();
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
                          controller.selectedSubCategory.value =
                              subCategoryList[index];
                          categoriesList = [];
                          controller.schemes.value = '';
                          bottomState(() {});
                          EasyLoading.show();
                          controller.selectedFund.value = "1 Fund Selected";
                          await autoSuggestAllMfSchemesShortNames();
                          if (categoriesList.isNotEmpty) {
                            setState(() {
                              controller.schemes.value =
                                  categoriesList[0]['scheme_amfi'];
                              controller.selectedValues.value =
                                  categoriesList[0]['scheme_amfi'];
                            });
                          }
                          bottomState(() {});
                          EasyLoading.dismiss();

                          Get.back();
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Radio(
                                value: subCategoryList[index],
                                groupValue:
                                    controller.selectedSubCategory.value,
                                activeColor: Config.appTheme.themeColor,
                                onChanged: (val) async {
                                  EasyLoading.show();
                                  controller.selectedSubCategory.value =
                                      subCategoryList[index];
                                  categoriesList = [];
                                  controller.schemes.value = '';
                                  controller.selectedFund.value =
                                      "1 Fund Selected";
                                  bottomState(() {});
                                  await autoSuggestAllMfSchemesShortNames();
                                  if (categoriesList.isNotEmpty) {
                                    setState(() {
                                      controller.schemes.value =
                                          categoriesList[0]['scheme_amfi'];
                                      controller.selectedValues.value =
                                          categoriesList[0]['scheme_amfi'];
                                    });
                                  }
                                  Get.back();
                                  EasyLoading.dismiss();
                                  setState(() {});
                                }),
                            // Container(
                            //     height: 30,
                            //     width: 30,
                            //     decoration: BoxDecoration(
                            //         color: Color(0xffF8DFD5),
                            //         borderRadius: BorderRadius.circular(5)),
                            //     child: Icon(Icons.bar_chart,
                            //         color: Colors.red, size: 20)),
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
    List<bool> isSelectedList = List.filled(categoriesList.length, false);
    List<String> selectedSchemes = List.filled(categoriesList.length, '');

    TextEditingController searchController = TextEditingController();
    if (controller.selectedValues.value.isNotEmpty) {
      List<String> selectedItems = controller.selectedValues.value.split(',');
      for (int i = 0; i < categoriesList.length; i++) {
        if (selectedItems.contains(categoriesList[i]['scheme_amfi'])) {
          isSelectedList[i] = true;
          selectedSchemes[i] = categoriesList[i]['scheme_amfi'];
        }
      }
    }

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
          List<Map<String, dynamic>> selectedFundDetails = [];
          for (int i = 0; i < isSelectedList.length; i++) {
            if (isSelectedList[i]) {
              selectedFundDetails.add({
                'index': i,
                'scheme': categoriesList[i]['scheme_amfi_short_name'],
                'scheme_amfi': categoriesList[i]['scheme_amfi']
              });
            }
          }
          return Container(
            height: devHeight * 0.82,
            padding: EdgeInsets.all(7),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Select Schemes",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        EasyLoading.show();
                        List<String> selectedItems = [];

                        for (int i = 0; i < isSelectedList.length; i++) {
                          if (isSelectedList[i]) {
                            selectedItems.add(selectedSchemes[i]);
                          }
                        }

                        controller.selectedValues.value =
                            selectedItems.join(',');
                        controller.schemes.value =
                            controller.selectedValues.value;
                        controller.selectedFund.value =
                            "${selectedItems.length} Funds Selected";

                        Get.back();
                        EasyLoading.dismiss();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Config.appTheme.themeColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Apply'),
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
                if (selectedFundDetails.isNotEmpty) ...[
                  Column(
                    children: [
                      Container(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedFundDetails.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 8),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color:
                                    Config.appTheme.themeColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Config.appTheme.themeColor,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      selectedFundDetails[index]['scheme'],
                                      style: TextStyle(
                                        color: Config.appTheme.themeColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  InkWell(
                                    onTap: () {
                                      bottomState(() {
                                        int originalIndex =
                                            selectedFundDetails[index]['index'];
                                        isSelectedList[originalIndex] = false;
                                        selectedSchemes[originalIndex] = '';
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Config.appTheme.themeColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                ],
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    cursorColor: Colors.white,
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
                    itemCount: categoriesList.length,
                    itemBuilder: (context, index) {
                      if (searchController.text.isNotEmpty &&
                          !categoriesList[index]['scheme_amfi_short_name']
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase())) {
                        return SizedBox.shrink();
                      }
                      return CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                            categoriesList[index]['scheme_amfi_short_name']),
                        value: isSelectedList[index],
                        onChanged: (bool? value) {
                          bottomState(() {
                            if (value == true) {
                              if (isSelectedList
                                      .where((element) => element == true)
                                      .length <=
                                  4) {
                                isSelectedList[index] = value!;
                                selectedSchemes[index] =
                                    categoriesList[index]['scheme_amfi'];
                              } else {
                                isSelectedList[index] = false;
                                Utils.showError(
                                    context, "Maximum Five Funds Only Select");
                              }
                            } else {
                              isSelectedList[index] = value!;
                              selectedSchemes[index] = '';
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(data["logo"] ?? "", height: 30),
                  SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data["scheme_name"],
                          style: AppFonts.f50014Black
                              .copyWith(color: Config.appTheme.themeColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis, // Prevents overflow
                        ),
                        Row(
                          children: [
                            Text(
                              "Launch Date : ",
                              style: AppFonts.f40013.copyWith(fontSize: 12),
                              softWrap: true,
                            ),
                            Flexible(
                              child: Text(
                                data["scheme_inception_date"] ?? '',
                                style: AppFonts.f50014Grey.copyWith(
                                    color: Colors.black, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Expanded(
                  //     child: Text(data["scheme_name"],
                  //         style: AppFonts.f50014Black
                  //             .copyWith(color: Config.appTheme.themeColor))),
                  // Row(
                  //   children: [
                  //     Text('Launch Date: ',
                  //         style: AppFonts.f50014Black
                  //             .copyWith(color: Config.appTheme.themeColor)),
                  //     Text(data["scheme_name"],
                  //         style: AppFonts.f50014Black
                  //             .copyWith(color: Config.appTheme.themeColor)),
                  //   ],
                  // ),
                  /*Spacer(),
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
                  )*/
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
      EasyLoading.show();
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      startDateController.text = formattedDate;
      controller.startDate.value = formattedDate;
      // rollingReturnCategoryList = [];
      EasyLoading.dismiss();
    }
  }
}



class RollingReturnsController extends GetxController {


  var startDate = "".obs;
  final selectedRadioIndex = RxInt(-1);

  // var selectedFund = "ICICI Pru BlueChip Gr".obs;
  // var scheme = "ICICI Pru BlueChip Gr".obs;
  var shouldRefresh = false.obs;

  var selectedRollingPeriod = "3 Years".obs;

  var selectedCategory = "Equity Schemes".obs;
  var selectedSubCategory = "Equity: Flexi Cap".obs;
  var selectedFund = "1 Fund Selected".obs;

  // var selectedRollingPeriod = "3 Year";
  var rollingPeriods = "3 Year".obs;
  var schemes =
      "HDFC Flexi Cap Fund - Growth Plan".obs;
  var selectedValues =
      "HDFC Flexi Cap Fund - Growth Plan".obs;

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

  @override
  void onClose() {
    // selectedFundDetails.clear();
    // stpAmountController.dispose();
    super.onClose();
  }

  void selectScheme(String schemeName, int index) {
    if (isProcessingSelection.value) return;

    _debouncer.run(() {
      isProcessingSelection.value = true;
      selectedRadioIndex.value = index;
      selectedFund.value = schemeName;
      schemes.value = schemeName;
      isProcessingSelection.value = false;
      // Don't set shouldRefresh here
    });
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
