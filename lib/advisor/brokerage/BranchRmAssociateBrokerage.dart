import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/BrokerageApi.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/AmcChip.dart';
import 'package:mymfbox2_0/rp_widgets/RpChip.dart';
import 'package:mymfbox2_0/rp_widgets/SearchField.dart';
import 'package:mymfbox2_0/rp_widgets/SelectedAmcChip.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class BranchRmAssociateBrokerage extends StatefulWidget {
  const BranchRmAssociateBrokerage(
      {super.key,
      required this.selectedBranchType,
      required this.title,
      required this.branchBtnList});

  final String selectedBranchType;
  final String title;
  final List branchBtnList;

  @override
  State<BranchRmAssociateBrokerage> createState() =>
      _BranchRmAssociateBrokerageState();
}

class _BranchRmAssociateBrokerageState
    extends State<BranchRmAssociateBrokerage> {
  late double devWidth, devHeight;

  int user_id = GetStorage().read("mfd_id");
  String client_name = GetStorage().read("client_name");

  List branchBtnList = [];

  List branchList = [], selectAmcMonth = [], associateList = [], rmList = [];
  String title = "";
  String serarchKey = "";

  @override
  void initState() {
    //  implement initState
    super.initState();
    selectedBranchType.value = widget.selectedBranchType;
    title = widget.title;
    branchBtnList = widget.branchBtnList;
  }

  String selectedFinancialYear = "";
  List financialYearList = [];

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

  RxBool isLoading = true.obs;

  Future getDatas() async {
    await getbrokerageFinancialYearList();
    await getBrokerageMonthList();
    //if (selectedBranchType.value == "Branch") await getBranchWiseBrokerage();
    if (selectedBranchType.value == "RM") await getRmWiseBrokerage();
    if (selectedBranchType.value == "Associate")
      await getAssociateWiseBrokerage();
    isLoading.value = false;
  }

  Future getBranchWiseBrokerage() async {
    // if (branchList.isNotEmpty) return 0;

    Map data = await BrokerageApi.getBranchRmSubBrokerWiseBrokerage(
        user_id: user_id,
        client_name: client_name,
        month: selectedMonth,
        search: serarchKey,
        type: "Branch",
        fin_year: selectedFinancialYear);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    branchList = data['result'];

    return 0;
  }

  Future getRmWiseBrokerage() async {
    // if (rmList.isNotEmpty) return 0;

    Map data = await BrokerageApi.getBranchRmSubBrokerWiseBrokerage(
        user_id: user_id,
        client_name: client_name,
        month: selectedMonth,
        search: serarchKey,
        type: "Rm",
        fin_year: selectedFinancialYear);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    rmList = data['result'];

    return 0;
  }

  Future getAssociateWiseBrokerage() async {
    // if (associateList.isNotEmpty) return 0;

    Map data = await BrokerageApi.getBranchRmSubBrokerWiseBrokerage(
        user_id: user_id,
        client_name: client_name,
        month: selectedMonth,
        search: serarchKey,
        type: "SubBroker",
        fin_year: selectedFinancialYear);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    associateList = data['result'];

    return 0;
  }

  RxString selectedBranchType = "RM".obs;
  int totalCount = 0;

  String selectedMonth = "";
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

  Future reloadPage() async {
    branchList = [];
    rmList = [];
    associateList = [];

    //if (selectedBranchType.value == "Branch") await getBranchWiseBrokerage();
    if (selectedBranchType.value == "RM") await getRmWiseBrokerage();
    if (selectedBranchType.value == "Associate")
      await getAssociateWiseBrokerage();
  }

  Timer? searchOnStop;

  searchHandler(String val) {
    serarchKey = val;
    print("serarchKey--$serarchKey");
    const duration = Duration(milliseconds: 1000);
    if (searchOnStop != null) {
      searchOnStop!.cancel();
    }

    searchOnStop = Timer(duration, () async {
      EasyLoading.show(status: "Searching for `$val`");
      if (selectedBranchType.value == "RM") await getRmWiseBrokerage();
      if (selectedBranchType.value == "Associate")
        await getAssociateWiseBrokerage();
      EasyLoading.dismiss();
      setState(() {});
    });
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
              title: "$title", hasAction: false, bgColor: Colors.white),
          resizeToAvoidBottomInset: true,
          body: Obx(() {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  chipArea(),
                  SizedBox(height: 20),
                  SearchField(
                    hintText: "Search $selectedBranchType",
                    onChange: searchHandler,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(" $totalCount Items", style: AppFonts.f40013),
                      SortButton(
                          title: selectedFinancialYear.isNotEmpty
                              ? selectedFinancialYear
                              : selectedMonth.isNotEmpty
                                  ? selectedMonth
                                  : "Select Period",
                          onTap: () {
                            showMonthYearBottomSheet(
                              selectfinancial: selectedFinancialYear,
                              selectMonth: selectedMonth,
                              monthList: brokerageMonthList,
                              financial_onChanged: (val) async {
                                selectedMonth = "";
                                selectedFinancialYear = val!;

                                Get.back();
                                branchList = [];
                                setState(() {});
                                await reloadPage();
                              },
                              AMC_onChanged: (val) async {
                                selectedMonth = val!;
                                selectedFinancialYear = "";
                                Get.back();
                                branchList = [];
                                setState(() {});
                                await reloadPage();
                              },
                            );
                          }),
                    ],
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (selectedBranchType.value == "RM") rmArea(),
                          if (selectedBranchType.value == "Associate")
                            associateArea(),
                        ],
                      ),
                    ),
                  ),
                  //if (selectedBranchType.value == "Branch") branchArea(),
                  // if (selectedBranchType.value == "RM") rmArea(),
                  // if (selectedBranchType.value == "Associate") associateArea(),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  String selectedLeft = "Financial Year";

  void showMonthYearBottomSheet({
    required String selectfinancial,
    required String selectMonth,
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
                                    })
                                : Expanded(
                                    child: ListView.builder(
                                        itemCount: monthList.length,
                                        itemBuilder: (context, index) {
                                          String title = monthList[index];
                                          return InkWell(
                                            onTap: () {
                                              bottomState(() {
                                                selectMonth = title;
                                              });
                                              AMC_onChanged?.call(title);
                                            },
                                            child: Row(
                                              children: [
                                                Radio<String>(
                                                  value: title,
                                                  groupValue: selectMonth,
                                                  onChanged: (value) {
                                                    bottomState(() {
                                                      selectMonth = value!;
                                                    });
                                                    AMC_onChanged?.call(value);
                                                  },
                                                ),
                                                SizedBox(width: 5),
                                                Text(title),
                                              ],
                                            ),
                                          );
                                        }))),
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

  Widget branchArea() {
    if (isLoading.value)
      return Utils.shimmerWidget(200, margin: EdgeInsets.zero);
    if (branchList.isEmpty)
      return NoData(
        text: "No Branch Available",
      );
    return SizedBox(
      height: devHeight - 267,
      child: SingleChildScrollView(
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: branchList.length,
          itemBuilder: (context, index) {
            Map data = branchList[index];
            return branchRmAssociateTile(data);
          },
          separatorBuilder: (BuildContext context, int index) =>
              DottedLine(verticalPadding: 12),
        ),
      ),
    );
  }

  Widget rmArea() {
    if (isLoading.value)
      return Utils.shimmerWidget(200, margin: EdgeInsets.zero);
    if (rmList.isEmpty)
      return NoData(
        text: "No RM Available",
      );
    return SizedBox(
      height: devHeight - 267,
      child: SingleChildScrollView(
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: rmList.length,
          itemBuilder: (context, index) {
            Map data = rmList[index];
            return branchRmAssociateTile(data);
          },
          separatorBuilder: (BuildContext context, int index) =>
              DottedLine(verticalPadding: 12),
        ),
      ),
    );
  }

  Widget associateArea() {
    if (isLoading.value)
      return Utils.shimmerWidget(200, margin: EdgeInsets.zero);
    if (associateList.isEmpty)
      return NoData(
        text: "No Associate Available ",
      );
    return SizedBox(
      height: devHeight - 267,
      child: SingleChildScrollView(
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: associateList.length,
          itemBuilder: (context, index) {
            Map data = associateList[index];
            return branchRmAssociateTile(data);
          },
          separatorBuilder: (BuildContext context, int index) =>
              DottedLine(verticalPadding: 12),
        ),
      ),
    );
  }

  Widget chipArea() {
    if (selectedBranchType.value == 'Branch') totalCount = branchList.length;
    if (selectedBranchType.value == 'RM') totalCount = rmList.length;
    if (selectedBranchType.value == "Associate")
      totalCount = associateList.length;

    return SizedBox(
      height: 36,
      child: ListView.builder(
        itemCount: branchBtnList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          String title = branchBtnList[index];
          bool isSelectedBranch = (selectedBranchType.value == title);

          if (isSelectedBranch)
            return SelectedAmcChip(
              title: title,
              value: "",
              hasValue: false,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            );
          else
            return AmcChip(
              title: title,
              value: '',
              hasValue: false,
              onTap: () async {
                selectedBranchType.value = title;
                isLoading.value = true;
                if (title == 'Branch') await getBranchWiseBrokerage();
                if (title == 'RM') await getRmWiseBrokerage();
                if (title == 'Associate') await getAssociateWiseBrokerage();
                isLoading.value = false;
              },
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              titleStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            );
        },
      ),
    );
  }

  Widget branchRmAssociateTile(Map data) {
    String name = data["user_name"];
    num amount = data["net_after_expense"];
    List<dynamic>? list = data["list"];
    return GestureDetector(
      onTap: (list == null)
          ? () async {
              showBrokerageBottomSheet(data);
            }
          : null,
      child: Row(
        children: [
          Image.asset('assets/map.png', height: 30),
          SizedBox(
            width: 10,
          ),
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
          SizedBox(width: 5),
          if (list == null)
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0XFFB4B4B4),
            ),
        ],
      ),
    );
  }

  showBrokerageBottomSheet(Map data) {
    String userName = data["user_name"];

    List list = [
      {
        "title": "Gross Brokerage",
        "value": data["gross_brokerage"],
      },
      {
        "title": "ST/GST",
        "value": data["gst"],
      },
      {
        "title": "Net Brokerage",
        "value": data["net_brokerage"],
      },
      {
        "title": "Expenses",
        "value": data["expense"],
      },
    ];

    String netAfterExpense = Utils.formatNumber(data['net_after_expense']);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        builder: (context) {
          return StatefulBuilder(builder: (_, bottomSheet) {
            return Container(
              height: devHeight * 0.4,
              width: devWidth,
              decoration: BoxDecoration(
                borderRadius: cornerBorder,
                color: Colors.white,
              ),
              padding: EdgeInsets.only(left: 24, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      Expanded(
                        flex: 2,
                        child: Text(
                          userName,
                          style: AppFonts.f50014Black,
                        ),
                      ),
                      RpChip(label: selectedMonth)
                    ],
                  ),
                  SizedBox(height: 24),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      Map map = list[index];
                      String title = map['title'];
                      num value = map['value'];

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
                              "$rupee ${Utils.formatNumber(value)}",
                              style: AppFonts.f50014Black,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  DottedLine(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Net After Expense",
                          style: AppFonts.f50014Black,
                        ),
                        Text(
                          "$rupee $netAfterExpense",
                          style: AppFonts.f50014Black,
                        ),
                      ]),
                  SizedBox(height: 24),
                ],
              ),
            );
          });
        });
  }
}
