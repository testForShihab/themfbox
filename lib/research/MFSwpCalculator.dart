import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:mymfbox2_0/rp_widgets/NoData.dart';

class MFSwpCalculator extends StatefulWidget {
  const MFSwpCalculator({super.key});

  @override
  State<MFSwpCalculator> createState() => _MFSwpCalculatorState();
}

class _MFSwpCalculatorState extends State<MFSwpCalculator> {
  late double devWidth, devHeight;
  int user_id = getUserId();
  String client_name = GetStorage().read("client_name");
  List allCategories = [];

  TextEditingController lumpsumDateController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController initialLumpsumAmountController =
      TextEditingController();

  TextEditingController swpAmountController = TextEditingController();

  String lumpsumDate = "08-06-2016";
  String startDate = "08-06-2016";
  String endDate = "16-12-2023";

  TextStyle underlineText = TextStyle(
      color: Config.appTheme.themeColor,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w500,
      fontSize: 13);

  int selectedRadioIndex = -1;
  int selectedToRadioIndex = -1;
  String selectedFromScheme = "ICICI Pru Small Cap Gr";
  String selectedRollingPeriod = "3 Years";
  String rollingPeriods = "3 Year";
  String scheme = "ICICI Prudential Smallcap Fund - Growth";
  String selectedValues = "ICICI Prudential Smallcap Fund - Growth";
  int percentage = 0;
  String shortName = "";
  String benchMarkName = "";
  double startingPoint = 0;

  List<ChartData> chartData = [];
  List<ChartData> chartData1 = [];
  ValueNotifier<String> tooltipDateNotifier =
      ValueNotifier<String>("13-11-2023");
  ValueNotifier<String> tooltipCurrentValueNotifier =
      ValueNotifier<String>("1234500");
  ValueNotifier<String> tooltipTotalWithdrawalNotifier =
      ValueNotifier<String>("1234500");
  String tooltipDate = "";
  String tooltipValue = "";
  bool isFirst = true;
  String initialLumpsumAmount = "1000000";
  String swpAmount = "3000";

  List<String> lumpsumAmountList = [
    "10,000",
    "1,00,000",
    "10,00,000",
  ];

  List<String> swpFrequencyList = [
    "weekly",
    "Fortnightly",
    "Monthly",
    "Quarterly",
  ];
  String swpFrequency = "Monthly";

  List<String> swpAmountList = [
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
  final List<FlSpot> data = [
    FlSpot(0, 3),
    FlSpot(1, 4),
    FlSpot(2, 3.5),
    FlSpot(3, 5),
    FlSpot(4, 4.5),
    FlSpot(5, 6),
  ];
  List rollingReturnBenchmarkList = [];
  List chartRollingReturnBenchmarkList = [];
  final List<String> months = [];
  List<double> series1Data = [];
  List<double> series2Data = [];
  List fundList = [];

  bool isLoading = true;

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
  Map swpCalculatorList = {};
  List cashFlow = [];
  List<dynamic> dateList = [];
  List<dynamic> currentValues = [];
  List<dynamic> cumulativeWithdrawals = [];
  Future getDatas() async {
    isLoading = true;
    await getTopLumpsumFunds();
    await getSwpReturns();
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
    });

