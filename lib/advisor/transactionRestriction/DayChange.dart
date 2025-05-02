import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';

import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/pojo/OnlineTransactionRestrictionPojo.dart';
import 'package:mymfbox2_0/rp_widgets/RpFilterChip.dart';
import 'package:mymfbox2_0/rp_widgets/SearchField.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class DayChange extends StatefulWidget {
  const DayChange({super.key});

  @override
  State<DayChange> createState() => _DayChangeState();
}

class _DayChangeState extends State<DayChange> {
  int user_id = GetStorage().read("mfd_id");
  String client_name = GetStorage().read("client_name");
  String mobile = GetStorage().read('mfd_mobile');

  List branchList = [];
  List rmList = [];
  List subBrokerList = [];

  num total_count = 0;

  bool isFirst = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.removeListener(scrollListener);
  }

  Future getDatas() async {
    if (!isFirst) return 0;
    await getAllBranch();
    await getAllRM();
    await getAllSubBroker();
    await getAllOnlineRestrictions();
    isFirst = false;
    return 0;
  }

  Future getAllBranch() async {
    if (branchList.isNotEmpty) return 0;
    Map data = await Api.getAllBranch(mobile: mobile, client_name: client_name);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    branchList = List<String>.from(data['list']);
    print("branchListttt ${branchList.length}");
    branchList.insert(0, "All");
    return 0;
  }

  Future getAllRM() async {
    if (rmList.isNotEmpty) return 0;
    Map data = await Api.getAllRM(
        mobile: mobile, client_name: client_name, branch: "");

    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    rmList = List<String>.from(data['list']);
    rmList.insert(0, "All");
    return 0;
  }

  Future getAllSubBroker() async {
    if (subBrokerList.isNotEmpty) return 0;
    Map data = await Api.getAllSubbroker(
      mobile: mobile,
      client_name: client_name,
    );

    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    subBrokerList = List<String>.from(data['list']);
    subBrokerList.insert(0, "All");
    return 0;
  }

  Timer? searchOnStop;
  searchHandler(String search) {
    searchKey = search;

    const duration = Duration(milliseconds: 1000);
    if (searchOnStop != null) {
      searchOnStop!.cancel();
    }

    searchOnStop = Timer(duration, () async {
      EasyLoading.show(status: "searching for `$searchKey`");
      await getAllOnlineRestrictions();
      EasyLoading.dismiss();

      setState(() {});
    });
  }

  List investorList = [];
  Future getAllOnlineRestrictions() async {
    isLoading = true;
    Map data = await AdminApi.getAllOnlineRestrictions(
        user_id: user_id,
        client_name: client_name,
        branch: selectedBranch.join(","),
        rm_name: selectedRm.join(","),
        subbroker_name: selectedSubBroker.join(","),
        page_id: 1,
        search: searchKey,
        sort_by: "",
        broker_code: "");

    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      return 0;
    }
    total_count = data['total_count'];
    investorList = data['list'];
    isLoading = false;
    setState(() {});
    return 0;
  }

  int page_id = 1;
  String searchKey = "";
  Future getMoreInvestors() async {
    page_id++;

    print("getting more investor with page id = $page_id");
    isLoading = true;
    EasyLoading.show();

    Map data = await AdminApi.getAllOnlineRestrictions(
        user_id: user_id,
        client_name: client_name,
        branch: selectedBranch.join(","),
        rm_name: selectedRm.join(","),
        subbroker_name: selectedSubBroker.join(","),
        page_id: 1,
        search: "",
        sort_by: "",
        broker_code: "");

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    List list = data['list'];
    investorList.addAll(list);
    isLoading = false;
    EasyLoading.dismiss();
    setState(() {});

    return 0;
  }

  Future<void> updateOnlineRestrictionsByUserId({
    num? purchaseUpdate,
    num? redeemUpdate,
    num? stpUpdate,
    num? switchUpdate,
    num? swpUpdate,
    num? onedaychange,
    required num? user_id,
  }) async {
    isLoading = true;
    EasyLoading.show();

    Map<String, dynamic> data = await AdminApi.updateOnlineRestrictionsByUserId(
      user_id: user_id!,
      client_name: client_name,
      purchase_allowed: purchaseUpdate?.toString() ?? "",
      redeem_allowed: redeemUpdate?.toString() ?? "",
      stp_allowed: stpUpdate?.toString() ?? "",
      switch_allowed: switchUpdate?.toString() ?? "",
      swp_allowed: swpUpdate?.toString() ?? "",
      mf_oneday_change: onedaychange?.toString() ?? "",
    );

    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      isLoading = false;
      EasyLoading.dismiss();
      return;
    }

    isLoading = false;
    EasyLoading.dismiss();
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
          appBar: AppBar(
            backgroundColor: Config.appTheme.themeColor,
            leadingWidth: 0,
            toolbarHeight: 80,
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
                    Text(
                      "Mutual Fund Report Transaction",
                      style: AppFonts.f50014Black
                          .copyWith(fontSize: 18, color: Colors.white),
                    ),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          sortFilter();
                        },
                        child: Icon(Icons.filter_alt_outlined)),
                  ],
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              SizedBox(height: 16),
              Container(
                //color: Config.appTheme.themeColor,
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SearchField(
                  bgColor: Config.appTheme.themeColor,
                  hintText: "Search Investors",
                  // controller: _controller,
                  onChange: searchHandler,
                ),
              ),
              countLine(),
              listArea(),
            ],
          ),
        );
      },
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
            Text("${investorList.length} of $total_count Items",
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
            ? Utils.shimmerWidget(devHeight)
            : (investorList.isEmpty)
                ? NoData()
                : ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: investorList.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = investorList[index];
                      OnlineTransactionRestrictionPojo userData =
                          OnlineTransactionRestrictionPojo.fromJson(data);
                      return fundCard(userData);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Container(),
                    ),
                  ),
      ),
    );
  }

  Widget fundCard(OnlineTransactionRestrictionPojo userData) {
    if (isLoading) return Utils.shimmerWidget(200);

    String? investorName = userData.name;
    String? pan = userData.pan;
    String? mobile = userData.mobile;
    return GestureDetector(
      onTap: () {
        dayChangeCkeckBox(userData);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.white),
        child: Column(
          children: [
            //1st row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                  child: Text(
                    "$investorName",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 3,
                    softWrap: true,
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
              child: Text(
                "PAN - $pan",
                style: TextStyle(
                  fontSize: 16,
                ),
                maxLines: 3,
                softWrap: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ColumnText(title: "Mobile", value: "${mobile}"),
                      ColumnText(
                        title: "BSE/NSE Code",
                        value: "${userData.bseNseCode}",
                        alignment: CrossAxisAlignment.center,
                      ),
                    ],
                  ),
                  DottedLine(verticalPadding: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ColumnText(
                        title: "Branch",
                        value: "${userData.branch}",
                        alignment: CrossAxisAlignment.start,
                      ),
                      ColumnText(
                        title: "RM",
                        value: "${userData.rmName}",
                        alignment: CrossAxisAlignment.center,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  dayChangeCkeckBox(userData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool oneDayChange = false;

  void initializeCheckBoxValues(OnlineTransactionRestrictionPojo userData) {
    oneDayChange = userData.oneDayChange == 1;
  }

  Widget dayChangeCkeckBox(OnlineTransactionRestrictionPojo userData) {
    bool currentOneDayChange = userData.oneDayChange == 1;

    return Row(
      children: [
        Checkbox(
          value: currentOneDayChange,
          onChanged: (bool? value) async {
            if (value != null) {
              setState(() {
                userData.oneDayChange = value ? 1 : 0;
              });

              await updateOnlineRestrictionsByUserId(
                onedaychange: userData.oneDayChange,
                user_id: userData.userId,
              );
              await getAllOnlineRestrictions();
            }
          },
        ),
        SizedBox(width: 8),
        Text(
          "One Day Change",
          style: TextStyle(fontSize: 16, color: Config.appTheme.themeColor),
        ),
      ],
    );
  }

  bool showSortChip = true;
  Widget sortLine() {
    print("--------sort-----");
    return Container(
      height: 160,
      width: devWidth,
      color: Config.appTheme.mainBgColor,
      padding: EdgeInsets.only(left: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SortButton(
              onTap: () {
                print("--------sort b-----");
                sortFilter();
              },
            ),
            SizedBox(width: 16),
            multipleFilterChip(selectedBranch),
            multipleFilterChip(selectedRm),
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
                  EasyLoading.show();
                  await getAllOnlineRestrictions();
                  EasyLoading.dismiss();
                  setState(() {});
                },
              )),
    );
  }

  List selectedBranch = [];
  Widget branchView(var bottomState) {
    List branchLists = branchList;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: branchLists.length,
      itemBuilder: (context, index) {
        String title = branchLists[index];
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

  List selectedRm = [];
  Widget rmView(var bottomState) {
    List rmLists = rmList;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: rmLists.length,
      itemBuilder: (context, index) {
        String title = rmLists[index];
        bool isContains = selectedRm.contains(title);
        return InkWell(
          onTap: () async {
            if (isContains)
              selectedRm.remove(title);
            else
              selectedRm.add(title);
            bottomState(() {});
          },
          child: Row(
            children: [
              Checkbox(
                value: selectedRm.contains(title),
                onChanged: (val) async {
                  if (isContains)
                    selectedRm.remove(title);
                  else
                    selectedRm.add(title);
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
    List subBrokerLists = subBrokerList;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: subBrokerLists.length,
      itemBuilder: (context, index) {
        String title = subBrokerLists[index];
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

  Map filterValues = {
    'Branch': [],
    'RM': [],
    'Sub Broker': [],
  };
  String selectedLeft = "Branch";
  String selectedSort = "";

  sortFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (context) {
        return StatefulBuilder(builder: (context, bottomState) {
          return Container(
            height: devHeight * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: cornerBorder,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BottomSheetTitle(title: "Sort & Filter"),
                Divider(height: 1),
                Expanded(
                  flex: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      leftContent(bottomState),
                      Expanded(child: rightContent(bottomState)),
                    ],
                  ),
                ),
                Divider(height: 1),
                SizedBox(
                  height: 70,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                            child: PlainButton(
                          text: "CLEAR ALL",
                          color: Config.appTheme.buttonColor,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          onPressed: () async {
                            Get.back();
                            selectedBranch = [];
                            selectedRm = [];
                            selectedSubBroker = [];
                            EasyLoading.show();
                            await getAllOnlineRestrictions();
                            EasyLoading.dismiss();
                            setState(() {});
                          },
                        )),
                        SizedBox(width: 16),
                        Expanded(
                          child: RpFilledButton(
                            color: Config.appTheme.buttonColor,
                            text: "APPLY",
                            padding: EdgeInsets.symmetric(vertical: 8),
                            onPressed: () async {
                              Get.back();

                              await refreshPage();
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
        });
      },
    );
  }

  bool isLoading = true;
  ScrollController scrollController = ScrollController();
  Future scrollListener() async {
    bool atBottom = scrollController.position.extentAfter < 100;
    bool fullyLoaded = investorList.length == total_count;

    bool fetchAgain = atBottom && !fullyLoaded && !isLoading;

    if (fetchAgain) await getMoreInvestors();
  }

  Widget leftContent(var bottomState) {
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
              : rpLeftBtn(title, () {
                  selectedLeft = title;
                  bottomState(() {});
                });
        },
      ),
    );
  }

  Widget rightContent(var bottomState) {
    if (selectedLeft == 'Branch') return branchView(bottomState);
    if (selectedLeft == 'Sub Broker') return subBrokerView(bottomState);
    if (selectedLeft == 'RM') return rmView(bottomState);
    return Text("Invalid Left");
  }

  Widget rpLeftSelectedBtn({required String title}) {
    bool hasDot = false;
    if (title == 'Branch') hasDot = selectedBranch.isNotEmpty;
    if (title == 'RM') hasDot = selectedRm.isNotEmpty;
    if (title == 'Sub Broker') hasDot = selectedSubBroker.isNotEmpty;

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

  Widget rpLeftBtn(String title, Function() onTap) {
    bool hasDot = false;
    if (title == 'Branch') hasDot = selectedBranch.isNotEmpty;
    if (title == 'RM') hasDot = selectedRm.isNotEmpty;
    if (title == 'Sub Broker') hasDot = selectedSubBroker.isNotEmpty;

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
        ));
  }

  Future<void> refreshPage() async {
    EasyLoading.show();
    await getAllOnlineRestrictions();
    EasyLoading.dismiss();
    scrollController.position.jumpTo(0);
    setState(() {});
  }
}
