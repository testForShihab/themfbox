import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/advisor/reports/portfolioAnalysisReport/PortfolioAnalysisDetails.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class PortfolioAnalysisReport extends StatefulWidget {
  const PortfolioAnalysisReport({super.key});

  @override
  State<PortfolioAnalysisReport> createState() =>
      _PortfolioAnalysisReportState();
}

class _PortfolioAnalysisReportState extends State<PortfolioAnalysisReport> {
  late double devWidth, devHeight;
  List allCategories = [];
  late int user_id;
  late String client_name;

  ExpansionTileController typeController = ExpansionTileController();
  ExpansionTileController nameController = ExpansionTileController();
  ExpansionTileController benchMarkTypeController = ExpansionTileController();
  String investorName = 'Search and Select Investor';
  List investorList = [];
  List portfolioList = [];

  int page_id = 1;
  String searchKey = "";
  bool isFirst = true;
  int investorId = 0;

  String selectedInvestor = "";
  int selectedRadioIndex = 0;
  String schemes = "ICICI Prudential Value Discovery Fund - Growth";
  String selectedValues = "ICICI Prudential Value Discovery Fund - Growth";
  Map reportActionData = {
    "Download PDF Report ": ["", "", "assets/pdf.png"],
    "Download Excel Report": ["", "", "assets/excel.png"],
  };
  List<String> benchMarkType = [
    "NIFTY 50 TRI",
    "NIFTY 100 TRI",
    "NIFTY 500 TRI",
    "Nifty MIDCAP 150 TRI",
  ];

  Map benchMarkMap = {
    "NIFTY 50 TRI": "NIFTY50",
    "NIFTY 100 TRI": "NIFTY100",
    "NIFTY 200 TRI": "NIFTY200",
    "NIFTY 500 TRI": "NIFTY500",
    "NIFTY500 MULTICAP 50:25:25 TRI":"NIFTY500MULTICAP50:25:25",
    "AK Hybrid Aggressive TRI":"HybAgg",
    "AK Hybrid Balanced TRI":"HybBal",
    "NIFTY 10 yr Benchmark G-Sec Index":"NFT10GSEC",
  /*"S&P BSE MidCap TRI": "BSEMidCapTRI",
    "S&P BSE SmallCap TRI": "BSESmallCapTRI",*/
  };

  String selectedBenchMarkType = "NIFTY50";
  String selectedBenchMarkTypeKeys = "NIFTY 50 TRI";
  String benchMarkTypeName = "NIFTY50";
  List<dynamic> benchMarkMonitorsData = [];

  bool isLoading = true;
  TextEditingController investorNameController = TextEditingController();
  bool schemesLoaded = false;
  TextStyle underlineText = TextStyle(
      color: Config.appTheme.themeColor, decoration: TextDecoration.underline);

  int? selectedIndex;

  String scheme = "";

  Timer? searchOnStop;

  num eqtPortfolioCurrVal = 0;
  num eqtPortfolioReturn = 0;
  num benchmarkCurrVal = 0;
  num benchmarkReturn = 0;
  num extraReturn = 0;
  String formattedExtraReturn = "";

