import 'dart:async';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/SearchText.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Restrictions.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TaxPackage extends StatefulWidget {
  const TaxPackage({super.key});

  @override
  State<TaxPackage> createState() => _TaxPackageState();
}

class _TaxPackageState extends State<TaxPackage> {
  late double devHeight, devWidth;
  bool isLoading = true;
  ScrollController scrollController = ScrollController();
  bool isFirst = true;
  Map summary = {};
  bool investorFetching = false;
  int userId = getUserId();
  String mobile = GetStorage().read("mfd_mobile");
  String clientName = GetStorage().read("client_name");
  int pageId = 1;
  List investorList = [];
  late num totalInvestors;
  num totalCount = 0;
  late String url;
  late String type;
  List branchList = [];
  List rmList = [];
  List subBrokerList = [];
  bool mailToClientValue = false;
  bool mailToAdminValue = false;
  String userIdsSeparator = "";
  String selectedBranch = "All";
  String selectedRm = "All";
  String selectedSubBroker = "All";
  List financialYearList = [];
  String selectedFinancialYear = "";

  String submitType = "";
  String sendClientMail = "N";
  String sendAdminMail = "N";
  final Dio _dio = Dio();

  @override
  void initState() {
    //  implement initState
    super.initState();
    scrollController.addListener(scrollListener);
    // url = widget.url;
  }

  Future scrollListener() async {
    double extentAfter = scrollController.position.extentAfter;
    if (searchKey.isNotEmpty) return;
    if (extentAfter < 100.0 && investorFetching == false) {
      investorFetching = true;
      pageId += 1;
      await getTaxPackage(merge: true);
    }
  }

  Future getTaxPackage({String search = "", bool merge = false}) async {
    //print("merge = $merge");
    if (!merge) investorList = [];
    if (!isFirst) EasyLoading.show();
    Map data = await Api.getTaxPackage(
      user_id: userId,
      client_name: clientName,
      branch: selectedBranch == "All" ? "" : selectedBranch,
      rm_name: selectedRm == "All" ? "" : selectedRm,
      subbroker_name: selectedSubBroker == "All" ? "" : selectedSubBroker,
      page_id: pageId,
      search: searchKey,
      sort_by: "Asc",
    );
    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      return 0;
    }
    totalCount = data['total_count'];
    if (merge) {
      List newUserList = data['list'];
      investorList.addAll(newUserList);
    } else {
      investorList = data['list'];
    }
    setState(() {});
    investorFetching = false;
    if (!isFirst) EasyLoading.dismiss();
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

