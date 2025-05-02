import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/advisor/sip/AssociateWiseSip.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpFilterChip.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile2.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';

class RmWiseSip extends StatefulWidget {
  const RmWiseSip({super.key, this.branch = "", this.hasAppBar = false});
  final String branch;
  final bool hasAppBar;
  @override
  State<RmWiseSip> createState() => _RmWiseSipState();
}

class _RmWiseSipState extends State<RmWiseSip> {
  int user_id = GetStorage().read("mfd_id") ?? 0;
  String client_name = GetStorage().read("client_name") ?? "null";

  Future fetchChartData(String rm_name) async {
    EasyLoading.show();
    Map data = await Api.getAumHistoryByMonths(
      user_id: user_id,
      client_name: client_name,
      frequency: selectedMonth,
      type: "rm",
      type_user_name: rm_name,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return [];
    }

    EasyLoading.dismiss();
    List list = data['list'];
    return list;
  }

  int page_id = 1;
  num totalCount = 0, totalAum = 0;
  List investorList = [];

  Future getInitialInvestors() async {
    page_id = 1;

    Map data = await AdminApi.getRmWiseSipDetails(
      user_id: user_id,
      client_name: client_name,
      page_id: page_id,
      sort_by: selectedSort,
      branch: widget.branch,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    totalCount = data['total_investor_count'] ?? 0;
    totalAum = data['total_amount'] ?? 0;
    investorList = data['list'];
    isLoading = false;

    return 0;
  }

  Future getMoreInvestors() async {
    page_id++;

    EasyLoading.show();
    isLoading = true;

    Map data = await AdminApi.getRmWiseSipDetails(
      user_id: user_id,
      client_name: client_name,
      page_id: page_id,
      sort_by: selectedSort,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    List list = data['list'];
    investorList.addAll(list);

    isLoading = false;
    EasyLoading.dismiss();
    setState(() {});

    return 0;
  }

  bool isFirst = true;
  Future getDatas() async {
    if (!isFirst) return 0;

    await getInitialInvestors();

    isFirst = false;
    return 0;
  }

  ScrollController scrollController = ScrollController();
  Future scrollListener() async {
    bool atBottom = scrollController.position.extentAfter < 100;
    bool fullyLoaded = investorList.length == totalCount;

    bool fetchAgain = atBottom && !fullyLoaded && !isLoading;

    if (fetchAgain) await getMoreInvestors();
  }

  bool isLoading = true;

  @override
  void initState() {
    //  implement initState
    super.initState();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    //  implement dispose
    super.dispose();
    scrollController.removeListener(scrollListener);
  }

  late double devHeight, devWidth;
  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: (widget.hasAppBar)
          ? adminAppBar(
              hasAction: false, title: "RM wise SIP", bgColor: Colors.white)
          : null,
      body: FutureBuilder(
          future: getDatas(),
          builder: (context, snapshot) {
            return Column(
              children: [
                sortLine(),
                countLine(),
                listArea(),
              ],
            );
          }),
    );
  }

