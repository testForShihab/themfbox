import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils/Constants.dart';

class BirthdayAnniversary extends StatefulWidget {
  const BirthdayAnniversary({super.key});

  @override
  State<BirthdayAnniversary> createState() => _BirthdayAnniversaryState();
}

class _BirthdayAnniversaryState extends State<BirthdayAnniversary> {
  late double devHeight, devWidth;
  bool isLoading = true;
  int selectedScenario = 1;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  int userId = getUserId();
  String clientName = GetStorage().read("client_name");
  String user_name = GetStorage().read("user_name") ?? "";
  String user_mobile = GetStorage().read("user_mobile") ?? "";

  String concatUserId = "";
  int pageId = 1;
  int totalCount = 0;
  ScrollController scrollController = ScrollController();

  num birthdayCount = 0;
  num anniversaryCount = 0;

  List birthdayList = [];
  List anniversaryList = [];
  Future getInvestorsBirthday({bool merge = false}) async {
    print("merge $merge");
    if (!merge && birthdayList.isNotEmpty) return 0;
    if (merge) {
      EasyLoading.show();
    }
    isLoading = true;
    Map data = await AdminApi.getInvestorsBirthday(
        user_id: userId, client_name: clientName, page_id: pageId);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    if (merge) {
      List newBirthdays = data['master_list'];
      birthdayList.addAll(newBirthdays);
    } else {
      birthdayCount = data['count'];
      birthdayList = data['master_list'];
    }
    totalCount = birthdayList.length;
    print("totalcount ${birthdayList.length}");
    if (merge) {
      EasyLoading.dismiss();
    }
    isLoading = false;

    return 0;
  }

  Future scrollListener() async {
    double extentAfter = scrollController.position.extentAfter;
    if (selectedScenario == 1) {
      if (extentAfter < 25 && scrollController.position.atEdge) {
        print("scrollListener");
        pageId++;
        await getInvestorsBirthday(merge: true);
        print("scrollListener $pageId");
        setState(() {});
      }
    } else {
      if (extentAfter < 25 &&
          scrollController.position.atEdge &&
          totalCount != anniversaryList.length) {
        pageId++;
        await getInvestorsAnniversary(merge: true);
        setState(() {});
      }
    }
  }

