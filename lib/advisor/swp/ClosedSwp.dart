import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/pojo/sip/AmcWiseSipPojo.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpFilterChip.dart';
import 'package:mymfbox2_0/rp_widgets/SearchField.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class ClosedSwp extends StatefulWidget {
  const ClosedSwp({
    super.key,
    required this.amcList,
    required this.subBrokerList,
    required this.rmList,
    required this.branchList,
    required this.arnList,
  });

  final List amcList, subBrokerList, rmList, branchList, arnList;

  @override
  State<ClosedSwp> createState() => _ClosedSwpState();
}

class _ClosedSwpState extends State<ClosedSwp> {
  int user_id = GetStorage().read("mfd_id");
  String client_name = GetStorage().read("client_name");
  int type_id = GetStorage().read('type_id');
  bool isLoading = true;
  int page_id = 1;

  String searchKey = "";

  num totalCount = 0;
  List investorList = [];
  Future getInitialInvestors() async {
    page_id = 1;

    Map data = await AdminApi.getClosedSwpReport(
      user_id: user_id,
      client_name: client_name,
      sip_date: "",
      amc_name: selectedAMC.join(","),
      start_date: "",
      end_date: "",
      broker_code: selectedArn,
      page_id: page_id,
      search: searchKey,
      branch: selectedBranch.join(","),
      rm_name: selectedRm.join(","),
      sub_broker_name: selectedSubBroker.join(","),
      sort_by: (selectedSort.contains("SWP")) ? "SWP" : selectedSort,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    totalCount = data['total_count'] ?? 0;
    investorList = data['list'];
    isLoading = false;

    return 0;
  }

  Future getMoreInvestors() async {
    page_id++;

    print("getting more investor with page id = $page_id");
    isLoading = true;
    EasyLoading.show();

    Map data = await AdminApi.getClosedSwpReport(
      user_id: user_id,
      client_name: client_name,
      sip_date: "",
      amc_name: selectedAMC.join(","),
      start_date: "",
      end_date: "",
      broker_code: selectedArn,
      page_id: page_id,
      search: searchKey,
      branch: selectedBranch.join(","),
      rm_name: selectedRm.join(","),
      sub_broker_name: selectedSubBroker.join(","),
      sort_by: (selectedSort.contains("SWP")) ? "SWP" : selectedSort,
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

  ScrollController scrollController = ScrollController();
  Future scrollListener() async {
    bool atBottom = scrollController.position.extentAfter < 100;
    bool fullyLoaded = investorList.length == totalCount;

    bool fetchAgain = atBottom && !fullyLoaded && !isLoading;

    if (fetchAgain) await getMoreInvestors();
  }

  bool isFirst = true;
  Future getDatas() async {
    if (!isFirst) return 0;

    await getInitialInvestors();

    isFirst = false;
    return 0;
  }

  @override
  void initState() {
    //  implement initState
    super.initState();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    //  implement dispose
    scrollController.removeListener(() {});
    super.dispose();
  }

  Timer? searchOnStop;

  searchHandler(String search) {
    searchKey = search;
    const duration = Duration(milliseconds: 1000);
    if (searchOnStop != null) {
      searchOnStop!.cancel();
    }

    searchOnStop = Timer(duration, () async {
      EasyLoading.show(status: "Searching for `$searchKey`");
      await getInitialInvestors();
      EasyLoading.dismiss();
      setState(() {});
    });
  }

  late double devHeight, devWidth;
  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Column(
            children: [
              if (type_id == UserType.ADMIN)
              sortLine(),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: SearchField(
                  hintText: "Search",
                  onChange: searchHandler,
                ),
              ),
              countLine(),
              listArea(),
            ],
          );
        });
  }

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
                sortFilter();
              },
            ),
            SizedBox(width: 16),
            RpFilterChip(
              selectedSort: selectedSort,
              hasClose: false,
            ),
            if (selectedArn != "All")
              RpFilterChip(
                selectedSort: selectedArn,
                onClose: () async {
                  selectedArn = "All";
                  EasyLoading.show();
                  await getInitialInvestors();
                  EasyLoading.dismiss();
                  setState(() {});
                },
              ),
            multipleFilterChip(selectedBranch),
            multipleFilterChip(selectedRm),
            multipleFilterChip(selectedSubBroker),
            multipleFilterChip(selectedAMC),
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
                  await getInitialInvestors();
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
                itemCount: investorList.length + 1,
                itemBuilder: (context, index) {
                  if (index == investorList.length) return SizedBox(height: 16);

                  Map<String, dynamic> data = investorList[index];
                  ActiveSwpPojo swp = ActiveSwpPojo.fromJson(data);

                  return swpTile(swp);
                },
                separatorBuilder: (BuildContext context, int index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: DottedLine(verticalPadding: 8),
                ),
              ),
      ),
    );
  }

  Widget swpTile(ActiveSwpPojo swp) {
    String name = swp.schemeAmfiShortName ?? "";
    if (name.isEmpty) name = swp.scheme ?? "null";

    return GestureDetector(
      onTap: () {
        swpBottomSheet(swp);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ColumnText(
                    title: Utils.getFirst13(swp.invName, count: 20),
                    value: "Folio: ${swp.folioNo}",
                    alignment: CrossAxisAlignment.start,
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013,
                  ),
                ),
                ColumnText(
                    title: "$rupee ${Utils.formatNumber(swp.amount)}",
                    value: "",//"{date} {frequency}",
                    alignment: CrossAxisAlignment.end,
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013),
                SizedBox(width: 5),
                Icon(Icons.arrow_forward_ios,
                    size: 15,
                    color: Config.appTheme.placeHolderInputTitleAndArrow),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                //Image.network("${swp.schemeLogo}", height: setImageSize(30)),
                Utils.getImage("${swp.schemeLogo}", setImageSize(30)),
                SizedBox(width: 10),
                Flexible(
                  child: Text(name,
                      style: AppFonts.f50014Black
                          .copyWith(color: Config.appTheme.themeColor)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  swpBottomSheet(ActiveSwpPojo swp) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: cornerBorder),
        builder: (context) {
          return StatefulBuilder(
            builder: (context, bottomState) {
              return Container(
                height: devHeight * 0.65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: cornerBorder,
                ),
                child: Column(
                  children: [
                    BottomSheetTitle(title: ""),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ColumnText(
                                  title:
                                      Utils.getFirst13(swp.invName, count: 17),
                                  value: "Folio: ${swp.folioNo}",
                                  alignment: CrossAxisAlignment.start,
                                  titleStyle: AppFonts.f50014Black,
                                  valueStyle: AppFonts.f40013,
                                ),
                                ColumnText(
                                  title:
                                      "$rupee ${Utils.formatNumber(swp.amount)}",
                                  value:"",//"{sip.autoDebitDate} {sip.frequency}",
                                  alignment: CrossAxisAlignment.end,
                                  titleStyle: AppFonts.f50014Black,

                                  valueStyle: AppFonts.f40013,
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                //Image.network("${swp.schemeLogo}", height: setImageSize(30)),
                                Utils.getImage(
                                    "${swp.schemeLogo}", setImageSize(30)),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "${swp.schemeAmfiShortName}",
                                    style: AppFonts.f50014Theme,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            rpRow(
                              lhead: "Start Date",
                              lSubHead: "${swp.startDate}",
                              rhead: "End Date",
                              rSubHead: "${swp.endDate}",
                            ),
                            DottedLine(verticalPadding: 8),
                            ColumnText(
                              title: "Branch",
                              value: "${swp.userBranch}",
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ColumnText(
                                    title: "RM",
                                    value: "${swp.rmName}",
                                  ),
                                ),
                                Expanded(
                                  child: ColumnText(
                                    title: "Associate",
                                    value: "${swp.subbrokerName}",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                          ],
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

  Map filterValues = {
    "Sort By": ["Alphabet", "SWP Amount"],
    'Branch': [],
    'RM': [],
    'Sub Broker': [],
    //'AMC': [],
    // 'ARN': [],
  };
  String selectedLeft = "Sort By";
  String selectedSort = "Alphabet";

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
                              color: Config.appTheme.buttonColor,
                          onPressed: () async {
                            Get.back();
                            selectedBranch = [];
                            selectedRm = [];
                            selectedSubBroker = [];
                            selectedAMC = [];
                            EasyLoading.show();
                            await getInitialInvestors();
                            EasyLoading.dismiss();
                            setState(() {});
                          },
                        )),
                        SizedBox(width: 16),
                        Expanded(
                          child: RpFilledButton(
                            text: "APPLY",
                            color: Config.appTheme.buttonColor,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            onPressed: () async {
                              Get.back();

                              EasyLoading.show();
                              await getInitialInvestors();
                              EasyLoading.dismiss();

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
        });
      },
    );
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
    if (selectedLeft == 'AMC') return amcView(bottomState);
    if (selectedLeft == 'ARN') return arnView(bottomState);

    return Text("Invalid Left");
  }

  Widget rpLeftSelectedBtn({required String title}) {
    bool hasDot = false;
    if (title == 'Branch') hasDot = selectedBranch.isNotEmpty;
    if (title == 'RM') hasDot = selectedRm.isNotEmpty;
    if (title == 'Sub Broker') hasDot = selectedSubBroker.isNotEmpty;
    if (title == 'AMC') hasDot = selectedAMC.isNotEmpty;
    if (title == 'ARN') hasDot = selectedArn != "All";

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
    if (title == 'AMC') hasDot = selectedAMC.isNotEmpty;
    if (title == 'ARN') hasDot = selectedArn != "All";

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

  List selectedBranch = [];
  Widget branchView(var bottomState) {
    List branchList = widget.branchList;

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

  List selectedRm = [];
  Widget rmView(var bottomState) {
    List rmList = widget.rmList;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: rmList.length,
      itemBuilder: (context, index) {
        String title = rmList[index];
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
    List subBrokerList = widget.subBrokerList;

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

  List selectedAMC = [];
  Widget amcView(var bottomState) {
    List amcList = widget.amcList;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: amcList.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> data = amcList[index];
        AmcWiseSipPojo amcPojo = AmcWiseSipPojo.fromJson(data);

        String title = "${amcPojo.amcName}";
        bool isContains = selectedAMC.contains(amcPojo.amcName);

        return InkWell(
          onTap: () async {
            if (isContains)
              selectedAMC.remove(title);
            else
              selectedAMC.add(title);
            bottomState(() {});
          },
          child: Row(
            children: [
              Checkbox(
                value: selectedAMC.contains(title),
                onChanged: (val) async {
                  if (isContains)
                    selectedAMC.remove(title);
                  else
                    selectedAMC.add(title);
                  bottomState(() {});
                },
              ),
              //Image.network("${amcPojo.amcLogo}", width: setImageSize(24)),
              Utils.getImage("${amcPojo.amcLogo}", setImageSize(24)),
              SizedBox(width: 10),
              Expanded(child: Text(title)),
            ],
          ),
        );
      },
    );
  }

  String selectedArn = "All";
  Widget arnView(var bottomState) {
    List list = widget.arnList;

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        String title = list[index];

        return InkWell(
          onTap: () {
            selectedArn = title;
            bottomState(() {});
          },
          child: Row(
            children: [
              Radio(
                  value: title,
                  groupValue: selectedArn,
                  onChanged: (val) {
                    selectedArn = title;
                    bottomState(() {});
                  }),
              Text(title),
            ],
          ),
        );
      },
    );
  }

  Widget rpRow({
    required String lhead,
    required String lSubHead,
    required String rhead,
    required String rSubHead,
  }) {
    return Row(
      children: [
        Expanded(child: ColumnText(title: lhead, value: lSubHead)),
        Expanded(child: ColumnText(title: rhead, value: rSubHead)),
      ],
    );
  }
}

class ActiveSwpPojo {
  String? userId;
  String? invName;
  String? pan;
  String? userBranch;
  String? rmName;
  String? subbrokerName;
  String? folioNo;
  String? scheme;
  String? schemeAmfiShortName;
  String? schemeLogo;
  String? lastTrxnDate;
  num? amount;
  String? finalAmount;
  String? prodcode;
  String? trxnno;
  String? startDate;
  String? endDate;

  ActiveSwpPojo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    invName = json['inv_name'];
    pan = json['pan'];
    userBranch = json['user_branch'];
    rmName = json['rm_name'];
    subbrokerName = json['subbroker_name'];
    folioNo = json['folio_no'];
    scheme = json['scheme'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeLogo = json['scheme_logo'];
    lastTrxnDate = json['last_trxn_date'];
    amount = json['amount'];
    finalAmount = json['final_amount'];
    prodcode = json['prodcode'];
    trxnno = json['trxnno'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }
}
