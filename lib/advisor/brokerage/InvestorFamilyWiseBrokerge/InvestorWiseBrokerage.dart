import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class InvestorWiseBrokerage extends StatefulWidget {
  const InvestorWiseBrokerage({super.key, required this.selectedMonth});
  final String selectedMonth;

  @override
  State<InvestorWiseBrokerage> createState() => _InvestorWiseBrokerageState();
}

class _InvestorWiseBrokerageState extends State<InvestorWiseBrokerage> {
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
    Map data = await BrokerageApi.getInvestorWiseBrokerage(
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

    print("getting more investor with page id = $page_id");
    isLoading = true;
    EasyLoading.show();
    Map data = await BrokerageApi.getInvestorWiseBrokerage(
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
    Map data = await BrokerageApi.getInvestorWiseBrokerage(
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

  Future getInvestorBrokerageDetails(int userId) async {
    Map data = await BrokerageApi.getInvestorBrokerageDetails(
      login_user_id: mfd_id,
      client_name: client_name,
      month: selectedMonth,
      user_id: userId,
      type: "Investor",
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    Map result = data['result'][0];

    return result;
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
      EasyLoading.show(status: "Searching for `$val`");
      await searchInvestors();
      EasyLoading.dismiss();
      setState(() {});
    });
  }

  late double devWidth, devHeight;
  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return  Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: SearchField(
                    hintText: "Search Investor",
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

   /* if (isLoading) {
      return Utils.shimmerWidget(devHeight * 0.6,
          margin: EdgeInsets.fromLTRB(16, 16, 16, 16));
    } else {*/
      return Expanded(
        child: SingleChildScrollView(
          controller: scrollController,
          child: (isLoading)
              ? Utils.shimmerWidget(devHeight)
              : ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              Map map = list[index];

              int user_id = map['user_id'];
              String name = map['investor_name'] ?? "null";
              num amount = map['brokerage_amount'].round() ?? "null";

              return InkWell(
                splashColor: Colors.white,
                onTap: () async {
                  EasyLoading.show();
                  Map invData = await getInvestorBrokerageDetails(user_id);
                  EasyLoading.dismiss();
                  investorBottomSheet(invData);
                },
                child: RpListTile2(
                    leading: InitialCard(title: name),
                    l1: name,
                    l2: "",
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

  investorBottomSheet(Map data) {
    String name = data['name'];
    num amount = data['brokerage_amount'];
    List schemeList = data['scheme_list'];

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
                    BottomSheetTitle(
                        title: "", padding: EdgeInsets.fromLTRB(16, 16, 16, 0)),
                    Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        collapsedBackgroundColor: Colors.white,
                        backgroundColor: Colors.white,
                        tilePadding: EdgeInsets.symmetric(horizontal: 16),
                        title: Row(
                          children: [
                            InitialCard(title: name),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                name,
                                style: AppFonts.f50014Black,
                              ),
                            ),
                            SizedBox(width: 10),
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
                        childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                  child: ColumnText(
                                      title: "PAN", value: "${data['pan']}")),
                              Expanded(
                                  child: ColumnText(
                                title: "Mobile",
                                value: "${data['mobile']}",
                                valueStyle: AppFonts.f50014Theme.copyWith(
                                    decoration: TextDecoration.underline),
                              )),
                            ],
                          ),
                          SizedBox(height: 16),
                          ColumnText(
                            title: "Email",
                            value: "${data['email']}",
                            valueStyle: AppFonts.f50014Theme
                                .copyWith(decoration: TextDecoration.underline),
                          ),
                          DottedLine(verticalPadding: 8),
                          ColumnText(
                            title: "Branch",
                            value: "${data['branch']}",
                          ),
                          ColumnText(
                            title: "RM",
                            value: "${data['rm_name']}",
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Brokerage",
                              style: AppFonts.f50014Black,
                            ),
                            Text("$rupee ${Utils.formatNumber(amount)}",
                                style: AppFonts.f50014Black),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    schemeListArea(schemeList),
                    SizedBox(height: 16),
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
