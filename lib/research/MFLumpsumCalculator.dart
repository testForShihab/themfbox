import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/api/ResearchApi.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import 'package:mymfbox2_0/rp_widgets/NoData.dart';

class MFLumpsumCalculator extends StatefulWidget {
  const MFLumpsumCalculator({super.key});

  @override
  State<MFLumpsumCalculator> createState() => _MFLumpsumCalculatorState();
}

class _MFLumpsumCalculatorState extends State<MFLumpsumCalculator> {
  final RollingReturnsController controller =
      Get.put(RollingReturnsController());
  late double devWidth, devHeight;
  List allCategories = [];
  late int user_id;
  late String client_name;

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  String selectedFund = "1 Fund Selected";
  int selectedRadioIndex = 0;
  String schemes = "ICICI Prudential Value Discovery Fund - Growth";
  String selectedValues = "ICICI Prudential Value Discovery Fund - Growth";

  List lumpsumAmountCalc = [];

  List containingSchemes = [];
  List notContainingSchemes = [];

  List<String> lumpsumAmountList = [
    "\u20b910,000",
    "\u20b91,00,000",
    "\u20b910,00,000",
  ];

  List fundList = [];
  bool isLoading = true;

  bool schemesLoaded = false;
  TextStyle underlineText = TextStyle(
      color: Config.appTheme.themeColor, decoration: TextDecoration.underline);

  int? selectedIndex;

  String scheme = "";

  Future getDatas() async {
    isLoading = true;
    await getTopLumpsumFunds();
    await getLumpSumReturns();
    isLoading = false;
    return 0;
  }

