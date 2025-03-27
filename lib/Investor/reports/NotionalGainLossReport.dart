import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/Investor/reports/NotionalGainLossDetails.dart';
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

class NotionalGainLossReport extends StatefulWidget {
  const NotionalGainLossReport({super.key});

  @override
  State<NotionalGainLossReport> createState() => _NotionalGainLossReportState();
}

class _NotionalGainLossReportState extends State<NotionalGainLossReport> {
  late double devWidth, devHeight;

  int userId = GetStorage().read("user_id");
  String clientName = GetStorage().read("client_name");
  bool isLoading = true;
  List financialYearList = [], equityList = [], debtSummary = [], debtList = [];
  List equitySummary = [];

  bool isDateRange = false;
  String? selectedOption;
  ExpansionTileController reportTypeController = ExpansionTileController();
  ExpansionTileController folioTypeController = ExpansionTileController();
  ExpansionTileController fundController = ExpansionTileController();
  TextEditingController redemptionAmountController = TextEditingController();

  final String initialValue = "";
  Map<int, String> textFieldValues = {};
  Map<String, TextEditingController> controllers = {};

  List folioSchemeList = [];
  bool isScheme = false;

  String selectedReportType = "Simple";
  String selectedTitle = "Equity";
  Map reportMap = {
    "Notional Gain/Loss - Simple": "Simple",
    "Notional Gain/Loss - Taxation": "Taxation",
  };
  String selectedFolioType = "Live";
  Map folioType = {
    "All": "Live",
    "MF Without other ARN": "MF Without other ARN",
    "MF bought from others": "MF bought from others",
  };
  String selectedFund = "All";
  Map fundType = {
    "All Funds": "All",
    "Selected Funds": "Selected",
  };
  Map reportActionData = {
    "Download PDF Report ": ["", "", "assets/pdf.png"],
    "Email Report": ["", null, "assets/email.png"],
    /*"Download Excel Report": ["", "", "assets/excel.png"],*/
  };
  int selectedRadio = 0;

  num portfolioTotalGain = 0;
  num portfolioLongGain = 0;
  num portfolioShortGain = 0;
  Map<String, bool> isCheckedMap = {};
  List<String> checkedAmfiCode = [];
  List<String> redemptionAmounts = [];
  num equityLongTermSoldAmt = 0,
      equityShortTermSoldAmt = 0,
      equityLongTermPuchaseAmt = 0,
      equityShortTermPurchaseAmt = 0,
      equityLongGainLoss = 0,
      equityShortGainLoss = 0;
  num debtLongTermSoldAmt = 0,
      debtShortTermSoldAmt = 0,
      debtLongTermPuchaseAmt = 0,
      debtShortTermPurchaseAmt = 0,
      debtLongGainLoss = 0,
      debtShortGainLoss = 0;

  @override
  void initState() {
    super.initState();
    folioSchemeList.forEach((data) {
      String schemeAmfiShortName = data['scheme_amfi_short_name'];
      controllers[schemeAmfiShortName] = TextEditingController();
    });
  }

