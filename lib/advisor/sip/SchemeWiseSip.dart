import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/advisor/sip/ClientWiseSipExposure.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpFilterChip.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import '../../pojo/sip/SchemeWiseSIPPojo.dart';

class SchemeWiseSip extends StatefulWidget {
  const SchemeWiseSip({
    super.key,
    required this.amc,
    this.selectedRisk = const [],
    this.selectedAMC = const [],
    this.selectedCategory = const [],
    this.category = "",
  });
  final List selectedRisk, selectedAMC, selectedCategory;
  final String amc, category;
  @override
  State<SchemeWiseSip> createState() => _SchemeWiseSipState();
}

class _SchemeWiseSipState extends State<SchemeWiseSip> {
  int user_id = GetStorage().read("mfd_id");
  String client_name = GetStorage().read("client_name");
  String mobile = GetStorage().read("mfd_mobile");

  bool isLoading = true;
  List broadCategoryList = [];
  List categoryList = [];
  List schemeList = [];

  Map filterValues = {
    "Sort By": ["Amount", "Alphabet"],
    "Branch": [],
    "RM": [],
    "Sub Broker": [],
  };

  String selectedLeft = "Sort By";
  String selectedSort = "Amount";

  List amcList = [];
  List selectedAMC = [];
  List selectedBroadCategoryList = [];
  List selectedCategory = [];
  String selectedBroadCategory = "All";

  String selectedArn = "All";
  List arnList = [];
  bool sortArn = true;

  num totalCount = 0;
  int page_id = 1;
  Future getInitialSchemes() async {
    page_id = 1;

    Map data = await Api.getSchemeWiseSipDetails(
      user_id: user_id,
      client_name: client_name,
      category: widget.category,
      branch: selectedBranch.join(","),
      rm_name: selectedRM.join(","),
      sub_broker_name: selectedSubBroker.join(","),
      amc_name: widget.amc,
      sort_by: selectedSort,
      broker_code: selectedArn,
      page_id: page_id,
      search: '',
      sip_date: '',
      start_date: '',
      end_date: '',
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    schemeList = data['list'];
    totalCount = data['total_count'];

    return 0;
  }

  Future getMoreSchemes() async {
    page_id++;

    isLoading = true;
    EasyLoading.show();
    Map data = await Api.getSchemeWiseSipDetails(
      user_id: user_id,
      client_name: client_name,
      category: widget.category,
      branch: selectedBranch.join(","),
      rm_name: selectedRM.join(","),
      sub_broker_name: selectedSubBroker.join(","),
      amc_name: selectedAMC.join(","),
      sort_by: selectedSort,
      broker_code: selectedArn,
      page_id: page_id,
      search: '',
      sip_date: '',
      start_date: '',
      end_date: '',
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }

    List list = data['list'];
    schemeList.addAll(list);
    isLoading = false;
    EasyLoading.dismiss();
    setState(() {});

    return 0;
  }

  Future getAllBranch() async {
    if (filterValues['Branch'].isNotEmpty) return 0;
    Map data = await Api.getAllBranch(mobile: mobile, client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    filterValues['Branch'] = data['list'];
    return 0;
  }

  Future getAllRM() async {
    if (filterValues['RM'].isNotEmpty) return 0;
    Map data = await Api.getAllRM(
        mobile: mobile, client_name: client_name, branch: "");

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    filterValues['RM'] = data['list'];
    return 0;
  }

  Future getAllSubBroker() async {
    if (filterValues['Sub Broker'].isNotEmpty) return 0;
    Map data =
        await Api.getAllSubbroker(mobile: mobile, client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    filterValues['Sub Broker'] = data['list'];
    return 0;
  }

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
      filterValues['ARN'] = arnList;
    } catch (e) {
      print("getArnList exception = $e");
    }
    return 0;
  }

  ScrollController scrollController = ScrollController();
  Future scrollListener() async {
    bool atBottom = scrollController.position.extentAfter < 100;
    bool fullyLoaded = schemeList.length == totalCount;

    bool fetchAgain = atBottom && !fullyLoaded && !isLoading;

    if (fetchAgain) await getMoreSchemes();
  }

  bool isFirst = true;
  Future getDatas() async {
    if (!isFirst) return 0;

    await getAllBranch();
    await getAllRM();
    await getAllSubBroker();
    await getArnList();

    await getInitialSchemes();
    isLoading = false;
    isFirst = false;

    return 0;
  }

  @override
  void initState() {
    //  implement initState
    super.initState();

    scrollController.addListener(scrollListener);

    selectedAMC = widget.selectedAMC;
    selectedCategory = List.of(widget.selectedCategory);
  }

  @override
  void dispose() {
    //  implement dispose
    scrollController.removeListener(() {});
    super.dispose();
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
            appBar:
                adminAppBar(title: "Scheme Wise SIPs", bgColor: Colors.white),
            body: Column(
              children: [
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
      padding: EdgeInsets.only(left: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SortButton(onTap: () {
              sortFilter();
            }),
            SizedBox(width: 16),
            multipleFilterChip(selectedBranch),
            multipleFilterChip(selectedRM),
            multipleFilterChip(selectedSubBroker),
          ],
        ),
      ),
    );
  }

