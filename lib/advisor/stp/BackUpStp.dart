import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/pojo/sip/ActiveStpPojo.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/rp_widgets/TransferCircle.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/rp_widgets/AmcChip.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/SelectedAmcChip.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class ActiveStp extends StatefulWidget {
  const ActiveStp({super.key});

  @override
  State<ActiveStp> createState() => _ActiveStpState();
}

class _ActiveStpState extends State<ActiveStp> {
  late double devHeight, devWidth;

  Map filterValues = {
    'Branch': [],
    'RM': [],
    'Sub Broker': [],
    'AMC': [],
  };
  final List buttonList = ["Active STPs", "Closed STPs"];
  ScrollController scrollController = ScrollController();
  bool isFirst = true;
  int page_id = 1;

  List<ActiveStpPojo> stpList = [];
  bool investorFetching = false;
  bool isLoading = true;

  String selectedLeft = "Branch";
  String selectedSort = "Alphabet A-Z";
  List selectedRM = [];

  String searchKey = "";

  int user_id = GetStorage().read("mfd_id") ?? 0;
  String client_name = GetStorage().read("client_name") ?? "null";
  String mobile = GetStorage().read("mfd_mobile") ?? "null";

  String branch = "", rm = "", subBroker = "";
  Future getAllBranch() async {
    if (filterValues['Branch'].isNotEmpty) return 0;
    Map data = await Api.getAllBranch(mobile: mobile, client_name: client_name);
    filterValues['Branch'] = data['list'];
    return 0;
  }

  Future getAllRM() async {
    if (filterValues['RM'].isNotEmpty) return 0;
    Map data = await Api.getAllRM(
        mobile: mobile, client_name: client_name, branch: "");
    filterValues['RM'] = data['list'];
    return 0;
  }

  Future getAllSubBroker() async {
    if (filterValues['Sub Broker'].isNotEmpty) return 0;
    Map data =
        await Api.getAllSubbroker(mobile: mobile, client_name: client_name);

    filterValues['Sub Broker'] = data['list'];
    return 0;
  }

  Future getAllAmc() async {
    if (filterValues['AMC'].isNotEmpty) return 0;

    try {
      String client_name = GetStorage().read("client_name");

      Map data = await Api.getAmcWiseSipDetails(
          user_id: user_id,
          client_name: client_name,
          maxCount: 'All',
          broker_code: 'All');
      if (data['status'] != 200) {
        Utils.showError(context, data['msg']);
        return 0;
      }
      List list = data['list'];
      List amcList = [];
      list.forEach((element) {
        amcList.add(element['amc_name']);
      });
      filterValues['AMC'] = amcList;
    } catch (e) {
      print("getAmcWiseSipDetails exception = $e");
    }
    return 0;
  }

  bool branchContainer = true;
  bool rmContainer = true;
  bool subBrokerContainer = true;
  bool amcContainer = true;
  TextStyle underlineText = TextStyle(
      color: Config.appTheme.themeColor,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w500,
      fontSize: 14);

  @override
  void initState() {
    //  implement initState
    super.initState();
    scrollController.addListener(scrollListener);
  }

  Future scrollListener() async {
    double extentAfter = scrollController.position.extentAfter;
    bool atEdge = scrollController.position.atEdge;

    if (extentAfter < 100 && atEdge && totalCount != stpList.length) {
      page_id++;
      await refreshStpList(merge: true);
    }
  }

  int totalCount = 0;

  Future getActiveStpDetails({bool merge = false}) async {
    if (!merge) stpList = [];
    EasyLoading.show();
    Map data = await AdminApi.getActiveStpReport(
        user_id: user_id,
        client_name: client_name,
        branch: branch,
        rm_name: rm,
        sub_broker_name: subBroker,
        start_date: "",
        end_date: "",
        broker_code: "",
        page_id: page_id,
        amc: amc,
        sort_by: " ",
        search: '');
    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      return 0;
    }
    totalCount = data['total_count'];
    List list = data['list'];
    convertListToObj(list);

