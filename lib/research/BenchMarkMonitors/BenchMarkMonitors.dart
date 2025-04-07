import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/ResearchApi.dart';
import 'package:mymfbox2_0/pojo/TopConsistentFundPojo.dart';
import 'package:mymfbox2_0/rp_widgets/SearchText.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../rp_widgets/NoData.dart';

class BenchMarkMonitors extends StatefulWidget {
  const BenchMarkMonitors({super.key});

  @override
  State<BenchMarkMonitors> createState() => _BenchMarkMonitorsState();
}

class _BenchMarkMonitorsState extends State<BenchMarkMonitors> {
  late double devWidth, devHeight;
  String client_name = GetStorage().read("client_name");
  List<ConsistentFundsPojo> topConsistentFundPojo = [];
  String selectedSort = "Returns";
  String selectedBenchMarkType = "All Benchmarks";
  String searchKey = "";
  Timer? searchOnStop;
  String monitorType = "All";
  List sortList = ["Returns", "A to Z"];

  Map periodMap = {
    0: "1W",
    1: "1M",
    2: "3M",
    3: "6M",
    4: "YTD",
    5: "1Y",
    6: "3Y",
    7: "5Y",
    8: "10Y",
    9: "Launch"
  };
  String period = "1W";
  String benchmark = "All";
  bool isLoading = true;

  List<dynamic> benchMarkMonitorsData = [];

  String amc = "3";
  List amcList = [];
  List selectedAmcList = [];

  String benchmarkMonitorType = "All";

  List<String> benchMarkType = [
    "All Benchmarks",
    "Nifty Benchmarks",
    "BSE Benchmarks",
  ];

  Future getDatas() async {
    isLoading = true;
    await getBenchmarkMonitors();
    isLoading = false;
    return 0;
  }

  Future getBenchmarkMonitors() async {
    if (benchMarkMonitorsData.isNotEmpty) return 0;
    Map data = await ResearchApi.getBenchmarkMonitors(
        benchmark: benchmarkMonitorType,
        period: period,
        client_name: client_name);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    benchMarkMonitorsData = data['list'];
    sortOptions();
    return 0;
  }


  void searchHandler(String search) async {
    searchKey = search;
    print("searchKey $searchKey");
    if (searchKey.isEmpty) {
      benchMarkMonitorsData = [];
      await getBenchmarkMonitors();
    } else {
      benchMarkMonitorsData = benchMarkMonitorsData.where((item) {
        return item['benchmark']
            .toString()
            .toLowerCase()
            .contains(searchKey.toLowerCase());
      }).toList();
    }
    setState(() {});
  }

