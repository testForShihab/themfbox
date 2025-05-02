import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/login/CheckUserType.dart';
import 'package:mymfbox2_0/pojo/AllInvestorsPojo.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpFilterChip.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile2.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Restrictions.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/RectButton.dart';
import 'package:mymfbox2_0/rp_widgets/SearchField.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../api/InvestorApi.dart';
import '../../pojo/MfSchemeSummaryPojo.dart';
import '../../pojo/MfSummaryPojo.dart';

class AllInvestor extends StatefulWidget {
  AllInvestor(
      {super.key,
      required this.totalInvestors,
      required this.branch,
      required this.rm,
      required this.associate,
      this.startDate,
      this.endDate});

  final num totalInvestors;
  final List branch;
  final List rm;
  final List associate;
  DateTime? startDate;
  DateTime? endDate;

  @override
  State<AllInvestor> createState() => _AllInvestorState();
}

class _AllInvestorState extends State<AllInvestor> {
  int user_id = GetStorage().read("mfd_id");
  String client_name = GetStorage().read("client_name");
  String mobile = GetStorage().read("mfd_mobile");
  int type_id = GetStorage().read("type_id");

  Map sipSummary = {};
  MfSummaryPojo mfSummary = MfSummaryPojo();
  List<MfSchemeSummaryPojo> schemeList = [];

  bool isLoading = true;
  int page_id = 1;

  String searchKey = "";
  DateTime? startDate;
  DateTime? endDate;

  num totalCount = 0, totalAum = 0;
  List investorList = [];

  formatDate(DateTime dt) {
    return DateFormat("dd-MM-yyyy").format(dt);
  }

