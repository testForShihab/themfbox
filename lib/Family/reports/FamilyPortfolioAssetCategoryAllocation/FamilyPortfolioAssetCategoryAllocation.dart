import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/FundDetails.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/api/ReportApi.dart';
import 'package:mymfbox2_0/pojo/InvestmentSummaryPojo.dart';
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

import '../../../Investor/AssetCategoryFundDetails.dart';
import '../../../pojo/FamilyPortfolioAssetCategoryAllocationPojo.dart';
import '../../../pojo/FamilyPortfolioAssetCategoryAllocationPojo.dart';
import '../../../pojo/FamilyPortfolioAssetCategoryAllocationPojo.dart';
import '../../../pojo/FamilyPortfolioAssetCategoryAllocationPojo.dart';
import '../../../pojo/FamilyPortfolioAssetCategoryAllocationPojo.dart';
import '../../../rp_widgets/RpButton.dart';
import 'FamilyPortfolioAssetCategoryAllocationDetails.dart';

class FamilyPortfolioAssetCategoryAllocation extends StatefulWidget {
  const FamilyPortfolioAssetCategoryAllocation({super.key, this.user_id = 0});

  final int user_id;

  @override
  State<FamilyPortfolioAssetCategoryAllocation> createState() =>
      _FamilyPortfolioAssetCategoryAllocationState();
}

