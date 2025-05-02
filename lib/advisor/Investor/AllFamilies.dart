import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/login/CheckUserType.dart';
import 'package:mymfbox2_0/pojo/FamilyDataPojo.dart';
import 'package:mymfbox2_0/pojo/MfSchemeSummaryPojo.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
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
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../api/ApiConfig.dart';
import '../../api/InvestorApi.dart';
import '../../api/ReportApi.dart';
import '../../pojo/AllInvestorsPojo.dart';
import '../../pojo/MfSummaryPojo.dart';
import '../../pojo/familyCurrentPortfolioPojo.dart';
import 'AllInvestor.dart';

class AllFamilies extends StatefulWidget {
  const AllFamilies({super.key, required this.totalFamilies});

  final num totalFamilies;

  @override
  State<AllFamilies> createState() => _AllFamiliesState();
}

class _AllFamiliesState extends State<AllFamilies> {
  int user_id = GetStorage().read("mfd_id");
  String client_name = GetStorage().read("client_name");
  String mobile = GetStorage().read("mfd_mobile");
  int type_id = GetStorage().read("type_id");

  List<ExpansionTileController> exControler = [];
  int selectedTile = -1;
  bool isLoading = true;
  int page_id = 1;

  String searchKey = "";

  num totalCount = 0, totalAum = 0;
  List investorList = [];

