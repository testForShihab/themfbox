import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/api/ResearchApi.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class ExploreFundsAmcWise extends StatefulWidget {
  const ExploreFundsAmcWise({
    Key? key,
    required this.amc_name,
    required this.amc_logo,
  }) : super(key: key);

  final String amc_name;
  final String amc_logo;

  @override
  State<ExploreFundsAmcWise> createState() => _ExploreFundsAmcWiseState();
}

class _ExploreFundsAmcWiseState extends State<ExploreFundsAmcWise> {
  late double devWidth, devHeight;
  int user_id = GetStorage().read("mfd_id") ?? GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  List categoryList = [];
  String selectedCategory = "All Categories";
  String catName = "All";
  String selectedAmcName = "";
  String selectedAmcCode = "";
  Map periodMap = {0: "1W", 1: "1M", 2: "3M", 3: "6M", 4: "YTD", 5: "1Y"};
  String period = "1W";
  String amcName = "";
  String selectedAmcLogo = "";
  String selectedSort = "Returns";
  String selectedSortFinal = "Returns";
  bool isLoading = true;
  List amcList = [];
  String categoryName = "";
  double categoryPercentage = 0.0;
  Color schemeColor = Colors.blue;
  Color bgSchemeColor = Colors.red;
  String amcSearch = "";
  List sortList = ["Returns", "A to Z", "AUM", "Ter"];
  num sumSchemeAssets = 0;
  bool isFirst = true;

  List amcWiseExploreList = [];

  Future getData() async {
    isLoading = true;
    await getBroadCategoryList();
    await getCategoryReturns();
    await getAllAmc();
    await getAmcWiseExplore();
    isLoading = false;

    return 0;
  }

  TextStyle underlineText = TextStyle(
      color: Config.appTheme.defaultProfit,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w500,
      fontSize: 13,
      decorationColor: Config.appTheme.defaultProfit);

  /*Future getAllAmc() async {
    if (amcList.isNotEmpty) return 0;

    Map data = await TransactionApi.getSipAmc(
      client_name: client_name,
      bse_nse_mfu_flag: "nse",
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      print("Error if");
      return -1;
    }
    amcList = data['list'];
    // amcList.insert(0, {
    //   "amc_name": "Select AMC Name",
    //   "amc_code": "Zero",
    //   "amc_logo": "",
    // });
    // selectedAmcName = amcList[0]['amc_name'];
    // selectedAmcCode = amcList[0]['amc_code'];

    return 0;
  }*/

  Future getAllAmc() async {
    if (amcList.isNotEmpty) return 0;
    try {
      isLoading = true;
      Map data = await ResearchApi.getAllAmc(client_name: client_name);
      if (data['status'] != 200) {
        Utils.showError(context, data['msg']);
        return 0;
      }
      amcList = data['list'];
      if (widget.amc_name.isEmpty) {
        selectedAmcName = amcList[0]['amc_name'] ?? "";
        selectedAmcLogo = amcList[0]['amc_logo'] ?? "";
      }
    } catch (e) {
      print("getTopAmc exception = $e");
    }
    isLoading = false;
    return 0;
  }

  Future getBroadCategoryList() async {
    if (categoryList.isNotEmpty) return 0;
    Map<String, dynamic> data =
        await Api.getBroadCategoryList(client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return;
    }
    List<dynamic> categories = data['list'];
    categoryList.add("All Categories");
    categoryList.addAll(categories.map((category) => category['name']));

    return;
  }

  String searchKey = "";
  Timer? searchOnStop;
  void searchHandler(String search) async {
    searchKey = search;
    print("searchKey $searchKey");
    if (searchKey.isEmpty) {
      categoryReturns = [];
      await getCategoryReturns();
    } else {
      categoryReturns = categoryReturns.where((item) {
        return item['category']
            .toString()
            .toLowerCase()
            .contains(searchKey.toLowerCase());
      }).toList();
    }
    //setState(() {});
  }