class _FamilyPortfolioAssetCategoryAllocationState
    extends State<FamilyPortfolioAssetCategoryAllocation> {
  late double devWidth, devHeight;

  int user_id = GetStorage().read("family_id");
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

  String selectedType = "Equity";

  DateTime selectedFolioDate = DateTime.now();

  FamilyPortfolioAssetCategoryAllocationPojo famPortAssetCat =
      FamilyPortfolioAssetCategoryAllocationPojo();

  Map famPortAsset = {};
  List assetCategory = [];
  List categoryList = [];

  Future getFamilyPortfolioAssetCategoryAllocation() async {
    if (famPortAssetCat.msg != null) return 0;
    Map<String, dynamic> data =
        await ReportApi.FamilyPortfolioAssetCategoryAllocation(
      user_id: user_id,
      client_name: client_name,
      folio_type: selectedFolioType,
      selected_date: convertDtToStr(selectedFolioDate),
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    assetCategory = data['list'];
    famPortAsset = data;
    categoryList = assetCategory
        .map((item) => item["category_list"])
        .expand((x) => x)
        .toList();
    return 0;
  }

  Future getDatas() async {
    isLoading = true;
    await getFamilyPortfolioAssetCategoryAllocation();
    isLoading = false;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    if (user_id == 0) user_id = widget.user_id;
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
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
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        "Family Portfolio Asset Cat...",
                        style: AppFonts.appBarTitle,
                        overflow: TextOverflow.ellipsis,
                        // Ensures text does not overflow
                        maxLines: 1,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        showCustomizedSummaryBottomSheet();
                      },
                      child: Icon(Icons.filter_alt_outlined),
                    ),
                    SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        showReportActionBottomSheet();
                      },
                      child: Icon(Icons.pending_outlined),
                    ),
                  ],
                ),
              ),
            ),
            body: SideBar(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Fixed header (mfSummaryCard)
                  topArea(),
                  SizedBox(height: 26),
                  (isLoading)
                      ? Utils.shimmerWidget(devHeight * 0.06,
                          margin: EdgeInsets.fromLTRB(16, 0, 16, 0))
                      : middleArea(),
                  SizedBox(height: 26),
                   Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                bottomArea(),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        });
  }

  getKeyByValue(Map map, String value) {
    return map.keys.firstWhere((element) => map[element] == value);
  }

  ExpansionTileController portfolioDateController = ExpansionTileController();

  showCustomizedSummaryBottomSheet() {
    String tempSelected = convertDtToStr(selectedFolioDate);
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
              height: devHeight * 0.85,
              decoration: BoxDecoration(
                color: Config.appTheme.mainBgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child:  SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: devHeight * 0.85, // Adjust to allow scrolling
                  ),
                  child: Column(
                    children: [
                      BottomSheetTitle(title: "View Customized Summary"),
                      Divider(height: 0),
                      SizedBox(height: 16),
                      folioExpansionTile(context, bottomState),
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
                                          : selectedFolioDate
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
                                      selectedDate: selectedFolioDate,
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
                      Spacer(),
                      Container(
                        height: 75,
                        padding: EdgeInsets.all(16),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: getCancelApplyButton(ButtonType.plain)),
                            SizedBox(width: 16),
                            Expanded(
                                child: getCancelApplyButton(ButtonType.filled)),
                          ],
                        ),
                      ),
                    ],
                  ),
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
    "NRE Folios":"NRE",
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


  Widget getCancelApplyButton(ButtonType type) {
    if (type == ButtonType.plain)
      return PlainButton(
        color: Config.appTheme.buttonColor,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        text: "CLEAR ALL",
        onPressed: () {
          selectedFolioType;
          selectedFolioDate;
          Get.back();
        },
      );
    else
      return RpFilledButton(
        color: Config.appTheme.buttonColor,
        text: "APPLY",
        onPressed: () {
          famPortAssetCat.msg = null;
          Get.back();
          setState(() {});
        },
      );
  }

  int length = 0;

  Widget countArea() {
    if (["Equity", "Debt", "Hybrid", "Solutions", "Others"]
        .contains(selectedType)) {
      categoryList = assetCategory
          .where((item) => item["broad_category"] == selectedType)
          .map((item) => item["category_list"])
          .expand((x) => x)
          .toList();

      length = categoryList.length;
      print("Filtered Category Length: $length");
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("$length items"),
          // Spacer(),
          // SortButton(
          //   onTap: () {
          //     // sortBottomSheet();
          //   },
          //   title: " Sort By",
          //   icon: Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 2),
          //     child: Image.asset(
          //       "assets/mobile_data.png",
          //       height: 14,
          //       color: Config.appTheme.themeColor,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget bottomArea() {
    // Handle all types dynamically
    if (selectedType == "Equity" ||
        selectedType == "Debt" ||
        selectedType == "Hybrid" ||
        selectedType == "Solutions" ||
        selectedType == "Others") {
      return assetCategoryArea(selectedType);
    }
    return Text("Invalid Option");
  }

  Widget assetCategoryArea(String type) {
    if (famPortAsset.isEmpty) return Utils.shimmerWidget(400);

    // Filter the assetCategory based on the selected type
    List filteredAssetCategory = assetCategory
        .where((item) => (item['broad_category'] ?? '') == type)
        .toList();

    return (filteredAssetCategory.isEmpty)
        ? NoData(text: ' No data Available')
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filteredAssetCategory.length,
            itemBuilder: (context, index) {
              return investorCard(filteredAssetCategory[index], index);
            },
          );
  }

  Widget middleArea() {
    List AssetCategoryList = assetCategory;

    return (isLoading)
        ? Utils.shimmerWidget(devHeight,
        margin: EdgeInsets.fromLTRB(16, 0, 16, 0))
        :Container(
      height: 50,
      margin: EdgeInsets.only(left: 16, right: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: AssetCategoryList.length ?? 0,
        // Corrected typo and added null check
        itemBuilder: (context, index) {
          final category = AssetCategoryList[index];
          String broadCategory = category?["broad_category"] ?? '';
          if (selectedType == broadCategory)
            return getButton(text: broadCategory, type: ButtonType.filled);
          return getButton(text: broadCategory, type: ButtonType.plain);
        },
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(width: 16),
      ),
    );
  }

  bool isLoading = true;

  Widget investorCard(Map<String, dynamic> assetcategory, int index) {
    int colorIndex = index % colorList.length; // Fix out-of-range issue

    String invName =
        assetcategory['broad_category'] ?? "Unknown"; // Extract category name
    List categoryList =
        assetcategory['category_list'] ?? []; // Extract category list

    num unrealisedgain = assetcategory['unrealised_gain'] ?? 0;
    num realisedgain = assetcategory['realised_gain'] ?? 0;
    num abs_rtn = assetcategory['abs_rtn'] ?? 0;
    num currentcost = assetcategory['current_cost'] ?? 0;
    num currentvalue = assetcategory['current_value'] ?? 0;
    num portfolioWeight = assetcategory['portfolio_weight'] ?? 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: devWidth,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              // Investor Name & Arrow
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // InitialCard(title: invName, bgColor: colorList[colorIndex]),
                  // SizedBox(width: 8),
                  Expanded(
                    child: Text(invName,
                        style:
                            AppFonts.f50014Black.copyWith(color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // DottedLine(), SizedBox(height: 8),
              // Portfolio details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ColumnText(
                    title: "Current Cost",
                    value: "$rupee ${Utils.formatNumber(currentcost)}",
                    valueStyle: AppFonts.f40013.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  ColumnText(
                    title: "Current Value",
                    value: "$rupee ${Utils.formatNumber(currentvalue)}",
                    alignment: CrossAxisAlignment.center,
                    valueStyle: AppFonts.f40013.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  ColumnText(
                    title: "Unrealised Gain",
                    value: "$rupee ${Utils.formatNumber(unrealisedgain)}",
                    alignment: CrossAxisAlignment.end,
                    valueStyle: AppFonts.f40013.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ColumnText(
                    title: "Realised Gain",
                    value: "$rupee ${Utils.formatNumber(realisedgain)}",
                    valueStyle: AppFonts.f40013.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    alignment: CrossAxisAlignment.start,
                  ),
                  ColumnText(
                    title: "Absolute Return",
                    value: "${abs_rtn.toStringAsFixed(2)} $percentage",
                    valueStyle: AppFonts.f40013.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    alignment: CrossAxisAlignment.center,
                  ),
                  ColumnText(
                    title: "Portfolio Weight",
                    value: "${Utils.formatNumber(portfolioWeight)} $percentage",
                    valueStyle: AppFonts.f40013.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    alignment: CrossAxisAlignment.end,
                    // titleStyle: AppFonts.f40013
                    //     .copyWith(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        SizedBox(height: 16),
        countArea(),
        SizedBox(height: 16),
        (categoryList.isEmpty)
            ? NoData(text: 'No data Available')
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: categoryList.length,
                itemBuilder: (context, catIndex) {
                  Map<String, dynamic> category = categoryList[catIndex];

                  return categoryCard(category, assetcategory);
                },
              ),
      ],
    );
  }

  Widget categoryCard(Map<String, dynamic> category, assetcategory) {
    String categoryName = category['category'] ?? "Unknown";
    num categoryCost = category['current_cost'] ?? 0;
    num categoryValue = category['current_value'] ?? 0;
    num categoryAbsRtn = category['abs_rtn'] ?? 0;
    num unrealisedGain = category['unrealised_gain'] ?? 0;
    num realisedGain = category['realised_gain'] ?? 0;
    num portfolioWeight = category['portfolio_weight'] ?? 0;
    List<Map<String, dynamic>> schemeList =
        List<Map<String, dynamic>>.from(category['scheme_list'] ?? []);
    return InkWell(
      onTap: () {
        Get.to(FamilyPortfolioAssetCategoryAllocationDetails(
            schemeList: schemeList,
            folioType: selectedFolioType,
            categoryName: categoryName));
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                  categoryName,
                  style: AppFonts.f50014Black,
                  maxLines: 2,
                )),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Config.appTheme.placeHolderInputTitleAndArrow,
                )
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnText(
                  title: "Current Cost",
                  value: "$rupee ${Utils.formatNumber(categoryCost)}",
                  alignment: CrossAxisAlignment.start,
                  titleStyle: AppFonts.f40013
                      .copyWith(fontSize: 12, color: Colors.black),
                  valueStyle: AppFonts.f40013.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                ColumnText(
                  title: "Current Value",
                  value: "$rupee ${Utils.formatNumber(categoryValue)}",
                  alignment: CrossAxisAlignment.center,
                  titleStyle: AppFonts.f40013
                      .copyWith(fontSize: 12, color: Colors.black),
                  valueStyle: AppFonts.f40013.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                ColumnText(
                  title: "Abs Rtn",
                  value: "${categoryAbsRtn.toStringAsFixed(2)} %",
                  alignment: CrossAxisAlignment.end,
                  titleStyle: AppFonts.f40013
                      .copyWith(fontSize: 12, color: Colors.black),
                  valueStyle: AppFonts.f40013.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnText(
                  title: "Unrealised Gain",
                  value: "$rupee ${Utils.formatNumber(unrealisedGain)}",
                  alignment: CrossAxisAlignment.start,
                  titleStyle: AppFonts.f40013
                      .copyWith(fontSize: 12, color: Colors.black),
                  valueStyle: AppFonts.f40013.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                ColumnText(
                  title: "Realised Gain",
                  value: "$rupee ${Utils.formatNumber(realisedGain)}",
                  alignment: CrossAxisAlignment.center,
                  titleStyle: AppFonts.f40013
                      .copyWith(fontSize: 12, color: Colors.black),
                  valueStyle: AppFonts.f40013.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                ColumnText(
                  title: "Portfolio Weight",
                  value: "${portfolioWeight.toStringAsFixed(2)} %",
                  alignment: CrossAxisAlignment.end,
                  titleStyle: AppFonts.f40013
                      .copyWith(fontSize: 12, color: Colors.black),
                  valueStyle: AppFonts.f40013.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String selectedSort = "Equity";

  Widget getButton({required String text, required ButtonType type}) {
    EdgeInsets padding = EdgeInsets.symmetric(horizontal: 16);
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
    double currValue = famPortAsset?['current_value'] ?? 0.0;
    num currCost = famPortAsset?['current_cost'] ?? 0;
    num unreaGain = famPortAsset?['unrealised_gain'] ?? 0;
    num xirr = famPortAsset?['xirr'] ?? 0;
    num absolute = famPortAsset?['absolute_return'] ?? 0;

    return Container(
      color: Config.appTheme.themeColor,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  whiteText("Current Cost"),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  whiteText("$rupee ${Utils.formatNumber(currCost)}"),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  whiteText("Current Value"),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  whiteText("$rupee ${Utils.formatNumber(currValue)}"),
                ],
              ),
            ],
          ),
          DottedLine(),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Unrealised Gain",
                value: "$rupee ${Utils.formatNumber(unreaGain)}",
                titleStyle: AppFonts.f40013.copyWith(color: Colors.white),
                valueStyle: AppFonts.f50014Black.copyWith(
                  color: Config.appTheme.defaultProfit,
                ),
              ),
              ColumnText(
                title: "Absolute Return",
                value: "${absolute.toStringAsFixed(2)}$percentage",
                alignment: CrossAxisAlignment.center,
                titleStyle: AppFonts.f40013.copyWith(color: Colors.white),
                valueStyle: AppFonts.f50014Black.copyWith(
                  color: Config.appTheme.defaultProfit,
                ),
              ),
              ColumnText(
                title: "XIRR",
                value: "${Utils.formatNumber(xirr)}$percentage",
                alignment: CrossAxisAlignment.end,
                titleStyle: AppFonts.f40013.copyWith(color: Colors.white),
                valueStyle: AppFonts.f50014Black.copyWith(
                  color: Config.appTheme.defaultProfit,
                ),
              ),
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
    },
    {
      'title': "Excel Report",
      'img': "assets/excel.png",
      'type': ReportType.EXCEL,
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
                Map data = await ReportApi.downloadFamilyPortfolioAssetCategoryAllocation(
                    user_id: user_id,
                    type: type,
                    client_name: client_name,
                    folio_type: selectedFolioType,
                    selected_date: convertDtToStr(selectedFolioDate)
                );
                if (data['status'] != 200) {
                  Utils.showError(context, data['msg']);
                  return;
                }
                EasyLoading.dismiss();
                Get.back();

                if (type == ReportType.DOWNLOAD) {
                  rpDownloadFile(
                      url: data['msg'], context: context, index: index);
                }
                if (type == ReportType.EMAIL) {
                  Fluttertoast.showToast(
                      msg: data['msg'],
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor:
                      Config.appTheme.themeColor,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
                if (type == ReportType.EXCEL) {
                  rpDownloadExcelFile(
                      url: data['msg'], context: context, index: index);
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