  @override
  void dispose() {
    controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void clearTextFields() {
    for (var controller in controllers.values) {
      controller.clear();
    }
  }

  String getFirst13(String text) {
    String s = text.split(":").last;
    if (s.length > 13) s = s.substring(0, 13);
    return s;
  }

  String selectedFinancialYear = "";

  Future getFolioSchemeDetails() async {
    if (folioSchemeList.isNotEmpty) return 0;

    Map data = await ReportApi.getFolioSchemeDetails(
        user_id: userId,
        client_name: clientName,
        folio_type: selectedFolioType);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    folioSchemeList = data['folioSchemeDetailsList'];
    return 0;
  }

  Future getMfNotionalGainLossReport() async {
    if (portfolioTotalGain != 0) return 0;

    List<String> redemptionAmt = textFieldValues.values.toList();
    redemptionAmounts.removeWhere((amount) => amount.isEmpty);
    Map data = await ReportApi.getMfNotionalGainLossReport(
      user_id: userId,
      client_name: clientName,
      report_type: selectedReportType,
      folio_type: selectedFolioType,
      folio_scheme_code_array: checkedAmfiCode.join(","),
      red_amt_array: redemptionAmt.join(","),
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
    }

    debtList = data['debt_summary_list'];

    if (debtList.isNotEmpty) {
      debtLongTermSoldAmt = data['debt_ltg_sold_amount'] ?? 0;
      debtShortTermSoldAmt = data['debt_stg_sold_amount'] ?? 0;
      debtLongTermPuchaseAmt = data['debt_ltg_purchase_amount'] ?? 0;
      debtShortTermPurchaseAmt = data['debt_stg_purchase_amount'] ?? 0;
      debtLongGainLoss = data['debt_ltg_gain'] ?? 0;
      debtShortGainLoss = data['debt_stg_gain'] ?? 0;
    }
    return 0;
  }

  formatDate(DateTime dt) {
    return DateFormat("dd-MM-yyyy").format(dt);
  }

  Future getDatas() async {
    isLoading = true;
    await getMfNotionalGainLossReport();
    isLoading = false;
    await getFolioSchemeDetails();
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return SideBar(
            child: Scaffold(
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
                            "Notional Gain/Loss Report",
                            style: AppFonts.f50014Black
                                .copyWith(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                            icon: Icon(Icons.filter_alt_outlined),
                            onPressed: () {
                              print("pressed");
                              showFilterBottomSheet();
                              isCheckedMap.forEach((key, _) {
                                isCheckedMap[key] = false;
                              });
                              checkedAmfiCode.clear();
                              textFieldValues.clear();
                              clearTextFields();
                            }),
                        GestureDetector(
                            onTap: () {
                              showReportActionBottomSheet();
                            },
                            child: Icon(Icons.pending_outlined))
                      ],
                    ),
                  ],
                ),
              ),
              body: Column(
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
                    child: reportActionContainer(),
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
  Widget reportActionContainers() {
    InvestorDetails investorDetails =
        InvestorDetails(userId: userId, email: '');
    List<InvestorDetails> investorDetailsList = [];
    investorDetailsList.add(investorDetails);

    String investor_details = jsonEncode(investorDetailsList);
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
                      "${ApiConfig.apiUrl}/investor/download/downloadNotionalReportPdf?key=${ApiConfig.apiKey}&client_name=$clientName&userid=$userId&report_type=$selectedReportType&folio_type=$selectedFolioType&folio_scheme_code_array="
                      "&red_amt_array=&type=pdf";

                  http.Response response = await http.post(Uri.parse(url));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  String resUrl = data['msg'];
                  print("download $url");
                  rpDownloadFile(url: resUrl, context: context, index: index);
                  Get.back();
                } else if (index == 1) {
                  String url =
                      "${ApiConfig.apiUrl}/investor/download/downloadNotionalReportPdf?key=${ApiConfig.apiKey}&client_name=$clientName&userid=$userId&report_type=$selectedReportType&folio_type=$selectedFolioType&folio_scheme_code_array="
                      "&red_amt_array=&type=email";

                  http.Response response = await http.post(Uri.parse(url));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  String resUrl = data['msg'];
                  print("email $url");
                  rpDownloadFile(url: resUrl, context: context, index: index);
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
*/
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
                EasyLoading.show();
                Map data = await ReportApi.downloadNotionalReportPdf(
                    user_id: userId,
                    client_name: clientName,
                    type: type,
                    selectedReportType: selectedReportType,
                    selectedFolioType: selectedFolioType);
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

  Widget getCardBasedOnButton() {
    if (isLoading)
      return Utils.shimmerWidget(devHeight, margin: EdgeInsets.all(16));

    if (selectedTitle == "Equity") {
      if (equityList.isEmpty) {
        return NoData();
      } else {
        return equityArea();
      }
    } else {
      if (debtList.isEmpty) {
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
                SizedBox(height: 16),
                Text(
                  "$selectedReportType Report",
                  style: AppFonts.f40016
                      .copyWith(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Config.appTheme.overlay85,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ColumnText(
                        title: "Total Notional Gain/Loss",
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
                            title: "Short Term G/L",
                            titleStyle: AppFonts.f40013,
                            value:
                                "$rupee ${Utils.formatNumber(portfolioShortGain.round())}",
                            valueStyle: AppFonts.f50014Black,
                          ),
                          ColumnText(
                            title: "Long Term G/L",
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
                SizedBox(height: 8),
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
                child: Text('Gain/Loss',
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
                    style:
                        AppFonts.f40013.copyWith(color: AppColors.lineColor)),
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
                child: Text('Gain/Loss',
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
        ],
      ),
    );
  }

  Widget schemeCard(Map data) {
    String shortName = data['scheme_amfi_short_name'] ?? "";
    String folio = data['folio_no'] ?? "";
    num totalGain = data['total_gain'] ?? 0;
    num shortTermGain = data['short_term_gain'] ?? 0;
    num longTermGain = data['long_term_gain'] ?? 0;
    num currValue = data['current_value'] ?? 0;
    return InkWell(
      onTap: () {
        Get.to(() => NotionalGainLossDetails(
              summary: data,
              reportType: selectedReportType,
            ));
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
                Image.network(
                  data["amc_logo"],
                  height: 32,
                ),
                SizedBox(width: 10),
                Expanded(
                    child: ColumnText(
                  title: shortName,
                  value: "Folios : $folio",
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
                  title: "Total G/L",
                  value: "$rupee ${Utils.formatNumber(totalGain.round())}",
                ),
                ColumnText(
                  title: "STCG",
                  value: "$rupee ${Utils.formatNumber(shortTermGain.round())}",
                  alignment: CrossAxisAlignment.center,
                ),
                ColumnText(
                  title: "LTCG",
                  value: "$rupee ${Utils.formatNumber(longTermGain.round())}",
                  valueStyle: AppFonts.f50014Black.copyWith(
                      color: (longTermGain >= 0)
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

  showFilterBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, bottomState) {
            return Container(
              height: devHeight * 0.80,
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
                    BottomSheetTitle(title: "Filter"),
                    Divider(height: 0),
                    SizedBox(height: 8),
                    //to select report type
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          controller: reportTypeController,
                          onExpansionChanged: (val) {},
                          title:
                              Text("Report Type", style: AppFonts.f50014Black),
                          tilePadding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${getKeyByValue(reportMap, selectedReportType)}",
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
                              itemCount: reportMap.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    selectedReportType =
                                        reportMap.values.elementAt(index);
                                    bottomState(() {});
                                  },
                                  child: Row(
                                    children: [
                                      Radio(
                                        value:
                                            reportMap.values.elementAt(index),
                                        groupValue: selectedReportType,
                                        onChanged: (value) {
                                          selectedReportType =
                                              reportMap.values.elementAt(index);
                                          bottomState(() {});
                                        },
                                      ),
                                      Text(
                                          "${reportMap.keys.elementAt(index)}"),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          controller: folioTypeController,
                          onExpansionChanged: (val) {},
                          title:
                              Text("Folio Type", style: AppFonts.f50014Black),
                          tilePadding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${getKeyByValue(folioType, selectedFolioType)}",
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
                              itemCount: folioType.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () async {
                                    selectedFolioType =
                                        folioType.values.elementAt(index);
                                    bottomState(() {});
                                  },
                                  child: Row(
                                    children: [
                                      Radio(
                                        value:
                                            folioType.values.elementAt(index),
                                        groupValue: selectedFolioType,
                                        onChanged: (value) async {
                                          selectedFolioType =
                                              folioType.values.elementAt(index);
                                          folioSchemeList = [];
                                          await getFolioSchemeDetails();
                                          bottomState(() {});
                                        },
                                      ),
                                      Text(
                                          "${folioType.keys.elementAt(index)}"),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          controller: fundController,
                          onExpansionChanged: (val) {},
                          title:
                              Text("Select Funds", style: AppFonts.f50014Black),
                          tilePadding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${getKeyByValue(fundType, selectedFund)}",
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
                              itemCount: fundType.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    selectedFund =
                                        fundType.values.elementAt(index);
                                    if (selectedFund == "Selected") {
                                      isScheme = true;
                                      folioSchemeExpansionTile(context);
                                    }
                                    bottomState(() {});
                                  },
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: fundType.values.elementAt(index),
                                        groupValue: selectedFund,
                                        onChanged: (value) {
                                          selectedFund =
                                              fundType.values.elementAt(index);
                                          if (selectedFund == "Selected") {
                                            isScheme = true;
                                            folioSchemeExpansionTile(context);
                                          }
                                          bottomState(() {});
                                        },
                                      ),
                                      Text("${fundType.keys.elementAt(index)}"),
                                    ],
                                  ),
                                );
                              },
                            ),
                            selectedFund == "Selected"
                                ? folioSchemeExpansionTile(context)
                                : SizedBox(),
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

  String searchKey = "";
  Timer? searchOnStop;

  searchHandler(String search) {
    searchKey = search;
    const duration = Duration(milliseconds: 1000);
    if (searchOnStop != null) {
      searchOnStop!.cancel();
    }
    searchOnStop = Timer(duration, () async {
      EasyLoading.show(status: "searching for `$searchKey`");
      await getFolioSchemeDetails();
      EasyLoading.dismiss();

      setState(() {});
    });
  }

  Widget folioSchemeExpansionTile(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.42,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            folioSchemeList.isEmpty
                ? NoData()
                : Visibility(
                    visible: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NotificationListener<ScrollNotification>(
                          onNotification: (scrollNotification) {
                            return false;
                          },
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: folioSchemeList.length,
                            itemBuilder: (context, index) {
                              Map data = folioSchemeList[index];
                              String schemeAmfiShortName =
                                  data['scheme_amfi_short_name'] ?? "";
                              String schemeAmfiCode =
                                  data['scheme_amfi_code'] ?? "";
                              String folioNo = data['folio_no'] ?? "";
                              String amcLogo = data['amc_logo'] ?? "";
                              String schemeCode = data['scheme_code'] ?? "";
                              num current_value = data['current_value'] ?? "";

                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter bottomState) {
                                          return Checkbox(
                                            value: isCheckedMap[
                                                    schemeAmfiShortName] ??
                                                false,
                                            onChanged: (newValue) {
                                              bottomState(() {
                                                isCheckedMap[
                                                        schemeAmfiShortName] =
                                                    newValue ?? false;

                                                if (newValue == true) {
                                                  checkedAmfiCode.add(
                                                      folioNo + schemeCode);
                                                } else {
                                                  checkedAmfiCode.remove(
                                                      folioNo + schemeCode);
                                                }
                                              });
                                            },
                                          );
                                        },
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 16, 16),
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color:
                                                    Config.appTheme.lineColor,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  /*  Image.network(amcLogo,
                                                      height: 32),
                                                  SizedBox(width: 6),*/
                                                  Expanded(
                                                    child: ColumnText(
                                                      title:
                                                          schemeAmfiShortName,
                                                      value: "Folio : $folioNo",
                                                      titleStyle:
                                                          AppFonts.f50014Black,
                                                      valueStyle:
                                                          AppFonts.f40013,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.06,
                                                margin: EdgeInsets.only(top: 4),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Config
                                                          .appTheme.lineColor,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: StatefulBuilder(
                                                  builder:
                                                      (context, bottomState) {
                                                    return TextFormField(
                                                      cursorColor: Config
                                                          .appTheme.themeColor,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        fillColor: Colors.white,
                                                        hintText:
                                                            'Enter Redemption Amount',
                                                        hintStyle: TextStyle(
                                                            color: Colors.grey),
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        13,
                                                                    horizontal:
                                                                        8),
                                                      ),
                                                      style: TextStyle(
                                                          color: Config.appTheme
                                                              .themeColor),
                                                      controller: controllers[
                                                          schemeAmfiShortName],
                                                      onChanged: (text) {
                                                        bottomState(() {
                                                          textFieldValues[
                                                              index] = text;
                                                        });
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "(Market Value: $rupee ${Utils.formatNumber(current_value)})",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
    );
  }

  getKeyByValue(Map map, String value) {
    return map.keys.firstWhere((element) => map[element] == value);
  }

  Widget getCancelApplyButton(ButtonType type) {
    if (type == ButtonType.plain)
      return PlainButton(
        padding: EdgeInsets.symmetric(horizontal: devWidth * 0.10, vertical: 2),
        text: "CLEAR ALL",
        onPressed: () {},
      );
    else
      return RpFilledButton(
        text: "APPLY",
        onPressed: () {
          if (selectedFund == "Selected") {
            if (checkedAmfiCode.isEmpty) {
              Utils.showError(context, "Please Select the Fund");
              return;
            }
          }
          print("textFieldValues $textFieldValues");
          Get.back();
          portfolioTotalGain = 0;
          setState(() {});
        },
      );
  }
}