  Future getInitialInvestors() async {
    page_id = 1;

    String tempSort = selectedSort;
    if (selectedSort.contains("Alphabet")) {
      tempSort = selectedSort.replaceAll("-", ""); //Alphabet AZ
      tempSort = tempSort.replaceAll(" ", "-"); //Alphabet-AZ
    }

    Map data = await AdminApi.getAllFamilies(
      page_id: page_id,
      client_name: client_name,
      user_id: user_id,
      search: searchKey,
      sortby: tempSort,
      branch: selectedBranch.join(","),
      rmList: selectedRm.join(","),
      subbroker_name: selectedSubBroker.join(","),
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    totalCount = data['total_count'] ?? 0;
    totalAum = data['total_aum'];
    investorList = data['list'];
    isLoading = false;

    return 0;
  }

  String formatDate(DateTime date) {
    String day =
        date.day.toString().padLeft(2, '0'); // Ensure two digits for day
    String month =
        date.month.toString().padLeft(2, '0'); // Ensure two digits for month
    String year = date.year.toString(); // Year
    return '$day-$month-$year'; // Return formatted date
  }

  MfSummary mfSummary = MfSummary();
  List<FamilyCurrentPortfolioPojo> schemeList = [];
  List<MfSchemeSummary> mfSchemeSummaryList = [];
  DateTime selectedFolioDate = DateTime.now();
  String selectedFolioType = "Live";

  Future<void> getfamilyCurrentPortfolio(int faminvestorId) async {
    if (schemeList.isNotEmpty) {
      print("Scheme list is not empty, skipping API call.");
      return;
    }

    String formattedDate = formatDate(selectedFolioDate);
    Map data = await ReportApi.familyCurrentPortfolio(
      user_id: faminvestorId,
      client_name: client_name,
      folio_type: selectedFolioType,
      selected_date: formattedDate,
    );

    if (data['status'] != 200) {
      print("Error: ${data['msg']}");
      Utils.showError(context, data['msg']);
      return;
    }
    mfSummary = MfSummary.fromJson(data['mf_summary']);
    List mflist = data['mf_scheme_summary'];
    convertListToObj(mflist);

    //
  }

  void convertListToObj(List mflist) {
    mfSchemeSummaryList =
        mflist.map((item) => MfSchemeSummary.fromJson(item)).toList();
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

    Map data = await AdminApi.getAllFamilies(
      page_id: page_id,
      client_name: client_name,
      user_id: user_id,
      search: searchKey,
      sortby: tempSort,
      branch: selectedBranch.join(","),
      rmList: selectedRm.join(","),
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

  @override
  void initState() {
    //  implement initState
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
            appBar: adminAppBar(title: "All Families", bgColor: Colors.white),
            body: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SearchField(
                    hintText: "Search Family",
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
            Text("${investorList.length} of ${widget.totalFamilies} Items",
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
                  FamilyDataPojo familyData = FamilyDataPojo.fromJson(data);

                  return InkWell(
                    onTap: () async {
                      Map data = await AdminApi.getFamilyDetails(
                          user_id: familyData.id ?? 0,
                          client_name: client_name);
                      if (data['status'] != 200) {
                        Utils.showError(context, "${data['msg']}");
                        return;
                      }
                      Map summary = data['summary'];
                      num currValue = summary['family_curr_value'];
                      List temp = data['members'];
                      List<FamilyDataPojo> members = [];

                      temp.forEach((element) {
                        members.add(FamilyDataPojo.fromJson(element));
                      });

                      FamilyDataPojo familyHead = FamilyDataPojo();
                      members.forEach((element) {
                        if (element.name == summary['family_head_name'])
                          familyHead = element;
                      });

                      showFamilyMembers(
                        members: members,
                        familyHead: familyHead,
                        curValue: Utils.formatNumber(currValue, isAmount: true),
                      );
                    },
                    child: RpListTile2(
                        leading: InitialCard(title: "${familyData.name}"),
                        l1: "${familyData.name}",
                        l2: "${familyData.familyMemberCount} Members",
                        r1: "$rupee ${Utils.formatNumber(familyData.currentValue, isAmount: true)}",
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

  showFamilyMembers(
      {required List<FamilyDataPojo> members,
      required FamilyDataPojo familyHead,
      required String curValue}) {
    String? rmName = "";
    String? subBrokerName = "";
    int faminvestorId = familyHead.id ?? 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Config.appTheme.mainBgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (context) {
        return StatefulBuilder(builder: (context, bottomState) {
          return SizedBox(
            // height: (isExpanded) ? devHeight * 0.9 : devHeight * 0.6,
            height: devHeight * 0.9,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.close))
                      ],
                    ),
                  ),
                  ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(),
                    title: Text("${members.length} Members"),
                    trailing: SizedBox(
                        width: 110,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("$rupee $curValue",
                                style: AppFonts.f50014Black),
                          ],
                        )),
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    itemCount: members.length,
                    shrinkWrap: true,
                    key: Key("builder $selectedTile"),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      FamilyDataPojo memberData = members[index];
                      String name = memberData.name ?? "null";
                      String relation = memberData.relation ?? "null";
                      /*relation = (relation.isEmpty)
                          ? "Family Member"
                          : "Member - $relation";*/
                      relation = "$relation";

                      String currValue = Utils.formatNumber(
                          memberData.currentValue,
                          isAmount: true);

                      if (client_name == 'nextfreedom') {
                        rmName = memberData.subBrokerName;
                        subBrokerName = memberData.rmName;
                      } else {
                        rmName = memberData.rmName;
                        subBrokerName = memberData.subBrokerName;
                      }

                      return Padding(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                        child: ExpansionTile(
                          key: Key(index.toString()),
                          initiallyExpanded: index == selectedTile,
                          onExpansionChanged: (val) {
                            if (val) {
                              selectedTile = index;
                            } else {
                              selectedTile = -1;
                            }

                            bottomState(() {});
                          },
                          collapsedBackgroundColor: Colors.white,
                          backgroundColor: Colors.white,
                          collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          leading: InitialCard(size: 32, title: name[0]),
                          tilePadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          title: Text(Utils.getFirst13(name, count: 20),
                              style: AppFonts.f50014Black),
                          subtitle: Text(relation),
                          childrenPadding: EdgeInsets.only(bottom: 16),
                          trailing: SizedBox(
                            width: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("$rupee $currValue",
                                    style: AppFonts.f50014Black),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_forward_ios,
                                    size: 15, color: Colors.grey)
                              ],
                            ),
                          ),
                          children: [
                            infoRow(
                                lHead: "PAN",
                                lSubHead: "${memberData.pan}",
                                rHead: "Mobile",
                                rSubHead: "${memberData.mobile}",
                                rStyle: AppFonts.f50014Theme.copyWith(
                                    decoration: TextDecoration.underline)),
                            infoRow(
                                lHead: "Email",
                                lSubHead: "${memberData.email}",
                                lStyle: AppFonts.f50014Theme.copyWith(
                                    color: Config.appTheme.themeColor,
                                    decoration: TextDecoration.underline)),
                            infoRow(
                                lHead: "Address",
                                lSubHead: "${memberData.address}"),
                            Divider(),
                            infoRow(
                                lHead: "Birthday",
                                lSubHead: "${memberData.dob}",
                                rHead: "Created On",
                                rSubHead: "${memberData.createdOn}"),
                            Divider(),
                            infoRow(
                                lHead: "Branch",
                                lSubHead: "${memberData.branch}"),
                            infoRow(
                                lHead: "RM",
                                lSubHead: "$rmName",
                                rHead: (client_name != 'nextfreedom')
                                    ? "Associate"
                                    : "BM Name",
                                rSubHead: "$subBrokerName"),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  rectButton(memberData),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                          onTap: () async {
                                            if (memberData.currentValue != 0) {
                                              String msgUrl = "";
                                              InvestorDetails investorDetails =
                                                  InvestorDetails(
                                                      userId: memberData.id,
                                                      email: memberData.email);
                                              List<InvestorDetails>
                                                  investorDetailsList = [];
                                              investorDetailsList
                                                  .add(investorDetails);

                                              String investor_details =
                                                  jsonEncode(
                                                      investorDetailsList);

                                              String url =
                                                  "${ApiConfig.apiUrl}/investor/download/getInvestorSummaryPdf?key=${ApiConfig.apiKey}"
                                                  "&investor_details=$investor_details&mobile=${memberData.mobile}&type=Download&client_name=$client_name";
                                              EasyLoading.show();
                                              http.Response response =
                                                  await http
                                                      .post(Uri.parse(url));
                                              msgUrl = response.body;
                                              Map data = jsonDecode(msgUrl);
                                              String resUrl = data['msg'];
                                              print("download $url");
                                              rpDownloadFile(
                                                  url: resUrl,
                                                  context: context);
                                              EasyLoading.dismiss();
                                              Get.back();
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Member contains 0 value",
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Config
                                                      .appTheme.themeColor,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                              Get.back();
                                            }
                                          },
                                          child: Text(
                                            "Download Portfolio",
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                color:
                                                    Config.appTheme.buttonColor,
                                                decorationColor:
                                                    Config.appTheme.buttonColor),
                                          )),
                                      GestureDetector(
                                          onTap: () async {
                                            if (memberData.currentValue != 0) {
                                              String msgUrl = "";
                                              InvestorDetails investorDetails =
                                                  InvestorDetails(
                                                      userId: memberData.id,
                                                      email: memberData.email);
                                              List<InvestorDetails>
                                                  investorDetailsList = [];
                                              investorDetailsList
                                                  .add(investorDetails);

                                              String investor_details =
                                                  jsonEncode(
                                                      investorDetailsList);

                                              String url =
                                                  "${ApiConfig.apiUrl}/investor/download/getInvestorSummaryPdf?key=${ApiConfig.apiKey}"
                                                  "&investor_details=$investor_details&mobile=${memberData.mobile}&type=Email&client_name=$client_name";

                                              http.Response response =
                                                  await http
                                                      .post(Uri.parse(url));
                                              msgUrl = response.body;
                                              Map data = jsonDecode(msgUrl);
                                              String resUrl = data['msg'];
                                              print("email $url");
                                              rpDownloadFile(
                                                  url: resUrl,
                                                  context: context);
                                              Get.back();
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Member contains 0 value",
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Config
                                                      .appTheme.themeColor,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                              Get.back();
                                            }
                                          },
                                          child: Text(
                                            "Email Portfolio",
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                color:
                                                    Config.appTheme.buttonColor,
                                                decorationColor:
                                                    Config.appTheme.buttonColor),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: devHeight * 0.05),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      children: [
                        RectButton(
                            leading: "assets/bulletList.png",
                            imgSize: 20,
                            title: "View Dashboard",
                            fgColor: Colors.white,
                            onPressed: () async {
                              await loginAsFamily(familyHead);
                            },
                            trailing:
                                Icon(Icons.arrow_forward, color: Colors.white),
                            bgColor: Config.appTheme.buttonColor),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              child: GestureDetector(
                                  onTap: () async {
                                    if (curValue != "0") {
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
                                                    color: Config
                                                        .appTheme.themeColor,
                                                    fontSize: 16)),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text("Cancel",
                                                    style: AppFonts.f40016
                                                        .copyWith(
                                                            color: Config.appTheme.defaultLoss,
                                                            fontSize: 16)),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  String msgUrl = "";

                                                  InvestorDetails
                                                      investorDetails =
                                                      InvestorDetails(
                                                          userId: familyHead.id,
                                                          email:
                                                              familyHead.email);
                                                  List<InvestorDetails>
                                                      investorDetailsList = [];
                                                  investorDetailsList
                                                      .add(investorDetails);

                                                  String investor_details =
                                                      jsonEncode(
                                                          investorDetailsList);

                                                  String url =
                                                      "${ApiConfig.apiUrl}/admin/family/getFamilySummary?key=${ApiConfig.apiKey}"
                                                      "&investor_details=$investor_details&mobile=${familyHead.mobile}&type=Download&client_name=$client_name";

                                                  EasyLoading.show();
                                                  http.Response response =
                                                      await http
                                                          .post(Uri.parse(url));
                                                  msgUrl = response.body;
                                                  Map data = jsonDecode(msgUrl);
                                                  String resUrl = data['msg'];
                                                  print("download $url");
                                                  rpDownloadFile(
                                                      url: resUrl,
                                                      context: context);
                                                  print("download $resUrl");
                                                  EasyLoading.dismiss();
                                                  Get.back();
                                                },
                                                child: Text("Download",
                                                    style: AppFonts.f40016
                                                        .copyWith(color: Config.appTheme.buttonColor, fontSize: 16)),
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
                                  )),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Config.appTheme.buttonColor,
                                      width: 1.5),
                                  borderRadius: BorderRadius.circular(10)),
                              width: devWidth * 0.29,
                              height: 45,
                              child: GestureDetector(
                                  onTap: () async {
                                    if (curValue != "0") {
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
                                                    color: Config
                                                        .appTheme.themeColor,
                                                    fontSize: 16)),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text("Cancel",
                                                    style: AppFonts.f40016
                                                        .copyWith(
                                                            color: Config
                                                                .appTheme
                                                                .defaultLoss,
                                                            fontSize: 16)),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  String msgUrl = "";
                                                  InvestorDetails
                                                      investorDetails =
                                                      InvestorDetails(
                                                          userId: familyHead.id,
                                                          email:
                                                              familyHead.email);
                                                  List<InvestorDetails>
                                                      investorDetailsList = [];
                                                  investorDetailsList
                                                      .add(investorDetails);

                                                  String investor_details =
                                                      jsonEncode(
                                                          investorDetailsList);

                                                  String url =
                                                      "${ApiConfig.apiUrl}/admin/family/getFamilySummary?key=${ApiConfig.apiKey}"
                                                      "&investor_details=$investor_details&mobile=${familyHead.mobile}&type=Email&client_name=$client_name";

                                                  http.Response response =
                                                      await http
                                                          .post(Uri.parse(url));
                                                  msgUrl = response.body;
                                                  Map data = jsonDecode(msgUrl);
                                                  String resUrl = data['msg'];
                                                  print("email $url");
                                                  print("email $resUrl");
                                                  print("API ${ApiConfig.apiKey}");
                                                  EasyLoading.dismiss();
                                                  Get.back();
                                                  Fluttertoast.showToast(
                                                      msg: resUrl,
                                                      toastLength: Toast.LENGTH_LONG,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: Config.appTheme.themeColor,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);

                                                },
                                                child: Text("Send",
                                                    style: AppFonts.f40016
                                                        .copyWith(
                                                            color: Config
                                                                .appTheme
                                                                .themeColor,
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
                                    ;
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
                                  )),
                            ),
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
                                  if (curValue != "0") {
                                    String? mobile = familyHead.mobile ?? "";
                                    print("mobile number $mobile");

                                    await getfamilyCurrentPortfolio(
                                        faminvestorId);
                                    numberController =
                                        TextEditingController(text: mobile);
                                    whatsappshare(familyHead, mobile);
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
                                    WhatsappIcon(
                                        height: 18.0,
                                        width: 18.0,
                                        color: Config.appTheme.buttonColor),
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
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  TextEditingController? numberController;

  Future<void> whatsappshare(FamilyDataPojo familyHead, String mobile) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Mobile Number'),
          content: TextFormField(
              controller: numberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () => numberController?.clear(),
              ))),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                showDialog<void>(
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
                          onPressed: () {
                            String? mobile = numberController!.text;
                            _sendMessage(
                                familyHead, mobile, mfSummary, mfSchemeSummaryList);
                            Get.back();
                          },
                          child: Text('Send',
                              style: AppFonts.f40016.copyWith(
                                  color: Config.appTheme.themeColor,
                                  fontSize: 16)),
                        ),
                      ],
                    );
                  },
                );
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

  // String value = "";
  // String cost = "",
  //     gain = "",
  //     regain = "",
  //     totalDivReinv = "",
  //     totalDivPaidt = "",
  //     date = "";
  // num xirr = 0;

  String shareURl = "";

  Future getWhatsappShareLink({required int faminvestorId}) async {
    Map data = await InvestorApi.getWhatsappShareLink(
        user_id: faminvestorId, client_name: client_name);
    shareURl = data['msg'];
    print("ALL Family share url $shareURl");
    return 0;
  }

  Future<void> _sendMessage(FamilyDataPojo familyHead, String mobile,
      MfSummary mfSummary, List<MfSchemeSummary> mfSchemeSummary) async {
    String value = Utils.formatNumber(mfSummary.totalCurrValue ?? 0);
    String cost = Utils.formatNumber(mfSummary.totalCurrCost ?? 0);
    String unrealgain = Utils.formatNumber(mfSummary.totalUnrealisedGain ?? 0);
    String realgain = Utils.formatNumber(mfSummary.totalRealisedGain ?? 0);
    String AbsRtn = Utils.formatNumber(mfSummary.totalAbsRtn ?? 0);

    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    // Accumulate scheme details
    String schemeDetails = '';
    for (var scheme in mfSchemeSummary) {
      final investorName = scheme.investorName ?? '';
      final currentCost = Utils.formatNumber(scheme.currentCost ?? 0);
      final currentValue = Utils.formatNumber(scheme.currentValue ?? 0);
      final unrealisedGain = Utils.formatNumber(scheme.unrealisedGain ?? 0);
      final realisedGain = Utils.formatNumber(scheme.realisedGain ?? 0);
      final absRtn = Utils.formatNumber(scheme.absRtn ?? 0.0);
      final xirr = Utils.formatNumber(scheme.xirr ?? 0.0);

      // 📌 *Realized Gain/Loss : RS.$realisedGain*
      // 📌 *Realized Gain/Loss : RS.$realgain*
      schemeDetails += '''
      
  *$investorName*

📌 *Current Cost : Rs $currentCost*
📌 *Current Value : Rs $currentValue*
📌 *Unrealized Gain/Loss : Rs $unrealisedGain*
📌 *Absolute Return : $absRtn%*
📌 *XIRR : $xirr%*     
''';
    }
    int faminvestorId = familyHead.id ?? 0;
    await getWhatsappShareLink(faminvestorId: faminvestorId);

    String websiteUrl = '''Dear ${familyHead.name?.toUpperCase()},
    
Greetings for the Day!

Below 👇 is the snapshot of your Mutual Fund Investments as on $formattedDate

*Family's Total*

📌 *Current Cost : Rs $cost*
📌 *Current Value : Rs $value*
📌 *Unrealized Gain/Loss : Rs $unrealgain*
📌 *Absolute Return : $AbsRtn%*
$schemeDetails
To view the detailed portfolio, please login using the link below.
$shareURl

Please call us for more details.

Assuring you of our best services always!

*Thank you!*
${client_name.toUpperCase()}''';

    var whatsappUrl =
        "https://wa.me/$mobile?text=${Uri.encodeComponent(websiteUrl)}";
    print("Generated WhatsApp URL: $whatsappUrl");
    if (await canLaunch(whatsappUrl) != null) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  Future<void> loginAsFamily(FamilyDataPojo familyHead) async {
    await GetStorage().write("adminAsFamily", familyHead.id);
    await GetStorage().write("family_id", familyHead.id);
    await GetStorage().write("family_name", familyHead.name);
    await GetStorage().write("family_pan", familyHead.pan);
    await GetStorage().write("family_mobile", familyHead.mobile);
    Get.offAll(() => CheckUserType());
  }

  TextStyle underlineText = TextStyle(
      color: Config.appTheme.themeColor, decoration: TextDecoration.underline);

  Widget rectButton(FamilyDataPojo member) {
    return InkWell(
      onTap: () async {
        await GetStorage().write("adminAsInvestor", member.id);
        await GetStorage().write("user_id", member.id);
        await GetStorage().write("user_name", member.name);
        await GetStorage().write("user_pan", member.pan);
        await GetStorage().write("user_mobile", member.mobile);
        Get.offAll(() => CheckUserType());
      },
      child: Container(
        width: devWidth,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Config.appTheme.buttonColor)),
        child: Center(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Image.asset("assets/bulletList.png",
                  height: 20, color: Config.appTheme.buttonColor,),
              SizedBox(width: 10),
              Text("View Dashboard",
                  style: TextStyle(
                      color: Config.appTheme.buttonColor,
                      fontWeight: FontWeight.w500)),
              Spacer(),
              Icon(Icons.arrow_forward, color: Config.appTheme.buttonColor)
            ],
          ),
        )),
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

  Widget button(String text,
      {Color bgColor = Colors.white, Color? fgColor, Function()? onTap}) {
    fgColor ??= Config.appTheme.themeColor;
    return Container(
      decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: Config.appTheme.themeColor, width: 1.5),
          borderRadius: BorderRadius.circular(10)),
      width: devWidth * 0.3,
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
