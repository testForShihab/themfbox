import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/Controllers/GainLossReportController/gain_loss_report_state.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import '../../Controllers/GainLossReportController/gain_loss_report_controller.dart';
import '../../pojo/gain_loss_report_response.dart';
import '../../rp_widgets/BottomSheetTitle.dart';
import '../../rp_widgets/ColumnText.dart';
import '../../rp_widgets/DottedLine.dart';
import '../../rp_widgets/PlainButton.dart';
import '../../rp_widgets/RpListTile.dart';
import '../../utils/AppColors.dart';
import '../../utils/AppFonts.dart';
import '../../utils/Config.dart';
import '../../utils/Constants.dart';
import '../../utils/Utils.dart';

class InvestorGainLossReportPage extends StatefulWidget {
  const InvestorGainLossReportPage({super.key});

  @override
  State<InvestorGainLossReportPage> createState() =>
      _InvestorGainLossReportPageState();
}

class _InvestorGainLossReportPageState
    extends State<InvestorGainLossReportPage> {
  final GainLossController controller = Get.put(GainLossController());

  @override
  void initState() {
    super.initState();
    controller.fetchGainLossData().then((value) {
      controller.getFinancialYears().then((value) {
        switch (controller.state) {
          case GainLossLoadedState(
              financialYears: final fyList,
            ):
            controller.selectFinancialYear(fyList?[0] ?? '');
          case GainLossInitialState():
          case GainLossLoadingState():
          case GainLossErrorState():
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: AppBar(
        backgroundColor: Config.appTheme.themeColor,
        leadingWidth: 0,
        toolbarHeight: 60,
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
                    "Gain/Loss Report",
                    style: AppFonts.f50014Black
                        .copyWith(fontSize: 18, color: Colors.white),
                  ),
                ),
                Spacer(),
                IconButton(
                    icon: Icon(Icons.filter_alt_outlined),
                    onPressed: () {
                      showFinancialYearBottomSheet(
                        context,
                        controller,
                      );
                    }),
                GestureDetector(
                    onTap: () {
                      showDownloadModal(context, controller);
                    },
                    child: Icon(Icons.pending_outlined))
              ],
            ),
          ],
        ),
      ),
      body: Obx(() {
        final state = controller.state;
        return switch (state) {
          GainLossLoadingState() => Column(
              children: [
                SizedBox(height: 20),
                Utils.shimmerWidget(200),
                SizedBox(height: 20),
                Utils.shimmerWidget(200),
              ],
            ),
          GainLossLoadedState(
            result: final gainLossDetails,
            selectedFinancialYear: final selectedFY,
            startDate: final selectedStartDate,
            endDate: final selectedEndDate,
            isDebtSelected: final isDebtSelected,
            isDownloadingPdf: final isDownloadingPdf,
          ) =>
            gainLossDetails.totalGainLoss == null
                ? SizedBox(height: 120, child: NoData())
                : Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            color: Config.appTheme.themeColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Text(
                                    "For ${selectedFY == "date-range" ? "Date ${Utils.getFormattedDate(date: selectedStartDate)} - ${Utils.getFormattedDate(date: selectedEndDate)}" : "FY $selectedFY"}",
                                    style: AppFonts.f40016.copyWith(
                                        color: Colors.white, fontSize: 16),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.all(16).copyWith(top: 5),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Config.appTheme.overlay85,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ColumnText(
                                              title: "Total Gain/Loss",
                                              value:
                                                  "$rupee ${Utils.formatNumber(gainLossDetails.totalGainLoss?.round())}",
                                              titleStyle: AppFonts.f40013,
                                              valueStyle: AppFonts.f70024
                                                  .copyWith(
                                                      color: Config
                                                          .appTheme.themeColor),
                                            ),
                                          ],
                                        ),
                                        DottedLine(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ColumnText(
                                              title: "Long Term Gain",
                                              titleStyle: AppFonts.f40013,
                                              value:
                                                  "$rupee ${Utils.formatNumber(gainLossDetails.totalLtGain?.round())}",
                                              valueStyle: AppFonts.f50014Black,
                                            ),
                                            ColumnText(
                                              title: "Short Term Gain",
                                              titleStyle: AppFonts.f40013,
                                              value:
                                                  "$rupee ${Utils.formatNumber(gainLossDetails.totalStGain?.round())}",
                                              valueStyle: AppFonts.f50014Black,
                                              alignment: CrossAxisAlignment.end,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.055,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: DebtEquityButton(
                                      isSelected: !isDebtSelected,
                                      onPressed: () {
                                        controller.unselectDebt();
                                      },
                                      text: 'Equity',
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: DebtEquityButton(
                                      isSelected: isDebtSelected,
                                      onPressed: () {
                                        controller.selectDebt();
                                      },
                                      text: 'Debt',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                BlackCard(
                                  schemeData: (isDebtSelected
                                          ? gainLossDetails.debtResult
                                          : gainLossDetails.equityResult) ??
                                      SchemeData(),
                                ),
                                SizedBox(height: 5),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: isDebtSelected
                                        ? gainLossDetails
                                            .debtResult?.list?.length
                                        : gainLossDetails
                                            .equityResult?.list?.length,
                                    itemBuilder: (ctx, index) {
                                      final schemeDetails =
                                          switch (isDebtSelected) {
                                        true => gainLossDetails
                                            .debtResult?.list?[index],
                                        false => gainLossDetails
                                            .equityResult?.list?[index],
                                      };
                                      return SchemeCard(
                                          schemeData:
                                              schemeDetails ?? SchemeDetails());
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (isDownloadingPdf)
                        Container(
                          color: Colors.black.withOpacity(.1),
                          child: Center(child: CircularProgressIndicator()),
                        )
                    ],
                  ),
          _ => SizedBox(),
        };
      }),
    );
  }
}

