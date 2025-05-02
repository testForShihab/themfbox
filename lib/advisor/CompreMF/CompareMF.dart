import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/api/ResearchApi.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/Loading.dart';
import 'package:mymfbox2_0/rp_widgets/NoData.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import '../../api/ReportApi.dart';
import '../../rp_widgets/RpListTile.dart';

class CompareMF extends StatefulWidget {
  const CompareMF({super.key});

  @override
  State<CompareMF> createState() => _CompareMFState();
}

class _CompareMFState extends State<CompareMF> {
  int userId = getUserId();
  String client_name = GetStorage().read("client_name");
  late TextEditingController investedAmountController;
  String investedAmount = "0";
  late double devWidth, devHeight;
  double multiplier = 10;
  double percent = 9;
  num amount = 10;
  bool isPageLoad = true;

  List compareList = ["Nifty 50 TRI", "PPF", "Fixed Deposit", "Gold"];
  List<String> checkedValues = [];

  List allCategories = [];
  List subCategoryList = [];

  String selectedCategory = "Equity Schemes";
  String selectedSubCategory = "Equity: Flexi Cap";
  List fundList = [];
  List compareFundList = [];
  List checkedFundList = [];
  List<Map<String, dynamic>> basicInfoTableData = [];
  String schemes = "ABSL Flexi Cap Gr Reg";
  String selectedValues = "ABSL Flexi Cap Gr Reg";
  String selectedFund = "0 Fund Selected";
  String investedAmt = "";
  String selectedbroadCategory = "All";
  String compareType = "";
  List selectedItemsNew = [];
  String sensex = 'false';
  String ppf = 'false';
  String fd = 'false';
  String gold = 'false';

  String getFirst13(String text) {
    String s = text.split(":").last;
    if (s.length > 13) s = s.substring(0, 13);
    return s;
  }

  String getFirst16(String text) {
    String s = text.split(":").last;
    if (s.length > 16) s = s.substring(0, 16);
    return s;
  }

