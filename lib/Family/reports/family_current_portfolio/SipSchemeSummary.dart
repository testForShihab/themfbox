import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'package:mymfbox2_0/api/ReportApi.dart';

import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DayChange.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';

import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../../pojo/OnlineTransactionRestrictionPojo.dart';
import '../../../pojo/familyCurrentPortfolioPojo.dart';
import '../../../pojo/familyCurrentPortfolioPojo.dart';
import '../../../rp_widgets/NoData.dart';
import '../../../rp_widgets/PlainButton.dart';
import '../../../rp_widgets/RpListTile.dart';
import '../../../utils/AppColors.dart';

class SipSchemeSummary extends StatefulWidget {
 final List<SipSchemeSummaryPojo> sipSchemeSummaryList;
  SipSchemeSummary({Key? key, required this.sipSchemeSummaryList})
      : super(key: key);

  @override
  State<SipSchemeSummary> createState() => _SipSchemeSummaryState();
}

class _SipSchemeSummaryState extends State<SipSchemeSummary> {
  late double devHeight, devWidth;
  String selectedDate = " ";


  String selectedFolioType = "Live";
  DateTime? selectedFolioDate = DateTime.now();
  ExpansionTileController controller1 = ExpansionTileController();
  ExpansionTileController controller2 = ExpansionTileController();
  String selectedSort = "";
  bool isLoading = true;


