import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/ResearchApi.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/rp_widgets/SearchText.dart';

import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import 'package:mymfbox2_0/rp_widgets/NoData.dart';
import '../trailingReturns/TrailingReturns.dart';

class CategoryMonitor extends StatefulWidget {
  const CategoryMonitor({super.key});

  @override
  State<CategoryMonitor> createState() => _CategoryMonitorState();
}

class _CategoryMonitorState extends State<CategoryMonitor> {
  late double devWidth, devHeight;
  String client_name = GetStorage().read("client_name");
  List allCategories = [];
  List categoryList = [];

  String selectedCategory = "All Categories";
  String catName = "All";

  Map periodMap = {0: "1W", 1: "1M", 2: "3M", 3: "6M", 4: "YTD", 5: "1Y", 6: "3Y", 7: "5Y", 8: "10Y", 9: "Launch"};
  String period = "1W";

  String selectedSort = "Returns";
  bool isLoading = true;

  String categoryName = "";
  double categoryPercentage = 0.0;
  Color schemeColor = Colors.blue;
  Color bgSchemeColor = Colors.red;

  List sortList = ["Returns", "A to Z"];
  List colorList = [
    Color(0xffDE5E2F),
    Color(0xff5DB25D),
    Color(0xff4155B9),
    Color(0xff3C9AB6)
  ];

  Future getData() async {
    isLoading = true;
    getBroadCategoryList();
    getCategoryMonitors();
    isLoading = false;
    return 0;
  }

  Future<void> getBroadCategoryList() async {
    if (allCategories.isNotEmpty) return;
    categoryList.clear();

    Map<String, dynamic> data = await Api.getBroadCategoryList(client_name: client_name);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return;
    }

    List<dynamic> categories = data['list'];
    categoryList.add("All Categories"); // Add default category once

    for (var category in categories) {
      String categoryName = category['name'];
      categoryList.add(categoryName);
    }