    return 0;
  }

  Future getSwpReturns() async {
    String init_amount = initialLumpsumAmount.toString().replaceAll(',', '');
    String with_amount = swpAmount.toString().replaceAll(',', '');
    isLoading = true;
    chartData = [];
    Map data = await ResearchApi.getSwpReturns(
      user_id: user_id,
      client_name: client_name,
      frequency: swpFrequency,
      from_date: startDate,
      to_date: endDate,
      init_start_date: lumpsumDate,
      initial_amount: init_amount,
      withdrawal_amount: with_amount,
      scheme_name: Uri.encodeComponent(scheme),
    );
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    swpCalculatorList = data['result'];
    cashFlow = swpCalculatorList['scheme_list'];

    dateList = swpCalculatorList['date_list'];
    cumulativeWithdrawals = swpCalculatorList['cumulative_withdrawal'];

    currentValues = swpCalculatorList['current_value_graph'];

    chartData = List.generate(dateList.length, (index) {
      final dateParts = dateList[index].split('-');
      final date = DateTime(
        int.parse(dateParts[2]), // Year
        int.parse(dateParts[0]), // Month
        int.parse(dateParts[1]), // Day
      );
      return ChartData(
        dateList[index],
        cumulativeWithdrawals[index],
        currentValues[index],
      );
    });
    // print("chartData length =${chartData.length}");
    isLoading = false;

    return 0;
  }

  @override
  void initState() {
    super.initState();
    lumpsumDateController.text = lumpsumDate;
    startDateController.text = startDate;
    endDateController.text = endDate;
    initialLumpsumAmountController = TextEditingController(text: "1000000");
    swpAmountController = TextEditingController(text: "3000");
  }

  String formatDate(String dateString) {
    if (dateString.isEmpty) {
      return '';
    }
    DateTime dateTime = DateTime.parse(dateString);

    // Format the DateTime object into the desired format
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    return formattedDate;
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
              toolbarHeight: 340,
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
                        "MF SWP Calculator",
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
                          showSchemeBottomSheet();
                        },
                        child: appBarNewColumn(
                            "Select Scheme",
                            getFirst32(selectedFromScheme),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
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
                                "Initial Lumpsum Amount",
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
                                controller: initialLumpsumAmountController,
                                onChanged: (text) async {
                                  if (text.length <= 8) {
                                    initialLumpsumAmount = text;
                                    initialLumpsumAmount = text;
                                    print(
                                        "lumpsumAmount $initialLumpsumAmount");
                                    print("get lumpsumAmount ");
                                    setState(() {});
                                  } else {
                                    initialLumpsumAmountController.text =
                                        text.substring(0, 8);
                                    initialLumpsumAmountController.selection =
                                        TextSelection.fromPosition(
                                      TextPosition(
                                          offset: initialLumpsumAmountController
                                              .text.length),
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
                      //     showLumpsumAmountBottomSheet();
                      //   },
                      //   child: appBarColumn(
                      //       "Initial Lumpsum Amount",
                      //       Utils.getFirst13("$rupee $lumpsumAmount"),
                      //       Icon(Icons.keyboard_arrow_down,
                      //           color: Config.appTheme.themeColor)),
                      // ),
                      GestureDetector(
                        onTap: () {
                          lumpsumDateController.text = "";
                          lumpsumDate = "";
                          showDatePickerDialog(context, 0);
                        },
                        child: appBarColumn(
                            "Initial Lumpsum Date",
                            Utils.getFirst13(lumpsumDateController.text),
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
                          showSipFrequencyBottomSheet();
                        },
                        child: appBarColumn(
                            "SWP Frequency",
                            Utils.getFirst13(swpFrequency),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 28.0),
                              child: Text(
                                "Swp Amount",
                                style: AppFonts.f40013
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            Container(
                              width: devWidth * 0.42,
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
                                  LengthLimitingTextInputFormatter(8),
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
                                controller: swpAmountController,
                                onChanged: (text) async {
                                  if (text.length <= 8) {
                                    swpAmount = text;
                                    print("swpAmount $swpAmount");
                                    print("get swpAmount ");
                                    setState(() {});
                                  } else {
                                    swpAmountController.text =
                                        text.substring(0, 8);
                                    swpAmountController.selection =
                                        TextSelection.fromPosition(
                                      TextPosition(
                                          offset:
                                              swpAmountController.text.length),
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
                          startDateController.text = "";
                          startDate = "";
                          showDatePickerDialog(context, 1);
                        },
                        child: appBarColumn(
                            "Swp Start Date",
                            Utils.getFirst13(startDateController.text),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
                      ),
                      GestureDetector(
                        onTap: () {
                          endDateController.text = "";
                          endDate = "";
                          showDatePickerDialog(context, 2);
                        },
                        child: appBarColumn(
                            "Swp End Date",
                            Utils.getFirst13(endDateController.text),
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
          isLoading
              ? Utils.shimmerWidget(devHeight * 0.2, margin: EdgeInsets.all(20))
              : (cashFlow.isEmpty)
                  ? NoData()
                  : Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("SWP Summary",
                              style: AppFonts.f50014Grey,
                              textAlign: TextAlign.left),
                          SizedBox(height: 8),
                          swpSummaryCard(),
                        ],
                      ),
                    ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("SWP History",
                    style: AppFonts.f50014Grey, textAlign: TextAlign.left),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(4, 0, 4, 16),
            child: Column(
              children: [
                isLoading
                    ? Utils.shimmerWidget(
                        230,
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      )
                    : chartData.isEmpty
                        ? Padding(
                            padding: EdgeInsets.only(left: devWidth * 0.2),
                            child: Text("No Chart Data Available"))
                        : chartArea(chartData)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("SWP Cashflow",
                    style: AppFonts.f50014Grey, textAlign: TextAlign.left),
                SizedBox(height: 16),
                (cashFlow.isEmpty)
                    ? NoData()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: cashFlow.length,
                        itemBuilder: (context, index) {
                          Map data = cashFlow[index];
                          return cashFlowTile(index, data);
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cashFlowTile(int index, Map data) {
    String nav_date = formatDate(data['nav_date']);
    num cash_flow_amount = data['cash_flow'] ?? 0;
    num nav = data['nav'] ?? 0;
    num units = data['units'] ?? 0;
    String finalUnits = units.toStringAsFixed(3);
    num current_value = data['current_value'] ?? 0;
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
                nav_date,
                style: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.themeColor),
              ),
              Text("$rupee ${Utils.formatNumber(cash_flow_amount)}",
                  style: AppFonts.f50014Black.copyWith(
                      color: (cash_flow_amount > 0)
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
                value: Utils.formatNumber(double.parse(finalUnits)),
                valueStyle: AppFonts.f50014Black,
              ),
              ColumnText(
                title: "Current Value",
                value: "$rupee ${Utils.formatNumber(current_value.round())}",
                valueStyle: AppFonts.f50014Black,
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget swpSummaryCard() {
    String schemename = swpCalculatorList['scheme_name'] ?? '';
    String withdrawal_period =
        swpCalculatorList['scheme_withdrawal_period'] ?? '';
    num schemeinstallment = swpCalculatorList['scheme_installment'];
    num total_withdrawal_amount =
        swpCalculatorList['scheme_total_withdrawal_amount'];
    num scheme_returns = swpCalculatorList['scheme_returns'];
    num current_value = swpCalculatorList['scheme_current_value'];
    String current_date = swpCalculatorList['scheme_current_value_date'] ?? '';
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Column(
        children: [
          //1st row
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 16, 0, 0),
            child: Row(
              children: [
                // Image.asset("assets/48.png", height: 30),
                Image.network(swpCalculatorList["amc_logo"] ?? "", height: 30),
                SizedBox(width: 10),
                SizedBox(
                    width: 204,
                    child: Text("$schemename",
                        style: AppFonts.f50014Black
                            .copyWith(color: Config.appTheme.themeColor))),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 14),
                  decoration: BoxDecoration(
                      color: Color(0xffEDFFFF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      )),
                  child: Row(children: [
                    Text(swpCalculatorList['scheme_rating'] ?? '',
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
                DottedLine(),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Withdrawal Period",
                          style: AppFonts.f40013,
                        ),
                        RichText(
                          text: TextSpan(
                            style: AppFonts.f50014Black,
                            children: [
                              TextSpan(
                                text: "$withdrawal_period ",
                              ),
                              /* TextSpan(
                                text: "to ",
                                style: AppFonts.f40013.copyWith(fontSize: 14),
                              ),
                              TextSpan(
                                text: "12-07-2018",
                                style: AppFonts.f50014Black,
                              ),*/
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                DottedLine(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColumnText(
                        title: "Monthly Installments",
                        value: "$schemeinstallment"),
                    ColumnText(
                      title: "Total Withdrawal",
                      value:
                          "$rupee ${Utils.formatNumber(total_withdrawal_amount)}",
                      alignment: CrossAxisAlignment.end,
                    ),
                  ],
                ),
                DottedLine(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColumnText(
                        title: "Value on $current_date",
                        value:
                            "$rupee ${Utils.formatNumber(current_value.round())}"),
                    ColumnText(
                      title: "Returns",
                      value: "${scheme_returns.toStringAsFixed(2)}%",
                      alignment: CrossAxisAlignment.end,
                      valueStyle: AppFonts.f50014Black.copyWith(
                          color: (scheme_returns > 0)
                              ? Config.appTheme.defaultProfit
                              : Config.appTheme.defaultLoss),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget navDateAndReturns() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ValueListenableBuilder<String>(
            valueListenable: tooltipDateNotifier,
            builder: (context, tooltipDate, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    child: ColumnText(
                      title: "Date",
                      value: tooltipDate,
                      valueStyle: AppFonts.f50012.copyWith(color: Colors.black),
                    ),
                  ),
                ],
              );
            },
          ),
          ValueListenableBuilder<String>(
            valueListenable: tooltipCurrentValueNotifier,
            builder: (context, tooltipValue, child) {
              double tooltipValueNumeric = double.tryParse(tooltipValue) ?? 0;
              Color textColor = tooltipValueNumeric > 0
                  ? Config.appTheme.defaultProfit
                  : Config.appTheme.defaultLoss;

              return ColumnText(
                title: "Current Value",
                value: "$rupee ${Utils.formatNumber(tooltipValueNumeric)}",
                valueStyle: AppFonts.f50012.copyWith(color: textColor),
                alignment: CrossAxisAlignment.center,
              );
            },
          ),
          ValueListenableBuilder<String>(
            valueListenable: tooltipTotalWithdrawalNotifier,
            builder: (context, tooltipValue, child) {
              double tooltipValueNumeric = double.tryParse(tooltipValue) ?? 0;
              Color textColor = tooltipValueNumeric > 0
                  ? Config.appTheme.themeColor
                  : Config.appTheme.defaultLoss;

              return ColumnText(
                title: "Cumulative Withdrawal",
                value: "$rupee ${Utils.formatNumber(tooltipValueNumeric)}",
                valueStyle: AppFonts.f50012.copyWith(color: textColor),
                alignment: CrossAxisAlignment.end,
              );
            },
          ),
        ],
      ),
    );
  }

  String formatNewDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return ''; // Return an empty string or some default value
    }
    final inputFormat = DateFormat('dd-MM-yyyy');
    final dateTime = inputFormat.parse(dateStr);
    final outputFormat = DateFormat('dd MMM yyyy');
    return outputFormat.format(dateTime);
  }

  Widget chartArea(List<ChartData> chartData) {
    List<ChartData> legends = getChartLegends(chartData);

    List<List<ChartData>> multipleSeriesData = [
      chartData,
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           navDateAndReturns(),
          Stack(
            children: [
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16),
              //   child: Text("", style: AppFonts.f40016),
              // ),
              rpChart(chartData: chartData),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(legends.length, (index) {
                ChartData curr = legends[index];
                String? currDate = formatNewDate(curr.date);
                return Text(currDate, style: AppFonts.f40013);
              }),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget rpChart({required List<ChartData> chartData}) {
    if (chartData.isEmpty) return Utils.shimmerWidget(200);

    TrackballBehavior trackballBehavior = TrackballBehavior(
      enable: true,
      lineColor: Colors.red,
      lineWidth: 1,
      activationMode: ActivationMode.singleTap,
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
      // Show trackball initially
      shouldAlwaysShow: true,
    );

    // Add post-frame callback to trigger trackball at last point
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chartData.isNotEmpty) {
        trackballBehavior.show(
          chartData.length - 1, // Show for last data point
          0, // First series (Current Value)
        );
      }
    });

    return Container(
      width: devWidth,
      height: 250,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(top: 16),
      child: SfCartesianChart(
        margin: EdgeInsets.all(0),
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
            isVisible: false,
            majorGridLines: MajorGridLines(width: 0),
            rangePadding: ChartRangePadding.none),
        primaryYAxis: NumericAxis(
          isVisible: false,
          rangePadding: ChartRangePadding.additional,
        ),
        trackballBehavior: trackballBehavior,
        series: <CartesianSeries<ChartData, String>>[
          SplineAreaSeries(
            name: "Current Value",
            xValueMapper: (ChartData sales, _) => sales.date,
            yValueMapper: (ChartData sales, _) => sales.currentValue,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Config.appTheme.themeProfit.withOpacity(0.8),
                Config.appTheme.mainBgColor.withOpacity(0.2)
              ],
              tileMode: TileMode.mirror,
            ),
            borderColor: Color(0xFF388E3C),
            borderWidth: 2,
            dataSource: chartData,
            dataLabelSettings: DataLabelSettings(isVisible: false),
          ),
          SplineAreaSeries(
            name: "Cumulative",
            xValueMapper: (ChartData sales, _) => sales.date,
            yValueMapper: (ChartData sales, _) => sales.cumulativeWithdrawal,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0xFF64B5F6).withOpacity(0.8),
                Color(0xFF64B5F6).withOpacity(0.2)
              ],
              tileMode: TileMode.mirror,
            ),
            borderColor:Color(0xFF2196F3),
            borderWidth: 2,
            dataSource: chartData,
            dataLabelSettings: DataLabelSettings(isVisible: false),
          ),
        ],
      ),
    );
  }

  List<ChartData> getChartLegends(List<ChartData> chartData) {
    if (chartData.isEmpty) return [];
    int length = chartData.length;

    ChartData first = chartData.first;
    ChartData mid = chartData[length ~/ 2];
    ChartData last = chartData.last;
    return [first, mid, last];
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
                            itemCount: swpFrequencyList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  swpFrequency = swpFrequencyList[index];

                                  Get.back();
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: swpFrequency,
                                      value: swpFrequencyList[index],
                                      onChanged: (val) async {
                                        Get.back();
                                        setState(() {
                                          swpFrequency =
                                              swpFrequencyList[index];

                                          rollingReturnBenchmarkList = [];
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          swpFrequencyList[index],
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
              height: devHeight * 0.7,
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
                                  selectedRollingPeriod = rollingPeriod[index];
                                  if (rollingPeriod[index] == "1 Month") {
                                    rollingPeriods = "1 Month";
                                  } else if (rollingPeriod[index] == "1 Year") {
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
                                    rollingPeriods = "15 Years";
                                  } else {
                                    selectedRollingPeriod =
                                        rollingPeriod[index];
                                  }

                                  Get.back();
                                  setState(() {});
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

                                          rollingReturnBenchmarkList = [];
                                          chartRollingReturnBenchmarkList = [];
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

  showSchemeBottomSheet() {
    List<bool> isSelectedList = List.filled(fundList.length, false);
    List<String> selectedSchemes = List.filled(fundList.length, '');

    TextEditingController searchController = TextEditingController();

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
                      "Select Scheme",
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
                      return RadioListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(fundList[index]['scheme_amfi_short_name']),
                        value: index,
                        groupValue: selectedRadioIndex,
                        onChanged: (int? value) {
                          bottomState(() {
                            if (value != null) {
                              // Update selectedRadioIndex
                              setState(() {
                                selectedRadioIndex = value;
                                selectedValues = fundList[0]['scheme_amfi'];
                                // Set selected schemes
                                selectedSchemes = [];
                                selectedSchemes
                                    .add(fundList[value]['scheme_amfi']);

                                // Set selected fund
                                selectedFromScheme =
                                    fundList[value]['scheme_amfi_short_name'];
                                scheme = fundList[value]['scheme_amfi'];
                                // Apply the selected value
                                scheme = selectedSchemes.join(',');
                                rollingReturnBenchmarkList = [];
                                chartRollingReturnBenchmarkList = [];
                                bottomState(() {});
                                setState(() {});
                                Get.back();
                              });
                            }
                          });
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

  Widget appBarNewColumn(String title, String value, Widget suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14)),
        Container(
          width: devWidth * 0.91,
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

  Widget lineChart() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child: LineChart(
            LineChartData(
              minX: startingPoint,
              maxX: startingPoint + months.length.toDouble() - 1,
              // minY: 0,
              // maxY: 100,
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int skipInterval = 4;
                      String month = "";
                      if (value % skipInterval == 0) {
                        month = months.isNotEmpty
                            ? months[value.toInt() % months.length]
                            : '';
                      }
                      return Expanded(
                        child: Center(
                          child: Text(
                            month,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    getTitlesWidget: (value, meta) {
                      int percentage = (value + 5).toInt();

                      return Expanded(
                        child: Text(
                          '$percentage%',
                          style: TextStyle(
                            color: Config.appTheme.themeColor,
                            fontSize: 9,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: false, // Remove outer border line
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(months.length, (index) {
                    return FlSpot(index.toDouble(), series1Data[index]);
                  }),
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 1.5,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(
                    show: true,
                    color: Config.appTheme.themeColor.withOpacity(0.09),
                  ),
                  dotData: FlDotData(show: false),
                ),
                LineChartBarData(
                  spots: List.generate(months.length, (index) {
                    if (index < series2Data.length) {
                      return FlSpot(index.toDouble(), series2Data[index]);
                    } else {
                      return FlSpot(index.toDouble(), 0);
                    }
                  }),
                  isCurved: true,
                  color: Config.appTheme.themeColor,
                  barWidth: 1.5,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(
                    show: true,
                    color: Config.appTheme.themeColorDark.withOpacity(
                        0.09), // Adjust opacity and color as needed
                  ),
                  // belowBarData: BarAreaData(
                  //     show: true,
                  //     gradient: LinearGradient(
                  //         begin: Alignment.bottomRight,
                  //         stops: [
                  //           0.5,
                  //           0.9
                  //         ],
                  //         colors: [
                  //           Config.appTheme.themeColor.withOpacity(.5),
                  //           Config.appTheme.themeColorDark.withOpacity(.6),
                  //         ])),
                  dotData: FlDotData(show: false),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.blue.withOpacity(0.8),
                  tooltipRoundedRadius: 6,
                  maxContentWidth: 400,
                  tooltipPadding: EdgeInsets.all(8),
                  getTooltipItems: (List<LineBarSpot> touchedSpots) {
                    return touchedSpots.map((LineBarSpot touchedSpot) {
                      final TextStyle textStyle = TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                      );

                      // Concatenate month, series1 data, and series2 data
                      String tooltipText = '';
                      String month = months.isNotEmpty
                          ? months[touchedSpot.x.toInt() % months.length]
                          : '';
                      month = month.replaceAll('\n', ' ');
                      String series1Text = touchedSpot.barIndex == 0
                          ? '$shortName ${touchedSpot.y}'
                          : '';
                      String series2Text = touchedSpot.barIndex == 1
                          ? '$benchMarkName ${touchedSpot.y}'
                          : '';
                      tooltipText =
                          '$month\n$series1Text${touchedSpot.barIndex == 1 ? series2Text : ''}';

                      return LineTooltipItem(
                        tooltipText,
                        textStyle,
                        textAlign: TextAlign.left,
                      );
                    }).toList();
                  },
                ),
                handleBuiltInTouches: true,
                touchSpotThreshold: 16,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12,
              height: 12,
              color: Colors.blue,
            ),
            Expanded(
              child: Text(
                shortName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: 12,
              height: 12,
              color: Config.appTheme.themeColor,
            ),
            Expanded(
              child: Text(
                benchMarkName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
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

  //                                         rollingReturnBenchmarkList = [];
  //                                       });
  //                                     },
  //                                   ),
  //                                   Expanded(
  //                                     child: Container(
  //                                       child: Text(
  //                                         lumpsumAmountList[index],
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

  showSwpAmountBottomSheet() {
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
                      Text("Select Stp Amount",
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
                            itemCount: swpAmountList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  swpAmount = swpAmountList[index];
                                  Get.back();
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: swpAmount,
                                      value: swpAmountList[index],
                                      onChanged: (val) async {
                                        Get.back();
                                        setState(() {
                                          swpAmount = swpAmountList[index];

                                          rollingReturnBenchmarkList = [];
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          swpAmountList[index],
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

  void showDatePickerDialog(BuildContext context, int dateType) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      if (dateType == 0) {
        lumpsumDateController.text = formattedDate;
        lumpsumDate = formattedDate;
        setState(() {
          lumpsumDate = formattedDate;
        });
      } else if (dateType == 1) {
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
      rollingReturnBenchmarkList = [];
    }
  }

  String getFirst32(String text) {
    String s = text.split(":").last;
    if (s.length > 32) s = s.substring(0, 32);
    return s;
  }
}

class ChartData {
  final String? date;
  final double cumulativeWithdrawal;
  final double currentValue;

  ChartData(this.date, this.cumulativeWithdrawal, this.currentValue);

  // ChartData.fromJson(Map<String, dynamic> json) {
  //   String navDate = json['nav_date'];
  //   String forwardDate = json['scheme_forward_date'];

  //   DateTime formatNavDate = DateTime.parse(navDate);
  //   DateTime formatForwardDate = DateTime.parse(forwardDate);

  //   String newNavDate = DateFormat('MMM yyyy').format(formatNavDate);
  //   String newForwardDate = DateFormat('MMM yyyy').format(formatForwardDate);
  //   String finalDate = "$newNavDate-\n$newForwardDate";

  //   nav_date = finalDate;

  //   String topNewNavDate = DateFormat('dd-MM-yyyy').format(formatNavDate);
  //   String topNewForwardDate =
  //       DateFormat('dd-MM-yyyy').format(formatForwardDate);

  //   dateFormatNav = "$topNewNavDate to\n$topNewForwardDate";

  //   scheme_forward_date = json['scheme_forward_date'];
  //   scheme_rolling_returns = json['scheme_rolling_returns'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['nav_date'] = nav_date;
  //   data['scheme_forward_date'] = scheme_forward_date;
  //   data['scheme_rolling_returns'] = scheme_rolling_returns;

  //   return data;
}

class ChartData1 {
  String? nav_date;
  String? dateFormatNav;
  String? scheme_forward_date;
  num? scheme_rolling_returns;

  ChartData1(
      {this.nav_date, this.scheme_forward_date, this.scheme_rolling_returns});

  ChartData1.fromJson(Map<String, dynamic> json) {
    String navDate = json['nav_date'];
    String forwardDate = json['scheme_forward_date'];

    DateTime formatNavDate = DateTime.parse(navDate);
    DateTime formatForwardDate = DateTime.parse(forwardDate);

    String newNavDate = DateFormat('MMM yyyy').format(formatNavDate);
    String newForwardDate = DateFormat('MMM yyyy').format(formatForwardDate);
    String finalDate = "$newNavDate -\n$newForwardDate";
    String topNewNavDate = DateFormat('dd-MM-yyyy').format(formatNavDate);
    String topNewForwardDate =
        DateFormat('dd-MM-yyyy').format(formatForwardDate);

    dateFormatNav = "$topNewNavDate to\n$topNewForwardDate";
    nav_date = finalDate;
    scheme_forward_date = json['scheme_forward_date'];
    scheme_rolling_returns = json['scheme_rolling_returns'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nav_date'] = nav_date;
    data['scheme_forward_date'] = scheme_forward_date;
    data['scheme_rolling_returns'] = scheme_rolling_returns;

    return data;
  }
}
