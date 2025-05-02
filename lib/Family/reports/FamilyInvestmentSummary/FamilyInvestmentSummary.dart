import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/Investor/reports/InvestorInvestmentSummary.dart';
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

class FamilyInvestmentSummary extends StatefulWidget {
  const FamilyInvestmentSummary({super.key});

  @override
  State<FamilyInvestmentSummary> createState() =>
      _FamilyInvestmentSummaryState();
}

class _FamilyInvestmentSummaryState extends State<FamilyInvestmentSummary> {
  late double devWidth, devHeight;
  int user_id = GetStorage().read('family_id');
  String client_name = GetStorage().read("client_name");
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
      'title': "Redemption",
      'color': Color(0xFFE79C23),
      'key': "total_redemption"
    },
    {
      'initial': "E",
      'title': "Dividend Payout",
      'color': Color(0xFFE79C23),
      'key': "total_dividend_payout"
    },
    {
      'initial': "F",
      'title': "Dividends Reinvest",
      'color': Color(0xFFE79C23),
      'key': "total_dividend_reinvest"
    },
  ];
  String email = "";
  String mobile = "";
  List typeList = ["Members", "Schemes", "AMC", "Asset Class", "Category"];
  String selectedType = "Members";

  DateTime selectedFolioDate = DateTime.now();

  InvestmentSummaryPojo invSummary = InvestmentSummaryPojo();

  Future getUser() async {
    Map data =
        await InvestorApi.getUser(user_id: user_id, client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    Map userData = data['user'];
    email = userData["email"] ?? "";
    mobile = userData["mobile"] ?? "";

    return 0;
  }

  Future getInvestmentSummary() async {
    if (invSummary.msg != null) return 0;
    Map<String, dynamic> data = await ReportApi.getInvestmentSummary(
      user_id: user_id,
      client_name: client_name,
      type: "family",
      folio_type: selectedFolioType,
      selected_date: convertDtToStr(selectedFolioDate),
      summary_type: selectedSummaryType,
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    invSummary = InvestmentSummaryPojo.fromJson(data);
    return 0;
  }

  Future getDatas() async {
    await getInvestmentSummary();
    await getUser();
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;
    print("user_id $user_id");
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
                        child: Text("Family Investment Summary",
                            style: AppFonts.appBarTitle)),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          showCustomizedSummaryBottomSheet();
                        },
                        child: Icon(Icons.filter_alt_outlined)),
                    SizedBox(width: 12),
                    GestureDetector(
                        onTap: () {
                          showReportActionBottomSheet();
                        },
                        child: Icon(Icons.pending_outlined)),
                  ],
                ),
              ),
            ),
            body: SideBar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    topArea(),
                    SizedBox(height: 26),
                    middleArea(),
                    SizedBox(height: 26),
                    countArea(),
                    SizedBox(height: 16),
                    bottomArea(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  bool isExpand = false;

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
                    summaryExpansionTile(context, bottomState),
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
                                  portfolioDateController.collapse();
                                  bottomState(() {});
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      value: true,
                                      groupValue: isToday,
                                      onChanged: (value) {
                                        isToday = true;
                                        portfolioDateController.collapse();
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
              //),
            );
          });
        });
  }

  Map folioMap = {
    "Live Folios": "Live",
    "All Folios": "All",
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

  List summaryTypeList = [
    "All",
    "MF without other ARN",
    "MF bought from others"
  ];
  String selectedSummaryType = "All";
  ExpansionTileController summaryController = ExpansionTileController();

  Widget summaryExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: summaryController,
          title: Text("Summary Type", style: AppFonts.f50014Black),
          tilePadding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedSummaryType,
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
              itemCount: summaryTypeList.length,
              itemBuilder: (context, index) {
                String title = summaryTypeList[index];

                return InkWell(
                  onTap: () {
                    selectedSummaryType = title;
                    summaryController.collapse();
                    bottomState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: title,
                        groupValue: selectedSummaryType,
                        onChanged: (temp) {
                          selectedSummaryType = title;
                          summaryController.collapse();
                          bottomState(() {});
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

  Widget getCancelApplyButton(ButtonType type) {
    if (type == ButtonType.plain)
      return PlainButton(
        color: Config.appTheme.buttonColor,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        text: "CLEAR ALL",
        onPressed: () {},
      );
    else
      return RpFilledButton(
        color: Config.appTheme.buttonColor,
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
    List investorList = invSummary.investorList ?? [];
    if (selectedType == "Members") length = investorList.length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text("$length items"),
          Spacer(),
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
          ),
          SizedBox(width: 16),
          SortButton(
            onTap: () {
              if (xirrType == 'xirr')
                xirrType = 'absolute_return';
              else
                xirrType = 'xirr';
              setState(() {});
            },
            title: xirrMap[xirrType],
            icon: Padding(
              padding: EdgeInsets.only(left: 2),
              child: Image.asset(
                "assets/mobile_sort.png",
                height: 10,
                color: Config.appTheme.themeColor,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 4),
          )
        ],
      ),
    );
  }

  List sortOptions = ["Current Value", "Current Cost", "A to Z", "XIRR"];
  String selectedSort = "Current Value";

  sortBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: cornerBorder),
      builder: (context) {
        return StatefulBuilder(builder: (context, bottomState) {
          return Container(
            height: devHeight * 0.4,
            decoration: BoxDecoration(
              borderRadius: cornerBorder,
              color: Colors.white,
            ),
            child: Column(
              children: [
                BottomSheetTitle(title: "Sort & Filter"),
                Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: sortOptions.length,
                  itemBuilder: (context, index) {
                    String option = sortOptions[index];

                    return InkWell(
                      onTap: () {
                        selectedSort = option;
                        applySort();
                        bottomState(() {});
                      },
                      child: Row(
                        children: [
                          Radio(
                            value: option,
                            groupValue: selectedSort,
                            onChanged: (value) {
                              selectedSort = option;
                              applySort();
                              bottomState(() {});
                            },
                          ),
                          Text(option),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          );
        });
      },
    );
  }

  applySort() {
    if (selectedType == "Members") memberSort();
    if (selectedType == "Schemes") schemeSort();
    if (selectedType == "Asset Class") assetSort();
    if (selectedType == "AMC") amcSort();
    if (selectedType == "Category") categorySort();
    Get.back();
    setState(() {});
  }

  memberSort() {
    if (selectedSort == 'Current Value')
      investorList.sort((a, b) => b.marketValue!.compareTo(a.marketValue!));
    if (selectedSort == 'Current Cost')
      investorList.sort((a, b) => b.purchaseCost!.compareTo(a.purchaseCost!));
    if (selectedSort == 'A to Z')
      investorList.sort((a, b) => a.invName!.compareTo(b.invName!));
    if (selectedSort == "XIRR")
      investorList.sort((a, b) => b.xirr!.compareTo(a.xirr!));
  }

  assetSort() {
    if (selectedSort == 'Current Value')
      broadCategoryList
          .sort((a, b) => b.marketValue!.compareTo(a.marketValue!));
    if (selectedSort == 'Current Cost')
      broadCategoryList
          .sort((a, b) => b.purchaseCost!.compareTo(a.purchaseCost!));
    if (broadCategoryList == 'A to Z')
      schemeList.sort(
          (a, b) => a.schemeAmfiShortName!.compareTo(b.schemeAmfiShortName!));
    if (selectedSort == "XIRR")
      broadCategoryList.sort((a, b) => b.xirr!.compareTo(a.xirr!));
  }

  schemeSort() {
    if (selectedSort == 'Current Value')
      schemeList.sort((a, b) => b.marketValue!.compareTo(a.marketValue!));
    if (selectedSort == 'Current Cost')
      schemeList.sort((a, b) => b.purchaseCost!.compareTo(a.purchaseCost!));
    if (selectedSort == 'A to Z')
      schemeList.sort(
          (a, b) => a.schemeAmfiShortName!.compareTo(b.schemeAmfiShortName!));
    if (selectedSort == "XIRR")
      schemeList.sort((a, b) => b.xirr!.compareTo(a.xirr!));
  }

  amcSort() {
    if (selectedSort == 'Current Value')
      amcList.sort((a, b) => b.marketValue!.compareTo(a.marketValue!));
    if (selectedSort == 'Current Cost')
      amcList.sort((a, b) => b.purchaseCost!.compareTo(a.purchaseCost!));
    if (selectedSort == 'A to Z')
      amcList.sort((a, b) => a.invName!.compareTo(b.invName!));
    if (selectedSort == "XIRR")
      amcList.sort((a, b) => b.xirr!.compareTo(a.xirr!));
  }

  categorySort() {
    if (selectedSort == 'Current Value')
      categoryList.sort((a, b) => b.marketValue!.compareTo(a.marketValue!));
    if (selectedSort == 'Current Cost')
      categoryList.sort((a, b) => b.purchaseCost!.compareTo(a.purchaseCost!));
    if (selectedSort == 'A to Z')
      categoryList.sort((a, b) => a.category!.compareTo(b.category!));
    if (selectedSort == "XIRR")
      categoryList.sort((a, b) => b.xirr!.compareTo(a.xirr!));
  }

  Widget bottomArea() {
    if (selectedType == "Members") return investorArea();
    if (selectedType == "Schemes") return schemeArea();
    if (selectedType == "AMC") return amcArea();
    if (selectedType == "Asset Class") return assetArea();
    if (selectedType == "Category") return categoryArea();
    return Text("Invalid Option");
  }

  List<SchemeList> schemeList = [];

  Widget schemeArea() {
    schemeList = invSummary.schemeList ?? [];
    length = schemeList.length;
    if (schemeList.isNotEmpty && invSummary.msg == null)
      return Utils.shimmerWidget(400);

    return (schemeList.isEmpty)
        ? NoData()
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: schemeList.length,
            itemBuilder: (context, index) {
              SchemeList scheme = schemeList[index];

              return schemeCard(scheme);
            },
          );
  }

  List<InvestorList> investorList = [];

  Widget investorArea() {
    investorList = invSummary.investorList ?? [];
    length = investorList.length;
    if (investorList.isNotEmpty && invSummary.msg == null)
      return Utils.shimmerWidget(400);

    return (investorList.isEmpty)
        ? NoData()
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: investorList.length,
            itemBuilder: (context, index) {
              InvestorList investor = investorList[index];

              return investorCard(investor, index);
            },
          );
  }

  List<AmcList> amcList = [];

  Widget amcArea() {
    amcList = invSummary.amcList ?? [];
    length = amcList.length;
    if (amcList.isNotEmpty && invSummary.msg == null)
      return Utils.shimmerWidget(400);

    return (amcList.isEmpty)
        ? NoData()
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: amcList.length,
            itemBuilder: (context, index) {
              AmcList scheme = amcList[index];

              return amcCard(scheme);
            },
          );
  }

  List<BroadCategoryList> broadCategoryList = [];

  Widget assetArea() {
    broadCategoryList = invSummary.broadCategoryList ?? [];
    length = broadCategoryList.length;
    if (broadCategoryList.isNotEmpty && invSummary.msg == null)
      return Utils.shimmerWidget(400);

    return (broadCategoryList.isEmpty)
        ? NoData()
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: broadCategoryList.length,
            itemBuilder: (context, index) {
              BroadCategoryList scheme = broadCategoryList[index];
              int totalColors = AppColors.colorPalate.length;
              int colorIndex = index;
              if (index > totalColors) colorIndex = index % totalColors;

              return assetCard(scheme, colorIndex);
            },
          );
  }

  List<CategoryList> categoryList = [];

  Widget categoryArea() {
    categoryList = invSummary.categoryList ?? [];
    length = categoryList.length;

    if (categoryList.isNotEmpty && invSummary.msg == null)
      return Utils.shimmerWidget(400);

    return (categoryList.isEmpty)
        ? NoData()
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: categoryList.length,
            itemBuilder: (context, index) {
              CategoryList scheme = categoryList[index];
              int totalColors = AppColors.colorPalate.length;
              int colorIndex = index;
              if (index > totalColors) colorIndex = index % totalColors;

              return categoryCard(scheme, colorIndex);
            },
          );
  }

  Widget middleArea() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: typeList.length,
        itemBuilder: (context, index) {
          String type = typeList[index];

          if (selectedType == type)
            return getButton(text: type, type: ButtonType.filled);
          return getButton(text: type, type: ButtonType.plain);
        },
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(width: 16),
      ),
    );
  }

  Map xirrMap = {'xirr': "XIRR", 'absolute_return': "Abs Return"};
  String xirrType = "xirr";

  Widget schemeCard(SchemeList scheme) {
    num allocation = scheme.allocation ?? 0;
    Map map = scheme.toJson();
    num purchaseCost = scheme.purchaseCost?.round() ?? 0;
    num currentValue = scheme.marketValue?.round() ?? 0;
    return InkWell(
      onTap: () {
        /*Get.to(() => FundDetails(
              schemeName: "${scheme.schemeAmfiShortName}",
              schemeCategory: "${scheme.category}",
              schemeAmfiCode: "${scheme.schemeAmfiCode}",
              currCost: scheme.purchaseCost ?? 0,
              currValue: scheme.marketValue ?? 0,
              xirr: "${scheme.xirr}",
              schemeAmcLogo: "${scheme.amcLogo}",
              folio: "${scheme.folioNo}",
              folioType: selectedFolioType,
            ));*/
        // Get.to(() => FamilyInvestmentSummaryDetails());
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Row(
              children: [
                Image.network("${scheme.amcLogo}", height: 32),
                SizedBox(width: 10),
                Expanded(
                  child: ColumnText(
                    title: "${scheme.schemeAmfiShortName}",
                    value: "Folio : ${scheme.folioNo}",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013,
                  ),
                ),
                /* Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Config.appTheme.placeHolderInputTitleAndArrow,
                )*/
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PercentageBar(allocation.toDouble()),
                ColumnText(
                  title: "Allocation",
                  value: "($allocation%)",
                  valueStyle: AppFonts.f40013.copyWith(
                    fontSize: 12,
                  ),
                  alignment: CrossAxisAlignment.end,
                )
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnText(
                    title: "Current Cost",
                    value: "$rupee ${Utils.formatNumber(purchaseCost)}"),
                ColumnText(
                  title: "Current Value",
                  value: "$rupee ${Utils.formatNumber(currentValue)}",
                  alignment: CrossAxisAlignment.center,
                ),
                ColumnText(
                  title: "${xirrMap[xirrType]}",
                  value: "${map[xirrType]} %",
                  alignment: CrossAxisAlignment.end,
                  valueStyle: AppFonts.f50014Black
                      .copyWith(color: Config.appTheme.defaultProfit),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget investorCard(InvestorList investor, int index) {
    int colorIndex = index;
    if (index >= colorList.length) colorIndex = index % colorIndex;
    String invName = investor.invName.toString();
    num allocation = investor.allocation ?? 0;
    Map map = investor.toJson();
    num purchaseCost = investor.purchaseCost?.round() ?? 0;
    num currentValue = investor.marketValue?.round() ?? 0;
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () {
          print("nameandnum $invName ${investor.userId}");
          Get.to(() => InvestorInvestmentSummary(
              user_id: int.tryParse(investor.userId ?? "0") ?? 0));
          print("nameandnum $invName ${investor.userId}");
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InitialCard(title: invName, bgColor: colorList[colorIndex]),
                SizedBox(width: 8),
                SizedBox(
                    width: devWidth * 0.6,
                    child: Text(invName, style: AppFonts.f50014Black)),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Config.appTheme.placeHolderInputTitleAndArrow,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PercentageBar(allocation.toDouble()),
                ColumnText(
                  title: "Allocation",
                  value: "($allocation%)",
                  valueStyle: AppFonts.f40013.copyWith(
                    fontSize: 12,
                  ),
                  alignment: CrossAxisAlignment.end,
                )
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnText(
                    title: "Current Cost",
                    value: "$rupee ${Utils.formatNumber(purchaseCost)}"),
                ColumnText(
                  title: "Current Value",
                  value: "$rupee ${Utils.formatNumber(currentValue)}",
                  alignment: CrossAxisAlignment.center,
                ),
                ColumnText(
                  title: "${xirrMap[xirrType]}",
                  value: "${map[xirrType]} %",
                  alignment: CrossAxisAlignment.end,
                  valueStyle: AppFonts.f50014Black
                      .copyWith(color: Config.appTheme.defaultProfit),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget amcCard(AmcList scheme) {
    Map map = scheme.toJson();
    num purchaseCost = scheme.purchaseCost?.round() ?? 0;
    num currentValue = scheme.marketValue?.round() ?? 0;
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            children: [
              Image.network("${scheme.amcLogo}", height: 32),
              SizedBox(width: 10),
              Text("${scheme.amc}", style: AppFonts.f50014Black),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PercentageBar(scheme.allocation!.toDouble()),
              ColumnText(
                title: "Allocation",
                value: "(${scheme.allocation} %)",
                valueStyle: AppFonts.f40013.copyWith(
                  fontSize: 12,
                ),
                alignment: CrossAxisAlignment.end,
              )
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Current Cost",
                  value: "$rupee ${Utils.formatNumber(purchaseCost)}"),
              ColumnText(
                title: "Current Value",
                value: "$rupee ${Utils.formatNumber(currentValue)}",
                alignment: CrossAxisAlignment.center,
              ),
              ColumnText(
                title: "${xirrMap[xirrType]}",
                value: "${map[xirrType]} %",
                alignment: CrossAxisAlignment.end,
                valueStyle: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.defaultProfit),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget assetCard(BroadCategoryList scheme, int colorIndex) {
    Color color = AppColors.colorPalate[colorIndex];
    Map map = scheme.toJson();
    num purchaseCost = scheme.purchaseCost?.round() ?? 0;
    num currentValue = scheme.marketValue?.round() ?? 0;
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                    color: color.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Icons.bar_chart_rounded, color: color),
              ),
              SizedBox(width: 10),
              Text("${scheme.category}", style: AppFonts.f50014Black),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PercentageBar(scheme.allocation!.toDouble()),
              ColumnText(
                title: "Allocation",
                value: "(${scheme.allocation} %)",
                valueStyle: AppFonts.f40013.copyWith(
                  fontSize: 12,
                ),
                alignment: CrossAxisAlignment.end,
              )
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Current Cost",
                  value: "$rupee ${Utils.formatNumber(purchaseCost)}"),
              ColumnText(
                title: "Current Value",
                value: "$rupee ${Utils.formatNumber(currentValue)}",
                alignment: CrossAxisAlignment.center,
              ),
              ColumnText(
                title: xirrMap[xirrType],
                value: "${map[xirrType]} %",
                alignment: CrossAxisAlignment.end,
                valueStyle: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.defaultProfit),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget categoryCard(CategoryList scheme, int colorIndex) {
    Color color =
        AppColors.colorPalate[colorIndex % AppColors.colorPalate.length];
    Map map = scheme.toJson();
    num purchaseCost = scheme.purchaseCost?.round() ?? 0;
    num currentValue = scheme.marketValue?.round() ?? 0;
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                    color: color.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Icons.bar_chart_rounded, color: color),
              ),
              SizedBox(width: 10),
              Text("${scheme.category}", style: AppFonts.f50014Black),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PercentageBar(scheme.allocation!.toDouble()),
              ColumnText(
                title: "Allocation",
                value: "(${scheme.allocation} %)",
                valueStyle: AppFonts.f40013.copyWith(
                  fontSize: 12,
                ),
                alignment: CrossAxisAlignment.end,
              )
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Current Cost",
                  value: "$rupee ${Utils.formatNumber(purchaseCost)}"),
              ColumnText(
                title: "Current Value",
                value: "$rupee ${Utils.formatNumber(currentValue)}",
                alignment: CrossAxisAlignment.center,
              ),
              ColumnText(
                title: xirrMap[xirrType],
                value: "${map[xirrType]} %",
                alignment: CrossAxisAlignment.end,
                valueStyle: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.defaultProfit),
              ),
            ],
          )
        ],
      ),
    );
  }

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
    Summary summary = invSummary.summary ?? Summary();
    num? currValue = summary.totalCurrentValue;
    num? netInv = summary.totalNetAmount;
    Map summaryMap = summary.toJson();

    return Container(
      color: Config.appTheme.themeColor,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "As on ${Utils.getFormattedDate(date: selectedFolioDate)}",
            style: AppFonts.f40016.copyWith(color: Colors.white),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              InitialCard(
                bgColor: Color(0xFF4155B9),
                title: "H",
              ),
              SizedBox(width: 10),
              whiteText("Current Value"),
              Spacer(),
              whiteText("$rupee ${Utils.formatNumber(currValue?.round())}")
            ],
          ),

          SizedBox(height: 16),
          // #region initialCard
          Row(
            children: [
              InitialCard(bgColor: Color(0xFF3C9AB6), title: "G"),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  whiteText("Net Investment"),
                  Text(
                    "(G=A+B-C-D-E-F)",
                    style: AppFonts.f40013.copyWith(color: Colors.white),
                  )
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  whiteText("$rupee ${Utils.formatNumber(netInv?.round())}"),
                  GestureDetector(
                    onTap: () {
                      showDetails = !showDetails;
                      setState(() {});
                    },
                    child: Text(
                      "${(showDetails) ? "Hide" : "View"} details",
                      style: AppFonts.f40013.copyWith(
                          color: Colors.yellow,
                          decorationColor: Colors.yellow,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              )
            ],
          ),
          // #endregion,
          SizedBox(height: 16),
          Visibility(
            visible: showDetails,
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: summaryView.length,
              itemBuilder: (context, index) {
                Map data = summaryView[index];

                String initial = data['initial'];
                Color color = data['color'];
                String title = data['title'];
                String key = data['key'];

                return summaryRow(
                    initial: initial,
                    bgColor: color,
                    title: title,
                    value: Utils.formatNumber(summaryMap[key]?.round()));
              },
            ),
          ),
          DottedLine(),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Overall Gain",
                value:
                    "$rupee ${Utils.formatNumber(summary.totalGain?.round())}",
                titleStyle: AppFonts.f40013.copyWith(color: Colors.white),
                valueStyle: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.defaultProfit),
              ),
              ColumnText(
                title: "Absolute Return",
                value: "${summary.absoluteReturn ?? 0} %",
                alignment: CrossAxisAlignment.center,
                titleStyle: AppFonts.f40013.copyWith(color: Colors.white),
                valueStyle: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.defaultProfit),
              ),
              ColumnText(
                title: "XIRR",
                value: "${summary.portfolioReturn ?? 0} %",
                alignment: CrossAxisAlignment.end,
                titleStyle: AppFonts.f40013.copyWith(color: Colors.white),
                valueStyle: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.defaultProfit),
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
  Widget reportActionContainer() {
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
                      "${ApiConfig.apiUrl}/admin/family/downloadFamilyInvestmentSummaryPdf?key=${ApiConfig.apiKey}"
                      "&user_id=$user_id&client_name=$client_name&folio_type=$selectedFolioType&selected_date=${convertDtToStr(selectedFolioDate)}&summary_type=$selectedSummaryType";
                  // "https://api.mymfbox.com/admin/family/downloadFamilyInvestmentSummaryPdf?key=29c5a2ec-3910-4d71-acf7-c6f51e3e9c32&user_id=655178&client_name=eureka&folio_type=Live&selected_date=25-06-2024&summary_type=All";
                  http.Response response = await http.post(Uri.parse(url));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  String resUrl = data['msg'];
                  print("download $url");
                  rpDownloadFile(url: resUrl, context: context, index: index);
                  Get.back();
                } else if (index == 1) {
                  String url =
                      "${ApiConfig.apiUrl}/investor/download/getInvestorSummaryPdf?key=${ApiConfig.apiKey}&investor_details=$investor_details&mobile=$mobile&type=Email&client_name=$client_name";
                  http.Response response = await http.post(Uri.parse(url));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  String resUrl = data['msg'];
                  print("email $url");
                  rpDownloadFile(url: resUrl, context: context, index: index);
                  Get.back();
                } else if (index == 2) {}
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
  }
}
*/
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
                if (type == ReportType.DOWNLOAD) {
                  EasyLoading.show();
                  Map data = await ReportApi.downloadFamilyInvestmentSummaryPdf(
                      user_id: user_id,
                      client_name: client_name,
                      email: email,
                      mobile: mobile,
                      folio_type: selectedFolioType,
                      selected_date: convertDtToStr(selectedFolioDate),
                      summary_type: selectedSummaryType);
                  if (data['status'] != 200) {
                    Utils.showError(context, data['msg']);
                    return;
                  }
                  EasyLoading.dismiss();
                  Get.back();
                  rpDownloadFile(url: data['msg'], index: index);
                } else {
                  EasyLoading.show();
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
                  Get.back();
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