  Future searchInvestor(StateSetter bottomState) async {
    investorList = [];
    EasyLoading.show(status: "Searching for `$searchKey`");
    Map data = await AdminApi.getInvestors(
        page_id: page_id,
        client_name: client_name,
        user_id: user_id,
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
    user_id = getUserId();
    client_name = GetStorage().read("client_name");
  }

  Future getDatas() async {
    isLoading = true;
    await getInitialInvestor();
    isLoading = false;
    return 0;
  }

  Future fetchMoreInvestor() async {
    page_id++;
    Map data = await AdminApi.getInvestors(
        page_id: page_id,
        client_name: client_name,
        user_id: user_id,
        branch: "",
        rmList: []);

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

  Future getInitialInvestor() async {
    if (!isFirst) return 0;

    Map data = await AdminApi.getInvestors(
        page_id: page_id,
        client_name: client_name,
        user_id: user_id,
        branch: "",
        rmList: []);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    investorList = data['list'];
    if (isFirst) {
      investorId = investorList[0]['id'];
      selectedInvestor = investorList[0]['name'];
    }
    await getPortfolioAnalysisReport();
    setState(() {});
    isFirst = false;
    return 0;
  }

  Future getPortfolioAnalysisReport() async {
    if (portfolioList.isNotEmpty) return 0;

    Map data = await AdminApi.getPortfolioAnalysisReport(
      user_id: investorId,
      client_name: client_name,
      benchmark_code: selectedBenchMarkType,
      name_pan: selectedInvestor,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    eqtPortfolioCurrVal = data['eqt_portfolio_curr_val'] ?? 0;
    eqtPortfolioReturn = data['eqt_portfolio_return'] ?? 0;
    benchmarkCurrVal = data['benchmark_curr_val'] ?? 0;
    benchmarkReturn = data['benchmark_return'] ?? 0;
    extraReturn = data['extra_return'] ?? 0;
    num extraValue = extraReturn;
    formattedExtraReturn = extraValue.toStringAsFixed(2);
    portfolioList = data['equity_list'] ?? [];
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
            backgroundColor: Color(0XFFECF0F0),
            appBar: AppBar(
              backgroundColor: Config.appTheme.themeColor,
              leadingWidth: 0,
              toolbarHeight: 140,
              foregroundColor: Colors.white,
              elevation: 0,
              leading: SizedBox(),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Get.back(); // Navigate back
                        },
                        child: Text(
                          "Portfolio Analysis Report",
                          style: AppFonts.f50014Black.copyWith(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Spacer(),
                      /*GestureDetector(
                        onTap: () {
                          showCustomizeBottomSheet();
                        },
                        child: Icon(Icons.filter_alt_outlined),
                      ),*/
                      SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                          onTap: () {
                            showReportActionBottomSheet();
                          },
                          child: Icon(Icons.pending_outlined)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          searchKey = "";
                          //await getInitialInvestor();
                          // portfolioList = [];
                          // await getPortfolioAnalysisReport();
                          // setState(() {});
                          showInvestorBottomSheet();
                        },
                        child: appBarColumn(
                            "Investor",
                            selectedInvestor.replaceAll(RegExp(r'\[.*?\]'), ''),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
                      ),
                      GestureDetector(
                        onTap: () {
                          showBenchMarkMonitorBottomSheet();
                        },
                        child: appBarColumn(
                            "BenchMark",
                            getFirst15(
                              "${getKeyByValue(benchMarkMap, selectedBenchMarkType)}",
                            ),
                            Icon(Icons.keyboard_arrow_down,
                                color: Config.appTheme.themeColor)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            body: displayPage(),
          );
        });
  }

  Widget displayPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (isLoading
              ? Utils.shimmerWidget(devHeight, margin: EdgeInsets.all(16))
              : (portfolioList.isEmpty
                  ? NoData()
                  : Column(
                      children: [
                        blackBoxPortfolio(),
                        SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: (portfolioList.length / 2).ceil(),
                          itemBuilder: (context, index) {
                            int oddIndex = index * 2;
                            Map data = portfolioList[oddIndex];
                            Map nextData = {};
                            if (oddIndex + 1 < portfolioList.length) {
                              nextData = portfolioList[oddIndex + 1];
                            }
                            return returnsPortfolioAnalysis(data, nextData);
                          },
                        ),
                      ],
                    ))),
          SizedBox(height: devHeight * 0.3),
        ],
      ),
    );
  }

  String getFirst15(String text) {
    String s = text.split(":").last;
    if (s.length > 15) s = '${s.substring(0, 15)}...';
    return s;
  }

  Widget blackBoxPortfolio() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 16, 6, 0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.symmetric(horizontal: devWidth * 0.04),
        padding:
            EdgeInsets.symmetric(horizontal: devWidth * 0.04, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150,
                  child: Text(""),
                ),
                Text("Current Value",
                    textAlign: TextAlign.end,
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
                Text("XIRR (%)",
                    textAlign: TextAlign.end,
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Portfolio",
                  style: AppFonts.f40013
                      .copyWith(color: Config.appTheme.lineColor),
                ),
                Expanded(
                  child: Text(
                    "$rupee ${Utils.formatNumber(eqtPortfolioCurrVal.round(), isAmount: true)}",
                    textAlign: TextAlign.end,
                    style: AppFonts.f50012.copyWith(color: Colors.white),
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  "$eqtPortfolioReturn%",
                  textAlign: TextAlign.end,
                  style: AppFonts.f50012.copyWith(color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                      "${getKeyByValue(benchMarkMap, selectedBenchMarkType)}",
                      style: AppFonts.f40013
                          .copyWith(color: Config.appTheme.lineColor)),
                ),
                Expanded(
                    child: Text(
                        "$rupee ${Utils.formatNumber(benchmarkCurrVal.round(), isAmount: true)}",
                        textAlign: TextAlign.end,
                        style: AppFonts.f50012.copyWith(color: Colors.white))),
                SizedBox(width: 16),
                Text("$benchmarkReturn%",
                    textAlign: TextAlign.end,
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ],
            ),
            DottedLine(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Portfolio vs Benchmark",
                    textAlign: TextAlign.end,
                    style: AppFonts.f40013.copyWith(
                        fontSize: 14, color: Config.appTheme.lineColor)),
                Text("$formattedExtraReturn%",
                    style: AppFonts.f50012.copyWith(
                        color: (extraReturn > 0)
                            ? Config.appTheme.defaultProfit
                            : Config.appTheme.defaultLoss)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget appBarColumn(String title, String value, Widget suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.f40013.copyWith(color: Colors.white),
        ),
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
                Expanded(
                  child: Text(value, style: AppFonts.f50012),
                ),
                suffix
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget returnsPortfolioAnalysis(Map data, Map nextData) {
    String shortName = data['scheme_amfi_short_name'] ?? "";
    String folio = data['foliono'] ?? "";
    num cagr = data['cagr'] ?? 0;
    num totalCurrentValue = data['totalCurrentValue'] ?? 0;

    String nextshortName = nextData['scheme_amfi_short_name'] ?? "";
    num nextCagr = nextData['cagr'] ?? 0;
    num nextTotalCurrentValue = nextData['totalCurrentValue'] ?? 0;

    num extraReturn = double.parse((cagr - nextCagr ).toStringAsFixed(2));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: GestureDetector(
        onTap: () {
          print("tapped");
          Get.to(() =>
              PortfolioAnalysisDetails(summary: data, nextSummary: nextData));
        },
        child: Card(
          elevation: 0,
          color: Colors.white,
          child: Column(
            children: [
              //1st row
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Row(
                  children: [
                    Image.network(
                      data["amc_logo"],
                      height: 32,
                    ),
                    SizedBox(width: 6),
                    Expanded(
                        child: ColumnText(
                      title: shortName,
                      value: "Folios : $folio",
                      titleStyle: AppFonts.f50014Black,
                      valueStyle: AppFonts.f40013,
                    )),
                    SizedBox(width: 8),
                    ColumnText(
                        title: "$cagr%",
                        titleStyle: AppFonts.f50014Black,
                        value:
                            "$rupee ${Utils.formatNumber(totalCurrentValue.round(), isAmount: true)}",
                        valueStyle: AppFonts.f40013,
                        alignment: CrossAxisAlignment.end)
                  ],
                ),
              ),
              //2nd row
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 26,
                          width: 26,
                          decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(Icons.bar_chart, color: Colors.purple),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            nextshortName,
                            style: AppFonts.f50014Black,
                          ),
                        ),
                        SizedBox(width: 5),
                        ColumnText(
                            title: "$nextCagr%",
                            titleStyle: AppFonts.f50014Black,
                            value:
                                "$rupee ${Utils.formatNumber(nextTotalCurrentValue.round(), isAmount: true)}",
                            valueStyle: AppFonts.f40013,
                            alignment: CrossAxisAlignment.end)
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                child: DottedLine(),
              ),
              //3rd row
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Extra Return:",
                            style: AppFonts.f40013
                                .copyWith(fontSize: 14, color: Colors.black)),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          "$extraReturn%",
                          style: AppFonts.f50014Black.copyWith(
                              color: (extraReturn > 0)
                                  ? Config.appTheme.defaultProfit
                                  : Config.appTheme.defaultLoss),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Config.appTheme.placeHolderInputTitleAndArrow,
                        ),
                      ],
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

  showInvestorBottomSheet() {
    bool isExpanded = true;
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
                    BottomSheetTitle(title: "Select Investor"),
                    Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          initiallyExpanded: isExpanded,
                          onExpansionChanged: (expanded) {
                            setState(() {
                              isExpanded = expanded;
                            });
                          },
                          controller: nameController,
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
                                  controller: investorNameController,
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
                                        investorNameController.text = name;
                                        isExpanded = true;
                                      });
                                      isExpanded = true;
                                      // nameController.collapse();
                                      setState(() {});
                                    },
                                    child: ListTile(
                                      leading: InitialCard(
                                          title: (name == "") ? "." : name),
                                      title: Text(name),
                                    ),
                                  );
                                },
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                if (searchKey.isNotEmpty) return;
                                EasyLoading.show();
                                await fetchMoreInvestor();
                                bottomState(() {});
                                setState(() {});
                                EasyLoading.dismiss();
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
                    SizedBox(height: 8),
                    Container(
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
                            EasyLoading.show();
                            selectedInvestor = investorName;
                            portfolioList = [];
                            await getPortfolioAnalysisReport();
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
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  showCustomizeBottomSheet() {
    bool isExpanded = true;
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
              height: devHeight * 0.9,
              decoration: BoxDecoration(
                color: Config.appTheme.mainBgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  BottomSheetTitle(title: "Customize Report"),
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                initiallyExpanded: isExpanded,
                                onExpansionChanged: (expanded) {
                                  setState(() {
                                    isExpanded = expanded;
                                  });
                                },
                                controller: nameController,
                                title: Text("Investor",
                                    style: AppFonts.f50014Black),
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
                                        controller: investorNameController,
                                        onChanged: (val) {
                                          searchKey = val;
                                          searchHandler(bottomState);
                                        },
                                        decoration: InputDecoration(
                                            suffixIcon: Icon(Icons.close,
                                                color:
                                                    Config.appTheme.themeColor),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                10, 2, 12, 2),
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
                                        String name =
                                            investorList[index]['name'];
                                        String pan = investorList[index]['pan'];

                                        return InkWell(
                                          onTap: () {
                                            bottomState(() {
                                              investorId =
                                                  investorList[index]['id'];
                                              print("investorId $investorId");
                                              investorName = "$name [$pan]";
                                              investorNameController.text =
                                                  name;
                                              isExpanded = true;
                                            });
                                            isExpanded = true;
                                            // nameController.collapse();
                                            setState(() {});
                                          },
                                          child: ListTile(
                                            leading: InitialCard(
                                                title:
                                                    (name == "") ? "." : name),
                                            title: Text(name),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      if (searchKey.isNotEmpty) return;
                                      EasyLoading.show();
                                      await fetchMoreInvestor();
                                      bottomState(() {});
                                      setState(() {});
                                      EasyLoading.dismiss();
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
                          SizedBox(height: 10),
                          Container(
                            margin: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                controller: benchMarkTypeController,
                                onExpansionChanged: (val) {},
                                title: Text("Select Benchmark",
                                    style: AppFonts.f50014Black),
                                tilePadding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${getKeyByValue(benchMarkMap, selectedBenchMarkType)}",
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
                                    itemCount: benchMarkMap.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          selectedBenchMarkType = benchMarkMap.values.elementAt(index);
                                          selectedBenchMarkTypeKeys = benchMarkMap.keys.elementAt(index);
                                          print(
                                              "selectedReportType $selectedBenchMarkType");
                                          bottomState(() {});
                                        },
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: benchMarkMap.values.elementAt(index),
                                              groupValue: selectedBenchMarkType,
                                              onChanged: (value) {
                                                selectedBenchMarkType = benchMarkMap.values.elementAt(index);
                                                selectedBenchMarkTypeKeys = benchMarkMap.keys.elementAt(index);
                                                print(
                                                    "selectedReportType $selectedBenchMarkType");
                                                bottomState(() {});
                                              },
                                            ),
                                            Text(
                                                "${benchMarkMap.keys.elementAt(index)}"),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  Container(
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
                          EasyLoading.show();
                          selectedInvestor = investorName;
                          portfolioList = [];
                          await getPortfolioAnalysisReport();
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
                  ),
                ],
              ),
            );
          });
        });
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
                print("investorIddd $investorId");
                if (investorId != 0) {
                  if (index == 0) {
                    String url =
                        "${ApiConfig.apiUrl}/admin/download/portfolioAnalysisReport?key=${ApiConfig.apiKey}&user_id=$investorId&client_name=$client_name&type=pdf&start_date="
                        "&end_date=&benchmark_code=$selectedBenchMarkType";

                    http.Response response = await http.post(Uri.parse(url));
                    msgUrl = response.body;
                    Map data = jsonDecode(msgUrl);
                    String resUrl = data['msg'];
                    print("download $url");
                    rpDownloadFile(url: resUrl, context: context, index: index);
                    EasyLoading.dismiss();
                    Get.back();
                  } else if (index == 1) {
                    EasyLoading.show();
                    String url =
                        "${ApiConfig.apiUrl}/admin/download/portfolioAnalysisReport?key=${ApiConfig.apiKey}&user_id=$investorId&client_name=$client_name&type=excel&start_date="
                        "&end_date=&benchmark_code=$selectedBenchMarkType";
                    http.Response response = await http.post(Uri.parse(url));
                    msgUrl = response.body;
                    Map data = jsonDecode(msgUrl);
                    String resUrl = data['msg'];
                    print("email $url");
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

  // showInvestorBottomSheet() {
  //   print("selectedInvestor $selectedInvestor");
  //   bool isExpanded = true;
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(10),
  //         topRight: Radius.circular(10),
  //       ),
  //     ),
  //     builder: (context) {
  //       return StatefulBuilder(builder: (_, bottomState) {
  //         return Container(
  //           height: devHeight * 0.82,
  //           padding: EdgeInsets.all(8),
  //           child: Column(
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Padding(
  //                     padding: EdgeInsets.only(left: 10),
  //                     child: Text(
  //                       "Select Investor",
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.bold, fontSize: 16),
  //                     ),
  //                   ),
  //                   IconButton(
  //                     onPressed: () {
  //                       Get.back();
  //                     },
  //                     icon: Icon(Icons.close),
  //                   )
  //                 ],
  //               ),
  //               Divider(),
  //               SizedBox(height: 10),
  //               Expanded(
  //                 child: Container(
  //                   margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
  //                   decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   child: Theme(
  //                     data: Theme.of(context)
  //                         .copyWith(dividerColor: Colors.transparent),
  //                     child: ExpansionTile(
  //                       initiallyExpanded: isExpanded,
  //                       onExpansionChanged: (expanded) {
  //                         setState(() {
  //                           isExpanded = expanded;
  //                         });
  //                       },
  //                       controller: nameController,
  //                       title: Text("Investor", style: AppFonts.f50014Black),
  //                       subtitle: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             investorName,
  //                             style: TextStyle(
  //                               fontWeight: FontWeight.w500,
  //                               fontSize: 13,
  //                               color: Config.appTheme.themeColor,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       children: [
  //                         Padding(
  //                           padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
  //                           child: SizedBox(
  //                             height: 40,
  //                             child: TextFormField(
  //                               onChanged: (val) {
  //                                 searchKey = val;
  //                                 searchHandler(bottomState);
  //                               },
  //                               decoration: InputDecoration(
  //                                   suffixIcon: Icon(Icons.close,
  //                                       color: Config.appTheme.themeColor),
  //                                   contentPadding:
  //                                       EdgeInsets.fromLTRB(10, 2, 12, 2),
  //                                   border: OutlineInputBorder(
  //                                       borderRadius:
  //                                           BorderRadius.circular(10))),
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           height: 260,
  //                           child: ListView.builder(
  //                             itemCount: investorList.length,
  //                             itemBuilder: (context, index) {
  //                               String name = investorList[index]['name'];
  //                               String pan = investorList[index]['pan'];

  //                               return InkWell(
  //                                 onTap: () {
  //                                   bottomState(() {
  //                                     investorId = investorList[index]['id'];
  //                                     print("investorId $investorId");
  //                                     investorName = "$name [$pan]";
  //                                     isExpanded = true;
  //                                   });
  //                                   isExpanded = true;
  //                                   // nameController.collapse();
  //                                   setState(() {});
  //                                 },
  //                                 child: ListTile(
  //                                   leading: InitialCard(title: (name == "") ? "." : name),
  //                                   title: Text(name),
  //                                 ),
  //                               );
  //                             },
  //                           ),
  //                         ),
  //                         InkWell(
  //                           onTap: () async {
  //                             if (searchKey.isNotEmpty) return;
  //                             EasyLoading.show();
  //                             await fetchMoreInvestor();
  //                             bottomState(() {});
  //                             setState(() {});
  //                             EasyLoading.dismiss();
  //                           },
  //                           child: Text(
  //                             "Load More Results",
  //                             style: TextStyle(
  //                               decoration: TextDecoration.underline,
  //                               color: Config.appTheme.themeColor,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(height: 16),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(height: 16),
  //               Container(
  //                 width: devWidth,
  //                 padding: EdgeInsets.all(16),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 child: SizedBox(
  //                   height: 45,
  //                   child: ElevatedButton(
  //                     onPressed: () async {
  //                       EasyLoading.show();
  //                       selectedInvestor = investorName;
  //                       portfolioList = [];
  //                       await getPortfolioAnalysisReport();
  //                       EasyLoading.dismiss();
  //                       setState(() {});
  //                       Get.back();
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                       backgroundColor: Config.appTheme.themeColor,
  //                       foregroundColor: Colors.white,
  //                     ),
  //                     child: Text("SUBMIT"),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }

  showBenchMarkMonitorBottomSheet() {
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
                    BottomSheetTitle(title: "Select Benchmark"),
                    Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          initiallyExpanded: true,
                          controller: benchMarkTypeController,
                          onExpansionChanged: (val) {},
                          title: Text("Select Benchmark",
                              style: AppFonts.f50014Black),
                          tilePadding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${getKeyByValue(benchMarkMap, selectedBenchMarkType)}",
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
                              itemCount: benchMarkMap.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    selectedBenchMarkType =
                                        benchMarkMap.values.elementAt(index);
                                    selectedBenchMarkTypeKeys =
                                        benchMarkMap.keys.elementAt(index);
                                    print(
                                        "selectedReportType $selectedBenchMarkType");
                                    bottomState(() {});
                                  },
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: benchMarkMap.values
                                            .elementAt(index),
                                        groupValue: selectedBenchMarkType,
                                        onChanged: (value) {
                                          selectedBenchMarkType = benchMarkMap
                                              .values
                                              .elementAt(index);
                                          selectedBenchMarkTypeKeys =
                                              benchMarkMap.keys
                                                  .elementAt(index);
                                          print(
                                              "selectedReportType $selectedBenchMarkType");
                                          bottomState(() {});
                                        },
                                      ),
                                      Text(
                                          "${benchMarkMap.keys.elementAt(index)}"),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
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
                            EasyLoading.show();
                            benchMarkTypeName = selectedBenchMarkType;
                            portfolioList = [];
                            await getPortfolioAnalysisReport();
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
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  // showBenchMarkMonitorBottomSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(10),
  //         topRight: Radius.circular(10),
  //       ),
  //     ),
  //     builder: (context) {
  //       return StatefulBuilder(builder: (_, bottomState) {
  //         return Container(
  //           height: devHeight * 0.80,
  //           padding: EdgeInsets.all(8),
  //           child: Column(
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text("Select Benchmark",
  //                       style: AppFonts.f50014Grey
  //                           .copyWith(fontSize: 16, color: Color(0xff242424))),
  //                   IconButton(
  //                       onPressed: () {
  //                         Get.back();
  //                       },
  //                       icon: Icon(Icons.close)),
  //                 ],
  //               ),
  //               Divider(
  //                 color: Color(0XFFDFDFDF),
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //       Expanded(
  //         child: Container(
  //           margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
  //           decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(10)),
  //           child: Theme(
  //             data: Theme.of(context)
  //                 .copyWith(dividerColor: Colors.transparent),
  //             child: ExpansionTile(
  //               initiallyExpanded: true,
  //               controller: benchMarkTypeController,
  //               onExpansionChanged: (val) {},
  //               title: Text("Select Benchmark",
  //                   style: AppFonts.f50014Black),
  //               tilePadding: EdgeInsets.fromLTRB(16, 12, 16, 0),
  //               subtitle: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                       "${getKeyByValue(benchMarkMap, selectedBenchMarkType)}",
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.w500,
  //                           fontSize: 12,
  //                           color: Config.appTheme.themeColor)),
  //                   DottedLine(),
  //                 ],
  //               ),
  //               children: [
  //                 ListView.builder(
  //                   shrinkWrap: true,
  //                   physics: NeverScrollableScrollPhysics(),
  //                   itemCount: benchMarkMap.length,
  //                   itemBuilder: (context, index) {
  //                     return InkWell(
  //                       onTap: () {
  //                         selectedBenchMarkType =
  //                             benchMarkMap.values.elementAt(index);
  //                         selectedBenchMarkTypeKeys =
  //                             benchMarkMap.keys.elementAt(index);
  //                         print(
  //                             "selectedReportType $selectedBenchMarkType");
  //                         bottomState(() {});
  //                       },
  //                       child: Row(
  //                         children: [
  //                           Radio(
  //                             value:
  //                                 benchMarkMap.values.elementAt(index),
  //                             groupValue: selectedBenchMarkType,
  //                             onChanged: (value) {
  //                               selectedBenchMarkType = benchMarkMap
  //                                   .values
  //                                   .elementAt(index);
  //                               selectedBenchMarkTypeKeys =
  //                                   benchMarkMap.keys.elementAt(index);
  //                               print(
  //                                   "selectedReportType $selectedBenchMarkType");
  //                               bottomState(() {});
  //                             },
  //                           ),
  //                           Text(
  //                               "${benchMarkMap.keys.elementAt(index)}"),
  //                         ],
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //       SizedBox(height: 16),
  //       Container(
  //         width: devWidth,
  //         padding: EdgeInsets.all(16),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         child: SizedBox(
  //           height: 45,
  //           child: ElevatedButton(
  //             onPressed: () async {
  //               EasyLoading.isShow;
  //               benchMarkTypeName = selectedBenchMarkType;
  //               portfolioList = [];
  //               await getPortfolioAnalysisReport();
  //               EasyLoading.dismiss();
  //               setState(() {});
  //               Get.back();
  //             },
  //             style: ElevatedButton.styleFrom(
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               backgroundColor: Config.appTheme.themeColor,
  //               foregroundColor: Colors.white,
  //             ),
  //             child: Text("SUBMIT"),
  //           ),
  //         ),
  //       ),
  //     ],
  //   ),
  // );
  //       });
  //     },
  //   );
  // }

  getKeyByValue(Map map, String value) {
    return map.keys.firstWhere((element) => map[element] == value);
  }

  Widget benchmarkExpansionTile(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: typeController,
          title: Text("Select Investment Options", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedBenchMarkTypeKeys,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Config.appTheme.themeColor)),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemCount: benchMarkType.length,
              itemBuilder: (context, index) {
                String temp = benchMarkType[index];

                return InkWell(
                  onTap: () {
                    selectedBenchMarkType = temp;
                    typeController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: selectedBenchMarkType,
                        onChanged: (value) {
                          selectedBenchMarkType = temp;
                          typeController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(temp),
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
}
