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

class LumpsumCalculatorOutput extends StatefulWidget {
  const LumpsumCalculatorOutput({
    super.key,
    required this.lumpsumResult,
  });
  final Map lumpsumResult;

  @override
  State<LumpsumCalculatorOutput> createState() =>
      _LumpsumCalculatorOutputState();
}

class _LumpsumCalculatorOutputState extends State<LumpsumCalculatorOutput> {
  late double devHeight, devWidth;
  late Map lumpsumResult;
  String client_name = GetStorage().read("client_name");
  int type_id = GetStorage().read("type_id");
  UserDataPojo userDataPojo = UserDataPojo();
  @override
  void initState() {
    //  implement initState
    super.initState();
    lumpsumResult = widget.lumpsumResult;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    int futureAmount = 0;
    futureAmount =
        lumpsumResult['lumpsum_amount'] + lumpsumResult['future_amount'];
    print("futureAmount$futureAmount");

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Lumpsum Calculator",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white,
          actions: [
            if ((type_id == UserType.ADMIN) &&
                (!keys.contains("adminAsInvestor")))
              GestureDetector(
                  onTap: () {
                    String url =
                        "${ApiConfig.apiUrl}/download/downloadLumpsumCalcResult?key=${ApiConfig.apiKey}&"
                        "lumpsum_amount=${lumpsumResult['lumpsum_amount']}&"
                        "expected_return=${lumpsumResult['expected_return']}&years=${lumpsumResult['years']}&client_name=$client_name";
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
                        ColumnText(
                            title: "Lumpsum",
                            value:
                                "$rupee ${Utils.formatNumber(lumpsumResult['lumpsum_amount'], isAmount: false)}"),
                        ColumnText(
                          title: "Period",
                          value: "${lumpsumResult['years']} Years",
                          alignment: CrossAxisAlignment.center,
                        ),
                        ColumnText(
                          title: "Exp Return",
                          value:
                              "${lumpsumResult['expected_return'].toStringAsFixed(2)}%",
                          alignment: CrossAxisAlignment.end,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: devWidth,
              margin: EdgeInsets.all(16),
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
            /* Container(
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
                      "Future Value",
                      style: AppFonts.f50014Black,
                    ),
                  ),
                  Text(
                    "$rupee ${Utils.formatNumber(futureAmount, isAmount: false)}",
                    style: AppFonts.f70018Green,
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget getBroadCategory() {
    List<SipData> chartData = [];

    chartData.add(SipData(
      category: 'Your Lumpsum Amount',
      percentage: lumpsumResult['lumpsum_amount'].toDouble(),
    ));

    chartData.add(SipData(
      category: 'Future Amount',
      percentage: lumpsumResult['future_amount'].toDouble(),
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
                      width: 180,
                      child: Text(
                        "  ${sipData.category}",
                        style: AppFonts.f50014Black,
                      )),
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
