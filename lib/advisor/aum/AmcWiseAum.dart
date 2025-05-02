// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/advisor/aum/SchemeWiseAum.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/pojo/aum/AmcWiseAumPojo.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpFilterChip.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AmcWiseAum extends StatefulWidget {
  const AmcWiseAum({super.key});

  @override
  State<AmcWiseAum> createState() => _AmcWiseAumState();
}

class _AmcWiseAumState extends State<AmcWiseAum> {
  // final AmcController apiController = Get.put(AmcController());

  late double devHeight, devWidth;
  List<AmcWiseAumPojo> amcListPojo = [];
  late int user_id;
  late String client_name;
  Map bottomSheetFilter = {
    "Sort by": ['Alphabet', 'AUM'],
    "ARN": ['111', '222'],
  };
  String selectedLeft = "Sort by";
  String selectedSort = "AUM";
  String selectedArn = "All";
  bool isLoading = true;
  List financialYears = [];
  String selectedFinancialYear = "";
  bool isVisible = false;
  int type_id = GetStorage().read("type_id");

  @override
  void initState() {
    //  implement initState
    super.initState();
  }

  num itemCount = 0;
  num totalAum = 0;

  Future getTopAmc() async {
    if (amcListPojo.isNotEmpty) return 0;
    try {
      isLoading = true;
      Map data = await Api.getAMCWiseAum(
          user_id: "$user_id",
          client_name: client_name,
          max_count: "",
          broker_code: selectedArn,
          sort_by: "aum");
      if (data['status'] != 200) {
        Utils.showError(context, data['msg']);
        return 0;
      }
      List list = data['list'];
      totalAum = data['total_aum'];
      itemCount = data['total_count'];

      convertListToObj(list);
    } catch (e) {
      print("getTopAmc exception = $e");
    }

    isLoading = false;

    return 0;
  }

  convertListToObj(List list) {
    amcListPojo = [];
    for (var element in list) {
      amcListPojo.add(AmcWiseAumPojo.fromJson(element));
    }
    sortOptions();
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
    try {
      user_id = GetStorage().read("mfd_id");
      client_name = GetStorage().read("client_name");
    } catch (e) {
      print("read exception 84 = $e");
    }
    await getTopAmc();
    await getArnList();
    return 0;
  }

