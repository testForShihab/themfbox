import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/advisor/CAS_Upload/TransactionSummary.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/pojo/FamilyDataPojo.dart';
import 'package:mymfbox2_0/pojo/FamilyXirrResponse.dart';
import 'package:mymfbox2_0/pojo/InvestmentSummaryPojo.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/NoData.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import '../../api/ReportApi.dart';

class FamilyXirrReport extends StatefulWidget {
  const FamilyXirrReport({super.key});

  @override
  State<FamilyXirrReport> createState() => _FamilyXirrReportState();
}

class _FamilyXirrReportState extends State<FamilyXirrReport> {
  late double devWidth, devHeight;
  int user_id = getUserId();
  String client_name = GetStorage().read("client_name");
  String user_name = GetStorage().read("user_name") ?? "";
  bool isLoading = true;
  var name = GetStorage().read("family_name");
  num? currentValue;
  num? currentCost;
  String family_head = "";

  List<Color> colorList = [
    Colors.purple,
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.red,
  ];

  List summaryView = [
    {
      'initial': "F",
      'title': "Purchase",
      'color': Color(0xFF5DB25D),
      'key': "total_purchase"
    },
    {
      'initial': "G",
      'title': "Redemption",
      'color': Color(0xFF5DB25D),
      'key': "total_switch_in"
    },
    {
      'initial': "H",
      'title': "Dividend Pay",
      'color': Color(0xFFE79C23),
      'key': "total_switch_out"
    },
  ];
  Map reportActionData = {
    "Download PDF Report ": ["", "", "assets/pdf.png"],
    "Download Excel Report": ["", "", "assets/excel.png"],
  };
  List membersList = ["Family"];
  String selectedType = "Family";

  DateTime selectedFolioDate = DateTime.now();
  FamilyXirrResponse familyXirrResponse = FamilyXirrResponse();
  List<FamilyList> familyList = [];
  List investorSchemeWisePortfolioResponses = [];

  int page_id = 1;
  ScrollController scrollController = ScrollController();
  bool investorFetching = false;

  ExpansionTileController nameController = ExpansionTileController();
  TextEditingController familyNameController = TextEditingController();
  String familyName = 'Search and Select Investor';
  String familyPan = "";
  List investorList = [];
  String searchKey = "";
  Timer? searchOnStop;
  int investorId = 0;

  String selectedInvestor = "";
  bool isPageLoad = true;
  num totalInvCost = 0;

  DateTime selectedStartDate = DateTime.now().subtract(Duration(days: 1));
  DateTime selectedEndDate = DateTime.now().subtract(Duration(days: 1));
  ExpansionTileController startDatecontroller = ExpansionTileController();
  ExpansionTileController endDateController = ExpansionTileController();
  List<FamilyDataPojo> familyData = [];

  Future getDatas() async {
    isLoading = true;
    await getIntialFamily();
    // await fetchMoreInvestor();
    //await getFamilyXIRR();
    isLoading = false;
    return 0;
  }

  Future searchInvestor(StateSetter bottomState) async {
    investorList = [];
    EasyLoading.show(status: "Searching for `$searchKey`");
    Map data = await AdminApi.getAllFamilies(
      page_id: page_id,
      client_name: client_name,
      user_id: user_id,
      search: searchKey,
      sortby: "",
    );
    EasyLoading.dismiss();

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    List list = data['list'];
    bottomState(() {
      investorList = List.from(list);
    });
    return 0;
  }

