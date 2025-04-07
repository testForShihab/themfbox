import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/api/ResearchApi.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/TransferCircle.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import 'package:mymfbox2_0/api/ProposalApi.dart';
import 'package:mymfbox2_0/rp_widgets/NoData.dart';

class MfStpCalculator extends StatefulWidget {
  const MfStpCalculator({super.key});

  @override
  State<MfStpCalculator> createState() => _MfStpCalculatorState();
}

class _MfStpCalculatorState extends State<MfStpCalculator> {
  final RollingReturnsController controller =
      Get.put(RollingReturnsController());

  late double devWidth, devHeight;
  int user_id = getUserId();
  String client_name = GetStorage().read("client_name");
  List allCategories = [];

  TextEditingController lumpsumDateController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  // TextEditingController initialLumpsumAmountController =
  //     TextEditingController();
  // TextEditingController stpAmountController = TextEditingController();

  // String lumpsumDate = "01-07-2015";

  // String initialLumpsumAmount = "200000";

  TextStyle underlineText = TextStyle(
      color: Config.appTheme.themeColor,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w500,
      fontSize: 13);

  int selectedRadioIndex = -1;
  int selectedToRadioIndex = -1;
  String selectedCategory = "Equity Schemes";
  String selectedSubCategory = "Equity: Flexi Cap";

  // String selectedFromScheme = "ICICI Pru Liquid Gr";
  // String selectedToScheme = "ICICI Pru Equity & Debt Gr";
  String selectedRollingPeriod = "3 Years";
  String rollingPeriods = "3 Year";

  // String startDate = "05-07-2015";
  // String endDate = "01-04-2024";
  // String lumpsumDate = "01-07-2015";
  // String scheme = "ICICI Prudential Smallcap Fund - Growth";
  String toScheme = "Mirae Asset Large Cap Fund - Growth Plan";

  String btnNo = "";
  int percentage = 0;
  String shortName = "";
  String benchMarkName = "";
  double startingPoint = 0;
  Map cashFromScheme = {};
  List<String> lumpsumAmountList = [
    "10,000",
    "1,00,000",
    "10,00,000",
  ];
  String lumpsumAmount = "10,00,000";

  List<String> stpFrequencyList = [
    "daily",
    "weekly",
    "Fortnightly",
    "Monthly",
    "Quarterly",
  ];

  List<String> stpAmountList = [
    "10,000",
    "1,00,000",
    "10,00,000",
  ];

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
  List rollingReturnBenchmarkList = [];
  final List<String> months = [];
  List<double> series1Data = [];
  List<double> series2Data = [];
  List fundList = [];
  Map stpCalculatorList = {};
  double profit = 0.0;
  bool isLoading = true;
  Map autoscheme = {};
  String selectedInvType = "Return Statistics\n(%)";
  int? selectedIndex;
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
  List Fromcash = [];
  List Tocash = [];
  List to_SchemeMapping = [];

