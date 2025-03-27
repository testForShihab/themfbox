import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/api/ResearchApi.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import 'package:mymfbox2_0/rp_widgets/NoData.dart';

class MFSipCalculator extends StatefulWidget {
  const MFSipCalculator({super.key});

  @override
  State<MFSipCalculator> createState() => _MFSipCalculatorState();
}

class _MFSipCalculatorState extends State<MFSipCalculator> {
  late double devWidth, devHeight;
  late int user_id;
  late String client_name;

  List allCategories = [];

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  late DateTime formattedDate;
  String endDate = "";
  String startDate = "";
  late DateTime currentDate;
  late DateTime previousDate;
  late String formattedPreviousDate;
  late String formattedStartDate;

  bool schemesLoaded = false;
  String selectedCategory = "Equity Schemes";
  String selectedSubCategory = "Equity: Large Cap";
  String selectedFund = "1 Fund Selected";

  String schemes = "ICICI Prudential Bluechip Fund - Growth";
  String selectedValues = "ICICI Prudential Bluechip Fund - Growth";

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
  List<String> sipFrequencyList = [
    "weekly",
    "Fortnightly",
    "Monthly",
    "Quarterly",
  ];
  String sipFrequency = "Monthly";
  List<String> sipAmountList = [
    "\u20b910,000",
    "\u20b91,00,000",
    "\u20b910,00,000",
  ];
  String sipAmount = "3000";

  TextStyle underlineText = TextStyle(
      color: Config.appTheme.themeColor,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w500,
      fontSize: 13);
  late TextEditingController sipAmountController;
  List subCategoryList = [];
  List sipCalculatorList = [];
  List cashFlowList = [];
  List fundList = [];
  bool isLoading = true;

  String selectedInvType = "Return Statistics\n(%)";
  int? selectedIndex;

  String scheme = "";

  Future getDatas() async {
    isLoading = true;
    await getBroadCategoryList();
    await getCategoryList();
    await getTopLumpsumFunds();
    await getSIPReturnCalculator();
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
      client_name: client_name,
    );
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