class SchemeCard extends StatelessWidget {
  final SchemeDetails schemeData;

  const SchemeCard({
    super.key,
    required this.schemeData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                schemeData.logo ?? '',
                height: 32,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schemeData.schemeAmfiShortName ?? '',
                      style: AppFonts.f50014Black,
                    ),
                    Text(
                      "Folio : ${schemeData.folioNo ?? ''}",
                      style: AppFonts.f40013.copyWith(color: Colors.black),
                    ),
                  ],
                ),
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
                value: "$rupee ${Utils.formatNumber(
                  schemeData.totalGainLoss?.round(),
                )}",
              ),
              ColumnText(
                title: "STCG",
                value: "$rupee ${Utils.formatNumber(
                  schemeData.stGain?.round(),
                )}",
                alignment: CrossAxisAlignment.center,
              ),
              ColumnText(
                title: "LTCG",
                value: "$rupee ${Utils.formatNumber(
                  schemeData.ltGain?.round(),
                )}",
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: ((schemeData.stGain ?? 0) >= 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          DottedLine()
        ],
      ),
    );
  }
}

class BlackCard extends StatelessWidget {
  final SchemeData schemeData;

  const BlackCard({
    super.key,
    required this.schemeData,
  });

  @override
  Widget build(BuildContext context) {
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
                    "$rupee ${Utils.formatNumber(schemeData.ltSoldTotal?.round() ?? 0)}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(schemeData.stSoldTotal?.round() ?? 0)}",
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
                    "$rupee ${Utils.formatNumber(schemeData.ltPurchaseTotal?.round() ?? 0)}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(schemeData.stPurchaseTotal?.round() ?? 0)}",
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
                    "$rupee ${Utils.formatNumber(schemeData.ltGainTotal?.round() ?? 0)}",
                    style:
                        AppFonts.f50012.copyWith(color: AppColors.textGreen)),
              ),
              Expanded(
                child: Text(
                    "$rupee ${Utils.formatNumber(schemeData.stGainTotal?.round() ?? 0)}",
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DebtEquityButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isSelected;
  final String text;

  const DebtEquityButton({
    super.key,
    required this.onPressed,
    this.isSelected = false,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: BoxDecoration(
            color: isSelected ? Config.appTheme.themeColor : null,
            border: Border.all(
              color: Config.appTheme.themeColor,
            ),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppFonts.f50014Black.copyWith(
                color: isSelected ? Colors.white : Config.appTheme.themeColor),
          ),
        ),
      ),
    );
  }
}

