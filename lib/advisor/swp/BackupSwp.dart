import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/Api.dart';

import 'package:mymfbox2_0/pojo/sip/ActiveSipPojo.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/AmcChip.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/SelectedAmcChip.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class BackupSwp extends StatefulWidget {
  const BackupSwp({super.key});

  @override
  State<BackupSwp> createState() => _BackupSwpState();
}

class _BackupSwpState extends State<BackupSwp> {
  int user_id = GetStorage().read("mfd_id") ?? 0;
  String client_name = GetStorage().read("client_name") ?? "null";
  String mobile = GetStorage().read("mfd_mobile") ?? "null";

  late double devHeight, devWidth;
  int totalCount = 0;
  Map filterValues = {
    'Branch': [],
    'RM': [],
    'Sub Broker': [],
    'AMC': [],
  };
  final List buttonList = ["Active SWPs", "Closed SWPs"];
  ScrollController scrollController = ScrollController();
  bool isFirst = true;
  int page_id = 1;

  List<OldActiveSipPojo> swpList = [];
  bool investorFetching = false;
  bool isLoading = true;

  String selectedLeft = "Branch";
  String selectedSort = "Alphabet A-Z";

  String searchKey = "";

  String branch = "", rm = "", subBroker = "";

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
    print("getAllRM response = $data");
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
    ScrollPosition position = scrollController.position;
    if (position.atEdge && position.extentAfter < 100) {
      page_id++;
      await refreshSwpList(merge: true);
    }
  }

  Future getActiveSwpReport({bool merge = false}) async {
    if (!merge) swpList = [];
    EasyLoading.show();
    Map data = await AdminApi.getActiveSwpReport(
        user_id: user_id,
        client_name: client_name,
        branch: branch,
        rm_name: rm,
        sub_broker_name: subBroker,
        sip_date: "",
        amc_name: amc,
        start_date: "",
        end_date: "",
        broker_code: "",
        page_id: page_id,
        search: "",
        sort_by: "");
    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      return 0;
    }
    totalCount = data['total_count'];
    List list = data['list'];
    convertListToObj(list);
    setState(() {});
    investorFetching = false;

    EasyLoading.dismiss();
    return 0;
  }

  Future getClosedSwpReport({bool merge = false}) async {
    if (!merge) {
      if (swpList.isNotEmpty) return 0;
    }

    EasyLoading.show();
    Map data = await AdminApi.getClosedSwpReport(
        user_id: user_id,
        client_name: client_name,
        branch: branch,
        rm_name: rm,
        sub_broker_name: subBroker,
        sip_date: "",
        amc_name: "",
        start_date: "",
        end_date: "",
        broker_code: "",
        page_id: page_id,
        search: "",
        sort_by: "");
    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      return 0;
    }
    totalCount = data['total_count'];
    List list = data['list'];
    convertListToObj(list);
    setState(() {});
    investorFetching = false;

    EasyLoading.dismiss();
    return 0;
  }

  convertListToObj(List list) {
    list.forEach((element) {
      swpList.add(OldActiveSipPojo.fromJson(element));
    });
    EasyLoading.dismiss();
  }

  Future getDatas() async {
    if (!isFirst) return 0;
    isLoading = true;
    await getAllBranch();
    await getAllRM();
    await getAllSubBroker();
    await getAllAmc();
    await getActiveSwpReport();
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
            appBar: adminAppBar(title: "SWP", bgColor: Colors.white),
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

  int selectedSwpType = 0;
  Widget chipArea() {
    return Container(
      height: 36,
      margin: EdgeInsets.only(left: 16, bottom: 16),
      child: ListView.builder(
        itemCount: buttonList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          String title = buttonList[index];
          bool isSelected = (selectedSwpType == index);

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
                selectedSwpType = index;
                swpList = [];
                if (selectedSwpType == 0) await getActiveSwpReport();
                if (selectedSwpType == 1) await getClosedSwpReport();
                // setState(() {});
              },
              titleStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            );
        },
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
        visible: swpList.isNotEmpty,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$totalCount items", style: AppFonts.f40013),
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
            ? Utils.shimmerWidget(devHeight, margin: EdgeInsets.all(16))
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: swpList.length,
                itemBuilder: (context, index) {
                  OldActiveSipPojo sip = swpList[index];
                  return swpTile(sip);
                },
              ),
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
                        onPressed: () {
                          branch = "";
                          rm = "";
                          subBroker = "";
                          amc = "";
                          Get.back();
                          setState(() {});
                          refreshSwpList();
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
                        await getActiveSwpReport();
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

  refreshSwpList({bool merge = false}) async {
    if (selectedSwpType == 0) await getActiveSwpReport(merge: merge);
    if (selectedSwpType == 1) await getClosedSwpReport(merge: merge);
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
    if (selectedLeft == 'Branch') return branchView(bottomState);
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

  Widget branchView(var bottomState) {
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
            swpList = [];
            await refreshSwpList();
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
                  swpList = [];
                  await refreshSwpList();
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
            swpList = [];
            await refreshSwpList();
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
                  swpList = [];
                  await refreshSwpList();
                },
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
            swpList = [];
            await refreshSwpList();
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
                  swpList = [];
                  await refreshSwpList();
                },
                groupValue: subBroker,
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
            swpList = [];
            await refreshSwpList();
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
                  swpList = [];
                  await refreshSwpList();
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

  Widget swpTile(OldActiveSipPojo swp) {
    return GestureDetector(
      onTap: () {
        String investorName = swp.investorName ?? "";
        String folio = swp.folio ?? "";
        num amount = swp.amount ?? 0;
        String periodDay = swp.displayDate ?? "";
        String schemeLogo = swp.logo ?? "";
        String scheme = swp.schemeName ?? "";
        // String startDate = swp.fromDate ?? "";
        // String endDate = swp.toDate ?? "";
        String regDate = swp.regDate ?? "";
        String branch = swp.branch ?? "";
        String rmName = swp.rmName ?? "";
        String subbrokerName = swp.subbrokerName ?? "";

        // String formattedStartDate = formatDate(startDate);
        // String formattedEndDate = formatDate(endDate);
        String formattedRegDate = formatDate(regDate);

        swpBottomSheet(
            investorName,
            folio,
            amount,
            periodDay,
            schemeLogo,
            scheme,
            // formattedStartDate,
            // formattedEndDate,
            formattedRegDate,
            branch,
            rmName,
            subbrokerName);
      },
      child: Container(
        width: devWidth,
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0), // Add padding
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
                  title: Utils.getFirst13(swp.investorName, count: 15),
                  value: "Folio: ${swp.folio}",
                  alignment: CrossAxisAlignment.start,
                  titleStyle: AppFonts.f50014Black,
                  valueStyle: AppFonts.f40013,
                  // Add other text style properties as needed
                ),
                Spacer(),
                ColumnText(
                    title:
                        rupee + Utils.formatNumber(swp.amount, isAmount: false),
                    value: "",
                    alignment: CrossAxisAlignment.end,
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013),
                SizedBox(width: 5),
                Icon(Icons.arrow_forward_ios,
                    size: 15, color: Color(0xffB4B4B4)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                //Image.network("${swp.logo}", height: 30),
                Utils.getImage("${swp.logo}", 30),
                // Image.asset("assets/48.png", height: 30),
                SizedBox(width: 8),
                Flexible(
                  child: Text("${swp.schemeName}",
                      style: AppFonts.f50014Black
                          .copyWith(color: Config.appTheme.themeColor)),
                )
              ],
            ),
            DottedLine(verticalPadding: 8),
          ],
        ),
      ),
    );
  }

  swpBottomSheet(
      String investorName,
      String folio,
      num amount,
      String periodDay,
      String schemeLogo,
      String scheme,
      //String formattedStartDate,
      //String formattedEndDate,
      String formattedRegDate,
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
                                  // Add other text style properties as needed
                                ),
                                Spacer(),
                                // ColumnText(
                                //     title:
                                //         "$rupee ${Utils.formatNumber(amount, isAmount: false)}",
                                //     value: "$periodDay th of every ${swp.frequency}",
                                //     alignment: CrossAxisAlignment.end,
                                //     titleStyle: AppFonts.f50014Black,
                                //     valueStyle: AppFonts.f40013),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                //Image.network(schemeLogo, height: 30),
                                Utils.getImage(schemeLogo, 30),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    scheme,
                                    style: AppFonts.f50014Black.copyWith(
                                      color: Config.appTheme.themeColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            DottedLine(verticalPadding: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 180,
                                  child: ColumnText(
                                    title: "Start Date",
                                    value: "startDate",
                                  ),
                                ),
                                ColumnText(
                                  title: "End Date",
                                  value: "endDate",
                                  alignment: CrossAxisAlignment.start,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ColumnText(
                                  title: "Reg. Date",
                                  value: "regDate",
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
                                    title: "Branch",
                                    value: branch,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 160,
                                  child: ColumnText(
                                    title: "RM",
                                    value: rmName,
                                    alignment: CrossAxisAlignment.start,
                                  ),
                                ),
                                SizedBox(
                                  width: 160,
                                  child: ColumnText(
                                    title: "Associate",
                                    value: subbrokerName,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              );
            },
          );
        });
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
}
