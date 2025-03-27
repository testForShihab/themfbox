import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/SearchText.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ShareViaEmail extends StatefulWidget {
  ShareViaEmail({super.key, required this.url});
  String url;
  @override
  State<ShareViaEmail> createState() => _ShareViaEmailState();
}

class _ShareViaEmailState extends State<ShareViaEmail> {
  late double devHeight, devWidth;
  bool isLoading = true;
  ScrollController scrollController = ScrollController();
  bool isFirst = true;
  Map summary = {};
  bool investorFetching = false;
  int userId = getUserId();
  String clientName = GetStorage().read("client_name");
  int page_id = 1;
  List userList = [];
  late num totalInvestors;
  late String url;
  late String type;
  num totalCount = 0;

  Future getInvestorsSummaryDetails() async {
    if (summary.isNotEmpty) return 0;

    Map data = await AdminApi.getInvestorsSummaryDetails(
        user_id: userId, client_name: clientName);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    summary = data['summary'];
    totalInvestors = summary['total_investor_count'];
    isLoading = false;

    return 0;
  }

  @override
  void initState() {
    //  implement initState
    super.initState();
    scrollController.addListener(scrollListener);
    url = widget.url;
  }

  Future scrollListener() async {
    double extentAfter = scrollController.position.extentAfter;
    if (searchKey.isNotEmpty) return;
    if (extentAfter < 100.0 && investorFetching == false) {
      investorFetching = true;
      page_id += 1;
      await getInvestors(merge: true);
    }
  }

  Future getInvestors({String search = "", bool merge = false}) async {
    EasyLoading.show();
    print("merge = $merge");
    if (!merge) userList = [];
    Map data = await AdminApi.getInvestors(
      page_id: page_id,
      client_name: clientName,
      user_id: userId,
      search: search,
      sortby: "alphabet-az",
      branch: "",
      rmList: [],
    );
    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      return 0;
    }
    totalCount = data['total_count'];
    if (merge) {
      List newUserList = data['list'];
      userList.addAll(newUserList);
    } else {
      userList = data['list'];
    }
    setState(() {});
    investorFetching = false;

    EasyLoading.dismiss();
    return 0;
  }

  Future getDatas() async {
    if (!isFirst) return 0;
    await getInvestorsSummaryDetails();
    await getInvestors();
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
    const duration = Duration(milliseconds: 1000);
    if (searchOnStop != null) {
      setState(() {
        searchOnStop!.cancel();
      });
    }
    setState(() {
      searchOnStop = Timer(duration, () async {
        await getInvestors(search: search);
      });
    });
  }

  String getFirst13(String text) {
    String s = text.split(":").first;
    if (s.length > 13) s = '${s.substring(0, 13)}...';
    return s;
  }

  bool isAllSelected = false;
  TextStyle underlineText = TextStyle(
      color: Config.appTheme.themeColor,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w500,
      fontSize: 14);

  void makePhoneCall(String phoneNumber) async {
    final String telUrl = 'tel:$phoneNumber';
    await launchUrlString(telUrl);
  }

  void _sendMessage(String phoneNumber) async {
    final String smsUrl = 'sms:$phoneNumber';
    await launchUrlString(smsUrl);
  }

  void selectAll() {
    setState(() {
      if (isAllSelected) {
        // Unselect All
        isCheckedMap.forEach((key, _) {
          isCheckedMap[key] = false;
        });
        isCheckedMap.clear();
        checkedEmails.clear();
        user_id.clear();
        print("user id $user_id");
      } else {
        // Select All
        for (var data in userList) {
          String name = data['name'];
          String email = data['email']!;
          int id = data['id']!;
          isCheckedMap[name] = true;
          if (!checkedEmails.contains(email)) {
            checkedEmails.add(email);
            user_id.add(id);
            print("user id $user_id");
          }
        }
      }
      isAllSelected = !isAllSelected; // Toggle the state
    });
  }

  String searchKey = "";
  bool isSearching = false;
  Map<String, bool> isCheckedMap = {}; // Map to store checkbox state
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
                      "Share With",
                      style: AppFonts.f50014Black
                          .copyWith(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 20),
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
                              if (userList.isNotEmpty) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${Utils.formatNumber(userList.length)} Investors of ${Utils.formatNumber(totalCount)}",
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
                          padding: EdgeInsets.fromLTRB(0, 0, 16, 16),
                          child: Column(
                            children: [SizedBox(height: 8.0), investorCard()],
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
                        String user_String_id = user_id.join(',');
                        user_String_id = user_String_id
                            .replaceAll("[", "")
                            .replaceAll("]", "");
                        EasyLoading.show();
                        url += "&user_id=$user_String_id&type=email";
                        http.Response response =
                            await http.post(Uri.parse(url));
                        String msgUrl = response.body;
                        Map data = jsonDecode(msgUrl);
                        String resUrl = data['msg'];
                        print("ShareEmail = $url");
                        EasyLoading.dismiss();
                        Fluttertoast.showToast(
                            msg: resUrl, //'Email Send Successfully',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Config.appTheme.themeColor,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Set the desired corner radius
                        ),
                        backgroundColor: Config.appTheme.themeColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text("SEND EMAIL(${checkedEmails.length})"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget investorCard() {
    if (userList.isEmpty) {
      if (isLoading) {
        return Utils.shimmerWidget(devHeight,
            margin: EdgeInsets.fromLTRB(16, 16, 0, 16));
      } else {
        return Padding(
            padding: EdgeInsets.only(top: devHeight * 0.2),
            child: Text("No Data Available"));
      }
    } else {
      return SizedBox(
        height: devHeight * 0.85,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: userList.length,
                controller: scrollController,
                itemBuilder: (context, index) {
                  Map data = userList[index];

                  return GestureDetector(
                    onTap: () async {},
                    child: investorTile(data),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  List<num> user_id = [];
  Widget investorTile(Map data) {
    String name = data['name'];
    String email = data['email'];
    num id = data['id'];

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
                      user_id.add(id);
                      print("user id $user_id");
                    } else {
                      checkedEmails.remove(email);
                      user_id.remove(id);
                      print("checkedEmails $checkedEmails");   
                      print("user id $user_id");
                    }
                  });
                },
              ),
              Expanded(
                child: Container(
                  width: devWidth,
                  padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InitialCard(title: (data['name'] == "") ? "." : data['name']),
                          SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getFirst13(data['name']),
                                  style: AppFonts.f50014Black,
                                ),
                                Text(
                                  "${data['email']}",
                                  style: AppFonts.f40013
                                      .copyWith(color: Colors.black),
                                ),
                              ],
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
}
