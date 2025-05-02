import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
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

import '../main.dart';

class MFSipCalculator extends StatefulWidget {
  const MFSipCalculator({super.key});

  @override
  State<MFSipCalculator> createState() => _MFSipCalculatorState();
}

class _MFSipCalculatorState extends State<MFSipCalculator> {
  final RollingReturnsController controller =
      Get.put(RollingReturnsController());

  late double devWidth, devHeight;
  late int user_id;
  late String client_name;

  List allCategories = [];

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  late DateTime formattedDate;
  // String endDate = "";
  // String startDate = "";
  late DateTime currentDate;
  late DateTime previousDate;
  late String formattedPreviousDate;
  late String formattedStartDate;

  bool schemesLoaded = false;

  // String selectedCategory = "Equity Schemes";
  // String selectedSubCategory = "Equity: Large Cap";
  // String selectedFund = "1 Fund Selected";

  // String schemes = "ICICI Prudential Bluechip Fund - Growth";
  // String selectedValues = "ICICI Prudential Bluechip Fund - Growth";

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
    "Fortnightly",
    "Monthly",
    "Quarterly",
  ];
  // String sipFrequency = "Monthly";
  List<String> sipAmountList = [
    "\u20b910,000",
    "\u20b91,00,000",
    "\u20b910,00,000",
  ];
  // String sipAmount = "3000";

  TextStyle underlineText = TextStyle(
      color: Config.appTheme.themeColor,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w500,
      fontSize: 13);
  // late TextEditingController sipAmountController;
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
        category: controller.selectedCategory.value, client_name: client_name);
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
      category: controller.selectedSubCategory.value,
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
      category: controller.selectedSubCategory.value,
      fund: controller.schemes.value,
      amount: controller.sipAmount.value,
      frequency: controller.sipFrequency.value,
      startdate: controller.startDate.value,
      enddate: controller.endDate.value,
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
    controller.startDate.value = formatter.format(formattedDate);
    controller.endDate.value = formattedPreviousDate;
    startDateController.text = controller.startDate.value;
    endDateController.text = controller.endDate.value;
    // controller.sipAmountController = TextEditingController();
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
                          child: Obx(
                            () => appBarColumn(
                                "Category",
                                getFirst13(
                                    controller.selectedSubCategory.value),
                                Icon(Icons.keyboard_arrow_down,
                                    color: Config.appTheme.themeColor)),
                          )),
                      GestureDetector(
                          onTap: () {
                            schemesLoaded
                                ? showSchemeBottomSheet()
                                : Utils.shimmerWidget(devHeight * 0.2,
                                    margin: EdgeInsets.all(20));
                          },
                          child: Obx(
                            () => appBarColumn(
                                "Select Up To 5 Funds",
                                getFirst16(controller.selectedFund.value),
                                Icon(Icons.keyboard_arrow_down,
                                    color: Config.appTheme.themeColor)),
                          ))
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
                        child:Obx(() =>  appBarColumn(
                            "SIP Frequency",
                            getFirst13(controller.sipFrequency.value),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),)
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
                                border: Border.all(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0XFFDEE6E6),
                              ),

                              child: TextFormField(
                                cursorColor: Config.appTheme.themeColor,
                                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(8),
                                ],
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(color: Config.appTheme.themeColor),
                                  hintStyle: TextStyle(color: Config.appTheme.themeColor),
                                  contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 8),
                                ),
                                style: TextStyle(color: Config.appTheme.themeColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                controller: controller.sipAmountController,
                                onChanged: (text) async {
                                  if (text.length <= 8) {
                                    controller.sipAmount.value = text;
                                  } else {
                                    controller.sipAmountController.text = text.substring(0, 8);
                                    controller.sipAmountController.selection = TextSelection.fromPosition(
                                      TextPosition(offset: controller.sipAmountController.text.length),
                                    );
                                  }
                                },
                              ),
                            )

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
                        child:Obx(() =>  appBarColumn1(
                            "Start Date",
                            getFirst13(controller.startDate.value),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor))),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDatePickerDialog(context, 2);
                        },
                        child:Obx(() =>  appBarColumn1(
                            "End Date",
                            getFirst13(controller.endDate.value),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor))),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (controller.startDate.value.isNotEmpty) {
                            DateTime startDate = convertStrToDt(controller.startDate.value);
                            DateTime endDate = convertStrToDt(controller.endDate.value);
                            /*if(endDate.day <= startDate.day) {
                              Utils.showError(context, "Please select a valid start date and end date.");
                              return;
                            }*/
                            DateTime oneMonthBeforeEndDate = DateTime(endDate.year, endDate.month - 1, endDate.day);

                            DateTime threeMonthsBeforeEndDate = DateTime(endDate.year, endDate.month - 3, endDate.day);

                            DateTime fourteenDaysBeforeEndDate = endDate.subtract(Duration(days: 14));

                            if (controller.sipFrequency.value == "Monthly" && startDate.isAfter(oneMonthBeforeEndDate)) {
                              Utils.showError(context, "Please select a valid start date and end date.");
                             // Utils.showError(context, "Start date must be at least one month before the end date.");
                              return;
                            }
                            if (controller.sipFrequency.value == "Quarterly" && startDate.isAfter(threeMonthsBeforeEndDate)) {
                              Utils.showError(context, "Please select a valid start date and end date.");
                             // Utils.showError(context, "Start date must be at least three months before the end date.");
                              return;
                            }
                            if (controller.sipFrequency.value == "Fortnightly" && startDate.isAfter(fourteenDaysBeforeEndDate)) {
                              Utils.showError(context, "Please select a valid start date and end date.");
                              //Utils.showError(context, "Start date must be at least 14 days before the end date.");
                              return;
                            }

                            // Proceed with calculations
                            setState(() {});
                            sipCalculatorList = [];
                            getSIPReturnCalculator();
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 22),
                          padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                          decoration: BoxDecoration(
                            color: Config.appTheme.universalTitle,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text("Submit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                      )

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
          SizedBox(height: devHeight * 0.01),
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
                                    controller.sipFrequency.value = sipFrequencyList[index];

                                    // sipCalculatorList = [];
                                  Get.back();
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: controller.sipFrequency.value,
                                      value: sipFrequencyList[index],
                                      onChanged: (val) async {
                                          controller.sipFrequency.value =
                                              sipFrequencyList[index];

                                          // sipCalculatorList = [];
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

  // showSipAmountBottomSheet() {
  //   showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(10), topRight: Radius.circular(10)),
  //       ),
  //       builder: (context) {
  //         return StatefulBuilder(builder: (_, bottomState) {
  //           return Container(
  //             height: devHeight * 0.7,
  //             padding: EdgeInsets.all(7),
  //             child: Column(
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text("Select Sip Amount",
  //                         style: AppFonts.f50014Grey.copyWith(
  //                             fontSize: 16, color: Color(0xff242424))),
  //                     IconButton(
  //                         onPressed: () {
  //                           Get.back();
  //                         },
  //                         icon: Icon(Icons.close)),
  //                   ],
  //                 ),
  //                 Divider(
  //                   color: Color(0XFFDFDFDF),
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Expanded(
  //                   child: Container(
  //                       padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
  //                       child: ListView.builder(
  //                           padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
  //                           itemCount: sipAmountList.length,
  //                           scrollDirection: Axis.vertical,
  //                           itemBuilder: (context, index) {
  //                             return GestureDetector(
  //                               onTap: () async {
  //                                 controller.sipAmount.value = sipAmountList[index];
  //                                 Get.back();
  //                                 setState(() {});
  //                               },
  //                               child: Row(
  //                                 children: [
  //                                   Radio(
  //                                     activeColor: Config.appTheme.themeColor,
  //                                     groupValue: sipAmount,
  //                                     value: sipAmountList[index],
  //                                     onChanged: (val) async {
  //                                       Get.back();
  //                                       setState(() {
  //                                         sipAmount = sipAmountList[index];
  //
  //                                         sipCalculatorList = [];
  //                                       });
  //                                     },
  //                                   ),
  //                                   Expanded(
  //                                     child: Container(
  //                                       child: Text(
  //                                         sipAmountList[index],
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             );
  //                           })),
  //                 ),
  //               ],
  //             ),
  //           );
  //         });
  //       });
  // }

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
                      return (controller.selectedCategory.value == temp['name'])
                          ? selectedCategoryChip(
                              "${temp['name']}", "${temp['count']}")
                          : InkWell(
                              onTap: () async {
                                controller.selectedCategory.value =
                                    temp['name'];
                                subCategoryList = [];
                                await getCategoryList();
                                EasyLoading.show();
                                await getTopLumpsumFunds();
                                EasyLoading.dismiss();
                                bottomState(() { });
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
                          controller.selectedSubCategory.value =
                              subCategoryList[index];
                          controller.selectedFund.value = "1 Fund Selected";
                          fundList = [];
                          sipCalculatorList = [];
                          await getTopLumpsumFunds();
                          if (fundList.isNotEmpty) {
                            controller.schemes.value = fundList[0]['scheme_amfi'];
                            controller.selectedValues.value= fundList[0]['scheme_amfi'];
                          }
                          // await getSIPReturnCalculator();
                          Get.back();
                        },
                        child: Row(
                          children: [
                            Radio(
                                value: subCategoryList[index],
                                groupValue:
                                    controller.selectedSubCategory.value,
                                activeColor: Config.appTheme.themeColor,
                                onChanged: (val) async {
                                  controller.selectedSubCategory.value =
                                      subCategoryList[index];
                                  controller.selectedFund.value =
                                      "1 Fund Selected";
                                  fundList = [];
                                  sipCalculatorList = [];
                                  await getTopLumpsumFunds();
                                  if (fundList.isNotEmpty) {
                                    controller.schemes.value = fundList[0]['scheme_amfi'];
                                    controller.selectedValues.value = fundList[0]['scheme_amfi'];
                                  }
                                  // await getSIPReturnCalculator();
                                  Get.back();
                                }),
                            // Container(
                            //     height: 30,
                            //     width: 30,
                            //     decoration: BoxDecoration(
                            //         color: Color(0xffF8DFD5),
                            //         borderRadius: BorderRadius.circular(5)),
                            //     child: Icon(Icons.bar_chart,
                            //         color: Colors.red, size: 20)),
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

    if (controller.selectedValues.value.isNotEmpty) {
      List<String> selectedItems = controller.selectedValues.value.split(',');
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
          // Get list of selected funds
          List<Map<String, dynamic>> selectedFunds = [];
          for (int i = 0; i < isSelectedList.length; i++) {
            if (isSelectedList[i]) {
              selectedFunds.add({
                'index': i,
                'scheme': fundList[i]['scheme_amfi_short_name'],
                'scheme_amfi': fundList[i]['scheme_amfi']
              });
            }
          }

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
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        List<String> selectedItems = [];
                        for (int i = 0; i < isSelectedList.length; i++) {
                          if (isSelectedList[i]) {
                            selectedItems.add(selectedSchemes[i]);
                          }
                        }
                        controller.selectedValues.value = selectedItems.join(',');
                        controller.schemes.value = controller.selectedValues.value;
                        controller.selectedFund.value =
                            "${selectedItems.length} Funds Selected";
                        sipCalculatorList = [];
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Config.appTheme.buttonColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Apply'),
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

                // Selected Schemes Horizontal List
                if (selectedFunds.isNotEmpty) ...[
                  Column(
                    children: [
                      Container(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedFunds.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Config.appTheme.themeColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Config.appTheme.themeColor,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      selectedFunds[index]['scheme'],
                                      style: TextStyle(
                                        color: Config.appTheme.themeColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  InkWell(
                                    onTap: () {
                                      bottomState(() {
                                        int originalIndex = selectedFunds[index]['index'];
                                        isSelectedList[originalIndex] = false;
                                        selectedSchemes[originalIndex] = '';
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Config.appTheme.themeColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                ],

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

  Widget appBarColumn1(String title, String value, Widget suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14)),
        Container(
          width: devWidth * 0.324,
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
              padding: const EdgeInsets.fromLTRB(14, 14, 0, 0),
              child: Row(
                children: [
                  Image.network(data["logo"] ?? "", height: 30),
                  SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data["scheme_amfi_short_name"],
                          style: AppFonts.f50014Black
                              .copyWith(color: Config.appTheme.themeColor),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis, // Prevents overflow
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Scheme : ",
                              style: AppFonts.f40013.copyWith(fontSize: 12),
                              softWrap: true,
                            ),
                            Flexible(
                              child: Text(
                                data["scheme_category"],
                                style: AppFonts.f50014Grey.copyWith(
                                    color: Colors.black, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //     width: 210,
                  //     child: Text(data["scheme_amfi_short_name"],
                  //         style: AppFonts.f50014Black
                  //             .copyWith(color: Config.appTheme.themeColor))),
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
                  //     Text(schemeRating,
                  //         style: TextStyle(color: Config.appTheme.themeColor)),
                  //     Icon(Icons.star, color: Config.appTheme.themeColor)
                  //   ]),
                  // )
                ],
              ),
            ),
            DottedLine(),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
              child: Column(
                children: [
                  SizedBox(height: 6,),
                  rpRow(
                    lhead: "Launch date",
                    //rSubHead:data["sip_list"][0]['nav_date'],
                    lSubHead:data["sip_list"][0]['nav_date_str'],
                    rhead: "NAV date",
                    rSubHead:data["nav_date_str"],
                    chead: "NAV",
                    cSubHead: "${data['nav']}",
                  ),
                  SizedBox(height: 10,),
                  rpRow(
                    lhead: "Units",
                    lSubHead: Utils.navformatNumber(units),
                    rhead: "Installments",
                    rSubHead: "${data['no_of_installment']}",
                    chead: "Investment",
                    cSubHead: "$rupee ${Utils.formatNumber(investedAmount, isAmount: false)}",),
                  SizedBox(height: 10,),
                  rpRow(
                    lhead: "SIP Value \n as on end date",
                    lSubHead:"$rupee ${Utils.formatNumber(double.parse(roundedCurrentValue), isAmount: false)}",
                    rhead: "XIRR (%)",
                    rSubHead: "$currentXirr",
                  valueStyle: AppFonts.f50014Black.copyWith(color: (currentXirr > 0) ? Config.appTheme.defaultProfit
                      : Config.appTheme.defaultLoss),
                  chead: "",
                  cSubHead: ""),
                  SizedBox(height: 10,),
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
                data["nav_date_str"],
                style: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.themeColor),
              ),
              Text( "$rupee ${Utils.formatNumber(cumulativeInvestedAmount, isAmount: false)}"
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "NAV",
                value: "$rupee $nav",
                valueStyle: AppFonts.f50014Black,
              ),
              ColumnText(
                title: "Units",
                value: Utils.navformatNumber(cumulativeUnits),
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

  Widget rpRow({
    required String lhead,
    required String lSubHead,
    required String rhead,
    required String rSubHead,
    required String chead,
    required String cSubHead,
    final TextStyle? valueStyle,
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
                alignment: CrossAxisAlignment.end)),
      ],
    );
  }

  // void showDatePickerDialog(BuildContext context, int dateType) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate:
  //         dateType == 1 ? convertStrToDt(controller.startDate.value) : convertStrToDt(controller.endDate.value),
  //     firstDate: DateTime(1947),
  //     lastDate: DateTime.now(),
  //   );
  //
  //   if (pickedDate != null) {
  //     String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
  //     DateTime selectedDate = pickedDate;
  //
  //     int minDaysGap = 30; // Default for "Monthly"
  //      if (controller.sipFrequency.value == "Fortnightly") {
  //       minDaysGap = 15;
  //     } else if (controller.sipFrequency.value == "Quarterly") {
  //       minDaysGap = 90;
  //     }
  //
  //     if (dateType == 1) {
  //       // Selecting Start Date: Must be at least minDaysGap before End Date
  //       if (controller.endDate.value.isNotEmpty) {
  //         DateTime existingEndDate = convertStrToDt(controller.endDate.value);
  //         DateTime minStartDate =
  //             existingEndDate.subtract(Duration(days: minDaysGap));
  //
  //         if (!selectedDate.isBefore(minStartDate)) {
  //           Utils.showError(context,
  //               'Start date must be at least $minDaysGap days before the end date.');
  //           return;
  //         } else {
  //           startDateController.text = formattedDate;
  //           controller.startDate.value = formattedDate;
  //           // sipCalculatorList = [];
  //           // await getSIPReturnCalculator();
  //         }
  //       }
  //     } else {
  //       if (controller.startDate.value.isNotEmpty) {
  //         DateTime existingStartDate = convertStrToDt(controller.startDate.value);
  //         DateTime minEndDate =
  //             existingStartDate.add(Duration(days: minDaysGap));
  //
  //         if (!selectedDate.isAfter(minEndDate)) {
  //           Utils.showError(context,
  //               'End date must be at least $minDaysGap days after the start date.');
  //           return;
  //         } else {
  //           endDateController.text = formattedDate;
  //           controller.endDate.value = formattedDate;
  //           // sipCalculatorList = [];
  //           // await getSIPReturnCalculator();
  //         }
  //       }
  //     }
  //   }
  // }
  void showDatePickerDialog(BuildContext context, int dateType) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
      dateType == 1 ? convertStrToDt(controller.startDate.value) : convertStrToDt(controller.endDate.value),
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      if (dateType == 1) {
        startDateController.text = formattedDate;
        controller.startDate.value = formattedDate;
          controller.startDate.value = formattedDate;
      }
      if (dateType == 2){
        endDateController.text = formattedDate;
        controller.endDate.value = formattedDate;
        controller.endDate.value = formattedDate;
      }
      // sipCalculatorList = [];
      // await getSIPReturnCalculator();
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

class RollingReturnsController extends GetxController {
  final selectedRadioIndex = RxInt(-1);

  var selectedCategory = "Equity Schemes".obs;
  var selectedSubCategory = "Equity: Large Cap".obs;
  var selectedFund = "1 Fund Selected".obs;
  var schemes = "ICICI Prudential Bluechip Fund - Growth".obs;
  var selectedValues = "ICICI Prudential Bluechip Fund - Growth".obs;
  var sipFrequency = "Monthly".obs;
  var sipAmount = "3000".obs;
  var startDate = "".obs;
  var endDate = "".obs;

  var shouldRefresh = false.obs;
  var isProcessingSelection = false.obs;
  late TextEditingController sipAmountController;
  @override
  void onInit() {
    super.onInit();
    shouldRefresh.value = true;
    sipAmountController = TextEditingController(text: '3000');
  }

  @override
  void onClose() {
    sipAmountController.dispose();
    super.onClose();
  }

  void selectScheme(String schemeName, int index) {
    if (isProcessingSelection.value) return;
  }


}
