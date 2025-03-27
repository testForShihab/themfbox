import 'package:flutter/material.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';

import '../../rp_widgets/InvAppBar.dart';

class GainLossReport extends StatefulWidget {
  const GainLossReport({super.key});

  @override
  State<GainLossReport> createState() => _GainLossReportState();
}

class _GainLossReportState extends State<GainLossReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: invAppBar(
        // toolbarHeight: 200,
        title: "Gain Loss Report",
        // bottomSpace: topFilterArea(),
      ),
      /*rpAppBar(
        title: "Gain Loss Report",
        bgColor: Config.appTheme.themeColor,
        foregroundColor: Colors.white,
      ),*/
      body: SingleChildScrollView(
          child: Column(
        children: [
          topCard(),
          blackCard(),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return schemeCard();
            },
            separatorBuilder: (BuildContext context, int index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DottedLine(),
            ),
          )
        ],
      )),
    );
  }

  Widget topCard() {
    return Container(
      color: Config.appTheme.themeColor,
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Gain/Loss",
                  style: AppFonts.f40013,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$rupee 50,953",
                  style: AppFonts.f70018Green.copyWith(
                      fontSize: 24, color: Config.appTheme.themeColor),
                ),
              ],
            ),
            DottedLine(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColumnText(title: "Long Term Gain", value: "$rupee 27,599"),
                    ColumnText(
                      title: "Short Term Gain",
                      value: "$rupee 23,599",
                      alignment: CrossAxisAlignment.center,
                    ),
                    ColumnText(
                      title: "Slab Rate G/L",
                      value: "$rupee 23,354",
                      alignment: CrossAxisAlignment.end,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget blackCard() {
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
              // First row, three columns
              Expanded(
                child: Text('',
                    style:
                        AppFonts.f40013.copyWith(color: AppColors.lineColor)),
              ),
              Expanded(
                child: Text('Long Term',
                    style:
                        AppFonts.f40013.copyWith(color: AppColors.lineColor)),
              ),
              Expanded(
                child: Text('Short Term',
                    style:
                        AppFonts.f40013.copyWith(color: AppColors.lineColor)),
              ),
            ],
          ),
          SizedBox(height: 8), // Add spacing between rows

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Second row, three columns
              Expanded(
                child: Text('Sell',
                    style:
                        AppFonts.f40013.copyWith(color: AppColors.lineColor)),
              ),
              Expanded(
                child: Text('₹7,27,599',
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
              Expanded(
                child: Text('₹0',
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 8), // Add spacing between rows
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Third row, three columns
              Expanded(
                child: Text('Purchase',
                    style:
                        AppFonts.f40013.copyWith(color: AppColors.lineColor)),
              ),
              Expanded(
                child: Text('₹6,99,965',
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
              Expanded(
                child: Text('₹0',
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
            ],
          ),
          DottedLine(verticalPadding: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Third row, three columns
              Expanded(
                child: Text('Gain/Loss',
                    style:
                        AppFonts.f40013.copyWith(color: AppColors.lineColor)),
              ),
              Expanded(
                child: Text('₹27,599',
                    style:
                        AppFonts.f50012.copyWith(color: AppColors.textGreen)),
              ),
              Expanded(
                child: Text('₹0',
                    style: AppFonts.f50012.copyWith(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget schemeCard() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset("assets/48.png", height: 32),
              SizedBox(width: 10),
              Expanded(
                  child: Text("Kotak Banking & Financial Services Fund Growth",
                      style: AppFonts.f50014Black)),
              Icon(Icons.arrow_forward_ios,
                  size: 18, color: AppColors.arrowGrey)
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 42, top: 5, bottom: 10),
            child: Text("Folio : 1234", style: AppFonts.f40013),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(title: "Total G/L", value: "$rupee 25,42,000"),
              ColumnText(
                title: "STCG",
                value: "$rupee 23,10,000",
                alignment: CrossAxisAlignment.center,
              ),
              ColumnText(
                title: "LTCG",
                value: "12.44%",
                alignment: CrossAxisAlignment.end,
              ),
            ],
          )
        ],
      ),
    );
  }
}
