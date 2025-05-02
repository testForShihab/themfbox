import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpChip.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';

class FamilyInvestmentSummaryDetails extends StatefulWidget {
  const FamilyInvestmentSummaryDetails({super.key});

  @override
  State<FamilyInvestmentSummaryDetails> createState() =>
      _FamilyInvestmentSummaryDetailsState();
}

class _FamilyInvestmentSummaryDetailsState
    extends State<FamilyInvestmentSummaryDetails> {
  Map schemeItem = {};
  late double devWidth, devHeight;
  List tranxList = [];

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: AppBar(
        backgroundColor: Config.appTheme.themeColor,
        leadingWidth: 0,
        toolbarHeight: 40,
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
              ],
            ),
          ],
        ),
      ),
      body: displayPage(),
    );
  }

  Widget displayPage() {
    return SideBar(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            child: topCard(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  detailsCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container topCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      color: Config.appTheme.themeColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("assets/48.png", height: 30),
              SizedBox(width: 10),
              Expanded(
                child: ColumnText(
                  title:
                      "Parag Parikh Banking & Financial Services Fund Growth",
                  value: "Equity • Mid Cap ",
                  titleStyle: AppFonts.f50014Black
                      .copyWith(fontSize: 18, color: Colors.white),
                  valueStyle: AppFonts.f40013.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          DottedLine(verticalPadding: 4),
          Text(
            "₹40,00,000",
            style: AppFonts.f70024.copyWith(color: Colors.white),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "1 Day Change: ₹45,000 ",
                  style: AppFonts.f40013.copyWith(color: Colors.white),
                ),
                TextSpan(
                  text: "(0.34%)",
                  style: AppFonts.f40013
                      .copyWith(color: Config.appTheme.defaultProfit),
                ),
              ],
            ),
          ),
          DottedLine(
            verticalPadding: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Current Cost",
                titleStyle:
                    AppFonts.f40013.copyWith(color: Config.appTheme.overlay85),
                value: "₹15,00,000",
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
                alignment: CrossAxisAlignment.start,
              ),
              ColumnText(
                title: "Gain/Loss",
                titleStyle:
                    AppFonts.f40013.copyWith(color: Config.appTheme.overlay85),
                value: "₹25,00,000",
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
                alignment: CrossAxisAlignment.center,
              ),
              ColumnText(
                title: "XIRR",
                titleStyle:
                    AppFonts.f40013.copyWith(color: Config.appTheme.overlay85),
                value: "14.25%",
                valueStyle: AppFonts.f50014Black.copyWith(
                    color: (1 > 0)
                        ? Config.appTheme.defaultProfit
                        : Config.appTheme.defaultLoss),
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget detailsCard() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text("Folio Details",
                style: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.readableGreyTitle)),
          ),
          folioCard(),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Text("Gain/Loss Details",
                style: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.readableGreyTitle)),
          ),
          gainLossCard(),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Text("Cash Flow Summary",
                style: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.readableGreyTitle)),
          ),
          cashFlowCard(),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Text("Transactions",
                style: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.readableGreyTitle)),
          ),
          listCard(),
          SizedBox(
            height: 16,
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
          SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }

  Container cashFlowCard() {
    return Container(
      width: devWidth,
      margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white30,
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: devWidth * 0.36,
                  child:
                      ColumnText(title: "Total Purchase", value: "₹15,00,000")),
              ColumnText(
                title: "Total Switch In",
                value: "₹2,00,000",
                alignment: CrossAxisAlignment.start,
              ),
            ],
          ),
          DottedLine(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: devWidth * 0.36,
                  child: ColumnText(title: "Total Redemption", value: "₹0")),
              ColumnText(
                title: "Total Switch Out",
                value: "₹25,569",
                alignment: CrossAxisAlignment.start,
              ),
            ],
          ),
          DottedLine(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: devWidth * 0.36,
                  child:
                      ColumnText(title: "Dividend Reinvestment", value: "₹0")),
              ColumnText(
                title: "Dividend Payout",
                value: "₹25,569",
                alignment: CrossAxisAlignment.start,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container gainLossCard() {
    return Container(
      width: devWidth,
      margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white30,
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: devWidth * 0.36,
                  child: ColumnText(
                      title: "Unrealised Gain", value: "₹25,00,000 (85.34%)")),
              ColumnText(
                title: "Realised Gain",
                value: "₹2,00,000",
                alignment: CrossAxisAlignment.start,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container folioCard() {
    return Container(
      width: devWidth,
      margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white30,
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: devWidth * 0.36,
                  child:
                      ColumnText(title: "Folio Number", value: "1234567890")),
              ColumnText(
                title: "Start Date",
                value: "13 Dec 2023",
                alignment: CrossAxisAlignment.start,
              ),
            ],
          ),
          DottedLine(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: devWidth * 0.36,
                  child: ColumnText(title: "Total Units", value: "123.456")),
              ColumnText(
                title: "NAV as on 2 Jan 2024",
                value: "345.5697",
                alignment: CrossAxisAlignment.start,
              ),
            ],
          ),
          DottedLine(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  width: devWidth * 0.36,
                  child: ColumnText(title: "Avg Days", value: "45 days")),
              ColumnText(
                title: "Avg NAV",
                value: "145.5697",
                alignment: CrossAxisAlignment.start,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getCancelApplyButton(ButtonType type) {
    if (type == ButtonType.plain)
      return PlainButton(
        color: Config.appTheme.buttonColor,
        padding: EdgeInsets.symmetric(horizontal: devWidth * 0.09),
        text: "SELL FUND",
        onPressed: () {},
      );
    else
      return RpFilledButton(
        color: Config.appTheme.buttonColor,
        padding: EdgeInsets.symmetric(horizontal: devWidth * 0.09),
        text: "INVEST MORE",
        onPressed: () {},
      );
  }

  Widget listCard() {
    return Container(
      color: Config.appTheme.mainBgColor,
      child: ListView.builder(
        itemCount: 7,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return listContentCard(index);
        },
      ),
    );
  }

  Widget listContentCard(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: GestureDetector(
        onTap: () {},
        child: Card(
          elevation: 0,
          color: Colors.white,
          child: Column(
            children: [
              //1st row
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RpChip(label: "Fresh Lumpsum"),
                    Text(
                      "₹10,00,000",
                      style: AppFonts.f50014Black.copyWith(
                          color: (2 > 0)
                              ? Config.appTheme.defaultProfit
                              : Config.appTheme.defaultLoss),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              //2nd row
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColumnText(
                      title: "Date",
                      value: "2 Nov 2023",
                    ),
                    ColumnText(
                      title: "NAV",
                      value: "33.177",
                      alignment: CrossAxisAlignment.center,
                    ),
                    ColumnText(
                      title: "Units",
                      value: "27,641.872",
                      alignment: CrossAxisAlignment.end,
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
}
