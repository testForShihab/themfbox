import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/ReportApi.dart';
import 'package:mymfbox2_0/api/ResearchApi.dart';
import 'package:mymfbox2_0/rp_widgets/PercentageBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:mymfbox2_0/utils/appColors.dart';

class LtStHolding extends StatefulWidget {
  const LtStHolding({super.key});

  @override
  State<LtStHolding> createState() => _LtStHoldingState();
}

class _LtStHoldingState extends State<LtStHolding> {
  late double devWidth, devHeight;

  late num longTermAmt = 0,
      shortTermAmt = 0,
      longTermXirr = 0,
      shortTermXirr = 0,
      totalPortfolioAmt = 0,
      totalPortfolioXirr = 0,
      longGain = 0,
      shortGain = 0;
  num longAllocation = 0;
  num shortAllocation = 0;

  //int userId = getUserId();
  int userId = GetStorage().read('user_id');
  String clientName = GetStorage().read("client_name");

  List longShortTermHoldingsList = [];
  bool isLoading = true;
  List longschemeList = [];
  List shortschemeList = [];

  String btnNo = "1";

  Future getMfLongShortTermHoldings() async {
    if (longShortTermHoldingsList.isNotEmpty) return 0;

    Map data = await ResearchApi.getMfLongShortTermHoldings(
      user_id: userId,
      client_name: clientName,
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    longTermAmt = data['result']['long_curr_value'] ?? 0;
    shortTermAmt = data['result']['short_curr_value'] ?? 0;
    longTermXirr = data['result']['long_xirr'] ?? 0;
    shortTermXirr = data['result']['short_xirr'] ?? 0;
    totalPortfolioAmt = data['result']['portfolio_curr_value'] ?? 0;
    totalPortfolioXirr = data['result']['portfolio_xirr'] ?? 0;
    longGain = data['result']['long_gain'] ?? 0;
    shortGain = data['result']['short_gain'] ?? 0;
    longAllocation = data['result']['long_allocation'] ?? 0;
    shortAllocation = data['result']['short_allocation'] ?? 0;

    longschemeList = data['result']['long_scheme_list'] ?? 0;
    shortschemeList = data['result']['short_scheme_list'] ?? 0;
    return 0;
  }

  Future getDatas() async {
    isLoading = true;
    await getMfLongShortTermHoldings();
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
            appBar: AppBar(
              backgroundColor: Config.appTheme.themeColor,
              leadingWidth: 0,
              toolbarHeight: 50,
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
                          "Long/Short Term Holdings",
                          style: AppFonts.f50014Black
                              .copyWith(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                          icon: Icon(Icons.pending_outlined),
                          onPressed: () {
                            showReportActionBottomSheet();
                          }),
                    ],
                  ),
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
                            child: getButton("Long Term", "1"),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: getButton("Short Term", "2"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          btnNo == "1"
                              ? isLoading
                                  ? Utils.shimmerWidget(devHeight,
                                      margin: EdgeInsets.all(16))
                                  : longschemeList.isEmpty
                                      ? NoData()
                                      : longTermCard()
                              : isLoading
                                  ? Utils.shimmerWidget(devHeight,
                                      margin: EdgeInsets.all(20))
                                  : shortschemeList.isEmpty
                                      ? NoData()
                                      : shortTermCard()
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

  Widget shortTermCard() {
    return Column(
      children: [
        shortblackCard(),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: shortschemeList.length,
          itemBuilder: (context, index) {
            Map data = shortschemeList[index];
            return InkWell(
              onTap: () {
                shortSchemeBottomSheet(data);
              },
              child: shortSchemeCard(data),
            );
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
        SizedBox(height: 20),
      ],
    );
  }

  Widget longTermCard() {
    return Column(
      children: [
        longBlackCard(),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: longschemeList.length,
          itemBuilder: (context, index) {
            Map data = longschemeList[index];
            return InkWell(
              onTap: () {
                longSchemeBottomSheet(data);
              },
              child: longSchemeCard(data),
            );
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
        SizedBox(height: 20),
      ],
    );
  }

  Widget getButton(String flow, String selectedBtnNo) {
    print("flow $flow");
    String tempFlow = flow;

    if (btnNo == selectedBtnNo)
      return RpFilledButton(
        text: tempFlow,
        padding: EdgeInsets.zero,
      );
    else
      return PlainButton(
        text: tempFlow,
        padding: EdgeInsets.zero,
        onPressed: () {
          setState(() {
            btnNo = selectedBtnNo;
            print("btnNo $btnNo");
          });
        },
      );
  }

  Widget topCard() {
    return Container(
      color: Config.appTheme.themeColor,
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: (isLoading)
          ? Utils.shimmerWidget(200, margin: EdgeInsets.zero)
          : Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Config.appTheme.overlay85,
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  percentTile(
                      title: "Long Term Holdings",
                      amount: longTermAmt,
                      subTitle: PercentageBar(
                        longTermXirr.toDouble().clamp(0.0, 100.0),
                        width: devWidth * 0.5,
                      ),
                      xirrPercentage: longTermXirr,
                      allocation: longAllocation),
                  SizedBox(height: 5),
                  percentTile(
                      title: "Short Term Holdings",
                      amount: shortTermAmt,
                      subTitle: PercentageBar(
                          shortTermXirr.toDouble().clamp(0.0, 100.0),
                          width: devWidth * 0.5),
                      xirrPercentage: shortTermXirr,
                      allocation: shortAllocation),
                  DottedLine(),
                  percentTile(
                    title: "Total Portfolio",
                    amount: totalPortfolioAmt,
                    subTitle: SizedBox(),
                    xirrPercentage: totalPortfolioXirr,
                    titleSize: 18,
                  )
                ],
              ),
            ),
    );
  }

  Widget longBlackCard() {
    String gainLossValue = longGain.toStringAsFixed(0);
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("${longschemeList.length} Schemes",
                  style: AppFonts.f50014Grey.copyWith(color: Colors.white)),
              Spacer(),
              RichText(
                text: TextSpan(
                  text: "XIRR : ",
                  style: AppFonts.f40013.copyWith(color: AppColors.lineColor),
                  children: [
                    TextSpan(
                        text: "$longTermXirr%",
                        style: AppFonts.f40013.copyWith(
                          color: AppColors.textGreen,
                        ))
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Current Value",
                value:
                    "$rupee ${Utils.formatNumber(longTermAmt.round(), isAmount: false)}",
                titleStyle: AppFonts.f40013.copyWith(
                  color: AppColors.lineColor,
                ),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title: "Unrealised Gain",
                value:
                    "$rupee ${Utils.formatNumber(double.parse(gainLossValue), isAmount: false)}",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.lineColor),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget shortblackCard() {
    String gainLossValue = shortGain.toStringAsFixed(0);
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("${shortschemeList.length} Schemes",
                  style: AppFonts.f50014Grey.copyWith(color: Colors.white)),
              Spacer(),
              RichText(
                text: TextSpan(
                  text: "XIRR : ",
                  style: AppFonts.f40013.copyWith(color: AppColors.lineColor),
                  children: [
                    TextSpan(
                        text: "$shortTermXirr%",
                        style: AppFonts.f40013.copyWith(
                          color: AppColors.textGreen,
                        ))
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Current Value",
                value:
                    "$rupee ${Utils.formatNumber(shortTermAmt, isAmount: false)}",
                titleStyle: AppFonts.f40013.copyWith(
                  color: AppColors.lineColor,
                ),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title: "Unrealised Gain",
                value:
                    "$rupee ${Utils.formatNumber(double.parse(gainLossValue), isAmount: false)}",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.lineColor),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget percentTile({
    required Widget subTitle,
    double? titleSize,
    required String title,
    required num amount,
    required num xirrPercentage,
    num? allocation,
  }) {
    String amountStr = Utils.formatNumber(amount);
    String xirrStr = xirrPercentage.toStringAsFixed(2);
    String? allocationStr =
        (allocation != null) ? allocation.toStringAsFixed(2) : null;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppFonts.f50014Black.copyWith(fontSize: titleSize),
              ),
              Text(
                "$rupee $amountStr",
                style: AppFonts.f50014Black.copyWith(
                    color: Config.appTheme.themeColor, fontSize: titleSize),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              subTitle,
              RichText(
                text: TextSpan(
                  text: "(XIRR : ",
                  style: AppFonts.f40013,
                  children: [
                    TextSpan(
                      text: "$xirrStr%)",
                      style: AppFonts.f40013.copyWith(
                          color: (double.parse(xirrStr) >= 0)
                              ? Config.appTheme.defaultProfit
                              : Config.appTheme.defaultLoss),
                    )
                  ],
                ),
              ),
            ],
          ),
          if (allocation != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Allocation : ",
                    style: AppFonts.f40013,
                    children: [
                      TextSpan(
                        text: "${allocationStr}%",
                        style: AppFonts.f40013,
                      )
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget longSchemeCard(Map data) {
    double value = data['totalCurrentValue'];
    String roundedCurrentValue = value.toStringAsFixed(0);
    return Container(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(data["amc_logo"] ?? "", height: 32),
              SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: devWidth * 0.6,
                    child: Text(
                      data["scheme_amfi_short_name"] ?? "",
                      style: AppFonts.f50014Black,
                    ),
                  ),
                  SizedBox(
                    width: devWidth * 0.5,
                    child: Text(
                      "Folio: ${data['foliono']}",
                      style: AppFonts.f40013.copyWith(color: Colors.black),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios,
                  size: 18, color: AppColors.arrowGrey)
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Current Value",
                  value:
                      "$rupee ${Utils.formatNumber(double.parse(roundedCurrentValue), isAmount: false)}"),
              ColumnText(
                title: "Units",
                value: Utils.formatNumber(data['totalUnits'] ?? 0),
                alignment: CrossAxisAlignment.center,
              ),
              ColumnText(
                title: "XIRR",
                value: "${data['cagr'] ?? 0}%",
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: (data['cagr'] > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
                alignment: CrossAxisAlignment.end,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget shortSchemeCard(Map data) {
    double value = data['totalCurrentValue'];
    String roundedCurrentValue = value.toStringAsFixed(0);
    return Container(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(data["amc_logo"] ?? "", height: 32),
              SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: devWidth * 0.5,
                    child: Text(
                      data["scheme_amfi_short_name"] ?? "",
                      style: AppFonts.f50014Black,
                    ),
                  ),
                  SizedBox(
                    width: devWidth * 0.5,
                    child: Text(
                      "Folio: ${data['foliono'] ?? ""}",
                      style: AppFonts.f40013.copyWith(color: Colors.black),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios,
                  size: 18, color: AppColors.arrowGrey)
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Current Value",
                  value:
                      "$rupee ${Utils.formatNumber(double.parse(roundedCurrentValue), isAmount: false)}"),
              ColumnText(
                title: "Units",
                value: Utils.formatNumber(data['totalUnits'] ?? 0),
                alignment: CrossAxisAlignment.center,
              ),
              ColumnText(
                title: "XIRR",
                value: "${data['cagr'] ?? 0}%",
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: (data['cagr'] > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
                alignment: CrossAxisAlignment.end,
              ),
            ],
          )
        ],
      ),
    );
  }

  longSchemeBottomSheet(Map data) {
    String dateString = data['investmentStartDate_str'];

    String latestNavDate = data['latestNav_str'];

    double value = data['totalCurrentValue'] ?? 0;
    String roundedCurrentValue = value.toStringAsFixed(0);

    double currentCost = data['currentCostOfInvestment'] ?? 0;
    String roundedCurrentCost = currentCost.toStringAsFixed(0);

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
        return StatefulBuilder(
          builder: (context, bottomState) {
            return Container(
              height: devHeight * 0.60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  BottomSheetTitle(title: "Long Term Holdings"),
                  Divider(height: 0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(data["amc_logo"] ?? "", height: 32),
                            SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: devWidth * 0.8,
                                  child: Text(
                                    data["scheme"] ?? "",
                                    style: AppFonts.f50014Black,
                                  ),
                                ),
                                SizedBox(
                                  width: devWidth * 0.5,
                                  child: Text(
                                    "Folio: ${data['foliono']}",
                                    style: AppFonts.f40013
                                        .copyWith(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Current Value: ",
                              style: AppFonts.f40013,
                            ),
                            Text(
                              "$rupee ${Utils.formatNumber(double.parse(roundedCurrentValue), isAmount: false)}",
                              style: AppFonts.f50014Black,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 180,
                                child: ColumnText(
                                    title: "Current Cost",
                                    value:
                                        "$rupee ${Utils.formatNumber(double.parse(roundedCurrentCost), isAmount: false)}")),
                            ColumnText(
                              title: "Gain/Loss",
                              value:
                                  "$rupee ${Utils.formatNumber(data['total_gain_loss'] ?? 0, isAmount: false)}",
                              alignment: CrossAxisAlignment.start,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 180,
                                child: ColumnText(
                                    title: "Absolute Return",
                                    value: "${data['absolute_return']}%",
                                    valueStyle: AppFonts.f50014Black.copyWith(
                                        color: data['absolute_return'] > 0
                                            ? Config.appTheme.defaultProfit
                                            : Config.appTheme.defaultLoss))),
                            ColumnText(
                                title: "XIRR",
                                value: "${data['cagr'] ?? 0}%",
                                alignment: CrossAxisAlignment.start,
                                valueStyle: AppFonts.f50014Black.copyWith(
                                    color: data['cagr'] > 0
                                        ? Config.appTheme.defaultProfit
                                        : Config.appTheme.defaultLoss)),
                          ],
                        ),
                        DottedLine(
                          verticalPadding: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 180,
                                child: ColumnText(
                                    title: "Units",
                                    value: "${data['totalUnits'] ?? 0}")),
                            ColumnText(
                              title: "Start Date",
                              value: dateString,
                              alignment: CrossAxisAlignment.start,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 180,
                                child: ColumnText(
                                    title: "Avg NAV",
                                    value: "${data['purchaseNav'] ?? 0}")),
                            ColumnText(
                              title: "Avg Days",
                              value: "${data['average_days'] ?? 0}",
                              alignment: CrossAxisAlignment.start,
                            ),
                          ],
                        ),
                        DottedLine(
                          verticalPadding: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 180,
                                child: ColumnText(
                                    title: "Latest NAV",
                                    value: "${data['latestNav'] ?? 0}")),
                            ColumnText(
                              title: "NAV Date",
                              value: latestNavDate,
                              alignment: CrossAxisAlignment.start,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            );
          },
        );
      },
    );
  }

  shortSchemeBottomSheet(Map data) {
    String dateString = data['investmentStartDate_str'];

    String latestNavDate = data['latestNav_str'];

    double value = data['totalCurrentValue'] ?? 0;
    String roundedCurrentValue = value.toStringAsFixed(0);

    double currentCost = data['currentCostOfInvestment'] ?? 0;
    String roundedCurrentCost = currentCost.toStringAsFixed(0);

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
        return StatefulBuilder(
          builder: (context, bottomState) {
            return Container(
              height: devHeight * 0.60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  BottomSheetTitle(title: "Short Term Holdings"),
                  Divider(height: 0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(data["amc_logo"] ?? "", height: 32),
                            SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: devWidth * 0.8,
                                  child: Text(
                                    data["scheme"] ?? "",
                                    style: AppFonts.f50014Black,
                                  ),
                                ),
                                SizedBox(
                                  width: devWidth * 0.5,
                                  child: Text(
                                    "Folio: ${data['foliono']}",
                                    style: AppFonts.f40013
                                        .copyWith(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Current Value: ",
                              style: AppFonts.f40013,
                            ),
                            Text(
                              "$rupee ${Utils.formatNumber(double.parse(roundedCurrentValue), isAmount: false)}",
                              style: AppFonts.f50014Black,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 180,
                                child: ColumnText(
                                    title: "Current Cost",
                                    value:
                                        "$rupee ${Utils.formatNumber(double.parse(roundedCurrentCost), isAmount: false)}")),
                            ColumnText(
                              title: "Gain/Loss",
                              value:
                                  "$rupee ${Utils.formatNumber(data['total_gain_loss'] ?? 0, isAmount: false)}",
                              alignment: CrossAxisAlignment.start,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 180,
                                child: ColumnText(
                                    title: "Absolute Return",
                                    value: "${data['absolute_return']}%",
                                    valueStyle: AppFonts.f50014Black.copyWith(
                                        color: data['absolute_return'] > 0
                                            ? Config.appTheme.defaultProfit
                                            : Config.appTheme.defaultLoss))),
                            ColumnText(
                                title: "XIRR",
                                value: "${data['cagr'] ?? 0}%",
                                alignment: CrossAxisAlignment.start,
                                valueStyle: AppFonts.f50014Black.copyWith(
                                    color: data['cagr'] > 0
                                        ? Config.appTheme.defaultProfit
                                        : Config.appTheme.defaultLoss)),
                          ],
                        ),
                        DottedLine(
                          verticalPadding: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 180,
                                child: ColumnText(
                                    title: "Units",
                                    value: "${data['totalUnits'] ?? 0}")),
                            ColumnText(
                              title: "Start Date",
                              value: dateString,
                              alignment: CrossAxisAlignment.start,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 180,
                                child: ColumnText(
                                    title: "Avg NAV",
                                    value: "${data['purchaseNav'] ?? 0}")),
                            ColumnText(
                              title: "Avg Days",
                              value: "${data['average_days'] ?? 0}",
                              alignment: CrossAxisAlignment.start,
                            ),
                          ],
                        ),
                        DottedLine(
                          verticalPadding: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 180,
                                child: ColumnText(
                                    title: "Latest NAV",
                                    value: "${data['latestNav'] ?? 0}")),
                            ColumnText(
                              title: "NAV Date",
                              value: latestNavDate,
                              alignment: CrossAxisAlignment.start,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            );
          },
        );
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
                    String url =
                        "${ApiConfig.apiUrl}/investor/download/downloadLongShortTermHoldingsPdf?key=${ApiConfig.apiKey}&user_id=$userId&client_name=$clientName";

                    http.Response response = await http.post(Uri.parse(url));
                    msgUrl = response.body;
                    Map data = jsonDecode(msgUrl);
                    String resUrl = data['msg'];
                    print("download $url");
                    rpDownloadFile(url: resUrl, context: context, index: index);
                    Get.back();
                  } else {}
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

  List reportActions = [
    {
      'title': "Download PDF Report",
      'img': "assets/pdf.png",
      'type': ReportType.DOWNLOAD,
    },
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
                Map data = await ReportApi.downloadLongShortTermHoldingsPdf(
                    user_id: userId, client_name: clientName);
                if (data['status'] != 200) {
                  Utils.showError(context, data['msg']);
                  return;
                }
                EasyLoading.dismiss();
                Get.back();
                rpDownloadFile(url: data['msg'], index: index);
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
}