  bool isLoading = true;
  ExpansionTileController startDatecontroller = ExpansionTileController();
  ExpansionTileController endDateController = ExpansionTileController();
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    investedAmountController = TextEditingController(text: "10000");
    investedAmount = '10000';
  }

  Future getDatas() async {
    isLoading = true;
    EasyLoading.show();
    await getBroadCategoryList();
    await getCategoryList();
    await getTopLumpsumFunds();
    EasyLoading.dismiss();
    isLoading = false;
    return 0;
  }

  Future getBroadCategoryList() async {
    if (allCategories.isNotEmpty) return 0;
    Map data = await Api.getBroadCategoryList(client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    allCategories = data['list'];
    allCategories.insert(0, {"name": "ALL"});

    return 0;
  }

  Future getCategoryList() async {
    if (subCategoryList.isNotEmpty) return 0;

    Map data = await Api.getCategoryList(
        category: selectedCategory, client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    subCategoryList = data['list'];
    return 0;
  }

  Future getTopLumpsumFunds() async {
    if (fundList.isNotEmpty) return 0;
    Map data = await ResearchApi.getTopLumpsumFunds(
      amount: '',
      category: selectedSubCategory,
      period: '',
      amc: "",
      client_name: client_name,
    );
    List<dynamic> list = data['list'];
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    for (var fund in list) {
      Map<String, dynamic> fundData = {
        'logo': fund['logo'],
        'scheme_amfi': fund['scheme_amfi'],
        'scheme_amfi_short_name': fund['scheme_amfi_short_name']
      };
      fundList.add(fundData);
    }
    return 0;
  }

  formatDate(DateTime dt) {
    return DateFormat("dd-MM-yyyy").format(dt);
  }

  Future getCompareFunds() async {
    if (compareFundList.isNotEmpty) return 0;
    Map data = await AdminApi.getCompareFunds(
      user_id: userId,
      client_name: client_name,
      scheme: schemes,
      amount: investedAmount,
      start_date: formatDate(selectedStartDate),
      end_date: formatDate(selectedEndDate),
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    //compareFundList = data['scheme_info'];

    compareFundList = data['scheme_info'].where((scheme) {
      final schemeAmfi = scheme['scheme_amfi'];
      return schemeAmfi != 'NIFTY 50 TRI' &&
          schemeAmfi != 'PPF' &&
          schemeAmfi != 'Fixed Deposit' &&
          schemeAmfi != 'Gold';
    }).toList();
    if (compareType != "") {
      print("compareType $compareType");
      List<String> schemeNames =
          compareType.split(',').map((s) => s.trim().toLowerCase()).toList();

      checkedFundList = data['scheme_info'].where((scheme) {
        final schemeAmfi = scheme['scheme_amfi'].toLowerCase();
        return schemeNames.contains(schemeAmfi);
      }).toList();
    }
    basicInfoTableData =
        List<Map<String, dynamic>>.from(data['compare_schemes']);

    return 0;
  }

  showDownloadModal() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          return AspectRatio(
            aspectRatio: 2 / .8,
            child: Scaffold(
              backgroundColor: Config.appTheme.themeColor25,
              body: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Report Actions',
                              style:
                                  AppFonts.f50014Black.copyWith(fontSize: 18)),
                          IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              EasyLoading.show(status: 'Loading');
                              Get.back();
                              final res =
                                  await ReportApi.downLoadCompareMutualFundPdf(
                                userId: userId,
                                clientName: client_name,
                                endDate: '${formatDate(selectedEndDate)}',
                                startDate: '${formatDate(selectedStartDate)}',
                                amount: amount.toInt(),
                                schemes: schemes, sensex: sensex, ppf: ppf, fd: fd, gold: gold,
                              );

                              if (res['status'] != 200) {
                                print('Error downloading data');
                                EasyLoading.dismiss();
                                return;
                              }
                              rpDownloadFile(url: res['msg'], index: 0);
                            },
                            child: RpListTile(
                              title: SizedBox(
                                width: 220,
                                child: Text(
                                  'Download PDF Report',
                                  style: AppFonts.f50014Black.copyWith(
                                      color: Config.appTheme.themeColor),
                                ),
                              ),
                              subTitle: SizedBox(),
                              leading: Image.asset(
                                "assets/pdf.png",
                                color: Config.appTheme.themeColor,
                                width: 32,
                                height: 32,
                              ),
                              showArrow: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;
    devHeight = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: AppBar(
              backgroundColor: Config.appTheme.themeColor,
              leadingWidth: 0,
              toolbarHeight: 200,
              foregroundColor: Colors.white,
              elevation: 0,
              leading: SizedBox(),
              title: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.arrow_back),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          "Compare Mutual Funds",
                          style: AppFonts.f50014Black
                              .copyWith(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          showDownloadModal();
                        },
                        icon: Icon(Icons.pending_outlined),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showCompareMutualFundBottomSheet();
                        },
                        child: appBarColumn(
                            "Select Up To 5 Funds",
                            getFirst16(selectedFund),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
                      ),
                      GestureDetector(
                        onTap: () {
                          showAmountBottomSheet()();
                        },
                        child: appBarColumn(
                            "Invested Amount",
                            getFirst13(
                              "$rupee ${Utils.formatNumber(double.parse(investedAmount).round(), isAmount: false)}",
                            ),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showAmountBottomSheet()();
                        },
                        child: appBarColumn(
                            "Start Date",
                            "${formatDate(selectedStartDate)}",
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
                      ),
                      GestureDetector(
                        onTap: () {
                          showAmountBottomSheet()();
                        },
                        child: appBarColumn(
                            "End Date",
                            "${formatDate(selectedEndDate)}",
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: isPageLoad || compareFundList.isEmpty
                      ? NoData()
                      : Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: compareFundList.length,
                                itemBuilder: (context, index) {
                                  Map data = compareFundList[index];
                                  return compareMutualFundsTile(data);
                                },
                              ),
                              (checkedFundList.isNotEmpty) && compareType != ""
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: checkedFundList.length,
                                      itemBuilder: (context, index) {
                                        Map data = checkedFundList[index];
                                        return blackCard(data);
                                      },
                                    )
                                  : SizedBox(),
                              Text(
                                "Basic Informations",
                                style: AppFonts.f50014Black.copyWith(
                                    color: Config.appTheme.readableGreyTitle),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: 16),
                              basicInfoDataTable(),
                              SizedBox(height: 16),
                              Text(
                                "Fund Information",
                                style: AppFonts.f50014Black.copyWith(
                                    color: Config.appTheme.readableGreyTitle),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: 16),
                              fundInfoDataTable(),
                              SizedBox(height: 16),
                              Text(
                                "Trailing Return Analysis",
                                style: AppFonts.f50014Black.copyWith(
                                    color: Config.appTheme.readableGreyTitle),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: 16),
                              trailingReturnsDataTable(),
                              SizedBox(height: 16),
                              Text(
                                "Lumpsum Return Analysis",
                                style: AppFonts.f50014Black.copyWith(
                                    color: Config.appTheme.readableGreyTitle),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: 16),
                              lumpsumReturnsDataTable(),
                              SizedBox(height: 16),
                              Text(
                                "SIP Return Analysis (₹5,000 Monthly SIP)",
                                style: AppFonts.f50014Black.copyWith(
                                    color: Config.appTheme.readableGreyTitle),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: 16),
                              sipReturnsDataTable(),
                              SizedBox(height: 16),
                              Text(
                                "Risk Ratios",
                                style: AppFonts.f50014Black.copyWith(
                                    color: Config.appTheme.readableGreyTitle),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: 16),
                              riskRatiosDataTable(),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          );
        });
  }

  Widget blackCard(Map data) {
    String schemeAmfi = data['scheme_amfi'] ?? "";
    num maturityValue = data['current_value'] ?? 0;
    num absoluteReturn = data['abs_return'] ?? 0;
    num xirr = data['returns'] ?? 0;
    num units = data['total_units'] ?? 0;
    num buyNav = data['start_nav'] ?? 0;
    num sellNav = data['end_nav'] ?? 0;

    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(schemeAmfi,
              style: AppFonts.f50014Black.copyWith(color: Colors.white)),
          SizedBox(height: 10),
          //2nd row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Maturity Value",
                  titleStyle: AppFonts.f40013.copyWith(
                      color: Config.appTheme.placeHolderInputTitleAndArrow),
                  value:
                      "$rupee ${Utils.formatNumber(maturityValue.round(), isAmount: false)}",
                  valueStyle:
                      AppFonts.f50014Black.copyWith(color: Colors.white)),
              ColumnText(
                title: "Abs Return",
                titleStyle: AppFonts.f40013.copyWith(
                    color: Config.appTheme.placeHolderInputTitleAndArrow),
                value: "${absoluteReturn.toStringAsFixed(2)}%",
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
                alignment: CrossAxisAlignment.center,
              ),
              ColumnText(
                  title: "XIRR",
                  titleStyle: AppFonts.f40013.copyWith(
                      color: Config.appTheme.placeHolderInputTitleAndArrow),
                  value: "${xirr.toStringAsFixed(2)}%",
                  valueStyle: AppFonts.f50014Black.copyWith(
                      color: (xirr > 0)
                          ? Config.appTheme.defaultProfit
                          : Config.appTheme.defaultLoss),
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          DottedLine(verticalPadding: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Units",
                  titleStyle: AppFonts.f40013.copyWith(
                      color: Config.appTheme.placeHolderInputTitleAndArrow),
                  value: Utils.formatNumber(
                      double.parse(units.toStringAsFixed(2))),
                  valueStyle:
                      AppFonts.f50014Black.copyWith(color: Colors.white)),
              ColumnText(
                title: "Buy NAV",
                titleStyle: AppFonts.f40013.copyWith(
                    color: Config.appTheme.placeHolderInputTitleAndArrow),
                value:
                    Utils.formatNumber(double.parse(buyNav.toStringAsFixed(2))),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
                alignment: CrossAxisAlignment.center,
              ),
              ColumnText(
                  title: "Sell NAV",
                  titleStyle: AppFonts.f40013.copyWith(
                      color: Config.appTheme.placeHolderInputTitleAndArrow),
                  value: Utils.formatNumber(
                      double.parse(sellNav.toStringAsFixed(2))),
                  valueStyle:
                      AppFonts.f50014Black.copyWith(color: Colors.white),
                  alignment: CrossAxisAlignment.end),
            ],
          ),
        ],
      ),
    );
  }

  Widget compareMutualFundsTile(Map data) {
    String schemeLogo = data['scheme_logo'] ?? "";
    String schemeAmfi = data['scheme_amfi_short_name'] ?? "";
    String schemeRating = data['scheme_rating'] ?? "";
    num maturityValue = data['current_value'] ?? 0;
    num absoluteReturn = data['abs_return'] ?? 0;
    num xirr = data['returns'] ?? 0;
    num units = data['total_units'] ?? 0;
    num buyNav = data['start_nav'] ?? 0;
    num sellNav = data['end_nav'] ?? 0;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          //1st row
          Row(
            children: [
              //Image.network(schemeLogo, height: 32),
              Utils.getImage(schemeLogo, 32),
              SizedBox(width: 10),
              Expanded(
                  child: Text(schemeAmfi,
                      style: TextStyle(fontWeight: FontWeight.bold))),
              // SizedBox(width: 5),
              // Container(
              //   padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              //   decoration: BoxDecoration(
              //       color: Color(0xffEDFFFF),
              //       borderRadius: BorderRadius.only(
              //         topLeft: Radius.circular(10),
              //         bottomLeft: Radius.circular(10),
              //       )),
              //   child: Row(children: [
              //     Text(schemeRating,
              //         style: TextStyle(color: Config.appTheme.themeColor)),
              //     Icon(Icons.star, color: Config.appTheme.themeColor, size: 20)
              //   ]),
              // )
            ],
          ),
          SizedBox(height: 10),
          //2nd row
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColumnText(
                        title: "Market Value",
                        value:
                            "$rupee ${Utils.formatNumber(maturityValue.round(), isAmount: false)}"),
                    ColumnText(
                      title: "Abs Return",
                      value: "${absoluteReturn.toStringAsFixed(2)}%",
                      alignment: CrossAxisAlignment.center,
                    ),
                    ColumnText(
                        title: "XIRR",
                        value: "${xirr.toStringAsFixed(2)}%",
                        valueStyle: AppFonts.f50014Black.copyWith(
                            color: (xirr > 0)
                                ? Config.appTheme.defaultProfit
                                : Config.appTheme.defaultLoss),
                        alignment: CrossAxisAlignment.end),
                  ],
                ),
                DottedLine(verticalPadding: 4),
                //3rd row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColumnText(
                      title: "Units",
                      value: Utils.formatNumber(
                          double.parse(units.toStringAsFixed(2))),
                    ),
                    ColumnText(
                      title: "Buy NAV",
                      value: Utils.formatNumber(
                          double.parse(buyNav.toStringAsFixed(2))),
                      alignment: CrossAxisAlignment.center,
                    ),
                    ColumnText(
                        title: "Sell NAV",
                        value: Utils.formatNumber(
                            double.parse(sellNav.toStringAsFixed(2))),
                        valueStyle: AppFonts.f50014Black,
                        alignment: CrossAxisAlignment.end),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget appBarColumn(String title, String value, Widget suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14)),
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

  showCompareMutualFundBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (_, bottomState) {
          return Container(
            color: Config.appTheme.mainBgColor,
            child: Container(
              height: devHeight * 0.90,
              padding: EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Padding(
                        //   padding: EdgeInsets.only(left: 10),
                        //   child: Text(
                        //     "Select Investor",
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.bold, fontSize: 16),
                        //   ),
                        // ),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close),
                        )
                      ],
                    ),
                    Divider(),
                    SizedBox(height: 16),
                    categoryExpansionTile(context, bottomState),
                    SizedBox(height: 16),
                    schemeExpansionTile(context, bottomState),
                   /* Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Row(
                        children: [
                          Text("Investment Amount",
                              style: AppFonts.f50014Black),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    investedAmountArea(),
                    startDateExpansionTile(context, bottomState),
                    SizedBox(height: 16),
                    endDateExpansionTile(context, bottomState),*/
                    SizedBox(height: 16),
                    compareFundsExpansionTile(context, bottomState),
                    SizedBox(height: 16),
                    buttonCard(),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  showAmountBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (_, bottomState) {
          return Container(
            color: Config.appTheme.mainBgColor,
            child: Container(
              height: devHeight * 0.90,
              padding: EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Padding(
                        //   padding: EdgeInsets.only(left: 10),
                        //   child: Text(
                        //     "Select Investor",
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.bold, fontSize: 16),
                        //   ),
                        // ),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close),
                        )
                      ],
                    ),
                    Divider(),
                    SizedBox(height: 16),
                   /* categoryExpansionTile(context, bottomState),
                    SizedBox(height: 16),
                    schemeExpansionTile(context, bottomState),*/
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Row(
                        children: [
                          Text("Investment Amount",
                              style: AppFonts.f50014Black),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    investedAmountArea(),
                    startDateExpansionTile(context, bottomState),
                    SizedBox(height: 16),
                    endDateExpansionTile(context, bottomState),
                   /* SizedBox(height: 16),
                    compareFundsExpansionTile(context, bottomState),
                    SizedBox(height: 16),*/
                    buttonCard(),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Container investedAmountArea() {
    return Container(
      width: devWidth,
      margin: EdgeInsets.fromLTRB(8, 0, 8, 16),
      decoration: BoxDecoration(
        border: Border.all(color: Config.appTheme.themeColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        cursorColor: Config.appTheme.themeColor,
        keyboardType:
            TextInputType.numberWithOptions(signed: true, decimal: true),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: Colors.white,
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white),
          contentPadding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        ),
        style: TextStyle(color: Config.appTheme.themeColor),
        controller: investedAmountController,
        onChanged: (text) async {
          investedAmount = text;
          setState(() {});
        },
      ),
    );
  }

  ExpansionTileController categoryController = ExpansionTileController();

  Widget categoryExpansionTile(BuildContext context, StateSetter bottomState) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: categoryController,
            title: Text("Category", style: AppFonts.f50014Black),
            tilePadding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedSubCategory.isEmpty ? "ALL" : selectedSubCategory,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Config.appTheme.themeColor,
                  ),
                ),
                DottedLine(),
              ],
            ),
            children: [
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: allCategories.length,
                  itemBuilder: (context, index) {
                    Map temp = allCategories[index];
                    bool isAllCategory = temp['name'] == "ALL";

                    return (selectedCategory == temp['name'])
                        ? selectedCategoryChip(temp['name'],
                            isAllCategory ? "" : temp['count'].toString())
                        : InkWell(
                            onTap: () async {
                              selectedCategory = temp['name'];

                              if (selectedCategory == "ALL") {
                                subCategoryList = [];
                                selectedSubCategory = "ALL";
                              } else {
                                subCategoryList = [];
                                await getCategoryList();
                                EasyLoading.show();
                                selectedSubCategory = subCategoryList.isNotEmpty
                                    ? subCategoryList[0]
                                    : ""; // Handle empty subcategories
                              }

                              selectedFund = "0 Fund Selected";
                              selectedItemsNew = [];
                              fundList = [];

                              if (selectedCategory != "ALL") {
                                await getTopLumpsumFunds();
                              }

                              EasyLoading.dismiss();
                              bottomState(() {});
                            },
                            child: categoryChip(temp['name'],
                                isAllCategory ? "" : temp['count'].toString()));
                  },
                ),
              ),
              SizedBox(height: 10),
              if (selectedCategory !=
                  "ALL") // Hide subcategories if "ALL" is selected
                SingleChildScrollView(
                  child: SizedBox(
                    height: 200,
                    child: ListView.separated(
                      itemCount: subCategoryList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        String temp = subCategoryList[index].split(":").last;
                        return InkWell(
                          onTap: () async {
                            selectedSubCategory = subCategoryList[index];
                            EasyLoading.show();
                            fundList = [];
                            selectedFund = "0 Fund Selected";
                            selectedItemsNew = [];
                            await getTopLumpsumFunds();
                            EasyLoading.dismiss();
                            bottomState(() {});
                            setState(() {
                              print(
                                  "selectedSubCategory = $selectedSubCategory");
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Row(
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Color(0xffF8DFD5),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Icon(
                                    Icons.bar_chart,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(child: Text(" $temp")),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 8);
                      },
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  TextEditingController searchController = TextEditingController();
  ExpansionTileController schemeController = ExpansionTileController();

  Widget schemeExpansionTile(BuildContext context, StateSetter bottomState) {
    List<bool> isSelectedList = List.filled(fundList.length, false);
    List<String> selectedSchemes = List.filled(fundList.length, '');
    List<String> selectedItems = [];

    if (selectedValues.isNotEmpty) {
      selectedItems = selectedValues.split(',');
      for (int i = 0; i < fundList.length; i++) {
        if (selectedItems.contains(fundList[i]['scheme_amfi'])) {
          isSelectedList[i] = true;
          selectedSchemes[i] = fundList[i]['scheme_amfi'];
        }
      }
    }
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: schemeController,
            title: Text("Select Funds to Compare", style: AppFonts.f50014Black),
            tilePadding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedFund,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Config.appTheme.themeColor,
                  ),
                ),
                DottedLine(),
              ],
            ),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: selectedItemsNew.length,
                      itemBuilder: (context, index) {
                        final selectedItem = selectedItemsNew[index];
                        return Container(
                          color: Config.appTheme.mainBgColor,
                          padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          selectedItem,
                                          style: AppFonts.f40013
                                              .copyWith(color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      IconButton(
                                        icon: Icon(Icons.close_outlined,
                                            size: 16, color: Colors.black),
                                        onPressed: () {
                                          bottomState(() {
                                            selectedItemsNew.removeAt(index);
                                            isSelectedList = List.filled(
                                                fundList.length, false);
                                            selectedItemsNew.forEach((item) {
                                              final index = fundList.indexWhere(
                                                  (element) =>
                                                      element[
                                                          'scheme_amfi_short_name'] ==
                                                      item);
                                              if (index != -1) {
                                                isSelectedList[index] = true;
                                              }
                                            });
                                            selectedFund =
                                                "${selectedItemsNew.length} Funds Selected";
                                            selectedValues =
                                                selectedItemsNew.join(',');
                                            print(
                                                "selectedValues $selectedValues");
                                            schemes = "";
                                            schemes = selectedValues;
                                            setState(() {});
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    TextField(
                      cursorColor: Colors.white,
                      controller: searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search Fund...',
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        filled: true,
                        fillColor: Config.appTheme.themeColor,
                      ),
                      onChanged: (value) {
                        searchController.text = value;
                        bottomState(() {});
                      },
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: fundList.length,
                        itemBuilder: (context, index) {
                          print(
                              'Search text changed: ${searchController.text}');
                          if (searchController.text.isNotEmpty &&
                              !fundList[index]['scheme_amfi_short_name']
                                  .toLowerCase()
                                  .contains(
                                      searchController.text.toLowerCase())) {
                            print(
                                'Filtering out: ${fundList[index]['scheme_amfi_short_name']}');
                            return SizedBox.shrink();
                          }
                          return ListTile(
                            //leading: Image.network(fundList[index]['logo'], height: 32),
                            // leading:
                            //     Utils.getImage(fundList[index]['logo'], 32),
                            title:
                                Text(fundList[index]['scheme_amfi_short_name']),
                            onTap: () {
                              bottomState(() {
                                if (isSelectedList[index]) {
                                  Utils.showError(
                                      context, "Scheme already selected");
                                } //else {
                                if (selectedItemsNew.length < 5) {
                                  isSelectedList[index] = true;
                                  selectedSchemes[index] =
                                      fundList[index]['scheme_amfi_short_name'];
                                  selectedItems.add(selectedSchemes[index]);
                                  selectedItemsNew.add(selectedSchemes[index]);
                                  selectedValues = selectedItemsNew.join(',');
                                  print("selectedValues = $selectedValues");
                                  schemes = selectedValues;
                                  setState(() {});
                                  selectedFund =
                                      "${selectedItemsNew.length} Funds Selected";
                                } else {
                                  Utils.showError(context,
                                      "Maximum Five Funds Only Select");
                                }
                                // }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectedCategoryChip(String name, String count) {
    List l = name.split(" ");
    if (l.length > 2) {
      name = "${l[0]} ${l[1]}";
    } else {
      name = "${l[0]}";
    }

    return Container(
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Config.appTheme.themeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        count.isNotEmpty ? "$name ($count)" : name, // Fix applied
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget categoryChip(String name, String count) {
    List l = name.split(" ");
    if (l.length > 2) {
      name = "${l[0]} ${l[1]}";
    } else {
      name = "${l[0]}";
    }

    return Container(
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Color(0XFFF1F1F1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        count.isNotEmpty ? "$name ($count)" : name, // Fix applied
      ),
    );
  }

  ExpansionTileController compareFundsController = ExpansionTileController();

  Widget compareFundsExpansionTile(
      BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: compareFundsController,
          title: Text("Compare Funds With", style: AppFonts.f50014Black),
          tilePadding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(compareType,
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
              itemCount: compareList.length,
              itemBuilder: (context, index) {
                final item = compareList[index];
                final isChecked = checkedValues.contains(item);
                return GestureDetector(
                  onTap: () {
                    bottomState(() {
                      if (isChecked) {
                        checkedValues.remove(item);
                      } else {
                        checkedValues.add(item);
                      }
                      compareType = checkedValues.join(',');
                      print("compareType-- $compareType");
                      if(compareType.contains('Nifty 50 TRI')){
                        sensex = 'true';
                      } if(compareType.contains('PPF')){
                        ppf = 'true';
                      } if(compareType.contains('Fixed Deposit')){
                        fd = 'true';
                      } if(compareType.contains('Gold')){
                        gold = 'true';
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (newValue) {
                          bottomState(() {
                            if (newValue!) {
                              checkedValues.add(item);
                            } else {
                              checkedValues.remove(item);
                            }
                            compareType = checkedValues.join(',');
                          });
                          print("compareType-- $compareType");
                          if(compareType.contains('Nifty 50 TRI')){
                            sensex = 'true';
                          } if(compareType.contains('PPF')){
                            ppf = 'true';
                          } if(compareType.contains('Fixed Deposit')){
                            fd = 'true';
                          } if(compareType.contains('Gold')){
                            gold = 'true';
                          }
                        },
                      ),
                      Expanded(
                        child: Text(
                          item,
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
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
            isPageLoad = false;
            schemes = selectedItemsNew.join(',');
            print("schemes = $schemes");

            if (schemes == "") {
              Utils.showError(context, "Please select the Fund");
              return;
            }
            if (investedAmount == "0") {
              Utils.showError(context, "Please Enter the Investment Amount");
              return;
            }
            compareType = checkedValues.join(',');
            print("checkedValuesString $compareType");
            EasyLoading.show();
            compareFundList = [];
            await getCompareFunds();
            setState(() {});
            EasyLoading.dismiss();
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Config.appTheme.buttonColor,
            foregroundColor: Colors.white,
          ),
          child: Text("SUBMIT"),
        ),
      ),
    );
  }

  Widget endDateExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: endDateController,
            onExpansionChanged: (val) {},
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
                  onDateTimeChanged: (value) {
                    selectedEndDate = value;
                    bottomState(() {});
                  },
                ),
              ),
            ],
          )),
    );
  }

  Widget startDateExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
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

  Widget basicInfoDataTable() {
    return Scrollbar(
      thickness: 5.0,
      thumbVisibility: true,
      radius: Radius.circular(10),
      controller: ScrollController(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          height: 140,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: DataTable(
                  headingRowHeight: 35,
                  horizontalMargin: 12,
                  headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      return Config.appTheme.themeColor;
                    },
                  ),
                  columns: [
                    DataColumn(
                      label: SizedBox(
                        width: 80,
                        child: Text(
                          'Fund',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 80,
                        child: Text(
                          'Category',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 60,
                        child: Text(
                          'AUM(Cr)',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 80,
                        child: Text(
                          'Latest Nav',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 26,
                        child: Text(
                          'TER',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 64,
                        child: Text(
                          'Inception',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                  rows:
                      List<DataRow>.generate(basicInfoTableData.length, (index) {
                    final rowData = basicInfoTableData[index];

                    String schemeAmfi = rowData['scheme_amfi_short_name'] ?? "";
                    num aum = rowData['scheme_assets'] ?? 0;
                    num price = rowData['price'] ?? 0;
                    num ter = rowData['ter'] ?? 0;
                    String inceptionDateStr = rowData['inception_date_str'] ?? "";

                    final color = index == 0 ? Colors.white : Colors.white;
                    return DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        return color;
                      }),
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              //Image.network(rowData['amc_logo'] ?? "", height: 32,),
                              Utils.getImage(rowData['amc_logo'], 32),
                              SizedBox(width: 8),
                              Expanded(
                                child: SizedBox(
                                  width: 160,
                                  child: Text(
                                    schemeAmfi,
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppFonts.f40013
                                        .copyWith(color: Colors.black),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Expanded(
                            child: SizedBox(
                              width: 160,
                              child: Text(
                                selectedSubCategory,
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    AppFonts.f40013.copyWith(color: Colors.black),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                        DataCell(Text(
                            Utils.formatNumber(aum / 10, isAmount: false),
                            textAlign: TextAlign.center)),
                        DataCell(Text("${price.toStringAsFixed(2)}%",
                            textAlign: TextAlign.center)),
                        DataCell(Text("${ter.toStringAsFixed(2)}%",
                            textAlign: TextAlign.center)),
                        DataCell(
                            Text(inceptionDateStr, textAlign: TextAlign.center)),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget fundInfoDataTable() {
    List<DataColumn> columns = basicInfoTableData.map<DataColumn>((rowData) {
      return DataColumn(
        label: Row(
          children: [
            //Image.network(rowData['amc_logo'] ?? "", height: 32,),
            Utils.getImage(rowData['amc_logo'], 32),
            SizedBox(width: 4),
            SizedBox(
              width: 160,
              child: Text(
                rowData['scheme_amfi_short_name'] ?? "",
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: AppFonts.f40013.copyWith(color: Colors.white),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      );
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 200,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: DataTable(
                headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return Config.appTheme.themeColor;
                  },
                ),
                columns: columns,
                rows: [
                  DataRow(
                    cells: List.generate(basicInfoTableData.length, (index) {
                      final rowData = basicInfoTableData[index];
                      String riskometer = rowData['riskometer'] ?? "";
                      return DataCell(
                        ColumnText(
                            title: "Riskometer",
                            titleStyle: AppFonts.f40013,
                            value: riskometer,
                            valueStyle:
                                AppFonts.f40013.copyWith(color: Colors.black)),
                      );
                    }),
                  ),
                  DataRow(
                    cells: List.generate(basicInfoTableData.length, (index) {
                      final rowData = basicInfoTableData[index];
                      String schemeBenchmark =
                          rowData['scheme_benchmark'] ?? "";
                      return DataCell(
                        ColumnText(
                            title: "Benchmark",
                            titleStyle: AppFonts.f40013,
                            value: schemeBenchmark,
                            valueStyle:
                                AppFonts.f40013.copyWith(color: Colors.black)),
                      );
                    }),
                  ),
                  DataRow(
                    cells: List.generate(basicInfoTableData.length, (index) {
                      final rowData = basicInfoTableData[index];
                      String schemeManager = rowData['scheme_manager'] ?? "";
                      return DataCell(
                        ColumnText(
                            title: "Fund Manager",
                            titleStyle: AppFonts.f40013,
                            value: schemeManager,
                            valueStyle:
                                AppFonts.f40013.copyWith(color: Colors.black)),
                      );
                    }),
                  ),
                  DataRow(
                    cells: List.generate(basicInfoTableData.length, (index) {
                      final rowData = basicInfoTableData[index];
                      String exit1 = rowData['exit1'] ?? "";
                      return DataCell(
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              ColumnText(
                                title: "Exit Load",
                                titleStyle: AppFonts.f40013,
                                value: exit1,
                                valueStyle: AppFonts.f40013
                                    .copyWith(color: Colors.black),
                              ),
                              // Add more widgets as needed
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  DataRow(
                    cells: List.generate(basicInfoTableData.length, (index) {
                      final rowData = basicInfoTableData[index];
                      String openOrClosed = rowData['open_or_closed'] ?? "";
                      return DataCell(
                        ColumnText(
                            title: "Fund Type",
                            titleStyle: AppFonts.f40013,
                            value: openOrClosed,
                            valueStyle:
                                AppFonts.f40013.copyWith(color: Colors.black)),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget trailingReturnsDataTable() {
    return Scrollbar(
      thickness: 5.0,
      thumbVisibility: true,
      radius: Radius.circular(10),
      controller: ScrollController(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          height: 140,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: DataTable(
                  headingRowHeight: 35,
                  horizontalMargin: 12,
                  headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      return Config.appTheme.themeColor;
                    },
                  ),
                  columns: [
                    DataColumn(
                      label: SizedBox(
                        width: 80,
                        child: Text(
                          'Fund',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 30,
                        child: Text(
                          '1M',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 30,
                        child: Text(
                          '3M',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 30,
                        child: Text(
                          '6M',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 30,
                        child: Text(
                          '1Y',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 30,
                        child: Text(
                          '3Y',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 30,
                        child: Text(
                          '5Y',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 30,
                        child: Text(
                          '10Y',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 150,
                        child: Text(
                          'Since Inception Rtn',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                  rows:
                      List<DataRow>.generate(basicInfoTableData.length, (index) {
                    final rowData = basicInfoTableData[index];

                    String schemeAmfi = rowData['scheme_amfi_short_name'] ?? "";
                    num returnsAbsOneMonth = rowData['returns_abs_1month'] ?? 0;
                    num returnsAbsThreeMonth = rowData['returns_abs_3month'] ?? 0;
                    num returnsAbsSixMonth = rowData['returns_abs_6month'] ?? 0;
                    num returnsAbsOneYear = rowData['returns_abs_1year'] ?? 0;
                    num returnsCmpThreeYear = rowData['returns_cmp_3year'] ?? 0;
                    num returnsCmpFiveYear = rowData['returns_cmp_5year'] ?? 0;
                    num returnsCmpTenYear = rowData['returns_cmp_10year'] ?? 0;
                    num returnsCmpInception =
                        rowData['returns_cmp_inception'] ?? 0;

                    final color = index == 0 ? Colors.white : Colors.white;
                    return DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        return color;
                      }),
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              //Image.network(rowData['amc_logo'] ?? "", height: 32,),
                              Utils.getImage(rowData['amc_logo'], 32),
                              SizedBox(width: 8),
                              Expanded(
                                child: SizedBox(
                                  width: 160,
                                  child: Text(
                                    schemeAmfi,
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppFonts.f40013
                                        .copyWith(color: Colors.black),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text("${returnsAbsOneMonth.toStringAsFixed(2)}%",
                            textAlign: TextAlign.center)),
                        DataCell(Text(
                            "${returnsAbsThreeMonth.toStringAsFixed(2)}%",
                            textAlign: TextAlign.center)),
                        DataCell(Text("${returnsAbsSixMonth.toStringAsFixed(2)}%",
                            textAlign: TextAlign.center)),
                        DataCell(Text("${returnsAbsOneYear.toStringAsFixed(2)}%",
                            textAlign: TextAlign.center)),
                        DataCell(Text(
                            "${returnsCmpThreeYear.toStringAsFixed(2)}%",
                            textAlign: TextAlign.center)),
                        DataCell(Text("${returnsCmpFiveYear.toStringAsFixed(2)}%",
                            textAlign: TextAlign.center)),
                        DataCell(Text("${returnsCmpTenYear.toStringAsFixed(2)}%",
                            textAlign: TextAlign.center)),
                        DataCell(Text(
                            "${returnsCmpInception.toStringAsFixed(2)}%",
                            textAlign: TextAlign.center)),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget lumpsumReturnsDataTable() {
    return Scrollbar(
      thickness: 5.0,
      thumbVisibility: true,
      radius: Radius.circular(10),
      controller: ScrollController(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          height: 140,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: DataTable(
                  headingRowHeight: 35,
                  horizontalMargin: 12,
                  headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      return Config.appTheme.themeColor;
                    },
                  ),
                  columns: [
                    DataColumn(
                      label: SizedBox(
                        width: 80,
                        child: Text(
                          'Fund',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 30,
                        child: Text(
                          '1Y',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 30,
                        child: Text(
                          '3Y',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 30,
                        child: Text(
                          '5Y',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 30,
                        child: Text(
                          '10Y',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                  rows:
                      List<DataRow>.generate(basicInfoTableData.length, (index) {
                    final rowData = basicInfoTableData[index];

                    String schemeAmfi = rowData['scheme_amfi_short_name'] ?? "";
                    num lumpOneYearCurrValue =
                        rowData['lump_1yr_current_value'].round() ?? 0;

                    num lumpThreeYearCurrValue =
                        rowData['lump_3yr_current_value'].round() ?? 0;

                    num lumpFiveYearCurrValue =
                        rowData['lump_5yr_current_value'].round() ?? 0;

                    num lumpTenYearCurrValue =
                        rowData['lump_10yr_current_value'].round() ?? 0;

                    final color = index == 0 ? Colors.white : Colors.white;
                    return DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        return color;
                      }),
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              //Image.network(rowData['amc_logo'] ?? "", height: 32,),
                              Utils.getImage(rowData['amc_logo'], 32),
                              SizedBox(width: 8),
                              Expanded(
                                child: SizedBox(
                                  width: 160,
                                  child: Text(
                                    schemeAmfi,
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppFonts.f40013
                                        .copyWith(color: Colors.black),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text(
                            "$rupee ${Utils.formatNumber(lumpOneYearCurrValue, isAmount: true)}",
                            textAlign: TextAlign.center)),
                        DataCell(Text(
                            "$rupee ${Utils.formatNumber(lumpThreeYearCurrValue, isAmount: true)}",
                            textAlign: TextAlign.center)),
                        DataCell(Text(
                            "$rupee ${Utils.formatNumber(lumpFiveYearCurrValue, isAmount: true)}",
                            textAlign: TextAlign.center)),
                        DataCell(Text(
                            "$rupee ${Utils.formatNumber(lumpTenYearCurrValue, isAmount: true)}",
                            textAlign: TextAlign.center)),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget sipReturnsDataTable() {
    return Scrollbar(
      thickness: 5.0,
      thumbVisibility: true,
      radius: Radius.circular(10),
      controller: ScrollController(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          height: 140,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: DataTable(
                  headingRowHeight: 35,
                  horizontalMargin: 12,
                  headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      return Config.appTheme.themeColor;
                    },
                  ),
                  columns: [
                    DataColumn(
                      label: SizedBox(
                        width: 80,
                        child: Text(
                          'Fund',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 30,
                        child: Text(
                          '1Y',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 30,
                        child: Text(
                          '3Y',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 30,
                        child: Text(
                          '5Y',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 30,
                        child: Text(
                          '10Y',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                  rows:
                      List<DataRow>.generate(basicInfoTableData.length, (index) {
                    final rowData = basicInfoTableData[index];

                    String schemeAmfi = rowData['scheme_amfi_short_name'] ?? "";
                    num sipOneYearCurrValue =
                        rowData['sip_1yr_current_value'].round() ?? 0;
                    num sipThreeYearCurrValue =
                        rowData['sip_3yr_current_value'].round() ?? 0;
                    num sipFiveYearCurrValue =
                        rowData['sip_5yr_current_value'].round() ?? 0;
                    num sipTenYearCurrValue =
                        rowData['sip_10yr_current_value'].round() ?? 0;

                    final color = index == 0 ? Colors.white : Colors.white;
                    return DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        return color;
                      }),
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              //Image.network(rowData['amc_logo'] ?? "", height: 32,),
                              Utils.getImage(rowData['amc_logo'], 32),
                              SizedBox(width: 8),
                              Expanded(
                                child: SizedBox(
                                  width: 160,
                                  child: Text(
                                    schemeAmfi,
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppFonts.f40013
                                        .copyWith(color: Colors.black),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text(
                            "$rupee ${Utils.formatNumber(sipOneYearCurrValue, isAmount: true)}",
                            textAlign: TextAlign.center)),
                        DataCell(Text(
                            "$rupee ${Utils.formatNumber(sipThreeYearCurrValue, isAmount: true)}",
                            textAlign: TextAlign.center)),
                        DataCell(Text(
                            "$rupee ${Utils.formatNumber(sipFiveYearCurrValue, isAmount: true)}",
                            textAlign: TextAlign.center)),
                        DataCell(Text(
                            "$rupee ${Utils.formatNumber(sipTenYearCurrValue, isAmount: true)}",
                            textAlign: TextAlign.center)),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget riskRatiosDataTable() {
    return Scrollbar(
      thickness: 5.0,
      thumbVisibility: true,
      radius: Radius.circular(10),
      controller: ScrollController(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          height: 140,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: DataTable(
                  headingRowHeight: 35,
                  horizontalMargin: 12,
                  headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      return Config.appTheme.themeColor;
                    },
                  ),
                  columns: [
                    DataColumn(
                      label: SizedBox(
                        width: 80,
                        child: Text(
                          'Fund',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 60,
                        child: Text(
                          'Std Dev',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 40,
                        child: Text(
                          'Mean',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 90,
                        child: Text(
                          'Sortino Ratio',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 40,
                        child: Text(
                          'Alpha',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 40,
                        child: Text(
                          'Beta',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 120,
                        child: Text(
                          'Sharp Ratio',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                  rows:
                      List<DataRow>.generate(basicInfoTableData.length, (index) {
                    final rowData = basicInfoTableData[index];

                    String schemeAmfi = rowData['scheme_amfi_short_name'] ?? "";
                    num standardDeviation = rowData['standard_deviation'] ?? 0;
                    num mean = rowData['mean'] ?? 0;
                    num sortinoRatio = rowData['sortino_ratio'] ?? 0;
                    num alpha = rowData['alpha'] ?? 0;
                    num beta = rowData['beta'] ?? 0;
                    num sharpRatio = rowData['sharpratio'] ?? 0;

                    final color = index == 0 ? Colors.white : Colors.white;
                    return DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        return color;
                      }),
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              //Image.network(rowData['amc_logo'] ?? "", height: 32,),
                              Utils.getImage(rowData['amc_logo'], 32),
                              SizedBox(width: 8),
                              Expanded(
                                child: SizedBox(
                                  width: 160,
                                  child: Text(
                                    schemeAmfi,
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppFonts.f40013
                                        .copyWith(color: Colors.black),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text("${standardDeviation.toStringAsFixed(2)}%",
                            textAlign: TextAlign.center)),
                        DataCell(Text("${mean.toStringAsFixed(2)}%",
                            textAlign: TextAlign.center)),
                        DataCell(Text("${sortinoRatio.toStringAsFixed(2)}%",
                            textAlign: TextAlign.center)),
                        DataCell(Text("${alpha.toStringAsFixed(2)}%",
                            textAlign: TextAlign.center)),
                        DataCell(Text("${beta.toStringAsFixed(2)}%",
                            textAlign: TextAlign.center)),
                        DataCell(Text("${sharpRatio.toStringAsFixed(2)}%",
                            textAlign: TextAlign.center)),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
