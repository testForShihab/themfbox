import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/advisor/brokerage/AmcWiseBrokerage.dart';
import 'package:mymfbox2_0/advisor/brokerage/BranchRmAssociateBrokerage.dart';
import 'package:mymfbox2_0/advisor/brokerage/InvestorFamilyWiseBrokerge/InvestorFamilyWiseBrokerge.dart';
import 'package:mymfbox2_0/advisor/dashboard/BrokerageCard.dart';
import 'package:mymfbox2_0/api/BrokerageApi.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/AmcChip.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/SelectedAmcChip.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/rp_widgets/ViewAllBtn.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../utils/Utils.dart';

class BrokerageDashboard extends StatefulWidget {
  const BrokerageDashboard(
      {super.key,
      required this.month,
      required this.monthAmount,
      required this.yearAmount});

  final String month;
  final num monthAmount;
  final num yearAmount;

  @override
  State<BrokerageDashboard> createState() => _BrokerageDashboardState();
}

class _BrokerageDashboardState extends State<BrokerageDashboard> {
  int user_id = GetStorage().read("mfd_id");
  String client_name = GetStorage().read("client_name");

  final TextStyle headStyle =
      TextStyle(fontWeight: FontWeight.w700, fontSize: 24);
  final TextStyle subHeadStyle = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF989898));

  List amcList = [], invList = [], famList = [];
  List branchList = [], rmList = [], associateList = [];

  List invBtnList = [
    "Investor",
    "Family",
  ];
  List branchBtnList = [
    /*  "Branch",*/
    "RM",
    "Associate",
  ];
  Map dashboardData = {};

  List<bool> _selections = List.generate(3, (_) => false);
  String selectedAmcMonth = "";
  int type_id = GetStorage().read("type_id") ?? 0;

  bool isLoading = true;
  bool isFirst = true;

  Future getDatas() async {
    if (!isFirst) return 0;
    await getbrokerageFinancialYearList();
    await Future.wait([
      getBrokerageSummaryDetails(),
      getAmcWiseBrokerage(),
      getInvestorWiseBrokerage(),
      getRmWiseBrokerage(),
      getAssociateWiseBrokerage(),
      getBrokerageHistoryDetails(selectedChartMonth),
      getBrokerageMonthList()
    ]);

    isLoading = false;
    isFirst = false;
    return 0;
  }

  RxBool summaryLoading = true.obs;
  RxString summaryError = "".obs;

  Future getBrokerageSummaryDetails() async {
    summaryLoading.value = true;
    try {
      Map data = await BrokerageApi.getBrokerageSummaryDetails(
          user_id: user_id, client_name: client_name);
      if (data['status'] != 200) {
        summaryLoading.value = false;
        summaryError.value = data['msg'];
        return -1;
      }
      dashboardData = data['result'];
    } catch (e) {
      summaryError.value = "Exception Occured";
    }
    summaryLoading.value = false;
    return 0;
  }

  num total_aum = 0;
  RxBool amcLoading = true.obs;
  RxString amcError = "".obs;

  Future getAmcWiseBrokerage() async {
    amcLoading.value = true;
    try {
      Map data = await BrokerageApi.getAmcWiseBrokerage(
        user_id: user_id,
        client_name: client_name,
        month: selectedAmcMonth,
        max_count: "5",
        sort_by: "",
        broker_code: "",
        fin_year: selectedFinancialYear,
      );

      if (data['status'] != 200) {
        amcError.value = data['msg'];
        amcLoading.value = false;
        return -1;
      }
      amcList = data['result'];
      total_aum = data['total_aum'];
    } catch (e) {
      amcError.value = "Exception Occured";
    }
    amcLoading.value = false;
    return 0;
  }

  RxBool chartLoading = true.obs;
  RxString chartError = "".obs;

  Future getBrokerageHistoryDetails(String selectedChartMonth) async {
    chartLoading.value = true;
    try {
      Map data = await BrokerageApi.getBrokerageHistoryDetails(
          user_id: user_id,
          client_name: client_name,
          frequency: "Last $selectedChartMonth",
          amc_name: "");
      if (data['status'] != 200) {
        chartError.value = data['msg'];
        chartLoading.value = false;
        return -1;
      }

      List list = data['result'];
      convertToChartObj(list);
    } catch (e) {
      chartError.value = "Exception Occured";
    }
    chartLoading.value = false;
    return 0;
  }

  convertToChartObj(List list) {
    chartData = [];
    for (var element in list) {
      chartData.add(ChartData.fromJson(element));
    }
  }

  RxBool investorLoading = true.obs;
  RxString investorError = "".obs;

  Future getInvestorWiseBrokerage() async {
    investorLoading.value = true;
    try {
      Map data = await BrokerageApi.getInvestorWiseBrokerage(
          user_id: user_id,
          client_name: client_name,
          month: selectedInvMonth,
          page_id: 1);

      if (data['status'] != 200) {
        investorError.value = data['msg'];
        investorLoading.value = false;
        return -1;
      }
      invList = data['result'];
    } catch (e) {
      investorError.value = "Exception Occured";
    }
    investorLoading.value = false;
    return 0;
  }

  Future getFamilyWiseBrokerage() async {
    investorLoading.value = true;
    try {
      Map data = await BrokerageApi.getFamilyWiseBrokerage(
          user_id: user_id,
          client_name: client_name,
          month: selectedInvMonth,
          page_id: 1);

      if (data['status'] != 200) {
        investorError.value = data['msg'];
        investorLoading.value = false;
        return -1;
      }
      famList = data['result'];
    } catch (e) {
      investorError.value = "Exception Occured";
    }
    investorLoading.value = false;
    return 0;
  }

  RxBool branchLoading = true.obs;
  RxString branchError = "".obs;

  Future getBranchWiseBrokerage() async {
    branchLoading.value = true;
    try {
      Map data = await BrokerageApi.getBranchRmSubBrokerWiseBrokerage(
          user_id: user_id,
          client_name: client_name,
          month: selectedBranchMonth,
          search: "",
          type: "Rm");

      if (data['status'] != 200) {
        branchError.value = data['msg'];
        branchLoading.value = false;
        return -1;
      }
      branchList = data['result'];
    } catch (e) {
      branchError.value = "Exception Occured";
    }
    branchLoading.value = false;
    return 0;
  }

  Future getRmWiseBrokerage() async {
    branchLoading.value = true;
    try {
      Map data = await BrokerageApi.getBranchRmSubBrokerWiseBrokerage(
          user_id: user_id,
          client_name: client_name,
          month: selectedBranchMonth,
          fin_year: selectedFinancialYear,
          search: "",
          type: "Rm");

      if (data['status'] != 200) {
        branchError.value = data['msg'];
        branchLoading.value = false;
        return -1;
      }
      rmList = data['result'];
    } catch (e) {
      branchError.value = "Exception Occured";
    }
    branchLoading.value = false;
    return 0;
  }

  Future getAssociateWiseBrokerage() async {
    branchLoading.value = true;
    try {
      Map data = await BrokerageApi.getBranchRmSubBrokerWiseBrokerage(
          user_id: user_id,
          client_name: client_name,
          month: selectedBranchMonth,
          fin_year: selectedFinancialYear,
          search: "",
          type: "SubBroker");

      if (data['status'] != 200) {
        branchError.value = data['msg'];

        branchLoading.value = false;
        return -1;
      }
      associateList = data['result'];
    } catch (e) {
      branchError.value = "Exception Occured";
    }
    branchLoading.value = false;
    return 0;
  }

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
    selectedInvMonth = brokerageMonthList.first;
    selectedBranchMonth = brokerageMonthList.first;

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

  List<ChartData> chartData = [];

  late double devWidth, devHeight;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
      future: getDatas(),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Config.appTheme.mainBgColor,
          appBar: adminAppBar(title: "Brokerage Dashboard"),
          body: RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: () async {
              Future<void>.delayed(const Duration(seconds: 3));
              isFirst = true;
              setState(() {});
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // summaryCard
                    brokerageSummaryCard(),
                    SizedBox(height: 18),
                    if (type_id == UserType.ADMIN) ...[
                      /*if (chartData.length > 1) ...[
                        chartArea(),
                        SizedBox(height: 20),
                      ],*/
                      amcCard(),
                      SizedBox(height: 20),
                      invFamCard(),
                      SizedBox(height: 20),
                    ],
                    branchRmCard(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget brokerageSummaryCard() {
    return Obx(() {
      if (summaryLoading.isTrue)
        return Utils.shimmerWidget(200, margin: EdgeInsets.zero);
      if (summaryError.isNotEmpty)
        return Utils.showBoxError(height: 200, msg: summaryError.value);
      return BrokerageCard(
        title: "Brokerage",
        lHead:
            "$rupee ${Utils.formatNumber(widget.monthAmount, isShortAmount: true)}",
        lSubHead: "For ${widget.month}",
        rHead:
            "$rupee ${Utils.formatNumber(widget.yearAmount, isShortAmount: true)}",
        rSubHead: "Current FY",
        padding: EdgeInsets.zero,
        hasArrow: false,
      );
    });
  }

  String selectedBranchMonth = "";
  String RmAssTitle = "";

  Widget branchRmCard() {
    if (type_id == UserType.ADMIN) {
      selectedBranchType == "RM";
      RmAssTitle = "RM/Associate Wise Brokerage";
    } else {
      selectedBranchType == "Associate";
      RmAssTitle = "Associate Wise Brokerage";
    }

    return Obx(() {
      if (branchLoading.isTrue)
        return Utils.shimmerWidget(200, margin: EdgeInsets.zero);
      if (branchError.isNotEmpty)
        return Utils.showBoxError(height: 200, msg: branchError.value);
      return Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.fromLTRB(16, 16, 0, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    RmAssTitle,
                    style: AppFonts.f40016,
                  ),
                ),
                SortButton(
                  title: selectedFinancialYear.isNotEmpty
                      ? selectedFinancialYear
                      : selectedAmcMonth.isNotEmpty
                      ? selectedAmcMonth
                      : "Select Period",
                  textStyle: AppFonts.f50012,
                  onTap: () {
                    rmAssociateWiseBottomSheet(
                      selectfinancial: selectedFinancialYear,
                      groupValue: selectedBranchMonth,
                      monthList: brokerageMonthList,
                      financial_branchonChanged: (val) async {
                        selectedBranchMonth = "";
                        selectedFinancialYear = val!;

                        Get.back();
                        branchList = [];
                        setState(() {});
                        if (selectedBranchType == "RM")
                          await getRmWiseBrokerage();
                        if (selectedBranchType == "Associate")
                          await getAssociateWiseBrokerage();
                      },
                      AMC_branchonChanged: (val) async {
                        selectedBranchMonth = val!;
                        selectedFinancialYear = "";

                        Get.back();
                        branchList = [];
                        setState(() {});
                        if (selectedBranchType == "RM")
                          await getRmWiseBrokerage();
                        if (selectedBranchType == "Associate")
                          await getAssociateWiseBrokerage();
                      },
                    );
                  },

                ),
                SizedBox(width: 16),
              ],
            ),
            SizedBox(height: 16),
            branchBtnChipArea(),
            SizedBox(height: 16),
            // if (selectedBranchType == "Branch") branchArea(),
            if (selectedBranchType == "RM") rmArea(),
            if (selectedBranchType == "Associate") associateArea(),
            SizedBox(height: 12),

            if((selectedBranchType == "RM" && rmList.isNotEmpty) || (selectedBranchType == "Associate" && associateList.isNotEmpty))
            ViewAllBtn(
              onTap: () {
                Get.to(BranchRmAssociateBrokerage(
                  selectedBranchType: selectedBranchType,
                  title: RmAssTitle,
                  branchBtnList: branchBtnList,
                ));
              },
            )
          ],
        ),
      );
    });
  }

  Widget branchArea() {
    int length = branchList.length;

    return branchList.isEmpty
        ? noData(selectedBranchType)
        : ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: (length > 5) ? 5 : length,
            itemBuilder: (context, index) {
              Map data = branchList[index];
              return branchRmAssociateTile(data);
            },
            separatorBuilder: (BuildContext context, int index) =>
                DottedLine(verticalPadding: 5),
          );
  }

  Widget rmArea() {
    int length = rmList.length;

    return rmList.isEmpty
        ? NoData(text: "No RM Available",)
        : ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: (length > 5) ? 5 : length,
            itemBuilder: (context, index) {
              Map data = rmList[index];
              return branchRmAssociateTile(data);
            },
            separatorBuilder: (BuildContext context, int index) =>
                DottedLine(verticalPadding: 5),
          );
  }

  Widget associateArea() {
    int length = associateList.length;
    return associateList.isEmpty
        ? NoData(text: "No Associate Available")
        : ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: (length > 5) ? 5 : length,
            itemBuilder: (context, index) {
              Map data = associateList[index];
              return branchRmAssociateTile(data);
            },
            separatorBuilder: (BuildContext context, int index) =>
                DottedLine(verticalPadding: 5),
          );
  }

  Widget noData(String selectedBranchType) {
    return Padding(
      padding: EdgeInsets.only(top: devHeight * 0.02, left: devWidth * 0.20),
      child: Column(
        children: [
          Text("No $selectedBranchType Available"),
          SizedBox(height: devHeight * 0.01),
        ],
      ),
    );
  }

  String selectedInvMonth = "";


  Widget invFamCard() {
    return Obx(() {
      if (investorLoading.isTrue)
        return Utils.shimmerWidget(200, margin: EdgeInsets.zero);
      if (investorError.isNotEmpty)
        return Utils.showBoxError(height: 200, msg: investorError.value);

      return Container(
        padding: EdgeInsets.fromLTRB(16, 16, 0, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Investor/Family Wise Brokerage",
                    style: AppFonts.f40016,
                  ),
                ),
                /*SortButton(
                  onTap: () {
                    showMonthYearBottomSheet(
                      groupValue: selectedInvMonth,
                      monthList: brokerageMonthList,
                      onChanged: (val) async {
                        selectedInvMonth = val ?? "null";
                        Get.back();
                        invList = [];
                        await getInvestorWiseBrokerage();
                      },
                    );
                  },
                  title: " $selectedInvMonth",
                ),*/
                SortButton(
                  onTap: () {
                    investorFamilyWiseBottomSheet(
                      groupValue: selectedInvMonth,
                      monthList: brokerageMonthList,
                      onChanged: (val) async {
                        selectedInvMonth = val ?? "null";
                        Get.back();
                        invList = [];
                        await getInvestorWiseBrokerage();
                      },
                    );
                  },
                  title: " $selectedInvMonth",
                ),
                SizedBox(width: 16),
              ],
            ),
            SizedBox(height: 16),
            invBtnchipArea(),
            SizedBox(height: 16),
            if (selectedInvType == "Investor") invArea(),
            if (selectedInvType == "Family") famArea(),
            SizedBox(height: 12),
            ViewAllBtn(
              onTap: () {
                Get.to(InvestorFamilyWiseBrokerage(
                    selectedMonth: selectedInvMonth,
                    selectedInvType: selectedInvType));
              },
            )
          ],
        ),
      );
    });
  }

  Widget invArea() {
    int length = invList.length;

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: (length > 5) ? 5 : length,
      itemBuilder: (context, index) {
        Map data = invList[index];
        return invFamBrokerageTile(data);
      },
      separatorBuilder: (BuildContext context, int index) =>
          DottedLine(verticalPadding: 5),
    );
  }

  Widget famArea() {
    int length = famList.length;

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: (length > 5) ? 5 : length,
      itemBuilder: (context, index) {
        Map data = famList[index];
        return invFamBrokerageTile(data);
      },
      separatorBuilder: (BuildContext context, int index) =>
          DottedLine(verticalPadding: 5),
    );
  }

  Widget amcCard() {
    return Obx(() {
      if (amcLoading.isTrue)
        return Utils.shimmerWidget(200, margin: EdgeInsets.zero);
      if (amcError.isNotEmpty)
        return Utils.showBoxError(height: 200, msg: amcError.value);
      return Container(
        padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("AMC Wise Brokerage", style: AppFonts.f40016),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  totalAumArea(),
                  SortButton(
                      title: selectedFinancialYear.isNotEmpty
                          ? selectedFinancialYear
                          : selectedAmcMonth.isNotEmpty
                              ? selectedAmcMonth
                              : "Select Period",
                      textStyle: AppFonts.f50012,
                      onTap: () {
                        amcBottomSheet(
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
                  /* SortButton(
                    onTap: () {
                      showMonthBottomSheet(
                        groupValue: selectedAmcMonth,
                        monthList: brokerageMonthList,
                        onChanged: (val) async {
                          selectedAmcMonth = val ?? "null";
                          Get.back();
                          amcList = [];
                          await getAmcWiseBrokerage();
                        },
                      );
                    },
                    title: " $selectedAmcMonth",
                  ),*/
                ],
              ),
            ),
            SizedBox(height: 20),
            amcArea(),
            ViewAllBtn(
              onTap: () {
                Get.to(AmcWiseBrokerage());
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      );
    });
  }

  String selectedFinancialYear = "";
  List financialYearList = [];

  String selectedLeft = "Financial Year";

  void amcBottomSheet({
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
                                    final title = financialYearList[index];
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
                                              financial_onChanged?.call(value);
                                            },
                                          ),
                                          SizedBox(width: 5),
                                          Text(title),
                                        ],
                                      ),
                                    );
                                  })
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: monthList.length,
                                  itemBuilder: (context, index) {
                                    final title = monthList[index];
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
                                              financial_onChanged?.call(value);
                                            },
                                          ),
                                          SizedBox(width: 5),
                                          Text(title),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
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

  rmAssociateWiseBottomSheet({
     String? selectfinancial,
    required String groupValue,
    Function(String?)? onChanged,
    required List monthList,
    Function(String?)? financial_branchonChanged,
    Function(String?)? AMC_branchonChanged,
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
                                "Month Wise",
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
                          child: selectedLeft == "Month Wise"
                              ? ListView.builder(
                                  itemCount: monthList.length,
                                  itemBuilder: (context, index) {
                                    String title = monthList[index];
                                    return InkWell(
                                      onTap: () {
                                        bottomState(() {
                                          selectfinancial = title;
                                        });
                                        financial_branchonChanged?.call(title);
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
                                              financial_branchonChanged?.call(value);
                                            },
                                          ),
                                          SizedBox(width: 5),
                                          Text(title),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : ListView.builder(
                                  itemCount: financialYearList.length,
                                  itemBuilder: (context, index) {
                                    String title = financialYearList[index];
                                    return InkWell(
                                      onTap: () {

                                        bottomState(() {
                                          selectfinancial = title;
                                        });
                                        financial_branchonChanged?.call(title);
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
                                              financial_branchonChanged?.call(value);
                                            },
                                          ),
                                          SizedBox(width: 5),
                                          Text(title),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
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

  Widget totalAumArea() {
    return Text("Total Brokerage $rupee ${Utils.formatNumber(total_aum)}",
        style: AppFonts.f50014Theme.copyWith(fontWeight: FontWeight.w400));
  }

  Widget amcArea() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: amcList.length > 5 ? 5 : amcList.length,
      itemBuilder: (context, index) {
        Map data = amcList[index];
        return amcWiseBrokerageTile(data);
      },
      separatorBuilder: (BuildContext context, int index) =>
          DottedLine(verticalPadding: 5),
    );
  }

  investorFamilyWiseBottomSheet(
      {required String groupValue,
      Function(String?)? onChanged,
      required List monthList}) {
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
                // color: Colors.white,
              ),
              child: Column(
                children: [
                  BottomSheetTitle(title: "Select Month"),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: monthList.length,
                        itemBuilder: (context, index) {
                          String title = monthList[index];
                          return InkWell(
                            onTap: () {
                              onChanged!(title);
                            },
                            child: Row(
                              children: [
                                Radio(
                                    value: title,
                                    groupValue: groupValue,
                                    onChanged: onChanged),
                                SizedBox(width: 5),
                                Text(title),
                              ],
                            ),
                          );
                        },
                      ),
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

  Widget amcWiseBrokerageTile(Map data) {
    String name = data["amc_name"];
    String amount =
        Utils.formatNumber(data["brokerage_amount"], isAmount: true);
    String logo = data['logo'];

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
      child: Row(
        children: [
          // Image at the start
          //Image.network(logo, height: 32),
          Utils.getImage(logo, 32),
          // Text in the middle
          SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: AppFonts.f50014Black,
            ),
          ),
          SizedBox(width: 8),
          Text(
            "$rupee $amount",
            style: AppFonts.f50014Black,
          ),
          SizedBox(width: 8)
        ],
      ),
    );
  }

  Widget invFamBrokerageTile(Map data) {
    String name = data["inv_name"] ?? data["investor_name"];
    num temp = data["brokerage_amount"].round();
    String amount = Utils.formatNumber(temp, isAmount: true);

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
      child: Row(
        children: [
          // Image at the start
          InitialCard(title: name[0]),
          // Text in the middle
          SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: AppFonts.f50014Black,
            ),
          ),
          SizedBox(width: 5),
          Text(
            "$rupee $amount",
            style: AppFonts.f50014Black,
          ),
          // Text at the end with image
        ],
      ),
    );
  }

  String selectedInvType = "Investor";

  Widget invBtnchipArea() {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        itemCount: invBtnList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          String title = invBtnList[index];
          bool isSelectedInv = (selectedInvType == title);

          if (isSelectedInv)
            return SelectedAmcChip(
              title: title,
              value: "",
              hasValue: false,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            );
          else
            return AmcChip(
              title: title,
              value: '',
              hasValue: false,
              onTap: () async {
                selectedInvType = title;
                if (title == "Family") await getFamilyWiseBrokerage();
                setState(() {});
              },
              titleStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            );
        },
      ),
    );
  }

  String selectedBranchType = "RM";

  Widget branchBtnChipArea() {
    /*if(type_id == UserType.ADMIN){
      selectedBranchType = "RM";
      branchBtnList = ["RM", "Associate",];
    }
    else{
      selectedBranchType = "Associate";
      branchBtnList = ["Associate"];
    }*/
    if (type_id != UserType.ADMIN) {
      selectedBranchType = "Associate";
      branchBtnList = ["Associate"];
    }

    return SizedBox(
      height: 36,
      child: ListView.builder(
        itemCount: branchBtnList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          String title = branchBtnList[index];
          print("Building chip with title: $title");
          bool isSelectedBranch = (selectedBranchType == title);

          if (isSelectedBranch)
            return SelectedAmcChip(
              title: title,
              value: "",
              hasValue: false,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            );
          else
            return AmcChip(
              title: title,
              value: '',
              hasValue: false,
              onTap: () async {
                selectedBranchType = title;
                setState(() {});
                //if (title == 'Branch') await getBranchWiseBrokerage();
                print("title-- $title");
                if (title == 'RM') await getRmWiseBrokerage();
                if (title == 'Associate') await getAssociateWiseBrokerage();
              },
              titleStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            );
        },
      ),
    );
  }

  Widget branchRmAssociateTile(Map data) {
    String name = data["user_name"];
    num amount = data["net_after_expense"];
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
      child: Row(
        children: [
          // Text in the middle
          SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: AppFonts.f50014Black,
            ),
          ),
          SizedBox(width: 5),
          Text(
            "$rupee ${Utils.formatNumber(amount, isAmount: true)}",
            style: AppFonts.f50014Black,
          ),
          // Text at the end with image
        ],
      ),
    );
  }

  Widget chartMonths() {
    return Container(
      height: 50,
      alignment: Alignment.center,
      margin: EdgeInsets.all(32),
      color: Colors.white,
      child: ToggleButtons(
        borderColor: Color(0xFFD9DFE7),
        selectedBorderColor: Colors.black,
        selectedColor: Colors.white,
        fillColor: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(3)),
        borderWidth: 1.5,
        isSelected: _selections,
        onPressed: (int index) {
          setState(() {
            print(index);
            //_selections[index] = !_selections[index];
            if (index == 0) {
              _selections = [true, false, false];
              //loadNavMovementGraph(noOfMonths: 60);
            } else if (index == 1) {
              _selections = [false, true, false];
              //loadNavMovementGraph(noOfMonths: 24);
            } else if (index == 2) {
              _selections = [false, false, true];
              //loadNavMovementGraph(noOfMonths: 12);
            } else {}
          });
        },
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              "12 Months",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              "24 Months",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              "36 Months",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String selectedChartMonth = "12 Months";
  List<String> chartMonthList = ["12 Months", "24 Months", "36 Months"];

  Widget chartArea() {
    return Obx(() {
      if (chartLoading.isTrue)
        return Utils.shimmerWidget(200, margin: EdgeInsets.zero);
      if (chartError.isNotEmpty)
        return Utils.showBoxError(height: 200, msg: chartError.value);

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
                  child: Text("Brokerage History", style: AppFonts.f40016),
                ),
                rpChart(funChartData: chartData),
              ],
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(legends.length, (index) {
                  ChartData curr = legends[index];
                  return Text("${curr.month}");
                }),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ToggleSwitch(
                minWidth: 100,
                initialLabelIndex: chartMonthList.indexOf(selectedChartMonth),
                onToggle: (val) async {
                  selectedChartMonth = chartMonthList[val ?? 0];
                  await getBrokerageHistoryDetails(selectedChartMonth);
                },
                labels: chartMonthList,
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

  Widget rpChart({required List<ChartData> funChartData}) {
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
          numberFormat: NumberFormat.decimalPattern(),
          rangePadding: ChartRangePadding.additional,
        ),
        trackballBehavior: trackballBehavior,
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
            name: "Amount",
            borderColor: Config.appTheme.themeColor,
            borderWidth: 2,
            dataSource: funChartData,
            xValueMapper: (ChartData sales, _) => sales.month,
            yValueMapper: (ChartData sales, _) => sales.brokerageAmount,
            dataLabelSettings: DataLabelSettings(isVisible: false),
          ),
        ],
      ),
    );
  }
}

/*class ApiController extends GetxController {
  int user_id = GetStorage().read("mfd_id");
  String client_name = GetStorage().read("client_name");

  RxBool chartLoading = false.obs;
  List<ChartData> chartData = [];

  RxBool amcCardLoading = false.obs;
  RxBool invCardLoading = false.obs;
  RxBool branchCardLoading = false.obs;

  @override
  void onInit() {
    //  implement onInit
    super.onInit();
    getChartData(selectedMonths: "12 Months");
  }

  Future getChartData({required String selectedMonths}) async {
    chartLoading.value = true;
    chartData = [];

    Map data = await BrokerageApi.getBrokerageHistoryDetails(
        user_id: user_id,
        client_name: client_name,
        frequency: "Last $selectedMonths",
        amc_name: "");

    List list = data['result'];
    for (var element in list) {
      chartData.add(ChartData.fromJson(element));
    }

    chartLoading.value = false;
  }
}*/

class ChartData {
  String? month;
  double? brokerageAmount;

  ChartData({required this.month, required this.brokerageAmount});

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
