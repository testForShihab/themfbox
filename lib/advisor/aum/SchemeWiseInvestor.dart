import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/login/CheckUserType.dart';
import 'package:mymfbox2_0/pojo/AllInvestorsPojo.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/RectButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpFilterChip.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile2.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Restrictions.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../api/ApiConfig.dart';

class SchemeWiseInvestor extends StatefulWidget {
  const SchemeWiseInvestor({
    super.key,
    required this.schemeFullname,
    required this.logo,
    required this.amount,
    required this.percentage,
    required this.schemeShortName,
  });
  final String schemeFullname, logo, schemeShortName;
  final num amount, percentage;
  @override
  State<SchemeWiseInvestor> createState() => _SchemeWiseInvestorState();
}

class _SchemeWiseInvestorState extends State<SchemeWiseInvestor> {
  List investorList = [];
  int user_id = GetStorage().read("mfd_id");
  String client_name = GetStorage().read("client_name");
  String mobile = GetStorage().read("mfd_mobile");

  late double devHeight, devWidth;
  bool isLoading = true;
  late String amount, percentage;

  Future getAllBranch() async {
    if (bottomSheetFilter['Branch'].isNotEmpty) return 0;

    Map data = await Api.getAllBranch(mobile: mobile, client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    bottomSheetFilter['Branch'] = data['list'];
    return 0;
  }

  Future getAllRM() async {
    if (bottomSheetFilter['RM'].isNotEmpty) return 0;

    Map data = await Api.getAllRM(
        mobile: mobile, client_name: client_name, branch: "");
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    bottomSheetFilter['RM'] = data['list'];
    return 0;
  }

  Future getAllSubBroker() async {
    if (bottomSheetFilter['Sub Broker'].isNotEmpty) return 0;
    Map data =
        await Api.getAllSubbroker(mobile: mobile, client_name: client_name);

    bottomSheetFilter['Sub Broker'] = data['list'];
    return 0;
  }

  num filteredCount = 0, filteredAmount = 0;
  Future getSchemesWiseInvestors() async {
    if (investorList.isNotEmpty) return 0;

    Map data = await AdminApi.getSchemesWiseInvestors(
      sort_by: "aum",
      user_id: user_id,
      client_name: client_name,
      scheme_name: widget.schemeFullname,
      branch_name: selectedBranchList.join(","),
      broker_code: (arn == "All") ? "" : arn,
      rm_name: selectedRmList.join(","),
      subbroker_name: selectedSubBrokerList.join(","),
    );
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }

    filteredCount = data['count'];
    filteredAmount = data['total_aum'];
    investorList = data['list'];
    //invPercentage = data['list']['returns'];
    // print("%% $invPercentage");
    applySort();

    return 0;
  }

  List arnList = [];
  Future getArnList() async {
    if (arnList.isNotEmpty) return 0;
    Map data = await Api.getArnList(client_name: client_name);
    try {
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
      bottomSheetFilter['ARN'] = arnList;
    } catch (e) {
      print("getArnList exception = $e");
    }
    return 0;
  }

  @override
  void initState() {
    //  implement initState
    super.initState();
    amount = Utils.formatNumber(widget.amount, isAmount: true);
    percentage = widget.percentage.toStringAsFixed(2);
  }

