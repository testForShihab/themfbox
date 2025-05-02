// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/pojo/PerformanceReturnsPojo.dart';
import 'package:mymfbox2_0/research/SchemeInfo.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class TrailingReturns extends StatefulWidget {
  const TrailingReturns(
      {super.key,
      this.defaultCategory = "Equity",
      this.defaultSubCategory = "Equity: Flexi Cap"});

  final String? defaultCategory;
  final String defaultSubCategory;

  @override
  State<TrailingReturns> createState() => _TrailingReturnsState();
}

class _TrailingReturnsState extends State<TrailingReturns> {
  String client_name = GetStorage().read("client_name");

  late double devWidth, devHeight;
  List allCategories = [];

  String selectedCategory = "";
  String selectedSubCategory = "";
  String selectedAMC = "All AMCs";
  List subCategoryList = [];
  List performanceList = [];

  bool isLoading = true;

  List<PerformanceReturnsPojo> performancePojoList = [];

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
    9: 'Since Inception'
  };
  String period = "1W";
  Map amcTitle = {
    "Top 3": 3,
    "Top 5": 5,
    "Top 10": 10,
    "Top 15": 15,
    "Select": ""
  };
  String amc = "3";
  List amcList = [];
  List selectedAmcList = [];
  List sortList = [
    "Returns",
    "A to Z",
    "AUM (High to Low)",
    "TER (Low to High)"
  ];
  String selectedSort = "Returns";

  @override
  void initState() {
    super.initState();

    selectedCategory = widget.defaultCategory!;
    selectedSubCategory = widget.defaultSubCategory;

    // selectedWidgetCategory = widget.exploreCategory;
    // selectedWidgetSubCategory = widget.defaultSubCategory;
    //
    // if (selectedWidgetCategory.isNotEmpty &&
    //     selectedWidgetSubCategory.isNotEmpty) {
    //   selectedCategory = selectedWidgetCategory;
    //   selectedSubCategory = selectedWidgetSubCategory;
    //
    //   print("selected category ----> $selectedCategory");
    //   print("selected subcategory -----> $selectedSubCategory");
    // } else {
    //   selectedCategory = "Equity Schemes";
    //   selectedSubCategory = "Equity: Large Cap";
    // }
    // print("selectedCategory init $selectedCategory");
    // print("selectedSubCategory init $selectedSubCategory");
  }

  Future getDatas() async {
    isLoading = true;
    try {
      await getCategoryList();
      await getSubCategoryList();
      await getTrailingReturns();
      await getTopAmc();
    } catch (e) {
      print("getDatas Exception = $e");
    }
    isLoading = false;

    return 0;
  }

  Future getTopAmc() async {
    Map data = await Api.getTopAmc(count: amc, client_name: client_name);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    amcList = data['list'];

    return 0;
  }

  Future getCategoryList() async {
    if (allCategories.isNotEmpty) return 0;
    Map data = await Api.getBroadCategoryList(client_name: client_name);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    allCategories = data['list'];

    return 0;
  }

  Future getSubCategoryList() async {
    if (subCategoryList.isNotEmpty) return 0;

    Map data = await Api.getCategoryList(
        category: selectedCategory, client_name: client_name);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    subCategoryList = data['list'];
    // selectedSubCategory = "Large Cap";

    return 0;
  }

  Future getTrailingReturns() async {
    if (performanceList.isNotEmpty) return 0;

    Map data = await Api.getTrailingReturns(
        category: selectedSubCategory,
        period: period,
        amcList: selectedAmcList,
        client_name: client_name);
    performanceList = data['performances'];
    summary = data['summary'];
    convertListToObj();
    return 0;
  }

  convertListToObj() {
    performancePojoList = [];
    for (var element in performanceList) {
      performancePojoList.add(PerformanceReturnsPojo.fromJson(element));
    }

    performancePojoList.sort((a, b) => b.returnsAbs!.compareTo(a.returnsAbs!));
  }

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
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back),
                          SizedBox(width: 5),
                          Text(
                            "Trailing Returns",
                            style: AppFonts.f50014Black
                                .copyWith(fontSize: 20, color: Colors.white),
                          ),
                          //Spacer(),
                          //MfAboutIcon(context: context),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showCategoryBottomSheet();
                          },
                          child: appBarColumn(
                              "Category",
                              getFirst15(selectedSubCategory),
                              Icon(Icons.keyboard_arrow_down,
                                  color: Config.appTheme.themeColor)),
                        ),
                       /* GestureDetector(
                          onTap: () {
                            showAmcFilter();
                          },
                          child: appBarColumn(
                              "Select Up To 5 AMCs",
                              getFirst15(selectedAMC),
                              Icon(Icons.keyboard_arrow_down,
                                  color: Config.appTheme.themeColor)),
                        ),*/
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
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                  ],
                ),
                bottom: TabBar(
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    labelPadding: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.only(bottom: 15, top: 10),
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white,
                    dividerColor: Config.appTheme.themeColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    onTap: (val) {
                      selectedSort = "Returns";
                      print("tab tap = $val");
                      performanceList = [];
                      period = periodMap[val] ?? '';
                      setState(() {});
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
                      Tab(text: "Since Inception"),
                    ]),
              ),
              body: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
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
        });
  }

  Widget displayImage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: displayPage(),
          ),
        ],
      ),
    );
  }

  Widget displayPage() {
    num fundcount = performanceList.length;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Text((fundcount<=1) ? "$fundcount Fund" : "$fundcount Funds",
                style: TextStyle(
                    color: Color(0XFFB4B4B4), fontWeight: FontWeight.bold)),
          ),
          (isLoading)
              ? Utils.shimmerWidget(devHeight * 0.6, margin: EdgeInsets.all(20))
              : summary.isNotEmpty
                  ? blackBox()
                  : NoData(),
          SizedBox(height: 16),
          (isLoading)
              ? Utils.shimmerWidget(devHeight * 0.6, margin: EdgeInsets.all(20))
              : (summary.isNotEmpty && performanceList.isEmpty)
                  ? NoData()
                  : ListView.builder(
                      itemCount: performanceList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return fundCard(performancePojoList[index]);
                      },
                    ),
          SizedBox(height: devHeight * 0.05)
        ],
      ),
    );
  }

  String getFirst13(String text) {
    String s = text.split(":").last;
    if (s.length > 13) s = s.substring(0, 13);
    return s;
  }

  String getFirst15(String text) {
    String s = text.split(":").last;
    if (s.length > 15) s = s.substring(0, 15);
    return s;
  }

  List summary = [];

  Widget blackBox() {
    if (isLoading) return Utils.shimmerWidget(100);

    return Container(
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: summary.length,
        itemBuilder: (context, index) {
          Map data = summary[index];

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(data['title'],
                      style:
                          AppFonts.f50014Black.copyWith(color: Colors.white))),
              SizedBox(width: 4),
              Text("${data['value']} %",
                  style: AppFonts.f50014Black.copyWith(
                      color: (data['value'] > 0)
                          ? Config.appTheme.defaultProfit
                          : Config.appTheme.defaultLoss)),
            ],
          );
        },
      ),
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
            return SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(7),
                child: Column(
                  children: [
                    BottomSheetTitle(title: "Sort By"),
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
                                  }),
                              Text(sortList[index])
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  sortOptions() {
    if (selectedSort.contains("AUM")) {
      performancePojoList
          .sort((a, b) => b.schemeAssets!.compareTo(a.schemeAssets!));
    }
    if (selectedSort.contains("Returns")) {
      performancePojoList
          .sort((a, b) => b.returnsAbs!.compareTo(a.returnsAbs!));
    }
    if (selectedSort.contains("TER")) {
      performancePojoList.sort((a, b) => a.ter!.compareTo(b.ter!));
    }
    if (selectedSort == "A to Z") {
      performancePojoList.sort(
          (a, b) => a.schemeAmfiShortName!.compareTo(b.schemeAmfiShortName!));
    }
    Get.back();
    setState(() {});
  }

  showAmcFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      builder: (context) {
        return StatefulBuilder(builder: (_, bottomState) {
          return Container(
            color: Colors.white,
            height: devHeight * 0.7,
            padding: EdgeInsets.all(7),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("  AMC Filter",
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
                    itemCount: amcTitle.length,
                    itemBuilder: (context, index) {
                      String text = amcTitle.keys.elementAt(index);
                      String value =
                          amcTitle.values.elementAt(index).toString();

                      return (amc == value)
                          ? selectedAmcChip(text)
                          : InkWell(
                              onTap: () async {
                                selectedAMC = "Selected AMC";
                                amc = value;
                                await getTopAmc();
                                bottomState(() {});
                              },
                              child: amcChip(text));
                    },
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  flex: 9,
                  child: ListView.builder(
                    itemCount: amcList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Map data = amcList[index];
                      String name = data['name'];
                      String logo = data['logo'];

                      return InkWell(
                        onTap: () async {
                          selectedAMC = "Selected AMC";
                          if (selectedAmcList.contains(name))
                            selectedAmcList.remove(name);
                          else
                            selectedAmcList.add(name);
                          bottomState(() {});
                          performanceList = [];
                          //  Get.back();
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Checkbox(
                                value: selectedAmcList.contains(name),
                                activeColor: Config.appTheme.themeColor,
                                onChanged: (val) async {
                                  if (selectedAmcList.contains(name))
                                    selectedAmcList.remove(name);
                                  else
                                    selectedAmcList.add(name);
                                  bottomState(() {});
                                  performanceList = [];
                                  //    Get.back();
                                  setState(() {});
                                }),
                            //Image.network(logo, height: 30),
                            Utils.getImage(logo, 30),
                            SizedBox(width: 10),
                            Text(name),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          plainButton(),
                          filledButton(),
                        ],
                      ),
                    ))
              ],
            ),
          );
        });
      },
    );
  }

  Widget plainButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: devWidth * 0.15, vertical: 2),
      decoration: BoxDecoration(
          border: Border.all(color: Config.appTheme.themeColor),
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text("Cancel"),
      ),
    );
  }

  Widget filledButton() {
    return InkWell(
      onTap: () {
        if (selectedAmcList.length > 5) {
          Utils.showError(context, "Please Select Top 5 Amcs");
          return;
        }
        performanceList = [];
        Get.back();
        if (selectedAmcList.isEmpty)
          selectedAMC = "All AMCs";
        else
          selectedAMC = "${selectedAmcList.length} Amcs Selected";
        setState(() {});
      },
      child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: devWidth * 0.15, vertical: 2),
          decoration: BoxDecoration(
              color: Config.appTheme.themeColor,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text("Apply (${selectedAmcList.length})",
                  style: TextStyle(color: Colors.white)))),
    );
  }

  Widget selectedAmcChip(String text) {
    return Container(
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          color: Config.appTheme.themeColor,
          borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }

  Widget amcChip(String text) {
    return Container(
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          color: Color(0XFFF1F1F1), borderRadius: BorderRadius.circular(8)),
      child: Text(text),
    );
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
            color: Colors.white,
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
                      String category = temp['name'];

                      return (category.contains(selectedCategory))
                          ? selectedCategoryChip(
                              "${temp['name']}", "${temp['count']}")
                          : categoryChip("${temp['name']}", "${temp['count']}",
                              bottomState);
                    },
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: subCategoryList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      String subCategory =
                          subCategoryList[index].split(":").last.trim();
                      return InkWell(
                        onTap: () async {
                          selectedSubCategory = subCategoryList[index];
                          performanceList = [];
                          bottomState(() {});
                          await getTrailingReturns();
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
                                  performanceList = [];
                                  bottomState(() {});

                                  await getTrailingReturns();

                                  Get.back();
                                  setState(() {
                                    print(
                                        "selectedSubCategory = $selectedSubCategory");
                                  });
                                }),
                            // Container(
                            //     height: 30,
                            //     width: 30,
                            //     decoration: BoxDecoration(
                            //         color: Color(0xffF8DFD5),
                            //         borderRadius: BorderRadius.circular(5)),
                            //     child: Icon(Icons.bar_chart,
                            //         color: Colors.red, size: 20)),
                            Text(" $subCategory"),
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

  Widget categoryChip(String name, String count, Function bottomState) {
    String category = "";
    if (name.contains("Schemes")) {
      List list = name.split(" ");
      list.removeWhere((element) => element == 'Schemes');
      category = list.join(" ");
    }

    return GestureDetector(
      onTap: () async {
        print("category = $category");

        selectedCategory = category;
        subCategoryList = [];
        await getSubCategoryList();
        bottomState(() {});
      },
      child: Container(
        padding: EdgeInsets.all(7),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
            color: Config.appTheme.overlay85,
            borderRadius: BorderRadius.circular(8)),
        child: Text("$category ($count)"),
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

  Widget fundCard(PerformanceReturnsPojo fund) {
    if (isLoading) return Utils.shimmerWidget(200);

    num aum = fund.schemeAssets ?? 0;
    String? schemeName = fund.schemeAmfi;
    String? schemeShortName = fund.schemeAmfiShortName;
    String? schemeLogo = fund.logo;
    String launchDate = fund.tra_InceptionDate ?? '';
    num returnsAbs = fund.returnsAbs ?? 0;

    return GestureDetector(
      onTap: () {
        Get.to(SchemeInfo(
            schemeName: schemeName,
            schemeShortName: schemeShortName,
            schemeLogo: schemeLogo));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          children: [
            //1st row
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 0, 0),
              child: Row(
                children: [
                  //Image.network(fund.logo ?? "", height: 30),
                  Utils.getImage(fund.logo ?? "", 32),
                  SizedBox(width: 10),
                  // SizedBox(
                  //     width: 200,
                  //     child: Text("$schemeShortName",
                  //         style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$schemeShortName",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                                launchDate,
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
                  //     Text("${fund.schemeRating}",
                  //         style: TextStyle(color: Config.appTheme.themeColor)),
                  //     Icon(Icons.star,
                  //         color: Config.appTheme.themeColor, size: 18)
                  //   ]),
                  // )
                ],
              ),
            ),
            DottedLine(),
            //2nd row
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ColumnText(
                        title: "AUM (Cr)",
                        value: "$rupee $aum",
                        alignment: CrossAxisAlignment.start,
                      ),
                      ColumnText(
                        title: "TER (%)",
                        value: "${fund.ter}",
                        alignment: CrossAxisAlignment.center,
                      ),
                      ColumnText(
                        title: "${(period == "Since Inception") ? "Since Launch" :period} Rtn (%)",
                        value: "${(returnsAbs == 0) ? "-" : returnsAbs}",
                        alignment: CrossAxisAlignment.end,
                        valueStyle: AppFonts.f50014Theme.copyWith(
                            color: (returnsAbs > 0)
                                ? Config.appTheme.defaultProfit
                                : Config.appTheme.defaultLoss),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ColumnText(
                        title: "NAV",
                        value: Utils.formatNumber(fund.price),
                        alignment: CrossAxisAlignment.start,
                      ),
                     *//* if (period != 'Since Inception' && period != 'ytd')
                        ColumnText(
                          title: "Category Rank",
                          value:
                              "${fund.returnsAbsRank} of ${fund.returnsAbsTotalrank}",
                          alignment: CrossAxisAlignment.end,
                        ),*//*

                      // ColumnText(
                      //   title: "Launch Date",
                      //   value: "$launchDate",
                      //   alignment: CrossAxisAlignment.end,
                      // ),
                    ],
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String formatNumberWithoutDecimal(num? source,
      {bool isAmount = false, bool isShortAmount = false}) {
    if (source == null) return "0";
    NumberFormat formatter = NumberFormat("#,##,###");
    String suffix = "";
    if (isShortAmount) {
      if (source > crore) {
        source /= crore;
        suffix = " Cr";
      } else if (source > lakh) {
        source /= lakh;
        suffix = " L";
      } else {
        source /= 1000;
        suffix = " K";
      }
    }
    String result = formatter.format(source);
    return result + suffix;
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
}