  bool showSortChip = true;
  Widget sortLine() {
    return Container(
      height: 60,
      width: devWidth,
      color: Config.appTheme.mainBgColor,
      padding: EdgeInsets.only(left: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SortButton(
              onTap: () {
                sortFilter(context);
              },
            ),
            SizedBox(width: 16),
            if (showSortChip)
              RpFilterChip(
                selectedSort: selectedSort,
                onClose: () async {
                  showSortChip = false;
                  selectedSort = "Alphabet";

                  await refreshPage();
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> refreshPage() async {
    EasyLoading.show();
    await getInitialInvestors();
    EasyLoading.dismiss();
    setState(() {});
  }

  Widget countLine() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Visibility(
        visible: !isLoading,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${investorList.length}  of $totalCount Items", style: f40012),
            Text(
                "Total SIP $rupee ${Utils.formatNumber(totalAum, isAmount: true)}",
                style: cardHeadingSmall.copyWith(
                    color: Config.appTheme.themeColor)),
          ],
        ),
      ),
    );
  }

  Widget listArea() {
    return Expanded(
        child: SingleChildScrollView(
            controller: scrollController,
            child: (isLoading)
                ? Utils.shimmerWidget(devHeight)
                : (investorList.isEmpty)
                    ? NoData()
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: investorList.length,
                        itemBuilder: (context, index) {
                          Map data = investorList[index];

                          String title = data['rm_name'];
                          num amount = data['amount'];
                          String branch = data['branch'];

                          return InkWell(
                            splashColor: Colors.transparent,
                            onTap: () async {
                              List list = await fetchChartData(title);
                              if (list.isEmpty) return;
                              List<ChartData> chartData = [];
                              list.forEach((element) {
                                chartData.add(ChartData.fromJson(element));
                              });
                              detailsBottomSheet(data, chartData);
                            },
                            child: RpListTile2(
                                leading: Image.asset("assets/tie_man.png",
                                    height: 30),
                                l1: title,
                                l2: "",
                                r1: Utils.formatNumber(amount, isAmount: true),
                                r2: ""),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: DottedLine(verticalPadding: 4),
                            ))));
  }

  List<String> bottomSheetFilter = ["Alphabet", "SIP"];
  String selectedSort = "SIP";

  // String selectedFilter = "Sort By";

  sortFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => Container(
        height: devHeight * 0.3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BottomSheetTitle(title: "Sort By"),
            Divider(height: 0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: bottomSheetFilter.length,
              itemBuilder: (context, index) {
                final option = bottomSheetFilter[index];
                return RadioListTile(
                  title: Text(option),
                  value: option,
                  groupValue: selectedSort,
                  onChanged: (value) async {
                    Get.back();
                    selectedSort = value ?? "";
                    showSortChip = true;
                    await refreshPage();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  detailsBottomSheet(Map data, List<ChartData> chartData) {
    String rmName = data["rm_name"];
    double sheetHeight = devHeight * 0.5;
    bool showChart = false;



    //  String netAfterExpense = Utils.formatNumber(data['net_after_expense']);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: cornerBorder),
        builder: (context) {
          return StatefulBuilder(builder: (context, bottomState) {
            return Container(
              height: sheetHeight,
              decoration: BoxDecoration(
                  borderRadius: cornerBorder, color: Colors.white),
              padding: EdgeInsets.only(left: 24, right: 24),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.close,
                            color:
                                Config.appTheme.placeHolderInputTitleAndArrow,
                          ))),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        rmName,
                        style: AppFonts.f50014Black,
                      ),
                      // RpChip(label: selectedMonth)
                    ],
                  ),
                  SizedBox(height: 24),

                  RowText(
                      title: "SIP Amount",
                      value: "$rupee ${Utils.formatNumber(data["sip_amount"])}"),
                  RowText(
                      title: "Monthly Amount",
                      value: "$rupee ${Utils.formatNumber(data["amount"])}"),
                  RowText(
                      title: "SIP Count",
                      value: "${data["sip_counts"]}"),
                  RowText(
                      title: "Current Cost",
                      value: "$rupee ${Utils.formatNumber(data["current_cost"])}"),
                  RowText(
                      title: "Current Value",
                      value: "$rupee ${Utils.formatNumber(data["current_value"])}"),
                  RowText(
                      title: "Abs Rtn (%)",
                      value: "${(data["abs_return"]).toStringAsFixed(2)}"),
                  RowText(
                      title: "Share (%)",
                      value: "${data["share"]}"),

                  Padding(
                    padding: EdgeInsets.all(16),
                    child: extraButton(
                      icon: Icon(Icons.account_circle_outlined,
                          color: Colors.white),
                      text: "View All Associate",
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Config.appTheme.buttonColor,
                      ),
                      onTap: () {
                        Get.back();
                        Get.to(() => AssociateWiseSip(rm: rmName));
                      },
                    ),
                  ),

               /*   (showChart)
                      ? chartArea(chartData, (val) async {
                          selectedMonth = monthList[val ?? 0];
                          List list = await fetchChartData(branch);
                          if (list.isEmpty) return;
                          chartData = [];
                          list.forEach((element) {
                            chartData.add(ChartData.fromJson(element));
                          });

                          bottomState(() {});
                        })
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: extraButton(
                            icon: Icon(Icons.history),
                            text: "View SIP History",
                            isWhite: false,
                            onTap: () {
                              sheetHeight = devHeight * 0.9;
                              showChart = true;
                              bottomState(() {});
                            },
                            trailing: Icon(Icons.add),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                          ),
                        ),*/
                  //SizedBox(height: 24),
                ],
              ),
            );
          });
        });
  }

  List<ChartData> getChartLegends(List<ChartData> chartData) {
    if (chartData.isEmpty) return [];
    int length = chartData.length;

    ChartData first = chartData.first;
    ChartData mid = chartData[length ~/ 2];
    ChartData last = chartData.last;
    return [first, mid, last];
  }

  String selectedMonth = "12 Months";
  List<String> monthList = ["12 Months", "24 Months", "36 Months"];

  Widget chartArea(List<ChartData> chartData, Function(int?)? onToggle) {
    List<ChartData> legends = getChartLegends(chartData);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("SIP History", style: AppFonts.f40016),
              ),
              rpChart(funChartData: chartData)
              // Obx(() {
              //   if (apiController.isChartAreaLoading.value) {
              //     return Utils.shimmerWidget(
              //       230,
              //       margin: EdgeInsets.fromLTRB(16, 36, 16, 0),
              //     );
              //   } else {
              //     return rpChart(funChartData: chartData);
              //   }
              // })
            ],
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(legends.length, (index) {
                ChartData curr = legends[index];
                return Text("${curr.aum_month}");
              }),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: ToggleSwitch(
              minWidth: 100,
              initialLabelIndex: monthList.indexOf(selectedMonth),
              onToggle: onToggle,
              labels: monthList,
              activeBgColor: [Colors.black],
              inactiveBgColor: Colors.white,
              borderColor: [Colors.grey.shade300],
              borderWidth: 1,
              dividerColor: Colors.grey.shade300,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget rpChart({required List<ChartData> funChartData}) {
    return Container(
      width: double.infinity,
      height: 250,
      //decoration: BoxDecoration(border: Border.all()),
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
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<ChartData, String>>[
          SplineAreaSeries(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Config.appTheme.themeColorDark.withOpacity(0.8),
                Config.appTheme.mainBgColor.withOpacity(0.2)
              ],
              tileMode: TileMode.mirror,
            ),
            borderColor: Config.appTheme.themeColor,
            borderWidth: 2,
            dataSource: funChartData,
            xValueMapper: (ChartData sales, _) => sales.aum_month,
            yValueMapper: (ChartData sales, _) => sales.current_value,
            dataLabelSettings: DataLabelSettings(isVisible: false),
          ),
        ],
      ),
    );
  }

  Widget extraButton(
      {required Icon icon,
      Decoration? decoration,
      String? text,
      Widget? trailing,
      Function()? onTap,
      bool isWhite = true}) {
    return Container(
      width: devWidth,
      height: 50,
      decoration: decoration,
      child: InkWell(
        onTap: onTap,
        child: Center(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              icon,
              SizedBox(width: 10),
              Text(text ?? "null",
                  style: TextStyle(
                      color: (isWhite) ? Colors.white : null,
                      fontWeight: FontWeight.w500)),
              Spacer(),
              trailing ??
                  Icon(Icons.arrow_forward,
                      color: (isWhite) ? Colors.white : null)
            ],
          ),
        )),
      ),
    );
  }
}

class ChartData {
  String? aum_month;
  num? current_value;
  ChartData({this.aum_month, this.current_value});

  ChartData.fromJson(Map<String, dynamic> json) {
    aum_month = json['aum_month'];
    current_value = json['current_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aum_month'] = aum_month;
    data['current_value'] = current_value;

    return data;
  }
}


/*

List list = [
  {
    "title": "Monthly Amount",
    "value": data["amount"],
  },
  {
    "title": "SIP Count",
    "value": data["sip_counts"],
  },
  {
    "title": "Current Cost",
    "value": data["current_cost"],
  },
  {
    "title": "Current Value",
    "value": data["current_value"],
  },
  {
    "title": "Abs Rtn",
    "value": data["abs_return"],
  }
];

ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      Map map = list[index];
                      String title = map['title'];
                      num value = map['value'];

                      String displayValue = (title != "SIP Count" && title != "Abs Rtn")
                          ? "$rupee ${Utils.formatNumber(value)}"
                          : Utils.formatNumber(value).toString();

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: AppFonts.f50014Black,
                            ),
                            Text(
                              "$displayValue",
                              style: AppFonts.f50014Black,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
*/