  //
  // @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Family SIP Summary",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            if(widget.sipSchemeSummaryList!=null && widget.sipSchemeSummaryList.isNotEmpty)...[
              (isLoading)
                  ? Utils.shimmerWidget(devHeight*0.06,
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 0))
                  :middleArea(widget.sipSchemeSummaryList),],
            SizedBox(height: 16),
            if(widget.sipSchemeSummaryList !=null && widget.sipSchemeSummaryList == 0 && widget.sipSchemeSummaryList.isNotEmpty)...[
              (isLoading)
                  ? Utils.shimmerWidget(devHeight,
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 0))
                  :investorCard(widget.sipSchemeSummaryList, selectedInvestorName)],
            // categoryCard(mfSchemeSummaryList, selectedInvestorName),
            ..._buildSchemeListForSelectedInvestor(
                widget.sipSchemeSummaryList, selectedInvestorName),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSchemeListForSelectedInvestor(
      List<SipSchemeSummaryPojo> sipSchemeSummaryList, String selectedInvestorName) {
    final sipSchemeSummary = sipSchemeSummaryList.firstWhere(
      (element) => element.investorName == selectedInvestorName,
      orElse: () => SipSchemeSummaryPojo(),
    );

    final schemeList = sipSchemeSummary.schemeList ?? [];
    if (schemeList.isEmpty ) {
      return [NoData(text: 'No data Available')];
    }
    return schemeList.map((scheme) {
      return categoryCard(scheme);
    }).toList();
  }

  Widget categoryCard(SchemeList scheme) {
    final schemeAmfi = scheme.schemeAmfi ?? '';
    final schemeAmfiCode = scheme.schemeAmfiCode ?? '';
    final schemeAmfiShortName = scheme.schemeAmfiShortName ?? '';
    final schemeAmc = scheme.schemeAmc ?? '';
    final schemeAmcCode = scheme.schemeAmcCode ?? '';
    final schemeAmcLogo = scheme.schemeAmcLogo ?? '';
    final schemeBroadCategory = scheme.schemeBroadCategory ?? '';
    final schemeCategory = scheme.schemeCategory ?? '';
    final folio = scheme.folio ?? '';
    final brokerCode = scheme.brokerCode ?? '';
    final currCost = scheme.currCost ?? 0;
    final currValue = scheme.currValue ?? 0;
    final units = scheme.units ?? 0;
    final unrealisedProfitLoss = scheme.unrealisedProfitLoss ?? 0;
    final realisedProfitLoss = scheme.realisedProfitLoss ?? 0;
    final realisedGainLoss = scheme.realisedGainLoss ?? 0;
    final dayChangeValue = scheme.dayChangeValue ?? 0;
    final dayChangePercentage = scheme.dayChangePercentage ?? 0;
    final absoluteReturn = scheme.absoluteReturn ?? 0;
    final xirr = scheme.xirr ?? 0;
    final isSip = scheme.isSip ?? false;

    return InkWell(
      onTap: () {
        // Get.to(FamilyPortfolioAssetCategoryAllocationDetails(
        //     schemeList: schemeList, folioType: selectedFolioType,categoryName:categoryName));
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                // Get.to(SchemeInfo(
                //     schemeName: encodedName,
                //     schemeLogo: scheme.schemeAmcLogo,
                //     schemeShortName: encodedSchemeName));
              },
              child: RpListTile(
                showArrow: false,
                subTitle: Text("Folio : $folio",
                    style: f40012.copyWith(color: Colors.black)),
                leading: Image.network(
                  schemeAmcLogo ?? "",
                  height: 32,
                ),
                title: Text(
                  schemeAmfiShortName,
                  style: AppFonts.f50014Grey.copyWith(color: Colors.blue),
                  maxLines: 3,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  rpRow(
                      lhead: "Units",
                      lSubHead: Utils.formatNumber(units),
                      rhead: "Current Cost",
                      rSubHead: "$rupee ${Utils.formatNumber(currCost)}",
                      chead: "Current Value",
                      cSubHead: "$rupee ${Utils.formatNumber(currValue)}"),
                  SizedBox(
                    height: 16,
                  ),
                  rpRow(
                      lhead: "Unrealised Gain",
                      lSubHead:
                          "$rupee ${Utils.formatNumber(unrealisedProfitLoss)}",
                      rhead: "Realised Gain",
                      rSubHead:
                          "$rupee ${Utils.formatNumber(realisedProfitLoss)}",
                      chead: "Abs Rtn (%)",
                      cSubHead: Utils.formatNumber(absoluteReturn)),
                  SizedBox(
                    height: 16,
                  ),
                  rpRow(
                      lhead: "XIRR (%)",
                      lSubHead: Utils.formatNumber(xirr),
                      rhead: "",
                      rSubHead: '',
                      titleStyle: AppFonts.f40014,
                      valueStyle: AppFonts.f50016Grey,
                      chead: "",
                      cSubHead: "")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String selectedInvestorName = '';

  Widget investorCard(
      List<SipSchemeSummaryPojo> sipSchSumList, String selectedInvestorName) {
    final sipSchemeSummary = sipSchSumList.firstWhere(
      (element) => element.investorName == selectedInvestorName,
      orElse: () => SipSchemeSummaryPojo(),
    );

    final investorName = sipSchemeSummary.investorName ?? '';
    final familyStatus = sipSchemeSummary.familyStatus ?? '';
    final pan = sipSchemeSummary.pan ?? '';
    final salutation = sipSchemeSummary.salutation ?? '';
    final currentCost = sipSchemeSummary.currentCost ?? 0;
    final currentValue = sipSchemeSummary.currentValue ?? 0;
    final unrealisedGain = sipSchemeSummary.unrealisedGain ?? 0;
    final realisedGain = sipSchemeSummary.realisedGain ?? 0;
    final absRtn = sipSchemeSummary.absRtn ?? 0.0;
    final xirr = sipSchemeSummary.xirr ?? 0.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: devWidth,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Expanded(
              //       child: Text("$salutation $investorName",
              //           style:
              //               AppFonts.f50014Black.copyWith(color: Colors.white)),
              //     ),
              //   ],
              // ),
              // // SizedBox(height: 8),
              // if (familyStatus.isEmpty || familyStatus != null)
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Expanded(
              //         child: Text("$familyStatus",
              //             style: AppFonts.f50014Black
              //                 .copyWith(color: Colors.white, fontSize: 12)),
              //       ),
              //     ],
              //   ),
              // SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ColumnText(
                    title: "Current Cost",
                    value: "$rupee ${Utils.formatNumber(currentCost)}",
                    valueStyle: AppFonts.f40013.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  ColumnText(
                    title: "Current Value",
                    value: "$rupee ${Utils.formatNumber(currentValue)}",
                    alignment: CrossAxisAlignment.center,
                    valueStyle: AppFonts.f40013.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  ColumnText(
                    title: "Unrealised Gain",
                    value: "$rupee ${Utils.formatNumber(unrealisedGain)}",
                    alignment: CrossAxisAlignment.end,
                    valueStyle: AppFonts.f40013.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ColumnText(
                    title: "Realised Gain",
                    value: "$rupee ${Utils.formatNumber(realisedGain)}",
                    valueStyle: AppFonts.f40013.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    alignment: CrossAxisAlignment.start,
                  ),
                  ColumnText(
                    title: "Absolute Return",
                    value: "${absRtn.toStringAsFixed(2)} $percentage",
                    valueStyle: AppFonts.f40013.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    alignment: CrossAxisAlignment.center,
                  ),
                  ColumnText(
                    title: "XIRR",
                    value: "${Utils.formatNumber(xirr)} $percentage",
                    valueStyle: AppFonts.f40013.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    alignment: CrossAxisAlignment.end,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget middleArea(List<SipSchemeSummaryPojo> sipSchSumList) {
    if (selectedInvestorName.isEmpty && sipSchSumList.isNotEmpty) {
      selectedInvestorName = sipSchSumList.first.investorName ?? '';
    }
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 16, right: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: sipSchSumList.length ?? 0,
        itemBuilder: (context, index) {
          final category = sipSchSumList[index];
          String investorName = category.investorName ?? '';
          String status = category.familyStatus ?? '';
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedInvestorName = investorName;
              });
            },
            child: getButton(
              text: investorName,status:status,
              type: selectedInvestorName == investorName
                  ? ButtonType.filled
                  : ButtonType.plain,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(width: 16),
      ),
    );
  }

  Widget getButton({required String text, required ButtonType type, required String status}) {
    EdgeInsets padding = EdgeInsets.symmetric(horizontal: 16);
    if (type == ButtonType.plain) {
      return GestureDetector(
        onTap: () {
          selectedInvestorName = text;
          selectedSort = "";
          setState(() {});
        },
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
              border: Border.all(color: Config.appTheme.themeColor),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor,fontSize: 14),
                  ),
                ],
              ),
              if (status != null && status.isNotEmpty)
                Row(
                  children: [
                    Text(
                      "($status)",
                      textAlign: TextAlign.center,
                      style: AppFonts.f50014Black
                          .copyWith(color: Config.appTheme.themeColor,fontSize: 10),
                    ),
                  ],
                ),
            ],
          ),
        ),
      );
    } else {
      return Container(
          padding: padding,
          decoration: BoxDecoration(
              color: Config.appTheme.themeColor,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: AppFonts.f50014Black.copyWith(color: Colors.white,fontSize: 14),
                  ),
                ],
              ),
              if (status != null && status.isNotEmpty)
                Row(
                  children: [
                    Text(
                      "($status)",
                      textAlign: TextAlign.center,
                      style: AppFonts.f50014Black.copyWith(color: Colors.white,fontSize: 10),
                    ),
                  ],
                ),
            ],
          ));
    }
  }

  Widget rpRow({
    required String lhead,
    required String lSubHead,
    required String rhead,
    required String rSubHead,
    required String chead,
    required String cSubHead,
    final TextStyle? valueStyle,
    final TextStyle? titleStyle,
  }) {
    return Row(
      children: [
        Expanded(
            child: ColumnText(
                title: lhead,
                value: lSubHead,
                alignment: CrossAxisAlignment.start)),
        Expanded(
            child: ColumnText(
          title: rhead,
          value: rSubHead,
          alignment: CrossAxisAlignment.center,
          valueStyle: valueStyle,
          titleStyle: titleStyle,
        )),
        Expanded(
            child: ColumnText(
                title: chead,
                value: cSubHead,
                alignment: CrossAxisAlignment.end)),
      ],
    );
  }
}