  Future getDatas() async {
    isLoading = true;

    if (Restrictions.isBranchApiAllowed) await getAllBranch();
    if (Restrictions.isRmApiAllowed) await getAllRM();
    if (Restrictions.isAssociateApiAllowed) await getAllSubBroker();
    await getArnList();
    await getSchemesWiseInvestors();

    isLoading = false;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;

    return FutureBuilder(
      future: getDatas(),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: adminAppBar(
              title: "Scheme Wise Investors", bgColor: Colors.white),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
                child: Row(
                  children: [
                    //Image.network(widget.logo, height: 32),
                    Utils.getImage(widget.logo, 32),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(widget.schemeShortName,
                          style: AppFonts.f50014Black),
                    ),
                    ColumnText(
                      title: "$rupee $amount",
                      value: "($percentage%)",
                      alignment: CrossAxisAlignment.end,
                      titleStyle: AppFonts.f50014Black,
                      valueStyle: AppFonts.f40013,
                    ),
                  ],
                ),
              ),
              sortLine(),
              countLine(),
              listArea()
            ],
          ),
        );
      },
    );
  }

  Widget listArea() {
    return Expanded(
      child: SingleChildScrollView(
        child: (isLoading)
            ? Utils.shimmerWidget(devHeight)
            : ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  Map<String, dynamic> map = investorList[index];
                  AllInvestorsPojo userData = AllInvestorsPojo.fromJson(map);
                  Map scheme = investorList[index];
                  String name = scheme['name'];
                  String branch = scheme['branch'];
                  num aum = scheme['aum'];
                  double returns = scheme['returns'];
                  return InkWell(
                    onTap: () {
                      showUserDetails(userData);
                    },
                    child: RpListTile2(
                      leading: InitialCard(title: name, size: 34),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      l1: name,

                      l2: "Folio : ${scheme['folio_no']}",
                      r1: "$rupee ${Utils.formatNumber(aum, isAmount: true)}",
                      //r2: "${returns.toStringAsFixed(2)} %",
                      r2: "",
                    ), /*Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      child: Row(
                        children: [
                          InitialCard(title: "${userData.name}", size: 34),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${userData.name}",
                                    style: AppFonts.f50014Black
                                        .copyWith(fontSize: 15)),
                             if(userData.branch != null) Text("${userData.branch}",
                                    style: AppFonts.f40013),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "$rupee ${Utils.formatNumber(userData.aum, isAmount: true)}",
                                style: cardHeadingSmall,
                              ),
                              Text("($percentage%)"),
                            ],
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color:
                                Config.appTheme.placeHolderInputTitleAndArrow,
                          )
                        ],
                      ),
                    ),*/
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Divider(height: 0),
                  );
                },
                itemCount: investorList.length),
      ),
    );
  }

  bool showSortChip = true;
  Widget sortLine() {
    return Container(
      height: 60,
      width: devWidth,
      color: Config.appTheme.mainBgColor,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SortButton(onTap: () {
            sortFilter();
          }),
          SizedBox(width: 16),
          if (showSortChip)
            RpFilterChip(
              selectedSort: selectedSort,
              hasClose: true,
              onClose: () {
                selectedSort = "Alphabet";
                showSortChip = false;
                applySort();
                setState(() {});
              },
            ),
          for (int i = 0; i < selectedBranchList.length; i++)
            RpFilterChip(
              selectedSort: selectedBranchList[i],
              onClose: () {
                selectedBranchList.removeAt(i);
                investorList = [];
                setState(() {});
              },
            )
        ],
      ),
    );
  }

  sortFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: cornerBorder),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return Container(
              height: devHeight * 0.7,
              decoration: BoxDecoration(
                  borderRadius: cornerBorder, color: Colors.white),
              child: Column(
                children: [
                  BottomSheetTitle(title: "Sort & Filter"),
                  Divider(height: 0),
                  Expanded(
                    flex: 7,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        leftContent(bottomState),
                        Expanded(child: rightContent(bottomState))
                      ],
                    ),
                  ),
                  Divider(height: 1),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                              child: PlainButton(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            text: "Clear All",
                             color: Config.appTheme.buttonColor,
                            onPressed: () {
                              selectedBranchList = [];
                              selectedRmList = [];
                              investorList = [];
                              Get.back();
                              setState(() {});
                            },
                          )),
                          SizedBox(width: 16),
                          Expanded(
                            child: RpFilledButton(
                              text: "Apply",
                              color: Config.appTheme.buttonColor,
                              onPressed: () {
                                applySort();
                                if (selectedBranchList.isNotEmpty)
                                  investorList = [];
                                if (selectedRmList.isNotEmpty)
                                  investorList = [];
                                Get.back();
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Map bottomSheetFilter = {
    "Sort By": ["Alphabet", "AUM"],
    "Branch": [],
    "RM": [],
    "Sub Broker": [],
    "ARN": [],
  };
  String selectedLeft = "Sort By";
  Widget leftContent(var bottomState) {
    List list = bottomSheetFilter.keys.toList();

    return Container(
      width: devWidth * 0.35,
      color: Config.appTheme.mainBgColor,
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          String title = list[index];
          return (selectedLeft == title)
              ? rpLeftSelectedBtn(title)
              : rpLeftBtn(
                  title: title,
                  onTap: () {
                    selectedLeft = title;
                    bottomState(() {});
                  });
        },
      ),
    );
  }

  Widget rpLeftSelectedBtn(String title) {
    bool hasDot = false;
    if (title == 'Branch') hasDot = selectedBranchList.isNotEmpty;
    if (title == 'RM') hasDot = selectedRmList.isNotEmpty;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
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
          Text(title),
        ],
      ),
    );
  }

  Widget rpLeftBtn({required String title, required Function() onTap}) {
    bool hasDot = false;
    if (title == 'Branch') hasDot = selectedBranchList.isNotEmpty;
    if (title == 'RM') hasDot = selectedRmList.isNotEmpty;

    return InkWell(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }

  Widget rightContent(var bottomState) {
    if (selectedLeft == 'Sort By') return sortView(bottomState);
    if (selectedLeft == 'Branch') return branchView(bottomState);
    if (selectedLeft == 'RM') return rmView(bottomState);
    if (selectedLeft == "Sub Broker") return subBrokerView(bottomState);
    if (selectedLeft == 'ARN') return arnView(bottomState);
    return Text("Invalid Left");
  }

  applySort() {
    if (selectedSort == "Alphabet")
      investorList.sort((a, b) => a['name'].compareTo(b['name']));
    if (selectedSort == "AUM")
      investorList.sort((a, b) => b['aum'].compareTo(a['aum']));
  }

  String selectedSort = "AUM";
  Widget sortView(var bottomState) {
    List list = bottomSheetFilter['Sort By'];

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            selectedSort = list[index];
            showSortChip = true;
            bottomState(() {});
          },
          child: Row(
            children: [
              Radio(
                  value: list[index],
                  activeColor: Config.appTheme.themeColor,
                  groupValue: selectedSort,
                  onChanged: (val) {
                    selectedSort = list[index];
                    showSortChip = true;
                    bottomState(() {});
                  }),
              Text(list[index]),
            ],
          ),
        );
      },
    );
  }

  List selectedBranchList = [];
  Widget branchView(var bottomState) {
    List list = bottomSheetFilter['Branch'];
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        String title = list[index];
        bool isContains = selectedBranchList.contains(title);

        return InkWell(
          onTap: () {
            (isContains)
                ? selectedBranchList.remove(title)
                : selectedBranchList.add(title);

            bottomState(() {});
          },
          child: Row(
            children: [
              Checkbox(
                  value: isContains,
                  onChanged: (val) {
                    (isContains)
                        ? selectedBranchList.remove(title)
                        : selectedBranchList.add(title);

                    bottomState(() {});
                  }),
              Flexible(child: Text(title))
            ],
          ),
        );
      },
    );
  }

  List selectedSubBrokerList = [];
  Widget subBrokerView(var bottomState) {
    List list = bottomSheetFilter['Sub Broker'];
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        String title = list[index];
        bool isContains = selectedSubBrokerList.contains(title);

        return InkWell(
          onTap: () {
            (isContains)
                ? selectedSubBrokerList.remove(title)
                : selectedSubBrokerList.add(title);

            bottomState(() {});
          },
          child: Row(
            children: [
              Checkbox(
                  value: isContains,
                  onChanged: (val) {
                    (isContains)
                        ? selectedSubBrokerList.remove(title)
                        : selectedSubBrokerList.add(title);

                    bottomState(() {});
                  }),
              Flexible(child: Text(title))
            ],
          ),
        );
      },
    );
  }

  List selectedRmList = [];
  Widget rmView(var bottomState) {
    List list = bottomSheetFilter['RM'];
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        String title = list[index];
        bool isContains = selectedRmList.contains(title);

        return InkWell(
          onTap: () {
            (isContains)
                ? selectedRmList.remove(title)
                : selectedRmList.add(title);

            bottomState(() {});
          },
          child: Row(
            children: [
              Checkbox(
                  value: isContains,
                  onChanged: (val) {
                    (isContains)
                        ? selectedRmList.remove(title)
                        : selectedRmList.add(title);

                    bottomState(() {});
                  }),
              Flexible(child: Text(title))
            ],
          ),
        );
      },
    );
  }

  String arn = "All";
  Widget arnView(var bottomState) {
    return ListView.builder(
      itemCount: bottomSheetFilter['ARN'].length,
      itemBuilder: (context, index) {
        List list = bottomSheetFilter['ARN'];
        String title = list[index];

        return InkWell(
          onTap: () {
            arn = title;
            bottomState(() {});
          },
          child: Row(
            children: [
              Radio(
                  value: title,
                  groupValue: arn,
                  onChanged: (val) {
                    arn = title;
                    bottomState(() {});
                  }),
              Text(title),
            ],
          ),
        );
      },
    );
  }

  showUserDetails(AllInvestorsPojo userData) {
    String aum = Utils.formatNumber(userData.aum, isAmount: true);
    String name = userData.name ?? "null";
    int type_id = userData.typeId ?? 0;
    String invType = "null";
    if (type_id == 1) invType = "Individual";
    if (type_id == 3) invType = "Family";

    String? rmname = "";
    String? subBrokerName = "";
    if(client_name == 'nextfreedom'){
      rmname = userData.subbrokerName;
      subBrokerName = userData.rmName;
    }else{
      rmname = userData.rmName;
      subBrokerName = userData.subbrokerName;
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, bottomState) {
          return Container(
            height: devHeight * 0.8,
            decoration:
                BoxDecoration(color: Colors.white, borderRadius: cornerBorder),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close))
                    ],
                  ),
                  ListTile(
                    leading: InitialCard(title: name[0]),
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
                      rStyle: AppFonts.f50014Theme
                          .copyWith(decoration: TextDecoration.underline)),
                  infoRow(
                      lHead: "Email",
                      lSubHead: "${userData.email}",
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
                  infoRow(lHead: "Branch", lSubHead: "${userData.branch}"),
                  infoRow(
                      lHead: "RM",
                      lSubHead: "$rmname",
                      rHead: (client_name != 'nextfreedom') ? "Associate" : "BM Name",
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
                       // SizedBox(height: 15),
                       /* Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () async {
                                  EasyLoading.show();
                                  if (userData.aum != 0) {
                                    String msgUrl = "";
                                    InvestorDetails investorDetails =
                                        InvestorDetails(
                                            userId: userData.id,
                                            email: userData.email);
                                    List<InvestorDetails> investorDetailsList =
                                        [];
                                    investorDetailsList.add(investorDetails);

                                    String investor_details =
                                        jsonEncode(investorDetailsList);

                                    String url =
                                        "${ApiConfig.apiUrl}/investor/download/getInvestorSummaryPdf?key=${ApiConfig.apiKey}"
                                        "&investor_details=$investor_details&mobile=${userData.mobile}&type=download&client_name=$client_name";

                                    http.Response response =
                                        await http.post(Uri.parse(url));
                                    msgUrl = response.body;
                                    Map data = jsonDecode(msgUrl);
                                    String resUrl = data['msg'];
                                    print("download $url");
                                    rpDownloadFile(
                                        url: resUrl, context: context);
                                    EasyLoading.dismiss();
                                    Get.back();
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
                                child: button("Download Portfolio")),
                            GestureDetector(
                                onTap: () async {
                                  EasyLoading.show();
                                  if (userData.aum != 0) {
                                    String msgUrl = "";
                                    InvestorDetails investorDetails =
                                        InvestorDetails(
                                            userId: userData.id,
                                            email: userData.email);
                                    List<InvestorDetails> investorDetailsList =
                                        [];
                                    investorDetailsList.add(investorDetails);

                                    String investor_details =
                                        jsonEncode(investorDetailsList);

                                    String url =
                                        "${ApiConfig.apiUrl}/investor/download/getInvestorSummaryPdf?key=${ApiConfig.apiKey}"
                                        "&investor_details=$investor_details&mobile=${userData.mobile}&type=Email&client_name=$client_name";

                                    http.Response response =
                                        await http.post(Uri.parse(url));
                                    msgUrl = response.body;
                                    Map data = jsonDecode(msgUrl);
                                    String resUrl = data['msg'];
                                    print("email $url");
                                    rpDownloadFile(
                                        url: resUrl, context: context);
                                    EasyLoading.dismiss();
                                    Get.back();
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
                                child: button("Email Portfolio")),
                          ],
                        ),*/
                      ],
                    ),
                  ),
                 // SizedBox(height: 20),
                ],
              ),
            ),
          );
        });
      },
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

  Widget countLine() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Visibility(
        visible: !isLoading,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$filteredCount Items", style: AppFonts.f40013),
            Text(
                "Total AUM $rupee ${Utils.formatNumber(filteredAmount, isAmount: true)}",
                style: cardHeadingSmall.copyWith(
                    color: Config.appTheme.themeColor)),
          ],
        ),
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
      // else
      //   showError();
    }
    // android
    else if (Platform.isAndroid) {
      if (await Permission.storage
          .request()
          .isGranted) // Request storage permission instead of photos permission
        dirloc = (await getExternalStorageDirectory())?.path ?? "";
      // else
      //   showError();
    }
    print("Url == $url");
    // Fluttertoast.showToast(
    //     msg: url,
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Config.appTheme.themeColor,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
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