    schemesLoaded = true;
    return 0;
  }

  Future getSIPReturnCalculator() async {
    if (sipCalculatorList.isNotEmpty) return 0;
    Map data = await ResearchApi.getSIPReturnCalculator(
      user_id: user_id.toString(),
      client_name: client_name,
      category: selectedSubCategory,
      fund: schemes,
      amount: sipAmount,
      frequency: sipFrequency,
      startdate: startDate,
      enddate: endDate,
    );
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    sipCalculatorList = data['list'];

    return 0;
  }

  @override
  void initState() {
    super.initState();
    user_id = GetStorage().read("mfd_id") ?? GetStorage().read("user_id");
    client_name = GetStorage().read("client_name");

    currentDate = DateTime.now();
    // Get previous date
    previousDate = currentDate.subtract(Duration(days: 1));
    // Format dates
    DateFormat formatter = DateFormat("dd-MM-yyyy");
    formattedPreviousDate = formatter.format(previousDate);

    formattedDate = DateTime(
        currentDate.year - 1, currentDate.month + 1, currentDate.day - 1);
    // Assign endDate
    startDate = formatter.format(formattedDate);
    endDate = formattedPreviousDate;
    startDateController.text = startDate;
    endDateController.text = endDate;
    sipAmountController = TextEditingController(text: "3000");
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
              toolbarHeight: 260,
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
                        "MF SIP Calculator",
                        style: AppFonts.f50014Black
                            .copyWith(fontSize: 18, color: Colors.white),
                      ),
                      //Spacer(),
                      //MfAboutIcon(context: context),
                    ],
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
                          schemesLoaded
                              ? showSchemeBottomSheet()
                              : Utils.shimmerWidget(devHeight * 0.2,
                                  margin: EdgeInsets.all(20));
                        },
                        child: appBarColumn(
                            "Select Up To 5 Funds",
                            getFirst16(selectedFund),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showSipFrequencyBottomSheet();
                        },
                        child: appBarColumn(
                            "SIP Frequency",
                            getFirst13(sipFrequency),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 30.0),
                              child: Text(
                                "SIP Amount",
                                style: AppFonts.f40013
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            Container(
                              width: devWidth * 0.40,
                              height: devHeight * 0.04,
                              margin: EdgeInsets.only(top: 4, left: 28),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextFormField(
                                cursorColor: Colors.white,
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(5),
                                ],
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(
                                      color:
                                          Colors.white), // Style for label text
                                  // Alternatively, you can use hintText
                                  hintStyle: TextStyle(color: Colors.white),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 13,
                                      horizontal: 8), // Style for hint text
                                ),
                                style: TextStyle(color: Colors.white),
                                controller: sipAmountController,
                                onChanged: (text) async {
                                  if (text.length <= 5) {
                                    sipAmount = text;
                                    sipCalculatorList = [];
                                    await getSIPReturnCalculator();
                                    setState(() {});
                                  } else {
                                    sipAmountController.text =
                                        text.substring(0, 5);
                                    sipAmountController.selection =
                                        TextSelection.fromPosition(
                                      TextPosition(
                                          offset:
                                              sipAmountController.text.length),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     showSipAmountBottomSheet();
                      //   },
                      //   child: appBarColumn(
                      //       "SIP Amount",
                      //       getFirst13(sipAmount),
                      //       Icon(Icons.keyboard_arrow_down,
                      //           color: Config.appTheme.themeColor)),
                      // ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDatePickerDialog(context, 1);
                        },
                        child: appBarColumn(
                            "Start Date",
                            getFirst13(startDateController.text),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDatePickerDialog(context, 2);
                        },
                        child: appBarColumn(
                            "End Date",
                            getFirst13(endDateController.text),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
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

  Widget displayPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (isLoading
              ? Utils.shimmerWidget(devHeight * 0.2, margin: EdgeInsets.all(20))
              : (sipCalculatorList.isEmpty)
                  ? NoData()
                  : Column(
                      children: [
                        SizedBox(height: 16),
                        ListView.builder(
                          itemCount: sipCalculatorList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Map data = sipCalculatorList[index];
                            return returnsSipCard(data, index);
                          },
                        ),
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

  showSipFrequencyBottomSheet() {
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
                      Text("Select SIP Frequency",
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
                            itemCount: sipFrequencyList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    sipFrequency = sipFrequencyList[index];

                                    sipCalculatorList = [];
                                  });
                                  Get.back();
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: sipFrequency,
                                      value: sipFrequencyList[index],
                                      onChanged: (val) async {
                                        setState(() {
                                          sipFrequency =
                                              sipFrequencyList[index];

                                          sipCalculatorList = [];
                                        });
                                        Get.back();
                                      },
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          sipFrequencyList[index],
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

  showSipAmountBottomSheet() {
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
                      Text("Select Sip Amount",
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
                            itemCount: sipAmountList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  sipAmount = sipAmountList[index];
                                  Get.back();
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: sipAmount,
                                      value: sipAmountList[index],
                                      onChanged: (val) async {
                                        Get.back();
                                        setState(() {
                                          sipAmount = sipAmountList[index];

                                          sipCalculatorList = [];
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          sipAmountList[index],
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
                          selectedFund = "1 Fund Selected";
                          fundList = [];
                          sipCalculatorList = [];
                          bottomState(() {});
                          await getTopLumpsumFunds();
                          if (fundList.isNotEmpty) {
                            setState(() {
                              schemes = fundList[0]['scheme_amfi'];
                              selectedValues = fundList[0]['scheme_amfi'];
                            });
                          }
                          await getSIPReturnCalculator();
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
                                  sipCalculatorList = [];
                                  bottomState(() {});
                                  await getTopLumpsumFunds();
                                  if (fundList.isNotEmpty) {
                                    setState(() {
                                      schemes = fundList[0]['scheme_amfi'];
                                      selectedValues =
                                          fundList[0]['scheme_amfi'];
                                    });
                                  }
                                  await getSIPReturnCalculator();
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

    if (selectedValues.isNotEmpty) {
      List<String> selectedItems = selectedValues.split(',');
      for (int i = 0; i < fundList.length; i++) {
        if (selectedItems.contains(fundList[i]['scheme_amfi'])) {
          isSelectedList[i] = true;
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
                    selectedFund = "${selectedItems.length} Funds Selected";
                    sipCalculatorList = [];
                    bottomState(() {});
                    await getSIPReturnCalculator();
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

  Widget returnsSipCard(Map data, int index) {
    double investedAmount = data['invested_amount'] ?? 0;
    double currentValue = data['current_value'] ?? 0;
    String roundedCurrentValue = currentValue.toStringAsFixed(0);
    double currentXirr = data['returns'] ?? 0;
    double units = data['units'] ?? 0;
    int noOfInstallment = data['no_of_installment'] ?? 0;
    double endValue = data['current_value_today'] ?? 0;
    String roundedEndValue = endValue.toStringAsFixed(0);
    String schemeRating =
        data["scheme_rating"] != null ? data["scheme_rating"].toString() : 'NR';
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
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
                  SizedBox(width: 5),
                  SizedBox(
                      width: 210,
                      child: Text(data["scheme_amfi_short_name"],
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
                      Text(schemeRating,
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
                        title: "Invested",
                        value:
                            "$rupee ${Utils.formatNumber(investedAmount, isAmount: false)}",
                      ),
                      ColumnText(
                          title: "Current Value",
                          value:
                              "$rupee ${Utils.formatNumber(double.parse(roundedCurrentValue), isAmount: false)}",
                          alignment: CrossAxisAlignment.center),
                      ColumnText(
                          title: "Current XIRR",
                          value: "$currentXirr%",
                          valueStyle: AppFonts.f50014Black.copyWith(
                              color: (currentXirr > 0)
                                  ? Config.appTheme.defaultProfit
                                  : Config.appTheme.defaultLoss),
                          alignment: CrossAxisAlignment.end),
                    ],
                  ),
                ],
              ),
            ),
            DottedLine(),
            //3rd row
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ColumnText(
                        title: "Installments",
                        value: noOfInstallment.toString(),
                      ),
                      ColumnText(
                          title: "End Value",
                          value:
                              "$rupee ${Utils.formatNumber(double.parse(roundedEndValue), isAmount: false)}",
                          alignment: CrossAxisAlignment.center),
                      ColumnText(
                          title: "Units",
                          value: Utils.formatNumber(units),
                          alignment: CrossAxisAlignment.end),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      showCashFlowBottomSheet(
                          index, data["scheme_amfi_short_name"], data["logo"]);
                    },
                    child: Text(
                      "View Cash Flow",
                      style: underlineText,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showCashFlowBottomSheet(int index, String schemeName, String logo) {
    cashFlowList = [];
    cashFlowList = sipCalculatorList[index]['sip_list'];
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
                      Text("  Cash Flow",
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 0, 14),
                    child: Row(
                      children: [
                        Image.network(logo ?? "", height: 30),
                        SizedBox(width: 5),
                        SizedBox(
                            width: 280,
                            child: Text(schemeName,
                                style: AppFonts.f50014Black.copyWith(
                                    color: Config.appTheme.themeColor))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 0, 14),
                    child: Row(
                      children: [
                        Text(
                          "SIP Cashflow",
                          style: AppFonts.f50014Grey,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      // Wrap ListView with SingleChildScrollView
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: cashFlowList.length,
                          itemBuilder: (context, index) {
                            Map data = cashFlowList[index];

                            return cashFlowTile(data);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  Widget cashFlowTile(Map data) {
    String navDate = data["nav_date"];
    String formattedNavDate = formatDate(navDate);
    double cumulativeInvestedAmount = data["cumulative_invested_amount"] ?? 0;
    double nav = data["nav"] ?? 0;
    double cumulativeUnits = data["cumulative_units"] ?? 0;
    double currentValue = data["current_value"] ?? 0;
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16.0), // Add padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedNavDate,
                style: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.themeColor),
              ),
              Text(
                  (cumulativeInvestedAmount > 0)
                      ? "+$rupee ${Utils.formatNumber(cumulativeInvestedAmount, isAmount: false)}"
                      : "-$rupee ${Utils.formatNumber(cumulativeInvestedAmount, isAmount: false)}",
                  style: AppFonts.f50014Black.copyWith(
                      color: (cumulativeInvestedAmount > 0)
                          ? Config.appTheme.defaultProfit
                          : Config.appTheme.defaultLoss)),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Nav",
                value: "$nav",
                valueStyle: AppFonts.f50014Black,
              ),
              ColumnText(
                title: "Units",
                value: Utils.formatNumber(cumulativeUnits),
                valueStyle: AppFonts.f50014Black,
                alignment: CrossAxisAlignment.center,
              ),
              ColumnText(
                title: "Current Value",
                value:
                    "$rupee ${Utils.formatNumber(currentValue.round(), isAmount: false)}",
                valueStyle: AppFonts.f50014Black,
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showDatePickerDialog(BuildContext context, int dateType) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      if (dateType == 1) {
        startDateController.text = formattedDate;
        startDate = formattedDate;
        setState(() {
          startDate = formattedDate;
        });
      } else {
        endDateController.text = formattedDate;
        endDate = formattedDate;
        setState(() {
          endDate = formattedDate;
        });
      }
      sipCalculatorList = [];
      await getSIPReturnCalculator();
    }
  }

  String formatDate(String dateString) {
    // Parse the input date string
    DateTime date = DateTime.parse(dateString);

    // Create a date format pattern
    final DateFormat formatter = DateFormat('dd-MM-yyyy');

    // Format the date
    return formatter.format(date);
  }
}