showDownloadModal(
  context,
  GainLossController gainLossController,
) {
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
          aspectRatio: 2 / 1,
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
                            style: AppFonts.f50014Black.copyWith(fontSize: 18)),
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.close))
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            gainLossController
                                .downloadOrSendPdf(ActionType.download);
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
                        DottedLine(),
                        InkWell(
                          onTap: () {
                            gainLossController
                                .downloadOrSendPdf(ActionType.email);
                            Get.back();
                          },
                          child: RpListTile(
                            title: SizedBox(
                              width: 220,
                              child: Text(
                                'Email Report',
                                style: AppFonts.f50014Black.copyWith(
                                    color: Config.appTheme.themeColor),
                              ),
                            ),
                            subTitle: SizedBox(),
                            leading: Image.asset(
                              "assets/email.png",
                              color: Config.appTheme.themeColor,
                              width: 32,
                              height: 32,
                            ),
                            showArrow: false,
                          ),
                        )
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

showFinancialYearBottomSheet(
  context,
  GainLossController gainLossController,
) {
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
        return AspectRatio(
          aspectRatio: 2 / 2.5,
          child: Scaffold(
            body: Obx(() {
              final state = gainLossController.state;
              return switch (state) {
                GainLossLoadedState(
                  financialYears: final fyList,
                  selectedFinancialYear: final selectedFy,
                ) =>
                  Container(
                    decoration: BoxDecoration(
                      color: Config.appTheme.overlay85,
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
                                gainLossController
                                    .selectFinancialYear("date-range");
                              },
                              child: Row(
                                children: [
                                  Radio(
                                    value: "date-range",
                                    groupValue: selectedFy,
                                    onChanged: (val) {},
                                  ),
                                  Text("Date Range")
                                ],
                              )),
                          Visibility(
                              visible: selectedFy == "date-range",
                              child: startDateExpansionTile(
                                  context, gainLossController)),
                          Visibility(
                              visible: selectedFy == "date-range",
                              child: endDateExpansionTile(
                                  context, gainLossController)),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 1,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              String year = fyList?[index] ?? '';
                              return InkWell(
                                onTap: () {
                                  gainLossController.selectFinancialYear(year);
                                  gainLossController.fetchGainLossData();
                                  Get.back();
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Config.appTheme.themeColor,
                                      groupValue: selectedFy,
                                      value: fyList?[index],
                                      onChanged: (val) {},
                                    ),
                                    Expanded(
                                      child: Text(year),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                _ => Utils.shimmerWidget(200),
              };
            }),
            bottomNavigationBar: Container(
              height: 75,
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getCancelApplyButton(ButtonType.plain, gainLossController),
                  getCancelApplyButton(ButtonType.filled, gainLossController),
                ],
              ),
            ),
          ),
        );
      });
}

Widget startDateExpansionTile(
  BuildContext context,
  GainLossController gainLossController,
) {
  return Obx(() {
    final state = gainLossController.state;
    return switch (state) {
      GainLossLoadedState(
        startDate: final startDate,
      ) =>
        Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text("Start Date", style: AppFonts.f50014Black),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Utils.getFormattedDate(date: startDate),
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
                      selectedDate: startDate ?? DateTime.now(),
                      onDateTimeChanged: (value) {
                        gainLossController.selectStartDate(value);
                      },
                    ),
                  ),
                ],
              )),
        ),
      _ => SizedBox(),
    };
  });
}

Widget endDateExpansionTile(
  BuildContext context,
  GainLossController gainLossController,
) {
  return Obx(() {
    final state = gainLossController.state;
    return switch (state) {
      GainLossLoadedState(endDate: final endDate) => Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text("End Date", style: AppFonts.f50014Black),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Utils.getFormattedDate(date: endDate),
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
                      selectedDate: endDate ?? DateTime.now(),
                      onDateTimeChanged: (value) {
                        gainLossController.selectEndDate(value);
                      },
                    ),
                  ),
                ],
              )),
        ),
      _ => SizedBox(),
    };
  });
}

Widget getCancelApplyButton(
  ButtonType type,
  GainLossController gainLossController,
) {
  if (type == ButtonType.plain)
    return PlainButton(
      color: Config.appTheme.buttonColor,
      text: "RESET",
      onPressed: () {
        gainLossController.resetFilterData();
        Get.back();
      },
    );
  else
    return RpFilledButton(
      color: Config.appTheme.buttonColor,
      text: "APPLY",
      onPressed: () {
        gainLossController.fetchGainLossData();
        Get.back();
      },
    );
}
