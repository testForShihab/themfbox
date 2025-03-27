import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/api/ResearchApi.dart';
import 'package:mymfbox2_0/pojo/lumpsum/AllLumpsumFundsPojo.dart';
import 'package:mymfbox2_0/research/SchemeInfo.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import 'package:mymfbox2_0/rp_widgets/NoData.dart';

class TopLumpsumFunds extends StatefulWidget {
  const TopLumpsumFunds({super.key});

  @override
  State<TopLumpsumFunds> createState() => _TopLumpsumFundsState();
}

class _TopLumpsumFundsState extends State<TopLumpsumFunds> {
  String client_name = GetStorage().read("client_name");

  List allCategories = [];

  String selectedCategory = "Equity Schemes";
  String selectedSubCategory = "Equity: Large Cap";
  String selectedAMC = "All AMCs";
  String selectedPlan = "Regular Plan";
  String selectedAmount = "10000";
  String selectedPeriod = "5";

  List<String> lumpsumAmount = [
    '10000',
    '25000',
    '50000',
    '100000',
    '200000',
    '300000',
    '500000',
    '1000000',
    '1500000',
    '2500000'
  ];

  List<String> lumpsumPeriodSOfReturns = [
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

  List subCategoryList = [];
  List performanceList = [];
  List schemePlanList = ['Regular Plan'];

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

  Map benchmark = {};
  Map category = {};

  Future getDatas() async {
    isLoading = true;
    await getBroadCategoryList();
    await getCategoryList();
    await getLumpsumFunds();
    isLoading = false;
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

  Future getLumpsumFunds() async {
    if (performanceList.isNotEmpty) return 0;

    Map data = await ResearchApi.getTopLumpsumFunds(
        category: selectedSubCategory,
        period: selectedPeriod.replaceAll("Year", ''),
        amount: selectedAmount,
        amc: '',
        client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    performanceList = data['list'];
    summary = data['summary'];

    convertListToObj();

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
            length: 6,
            child: Scaffold(
              backgroundColor: Config.appTheme.mainBgColor,
              appBar: AppBar(
                backgroundColor: Config.appTheme.themeColor,
                leadingWidth: 0,
                toolbarHeight: 280,
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
                            "Top Lumpsum Funds",
                            style: AppFonts.f50014Black
                                .copyWith(fontSize: 20, color: Colors.white),
                          ),
                          Spacer(),
                          MfAboutIcon(
                            context: context,
                          )
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
                            showPlanBottomSheet();
                          },
                          child: appBarColumn(
                              "Select Plan",
                              getFirst13(selectedPlan),
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
                            showLumpsumAmountBottomSheet();
                          },
                          child: appBarColumn(
                              "Lumpsum Amount",
                              getFirst13(selectedAmount),
                              Icon(Icons.keyboard_arrow_down,
                                  color: Config.appTheme.themeColor)),
                        ),
                        GestureDetector(
                          onTap: () {
                            showSIPPeriodFilter();
                          },
                          child: appBarColumn(
                              "Lumpsum Period (Years)",
                              getFirst13(selectedPeriod),
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
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                  ],
                ),
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
        itemCount: 2,
        itemBuilder: (context, index) {
          Map data = summary[index];

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data['title'],
                  style: AppFonts.f50014Black.copyWith(color: Colors.white)),
              Text("${data['value'].toStringAsFixed(2)} %",
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

  showLumpsumAmountBottomSheet() {
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
                      Text("   select Lumpsum Amount",
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
                            itemCount: lumpsumAmount.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              num titleNum = num.parse(lumpsumAmount[index]);

                              return GestureDetector(
                                onTap: () async {
                                  Get.back();
                                  selectedAmount = lumpsumAmount[index];
                                  performanceList = [];
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: selectedAmount,
                                      value: lumpsumAmount[index],
                                      onChanged: (val) async {
                                        Get.back();
                                        selectedAmount = lumpsumAmount[index];
                                        performanceList = [];
                                        setState(() {});
                                        /*${getLumpsumFunds()}*/
                                      },
                                    ),
                                    Expanded(
                                        child:
                                            Text(Utils.formatNumber(titleNum))),
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

  showSortFilter() {
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
        return StatefulBuilder(
          builder: (_, bottomState) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sort By",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Divider(),
                    ListView.builder(
                      itemCount: sortList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
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
                                },
                              ),
                              Text(sortList[index]),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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

  Widget filledButton() {
    return InkWell(
      onTap: () {
        performanceList = [];
        Get.back();
        if (selectedAmcList.isEmpty)
          selectedAMC = "All AMCs";
        else
          selectedAMC = "Selected AMC";
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
                                await getCategoryList();
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
                          selectedSubCategory = subCategoryList[index];
                          performanceList = [];
                          bottomState(() {});
                          // EasyLoading.show();
                          await getLumpsumFunds();
                          // EasyLoading.dismiss();

                          Get.back();
                          setState(() {
                            print("selectedSubCategory = $selectedSubCategory");
                          });
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
                                  await getLumpsumFunds();
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
                            SizedBox(width: 6),
                            Expanded(child: Text(temp)),
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
                                setState(() {
                                  selectedPlan = schemePlanList[index];
                                  print(selectedPlan);
                                });
                                Get.back();
                              },
                              child: Row(
                                children: [
                                  Radio(
                                    activeColor: Config.appTheme.themeColor,
                                    groupValue: selectedPlan,
                                    value: schemePlanList[index],
                                    onChanged: (val) {
                                      setState(() {
                                        selectedPlan = schemePlanList[index];
                                        print(selectedPlan);
                                      });
                                      Get.back();
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      schemePlanList[index],
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
            height: devHeight * 0.7,
            padding: EdgeInsets.all(7),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("  Select Lumpsum Period",
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
                          itemCount: lumpsumPeriodSOfReturns.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                selectedPeriod = lumpsumPeriodSOfReturns[index];
                                print("selectedPeriod = $selectedPeriod");
                                performanceList = [];
                                Get.back();
                                setState(() {});
                              },
                              child: Row(
                                children: [
                                  Radio(
                                    activeColor: Config.appTheme.themeColor,
                                    groupValue: selectedPeriod,
                                    value: lumpsumPeriodSOfReturns[index],
                                    onChanged: (val) async {
                                      selectedPeriod =
                                          lumpsumPeriodSOfReturns[index];
                                      print(selectedPeriod);
                                      performanceList = [];
                                      Get.back();
                                      setState(() {});
                                    },
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        lumpsumPeriodSOfReturns[index],
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

  Widget fundCard(AllLumpsumFundsPojo fund) {
    if (isLoading) return Utils.shimmerWidget(200);

    num aum = fund.schemeAssets ?? 0;

    String? schemeName = fund.schemeAmfi;
    String? schemeShortName = fund.schemeAmfiShortName;
    String? schemeLogo = fund.logo;
    num currValue = fund.currentValue ?? 0;
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
                          value:
                              "$rupee ${Utils.formatNumber(customRound(aum / 10))}"),
                      ColumnText(
                        title: "Doubled In",
                        value: "${fund.doubleIn}",
                        alignment: CrossAxisAlignment.center,
                      ),
                      ColumnText(
                          title: "Returns",
                          value: "$returnsAbs %",
                          alignment: CrossAxisAlignment.end,
                          valueStyle: AppFonts.f50014Theme.copyWith(
                              color: (returnsAbs > 0)
                                  ? Config.appTheme.defaultProfit
                                  : Config.appTheme.defaultLoss)),
                    ],
                  ),
                  DottedLine(verticalPadding: 8),
                  Row(
                    children: [
                      Expanded(
                          child:
                              ColumnText(title: "TER", value: "${fund.ter} %")),
                      Expanded(
                        child: ColumnText(
                          title: "Launch Date",
                          value: "${fund.schemeInceptionDate}",
                          alignment: CrossAxisAlignment.center,
                        ),
                      ),
                      Expanded(
                        child: ColumnText(
                          title: "Current Value",
                          value: Utils.formatNumber(currValue.round()),
                          alignment: CrossAxisAlignment.end,
                        ),
                      ),
                      //Expanded(child: SizedBox())
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
}