  Future sendInvestorBirthDayOrAnniversaryEmail() async {
    print("concatUserIds $concatUserId");
    EasyLoading.show();
    Map data = await AdminApi.sendInvestorBirthDayOrAnniversaryEmail(
      user_id: userId,
      client_name: clientName,
      user_ids: concatUserId,
      type: selectedScenario == 1 ? 'birthday' : 'anniversary',
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    } else {
      Fluttertoast.showToast(
          msg:
              "${(selectedScenario == 1) ? 'Birthday' : 'Anniversary'} Email Sent Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Config.appTheme.themeColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    EasyLoading.dismiss();
    return 0;
  }


  Future getInvestorsAnniversary({bool merge = false}) async {
    if (!merge) {
      if (anniversaryList.isNotEmpty) return 0;
    }

    isLoading = true;
    Map data = await AdminApi.getInvestorsAnniversary(
        user_id: userId, client_name: clientName, page_id: pageId);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    if (merge) {
      EasyLoading.show();
      List newAnniversary = data['master_list'];
      anniversaryList.addAll(newAnniversary);
      EasyLoading.dismiss();
    } else {
      anniversaryCount = data['total_count'] ?? 0;
      anniversaryList = data['master_list'];
    }
    totalCount = anniversaryList.length;
    print("totalcount ${anniversaryList.length}");
    isLoading = false;

    return 0;
  }

  Future getDatas() async {
    await getContactDetailsByClientName();
    await getInvestorsBirthday();
    await getInvestorsAnniversary();

    return 0;
  }

  String companyName = "";
  String companyEmail = "";

  Future getContactDetailsByClientName() async {
    Map<String, dynamic> data = await InvestorApi.getContactDetailsByClientName(
      client_name: clientName,
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    companyName = data['result']['company_name'] ?? "";
    companyEmail = data['result']['company_email'] ?? "";
    print("companyName $companyName");

    return 0;
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
      if (selectedScenario == 1) {
        if (isAllSelected) {
          // Unselect All
          isCheckedMap.forEach((key, _) {
            isCheckedMap[key] = false;
          });
          isCheckedMap.clear();
          checkeduserIds.clear();
        } else {
          // Select All
          for (var data in birthdayList) {
            String name = data['name'];
            String email = data['email']!;
            String birthdayUserId = data['user_id'].toString();
            isCheckedMap[name] = true;
            if (!checkeduserIds.contains(userId)) {
              checkeduserIds.add(birthdayUserId);
            }
          }
        }
      } else {
        if (isAllSelected) {
          // Unselect All
          isCheckedMap.forEach((key, _) {
            isCheckedMap[key] = false;
          });
          isCheckedMap.clear();
          checkeduserIds.clear();
        } else {
          // Select All
          for (var data in anniversaryList) {
            String name = data['name'];
            String email = data['email']!;
            String anniversaryUserId = data['user_id'].toString();
            isCheckedMap[name] = true;
            if (!checkeduserIds.contains(userId)) {
              checkeduserIds.add(anniversaryUserId);
            }
          }
        }
      }
      isAllSelected = !isAllSelected;
      concatUserId = checkeduserIds.join(',');

      print("concatenatedString $concatUserId");
    });
  }

  Map<String, bool> isCheckedMap = {};
  List<String> checkeduserIds = [];

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: getDatas(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: rpAppBar(
            title: "Birthday & Anniversaries",
            bgColor: Config.appTheme.themeColor,
            foregroundColor: Colors.white,
          ),
          body: Container(
            color: Config.appTheme.mainBgColor,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                          padding: EdgeInsets.fromLTRB(16, 16, 8, 0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: getButton(1),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: getButton(2),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Column(
                            children: [
                              if (selectedScenario == 1 &&
                                  birthdayList.isNotEmpty) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${(selectedScenario == 1) ? birthdayCount : anniversaryCount} Investors",
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
                              if (selectedScenario == 2 &&
                                  anniversaryList.isNotEmpty) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${anniversaryList.length} Investors",
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
                            children: [
                              SizedBox(height: 8.0),
                              selectedScenario == 1
                                  ? birthdayCard()
                                  : anniversaryCard(),
                            ],
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
                        if (checkeduserIds.isEmpty) {
                          Utils.showError(context, "Please select the Users");
                          return;
                        }
                        if (concatUserId == "") {
                          Utils.showError(context, "Please select the Users");
                          return;
                        }
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm"),
                                content: Text(
                                    "Would you like to send email for selected Investors?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text("No")),
                                  TextButton(
                                      onPressed: () async {
                                        await sendInvestorBirthDayOrAnniversaryEmail();
                                        Get.back();
                                        isCheckedMap.clear();
                                        checkeduserIds.clear();
                                      },
                                      child: Text("Yes")),
                                ],
                              );
                            });

                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Set the desired corner radius
                        ),
                        backgroundColor: Config.appTheme.buttonColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text("SEND EMAIL(${checkeduserIds.length})"),
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

  Widget getButton(int scenario) {
    String buttonText = scenario == 1
        ? "Birthday ($birthdayCount)"
        : "Anniversary ($anniversaryCount)";

    if (selectedScenario == scenario) {
      return RpFilledButton(
        text: buttonText,
        padding: EdgeInsets.zero,
      );
    } else {
      return PlainButton(
        text: buttonText,
        padding: EdgeInsets.zero,
        onPressed: () async {
          print("button pressed $scenario");
          selectedScenario = scenario;
          if (scenario == 2) await getInvestorsAnniversary();
          checkeduserIds.length = 0;
          isAllSelected = false;
          isCheckedMap.forEach((key, _) {
            isCheckedMap[key] = false;
          });
          isCheckedMap.clear();
          checkeduserIds.clear();
          setState(() {});
          print("scenario $scenario");
          if (selectedScenario != scenario) {
            print("scenario $scenario");
            print("selectedScenario $selectedScenario");
          }
        },
      );
    }
  }

  Widget birthdayCard() {
    if (selectedScenario == 1 && birthdayList.isEmpty) {
      if (isLoading) {
        return Utils.shimmerWidget(devHeight,
            margin: EdgeInsets.fromLTRB(16, 16, 0, 16));
      } else {
        return birthAnniversaryEmptyTile();
      }
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: birthdayList.length,
        itemBuilder: (context, index) {
          Map data = birthdayList[index];

          return GestureDetector(
            onTap: () async {},
            child: birthdayAnniversaryTile(data),
          );
        },
      );
    }
  }

  Widget anniversaryCard() {
    print('Selected Scenario: $selectedScenario');
    print('Anniversary List: $anniversaryList');
    if (selectedScenario == 2 && anniversaryList.isEmpty) {
      if (isLoading) {
        return Utils.shimmerWidget(100,
            margin: EdgeInsets.fromLTRB(16, 16, 0, 16));
      } else {
        return birthAnniversaryEmptyTile();
      }
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: anniversaryList.length,
        itemBuilder: (context, index) {
          Map dataAnniversary = anniversaryList[index];
          print('Anniversary Item $index: $dataAnniversary');
          return GestureDetector(
            onTap: () async {},
            child: birthdayAnniversaryTile(dataAnniversary),
          );
        },
      );
    }
  }

