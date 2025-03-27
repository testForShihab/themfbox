import 'package:flutter/material.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/pojo/LumpsumAllocation.dart';
import 'package:mymfbox2_0/rp_widgets/PercentageBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class LumpsumPlusSipProposalOutput extends StatefulWidget {
  const LumpsumPlusSipProposalOutput({
    super.key,
    required this.lumpsumNoOfSchemeAmt,
    required this.sipNoOfSchemeAmt,
    required this.summary,
    required this.portfolioAllocation,
    required this.amcAllocation,
    required this.assetAllocation,
    required this.categoryAllocation,
    required this.clientName,
    required this.invId,
    required this.invName,
    required this.userId,
    required this.amount,
    required this.horizon,
    required this.risk,
    required this.schemeCode,
    required this.schemeaAmt,
    required this.invPurpose,
    required this.invType,
    required this.totalInvested,
    required this.sipSummary,
    required this.portfolioSipAllocation,
    required this.assetSipAllocation,
    required this.amcSipAllocation,
    required this.categorySipAllocation,
    required this.sipAllocation,
  });

  final Map summary;
  final Map sipSummary;
  final List portfolioSipAllocation,
      amcSipAllocation,
      assetSipAllocation,
      categorySipAllocation,
      sipAllocation;
  final List portfolioAllocation,
      amcAllocation,
      assetAllocation,
      categoryAllocation;
  final String clientName;
  final String lumpsumNoOfSchemeAmt;
  final String sipNoOfSchemeAmt;
  final int invId;
  final String invName;
  final int userId;
  final num amount;
  final num horizon;
  final String risk;
  final String schemeCode;
  final String schemeaAmt;
  final String invPurpose;
  final String invType;
  final num totalInvested;

  @override
  State<LumpsumPlusSipProposalOutput> createState() =>
      _LumpsumPlusSipProposalOutputState();
}

