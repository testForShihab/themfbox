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
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../../Investor/sipPortfolioSummary/SipPortfolioSummary.widgets.dart';
import '../../../pojo/UserDataPojo.dart';

class SipTopUpCalculatorOutput extends StatefulWidget {
  const SipTopUpCalculatorOutput(
      {super.key,
      required this.sipTopUpResult,
      required this.sipAnnualtopUp,
      required this.sipTopUpexpectAnnualRate});
  final Map sipTopUpResult;
  final String sipAnnualtopUp;
  final String sipTopUpexpectAnnualRate;

  @override
  State<SipTopUpCalculatorOutput> createState() =>
      _SipTopUpCalculatorOutputState();
}

class _SipTopUpCalculatorOutputState extends State<SipTopUpCalculatorOutput> {
  late double devHeight, devWidth;
  late Map sipTopUpResult;
  late String sipAnnualtopUp;
  late String sipTopUpexpectAnnualRate;
  late String futureWith, futureWithout;
  String client_name = GetStorage().read("client_name");
  List<dynamic> yearData = [];
  int type_id = GetStorage().read("type_id");
  UserDataPojo userDataPojo = UserDataPojo();

  @override
  void initState() {
    //  implement initState
    super.initState();
    sipTopUpResult = widget.sipTopUpResult;
    sipAnnualtopUp = widget.sipAnnualtopUp;
    sipTopUpexpectAnnualRate = widget.sipTopUpexpectAnnualRate;
    futureWith = Utils.formatNumber(sipTopUpResult['stepup_maturity_amount']);
    futureWithout = Utils.formatNumber(sipTopUpResult['maturity_amount']);
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    yearData = sipTopUpResult['list'];

    double parsedRate = double.parse(sipTopUpexpectAnnualRate);
    String formattedSipTopUpexpectAnnualRate = (parsedRate).toStringAsFixed(2);

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "SIP Top Up Calculator",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white,
          actions: [
            if ((type_id == UserType.ADMIN) && (!keys.contains("adminAsInvestor")))
            GestureDetector(
                onTap: () {
                  String url =
                      "${ApiConfig.apiUrl}/download/downloadstepupsipCalcResult?key=${ApiConfig.apiKey}&"
                      "sip_amount=${sipTopUpResult['sip_amount']}&"
                      "interest_rate=$formattedSipTopUpexpectAnnualRate"
                      "&period=${sipTopUpResult['period']}"
                      "&sip_stepup_value=$sipAnnualtopUp"
                      "&client_name=$client_name";
                  print("downloadstepupsipCalcResult $url");
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
                            title: "Monthly SIP",
                            value:
                                "$rupee ${Utils.formatNumber(sipTopUpResult['sip_amount'], isAmount: false)}"),
                        ColumnText(
                          title: "Period",
                          value: "${sipTopUpResult['period']} Months",
                          alignment: CrossAxisAlignment.center,
                        ),
                        ColumnText(
                          title: "Exp Return",
                          value: "$formattedSipTopUpexpectAnnualRate%",
                          alignment: CrossAxisAlignment.end,
                        ),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    DottedLine(),
                    SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("With Annual Top Up: $sipAnnualtopUp%",
                            style: AppFonts.f50012),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: devWidth,
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16), // Add padding
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
              margin: EdgeInsets.fromLTRB(16, 0, 16, 6),
              padding: EdgeInsets.all(16.0), // Add padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white30, //Color(0xFFE1E1E1),
                  width: 2.0, // Set border width
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Future Value",
                        style: AppFonts.f50014Black,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ColumnText(
                          title: "With Top Up",
                          value: "$rupee $futureWith",
                          valueStyle: AppFonts.f70018Green),
                      ColumnText(
                        title: "Without Top Up",
                        value: "$rupee $futureWithout",
                        valueStyle: AppFonts.f70018Black,
                        alignment: CrossAxisAlignment.end,
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              "SIP Calculator Top Up Amount Invested Summary",
              style:
                  AppFonts.f50014Black.copyWith(color: AppColors.readableGrey),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: yearData.length,
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
                '${yearData[index]['year']}',
                style: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.themeColor),
              ),
              RichText(
                text: TextSpan(
                  text:
                      '$rupee ${Utils.formatNumber(yearData[index]['sip_amount_per_month'], isAmount: false)}',
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
          DottedLine(),
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
                  '$rupee ${Utils.formatNumber(yearData[index]['total_invested_amount'], isAmount: false)}',
                  style: AppFonts.f50014Black,
                ),
              ),
              Text(
                '$rupee ${Utils.formatNumber(yearData[index]['invested_amount_per_year'], isAmount: false)}',
                style: AppFonts.f50014Black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getBroadCategory() {
    String investedWithTopUp =
        Utils.formatNumber(sipTopUpResult['stepup_invested_amount']);
    String growthWithTopUp =
        Utils.formatNumber(sipTopUpResult['stepup_growth_value']);

    String investedWithoutTopUp =
        Utils.formatNumber(sipTopUpResult['invested_amount']);
    String growthWithoutTopUp =
        Utils.formatNumber(sipTopUpResult['growth_value']);

    List<SipData> chartData = [];

    chartData.add(SipData(
      category: 'Total Amount Invested',
      percentage: sipTopUpResult['invested_amount'].toDouble(),
    ));

    chartData.add(SipData(
      category: 'Total Growth Amount',
      percentage: sipTopUpResult['growth_value'].toDouble(),
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
        ...chartBottom(
            title: "Invested Amount",
            color: colorPalate[0],
            withTopUp: investedWithTopUp,
            withoutTopUp: investedWithoutTopUp),
        SizedBox(height: 5),
        DottedLine(),
        SizedBox(height: 5),
        ...chartBottom(
            title: "Growth Amount",
            color: colorPalate[1],
            withTopUp: growthWithTopUp,
            withoutTopUp: growthWithoutTopUp),
      ],
    );
  }

  List<Widget> chartBottom(
      {required Color color,
      required String title,
      required String withTopUp,
      required String withoutTopUp}) {
    return [
      Text(title, style: AppFonts.f50014Black),
      SizedBox(height: 10),
      Row(
        children: [
          Text("With Top Up"),
          SizedBox(width: 3),
          CircleAvatar(
            backgroundColor: color,
            radius: 7,
          ),
          Spacer(),
          Text("Without Top Up")
        ],
      ),
      SizedBox(height: 5),
      Row(
        children: [
          Text("$rupee $withTopUp", style: AppFonts.f50014Black),
          Spacer(),
          Text("$rupee $withoutTopUp", style: AppFonts.f50014Black),
        ],
      )
    ];
  }
}
