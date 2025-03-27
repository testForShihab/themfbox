import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class Newfundofferingdetails extends StatefulWidget {
  const Newfundofferingdetails({super.key});

  @override
  State<Newfundofferingdetails> createState() => _NewfundofferingdetailsState();
}

class _NewfundofferingdetailsState extends State<Newfundofferingdetails> {
  String client_name = GetStorage().read('client_name');
  int user_id = GetStorage().read('mfd_id');
  late double devWidth, devHeight;
  TextStyle underlineText = TextStyle(
      color: Config.appTheme.themeColor,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w400,
      fontSize: 14);
  String category = "Equity • Sectoral / Thematic";

  Future getDatas() async {}
  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: AppBar(
              backgroundColor: Config.appTheme.themeColor,
              leadingWidth: 0,
              toolbarHeight: 100,
              foregroundColor: Colors.white,
              elevation: 0,
              leading: SizedBox(),
              title: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: Icon(Icons.arrow_back),
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/48.png", height: 32),
                      //  Image.network(schemeLogo, height: 32),
                      SizedBox(width: 8),
                      Expanded(
                        child: ColumnText(
                          title:
                              "Kotak India Manufacturing Fund India Manufacturing Fund",
                          value:
                              "${category.replaceAll(":", " •")} • High Risk",
                          titleStyle: AppFonts.f50014Black
                              .copyWith(fontSize: 18, color: Colors.white),
                          valueStyle:
                              AppFonts.f40013.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            body: displayPage(),
          );
        });
  }

  Widget displayPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 180,
                        child: ColumnText(
                          title: "NFO Opens On",
                          value: "7 Dec 2023",
                        ),
                      ),
                      ColumnText(
                        title: "NFO Closes On",
                        value: "22 Dec 2023",
                      ),
                    ],
                  ),
                  DottedLine(verticalPadding: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 180,
                        child: ColumnText(
                          title: "Min Lumpsum",
                          value:
                              "$rupee ${Utils.formatNumber(5000, isAmount: false)}",
                        ),
                      ),
                      ColumnText(
                        title: "Min SIP",
                        value:
                            "$rupee ${Utils.formatNumber(500, isAmount: false)}",
                      ),
                    ],
                  ),
                  DottedLine(verticalPadding: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ColumnText(
                        title: "Benchmark",
                        value: "Nifty 500 Multicap 50:25:25 TRI",
                      ),
                    ],
                  ),
                  DottedLine(verticalPadding: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ColumnText(
                        title: "Fund Manager",
                        value: "Shreyas Gupta",
                      ),
                    ],
                  ),
                  DottedLine(verticalPadding: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        // Wrap with Expanded
                        child: ColumnText(
                          title: "Investment Objective",
                          value:
                              "Most consistent funds consisting of Top 10 Mutual Fund Schemes in each category have been chosen based on average rolling returns and consistency with which funds have beaten category average returns.",
                        ),
                      ),
                    ],
                  ),
                  DottedLine(verticalPadding: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // rpDownloadFile(url: factsheetLink, context: context);
                        },
                        child: Text(
                          "Scheme Information Document",
                          style: underlineText,
                        ),
                      ),
                      SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          // Get.to(WebviewContent(
                          //   webViewTitle: schemeName,
                          //   disqusUrl: portfolioLink,
                          // ));
                        },
                        child: Text(
                          "KIM Document",
                          style: underlineText,
                        ),
                      ),
                    ],
                  ),
                  DottedLine(verticalPadding: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ColumnText(
                        title: "Exit Load",
                        value: "Exit load of 1%, if redeemed within 1 month.",
                      ),
                    ],
                  ),
                  DottedLine(verticalPadding: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        // Wrap with Expanded
                        child: ColumnText(
                          title: "Tax Implication",
                          value:
                              "Returns are taxed at 15%, if you redeem before one year. After 1 year, you are required to pay LTCG tax of 10% on returns of Rs 1 lakh+ in a financial year.",
                        ),
                      ),
                    ],
                  ),
                  DottedLine(verticalPadding: 4),
                  Text(
                    "Risk-O-Meter",
                    style: AppFonts.f40013.copyWith(color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 220,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/risko_meter_low.png",
                          fit: BoxFit.fitWidth,
                          errorBuilder: (context, error, stackTrace) {
                            return Placeholder();
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget riskometerCard() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Image.asset("assets/48.png", height: 32),
          // Image.network(
          //   riskometerImage,
          //   height: 220,
          // ),
        ],
      ),
    );
  }
}
