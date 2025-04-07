import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/rp_widgets/RpFilterChip.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../api/Api.dart';
import '../../api/BrokerageApi.dart';
import '../../api/ReportApi.dart';
import '../../pojo/AmcWiseBrokeragePojo.dart';
import '../../rp_widgets/AdminAppBar.dart';

class AmcWiseBrokerage extends StatefulWidget {
  const AmcWiseBrokerage({super.key});

  @override
  State<AmcWiseBrokerage> createState() => _AmcWiseBrokerageState();
}

class _AmcWiseBrokerageState extends State<AmcWiseBrokerage> {
  late double devWidth, devHeight;
  int user_id = GetStorage().read('mfd_id');
  String client_name = GetStorage().read("client_name");
  bool isLoading = true;
  List<dynamic> amcListPojo = [];
  List amcList = [];
  num total_aum = 0;

  List<String> chartFilterList = ["12 Months", "24 Months", "36 Months"];
  String selectedAmc = "";

  Map bottomSheetFilter = {
    "Sort by": ['Alphabet', 'Amount'],
    "ARN": ['111', '222']
  };
  String selectedLeft = "Financial Year";
  String selectedSort = "Amount";
  String selectedArn = "All";

  bool sortContainer = true;
  bool sortArn = true;

  String selectedFinancialYear = "";
  List financialYearList = [];

  List brokerageMonthList = [];