class _LumpsumPlusSipProposalOutputState
    extends State<LumpsumPlusSipProposalOutput> {
  late double devWidth;
  Map summary = {};
  Map sipSummary = {};
  List<LumpsumAllocationPojo> allocationList = [];
  List<LumpsumAllocationPojo> allocationSipList = [];
  late List amcAllocation,
      portfolioAllocation,
      assetAllocation,
      categoryAllocation;
  int selectedScenario = 1;
  late List portfolioSipAllocation,
      amcSipAllocation,
      assetSipAllocation,
      categorySipAllocation,
      sipAllocation;

  String clientName = "";
  String noOfSchemeAmt = "";
  String noOfSipSchemeAmt = "";
  int invId = 0;
  String invName = "";
  bool isVisible = false;
  int userId = 0;
  num amount = 0;
  num horizon = 0;
  String risk = "";
  String schemeCode = "";
  String schemeaAmt = "";
  String invPurpose = "";
  String invType = "";
  late num totalInvested = 0;
  int selectedYear = 1;
  @override
  void initState() {
    //  implement initState
    super.initState();
    summary = widget.summary;
    amcAllocation = widget.amcAllocation;
    portfolioAllocation = widget.portfolioAllocation;
    assetAllocation = widget.assetAllocation;
    categoryAllocation = widget.categoryAllocation;
    clientName = widget.clientName;
    noOfSchemeAmt = widget.lumpsumNoOfSchemeAmt;
    noOfSipSchemeAmt = widget.sipNoOfSchemeAmt;
    invId = widget.invId;
    invName = widget.invName;
    userId = widget.userId;
    amount = widget.amount;
    horizon = widget.horizon;
    schemeCode = widget.schemeCode;
    schemeaAmt = widget.schemeaAmt;
    risk = widget.risk;
    invPurpose = widget.invPurpose;
    invType = widget.invType;
    totalInvested = widget.totalInvested;

    sipSummary = widget.sipSummary;
    portfolioSipAllocation = widget.portfolioSipAllocation;
    amcSipAllocation = widget.amcSipAllocation;
    assetSipAllocation = widget.assetSipAllocation;
    categorySipAllocation = widget.categorySipAllocation;
    sipAllocation = widget.sipAllocation;

    widget.portfolioAllocation.forEach((element) {
      allocationList.add(LumpsumAllocationPojo.fromJson(element));
    });

    widget.portfolioSipAllocation.forEach((element) {
      allocationSipList.add(LumpsumAllocationPojo.fromJson(element));
    });
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Suggested Portfolio Allo..",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white,
          actions: [
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    )),
                margin: EdgeInsets.only(right: 15),
                child: Icon(Icons.more_horiz_outlined),
              ),
            ),
          ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              topBlackCard(),
              SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: allocationList.length,
                itemBuilder: (context, index) {
                  return schemeCard(allocationList[index]);
                },
              ),
              topSipBlackCard(),
              SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: allocationSipList.length,
                itemBuilder: (context, index) {
                  return schemeSipCard(allocationSipList[index]);
                },
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Config.appTheme.whiteOverlay,
                  border: Border.all(color: Config.appTheme.lineColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Note: Expected returns are taken from the category average returns basis the latest NAV as on date. For Equity & Solution Oriented categories 5 years, Hybrid Fund categories 3 years and for Debt categories 1 year category average returns have been considered.",
                  style: AppFonts.f40013,
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  isVisible = true;
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 14, horizontal: 46), // Add padding
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Config.appTheme.themeColor,
                      width: 1,
                    ),
                  ), // Set background color
                  child: Text(
                    "VIEW PORTFOLIO ANALYSIS",
                    style: AppFonts.f50014Grey
                        .copyWith(color: Config.appTheme.themeColor),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Visibility(
                visible: isVisible,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: getButton(1),
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: getButton(2),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    if (selectedScenario == 1) ...[
                      amcAllocationCard(),
                      SizedBox(height: 16),
                      assetAllocationCard(),
                      SizedBox(height: 16),
                      categoryAllocationCard(),
                    ],
                    if (selectedScenario == 2)
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Growth of $rupee 10,000 SIP (an example)",
                              style: AppFonts.f50014Black.copyWith(
                                color: Config.appTheme.themeColor,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              height: 50,
                              child: Row(
                                children: [
                                  yearCard(1),
                                  yearCard(3),
                                  yearCard(5),
                                  yearCard(10),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: sipAllocation.length,
                              itemBuilder: (context, index) {
                                Map sip = sipAllocation[index];
                                return sipCard(sip, year: selectedYear);
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
            // SipProposalOutput(
            //     noOfSchemeAmt: noOfSchemeAmt,
            //     totalInvested: totalInvested,
            //     summary: summary,
            //     portfolioAllocation: portfolioAllocation,
            //     amcAllocation: amcAllocation,
            //     assetAllocation: assetAllocation,
            //     sipAllocation: sipAllocation,
            //     categoryAllocation: categoryAllocation,
            //     clientName: clientName,
            //     invId: invId,
            //     invName: invName,
            //     userId: userId,
            //     amount: amount,
            //     horizon: horizon,
            //     risk: risk,
            //     schemeCode: schemeCode,
            //     schemeaAmt: schemeaAmt,
            //     invPurpose: invPurpose,
            //     invType: invType)
          ),
        ),
      ),
    );
  }

  Widget topBlackCard() {
    num futureValueNum = num.tryParse(summary['future_value_str'] ?? "0") ?? 0;
    String futureValue = Utils.formatNumber(futureValueNum);
    String catAvg = summary['cat_avg'].toStringAsFixed(2);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Lumpsum Portfolio",
            style: AppFonts.f50014Black.copyWith(color: Colors.white),
          ),
          Text(
            noOfSchemeAmt,
            style: AppFonts.f50012.copyWith(color: AppColors.textGreen),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Period",
                value: "${summary['period']} Years",
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50012.copyWith(color: Colors.white),
              ),
              ColumnText(
                title: "Cat Avg",
                value: "$catAvg%",
                alignment: CrossAxisAlignment.center,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50012.copyWith(color: Colors.white),
              ),
              ColumnText(
                title: "Future Value",
                value: "$rupee $futureValue",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50012.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget schemeCard(LumpsumAllocationPojo pojo) {
    String amount = Utils.formatNumber(pojo.amount);

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.lineColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //image & scheme name
          Row(
            children: [
              //Image.network("${pojo.logo}", height: 32),
              Utils.getImage("${pojo.logo}", 32),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: devWidth * 0.7,
                    child: Text("${pojo.schemeAmfiShortName}",
                        style: AppFonts.f50014Black),
                  ),
                  Text("${pojo.amfiCategory} : ${pojo.riskometer}",
                      style: AppFonts.f40013),
                ],
              )
            ],
          ),
          SizedBox(height: 16),

          //lumpsum & percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Lumpsum ($rupee $amount)",
                style:
                    AppFonts.f50012.copyWith(color: Config.appTheme.themeColor),
              ),
              Text("(${pojo.percentage}%)", style: AppFonts.f40013)
            ],
          ),
          SizedBox(height: 5),
          PercentageBar(pojo.percentage!.toDouble(), width: devWidth - 32),
          SizedBox(height: 16),

          //period, cat avg, future
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(title: "Period", value: "${summary['period']} Years"),
              ColumnText(
                title: "Cat Avg",
                value: "${pojo.catAvg}%",
                alignment: CrossAxisAlignment.center,
              ),
              ColumnText(
                title: "Future Value",
                value: "$rupee ${Utils.formatNumber(pojo.futureValue)}",
                alignment: CrossAxisAlignment.end,
              )
            ],
          ),
          DottedLine(),

          //1y, 3y, 5y return
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(title: "1Y Return", value: "${pojo.yr1Return}%"),
              ColumnText(
                title: "3Y Return",
                value: "${pojo.yr3Return}%",
                alignment: CrossAxisAlignment.center,
              ),
              ColumnText(
                title: "5Y Return",
                value: "${pojo.yr5Return}%",
                alignment: CrossAxisAlignment.end,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget amcAllocationCard() {
    num grandTotalAmount = 0;
    for (var amc in amcAllocation) {
      grandTotalAmount += num.tryParse(amc['amount'].toString()) ?? 0;
    }
    String formattedGrandTotalAmount = Utils.formatNumber(grandTotalAmount);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "AMC Allocation",
            style: AppFonts.f50014Black
                .copyWith(color: Config.appTheme.themeColor, fontSize: 16),
          ),
          SizedBox(height: 14),
          ListView.separated(
            shrinkWrap: true,
            itemCount: amcAllocation.length,
            itemBuilder: (context, index) {
              Map amc = amcAllocation[index];
              String amount = Utils.formatNumber(amc['amount']);
              String percentage = amc['percentage'].toStringAsFixed(2);

              return Row(
                children: [
                  //Image.network("${amc['logo']}", height: 32),
                  Utils.getImage("${amc['logo']}", 32),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text("${amc['company']}"),
                  ),
                  SizedBox(width: 5),
                  ColumnText(
                    title: "$rupee $amount",
                    value: "$percentage %",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013,
                    alignment: CrossAxisAlignment.end,
                  ),
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return DottedLine();
            },
          ),
          DottedLine(verticalPadding: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Grand Total",
                style: AppFonts.f50014Black,
              ),
              Text("$rupee $formattedGrandTotalAmount",
                  style: AppFonts.f50014Black
                      .copyWith(color: Config.appTheme.themeColor))
            ],
          ),
        ],
      ),
    );
  }

  Widget assetAllocationCard() {
    num grandTotalAssetAllocation = 0;
    for (var amc in assetAllocation) {
      grandTotalAssetAllocation += num.tryParse(amc['amount'].toString()) ?? 0;
    }
    String formattedGrandTotalAssetAllocation =
        Utils.formatNumber(grandTotalAssetAllocation);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Asset Allocation",
            style: AppFonts.f50014Black
                .copyWith(color: Config.appTheme.themeColor, fontSize: 16),
          ),
          SizedBox(height: 14),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: assetAllocation.length,
            itemBuilder: (context, index) {
              Map asset = assetAllocation[index];
              String name = asset['scheme_broad_category'];
              String amount = Utils.formatNumber(asset['amount']);
              num percentage = asset['percentage'];

              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name),
                    Text(amount),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PercentageBar(percentage.toDouble()),
                    Text("${percentage.toStringAsFixed(2)} %")
                  ],
                ),
              );
            },
          ),
          DottedLine(verticalPadding: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Grand Total",
                style: AppFonts.f50014Black,
              ),
              Text("$rupee $formattedGrandTotalAssetAllocation",
                  style: AppFonts.f50014Black
                      .copyWith(color: Config.appTheme.themeColor))
            ],
          ),
        ],
      ),
    );
  }

  Widget categoryAllocationCard() {
    num grandTotalCategoryAllocation = 0;
    for (var amc in categoryAllocation) {
      grandTotalCategoryAllocation +=
          num.tryParse(amc['amount'].toString()) ?? 0;
    }
    String formattedGrandTotalCategoryAllocation =
        Utils.formatNumber(grandTotalCategoryAllocation);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Category Allocation",
            style: AppFonts.f50014Black
                .copyWith(color: Config.appTheme.themeColor, fontSize: 16),
          ),
          SizedBox(height: 14),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: categoryAllocation.length,
            itemBuilder: (context, index) {
              Map category = categoryAllocation[index];

              String name = category['scheme_category'];
              String amount = Utils.formatNumber(category['amount']);
              num percentage = category['percentage'];

              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name),
                    Text(amount),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PercentageBar(percentage.toDouble()),
                    Text("${percentage.toStringAsFixed(2)} %")
                  ],
                ),
              );
            },
          ),
          DottedLine(verticalPadding: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Grand Total",
                style: AppFonts.f50014Black,
              ),
              Text("$rupee $formattedGrandTotalCategoryAllocation",
                  style: AppFonts.f50014Black
                      .copyWith(color: Config.appTheme.themeColor))
            ],
          ),
        ],
      ),
    );
  }