  Future getDatas() async {
    isLoading = true;
    await getTopLumpsumFunds();
    await getSTPReturns();
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
      /*print("selectedFromScheme $selectedFromScheme");
      print("fund name ${fund['scheme_amfi']}");*/
    });
    print("fundList.length ${fundList.length}");
    return 0;
  }

  Future getSTPReturns() async {
    if (stpCalculatorList.isNotEmpty) return 0;

    String lamount =
        controller.initialLumpsumAmount.value.toString().replaceAll(',', '');
    String samount = controller.stpAmount.value.toString().replaceAll(',', '');
    String FromScheme =
        controller.selectedFromScheme.value.toString().replaceAll('&', '%26');
    String ToScheme =
        controller.selectedToScheme.value.toString().replaceAll('&', '%26');
    Map data = await ResearchApi.getSTPReturns(
      user_id: user_id,
      client_name: client_name,
      frequency: controller.stpFrequency.value,
      from_date: controller.startDate.value,
      to_date: controller.endDate.value,
      from_scheme: FromScheme,
      to_scheme: ToScheme,
      init_start_date: controller.lumpsumDate.value,
      initial_amount: lamount,
      transfer_amount: samount,
    );
    print("-----------camehere");
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    stpCalculatorList = data['result'];
    Fromcash = stpCalculatorList['from_scheme_list'];
    Tocash = stpCalculatorList['to_scheme_list'];
  }

  @override
  void initState() {
    super.initState();
    btnNo = "1";
    // lumpsumDateController.text = controller.lumpsumDate.value;
    // startDateController.text = controller.startDate.value;
    // endDateController.text = controller.endDate.value;

    // stpAmountController = TextEditingController(text: "10000");
    // stpAmountController = TextEditingController(text: "10000");
    // initialLumpsumAmountController = TextEditingController(text: "200000");
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
              toolbarHeight: 350,
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
                        "MF STP Calculator",
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
                          showSchemeBottomSheet();
                        },
                        child: Obx(() => appBarColumn(
                            "From",
                            Utils.getFirst10(controller.scheme.value.isEmpty
                                ? controller.scheme.value
                                : controller.selectedFromScheme.value),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor))),
                      ),
                      GestureDetector(
                        onTap: () {
                          showToSchemeBottomSheet();
                        },
                        child: Obx(() => appBarColumn(
                            "To",
                            Utils.getFirst10(controller.selectedToScheme.value),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor))),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 2.0),
                              child: Text(
                                "Initial Investment Amount",
                                style: AppFonts.f40013
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            Container(
                              width: devWidth * 0.42,
                              height: devHeight * 0.04,
                              margin: EdgeInsets.only(top: 4, left: 2),
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
                                  LengthLimitingTextInputFormatter(8),
                                ],
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(color: Colors.white),
                                  // Style for label text
                                  // Alternatively, you can use hintText
                                  hintStyle: TextStyle(color: Colors.white),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 13,
                                      horizontal: 8), // Style for hint text
                                ),
                                style: TextStyle(color: Colors.white),
                                controller:
                                    controller.initialLumpsumAmountController,
                                onChanged: (text) async {
                                  if (text.length <= 6) {
                                    controller.stpAmount.value = text;
                                    print(
                                        "stpAmount ${controller.stpAmount.value}");
                                    // rollingReturnBenchmarkList = [];
                                  } else {
                                    controller.stpAmountController.text =
                                        text.substring(0, 6);
                                    controller.stpAmountController.selection =
                                        TextSelection.fromPosition(
                                      TextPosition(
                                          offset: controller
                                              .stpAmountController.text.length),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // lumpsumDateController.text = "";
                          // lumpsumDate = "";
                          showDatePickerDialog(context, 0);
                        },
                        child: Obx(() => appBarColumn(
                            "Initial Investment Date",
                            getFirst13(controller.lumpsumDate.value),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor))),
                      ),
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
                        child: Obx(() => appBarColumn(
                            "STP Frequency",
                            getFirst13(controller.stpFrequency.value),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor))),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 26.0),
                              child: Text(
                                "STP Amount",
                                style: AppFonts.f40013
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            Container(
                              width: devWidth * 0.44,
                              height: devHeight * 0.04,
                              margin: EdgeInsets.only(top: 4, left: 26),
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
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(color: Colors.white),
                                  // Style for label text
                                  // Alternatively, you can use hintText
                                  hintStyle: TextStyle(color: Colors.white),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 13,
                                      horizontal: 8), // Style for hint text
                                ),
                                style: TextStyle(color: Colors.white),
                                controller: controller.stpAmountController,
                                onChanged: (text) async {
                                  isLoading = false;
                                  if (text.length <= 6) {
                                    controller.stpAmount.value = text;
                                    print(
                                        "stpAmount ${controller.stpAmount.value}");
                                    // rollingReturnBenchmarkList = [];
                                  } else {
                                    controller.stpAmountController.text =
                                        text.substring(0, 6);
                                    controller.stpAmountController.selection =
                                        TextSelection.fromPosition(
                                      TextPosition(
                                          offset: controller
                                              .stpAmountController.text.length),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // startDateController.text = "";
                          // controller.startDate.value = "";
                          showDatePickerDialog(context, 1);
                        },
                        child: Obx(() => appBarColumn1(
                            "Stp Start Date",
                            getFirst13(controller.startDate.value),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor))),
                      ),
                      GestureDetector(
                        onTap: () {
                          // endDateController.text = "";
                          // controller.endDate.value = "";
                          showDatePickerDialog(context, 2);
                        },
                        child: Obx(() => appBarColumn1(
                            "Stp End Date",
                            getFirst13(controller.endDate.value),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor))),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (controller.startDate.value.isNotEmpty) {
                            DateTime lumpsumDate = convertStrToDt(controller.lumpsumDate.value);
                            DateTime startDate = convertStrToDt(controller.startDate.value);
                            DateTime endDate = convertStrToDt(controller.endDate.value);
                            print("startDate $startDate");
                            print("endDate $endDate");

                            // First validate if start and end dates are same
                            if (endDate.year == startDate.year &&
                                endDate.month == startDate.month &&
                                endDate.day == startDate.day) {
                              Utils.showError(context, "Please select a valid start date and end date.");
                              return;
                            }

                              if (startDate.isBefore(lumpsumDate)) {
                                Utils.showError(context, "Please select STP start date less than intial amount start date.");
                                return;
                              }

                            if (controller.stpFrequency.value == "daily") {
                              if (startDate.isAfter(endDate)) {
                                Utils.showError(context, "Please select a valid start date and end date.");
                                return;
                              }
                            }

                            if (controller.stpFrequency.value == "weekly") {
                              DateTime oneWeekBeforeEndDate = endDate.subtract(const Duration(days: 7));
                              if (startDate.isAfter(oneWeekBeforeEndDate)) {
                                Utils.showError(context, "Please select a valid start date and end date.");
                                return;
                              }
                            }

                            if (controller.stpFrequency.value == "Monthly") {
                              DateTime oneMonthBeforeEndDate = DateTime(endDate.year, endDate.month - 1, endDate.day);
                              if (startDate.isAfter(oneMonthBeforeEndDate)) {
                                Utils.showError(context, "Please select a valid start date and end date.");
                                return;
                              }
                            }

                            if (controller.stpFrequency.value == "Quarterly") {
                              DateTime threeMonthsBeforeEndDate = DateTime(endDate.year, endDate.month - 3, endDate.day);
                              if (startDate.isAfter(threeMonthsBeforeEndDate)) {
                                Utils.showError(context, "Please select a valid start date and end date.");
                                return;
                              }
                            }

                            if (controller.stpFrequency.value == "Fortnightly") {
                              DateTime fourteenDaysBeforeEndDate = endDate.subtract(Duration(days: 14));
                              if (startDate.isAfter(fourteenDaysBeforeEndDate)) {
                                Utils.showError(context, "Please select a valid start date and end date.");
                                return;
                              }
                            }

                            // Validate if from and to schemes are same
                            if (controller.selectedFromScheme.value == controller.selectedToScheme.value) {
                              Utils.showError(context, 'Transfer from scheme and to scheme should not be same');
                              return;
                            }

                            stpCalculatorList = {};
                            rollingReturnBenchmarkList = [];
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: devWidth * 0.22,
                          padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
                          margin: EdgeInsets.only(top: 22),
                          decoration: BoxDecoration(
                            color: Config.appTheme.defaultProfit,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text("Submit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
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
          isLoading
              ? Utils.shimmerWidget(devHeight * 0.8, margin: EdgeInsets.all(20))
              /*: (rollingReturnBenchmarkList.isEmpty)
                  ? Padding(
                      padding: EdgeInsets.only(
                          top: devHeight * 0.02, left: devWidth * 0.34),
                      child: Column(
                        children: [
                          Text("No Data Available"),
                          SizedBox(height: devHeight * 0.01),
                        ],
                      ),
                    )*/
              : Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("STP Summary",
                          style: AppFonts.f50014Grey,
                          textAlign: TextAlign.left),
                      SizedBox(height: 16),
                      stpSummaryCard(),
                      SizedBox(height: 16),
                      Text("Scheme Summary",
                          style: AppFonts.f50014Grey,
                          textAlign: TextAlign.left),
                      SizedBox(height: 16),
                      schemeSummaryCard(),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  String getFirst13(String text) {
    String s = text.split(":").last;
    if (s.length > 12) s = s.substring(0, 12);
    return s;
  }

  Widget stpSummaryCard() {
    double profits = stpCalculatorList['total_profit'] ?? 0;
    num returns = stpCalculatorList['total_returns'] ?? 0;
    num installment = stpCalculatorList['from_scheme_installment'] ?? 0;
    num transfer_amount = stpCalculatorList['from_scheme_transfer_amount'] ?? 0;
    num initial_amount = stpCalculatorList['from_scheme_initial_amount'] ?? 0;
    num current_value = stpCalculatorList['total_current_value'] ?? 0;
    print("Profit data $profits");
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Stp Period",
                    style: AppFonts.f40013,
                  ),
                  RichText(
                    text: TextSpan(
                      style: AppFonts.f50014Black,
                      children: [
                        TextSpan(text: controller.startDate.value
                            //"20-08-2016 ",
                            ),
                        TextSpan(
                          text: "   to   ",
                          style: AppFonts.f40013.copyWith(fontSize: 14),
                        ),
                        TextSpan(
                          text: controller.endDate.value,
                          //"12-07-2018",
                          style: AppFonts.f50014Black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          DottedLine(verticalPadding: 4),
          Row(
            children: [
              ColumnText(
                  title: "${controller.stpFrequency.value} STP ",
                  value:
                      "$rupee ${Utils.formatNumber(double.parse(controller.stpAmount.value))}"),
            ],
          ),
          DottedLine(verticalPadding: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "${controller.stpFrequency.value} Installments",
                  value: "$installment"),
              ColumnText(
                title: "Transferred Amount",
                value: "$rupee ${Utils.formatNumber(transfer_amount)}",
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
          DottedLine(verticalPadding: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Initial Investment",
                  value: "$rupee ${Utils.formatNumber(initial_amount)}"),
              ColumnText(
                title: "Total Current Value",
                value: "$rupee ${Utils.formatNumber(current_value.round())}",
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
          DottedLine(verticalPadding: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Total Profit",
                value: "$rupee ${Utils.formatNumber(profits.round())}",
              ),
              ColumnText(
                title: "Total Returns",
                value: " ${returns.toStringAsFixed(2)}%",
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: (returns > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget schemeSummaryCard() {
    num remaining_units = stpCalculatorList['from_scheme_remaining_units'];
    num accumulated_units = stpCalculatorList['to_scheme_accumulated_units'];
    String from_current_value_date =
        stpCalculatorList['from_scheme_current_value_date'];
    String to_current_value_date =
        stpCalculatorList['to_scheme_current_value_date'];
    num from_current_value = stpCalculatorList['from_scheme_current_value'];
    num to_current_value = stpCalculatorList['to_scheme_current_value'];
    String from_end_date = stpCalculatorList['from_scheme_end_value_date'];
    String to_end_date = stpCalculatorList['to_scheme_end_value_date'];
    num from_end_value = stpCalculatorList['from_scheme_end_value'];
    num to_end_value = stpCalculatorList['to_scheme_end_value'];
    num from_scheme_profit = stpCalculatorList['from_scheme_profit'];
    num to_scheme_profit = stpCalculatorList['to_scheme_profit'];
    num from_scheme_returns = stpCalculatorList['from_scheme_returns'];
    num to_scheme_returns = stpCalculatorList['to_scheme_returns'];
    String logo = stpCalculatorList['amc_logo'];
    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
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
              Image.network(stpCalculatorList["amc_logo"] ?? "", height: 30),
              Image.network(stpCalculatorList["amc_logo"] ?? "", height: 30),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text("${controller.selectedFromScheme.value}",
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor)),
              ),
              TransferCircle(),
              Expanded(
                child: Text(
                  "${controller.selectedToScheme.value}",
                  style: AppFonts.f50014Black
                      .copyWith(color: Config.appTheme.themeColor),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Units Remaining",
                  value:
                      "$rupee ${Utils.formatNumber(remaining_units.round())}"),
              ColumnText(
                  title: "Units Accumulated",
                  value:
                      "$rupee ${Utils.formatNumber(accumulated_units.round())}",
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Value on $from_current_value_date",
                  value:
                      "$rupee ${Utils.formatNumber(from_current_value.round())}"),
              ColumnText(
                  title: "Value on $to_current_value_date",
                  value:
                      "$rupee ${Utils.formatNumber(to_current_value.round())}",
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Value on $from_end_date",
                  value:
                      "$rupee ${Utils.formatNumber(from_end_value.round())}"),
              ColumnText(
                  title: "Value on $to_end_date",
                  value: "$rupee ${Utils.formatNumber(to_end_value.round())}",
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Profit",
                  value:
                      "$rupee ${Utils.formatNumber(from_scheme_profit.round())}"),
              ColumnText(
                  title: "Profit",
                  value:
                      "$rupee ${Utils.formatNumber(to_scheme_profit.round())}",
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Return",
                value: "${from_scheme_returns.toStringAsFixed(2)}%",
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: (from_scheme_returns > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
              ),
              ColumnText(
                  title: "Return",
                  value: "${to_scheme_returns.toStringAsFixed(2)}%",
                  valueStyle: AppFonts.f50014Black.copyWith(
                      color: (to_scheme_returns > 0)
                          ? Config.appTheme.defaultProfit
                          : Config.appTheme.defaultLoss),
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  cashFromSchemeBottomSheet();
                },
                child: Text(
                  "View Cash Flow",
                  style: underlineText,
                ),
              ),
              GestureDetector(
                onTap: () {
                  cashToSchemeBottomSheet();
                },
                child: Text(
                  "View Cash Flow",
                  style: underlineText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // showInitialInvestmentBottomSheet() {
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
  //                     Text("Select SIP Frequency",
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
  //                           itemCount: stpFrequencyList.length,
  //                           scrollDirection: Axis.vertical,
  //                           itemBuilder: (context, index) {
  //                             return GestureDetector(
  //                               onTap: () async {
  //                                 controller.stpFrequency.value =
  //                                     stpFrequencyList[index];
  //                                 print(
  //                                     "sipFrequency ${controller.stpFrequency.value}");
  //                                 print("get sipFrequency ");
  //                                 Get.back();
  //                                 setState(() {});
  //                               },
  //                               child: Row(
  //                                 children: [
  //                                   Radio(
  //                                     activeColor: Config.appTheme.themeColor,
  //                                     groupValue: controller.stpFrequency.value,
  //                                     value: stpFrequencyList[index],
  //                                     onChanged: (val) async {
  //                                       Get.back();
  //                                       setState(() {
  //                                         controller.stpFrequency.value =
  //                                             stpFrequencyList[index];
  //
  //                                         print(
  //                                             "sipFrequency ${controller.stpFrequency.value}");
  //                                         rollingReturnBenchmarkList = [];
  //                                       });
  //                                     },
  //                                   ),
  //                                   Expanded(
  //                                     child: Container(
  //                                       child: Text(
  //                                         stpFrequencyList[index],
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

  // showTenureYearBottomSheet() {
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
  //                     Text("Select SIP Frequency",
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
  //                           itemCount: stpFrequencyList.length,
  //                           scrollDirection: Axis.vertical,
  //                           itemBuilder: (context, index) {
  //                             return GestureDetector(
  //                               onTap: () async {
  //                                 controller.stpFrequency.value = stpFrequencyList[index];
  //                                 print("sipFrequency ${controller.stpFrequency.value}");
  //                                 print("get sipFrequency ");
  //                                 Get.back();
  //                                 setState(() {});
  //                               },
  //                               child: Row(
  //                                 children: [
  //                                   Radio(
  //                                     activeColor: Config.appTheme.themeColor,
  //                                     groupValue: controller.stpFrequency.value,
  //                                     value: stpFrequencyList[index],
  //                                     onChanged: (val) async {
  //                                       Get.back();
  //                                       setState(() {
  //                                         controller.stpFrequency.value =
  //                                             stpFrequencyList[index];
  //
  //                                         print("sipFrequency ${controller.stpFrequency.value}");
  //                                         rollingReturnBenchmarkList = [];
  //                                       });
  //                                     },
  //                                   ),
  //                                   Expanded(
  //                                     child: Container(
  //                                       child: Text(
  //                                         stpFrequencyList[index],
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
                            itemCount: stpFrequencyList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  controller.stpFrequency.value =
                                      stpFrequencyList[index];
                                  print(
                                      "sipFrequency ${controller.stpFrequency.value}");
                                  print("get sipFrequency ");
                                  Get.back();
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: controller.stpFrequency.value,
                                      value: stpFrequencyList[index],
                                      onChanged: (val) async {
                                        Get.back();
                                        controller.stpFrequency.value =
                                            stpFrequencyList[index];

                                        print(
                                            "sipFrequency ${controller.stpFrequency.value}");
                                        // rollingReturnBenchmarkList = [];
                                      },
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          stpFrequencyList[index],
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

  // showRollingPeriodBottomSheet() {
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
  //                     Text("Select Rolling Period",
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
  //                           itemCount: rollingPeriod.length,
  //                           scrollDirection: Axis.vertical,
  //                           itemBuilder: (context, index) {
  //                             return GestureDetector(
  //                               onTap: () async {
  //                                 selectedRollingPeriod = rollingPeriod[index];
  //                                 if (rollingPeriod[index] == "1 Month") {
  //                                   rollingPeriods = "1 Month";
  //                                 } else if (rollingPeriod[index] == "1 Year") {
  //                                   rollingPeriods = "1 Year";
  //                                 } else if (rollingPeriod[index] ==
  //                                     "2 Years") {
  //                                   rollingPeriods = "2 Year";
  //                                 } else if (rollingPeriod[index] ==
  //                                     "3 Years") {
  //                                   rollingPeriods = "3 Year";
  //                                 } else if (rollingPeriod[index] ==
  //                                     "5 Years") {
  //                                   rollingPeriods = "5 Year";
  //                                 } else if (rollingPeriod[index] ==
  //                                     "7 Years") {
  //                                   rollingPeriods = "7 Year";
  //                                 } else if (rollingPeriod[index] ==
  //                                     "10 Years") {
  //                                   rollingPeriods = "10 Year";
  //                                 } else if (rollingPeriod[index] ==
  //                                     "15 Years") {
  //                                   rollingPeriods = "15 Years";
  //                                 } else {
  //                                   selectedRollingPeriod =
  //                                       rollingPeriod[index];
  //                                 }
  //                                 print(
  //                                     "selectedRollingPeriod $selectedRollingPeriod");
  //                                 print("get selectedRollingPeriod ");
  //                                 Get.back();
  //                                 setState(() {});
  //                               },
  //                               child: Row(
  //                                 children: [
  //                                   Radio(
  //                                     activeColor: Config.appTheme.themeColor,
  //                                     groupValue: selectedRollingPeriod,
  //                                     value: rollingPeriod[index],
  //                                     onChanged: (val) async {
  //                                       Get.back();
  //                                       setState(() {
  //                                         selectedRollingPeriod =
  //                                             rollingPeriod[index];
  //                                         if (rollingPeriod[index] ==
  //                                             "1 Month") {
  //                                           rollingPeriods = "1 Month";
  //                                         } else if (rollingPeriod[index] ==
  //                                             "1 Year") {
  //                                           rollingPeriods = "1 Year";
  //                                         } else if (rollingPeriod[index] ==
  //                                             "2 Years") {
  //                                           rollingPeriods = "2 Year";
  //                                         } else if (rollingPeriod[index] ==
  //                                             "3 Years") {
  //                                           rollingPeriods = "3 Year";
  //                                         } else if (rollingPeriod[index] ==
  //                                             "5 Years") {
  //                                           rollingPeriods = "5 Year";
  //                                         } else if (rollingPeriod[index] ==
  //                                             "7 Years") {
  //                                           rollingPeriods = "7 Year";
  //                                         } else if (rollingPeriod[index] ==
  //                                             "10 Years") {
  //                                           rollingPeriods = "10 Year";
  //                                         } else if (rollingPeriod[index] ==
  //                                             "15 Years") {
  //                                           rollingPeriods = "15 Year";
  //                                         } else {
  //                                           selectedRollingPeriod =
  //                                               rollingPeriod[index];
  //                                         }
  //                                         print(
  //                                             "rollingPeriod $selectedRollingPeriod");
  //
  //                                         rollingReturnBenchmarkList = [];
  //                                       });
  //                                     },
  //                                   ),
  //                                   Expanded(
  //                                     child: Container(
  //                                       child: Text(
  //                                         rollingPeriod[index],
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

  // showCategoryBottomSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(10), topRight: Radius.circular(10))),
  //     builder: (context) {
  //       return StatefulBuilder(builder: (_, bottomState) {
  //         return Container(
  //           height: devHeight * 0.7,
  //           padding: EdgeInsets.all(7),
  //           child: Column(
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text("  Select Category",
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.bold, fontSize: 16)),
  //                   IconButton(
  //                       onPressed: () {
  //                         Get.back();
  //                       },
  //                       icon: Icon(Icons.close))
  //                 ],
  //               ),
  //               Divider(),
  //               SizedBox(
  //                 height: 40,
  //                 child: ListView.builder(
  //                   scrollDirection: Axis.horizontal,
  //                   itemCount: allCategories.length,
  //                   itemBuilder: (context, index) {
  //                     Map temp = allCategories[index];
  //
  //                     return (selectedCategory == temp['name'])
  //                         ? selectedCategoryChip(
  //                             "${temp['name']}", "${temp['count']}")
  //                         : InkWell(
  //                             onTap: () async {
  //                               selectedCategory = temp['name'];
  //                               subCategoryList = [];
  //                               EasyLoading.show();
  //                               await getTopLumpsumFunds();
  //                               EasyLoading.dismiss();
  //                               bottomState(() {});
  //                             },
  //                             child: categoryChip(
  //                                 "${temp['name']}", "${temp['count']}"));
  //                   },
  //                 ),
  //               ),
  //               SizedBox(height: 10),
  //               Expanded(
  //                 child: ListView.builder(
  //                   itemCount: subCategoryList.length,
  //                   shrinkWrap: true,
  //                   itemBuilder: (context, index) {
  //                     String temp = subCategoryList[index].split(":").last;
  //                     return InkWell(
  //                       onTap: () async {
  //                         selectedSubCategory = subCategoryList[index];
  //                         EasyLoading.show();
  //                         fundList = [];
  //                         await getTopLumpsumFunds();
  //                         EasyLoading.dismiss();
  //                         rollingReturnBenchmarkList = [];
  //                         bottomState(() {});
  //                         Get.back();
  //                         setState(() {
  //                           print("selectedSubCategory = $selectedSubCategory");
  //                         });
  //                       },
  //                       child: Row(
  //                         children: [
  //                           Radio(
  //                               value: subCategoryList[index],
  //                               groupValue: selectedSubCategory,
  //                               activeColor: Config.appTheme.themeColor,
  //                               onChanged: (val) async {
  //                                 selectedSubCategory = subCategoryList[index];
  //                                 fundList = [];
  //                                 rollingReturnBenchmarkList = [];
  //                                 bottomState(() {});
  //                                 await getTopLumpsumFunds();
  //                                 if (fundList.isNotEmpty) {
  //                                   setState(() {
  //                                     controller.scheme.value = fundList[0]['scheme_amfi'];
  //                                   });
  //                                 }
  //                                 Get.back();
  //                                 setState(() {
  //                                   print(
  //                                       "selectedSubCategory = $selectedSubCategory");
  //                                 });
  //                               }),
  //                           Container(
  //                               height: 30,
  //                               width: 30,
  //                               decoration: BoxDecoration(
  //                                   color: Color(0xffF8DFD5),
  //                                   borderRadius: BorderRadius.circular(5)),
  //                               child: Icon(Icons.bar_chart,
  //                                   color: Colors.red, size: 20)),
  //                           Expanded(child: Text(" $temp")),
  //                         ],
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               )
  //             ],
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }

  showSchemeBottomSheet() {
    List<bool> isSelectedList = List.filled(fundList.length, false);
    List<String> selectedSchemes = List.filled(fundList.length, '');
    // TextEditingController searchController = TextEditingController();
    print("fundList.length bottomsheet ${fundList.length}");
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
                      "Select From Scheme",
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
                    controller: controller.fromsearchController,
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
                      if (controller.fromsearchController.text.isNotEmpty &&
                          !fundList[index]['scheme_amfi_short_name']
                              .toLowerCase()
                              .contains(controller.fromsearchController.text
                                  .toLowerCase())) {
                        return SizedBox.shrink();
                      }
                      return RadioListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(fundList[index]['scheme_amfi_short_name']),
                        value: index,
                        groupValue: selectedRadioIndex,
                        onChanged: (int? value) {
                          if (value != null) {
                            selectedRadioIndex = value;

                            controller.selectedValues.value =
                                fundList[0]['scheme_amfi'];

                            selectedSchemes = [];
                            selectedSchemes.add(fundList[value]['scheme_amfi']);

                            controller.selectedFromScheme.value =
                                fundList[value]['scheme_amfi_short_name'];

                            controller.scheme.value =
                                fundList[value]['scheme_amfi'];
                            controller.scheme.value = selectedSchemes.join(',');

                            controller.fromsearchController.clear();
                            // rollingReturnBenchmarkList = [];
                            Get.back();
                          }
                        },
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

  showToSchemeBottomSheet() async {
    List<bool> isSelectedList = List.filled(fundList.length, false);
    List<String> selectedSchemes = List.filled(fundList.length, '');
    String toscheme =
        controller.selectedFromScheme.value.split(" ").elementAt(0);
    List suggestions = [];
    EasyLoading.show();
    Map data = await PropoaslApi.autoSuggestScheme(
        user_id: user_id, query: toscheme, client_name: client_name);
    suggestions = data['list'];
    EasyLoading.dismiss();
    print("fundList.length bottomsheet ${fundList.length}");
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
                      "Select To Scheme",
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
                    controller: controller.tosearchController,
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
                    onChanged: (value) async {
                      Map data = await PropoaslApi.autoSuggestScheme(
                          user_id: user_id,
                          query: controller.selectedFromScheme.value
                              .split(" ")
                              .elementAt(0),
                          client_name: client_name);
                      suggestions = data['list'];
                      bottomState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      Map temp = suggestions[index];
                      String name = temp['scheme_amfi_short_name'];

                      if (controller.tosearchController.text.isNotEmpty &&
                          !name.toLowerCase().contains(controller
                              .tosearchController.text
                              .toLowerCase())) {
                        return SizedBox.shrink();
                      }

                      return RadioListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(name),
                        value: index,
                        groupValue: selectedToRadioIndex,
                        onChanged: (int? value) {
                          if (value != null) {
                            selectedToRadioIndex = value;
                            selectedSchemes = [];
                            controller.selectedToScheme.value = name;
                            //toScheme = fundList[value]['scheme_amfi'];
                            // rollingReturnBenchmarkList = [];
                            controller.tosearchController.clear();
                            Get.back();
                          }
                        },
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

  // showLumpsumAmountBottomSheet() {
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
  //                     Text("Select Lumpsum Amount",
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
  //                           itemCount: lumpsumAmountList.length,
  //                           scrollDirection: Axis.vertical,
  //                           itemBuilder: (context, index) {
  //                             return GestureDetector(
  //                               onTap: () async {
  //                                 lumpsumAmount = lumpsumAmountList[index];
  //                                 print("lumpsumAmount $lumpsumAmount");
  //                                 print("get lumpsumAmount ");
  //                                 Get.back();
  //                                 setState(() {});
  //                               },
  //                               child: Row(
  //                                 children: [
  //                                   Radio(
  //                                     activeColor: Config.appTheme.themeColor,
  //                                     groupValue: lumpsumAmount,
  //                                     value: lumpsumAmountList[index],
  //                                     onChanged: (val) async {
  //                                       Get.back();
  //                                       setState(() {
  //                                         lumpsumAmount =
  //                                             lumpsumAmountList[index];
  //
  //                                         print("lumpsumAmount $lumpsumAmount");
  //                                         rollingReturnBenchmarkList = [];
  //                                       });
  //                                     },
  //                                   ),
  //                                   Expanded(
  //                                     child: Container(
  //                                       child: Text(
  //                                         "$rupee ${lumpsumAmountList[index]}",
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

  // showStpAmountBottomSheet() {
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
  //                     Text("Select Stp Amount",
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
  //                           itemCount: stpAmountList.length,
  //                           scrollDirection: Axis.vertical,
  //                           itemBuilder: (context, index) {
  //                             return GestureDetector(
  //                               onTap: () async {
  //                                 controller.stpAmount.value = stpAmountList[index];
  //                                 print("stpAmount $lumpsumAmount");
  //                                 print("get stpAmount ");
  //                                 Get.back();
  //                                 setState(() {});
  //                               },
  //                               child: Row(
  //                                 children: [
  //                                   Radio(
  //                                     activeColor: Config.appTheme.themeColor,
  //                                     groupValue: controller.stpAmount.value,
  //                                     value: stpAmountList[index],
  //                                     onChanged: (val) async {
  //                                       Get.back();
  //                                       setState(() {
  //                                         controller.stpAmount.value = stpAmountList[index];
  //
  //                                         print("stpAmount ${controller.stpAmount.value}");
  //                                         rollingReturnBenchmarkList = [];
  //                                       });
  //                                     },
  //                                   ),
  //                                   Expanded(
  //                                     child: Container(
  //                                       child: Text(
  //                                         "$rupee ${stpAmountList[index]}",
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

  void showDatePickerDialog(BuildContext context, int dateType) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dateType == 0
          ? convertStrToDt(controller.lumpsumDate.value)
          : dateType == 1
              ? convertStrToDt(controller.startDate.value)
              : convertStrToDt(controller.endDate.value),
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
    );
    print("pickedDate $pickedDate");
    print("pickedDate dateType $dateType");

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      if (dateType == 0) {
        lumpsumDateController.text = formattedDate;
        controller.lumpsumDate.value = formattedDate;
        controller.lumpsumDate.value = formattedDate;
      } else if (dateType == 1) {
        startDateController.text = formattedDate;
        controller.startDate.value = formattedDate;
        controller.startDate.value = formattedDate;
      } else {
        endDateController.text = formattedDate;
        controller.endDate.value = formattedDate;
        controller.endDate.value = formattedDate;
      }
      // rollingReturnBenchmarkList = [];
    }
  }

  cashFromSchemeBottomSheet() {
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
                        "  Cash Flow",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.close),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  Divider(
                    color: Color(0XFFDFDFDF),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 0, 14),
                    child: Row(
                      children: [
                        Image.network(stpCalculatorList["amc_logo"] ?? "",
                            height: 30),
                        SizedBox(width: 5),
                        SizedBox(
                            width: 280,
                            child: Text(controller.selectedFromScheme.value,
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
                          "STP Cashflow",
                          style: AppFonts.f50014Grey,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  (Fromcash.isEmpty)
                      ? NoData()
                      : Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: Fromcash.length,
                                  itemBuilder: (context, index) {
                                    Map data = Fromcash[index];
                                    return cashFlowTileFromScheme(data);
                                  }),
                            ),
                          ),
                        ),
                ],
              ),
            );
          });
        });
  }

  Widget cashFlowTileFromScheme(Map data) {
    String nav_date = data['nav_date'] ?? "";
    num amount = data['cash_flow'] ?? 0;
    num units = data['units'] ?? 0;
    num current_value = data['current_value'] ?? 0;
    double Nav = data['nav'] ?? 0;
    num cashlength = Fromcash.length;
    print("cashlength = $cashlength");
    String formattedNavDateString = "";
    if (nav_date.isNotEmpty) {
      try {
        // Parse the original date string to a DateTime object
        DateTime date = DateTime.parse(nav_date);

        // Format the DateTime object to the desired format
        formattedNavDateString = DateFormat('dd-MM-yyyy').format(date);

        // Print the formatted date
        print(formattedNavDateString); // Output: 01-07-2015
      } catch (e) {
        // Handle the error if the date string is invalid
        print('Error parsing the date: $e');
      }
    }
    return Container(
      height: 100,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedNavDateString,
                style:
                    AppFonts.f40013.copyWith(color: Config.appTheme.themeColor),
              ),
              Text(
                  (amount > 0)
                      ? "$rupee ${Utils.formatNumber(amount, isAmount: false)}"
                      : "$rupee ${Utils.formatNumber(amount, isAmount: false)}",
                  style: AppFonts.f50014Black.copyWith(
                      color: (amount > 0)
                          ? Config.appTheme.defaultProfit
                          : Config.appTheme.defaultLoss))
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Nav",
                  value: "$Nav",
                  alignment: CrossAxisAlignment.start),
              ColumnText(
                  title: "Units",
                  value: "${Utils.formatNumber(units)}",
                  alignment: CrossAxisAlignment.center),
              ColumnText(
                title: "Current Value",
                value: "$rupee ${Utils.formatNumber(current_value.round())}",
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }

  cashToSchemeBottomSheet() {
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
                        "  Cash Flow",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.close),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  Divider(
                    color: Color(0XFFDFDFDF),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 0, 14),
                    child: Row(
                      children: [
                        Image.network(stpCalculatorList["amc_logo"] ?? "",
                            height: 30),
                        SizedBox(width: 5),
                        SizedBox(
                            width: 280,
                            child: Text(controller.selectedToScheme.value,
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
                          "STP Cashflow",
                          style: AppFonts.f50014Grey,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  (Tocash.isEmpty)
                      ? NoData()
                      : Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: Tocash.length,
                                  itemBuilder: (context, index) {
                                    Map data = Tocash[index];
                                    return cashFlowTileToScheme(data);
                                  }),
                            ),
                          ),
                        ),
                ],
              ),
            );
          });
        });
  }

  Widget cashFlowTileToScheme(Map data) {
    String nav_date = data['nav_date'] ?? "";
    num amount = data['cash_flow'] ?? 0;
    num units = data['units'] ?? 0;
    num current_value = data['current_value'] ?? 0;
    double Nav = data['nav'] ?? 0;
    num cashlength = Tocash.length;
    print("cashlength = $cashlength");
    String formattedNavDateString = "";
    if (nav_date.isNotEmpty) {
      try {
        // Parse the original date string to a DateTime object
        DateTime date = DateTime.parse(nav_date);

        // Format the DateTime object to the desired format
        formattedNavDateString = DateFormat('dd-MM-yyyy').format(date);

        // Print the formatted date
        print(formattedNavDateString); // Output: 01-07-2015
      } catch (e) {
        // Handle the error if the date string is invalid
        print('Error parsing the date: $e');
      }
    }
    return Container(
      height: 100,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedNavDateString,
                style:
                    AppFonts.f40013.copyWith(color: Config.appTheme.themeColor),
              ),
              Text(
                  (amount > 0)
                      ? "$rupee ${Utils.formatNumber(amount, isAmount: false)}"
                      : "$rupee ${Utils.formatNumber(amount, isAmount: false)}",
                  style: AppFonts.f50014Black.copyWith(
                      color: (amount > 0)
                          ? Config.appTheme.defaultProfit
                          : Config.appTheme.defaultLoss))
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Nav",
                  value: "$Nav",
                  alignment: CrossAxisAlignment.start),
              ColumnText(
                  title: "Units",
                  value: "${Utils.formatNumber(units)}",
                  alignment: CrossAxisAlignment.center),
              ColumnText(
                title: "Current Value",
                value: "$rupee ${Utils.formatNumber(current_value.round())}",
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RollingReturnsController extends GetxController {
  var scheme = "ICICI Prudential Smallcap Fund - Growth".obs;
  var selectedValues = "ICICI Prudential Smallcap Fund - Growth".obs;
  var selectedFromScheme = "ICICI Pru Liquid Gr".obs;
  var selectedToScheme = "ICICI Pru Equity & Debt Gr".obs;
  var initialLumpsumAmount = "200000".obs;
  var startDate = "05-07-2015".obs;
  var endDate = DateFormat('dd-MM-yyyy').format(
    DateTime.now().subtract(Duration(days: 1)),
  ).obs;
  var lumpsumDate = "01-07-2015".obs;
  var stpFrequency = "Monthly".obs;
  var stpAmount = "10000".obs;

  var shouldRefresh = false.obs;
  var isProcessingSelection = false.obs;
  final TextEditingController fromsearchController = TextEditingController();
  final TextEditingController tosearchController = TextEditingController();

  late TextEditingController initialLumpsumAmountController;
  late TextEditingController stpAmountController;

  @override
  void onInit() {
    super.onInit();
    stpAmountController = TextEditingController(text: "10000");
    initialLumpsumAmountController = TextEditingController(text: "200000");
    shouldRefresh.value = true;
  }

  @override
  void onClose() {
    // fromsearchController.dispose();
    // tosearchController.dispose();
    stpAmountController.dispose();
    initialLumpsumAmountController.dispose();
    super.onClose();
  }

  void selectScheme(String schemeName, int index) {
    if (isProcessingSelection.value) return;
  }
}
