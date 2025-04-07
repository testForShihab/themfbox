import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/rp_widgets/ShareWidget.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';

import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class SwpProposalOutput extends StatefulWidget {
  const SwpProposalOutput({
    super.key,
    required this.swpResult,
    required this.swpSchemeName,
    required this.swpAmt,
    required this.swpExpectedReturn,
    required this.swpPeriod,
    required this.swpSchemeLogo,
    required this.lumpsumAmount,
    required this.swpFrequency,
    required this.clientName,
    required this.invPurpose,
  });
  final Map swpResult;
  final String swpSchemeName,
      swpSchemeLogo,
      swpFrequency,
      clientName,
      invPurpose;
  final num swpAmt;
  final num swpExpectedReturn;
  final num swpPeriod;
  final num lumpsumAmount;

  @override
  State<SwpProposalOutput> createState() => _SwpProposalOutputState();
}

class _SwpProposalOutputState extends State<SwpProposalOutput> {
  String client_name = GetStorage().read("client_name");
  int user_id = GetStorage().read("mfd_id");

  late Map summary;

  late num swpAmt, swpExpectedReturn, swpPeriod, lumpsumAmount;
  late String totalWithdrawal,
      totalProfit,
      balanceAtEnd,
      initialLumpsum,
      swpSchemeName;
  String swpFrequency = "";
  String clientName = "";
  String invPurpose = "";
  List<dynamic> swpCashFlowData = [];

  @override
  void initState() {
    //  implement initState
    super.initState();
    summary = widget.swpResult['summary'];
    swpSchemeName = widget.swpSchemeName;
    swpAmt = widget.swpAmt;
    swpExpectedReturn = widget.swpExpectedReturn;
    swpPeriod = widget.swpPeriod;
    lumpsumAmount = widget.lumpsumAmount;
    totalWithdrawal = Utils.formatNumber(summary['total_withdrawal']);
    initialLumpsum = "";
    totalProfit = Utils.formatNumber(summary['total_profit'].round());
    balanceAtEnd = Utils.formatNumber(summary['balance_end'].round());
    swpCashFlowData = widget.swpResult['cash_flow_list'];

    swpFrequency = widget.swpFrequency;
    clientName = widget.clientName;
    invPurpose = widget.invPurpose;
  }

  late double devHeight, devWidth;

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "SWP Proposal",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white,
          actions: [
            GestureDetector(
              onTap: () {
                String url = "";
                url =
                    "${ApiConfig.apiUrl}/download/downloadInvestmentSWPProposalPDF?key=${ApiConfig.apiKey}&"
                    "client_name=$clientName"
                    "&name=$clientName"
                    "&horizon=$swpPeriod"
                    "&swp_scheme_name=$swpSchemeName"
                    "&swp_lumpsum_amount=$lumpsumAmount&swp_amount=$swpAmt&swp_return=$swpExpectedReturn"
                    "&swp_frequency=$swpFrequency&invPurpose=$invPurpose";
                print("downloadInvestmentSWPProposalPDF $url");

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
              Text("SWP Summary", style: AppFonts.f50014Grey),
              SizedBox(height: 10),
              Container(
                width: devWidth,
                padding: EdgeInsets.all(16.0), // Add padding
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        //Image.network(widget.swpSchemeLogo, height: 32),
                        Utils.getImage(widget.swpSchemeLogo, 32),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(swpSchemeName,
                              style: AppFonts.f50014Grey
                                  .copyWith(color: Colors.black)),
                        )
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ColumnText(
                            title: "Monthly SWP Amount",
                            value: rupee + Utils.formatNumber(swpAmt)),
                        ColumnText(
                          title: "Expected Return",
                          value: "${swpExpectedReturn.toStringAsFixed(2)}%",
                          alignment: CrossAxisAlignment.end,
                        ),
                      ],
                    ),
                    DottedLine(verticalPadding: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ColumnText(
                            title: "Monthly Installments", value: "$swpPeriod"),
                        ColumnText(
                          title: "Total Withdrawal",
                          value: "$rupee $totalWithdrawal",
                          alignment: CrossAxisAlignment.end,
                        ),
                      ],
                    ),
                    DottedLine(verticalPadding: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ColumnText(
                            title: "Initial Lumpsum",
                            value: rupee + Utils.formatNumber(lumpsumAmount)),
                        ColumnText(
                          title: "Total Profit",
                          value: "$rupee $totalProfit",
                          alignment: CrossAxisAlignment.end,
                        ),
                      ],
                    ),
                    DottedLine(verticalPadding: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ColumnText(
                            title: "Balance at End",
                            value: "$rupee $balanceAtEnd"),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text("SWP Cash Flow", style: AppFonts.f50014Grey),
              SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: swpCashFlowData.length,
                itemBuilder: (context, index) {
                  return swpCashFlow(index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget swpCashFlow(int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
      padding: EdgeInsets.all(16.0),
      // Add padding
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
                "Monthly SWP: ${index + 1}",
                style: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.themeColor),
              ),
              Text(
                "$rupee ${Utils.formatNumber(swpCashFlowData[index]['withdrawal_amt'], isAmount: false)}",
                style: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.themeColor),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Balance at Start",
                value: rupee +
                    Utils.formatNumber(swpCashFlowData[index]['balance_amt'],
                        isAmount: false),
              ),
              ColumnText(
                title: "Gain",
                value: rupee +
                    Utils.formatNumber(
                        swpCashFlowData[index]['interest_earned'],
                        isAmount: false),
                alignment: CrossAxisAlignment.center,
              ),
              ColumnText(
                title: "Balance at End",
                value: rupee +
                    Utils.formatNumber(
                        swpCashFlowData[index]['month_end_balance'],
                        isAmount: false),
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
