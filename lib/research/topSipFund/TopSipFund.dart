import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/pojo/lumpsum/AllLumpsumFundsPojo.dart';
import 'package:mymfbox2_0/research/SchemeInfo.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class TopSipFunds extends StatefulWidget {
  const TopSipFunds({super.key});

  @override
  State<TopSipFunds> createState() => _TopSipFundsState();
}

class _TopSipFundsState extends State<TopSipFunds> {
  String client_name = GetStorage().read("client_name");

  List allCategories = [];

  String selectedCategory = "Equity Schemes";
  String selectedSubCategory = "Equity: Flexi Cap";
  String selectedAMC = "All AMCs";
  String selectedPlan = "Regular Plan";
  String selectedLumpsumAmount = "3000";
  String selectedPeriod = "1";
  String selectedInvestedAmount = "36000";

  List subCategoryList = [];
  List performanceList = [];
  List schemePlanList = ['Regular Plan'];

  List<String> sipAmountList = [
    '1000',
    '2000',
    '3000',
    '5000',
    '10000',
    '15000',
    '20000',
    '25000',
    '30000',
    '35000',
    '40000',
    '45000',
    '50000'
  ];
  List<String> sipPeriodSOfReturns = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
  ];
  bool isLoading = true;

  List<AllLumpsumFundsPojo> lumpsumPojoList = [];

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
  FocusNode focusNode = FocusNode();
  TextEditingController investmentController = TextEditingController();

  Color borderColor = Colors.grey;

  Map benchmark = {};
  Map category = {};

  Future getDatas() async {
    await getBroadCategoryList();
    await getCategoryList();
    await getTopSIPFunds();
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

  Future getBroadCategoryList() async {
    if (allCategories.isNotEmpty) return 0;
    Map data = await Api.getBroadCategoryList(client_name: client_name);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    allCategories = data['list'];

    return 0;
  }

  Future getCategoryList() async {
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

  Future getTopSIPFunds() async {
    if (performanceList.isNotEmpty) return 0;

    EasyLoading.show();
    Map data = await Api.getTopSIPFunds(
      category: selectedCategory,
      subCategory: selectedSubCategory,
      period: selectedPeriod.replaceAll("Year", ''),
      amount: selectedLumpsumAmount,
      client_name: client_name,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    performanceList = data['list'];
    summary = data['summary'];
    convertListToObj();
    EasyLoading.dismiss();

    return 0;
  }

  convertListToObj() {
    lumpsumPojoList = [];
    for (var element in performanceList) {
      lumpsumPojoList.add(AllLumpsumFundsPojo.fromJson(element));
    }

    lumpsumPojoList.sort((a, b) => b.returnsAbs!.compareTo(a.returnsAbs!));
  }

  late double devWidth, devHeight;

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return DefaultTabController(
            length: 1,
            child: Scaffold(
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
                            "SIP Funds",
                            style: AppFonts.f50014Black
                                .copyWith(fontSize: 20, color: Colors.white),
                          ),
                          // Spacer(),
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
                            showSIPAmountBottomSheet();
                          },
                          child: appBarColumn(
                              "Monthly SIP Amount",
                              getFirst13(selectedLumpsumAmount),
                              Icon(Icons.keyboard_arrow_down,
                                  color: Config.appTheme.themeColor)),
                        ),
                        /* GestureDetector(
                          onTap: () {
                            showPlanBottomSheet();
                          },
                          child: appBarColumn(
                              "Select Plan",
                              getFirst13(selectedPlan),
                              Icon(Icons.keyboard_arrow_down,
                                  color: Config.appTheme.themeColor)),
                        ),*/
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showSIPPeriodFilter();
                          },
                          child: appBarColumn(
                              "SIP Period",
                              "$selectedPeriod Years",
                              Icon(Icons.keyboard_arrow_down,
                                  color: Config.appTheme.themeColor)),
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
                            ),
                          ),
                        ),
                      ],
                    ),
                    /*  SizedBox(height: 16),
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
                        SizedBox(width: 35),
                        totalinvestamount()
                      ],
                    ),
                    SizedBox(height: 30),*/
                    SizedBox(height: 16),
                  ],
                ),
              ),
              body: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    displayPage(),
                    //displayPage(),
                    // displayPage(),
                    // displayPage(),
                    //displayPage(),
                    // displayPage(),
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
                        // Map<String, dynamic> data = performanceList[index];
                        // PerformanceReturnsPojo performanceReturns = PerformanceReturnsPojo.fromJson(data);
                        return fundCard(lumpsumPojoList[index]);
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

  String getFirst20(String text) {
    String s = text.split(":").last;
    if (s.length > 20) s = s.substring(0, 20);
    return s;
  }

  List summary = [];

  Widget blackBox() {
    AllLumpsumFundsPojo? firstLumpsumPojo =
        lumpsumPojoList.isNotEmpty ? lumpsumPojoList.first : null;

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
              Expanded(
                child: Text(data['title'],
                    // == 'Category Average'
                    // ? selectedSubCategory
                    // : data['title'],
                    style: AppFonts.f50014Black.copyWith(color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),
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
      lumpsumPojoList
          .sort((a, b) => b.schemeAssets!.compareTo(a.schemeAssets!));
    }
    if (selectedSort.contains("Returns")) {
      lumpsumPojoList.sort((a, b) => b.returnsAbs!.compareTo(a.returnsAbs!));
    }
    if (selectedSort.contains("TER")) {
      lumpsumPojoList.sort((a, b) => a.ter!.compareTo(b.ter!));
    }
    if (selectedSort == "A to Z") {
      lumpsumPojoList.sort(
          (a, b) => a.schemeAmfiShortName!.compareTo(b.schemeAmfiShortName!));
    }
    Get.back();
    setState(() {});
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
                BottomSheetTitle(title: "Select Category"),
                Divider(color: Color(0XFFDFDFDF), indent: 0),
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
                                await getCategoryList();
                                bottomState(() {});
                              },
                              child: categoryChip(
                                  "${temp['name']}", "${temp['count']}"));
                    },
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    itemCount: subCategoryList.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        child: DottedLine(
                          verticalPadding: 2,
                        ),
                      );
                    },
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      String temp =
                          getFirst20(subCategoryList[index].split(":").last);
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
                                  selectedSubCategory = subCategoryList[index];
                                  performanceList = [];
                                  bottomState(() {});
                                  // EasyLoading.show();
                                  await getTopSIPFunds();
                                  // EasyLoading.dismiss();
                                  Get.back();
                                  setState(() {
                                    print(
                                        "selectedSubCategory = $selectedSubCategory");
                                  });
                                }),
                            Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Color(0xffF8DFD5),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Icon(Icons.bar_chart,
                                    color: Colors.red, size: 20)),
                            Text(" $temp",
                                style: AppFonts.f50014Grey
                                    .copyWith(color: Color(0XFF646464))),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Color(0XFFB4B4B4),
                            ),
                          ],
                        ),
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

  showPlanBottomSheet() {
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
                    Text("  Select Plan",
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
                          itemCount: schemePlanList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                selectedPlan = schemePlanList[index];
                                print(selectedPlan);
                                performanceList = [];
                                Get.back();
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: selectedPlan,
                                      value: schemePlanList[index],
                                      onChanged: (val) {
                                        selectedPlan = schemePlanList[index];
                                        print(selectedPlan);
                                        performanceList = [];
                                        Get.back();
                                        setState(() {});
                                      },
                                    ),
                                    Expanded(
                                      child: Text(
                                        schemePlanList[index],
                                      ),
                                    ),
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

  showSIPPeriodFilter() {
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
                    Text("  Select SIP Period",
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
                          itemCount: sipPeriodSOfReturns.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                print("test");
                                selectedPeriod = sipPeriodSOfReturns[index];
                                print(selectedPeriod);
                                performanceList = [];
                                Get.back();
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                decoration: BoxDecoration(),
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: selectedPeriod,
                                      value: sipPeriodSOfReturns[index],
                                      onChanged: (val) {
                                        print("test radio");
                                        selectedPeriod =
                                            sipPeriodSOfReturns[index];
                                        print(selectedPeriod);
                                        performanceList = [];
                                        Get.back();
                                        setState(() {});
                                      },
                                    ),
                                    Expanded(
                                      child: Text(
                                        sipPeriodSOfReturns[index] + " Year",
                                      ),
                                    ),
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

  showSIPAmountBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: cornerBorder),
        builder: (context) {
          return StatefulBuilder(builder: (context, bottomState) {
            return Container(
              height: devHeight * 0.7,
              decoration: BoxDecoration(
                  borderRadius: cornerBorder, color: Colors.white),
              child: Column(
                children: [
                  BottomSheetTitle(title: "Select SIP Amount"),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            itemCount: sipAmountList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Get.back();
                                  selectedLumpsumAmount = sipAmountList[index];
                                  performanceList = [];
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: selectedLumpsumAmount,
                                      value: sipAmountList[index],
                                      onChanged: (val) {
                                        Get.back();
                                        selectedLumpsumAmount =
                                            sipAmountList[index];
                                        performanceList = [];
                                        setState(() {});
                                      },
                                    ),
                                    Expanded(
                                      child: Text(
                                        sipAmountList[index],
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

  Widget fundCard(AllLumpsumFundsPojo fund) {
    if (isLoading) return Utils.shimmerWidget(200);

    num aum = fund.schemeAssets ?? 0;
    // String aum = temp.toStringAsFixed(2);
    // dynamic formattedValue = formatter.format(num.parse(aum));

    //  print(formattedValue);
    //print("temp $aum");
    String? schemeName = fund.schemeAmfi;
    String? schemeShortName = fund.schemeAmfiShortName;
    String? schemeLogo = fund.logo;
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
              padding: const EdgeInsets.fromLTRB(14, 14, 0, 14),
              child: Row(
                children: [
                  // Image.network(fund.logo ?? "", height: 30),
                  Utils.getImage(fund.logo ?? "", 30),
                  SizedBox(width: 10),
                  ColumnText(
                    title: "$schemeShortName",
                    value: "Launch Date : ${fund.schemeInceptionDate}",
                    valueStyle: AppFonts.f40013.copyWith(fontSize: 12),
                    titleStyle: AppFonts.f40016.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                  ),

                  /*  Spacer(),
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
                  )*/
                ],
              ),
            ),
            //2nd row
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                children: [
                  rpRow(
                    lhead: "AUM (Cr)",
                    lSubHead: "$rupee ${Utils.formatNumber(aum)}",
                    rhead: "TER (%)",
                    rSubHead: "${fund.ter ?? 0}",
                    chead: "INV Amount",
                    cSubHead:
                        Utils.formatNumber((fund.investedAmount ?? 0).round()),
                  ),
                  DottedLine(verticalPadding: 8),
                  rpRow(
                      lhead: "Current Value",
                      lSubHead:
                          Utils.formatNumber((fund.currentValue ?? 0).round()),
                      rhead: "Returns (%)",
                      rSubHead: "${(returnsAbs == 0) ? "-" : returnsAbs}",
                      valueStyle: AppFonts.f50014Theme.copyWith(
                          color: (returnsAbs > 0)
                              ? Config.appTheme.defaultProfit
                              : Config.appTheme.defaultLoss),
                      chead: "",
                      cSubHead: ""),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int customRound(double value) {
    // Extract the integer part and the decimal part
    int integerPart = value.toInt();
    double decimalPart = value - integerPart;

    // If the decimal part is 0.5 or greater, return the integer part + 1
    if (decimalPart >= 0.5) {
      return integerPart + 1;
    } else {
      return integerPart;
    }
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

  totalinvestamount() {
    int investAmount = 0;
    int yearByMonth = 0;
    String toscheme = selectedPeriod.split(" ").elementAt(0);
    int selectperiod = int.parse(toscheme);
    int selectLumpsumAmount = int.parse(selectedLumpsumAmount);
    yearByMonth = (selectperiod * 12);
    investAmount = (selectLumpsumAmount * yearByMonth);
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Invested Amount",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          Container(
              width: devWidth * 0.42,
              padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
              margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: Color(0XFFDEE6E6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("$rupee ${Utils.formatNumber(investAmount)}",
                  style: TextStyle(
                      color: Config.appTheme.themeColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget rpRow({
    required String lhead,
    required String lSubHead,
    required String rhead,
    required String rSubHead,
    required String chead,
    required String cSubHead,
    final TextStyle? valueStyle,
    final TextStyle? cheadStyle,
    final TextStyle? titleStyle,
  }) {
    return Row(
      children: [
        Expanded(
            child: ColumnText(
                title: lhead,
                value: lSubHead,
                alignment: CrossAxisAlignment.start)),
        Expanded(
            child: ColumnText(
          title: rhead,
          value: rSubHead,
          alignment: CrossAxisAlignment.center,
          valueStyle: valueStyle,
          titleStyle: titleStyle,
        )),
        Expanded(
            child: ColumnText(
                title: chead,
                value: cSubHead,
                valueStyle: cheadStyle,
                alignment: CrossAxisAlignment.end)),
      ],
    );
  }
}