  Future getBrokerageMonthList() async {
    if (brokerageMonthList.isNotEmpty) return 0;

    Map data = await BrokerageApi.getBrokerageMonthList(
        user_id: user_id, client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    brokerageMonthList = data['result'];
    // selectedAmcMonth = brokerageMonthList.first;

    return 0;
  }

  Future getbrokerageFinancialYearList() async {
    if (financialYearList.isNotEmpty) return 0;

    Map data = await BrokerageApi.getbrokerageFinancialYearList(
      user_id: user_id,
      client_name: client_name,
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    financialYearList = data['list'];
    selectedFinancialYear = financialYearList.first;
    print("length ${financialYearList.length}");
    return 0;
  }

  Future getAmcWiseBrokerage() async {
    if (amcList.isNotEmpty) return 0;
    Map data = await BrokerageApi.getAmcWiseBrokerage(
      user_id: user_id,
      client_name: client_name,
      month: selectedAmcMonth!,
      max_count: "",
      sort_by: "aum",
      broker_code: selectedArn,
      fin_year: selectedFinancialYear!,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    amcList = data['result'];
    total_aum = data['total_aum'];
    return 0;
  }

  List<ChartData> chartData = [];

  Future getBrokerageHistoryDetails(String name) async {
    EasyLoading.show();
    Map data = await BrokerageApi.getBrokerageHistoryDetails(
        user_id: user_id,
        client_name: client_name,
        frequency: "Last $selectedMonths",
        amc_name: name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    EasyLoading.dismiss();

    List list = data['result'];
    convertToChartObj(list);

    return 0;
  }

  convertToChartObj(List list) {
    chartData = [];
    for (var element in list) {
      chartData.add(ChartData.fromJson(element));
    }
  }

  List arnList = [];

  Future getArnList() async {
    if (arnList.isNotEmpty) return 0;
    Map data = await Api.getArnList(client_name: client_name);
    try {
      if (data['status'] != 200) {
        Utils.showError(context, data['msg']);
        return 0;
      }
      arnList = [
        "All",
        data['broker_code_1'],
        data['broker_code_2'],
        data['broker_code_3']
      ];
      arnList.removeWhere((element) => element.isEmpty);
      bottomSheetFilter['ARN'] = arnList;
    } catch (e) {
      print("getArnList exception = $e");
    }
    return 0;
  }

  Future getDatas() async {
    await getbrokerageFinancialYearList();
    await getAmcWiseBrokerage();
    await getArnList();
    await getBrokerageMonthList();
    isLoading = false;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: adminAppBar(
              title: "AMC Wise Brokerage",
              bgColor: Colors.white,
              hasAction: false,
              suffix: SortButton(
                  title: selectedFinancialYear.isNotEmpty
                      ? selectedFinancialYear
                      : selectedAmcMonth.isNotEmpty
                          ? selectedAmcMonth
                          : "Select Period",
                  textStyle: AppFonts.f50012,
                  onTap: () {
                    showMonthYearBottomSheet(
                      selectfinancial: selectedFinancialYear,
                      selectAmcMonth: selectedAmcMonth,
                      monthList: brokerageMonthList,
                      financial_onChanged: (val) async {
                        selectedAmcMonth = "";
                        selectedFinancialYear = val!;

                        Get.back();
                        amcList = [];
                        setState(() {});
                        await getAmcWiseBrokerage();
                      },
                      AMC_onChanged: (val) async {
                        selectedAmcMonth = val!;
                        selectedFinancialYear = "";
                        Get.back();
                        amcList = [];
                        setState(() {});
                        await getAmcWiseBrokerage();
                      },
                    );
                  }),
            ),
            body: Column(
              children: [
                sortLine(),
                countLine(),
                isLoading ? Utils.shimmerWidget(devHeight - 200) :
                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: amcList.length,
                      itemBuilder: (context, index) {
                        dynamic amcPojo = amcList[index];
                        return amcWiseBrokerageTile(amcPojo);
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          DottedLine(verticalPadding: 5),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget sortLine() {
    return Container(
      height: 60,
      width: devWidth,
      color: Config.appTheme.mainBgColor,
      padding: EdgeInsets.only(left: 15),
      child: Row(
        children: [
          SortButton(onTap: () {
            sortFilter();
          }),
          SizedBox(width: 16),
          if (selectedArn != "All") RpFilterChip(selectedSort: selectedArn)
        ],
      ),
    );
  }

  Widget countLine() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Visibility(
        visible: !isLoading,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${amcList.length} Items"),
            Text(
                "Total Brokerage $rupee ${Utils.formatNumber(total_aum, isAmount: true)}",
                style: TextStyle(color: Config.appTheme.themeColor))
          ],
        ),
      ),
    );
  }

  sortFilter() {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return Container(
              height: devHeight * 0.4,
              decoration: BoxDecoration(
                  borderRadius: cornerBorder, color: Colors.white),
              child: Column(
                children: [
                  //sort & filter , close
                  BottomSheetTitle(title: "Sort & filter"),
                  Divider(height: 0),
                  Expanded(
                    child: Row(
                      children: [
                        leftContent(bottomState),
                        Expanded(child: rightContent())
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String selectedAmcMonth = "";

  void showMonthYearBottomSheet({
    required String selectfinancial,
    required String selectAmcMonth,
    Function(String?)? financial_onChanged,
    Function(String?)? AMC_onChanged,
    required List monthList,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return Container(
              height: devHeight * 0.6,
              decoration: BoxDecoration(
                borderRadius: cornerBorder,
              ),
              child: Column(
                children: [
                  BottomSheetTitle(title: "Select Period"),
                  Expanded(
                    child: Row(
                      children: [
                        // Left content
                        Container(
                          width: devWidth * 0.35,
                          color: Config.appTheme.mainBgColor,
                          child: ListView.builder(
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              List<String> titles = [
                                "Financial Year",
                                "Month Wise"
                              ];
                              String title = titles[index];
                              return InkWell(
                                onTap: () {
                                  bottomState(() {
                                    selectedLeft = title;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  color: selectedLeft == title
                                      ? Colors.white
                                      : Colors.transparent,
                                  child: Center(
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                        color: selectedLeft == title
                                            ? Config.appTheme.themeColor
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // Right content
                        Expanded(
                            child: selectedLeft == "Financial Year"
                                ? ListView.builder(
                                    itemCount: financialYearList.length,
                                    itemBuilder: (context, index) {
                                      String title = financialYearList[index];
                                      return InkWell(
                                        onTap: () {
                                          bottomState(() {
                                            selectfinancial = title;
                                          });
                                          financial_onChanged?.call(title);
                                        },
                                        child: Row(
                                          children: [
                                            Radio<String>(
                                              value: title,
                                              groupValue: selectfinancial,
                                              onChanged: (value) {
                                                bottomState(() {
                                                  selectfinancial = value!;
                                                });
                                                financial_onChanged
                                                    ?.call(value);
                                              },
                                            ),
                                            SizedBox(width: 5),
                                            Text(title),
                                          ],
                                        ),
                                      );
                                    },
                                  ) : ListView.builder(
                                    itemCount: monthList.length,
                                    itemBuilder: (context, index) {
                                      String title = monthList[index];
                                      return InkWell(
                                        onTap: () {
                                          bottomState(() {
                                            selectAmcMonth = title;
                                          });
                                          AMC_onChanged?.call(title);
                                        },
                                        child: Row(
                                          children: [
                                            Radio<String>(
                                              value: title,
                                              groupValue: selectAmcMonth,
                                              onChanged: (value) {
                                                bottomState(() {
                                                  selectAmcMonth = value!;
                                                });
                                                AMC_onChanged?.call(value);
                                              },
                                            ),
                                            SizedBox(width: 5),
                                            Text(title),
                                          ],
                                        ),
                                      );
                                    },

                                  ),
                                )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget leftContent(void Function(void Function() Function) bottomState) {
    return Container(
      width: devWidth * 0.35,
      color: Config.appTheme.mainBgColor,
      child: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          List list = bottomSheetFilter.keys.toList();
          String title = list[index];
          return (selectedLeft == title)
              ? bottomLeftSelectedBtn(title: title)
              : bottomLeftBtn(
                  title: title,
                  onTap: () {
                    selectedLeft = title;
                    bottomState(() {});
                  });
        },
      ),
    );
  }

  Widget rightContent() {
    if (selectedLeft == 'Sort by')
      return sortView();
    else
      return arnView();
  }

  Widget bottomLeftBtn({required String title, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(title),
        ),
      ),
    );
  }

  Widget bottomLeftSelectedBtn({required String title}) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        width: double.maxFinite,
        color: Colors.white,
        child: Center(
            child: Text(title,
                style: TextStyle(color: Config.appTheme.themeColor))),
      ),
    );
  }

  Widget sortView() {
    return ListView.builder(
      itemCount: bottomSheetFilter['Sort by'].length,
      itemBuilder: (context, index) {
        List list = bottomSheetFilter['Sort by'];

        return InkWell(
          onTap: () {
            selectedSort = list[index];
            applySort();
            sortContainer = true;
            Get.back();
            setState(() {});
          },
          child: Row(
            children: [
              Radio(
                  value: list[index],
                  groupValue: selectedSort,
                  onChanged: (val) {
                    selectedSort = list[index];
                    applySort();
                    sortContainer = true;
                    Get.back();
                    setState(() {});
                  }),
              Text(list[index]),
            ],
          ),
        );
      },
    );
  }

  Widget arnView() {
    return ListView.builder(
      itemCount: bottomSheetFilter['ARN'].length,
      itemBuilder: (context, index) {
        List list = bottomSheetFilter['ARN'];
        String title = list[index];

        return InkWell(
          onTap: () {
            selectedArn = title;
            sortArn = true;
            amcList = [];
            Get.back();
            setState(() {});
          },
          child: Row(
            children: [
              Radio(
                  value: title,
                  groupValue: selectedArn,
                  onChanged: (val) {
                    selectedArn = title;
                    sortArn = true;
                    amcList = [];
                    Get.back();
                    setState(() {});
                  }),
              Text(title),
            ],
          ),
        );
      },
    );
  }

  chartBottomSheet(
      {required String logo, required String amcName, required String amount}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: cornerBorder),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  BottomSheetTitle(
                      title: "", padding: EdgeInsets.only(right: 16, top: 16)),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Image.network(logo, height: 32),
                        Utils.getImage(logo, 32),
                        SizedBox(width: 10),
                        Expanded(child: Text(amcName, style: AppFonts.f50014Black)),
                        // Spacer(),
                        // Text("$rupee $amount", style: AppFonts.f50014Black)
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  chartArea(
                      amcName: amcName,
                      onToggle: (val) async {
                        selectedMonths = monthList[val ?? 0];
                        await getBrokerageHistoryDetails(amcName);
                        bottomState(() {});
                      }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget amcWiseBrokerageTile(Map data) {
    if (isLoading) return Utils.shimmerWidget(100, margin: EdgeInsets.all(16));

    // String? logo = amcPojo.logo;
    // String? amcName = amcPojo.amcName;
    // num? amount = amcPojo.brokerageAmount ?? 0;

    String amcName = data["amc_name"];
    String? amount =
        Utils.formatNumber(data["brokerage_amount"], isAmount: true);
    String logo = data['logo'];
    List<dynamic>? list = data["list"];

    return GestureDetector(
      onTap: (list != null && list.isNotEmpty)
          ? () async {
              await getBrokerageHistoryDetails(amcName);
              chartBottomSheet(amcName: amcName, logo: logo, amount: amount);
            }
          : null,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Row(
          children: [
            //Image.network(logo!, height: 30),
            Utils.getImage(logo!, 30),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                amcName!,
                style: AppFonts.f50014Black,
              ),
            ),
            SizedBox(width: 10),
            Text(
              "$rupee $amount",
              style: AppFonts.f50014Black,
            ),
            SizedBox(width: 5),
            if (list != null && list.isNotEmpty)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0XFFB4B4B4),
              ),
          ],
        ),
      ),
    );
  }

  String selectedMonths = "12 Months";

  Widget chartArea({required String amcName, Function(int?)? onToggle}) {
    if (isLoading) return Utils.shimmerWidget(300, margin: EdgeInsets.zero);

    List<ChartData> legends = getChartLegends();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("AMC wise Brokerage", style: AppFonts.f40016),
          ),
          SizedBox(height: 16),
          rpChart(funChartData: chartData),
          SizedBox(height: 16),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: List.generate(legends.length, (index) {
          //     ChartData curr = legends[index];
          //     return Text("${curr.month}");
          //   }),
          // ),
          // SizedBox(height: 20),
          // Center(
          //   child: ToggleSwitch(
          //     minWidth: 100,
          //     initialLabelIndex: monthList.indexOf(selectedMonths),
          //     onToggle: onToggle,
          //     labels: monthList,
          //     activeBgColor: [Colors.black],
          //     inactiveBgColor: Colors.white,
          //     borderColor: [Colors.grey.shade300],
          //     borderWidth: 1,
          //     dividerColor: Colors.grey.shade300,
          //   ),
          // ),
          // SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget rpChart({required List<ChartData> funChartData}) {
    return Container(
      width: double.infinity,
      height: 290,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(top: 16),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          labelRotation: 270,
          labelStyle: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold), // Reduced X-axis label size
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          interval: 100000,
          labelFormat: '{value}',
          labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          numberFormat: NumberFormat.decimalPattern(),
          axisLabelFormatter: (AxisLabelRenderDetails details) {
            double value = (details.value).toDouble();
            return ChartAxisLabel('${(value / 100000).toStringAsFixed(0)}L',
                TextStyle(fontSize: 10));
          }, // Reduced Y-axis label size
        ),
        // title: ChartTitle(text: 'Brokerage Amount per AMC'),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<dynamic, dynamic>>[
          ColumnSeries<dynamic, dynamic>(
            dataSource: funChartData,
            xValueMapper: (data, _) => data.month,
            yValueMapper: (data, _) => data.brokerageAmount,
            name: 'Brokerage',
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              angle: 270,
              offset: Offset(0, 8),
            ),
          )
        ],
      ),
    );
  }

  List<ChartData> getChartLegends() {
    if (chartData.isEmpty) return [];
    int length = chartData.length;

    ChartData first = chartData.first;
    ChartData mid = chartData[length ~/ 2];
    ChartData last = chartData.last;
    return [first, mid, last];
  }

  appBar() {
    return PreferredSize(
      preferredSize: Size(devWidth, 85),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 32),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back)),
                Text("Amc Wise Brokerage", style: AppFonts.appBarTitle)
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${amcList.length} Items",
                    style: AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                  ),
                  Text("Total ₹$total_aum",
                      style: AppFonts.f50014Black
                          .copyWith(color: Config.appTheme.themeColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  applySort() {
    if (selectedSort == 'Alphabet') {
      amcListPojo.sort((a, b) {
        final amcShortNameA = a.amcName ?? '';
        final amcShortNameB = b.amcName ?? '';
        return amcShortNameA.compareTo(amcShortNameB);
      });
    }
    if (selectedSort == "Amount") {
      amcListPojo
          .sort((a, b) => b.brokerageAmount!.compareTo(a.brokerageAmount!));
    }
  }
}

class ChartData {
  String? month;
  num? brokerageAmount;

  ChartData({this.month, this.brokerageAmount});

  ChartData.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    brokerageAmount = json['brokerage_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['month'] = month;
    data['brokerage_amount'] = brokerageAmount;

    return data;
  }
}