  Future fetchMoreInvestor() async {
    page_id++;
    Map data = await AdminApi.getAllFamilies(
      page_id: page_id,
      client_name: client_name,
      user_id: user_id,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    List list = data['list'];

    investorList.addAll(list);
    investorList = investorList.toSet().toList();
    setState(() {});
    return 0;
  }

  bool isFirst = true;

  Future getIntialFamily() async {
    if (!isFirst) return 0;

    Map data = await AdminApi.getAllFamilies(
      page_id: page_id,
      client_name: client_name,
      user_id: user_id,
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    investorList = data['list'];
    isFirst = false;
    return 0;
  }

  convertListToObj(List list) {
    list.forEach((element) {
      investorList.add(FamilyDataPojo.fromJson(element));
    });
  }

  searchHandler(StateSetter bottomState) {
    const duration = Duration(milliseconds: 1000);
    if (searchOnStop != null) {
      setState(() {
        searchOnStop!.cancel();
      });
    }
    setState(() {
      searchOnStop = Timer(duration, () async {
        await searchInvestor(bottomState);
      });
    });
  }

  formatDate(DateTime dt) {
    return DateFormat("dd-MM-yyyy").format(dt);
  }

  Future getFamilyXIRR() async {
    if (totalInvCost != 0) return 0;

    Map<String, dynamic> data = await AdminApi.getFamilyXIRR(
      user_id: investorId,
      client_name: client_name,
      pan: familyPan,
      name: familyName,
      start_date: formatDate(selectedStartDate),
      end_date: formatDate(selectedEndDate),
      option: 'All',
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    totalInvCost = data['total_inv_cost'] ?? 0;
    familyXirrResponse = FamilyXirrResponse.fromJson(data);
    familyList = familyXirrResponse.list ?? [];
    // investorSchemeWisePortfolioResponses = data["list"]["investorSchemeWisePortfolioResponses"];
    getFamilyMemberList();
    return 0;
  }

  getFamilyMemberList() {
    membersList = ["Family"];
    familyXirrResponse.list?.forEach((element) {
      membersList.add(element.investorName);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: AppBar(
              leading: SizedBox(),
              leadingWidth: 0,
              backgroundColor: Config.appTheme.themeColor,
              foregroundColor: Colors.white,
              title: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_back),
                    SizedBox(width: 10),
                    Text("Point to Point Family XIRR \nReport",
                        style: AppFonts.appBarTitle),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          showCustomizedSummaryBottomSheet();
                        },
                        child: Icon(Icons.filter_alt_outlined)),
                    SizedBox(width: 12),
                    GestureDetector(
                        onTap: () {
                          showReportActionBottomSheet();
                        },
                        child: Icon(Icons.pending_outlined)),
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: getBody(),
            ),
          );
        });
  }

  Widget getBody() {
    if (investorId == 0) return initialContainer();
    if (totalInvCost == 0 && investorId != 0) return NoData();
    return contentContainer();
  }

  getKeyByValue(Map map, String value) {
    return map.keys.firstWhere((element) => map[element] == value);
  }

  ExpansionTileController portfolioDateController = ExpansionTileController();

  showCustomizedSummaryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (_, bottomState) {
          return Container(
            height: devHeight * 0.93,
            decoration: BoxDecoration(
              color: Config.appTheme.mainBgColor,
              borderRadius: cornerBorder,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BottomSheetTitle(title: 'Customize Report'),
                  SizedBox(height: 10),
                  investorSearchCard(context, bottomState),
                  SizedBox(height: 16),
                  startDateExpansionTile(context, bottomState),
                  endDateExpansionTile(context, bottomState),
                  SizedBox(height: 16),
                  buttonCard(),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget initialContainer() {
    return Center(
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please click the filter button and select the input to get the results.",
              style: AppFonts.f40013.copyWith(
                color: Config.appTheme.themeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget contentContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Config.appTheme.themeColor,
          child: Column(
            children: [
              // topArea(),
              middleArea(),
            ],
          ),
        ),
        SizedBox(height: 16),
        tabbutton(),
        SizedBox(height: 16),
        countArea(),
        SizedBox(height: 4),
        bottomArea(),
      ],
    );
  }

  Widget tabbutton() {
    return Container(
      height: devHeight* 0.06,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: membersList.length,
        itemBuilder: (context, index) {
          String type = membersList[index];

          if (selectedType == type)
            return getButton(text: type, type: ButtonType.filled);
          return getButton(text: type, type: ButtonType.plain);
        },
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(width: 16),
      )
    );
  }

  Widget investorSearchCard(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          controller: nameController,
          title: Text("Family Head", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(familyName,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Config.appTheme.themeColor)),
              DottedLine(),
            ],
          ),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: TextFormField(
                controller: familyNameController,
                onChanged: (val) {
                  searchKey = val;
                  searchHandler(bottomState);
                },
                decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.search,
                      color: Config.appTheme.themeColor,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(10, 2, 12, 2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 170,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: investorList.length,
                    itemBuilder: (context, index) {
                      String name = investorList[index]['name'];
                      String fpan = investorList[index]['pan'];
                      int id = investorList[index]['id'];

                      return InkWell(
                        onTap: () {
                          familyName = name;
                          familyPan = fpan;
                          investorId = id;
                          familyNameController.text = familyName;
                          print("family name $familyName");
                          print("family pan $familyPan");
                          print("family id $investorId");
                          // nameController.collapse();
                          bottomState(() {});
                        },
                        child: ListTile(
                          leading:
                              InitialCard(title: (name == "") ? "." : name),
                          title: Text(name),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () async {
                if (searchKey.isNotEmpty) return;

                EasyLoading.show();
                await fetchMoreInvestor();
                bottomState(() {});
                EasyLoading.dismiss();
              },
              child: Text(
                "Load More Results",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Config.appTheme.themeColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget startDateExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: startDatecontroller,
            title: Text("Start Date", style: AppFonts.f50014Black),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Utils.getFormattedDate(date: selectedStartDate),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Config.appTheme.themeColor)),
              ],
            ),
            children: [
              SizedBox(
                height: 200,
                child: ScrollDatePicker(
                  selectedDate: selectedStartDate,
                  maximumDate: DateTime.now().subtract(Duration(days: 1)),
                  onDateTimeChanged: (value) {
                    selectedStartDate = value;
                    bottomState(() {});
                  },
                ),
              ),
            ],
          )),
    );
  }

  Widget endDateExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: endDateController,
            title: Text("End Date", style: AppFonts.f50014Black),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Utils.getFormattedDate(date: selectedEndDate),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Config.appTheme.themeColor)),
              ],
            ),
            children: [
              SizedBox(
                height: 200,
                child: ScrollDatePicker(
                  selectedDate: selectedEndDate,
                  maximumDate: DateTime.now().subtract(Duration(days: 1)),
                  onDateTimeChanged: (value) {
                    selectedEndDate = value;
                    bottomState(() {});
                    setState(() {});
                  },
                ),
              ),
            ],
          )),
    );
  }

  Widget buttonCard() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: 45,
        child: ElevatedButton(
          onPressed: () async {
            if (investorId == 0) {
              Utils.showError(context, "Please Select the Investor");
              return;
            }

            selectedInvestor = familyName;
            print("investorName $familyName");
            print("pan $familyPan");

            isPageLoad = false;
            EasyLoading.show();
            totalInvCost = 0;
            await getFamilyXIRR();
            EasyLoading.dismiss();
            setState(() {});
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Config.appTheme.themeColor,
            foregroundColor: Colors.white,
          ),
          child: Text("SUBMIT"),
        ),
      ),
    );
  }

  Map folioMap = {
    "Live Folios": "Live",
    "All Folios": "All",
    "Non segregated Folios": "NonSegregated",
  };
  String selectedFolioType = "Live";
  ExpansionTileController folioController = ExpansionTileController();

  List summaryTypeList = [
    "All",
    "MF without other ARN",
    "MF bought from others"
  ];
  String selectedSummaryType = "All";
  ExpansionTileController summaryController = ExpansionTileController();

  Widget getCancelApplyButton(ButtonType type) {
    if (type == ButtonType.plain)
      return PlainButton(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        text: "CLEAR ALL",
        onPressed: () {},
      );
    else
      return RpFilledButton(
        text: "APPLY",
        onPressed: () {
          familyXirrResponse.msg = null;
          Get.back();
          setState(() {});
        },
      );
  }



  int length = 0;

  Widget countArea() {
    int length = familyList.length;
    return isLoading
        ? Utils.shimmerWidget(devHeight * 0.03,)
        : Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            "$length items",
            style: TextStyle(color: Colors.grey),
          ),
          Spacer(),
          if (selectedType != "Family")
            SortButton(
              onTap: () {
                sortBottomSheet();
              },
              title: " Sort By",
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Image.asset("assets/mobile_data.png", height: 14),
              ),
            ),
          SizedBox(width: 16),
          SortButton(
            onTap: () {
              if (xirrType == 'cagr')
                xirrType = 'absolute_return';
              else
                xirrType = 'cagr';
              setState(() {});
            },
            title: xirrMap[xirrType],
            icon: Padding(
              padding: EdgeInsets.only(left: 2),
              child: Image.asset(
                "assets/mobile_sort.png",
                height: 10,
                color: Config.appTheme.themeColor,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 4),
          )
        ],
      ),
    );
  }

  List sortOptions = ["Start Value", "End Value", "XIRR"];
  String selectedSort = "Start Value";

  sortBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, bottomState) {
          return Column(
            children: [
              BottomSheetTitle(title: "Sort & Filter"),
              ListView.builder(
                shrinkWrap: true,
                itemCount: sortOptions.length,
                itemBuilder: (context, index) {
                  String option = sortOptions[index];

                  return InkWell(
                    onTap: () {
                      selectedSort = option;
                      Get.back();
                      applySort();
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        Radio(
                          value: option,
                          groupValue: selectedSort,
                          onChanged: (value) {
                            selectedSort = option;
                            bottomState(() {});
                            applySort();
                            Get.back();
                            setState(() {});
                          },
                        ),
                        Text(option),
                      ],
                    ),
                  );
                },
              )
            ],
          );
        });
      },
    );
  }

  showReportActionBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Config.appTheme.mainBgColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  BottomSheetTitle(title: "Report Actions"),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: reportActionContainer(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /*Widget reportActionContainer() {
    String startDate = formatDate(selectedStartDate);
    String endDate = formatDate(selectedEndDate);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: reportActionData.length,
        separatorBuilder: (context, index) {
          return DottedLine(verticalPadding: 4);
        },
        itemBuilder: (context, index) {
          String title = reportActionData.keys.elementAt(index);
          List stitle = reportActionData.values.elementAt(index);
          String imagePath = stitle[2];
          String msgUrl = "";
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () async {
                EasyLoading.show();
                if (investorId != 0) {
                  if (index == 0) {
                    String url =
                        "${ApiConfig.apiUrl}/admin/download/familyXirrReport?key=${ApiConfig.apiKey}&user_id=$investorId&client_name=$client_name&type=pdf&start_date=$startDate&end_date=$endDate&option=$selectedSummaryType";

                    http.Response response = await http.post(Uri.parse(url));
                    msgUrl = response.body;
                    Map data = jsonDecode(msgUrl);
                    String resUrl = data['msg'];
                    print("pdf $url");
                    rpDownloadFile(url: resUrl, context: context, index: index);
                    EasyLoading.dismiss();
                    Get.back();
                  } else if (index == 1) {
                    EasyLoading.show();
                    String url =
                        "${ApiConfig.apiUrl}/admin/download/familyXirrReport?key=${ApiConfig.apiKey}&user_id=$investorId&client_name=$client_name&type=excel&start_date=$startDate&end_date=$endDate&option=$selectedSummaryType";
                    http.Response response = await http.post(Uri.parse(url));
                    msgUrl = response.body;
                    Map data = jsonDecode(msgUrl);
                    String resUrl = data['msg'];
                    print("excel $url");
                    rpDownloadFile(url: resUrl, context: context, index: index);
                    EasyLoading.dismiss();
                    Get.back();
                  }
                } else {
                  Utils.showError(context, "Please Select the Investor");
                  return;
                }
                EasyLoading.dismiss();
              },
              child: RpListTile(
                title: SizedBox(
                  width: 220,
                  child: Text(
                    title,
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor),
                  ),
                ),
                subTitle: Visibility(
                  visible: stitle[0].isNotEmpty,
                  child: Text(stitle[0], style: AppFonts.f40013),
                ),
                leading: Image.asset(
                  imagePath,
                  color: Config.appTheme.themeColor,
                  width: 32,
                  height: 32,
                ),
                showArrow: false,
              ),
            ),
          );
        },
      ),
    );
  }*/

  List reportActions = [
    {
      'title': "Download PDF Report",
      'img': "assets/pdf.png",
      'type': ReportType.DOWNLOAD,
    },
    {
      'title': "Download Excel Report",
      'img': "assets/excel.png",
      'type': ReportType.EXCEL,
    },
  ];

  Widget reportActionContainer() {
    String startDate = formatDate(selectedStartDate);
    String endDate = formatDate(selectedEndDate);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: reportActions.length,
        separatorBuilder: (context, index) {
          return DottedLine(verticalPadding: 4);
        },
        itemBuilder: (context, index) {
          Map data = reportActions[index];

          String title = data['title'];
          String img = data['img'];
          String type = data['type'];

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () async {
                if (investorId != 0) {
                  EasyLoading.show();
                  Map data = await ReportApi.familyXirrReport(
                      user_id: investorId,
                      client_name: client_name,
                      type: type,
                      start_date: startDate,
                      end_date: endDate,
                      option: selectedSummaryType);
                  if (data['status'] != 200) {
                    Utils.showError(context, data['msg']);
                    return;
                  }
                  EasyLoading.dismiss();
                  Get.back();
                  if (type == ReportType.DOWNLOAD) {
                    rpDownloadFile(
                        url: data['msg'], context: context, index: index);
                  } else {
                    rpDownloadFile(
                        url: data['msg'], context: context, index: index);
                  }
                } else {
                  Utils.showError(context, "Please Select the Investor");
                  return;
                }
              },
              child: RpListTile(
                title: SizedBox(
                  width: 220,
                  child: Text(
                    title,
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor),
                  ),
                ),
                subTitle: SizedBox(),
                leading: Image.asset(
                  img,
                  color: Config.appTheme.themeColor,
                  width: 32,
                  height: 32,
                ),
                showArrow: false,
              ),
            ),
          );
        },
      ),
    );
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

  applySort() {
    if (selectedSort == 'Start Value')
      individualSchemes.investorSchemeWisePortfolioResponses!.sort((a, b) {
        double valueA = double.parse(a.currValueStartDate ?? "0");
        double valueB = double.parse(b.currValueStartDate ?? "0");

        return valueB.compareTo(valueA);
      });
    if (selectedSort == 'End Value')
      individualSchemes.investorSchemeWisePortfolioResponses!.sort((a, b) {
        double valueA = double.parse(a.currValueEndDate ?? "0");
        double valueB = double.parse(b.currValueEndDate ?? "0");
        return valueB.compareTo(valueA);
      });
    if (selectedSort == "XIRR") {
      individualSchemes.investorSchemeWisePortfolioResponses!.sort((a, b) {
        num valueA = a.cagr ?? 0;
        num valueB = b.cagr ?? 0;
        return valueB.compareTo(valueA);
      });
    }
  }

  Widget bottomArea() {
    if (selectedType == "Family") return getAllFamilyDetails();
    return isLoading
        ? Utils.shimmerWidget(devHeight )
        : individualDetails();
  }

  List<FamilyList> schemeList = [];

  Widget getAllFamilyDetails() {
    if (familyXirrResponse.msg == null) return Utils.shimmerWidget(400);
    schemeList = familyXirrResponse.list ?? [];
    length = schemeList.length;

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: schemeList.length,
      itemBuilder: (context, index) {
        FamilyList scheme = schemeList[index];
        return schemeCard(scheme);
      },
    );
  }

  Widget individualDetails() {
    return schemeCard(individualSchemes);
  }

  bool bottomSheetShowDetails = false;
  List<AmcList> amcList = [];

  showXirrReportBottomSheet(
      String shortName,
      String folioNo,
      String amcLogo,
      num startValue,
      DateTime selectedStartDate,
      String invCostStartDate,
      String currValueStartDate,
      DateTime selectedEndDate,
      String invCostEndDate,
      String currValueEndDate,
      num realisedGainLoss,
      totalInflow,
      totalOutflow,
      dividendPaid,
      absoluteReturn,
      xirr) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (_, bottomState) {
          return Container(
            height: devHeight * 0.78,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "XIRR Report",
                        style: AppFonts.f50014Black.copyWith(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(amcLogo, height: 32),
                              SizedBox(width: 8),
                              Expanded(
                                child: ColumnText(
                                  title: shortName,
                                  value: "Folio : $folioNo",
                                  titleStyle: AppFonts.f50014Black,
                                  valueStyle: AppFonts.f40013
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            "As on ${Utils.getFormattedDate(date: selectedStartDate)}",
                            style: AppFonts.f40013,
                          ),
                          SizedBox(height: 10),
                          summaryRowBlack(
                              initial: "A",
                              bgColor: Color(0xFF4155B9),
                              title: "Investment Cost",
                              value: Utils.formatNumber(
                                  double.parse(invCostStartDate).round())),
                          SizedBox(
                            height: 5,
                          ),
                          summaryRowBlack(
                              initial: "B",
                              bgColor: Color(0xFF4155B9),
                              title: "Investment Value",
                              value: Utils.formatNumber(
                                  double.parse(currValueStartDate).round())),
                          DottedLine(),
                          Text(
                            "As on ${Utils.getFormattedDate(date: selectedEndDate)}",
                            style: AppFonts.f40013,
                          ),
                          SizedBox(height: 5),
                          summaryRowBlack(
                              initial: "C",
                              bgColor: Color(0xFFFF6F61),
                              title: "Investment Cost",
                              value: Utils.formatNumber(
                                  double.parse(invCostEndDate).round())),
                          summaryRowBlack(
                              initial: "D",
                              bgColor: Color(0xFFFF6F61),
                              title: "Current Value",
                              value: Utils.formatNumber(
                                  double.parse(currValueEndDate).round())),
                          SizedBox(height: 5),
                          DottedLine(),
                          Row(
                            children: [
                              InitialCard(
                                bgColor: Color(0xFF3C9AB6),
                                title: "E",
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  blackText("Purchase"),
                                ],
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  blackText(
                                      "$rupee ${Utils.formatNumber(totalInflow.round())}"),
                                  GestureDetector(
                                    onTap: () {
                                      bottomSheetShowDetails =
                                          !bottomSheetShowDetails;
                                      bottomState(() {});
                                    },
                                    child: Text(
                                      "${(bottomSheetShowDetails) ? "Hide" : "View"} details",
                                      style: AppFonts.f40013.copyWith(
                                          color: Colors.blue,
                                          decorationColor: Colors.blue,
                                          decoration: TextDecoration.underline),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 16),
                          Visibility(
                              visible: bottomSheetShowDetails,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  summaryRowBlack(
                                      initial: "F",
                                      bgColor: Color(0xFF5DB25D),
                                      title: "Redemption",
                                      value: Utils.formatNumber(
                                          totalOutflow.round())),
                                  summaryRowBlack(
                                      initial: "G",
                                      bgColor: Color(0xFFE79C23),
                                      title: "Dividend Pay",
                                      value: Utils.formatNumber(
                                          dividendPaid.round())),
                                  summaryRowBlack(
                                      initial: "H",
                                      bgColor: Color(0xFFE79C23),
                                      title: "Gain/Loss \n(D-B)-(E)+F+G",
                                      value:
                                          Utils.formatNumber(realisedGainLoss)),
                                ],
                              )),
                          DottedLine(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ColumnText(
                                  title: "Absolute Return",
                                  value:
                                      "${absoluteReturn.toStringAsFixed(2)}%",
                                  alignment: CrossAxisAlignment.start,
                                  titleStyle: AppFonts.f40013
                                      .copyWith(color: Colors.black),
                                  valueStyle: AppFonts.f50014Black.copyWith(
                                      color: (absoluteReturn > 0)
                                          ? Config.appTheme.defaultProfit
                                          : Config.appTheme.defaultLoss)),
                              ColumnText(
                                  title: "XIRR",
                                  value: "${xirr.toStringAsFixed(2)}%",
                                  alignment: CrossAxisAlignment.end,
                                  titleStyle: AppFonts.f40013
                                      .copyWith(color: Colors.black),
                                  valueStyle: AppFonts.f50014Black.copyWith(
                                      color: (xirr > 0)
                                          ? Config.appTheme.defaultProfit
                                          : Config.appTheme.defaultLoss)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }

  Widget summaryRowBlack({
    required String initial,
    required Color bgColor,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          InitialCard(title: (initial == "") ? "." : initial, bgColor: bgColor),
          SizedBox(width: 10),
          blackText(title),
          Spacer(),
          blackText("$rupee $value")
        ],
      ),
    );
  }

  Widget blackText(String text) {
    return Text(
      text,
      style: AppFonts.f50014Black.copyWith(color: Colors.black),
    );
  }

  Widget topArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Family Head: $familyName",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Map xirrMap = {"cagr": "XIRR", 'absolute_return': "Abs Return"};
  String xirrType = "cagr";

  Widget schemeCard(FamilyList scheme) {
    List<InvestorSchemeWisePortfolioResponses> schemePortfolioList =
        scheme.investorSchemeWisePortfolioResponses ?? [];
    return InkWell(
      onTap: () {
        //Get.to(() => FamilyInvestmentSummaryDetails());
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          children: [
            SizedBox(height: 16),
            blackBoxPortfolio(scheme),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: schemePortfolioList.length,
              itemBuilder: (context, index) {
                InvestorSchemeWisePortfolioResponses invList =
                    schemePortfolioList[index];
                Map map = invList.toJson();
                String? strt = invList.currValueStartDate;
                num? startValue = num.parse(strt!);
                String? end = invList.currValueEndDate;
                num? endValue = num.parse(end!);

                return invListCard(invList, startValue, endValue, map);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget invListCard(InvestorSchemeWisePortfolioResponses invList,
      num startValue, num endValue, Map<dynamic, dynamic> map) {
    String shortName = invList.schemeAmfiShortName ?? "";
    String folioNo = invList.foliono ?? "";
    String amcLogo = invList.amcLogo ?? "";

    String invCostStartDate = invList.invCostStartDate ?? "0";
    String currValueStartDate = invList.currValueStartDate ?? "0";
    String invCostEndDate = invList.invCostEndDate ?? "0";
    String currValueEndDate = invList.currValueEndDate ?? "0";

    num realisedGainLoss = invList.realisedGainLoss ?? 0;
    num totalInflow = invList.totalInflow ?? 0;
    num totalOutflow = invList.totalOutflow ?? 0;
    num dividendPaid = invList.dividendPaid ?? 0;

    num absoluteReturn = invList.absoluteReturn ?? 0;
    num xirr = invList.cagr ?? 0;

    return InkWell(
      onTap: () {
        showXirrReportBottomSheet(
            shortName,
            folioNo,
            amcLogo,
            startValue,
            selectedStartDate,
            invCostStartDate,
            currValueStartDate,
            selectedEndDate,
            invCostEndDate,
            currValueEndDate,
            realisedGainLoss,
            totalInflow,
            totalOutflow,
            dividendPaid,
            absoluteReturn,
            xirr);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Image.network(
                  invList.amcLogo!,
                  height: 32,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ColumnText(
                    title: "${invList.schemeAmfiShortName}",
                    value: "Folio : ${invList.foliono}",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Config.appTheme.placeHolderInputTitleAndArrow,
                )
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnText(
                    title: "Start Value",
                    value: "$rupee ${Utils.formatNumber(startValue.round())}"),
                ColumnText(
                  title: "End Value",
                  value: "$rupee ${Utils.formatNumber(endValue.round())}",
                  alignment: CrossAxisAlignment.center,
                ),
                ColumnText(
                  title: "${xirrMap[xirrType]}",
                  value: "${map[xirrType].toStringAsFixed(2) ?? ""} %",
                  alignment: CrossAxisAlignment.end,
                  valueStyle: AppFonts.f50014Black.copyWith(
                      color: (map[xirrType]! > 0)
                          ? Config.appTheme.defaultProfit
                          : Config.appTheme.defaultLoss),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget blackBoxPortfolio(FamilyList scheme) {
    String invName = scheme.investorName ?? "";
    int? item = scheme.investorSchemeWisePortfolioResponses?.length;
    String? startValue = scheme.icsdGrandTotal ?? "";
    num strtVal = num.parse(startValue) ?? 0;
    String? endValue = scheme.ccedGrandTotal ?? "";
    String? startDate = scheme.icedGrandTotal ?? "";
    String? endDate = scheme.ccsdGrandTotal ?? "";
    num? edDate = num.parse(endDate) ?? 0;
    num? strtDate = num.parse(startDate) ?? 0;

    num? edValue = num.parse(endValue) ?? 0;
    num? xirr = num.parse(scheme.familyXirr!.toStringAsFixed(2));
    String? invRole = scheme.familyStatus;
    num? absReturn = num.parse(scheme.absRtnGrandTotal!.toStringAsFixed(2));

    return Container(
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InitialCard(title: (invName[0] == "") ? "." : invName[0]),
              SizedBox(
                width: 10,
              ),
              ColumnText(
                title: invName,
                value: invRole ?? "",
                valueStyle:
                    AppFonts.f40013.copyWith(color: Config.appTheme.lineColor),
              ),
              /*Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(invName,
                      textAlign: TextAlign.start,
                      style: AppFonts.f40013
                          .copyWith(color: Config.appTheme.lineColor)),
                  Text(invRole ?? "",
                      textAlign: TextAlign.start,
                      style: AppFonts.f40013
                          .copyWith(color: Config.appTheme.lineColor)),
                ],
              ),*/
              SizedBox(
                width: 10,
              ),
              Text("($item Schemes)",
                  textAlign: TextAlign.end,
                  style: AppFonts.f40013
                      .copyWith(color: Config.appTheme.lineColor)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title:
                    "Inv. Cost ${Utils.getFormattedDate(date: selectedStartDate)}",
                value: Utils.formatNumber(strtVal.round()),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title:
                    "Value ${Utils.getFormattedDate(date: selectedStartDate)}",
                value: Utils.formatNumber(edDate.round()),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title:
                    "Inv. Cost ${Utils.getFormattedDate(date: selectedEndDate)}",
                value: Utils.formatNumber(strtDate.round()),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title:
                    "Cur. Value ${Utils.getFormattedDate(date: selectedEndDate)}",
                value: Utils.formatNumber(edValue.round()),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "XIRR",
                value: "$xirr",
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
                alignment: CrossAxisAlignment.start,
              ),
              ColumnText(
                title: "Abs. Rtn",
                value: "$absReturn",
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
                alignment: CrossAxisAlignment.end,
              )
            ],
          ),
        ],
      ),
    );
  }

  FamilyList individualSchemes = FamilyList();

  Widget getButton({required String text, required ButtonType type}) {
    EdgeInsets padding = EdgeInsets.symmetric(horizontal: 16);
    if (type == ButtonType.plain) {
      return PlainRButton(
        text: text,
        padding: padding,
        onPressed: () {
          selectedType = text;
          selectedSort = "";
          if (selectedType == "Family") {
            getAllFamilyDetails();
          } else {
            individualSchemes = schemeList
                .firstWhere((element) => element.investorName == selectedType);
          }
          print("individualSchemes $individualSchemes");
          setState(() {});
        },
      );
    } else {
      return RpFilledRButton(text: text, padding: padding);
    }
  }

  bool showDetails = false;

  Widget middleArea() {
    num? totalInvCost = familyXirrResponse.totalInvCost ?? 0;
    num? totalCurrVal = familyXirrResponse.totalCurrVal ?? 0;
    num? invCostAsOn = familyXirrResponse.invCostAsOn ?? 0;
    num? currValAsOn = familyXirrResponse.currValAsOn ?? 0;
    num? gainLoss = familyXirrResponse.totalGainLoss ?? 0;
    num? totalXirr = familyXirrResponse.totalXirr ?? 0;
    num? purchase = familyXirrResponse.totalPurchase ?? 0;
    num? redemption = familyXirrResponse.totalRedemption ?? 0;
    num? divPay = familyXirrResponse.totalDivPay ?? 0;

    return Container(
      // color: Config.appTheme.themeColor,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "As on ${Utils.getFormattedDate(date: selectedEndDate)}",
            style: AppFonts.f40013.copyWith(color: Colors.white),
          ),
          SizedBox(height: 10),
          summaryRow(
              initial: "A",
              bgColor: Color(0xFF4FF6F61),
              title: "Investment Cost",
              value: Utils.formatNumber(totalInvCost.round())),
          summaryRow(
              initial: "B",
              bgColor: Color(0xFFFF6F61),
              title: "Investment Value",
              value: Utils.formatNumber(totalCurrVal.round())),

          DottedLine(),
          Text(
            "As on ${Utils.getFormattedDate(date: selectedStartDate)}",
            style: AppFonts.f40013.copyWith(color: Colors.white),
          ),
          SizedBox(height: 5),
          summaryRow(
              initial: "C",
              bgColor: Color(0xFF4155B9),
              title: "Investment Cost",
              value: Utils.formatNumber(invCostAsOn.round())),
          SizedBox(
            height: 5,
          ),
          summaryRow(
              initial: "D",
              bgColor: Color(0xFF4155B9),
              title: "Current Value",
              value: Utils.formatNumber(currValAsOn.round())),

          SizedBox(height: 5),
          DottedLine(),
          // #region initialCard
          Row(
            children: [
              InitialCard(
                bgColor: Color(0xFF3C9AB6),
                title: "E",
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  whiteText("Purchase"),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  whiteText("$rupee ${Utils.formatNumber(purchase.round())}"),
                  GestureDetector(
                    onTap: () {
                      showDetails = !showDetails;
                      setState(() {});
                    },
                    child: Text(
                      "${(showDetails) ? "Hide" : "View"} Details",
                      style: AppFonts.f40013.copyWith(
                          color: Colors.yellow,
                          decorationColor: Colors.yellow,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              )
            ],
          ),
          // #endregion,
          SizedBox(height: 16),
          Visibility(
              visible: showDetails,
              child: Column(
                children: [
                  summaryRow(
                      initial: "F",
                      bgColor: Color(0xFF5DB25D),
                      title: "Redemption",
                      value: Utils.formatNumber(redemption.round())),
                  summaryRow(
                      initial: "G",
                      bgColor: Color(0xFFE79C23),
                      title: "Dividend Pay",
                      value: Utils.formatNumber(divPay.round())),
                  summaryRow(
                      initial: "H",
                      bgColor: Color(0xFFE79C23),
                      title: "Gain/Loss \n(D-B)-(E)+F+G",
                      value: Utils.formatNumber(gainLoss.round())),
                ],
              )),

          DottedLine(),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Absolute Returnss",
                value:
                    "${familyXirrResponse.totalAbsRet?.toStringAsFixed(2) ?? 0} %",
                titleStyle: AppFonts.f40013.copyWith(color: Colors.white),
                valueStyle: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.defaultProfit),
              ),
              ColumnText(
                title: "XIRR",
                value:
                    "${familyXirrResponse.totalXirr?.toStringAsFixed(2) ?? 0} %",
                alignment: CrossAxisAlignment.end,
                titleStyle: AppFonts.f40013.copyWith(color: Colors.white),
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: (familyXirrResponse.totalXirr! > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget summaryRow({
    required String initial,
    required Color bgColor,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          InitialCard(title: (initial == "") ? "." : initial, bgColor: bgColor),
          SizedBox(width: 10),
          whiteText(title),
          Spacer(),
          whiteText("$rupee $value")
        ],
      ),
    );
  }

  Widget whiteText(String text) {
    return Text(
      text,
      style: AppFonts.f50014Black.copyWith(color: Colors.white),
    );
  }
}

class PlainRButton extends StatelessWidget {
  const PlainRButton(
      {super.key, required this.text, this.onPressed, this.padding});

  final String text;
  final Function()? onPressed;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.sizeOf(context).width;

    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: padding ??
            EdgeInsets.symmetric(horizontal: devWidth * 0.15, vertical: 2),
        decoration: BoxDecoration(
            border: Border.all(color: Config.appTheme.themeColor),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppFonts.f50014Black
                .copyWith(color: Config.appTheme.themeColor),
          ),
        ),
      ),
    );
  }
}
