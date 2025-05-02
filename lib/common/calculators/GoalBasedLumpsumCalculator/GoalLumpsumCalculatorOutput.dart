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

class GoalLumpsumCalculatorOutput extends StatefulWidget {
  const GoalLumpsumCalculatorOutput({
    super.key,
    required this.goalBasedLumpsumResult,
  });

  final Map goalBasedLumpsumResult;

  @override
  State<GoalLumpsumCalculatorOutput> createState() =>
      _GoalLumpsumCalculatorOutputState();
}

class _GoalLumpsumCalculatorOutputState
    extends State<GoalLumpsumCalculatorOutput> {
  late double devHeight, devWidth;
  late Map goalBasedLumpsumResult;
  String client_name = GetStorage().read("client_name");
  int type_id = GetStorage().read("type_id");
  UserDataPojo userDataPojo = UserDataPojo();

  @override
  void initState() {
    //  implement initState
    super.initState();
    goalBasedLumpsumResult = widget.goalBasedLumpsumResult;
  }

  String getFirst18(String text) {
    String s = text.split(":").first;
    if (s.length > 18) s = '${s.substring(0, 18)}...';
    return s;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: getFirst18("Goal Based Lumpsum Calculator"),
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white,
          actions: [
            if ((type_id == UserType.ADMIN) &&
                (!keys.contains("adminAsInvestor")))
              GestureDetector(
                  onTap: () {
                    String url =
                        "${ApiConfig.apiUrl}/download/downloadLumpsumTargetCalcResult?key=${ApiConfig.apiKey}&"
                        "target_amount=${goalBasedLumpsumResult['target_amount']}&"
                        "expected_return=${goalBasedLumpsumResult['expected_return']}"
                        "&years=${goalBasedLumpsumResult['years']}&client_name=$client_name";
                    print("downloadLumpsumTargetCalcResult $url");
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
                          "Your Targeted Amount",
                          style: AppFonts.f40013,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$rupee ${Utils.formatNumber(goalBasedLumpsumResult['target_amount'], isAmount: false)}",
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
                            value: "${goalBasedLumpsumResult['years']} Years"),
                        ColumnText(
                          title: "Exp Return",
                          value:
                              "${goalBasedLumpsumResult['expected_return']} %",
                          alignment: CrossAxisAlignment.end,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            /* DEBARYA sir comment -
            Container(
              width: devWidth,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                      "Lumpsum Investment Required",
                      style: AppFonts.f50014Black,
                    ),
                  ),
                  Text(
                    rupee +
                        Utils.formatNumber(
                            goalBasedLumpsumResult['lumpsum_amount'],
                            isAmount: false),
                    style: AppFonts.f70024
                        .copyWith(fontSize: 18, color: Color(0xff3CB66D)),
                  ),
                ],
              ),
            ),*/
            Container(
              width: devWidth,
              margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
              padding: EdgeInsets.all(4.0),
              // Add padding
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

    int growthAmount = 0;
    growthAmount = goalBasedLumpsumResult['target_amount'];
        // -
        // goalBasedLumpsumResult['lumpsum_amount'];
    chartData.add(SipData(
      category: 'Lumpsum Investment Amount',
      percentage: goalBasedLumpsumResult['lumpsum_amount'].toDouble(),
    ));

    chartData.add(SipData(
      category: 'Your Targeted Amount',
      percentage: growthAmount.toDouble(),
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
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 200,
                    child: RichText(
                      text: TextSpan(
                        style: AppFonts.f50014Black, // Default text style
                        children: [
                          TextSpan(
                            text: "${sipData.category}" ,style: AppFonts.f50014Black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    "$rupee ${Utils.formatNumber(sipData.percentage)}",
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