  Widget multipleFilterChip(List list) {
    if (list.isEmpty) return SizedBox();

    return Row(
      children: List.generate(
          list.length,
          (index) => RpFilterChip(
                selectedSort: list[index],
                onClose: () async {
                  list.removeAt(index);
                  setState(() {});
                },
              )),
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
            Text("${schemeList.length} of $totalCount Items",
                style: AppFonts.f40013),
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
            ? Utils.shimmerWidget(devHeight,
                margin: EdgeInsets.fromLTRB(16, 0, 16, 16))
            : ListView.separated(
                shrinkWrap: true,
                itemCount: schemeList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = schemeList[index];
                  SchemeWiseSIPPojo scheme = SchemeWiseSIPPojo.fromJson(data);

                  return sipTile(scheme);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: DottedLine(),
                  );
                }),
      ),
    );
  }

  Widget sipTile(SchemeWiseSIPPojo scheme) {
    return InkWell(
      onTap: () {
        Get.to(() => ClientWiseSipExposure(
              scheme_name: "${scheme.schemeAmfi}",
            ));
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
        child: Row(
          children: [
            Image.network(scheme.logo ?? "", height: 28),
            SizedBox(width: 16),
            SizedBox(
              width: devWidth * 0.5,
              child: Text("${scheme.schemeAmfiShortName}",
                  style: cardHeadingSmall),
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$rupee ${Utils.formatNumber(scheme.sipCurrValue, isAmount: true)}",
                  style: cardHeadingSmall,
                ),
                Text("(${scheme.sipCounts} SIPs)"),
              ],
            ),
            SizedBox(width: 5),
            Icon(Icons.arrow_forward_ios, size: 16)
          ],
        ),
      ),
    );
  }

  Widget rpLeftBtn({required String title, required Function() onTap}) {
    bool hasDot = false;
    if (title == 'AMC') hasDot = selectedAMC.isNotEmpty;

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
      shape: RoundedRectangleBorder(borderRadius: cornerBorder),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return Container(
              height: devHeight * 0.7,
              decoration: BoxDecoration(
                borderRadius: cornerBorder,
                color: Colors.white,
              ),
              child: Column(
                children: [
                  BottomSheetTitle(title: "Sort & Filter"),
                  Divider(height: 1),
                  Expanded(
                    flex: 7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        leftContent(bottomState),
                        Expanded(child: rightContent(bottomState))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                              child: PlainButton(
                            text: "CLEAR ALL",
                            padding: EdgeInsets.symmetric(vertical: 8),
                            onPressed: () async {
                              selectedBranch = [];
                              selectedRM = [];

                              Get.back();
                              // await refreshPage();
                            },
                          )),
                          SizedBox(width: 16),
                          Expanded(
                            child: RpFilledButton(
                              text: "APPLY",
                              padding: EdgeInsets.symmetric(vertical: 8),
                              onPressed: () async {
                                Get.back();
                                setState(() {});
                              },
                            ),
                          ),
                        ],
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

  Widget leftContent(void Function(void Function() Function) bottomState) {
    return Container(
      width: devWidth * 0.35,
      color: Config.appTheme.mainBgColor,
      child: ListView.builder(
        itemCount: filterValues.length,
        itemBuilder: (context, index) {
          List list = filterValues.keys.toList();
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
    if (selectedLeft == "Sort By") return sortView(bottomState);
    if (selectedLeft == "Branch") return branchView(bottomState);
    if (selectedLeft == "RM") return rmView(bottomState);
    if (selectedLeft == "Sub Broker") return subBrokerView(bottomState);
    if (selectedLeft == "ARN") return arnView();

    return Text("Invalid left");
  }

  List selectedBranch = [];
  Widget branchView(var bottomState) {
    List branchList = filterValues['Branch'];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: branchList.length,
      itemBuilder: (context, index) {
        String title = branchList[index];
        bool isContains = selectedBranch.contains(title);
        return InkWell(
          onTap: () async {
            if (isContains)
              selectedBranch.remove(title);
            else
              selectedBranch.add(title);
            bottomState(() {});
          },
          child: Row(
            children: [
              Checkbox(
                value: selectedBranch.contains(title),
                activeColor: Config.appTheme.themeColor,
                onChanged: (val) async {
                  if (isContains)
                    selectedBranch.remove(title);
                  else
                    selectedBranch.add(title);
                  bottomState(() {});
                },
              ),
              Flexible(child: Text(title)),
            ],
          ),
        );
      },
    );
  }

  List selectedRM = [];
  Widget rmView(var bottomState) {
    List rmList = filterValues['RM'];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: rmList.length,
      itemBuilder: (context, index) {
        String title = rmList[index];
        bool contains = selectedRM.contains(title);

        return InkWell(
          onTap: () {
            if (contains)
              selectedRM.remove(title);
            else
              selectedRM.add(title);
            bottomState(() {});
          },
          child: Row(
            children: [
              Checkbox(
                value: contains,
                activeColor: Config.appTheme.themeColor,
                onChanged: (val) {
                  if (contains)
                    selectedRM.remove(title);
                  else
                    selectedRM.add(title);
                  bottomState(() {});
                },
              ),
              Flexible(child: Text(title)),
            ],
          ),
        );
      },
    );
  }

  List selectedSubBroker = [];
  Widget subBrokerView(var bottomState) {
    List subBrokerList = filterValues['Sub Broker'];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: subBrokerList.length,
      itemBuilder: (context, index) {
        String title = subBrokerList[index];
        bool isContains = selectedSubBroker.contains(title);
        return InkWell(
          onTap: () async {
            if (isContains)
              selectedSubBroker.remove(title);
            else
              selectedSubBroker.add(title);
            bottomState(() {});
          },
          child: Row(
            children: [
              Checkbox(
                value: selectedSubBroker.contains(title),
                onChanged: (val) async {
                  if (isContains)
                    selectedSubBroker.remove(title);
                  else
                    selectedSubBroker.add(title);
                  bottomState(() {});
                },
              ),
              Flexible(child: Text(title)),
            ],
          ),
        );
      },
    );
  }

  Widget amcView(var bottomState) {
    return ListView.builder(
      itemCount: filterValues['AMC'].length,
      itemBuilder: (context, index) {
        List list = filterValues['AMC'];
        String amc = list[index];
        bool isContains = selectedAMC.contains(amc);

        return InkWell(
          onTap: () {
            if (isContains)
              selectedAMC.remove(amc);
            else
              selectedAMC.add(amc);

            bottomState(() {});
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

  Widget sortView(var bottomState) {
    List list = filterValues['Sort By'];

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        String title = list[index];

        return InkWell(
          onTap: () {
            selectedSort = title;
            bottomState(() {});
          },
          child: Row(
            children: [
              Radio(
                  value: list[index],
                  groupValue: selectedSort,
                  onChanged: (val) {
                    selectedSort = title;
                    bottomState(() {});
                  }),
              Text(list[index]),
            ],
          ),
        );
      },
    );
  }

  Widget arnView() {
    return ListView.builder(
      itemCount: filterValues['ARN'].length,
      itemBuilder: (context, index) {
        List list = filterValues['ARN'];
        String title = list[index];

        return InkWell(
          onTap: () async {
            Get.back();
            selectedArn = title;
            sortArn = true;
            amcList = [];
            await Future.delayed(
                Duration(milliseconds: 250), () => setState(() {}));
          },
          child: Row(
            children: [
              Radio(
                  value: title,
                  groupValue: selectedArn,
                  onChanged: (val) async {
                    Get.back();
                    selectedArn = title;
                    sortArn = true;
                    amcList = [];
                    await Future.delayed(
                        Duration(milliseconds: 250), () => setState(() {}));
                  }),
              Text(title),
            ],
          ),
        );
      },
    );
  }
}
