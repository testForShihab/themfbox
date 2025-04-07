import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/pojo/UserDataPojo.dart';
import 'package:mymfbox2_0/rp_widgets/ShareWidget.dart';

import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
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

class CompoundingCalculatorOutput extends StatefulWidget {
  const CompoundingCalculatorOutput({
    super.key,
    required this.compoundingCalculatorResult,
  });
  final Map compoundingCalculatorResult;

  @override
  State<CompoundingCalculatorOutput> createState() =>
      _CompoundingCalculatorOutputState();
}

class _CompoundingCalculatorOutputState
    extends State<CompoundingCalculatorOutput> {
  late double devHeight, devWidth;
  late Map compoundingCalculatorResult;
  String client_name = GetStorage().read("client_name");

  int type_id = GetStorage().read("type_id");
  UserDataPojo userDataPojo = UserDataPojo();

  @override
  void initState() {
    //  implement initState
    super.initState();
    compoundingCalculatorResult = widget.compoundingCalculatorResult;
  }

  Map bottomSheetSData = {
    "Download": [
      "",
      "assets/add_photo_alternate.png",
    ],
    "Share via email": [
      "",
      "assets/add_photo_alternate.png",
    ],
  };

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Compounding Calculator",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white,
          actions: [
            if ((type_id == UserType.ADMIN) && (!keys.contains("adminAsInvestor")))
            GestureDetector(
                onTap: () {
                  String url =
                      "${ApiConfig.apiUrl}/download/downloadCompoundingCalcResult?key=${ApiConfig.apiKey}&"
                      "principal_amount=${compoundingCalculatorResult['principal_amount']}&"
                      "interest_rate=${compoundingCalculatorResult['interest_rate']}"
                      "&period=${compoundingCalculatorResult['period']}"
                      "&compound_interval=${compoundingCalculatorResult['compound_interval']}"
                      "&client_name=$client_name";
                  print("downloadCompoundingCalcResult $url");
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
                        ColumnText(title: "Principal Amount", value: "$rupee ${Utils.formatNumber(compoundingCalculatorResult['principal_amount'], isAmount: false)}",),
                        ColumnText(title: "Compounding Interval", value: "${compoundingCalculatorResult['compound_interval']}", alignment: CrossAxisAlignment.end,),
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
                                "${compoundingCalculatorResult['period']} Years"),
                        ColumnText(
                          title: "Interest Rate",
                          value:
                              "${compoundingCalculatorResult['interest_rate']} %",
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
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Total Maturity",
                      style: AppFonts.f50014Black,
                    ),
                  ),
                  Text(
                    "$rupee ${Utils.formatNumber(compoundingCalculatorResult['maturity_amount'], isAmount: false)}",
                    style: AppFonts.f70024
                        .copyWith(fontSize: 18, color: Color(0xff3CB66D)),
                  ),
                ],
              ),
            ),
            Container(
              width: devWidth,
              margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
              padding: EdgeInsets.all(4.0),
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

    int intetestAmount = 0;
    intetestAmount = compoundingCalculatorResult['maturity_amount'] -
        compoundingCalculatorResult['principal_amount'];
    print("intetestAmount$intetestAmount");

    chartData.add(SipData(
      category: 'Principal Amount',
      percentage: compoundingCalculatorResult['principal_amount'].toDouble(),
    ));

    chartData.add(SipData(
      category: 'Interest Amount',
      percentage: intetestAmount.toDouble(),
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
                    width: 190,
                    child: RichText(
                      text: TextSpan(
                        style: AppFonts.f50014Black,
                        children: [
                          TextSpan(
                            text: "${sipData.category} ",
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
            return Container(
                margin: EdgeInsets.only(left: 12, right: 12),
                child: DottedLine());
          },
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  shareBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Config.appTheme.mainBgColor,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SizedBox(
              height: devHeight * 0.32,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: devWidth * 0.03),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Share",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        listContainer(),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget listContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: bottomSheetSData.length,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 8,
          );
        },
        itemBuilder: (context, index) {
          String title = bottomSheetSData.keys.elementAt(index);
          List stitle = bottomSheetSData.values.elementAt(index);
          String imagePath = stitle[1];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () {
                if (index == 0) {
                } else if (index == 1) {
                  // Get.to(() => ShareViaEmail());
                  ();
                } else if (stitle[1] != null) {
                  Get.to(stitle[1]);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: RpListTile(
                  title: SizedBox(
                    width: 220,
                    child: Text(
                      title,
                      style: AppFonts.f50014Black
                          .copyWith(color: Config.appTheme.themeColor),
                    ),
                  ),
                  subTitle: Visibility(
                    visible: stitle[0].isNotEmpty,
                    child: Text(stitle[0], style: AppFonts.f40013),
                  ),
                  leading: Image.asset(
                    imagePath,
                    color: Config.appTheme.themeColor,
                    width: 32,
                    height: 32,
                  ),
                  showArrow: false,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
