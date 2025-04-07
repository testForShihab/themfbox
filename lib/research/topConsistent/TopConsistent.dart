import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/pojo/TopConsistentFundPojo.dart';
import 'package:mymfbox2_0/research/SchemeInfo.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class TopConsistent extends StatefulWidget {
  const TopConsistent({super.key});

  @override
  State<TopConsistent> createState() => _TopConsistentState();
}

class _TopConsistentState extends State<TopConsistent> {
  String client_name = GetStorage().read("client_name");

  List<ConsistentFundsPojo> topConsistentFundPojo = [];
  String selectedSort = "Returns";

  List sortList = [
    "Returns",
    "A to Z",
    "AUM (High to Low)",
    "TER (Low to High)"
  ];

  Map periodMap = {0: "1Y", 1: "3Y", 2: "5Y", 3: "10Y"};
  String period = "1Y";
  String selectedCategory = "Equity Schemes";
  String selectedSubCategory = "Equity: Large and Mid Cap";

  bool isLoading = true;

  List subCategoryList = [];
  List consistentFunds = [];
  List allCategories = [];

  Future getDatas() async {
    EasyLoading.show();
    await getCategoryList();
    await getSubCategoryList();
    await getTopConsistentFund();
    EasyLoading.dismiss();
    isLoading = false;
    return 0;
  }

  Future getCategoryList() async {
    if (allCategories.isNotEmpty) return 0;
    Map data = await Api.getBroadCategoryList(client_name: client_name);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    allCategories = data['list'];
    return 0;
  }

  Future getSubCategoryList() async {
    if (subCategoryList.isNotEmpty) return 0;

    Map data = await Api.getCategoryList(
        category: selectedCategory, client_name: client_name);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    subCategoryList = data['list'];
    return 0;
  }

