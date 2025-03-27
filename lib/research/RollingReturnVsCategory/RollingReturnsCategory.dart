import 'package:flutter/material.dart';
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

class RollingReturnsCategory extends StatefulWidget {
  const RollingReturnsCategory({super.key});

  @override
  State<RollingReturnsCategory> createState() => _RollingReturnsCategoryState();
}

class _RollingReturnsCategoryState extends State<RollingReturnsCategory> {
  late double devWidth, devHeight;
  List allCategories = [];
  String client_name = GetStorage().read("client_name");

  TextEditingController startDateController = TextEditingController();
  String startDate = "15-04-2019";

  String selectedCategory = "Equity Schemes";
  String selectedSubCategory = "Equity: Flexi Cap";
  String selectedFund = "1 Fund Selected";
  String selectedRollingPeriod = "3 Years";
  String rollingPeriods = "3 Year";
  String schemes =
      "Aditya Birla Sun Life Flexi Cap Fund - Growth - Regular Plan";
  String selectedValues =
      "Aditya Birla Sun Life Flexi Cap Fund - Growth - Regular Plan";
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
    isLoading = false;
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
    return 0;
  }

  Future getTopLumpsumFunds() async {
    if (fundList.isNotEmpty) return 0;
    Map data = await ResearchApi.getTopLumpsumFunds(
        amount: '',
        category: selectedSubCategory,
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
        schemes: schemes,
        category: selectedSubCategory,
        start_date: startDate,
        period: rollingPeriods,
        client_name: client_name);
    newRollingReturnCategoryList = data['rollingReturnsTable'];
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    rollingReturnCategoryList = List.from(data['rollingReturnsTable']);
    originalRollingReturnCategoryList = data['rollingReturnsTable'];

    // Remove items where scheme_name is "Equity: Flexi Cap"
    rollingReturnCategoryList
        .removeWhere((item) => item['scheme_name'] == selectedSubCategory);

    for (int i = 0; i < newRollingReturnCategoryList.length; i++) {
      if (newRollingReturnCategoryList[i]['scheme_name'] ==
          selectedSubCategory) {
        selectedIndex = i;
        break;
      }
    }
    if (newRollingReturnCategoryList.isNotEmpty) {
      var blackboxIndex = selectedIndex ?? 0;
      var item = newRollingReturnCategoryList[blackboxIndex];

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

    return 0;
  }

  @override
  void initState() {
    super.initState();
    btnNo = "1";
    startDateController.text = startDate;
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
                          showSchemeBottomSheet();
                        },
                        child: appBarColumn(
                            "Select Up To 5 Funds",
                            getFirst16(selectedFund),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showRollingPeriodBottomSheet();
                        },
                        child: appBarColumn(
                            "Rolling Period",
                            getFirst13(selectedRollingPeriod),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
                      ),
                      GestureDetector(
                        onTap: () {
                          startDateController.text = "";
                          startDate = "";
                          showDatePickerDialog(context);
                        },
                        child: appBarColumn(
                            "Start Date",
                            getFirst13(startDateController.text),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            body: displayPage(),
          );
        });
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
                  ? Utils.shimmerWidget(devHeight * 0.2,
                      margin: EdgeInsets.all(20))
                  : (originalRollingReturnCategoryList.isEmpty)
                      ? NoData()
                      : Column(
                          children: [
                            ListView.builder(
                              itemCount: rollingReturnCategoryList.length,
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
                  ? Utils.shimmerWidget(devHeight * 0.2,
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
                                    selectedSubCategory) {
                                  return returnsDistributionCard(data);
                                }
                              },
                            ),
                            SizedBox(height: devHeight * 0.01),
                            blackBoxDistribution(),
                          ],
                        )),
          SizedBox(height: devHeight * 0.3),
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
                  width: 266,
                  child: Text(selectedSubCategory,
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
                  child: Text(selectedSubCategory,
                      style:
                          AppFonts.f50014Black.copyWith(color: Colors.white))),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Negative",
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
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  Get.back();
                                  setState(() {
                                    selectedRollingPeriod =
                                        rollingPeriod[index];
                                    if (rollingPeriod[index] == "1 Month") {
                                      rollingPeriods = "1 Month";
                                    } else if (rollingPeriod[index] ==
                                        "1 Year") {
                                      rollingPeriods = "1 Year";
                                    } else if (rollingPeriod[index] ==
                                        "2 Years") {
                                      rollingPeriods = "2 Year";
                                    } else if (rollingPeriod[index] ==
                                        "3 Years") {
                                      rollingPeriods = "3 Year";
                                    } else if (rollingPeriod[index] ==
                                        "5 Years") {
                                      rollingPeriods = "5 Year";
                                    } else if (rollingPeriod[index] ==
                                        "7 Years") {
                                      rollingPeriods = "7 Year";
                                    } else if (rollingPeriod[index] ==
                                        "10 Years") {
                                      rollingPeriods = "10 Year";
                                    } else if (rollingPeriod[index] ==
                                        "15 Years") {
                                      rollingPeriods = "15 Year";
                                    } else {
                                      selectedRollingPeriod =
                                          rollingPeriod[index];
                                    }

                                    rollingReturnCategoryList = [];
                                  });
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: selectedRollingPeriod,
                                      value: rollingPeriod[index],
                                      onChanged: (val) async {
                                        Get.back();
                                        setState(() {
                                          selectedRollingPeriod =
                                              rollingPeriod[index];
                                          if (rollingPeriod[index] ==
                                              "1 Month") {
                                            rollingPeriods = "1 Month";
                                          } else if (rollingPeriod[index] ==
                                              "1 Year") {
                                            rollingPeriods = "1 Year";
                                          } else if (rollingPeriod[index] ==
                                              "2 Years") {
                                            rollingPeriods = "2 Year";
                                          } else if (rollingPeriod[index] ==
                                              "3 Years") {
                                            rollingPeriods = "3 Year";
                                          } else if (rollingPeriod[index] ==
                                              "5 Years") {
                                            rollingPeriods = "5 Year";
                                          } else if (rollingPeriod[index] ==
                                              "7 Years") {
                                            rollingPeriods = "7 Year";
                                          } else if (rollingPeriod[index] ==
                                              "10 Years") {
                                            rollingPeriods = "10 Year";
                                          } else if (rollingPeriod[index] ==
                                              "15 Years") {
                                            rollingPeriods = "15 Year";
                                          } else {
                                            selectedRollingPeriod =
                                                rollingPeriod[index];
                                          }

                                          rollingReturnCategoryList = [];
                                        });
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

                      return (selectedCategory == temp['name'])
                          ? selectedCategoryChip(
                              "${temp['name']}", "${temp['count']}")
                          : InkWell(
                              onTap: () async {
                                selectedCategory = temp['name'];
                                subCategoryList = [];
                                await getCategoryList();
                                EasyLoading.show();
                                await getTopLumpsumFunds();
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
                          selectedSubCategory = subCategoryList[index];
                          EasyLoading.show();
                          fundList = [];
                          await getTopLumpsumFunds();
                          EasyLoading.dismiss();
                          rollingReturnCategoryList = [];
                          bottomState(() {});
                          await getRollingReturnsVsCategory();

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
                                  selectedFund = "1 Fund Selected";
                                  fundList = [];
                                  rollingReturnCategoryList = [];
                                  bottomState(() {});
                                  await getTopLumpsumFunds();
                                  if (fundList.isNotEmpty) {
                                    setState(() {
                                      schemes = fundList[0]['scheme_amfi'];
                                      selectedValues =
                                          fundList[0]['scheme_amfi'];
                                    });
                                  }
                                  await getRollingReturnsVsCategory();
                                  Get.back();
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
    List<bool> isSelectedList = List.filled(fundList.length, false);
    List<String> selectedSchemes = List.filled(fundList.length, '');

    TextEditingController searchController = TextEditingController();
    // Check if selectedValues is not empty
    if (selectedValues.isNotEmpty) {
      // Split selectedValues into individual scheme IDs
      List<String> selectedItems = selectedValues.split(',');
      for (int i = 0; i < fundList.length; i++) {
        // Check if the current fund scheme ID is in the selectedItems list
        if (selectedItems.contains(fundList[i]['scheme_amfi'])) {
          // If it is, set the corresponding isSelectedList item to true
          isSelectedList[i] = true;
          // Also set the corresponding selectedSchemes item to the scheme ID
          selectedSchemes[i] = fundList[i]['scheme_amfi'];
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
          return Container(
            height: devHeight * 0.7,
            padding: EdgeInsets.all(7),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select Schemes",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                    itemCount: fundList.length,
                    itemBuilder: (context, index) {
                      if (searchController.text.isNotEmpty &&
                          !fundList[index]['scheme_amfi_short_name']
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase())) {
                        return SizedBox.shrink();
                      }
                      return CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(fundList[index]['scheme_amfi_short_name']),
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
                                    fundList[index]['scheme_amfi'];
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
                ElevatedButton(
                  onPressed: () async {
                    List<String> selectedItems = [];
                    for (int i = 0; i < isSelectedList.length; i++) {
                      if (isSelectedList[i]) {
                        selectedItems.add(selectedSchemes[i]);
                      }
                    }
                    selectedValues = selectedItems.join(',');
                    schemes = selectedValues;
                    selectedFund =
                        "${selectedItems.length} ${selectedItems.length > 1 ? "Funds" : "Fund"} Selected";
                    rollingReturnCategoryList = [];
                    bottomState(() {});
                    await getRollingReturnsVsCategory();
                    setState(() {});
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Config.appTheme.themeColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Apply'),
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
                  SizedBox(
                      width: 200,
                      child: Text(data["scheme_name"],
                          style: AppFonts.f50014Black
                              .copyWith(color: Config.appTheme.themeColor))),
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
                      Text(data["scheme_rating"],
                          style: TextStyle(color: Config.appTheme.themeColor)),
                      Icon(Icons.star, color: Config.appTheme.themeColor)
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
                  SizedBox(
                      width: 200,
                      child: Text(data["scheme_name"],
                          style: AppFonts.f50014Black
                              .copyWith(color: Config.appTheme.themeColor))),
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
                      Text(data["scheme_rating"],
                          style: TextStyle(color: Config.appTheme.themeColor)),
                      Icon(Icons.star, color: Config.appTheme.themeColor)
                    ]),
                  )
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
                        title: "Negative",
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

  void showDatePickerDialog(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      startDateController.text = formattedDate;
      startDate = formattedDate;
      setState(() {
        startDate = formattedDate;
      });
      rollingReturnCategoryList = [];
      await getRollingReturnsVsCategory();
    }
  }
}
