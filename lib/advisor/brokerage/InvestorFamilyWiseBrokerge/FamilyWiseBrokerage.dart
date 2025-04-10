import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/BrokerageApi.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile2.dart';
import 'package:mymfbox2_0/rp_widgets/SearchField.dart';
import 'package:mymfbox2_0/rp_widgets/ShowBrokerageMonths.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class FamilyWiseBrokerage extends StatefulWidget {
  const FamilyWiseBrokerage({super.key, required this.selectedMonth});
  final String selectedMonth;

  @override
  State<FamilyWiseBrokerage> createState() => _FamilyWiseBrokerageState();
}

class _FamilyWiseBrokerageState extends State<FamilyWiseBrokerage> {
  int mfd_id = getUserId();
  String client_name = GetStorage().read("client_name");

  bool getInitial = true;
  int page_id = 1;

  List brokerageMonthList = [];
  Future getBrokerageMonthList() async {
    if (brokerageMonthList.isNotEmpty) return 0;

    Map data = await BrokerageApi.getBrokerageMonthList(
        user_id: mfd_id, client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    brokerageMonthList = data['result'];

    return 0;
  }

  List investorList = [];
  num totalCount = 0;
  Future getInitialInvestors() async {
    if (!getInitial) return 0;
    Map data = await BrokerageApi.getFamilyWiseBrokerage(
        user_id: mfd_id,
        client_name: client_name,
        month: selectedMonth,
        page_id: page_id);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    totalCount = data['total_count'];
    investorList = data['result'];
    getInitial = false;

    return 0;
  }

  bool isLoading = false;
  Future getMoreInvestors() async {
    page_id++;
    if (investorList.length == totalCount) return 0;

    print("getting more investor with page id = $page_id");
    isLoading = true;
    EasyLoading.show();
    Map data = await BrokerageApi.getFamilyWiseBrokerage(
        user_id: mfd_id,
        client_name: client_name,
        month: selectedMonth,
        page_id: page_id);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    List list = data['result'];
    investorList.addAll(list);
    isLoading = false;
    EasyLoading.dismiss();
    setState(() {});

    return 0;
  }

  String serarchKey = "";
  List searchResult = [];
  Future searchInvestors() async {
    Map data = await BrokerageApi.getFamilyWiseBrokerage(
      user_id: mfd_id,
      client_name: client_name,
      month: selectedMonth,
      page_id: page_id,
      search: serarchKey,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    searchResult = data['result'];
    setState(() {});

    return 0;
  }

  Future getDatas() async {
    isLoading = true;
    await getBrokerageMonthList();
    await getInitialInvestors();
    isLoading = false;
    return 0;
  }

  ScrollController scrollController = ScrollController();
  void scrollListener() async {
    bool atEdge = scrollController.position.atEdge;
    double extentAfter = scrollController.position.extentAfter;

    if (extentAfter < 100 && !isLoading) await getMoreInvestors();
  }

  @override
  void initState() {
    //  implement initState
    super.initState();
    scrollController.addListener(scrollListener);
    selectedMonth = widget.selectedMonth;
  }

  Timer? searchOnStop;

  searchHandler(String val) {
    serarchKey = val;
    const duration = Duration(milliseconds: 1000);
    if (searchOnStop != null) {
      searchOnStop!.cancel();
    }

    searchOnStop = Timer(duration, () async {
      await searchInvestors();
    });
  }

  Future getInvestorBrokerageDetails(int userId) async {
    Map data = await BrokerageApi.getInvestorBrokerageDetails(
      login_user_id: mfd_id,
      client_name: client_name,
      month: selectedMonth,
      user_id: userId,
      type: "Family",
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    List result = data['result'];

    return result;
  }

  late double devWidth, devHeight;
  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: SearchField(
                  hintText: "Search Family",
                  onChange: searchHandler,
                ),
              ),
              countLine(),
              listArea()
            ],
          );
        });
  }

  String selectedMonth = "";
  Widget countLine() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${Utils.formatNumber(totalCount)} Items",
            style: AppFonts.f40013,
          ),
          SortButton(
            title: " $selectedMonth",
            onTap: () {
              showBrokerageMonths(
                context,
                groupValue: selectedMonth,
                monthList: brokerageMonthList,
                onChanged: (val) async {
                  selectedMonth = val ?? "";
                  Get.back();
                  EasyLoading.show();
                  getInitial = true;
                  page_id = 1;

                  await getInitialInvestors();
                  setState(() {});

                  EasyLoading.dismiss();
                },
              );
            },
          )
        ],
      ),
    );
  }

  Widget listArea() {
    List list = (serarchKey.isEmpty) ? investorList : searchResult;
    /*if (isLoading) {
      return Utils.shimmerWidget(devHeight * 0.6,
          margin: EdgeInsets.fromLTRB(16, 16, 16, 16));
    } else {*/
      return Expanded(
        child: SingleChildScrollView(
          controller: scrollController,
          child: (isLoading)
              ? Utils.shimmerWidget(devHeight)
              :  ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              Map map = list[index];

              int user_id = map['user_id'];
              String name = map['inv_name'] ?? "null";
              num amount = map['brokerage_amount'].round() ?? "null";
              int count = map['member_count'];

              return InkWell(
                splashColor: Colors.white,
                onTap: () async {
                  EasyLoading.show();
                  List memberList = await getInvestorBrokerageDetails(user_id);
                  EasyLoading.dismiss();
                  familyBottomSheet(
                      memberList: memberList, headName: name, amount: amount);
                },
                child: RpListTile2(
                    leading: InitialCard(title: name),
                    l1: name,
                    l2: "$count Members",
                    r1: Utils.formatNumber(amount, isAmount: true),
                    r2: ""),
              );
            },
            separatorBuilder: (BuildContext context, int index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DottedLine(),
            ),
          ),
        ),
      );
  }

  familyBottomSheet(
      {required List memberList,
      required String headName,
      required num amount}) {
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
                height: devHeight * 0.8,
                child: Column(
                  children: [
                    BottomSheetTitle(title: ""),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Row(
                        children: [
                          InitialCard(title: headName),
                          SizedBox(width: 10),
                          Expanded(
                            child: ColumnText(
                              title: headName,
                              value: "${memberList.length} Members",
                              titleStyle: AppFonts.f50014Black,
                              valueStyle: AppFonts.f40013,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            children: [
                              Text("$rupee ${Utils.formatNumber(amount)}",
                                  style: AppFonts.f50014Black),
                              Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: Color(0xffDAF8F9),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Text(
                                  " $selectedMonth ",
                                  style: AppFonts.f50012.copyWith(fontSize: 12),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: memberList.length,
                        itemBuilder: (context, index) {
                          Map member = memberList[index];
                          String name = member['name'];
                          num amount = member['brokerage_amount'];
                          String relation = member['relation'] ?? "";
                          List schemeList = member['scheme_list'];

                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                collapsedIconColor: Config
                                    .appTheme.placeHolderInputTitleAndArrow,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                tilePadding: EdgeInsets.only(right: 16),
                                title: RpListTile2(
                                    padding: EdgeInsets.fromLTRB(16, 8, 0, 8),
                                    hasArrow: false,
                                    leading: InitialCard(title: name),
                                    l1: name,
                                    l2: relation,
                                    gap: 0,
                                    r1: "$rupee ${Utils.formatNumber(amount)}",
                                    r2: ""),
                                children: [
                                  SizedBox(
                                    height: schemeList.length * 60,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: schemeList.length,
                                      itemBuilder: (context, index) {
                                        Map data = schemeList[index];
                                        String name = data["amc_name"] ?? "";
                                        num amount = data["brokerage_amount"];
                                        String logo = data["logo"];

                                        return RpListTile2(
                                          leading: Image.network(logo,
                                              width: setImageSize(30)),
                                          l1: name,
                                          l2: "",
                                          r1: "$rupee ${Utils.formatNumber(amount)}",
                                          r2: "",
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          hasArrow: false,
                                          gap: 16,
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: DottedLine(verticalPadding: 8),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(height: 16),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  Widget schemeListArea(List list) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: ListView.separated(
          shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            Map data = list[index];
            String name = data["amc_name"] ?? "";
            num amount = data["brokerage_amount"];
            String logo = data["logo"];

            return RpListTile2(
              leading: Image.network(logo, width: setImageSize(30)),
              l1: name,
              l2: "",
              r1: "$rupee ${Utils.formatNumber(amount)}",
              r2: "",
              padding: EdgeInsets.zero,
              hasArrow: false,
              gap: 16,
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              DottedLine(verticalPadding: 5),
        ),
      ),
    );
  }
}