  Future getTopLumpsumFunds() async {
    if (fundList.isNotEmpty) return 0;
    Map data = await ResearchApi.getTopLumpsumFunds(
      amount: '',
      category: '',
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
      schemesLoaded = true;
      print("selectedFund $selectedFund");
      print("fund name ${fund['scheme_amfi']}");
    });
    print("fundList.length ${fundList.length}");
    return 0;
  }

  Future getLumpSumReturns() async {
    if (lumpsumAmountCalc.isNotEmpty) return 0;
    Map data = await ResearchApi.getLumpSumReturns(
        user_id: user_id,
        client_name: client_name,
        scheme: schemes,
        amount: controller.lumpsumAmount.value,
        startdate: controller.startDate.value,
        enddate: controller.endDate.value);

    lumpsumAmountCalc = data['schemePerformance_list'];
    containingSchemes = [];
    notContainingSchemes = [];

    for (var scheme in lumpsumAmountCalc) {
      bool isValidMF = scheme['scheme_amfi_code'] != null &&
          scheme['scheme_amfi_code'].toString().isNotEmpty;
      if (isValidMF && schemes.contains(scheme['scheme'])) {
        containingSchemes.add(scheme);
      } else {
        notContainingSchemes.add(scheme);
      }
    }

    print("Containing Schemes:");
    containingSchemes.forEach((scheme) {
      print(scheme['scheme']);
    });

    print("Not Containing Schemes:");
    notContainingSchemes.forEach((scheme) {
      print(scheme['scheme']);
    });
    return 0;
  }

  Timer? _debounce;

  late Future future;

  @override
  void initState() {
    super.initState();
    user_id = GetStorage().read("mfd_id") ?? GetStorage().read("user_id");
    client_name = GetStorage().read("client_name");
    future = getDatas();
  }

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
  }

  void _refreshData() {
    setState(() {
      future = getDatas();
    });
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: future,
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
                        "MF Lumpsum Calculator",
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lumpsum Amount",
                              style: AppFonts.f40013
                                  .copyWith(color: Colors.white, fontSize: 14),
                            ),
                            Container(
                              width: devWidth * 0.40,
                              height: devHeight * 0.04,
                              margin: EdgeInsets.only(top: 4, left: 0),
                              padding: EdgeInsets.only(left: 8, bottom: 5),
                              decoration: BoxDecoration(
                                color: Color(0XFFDEE6E6),
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
                                  LengthLimitingTextInputFormatter(9)
                                ],
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  // filled: true,
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintStyle: TextStyle(color: Colors.white),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 11),
                                ),
                                style: TextStyle(color: Config.appTheme.themeColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                controller: controller.lumpsumAmountController,
                                onChanged: (text) async {
                                  if (_debounce?.isActive ?? false)
                                    _debounce?.cancel();
                                  _debounce =
                                      Timer(const Duration(milliseconds: 500),
                                          () async {
                                    controller.lumpsumAmount.value = text;

                                  });
                                },
                              ),
                            )
                          ],
                        ),
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
                      ),
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
                        child: Obx(() => appBarColumn1(
                            "Start Date",
                            getFirst13(controller.startDate.value),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor))),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDatePickerDialog(context, 2);
                        },
                        child: Obx(() => appBarColumn1(
                            "End Date",
                            getFirst13(controller.endDate.value),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor))),
                      ),
                      GestureDetector(
                        onTap: () async {
                          DateTime endDate =
                              convertStrToDt(controller.endDate.value);
                          DateTime startDate =
                              convertStrToDt(controller.startDate.value);
                          if (endDate.year == startDate.year &&
                              endDate.month == startDate.month &&
                              endDate.day == startDate.day) {
                            Utils.showError(context,
                                "Please select a valid start date and end date.");
                            return;
                          }

                          lumpsumAmountCalc = [];
                          containingSchemes = [];
                          notContainingSchemes = [];
                          _refreshData();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 22),
                          padding:
                              EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text("Submit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
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
              : (lumpsumAmountCalc.isEmpty)
                  ? NoData()
                  : Column(
                      children: [
                        SizedBox(height: 8),
                        ListView.builder(
                          itemCount: containingSchemes.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Map data = containingSchemes[index];
                            return returnsMFLumpsumCard(data);
                          },
                        ),
                        ListView.builder(
                          itemCount: notContainingSchemes.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Map notContainingData = notContainingSchemes[index];
                            return blackBoxStatistics(notContainingData);
                          },
                        ),
                      ],
                    )),
          SizedBox(height: devHeight * 0.03),
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

  Widget blackBoxStatistics(Map data) {
    double cagrReturns = data["returns"] ?? 0;
    double absoluteReturns = data["absolute_returns"] ?? 0;
    double endValue = data["current_value"] ?? 0;
    double roundedEndValue = (endValue /*  /100  */).roundToDouble();
    double profit = data["current_value"] - data["current_cost"] ?? 0;
    double roundedProfit = (profit /* /100 */).roundToDouble();
    //String roundedEndValue = endValue.toStringAsFixed(0) ;
    //String roundedProfit = profit.toStringAsFixed(0);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.symmetric(horizontal: devWidth * 0.04),
        padding:
            EdgeInsets.symmetric(horizontal: devWidth * 0.04, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 266,
                    child: Text(data['scheme'],
                        style: AppFonts.f50014Black
                            .copyWith(color: Colors.white))),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnText(
                    title: "Value as on end date",
                    value:
                        "$rupee ${Utils.formatNumber(roundedEndValue, isAmount: false)}",
                    titleStyle: AppFonts.f40013.copyWith(
                        color: Config.appTheme.placeHolderInputTitleAndArrow),
                    valueStyle:
                        AppFonts.f50014Black.copyWith(color: Colors.white),
                    alignment: CrossAxisAlignment.start),
                ColumnText(
                    title: "Profit",
                    value:
                        "$rupee ${Utils.formatNumber(roundedProfit, isAmount: false)}",
                    titleStyle: AppFonts.f40013.copyWith(
                        color: Config.appTheme.placeHolderInputTitleAndArrow),
                    valueStyle:
                        AppFonts.f50014Black.copyWith(color: Colors.white),
                    alignment: CrossAxisAlignment.end),
              ],
            ),
            DottedLine(),
            // SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnText(
                    title: "Abs rtn (%)",
                    value: Utils.formatNumber(absoluteReturns),
                    titleStyle: AppFonts.f40013.copyWith(
                        color: Config.appTheme.placeHolderInputTitleAndArrow),
                    valueStyle:
                        AppFonts.f50014Black.copyWith(color: Colors.white),
                    alignment: CrossAxisAlignment.start),
                ColumnText(
                    title: "XIRR (%)",
                    value: "$cagrReturns",
                    titleStyle: AppFonts.f40013.copyWith(
                        color: Config.appTheme.placeHolderInputTitleAndArrow),
                    valueStyle: AppFonts.f50014Black.copyWith(
                        color: (cagrReturns > 0)
                            ? Config.appTheme.defaultProfit
                            : Config.appTheme.defaultLoss),
                    alignment: CrossAxisAlignment.end),
              ],
            ),
          ],
        ),
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
          width: devWidth * 0.45,
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

  Widget returnsMFLumpsumCard(Map data) {
    double cagrReturns = data["returns"] ?? 0;
    double absoluteReturns = data["absolute_returns"] ?? 0;
    double endValue = data["current_value"] ?? 0;
    double roundedEndValue = (endValue /* /100 */).roundToDouble();
    double profit = data["profit"] ?? 0;
    double roundedProfit = (profit /* /100  */).roundToDouble();
    double ter = data["expense_ratio"] ?? 0;
    String schemeRating =
        data["scheme_rating"] != null ? data["scheme_rating"].toString() : 'NR';
    double netAssets = data["net_assets"] ?? 0;
    String roundedNetAssets = netAssets.toStringAsFixed(0);
    //String roundedEndValues = endValue.toStringAsFixed(0);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
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
                  Expanded(
                      child: Text(data["scheme_amfi_short_name"],
                          style: AppFonts.f50014Black
                              .copyWith(color: Config.appTheme.themeColor))),
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
            //2nd row
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ColumnText(
                        alignment: CrossAxisAlignment.start,
                        title: "Launch Date",
                        value: data['inception_date'],
                      ),
                      ColumnText(
                        alignment: CrossAxisAlignment.center,
                        title: "Amount Invested",
                        value: Utils.formatNumber(data["current_cost"]),
                      ),
                      ColumnText(
                          title: "Abs rtn (%)",
                          value: "${Utils.formatNumber(absoluteReturns)}",
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
                        alignment: CrossAxisAlignment.start,
                        title: "Value as on end date",
                        value:
                            "$rupee ${Utils.formatNumber(roundedEndValue, isAmount: true)}",
                      ),
                      ColumnText(
                          title: "Profit",
                          value:
                              "$rupee ${Utils.formatNumber(roundedProfit, isAmount: true)}",
                          alignment: CrossAxisAlignment.center),
                      ColumnText(
                          title: "XIRR (%)",
                          value: "$cagrReturns",
                          valueStyle: AppFonts.f50014Black.copyWith(
                              color: (cagrReturns > 0)
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

  showSchemeBottomSheet() {
    List<bool> isSelectedList = List.filled(fundList.length, false);
    List<String> selectedSchemes = List.filled(fundList.length, '');
    List<Map<String, dynamic>> selectedFundDetails = [];

    TextEditingController searchController = TextEditingController();
    print("fundList.length bottomsheet ${fundList.length}");

    // Populate selected schemes
    if (selectedValues.isNotEmpty) {
      List<String> selectedItems = selectedValues.split(',');
      for (int i = 0; i < fundList.length; i++) {
        if (selectedItems.contains(fundList[i]['scheme_amfi'])) {
          isSelectedList[i] = true;
          selectedSchemes[i] = fundList[i]['scheme_amfi'];
          selectedFundDetails.add(fundList[i]);
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
            height: devHeight * 0.8,
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
                    Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        EasyLoading.show();
                        List<String> selectedItems = [];
                        for (int i = 0; i < isSelectedList.length; i++) {
                          if (isSelectedList[i]) {
                            selectedItems.add(selectedSchemes[i]);
                          }
                        }
                        selectedValues = selectedItems.join(',');
                        print('Selected values: $selectedValues');
                        schemes = selectedValues;
                        selectedFund = "${selectedItems.length} Funds Selected";
                        // lumpsumAmountCalc = [];
                        // containingSchemes = [];
                        // notContainingSchemes = [];
                        // bottomState(() {});
                        // await getLumpSumReturns();
                        // setState(() {});
                        Get.back();
                        EasyLoading.dismiss();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Config.appTheme.themeColor,
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
                // Show selected schemes section if any schemes are selected
                if (selectedFundDetails.isNotEmpty) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   "Selected Schemes",
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     color: Config.appTheme.themeColor,
                      //   ),
                      // ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: selectedFundDetails.map((fund) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color:
                                  Config.appTheme.themeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Config.appTheme.themeColor,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    fund['scheme_amfi_short_name'],
                                    style: TextStyle(
                                      color: Config.appTheme.themeColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    bottomState(() {
                                      int index = fundList.indexWhere(
                                          (element) =>
                                              element['scheme_amfi'] ==
                                              fund['scheme_amfi']);
                                      if (index != -1) {
                                        isSelectedList[index] = false;
                                        selectedSchemes[index] = '';
                                        selectedFundDetails.remove(fund);
                                      }
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
                        }).toList(),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                  Divider(),
                ],
                SizedBox(height: 10),
                // Search field
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
                        vertical: 10.0,
                        horizontal: 16.0,
                      ),
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
                // List of all schemes
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
                                selectedFundDetails.add(fundList[index]);
                              } else {
                                isSelectedList[index] = false;
                                Utils.showError(
                                    context, "Maximum Five Funds Only Select");
                              }
                            } else {
                              isSelectedList[index] = value!;
                              selectedSchemes[index] = '';
                              selectedFundDetails.removeWhere((element) =>
                                  element['scheme_amfi'] ==
                                  fundList[index]['scheme_amfi']);
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

  /*showLumpsumAmountBottomSheet() {
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
                      Text("Select Lumpsum Amount",
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
                            itemCount: lumpsumAmountList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  lumpsumAmount = lumpsumAmountList[index];
                                  print("lumpsumAmount $lumpsumAmount");
                                  print("get lumpsumAmount ");
                                  Get.back();
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: lumpsumAmount,
                                      value: lumpsumAmountList[index],
                                      onChanged: (val) async {
                                        Get.back();
                                        setState(() {
                                          lumpsumAmount =
                                              lumpsumAmountList[index];

                                          print("lumpsumAmount $lumpsumAmount");
                                          lumpsumAmountCalc = [];
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          lumpsumAmountList[index],
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
  }*/

  DateTime convertStrToDt(String dateStr) {
    if (dateStr.isEmpty) return DateTime.now();
    try {
      return DateFormat('dd-MM-yyyy').parse(dateStr);
    } catch (e) {
      return DateTime.now();
    }
  }

  void showDatePickerDialog(BuildContext context, int dateType) async {
    DateTime initialDate;
    if (dateType == 1) {
      initialDate = controller.startDate.value.isNotEmpty
          ? convertStrToDt(controller.startDate.value)
          : DateTime.now()
              .subtract(Duration(days: 365 * 10)); // Default to 10 years ago
    } else {
      initialDate = controller.endDate.value.isNotEmpty
          ? convertStrToDt(controller.endDate.value)
          : DateTime.now().subtract(Duration(days: 1)); // Default to yesterday
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      if (dateType == 1) {
        startDateController.text = formattedDate;
        controller.startDate.value = formattedDate;
      } else {
        endDateController.text = formattedDate;
        controller.endDate.value = formattedDate;
      }
    }
  }
}

class RollingReturnsController extends GetxController {
  var endDate = "".obs;
  var startDate = "".obs;
  var lumpsumAmount = "".obs;

  var shouldRefresh = false.obs;

  late DateTime formattedDate;

  DateTime currentDate = DateTime.now();
  DateTime previousDate = DateTime.now().subtract(Duration(days: 1));
  DateFormat formatter = DateFormat("dd-MM-yyyy");
  late String formattedPreviousDate;

  late TextEditingController lumpsumAmountController;

  @override
  void onInit() {
    super.onInit();
    lumpsumAmountController = TextEditingController(text: "100000");
    shouldRefresh.value = true;
    formattedPreviousDate = formatter.format(previousDate);
    formattedDate =
        DateTime(currentDate.year - 10, currentDate.month, currentDate.day - 1);
    print("formattedDate $formattedDate");
    startDate.value = formatter.format(formattedDate);
    endDate.value = formattedPreviousDate;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
