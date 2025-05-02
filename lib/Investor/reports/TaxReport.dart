import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/Investor/reports/TaxReportDetails.dart';
import 'package:mymfbox2_0/api/ReportApi.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/NoData.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class TaxReport extends StatefulWidget {
  const TaxReport({super.key});

  @override
  State<TaxReport> createState() => _TaxReportState();
}

class _TaxReportState extends State<TaxReport> {
  late double devWidth, devHeight;

  int userId = GetStorage().read("user_id");
  String clientName = GetStorage().read("client_name");
  bool isLoading = true;
  List financialYearList = [
    "2024-2025",
    "2023-2024",
  ];
  List equityList = [];
  List debtList = [];
  String selectedTitle = "Equity";
  bool isDateRange = false;
  String? selectedOption;
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  ExpansionTileController startDatecontroller = ExpansionTileController();
  ExpansionTileController endDateController = ExpansionTileController();

  int selectedRadio = 0;
  bool isExpanded = false;

  num portfolioTotalGain = 0;
  num portfolioLongGain = 0;
  num portfolioShortGain = 0;

  num equityLongTermSoldAmt = 0;
  num equityShortTermSoldAmt = 0;
  num equityLongTermPuchaseAmt = 0;
  num equityShortTermPurchaseAmt = 0;
  num equityLongTermIndexAmt = 0;

  num equityLongGainLoss = 0;
  num equityShortGainLoss = 0;
  num equityShortLoss = 0;
  num equityLongLoss = 0;

  num debtLongTermSoldAmt = 0;
  num debtShortTermSoldAmt = 0;
  num debtLongTermPuchaseAmt = 0;
  num debtShortTermPurchaseAmt = 0;

  num debtLongGainLoss = 0;
  num debtShortGainLoss = 0;
  num debtShortLoss = 0;
  num debtLongLoss = 0;
  num debtLongTermIndexAmt = 0;

  String selectedFinancialYear = "";
  Map reportActionData = {
    "Download PDF Report ": ["", "", "assets/pdf.png"],
    /*"Download Excel Report": ["", "", "assets/excel.png"],*/
    "Email Report": ["", null, "assets/email.png"],
  };

