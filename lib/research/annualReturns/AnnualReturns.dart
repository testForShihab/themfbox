import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/pojo/PerformanceReturnsPojo.dart';
import 'package:mymfbox2_0/research/SchemeInfo.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class AnnualReturns extends StatefulWidget {
  const AnnualReturns({super.key});

  @override
  State<AnnualReturns> createState() => _AnnualReturnsState();
}

class _AnnualReturnsState extends State<AnnualReturns> {
  late double devWidth, devHeight;
  List allCategories = [];
  String selectedCategory = "Equity Schemes";
  String selectedSubCategory = "Equity: Large Cap";
  String selectedAMC = "All AMCs";

  late double benchmarkReturns;
  late double categoryReturns;

  List subCategoryList = [];
  List performanceList = [];

  Map benchmark = {};
  Map category = {};

  List<PerformanceReturnsPojo> performancePojoList = [];

  Map periodMap = {0: "1", 1: "2", 2: "3", 3: "4", 4: "5"};
  String period = "1";
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
  String client_name = GetStorage().read("client_name");
  int str_year1 = 0, str_year2 = 0, str_year3 = 0, str_year4 = 0, str_year5 = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getYear();
  }

  Future getDatas() async {
    await getCategoryList();
    await getSubCategoryList();
    await getAnnualReturns();
    await getTopAmc();
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
    return 0;
  }

  Future getAnnualReturns() async {
    if (performanceList.isNotEmpty) return 0;

    String client_name = GetStorage().read("client_name");

    Map data = await Api.getAnnualReturns(
        subCategory: selectedSubCategory,
        period: period,
        client_name: client_name,
        maxno: '');
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
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

  getYear() {
    DateTime str_year = DateTime.now();
    str_year1 = str_year.year;
    str_year2 = str_year1 - 1;
    str_year3 = str_year1 - 2;
    str_year4 = str_year1 - 3;
    str_year5 = str_year1 - 4;
    print("str year1 = " + str_year1.toString());
    print("str year2 = " + str_year2.toString());
    print("str year3 = " + str_year3.toString());
    print("str year4 = " + str_year4.toString());
    print("str year5 = " + str_year5.toString());
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return DefaultTabController(
            length: 5,
            child: Scaffold(
              backgroundColor: Color(0XFFECF0F0),
              appBar: AppBar(
                backgroundColor: Config.appTheme.themeColor,
                leadingWidth: 0,
                toolbarHeight: 220,
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
                            "Annual Returns",
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
                              getFirst13(selectedSubCategory),
                              Icon(Icons.keyboard_arrow_down,
                                  color: Config.appTheme.themeColor)),
                        ),
                        GestureDetector(
                          onTap: () {
                            showAmcFilter();
                          },
                          child: appBarColumn(
                              "Select AMCs",
                              getFirst16(selectedAMC),
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
                  ],
                ),
                bottom: TabBar(
                    padding: EdgeInsets.only(bottom: 25, top: 10),
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white,
                    dividerColor: Config.appTheme.themeColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    onTap: (val) async {
                      print("tab tap = $val");
                      period = periodMap[val];
                      print("Period $period");
                      performanceList = [];
                      await getAnnualReturns();
                      setState(() {});
                    },
                    tabs: [
                      Tab(text: "$str_year1"),
                      Tab(text: "$str_year2"),
                      Tab(text: "$str_year3"),
                      Tab(text: "$str_year4"),
                      Tab(text: "$str_year5"),
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
                  ]),
            ),
          );
        });
  }

  Widget displayPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Text("${performanceList.length} funds",
                style: TextStyle(
                    color: Color(0XFFB4B4B4), fontWeight: FontWeight.bold)),
          ),
          blackBox(),
          SizedBox(height: 16),
          (isLoading)
              ? Utils.shimmerWidget(devHeight * 0.6, margin: EdgeInsets.all(20))
              : (performanceList.isEmpty)
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

  String getFirst16(String text) {
    String s = text.split(":").last;
    if (s.length > 16) s = s.substring(0, 16);
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data['title'],
                  style: AppFonts.f50014Black.copyWith(color: Colors.white)),
              Text("${data['value']} %",
                  style: AppFonts.f50014Black
                      .copyWith(color: Config.appTheme.themeProfit)),
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
                          if (selectedAmcList.contains(name))
                            selectedAmcList.remove(name);
                          else
                            selectedAmcList.add(name);
                          bottomState(() {});
                          performanceList = [];
                          //   Get.back();
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
                                  //  Get.back();
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
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: devWidth * 0.15, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(color: Config.appTheme.themeColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text("Cancel"),
        ),
      ),
    );
  }

  Widget filledButton() {
    return InkWell(
      onTap: () {
        performanceList = [];
        if (selectedAmcList.isEmpty)
          selectedAMC = "All AMCs";
        else
          selectedAMC = "${selectedAmcList.length} Amcs Selected";
        setState(() {});
        Get.back();
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

                      return (selectedCategory == temp['name'])
                          ? selectedCategoryChip(
                              "${temp['name']}", "${temp['count']}")
                          : InkWell(
                              onTap: () async {
                                selectedCategory = temp['name'];
                                subCategoryList = [];
                                // EasyLoading.show();
                                await getSubCategoryList();
                                // EasyLoading.dismiss();
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
                          Get.back();
                          selectedSubCategory = subCategoryList[index];
                          performanceList = [];
                          bottomState(() {});
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Radio(
                                value: subCategoryList[index],
                                groupValue: selectedSubCategory,
                                activeColor: Config.appTheme.themeColor,
                                onChanged: (val) async {
                                  Get.back();
                                  selectedSubCategory = subCategoryList[index];
                                  performanceList = [];
                                  bottomState(() {});
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
                            Text(" $temp"),
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

  Widget fundCard(PerformanceReturnsPojo fund) {
    if (isLoading) return Utils.shimmerWidget(200);

    num aum = fund.schemeAssets ?? 0;
    String? schemeName = fund.schemeAmfi;
    String? schemeShortName = fund.schemeAmfiShortName;
    String? schemeLogo = fund.logo;
    String? launchDate = fund.inceptionDate;

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
              padding: const EdgeInsets.fromLTRB(14, 14, 0, 14),
              child: Row(
                children: [
                  //Image.network(fund.logo ?? "", height: 30),
                  Utils.getImage(fund.logo ?? "", 30),
                  SizedBox(width: 10),
                  SizedBox(
                      width: 200,
                      child: Text("$schemeShortName",
                          style: TextStyle(fontWeight: FontWeight.bold))),
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
                      Text("${fund.schemeRating}",
                          style: TextStyle(color: Config.appTheme.themeColor)),
                      Icon(Icons.star,
                          color: Config.appTheme.themeColor, size: 18)
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
                          title: "AUM(Cr)",
                          value: "$rupee ${Utils.formatNumber((aum).round())}"),
                      ColumnText(
                        title: "Doubled In",
                        value: fund.doubleIn ?? '',
                        alignment: CrossAxisAlignment.center,
                      ),
                      ColumnText(
                        title: "Returns",
                        value: "${fund.returnsAbs} %",
                        alignment: CrossAxisAlignment.end,
                        valueStyle: AppFonts.f50014Theme
                            .copyWith(color: Config.appTheme.defaultProfit),
                      ),
                    ],
                  ),
                  DottedLine(verticalPadding: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ColumnText(title: "TER", value: "${fund.ter} %"),
                      ColumnText(
                        title: "Category Rank",
                        value:
                            "${fund.returnsAbsRank} of ${fund.returnsAbsTotalrank}",
                        alignment: CrossAxisAlignment.center,
                      ),
                      ColumnText(
                        title: "           ",
                        value: "           ",
                        alignment: CrossAxisAlignment.end,
                      ),
                      // ColumnText(
                      //   title: "Launch Date",
                      //   value: "$launchDate",
                      //   alignment: CrossAxisAlignment.end,
                      // ),
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

  Widget dottedLine() {
    List<Widget> line = [];
    for (int i = 0; i < devWidth * 0.13; i++)
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