  String newSearchKey = "";

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return DefaultTabController(
            length: 10,
            child: Scaffold(
              backgroundColor: Config.appTheme.mainBgColor,
              appBar: AppBar(
                backgroundColor: Config.appTheme.themeColor,
                leadingWidth: 0,
                toolbarHeight: 140,
                elevation: 1,
                leading: SizedBox(),
                title: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                        SizedBox(width: 5),
                        Text(
                          "Benchmark Monitors",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        //Spacer(),
                        //MfAboutIcon(context: context),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // GestureDetector(
                        //   onTap: () {
                        //     //  showBenchMarkMonitorBottomSheet();
                        //   },
                        //   child: appBarColumn(
                        //       "BenchMark",
                        //       getFirst13(selectedBenchMarkType),
                        //       Icon(Icons.keyboard_arrow_down,
                        //           color: Colors.white)),
                        // ),
                        // SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showSortFilter();
                              },
                              child: appBarColumn(
                                  "Sort By",
                                  getFirst13(selectedSort),
                                  Image.asset(
                                    'assets/mobile_data.png',
                                    color: Config.appTheme.themeColor,
                                    height: 18,
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                bottom: TabBar(
                    padding: EdgeInsets.only(bottom: 25, top: 10),
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white,
                    dividerColor: Config.appTheme.themeColor,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorSize: TabBarIndicatorSize.tab,
                    onTap: (val) {
                      benchMarkMonitorsData = [];
                      // selectedBenchMarkType = "All Categories";
                      print("tab tap = $val");
                      setState(() {
                        period = periodMap[val];
                      });
                      getBenchmarkMonitors();
                    },
                    tabs: [
                      Tab(text: "1 W"),
                      Tab(text: "1 M"),
                      Tab(text: "3 M"),
                      Tab(text: "6 M"),
                      Tab(text: "YTD"),
                      Tab(text: "1 Y"),
                      Tab(text: "3 Y"),
                      Tab(text: "5 Y"),
                      Tab(text: "10 Y"),
                      Tab(text: "Launch"),
                    ]),
              ),
              body: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    // (benchMarkMonitorsData.isEmpty) ? NoData() : displayPage(),
                    displayPage(),
                    displayPage(),
                    displayPage(),
                    displayPage(),
                    displayPage(),
                    displayPage(),
                    displayPage(),
                    displayPage(),
                    displayPage(),
                    displayPage(),
                  ]),
            ),
          );
        });
  }

  String getFirst13(String text) {
    String s = text.split(":").last;
    if (s.length > 13) s = s.substring(0, 13);
    return s;
  }

  String getFirst12(String text) {
    String s = text.split(":").last;
    if (s.length > 12) s = s.substring(0, 12);
    return s;
  }

  Widget displayPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchText(
                  hintText: "Search",
                  onChange: (val) => searchHandler(val),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 10, 5),
            child: Text("${benchMarkMonitorsData.length} Benchmark",
                style: TextStyle(
                    color: Color(0XFFB4B4B4), fontWeight: FontWeight.bold)),
          ),
          (isLoading)
              ? Utils.shimmerWidget(devHeight * 0.8, margin: EdgeInsets.all(8))
              /*: (benchMarkMonitorsData.isEmpty)
                  ? Padding(
                      padding: EdgeInsets.only(
                          top: devHeight * 0.02, left: devWidth * 0.34),
                      child: Column(
                        children: [
                          Text("No Data Available"),
                          SizedBox(height: devHeight * 0.01),
                        ],
                      ),
                    )*/
              : (searchKey.isNotEmpty && benchMarkMonitorsData.isEmpty)
                  ? NoData()
                  : ListView.builder(
                      itemCount: benchMarkMonitorsData.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index < benchMarkMonitorsData.length) {
                          Map data = benchMarkMonitorsData[index];
                          return benchMarkMonitorCard(data);
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
          SizedBox(
            height: devHeight * 0.05,
          )
        ],
      ),
    );
  }

  showAboutDialogBottom() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (_, bottomState) {
            return Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(0.5)),
              height: devHeight * 0.7,
              padding: EdgeInsets.all(7),
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("  About",
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
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "\nMost consistent funds consisting of Top 10 Mutual Fund Schemes in each category"
                      " have been chosen based on average rolling returns and consistency with which funds have"
                      " beaten category average returns. \n\nWe have ranked schemes based on these two parameters "
                      "using our proprietary algorithm and are showing the most consistent schemes for each category."
                      " Note that we have ranked schemes which have performance track records of at least 5 years "
                      "(consistency cannot be measured unless a scheme has sufficiently long track record covering"
                      "multiple market cycles e.g. bull market, bear market,sideways market etc.). \n\nAlso note that,"
                      "schemes whose AUMs have not yet reached Rs 500 Crores have been excluded from the ranking.",
                      maxLines: 20,
                      softWrap: true,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            );
          });
        });
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

  Widget appBarColumn(String title, String value, Widget suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14, color: Colors.white)),
        Container(
          width: devWidth * 0.42,
          padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Color(0XFFFFFFFF),
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

  Widget benchMarkMonitorCard(Map data) {
    String benchMark = data['benchmark'] ?? "";
    double returnsAbs = data['returns_abs'] ?? 0.00;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white),
                        color: benchMark.toLowerCase().contains('nifty')
                            ? Config.appTheme.Bg2Color
                            : benchMark.contains('bse')
                                ? Config.appTheme.lineColor
                                : Config.appTheme.overlay85),
                    child: Icon(Icons.bar_chart,
                        size: 18,
                        color: benchMark.toLowerCase().contains('nifty')
                            ? Config.appTheme.themeProfit
                            : benchMark.contains('bse')
                                ? Config.appTheme.themeColor
                                : Config.appTheme.themeLoss),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(benchMark, style: AppFonts.f50014Black),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "$returnsAbs%",
                    style: TextStyle(
                      color: returnsAbs > 0
                          ? Config.appTheme.defaultProfit
                          : Config.appTheme.defaultLoss,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // SizedBox(width: 6),
                  // Icon(
                  //   Icons.arrow_forward_ios,
                  //   size: 15,
                  //   color: Config.appTheme.placeHolderInputTitleAndArrow,
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dottedLine() {
    List<Widget> line = [];
    for (int i = 0; i < devWidth * 0.11; i++)
      line.add(Text("-", style: TextStyle(color: Colors.grey[300])));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: line,
    );
  }

  Widget infoColumn(String title, String value,
      {Color? color, CrossAxisAlignment? alignment}) {
    return Column(
      crossAxisAlignment: alignment ?? CrossAxisAlignment.start,
      children: [
        Text(title),
        Text(value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
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
              height: devHeight * 0.36,
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
                          bottomState(() {});
                          sortOptions();
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
                                  bottomState(() {});
                                  sortOptions();
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

  showBenchMarkMonitorBottomSheet() {
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
              height: devHeight * 0.36,
              padding: EdgeInsets.all(7),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Select Benchmark",
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
                            itemCount: benchMarkType.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  selectedBenchMarkType = benchMarkType[index];
                                  selectedBenchMarkType = benchMarkType[index];
                                  if (benchMarkType[index] ==
                                      "All Benchmarks") {
                                    monitorType = "All";
                                  } else if (benchMarkType[index] ==
                                      "Nifty Benchmarks") {
                                    monitorType = "Nifty";
                                  } else if (benchMarkType[index] ==
                                      "BSE Benchmarks") {
                                    monitorType = "S&P";
                                  }
                                  print(
                                      "monitorType radio $selectedBenchMarkType");
                                  print("monitorType $monitorType");
                                  if (monitorType == "All") {
                                    print("if monitortype");
                                    benchMarkMonitorsData = [];
                                    await getBenchmarkMonitors();
                                  } else if (monitorType == "Nifty") {
                                    benchMarkMonitorsData = [];
                                    await getBenchmarkMonitors();
                                    print("else monitortype Nifty");
                                    benchMarkMonitorsData =
                                        benchMarkMonitorsData.where((item) {
                                      return item['benchmark']
                                          .toString()
                                          .toLowerCase()
                                          .contains(monitorType.toLowerCase());
                                    }).toList();
                                  } else if (monitorType == "S&P") {
                                    benchMarkMonitorsData = [];
                                    await getBenchmarkMonitors();
                                    print("else monitortype S&P");
                                    benchMarkMonitorsData =
                                        benchMarkMonitorsData.where((item) {
                                      return item['benchmark']
                                          .toString()
                                          .toLowerCase()
                                          .contains(monitorType.toLowerCase());
                                    }).toList();
                                  }
                                  setState(() {});
                                  Get.back();
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: selectedBenchMarkType,
                                      value: benchMarkType[index],
                                      onChanged: (val) async {
                                        Get.back();
                                        setState(() async {
                                          selectedBenchMarkType =
                                              benchMarkType[index];
                                          if (benchMarkType[index] ==
                                              "All Benchmarks") {
                                            monitorType = "All";
                                          } else if (benchMarkType[index] ==
                                              "Nifty Benchmarks") {
                                            monitorType = "Nifty";
                                          } else if (benchMarkType[index] ==
                                              "BSE Benchmarks") {
                                            monitorType = "S&P";
                                          }
                                          print(
                                              "monitorType radio $selectedBenchMarkType");
                                          print("monitorType $monitorType");
                                          if (monitorType == "All") {
                                            print("if monitortype");
                                            benchMarkMonitorsData = [];
                                            await getBenchmarkMonitors();
                                          } else if (monitorType == "Nifty") {
                                            benchMarkMonitorsData = [];
                                            await getBenchmarkMonitors();
                                            print("else monitortype Nifty");
                                            benchMarkMonitorsData =
                                                benchMarkMonitorsData
                                                    .where((item) {
                                              return item['benchmark']
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(monitorType
                                                      .toLowerCase());
                                            }).toList();
                                          } else if (monitorType == "S&P") {
                                            benchMarkMonitorsData = [];
                                            await getBenchmarkMonitors();
                                            print("else monitortype S&P");
                                            benchMarkMonitorsData =
                                                benchMarkMonitorsData
                                                    .where((item) {
                                              return item['benchmark']
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(monitorType
                                                      .toLowerCase());
                                            }).toList();
                                          }
                                          setState(() {});
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          benchMarkType[index],
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

  sortOptions() {
    if (selectedSort == "A to Z") {
      benchMarkMonitorsData
          .sort((a, b) => a['benchmark'].compareTo(b['benchmark']!));
    }
    if (selectedSort == 'Returns') {
      benchMarkMonitorsData
          .sort((a, b) => b['returns_abs']!.compareTo(a['returns_abs']!));
    }
    setState(() {});
  }
}