    EasyLoading.dismiss();
    setState(() {});
    return 0;
  }

  Future getClosedStpDetails({bool merge = false}) async {
    if (!merge) {
      if (stpList.isNotEmpty) return 0;
    }

    EasyLoading.show();
    Map data = await AdminApi.getClosedStpReport(
        user_id: user_id,
        client_name: client_name,
        branch: branch,
        rm_name: rm,
        sub_broker_name: subBroker,
        start_date: "",
        end_date: "",
        broker_code: "",
        page_id: page_id,
        amc: amc,
        sort_by: " ",
        search: '');
    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      return 0;
    }
    totalCount = data['total_count'];
    List list = data['list'];
    convertListToObj(list);

    EasyLoading.dismiss();
    setState(() {});
    return 0;
  }

  convertListToObj(List list) {
    list.forEach((element) {
      stpList.add(ActiveStpPojo.fromJson(element));
    });

    EasyLoading.dismiss();
  }

  Future getDatas() async {
    if (!isFirst) return 0;

    await getAllBranch();
    await getAllRM();
    await getAllSubBroker();
    await getAllAmc();

    await getActiveStpDetails();

    print("filterValues = $filterValues");

    isFirst = false;
    isLoading = false;

    return 0;
  }

  @override
  void dispose() {
    //  implement dispose
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: adminAppBar(title: "STPs", bgColor: Colors.white),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chipArea(),
                sortLine(),
                countLine(),
                listArea(),
              ],
            ),
          );
        });
  }

  Widget listArea() {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        child: (isLoading)
            ? Utils.shimmerWidget(devHeight * 0.7)
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: stpList.length,
                itemBuilder: (context, index) {
                  ActiveStpPojo stp = stpList[index];
                  return stpTile(stp);
                },
              ),
      ),
    );
  }

  Widget sortLine() {
    return Container(
      height: 60,
      width: devWidth,
      color: Config.appTheme.mainBgColor,
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SortButton(onTap: () {
            showFilter();
          }),
        ],
      ),
    );
  }

  Widget countLine() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Visibility(
        visible: stpList.isNotEmpty,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${stpList.length} items",
              style: AppFonts.f40013,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSize appBar() {
    return PreferredSize(
      //preferredSize: Size(devWidth, 245),
      preferredSize: Size.fromHeight(185),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(12, 32, 12, 16),
            child: Column(
              children: [
                SizedBox(height: 16),
                Row(
                  children: [
                    GestureDetector(
                      child: Icon(Icons.arrow_back,
                          color: Config.appTheme.themeColor),
                      onTap: () {
                        Get.back();
                      },
                    ),
                    SizedBox(width: 10),
                    Text("STP", style: AppFonts.f40016.copyWith(fontSize: 18)),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          Container(
            width: devWidth,
            color: Config.appTheme.mainBgColor,
            padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showFilter();
                      },
                      child: Container(
                        width: 120,
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: Config.appTheme.themeColor)),
                        child: Row(
                          children: [
                            Text("Sort & Filter",
                                style: TextStyle(
                                    color: Config.appTheme.themeColor)),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    if (branch.isNotEmpty)
                      GestureDetector(
                        onTap: () async {
                          branch = "";
                          branchContainer = false;
                          stpList = [];
                          await refreshStpList();
                          setState(() {});
                        },
                        child: Visibility(
                          visible: branchContainer,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.white)),
                            child: Row(
                              children: [
                                Text("Branch",
                                    style: AppFonts.f40013
                                        .copyWith(color: Colors.black)),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.close_outlined,
                                  color: Colors.black,
                                  size: 16,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    SizedBox(width: 4),
                    if (rm.isNotEmpty)
                      GestureDetector(
                        onTap: () async {
                          rm = "";
                          rmContainer = false;
                          stpList = [];
                          await refreshStpList();
                          setState(() {});
                        },
                        child: Visibility(
                          visible: rmContainer,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.white)),
                            child: Row(
                              children: [
                                Text("RM",
                                    style: AppFonts.f40013
                                        .copyWith(color: Colors.black)),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.close_outlined,
                                  color: Colors.black,
                                  size: 16,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    SizedBox(width: 4),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          Visibility(
            visible: stpList.isNotEmpty,
            child: Padding(
              padding: EdgeInsets.only(left: 12, top: 5),
              child: Text("$totalCount items"),
            ),
          ),
        ],
      ),
    );
  }

  showFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (context) {
        return StatefulBuilder(builder: (context, bottomState) {
          return SizedBox(
            height: devHeight * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("  Sort & Filter",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Spacer(),
                    TextButton(
                        onPressed: () async {
                          Get.back();
                          branch = "";
                          rm = "";
                          subBroker = "";
                          amc = "";
                          stpList = [];
                          await refreshStpList();
                        },
                        child: Text("Reset")),
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.close))
                  ],
                ),
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
                SizedBox(height: devHeight * 0.05),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      button("Clear All"),
                      button("Apply",
                          bgColor: Config.appTheme.themeColor,
                          fgColor: Colors.white, onTap: () async {
                        EasyLoading.show();
                        page_id = 1;
                        await getActiveStpDetails();
                        EasyLoading.dismiss();
                        Get.back();
                      })
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  String sortMapping() {
    Map map = {
      "Alphabet A-Z": "alphabet-az",
      "Alphabet Z-A": "alphabet-za",
      "AUM-ASC": "aum-asc",
      "AUM-DESC": "aum-desc"
    };
    return map[selectedSort];
  }

  Widget rightContent(var bottomState) {
    if (selectedLeft == 'Sort By') return sortListView(bottomState);
    if (selectedLeft == 'Branch') return branchView();
    if (selectedLeft == 'Sub Broker') return subBrokerView();
    if (selectedLeft == 'RM') return rmView(bottomState);
    if (selectedLeft == 'AMC') return amcView(bottomState);

    return sortListView(bottomState);
  }

  Widget leftContent(var bottomState) {
    return SizedBox(
      width: devWidth * 0.35,
      child: Container(
        color: Color(0xfff5f5f7),
        child: Column(
          children: [
            SizedBox(
              width: devWidth * 0.35,
              child: ListView.builder(
                itemCount: filterValues.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  List list = filterValues.keys.toList();
                  String title = list[index];

                  return (selectedLeft == title)
                      ? rpSelectedLeftCard(title)
                      : rpLeftCard(title, () {
                          selectedLeft = title;
                          bottomState(() {});
                        });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sortListView(var bottomState) {
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

  Widget branchView() {
    List branchList = filterValues['Branch'];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: branchList.length,
      itemBuilder: (context, index) {
        String title = branchList[index];
        return InkWell(
          onTap: () async {
            branch = title;
            branchContainer = true;
            Get.back();
            stpList = [];
            await refreshStpList();
          },
          child: Row(
            children: [
              Radio(
                value: title,
                activeColor: Config.appTheme.themeColor,
                onChanged: (val) async {
                  branch = title;
                  branchContainer = true;
                  Get.back();
                  stpList = [];
                  await refreshStpList();
                },
                groupValue: branch,
              ),
              Flexible(child: Text(title)),
            ],
          ),
        );
      },
    );
  }

  Widget subBrokerView() {
    List subBrokerList = filterValues['Sub Broker'];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: subBrokerList.length,
      itemBuilder: (context, index) {
        String title = subBrokerList[index];
        return InkWell(
          onTap: () async {
            subBroker = title;
            subBrokerContainer = true;
            Get.back();
            stpList = [];
            await refreshStpList();
          },
          child: Row(
            children: [
              Radio(
                value: title,
                activeColor: Config.appTheme.themeColor,
                onChanged: (val) async {
                  subBroker = title;
                  subBrokerContainer = true;
                  Get.back();
                  stpList = [];
                  await refreshStpList();
                },
                groupValue: "sortBy",
              ),
              Flexible(child: Text(title)),
            ],
          ),
        );
      },
    );
  }

  Widget rmView(var bottomState) {
    List rmList = filterValues['RM'];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: rmList.length,
      itemBuilder: (context, index) {
        String title = rmList[index];

        return InkWell(
          onTap: () async {
            rm = title;
            rmContainer = true;
            Get.back();
            stpList = [];
            await refreshStpList();
          },
          child: Row(
            children: [
              Radio(
                value: title,
                activeColor: Config.appTheme.themeColor,
                groupValue: rm,
                onChanged: (val) async {
                  rm = title;
                  rmContainer = true;
                  Get.back();
                  stpList = [];
                  await refreshStpList();
                },
              ),
              Flexible(child: Text(title)),
            ],
          ),
        );
      },
    );
  }

  String amc = "";
  Widget amcView(var bottomState) {
    List amcList = filterValues['AMC'];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: amcList.length,
      itemBuilder: (context, index) {
        String title = amcList[index];

        return InkWell(
          onTap: () async {
            amc = title;
            amcContainer = true;
            page_id = 1;
            Get.back();
            stpList = [];
            await refreshStpList();
          },
          child: Row(
            children: [
              Radio(
                value: title,
                activeColor: Config.appTheme.themeColor,
                onChanged: (val) async {
                  amc = title;
                  amcContainer = true;
                  page_id = 1;
                  Get.back();
                  stpList = [];
                  await refreshStpList();
                },
                groupValue: amc,
              ),
              Flexible(child: Text(title)),
            ],
          ),
        );
      },
    );
  }

  refreshStpList({bool merge = false}) async {
    if (selectedIndex == 0) await getActiveStpDetails(merge: merge);
    if (selectedIndex == 1) await getClosedStpDetails(merge: merge);
  }

  Widget rpLeftCard(String title, Function() onTap) {
    return InkWell(
        onTap: onTap,
        child: SizedBox(
            width: 70,
            height: 40,
            child: Center(
                child: Text(
              title,
              style: TextStyle(fontSize: 16),
            ))));
  }

  Widget rpSelectedLeftCard(String title) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0), color: Colors.white),
      child: Center(
          child: Text(
        title,
        style: AppFonts.f40016.copyWith(color: Config.appTheme.themeColor),
      )),
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
              Text(
                lHead,
                style: AppFonts.f40013,
              ),
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

  int selectedIndex = 0;
  Widget chipArea() {
    return Container(
      height: 36,
      margin: EdgeInsets.only(left: 16, bottom: 16),
      child: ListView.builder(
        itemCount: buttonList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          String title = buttonList[index];
          bool isSelected = (selectedIndex == index);

          if (isSelected)
            return SelectedAmcChip(
              title: title,
              value: "",
              hasValue: false,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            );
          else
            return AmcChip(
              title: title,
              value: '',
              hasValue: false,
              onTap: () async {
                selectedIndex = index;
                stpList = [];
                scrollController.jumpTo(0);
                page_id = 1;
                if (selectedIndex == 0) await getActiveStpDetails();
                if (selectedIndex == 1) await getClosedStpDetails();
                setState(() {});
              },
              titleStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            );
        },
      ),
    );
  }

  String formatDate(String date) {
    if (date == null || date.isEmpty) {
      return "";
    }
    DateFormat originalFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime = originalFormat.parse(date);
    DateFormat newFormat = DateFormat('dd MMM yyyy');
    return newFormat.format(dateTime);
  }

  Widget stpTile(ActiveStpPojo stp) {
    String periodDay = stp.periodDay ?? "";
    num listAmount = stp.amount ?? 0;
    num finalAmt = listAmount.round();
    return GestureDetector(
      onTap: () {
        String investorName = stp.userName ?? "";
        String folio = stp.folioNo ?? "";
        num amount = stp.amount ?? 0;
        String periodDay = stp.periodDay ?? "";
        String schemeLogo = stp.schemeLogo ?? "";
        String scheme = stp.scheme ?? "";
        String toSchemeName = stp.toSchemeName ?? "";
        String startDate = stp.fromDate ?? "";
        String endDate = stp.toDate ?? "";
        String regDate = stp.regDate ?? "";
        String branch = stp.branch ?? "";
        String rmName = stp.rmName ?? "";
        String subbrokerName = stp.subbrokerName ?? "";

        String formattedStartDate = formatDate(startDate);
        String formattedEndDate = formatDate(endDate);
        String formattedRegDate = formatDate(regDate);

        stpBottomSheet(
            investorName,
            folio,
            amount,
            periodDay,
            schemeLogo,
            scheme,
            toSchemeName,
            mobile,
            formattedStartDate,
            formattedEndDate,
            formattedRegDate,
            branch,
            rmName,
            subbrokerName);
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
                ColumnText(
                  title: Utils.getFirst13(stp.userName, count: 15),
                  value: "Folio: ${stp.folioNo}",
                  alignment: CrossAxisAlignment.start,
                  titleStyle: AppFonts.f50014Black,
                  valueStyle: AppFonts.f40013,
                ),
                Spacer(),
                SizedBox(
                  width: periodDay.contains(',') ? 150 : null,
                  child: ColumnText(
                      title: "$rupee $finalAmt",
                      value: "${stp.periodDay}th of every ${stp.frequency}",
                      alignment: CrossAxisAlignment.end,
                      titleStyle: AppFonts.f50014Black,
                      valueStyle: AppFonts.f40013),
                ),
                SizedBox(width: 5),
                Icon(Icons.arrow_forward_ios,
                    size: 15, color: Color(0xffB4B4B4)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                //Image.network("${stp.schemeLogo}", height: 24),
                Utils.getImage("${stp.schemeLogo}", 24),
                // Image.asset("assets/48.png", height: 32),
                Spacer(),
                SizedBox(
                  width: devWidth * 0.35,
                  child: Text("${stp.scheme}",
                      style: AppFonts.f50014Black
                          .copyWith(color: Config.appTheme.themeColor)),
                ),
                TransferCircle(),
                SizedBox(
                  width: devWidth * 0.35,
                  child: Text(
                    "${stp.toSchemeName}",
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor),
                    textAlign: TextAlign.end,
                  ),
                ),
                Spacer(),
              ],
            ),
            DottedLine(verticalPadding: 8),
          ],
        ),
      ),
    );
  }

  stpBottomSheet(
      String investorName,
      String folio,
      num amount,
      String periodDay,
      String schemeLogo,
      String scheme,
      String toSchemeName,
      String mobile,
      String startDate,
      String endDate,
      String regDate,
      String branch,
      String rmName,
      String subbrokerName) {
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
          return StatefulBuilder(
            builder: (context, bottomState) {
              return Container(
                height: devHeight * 0.54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    BottomSheetTitle(title: ""),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ColumnText(
                                  title:
                                      Utils.getFirst13(investorName, count: 15),
                                  value: "Folio: $folio",
                                  alignment: CrossAxisAlignment.start,
                                  titleStyle: AppFonts.f50014Black,
                                  valueStyle: AppFonts.f40013,
                                ),
                                Spacer(),
                                // SizedBox(
                                //   width: periodDay.contains(',') ? 150 : null,
                                //   child: ColumnText(
                                //       title:
                                //           "$rupee ${Utils.formatNumber(amount, isAmount: false)}",
                                //       value: "$periodDay th of every ${stp.frequency}",
                                //       alignment: CrossAxisAlignment.end,
                                //       titleStyle: AppFonts.f50014Black,
                                //       valueStyle: AppFonts.f40013),
                                // ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //Image.network(schemeLogo, height: 24),
                                Utils.getImage(schemeLogo, 24),
                                SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  width: devWidth * 0.35,
                                  child: Text(getFirst30(scheme),
                                      style: AppFonts.f50014Black.copyWith(
                                          color: Config.appTheme.themeColor)),
                                ),
                                TransferCircle(),
                                SizedBox(width: 6),
                                SizedBox(
                                  width: devWidth * 0.35,
                                  child: Text(
                                    getFirst30(toSchemeName),
                                    style: AppFonts.f50014Black.copyWith(
                                        color: Config.appTheme.themeColor),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            DottedLine(verticalPadding: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: 180,
                                    child: ColumnText(
                                        title: "Start Date", value: startDate)),
                                ColumnText(
                                  title: "End Date",
                                  value: endDate,
                                  alignment: CrossAxisAlignment.start,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ColumnText(
                                  title: "Reg. Date",
                                  value: regDate,
                                ),
                              ],
                            ),
                            DottedLine(
                              verticalPadding: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: 180,
                                    child: ColumnText(
                                        title: "Branch", value: branch)),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: 160,
                                    child: ColumnText(
                                      title: "RM",
                                      value: rmName,
                                      alignment: CrossAxisAlignment.start,
                                    )),
                                SizedBox(
                                    width: 160,
                                    child: ColumnText(
                                        title: "Associate",
                                        value: subbrokerName)),
                              ],
                            ),
                            SizedBox(height: 15),
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

  String getFirst30(String text) {
    String s = text.split(":").last;
    if (s.length > 30) s = s.substring(0, 30);
    return s;
  }
}
