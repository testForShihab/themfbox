import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/advisor/reports/SipDueReport.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/login/CheckUserType.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/RectButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/SearchText.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PositiveandNegativeReturnPortfolios extends StatefulWidget {
  const PositiveandNegativeReturnPortfolios({super.key});

  @override
  State<PositiveandNegativeReturnPortfolios> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PositiveandNegativeReturnPortfolios> {
  late double devWidth, devHeight;
  String selectedCategory = "Category";
  String selectedAuthor = "Author";
  String searchKey = "";
  String blogCategory = "";
  String blogAuthor = "";
  Timer? searchOnStop;

  int userId = GetStorage().read('mfd_id');
  String clientName = GetStorage().read('client_name');
  int type_id = GetStorage().read("type_id");

  ScrollController scrollController = ScrollController();
  bool isFirst = true;
  int pageId = 1;
  bool blogsFetching = false;
  bool isLoading = false;
  int totalCount = 0;
  ExpansionTileController reportTypeController = ExpansionTileController();
  ExpansionTileController fundController = ExpansionTileController();
  String selectedPortfolioName = "";
  List sortOptions = [
    "A to Z",
    "Current Value",
    "Current Cost",
    "XIRR",
  ];
  String selectedSort = "A to Z";
  String selectedSortValue = "alphabet-az";
  bool positiveNegativeFetching = false;
  String selectedRmName = "";
  String selectedTitle = "Equity";
  Map reportMap = {
    "Notional Gain/Loss - Simple": "Simple",
    "Notional Gain/Loss - Taxation": "Taxation",
  };
  String pincode = "";
  List portfolioList = [
    "All Portfolios",
    "Negative Return Portfolios",
    "Positive Return Portfolios",
  ];
  Map reportActionData = {
    "Download Excel Report": ["", "", "assets/excel.png"],
  };
  String startReturn = "0";
  String endReturn = "10";

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  Future scrollListener() async {
    double extentAfter = scrollController.position.extentAfter;
    if (searchKey.isNotEmpty) return;
    if (extentAfter < 100.0 && positiveNegativeFetching == false) {
      positiveNegativeFetching = true;
      pageId++;
      await getNegativePositiveReturnFolios(merge: true);
    }
  }

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
        await getNegativePositiveReturnFolios(search: search);
      });
    });
  }

  @override
  void dispose() {
    //  implement dispose
    scrollController.dispose();
    super.dispose();
  }

  String selectedValue = "recent";
  List positiveNegativeList = [];
  List userList = [];
  List rmFilterList = [];
  String selectedPortfolioKey = "";
  bool isSearching = false;
  int count = 0;

  Future getNegativePositiveReturnFolios(
      {String search = "", bool merge = false}) async {
    print("!merge = ${!merge}");
    if (!merge) positiveNegativeList = [];
    if (merge) {
      EasyLoading.show();
    }
    isLoading = true;
    Map data = await AdminApi.getNegativePositiveReturnFolios(
      user_id: userId,
      client_name: clientName,
      start_range: startReturn,
      end_range: endReturn,
      option: selectedPortfolioName == "return-range"
          ? "range"
          : selectedPortfolioKey,
      rm_name: selectedRmName == "All" ? "" : selectedRmName,
      page_id: (searchKey.isNotEmpty) ? 1 : pageId,
      search: searchKey,
      sort_by: selectedSortValue,
      max_count: "",
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    if (merge) {
      List newList = data['list'];
      positiveNegativeList.addAll(newList);
      List newUserList = data['user_details'];
      userList.addAll(newUserList);
    } else {
      positiveNegativeList = data['list'];
      userList = data['user_details'];
    }
    count = data['total_count'];
    isLoading = false;
    setState(() {});
    positiveNegativeFetching = false;
    if (merge) {
      EasyLoading.dismiss();
    }
    return 0;
  }

  Future getNegativePositiveRMFilter() async {
    if (rmFilterList.isNotEmpty) return 0;
    Map data = await AdminApi.getNegativePositiveRMFilter(
        user_id: userId, client_name: clientName);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    rmFilterList = data['list'];
    rmFilterList.insert(0, "All");
    selectedRmName = rmFilterList[0];
    return 0;
  }

  Future getDatas() async {
    if (!isFirst) return 0;
    isLoading = true;
    await getNegativePositiveReturnFolios();
    await getNegativePositiveRMFilter();
    isFirst = false;
    isLoading = false;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: positiveNegativeList.isEmpty
                ? Config.appTheme.mainBgColor
                : Colors.white,
            appBar: AppBar(
              backgroundColor: Config.appTheme.themeColor,
              leadingWidth: 0,
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
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          "Positive and Negative Retur...",
                          style: AppFonts.f50014Black
                              .copyWith(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                          icon: Icon(Icons.filter_alt_outlined),
                          onPressed: () {
                            showFilterBottomSheet();
                          }),
                      GestureDetector(
                        onTap: () {
                          showReportActionBottomSheet();
                        },
                        child: Icon(
                          Icons.pending_outlined,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                topCard(),
                countArea(),
                isLoading
                    ? Utils.shimmerWidget(devHeight * 0.62,
                        margin: EdgeInsets.all(16))
                    : (!isLoading && positiveNegativeList.isEmpty)
                        ? NoData()
                        : listCard()
              ],
            ),
          );
        });
  }

  Container countArea() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${positiveNegativeList.length} Items of $count",
            style: AppFonts.f40013
                .copyWith(color: Config.appTheme.placeHolderInputTitleAndArrow),
          ),
          SortButton(
            onTap: () {
              sortBottomSheet();
            },
            title: " Sort By",
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Image.asset(
                "assets/mobile_data.png",
                height: 14,
                color: Config.appTheme.themeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listCard() {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            (isLoading)
                ? Utils.shimmerWidget(devHeight)
                : ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: positiveNegativeList.length,
                    itemBuilder: (context, index) {
                      Map data = positiveNegativeList[index];
                      Map userData = userList[index];
                      return detailsCard(data, userData);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: DottedLine(),
                    ),
                  ),
            SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget detailsCard(Map data, Map userData) {
    String name = data['name'] ?? "";
    String rmName = data['rm_name'] ?? "";
    String branch = data['branch'] ?? "";
    num investmentCost = data['invested_amount'] ?? 0;
    num currentValue = data['current_value'] ?? 0;
    num xirr = data['cagr'] ?? 0;

    return GestureDetector(
      onTap: () {
        EasyLoading.show();
        showUserDetails(data, userData);
        EasyLoading.dismiss();
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InitialCard(title: name[0]),
                SizedBox(width: 10),
                Expanded(
                    child: ColumnText(
                  title: name,
                  value: "$rmName . $branch",
                  titleStyle: AppFonts.f50014Black,
                  valueStyle: AppFonts.f40013,
                )),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Config.appTheme.placeHolderInputTitleAndArrow,
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnText(
                  title: "Investment Cost",
                  value: "$rupee ${Utils.formatNumber(investmentCost.round())}",
                ),
                ColumnText(
                  title: "Current Value",
                  value: "$rupee ${Utils.formatNumber(currentValue.round())}",
                  alignment: CrossAxisAlignment.center,
                ),
                ColumnText(
                  title: "XIRR (%)",
                  value: "${xirr.toStringAsFixed(2)}",
                  valueStyle: AppFonts.f50014Black.copyWith(
                      color: (xirr >= 0)
                          ? Config.appTheme.defaultProfit
                          : Config.appTheme.defaultLoss),
                  alignment: CrossAxisAlignment.end,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  showUserDetails(Map data, Map userData) {
    String name = userData['name'] ?? "null";
    int type_id = userData['type_id'] ?? 0;
    String invType = "null";
    if (type_id == 1) invType = "Individual";
    if (type_id == 3) invType = "Family";

    String? rmname = "";
    if (client_name == 'nextfreedom') {
      rmname = data['subbroker_name'];
      ;
      print("rmname-$rmname");
    } else {
      rmname = userData['rm'];
    }

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
                  leading: InitialCard(title: name[0]),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text("${userData['name']}",
                            style: AppFonts.f50014Black, softWrap: true),
                      ),
                    ],
                  ),
                ),
                infoRow(
                    lHead: "PAN",
                    lSubHead: "${userData['pan']}",
                    rHead: "Mobile",
                    rSubHead: "${userData['mobile']}",
                    rStyle: AppFonts.f50014Theme
                        .copyWith(decoration: TextDecoration.underline)),
                infoRow(
                    lHead: "Email",
                    lSubHead: "${userData['email']}",
                    lStyle: AppFonts.f50014Theme.copyWith(
                        color: Config.appTheme.themeColor,
                        decoration: TextDecoration.underline)),
                infoRow(
                    lHead: "Address",
                    lSubHead:
                        "${userData['address1']} ${userData['address2']}  ${userData['address3']} \n${userData['city']} - ${userData['pincode']} "),
                Divider(),
                infoRow(
                    lHead: "Birthday",
                    lSubHead: "${userData['birthday']}",
                    rHead: "RM",
                    rSubHead: "$rmname"),
                Divider(),
                infoRow(lHead: "Branch", lSubHead: "${userData['branch']}"),
                /*infoRow(
                    lHead: "RM",
                    lSubHead: "${userData['rm'] ?? ""}",
                    rHead: "",
                    rSubHead: ""),*/
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
                            if (userData['type_id'] == 1)
                              await loginAsInvestor(userData);
                            else if (userData['type_id'] == 3)
                              await loginAsFamily(userData);
                            else
                              Utils.showError(context, "Unknown type id");
                          },
                          trailing:
                              Icon(Icons.arrow_forward, color: Colors.white),
                          bgColor: Config.appTheme.buttonColor),
                      SizedBox(height: 15),
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

  Future<void> rpDownloadFile(
      {required String url, required BuildContext context}) async {
    Dio dio = Dio();
    String dirloc = "";

    if (Platform.isIOS) {
      if (await Permission.storage.request().isGranted)
        dirloc = (await getTemporaryDirectory()).path;
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

    try {
      final dir = await getExternalStorageDirectory();
      final filename = url.substring(url.lastIndexOf("/") + 1);
      final filePath = '${dir!.path}/$filename';
      final dio = Dio();
      await dio.download(url, filePath);
      final _result = await OpenFile.open(filePath);
    } catch (e) {
      print('Error opening PDF: $e');
    }
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

  Future<void> loginAsInvestor(Map userData) async {
    await GetStorage().write("adminAsInvestor", userData['id']);
    await GetStorage().write("user_id", userData['id']);
    await GetStorage().write("user_name", userData['name']);
    await GetStorage().write("user_pan", userData['pan']);
    await GetStorage().write("user_mobile", userData['mobile']);
    await GetStorage().write('user_email', userData['email']);

    Get.offAll(() => CheckUserType());
  }

  Future<void> loginAsFamily(Map familyHead) async {
    await GetStorage().write("adminAsFamily", familyHead['id']);
    await GetStorage().write("family_id", familyHead['id']);
    await GetStorage().write("family_name", familyHead['name']);
    await GetStorage().write("family_pan", familyHead['pan']);
    await GetStorage().write("family_mobile", familyHead['mobile']);

    Get.offAll(() => CheckUserType());
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

  Widget topCard() {
    return Container(
      color: Config.appTheme.themeColor,
      padding: EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(selectedPortfolioName,
              style: AppFonts.f40013.copyWith(color: Colors.white)),
          SizedBox(height: 16),
          SearchText(
            hintText: "Search",
            onChange: (val) => searchHandler(val),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  sortBottomSheet() {
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
        return StatefulBuilder(builder: (context, bottomState) {
          return Container(
            height: devHeight * 0.40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BottomSheetTitle(title: " Sort By"),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: sortOptions.length,
                      itemBuilder: (context, index) {
                        String option = sortOptions[index];

                        return InkWell(
                          onTap: () async {
                            selectedSort = option;
                            if (option == "A to Z") {
                              selectedSortValue = "alphabet-az";
                            } else if (option == "Current Value") {
                              selectedSortValue = "currval-desc";
                            } else if (option == "Current Cost") {
                              selectedSortValue = "currcost-desc";
                            } else {
                              selectedSortValue = "xirr-desc";
                            }
                            pageId = 1;
                            print("selectedSort $selectedSort");
                            EasyLoading.show();
                            positiveNegativeList = [];
                            await getNegativePositiveReturnFolios();
                            EasyLoading.dismiss();
                            setState(() {});
                            bottomState(() {});
                            Get.back();
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: option,
                                groupValue: selectedSort,
                                onChanged: (value) async {
                                  selectedSort = option;
                                  if (option == "A to Z") {
                                    selectedSortValue = "alphabet-az";
                                  } else if (option == "Current Value") {
                                    selectedSortValue = "currval-desc";
                                  } else if (option == "Current Cost") {
                                    selectedSortValue = "currcost-desc";
                                  } else {
                                    selectedSortValue = "xirr-desc";
                                  }
                                  EasyLoading.show();
                                  positiveNegativeList = [];
                                  await getNegativePositiveReturnFolios();
                                  EasyLoading.dismiss();
                                  setState(() {});
                                  bottomState(() {});
                                  Get.back();
                                },
                              ),
                              Text(option),
                            ],
                          ),
                        );
                      },
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

  applySort() {
    if (selectedSort == 'Current Value')
      positiveNegativeList
          .sort((a, b) => b.current_value!.compareTo(a.current_value!));
    if (selectedSort == 'Current Cost')
      positiveNegativeList
          .sort((a, b) => b.invested_amount!.compareTo(a.invested_amount!));
    if (selectedSort == 'A to Z')
      positiveNegativeList.sort((a, b) => a.name!.compareTo(b.name!));
    if (selectedSort == "XIRR")
      positiveNegativeList.sort((a, b) => b.cagr!.compareTo(a.cagr!));
    if (selectedSort == "Absolute Return")
      positiveNegativeList
          .sort((a, b) => b.absolute_return!.compareTo(a.absolute_return!));
  }

  showFilterBottomSheet() {
    String filtertitle = '';
    if (clientName == 'nextfreedom') {
      filtertitle = 'Select BM Name';
    } else {
      filtertitle = 'Select RM Name';
    }

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
          return StatefulBuilder(builder: (context, bottomState) {
            return Container(
              height: devHeight * 0.60,
              decoration: BoxDecoration(
                color: Config.appTheme.mainBgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BottomSheetTitle(title: "Select Portfolio"),
                    Divider(height: 0),
                    SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: portfolioList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        String portfolioName = portfolioList[index];

                        return InkWell(
                          onTap: () {
                            bottomState(() {
                              pageId = 1;
                              selectedPortfolioName = portfolioName;
                              if (selectedPortfolioName == "All Portfolios") {
                                selectedPortfolioKey = "";
                              } else if (selectedPortfolioName ==
                                  "Negative Return Portfolios") {
                                selectedPortfolioKey = "negative";
                              } else {
                                selectedPortfolioKey = "positive";
                              }
                              print(
                                  "selectedPortfolioName $selectedPortfolioName");
                            });
                            print(
                                "selectedPortfolioName $selectedPortfolioName");
                            // setState(() {});
                          },
                          child: Row(
                            children: [
                              Radio(
                                activeColor: Config.appTheme.themeColor,
                                groupValue: selectedPortfolioName,
                                value: portfolioList[index],
                                onChanged: (val) {
                                  bottomState(() {
                                    pageId = 1;
                                    selectedPortfolioName = portfolioName;
                                    if (selectedPortfolioName ==
                                        "All Portfolios") {
                                      selectedPortfolioKey = "";
                                    } else if (selectedPortfolioName ==
                                        "Negative Return Portfolios") {
                                      selectedPortfolioKey = "negative";
                                    } else {
                                      selectedPortfolioKey = "positive";
                                    }
                                    print(
                                        "selectedPortfolioName $selectedPortfolioName");
                                  });

                                  // setState(() {});
                                },
                              ),
                              Expanded(
                                child: Text(
                                  portfolioName,
                                  style: AppFonts.f50014Black.copyWith(
                                      color: Config.appTheme.readableGreyTitle),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    InkWell(
                        onTap: () {
                          selectedPortfolioName = "return-range";
                          print("selectedPortfolioName $selectedPortfolioName");
                          pageId = 1;
                          bottomState(() {});
                        },
                        child: Row(
                          children: [
                            Radio(
                              value: "return-range",
                              groupValue: selectedPortfolioName,
                              onChanged: (val) {
                                selectedPortfolioName = "return-range";
                                print(
                                    "selectedPortfolioName $selectedPortfolioName");
                                pageId = 1;
                                bottomState(() {});
                              },
                            ),
                            Text("Return Range of Portfolios",
                                style: AppFonts.f50014Black.copyWith(
                                    color: Config.appTheme.readableGreyTitle)),
                          ],
                        )),
                    Visibility(
                        visible: selectedPortfolioName == "return-range",
                        child: returnRangeExpansionTile(context, bottomState)),
                    if (type_id == UserType.ADMIN)
                      Container(
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            controller: reportTypeController,
                            title: Text("$filtertitle",
                                style: AppFonts.f50014Black),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(selectedRmName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: Config.appTheme.themeColor)),
                                // DottedLine(),
                              ],
                            ),
                            children: [
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: rmFilterList.length,
                                  itemBuilder: (context, index) {
                                    String temp = rmFilterList[index];

                                    return InkWell(
                                      onTap: () {
                                        bottomState(() {
                                          pageId = 1;
                                          selectedRmName = temp;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Radio(
                                            value: temp,
                                            groupValue: selectedRmName,
                                            onChanged: (value) {
                                              bottomState(() {
                                                pageId = 1;
                                                selectedRmName = temp;
                                              });
                                            },
                                          ),
                                          Text(temp,
                                              style: AppFonts.f50014Black
                                                  .copyWith(
                                                      color: Config.appTheme
                                                          .readableGreyTitle)),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    Container(
                      height: 75,
                      padding: EdgeInsets.all(16),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getCancelApplyButton(ButtonType.plain),
                          getCancelApplyButton(ButtonType.filled),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  getKeyByValue(Map map, String value) {
    return map.keys.firstWhere((element) => map[element] == value);
  }

  Widget returnRangeExpansionTile(
    BuildContext context,
    StateSetter bottomState,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Return Range",
            style: AppFonts.f50014Black,
            textAlign: TextAlign.start,
          ),
          /*Text(
            "50.00% to 70.00%",
            style: AppFonts.f50012,
            textAlign: TextAlign.start,
          ),
          DottedLine(),*/
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: TextFormField(
                cursorColor: Colors.blue,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: 'Starting Return',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintStyle: AppFonts.f50014Black.copyWith(
                      color: Config.appTheme.placeHolderInputTitleAndArrow),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                onChanged: (value) {
                  bottomState(() {
                    startReturn = value;
                    print("startReturn $startReturn");
                  });
                },
              )),
              SizedBox(
                width: 2,
              ),
              Text(
                "to",
                style: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.themeColor),
              ),
              SizedBox(
                width: 2,
              ),
              Expanded(
                child: TextFormField(
                  cursorColor: Colors.blue,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: 'End Return',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintStyle: AppFonts.f50014Black.copyWith(
                        color: Config.appTheme.placeHolderInputTitleAndArrow),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  onChanged: (value) {
                    bottomState(() {
                      endReturn = value;
                      print("endReturn $endReturn");
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getCancelApplyButton(ButtonType type) {
    searchKey = "";
    if (type == ButtonType.plain)
      return PlainButton(
        color: Config.appTheme.buttonColor,
        padding: EdgeInsets.symmetric(horizontal: devWidth * 0.10, vertical: 2),
        text: "CLEAR ALL",
        onPressed: () {
          Get.back();
        },
      );
    else
      return RpFilledButton(
        color: Config.appTheme.buttonColor,
        text: "APPLY",
        onPressed: () async {
          print("startReturn $startReturn");
          print("endReturn $endReturn");
          if (selectedPortfolioName == "return-range") {
            if (startReturn.isEmpty) {}
            if (endReturn.isEmpty) {}
          }
          pageId = 1;
          positiveNegativeList = [];
          EasyLoading.show();
          await getNegativePositiveReturnFolios();
          EasyLoading.dismiss();
          setState(() {});
          Get.back();
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: devWidth * 0.05),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Report Actions",
                            style: AppFonts.f50014Black.copyWith(fontSize: 16)),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        reportActionContainer(),
                      ],
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

  Widget reportActionContainer() {
    String options = selectedPortfolioName == "return-range"
        ? "range"
        : selectedPortfolioKey;
    String rmName = selectedRmName == "All" ? "" : selectedRmName;
    print("rmName selected $selectedRmName");
    print("rmName $rmName");
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
                if (index == 0) {
                  String url =
                      "${ApiConfig.apiUrl}/admin/download/positiveNegativeReturnFoliosReport?key=${ApiConfig.apiKey}&user_id=$userId&client_name=$clientName&start_range=$startReturn&end_range=$endReturn&rm_name=$rmName"
                      "&option=$options&return_above_twenty="
                      "";

                  http.Response response = await http.post(Uri.parse(url));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  String resUrl = data['msg'];
                  rpDownloadFile(url: resUrl, context: context);
                  Get.back();
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
