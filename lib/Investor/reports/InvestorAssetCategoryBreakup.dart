import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/Investor/AssetCategoryFundDetails.dart';
import 'package:mymfbox2_0/Investor/FundDetails.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/ReportApi.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/PercentageBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:http/http.dart' as http;

import '../../pojo/InvestorAssetCategoryPojo.dart';

class InvestorAssetCategoryBreakup extends StatefulWidget {
  const InvestorAssetCategoryBreakup({super.key, this.user_id = 0});

  final int user_id;

  @override
  State<InvestorAssetCategoryBreakup> createState() =>
      _InvestorAssetCategoryBreakupState();
}

class _InvestorAssetCategoryBreakupState
    extends State<InvestorAssetCategoryBreakup> {
  late double devWidth, devHeight;
  int user_id = GetStorage().read('user_id') ?? 0;
  String client_name = GetStorage().read("client_name");
  String mobile = GetStorage().read("user_mobile") ?? "";
  String email = GetStorage().read("user_email") ?? "";
  List<Color> colorList = [
    Colors.purple,
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.red,
  ];
  Map reportActionData = {
    "Download PDF Report ": ["", "", "assets/pdf.png"],
    /*"Download Excel Report": ["", "", "assets/excel.png"],*/
    "Email Report": ["", null, "assets/email.png"],
  };
  List summaryView = [
    {
      'initial': "A",
      'title': "Purchase",
      'color': Color(0xFF5DB25D),
      'key': "total_purchase"
    },
    {
      'initial': "B",
      'title': "Switch In",
      'color': Color(0xFF5DB25D),
      'key': "total_switch_in"
    },
    {
      'initial': "C",
      'title': "Switch Out",
      'color': Color(0xFFE79C23),
      'key': "total_switch_out"
    },
    {
      'initial': "D",
      'title': "Redemption / SWP",
      'color': Color(0xFFE79C23),
      'key': "total_redemption"
    },
    {
      'initial': "E",
      'title': "Dividends",
      'color': Color(0xFFE79C23),
      'key': "total_dividend_payout"
    },
  ];

  List typeList = [];
  String selectedType = "";

  DateTime? selectedFolioDate;
  InvestorAssetCategoryPojo invSummary = InvestorAssetCategoryPojo();
  BroadCategoryList broadCategoryList = BroadCategoryList();

  Future getPortfolioAssetCategoryAllocation() async {
    if (invSummary.msg != null) return 0;

    String selectedFinancialYear = DateFormat("dd-MM-yyyy").format(
        (selectedFinancialyearDate ?? selectedFolioDate)?? DateTime.now());


    Map<String, dynamic> data =
        await ReportApi.getPortfolioAssetCategoryAllocation(
      user_id: user_id,
      client_name: client_name,
      folio_type: selectedFolioType,
      selected_date: selectedFinancialYear.isNotEmpty
          ? selectedFinancialYear
          : convertDtToStr(selectedFolioDate ?? DateTime.now()),
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    invSummary = InvestorAssetCategoryPojo.fromJson(data);
    broadCategoryList = invSummary.broadCategoryList![0];
    return 0;
  }

  Future getDatas() async {
    await getPortfolioAssetCategoryAllocation();
    return 0;
  }

  @override
  void initState() {
    super.initState();
    if (user_id == 0) user_id = widget.user_id;

    getPortfolioAssetCategoryAllocation().then((_) {
      if (invSummary.broadCategoryList != null &&
          invSummary.broadCategoryList!.isNotEmpty) {
        String? firstCategory = invSummary.broadCategoryList!
            .firstWhere((category) =>
                category.broadCategory != null &&
                category.broadCategory!.isNotEmpty)
            .broadCategory;

        if (firstCategory != null) {
          setState(() {
            selectedType = firstCategory;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: AppBar(
        leading: SizedBox(),
        leadingWidth: 0,
        backgroundColor: Config.appTheme.themeColor,
        foregroundColor: Colors.white,
        title: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Row(
            children: [
              Icon(Icons.arrow_back),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Text("Current Portfolio Asset Category Breakup",
                        style: AppFonts.appBarTitle)),
              ),
              GestureDetector(
                  onTap: () {
                    showCustomizedSummaryBottomSheet();
                  },
                  child: Icon(Icons.filter_alt_outlined)),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
          future: getPortfolioAssetCategoryAllocation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Utils.shimmerWidget(devHeight - 100));
            }

            if (snapshot.data == -1) {
              return Center(child: Text('Failed to load data'));
            }

            return SideBar(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    topArea(),
                    SizedBox(height: 26),
                    middleArea(),
                    //SizedBox(height: 26),
                    //countArea(),
                    SizedBox(height: 16),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          bottomArea(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  getKeyByValue(Map map, String value) {
    return map.keys.firstWhere((element) => map[element] == value);
  }

  ExpansionTileController portfolioDateController = ExpansionTileController();

  showCustomizedSummaryBottomSheet() {
    String tempSelected = convertDtToStr(selectedFolioDate ?? DateTime.now());
    String tempNow = convertDtToStr(DateTime.now());

    bool isToday = tempSelected == tempNow;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (context, bottomState) {
            return Container(
              height: devHeight * 0.60,
              decoration: BoxDecoration(
                color: Config.appTheme.mainBgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BottomSheetTitle(title: "View Customized Summary"),
                    Divider(height: 0),
                    SizedBox(height: 16),
                    folioExpansionTile(context, bottomState),
                    financialExpansionTile(context, bottomState),
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            controller: portfolioDateController,
                            title: Text("Portfolio Date",
                                style: AppFonts.f50014Black),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    (isToday)
                                        ? "Today"
                                        : (selectedFolioDate ?? '')
                                            .toString()
                                            .split(" ")[0],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Config.appTheme.themeColor)),
                                DottedLine(),
                              ],
                            ),
                            children: [
                              InkWell(
                                onTap: () {
                                  isToday = true;
                                  bottomState(() {});
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      value: true,
                                      groupValue: isToday,
                                      onChanged: (value) {
                                        isToday = true;
                                        bottomState(() {});
                                      },
                                    ),
                                    Text("Today"),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  isToday = false;
                                  bottomState(() {});
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      value: false,
                                      groupValue: isToday,
                                      onChanged: (value) {
                                        isToday = false;
                                        bottomState(() {});
                                      },
                                    ),
                                    Text("Select Specific Date"),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: !isToday,
                                child: SizedBox(
                                  height: 200,
                                  child: ScrollDatePicker(
                                    selectedDate: selectedFolioDate ?? DateTime.now(),
                                    onDateTimeChanged: (value) {
                                      selectedFolioDate = value;
                                      bottomState(() {});
                                    },
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                    Container(
                      height: 75,
                      padding: EdgeInsets.all(16),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: getCancelApplyButton(ButtonType.plain , bottomState)),
                          SizedBox(width: 16),
                          Expanded(
                              child: getCancelApplyButton(ButtonType.filled, bottomState)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //),
            );
          });
        });
  }

  Map folioMap = {
    "Live Folios": "Live",
    "Non segregated Folios": "NonSegregated",
  };
  String selectedFolioType = "Live";
  ExpansionTileController folioController = ExpansionTileController();

  Widget folioExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: folioController,
          title: Text("Folio Type", style: AppFonts.f50014Black),
          tilePadding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${getKeyByValue(folioMap, selectedFolioType)}",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Config.appTheme.themeColor)),
              DottedLine(),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: folioMap.length,
              itemBuilder: (context, index) {
                String key = folioMap.keys.elementAt(index);
                String value = folioMap.values.elementAt(index);

                return InkWell(
                  onTap: () {
                    selectedFolioType = value;
                    folioController.collapse();
                    bottomState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: value,
                        groupValue: selectedFolioType,
                        onChanged: (temp) {
                          selectedFolioType = value;
                          folioController.collapse();
                          bottomState(() {});
                        },
                      ),
                      Text(key),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<String> financialYearList = [
    "Last 1 Year",
    "Last 2 Year",
    "Last 3 Year",
    "Last 4 Year",
    "Last 5 Year",
  ];

  String selectedFinancialType = "";
  DateTime? selectedFinancialyearDate;

  ExpansionTileController financialController = ExpansionTileController();

  Widget financialExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: financialController,
          title: Text("Selected Financial Type", style: AppFonts.f50014Black),
          tilePadding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedFinancialType.isEmpty
                    ? "Select Financial Year"
                    : "$selectedFinancialType (${selectedFinancialyearDate != null ? selectedFinancialyearDate.toString().split(" ")[0] : ''})",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Config.appTheme.themeColor,
                ),
              ),
              DottedLine(),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: financialYearList.length,
              itemBuilder: (context, index) {
                String title = financialYearList[index];

                return InkWell(
                  onTap: () {
                    updateSelectedFinancialYear(title, bottomState);
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: title,
                        groupValue: selectedFinancialType,
                        onChanged: (value) {
                          updateSelectedFinancialYear(title, bottomState);
                        },
                      ),
                      Text(title),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Function to update the selected financial year and calculate the past date
  void updateSelectedFinancialYear(String title, StateSetter bottomState) {
    int years = int.parse(title.split(" ")[1]);
    // Extract number of years
    selectedFinancialyearDate = DateTime.now()
        .subtract(Duration(days: 365 * years)); // Get exact past date

    selectedFinancialType = title;
    financialController.collapse();
    bottomState(() {});
  }

  Widget getCancelApplyButton(ButtonType type ,StateSetter bottomState) {
    if (type == ButtonType.plain)
      return PlainButton(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        text: "CLEAR ALL",
        onPressed: () {
          selectedFinancialType = '';
          selectedFinancialyearDate = null;
          selectedFolioDate = null;
          financialController.collapse();
          portfolioDateController.collapse();
          bottomState(() {});
        },
      );
    else
      return RpFilledButton(
        text: "APPLY",
        onPressed: () {
          invSummary.msg = null;
          Get.back();
          setState(() {});
        },
      );
  }

  int length = 0;

  Widget countArea() {
    List schemeList = broadCategoryList.categoryList ?? [];

    // if (selectedType == "AMC") length = amcList.length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text("${schemeList.length} items"),
          /*Spacer(),
          SortButton(
            onTap: () {
              sortBottomSheet();
            },
            title: " Sort By",
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Image.asset(
                "assets/mobile_data.png",
                height: 14,
                color: Config.appTheme.themeColor,
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  List sortOptions = ["Current Value", "Current Cost"];
  String selectedSort = "Current Value";

  sortBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, bottomState) {
          return Column(
            children: [
              BottomSheetTitle(title: "Sort & Filter"),
              ListView.builder(
                shrinkWrap: true,
                itemCount: sortOptions.length,
                itemBuilder: (context, index) {
                  String option = sortOptions[index];

                  return InkWell(
                    onTap: () {
                      selectedSort = option;
                      bottomState(() {});
                      applySort();
                    },
                    child: Row(
                      children: [
                        Radio(
                          value: option,
                          groupValue: selectedSort,
                          onChanged: (value) {
                            selectedSort = option;
                            bottomState(() {});
                            applySort();
                          },
                        ),
                        Text(option),
                      ],
                    ),
                  );
                },
              )
            ],
          );
        });
      },
    );
  }

  Widget rpRow({
    required String lhead,
    required String lSubHead,
    required String rhead,
    required String rSubHead,
    final TextStyle? valueStyle,
    final TextStyle? titleStyle,
  }) {
    return Row(
      children: [
        Expanded(
            child: ColumnText(
          title: lhead,
          value: lSubHead,
          alignment: CrossAxisAlignment.start,
          valueStyle: valueStyle,
          titleStyle: titleStyle,
        )),
        Expanded(
            child: ColumnText(
          title: rhead,
          value: rSubHead,
          alignment: CrossAxisAlignment.end,
          valueStyle: valueStyle,
          titleStyle: titleStyle,
        )),
      ],
    );
  }

  Widget rpRow1({
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
          alignment: CrossAxisAlignment.start,
          valueStyle: valueStyle,
          titleStyle: titleStyle,
        )),
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
          alignment: CrossAxisAlignment.end,
          valueStyle: valueStyle,
          titleStyle: titleStyle,
        )),
      ],
    );
  }

  String categoryLength = "0";

  Widget bottomArea() {
    if (invSummary.msg == null) return Utils.shimmerWidget(400);

    List<BroadCategoryList> broadCategories =
        invSummary.broadCategoryList ?? [];

    // Filter categories based on selected type
    if (selectedType.isNotEmpty) {
      broadCategories = broadCategories
          .where((category) => category.broadCategory == selectedType)
          .toList();
    }

    length = broadCategories.length;

    if (broadCategories.isEmpty) {
      return NoData();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: broadCategories.length,
      itemBuilder: (context, index) {
        BroadCategoryList broadCategory = broadCategories[index];
        int totalColors = AppColors.colorPalate.length;
        int colorIndex = index % totalColors;
        categoryLength = broadCategory.categoryList?.length.toString() ?? "0";

        return Column(
          children: [
            // Broad Category Card
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  /*Row(
                    children: [
                      Text(broadCategory.broadCategory ?? '',
                        style: AppFonts.f50014Black.copyWith(color: Colors.white,fontSize: 18)
                      ),
                    ],
                  ),*/
                  rpRow(
                    lhead: "Current Cost",
                    lSubHead:
                        "$rupee ${Utils.formatNumber(broadCategory.currentCost?.round() ?? 0)}",
                    valueStyle:
                        AppFonts.f50014Black.copyWith(color: Colors.white),
                    rhead: "Current Value",
                    rSubHead:
                        "$rupee ${Utils.formatNumber(broadCategory.currentValue?.round() ?? 0)}",
                  ),
                  SizedBox(height: 13),
                  rpRow(
                    lhead: "Unrealised Gain",
                    lSubHead: Utils.formatNumber(
                        broadCategory.unrealisedGain?.round() ?? 0),
                    valueStyle:
                        AppFonts.f50014Black.copyWith(color: Colors.white),
                    rhead: "Realised Gain",
                    rSubHead: Utils.formatNumber(
                        broadCategory.realisedGain?.round() ?? 0),
                  ),
                  SizedBox(height: 13),
                  rpRow(
                    valueStyle:
                        AppFonts.f50014Black.copyWith(color: Colors.white),
                    lhead: "Portfolio weight",
                    lSubHead:
                        "${broadCategory.portfolioWeight?.toStringAsFixed(2)} %",
                    rhead: "Abs Return",
                    rSubHead: "${broadCategory.absRtn} %",
                  )
                ],
              ),
            ),

            // Category List Details
            if (broadCategory.categoryList != null)
              ...broadCategory.categoryList!
                  .map((category) => Container(
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: InkWell(
                          onTap: () {
                            Get.to(AssetCategoryFundDetails(
                                category: category,
                                folioType: selectedFolioType));
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(category.category ?? '',
                                        style: AppFonts.f50014Black),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                    color: Config
                                        .appTheme.placeHolderInputTitleAndArrow,
                                  )
                                ],
                              ),
                              SizedBox(height: 16),
                              rpRow1(
                                lhead: "Current Cost",
                                lSubHead:
                                    "$rupee ${Utils.formatNumber(category.currentCost?.round() ?? 0)}",
                                valueStyle: AppFonts.f50014Black
                                    .copyWith(color: Colors.black),
                                rhead: "Current Value",
                                rSubHead:
                                    "$rupee ${Utils.formatNumber(category.currentValue?.round() ?? 0)}",
                                chead: "Abs Rtn",
                                cSubHead: "${category.absRtn ?? 0} %",
                              ),
                              SizedBox(height: 16),
                              rpRow1(
                                lhead: "Unrealised Gain",
                                lSubHead: Utils.formatNumber(
                                    category.unrealisedGain?.round() ?? 0),
                                valueStyle: AppFonts.f50014Black
                                    .copyWith(color: Colors.black),
                                rhead: "Realised Gain",
                                rSubHead: Utils.formatNumber(
                                    category.realisedGain?.round() ?? 0),
                                chead: "Portfolio weight",
                                cSubHead:
                                    "${category.portfolioWeight?.toStringAsFixed(2) ?? 0} %",
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            SizedBox(
              height: 16,
            )
          ],
        );
      },
    );
  }

  applySort() {
    print("apply sort");
    EasyLoading.show();
    schemeSort();

    setState(() {});
    EasyLoading.dismiss();
    Get.back();
  }

  schemeSort() {
    if (selectedSort == 'Current Value')
      broadCategoryList.categoryList!
          .sort((a, b) => (a.currentValue ?? 0).compareTo(b.currentValue ?? 0));
    if (selectedSort == 'Current Cost')
      broadCategoryList.categoryList!
          .sort((a, b) => (a.currentCost ?? 0).compareTo(b.currentCost ?? 0));
  }

  Widget middleArea() {
    if (invSummary.msg == null || invSummary.broadCategoryList == null) {
      return Utils.shimmerWidget(50);
    }

    List<String> categories = invSummary.broadCategoryList!
        .map((category) => category.broadCategory ?? '')
        .where((category) => category.isNotEmpty)
        .toList();

    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 16, right: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          String category = categories[index];
          if (selectedType == category) {
            return getButton(text: category, type: ButtonType.filled);
          }
          return getButton(text: category, type: ButtonType.plain);
        },
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(width: 16),
      ),
    );
  }

  Widget getButton({required String text, required ButtonType type}) {
    EdgeInsets padding = EdgeInsets.symmetric(horizontal: 36);
    if (type == ButtonType.plain) {
      return PlainButton(
        text: text,
        padding: padding,
        onPressed: () {
          selectedType = text;
          selectedSort = "";
          setState(() {});
        },
      );
    } else {
      return RpFilledButton(text: text, padding: padding);
    }
  }

  bool showDetails = false;

  Widget topArea() {
    num? currValue = invSummary.currentValue ?? 0;
    num? netInv = invSummary.currentCost ?? 0;
    num? totalGain = invSummary.unrealisedGain ?? 0;

    return Container(
      color: Config.appTheme.themeColor,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Row(
            children: [
              //SizedBox(width: 10),
              whiteText("Current Cost"),
              Spacer(),
              whiteText("$rupee ${Utils.formatNumber(netInv.round())}")
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              // SizedBox(width: 10),
              whiteText("Current Value"),
              Spacer(),
              whiteText("$rupee ${Utils.formatNumber(currValue.round())}")
            ],
          ),
          SizedBox(height: 16),
          DottedLine(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Unrealised Gain",
                value: Utils.formatNumber(totalGain.round()),
                titleStyle: AppFonts.f40013.copyWith(color: Colors.white),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              /*ColumnText(title: "Realised Gain", value: Utils.formatNumber(invSummary.realisedGain ?? 0), alignment: CrossAxisAlignment.center,
                titleStyle: AppFonts.f40013.copyWith(color: Colors.white),
                valueStyle: AppFonts.f50014Black
                    .copyWith(color: Colors.white)),*/
              ColumnText(
                title: "Abs Rtn",
                value: "${invSummary.absoluteReturn ?? 0} %",
                alignment: CrossAxisAlignment.center,
                titleStyle: AppFonts.f40013.copyWith(color: Colors.white),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                  title: "XIRR",
                  value: "${invSummary.xirr ?? 0} %",
                  alignment: CrossAxisAlignment.end,
                  titleStyle: AppFonts.f40013.copyWith(color: Colors.white),
                  valueStyle:
                      AppFonts.f50014Black.copyWith(color: Colors.white)),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget summaryRow({
    required String initial,
    required Color bgColor,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          InitialCard(title: initial, bgColor: bgColor),
          SizedBox(width: 10),
          whiteText(title),
          Spacer(),
          whiteText("$rupee $value")
        ],
      ),
    );
  }

  Widget whiteText(String text) {
    return Text(
      text,
      style: AppFonts.f50014Black.copyWith(color: Colors.white),
    );
  }

  showReportActionBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Config.appTheme.mainBgColor,
      context: context,
      // isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  BottomSheetTitle(title: "Report Actions"),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: reportActionContainer(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

/*
  Widget reportActionContainers() {
    InvestorDetails investorDetails =
        InvestorDetails(userId: user_id, email: email);
    List<InvestorDetails> investorDetailsList = [];
    investorDetailsList.add(investorDetails);

    String investor_details = jsonEncode(investorDetailsList);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: reportActionData.length,
        separatorBuilder: (context, index) {
          return DottedLine(verticalPadding: 4);
        },
        itemBuilder: (context, index) {
          String title = reportActionData.keys.elementAt(index);
          List stitle = reportActionData.values.elementAt(index);
          String imagePath = stitle[2];
          String msgUrl = "";
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () async {
                EasyLoading.show();
                if (index == 0) {
                  String url =
                      "${ApiConfig.apiUrl}/investor/download/downloadInvestmentSummary?key=${ApiConfig.apiKey}&type=download"
                      "&user_id=$user_id&client_name=$client_name&folio_type=$selectedFolioType&selected_date=${convertDtToStr(selectedFolioDate)}&summary_type=$selectedSummaryType";

                  http.Response response = await http.post(Uri.parse(url));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  String resUrl = data['msg'];
                  print("download $url");
                  rpDownloadFile(url: resUrl, context: context, index: index);
                  Get.back();
                } /*else if (index == 1) {
                  String url =
                      "${ApiConfig.apiUrl}/investor/download/getInvestorSummaryPdf?key=${ApiConfig.apiKey}"
                      "&investor_details=$investor_details&mobile=$mobile&type=excel&client_name=$client_name";
                  http.Response response = await http.post(Uri.parse(url));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  String resUrl = data['msg'];
                  print("resUrl $resUrl");
                  print("excel $url");
                  rpDownloadFile(url: resUrl, context: context, index: index);
                  Get.back();
                }*/
                else if (index == 1) {
                  String url =
                      "${ApiConfig.apiUrl}/investor/download/getInvestorSummaryPdf?key=${ApiConfig.apiKey}&type=email&investor_details=$investor_details&mobile=$mobile&type=download&client_name=$client_name";
                  http.Response response = await http.post(Uri.parse(url));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  String resUrl = data['msg'];
                  print("email $url");
                  rpDownloadFile(url: resUrl, context: context, index: index);
                  Get.back();
                }
                EasyLoading.dismiss();
              },
              child: RpListTile(
                title: SizedBox(
                  width: 220,
                  child: Text(
                    title,
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor),
                  ),
                ),
                subTitle: Visibility(
                  visible: stitle[0].isNotEmpty,
                  child: Text(stitle[0], style: AppFonts.f40013),
                ),
                leading: Image.asset(
                  imagePath,
                  color: Config.appTheme.themeColor,
                  width: 32,
                  height: 32,
                ),
                showArrow: false,
              ),
            ),
          );
        },
      ),
    );
  } */

  List reportActions = [
    {
      'title': "Download PDF Report",
      'img': "assets/pdf.png",
      'type': ReportType.DOWNLOAD,
    },
    {
      'title': "Email Report",
      'img': "assets/email.png",
      'type': ReportType.EMAIL,
    }
  ];

  Widget reportActionContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: reportActions.length,
        separatorBuilder: (context, index) {
          return DottedLine(verticalPadding: 4);
        },
        itemBuilder: (context, index) {
          Map data = reportActions[index];

          String title = data['title'];
          String img = data['img'];
          String type = data['type'];

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () async {
                EasyLoading.show();
                Map data = await ReportApi.downloadInvestmentSummary(
                    email: email,
                    user_id: user_id,
                    user_mobile: mobile,
                    type: type,
                    client_name: client_name,
                    folio: selectedFolioType,
                    selected_date: convertDtToStr(selectedFolioDate ?? DateTime.now()),
                    selectedSummaryType: '');
                if (data['status'] != 200) {
                  Utils.showError(context, data['msg']);
                  return;
                }
                EasyLoading.dismiss();
                Get.back();

                if (type == ReportType.DOWNLOAD) {
                  rpDownloadFile(
                      url: data['msg'], context: context, index: index);
                } else {
                  Map data = await ReportApi.getInvestorSummaryPdf(
                      email: email,
                      user_id: user_id,
                      user_mobile: mobile,
                      type: type,
                      client_name: client_name,
                      report_type: '');
                  if (data['status'] != 200) {
                    Utils.showError(context, data['msg']);
                    return;
                  }
                  EasyLoading.dismiss();
                  EasyLoading.showToast("${data['msg']}");
                }
              },
              child: RpListTile(
                title: SizedBox(
                  width: 220,
                  child: Text(
                    title,
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor),
                  ),
                ),
                subTitle: SizedBox(),
                leading: Image.asset(
                  img,
                  color: Config.appTheme.themeColor,
                  width: 32,
                  height: 32,
                ),
                showArrow: false,
              ),
            ),
          );
        },
      ),
    );
  }

  void showError() {
    Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Config.appTheme.themeColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

class InvestorDetails {
  String? email;
  int? userId;

  InvestorDetails({this.email, this.userId});

  InvestorDetails.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['user_id'] = this.userId;
    return data;
  }
}
