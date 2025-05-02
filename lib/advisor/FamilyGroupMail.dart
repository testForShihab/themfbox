import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/SearchText.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class FamilyGroupMail extends StatefulWidget {
  const FamilyGroupMail({super.key});

  @override
  State<FamilyGroupMail> createState() => _FamilyGroupMailState();
}

class _FamilyGroupMailState extends State<FamilyGroupMail> {
  late double devHeight, devWidth;
  bool isLoading = true;
  ScrollController scrollController = ScrollController();
  bool isFirst = true;
  Map summary = {};
  int userId = getUserId();
  String mobile = GetStorage().read("mfd_mobile");
  String clientName = GetStorage().read("client_name");
  int pageId = 1;
  List investorList = [];
  late num totalInvestors;
  num totalCount = 0;
  late String type;
  List branchList = [];
  List rmList = [];
  List subBrokerList = [];
  String userIdsSeparator = "";
  String selectedBranch = "All";
  String selectedRm = "All";
  String selectedSubBroker = "All";
  List financialYearList = [];

  String submitType = "";

  DateTime selectedPortfolioDate = DateTime.now();
  ExpansionTileController portfolioDatecontroller = ExpansionTileController();

  Map customerTypeMap = {
    "All": "All",
    "1 Star": "1 Star",
    "2 Star": "2 Star",
    "3 Star": "3 Star",
    "4 Star": "4 Star",
    "5 Star": "5 Star",
  };
  Map emailOptionMap = {
    "PDF": "PDF",
    "Web Link": "Web Link",
  };

  String selectedOption = "";
  String selectedOptionKeys = "Choose";
  String optionName = "";

  String selectedEmailOption = "PDF";
  String selectedEmailOptionKeys = "PDF";
  String emailOptionName = "PDF";

  String selectedCustomerType = "All";
  String selectedCustomerTypeKeys = "All";
  String customerTypeName = "All";
  DateFormat format = DateFormat('dd-MM-yyyy');
  String selectedLeft = "Sort By";
  String selectedSort = "Alphabet A-Z";
  int type_id = GetStorage().read("type_id");
  // Convert DateTime to formatted string

  @override
  void initState() {
    //  implement initState
    super.initState();
    scrollController.addListener(scrollListener);
  }

  Future scrollListener() async {
    bool atBottom = scrollController.position.extentAfter < 100;
    bool fullyLoaded = investorList.length == totalCount;

    bool fetchAgain = atBottom && !fullyLoaded && !isLoading;

    if (fetchAgain) await getMoreGroupEmailInvestors();
  }

  Future getMoreGroupEmailInvestors() async {
    pageId++;

    print("getting more investor with page id = $pageId");
    isLoading = true;
    EasyLoading.show();

    String tempSort = selectedSort;
    if (selectedSort.contains("Alphabet")) {
      tempSort = selectedSort.replaceAll("-", "");
      tempSort = selectedSort.replaceAll(" ", "-");
    }

    Map data = await Api.getGroupEmailInvestor(
      user_id: userId,
      client_name: clientName,
      branch: selectedBranch == "All" ? "" : selectedBranch,
      rm_name: selectedRm == "All" ? "" : selectedRm,
      subbroker_name: selectedSubBroker == "All" ? "" : selectedSubBroker,
      page_id: pageId,
      search: searchKey,
      sort_by: tempSort,
      customer_type: 3,
      rating_type: selectedCustomerType,
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    List list = data['master_list'];
    investorList.addAll(list);
    isLoading = false;
    EasyLoading.dismiss();
    setState(() {});
    return 0;
  }

  Future getGroupEmailInvestor() async {
    pageId = 1;

    String tempSort = selectedSort;
    if (selectedSort.contains("Alphabet")) {
      tempSort = selectedSort.replaceAll("-", ""); //Alphabet AZ
      tempSort = tempSort.replaceAll(" ", "-"); //Alphabet-AZ
    }

    EasyLoading.show();
    Map data = await Api.getGroupEmailInvestor(
      user_id: userId,
      client_name: clientName,
      branch: selectedBranch == "All" ? "" : selectedBranch,
      rm_name: selectedRm == "All" ? "" : selectedRm,
      subbroker_name: selectedSubBroker == "All" ? "" : selectedSubBroker,
      page_id: pageId,
      search: searchKey,
      sort_by: tempSort,
      customer_type: 3,
      rating_type: selectedCustomerType,
    );
    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      return 0;
    }
    totalCount = data['total_count'];

    investorList = data['master_list'];

    setState(() {});
    EasyLoading.dismiss();
    return 0;
  }

