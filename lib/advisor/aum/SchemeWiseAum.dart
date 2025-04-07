// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/advisor/aum/SchemeWiseInvestor.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/pojo/aum/SchemeWiseAumPojo.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpFilterChip.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class SchemeWiseAum extends StatefulWidget {
  const SchemeWiseAum({
    super.key,
    this.selectedRisk = const [],
    this.selectedCategory = const [],
    this.amc = "",
  });
  final List selectedRisk, selectedCategory;
  final String amc;
  @override
  State<SchemeWiseAum> createState() => _SchemeWiseAumState();
}

class _SchemeWiseAumState extends State<SchemeWiseAum> {
  int user_id = GetStorage().read("mfd_id");
  String client_name = GetStorage().read("client_name");

  bool isLoading = true;
  List broadCategoryList = [];
  List categoryList = [];
  List schemeList = [];
  List<SchemeWiseAumPojo> schemeListPojo = [];
  num? totalMarketValue = 0;
  num itemCount = 0;
  Map bottomSheetFilter = {
    "Sort by": ["Alphabet", "AUM"],
    "AMC": ['aa', 'bb'],
  };
  String selectedLeft = "Sort by";
  String selectedSort = "AUM";
  List amcList = [];
  List selectedAMC = [];
  List selectedBroadCategoryList = [];
  List selectedCategoryList = [];
  String selectedBroadCategory = "All Schemes";
  String selectedCategory = "";
  String selectedRisk = "";
  List selectedRiskList = [];
  String amcParam = "";
  String categoryParam = "";
  String broadCategoryParam = "";
  bool firstRun = true;
  int type_id = GetStorage().read("type_id");

  Future getSchemeList() async {
    if (schemeList.isNotEmpty) return 0;
    Map data = await Api.getSchemesWiseAUM(
        user_id: user_id,
        max_count: "",
        client_name: client_name,
        sort_by: selectedSort,
        amc: selectedAMC.join(","),
        broad_category: selectedBroadCategoryList.join(","),
        category: selectedCategoryList.join(","),
        riskometer: selectedRiskList.join(","));
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    schemeList = data['list'];
    totalMarketValue = data['total_aum'] ?? 0;
    itemCount = data['total_count'];
    return 0;
  }

  Future getTopAmc() async {
    if (amcList.isNotEmpty) return 0;
    Map data = await Api.getTopAmc(client_name: client_name);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    List mapList = data['list'];
    for (var element in mapList) amcList.add(element['name']);
    bottomSheetFilter['AMC'] = amcList;
    amcList.sort((a, b) => a.toString().compareTo(b));
    return 0;
  }

  Future getBroadCategoryList() async {
    if (broadCategoryList.isNotEmpty) return 0;
    Map data = await Api.getBroadCategoryList(
      client_name: client_name
    );
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    List temp = data['list'];
    for (var element in temp) broadCategoryList.add(element['name']);

    bottomSheetFilter['Broad Category'] = broadCategoryList;
    return 0;
  }

  Future getCategoryList({bool merge = false}) async {
    if (categoryList.isNotEmpty) return 0;
    Map data = await Api.getCategoryList(
        category: selectedBroadCategory,
        client_name:client_name);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }

