import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import '../../api/Api.dart';
import '../../pojo/OnlineTransactionRestrictionPojo.dart';
import '../../rp_widgets/BottomSheetTitle.dart';
import '../../rp_widgets/ColumnText.dart';
import '../../rp_widgets/DottedLine.dart';
import '../../rp_widgets/PlainButton.dart';
import '../../rp_widgets/SearchField.dart';
import '../../utils/AppFonts.dart';
import '../../utils/Config.dart';
import '../../utils/Constants.dart';
import '../../utils/Utils.dart';

class TransactionRestriction extends StatefulWidget {
  const TransactionRestriction({super.key});

  @override
  State<TransactionRestriction> createState() => _TransactionRestrictionState();
}

class _TransactionRestrictionState extends State<TransactionRestriction> {
  int user_id = GetStorage().read("mfd_id");
  String client_name = GetStorage().read("client_name");
  String mobile = GetStorage().read('mfd_mobile');
  int type_id = GetStorage().read("type_id");

  List branchList = [];
  List rmList = [];
  List subBrokerList = [];

  num total_count = 0;

  bool isFirst = true;

  @override
  void initState() {
    //  implement initState
    super.initState();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    //  implement dispose
    scrollController.removeListener(scrollListener);
    super.dispose();
  }

  Future getDatas() async {
    await getAllBranch();
    await getAllRM();
    await getAllSubBroker();
    await getAllOnlineRestrictions();
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
    EasyLoading.show();
    Map data = await AdminApi.getAllOnlineRestrictions(
        user_id: user_id,
        client_name: client_name,
        branch: selectedBranch.join(","),
        rm_name: selectedRm.join(","),
        subbroker_name: selectedSubBroker.join(","),
        page_id: page_id,
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
    EasyLoading.dismiss();
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
        search: searchKey,
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
          backgroundColor: Config.appTheme.mainBgColor,
          appBar: invAppBar(
              title: "Online Transaction Restrictions",
              showCartIcon: false,
              showNotiIcon: false,
              actions: [
                if(type_id == UserType.ADMIN)
                GestureDetector(
                    onTap: () {
                      sortFilter();
                    },
                    child: Icon(Icons.filter_alt_outlined)),
              ]),
          // appBar: AppBar(
          //   backgroundColor: Config.appTheme.themeColor,
          //   leadingWidth: 0,
          //   toolbarHeight: 80,
          //   foregroundColor: Colors.white,
          //   elevation: 0,
          //   leading: SizedBox(),
          //   title: Column(
          //     children: [
          //       Row(
          //         children: [
          //           GestureDetector(
          //             child: Icon(Icons.arrow_back),
          //             onTap: () {
          //               Get.back();
          //             },
          //           ),
          //           SizedBox(width: 5),
          //           Text(
          //             "Online Transaction Restrictions",
          //             style: AppFonts.f50014Black
          //                 .copyWith(fontSize: 18, color: Colors.white),
          //           ),
          //           Spacer(),
          //           GestureDetector(
          //               onTap: () {
          //                 //sortLine();
          //                 sortFilter();
          //               },
          //               child: Icon(Icons.filter_alt_outlined)),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
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
                      padding: EdgeInsets.symmetric(horizontal: 8),
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
    return Container(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.white),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Container(
                margin: EdgeInsets.only(right: 10),
                child: InkWell(
                    onTap: (){
                      showBottomSheet(userData);
                      setState(() {});
                    },
                    child: Icon(Icons.more_vert)),
              ),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
            child: Text(
              "PAN - $pan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    Expanded(
                      child: ColumnText(
                        title: "Branch",
                        value: "${userData.branch}",
                        alignment: CrossAxisAlignment.start,
                      ),
                    ),
                    Expanded(
                      child: ColumnText(
                        title: "RM",
                        value: "${userData.rmName}",
                        alignment: CrossAxisAlignment.start,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColumnText(
                      title: "Associate",
                      value: "${userData.subbrokerName} ",
                      alignment: CrossAxisAlignment.start,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _purchaseAllowed = false;
  bool _redeemAllowed = false;
  bool _switchAllowed = false;
  bool _stpAllowed = false;
  bool _swpAllowed = false;

  void initializeCheckBoxValues(OnlineTransactionRestrictionPojo userData) {
    _purchaseAllowed = userData.purchaseAllowed == 1;
    _redeemAllowed = userData.redeemAllowed == 1;
    _switchAllowed = userData.switchAllowed == 1;
    _stpAllowed = userData.stpAllowed == 1;
    _swpAllowed = userData.swpAllowed == 1;
  }

  void showBottomSheet(OnlineTransactionRestrictionPojo userData) {
    // Initialize checkbox values only if not set yet, to avoid resetting them
    if (_purchaseAllowed == false &&
        _redeemAllowed == false &&
        _switchAllowed == false &&
        _stpAllowed == false &&
        _swpAllowed == false) {
      initializeCheckBoxValues(userData);
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(8),
              child: Wrap(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("",
                            style: AppFonts.f40016
                                .copyWith(fontWeight: FontWeight.w500)),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      CheckboxListTile(
                        title: Text("Purchase"),
                        value: _purchaseAllowed,
                        onChanged: (bool? value) async {
                          setState(() {
                            _purchaseAllowed = value ?? false;
                          });
                          setState(() {});
                          await updateOnlineRestrictionsByUserId(
                              purchaseUpdate: _purchaseAllowed ? 1 : 0,
                              user_id: userData.userId);
                          Get.back();
                        },
                      ),
                      CheckboxListTile(
                        title: Text("Redeem"),
                        value: _redeemAllowed,
                        onChanged: (bool? value) async {
                          setState(() {
                            _redeemAllowed = value ?? false;
                          });
                          setState(() {}); // Update parent state
                          await updateOnlineRestrictionsByUserId(
                              redeemUpdate: _redeemAllowed ? 1 : 0,
                              user_id: userData.userId);
                          Get.back();
                          ;
                        },
                      ),
                      CheckboxListTile(
                        title: Text("Switch"),
                        value: _switchAllowed,
                        onChanged: (bool? value) async {
                          setState(() {
                            _switchAllowed = value ?? false;
                          });
                          setState(() {}); // Update parent state
                          await updateOnlineRestrictionsByUserId(
                              switchUpdate: _switchAllowed ? 1 : 0,
                              user_id: userData.userId);
                          Get.back();
                        },
                      ),
                      CheckboxListTile(
                        title: Text("STP"),
                        value: _stpAllowed,
                        onChanged: (bool? value) async {
                          setState(() {
                            _stpAllowed = value ?? false;
                          });
                          setState(() {}); // Update parent state
                          await updateOnlineRestrictionsByUserId(
                              stpUpdate: _stpAllowed ? 1 : 0,
                              user_id: userData.userId);
                          Get.back();
                        },
                      ),
                      CheckboxListTile(
                        title: Text("SWP"),
                        value: _swpAllowed,
                        onChanged: (bool? value) async {
                          setState(() {
                            _swpAllowed = value ?? false;
                          });
                          setState(() {}); // Update parent state
                          await updateOnlineRestrictionsByUserId(
                              swpUpdate: _swpAllowed ? 1 : 0,
                              user_id: userData.userId);
                          Get.back();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
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