  Future getAllBranch() async {
    if (branchList.isNotEmpty) return 0;
    Map data = await Api.getAllBranch(mobile: mobile, client_name: clientName);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    branchList = List<String>.from(data['list']);
    print("branchListttt ${branchList.length}");
    branchList.insert(0, "All");
    return 0;
  }

  Future getAllRM() async {
    if (rmList.isNotEmpty) return 0;
    Map data = await Api.getAllRM(
        mobile: mobile,
        client_name: clientName,
        branch: selectedBranch == "All" ? "" : selectedBranch);

    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    rmList = List<String>.from(data['list']);
    rmList.insert(0, "All");
    return 0;
  }

  Future getAllSubBroker() async {
    if (subBrokerList.isNotEmpty) return 0;
    Map data = await Api.getAllSubbroker(
        mobile: mobile,
        client_name: clientName,
        rm_name: selectedRm == "All" ? "" : selectedRm);

    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    subBrokerList = List<String>.from(data['list']);
    subBrokerList.insert(0, "All");
    return 0;
  }

  Future sendFamilyEmailCurrentPortfolioReportPDF() async {
    EasyLoading.show();
    Map data = await Api.sendFamilyEmailCurrentPortfolioReportPDF(
      client_name: clientName,
      ids: userIdsSeparator,
      type: "",
      selected_date: format.format(selectedPortfolioDate),
      mail_content: "",
      folio_type: "",
      content_option: "",
      download_type: "",
      email_option: "",
      sel_from_email: "",
      pdf_email_option: selectedEmailOption,
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    EasyLoading.dismiss();
    Fluttertoast.showToast(
        msg: data['msg'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Config.appTheme.themeColor,
        textColor: Colors.white,
        fontSize: 16.0);
    return 0;
  }

  Future getDatas() async {
    if (!isFirst) return 0;
    //await getAllBranch();
    await getAllRM();
    if(type_id != UserType.ASSOCIATE) await getAllSubBroker();
    await getGroupEmailInvestor();
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

  Timer? searchOnStop;

  searchHandler(String search) {
    searchKey = search;
    pageId = 1;
    const duration = Duration(milliseconds: 1000);
    if (searchOnStop != null) {
      setState(() {
        searchOnStop!.cancel();
      });
    }
    setState(() {
      searchOnStop = Timer(duration, () async {
        await getGroupEmailInvestor();
      });
    });
  }

  String getFirst20(String text) {
    String s = text.split(":").first;
    if (s.length > 25) s = '${s.substring(0, 25)}...';
    return s;
  }

  bool isAllSelected = false;
  TextStyle underlineText = TextStyle(
      color: Config.appTheme.themeColor,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w500,
      fontSize: 14);

  void selectAll() {
    setState(() {
      if (isAllSelected) {
        // Unselect All
        isCheckedMap.forEach((key, _) {
          isCheckedMap[key] = false;
        });
        isCheckedMap.clear();
        checkedEmails.clear();
        userIds.clear();
      } else {
        // Select All
        for (var data in investorList) {
          String name = data['name'] ?? "";
          String email = data['email'] ?? "";
          num id = num.parse(data['user_id']);
          isCheckedMap[name] = true;
          if (!checkedEmails.contains(email)) {
            checkedEmails.add(email);
            userIds.add(id);
          }
        }
      }
      isAllSelected = !isAllSelected;
    });
  }

  String searchKey = "";
  bool isSearching = false;
  Map<String, bool> isCheckedMap = {};
  List<String> checkedEmails = [];
  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: getDatas(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Config.appTheme.themeColor,
            leadingWidth: 0,
            toolbarHeight: 120,
            foregroundColor: Colors.white,
            elevation: 0,
            leading: SizedBox(),
            title: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      child: Icon(Icons.arrow_back),
                      onTap: () {
                        Get.back();
                      },
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Group Email - Family Portfolio",
                      style: AppFonts.f50014Black
                          .copyWith(fontSize: 18, color: Colors.white),
                    ),
                    Spacer(),
                    if(type_id == UserType.ADMIN)
                    IconButton(
                        icon: Icon(Icons.filter_alt_outlined),
                        onPressed: () {
                          searchKey = "";

                          setState(() {});
                          showCustomizedSummaryBottomSheet();
                        }),
                  ],
                ),
                if(type_id != UserType.ADMIN)
                  SizedBox(height: 10,),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: SearchText(
                        hintText: "Search",
                        onChange: (val) => searchHandler(val),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          body: Container(
            color: Config.appTheme.mainBgColor,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: devWidth,
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Column(
                            children: [
                              if (investorList.isNotEmpty) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${Utils.formatNumber(investorList.length)} Investors of ${Utils.formatNumber(totalCount)}",
                                      style: AppFonts.f50014Grey,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        selectAll();
                                      },
                                      child: Text(
                                        isAllSelected
                                            ? 'Unselect All'
                                            : 'Select All',
                                        style: underlineText,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 16, 16, 0),
                          child: Column(
                            children: [investorCard()],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: devWidth,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        8), // Set the desired corner radius
                  ),
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        userIdsSeparator = "";
                        if (checkedEmails.length > 100) {
                          Utils.showError(context,
                              "Please select the investor upto 100 members only.");
                          return;
                        }
                        if (userIds.isEmpty) {
                          Utils.showError(context, "Please select the Users");
                          return;
                        }

                        userIdsSeparator = userIds.join(',');
                        userIdsSeparator = userIdsSeparator
                            .replaceAll("[", "")
                            .replaceAll("]", "");

                        print("user_String_id $userIdsSeparator");
                        await sendFamilyEmailCurrentPortfolioReportPDF();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Set the desired corner radius
                        ),
                        backgroundColor: Config.appTheme.buttonColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text("SEND EMAIL (${checkedEmails.length})"),
                    ),
                  ),
                ),
                // Container(
                //   width: devWidth,
                //   padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: <Widget>[
                //           SizedBox(
                //             height: 45,
                //             child: ElevatedButton(
                //               onPressed: () async {
                //                 if (checkedEmails.length > 100) {
                //                   Utils.showError(context,
                //                       "Please select the investor upto 100 members only.");
                //                   return;
                //                 }
                //                 if (userIds.isEmpty) {
                //                   Utils.showError(
                //                       context, "Please select the Users");
                //                   return;
                //                 }
                //                 if (sendAdminMail == "N" &&
                //                     sendClientMail == "N") {
                //                   Utils.showError(
                //                       context, "Please Choose the Mail Type");
                //                   return;
                //                 }
                //                 // userIdsSeparator = userIds.join(',');
                //                 // userIdsSeparator = userIdsSeparator
                //                 //     .replaceAll("[", "")
                //                 //     .replaceAll("]", "");

                //                 // print("user_String_id $userIdsSeparator");
                //                 // submitType = "Email";
                //                 // await sendOrDownloadTaxPackage();
                //               },
                //               style: ElevatedButton.styleFrom(
                //                 shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(
                //                       8), // Set the desired corner radius
                //                 ),
                //                 backgroundColor: Config.appTheme.themeColor,
                //                 foregroundColor: Colors.white,
                //               ),
                //               child: Text(
                //                 "SEND Email (${checkedEmails.length})",
                //                 style: AppFonts.f50014Black
                //                     .copyWith(color: Colors.white),
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget investorCard() {
    if (investorList.isEmpty) {
      if (isLoading) {
        return Utils.shimmerWidget(devHeight,
            margin: EdgeInsets.fromLTRB(16, 0, 0, 16));
      } else {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: NoData(),
        );
      }
    } else {
      return SizedBox(
        height: devHeight * 0.92,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: investorList.length,
                controller: scrollController,
                itemBuilder: (context, index) {
                  Map data = investorList[index];

                  return GestureDetector(
                    onTap: () async {},
                    child: investorTile(data),
                  );
                },
              ),
            ),
            SizedBox(height: 220),
          ],
        ),
      );
    }
  }

  List<num> userIds = [];
  Widget investorTile(Map data) {
    String name = data['name'];
    String email = data['email'];
    num id = num.parse(data['user_id']);

    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: isCheckedMap[name] ?? false,
                onChanged: (newValue) {
                  setState(() {
                    isCheckedMap[name] = newValue ?? false;
                    if (newValue == true) {
                      checkedEmails.add(email);
                      userIds.add(id);
                      print("checkedUserId $userIds");
                    } else {
                      checkedEmails.remove(email);
                      userIds.remove(id);
                      print("checkedUserId $userIds");
                      print("checkedEmails $checkedEmails");
                    }
                  });
                },
              ),
              Expanded(
                child: Container(
                  width: devWidth,
                  padding: EdgeInsets.fromLTRB(16, 16, 8, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InitialCard(
                              title: (data['name'] == "") ? "." : data['name']),
                          SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getFirst20(data['name']),
                                  style: AppFonts.f50014Black,
                                ),
                                Text(
                                  data['pan'],
                                  style: AppFonts.f40013,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Icon(Icons.alternate_email,
                              size: 16,
                              color: Config.appTheme.readableGreyTitle),
                          SizedBox(width: 2),
                          Expanded(
                              child:
                                  Text(data['email'], style: AppFonts.f40013)),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Icon(Icons.call_outlined,
                              size: 16, color: Config.appTheme.themeColor),
                          SizedBox(width: 2),
                          Text(
                            data['mobile'],
                            style: AppFonts.f50012.copyWith(
                              decorationColor: Config.appTheme.themeColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

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
          return SizedBox(
            height: devHeight * 0.54,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BottomSheetTitle(title: "Customize Report"),
                SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          padding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              portfolioDateExpansionTile(context, bottomState),
                              SizedBox(height: 4),
                              customerTypeExpansionTile(context, bottomState),
                              SizedBox(height: 4),
                              emailExpansionTile(context, bottomState),
                              SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 75,
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getCancelApplyButton(ButtonType.plain),
                      SizedBox(width: 48),
                      getCancelApplyButton(ButtonType.filled),
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

  Widget portfolioDateExpansionTile(
      BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: portfolioDatecontroller,
            title: Text("Select Portfolio as on Date",
                style: AppFonts.f50014Black),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Utils.getFormattedDate(date: selectedPortfolioDate),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Config.appTheme.themeColor)),
              ],
            ),
            children: [
              SizedBox(
                height: 180,
                child: ScrollDatePicker(
                  selectedDate: selectedPortfolioDate,
                  maximumDate: DateTime.now().subtract(Duration(days: 1)),
                  onDateTimeChanged: (value) {
                    selectedPortfolioDate = value;
                    bottomState(() {});
                  },
                ),
              ),
            ],
          )),
    );
  }

  ExpansionTileController emailController = ExpansionTileController();
  Widget emailExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: emailController,
          onExpansionChanged: (val) {},
          title: Text("Select Email Option", style: AppFonts.f50014Black),
          tilePadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${getKeyByValue(emailOptionMap, selectedEmailOption)}",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Config.appTheme.themeColor)),
              DottedLine(),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: emailOptionMap.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    selectedEmailOption =
                        emailOptionMap.values.elementAt(index);
                    selectedEmailOptionKeys =
                        emailOptionMap.keys.elementAt(index);
                    emailController.collapse();
                    bottomState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: emailOptionMap.values.elementAt(index),
                        groupValue: selectedEmailOption,
                        onChanged: (value) {
                          selectedEmailOption =
                              emailOptionMap.values.elementAt(index);
                          selectedEmailOptionKeys =
                              emailOptionMap.keys.elementAt(index);
                          print("selectedEmailOption $selectedEmailOption");
                          emailController.collapse();
                          bottomState(() {});
                        },
                      ),
                      Text("${emailOptionMap.keys.elementAt(index)}"),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ExpansionTileController customerTypeController = ExpansionTileController();
  Widget customerTypeExpansionTile(
      BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: customerTypeController,
          onExpansionChanged: (val) {},
          title: Text("Select Customer Type", style: AppFonts.f50014Black),
          tilePadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${getKeyByValue(customerTypeMap, selectedCustomerType)}",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Config.appTheme.themeColor)),
              DottedLine(),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: customerTypeMap.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    selectedCustomerType =
                        customerTypeMap.values.elementAt(index);
                    selectedCustomerTypeKeys =
                        customerTypeMap.keys.elementAt(index);
                    customerTypeController.collapse();
                    bottomState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: customerTypeMap.values.elementAt(index),
                        groupValue: selectedCustomerType,
                        onChanged: (value) {
                          selectedCustomerType =
                              customerTypeMap.values.elementAt(index);
                          selectedCustomerTypeKeys =
                              customerTypeMap.keys.elementAt(index);
                          print("selectedOption $selectedOption");
                          customerTypeController.collapse();
                          bottomState(() {});
                        },
                      ),
                      Text("${customerTypeMap.keys.elementAt(index)}"),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  getKeyByValue(Map map, String value) {
    return map.keys.firstWhere((element) => map[element] == value);
  }

  ExpansionTileController branchController = ExpansionTileController();
  Widget branchExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: branchController,
          title: Text("Branch", style: AppFonts.f50014Black),
          tilePadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedBranch, style: AppFonts.f50012),
              DottedLine(),
            ],
          ),
          children: [
            SizedBox(
              height: 100,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: branchList.length,
                      itemBuilder: (context, index) {
                        String title = branchList[index];

                        return InkWell(
                          onTap: () async {
                            selectedBranch = title;
                            print("selectedBranch $selectedBranch");
                            rmList = [];
                            await getAllRM();
                            bottomState(() {});
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: title,
                                groupValue: selectedBranch,
                                onChanged: (temp) async {
                                  selectedBranch = title;
                                  print("selectedBranch $selectedBranch");
                                  rmList = [];
                                  await getAllRM();
                                  bottomState(() {});
                                  setState(() {});
                                },
                              ),
                              Text(title),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ExpansionTileController rmController = ExpansionTileController();
  Widget rmExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: rmController,
          title: Text("RM", style: AppFonts.f50014Black),
          tilePadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedRm, style: AppFonts.f50012),
              DottedLine(),
            ],
          ),
          children: [
            SizedBox(
              height: 100,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: rmList.length,
                      itemBuilder: (context, index) {
                        String title = rmList[index];

                        return InkWell(
                          onTap: () async {
                            selectedRm = title;
                            print("selectedRm $selectedRm");
                            subBrokerList = [];
                            await getAllSubBroker();
                            bottomState(() {});
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: title,
                                groupValue: selectedRm,
                                onChanged: (temp) async {
                                  selectedRm = title;
                                  print("selectedRm $selectedRm");
                                  subBrokerList = [];
                                  await getAllSubBroker();
                                  bottomState(() {});
                                  setState(() {});
                                },
                              ),
                              Text(title),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ExpansionTileController subBrokerController = ExpansionTileController();
  Widget subBrokerExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: subBrokerController,
          title: Text("Associate", style: AppFonts.f50014Black),
          tilePadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedSubBroker, style: AppFonts.f50012),
              DottedLine(),
            ],
          ),
          children: [
            SizedBox(
              height: 100,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: subBrokerList.length,
                      itemBuilder: (context, index) {
                        String title = subBrokerList[index];

                        return InkWell(
                          onTap: () {
                            selectedSubBroker = title;
                            print("selectedSubBroker $selectedSubBroker");
                            bottomState(() {});
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: title,
                                groupValue: selectedSubBroker,
                                onChanged: (temp) {
                                  selectedSubBroker = title;
                                  print("selectedSubBroker $selectedSubBroker");
                                  bottomState(() {});
                                },
                              ),
                              Expanded(child: Text(title)),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCancelApplyButton(ButtonType type) {
    if (type == ButtonType.plain)
      return PlainButton(
        color: Config.appTheme.buttonColor,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        text: "CANCEL",
        onPressed: () {
          Get.back();
        },
      );
    else
      return RpFilledButton(
        color: Config.appTheme.buttonColor,
        text: "APPLY",
        onPressed: () async {
          pageId = 1;
          investorList = [];
          await getGroupEmailInvestor();
          print("selectedCustomerType $selectedCustomerType");
          print("selectedCustomerTypeKeys $selectedCustomerTypeKeys");

          print("selectedEmailOption $selectedEmailOption");
          print("selectedEmailOptionKeys $selectedEmailOptionKeys");

          print("selectedOption $selectedOption");
          print("selectedOptionKeys $selectedOptionKeys");

          print("selectedPortfolioDate $selectedPortfolioDate");
          String formattedDate = format.format(selectedPortfolioDate);
          print("selectedPortfolioDate $formattedDate");
          setState(() {});
          Get.back();
        },
      );
  }
}
