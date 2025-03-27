import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/SearchText.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;

class InvestorLoginCredential extends StatefulWidget {
  const InvestorLoginCredential({super.key});

  @override
  State<InvestorLoginCredential> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<InvestorLoginCredential> {
  late double devHeight, devWidth;
  bool isLoading = true;
  ScrollController scrollController = ScrollController();
  bool isFirst = true;
  bool investorFetching = false;
  int userId = getUserId();
  String clientName = GetStorage().read("client_name");
  int page_id = 1;
  List userList = [];

  num totalCount = 0;
  late String url;
  late String type;
  String selectedLeft = "Sort By";
  String selectedSort = "Alphabet A-Z";

  @override
  void initState() {
    //  implement initState
    super.initState();
    scrollController.addListener(scrollListener);
    // url = widget.url;
  }

  Future scrollListener() async {
    bool atBottom = scrollController.position.extentAfter < 100;
    bool fullyLoaded = userList.length == totalCount;

    bool fetchAgain = atBottom && !fullyLoaded && !isLoading;

    if (fetchAgain) await getMoreInvestors();
  }

  Future getInvestors() async {
    page_id = 1;

    String tempSort = selectedSort;
    if (selectedSort.contains("Alphabet")) {
      tempSort = selectedSort.replaceAll("-", "");
      tempSort = tempSort.replaceAll(" ", "-");
    }

    Map data = await AdminApi.getInvestors(
      page_id: page_id,
      client_name: clientName,
      user_id: userId,
      search: searchKey,
      sortby: tempSort,
      branch: "",
      rmList: [],
      subbroker_name: "",
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    totalCount = data['total_count'] ?? 0;
    List list = data['list'];
    userList.addAll(list);
    setState(() {
      print('State updated: $userList');
    });
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
      client_name: clientName,
      user_id: userId,
      search: searchKey,
      sortby: tempSort,
      branch: "",
      rmList: [],
      subbroker_name: "",
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    List list = data['list'];
    userList.addAll(list);
    isLoading = false;
    EasyLoading.dismiss();
    setState(() {});

    return 0;
  }

  Future getDatas() async {
    if (!isFirst) return 0;
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
      searchOnStop!.cancel();
    }

    searchOnStop = Timer(duration, () async {
      EasyLoading.show(status: "searching for `$searchKey`");
      userList = [];
      await getInvestors();
      EasyLoading.dismiss();
      setState(() {});
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
      } else {
        // Select All
        for (var data in userList) {
          num id = data['id'];
          String name = data['name'];
          String email = data['email']!;
          isCheckedMap[name] = true;
          if (!checkedEmails.contains(email)) {
            checkedEmails.add(email);
            user_id.add(id);
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
                          padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
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
                        if (user_id.isEmpty) {
                          Utils.showError(context, "Please select the Users");
                          return;
                        }
                        String user_String_id = user_id.join(',');
                        user_String_id = user_String_id
                            .replaceAll("[", "")
                            .replaceAll("]", "");
                        EasyLoading.show();
                        print("user_String_id $user_String_id");
                        String url =
                            "${ApiConfig.apiUrl}/sendLoginDetailsToInvestors?key=${ApiConfig.apiKey}&client_name=$clientName&user_id=$user_String_id";

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
                        EasyLoading.dismiss();
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
            margin: EdgeInsets.fromLTRB(16, 0, 0, 16));
      } else {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: NoData(),
        );
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
    num aum = data['aum'];
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
                      user_id.remove(id);
                      checkedEmails.remove(email);
                      print("user id $user_id");
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
                                  getFirst13(data['name']),
                                  style: AppFonts.f50014Black,
                                ),
                                Text(
                                  getFirst13(data['pan']),
                                  style: AppFonts.f40013,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xffECFFFF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(6),
                            child: Text(
                              "$rupee ${Utils.formatNumber(aum.round(), isAmount: true)}",
                              style: AppFonts.f40013
                                  .copyWith(color: Config.appTheme.themeColor),
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
              // Expanded(
              //   child: Container(
              //     width: devWidth,
              //     padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Row(
              //           children: [
              //             InitialCard(title: data['name']),
              //             SizedBox(width: 6),
              //             Expanded(
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text(
              //                     getFirst13(data['name']),
              //                     style: AppFonts.f50014Black,
              //                   ),
              //                   Text(
              //                     "${data['email']}",
              //                     style: AppFonts.f40013
              //                         .copyWith(color: Colors.black),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
