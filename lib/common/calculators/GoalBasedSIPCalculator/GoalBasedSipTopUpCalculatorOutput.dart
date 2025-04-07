import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/ShareWidget.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:mymfbox2_0/advisor/sip/SipDashboard.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../../Investor/sipPortfolioSummary/SipPortfolioSummary.widgets.dart';
import '../../../pojo/UserDataPojo.dart';

class GoalBasedSipTopUpCalculatorOutput extends StatefulWidget {
  const GoalBasedSipTopUpCalculatorOutput(
      {super.key,
      required this.goalBasedSipTopUpResult,
      required this.goalBasedAnnualtopUp});
  final Map goalBasedSipTopUpResult;
  final String goalBasedAnnualtopUp;

  @override
  State<GoalBasedSipTopUpCalculatorOutput> createState() =>
      _GoalBasedSipTopUpCalculatorState();
}

class _GoalBasedSipTopUpCalculatorState
    extends State<GoalBasedSipTopUpCalculatorOutput> {
  late double devHeight, devWidth;
  late Map goalBasedSipTopUpResult;
  late String goalBasedAnnualtopUp = "";
  List<dynamic> data = [];
  String client_name = GetStorage().read("client_name");
  int type_id = GetStorage().read("type_id");
  UserDataPojo userDataPojo = UserDataPojo();

  @override
  void initState() {

    //  implement initState
    super.initState();
    goalBasedSipTopUpResult = widget.goalBasedSipTopUpResult;
    goalBasedAnnualtopUp = widget.goalBasedAnnualtopUp;
  }

  String getFirst22(String text) {
    String s = text.split(":").first;
    if (s.length > 22) s = '${s.substring(0, 22)}...';
    return s;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    data = goalBasedSipTopUpResult['list'];
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: getFirst22("Goal Based SIP Top Up Calculator"),
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white,
          actions: [
            if ((type_id == UserType.ADMIN) && (!keys.contains("adminAsInvestor")))
            GestureDetector(
                onTap: () {
                  String url =
                      "${ApiConfig.apiUrl}/download/downloadExpensePlannerCalcResult?key=${ApiConfig.apiKey}&"
                      "goal_amount=${goalBasedSipTopUpResult['goal_amount']}&"
                      "expected_rate_of_return=${goalBasedSipTopUpResult['expected_rate_of_return']}"
                      "&investment_period=${goalBasedSipTopUpResult['investment_period']}"
                      "&sip_topup_value=$goalBasedAnnualtopUp"
                      "&client_name=$client_name";
                  print("downloadExpensePlannerCalcResult $url");
                  SharedWidgets().shareBottomSheet(context, url);
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
                          "Target Amount (Inflation Adjusted)",
                          style: AppFonts.f40013,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$rupee ${Utils.formatNumber(goalBasedSipTopUpResult['target_amount'], isAmount: false)}",
                          style: AppFonts.f50014Black.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                    DottedLine(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ColumnText(
                            title: "Period",
                            value:
                                "${Utils.formatNumber(goalBasedSipTopUpResult['investment_period'])} Years"),
                        ColumnText(
                          title: "Exp Return",
                          value:
                              "${goalBasedSipTopUpResult['expected_rate_of_return']} %",
                          alignment: CrossAxisAlignment.end,
                        ),
                      ],
                    ),
                    DottedLine(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('With Annual Top Up : $goalBasedAnnualtopUp%',
                            style: AppFonts.f50012)
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: AppFonts.f50014Black, // Default text style
                        children: [
                          TextSpan(
                            text: "Monthly SIP Required",
                          ),
                          TextSpan(
                              text: "\n(For the First Year)",
                              style: AppFonts.f40013),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "$rupee ${Utils.formatNumber(goalBasedSipTopUpResult['sip_amount'], isAmount: false)}",
                    style: AppFonts.f70024
                        .copyWith(fontSize: 18, color: Color(0xff3CB66D)),
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
            Container(
              width: devWidth,
              margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
              padding: EdgeInsets.all(4.0), //
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "SIP Calculator Top Up Amount Invested Summary",
                    style: AppFonts.f40013,
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return yearTile(index);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget yearTile(int index) {
    return Container(
      width: devWidth,
      margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
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
              Text(
                '${data[index]['year']}',
                style: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.themeColor),
              ),
              RichText(
                text: TextSpan(
                  text:
                      '$rupee ${Utils.formatNumber(data[index]['sip_amount_per_month'], isAmount: false)}',
                  style: AppFonts.f50014Black,
                  children: <TextSpan>[
                    TextSpan(
                      text: '/ Month',
                      style: AppFonts.f40013,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Invested Amount",
                style: AppFonts.f40013,
              ),
              Text(
                "Invested / Year",
                style: AppFonts.f40013,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '$rupee ${Utils.formatNumber(data[index]['total_invested_amount'], isAmount: false)}',
                  style: AppFonts.f50014Black,
                ),
              ),
              Text(
                '$rupee ${Utils.formatNumber(data[index]['invested_amount_per_year'], isAmount: false)}',
                style: AppFonts.f50014Black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getBroadCategory() {
    List<SipData> chartData = [];

    chartData.add(SipData(
      category: 'Total Amount Invested',
      percentage: goalBasedSipTopUpResult['invested_amount'].toDouble(),
    ));

    chartData.add(SipData(
      category: 'Total Growth Amount',
      percentage: goalBasedSipTopUpResult['growth_value'].toDouble(),
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
                  SizedBox(width: 5),
                  SizedBox(
                    width: 180,
                    child: RichText(
                      text: TextSpan(
                        style: AppFonts.f50014Black, // Default text style
                        children: [
                          TextSpan(
                            text: "${sipData.category}",
                          ),
                          if (index == 0)
                            TextSpan(
                                text:
                                    "\n(Through SIP In ${goalBasedSipTopUpResult['investment_period']} Years)",
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
