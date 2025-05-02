import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/advisor/CAS_Upload/ClientInfo.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class TransactionSummary extends StatefulWidget {
  const TransactionSummary({super.key});

  @override
  State<TransactionSummary> createState() => _TransactionSummaryState();
}

class _TransactionSummaryState extends State<TransactionSummary> {
  late double devWidth, devHeight;
  String clientName = GetStorage().read('client_name');
  int userId = GetStorage().read('mfd_id');
  String mobile = GetStorage().read("mfd_mobile");
  Map? clientCodeMap = GetStorage().read('client_code_map');

  String pan = GetStorage().read("pan") ?? "";
  String name = GetStorage().read("name") ?? "";

  bool isLoading = true;
  bool isPageLoad = true;
  String investorName = 'Search and Select Investor';
  ExpansionTileController searchController = ExpansionTileController();
  String selectedInvestor = "";
  List investorList = [];
  int page_id = 1;
  String searchKey = "";
  bool isFirst = true;
  late int investorId;
  Timer? searchOnStop;
  List typeList = [
    "All (15)",
    "Ready (15)",
    "Action Required (5)",
  ];

  Future fetchMoreInvestor() async {
    page_id++;
    Map data = await AdminApi.getInvestors(
        page_id: page_id,
        client_name: clientName,
        user_id: userId,
        branch: "",
        rmList: []);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    EasyLoading.show();
    List list = data['list'];

    investorList.addAll(list);
    investorList = investorList.toSet().toList();
    EasyLoading.dismiss();
    setState(() {});
    return 0;
  }

  Future getInitialInvestor() async {
    if (!isFirst) return 0;

    Map data = await AdminApi.getInvestors(
        page_id: page_id,
        client_name: clientName,
        user_id: userId,
        branch: "",
        rmList: []);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    investorList = data['list'];
    investorId = investorList[0]['id'];
    selectedInvestor = investorList[0]['name'];

    setState(() {});
    isFirst = false;
    return 0;
  }

  String selectedType = "All(15)";
  String selectedTypeFinal = "All";

  Future getDatas() async {
    isLoading = true;
    await getInitialInvestor();
    isLoading = false;
    return 0;
  }