  Future getTopConsistentFund() async {
    if (consistentFunds.isNotEmpty) return 0;

    Map data = await Api.getTopConsistentFund(
      subCategory: selectedSubCategory,
      period: period,
      client_name: client_name,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    consistentFunds = data['consistentFunds'];

    convertListToObj();

    return 0;
  }

  convertListToObj() {
    topConsistentFundPojo = [];

    for (var element in consistentFunds) {
      topConsistentFundPojo.add(ConsistentFundsPojo.fromJson(element));
    }
    topConsistentFundPojo
        .sort((a, b) => b.returnsAbs!.compareTo(a.returnsAbs!));
  }

  late double devWidth, devHeight;

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return DefaultTabController(
            length: 4,
            child: Scaffold(
              backgroundColor: Config.appTheme.mainBgColor,
              //backgroundColor: Color(0XFFECF0F0),
              appBar: AppBar(
                backgroundColor: Config.appTheme.themeColor,
                leadingWidth: 0,
                toolbarHeight: 150,
                elevation: 1,
                leading: SizedBox(),
                title: Column(
                  children: [
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Top Consistent Funds",
                            style: AppFonts.f50014Black
                                .copyWith(fontSize: 20, color: Colors.white),
                          ),
                          //Spacer(),
                          //MfAboutIcon(context: context),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showCategoryBottomSheet();
                          },
                          child: appBarColumn(
                              "Category",
                              getFirst13(selectedSubCategory),
                              Icon(Icons.keyboard_arrow_down,
                                  color: Config.appTheme.themeColor)),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                  ],
                ),
                bottom: TabBar(
                    padding: EdgeInsets.only(bottom: 15, top: 10),
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white,
                    dividerColor: Config.appTheme.themeColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    onTap: (val) {
                      print("tab tap = $val");
                      consistentFunds = [];
                      setState(() {
                        isLoading = true;
                        period = periodMap[val];
                      });
                    },
                    tabs: [
                      Tab(text: "1 Y"),
                      Tab(text: "3 Y"),
                      Tab(text: "5 Y"),
                      Tab(text: "10 Y"),
                    ]),
              ),
              body: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    displayPage(),
                    displayPage(),
                    displayPage(),
                    displayPage(),
                  ]),
            ),
          );
        });
  }

  String getFirst13(String text) {
    String s = text.split(":").last;
    if (s.length > 18) s = s.substring(0, 18);
    return s;
  }

  Widget displayPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Text("${consistentFunds.length} funds",
                style: TextStyle(
                    color: Color(0XFFB4B4B4), fontWeight: FontWeight.bold)),
          ),
          (!isLoading && consistentFunds.isEmpty)
              ? NoData()
              : ListView.builder(
                  itemCount: consistentFunds.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return fundCard(topConsistentFundPojo[index]);
                  },
                ),
          SizedBox(
            height: devHeight * 0.01,
          )
        ],
      ),
    );
  }

  showAboutDialogBottom() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (_, bottomState) {
            return Container(
              //color: Colors.white,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(0.5)),
              height: devHeight * 0.7,
              padding: EdgeInsets.all(7),
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("  About",
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
                  Container(
                    // decoration: BoxDecoration(color: Colors.white),
                    alignment: Alignment.center,
                    child: Text(
                      "\nMost consistent funds consisting of Top 10 Mutual Fund Schemes in each category"
                      " have been chosen based on average rolling returns and consistency with which funds have"
                      " beaten category average returns. \n\nWe have ranked schemes based on these two parameters "
                      "using our proprietary algorithm and are showing the most consistent schemes for each category."
                      " Note that we have ranked schemes which have performance track records of at least 5 years "
                      "(consistency cannot be measured unless a scheme has sufficiently long track record covering"
                      "multiple market cycles e.g. bull market, bear market,sideways market etc.). \n\nAlso note that,"
                      "schemes whose AUMs have not yet reached Rs 500 Crores have been excluded from the ranking.",
                      maxLines: 20,
                      softWrap: true,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  String selectedChip = "";
  String title = "";

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
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allCategories.length,
                    itemBuilder: (context, index) {
                      Map temp = allCategories[index];

                      return (selectedCategory == temp['name'])
                          ? selectedCategoryChip(
                              "${temp['name']}", "${temp['count']}")
                          : GestureDetector(
                              onTap: () async {
                                selectedCategory = temp['name'];
                                subCategoryList = [];
                                //  title = temp['name'];
                                await getSubCategoryList();

                                bottomState(() {});
                              },
                              child: categoryChip(
                                  "${temp['name']}", "${temp['count']}")
                              /*child:RpSelectableChip(
                               onTap: (){
                                 selectedChip = selectedCategory;
                                 setState(() {});
                               },
                                 isSelected: selectedChip == selectedCategory,
                                 title: "${temp['name']}" "${temp['count']}"
                             ),*/
                              );
                    },
                  ),
                ),
                SizedBox(height: 10),
                (isLoading)
                    ? Text("Loading 1..")
                    : Expanded(
                        child: ListView.builder(
                          itemCount: subCategoryList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            String temp =
                                subCategoryList[index].split(":").last;
                            return InkWell(
                              onTap: () async {
                                selectedSubCategory = subCategoryList[index];
                                consistentFunds = [];
                                bottomState(() {});
                                // EasyLoading.show();
                                await getTopConsistentFund();
                                // EasyLoading.dismiss();

                                Get.back();
                                setState(() {
                                  print(
                                      "selectedSubCategory = $selectedSubCategory");
                                });
                              },
                              child: Row(
                                children: [
                                  Radio(
                                      value: subCategoryList[index],
                                      groupValue: selectedSubCategory,
                                      activeColor: Config.appTheme.themeColor,
                                      onChanged: (val) async {
                                        selectedSubCategory =
                                            subCategoryList[index];
                                        consistentFunds = [];
                                        bottomState(() {});
                                        // EasyLoading.show();
                                        //  await getTopConsistentFund();
                                        // EasyLoading.dismiss();

                                        Get.back();
                                        setState(() {
                                          print(
                                              "selectedSubCategory = $selectedSubCategory");
                                        });
                                      }),
                                  // Container(
                                  //     height: 30,
                                  //     width: 30,
                                  //     decoration: BoxDecoration(
                                  //         color: Color(0xffF8DFD5),
                                  //         borderRadius:
                                  //             BorderRadius.circular(5)),
                                  //     child: Icon(Icons.bar_chart,
                                  //         color: Colors.red, size: 20)),
                                  Text("$temp"),
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

  Widget selectedCategoryChip(String name, String count) {
    List l = name.split(" ");
    if (l.length > 2)
      name = "${l[0]} ${l[1]}";
    else
      name = "${l[0]}";

    return Container(
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          color: Config.appTheme.themeColor,
          borderRadius: BorderRadius.circular(8)),
      child: Text("$name ($count)", style: TextStyle(color: Colors.white)),
    );
  }

  Widget categoryChip(String name, String count) {
    List l = name.split(" ");
    if (l.length > 2)
      name = "${l[0]} ${l[1]}";
    else
      name = "${l[0]}";

    return Container(
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          color: Color(0XFFF1F1F1), borderRadius: BorderRadius.circular(8)),
      child: Text("$name ($count)"),
    );
  }

  Widget appBarColumn(String title, String value, Widget suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14, color: Colors.white)),
        Container(
          width: devWidth * 0.44,
          padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Color(0XFFFFFFFF),
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

  Widget fundCard(ConsistentFundsPojo fund) {
    if (isLoading) return Utils.shimmerWidget(200);

    num aum = fund.schemeAssets ?? 0;
    // String aum = temp.toStringAsFixed(2);
    // dynamic formattedValue = formatter.format(num.parse(aum));

    //  print(formattedValue);
    //print("temp $aum");
    String? schemeName = fund.schemeAmfi;
    String? schemeShortName = fund.schemeAmfiShortName;
    String? schemeLogo = fund.logo;
    String? riskoMeter = fund.riskoMeter;
    num returnsAbs = fund.returnsAbs ?? 0;
    num mean = fund.mean ?? 0;
    num sharpratio = fund.sharpratio ?? 0;
    num alpha = fund.alpha ?? 0;
    num beta = fund.beta ?? 0;
    num stdDev = fund.std_dev ?? 0;
    return GestureDetector(
      onTap: () {
        Get.to(SchemeInfo(
            schemeName: schemeName,
            schemeShortName: schemeShortName,
            schemeLogo: schemeLogo));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 0, 0),
              child: Row(
                children: [
                  Utils.getImage(fund.logo ?? "", 30),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$schemeShortName",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis, // Prevents overflow
                        ),
                        Row(
                          children: [
                            Text(
                              "Launch Date : ",
                              style: AppFonts.f40013.copyWith(fontSize: 12),
                              softWrap: true,
                            ),
                            Flexible(
                              child: Text(
                                "${fund.schemeInceptionDate}",
                                style: AppFonts.f50014Grey.copyWith(
                                    color: Colors.black, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: devWidth * 0.25,
                    padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                    decoration: BoxDecoration(
                        color: Color(0xffEDFFFF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        )),
                    child: Row(children: [
                      Flexible(
                        child: Text(
                          "${fund.schemeRating}",
                          style: TextStyle(
                              color: Config.appTheme.themeColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w500),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]),
                  )
                ],
              ),
            ),
            DottedLine(verticalPadding: 8),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                children: [
                  rpRow(
                      lhead: "AUM (Cr)", lSubHead: "$rupee ${Utils.formatNumber(aum / 10)}",
                      rhead: "TER", rSubHead: "${Utils.formatNumber(fund.ter)} %",
                      chead: "$period Returns (%)", cSubHead: "${(returnsAbs == 0) ? "-" :Utils.formatNumber(returnsAbs)}",
                      cHeadValueStyle: AppFonts.f50014Theme.copyWith(
                          color: (returnsAbs > 0)
                              ? Config.appTheme.defaultProfit
                              : Config.appTheme.defaultLoss)),

                  SizedBox(height: 10,),
                  rpRow(
                      lhead: "Mean", lSubHead: Utils.formatNumber(mean),
                      rhead: "Sharp Ratio", rSubHead: Utils.formatNumber(sharpratio),
                      chead: "Alpha", cSubHead: Utils.formatNumber(alpha),),
                  SizedBox(height: 10,),
                  rpRow(
                      lhead: "Beta", lSubHead: Utils.formatNumber(beta),
                      rhead: "Std Deviation", rSubHead: Utils.formatNumber(stdDev),
                      chead: "", cSubHead: ""),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rpRow({
    required String lhead,
    required String lSubHead,
    required String rhead,
    required String rSubHead,
    required String chead,
    required String cSubHead,
    final TextStyle? valueStyle,
    final TextStyle? cHeadValueStyle,
    final TextStyle? titleStyle,
  }) {
    return Row(
      children: [

        Expanded(
            child: ColumnText(
                title: lhead,
                value: lSubHead,
                alignment: CrossAxisAlignment.start)),

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
                valueStyle: cHeadValueStyle,
                alignment: CrossAxisAlignment.end)),
      ],
    );
  }

  int customRound(double value) {
    // Extract the integer part and the decimal part
    int integerPart = value.toInt();
    double decimalPart = value - integerPart;

    // If the decimal part is 0.5 or greater, return the integer part + 1
    if (decimalPart >= 0.5) {
      return integerPart + 1;
    } else {
      return integerPart;
    }
  }

  void showSortFilter() {
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
          builder: (context, bottomState) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(7),
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Allows the column to be as tall as its content
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "  Sort By",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Use Navigator.pop() instead of Get.back() for consistency
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Divider(),
                    ListView.builder(
                      itemCount: sortList.length,
                      shrinkWrap: true,
                      // Ensures the ListView takes up only as much space as needed
                      physics: NeverScrollableScrollPhysics(),
                      // Prevents ListView from scrolling
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            selectedSort = sortList[index];
                            bottomState(() {});
                            sortOptions();
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: sortList[index],
                                groupValue: selectedSort,
                                activeColor: Config.appTheme.themeColor,
                                onChanged: (val) {
                                  selectedSort = sortList[index];
                                  bottomState(() {});
                                  sortOptions();
                                },
                              ),
                              Text(sortList[index]),
                            ],
                          ),
                        );
                      },
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

  sortOptions() {
    if (selectedSort.contains("AUM")) {
      topConsistentFundPojo
          .sort((a, b) => b.schemeAssets!.compareTo(a.schemeAssets!));
    }
    if (selectedSort.contains("Returns")) {
      topConsistentFundPojo
          .sort((a, b) => b.returnsAbs!.compareTo(a.returnsAbs!));
    }
    if (selectedSort.contains("TER")) {
      topConsistentFundPojo.sort((a, b) => a.ter!.compareTo(b.ter!));
    }
    if (selectedSort == "A to Z") {
      topConsistentFundPojo.sort(
          (a, b) => a.schemeAmfiShortName!.compareTo(b.schemeAmfiShortName!));
    }
    Get.back();
    setState(() {});
  }
}
