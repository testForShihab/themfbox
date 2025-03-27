import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/api/ResearchApi.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/SearchText.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../rp_widgets/NoData.dart';

class CategoryReturns extends StatefulWidget {
  const CategoryReturns({super.key});

  @override
  State<CategoryReturns> createState() => _CategoryReturnsState();
}

class _CategoryReturnsState extends State<CategoryReturns> {
  late double devWidth, devHeight;
  int user_id = getUserId();
  String client_name = GetStorage().read("client_name");
  List allCategories = [];
  List categoryList = [];
  String selectedCategory = "All Categories";
  String catName = "All";

  Map periodMap = {0: "1W", 1: "1M", 2: "3M", 3: "6M", 4: "YTD", 5: "1Y"};
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
    await getBroadCategoryList();
    await getCategoryReturns();
    isLoading = false;
    return 0;
  }

  Future<void> getBroadCategoryList() async {
    if (allCategories.isNotEmpty) return;
    Map<String, dynamic> data =
        await Api.getBroadCategoryList(client_name: client_name);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return;
    }
    List<dynamic> categories = data['list'];
    categoryList.add("All Categories");
    categoryList.addAll(categories.map((category) => category['name']));
    /*  for (var category in categories) {
      String categoryName = category['name'];
      categoryList.add(categoryName);
    }*/
    //  print("categoryList--$categoryList");
    return;
  }

  String searchKey = "";
  Timer? searchOnStop;
  void searchHandler(String search) async {
    searchKey = search;
    print("searchKey $searchKey");
    if (searchKey.isEmpty) {
      categoryReturns = [];
      await getCategoryReturns();
    } else {
      categoryReturns = categoryReturns.where((item) {
        return item['category']
            .toString()
            .toLowerCase()
            .contains(searchKey.toLowerCase());
      }).toList();
    }
    //setState(() {});
  }

  List<dynamic> categoryReturns = [];
  Future getCategoryReturns() async {
    if (categoryReturns.isNotEmpty) return 0;
    if (selectedCategory == "All Categories") {
      catName = "All";
    }
    Map data = await ResearchApi.getCategoryReturns(
        Category: catName,
        period: period,
        user_id: user_id,
        client_name: client_name);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    categoryReturns = data['list'];
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
          length: 6,
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
                        "Category Returns",
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
                          print("tapped");
                          categoryList = [];
                          await getBroadCategoryList();
                          showCategoryReturnsBottomSheet();
                        },
                        child: appBarColumn(
                            "Broad Category",
                            getFirst10(selectedCategory),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
                      ),
                      SizedBox(
                        width: 15,
                      ),
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
                  unselectedLabelColor: Colors.white,
                  dividerColor: Config.appTheme.themeColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (val) {
                    categoryReturns = [];
                    selectedCategory = "All Categories";
                    print("tab tap = $val");
                    setState(() {
                      period = periodMap[val];
                    });
                    getCategoryReturns();
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
            Text("${categoryReturns.length} Categories"),
            SizedBox(height: 16),
            isLoading
                ? Utils.shimmerWidget(devHeight * 0.6,
                    margin: EdgeInsets.all(2))
                : (categoryReturns.isEmpty)
                    ? NoData()
                    : ListView.builder(
                        itemCount: categoryReturns.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index < categoryReturns.length) {
                            Map data = categoryReturns[index];
                            Color color = getColorForCategory(data['category']);
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
    double average_returns = data['average_rolling_returns'];
    num max_returns = data['max_rolling_returns'];
    num min_returns = data['min_rolling_returns'];
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(Icons.bar_chart, color: color),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "${data['category']}",
                  style: AppFonts.f50014Black,
                ),
              ),
              SizedBox(width: 5),
              Text(
                "$average_returns %",
                style: AppFonts.f50014Black.copyWith(
                  color: (average_returns.isNegative)
                      ? Config.appTheme.defaultLoss
                      : Config.appTheme.defaultProfit,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: Config.appTheme.placeHolderInputTitleAndArrow,
              ),
            ],
          ), // Add some space between rows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Min",
                value: "$min_returns",
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "",
                    style: AppFonts.f40013,
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2, // Thickness of the track
                      thumbShape: CustomThumbShape(),
                      trackShape: CustomTrackShape(),
                    ),
                    child: Slider(
                      value: average_returns.abs(),
                      min: 0,
                      max: 100,
                      activeColor: Colors.transparent,
                      inactiveColor: Colors.transparent,
                      onChanged: (double value) {
                        setState(() {
                          average_returns = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              ColumnText(
                  title: "Max",
                  value: "$max_returns",
                  alignment: CrossAxisAlignment.end),
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
                                  bottomState(() {});
                                  sortOptions();
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

  showCategoryReturnsBottomSheet() {
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
                              return GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    selectedCategory = categoryList[index];
                                    catName = categoryList[index];
                                    print("SelectedCategory $selectedCategory");
                                    print(
                                        "category Returns length ${categoryReturns.length}");
                                  });
                                  categoryReturns = [];
                                  await getCategoryReturns();
                                  Get.back();
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: selectedCategory,
                                      value: categoryList[index],
                                      onChanged: (val) async {
                                        setState(() {
                                          selectedCategory =
                                              categoryList[index];
                                          catName = categoryList[index];
                                          print(
                                              "SelectedCategory $selectedCategory");
                                          print(
                                              "category Returns length ${categoryReturns.length}");
                                        });
                                        categoryReturns = [];
                                        await getCategoryReturns();
                                        Get.back();
                                      },
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(categoryList[index]),
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
      categoryReturns.sort((a, b) => a['category'].compareTo(b['category']!));
    }
    if (selectedSort == 'Returns') {
      categoryReturns.sort((a, b) => b['average_rolling_returns']!
          .compareTo(a['average_rolling_returns']!));
    }
    ;
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
}

bool isValidSlider(num temp) {
  if (temp < 0 || temp > 100)
    return false;
  else
    return true;
}

class CustomTrackShape extends SliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight!;
    final trackLeft = offset.dx + (parentBox.size.height - trackHeight) / 2;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width * 0.8;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight * 1.6);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    bool? isDiscrete,
    bool? isEnabled,
    bool? onActiveTrack,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
  }) {
    final Canvas canvas = context.canvas;
    final rect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled ?? false,
      isDiscrete: isDiscrete ?? false,
    );

    final gradient = LinearGradient(
      colors: [
        Colors.grey.withOpacity(0.2),
        Colors.black.withOpacity(0.5)
      ], // Gradient colors
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    final paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)),
      paint,
    );
  }
}

class CustomThumbShape extends SliderComponentShape {
  static const double _thumbRadius = 3.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(_thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double>? activationAnimation,
    Animation<double>? enableAnimation,
    bool? isDiscrete,
    bool? isEnabled,
    bool? isOnTop,
    TextPainter? labelPainter,
    RenderBox? parentBox,
    SliderThemeData? sliderTheme,
    TextDirection? textDirection,
    double? value,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, _thumbRadius, paint);
  }
}