//sip

  Widget topSipBlackCard() {
    String futureValue = Utils.formatNumber(sipSummary['future_value']);
    String catAvg = sipSummary['cat_avg'].toStringAsFixed(2);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SIP Portfolio",
            style: AppFonts.f50014Black.copyWith(color: Colors.white),
          ),
          Text(
            noOfSipSchemeAmt,
            style: AppFonts.f50012.copyWith(color: AppColors.textGreen),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Total Invested",
                value: "$rupee ${Utils.formatNumber(totalInvested)}",
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50012.copyWith(color: Colors.white),
              ),
              ColumnText(
                title: "Cat Avg",
                value: "$catAvg%",
                alignment: CrossAxisAlignment.center,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50012.copyWith(color: Colors.white),
              ),
              ColumnText(
                title: "Future Value",
                value: "$rupee $futureValue",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50012.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget schemeSipCard(LumpsumAllocationPojo pojo) {
    String amount = Utils.formatNumber(pojo.amount);
    String investedAmount = Utils.formatNumber(pojo.investedAmount);

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.lineColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //image & scheme name
          Row(
            children: [
              //Image.network("${pojo.logo}", height: 32),
              Utils.getImage("${pojo.logo}", 32),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: devWidth * 0.7,
                    child: Text("${pojo.schemeAmfiShortName}",
                        style: AppFonts.f50014Black),
                  ),
                  Text("${pojo.amfiCategory} : ${pojo.riskometer}",
                      style: AppFonts.f40013),
                ],
              )
            ],
          ),
          SizedBox(height: 16),

          //lumpsum & percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "SIP: $rupee $amount",
                      style: AppFonts.f50012
                          .copyWith(color: Config.appTheme.themeColor),
                    ),
                    TextSpan(
                        text: " (${summary['period']} Years)",
                        style: AppFonts.f50014Grey.copyWith(fontSize: 12)),
                  ],
                ),
              ),
              Text("(${pojo.percentage}%)", style: AppFonts.f40013)
            ],
          ),
          SizedBox(height: 5),
          PercentageBar(pojo.percentage!.toDouble(), width: devWidth - 32),
          SizedBox(height: 16),

          //period, cat avg, future
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Total Invested", value: "$rupee $investedAmount"),
              ColumnText(
                title: "Cat Avg",
                value: "${pojo.catAvg}%",
                alignment: CrossAxisAlignment.center,
              ),
              ColumnText(
                title: "Future Value",
                value: "$rupee ${Utils.formatNumber(pojo.futureValue)}",
                alignment: CrossAxisAlignment.end,
              )
            ],
          ),
          DottedLine(),

          //1y, 3y, 5y return
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(title: "1Y Return", value: "${pojo.yr1Return}%"),
              ColumnText(
                title: "3Y Return",
                value: "${pojo.yr3Return}%",
                alignment: CrossAxisAlignment.center,
              ),
              ColumnText(
                title: "5Y Return",
                value: "${pojo.yr5Return}%",
                alignment: CrossAxisAlignment.end,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget sipCard(Map sip, {required int year}) {
    String name = sip['scheme_amfi_short_name'];
    String totalInvested = Utils.formatNumber(sip['amount_invested_$year']);
    String currentValue = Utils.formatNumber(sip['maturity_value_$year']);
    num xirr = sip['xirr_$year'];

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lineColor),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Image.network("${sip['logo']}", height: 32),
              Utils.getImage("${sip['logo']}", 32),
              SizedBox(width: 10),
              Expanded(child: Text(name, style: AppFonts.f50014Black)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Total Invested", value: "$rupee $totalInvested"),
              ColumnText(
                title: "Current Value",
                value: "$rupee $currentValue",
                alignment: CrossAxisAlignment.center,
              ),
              ColumnText(
                title: "${year}Y XIRR",
                value: "$xirr%",
                alignment: CrossAxisAlignment.end,
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: (xirr > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget yearCard(int year) {
    if (selectedYear == year) return selectedYearCard(year);

    return Expanded(
      child: InkWell(
        onTap: () {
          selectedYear = year;
          setState(() {});
        },
        child: Container(
          margin: EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.cardGrey,
          ),
          child: Center(
              child: Text("${year}Y",
                  style: AppFonts.f50014Black
                      .copyWith(color: Config.appTheme.themeColor))),
        ),
      ),
    );
  }

  Widget selectedYearCard(int year) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Config.appTheme.themeColor,
        ),
        child: Center(
            child: Text("${year}Y",
                style: AppFonts.f50014Black.copyWith(color: Colors.white))),
      ),
    );
  }

  Widget getButton(int scenario) {
    String buttonText = scenario == 1
        ? "Lumpsum Portfolio Analysis"
        : "SIP Portfolio \nAnalysis";

    if (selectedScenario == scenario) {
      return RpFilledButton(
        text: buttonText,
        padding: EdgeInsets.zero,
      );
    } else {
      return PlainButton(
        text: buttonText,
        padding: EdgeInsets.zero,
        onPressed: () async {
          selectedScenario = scenario;
          if (scenario == 1) {
            setState(() {});
          } else {
            setState(() {});
          }
        },
      );
    }
  }
}