  Future getTaxPackageFinYear() async {
    if (financialYearList.isNotEmpty) return 0;

    Map data = await Api.getTaxPackageFinYear(
      user_id: userId,
      client_name: clientName,
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    financialYearList = data['list'];
    if (financialYearList.isNotEmpty) {
      selectedFinancialYear = financialYearList[0];
    }
    print("length ${financialYearList.length}");
    return 0;
  }

  Future sendOrDownloadTaxPackage() async {
    EasyLoading.show();
    Map data = await Api.sendOrDownloadTaxPackage(
      user_id: userId,
      client_name: clientName,
      type: submitType,
      ids_arr: userIdsSeparator,
      financial_year: selectedFinancialYear,
      sendClientMail: sendClientMail,
      sendAdminMail: sendAdminMail,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    if (submitType == "Download") {
      String url = data['msg'];
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    }

    Fluttertoast.showToast(
        msg: data['msg'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Config.appTheme.themeColor,
        textColor: Colors.white,
        fontSize: 16.0);
    EasyLoading.dismiss();
    checkedEmails.clear();
    return 0;
  }

  Future<void> downloadZipFile(String url) async {
    try {
      // Download the ZIP file
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Save the ZIP file
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/myfile.zip';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        print('ZIP file saved to $filePath');

        // Proceed to extract and open
        await extractAndOpenFile(filePath);
      } else {
        print('Failed to download file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  Future<void> extractAndOpenFile(String filePath) async {
    try {
      // Read the ZIP file
      final bytes = File(filePath).readAsBytesSync();
      final archive = ZipDecoder().decodeBytes(bytes);

      // Define the extraction path
      final directory = await getApplicationDocumentsDirectory();
      final extractionPath = '${directory.path}/extracted_files';
      final extractionDir = Directory(extractionPath);
      if (!await extractionDir.exists()) {
        await extractionDir.create(recursive: true);
        print('Created extraction directory $extractionPath');
      }

      // Extract the files
      for (final file in archive) {
        final filename = file.name;
        final outputPath = '$extractionPath/$filename';

        if (file.isFile) {
          final data = file.content as List<int>;
          final outFile = File(outputPath);
          await outFile.writeAsBytes(data);
          print('Extracted file to $outputPath');
        } else {
          final dir = Directory(outputPath);
          if (!await dir.exists()) {
            await dir.create(recursive: true);
            print('Created directory $outputPath');
          }
        }
      }
    } catch (e) {
      print('Error extracting file: $e');
    }
  }

  Future getDatas() async {
    if (!isFirst) return 0;

    if (Restrictions.isBranchApiAllowed) await getAllBranch();
    if (Restrictions.isRmApiAllowed) await getAllRM();
    if (Restrictions.isAssociateApiAllowed) await getAllSubBroker();

    await getTaxPackage();
    await getTaxPackageFinYear();
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
        await getTaxPackage(search: search);
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
        userIds.clear();
      } else {
        // Select All
        for (var data in investorList) {
          String name = data['name'];
          String email = data['email']!;
          num id = data['id']!;
          isCheckedMap[name] = true;
          if (!checkedEmails.contains(email)) {
            checkedEmails.add(email);
            userIds.add(id);
          }
        }
      }
      isAllSelected = !isAllSelected; // Toggle the state
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
                      "Tax Package",
                      style: AppFonts.f50014Black
                          .copyWith(fontSize: 18, color: Colors.white),
                    ),
                    Spacer(),
                    IconButton(
                        icon: Icon(Icons.filter_alt_outlined),
                        onPressed: () {
                          searchKey = "";

                          setState(() {});
                          showCustomizedSummaryBottomSheet();
                        }),
                  ],
                ),
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
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Checkbox(
                            value: mailToClientValue,
                            onChanged: (value) {
                              setState(() {
                                mailToClientValue = value!;
                                if (mailToClientValue) {
                                  sendClientMail = "Y";
                                } else {
                                  sendClientMail = "N";
                                }

                                print("mailToClientValue $mailToClientValue");
                              });
                            },
                          ),
                          Text('Mail To Clients', style: AppFonts.f50014Black),
                          SizedBox(width: 20),
                          Checkbox(
                            value: mailToAdminValue,
                            onChanged: (value) {
                              setState(() {
                                mailToAdminValue = value!;
                                if (mailToAdminValue) {
                                  sendAdminMail = "Y";
                                } else {
                                  sendAdminMail = "N";
                                }
                                print("mailToAdminValue $mailToAdminValue");
                              });
                            },
                          ),
                          Text(
                            ' Mail To Admin',
                            style: AppFonts.f50014Black,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (checkedEmails.length > 25) {
                                  Utils.showError(context,
                                      "Please select the investor upto 25 members only.");
                                  return;
                                }
                                if (userIds.isEmpty) {
                                  Utils.showError(
                                      context, "Please select the Users");
                                  return;
                                }
                                if (sendAdminMail == "N" &&
                                    sendClientMail == "N") {
                                  Utils.showError(
                                      context, "Please Choose the Mail Type");
                                  return;
                                }
                                userIdsSeparator = userIds.join(',');
                                userIdsSeparator = userIdsSeparator
                                    .replaceAll("[", "")
                                    .replaceAll("]", "");

                                print("user_String_id $userIdsSeparator");
                                submitType = "Email";
                                await sendOrDownloadTaxPackage();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Set the desired corner radius
                                ),
                                backgroundColor: Config.appTheme.themeColor,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                "SEND (${checkedEmails.length})",
                                style: AppFonts.f50014Black
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (checkedEmails.length > 25) {
                                  Utils.showError(context,
                                      "Please select the investor upto 25 members only.");
                                  return;
                                }
                                if (userIds.isEmpty) {
                                  Utils.showError(
                                      context, "Please select the Users");
                                  return;
                                }
                                /* if (sendAdminMail == "N" &&
                                    sendClientMail == "N") {
                                  Utils.showError(
                                      context, "Please Choose the Mail Type");
                                  return;
                                }*/
                                userIdsSeparator = userIds.join(',');
                                userIdsSeparator = userIdsSeparator
                                    .replaceAll("[", "")
                                    .replaceAll("]", "");
                                EasyLoading.show();
                                print("user_String_id $userIdsSeparator");

                                submitType = "Download";
                                await sendOrDownloadTaxPackage();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Set the desired corner radius
                                ),
                                backgroundColor: Config.appTheme.themeColor,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                "Download (${checkedEmails.length})",
                                style: AppFonts.f50014Black
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
    if (investorList.isEmpty) {
      if (isLoading) {
        return Utils.shimmerWidget(devHeight,
            margin: EdgeInsets.fromLTRB(16, 0, 0, 16));
      } else {
        return NoData();
      }
    } else {
      return SizedBox(
        height: devHeight * 0.85,
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
                      userIds.add(id);
                      print("user id $userIds");
                    } else {
                      checkedEmails.remove(email);
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
            height: devHeight * 0.7,
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
                              branchExpansionTile(context, bottomState),
                              SizedBox(height: 4),
                              rmExpansionTile(context, bottomState),
                              SizedBox(height: 4),
                              subBrokerExpansionTile(context, bottomState),
                              SizedBox(height: 4),
                              financialYearExpansionTile(context, bottomState),
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

  ExpansionTileController financialYearController = ExpansionTileController();

  Widget financialYearExpansionTile(
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
          controller: financialYearController,
          title: Text("Financial Year", style: AppFonts.f50014Black),
          tilePadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedFinancialYear, style: AppFonts.f50012),
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
                      itemCount: financialYearList.length,
                      itemBuilder: (context, index) {
                        String title = financialYearList[index];

                        return InkWell(
                          onTap: () {
                            selectedFinancialYear = title;
                            print(
                                "selectedFinancialYear $selectedFinancialYear");
                            bottomState(() {});
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: title,
                                groupValue: selectedFinancialYear,
                                onChanged: (temp) {
                                  selectedFinancialYear = title;
                                  print(
                                      "selectedFinancialYear $selectedFinancialYear");
                                  bottomState(() {});
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

  Widget getCancelApplyButton(ButtonType type) {
    if (type == ButtonType.plain)
      return PlainButton(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        text: "CANCEL",
        onPressed: () {
          Get.back();
        },
      );
    else
      return RpFilledButton(
        text: "APPLY",
        onPressed: () async {
          pageId = 1;
          investorList = [];
          await getTaxPackage();
          setState(() {});
          Get.back();
        },
      );
  }
}