  Future getInitialInvestors() async {
    page_id = 1;

    String tempSort = selectedSort;
    if (selectedSort.contains("Alphabet")) {
      tempSort = selectedSort.replaceAll("-", ""); //Alphabet AZ
      tempSort = tempSort.replaceAll(" ", "-"); //Alphabet-AZ
    }

    Map data = await AdminApi.getInvestors(
      page_id: page_id,
      client_name: client_name,
      user_id: user_id,
      search: searchKey,
      sortby: tempSort,
      branch: selectedBranch.join(","),
      rmList: selectedRm,
      subbroker_name: selectedSubBroker.join(","),
      start_date: (startDate != null) ? formatDate(startDate!) : "",
      end_date: (endDate != null) ? formatDate(endDate!) : "",
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    print("came here --> $totalCount");
    totalCount = data['total_count'] ?? 0;
    totalAum = data['total_aum'];
    investorList = data['list'];
    isLoading = false;

    return 0;
  }

  Future getMoreInvestors() async {
    page_id++;

    print("getting more investor with page id = $page_id");
    isLoading = true;
    EasyLoading.show();

    String tempSort = selectedSort;
    if (selectedSort.contains("Alphabet")) {
      tempSort = selectedSort.replaceAll("-", "");
      tempSort = selectedSort.replaceAll(" ", "-");
    }

    Map data = await AdminApi.getInvestors(
      page_id: page_id,
      client_name: client_name,
      user_id: user_id,
      search: searchKey,
      sortby: tempSort,
      branch: selectedBranch.join(","),
      rmList: selectedRm,
      subbroker_name: selectedSubBroker.join(","),
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
        mobile: mobile,
        client_name: client_name,
        branch: selectedBranch.join(","));

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
    Map data = await Api.getAllSubbroker(
        mobile: mobile,
        client_name: client_name,
        rm_name: selectedRm.join(","));

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
      await getInitialInvestors();
      EasyLoading.dismiss();

      setState(() {});
    });
  }

  Future getInvestorSummaryPdf(
      String investorDetails, String userMobile, String type) async {
    print("type = $type");
    EasyLoading.show();
    Map data = await AdminApi.getInvestorSummaryPdf(
        investor_details: investorDetails,
        mobile: userMobile,
        type: type,
        client_name: client_name);

    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    String resUrl = data['msg'];
    if (type == "download") {
      rpDownloadFile(url: resUrl, context: context);
    }
    if (type == "Email") {
      Fluttertoast.showToast(
          msg: resUrl,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Config.appTheme.themeColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    EasyLoading.dismiss();
    Get.back();
    return 0;
  }

  String selectedFolioType = "Live";
  DateTime selectedFolioDate = DateTime.now();

  Future getMutualFundPortfolio(int user_id) async {
    schemeList.clear();
    sipSummary.clear();
    mfSummary = MfSummaryPojo();

    Map data = await InvestorApi.getMutualFundPortfolio(
      user_id: user_id,
      client_name: client_name,
      folio_type: selectedFolioType,
      selected_date: selectedFolioDate,
      broker_code: "",
    );

    // Error handling for API response
    if (data['status'] != 200) {
      print("Error: API returned status ${data['status']} with message: ${data['msg']}");
      Utils.showError(context, data['msg']);
      return;
    }

    print("API Response Data: $data"); // Debugging

    // Safely parse mf_summary
    if (data['mf_summary'] != null) {
      Map<String, dynamic> map = data['mf_summary'];
      print("API Response mf_summary: $map");
      mfSummary = MfSummaryPojo.fromJson(map);
    } else {
      print("Error: mf_summary is null.");
      return;
    }

    // Parse SIP summary
    sipSummary = data['sip_summary'] ?? [];

    print("Parsed mfSummary values:");
    print("Total Current Value: ${mfSummary?.totalCurrValue ?? 0}");
    print("Total Current Cost: ${mfSummary?.totalCurrCost ?? 0}");
    print("Total Unrealised Gain: ${mfSummary?.totalUnrealisedGain ?? 0}");

    return;
  }

  bool isFirst = true;

  Future getDatas() async {
    if (!isFirst) return 0;

    if (Restrictions.isBranchApiAllowed) await getAllBranch();
    if (Restrictions.isRmApiAllowed) await getAllRM();
    if (Restrictions.isAssociateApiAllowed) await getAllSubBroker();
    await getInitialInvestors();

    isFirst = false;
    return 0;
  }

  ScrollController scrollController = ScrollController();

  Future scrollListener() async {
    bool atBottom = scrollController.position.extentAfter < 100;
    bool fullyLoaded = investorList.length == totalCount;

    bool fetchAgain = atBottom && !fullyLoaded && !isLoading;

    if (fetchAgain) await getMoreInvestors();
  }

  String shareURl = "";

  Future getWhatsappShareLink({required num user_id}) async {
    Map data = await InvestorApi.getWhatsappShareLink(
        user_id: user_id, client_name: client_name);
    shareURl = data['msg'];
    print("share url $shareURl");
    return 0;
  }

  @override
  void initState() {
    //  implement initState
    super.initState();
    selectedBranch = widget.branch;
    selectedRm = widget.rm;
    selectedSubBroker = widget.associate;
    startDate = widget.startDate;
    endDate = widget.endDate;
    scrollController.addListener(scrollListener);
    numberController = TextEditingController();
  }

  @override
  void dispose() {
    //  implement dispose
    scrollController.removeListener(scrollListener);
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
            appBar: adminAppBar(title: "All Investors", bgColor: Colors.white),
            body: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SearchField(
                    hintText: "Search Investors",
                    // controller: _controller,
                    onChange: searchHandler,
                  ),
                ),
                if (type_id == UserType.ADMIN) sortLine(),
                countLine(),
                listArea(),
              ],
            ),
          );
        });
  }

  Future<bool> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevents dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Do you really want to exit?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Exit'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((value) => value ?? false); // Handle null case
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
            Text(
                "Total AUM $rupee ${Utils.formatNumber(totalAum, isAmount: true)}",
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
            : ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: investorList.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = investorList[index];
                  AllInvestorsPojo userData = AllInvestorsPojo.fromJson(data);
                  return InkWell(
                    onTap: () {
                      showUserDetails(userData, mfSummary);
                    },
                    child: RpListTile2(
                        leading: InitialCard(
                            title: (data['name'] == "") ? "." : data['name']),
                        l1: "${userData.name}",
                        l2: "${userData.pan}",
                        r1: "$rupee ${Utils.formatNumber(userData.aum, isAmount: true)}",
                        r2: ""),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: DottedLine(verticalPadding: 8),
                ),
              ),
      ),
    );
  }

  Map filterValues = {
    "Sort By": ["Alphabet A-Z", "Alphabet Z-A", "AUM-ASC", "AUM-DESC"],
    'Branch': [],
    'RM': [],
    'Sub Broker': [],
  };
  String selectedLeft = "Sort By";
  String selectedSort = "Alphabet A-Z";

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
    await getInitialInvestors();
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
            await onBranchSelected(isContains, title, bottomState);
          },
          child: Row(
            children: [
              Checkbox(
                value: selectedBranch.contains(title),
                activeColor: Config.appTheme.themeColor,
                onChanged: (val) async {
                  await onBranchSelected(isContains, title, bottomState);
                },
              ),
              Flexible(child: Text(title)),
            ],
          ),
        );
      },
    );
  }

  Future onBranchSelected(
      bool isContains, String title, var bottomState) async {
    if (isContains)
      selectedBranch.remove(title);
    else
      selectedBranch.add(title);

    rmList = [];
    await getAllRM();
    bottomState(() {});
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
            await onRmSelected(isContains, title, bottomState);
          },
          child: Row(
            children: [
              Checkbox(
                value: selectedRm.contains(title),
                onChanged: (val) async {
                  await onRmSelected(isContains, title, bottomState);
                },
              ),
              Flexible(child: Text(title)),
            ],
          ),
        );
      },
    );
  }

  Future onRmSelected(bool isContains, String title, var bottomState) async {
    if (isContains)
      selectedRm.remove(title);
    else
      selectedRm.add(title);

    subBrokerList = [];
    await getAllSubBroker();
    bottomState(() {});
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

  showUserDetails(AllInvestorsPojo userData, MfSummaryPojo mfSummary) {
    String aum = Utils.formatNumber(userData.aum, isAmount: true);
    String name = userData.name ?? "null";
    int type_id = userData.typeId ?? 0;

    String invType = "null";
    if (type_id == 1) invType = "Individual";
    if (type_id == 3) invType = "Family";

    String? rmname = "";
    String? subBrokerName = "";
    if (client_name == 'nextfreedom') {
      rmname = userData.subbrokerName;
      subBrokerName = userData.rmName;
    } else {
      rmname = userData.rmName;
      subBrokerName = userData.subbrokerName;
    }

    print("userMobile ${userData.mobile}");

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: cornerBorder),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, bottomState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                BottomSheetTitle(
                    title: "", padding: EdgeInsets.only(top: 16, right: 16)),
                ListTile(
                  leading: InitialCard(
                      title:
                          (name.isNotEmpty && name[0] != "") ? name[0] : "."),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text("${userData.name}",
                            style: AppFonts.f50014Black, softWrap: true),
                      ),
                      Text(
                        "$rupee $aum",
                        style: AppFonts.f50014Black,
                      ),
                    ],
                  ),
                  subtitle: Text(invType),
                ),
                infoRow(
                    lHead: "PAN",
                    lSubHead: "${userData.pan}",
                    rHead: "Mobile",
                    rSubHead: "${userData.mobile}",
                    onTapRSubHead: () {
                      _launchPhoneDialer("${userData.mobile}");
                    },
                    phoneNumber: userData.mobile,
                    rStyle: AppFonts.f50014Theme
                        .copyWith(decoration: TextDecoration.underline)),
                infoRow(
                    lHead: "Email",
                    lSubHead: "${userData.email}",
                    onTaplSubHead: () {
                      _launchEmailClient(context, "${userData.email}");
                    },
                    email: userData.email,
                    lStyle: AppFonts.f50014Theme.copyWith(
                        color: Config.appTheme.themeColor,
                        decoration: TextDecoration.underline)),
                infoRow(lHead: "Address", lSubHead: "${userData.address}"),
                Divider(),
                infoRow(
                    lHead: "Birthday",
                    lSubHead: "${userData.dob}",
                    rHead: "Created On",
                    rSubHead: "${userData.createdDate}"),
                Divider(),
                infoRow(
                    lHead: "Branch",
                    lSubHead: "${userData.branch}",
                    rHead: "Online Code",
                    rSubHead: (userData.bseCustomer == '1' ||
                            userData.bseActive == '1' ||
                            userData.bseCustomer != '0')
                        ? "${userData.bseClientCode}"
                        : (userData.nseCustomer == '1' ||
                                userData.nseActive == '1' ||
                                userData.nseIinNumber != '0')
                            ? "${userData.nseIinNumber}"
                            : (userData.mfuCustomer == '1' ||
                                    userData.mfuActive == '1' ||
                                    userData.mfuCanNumber != '0')
                                ? "${userData.mfuCanNumber}"
                                : ""),
                infoRow(
                    lHead: "RM",
                    lSubHead: "$rmname",
                    rHead: (client_name != 'nextfreedom')
                        ? "Associate"
                        : "BM Name",
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
                            if (userData.typeId == 1)
                              await loginAsInvestor(userData);
                            else if (userData.typeId == 3)
                              await loginAsFamily(userData);
                            else
                              Utils.showError(context, "Unknown type id");
                          },
                          trailing:
                              Icon(Icons.arrow_forward, color: Colors.white),
                          bgColor: Config.appTheme.buttonColor),
                      SizedBox(height: 15),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Config.appTheme.buttonColor,
                                    width: 1.5),
                                borderRadius: BorderRadius.circular(10)),
                            width: devWidth * 0.29,
                            height: 45,
                            child: InkWell(
                              onTap: () async {
                                if (userData.aum != 0) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Download PDF",
                                            style: AppFonts.f40016.copyWith(
                                                color: Colors.black,
                                                fontSize: 20)),
                                        content: Text(
                                            "Are you sure to download the PDF?",
                                            style: AppFonts.f40016.copyWith(
                                                color:
                                                    Config.appTheme.buttonColor,
                                                fontSize: 16)),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text("Cancel",
                                                style: AppFonts.f40016.copyWith(
                                                    color: Config
                                                        .appTheme.defaultLoss,
                                                    fontSize: 16)),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              String msgUrl = "";
                                              InvestorDetails investorDetails = InvestorDetails(userId: userData.id, email: userData.email);
                                              List<InvestorDetails>investorDetailsList = [];
                                              investorDetailsList.add(investorDetails);

                                              String investor_details = jsonEncode(investorDetailsList);
                                              String userMobile = "${userData.mobile}";
                                              await getInvestorSummaryPdf(investor_details, userMobile, "download");
                                              Get.back();
                                            },
                                            child: Text("Download",
                                                style: AppFonts.f40016.copyWith(
                                                    color: Config
                                                        .appTheme.buttonColor,
                                                    fontSize: 16)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Member contains 0 value",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:
                                          Config.appTheme.themeColor,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  Get.back();
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.download_sharp,
                                    color: Config.appTheme.buttonColor,
                                    size: 18,
                                  ),
                                  SizedBox(width: 5),
                                  Text("Portfolio",
                                      style: AppFonts.f40016.copyWith(
                                          color: Config.appTheme.buttonColor,
                                          fontSize: 16)),
                                  SizedBox(width: 8),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Config.appTheme.buttonColor,
                                    width: 1.5),
                                borderRadius: BorderRadius.circular(10)),
                            width: devWidth * 0.29,
                            height: 45,
                            child: InkWell(
                              onTap: () async {
                                if (userData.aum != 0) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Send Mail",
                                            style: AppFonts.f40016.copyWith(
                                                color: Colors.black,
                                                fontSize: 20)),
                                        content: Text(
                                            "Are you sure, you want to Send the Mail?",
                                            style: AppFonts.f40016.copyWith(
                                                color:
                                                    Config.appTheme.themeColor,
                                                fontSize: 16)),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text("Cancel",
                                                style: AppFonts.f40016.copyWith(
                                                    color: Config
                                                        .appTheme.defaultLoss,
                                                    fontSize: 16)),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              String msgUrl = "";
                                              InvestorDetails investorDetails =
                                                  InvestorDetails(
                                                      userId: userData.id,
                                                      email: userData.email);
                                              List<InvestorDetails>
                                                  investorDetailsList = [];
                                              investorDetailsList
                                                  .add(investorDetails);

                                              String investor_details =
                                                  jsonEncode(
                                                      investorDetailsList);

                                              String userMobile =
                                                  "${userData.mobile}";
                                              await getInvestorSummaryPdf(
                                                  investor_details,
                                                  userMobile,
                                                  "Email");
                                              EasyLoading.dismiss();
                                              Get.back();
                                            },
                                            child: Text("Send",
                                                style: AppFonts.f40016.copyWith(
                                                    color: Config
                                                        .appTheme.themeColor,
                                                    fontSize: 16)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Member contains 0 value",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:
                                          Config.appTheme.themeColor,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  Get.back();
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.email,
                                    color: Config.appTheme.buttonColor,
                                    size: 18,
                                  ),
                                  SizedBox(width: 5),
                                  Text("Portfolio",
                                      style: AppFonts.f40016.copyWith(
                                          color: Config.appTheme.buttonColor,
                                          fontSize: 16)),
                                  SizedBox(width: 8),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Config.appTheme.buttonColor,
                                    width: 1.5),
                                borderRadius: BorderRadius.circular(10)),
                            width: devWidth * 0.29,
                            height: 45,
                            child: InkWell(
                              onTap: () async {
                                if (userData.aum != 0) {
                                  whatsappshare(userData, mfSummary, mobile);
                                  numberController = TextEditingController(text: userData.mobile);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Member contains 0 value",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:
                                          Config.appTheme.themeColor,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  Get.back();
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(width: 5),
                                  WhatsappIcon(
                                    height: 18.0,
                                    width: 18.0,
                                    color: Config.appTheme.buttonColor,
                                  ),
                                  SizedBox(width: 5),
                                  Text("Portfolio",
                                      style: AppFonts.f40016.copyWith(
                                          color: Config.appTheme.buttonColor,
                                          fontSize: 16)),
                                  SizedBox(width: 8),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        });
      },
    );
  }

  TextEditingController? numberController;

  Future<void> whatsappshare(AllInvestorsPojo userData, MfSummaryPojo mfSummary, String mobile) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Mobile Number'),
          content: TextFormField(
            maxLength: 10,
              controller: numberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                counterText: "",
                  suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => numberController?.clear(),
              ))),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel',
                  style: AppFonts.f40016.copyWith(
                      color: Config.appTheme.defaultLoss, fontSize: 16)),
            ),
            TextButton(
              onPressed: () {
                //String? phoneNumber = numberController?.text;
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Send WhatsApp Message',
                            style: AppFonts.f40016
                                .copyWith(color: Colors.black, fontSize: 20)),
                        content: Text(
                            "Are you sure, you want to Send the Message?",
                            style: AppFonts.f40016.copyWith(
                                color: Config.appTheme.themeColor,
                                fontSize: 16)),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text('Cancel',
                                style: AppFonts.f40016.copyWith(
                                    color: Config.appTheme.defaultLoss,
                                    fontSize: 16)),
                          ),
                          TextButton(
                            onPressed: () async {
                             /* String? mobile = userData.mobile ?? "";
                              print("mobile number $mobile");*/

                              String? mobile = numberController!.text;
                              await getMutualFundPortfolio(userData.id!);

                              //_sendMessage(userData.mobile!, mfSummary, userData);
                              // Inside your method where you call _sendMessage
                              await _sendMessage(mobile!, userData);
                              // print("user details ${mfSummary.totalDivReinv! + mfSummary.totalDivPaid!}");
                              Navigator.of(context).pop();
                            },
                            child: Text('Send',
                                style: AppFonts.f40016.copyWith(
                                    color: Config.appTheme.themeColor,
                                    fontSize: 16)),
                          ),
                        ],
                      );
                    });
              },
              child: Text('Confirm',
                  style: AppFonts.f40016.copyWith(
                      color: Config.appTheme.themeColor, fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendMessage(String phoneNumber,  AllInvestorsPojo userData) async {
    print("whats app message $phoneNumber");
    await getWhatsappShareLink(user_id: userData.id!);

    await getMutualFundPortfolio(userData.id!);
   // await getMutualFundPortfolio(userData.id!);


    final value = Utils.formatNumber(mfSummary.totalCurrValue ?? 0);
    final cost = Utils.formatNumber(mfSummary.totalCurrCost ?? 0);
    final gain = Utils.formatNumber(mfSummary.totalUnrealisedGain ?? 0);
    final regain = Utils.formatNumber(mfSummary.totalRealisedGain ?? 0);
    final totalDivReinv = Utils.formatNumber(mfSummary.totalDivReinv ?? 0);
    final totalDivPaidt = Utils.formatNumber(mfSummary.totalDivPaid ?? 0);
    final totalXirr = Utils.formatNumber(mfSummary.totalXirr ?? 0);

    print("Formatted values: value=$value, cost=$cost, gain=$gain, regain=$regain, totalDivReinv=$totalDivReinv, totalDivPaidt=$totalDivPaidt, totalXirr=$totalXirr");

    // Generate the WhatsApp message content
    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    var websiteUrl = '''Dear ${userData.name?.toUpperCase()},

Greetings for the Day!

Below 👇 is the snapshot of your Mutual Fund Investments as on $formattedDate

📌 *Current Cost : Rs $cost*
📌 *Current Value : Rs $value*
📌 *Dividend Paid : Rs $totalDivPaidt*
📌 *Dividend Reinvestment : Rs $totalDivReinv*
📌 *Unrealized Gain/Loss : Rs $gain*
📌 *Realized Gain/Loss : Rs $regain*
📌 *XIRR : $totalXirr%*

To view the detailed portfolio, please login using the link below.
$shareURl

Please call us for more details.

Assuring you of our best services always!

*Thank you!*
${client_name.toUpperCase()}''';

    var whatsappUrl =
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(websiteUrl)}";
    print("Generated WhatsApp URL: $whatsappUrl");

    // Check if the WhatsApp URL can be launched
    if (await canLaunch(whatsappUrl) != null) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  Future<void> loginAsInvestor(AllInvestorsPojo userData) async {
    await GetStorage().write("adminAsInvestor", userData.id);
    await GetStorage().write("user_id", userData.id);
    await GetStorage().write("user_name", userData.name);
    await GetStorage().write("user_pan", userData.pan);
    await GetStorage().write("user_mobile", userData.mobile);
    await GetStorage().write('user_email', userData.email);

    Get.offAll(() => CheckUserType());
  }

  Future<void> loginAsFamily(AllInvestorsPojo familyHead) async {
    await GetStorage().write("adminAsFamily", familyHead.id);
    await GetStorage().write("family_id", familyHead.id);
    await GetStorage().write("family_name", familyHead.name);
    await GetStorage().write("family_pan", familyHead.pan);
    await GetStorage().write("family_mobile", familyHead.mobile);

    Get.offAll(() => CheckUserType());
  }

  Widget infoRow({
    required String lHead,
    required String lSubHead,
    TextStyle? lStyle,
    String rHead = "",
    String rSubHead = "",
    TextStyle? rStyle,
    void Function()? onTapRSubHead,
    void Function()? onTaplSubHead,
    String? phoneNumber,
    String? email,
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
              GestureDetector(
                  onTap: onTaplSubHead,
                  child: Text(lSubHead, style: lStyle ?? AppFonts.f50014Black)),
            ],
          )),
          Visibility(
            visible: rHead.isNotEmpty,
            child: Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rHead),
                //Text(rHead),
                GestureDetector(
                    onTap: onTapRSubHead,
                    child:
                        Text(rSubHead, style: rStyle ?? AppFonts.f50014Black)),
                // GestureDetector(
                //     onTap: () {
                //       if (phoneNumber != null && phoneNumber.isNotEmpty) {
                //         _launchPhoneDialer(phoneNumber);
                //       }
                //     },
                //     child:
                //         Text(rSubHead, style: rStyle ?? AppFonts.f50014Black)),
              ],
            )),
          ),
        ],
      ),
    );
  }

  void _launchPhoneDialer(String phoneNumber) async {
    final Uri _phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      await launchUrl(_phoneUri);
    } catch (e) {
      EasyLoading.showError("Could not launch $phoneNumber = $e");
    }
  }

  void _launchEmailClient(BuildContext context, String email) async {
    print("email $email");
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: <String, String>{
        'subject': '',
        'body': '',
      },
    );

    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      EasyLoading.showError("Could not open email client $email = $e");
    }
  }

  // Future<void> requestStoragePermission() async {
  //   if (Platform.isAndroid) {
  //     var status = await Permission.storage.request();
  //     // if (!status.isGranted) {
  //     //   Fluttertoast.showToast(msg: "Storage permission required.");
  //     //   return;
  //     // }
  //   }
  // }
  Future<void> rpDownloadFile(
      {required String url, required BuildContext context}) async {
    // await requestStoragePermission();

    EasyLoading.show(status: 'loading...');
    Dio dio = Dio();

    Directory? dir = await getExternalStorageDirectory() ??
        await getApplicationDocumentsDirectory();
    if (dir == null) {
      Fluttertoast.showToast(msg: "Failed to get storage directory.");
      return;
    }

    print("Download Directory: ${dir.path}");
    String dirloc = dir.path;

    String fileName = url.substring(url.lastIndexOf("/") + 1);
    String filePath = "$dirloc/$fileName";

    try {
      await dio.download(url, filePath);
      EasyLoading.dismiss();

      final result = await OpenFile.open(filePath);
      Fluttertoast.showToast(
        msg: result.message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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
