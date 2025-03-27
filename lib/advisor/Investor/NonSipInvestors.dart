import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/utils/Restrictions.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mymfbox2_0/login/CheckAuth.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/RectButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpFilterChip.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile2.dart';
import 'package:mymfbox2_0/rp_widgets/SearchField.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';

import 'package:mymfbox2_0/pojo/NonSIPInvestorsPojo.dart';

import '../../login/CheckUserType.dart';

class NonSipInvestors extends StatefulWidget {
  const NonSipInvestors({super.key});

  @override
  State<NonSipInvestors> createState() => _NonSipInvestorsState();
}

class _NonSipInvestorsState extends State<NonSipInvestors> {
  int user_id = GetStorage().read("mfd_id");
  String client_name = GetStorage().read("client_name");
  String mobile = GetStorage().read('mfd_mobile');

  String arn = "All";

  int page_id = 1;
  String selectedSort = "Alphabet A-z";
  bool isLoading = true;
  List investorList = [];
  String selectedSortValue = "Alphabet-ASC";

  List selectedRm = [];
  List selectedBranch = [];
  List sortOptions = [
    "Alphabet-ASC",
    "Alphabet-DESC",
    "AUM-ASC",
    "AUM-DESC",
  ];

  Future getNonSipDetails() async {
    page_id = 1;
    String tempSort = selectedSort;

    if (selectedSort.contains("Alphabet")) {
      tempSort = selectedSort.replaceAll("-", "");
      tempSort = tempSort.replaceAll("", "-");
    }

    Map data = await AdminApi.getNonSipDetails(
        page_id: page_id,
        client_name: client_name,
        broker_code: arn,
        sub_broker_name: selectedSubBroker.join(","),
        rmList: selectedRm.join(","),
        search: searchKey,
        user_id: user_id,
        sort_by: selectedSortValue,
        branch: selectedBranch.join(","));

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    investorList = data['list'];
    totalCount = data['total_count'];
    totalAum = data['total_aum'];
    isLoading = false;
    return 0;
  }

