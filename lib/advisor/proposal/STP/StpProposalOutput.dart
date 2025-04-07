import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/rp_widgets/ShareWidget.dart';
import 'package:mymfbox2_0/utils/Config.dart';

import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/TransferCircle.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';

class StpProposalOutput extends StatefulWidget {
  const StpProposalOutput(
      {super.key,
      required this.result,
      required this.userId,
      required this.clientName,
      required this.name,
      required this.horizon,
      required this.fromScheme,
      required this.toscheme,
      required this.fromSchemeLogo,
      required this.toschemeLogo,
      required this.lumpsumAmt,
      required this.stpAmt,
      required this.stpFromReturn,
      required this.stpToReturn,
      required this.stpMonths,
      required this.stpFrequency,
      required this.invPurpose});
  final int userId;
  final String clientName;
  final String name;
  final num horizon;
  final String fromScheme;
  final String toscheme;
  final String fromSchemeLogo;
  final String toschemeLogo;
  final num lumpsumAmt;
  final num stpAmt;
  final num stpFromReturn;
  final num stpToReturn;
  final num stpMonths;
  final String stpFrequency;
  final String invPurpose;

  final Map result;
  @override
  State<StpProposalOutput> createState() => _StpProposalOutputState();
}

class _StpProposalOutputState extends State<StpProposalOutput> {
  String client_name = GetStorage().read("client_name");
  int user_id = 1;
  late double devHeight, devWidth;

  late Map result, summary;

  final List schemeTypeList = [
    "From Scheme \n Cash Flow",
    "To Scheme \n Cash Flow",
  ];

  String selectedCategory = "From Scheme \n Cash Flow";

  late num stpAmount, stpMonths, stpTotal;
  late String lumpsumAmt, totalProfit;
  late String s1StartBal, s2StartBal;
  late String s1EndBal, s2EndBal;

  String selectedFlow = "from";

  int userId = 0;
  String clientName = "";
  String name = "";
  num horizon = 0;
  String fromScheme = "";
  String toscheme = "";
  String fromSchemeLogo = "";
  String toschemeLogo = "";
  num lumpsumAmtShare = 0;
  num stpAmt = 0;
  num stpFromReturn = 0;
  num stpToReturn = 0;
  num stpMonthsshare = 0;
  String stpFrequency = "";
  String invPurpose = "";