  Future fetchChartData(
      {required String financialYear, required String amc}) async {
    Map data = await Api.getAMCMonthWiseAumHistory(
      user_id: "$user_id",
      client_name: client_name,
      fin_year: selectedFinancialYear,
      broker_code: '',
      amc: amc,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return [];
    }
    List chartList = data['history'];

    return chartList;
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
                title: "AMC Wise AUM", bgColor: Colors.white, hasAction: false),
            body: Column(
              children: [
                if(type_id == UserType.ADMIN)
                sortLine(),
                countLine(),
                listArea(),
              ],
            ),
          );
        });
  }

  bool showSortChip = true;
  Widget sortLine() {
    return Container(
      height: 60,
      width: devWidth,
      color: Config.appTheme.mainBgColor,
      padding: EdgeInsets.only(left: 15),
      child: Row(
        children: [
          SortButton(
            onTap: () {
              sortFilter();
            },
          ),
          SizedBox(width: 16),
          if (showSortChip)
            RpFilterChip(
              selectedSort: selectedSort,
              onClose: () {
                selectedSort = "Alphabet";
                showSortChip = false;
                sortOptions();
                setState(() {});
              },
            ),
          SizedBox(width: 8),
          if (selectedArn != "All")
            RpFilterChip(
              selectedSort: selectedArn,
              onClose: () {
                selectedArn = "All";
                amcListPojo = [];
                setState(() {});
              },
            ),
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
            Text("$itemCount Items"),
            Text(
                "Total AUM $rupee ${Utils.formatNumber(totalAum, isAmount: true)}",
                style: TextStyle(color: Config.appTheme.themeColor))
          ],
        ),
      ),
    );
  }

  String? amcName = "";
  Widget listArea() {
    return Expanded(
      child: SingleChildScrollView(
        child: (isLoading)
            ? Utils.shimmerWidget(devHeight)
            : ListView.separated(
                shrinkWrap: true,
                itemCount: amcListPojo.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  AmcWiseAumPojo amcPojo = amcListPojo[index];
                  return ListTile(
                    onTap: () async {
                      if(type_id == UserType.ADMIN){
                        Map data = await Api.getAumFinYear(
                          user_id: user_id,
                          client_name: client_name,
                          broker_code: "",
                          amc: "${amcPojo.amcName}",
                        );

                        financialYears = data['result'];
                        if (financialYears.length > 1 &&
                            financialYears.isNotEmpty) {
                          isVisible = true;
                        }

                        selectedFinancialYear = financialYears[0];
                        EasyLoading.show();
                        List list = await fetchChartData(
                            financialYear: selectedFinancialYear,
                            amc: "${amcPojo.amcName}");
                        if (list.isEmpty) return;
                        List<ChartData> chartData = [];
                        list.forEach((element) {
                          chartData.add(ChartData.fromJson(element));
                        });
                        EasyLoading.dismiss();
                        schemeDetailsBottomSheet(amcPojo, chartData);
                      }
                    },
                    //leading: Image.network("${amcPojo.amcLogo}", width: setImageSize(30)),
                    leading:
                        Utils.getImage("${amcPojo.amcLogo}", setImageSize(30)),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: devWidth * 0.3,
                          child: Text("${amcPojo.amcShortName}",
                              style: cardHeadingSmall),
                        ),
                        Text(
                          "$rupee ${Utils.formatNumber(amcPojo.aumAmount ?? 0, isAmount: false)}",
                          style: cardHeadingSmall,
                        ),
                        Text("(${amcPojo.aumPercentage}%)",
                            style: AppFonts.f40013),
                        if(type_id == UserType.ADMIN)
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Config.appTheme.placeHolderInputTitleAndArrow,
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    height: 1,
                    color: Config.appTheme.lineColor,
                  ),
                ),
              ),
      ),
    );
  }

  schemeDetailsBottomSheet(AmcWiseAumPojo amcPojo, List<ChartData> chartData) {
    bool showChart = false;
    amcName = amcPojo.amcName;
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
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: cornerBorder,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BottomSheetTitle(title: ""),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              //Image.network("${amcPojo.amcLogo}", height: setImageSize(30)),
                              Utils.getImage(
                                  "${amcPojo.amcLogo}", setImageSize(30)),
                              SizedBox(width: 10),
                              Expanded(
                                  child: Text("${amcPojo.amcShortName}",
                                      style: AppFonts.f50014Black)),
                              Text(
                                "$rupee ${Utils.formatNumber(amcPojo.aumAmount ?? 0, isAmount: false)}",
                                style: AppFonts.f50014Black,
                              ),
                              Text(" (${amcPojo.aumPercentage}%)",
                                  style: AppFonts.f40013),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Current Cost", style: AppFonts.f40013),
                              Text(
                                  "$rupee ${Utils.formatNumber(amcPojo.aumCurrentCost ?? 0, isAmount: true)}",
                                  style: AppFonts.f40013)
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: extraButton(
                            icon: Icon(Icons.menu, color: Colors.white),
                            text: "View All Schemes",
                            onTap: () {
                              Get.to(
                                SchemeWiseAum(amc: "${amcPojo.amcName}"),
                              );
                            },
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Config.appTheme.buttonColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        (showChart)
                            ? chartArea(chartData, amcName!, (int? val) async {
                                selectedFinancialYear =
                                    financialYears[val ?? 0];
                                EasyLoading.show();
                                List list = await fetchChartData(
                                    financialYear: selectedFinancialYear,
                                    amc: amcName!);
                                chartData = [];

                                list.forEach((element) {
                                  chartData.add(ChartData.fromJson(element));
                                });

                                EasyLoading.dismiss();
                                bottomState(() {});
                              })
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: extraButton(
                                  icon: Icon(Icons.history),
                                  text: "View AUM History",
                                  isWhite: false,
                                  onTap: () {
                                    showChart = true;
                                    bottomState(() {});
                                  },
                                  trailing: Icon(Icons.add),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.grey.shade400)),
                                ),
                              ),
                        SizedBox(height: 16),
                      ],
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

  List<ChartData> getChartLegends(List<ChartData> chartData) {
    if (chartData.isEmpty) return [];
    int length = chartData.length;

    ChartData first = chartData.first;
    ChartData mid = chartData[length ~/ 2];
    ChartData last = chartData.last;
    return [first, mid, last];
  }

  Widget chartArea(
      List<ChartData> chartData, String amcName, Function(int?)? onToggle) {
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
                child: Text("AUM History", style: AppFonts.f40016),
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
                return Text("${curr.aumMonthStr}");
              }),
            ),
          ),
          SizedBox(height: 16),
          Visibility(
            visible: isVisible, // Replace with your boolean condition
            child: Center(
              child: ToggleSwitch(
                minWidth: 150,
                initialLabelIndex: financialYears.indexOf(selectedFinancialYear),
                onToggle: onToggle,
                labels: financialYears.map((e) {
                  e = e.replaceAll("20", "");
                  return "$e";
                }).toList(),
                activeBgColor: [Config.appTheme.universalTitle],
                inactiveBgColor: Colors.white,
                borderColor: [Colors.grey.shade300],
                borderWidth: 1,
                dividerColor: Colors.grey.shade300,
              ),
            ),
          ),
          // Center(
          //   child: ToggleSwitch(
          //     minWidth: 100,
          //     initialLabelIndex: financialYears.indexOf(selectedFinancialYear),
          //     onToggle: onToggle,
          //     labels: financialYears.map((e) {
          //       e = e.replaceAll("20", "");
          //       return "FY $e";
          //     }).toList(),
          //     activeBgColor: [Colors.black],
          //     inactiveBgColor: Colors.white,
          //     borderColor: [Colors.grey.shade300],
          //     borderWidth: 1,
          //     dividerColor: Colors.grey.shade300,
          //   ),
          // ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget rpChart({required List<ChartData> funChartData}) {
    print("funChartData ${funChartData.length}");
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
        tooltipBehavior: TooltipBehavior(enable: true,tooltipPosition: TooltipPosition.pointer,activationMode: ActivationMode.singleTap),
        series: <CartesianSeries<ChartData, String>>[
          SplineAreaSeries(
            name: "AUM",
            enableTooltip: true,

            xValueMapper: (ChartData sales, _) => sales.aumMonthStr,
            yValueMapper: (ChartData sales, _) => sales.aumAmount,
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
                  BottomSheetTitle(title: "Sort & Filter"),
                  Divider(height: 1),
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
    if (selectedLeft == 'Sort by') return sortView();
    if (selectedLeft == "ARN") return arnView();
    return Text("Invalid Left");
  }

  Widget arnView() {
    List list = bottomSheetFilter['ARN'];

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        String title = list[index];

        return InkWell(
          onTap: () {
            selectedArn = title;
            amcListPojo = [];
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
                    amcListPojo = [];
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
  

  Widget sortView() {
    return ListView.builder(
      itemCount: bottomSheetFilter['Sort by'].length,
      itemBuilder: (context, index) {
        List list = bottomSheetFilter['Sort by'];

        return InkWell(
          onTap: () {
            selectedSort = list[index];
            sortOptions();
            showSortChip = true;
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
                    sortOptions();
                    showSortChip = true;
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

  sortOptions() {
    if (selectedSort == 'Alphabet') {
      amcListPojo.sort((a, b) {
        final amcShortNameA = a.amcShortName ?? '';
        final amcShortNameB = b.amcShortName ?? '';
        return amcShortNameA.compareTo(amcShortNameB);
      });
    }
    if (selectedSort == "AUM") {
      amcListPojo.sort((a, b) => b.aumAmount!.compareTo(a.aumAmount!));
    }
  }
}

class ChartData {
  num? aumAmount;
  String? aumMonthStr;
  ChartData({
    this.aumAmount,
    this.aumMonthStr,
  });

  ChartData.fromJson(Map<String, dynamic> json) {
    aumAmount = json['aum_amount'];
    aumMonthStr = json['aum_month_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aum_amount'] = aumAmount;
    data['aum_month_str'] = aumMonthStr;

    return data;
  }
}

// class AmcController extends GetxController {
//   var chartData = Map<String, dynamic>().obs;
//   var isChartDataLoading = false.obs;
//   var isChartAreaLoading = false.obs;

//   RxString controllerText = ''.obs;

//   String client_name = GetStorage().read("client_name");
//   int mfd_id = GetStorage().read("mfd_id");

//   @override
//   void onInit() {
//     super.onInit();

//     // fetchChartData(loadChartOnly: false, amc: '');
//   }
// }
