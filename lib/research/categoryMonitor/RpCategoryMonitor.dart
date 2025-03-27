import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/api/ResearchApi.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class RpCategoryMonitor extends StatefulWidget {
  const RpCategoryMonitor({super.key});

  @override
  State<RpCategoryMonitor> createState() => _RpCategoryMonitorState();
}

class _RpCategoryMonitorState extends State<RpCategoryMonitor> {
  late double devHeight, devWidth;
  String client_name = GetStorage().read("client_name");

  Map periodMap = {0: "1W", 1: "1M", 2: "3M", 3: "6M", 4: "YTD", 5: "1Y"};
  String period = "1W";

  List sortList = [
    "Returns",
    "A to Z",
    "AUM (High to Low)",
    "TER (Low to High)"
  ];

  String selectedSort = "Returns";
  bool isLoading = true;

  List colorList = [
    Color(0xffDE5E2F),
    Color(0xff5DB25D),
    Color(0xff4155B9),
    Color(0xff3C9AB6)
  ];

  List allCategories = [];
  Future getBroadCategoryList() async {
    if (allCategories.isNotEmpty) return 0;
    Map data = await Api.getBroadCategoryList(client_name: client_name);

    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    allCategories = data['list'];
    print("allCategories = $allCategories");
    return 0;
  }

  List categoryMonitor = [];
  String category = "All";

  Future getCategoryMonitors() async {
    if (categoryMonitor.isNotEmpty) return 0;

    Map data = await ResearchApi.getCategoryMonitors(
        broadCategory: category, period: period, client_name: client_name);

    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    categoryMonitor = data['list'];
    print("categoryMonitor = $categoryMonitor");
    return 0;
  }

  Future getDatas() async {
    EasyLoading.show();
    await getBroadCategoryList();
    await getCategoryMonitors();
    EasyLoading.dismiss();

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return DefaultTabController(
            length: 6,
            child: Scaffold(
              backgroundColor: Config.appTheme.mainBgColor,
              appBar: AppBar(
                backgroundColor: Config.appTheme.themeColor,
                leadingWidth: 0,
                toolbarHeight: 180,
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
                        Spacer(),
                        Icon(Icons.info_outline)
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showCategoryBottomSheet();
                          },
                          child: appBarColumn(
                              "Broad Category",
                              getFirst13(category),
                              Icon(Icons.keyboard_arrow_down,
                                  color: Config.appTheme.themeColor)),
                        ),
                        SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            showSortFilter();
                          },
                          child: appBarColumn(
                              "Sort By",
                              getFirst13(selectedSort),
                              Icon(
                                Icons.sort,
                                color: Config.appTheme.themeColor,
                              )),
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
                    indicatorSize: TabBarIndicatorSize.tab,
                    onTap: (val) {
                      print("tab tap = $val");
                      categoryMonitor = [];
                      setState(() {
                        period = periodMap[val];
                      });
                    },
                    tabs: [
                      Tab(text: "1 W"),
                      Tab(text: "1 M"),
                      Tab(text: "3 M"),
                      Tab(text: "6 M"),
                      Tab(text: "YTD"),
                      Tab(text: "1 Y"),
                    ]),
              ),
              body: TabBarView(children: [
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
                          bottomState(() {});
                          // sortOptions();
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
                                  //  sortOptions();
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
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          itemCount: allCategories.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            Map temp = allCategories[index];
                            return InkWell(
                              onTap: () async {
                                category = temp['name'];
                                EasyLoading.show();
                                categoryMonitor = [];
                                EasyLoading.dismiss();
                                await getCategoryMonitors();
                                Get.back();
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                decoration: BoxDecoration(
                                    border: Border(
                                  bottom: BorderSide(
                                      width: 1.0, color: Color(0XFFDFDFDF)),
                                )),
                                child: Row(
                                  children: [
                                    Radio(
                                        value: allCategories[index],
                                        groupValue: category,
                                        activeColor: Config.appTheme.themeColor,
                                        onChanged: (val) async {
                                          category = temp['name'];
                                          EasyLoading.show();
                                          categoryMonitor = [];
                                          EasyLoading.dismiss();
                                          await getCategoryMonitors();
                                          Get.back();
                                          setState(() {});
                                        }),
                                    Expanded(child: Text("${temp['name']}")),
                                  ],
                                ),
                              ),
                            );
                          })),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  String getFirst13(String text) {
    String s = text.split(":").last;
    if (s.length > 13) s = s.substring(0, 13);
    return s;
  }

  Widget displayPage() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${categoryMonitor.length} Categories"),
            SizedBox(height: 16),
            ListView.builder(
              itemCount: categoryMonitor.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Color color = (index >= colorList.length)
                    ? colorList[index % 4]
                    : colorList[index];
                Map data = categoryMonitor[index];

                return fundCard(color, data);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget fundCard(Color color, Map data) {
    num returnAbs = data['returns_abs'];

    return Container(
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
          SizedBox(width: 10),
          Expanded(child: Text("${data['scheme_broad_category']}")),
          SizedBox(width: 5),
          Text(
            "$returnAbs %",
            style: AppFonts.f50014Black.copyWith(
                color: (returnAbs.isNegative)
                    ? Config.appTheme.defaultLoss
                    : Config.appTheme.defaultProfit),
          )
        ],
      ),
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
        )
      ],
    );
  }
}