    print("categoryList $categoryList");
  }


  String searchKey = "";
  Timer? searchOnStop;

  void searchHandler(String search) async {
    searchKey = search;
    print("searchKey $searchKey");
    if (searchKey.isEmpty) {
      categoryMonitor = [];
      await getCategoryMonitors();
    } else {
      categoryMonitor = categoryMonitor.where((item) {
        return item['scheme_broad_category']
            .toString()
            .toLowerCase()
            .contains(searchKey.toLowerCase());
      }).toList();
    }
    setState(() {});
  }

  List<dynamic> categoryMonitor = [];

  Future getCategoryMonitors() async {
    if (categoryMonitor.isNotEmpty) return 0;
    if (selectedCategory == "All Categories") {
      catName = "All";
    }
    Map data = await ResearchApi.getCategoryMonitors(
        broadCategory: catName, period: period, client_name: client_name);

    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    categoryMonitor = data['list'];
    sortOptions();
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        return DefaultTabController(
          length: 10,
          child: Scaffold(
            backgroundColor: Color(0XFFECF0F0),
            appBar: AppBar(
              backgroundColor: Config.appTheme.themeColor,
              leadingWidth: 0,
              toolbarHeight: 140,
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
                        "Category Monitors",
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
                      // GestureDetector(
                      //   onTap: () async {
                      //     /* categoryList = [];
                      //      await getBroadCategoryList();
                      //     showCategoryMonitorBottomSheet();*/
                      //   },
                      //   child: appBarColumn(
                      //       "Broad Category",
                      //       getFirst13(selectedCategory),
                      //       Icon(Icons.keyboard_arrow_down,
                      //           color: Colors.white10)),
                      // ),
                      // SizedBox(
                      //   width: 15,
                      // ),
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
              bottom: TabBar(
                  padding: EdgeInsets.only(bottom: 25, top: 8),
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  tabAlignment: TabAlignment.start,
                  unselectedLabelColor: Colors.white,
                  isScrollable: true,
                  dividerColor: Config.appTheme.themeColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (val) {
                    categoryMonitor = [];
                    // selectedCategory = "All Categories";
                    setState(() {
                      period = periodMap[val];
                    });
                    getCategoryMonitors();
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
            body: TabBarView( physics: NeverScrollableScrollPhysics(),
                children: [
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
      },
    );
  }

  Widget displayPage() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
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
            SizedBox(height: 4),
            Text("${categoryMonitor.length} Categories"),
            SizedBox(height: 16),
            (isLoading)
                ? Utils.shimmerWidget(devHeight * 0.2,
                    margin: EdgeInsets.all(20))
                : /*((!isLoading) && categoryMonitor.isEmpty)
                    ? NoData()
                    :*/ ListView.builder(
                        itemCount: categoryMonitor.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index < categoryMonitor.length) {
                            Map data = categoryMonitor[index];
                            Color color = getColorForCategory(
                                data['scheme_broad_category']);
                            return fundCard(color, data);
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
          ],
        ),
      ),
    );
  }

  Widget fundCard(Color color, Map data) {
    num returnAbs = data['returns_abs'];

    return GestureDetector(
      onTap:() {
              Get.to(TrailingReturns(
                defaultSubCategory: "${data['scheme_broad_category']}"));
            },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                    color: color.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4)),
                child: Icon(Icons.bar_chart, color: color)),
            SizedBox(width: 8),
            Expanded(
                child: Text("${data['scheme_broad_category']}",
                    style: AppFonts.f50014Black)),
            SizedBox(width: 5),
            Text(
              (returnAbs == 0) ? "-" : "$returnAbs %",
              style: AppFonts.f50014Black.copyWith(
                  color: (returnAbs.isNegative)
                      ? Config.appTheme.defaultLoss
                      : Config.appTheme.defaultProfit),
            ),
            SizedBox(width: 4),
            /*Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: Config.appTheme.placeHolderInputTitleAndArrow,
            )*/
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

  String getFirst10(String text) {
    String s = text.split(":").last;
    if (s.length > 12) s = s.substring(0, 12);
    return s;
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
              height: devHeight * 0.26,
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

  showCategoryMonitorBottomSheet() {
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
              height: devHeight * 0.5,
              padding: EdgeInsets.all(7),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(" Select Category",
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
                            itemCount: categoryList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                            String list = categoryList[index];
                              return GestureDetector(
                                onTap: () async {
                                  selectedCategory = categoryList[index];
                                  catName = categoryList[index];
                                  print("selectedCategory $selectedCategory");
                                  print("get selectedCategory ");
                                  await getCategoryMonitors();
                                  setState(() {
                                    selectedCategory = categoryList[index];
                                    catName = categoryList[index];
                                    print("SelectedCategory $selectedCategory");
                                  });

                                  setState(() {
                                    print("category monitor length ${categoryMonitor.length}");
                                  });
                                  categoryMonitor = [];
                                  await getCategoryMonitors();
                                  Get.back();
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: selectedCategory,
                                      value: categoryList[index],
                                      onChanged: (val) async {
                                        categoryMonitor = [];
                                        await getCategoryMonitors();
                                        setState(() {
                                          selectedCategory =
                                              categoryList[index];
                                          catName = categoryList[index];
                                          print(
                                              "SelectedCategory $selectedCategory");
                                        });

                                        setState(() {
                                          print(
                                              "category monitor length ${categoryMonitor.length}");
                                        });
                                        categoryMonitor = [];
                                        await getCategoryMonitors();
                                        Get.back();
                                      },
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

  Color getColorForCategory(String category) {
    if (category.toLowerCase().contains("hybrid")) {
      return Colors.orange;
    } else if (category.toLowerCase().contains("equity")) {
      return Colors.blue;
    } else if (category.toLowerCase().contains("debt")) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  sortOptions() {
    if (selectedSort == "A to Z") {
      categoryMonitor.sort((a, b) =>
          a['scheme_broad_category'].compareTo(b['scheme_broad_category']!));
    }
    if (selectedSort == 'Returns') {
      categoryMonitor
          .sort((a, b) => b['returns_abs']!.compareTo(a['returns_abs']!));
    }
    setState(() {});
  }
}
