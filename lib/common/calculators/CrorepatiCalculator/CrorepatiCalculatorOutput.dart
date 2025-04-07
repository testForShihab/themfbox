import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/ShareWidget.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:mymfbox2_0/advisor/sip/SipDashboard.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import 'package:mymfbox2_0/api/ApiConfig.dart';

import '../../../Investor/sipPortfolioSummary/SipPortfolioSummary.widgets.dart';
import '../../../pojo/UserDataPojo.dart';

class CrorepatiCalculatorOutput extends StatefulWidget {
  const CrorepatiCalculatorOutput({
    super.key,
    required this.crorepatiCalculatorResult,
  });
  final Map crorepatiCalculatorResult;

  @override
  State<CrorepatiCalculatorOutput> createState() =>
      _CrorepatiCalculatorOutputState();
}

class _CrorepatiCalculatorOutputState extends State<CrorepatiCalculatorOutput> {
  late double devHeight, devWidth;
  late Map crorepatiCalculatorResult;
  String client_name = GetStorage().read("client_name");
  int type_id = GetStorage().read("type_id");
  UserDataPojo userDataPojo = UserDataPojo();
  @override
  void initState() {
    //  implement initState
    super.initState();
    crorepatiCalculatorResult = widget.crorepatiCalculatorResult;
    print("age ${crorepatiCalculatorResult['a']}");
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    int finalTargetAmount = 0;
    finalTargetAmount = crorepatiCalculatorResult['target_amount'];
    print("finalTargetAmount$finalTargetAmount");

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Crorepati Calculator",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white,
          actions: [
            if ((type_id == UserType.ADMIN) &&
                (!keys.contains("adminAsInvestor")))
              GestureDetector(
                  onTap: () {
                    String url =
                        "${ApiConfig.apiUrl}/download/downloadCrorepatiCalcResult?key=${ApiConfig.apiKey}"
                        "&current_age=${crorepatiCalculatorResult['current_age']}"
                        "&retirement_age=${crorepatiCalculatorResult['retirement_age']}"
                        "&wealth_amount=${crorepatiCalculatorResult['wealth_amount']}"
                        "&inflation_rate=${crorepatiCalculatorResult['inflation_rate']}"
                        "&expected_return=${crorepatiCalculatorResult['expected_return']}"
                        "&savings_amount=${crorepatiCalculatorResult['savings_amount']}&client_name=$client_name";
                    print("downloadCrorepatiCalcResult $url");
                    SharedWidgets().shareBottomSheet(
                      context,
                      url,
                    );
                    //shareBottomSheet();
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Icon(Icons.share))),
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Config.appTheme.themeColor,
              width: devWidth,
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                          "Target Amount (Inflation adjusted)",
                          style: AppFonts.f40013,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$rupee ${Utils.formatNumber(crorepatiCalculatorResult['target_wealth'], isAmount: false)}",
                          style: AppFonts.f50014Black.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    DottedLine(),
                    SizedBox(
                      height: 4.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ColumnText(
                            title: "Period",
                            value:
                                "${crorepatiCalculatorResult['years']} Years"),
                        ColumnText(
                          title: "Exp Return",
                          value:
                              "${crorepatiCalculatorResult['expected_return']} %",
                          alignment: CrossAxisAlignment.end,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: devWidth,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: EdgeInsets.all(16.0), // Add padding
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
                      Expanded(
                        child: Text(
                          "Growth of Current Savings",
                          style: AppFonts.f50014Black,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "(${crorepatiCalculatorResult['expected_return']}% per annum)",
                        style: AppFonts.f40013,
                      ),
                      Text(
                        "$rupee ${Utils.formatNumber(crorepatiCalculatorResult['target_savings'], isAmount: false)}",
                        style: AppFonts.f50014Black,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  DottedLine(),
                  SizedBox(
                    height: 4.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Final Target Amount",
                          style: AppFonts.f50014Black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "(Minus growth of current savings)",
                          style: AppFonts.f40013,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "$rupee ${Utils.formatNumber(finalTargetAmount, isAmount: false)}",
                        style: AppFonts.f50014Black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: devWidth,
              margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
              padding: EdgeInsets.all(16.0), // Add padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Monthly SIP Required",
                      style: AppFonts.f50014Black,
                    ),
                  ),
                  Text(
                    "$rupee ${Utils.formatNumber(crorepatiCalculatorResult['monthly_savings'], isAmount: false)}",
                    style: AppFonts.f70018Green,
                  ),
                ],
              ),
            ),
            Container(
              width: devWidth,
              margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
              padding: EdgeInsets.all(4.0), // Add padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [getBroadCategory()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getBroadCategory() {
    List<SipData> chartData = [];

    chartData.add(SipData(
      category: 'Total Amount Invested',
      percentage: crorepatiCalculatorResult['invested_amount'].toDouble(),
    ));

    chartData.add(SipData(
      category: 'Total Growth Amount',
      percentage: crorepatiCalculatorResult['total_earnings'].toDouble(),
    ));

    print("chartData $chartData");

    List<Color> colorPalate = [
      Color(0XFF4155B9),
      Color(0XFF67C587),
      Color(0xFFE79C23),
      Color(0xFF5DB25D),
      Color(0xFFDE5E2F),
      Colors.redAccent,
      Colors.greenAccent,
      Colors.deepPurple,
      Colors.black,
      Colors.teal
    ];
    return Column(
      children: [
        SfCircularChart(
          series: <CircularSeries>[
            PieSeries<SipData, String>(
              dataSource: chartData,
              xValueMapper: (data, _) => data.category,
              yValueMapper: (data, _) => data.percentage,
            ),
          ],
          palette: colorPalate,
          legend: Legend(
              isVisible: false,
              overflowMode: LegendItemOverflowMode.scroll,
              position: LegendPosition.bottom),
        ),
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: chartData.length,
          itemBuilder: (BuildContext context, int index) {
            SipData sipData = chartData.elementAt(index);

            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: colorPalate[index], radius: 6),
                  SizedBox(width: 7),
                  SizedBox(
                    width: 180,
                    child: RichText(
                      text: TextSpan(
                        style: AppFonts.f50014Black, // Default text style
                        children: [
                          TextSpan(
                            text: "${sipData.category}  ",
                          ),
                          if (index == 0)
                            TextSpan(
                                text:
                                    "\n(Through SIP In ${crorepatiCalculatorResult['years']} Years)",
                                style: AppFonts.f40013),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    "$rupee ${Utils.formatNumber(sipData.percentage, isAmount: false)}",
                    style: AppFonts.f50014Black,
                    textAlign: TextAlign.end,
                  )),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return DottedLine();
          },
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