    if (merge)
      categoryList.addAll(data['list']);
    else
      categoryList = data['list'];
    bottomSheetFilter['Category'] = categoryList;
    return 0;
  }

  Future getDatas() async {
    isLoading = true;
    await getSchemeList();
    await getBroadCategoryList();
    await getCategoryList();
    await getTopAmc();
    bottomSheetFilter['Risk-O-Meter'] = [
      "Low",
      "Low to Moderate",
      "Moderate",
      "Moderately High",
      "High",
      "Very High",
    ];

    isLoading = false;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    selectedRiskList = List.of(widget.selectedRisk);
    selectedCategoryList = List.of(widget.selectedCategory);
    if (widget.amc.isNotEmpty) selectedAMC.add(widget.amc);
  }

  late double devHeight, devWidth;
  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white,
            // appBar: appBar(),
            appBar:
                adminAppBar(title: "Scheme Wise AUM", bgColor: Colors.white),
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
      color: Config.appTheme.mainBgColor,
      padding: EdgeInsets.all(16),
      child: ListView(
        scrollDirection: Axis.horizontal,
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
                schemeList = [];
                setState(() {});
              },
            ),
          if (selectedAMC.isNotEmpty)
            Row(
              children: List.generate(
                  selectedAMC.length,
                  (index) => RpFilterChip(
                        selectedSort: selectedAMC[index],
                        onClose: () {
                          selectedAMC.removeAt(index);
                          schemeList = [];
                          setState(() {});
                        },
                      )),
            ),
          if (selectedBroadCategoryList.isNotEmpty)
            Row(
              children: List.generate(
                  selectedBroadCategoryList.length,
                  (index) => RpFilterChip(
                        selectedSort: selectedBroadCategoryList[index],
                        onClose: () {
                          selectedBroadCategoryList.removeAt(index);
                          selectedCategoryList.removeAt(index);
                          schemeList = [];
                          setState(() {});
                        },
                      )),
            ),
          if (selectedCategoryList.isNotEmpty)
            Row(
                children: List.generate(
                    selectedCategoryList.length,
                    (index) => RpFilterChip(
                          selectedSort: selectedCategoryList[index],
                          onClose: () {
                            selectedCategoryList.removeAt(index);
                            schemeList = [];
                            setState(() {});
                          },
                        ))),
          if (selectedRiskList.isNotEmpty)
            Row(
              children: List.generate(
                  selectedRiskList.length,
                  (index) => RpFilterChip(
                        selectedSort: selectedRiskList[index],
                        onClose: () {
                          selectedRiskList.removeAt(index);
                          schemeList = [];
                          setState(() {});
                        },
                      )),
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
            Text("$itemCount Items", style: AppFonts.f40013),
            Text(
                "Total AUM $rupee ${Utils.formatNumber(totalMarketValue, isAmount: true)}",
                style: cardHeadingSmall.copyWith(
                    color: Config.appTheme.themeColor)),
          ],
        ),
      ),
    );
  }

  /*double calculateTotalMarketValue(List schemeList) {
    double total = 0;
    for (var scheme in schemeList) {
      double marketValue = scheme['market_value'] ?? 0;
      total += marketValue;
    }
    return total;
  }*/

  Widget listArea() {
    return Expanded(
      child: SingleChildScrollView(
        child: (isLoading)
            ? Utils.shimmerWidget(devHeight)
            : ListView.separated(
                shrinkWrap: true,
                itemCount: schemeList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  Map scheme = schemeList[index];

                  num amount = scheme['market_value'] ?? 0;
                  num percentage = scheme['returns'] ?? 0;
                  String schemeFullName = scheme['scheme_name'] ?? "null";
                  String schemeShortName =
                      scheme['scheme_amfi_short_name'] ?? "null";

                  return InkWell(
                    onTap: () {
                      print("typeid - $type_id");
                      if(type_id == UserType.ADMIN){

                        Get.to(() => SchemeWiseInvestor(
                          schemeFullname: schemeFullName,
                          logo: "${scheme['logo']}",
                          amount: amount,
                          percentage: percentage,
                          schemeShortName: schemeShortName,
                        ));
                      }
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        children: [
                          //Image.network("${scheme['logo'] ?? ""}", height: setImageSize(30)),
                          Utils.getImage(
                              "${scheme['logo'] ?? ""}", setImageSize(30)),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text("${scheme['scheme_amfi_short_name']}",
                                style: cardHeadingSmall),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "$rupee ${Utils.formatNumber(amount, isAmount: true)}",
                                style: cardHeadingSmall,
                              ),
                              Text(
                                "($percentage%)",
                                style: TextStyle(
                                  color: Config
                                      .appTheme.placeHolderInputTitleAndArrow,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 5),
                          if(type_id == UserType.ADMIN)
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color:
                                Config.appTheme.placeHolderInputTitleAndArrow,
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(
                      height: 1,
                      color: Config.appTheme.lineColor,
                    ),
                  );
                }),
      ),
    );
  }

  Widget rpLeftBtn({required String title, required Function() onTap}) {
    bool hasDot = false;
    if (title == 'AMC') hasDot = selectedAMC.isNotEmpty;
    if (title == 'Broad Category')
      hasDot = selectedBroadCategoryList.isNotEmpty;
    if (title == 'Category') hasDot = selectedCategoryList.isNotEmpty;
    if (title == "Risk-O-Meter") hasDot = selectedRiskList.isNotEmpty;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: hasDot,
              child: Padding(
                padding: EdgeInsets.only(right: 5),
                child: CircleAvatar(
                  radius: 4,
                  backgroundColor: Config.appTheme.themeColor,
                ),
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget rpLeftSelectedBtn({required String title}) {
    bool hasDot = false;
    if (title == 'AMC') hasDot = selectedAMC.isNotEmpty;
    if (title == 'Broad Category')
      hasDot = selectedBroadCategoryList.isNotEmpty;
    if (title == 'Category') hasDot = selectedCategoryList.isNotEmpty;
    if (title == "Risk-O-Meter") hasDot = selectedRiskList.isNotEmpty;

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        width: double.maxFinite,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: hasDot,
              child: Padding(
                padding: EdgeInsets.only(right: 5),
                child: CircleAvatar(
                  radius: 4,
                  backgroundColor: Config.appTheme.themeColor,
                ),
              ),
            ),
            Text(title, style: TextStyle(color: Config.appTheme.themeColor)),
          ],
        ),
      ),
    );
  }

  sortFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return Container(
              height: devHeight * 0.7,
              decoration: BoxDecoration(
                  borderRadius: cornerBorder, color: Colors.white),
              child: Column(
                children: [
                  BottomSheetTitle(title: "Sort & Filter"),
                  Divider(height: 0),
                  Expanded(
                    flex: 7,
                    child: Row(
                      children: [
                        leftContent(bottomState),
                        Expanded(child: rightContent(bottomState))
                      ],
                    ),
                  ),
                  Divider(height: 1),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      child: Row(children: [
                        Expanded(
                            child: PlainButton(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          text: "Clear All",
                          onPressed: () {
                            selectedAMC = [];
                            selectedBroadCategoryList = [];
                            selectedCategoryList = [];
                            selectedRiskList = [];
                            // filteredSchemes = [];
                            schemeList = [];
                            Get.back();
                            setState(() {});
                          },
                        )),
                        SizedBox(width: 16),
                        Expanded(
                            child: RpFilledButton(
                          text: "Apply",
                          onPressed: () async {
                            print("selectedAMC $selectedAMC");

                            amcParam = selectedAMC.join(", ");
                            broadCategoryParam =
                                selectedBroadCategoryList.join(", ");
                            categoryParam = selectedCategoryList.join(", ");
                            selectedRisk = selectedRiskList.join(", ");

                            schemeList = [];
                            await getSchemeList();
                            setState(() {});
                            Get.back();
                          },
                        )),
                      ]),
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
    List list = bottomSheetFilter.keys.toList();

    return Container(
      width: devWidth * 0.35,
      color: Config.appTheme.mainBgColor,
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          String title = list[index];
          return (selectedLeft == title)
              ? rpLeftSelectedBtn(title: title)
              : rpLeftBtn(
                  title: title,
                  onTap: () {
                    selectedLeft = title;
                    bottomState(() {});
                  });
        },
      ),
    );
  }

  Widget rightContent(var bottomState) {
    if (selectedLeft == 'Sort by') return sortView(bottomState);
    if (selectedLeft == 'AMC') return amcView(bottomState);
    if (selectedLeft == 'Broad Category') return broadCategoryView(bottomState);
    if (selectedLeft == 'Category') return categoryView(bottomState);
    if (selectedLeft == "Risk-O-Meter") return riskView(bottomState);
    return Text("data");
  }

  Widget riskView(var bottomState) {
    return ListView.builder(
      itemCount: bottomSheetFilter["Risk-O-Meter"].length,
      itemBuilder: (context, index) {
        List list = bottomSheetFilter["Risk-O-Meter"];
        String title = list[index];
        bool contains = selectedRiskList.contains(title);

        return InkWell(
          onTap: () {
            if (contains)
              selectedRiskList.remove(title);
            else
              selectedRiskList.add(title);
            bottomState(() {});
          },
          child: Row(
            children: [
              Checkbox(
                value: contains,
                onChanged: (value) {
                  if (contains)
                    selectedRiskList.remove(title);
                  else
                    selectedRiskList.add(title);
                  bottomState(() {});
                },
              ),
              Text(title)
            ],
          ),
        );
      },
    );
  }

  Widget amcView(var bottomState) {
    return ListView.builder(
      itemCount: bottomSheetFilter['AMC'].length,
      itemBuilder: (context, index) {
        List list = bottomSheetFilter['AMC'];
        String amc = list[index];
        bool isContains = selectedAMC.contains(amc);

        return InkWell(
          onTap: () {
            if (isContains)
              selectedAMC.remove(amc);
            else
              selectedAMC.add(amc);
          },
          child: Row(
            children: [
              Checkbox(
                  value: selectedAMC.contains(amc),
                  onChanged: (val) {
                    if (isContains)
                      selectedAMC.remove(amc);
                    else
                      selectedAMC.add(amc);

                    bottomState(() {});
                  }),
              Flexible(child: Text(amc)),
            ],
          ),
        );
      },
    );
  }

  applySort() {
    if (selectedSort == 'Alphabet') {
      schemeList.sort(
        (a, b) => a.schemeAmfiShortName!.compareTo(b.schemeAmfiShortName!),
      );
    }
    if (selectedSort == 'AUM') {
      schemeList.sort(
        (a, b) => b.marketValue!.compareTo(a.marketValue!),
      );
    }
  }

  List<SchemeWiseAumPojo> amcFilter(List<SchemeWiseAumPojo> allList) {
    List<SchemeWiseAumPojo> filtered = [];
    allList.forEach((element) {
      if (selectedAMC.contains(element.amcName)) filtered.add(element);
    });

    return filtered;
  }

  List<SchemeWiseAumPojo> broadCategoryFilter(List<SchemeWiseAumPojo> allList) {
    List<SchemeWiseAumPojo> filtered = [];
    allList.forEach((element) {
      if (selectedBroadCategoryList.contains(element.schemeBroadCategory))
        filtered.add(element);
    });

    return filtered;
  }

  List<SchemeWiseAumPojo> categoryFilter(List<SchemeWiseAumPojo> allList) {
    List<SchemeWiseAumPojo> filtered = [];
    allList.forEach((element) {
      if (selectedCategoryList.contains(element.schemeSubCategory))
        filtered.add(element);
    });

    return filtered;
  }

  List<SchemeWiseAumPojo> riskFilter(List<SchemeWiseAumPojo> allList) {
    List<SchemeWiseAumPojo> filtered = [];
    allList.forEach((element) {
      if (selectedRiskList.contains(element.riskometer)) filtered.add(element);
    });

    return filtered;
  }

  Widget broadCategoryView(var bottomState) {
    List list = bottomSheetFilter['Broad Category'];

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        String title = list[index];
        bool isContains = selectedBroadCategoryList.contains(title);

        return InkWell(
          onTap: () async {
            if (isContains) {
              selectedBroadCategoryList.remove(title);
              selectedCategoryList.remove(title);
            } else {
              selectedBroadCategoryList.add(title);
              selectedCategoryList = [];
              bottomState(() {});
              categoryList = [];

              /* if (selectedBroadCategoryList.isEmpty) {
              selectedBroadCategory = "All";
              await getCategoryList();
            }*/

              selectedBroadCategoryList.forEach((element) async {
                selectedBroadCategory = element;

                await getCategoryList(merge: true);
              });
            }
          },
          child: Row(
            children: [
              Checkbox(
                  value: isContains,
                  onChanged: (val) async {
                    if (isContains) {
                      selectedBroadCategoryList.remove(title);
                      selectedCategoryList.remove(title);
                    } else {
                      selectedBroadCategoryList.add(title);
                      selectedCategoryList = [];
                      bottomState(() {});
                      categoryList = [];

                      /*  if (selectedBroadCategoryList.isEmpty) {
                      selectedBroadCategory = "All";
                      await getCategoryList();
                    }*/

                      selectedBroadCategoryList.forEach((element) async {
                        selectedBroadCategory = element;

                        await getCategoryList(merge: true);
                      });
                    }
                  }),
              Flexible(child: Text(title)),
            ],
          ),
        );
      },
    );
  }

  Widget categoryView(var bottomState) {
    /*if (selectedBroadCategoryList.isEmpty)
      return Container(
          alignment: Alignment.topLeft,
          child: Text(
            " Please select broad category",
            style: AppFonts.f40013,
          ));*/
    return ListView.builder(
      itemCount: bottomSheetFilter['Category'].length,
      itemBuilder: (context, index) {
        List list = bottomSheetFilter['Category'];
        String title = list[index];
        bool isContains = selectedCategoryList.contains(title);

        return InkWell(
          onTap: () {
            if (isContains)
              selectedCategoryList.remove(title);
            else
              selectedCategoryList.add(title);
            print("selectedCategory = $selectedCategory");
            bottomState(() {});
          },
          child: Row(
            children: [
              Checkbox(
                  value: isContains,
                  onChanged: (val) {
                    if (isContains)
                      selectedCategoryList.remove(title);
                    else
                      selectedCategoryList.add(title);
                    print("selectedCategory = $selectedCategory");
                    bottomState(() {});
                  }),
              Flexible(child: Text(list[index])),
            ],
          ),
        );
      },
    );
  }

  Widget sortView(var bottomState) {
    return ListView.builder(
      itemCount: bottomSheetFilter['Sort by'].length,
      itemBuilder: (context, index) {
        List list = bottomSheetFilter['Sort by'];

        return InkWell(
          onTap: () {
            selectedSort = list[index];
            showSortChip = true;
            bottomState(() {});
          },
          child: Row(
            children: [
              Radio(
                  value: list[index],
                  activeColor: Config.appTheme.themeColor,
                  groupValue: selectedSort,
                  onChanged: (val) {
                    selectedSort = list[index];
                    showSortChip = true;
                    bottomState(() {});
                  }),
              Text(list[index]),
            ],
          ),
        );
      },
    );
  }
}
