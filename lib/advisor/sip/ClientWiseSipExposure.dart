import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/pojo/sip/AmcWiseSipPojo.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpFilterChip.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile2.dart';
import 'package:mymfbox2_0/rp_widgets/SearchField.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../utils/Restrictions.dart';

class ClientWiseSipExposure extends StatefulWidget {
  const ClientWiseSipExposure({super.key, this.scheme_name = "", this.totalInvestors = 0, this.branch = const[],this.rm=const[], this.associate = const[]});
  final String scheme_name;
  final int totalInvestors;
  final List branch;
  final List rm;
  final List associate;
  @override
  State<ClientWiseSipExposure> createState() => _ClientWiseSipExposureState();
}

class _ClientWiseSipExposureState extends State<ClientWiseSipExposure> {
  int user_id = GetStorage().read("mfd_id") ?? 0;
  String client_name = GetStorage().read("client_name") ?? "null";
  String mobile = GetStorage().read("mfd_mobile") ?? "null";

  Map filterValues = {
    "Sort By": ["Alphabet", "SIP Amount"],
    'Branch': [],
    'RM': [],
    'Sub Broker': [],
    // 'AMC': [],
    'ARN': [],
  };
  bool isExpanded = false;

  int expandedIndex = -1;
  ScrollController scrollController = ScrollController();
  bool isFirst = true;
  int page_id = 1;

  String totalAum = "loading";
  bool isLoading = true;

  String selectedLeft = "Sort By";
  String selectedSort = "Alphabet";

  String searchKey = "";
  bool branchContainer = true;
  bool rmContainer = true;
  bool subBrokerContainer = true;

  int type_id = GetStorage().read('type_id');

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

  List amcList = [];
  Future getAllAmc() async {
    if (amcList.isNotEmpty) return 0;

    Map data = await Api.getAmcWiseSipDetails(
        user_id: user_id,
        client_name: client_name,
        maxCount: 'All',
        broker_code: 'All');

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }

    amcList = data['list'];