  Future searchInvestor(StateSetter bottomState) async {
    investorList = [];
    EasyLoading.show(status: "Searching for `$searchKey`");
    Map data = await AdminApi.getInvestors(
        page_id: page_id,
        client_name: clientName,
        user_id: userId,
        search: searchKey,
        branch: "",
        rmList: []);
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
                    Text("Transaction Summary", style: AppFonts.appBarTitle),
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                topArea(),
                Expanded(
                  child: SingleChildScrollView(
                    child: isLoading
                        ? Utils.shimmerWidget(devHeight)
                        : 1 == 0
                            ? NoData()
                            : bottomArea(),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        EasyLoading.show();
                        selectedInvestor = investorName;
                        EasyLoading.dismiss();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Config.appTheme.themeColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        "FINISH IMPORT",
                        style:
                            AppFonts.f50014Black.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  getKeyByValue(Map map, String value) {
    return map.keys.firstWhere((element) => map[element] == value);
  }

  Widget appBarColumn(String title, String value, Widget suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: AppFonts.f40013.copyWith(color: Colors.white)),
        Container(
          width: devWidth * 0.42,
          padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Color(0XFFDEE6E6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Row(
              children: [
                Text(value,
                    style: TextStyle(
                        color: Config.appTheme.themeColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Spacer(),
                suffix
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget getCancelApplyButton(ButtonType type) {
    if (type == ButtonType.plain)
      return PlainButton(
        color: Config.appTheme.buttonColor,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        text: "CLEAR ALL",
        onPressed: () {},
      );
    else
      return RpFilledButton(
        color: Config.appTheme.buttonColor,
        text: "APPLY",
        onPressed: () {
          Get.back();
          setState(() {});
        },
      );
  }

  Widget bottomArea() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              // Map data = transList[index];
              return bottomCard(index);
            },
          ),
        ],
      ),
    );
  }

  String getFirst20(String text) {
    String s = text.split(":").first;
    if (s.length > 20) s = '${s.substring(0, 20)}...';
    return s;
  }

  Widget bottomCard(int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InitialCard(title: "ABHIJIT MAXXXXX"),
                SizedBox(width: 8),
                SizedBox(
                  width: 210,
                  child: ColumnText(
                    title: "ABHIJIT MAXXXXX",
                    value: "PAN: ABCDE1234J",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013,
                  ),
                ),
                Spacer(),
                (index == 0)
                    ? Image.asset("assets/check_circle.png", height: 32)
                    : Image.asset("assets/error_circle.png", height: 32),
              ],
            ),
            SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ColumnText(
                    title:
                        "Kotak Banking & Financial Services Fund Growth Option",
                    value: "Folio: 1234456780",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013.copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnText(title: "Broker Code", value: "INA10076876"),
                ColumnText(
                  title: "Total Units",
                  value: "33.177",
                  alignment: CrossAxisAlignment.center,
                ),
                ColumnText(
                  title: "Market Value",
                  value:
                      "$rupee ${Utils.formatNumber(36000.50, isAmount: false)}",
                  alignment: CrossAxisAlignment.end,
                ),
              ],
            ),
            (index == 1)
                ? Column(
                    children: [
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Config.appTheme.themeColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              textStyle: AppFonts.f50014Black.copyWith(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                            ),
                            onPressed: () async {
                              Get.to(() => ClientInfo());
                            },
                            child: Text(
                              "Create New Investor",
                              style:
                                  AppFonts.f50012.copyWith(color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 4),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Config.appTheme.themeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              textStyle: AppFonts.f50014Black.copyWith(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                            ),
                            onPressed: () async {
                              showInvestorBottomSheet();
                            },
                            child: Text(
                              "Map Existing Investor",
                              style: AppFonts.f50012,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget topArea() {
    return Container(
      color: Config.appTheme.themeColor,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: typeList.length,
              itemBuilder: (context, index) {
                String type = typeList[index];
                String selectedTypeFinal;

                selectedTypeFinal = selectedType;

                print("type = $selectedTypeFinal");

                return GestureDetector(
                  onTap: () async {
                    if (selectedTypeFinal == type) {
                      setState(() {});
                    }
                  },
                  child: selectedType == type
                      ? getButton(text: type, type: ButtonType.filled)
                      : getButton(text: type, type: ButtonType.plain),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(width: 16),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget getButton({required String text, required ButtonType type}) {
    EdgeInsets padding = EdgeInsets.symmetric(horizontal: 16);
    if (type == ButtonType.plain) {
      return PlainRButton(
        text: text,
        padding: padding,
        onPressed: () async {
          selectedType = text;
          setState(() {});
        },
      );
    } else {
      return RpFilledRButton(text: text, padding: padding);
    }
  }

  void showInvestorBottomSheet() {
    print("selectedInvestor $selectedInvestor");
    bool isExpanded = true;
    TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: Config.appTheme.mainBgColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Column(
                children: [
                  // Top close button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Update Existing Investor",
                            style: AppFonts.f50014Black.copyWith(fontSize: 16)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close),
                        )
                      ],
                    ),
                  ),
                  // Investor ExpansionTile
                  Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded: isExpanded,
                        onExpansionChanged: (expanded) {
                          bottomState(() {
                            isExpanded = expanded;
                          });
                        },
                        title: Text("Investor", style: AppFonts.f50014Black),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              investorName,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Config.appTheme.themeColor,
                              ),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
                            child: SizedBox(
                              height: 40,
                              child: TextFormField(
                                controller: searchController,
                                onChanged: (val) {
                                  searchKey = val;
                                  searchHandler(bottomState);
                                },
                                decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.close,
                                        color: Config.appTheme.themeColor),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 2, 12, 2),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 260,
                            child: ListView.builder(
                              itemCount: investorList.length,
                              itemBuilder: (context, index) {
                                String name = investorList[index]['name'];
                                String pan = investorList[index]['pan'];

                                return InkWell(
                                  onTap: () {
                                    bottomState(() {
                                      investorId = investorList[index]['id'];
                                      print("investorId $investorId");
                                      investorName = "$name [$pan]";
                                      isExpanded = true;
                                    });
                                  },
                                  child: ListTile(
                                    leading: InitialCard(title: name),
                                    title: Text(name),
                                  ),
                                );
                              },
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (searchKey.isNotEmpty) return;
                              await fetchMoreInvestor();
                              bottomState(() {});
                            },
                            child: Text(
                              "Load More Results",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Config.appTheme.themeColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          EasyLoading.show();
                          selectedInvestor = investorName;
                          EasyLoading.dismiss();
                          Navigator.pop(context);
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
                  ),
                ],
              ),
            );
          },
        );
      },
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
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppFonts.f50014Black.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class RpFilledRButton extends StatelessWidget {
  const RpFilledRButton(
      {super.key, this.onPressed, required this.text, this.padding});

  final Function()? onPressed;
  final EdgeInsets? padding;
  final String text;
  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.sizeOf(context).width;

    return InkWell(
      onTap: onPressed,
      child: Container(
          padding: padding ??
              EdgeInsets.symmetric(horizontal: devWidth * 0.15, vertical: 2),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppFonts.f50014Black
                .copyWith(color: Config.appTheme.themeColor),
          ))),
    );
  }
}
