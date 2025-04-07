import 'package:flutter/material.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/pojo/LumpsumAllocation.dart';
import 'package:mymfbox2_0/rp_widgets/PercentageBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/ShareWidget.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class SipProposalOutput extends StatefulWidget {
  const SipProposalOutput(
      {super.key,
      required this.noOfSchemeAmt,
      required this.totalInvested,
      required this.summary,
      required this.portfolioAllocation,
      required this.amcAllocation,
      required this.assetAllocation,
      required this.sipAllocation,
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
      required this.invType});

  final Map summary;
  final num totalInvested;
  final List portfolioAllocation,
      amcAllocation,
      assetAllocation,
      categoryAllocation,
      sipAllocation;
  final String clientName;
  final String noOfSchemeAmt;
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

  @override
  State<SipProposalOutput> createState() => _SipProposalOutputState();
}

class _SipProposalOutputState extends State<SipProposalOutput> {
  late double devWidth;

  Map summary = {};
  List<LumpsumAllocationPojo> allocationList = [];
  late List amcAllocation, assetAllocation, categoryAllocation, sipAllocation;
  late num totalInvested;

  int selectedYear = 1;

  String clientName = "";
  String noOfSchemeAmt = "";
  int invId = 0;
  String invName = "";
  int userId = 0;
  num amount = 0;
  num horizon = 0;
  String risk = "";
  String schemeCode = "";
  String schemeaAmt = "";
  String invPurpose = "";
  String invType = "";

  @override
  void initState() {
    //  implement initState
    super.initState();
    summary = widget.summary;
    amcAllocation = widget.amcAllocation;
    assetAllocation = widget.assetAllocation;
    categoryAllocation = widget.categoryAllocation;
    totalInvested = widget.totalInvested;
    sipAllocation = widget.sipAllocation;
    clientName = widget.clientName;
    noOfSchemeAmt = widget.noOfSchemeAmt;
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

    widget.portfolioAllocation.forEach((element) {
      allocationList.add(LumpsumAllocationPojo.fromJson(element));
    });
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: rpAppBar(
          title: "Suggested Portfolio All..",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white,
          actions: [
            GestureDetector(
              onTap: () {
                String url = "";
                url =
                    "${ApiConfig.apiUrl}/download/downloadSipInvestmentProposalPDF?key=${ApiConfig.apiKey}&"
                    "client_name=$clientName"
                    "&name=$invType"
                    "&inv_amount=$amount"
                    "&horizon=$horizon&risk=$risk"
                    "&scheme_code=$schemeCode&amount=$schemeaAmt&inv_purpose=$invPurpose";
                print("downloadSipInvestmentProposalPDF $url");

                SharedWidgets().shareBottomSheet(context, url);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.more_horiz_outlined,
                ),
              ),
            ),
          ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topBlackCard(),
              SizedBox(height: 16),
              (allocationList.isEmpty)
                  ? NoData()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: allocationList.length,
                      itemBuilder: (context, index) {
                        return schemeCard(allocationList[index]);
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
              Text(
                "Growth of $rupee 10,000 SIP (an example)",
                style: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.themeColor, fontSize: 16),
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
              (sipAllocation.isEmpty)
                  ? NoData()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: sipAllocation.length,
                      itemBuilder: (context, index) {
                        Map sip = sipAllocation[index];

                        return sipCard(sip, year: selectedYear);
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget topBlackCard() {
    String futureValue = Utils.formatNumber(summary['future_value']);
    String catAvg = summary['cat_avg'].toStringAsFixed(2);

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
            noOfSchemeAmt,
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

  Widget schemeCard(LumpsumAllocationPojo pojo) {
    String amount = Utils.formatNumber(pojo.amount);
    String investedAmount = Utils.formatNumber(pojo.investedAmount);
    num percentage = pojo.percentage ?? 0;

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
              Text("(${percentage.toStringAsFixed(2)}%)",
                  style: AppFonts.f40013)
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
}