    return 0;
  }

  List arnList = [];
  Future getArnList() async {
    if (arnList.isNotEmpty) return 0;

    Map data = await Api.getArnList(client_name: client_name);
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

    return 0;
  }

  @override
  void initState() {
    //  implement initState
    super.initState();
    scrollController.addListener(scrollListener);
    selectedBranch = widget.branch;
    selectedRm = widget.rm;
    selectedSubBroker = widget.associate;

  }

  Future scrollListener() async {
    bool atBottom = scrollController.position.extentAfter < 100;
    bool fullyLoaded = investorList.length == totalCount;

    bool fetchAgain = atBottom && !fullyLoaded && !isLoading;

    if (fetchAgain) await getMoreInvestors();
  }

  num totalCount = 0;
  List investorList = [];
  Future getInitialInvestors() async {
    page_id = 1;

    Map data = await AdminApi.getClientWiseSipDetails(
      user_id: user_id,
      client_name: client_name,
      page_id: page_id,
      sort_by: selectedSort.toLowerCase().replaceAll(" ", "_"),
      branch: selectedBranch.join(","),
      rm_name: selectedRm.join(","),
      subbroker_name: selectedSubBroker.join(","),
      search: searchKey,
      scheme_name: widget.scheme_name,
      amc: selectedAMC.join(","),
      broker_code: selectedArn,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    totalCount = data['total_count'] ?? 0;
    investorList = data['list'];

    return 0;
  }

  Future getMoreInvestors() async {
    page_id++;

    print("getting more investor with page id = $page_id");
    isLoading = true;
    EasyLoading.show();
    Map data = await AdminApi.getClientWiseSipDetails(
      user_id: user_id,
      client_name: client_name,
      page_id: page_id,
      sort_by: selectedSort.toLowerCase().replaceAll(" ", "_"),
      branch: selectedBranch.join(","),
      rm_name: selectedRm.join(","),
      subbroker_name: selectedSubBroker.join(","),
      search: searchKey,
      scheme_name: widget.scheme_name,
      amc: selectedAMC.join(","),
      broker_code: selectedArn,
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

  Future getDatas() async {
    if (!isFirst) return 0;

    if (Restrictions.isBranchApiAllowed) await getAllBranch();
    await getAllRM();
    await getAllSubBroker();
    await getArnList();
    await getAllAmc();
    await getInitialInvestors();

    isFirst = false;
    isLoading = false;

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
      EasyLoading.show(status: "Searching for `$searchKey`");
      await getInitialInvestors();
      EasyLoading.dismiss();
      setState(() {});
    });
  }

  @override
  void dispose() {
    //  implement dispose
    scrollController.dispose();
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
            appBar: adminAppBar(
                title: "Client Wise SIP Exposure", bgColor: Colors.white),
            body: Column(
              children: [
                if (type_id == UserType.ADMIN)
                sortLine(),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: SearchField(
                    hintText: "Search",
                    onChange: searchHandler,
                  ),
                ),
                countLine(),
                listArea(),
              ],
            ),
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
                showFilter();
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
            Text("${Utils.formatNumber(totalCount)} Items",
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
          ? Utils.shimmerWidget(devHeight, margin: EdgeInsets.all(16))
          : ListView.separated(
              shrinkWrap: true,
              itemCount: investorList.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Map<String, dynamic> data = investorList[index];
                ClientWiseSipPojo investor = ClientWiseSipPojo.fromJson(data);
                return sipInvestorsCard(investor);
              },
              separatorBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: DottedLine(verticalPadding: 8),
                );
              }),
    ));
  }

  Widget sipInvestorsCard(ClientWiseSipPojo investor) {
    return InkWell(
      splashColor: Colors.white,
      onTap: () {
        investorBottomSheet(investor);
      },
      child: RpListTile2(
        leading: InitialCard(title: "${investor.name}"),
        l1: "${investor.name}",
        l2: "${investor.pan}",
        r1: "$rupee ${Utils.formatNumber(investor.sipAmount)}",
        r2: "(${investor.sipCounts} SIPs)",
      ),
    );
  }

  String formatDate(String dateString) {
    if (dateString.isEmpty) {
      return '';
    }
    DateTime dateTime = DateFormat('dd-MM-yyyy').parse(dateString);
    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    return formattedDate;
  }

  Widget sipDetailsCard(SipDetails sip) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 8),
          title: RpListTile2(
            padding: EdgeInsets.zero,
            leading: Image.network("${sip.logo}", width: setImageSize(30)),
            l1: "${sip.schemeAmfiShortName}",
            l2: "Folio: ${sip.folio}",
            r1: "$rupee ${Utils.formatNumber(sip.amount)}",
            r2: "${sip.sipDate} ${sip.frequency}",
            hasArrow: false,
            gap: 36,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: EdgeInsets.all(16),
          children: [
            rpRow(
              lhead: "Reg Date",
              lSubHead: "${sip.regDate}",
              rhead: "",
              rSubHead: "",
            ),
            DottedLine(verticalPadding: 4),
            rpRow(
              lhead: "Start Date",
              lSubHead: "${sip.startDate}",
              rhead: "End Date",
              rSubHead: "${sip.endDate}",
            ),
            DottedLine(verticalPadding: 4),
            rpRow(
              lhead: "BankName",
              lSubHead: "${sip.bankName}",
              rhead: "Account Number",
              rSubHead: "${sip.accountNo}",
            ),
            DottedLine(verticalPadding: 4),
            rpRow(
              lhead: "Current Cost",
              lSubHead:
                  "$rupee ${Utils.formatNumber(sip.currCost, isAmount: true)}",
              rhead: "Current Value",
              rSubHead:
                  "$rupee ${Utils.formatNumber(sip.currValue, isAmount: true)}",
            ),
            DottedLine(verticalPadding: 4),
            rpRow(
              lhead: "Abs Ret (%)",
              lSubHead: "${(sip.absReturn)?.toStringAsFixed(2)}",
              rhead: "",
              rSubHead: "",
            ),
          ],
        ),
      ),
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

  showFilter() {
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
                            selectedBranch = [];
                            selectedRm = [];
                            selectedSubBroker = [];
                            Get.back();
                            await refreshPage();
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

  Future refreshPage() async {
    EasyLoading.show();
    await getInitialInvestors();
    EasyLoading.dismiss();
    setState(() {});
  }

  Widget rightContent(var bottomState) {
    if (selectedLeft == 'sort By') return sortView(bottomState);
    if (selectedLeft == 'Branch') return branchView(bottomState);
    if (selectedLeft == 'RM') return rmView(bottomState);
    if (selectedLeft == 'Sub Broker') return subBrokerView(bottomState);
    if (selectedLeft == 'AMC') return amcView(bottomState);
    if (selectedLeft == 'ARN') return arnView(bottomState);

    return sortView(bottomState);
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
              ? rpLeftSelectedBtn(title)
              : rpLeftBtn(title, () {
                  selectedLeft = title;
                  bottomState(() {});
                  setState(() {});
                });
        },
      ),
    );
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
            print("selectedSort $selectedSort ");
            setState(() {
              selectedSort = title;
            });
            bottomState(() {});
          },
          child: Row(
            children: [
              Radio(
                value: title,
                activeColor: Config.appTheme.themeColor,
                onChanged: (val) {
                  setState(() {
                    selectedSort = title;
                  });
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

  List selectedRm = [];
  Widget rmView(var bottomState) {
    List rmList = filterValues['RM'];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: rmList.length,
      itemBuilder: (context, index) {
        String title = rmList[index];
        bool contains = selectedRm.contains(title);

        return InkWell(
          onTap: () {
            if (contains)
              selectedRm.remove(title);
            else
              selectedRm.add(title);
            bottomState(() {});
          },
          child: Row(
            children: [
              Checkbox(
                value: contains,
                activeColor: Config.appTheme.themeColor,
                onChanged: (val) {
                  if (contains)
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

  Widget rpLeftSelectedBtn(String title) {
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

  investorBottomSheet(ClientWiseSipPojo investor) {
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
              height: devHeight * 0.86,
              decoration: BoxDecoration(
                color: Config.appTheme.mainBgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  BottomSheetTitle(
                      title: "", padding: EdgeInsets.fromLTRB(16, 16, 16, 0)),
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InitialCard(title: "${investor.name}"),
                            SizedBox(width: 8),
                            Expanded(
                              child: ColumnText(
                                title: "${investor.name}",
                                value: "Individual",
                                titleStyle: AppFonts.f50014Black,
                                valueStyle: AppFonts.f40013,
                              ),
                            ),
                            ColumnText(
                              title:
                                  "$rupee ${Utils.formatNumber(investor.sipAmount)}",
                              value: "(${investor.sipCounts} SIPs)",
                              titleStyle: AppFonts.f50014Black,
                              valueStyle: AppFonts.f40013,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ColumnText(
                                title: "PAN",
                                value: "${investor.pan}",
                              ),
                            ),
                            Expanded(
                              child: ColumnText(
                                title: "Mobile",
                                value: "${investor.mobile}",
                                valueStyle: AppFonts.f50014Theme.copyWith(
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        ColumnText(
                          title: "Email",
                          value: "${investor.email}",
                          valueStyle: AppFonts.f50014Theme
                              .copyWith(decoration: TextDecoration.underline),
                        ),
                      /*  DottedLine(verticalPadding: 8),
                        rpRow(
                          lhead: "Current Cost",
                          lSubHead:
                              "$rupee ${Utils.formatNumber(investor.currCost, isAmount: true)}",
                          rhead: "Current Value",
                          rSubHead:
                              "$rupee ${Utils.formatNumber(investor.currValue, isAmount: true)}",
                        ),
                        SizedBox(height: 8),
                        ColumnText(
                          title: "Absolute Return",
                          value: "${investor.absReturn!.toStringAsFixed(2)}%",
                        ),
                       */
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
                        width: double.maxFinite,
                        color: Config.appTheme.mainBgColor,
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: investor.sipDetails!.length,
                          controller: scrollController,
                          itemBuilder: (context, index) {
                            SipDetails sip = investor.sipDetails![index];
                            return sipDetailsCard(sip);
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(height: 16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List selectedAMC = [];
  Widget amcView(var bottomState) {
    List list = amcList;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> data = list[index];
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
              Image.network("${amcPojo.amcLogo}", width: setImageSize(24)),
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
    List list = arnList;

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
}

class ClientWiseSipPojo {
  num? userId;
  String? name;
  String? pan;
  String? mobile;
  String? email;
  num? sipAmount;
  num? sipCounts;
  num? currCost;
  num? currValue;
  double? absReturn;
  List<SipDetails>? sipDetails;

  ClientWiseSipPojo(
      {this.userId,
      this.name,
      this.pan,
      this.mobile,
      this.email,
      this.sipAmount,
      this.sipCounts,
      this.currCost,
      this.currValue,
      this.absReturn,
      this.sipDetails});

  ClientWiseSipPojo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    pan = json['pan'];
    mobile = json['mobile'];
    email = json['email'];
    sipAmount = json['sip_amount'];
    sipCounts = json['sip_counts'];
    currCost = json['curr_cost'];
    currValue = json['curr_value'];
    absReturn = json['abs_return'];
    if (json['sip_details'] != null) {
      sipDetails = <SipDetails>[];
      json['sip_details'].forEach((v) {
        sipDetails!.add(SipDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['pan'] = pan;
    data['mobile'] = mobile;
    data['email'] = email;
    data['sip_amount'] = sipAmount;
    data['sip_counts'] = sipCounts;
    data['curr_cost'] = currCost;
    data['curr_value'] = currValue;
    data['abs_return'] = absReturn;
    if (sipDetails != null) {
      data['sip_details'] = sipDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SipDetails {
  String? scheme;
  String? schemeAmfiShortName;
  String? schemeCompany;
  String? logo;
  String? folio;
  num? amount;
  String? startDate;
  String? endDate;
  String? sipDate;
  String? regDate;
  String? frequency;
  String? bankName;
  String? accountNo;
  num? currCost;
  num? currValue;
  num? absReturn;

  SipDetails(
      {this.scheme,
      this.schemeAmfiShortName,
      this.schemeCompany,
      this.logo,
      this.folio,
      this.amount,
      this.startDate,
      this.endDate,
      this.sipDate,
      this.regDate,
      this.frequency,
      this.bankName,
      this.accountNo,
      this.currCost,
      this.currValue,
      this.absReturn});

  SipDetails.fromJson(Map<String, dynamic> json) {
    scheme = json['scheme'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeCompany = json['scheme_company'];
    logo = json['logo'];
    folio = json['folio'];
    amount = json['amount'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    sipDate = json['sip_date'];
    regDate = json['reg_date'];
    frequency = json['frequency'];
    bankName = json['bank_name'];
    accountNo = json['account_no'];
    currCost = json['curr_cost'];
    currValue = json['curr_value'];
    absReturn = json['abs_return'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scheme'] = scheme;
    data['scheme_amfi_short_name'] = schemeAmfiShortName;
    data['scheme_company'] = schemeCompany;
    data['logo'] = logo;
    data['folio'] = folio;
    data['amount'] = amount;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['sip_date'] = sipDate;
    data['reg_date'] = regDate;
    data['frequency'] = frequency;
    data['bank_name'] = bankName;
    data['account_no'] = accountNo;
    data['curr_cost'] = currCost;
    data['curr_value'] = currValue;
    data['abs_return'] = absReturn;
    return data;
  }
}
