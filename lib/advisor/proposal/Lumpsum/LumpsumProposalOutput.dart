import 'package:flutter/material.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/pojo/LumpsumAllocation.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/PercentageBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/ShareWidget.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class LumpsumProposalOutput extends StatefulWidget {
  const LumpsumProposalOutput(
      {super.key,
      required this.noOfSchemeAmt,
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
      required this.invType});

  final Map summary;
  final List portfolioAllocation,
      amcAllocation,
      assetAllocation,
      categoryAllocation;
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
  State<LumpsumProposalOutput> createState() => _LumpsumProposalOutputState();
}

class _LumpsumProposalOutputState extends State<LumpsumProposalOutput> {
  late double devWidth;

  Map summary = {};
  List<LumpsumAllocationPojo> allocationList = [];
  late List amcAllocation, assetAllocation, categoryAllocation;
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
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Suggested Portfolio Allo..",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white,
          actions: [
            GestureDetector(
              onTap: () {
                String url = "";
                url =
                    "${ApiConfig.apiUrl}/download/downloadInvestmentProposalPDF?key=${ApiConfig.apiKey}&"
                    "client_name=$clientName"
                    "&name=$invType"
                    "&inv_amount=$amount"
                    "&horizon=$horizon&risk=$risk"
                    "&scheme_code=$schemeCode&amount=$schemeaAmt&inv_purpose=$invPurpose";
                print("downloadInvestmentProposalPDF $url");

                SharedWidgets().shareBottomSheet(context, url);
              },
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
              amcAllocationCard(),
              SizedBox(height: 16),
              assetAllocationCard(),
              SizedBox(height: 16),
              categoryAllocationCard(),
            ],
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
          (amcAllocation.isEmpty)
              ? NoData()
              : ListView.separated(
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
          (assetAllocation.isEmpty)
              ? NoData()
              : ListView.builder(
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
          (categoryAllocation.isEmpty)
              ? NoData()
              : ListView.builder(
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
}