  Widget birthdayAnniversaryTile(Map data) {
    String dob = data['dob'] ?? data['anniversary_date'];
    String birthdayUserId = data['user_id'].toString();
    String name = data['name'];
    String email = data['email'];
    String mobile = data['mobile'];

    return GestureDetector(
      onTap: () {
        // Implement onTap functionality here
        birthAnniversarySheet(birthdayUserId, name, email, mobile);
      },
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
                      checkeduserIds.add(birthdayUserId);
                      print("userId $userId");
                    } else {
                      checkeduserIds.remove(birthdayUserId);
                      print("userId $userId");
                    }
                  });
                  print("checkeduserIds $checkeduserIds");

                  concatUserId = checkeduserIds.join(',');
                  print("concatenatedString $concatUserId");
                  // 655178,1103370
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
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InitialCard(title: data['name']),
                              SizedBox(width: 6),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getFirst13(data['name']),
                                      style: AppFonts.f50014Black,
                                    ),
                                    if (selectedScenario == 1)
                                      Text(
                                        "${data['age']} years",
                                        style: AppFonts.f40013.copyWith(color: Colors.black),
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
                                  dob,
                                  style: AppFonts.f40013.copyWith(
                                    color: Config.appTheme.themeColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Icon(Icons.mail_outline,
                                  size: 16, color: Config.appTheme.readableGreyTitle),
                              SizedBox(width: 2),
                              Expanded(child: Text(data['email'], style: AppFonts.f40013)),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Icon(Icons.call_outlined,
                                  size: 16, color: Config.appTheme.readableGreyTitle),
                              SizedBox(width: 2),
                              Text(
                                data['mobile'],
                                style: AppFonts.f50012.copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Config.appTheme.themeColor,
                                ),
                              ),
                              if (data['dob'] != null) Spacer(),
                            ],
                          ),
                        ],
                      ),
                      if (data["mobile"] != null && data["mobile"].isNotEmpty)
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: IconButton(
                            icon: Image.asset("assets/whatsapp_icon.png", width: 28),
                            onPressed: () {
                              print("companyName $companyName + $companyEmail");
                              _sendBirthdayMessage(data['name'], data['mobile'], companyName, companyEmail);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              )

            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

Future<void> _sendBirthdayMessage(String userName, String userMobile, String companyName, String companyEmail) async {
  if (userMobile.isEmpty) {
    throw 'User mobile is null or empty';
  }


  String formattedMobile = userMobile;
  if (!userMobile.startsWith('91')) {
    formattedMobile = '91$userMobile';
  }

  print("formatted mobile number $formattedMobile");

  var message = '''Greetings for the Day!

Dear $userName,

$companyName wishes you a lifetime of happiness and good health on your special day! 
We will always be with you and help you achieve every financial goal of your life.

Here's wishing you a very special birthday.

Write to us at $companyEmail

Happy Investing!
Team $companyName''';
  var whatsappUrl = "https://wa.me/$formattedMobile?text=${Uri.encodeComponent(message)}";

  await launch(whatsappUrl);
  print("whatsappUrl $whatsappUrl");
}


  birthAnniversarySheet(
      String birthdayUserId, String name, String Email, String Mobile) {
    showModalBottomSheet(
      backgroundColor: Config.appTheme.mainBgColor,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SizedBox(
              height: devHeight * 0.37,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: devWidth * 0.05, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color:
                                Config.appTheme.placeHolderInputTitleAndArrow,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => makePhoneCall(Mobile),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.phone_forwarded_outlined,
                                  size: 24,
                                  color: Config.appTheme.themeColor,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Call on $Mobile",
                                  style: AppFonts.f50014Black.copyWith(
                                    color: Config.appTheme.themeColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Row(
                          //   children: [
                          //     Icon(Icons.phone_forwarded_outlined,
                          //         size: 24, color: Config.appTheme.themeColor),
                          //     SizedBox(width: 8),
                          //     Text("Call on $Mobile",
                          //         style: AppFonts.f50014Black.copyWith(
                          //             color: Config.appTheme.themeColor)),
                          //   ],
                          // ),
                          DottedLine(verticalPadding: 8),
                          GestureDetector(
                            onTap: () {
                              String valueToCopy =
                                  Mobile; // Replace with the value you want to copy
                              Clipboard.setData(
                                  ClipboardData(text: valueToCopy));
                              // Show a feedback message to indicate that the value has been copied
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    Text('Copied to clipboard: $valueToCopy'),
                              ));
                            },
                            child: Row(
                              children: [
                                Icon(Icons.content_copy_outlined,
                                    size: 24,
                                    color: Config.appTheme.themeColor),
                                SizedBox(width: 8),
                                Text("Copy Phone Number",
                                    style: AppFonts.f50014Black.copyWith(
                                        color: Config.appTheme.themeColor)),
                              ],
                            ),
                          ),
                          DottedLine(verticalPadding: 8),
                          GestureDetector(
                            onTap: () => _sendMessage(Mobile),
                            child: Row(
                              children: [
                                Icon(Icons.message_outlined,
                                    size: 24,
                                    color: Config.appTheme.themeColor),
                                SizedBox(width: 8),
                                Text("Send Message",
                                    style: AppFonts.f50014Black.copyWith(
                                        color: Config.appTheme.themeColor)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget listContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16),

      // child: ListView.separated(
      //   physics: NeverScrollableScrollPhysics(),
      //   shrinkWrap: true,
      //   itemCount: dataBottomSheet.length,
      //   separatorBuilder: (context, index) {
      //     return SizedBox(
      //       height: 18,
      //       child: DottedLine(),
      //     );
      //   },
      //   itemBuilder: (context, index) {
      //     String title = dataBottomSheet.keys.elementAt(index);
      //     List stitle = dataBottomSheet.values.elementAt(index);
      //     IconData iconData = stitle[2];

      //     return Padding(
      //       padding: EdgeInsets.symmetric(vertical: 4),
      //       child: InkWell(
      //         onTap: () {
      //           if (stitle[1] != null) Get.to(stitle[1]);
      //         },
      //         child: RpListTile(
      //           title: SizedBox(
      //             width: 220,
      //             child: Text(
      //               title,
      //               style: AppFonts.f50014Black
      //                   .copyWith(color: Config.appTheme.themeColor),
      //             ),
      //           ),
      //           subTitle: Visibility(
      //             visible: stitle[0].isNotEmpty,
      //             child: Text(stitle[0], style: AppFonts.f40013),
      //           ),
      //           leading: Icon(
      //             iconData,
      //             color: Config.appTheme.themeColor,
      //             size: 24,
      //           ),
      //           showArrow: false,
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }

  Widget birthAnniversaryEmptyTile() {
    return Container(
      width: devWidth,
      margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset(
                      selectedScenario == 1
                          ? "assets/cake_gray.png"
                          : "assets/celebration.png",
                      height: 30),
                  SizedBox(height: 16),
                  Text(
                      selectedScenario == 1
                          ? "No Birthday Today."
                          : "No Anniversary Today.",
                      style: AppFonts.f40013),
                  SizedBox(width: 5),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
