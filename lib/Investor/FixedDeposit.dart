import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/rp_widgets/BankIcon.dart';

import '../rp_widgets/InvAppBar.dart';

class FixedDeposit extends StatefulWidget {
  const FixedDeposit({super.key});

  @override
  State<FixedDeposit> createState() => _FixedDepositState();
}

class _FixedDepositState extends State<FixedDeposit> {
  late double devHeight, devWidth;
  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: invAppBar(
        // toolbarHeight: 200,
        title: "Fixed Deposit",
        // bottomSpace: topFilterArea(),
      ),
      /*rpAppBar(
          title: "Fixed Deposit",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),*/
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            investmentCard(),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16),
              child: Text("3 Fixed Deposit", style: f40012),
            ),
            bankCard(),
            bankCard(),
            bankCard(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget investmentCard() {
    return Container(
      color: Config.appTheme.themeColor,
      width: devWidth,
      child: Container(
        width: devWidth * 0.78,
        height: devHeight * 0.18,
        margin: EdgeInsets.fromLTRB(16, 10, 16, 16),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Current Value",
                    style: f40012.copyWith(color: AppColors.readableGrey),
                  ),
                  Icon(Icons.arrow_forward, color: Config.appTheme.themeColor)
                ],
              ),
              Text(
                "$rupee 6,60,000",
                style: TextStyle(
                    color: Config.appTheme.themeColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 32),
              ),
              dottedLine(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  columnText("Cost", "$rupee 15.00 L"),
                  columnText("Gain/Loss", "$rupee 15.00 L",
                      alignment: CrossAxisAlignment.center),
                  columnText("XIRR", "$rupee 15.00 L",
                      alignment: CrossAxisAlignment.end),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dottedLine() {
    return SizedBox(
      height: 20,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 100,
        itemBuilder: (context, index) =>
            Text("-", style: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget columnText(String title, String value,
      {CrossAxisAlignment? alignment}) {
    return Column(
      crossAxisAlignment: alignment ?? CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.f40013,
        ),
        Text(value, style: AppFonts.f50014Grey.copyWith(color: Colors.black))
      ],
    );
  }

  Widget bankCard() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            children: [
              BankIcon(),
              SizedBox(width: 10),
              Text("HDFC Bank Limited",
                  style: AppFonts.f50014Grey.copyWith(color: Colors.black)),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    )),
                child: Text(
                  "@7.25%",
                  style: AppFonts.f50014Grey
                      .copyWith(color: Config.appTheme.themeColor),
                ),
              )
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text("Current Value : ", style: f40012),
              Text(
                "$rupee 40,000",
                style: f40012.copyWith(
                    fontSize: 14, color: Config.appTheme.themeColor),
              )
            ],
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    columnText("Cost", "$rupee 15.00 L"),
                    columnText("Gain/Loss", "$rupee 15.00 L",
                        alignment: CrossAxisAlignment.center),
                    columnText("Maturity", "29 Dec 2025",
                        alignment: CrossAxisAlignment.end),
                  ],
                ),
                dottedLine(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    columnText("Intrest Type", "Cumulative"),
                    columnText("Frequency", "Yearly",
                        alignment: CrossAxisAlignment.center),
                    columnText("Maturity Amt", "2.2025",
                        alignment: CrossAxisAlignment.end),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