  @override
  void initState() {
    //  implement initState
    super.initState();
    result = widget.result;
    summary = result['summary'];
    stpAmount = summary['stp_amount'];
    stpMonths = summary['stp_months'];
    stpMonths = stpMonths.round();
    stpTotal = stpAmount * stpMonths;
    lumpsumAmt = Utils.formatNumber(summary['lumpsum_amount']);
    totalProfit = Utils.formatNumber(summary['total_profit']);

    s1StartBal = Utils.formatNumber(summary['scheme1_balance']);
    s2StartBal = Utils.formatNumber(summary['scheme2_balance']);

    s1EndBal = Utils.formatNumber(summary['scheme1_balance_end']);
    s2EndBal = Utils.formatNumber(summary['scheme2_balance_end']);

    userId = widget.userId;
    clientName = widget.clientName;
    name = widget.name;
    horizon = widget.horizon;
    fromScheme = widget.fromScheme;
    toscheme = widget.toscheme;
    fromSchemeLogo = widget.fromSchemeLogo;
    toschemeLogo = widget.toschemeLogo;
    lumpsumAmtShare = widget.lumpsumAmt;
    stpAmt = widget.stpAmt;
    stpFromReturn = widget.stpFromReturn;
    stpToReturn = widget.stpToReturn;
    stpMonthsshare = widget.stpMonths;
    stpFrequency = widget.stpFrequency;
    invPurpose = widget.invPurpose;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "STP Proposal",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white,
          actions: [
            GestureDetector(
              onTap: () {
                String url = "";
                url =
                    "${ApiConfig.apiUrl}/download/downloadInvestmentSTPProposalPDF?key=${ApiConfig.apiKey}&"
                    "client_name=$clientName"
                    "&name=$name"
                    "&horizon=$horizon"
                    "&stp_from_scheme_name=$fromScheme"
                    "&stp_to_scheme_name=$toscheme&stp_lumpsum_amount=$lumpsumAmtShare"
                    "&stp_amount=$stpAmt&stp_from_return=$stpFromReturn&stp_to_return=$stpToReturn"
                    "&stp_months=$stpMonthsshare&stp_frequency=$stpFrequency&inv_purpose=$invPurpose";
                print("downloadInvestmentSTPProposalPDF $url");

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
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("STP Summary", style: AppFonts.f50014Grey),
              SizedBox(height: 8),
              stpSummaryCard(),
              SizedBox(height: 16),
              Text("Scheme Summary", style: AppFonts.f50014Grey),
              SizedBox(height: 8),
              schemeSummaryCard(),
              SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: getButton("from"),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: getButton("to"),
                    )
                  ],
                ),
              ),
              (result['${selectedFlow}_scheme_cash_flow_list'].length <= 0)
                  ? NoData()
                  : SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount:
                    result['${selectedFlow}_scheme_cash_flow_list'].length,
                itemBuilder: (context, index) {
                  List list = result['${selectedFlow}_scheme_cash_flow_list'];
                  Map data = list[index];
                  return cashFlowCard(index, data);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget schemeSummaryCard() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16), // Add padding
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
              //Image.network(fromSchemeLogo, height: 32),
              Utils.getImage(fromSchemeLogo, 32),
              // Image.network(toschemeLogo, height: 32),
              Utils.getImage(toschemeLogo, 32),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 120,
                  child: Text(fromScheme,
                      style: AppFonts.f50014Black
                          .copyWith(color: Config.appTheme.themeColor))),
              TransferCircle(),
              SizedBox(
                  width: 120,
                  child: Text(
                    toscheme,
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor),
                    textAlign: TextAlign.end,
                  )),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Expected Return",
                  value: "${summary['from_return']}%"),
              ColumnText(
                  title: "Expected Return",
                  value: "${summary['to_return']}%",
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(title: "Starting Balance", value: "₹ $s1StartBal"),
              ColumnText(
                  title: "Starting Balance",
                  value: "$rupee $s2StartBal",
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(title: "Balance after STP", value: "₹ $s1EndBal"),
              ColumnText(
                  title: "Balance after STP",
                  value: "$rupee $s2EndBal",
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(title: "Final Balance", value: "₹38,27,969 "),
              ColumnText(
                  title: "Final Balance",
                  value: "₹1,16,456",
                  alignment: CrossAxisAlignment.end),
            ],
          ),
        ],
      ),
    );
  }

  Widget getButton(String flow) {
    String tempFlow = flow.capitalizeFirst ?? "";

    if (selectedFlow == flow)
      return RpFilledButton(
        text: "$tempFlow Scheme \n Cash Flow",
        padding: EdgeInsets.zero,
      );
    else
      return PlainButton(
          text: "$tempFlow Scheme \n Cash Flow",
          padding: EdgeInsets.zero,
          onPressed: () {
            selectedFlow = flow;
            setState(() {});
          });
  }

  Widget cashFlowCard(int index, Map data) {
    String withdrawAmt = Utils.formatNumber(data['withdrawal_amt']);
    String startBalance = Utils.formatNumber(data['balance_amt']);
    String gain = Utils.formatNumber(data['interest_earned']);
    String endBalance = Utils.formatNumber(data['month_end_balance']);

    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
      padding: EdgeInsets.all(16), // Add padding
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
                "STP OUT: ${index + 1}",
                style: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.themeColor),
              ),
              RichText(
                text: TextSpan(
                  text: '$rupee $withdrawAmt',
                  style: AppFonts.f50014Black,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Balance at Start", value: "$rupee $startBalance"),
              ColumnText(
                  title: "Gain",
                  value: "$rupee $gain",
                  alignment: CrossAxisAlignment.center),
              ColumnText(
                  title: "Balance at End",
                  value: "$rupee $endBalance",
                  alignment: CrossAxisAlignment.end),
            ],
          ),
        ],
      ),
    );
  }

  Widget stpSummaryCard() {
    return Container(
      padding: EdgeInsets.all(16), // Add padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ColumnText(
                  title: "Monthly STP",
                  value: "$rupee ${Utils.formatNumber(stpAmount)}"),
            ],
          ),
          DottedLine(verticalPadding: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(title: "Monthly Installments", value: "$stpMonths"),
              ColumnText(
                title: "Total Transferred",
                value: "$rupee ${Utils.formatNumber(stpTotal)}",
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
          DottedLine(verticalPadding: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(title: "Initial Lumpsum", value: "$rupee $lumpsumAmt"),
              ColumnText(
                title: "Total Profit",
                value: "$rupee $totalProfit",
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String title;
  final int index;
  final bool isSelected;
  final VoidCallback onPressed;

  const MyButton({
    Key? key,
    required this.title,
    required this.index,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          isSelected ? Config.appTheme.themeColor : Colors.white,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          isSelected ? Colors.white : Config.appTheme.themeColor,
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: isSelected
                  ? Config.appTheme.themeColor
                  : Config.appTheme.themeColor,
            ),
          ),
        ),
        // Set minimum width for the button
        minimumSize: MaterialStateProperty.all<Size>(
          Size(146, 36), // Adjust width and height as needed
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          if (title == "Category")
            Icon(Icons.keyboard_arrow_down,
                color: isSelected
                    ? Colors.white
                    : Config.appTheme
                        .themeColor), // Change icon color based on selection
        ],
      ),
    );
  }
}
