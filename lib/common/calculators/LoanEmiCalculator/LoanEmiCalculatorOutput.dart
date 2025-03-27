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

class LoanEmiCalculatorOutput extends StatefulWidget {
  const LoanEmiCalculatorOutput({
    super.key,
    required this.loanEmiCalculatorResult,
  });
  final Map loanEmiCalculatorResult;

  @override
  State<LoanEmiCalculatorOutput> createState() =>
      _LoanEmiCalculatorOutputState();
}

class _LoanEmiCalculatorOutputState extends State<LoanEmiCalculatorOutput> {
  late double devHeight, devWidth;
  late Map loanEmiCalculatorResult;
  String client_name = GetStorage().read("client_name");
  int type_id = GetStorage().read("type_id");
  UserDataPojo userDataPojo = UserDataPojo();

  @override
  void initState() {
    //  implement initState
    super.initState();
    loanEmiCalculatorResult = widget.loanEmiCalculatorResult;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Loan EMI Calculator",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white,
          actions: [
            if ((type_id == UserType.ADMIN) && (!keys.contains("adminAsInvestor")))
            GestureDetector(
                onTap: () {
                  String url =
                      "${ApiConfig.apiUrl}/download/downloadLoanEmiCalcResult?key=${ApiConfig.apiKey}&"
                      "loan_amount=${loanEmiCalculatorResult['loan_amount']}"
                      "&interest_rate=${loanEmiCalculatorResult['interest_rate']}"
                      "&loan_tenure=${loanEmiCalculatorResult['loan_tenure']}"
                      "&loan_tenure_type=${loanEmiCalculatorResult['loan_tenure_type']}"
                      "&client_name=$client_name";
                  print("downloadLumpsumTargetCalcResult $url");
                  SharedWidgets().shareBottomSheet(context, url);
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
                          "Principal Amount",
                          style: AppFonts.f40013,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$rupee ${Utils.formatNumber(loanEmiCalculatorResult['loan_amount'], isAmount: false)}",
                          style: AppFonts.f50014Black.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ColumnText(
                            title: "Period",
                            value:
                                "${loanEmiCalculatorResult['loan_tenure'].toStringAsFixed(0)} Years"),
                        ColumnText(
                          title: "Interest Rate",
                          value:
                              "${loanEmiCalculatorResult['interest_rate']} %",
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
              margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
              padding: EdgeInsets.all(4.0), // Add padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getBroadCategory(),
                  DottedLine(),
                  Container(
                    width: devWidth,
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Total Payment \n",
                                    style: AppFonts.f50014Black,
                                  ),
                                  TextSpan(
                                    text: "(principal+interest)",
                                    style: AppFonts.f40013,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                                "$rupee ${Utils.formatNumber(loanEmiCalculatorResult['total_amount'], isAmount: false)}",
                                textAlign: TextAlign.end,
                                style: AppFonts.f50014Black)
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                      "Monthly EMI",
                      style: AppFonts.f50014Black,
                    ),
                  ),
                  Text(
                    "$rupee ${Utils.formatNumber(loanEmiCalculatorResult['emi'], isAmount: false)}",
                    style: AppFonts.f70024
                        .copyWith(fontSize: 18, color: Color(0xff3CB66D)),
                  ),
                ],
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
      category: 'Principal Amount',
      percentage: loanEmiCalculatorResult['loan_amount'].toDouble(),
    ));

    chartData.add(SipData(
      category: 'Interest Amount',
      percentage: loanEmiCalculatorResult['total_interest'].toDouble(),
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
                            text: "${sipData.category}  ",
                          ),
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
      ],
    );
  }
}