  Future getMfTaxReport() async {
    if (portfolioTotalGain != 0) return 0;
    print("getMfTaxReport userId $userId");
    print("selectedFinancialYear $selectedFinancialYear");
    Map data = await ReportApi.getMfTaxReport(
      user_id: userId,
      client_name: clientName,
      financial_year:
          selectedFinancialYear == "date-range" ? "" : selectedFinancialYear,
      option: (selectedFinancialYear == "date-range") ? "range" : "fy",
      start_date: selectedFinancialYear == "date-range"
          ? convertDtToStr(selectedStartDate)
          : "",
      end_date: selectedFinancialYear == "date-range"
          ? convertDtToStr(selectedEndDate)
          : "",
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    portfolioTotalGain = data['portfolio_gain'] ?? 0;
    portfolioLongGain = data['portfolio_long_gain'] ?? 0;
    portfolioShortGain = data['portfolio_short_gain'] ?? 0;
    equityList = data['equity_summary_list'];

    if (equityList.isNotEmpty) {
      equityLongTermSoldAmt = data['eq_ltg_sold_amount'] ?? 0;
      equityShortTermSoldAmt = data['eq_stg_sold_amount'] ?? 0;
      equityLongTermPuchaseAmt = data['eq_ltg_purchase_amount'] ?? 0;
      equityShortTermPurchaseAmt = data['eq_stg_purchase_amount'] ?? 0;

      equityLongGainLoss = data['eq_ltg_gain'] ?? 0;
      equityShortGainLoss = data['eq_stg_gain'] ?? 0;
      equityShortLoss = data['eq_stg_loss'] ?? 0;
      equityLongLoss = data['eq_ltg_loss'] ?? 0;


      equityLongTermIndexAmt = data['eq_ltg_indexed_amount'] ?? 0;
    }


    debtList = data['debt_summary_list'];

    if (debtList.isNotEmpty) {
      debtLongTermSoldAmt = data['debt_ltg_sold_amount'] ?? 0;
      debtShortTermSoldAmt = data['debt_stg_sold_amount'] ?? 0;
      debtLongTermPuchaseAmt = data['debt_ltg_purchase_amount'] ?? 0;
      debtShortTermPurchaseAmt = data['debt_stg_purchase_amount'] ?? 0;

      debtLongGainLoss = data['debt_ltg_gain'] ?? 0;
      debtShortGainLoss = data['debt_stg_gain'] ?? 0;
      debtShortLoss = data['debt_stg_loss'] ?? 0;
      debtLongLoss = data['debt_ltg_loss'] ?? 0;
      debtLongTermIndexAmt = data['debt_ltg_indexed_amount'] ?? 0;
    }

    print("equityList ${equityList.length}");
    print("debtList ${debtList.length}");

    return 0;
  }

  formatDate(DateTime dt) {
    return DateFormat("dd-MM-yyyy").format(dt);
  }

  Future getDatas() async {
    isLoading = true;
    await getMfTaxReport();
    isLoading = false;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    selectedFinancialYear = financialYearList[0];
  }

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
              foregroundColor: Colors.white,
              elevation: 0,
              leading: SizedBox(),
              title: Row(
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
                      "Tax Report",
                      style: AppFonts.f50014Black
                          .copyWith(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                      icon: Icon(Icons.filter_alt_outlined),
                      onPressed: () {
                        showFinancialYearBottomSheet();
                      }),
                  IconButton(
                      icon: Icon(Icons.pending_outlined),
                      onPressed: () {
                        showReportActionBottomSheet();
                      }),
                ],
              ),
            ),
            body: SideBar(
              child: Column(
                children: [
                  topCard(),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: getButton("Equity"),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: getButton("Debt"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: getCardBasedOnButton(),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  List reportActions = [
    {
      'title': "Download PDF Report",
      'img': "assets/pdf.png",
      'type': ReportType.DOWNLOAD,
    },
    {
      'title': "Email Report",
      'img': "assets/email.png",
      'type': ReportType.EMAIL,
    }
  ];
  String startDate = '';
  String endDate = '';
  String option = '';

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
        itemCount: reportActions.length,
        separatorBuilder: (context, index) {
          return DottedLine(verticalPadding: 4);
        },
        itemBuilder: (context, index) {
          Map data = reportActions[index];

          String title = data['title'];
          String img = data['img'];
          String type = data['type'];

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () async {
                if (selectedFinancialYear == "date-range") {
                  startDate = formatDate(selectedStartDate);
                  endDate = formatDate(selectedEndDate);
                  option = 'range';
                } else {
                  startDate = '';
                  endDate = '';
                  option = 'fy';
                }

                EasyLoading.show();
                Map data = await ReportApi.downloadPortfolioTaxPdf(
                    user_id: userId,
                    client_name: clientName,
                    type: type,
                    startDate: startDate,
                    endDate: endDate,
                    option: option,
                    financial_year: selectedFinancialYear);
                if (data['status'] != 200) {
                  Utils.showError(context, data['msg']);
                  return;
                }
                EasyLoading.dismiss();
                Get.back();

                if (type == ReportType.DOWNLOAD) {
                  rpDownloadFile(url: data['msg'], index: index);
                } else {
                  EasyLoading.showToast("${data['msg']}");
                }
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
                subTitle: SizedBox(),
                leading: Image.asset(
                  img,
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

  showFinancialYearBottomSheet() {
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
                    BottomSheetTitle(title: "Select Financial Year"),
                    Divider(height: 0),
                    SizedBox(height: 8),
                    InkWell(
                        onTap: () {
                          selectedFinancialYear = "date-range";
                          bottomState(() {});
                        },
                        child: Row(
                          children: [
                            Radio(
                              value: "date-range",
                              groupValue: selectedFinancialYear,
                              onChanged: (val) {
                                selectedFinancialYear = "date-range";
                                bottomState(() {});
                              },
                            ),
                            Text("Date Range")
                          ],
                        )),
                    Visibility(
                        visible: selectedFinancialYear == "date-range",
                        child: startDateExpansionTile(context, bottomState)),
                    Visibility(
                        visible: selectedFinancialYear == "date-range",
                        child: endDateExpansionTile(context, bottomState)),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: financialYearList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        String year = financialYearList[index];

                        return InkWell(
                          onTap: () {
                            selectedFinancialYear = year;
                            portfolioTotalGain = 0;
                            equityList = [];
                            debtList = [];
                            bottomState(() {});
                            // Get.back();
                          },
                          child: Row(
                            children: [
                              Radio(
                                activeColor: Config.appTheme.themeColor,
                                groupValue: selectedFinancialYear,
                                value: financialYearList[index],
                                onChanged: (val) {
                                  selectedFinancialYear = year;
                                  portfolioTotalGain = 0;
                                  equityList = [];
                                  debtList = [];
                                  bottomState(() {});
                                  // Get.back();
                                  setState(() {});
                                },
                              ),
                              Expanded(
                                child: Text(year),
                              ),
                            ],
                          ),
                        );
                      },
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
              //),
            );
          });
        });
  }

  Widget getCardBasedOnButton() {
    if (isLoading)
      return Utils.shimmerWidget(devHeight, margin: EdgeInsets.all(16));

    if (selectedTitle == "Equity") {
      if (equityList == null || equityList.isEmpty) {
        return NoData();
      } else {
        return equityArea();
      }
    } else {
      if (debtList == null || debtList.isEmpty) {
        return NoData();
      } else {
        return debtArea();
      }
    }
  }

  Widget debtArea() {
    return Column(
      children: [
        debtBlackCard(),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: debtList.length,
          itemBuilder: (context, index) {
            Map data = debtList[index];
            return schemeCard(data);
          },
          separatorBuilder: (BuildContext context, int index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: DottedLine(),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: DottedLine(),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget equityArea() {
    return Column(
      children: [
        equityBlackCard(),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: equityList.length,
          itemBuilder: (context, index) {
            Map data = equityList[index];
            return schemeCard(data);
          },
          separatorBuilder: (BuildContext context, int index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: DottedLine(),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: DottedLine(),
        ),
        SizedBox(height: 120),
      ],
    );
  }

  Widget getButton(String title) {
    if (title == selectedTitle)
      return RpFilledButton(
        text: title,
        padding: EdgeInsets.zero,
      );
    else
      return PlainButton(
        text: title,
        padding: EdgeInsets.zero,
        onPressed: () {
          setState(() {
            selectedTitle = title;
          });
        },
      );
  }

  Widget topCard() {
    return Container(
      color: Config.appTheme.themeColor,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: (isLoading)
          ? Utils.shimmerWidget(200, margin: EdgeInsets.zero)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "For ${selectedFinancialYear == "date-range" ? "Date ${formatDate(selectedStartDate)} - ${formatDate(selectedEndDate)}" : "FY $selectedFinancialYear"}",
                  style: AppFonts.f40016.copyWith(color: Colors.white),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Config.appTheme.overlay85,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ColumnText(
                        title: "Total Gain/Loss",
                        value:
                            "$rupee ${Utils.formatNumber(portfolioTotalGain.round())}",
                        titleStyle: AppFonts.f40013,
                        valueStyle: AppFonts.f70024
                            .copyWith(color: Config.appTheme.themeColor),
                      ),
                      DottedLine(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ColumnText(
                            title: "STCG",
                            titleStyle: AppFonts.f40013,
                            value:
                                "$rupee ${Utils.formatNumber(portfolioShortGain.round())}",
                            valueStyle: AppFonts.f50014Black,
                          ),
                          ColumnText(
                            title: "LTCG",
                            titleStyle: AppFonts.f40013,
                            value:
                                "$rupee ${Utils.formatNumber(portfolioLongGain.round())}",
                            valueStyle: AppFonts.f50014Black,
                            alignment: CrossAxisAlignment.end,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget equityBlackCard() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('',
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
              ),
              Expanded(
                child: Text('Long Term',
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
              ),
              Expanded(
                child: Text('Short Term',
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text('Sell',
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(equityLongTermSoldAmt.round())}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(equityShortTermSoldAmt.round())}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Purchase',
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(equityLongTermPuchaseAmt.round())}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(equityShortTermPurchaseAmt.round())}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
            ],
          ),
          DottedLine(verticalPadding: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Gain',
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(equityLongGainLoss.round())}",
                    style:
                        AppFonts.f50012.copyWith(color: AppColors.textGreen)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(equityShortGainLoss.round())}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Loss',
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(equityLongLoss.round())}",
                    style:
                    AppFonts.f50012.copyWith(color: AppColors.textGreen)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(equityShortLoss.round())}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget debtBlackCard() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text('',
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
              ),
              Expanded(
                child: Text('Long Term',
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
              ),
              Expanded(
                child: Text('Short Term',
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Sell',
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(debtLongTermSoldAmt.round())}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(debtShortTermSoldAmt.round())}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Purchase',
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(debtLongTermPuchaseAmt.round())}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(debtShortTermPurchaseAmt.round())}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
            ],
          ),
          DottedLine(verticalPadding: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Gain',
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(debtLongGainLoss.round())}",
                    style:
                        AppFonts.f50012.copyWith(color: AppColors.textGreen)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(debtShortGainLoss.round())}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text('Loss',
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.lineColor)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(debtLongLoss.round())}",
                    style:
                    AppFonts.f50012.copyWith(color: AppColors.textGreen)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(debtShortLoss.round())}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget schemeCard(Map data) {
    String shortName = data['scheme_amfi_short_name'] ?? "";
    String folio = data['folio'] ?? "";

    num shortTermGain = data['stg_gain'] ?? 0;
    num longTermGain = data['ltg_gain'] ?? 0;
    num indexedGain = data['indexed_gain'] ?? 0;
    return InkWell(
      onTap: () {
        Get.to(() => TaxReportDetails(summary: data));
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(
                  data["amc_logo"],
                  height: 32,
                ),
                SizedBox(width: 10),
                Expanded(
                    child: ColumnText(
                  title: shortName,
                  value: "Folio : $folio",
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
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnText(
                  title: "STCG",
                  value: "$rupee ${Utils.formatNumber(shortTermGain.round())}",
                ),
                ColumnText(
                  title: "LTCG",
                  value: "$rupee ${Utils.formatNumber(longTermGain.round())}",
                  alignment: CrossAxisAlignment.center,
                ),
                ColumnText(
                  title: "Indexed",
                  value: "$rupee ${Utils.formatNumber(indexedGain.round())}",
                  alignment: CrossAxisAlignment.end,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // showFinancialYearBottomSheet() {
  //   showModalBottomSheet(
  //       backgroundColor: Colors.white,
  //       context: context,
  //       isScrollControlled: true,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(15),
  //           topRight: Radius.circular(15),
  //         ),
  //       ),
  //       builder: (context) {
  //         return StatefulBuilder(builder: (context, bottomState) {
  //           return Container(
  //             height: devHeight * 0.80,
  //             decoration: BoxDecoration(
  //               color: Config.appTheme.mainBgColor,
  //               borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(15),
  //                 topRight: Radius.circular(15),
  //               ),
  //             ),
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 children: [
  //                   BottomSheetTitle(title: "Select Financial Year"),
  //                   Divider(height: 0),
  //                   SizedBox(height: 8),
  //                   InkWell(
  //                       onTap: () {
  //                         selectedFinancialYear = "date-range";
  //                         bottomState(() {});
  //                       },
  //                       child: Row(
  //                         children: [
  //                           Radio(
  //                             value: "date-range",
  //                             groupValue: selectedFinancialYear,
  //                             onChanged: (val) {
  //                               selectedFinancialYear = "date-range";
  //                               bottomState(() {});
  //                             },
  //                           ),
  //                           Text("Date Range")
  //                         ],
  //                       )),
  //                   Visibility(
  //                       visible: selectedFinancialYear == "date-range",
  //                       child: startDateExpansionTile(context, bottomState)),
  //                   Visibility(
  //                       visible: selectedFinancialYear == "date-range",
  //                       child: endDateExpansionTile(context, bottomState)),
  //                   ListView.builder(
  //                     shrinkWrap: true,
  //                     itemCount: financialYearList.length,
  //                     scrollDirection: Axis.vertical,
  //                     itemBuilder: (context, index) {
  //                       String year = financialYearList[index];

  //                       return InkWell(
  //                         onTap: () {
  //                           selectedFinancialYear = year;
  //                           portfolioTotalGain = 0;
  //                           equityList = [];
  //                           debtList = [];
  //                           Get.back();
  //                           setState(() {});
  //                         },
  //                         child: Row(
  //                           children: [
  //                             Radio(
  //                               activeColor: Config.appTheme.themeColor,
  //                               groupValue: selectedFinancialYear,
  //                               value: financialYearList[index],
  //                               onChanged: (val) {
  //                                 selectedFinancialYear = year;
  //                                 portfolioTotalGain = 0;
  //                                 equityList = [];
  //                                 debtList = [];
  //                                 Get.back();
  //                                 setState(() {});
  //                               },
  //                             ),
  //                             Expanded(
  //                               child: Text(year),
  //                             ),
  //                           ],
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                   Container(
  //                     height: 75,
  //                     padding: EdgeInsets.all(16),
  //                     color: Colors.white,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         getCancelApplyButton(ButtonType.plain),
  //                         getCancelApplyButton(ButtonType.filled),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         });
  //       });
  // }

  Widget getCancelApplyButton(ButtonType type) {
    if (type == ButtonType.plain)
      return PlainButton(
        color: Config.appTheme.buttonColor,
        text: "RESET",
        onPressed: () {
          Get.back();
        },
      );
    else
      return RpFilledButton(
        color: Config.appTheme.buttonColor,
        text: "APPLY",
        onPressed: () {
          Get.back();
          portfolioTotalGain = 0;
          setState(() {});
        },
      );
  }

  Widget endDateExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
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

/*
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
                print("investorIddd $userId");
                if (userId != 0) {
                  if (index == 0) {
                    String url = "";
                    print("donwload $selectedFinancialYear");

                    if (selectedFinancialYear == "date-range") {
                      url =
                          "${ApiConfig.apiUrl}/investor/download/downloadPortfolioTaxPdf?key=${ApiConfig.apiKey}&user_id=$userId&client_name=$clientName&type=pdf&financial_year=&start_date=${formatDate(selectedStartDate)}"
                          "&end_date=${formatDate(selectedEndDate)}"
                          "&option=range"
                          "&content_option="
                          "";
                    } else {
                      url =
                          "${ApiConfig.apiUrl}/investor/download/downloadPortfolioTaxPdf?key=${ApiConfig.apiKey}&user_id=$userId&client_name=$clientName&type=pdf&financial_year=$selectedFinancialYear&start_date="
                          "&end_date="
                          "&option=fy"
                          "&content_option="
                          "";
                    }
                    http.Response response = await http.post(Uri.parse(url));
                    msgUrl = response.body;
                    Map data = jsonDecode(msgUrl);
                    String resUrl = data['msg'];
                    print("download $url");
                    rpDownloadFile(url: resUrl, context: context, index: index);
                    Get.back();
                  } /*else if (index == 1) {
                    //   String url =
                    //       "${ApiConfig.apiUrl}/admin/download/portfolioAnalysisReport?key=${ApiConfig.apiKey}&user_id=$investorId&client_name=$client_name&type=excel&start_date="
                    //       "&end_date="
                    //       "&option=$selectedBenchMarkType"
                    //       "";
                    //   http.Response response = await http.post(Uri.parse(url));
                    //   msgUrl = response.body;
                    //   Map data = jsonDecode(msgUrl);
                    //   String resUrl = data['msg'];
                    //   print("email $url");
                    //   rpDownloadFile(url: resUrl, context: context, index: index);
                    //   Get.back();
                  }*/
                  else {}
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

*/

  Widget startDateExpansionTile(BuildContext context, StateSetter bottomState) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
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
}