  List<dynamic> categoryReturns = [];
  Future getCategoryReturns() async {
    if (categoryReturns.isNotEmpty) return 0;
    if (selectedCategory == "All Categories") {
      catName = "All";
    }
    Map data = await ResearchApi.getCategoryReturns(
        Category: catName,
        period: period,
        user_id: user_id,
        client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    categoryReturns = data['list'];
    return 0;
  }

  Future getAmcWiseExplore() async {
    if (amcWiseExploreList.isNotEmpty) return 0;

    if (selectedCategory == "All Categories") {
      selectedCategory = "All";
    }
    if (selectedAmcName.isEmpty) {
      selectedAmcName = widget.amc_name;
    }

    if (selectedSort == "Returns") {
      selectedSortFinal = "returns";
    } else if (selectedSort == "AUM") {
      selectedSortFinal = "aum";
    } else if (selectedSort == "A to Z") {
      selectedSortFinal = "alphabet";
    } else if (selectedSort == "Ter") {
      selectedSortFinal = "ter";
    }

    Map data = await ResearchApi.getAmcWiseExplore(
      client_name: client_name,
      amc: selectedAmcName,
      broad_category: selectedCategory,
      sort_by: selectedSortFinal,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    amcWiseExploreList = data['performances'] ?? [];
    sumSchemeAssets = 0;
    if (amcWiseExploreList.isNotEmpty) {
      print("sumSchemeAssets if");
      for (var performance in amcWiseExploreList) {
        sumSchemeAssets += performance['scheme_assets'];
      }
    }
    return 0;
  }

  @override
  void initState() {
    //  implement initState
    super.initState();
    selectedAmcName = widget.amc_name;
    selectedAmcLogo = widget.amc_logo;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Color(0XFFECF0F0),
          // appBar: adminAppBar(
          //   title: "AMC Wise Explorer",
          //   bgColor: Config.appTheme.themeColor,
          //   fgColor: Colors.white,
          //   arrowColor: Colors.white,
          //   hasAction: false,
          //   suffix: MfAboutIcon(context: context),
          // ),
          appBar: AppBar(
            backgroundColor: Config.appTheme.themeColor,
            leadingWidth: 0,
            toolbarHeight: 200,
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
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        "AMC Wise Explore",
                        style: AppFonts.f40016.copyWith(fontSize: 18),
                      ),
                    ),
                    //Spacer(),
                    //MfAboutIcon(context: context),
                  ],
                ),
                SizedBox(height: 20),
                // AppBarColumn(title: "title", value: "value", onTap: () {showCustomizedSummaryBottomSheet()}),
                // Row(
                //   children: [
                //     Expanded(
                //         child: AppBarColumn(
                //             title: "title", value: "value", onTap: () { print("tapped");
                //         categoryList = [];
                //          getBroadCategoryList();
                //         showCategoryBottomSheet();})),
                //     SizedBox(width: 16),
                //     Expanded(
                //         child: AppBarColumn(
                //             title: "title", value: "value", onTap: () {showSortFilter();})),
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        showCustomizedSummaryBottomSheet();
                      },
                      child: appBarNewColumn(
                          "AMC",
                          getFirst30(selectedAmcName),
                          Icon(Icons.keyboard_arrow_down,
                              color: Config.appTheme.themeColor)),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        showCategoryBottomSheet();
                      },
                      child: appBarColumn(
                          "Broad Category",
                          getFirst15(selectedCategory),
                          Icon(Icons.keyboard_arrow_down,
                              color: Config.appTheme.themeColor)),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        showSortFilter();
                      },
                      child: appBarColumn(
                          "Sort By",
                          getFirst13(selectedSort),
                          Image.asset(
                            'assets/mobile_data.png',
                            color: Config.appTheme.themeColor,
                            height: 18,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: displayPage(),
        );
      },
    );
  }

  Widget displayPage() {
    return isLoading
        ? Center(
            child: Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Utils.shimmerWidget(devHeight),
            ),
          )
        : Padding(
            padding: EdgeInsets.only(top: 16.0, left: 16, right: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${amcWiseExploreList.length} Funds",
                    style: AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                  ),
                  SizedBox(height: 16),
                  (amcWiseExploreList.isEmpty) ? NoData() : bottomArea(),
                  SizedBox(height: 15)
                ],
              ),
            ),
          );
  }

  Widget bottomArea() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          blackCard(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: amcWiseExploreList.length,
            itemBuilder: (context, index) {
              if (index < amcWiseExploreList.length &&
                  amcWiseExploreList[index] != null) {
                Map data = amcWiseExploreList[index];
                return amcCard(data);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget blackCard() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(
                selectedAmcLogo,
                height: 30,
              ),
              SizedBox(width: 10),
              Text(
                selectedAmcName,
                style: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              /*Spacer(),
              GestureDetector(
                onTap: () {
                  amcWiseBottomSheet();
                },
                child: Text(
                  "View Details",
                  style: underlineText,
                ),
              ),*/
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Active Schemes",
                value: "${amcWiseExploreList.length}",
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle:
                    AppFonts.f50012.copyWith(color: Colors.white, fontSize: 16),
              ),
              ColumnText(
                title: " AUM",
                value:
                    "$rupee ${Utils.formatNumber(sumSchemeAssets.round(), isAmount: true)}",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle:
                    AppFonts.f50012.copyWith(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  amcWiseBottomSheet() {
    showModalBottomSheet(
        backgroundColor: Config.appTheme.mainBgColor,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, bottomState) {
              return SizedBox(
                height: devHeight * 0.54,
                child: Column(
                  children: [
                    BottomSheetTitle(title: "AMC Details"),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.network(selectedAmcLogo,
                                      height: setImageSize(30)),
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      selectedAmcName,
                                      style: AppFonts.f50014Black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 180,
                                    child: ColumnText(
                                      title: "AUM",
                                      value: "₹15,000 Cr",
                                      alignment: CrossAxisAlignment.start,
                                    ),
                                  ),
                                  ColumnText(
                                    title: "AUM Share",
                                    value: "5.91%",
                                    alignment: CrossAxisAlignment.start,
                                  ),
                                ],
                              ),
                              DottedLine(verticalPadding: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 180,
                                    child: ColumnText(
                                      title: "Active Schemes",
                                      value: "100",
                                      alignment: CrossAxisAlignment.start,
                                    ),
                                  ),
                                  ColumnText(
                                    title: "Start Date",
                                    value: "01-10-2017",
                                    alignment: CrossAxisAlignment.start,
                                  ),
                                ],
                              ),
                              DottedLine(verticalPadding: 4),
                              ColumnText(
                                title: "Address",
                                value:
                                    "UTI Tower, ‘GN’ Block, Bandra-Kurla Complex, Bandra(East), Mumbai",
                              ),
                              DottedLine(verticalPadding: 4),
                              ColumnText(
                                title: "Phone Number",
                                value: "022-66786666 / 66786354 / 1800-22-1230",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  Widget amcCard(Map data) {
    String logo = data['logo'] ?? "";
    String shortName = data['scheme_amfi_short_name'] ?? "";
    String schemeRating = data['scheme_rating'] ?? "";
    num schemeAssets = data['scheme_assets'] ?? 0;
    String doubleIn = data['double_in'] ?? "";
    num returnsAbs = data['returns_abs'] ?? 0;
    num ter = data['ter'] ?? 0;
    num returnsAbsRank = data['returns_abs_rank'] ?? 0;

    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Column(
          children: [
            //1st row
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(logo, height: 30),
                  SizedBox(width: 5),
                  SizedBox(
                      width: 210,
                      child: Text(shortName,
                          style: AppFonts.f50014Black
                              .copyWith(color: Config.appTheme.themeColor))),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Color(0xffEDFFFF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        )),
                    child: Row(children: [
                      Text(schemeRating,
                          style: TextStyle(color: Config.appTheme.themeColor)),
                      Icon(Icons.star, color: Config.appTheme.themeColor)
                    ]),
                  )
                ],
              ),
            ),
            //2nd row
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ColumnText(
                        title: "AUM",
                        value:
                            "$rupee ${Utils.formatNumber(schemeAssets.round(), isAmount: true)}",
                      ),
                      ColumnText(
                          title: "Doubled In",
                          value: doubleIn,
                          alignment: CrossAxisAlignment.center),
                      ColumnText(
                          title: "Returns",
                          value: "$returnsAbs%",
                          valueStyle: AppFonts.f50014Black.copyWith(
                              color: (returnsAbs > 0)
                                  ? Config.appTheme.defaultProfit
                                  : Config.appTheme.defaultLoss),
                          alignment: CrossAxisAlignment.end),
                    ],
                  ),
                ],
              ),
            ),
            DottedLine(),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ColumnText(
                        title: "TER",
                        value: "$ter%",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fundCard(Color color, Map data) {
    double average_returns = data['average_rolling_returns'];
    num max_returns = data['max_rolling_returns'];
    num min_returns = data['min_rolling_returns'];
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(Icons.bar_chart, color: color),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "${data['category']}",
                  style: AppFonts.f50014Black,
                ),
              ),
              SizedBox(width: 5),
              Text(
                "$average_returns %",
                style: AppFonts.f50014Black.copyWith(
                  color: (average_returns.isNegative)
                      ? Config.appTheme.defaultLoss
                      : Config.appTheme.defaultProfit,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: Config.appTheme.placeHolderInputTitleAndArrow,
              ),
            ],
          ), // Add some space between rows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Min",
                value: "$min_returns",
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "",
                    style: AppFonts.f40013,
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2, // Thickness of the track
                      thumbShape: CustomThumbShape(),
                      trackShape: CustomTrackShape(),
                    ),
                    child: Slider(
                      value: average_returns.abs(),
                      min: 0,
                      max: 100,
                      activeColor: Colors.transparent,
                      inactiveColor: Colors.transparent,
                      onChanged: (double value) {
                        setState(() {
                          average_returns = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              ColumnText(
                  title: "Max",
                  value: "$max_returns",
                  alignment: CrossAxisAlignment.end),
            ],
          ),
        ],
      ),
    );
  }

  String getFirst13(String text) {
    String s = text.split(":").first;
    if (s.length > 13) s = s.substring(0, 13);
    return s;
  }

  String getFirst30(String text) {
    String s = text.split(":").first;
    if (s.length > 30) s = s.substring(0, 30);
    return s;
  }

  String getFirst15(String text) {
    String s = text.split(":").first;
    if (s.length > 15) s = '${s.substring(0, 15)}..';
    return s;
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

  showSortFilter() {
    showModalBottomSheet(
        backgroundColor: Config.appTheme.mainBgColor,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (context) {
          return StatefulBuilder(builder: (context, bottomState) {
            return Container(
              color: Colors.white,
              height: devHeight * 0.42,
              child: Column(
                children: [
                  BottomSheetTitle(title: "Sort By"),
                  Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListView.builder(
                          itemCount: sortList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                selectedSort = sortList[index];
                                print("selectedSort $selectedSort");
                                amcWiseExploreList = [];
                                await getAmcWiseExplore();
                                setState(() {});
                                bottomState(() {});
                                Get.back();
                              },
                              child: Row(
                                children: [
                                  Radio(
                                      value: sortList[index],
                                      groupValue: selectedSort,
                                      activeColor: Config.appTheme.themeColor,
                                      onChanged: (val) async {
                                        selectedSort = sortList[index];
                                        print("selectedSort $selectedSort");
                                        amcWiseExploreList = [];
                                        await getAmcWiseExplore();
                                        setState(() {});
                                        bottomState(() {});
                                        Get.back();
                                      }),
                                  Text(sortList[index])
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  showCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      builder: (context) {
        return StatefulBuilder(builder: (_, bottomState) {
          return Container(
            height: devHeight * 0.7,
            color: Colors.white,
            padding: EdgeInsets.all(7),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("  Select Category",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.close))
                  ],
                ),
                Divider(),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: categoryList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      String temp = categoryList[index];
                      return InkWell(
                        onTap: () async {
                          selectedCategory = categoryList[index];
                          EasyLoading.show();
                          amcWiseExploreList = [];
                          await getAmcWiseExplore();
                          setState(() {
                            print("selectedSubCategory = $selectedCategory");
                          });
                          EasyLoading.dismiss();
                          bottomState(() {});
                          Get.back();
                        },
                        child: Row(
                          children: [
                            Radio(
                                value: categoryList[index],
                                groupValue: selectedCategory,
                                activeColor: Config.appTheme.themeColor,
                                onChanged: (val) async {
                                  selectedCategory = categoryList[index];
                                  EasyLoading.show();
                                  amcWiseExploreList = [];
                                  await getAmcWiseExplore();
                                  setState(() {
                                    print(
                                        "selectedSubCategory = $selectedCategory");
                                  });
                                  EasyLoading.dismiss();
                                  bottomState(() {});
                                  Get.back();
                                }),
                            Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Color(0xffF8DFD5),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Icon(Icons.bar_chart,
                                    color: Colors.red, size: 20)),
                            Expanded(child: Text(" $temp")),
                          ],
                        ),
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

  /*showCategoryReturnsBottomSheet() {
    showModalBottomSheet(
        backgroundColor: Config.appTheme.mainBgColor,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (context) {
          return StatefulBuilder(builder: (context, bottomState) {
            return SizedBox(
              height: devHeight * 0.54,
              child: Column(
                children: [
                  BottomSheetTitle(title: "Select Category"),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: ListView.builder(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              itemCount: categoryList.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    selectedCategory = categoryList[index];
                                    catName = categoryList[index];
                                    print("selectedCategory $selectedCategory");

                                    setState(() {
                                      selectedCategory = categoryList[index];
                                      catName = categoryList[index];
                                      print(
                                          "SelectedCategory $selectedCategory");
                                      print(
                                          "category monitor length ${categoryReturns.length}");
                                    });
                                    amcWiseExploreList = [];
                                    await getAmcWiseExplore();
                                    bottomState(() {});
                                    Get.back();
                                  },
                                  child: Row(
                                    children: [
                                      Radio(
                                        activeColor: Config.appTheme.themeColor,
                                        groupValue: selectedCategory,
                                        value: categoryList[index],
                                        onChanged: (val) async {
                                          setState(() {
                                            selectedCategory =
                                                categoryList[index];
                                            catName = categoryList[index];
                                            print(
                                                "SelectedCategory $selectedCategory");
                                            print(
                                                "category Returns length ${categoryReturns.length}");
                                          });
                                          categoryReturns = [];
                                          amcWiseExploreList = [];
                                          await getAmcWiseExplore();
                                          bottomState(() {});
                                          Get.back();
                                        },
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(categoryList[index]),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }*/

  showCustomizedSummaryBottomSheet() {
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
            color: Colors.white,
            padding: EdgeInsets.all(7),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select AMC",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                Divider(),
                Expanded(
                  flex: 9,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: amcList.length,
                    itemBuilder: (context, index) {
                      Map data = amcList[index];
                      String name = data['amc_name'];
                      String img = data['amc_logo'];

                      return Visibility(
                        visible: searchVisibility(name, amcSearch),
                        child: InkWell(
                          onTap: () async {
                            bottomState(() {
                              selectedAmcName = name;
                              selectedAmcLogo = img;
                            });
                            print("selectedAmcName $selectedAmcName");
                            amcWiseExploreList = [];
                            await getAmcWiseExplore();
                            Get.back();
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: name,
                                groupValue: selectedAmcName,
                                activeColor: Config.appTheme.themeColor,
                                onChanged: (val) async {
                                  selectedAmcName = name;
                                  selectedAmcLogo = img;

                                  bottomState(() {});
                                  amcWiseExploreList = [];
                                  await getAmcWiseExplore();
                                  setState(() {});
                                  print("selectedAmcName $selectedAmcName");
                                  Get.back();
                                },
                              ),
                              index == 0
                                  ? Container(height: 32)
                                  : /*Image.network(img, height: 32),*/ Utils
                                      .getImage(img, 32),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  name,
                                  style: AppFonts.f50014Grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  searchVisibility(String title, String searchKey) {
    title = title.toLowerCase();
    searchKey = searchKey.toLowerCase();

    if (searchKey.isEmpty)
      return true;
    else {
      return title.contains(searchKey);
    }
  }

  ExpansionTileController amcController = ExpansionTileController();
  Widget amcExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: amcController,
          onExpansionChanged: (val) {},
          title: Text("AMC", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedAmcName,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Config.appTheme.themeColor)),
            ],
          ),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12, 4, 12, 10),
              child: SizedBox(
                height: 40,
                child: TextFormField(
                  initialValue: amcSearch,
                  onChanged: (val) {
                    setState(() {
                      amcSearch = val;
                    });
                    bottomState(() {});
                  },
                  decoration: InputDecoration(
                      // suffixIcon: Icon(Icons.close,
                      //     color: Config.appTheme.themeColor),
                      contentPadding: EdgeInsets.fromLTRB(10, 2, 12, 2),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ),
            SizedBox(
              height: 400,
              child: ListView.builder(
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: amcList.length,
                itemBuilder: (context, index) {
                  Map data = amcList[index];
                  String name = data['amc_name'];
                  String code = data['amc_code'];
                  String img = data['amc_logo'] ?? "";

                  return Visibility(
                    visible: searchVisibility(name, amcSearch),
                    child: InkWell(
                      onTap: () {
                        selectedAmcName = name;
                        selectedAmcCode = code;
                        bottomState(() {});
                      },
                      child: Row(
                        children: [
                          Radio(
                              value: code,
                              groupValue: selectedAmcCode,
                              onChanged: (val) {
                                selectedAmcName = name;
                                selectedAmcCode = code;
                                bottomState(() {});
                              }),
                          index == 0
                              ? Container(height: 32)
                              : Image.network(img, height: 32),
                          SizedBox(width: 10),
                          Expanded(
                              child: Text(name, style: AppFonts.f50014Grey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

bool isValidSlider(num temp) {
  if (temp < 0 || temp > 100)
    return false;
  else
    return true;
}

class CustomTrackShape extends SliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight!;
    final trackLeft = offset.dx + (parentBox.size.height - trackHeight) / 2;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width * 0.8;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight * 1.6);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    bool? isDiscrete,
    bool? isEnabled,
    bool? onActiveTrack,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
  }) {
    final Canvas canvas = context.canvas;
    final rect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled ?? false,
      isDiscrete: isDiscrete ?? false,
    );

    final gradient = LinearGradient(
      colors: [
        Colors.grey.withOpacity(0.2),
        Colors.black.withOpacity(0.5)
      ], // Gradient colors
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    final paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)),
      paint,
    );
  }
}

class CustomThumbShape extends SliderComponentShape {
  static const double _thumbRadius = 3.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(_thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double>? activationAnimation,
    Animation<double>? enableAnimation,
    bool? isDiscrete,
    bool? isEnabled,
    bool? isOnTop,
    TextPainter? labelPainter,
    RenderBox? parentBox,
    SliderThemeData? sliderTheme,
    TextDirection? textDirection,
    double? value,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, _thumbRadius, paint);
  }
}