  String searchKey = "";
  Future getMoreInvestors() async {
    page_id++;
    isLoading = true;
    EasyLoading.show();

    String tempSort = selectedSort;
    if (selectedSort.contains("Alphabet")) {
      tempSort = selectedSort.replaceAll("-", "");
      tempSort = selectedSort.replaceAll("", "-");
    }

    Map data = await AdminApi.getNonSipDetails(
      page_id: page_id,
      client_name: client_name,
      user_id: user_id,
      search: searchKey,
      sort_by: tempSort,
      rmList: selectedRm.join(","),
      branch: selectedBranch.join(","),
      sub_broker_name: selectedSubBroker.join(","),
    );
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

  List branchList = [];
  Future getAllBranch() async {
    if (branchList.isNotEmpty) return 0;
    Map data = await Api.getAllBranch(mobile: mobile, client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    branchList = data['list'];
    return 0;
  }

  List rmList = [];
  Future getAllRM() async {
    if (rmList.isNotEmpty) return 0;
    Map data = await Api.getAllRM(
        mobile: mobile, client_name: client_name, branch: "");

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    rmList = data['list'];
    return 0;
  }

  List subBrokerList = [];
  Future getAllSubBroker() async {
    if (subBrokerList.isNotEmpty) return 0;
    Map data =
        await Api.getAllSubbroker(mobile: mobile, client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    subBrokerList = data['list'];
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
      await getNonSipDetails();
      EasyLoading.dismiss();

      setState(() {});
    });
  }

  bool isFirst = true;
  Future getDatas() async {
    if (!isFirst) return 0;

    if (Restrictions.isBranchApiAllowed) await getAllBranch();
    if (Restrictions.isRmApiAllowed) await getAllRM();
    if (Restrictions.isAssociateApiAllowed) await getAllSubBroker();
    await getNonSipDetails();

    isFirst = false;
    return 0;
  }

  num totalCount = 0, totalAum = 0;
  ScrollController scrollController = ScrollController();
  Future scrollListener() async {
    bool atBottom = scrollController.position.extentAfter < 100;
    bool fullyLoaded = investorList.length == totalCount;

    bool fetchAgain = atBottom && !fullyLoaded && !isLoading;

    if (fetchAgain) await getMoreInvestors();
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    //  implement dispose
    super.dispose();
    scrollController.removeListener(scrollListener);
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
                adminAppBar(title: "Non SIP Investors", bgColor: Colors.white),
            body: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SearchField(
                    hintText: "Search Investors",
                    onChange: searchHandler,
                  ),
                ),
                //sortLine(),
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
            SortButton(
              onTap: () {
                sortBottomSheet();
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
                  await getNonSipDetails();
                  EasyLoading.dismiss();
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
            Text("${investorList.length} of $totalCount Items",
                style: AppFonts.f40013),
            Text(
                "Total AUM $rupee${Utils.formatNumber(totalAum, isAmount: true)}",
                style: AppFonts.f40016
                    .copyWith(fontSize: 16, color: Config.appTheme.themeColor))
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
                      NonSIPInvestorsPojo userData =
                          NonSIPInvestorsPojo.fromJson(data);

                      return InkWell(
                        onTap: () {
                          showUserDetails(userData);
                        },
                        child: RpListTile2(
                            leading: InitialCard(
                                title: (data['inv_name'] == "")
                                    ? "."
                                    : data['inv_name']),
                            l1: "${userData.invName}",
                            l2: "${userData.invPan}",
                            r1: "$rupee ${Utils.formatNumber(userData.aumAmount, isAmount: true)}",
                            r2: ""),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: DottedLine(verticalPadding: 8),
                    ),
                  ),
      ),
    );
  }

  showUserDetails(NonSIPInvestorsPojo data) {
    String aum = Utils.formatNumber(data.aumAmount, isAmount: true);
    num type_id = data.typeId ?? 0;
    String name = data.invName ?? "null";
    String invType = "null";
    if (type_id == 1) invType = "Individual";
    if (type_id == 3) invType = "Family";

    String? rmname = "";
    String? subBrokerName = "";
    if(client_name == 'nextfreedom'){
      rmname = data.invSubBrokerName;
      subBrokerName = data.invRmName;
      print("rmname- $rmname");
      print("subBrokerName- $subBrokerName");
    }else{
      rmname = data.invRmName;
      subBrokerName = data.invSubBrokerName;
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, bottomState) {
          return Container(
            height: devHeight * 0.55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BottomSheetTitle(title: ""),
                  ListTile(
                    leading: InitialCard(title: name[0]),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text("${data.invName}",
                              maxLines: 3,
                              style: AppFonts.f50014Black,
                              softWrap: true),
                        ),
                        Text(
                          "$rupee ${Utils.formatNumber(data.aumAmount)}",
                          style: AppFonts.f50014Black,
                        ),
                      ],
                    ),
                    subtitle: Text(invType),
                  ),
                  infoRow(
                      lHead: "PAN",
                      lSubHead: "${data.invPan}",
                      rHead: "Mobile",
                      rSubHead: "${data.invMobile}",
                      rStyle: AppFonts.f50014Theme
                          .copyWith(decoration: TextDecoration.underline)),
                  infoRow(
                      lHead: "Email",
                      lSubHead: "${data.invEmail}",
                      lStyle: AppFonts.f50014Theme.copyWith(
                          color: Config.appTheme.themeColor,
                          decoration: TextDecoration.underline)),
                  // infoRow(lHead: "Address", lSubHead: "${userData['inv_city']}"),
                  /*Divider(),
                  infoRow(
                      lHead: "Birthday",
                      lSubHead: "${userData['dob']}",
                      rHead: "Created On",
                      rSubHead: "${userData['created_date']}"),*/
                  Divider(),
                  infoRow(lHead: "Branch", lSubHead: "${data.invBranch}"),
                  infoRow(
                      lHead: "RM",
                      lSubHead: "$rmname",
                      rHead: (client_name != 'nextfreedom') ? "Associate" : "BM Name",
                      rSubHead: "$subBrokerName"),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        RectButton(
                            leading: "assets/bulletList.png",
                            imgSize: 20,
                            title: "View Dashboard",
                            fgColor: Colors.white,
                            onPressed: () async {
                              if (data.typeId == 1)
                                await loginAsInvestor(data);
                              else if (data.typeId == 3)
                                await loginAsFamily(data);
                              else
                                Utils.showError(context, "Unknown type id");
                            },
                            trailing:
                                Icon(Icons.arrow_forward, color: Colors.white),
                            bgColor: Config.appTheme.themeColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> loginAsInvestor(NonSIPInvestorsPojo userData) async {
    await GetStorage().write("adminAsInvestor", userData.userId);
    await GetStorage().write("user_id", userData.userId);
    await GetStorage().write("user_name", userData.invName);
    await GetStorage().write("user_pan", userData.invPan);
    await GetStorage().write("user_mobile", userData.invMobile);
    await GetStorage().write('user_email', userData.invEmail);

    Get.offAll(() => CheckUserType());
  }

  Future<void> loginAsFamily(NonSIPInvestorsPojo familyHead) async {
    await GetStorage().write("adminAsFamily", familyHead.userId);
    await GetStorage().write("family_id", familyHead.userId);
    await GetStorage().write("family_name", familyHead.invName);
    await GetStorage().write("family_pan", familyHead.invPan);
    await GetStorage().write("family_mobile", familyHead.invMobile);

    Get.offAll(() => CheckUserType());
  }

  Map filterValues = {
    "Sort By": ["Alphabet A-Z", "Alphabet Z-A", "AUM-ASC", "AUM-DESC"],
    'Branch': [],
    'RM': [],
    'Sub Broker': [],
  };
  String selectedLeft = "Sort By";

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
                          padding: EdgeInsets.symmetric(vertical: 8),
                          onPressed: () async {
                            Get.back();
                            selectedBranch = [];
                            selectedRm = [];
                            selectedSubBroker = [];
                            EasyLoading.show();
                            await getNonSipDetails();
                            EasyLoading.dismiss();
                            setState(() {});
                          },
                        )),
                        SizedBox(width: 16),
                        Expanded(
                          child: RpFilledButton(
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

  Future<void> refreshPage() async {
    EasyLoading.show();
    await getNonSipDetails();
    EasyLoading.dismiss();
    scrollController.position.jumpTo(0);
    setState(() {});
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
    if (selectedLeft == 'Sort By') return sortView(bottomState);
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

  Widget sortView(var bottomState) {
    List sortList = filterValues['Sort By'];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: sortList.length,
      itemBuilder: (context, index) {
        String title = sortList[index];

        return InkWell(
          onTap: () {
            selectedSort = title;
            bottomState(() {});
          },
          child: Row(
            children: [
              Radio(
                value: title,
                activeColor: Config.appTheme.themeColor,
                onChanged: (val) {
                  selectedSort = title;
                  bottomState(() {});
                },
                groupValue: selectedSort,
              ),
              Flexible(child: Text(title)),
            ],
          ),
        );
      },
    );
  }

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

  sortBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
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
            height: devHeight * 0.40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BottomSheetTitle(title: " Sort By"),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: sortOptions.length,
                      itemBuilder: (context, index) {
                        String option = sortOptions[index];

                        return InkWell(
                          onTap: () async {
                            selectedSort = option;
                            selectedSortValue = selectedSort;

                            page_id = 1;
                            print("selectedSort $selectedSort");
                            EasyLoading.show();
                            investorList = [];
                            await getNonSipDetails();
                            setState(() {});
                            bottomState(() {});
                            EasyLoading.dismiss();
                            Get.back();
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: option,
                                groupValue: selectedSort,
                                onChanged: (value) async {
                                  selectedSort = option;
                                  selectedSortValue = selectedSort;
                                  EasyLoading.show();
                                  investorList = [];
                                  await getNonSipDetails();
                                  setState(() {});
                                  bottomState(() {});
                                  EasyLoading.dismiss();
                                  Get.back();
                                },
                              ),
                              Text(option),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget button(String text,
      {Color bgColor = Colors.white, Color? fgColor, Function()? onTap}) {
    fgColor ??= Config.appTheme.themeColor;
    return Container(
      decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: Config.appTheme.themeColor, width: 1.5),
          borderRadius: BorderRadius.circular(10)),
      width: devWidth * 0.45,
      height: 45,
      child: InkWell(
        onTap: onTap,
        child: Center(
            child: Text(text,
                style: AppFonts.f40016.copyWith(color: fgColor, fontSize: 14))),
      ),
    );
  }

  Widget infoRow({
    required String lHead,
    required String lSubHead,
    TextStyle? lStyle,
    String rHead = "",
    String rSubHead = "",
    TextStyle? rStyle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lHead),
              Text(lSubHead, style: lStyle ?? AppFonts.f50014Black),
            ],
          )),
          Visibility(
            visible: rHead.isNotEmpty,
            child: Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rHead),
                Text(rSubHead, style: rStyle ?? AppFonts.f50014Black),
              ],
            )),
          ),
        ],
      ),
    );
  }

  Future<void> rpDownloadFile(
      {required String url, required BuildContext context}) async {
    Dio dio = Dio();
    String dirloc = "";

    if (Platform.isIOS) {
      if (await Permission.storage.request().isGranted)
        dirloc = (await getTemporaryDirectory()).path;
      else
        showError();
    }
    // android
    else if (Platform.isAndroid) {
      if (await Permission.storage
          .request()
          .isGranted) // Request storage permission instead of photos permission
        dirloc = (await getExternalStorageDirectory())?.path ?? "";
      else
        showError();
    }
    print("Url == $url");
    /* Fluttertoast.showToast(
        msg: url,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Config.appTheme.themeColor,
        textColor: Colors.white,
        fontSize: 16.0);*/
    try {
      final dir = await getExternalStorageDirectory();
      final filename = url.substring(url.lastIndexOf("/") + 1);
      final filePath = '${dir!.path}/$filename';
      final dio = Dio();
      await dio.download(url, filePath);
      final _result = await OpenFile.open(filePath);
      Fluttertoast.showToast(
          msg: _result.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Config.appTheme.themeColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      print('Error opening PDF: $e');
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
