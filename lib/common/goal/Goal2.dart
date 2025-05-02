import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/common/goal/Goal3.dart';
import 'package:mymfbox2_0/common/goal/Goal4.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../rp_widgets/AdminAppBar.dart';
import '../../rp_widgets/RpAppBar.dart';
import '../../rp_widgets/SliderInputCard.dart';
import '../../utils/AppThemes.dart';
import '../../utils/Config.dart';
import 'CircleThumbShape.dart';

class Goal2 extends StatefulWidget {
  final String goalName;
  final String? planName;
  final String? amount;
  final String? years;
  final double? inflation;
  final String? risk;
  final String? age;

  Goal2(
      {required this.goalName,
      this.planName,
      this.amount,
      this.years,
      this.inflation,
      this.risk,
      this.age});

  @override
  Goal2State createState() => Goal2State();
}

class Goal2State extends State<Goal2> {
  var textFieldController = TextEditingController();
  var yearsController = TextEditingController();
  var amountController = TextEditingController();
  var ageController = TextEditingController();
  double inflation = 5.0;
  String riskProfile = "";

  String inflation_over_the_years = "5 %";
  List<String> spinneinflation_over_the_years = [
    "5 %",
    "6 %",
    "7 %",
    "8 %",
    "9 %",
    "10 %"
  ];

  int user_id = GetStorage().read("mfd_id") ?? 0;

  // List<String> spinneRisk_profil = ["Conservative", "Moderate", "Aggressive", "Not sure? Take a quick test"];

  List<String> spinneRisk_profil = [
    "Conservative",
    "Moderately Conservative",
    "Moderate",
    "Moderately Aggressive",
    "Aggressive",
  ];

  String goalName = "";
  String planName = "";
  int todayValue = 0;
  String plan_goal = "";

  @override
  void initState() {
    super.initState();
    init();

    textFieldController.text = widget.goalName;
    ageController.text = widget.age!;
    yearsController.text = widget.years!;
    amountController.text = widget.amount!;
    inflation = widget.inflation!;
    riskProfile = widget.risk!;
    print("riskProfile");
    print(riskProfile);

    if (riskProfile == "") {
      riskProfile = "Check Your Risk Profile";
    } else {
      if (riskProfile == "Conservative") {
        riskProfile = "Conservative";
      } else if (riskProfile == "Moderately Conservative") {
        riskProfile = "Moderately Conservative";
      } else if (riskProfile == "Moderate") {
        riskProfile = "Moderate";
      } else if (riskProfile == "Moderately Aggressive") {
        riskProfile = "Moderately Aggressive";
      } else {
        riskProfile = "Aggressive";
      }
    }
  }

  init() async {
    goalName = widget.goalName;
    planName = widget.planName!;
  }

  NumberFormat numberFormat =
      NumberFormat.currency(locale: 'HI', symbol: "", decimalDigits: 0);
  late double devHeight, devWidth;

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: goalName,
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: SizedBox(
        height: devHeight * 0.80,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AmountInputCard(
                    title: getAgeLabelText(),
                    suffixText: "Years",
                    controller: ageController,
                    onChange: (String) {},
                    maxLength: 2,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  AmountInputCard(
                    title: getAmountLabelText(),
                    suffixText: "Amount",
                    onChange: (String) {},
                    controller: amountController,
                    maxLength: 9,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  AmountInputCard(
                    title: getYearsLabelText(),
                    suffixText: "Years",
                    onChange: (String) {},
                    maxLength: 2,
                    controller: yearsController,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: 12, top: 8, right: 12, bottom: 0),
                          child: Text(
                              "Expected inflation rate over the years %",
                              style: AppFonts.f50014Black),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 8, top: 20, right: 12, bottom: 10),
                          child: Column(
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTickMarkColor: Colors.transparent,
                                  inactiveTickMarkColor: Colors.transparent,
                                  activeTrackColor: Color(0xFFFBC441),
                                  inactiveTrackColor: Color(0xFFC6CCD6),
                                  thumbColor: Config.appTheme.themeColor,
                                  overlayShape:
                                      RoundSliderOverlayShape(overlayRadius: 1),
                                  thumbShape: CircleThumbShape(thumbRadius: 7),
                                ),
                                child: Slider(
                                    value: inflation.toDouble(),
                                    min: 0,
                                    max: 20,
                                    divisions: 20,
                                    onChangeStart: (double inflation) {},
                                    onChangeEnd: (double value) {},
                                    onChanged: (value) {
                                      setState(() {
                                        inflation = value.toDouble();
                                      });
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                color: Config.appTheme.themeColor25,
                                border: Border.all(
                                    color: Config.appTheme.themeColor25,
                                    width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0))),
                            margin: EdgeInsets.only(
                                left: 12, top: 10, right: 12, bottom: 12),
                            padding: EdgeInsets.only(
                                left: 0, top: 10, right: 0, bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "$inflation% annualized return",
                                  textAlign: TextAlign.center,
                                  style: AppFonts.f50014Black,
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                          child: Text(
                              "How much risk would you take with your Investments?",
                              style: AppFonts.f50014Black),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
                          child: Container(
                            height: 46.0,
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              focusColor: Color(0XFCDD3ED),
                              value: riskProfile,
                              style: AppFonts.f50014Black,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_sharp,
                                size: 28,
                              ),
                              iconEnabledColor: Config.appTheme.themeColor,
                              onChanged: (String? value) {
                                setState(() {
                                  riskProfile = value!;
                                });
                              },
                              items: spinneRisk_profil
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: AppFonts.f50014Black,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ]),
          ),
        ),
      ),
      bottomSheet: CalculateButton(
        text: "Build My $goalName Plan ",
        onPress: () {
          setState(() {
            if (textFieldController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Please fill all Fields"),
              ));
            }
            // else if (inflation == 0) {
            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //     content: Text("Please fill all Fields"),
            //   ));
            // }
            else if (yearsController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Please fill all Fields"),
              ));
            } else if (amountController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Please fill all Fields"),
              ));
            } else {
              if (riskProfile == "Check Your Risk Profile") {
                Get.to(Goals3(
                  goalName: goalName,
                  planName: planName,
                  amount: amountController.text,
                  years: yearsController.text,
                  inflation: inflation,
                  risk: this.riskProfile,
                  age: ageController.text,
                ));
              } else {
                String age = ageController.text;
                String plan_name = textFieldController.text;
                String year_amount = yearsController.text;
                String requires_money = amountController.text;
                // int requires_money = int.parse(money_require_textFieldController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Goal4(
                      goalName: goalName,
                      planName: plan_name,
                      amount: requires_money,
                      age: age,
                      years: year_amount,
                      inflation: this.inflation,
                      risk: this.riskProfile,
                    ),
                  ),
                );
                print(goalName);
              }
            }
          });
        },
      ),
    );
  }

  String getAgeLabelText() {
    String text = "";

    if (goalName == "Dream Home") {
      text = "What is your current age?";
    } else if (goalName == "Child Education") {
      text = "What is your current age?";
    } else if (goalName == "Retirement Planning") {
      text = "What is your current age?";
    } else if (goalName == "Child Education") {
      text = "What is your current age?";
    } else if (goalName == "Build Wealth") {
      text = "What is your current age?";
    } else if (goalName == "Emergency Fund") {
      text = "What is your current age?";
    } else if (goalName == "Wedding") {
      text = "What is your current age?";
    } else if (goalName == "International Vacation") {
      text = "What is your current age?";
    } else {
      text = "";
    }
    return text;
  }

  String getAmountLabelText() {
    String text = "";
    if (goalName == "Dream Home") {
      text =
          "How much money you would require in today's value for your dream home?";
    } else if (goalName == "Child Education") {
      text =
          "How much money you would require in today's value for your child education?";
    } else if (goalName == "Retirement Planning") {
      text =
          "How much money you would require in today's value for your retirement planning?";
    } else if (goalName == "Build Wealth") {
      text =
          "How much money you would require in today's value to build wealth?";
    } else if (goalName == "Emergency Fund") {
      text =
          "How much money you would require in today's value for your emergency fund?";
    } else if (goalName == "Wedding") {
      text =
          "How much money you would require in today's value for your wedding?";
    } else if (goalName == "International Vacation") {
      text =
          "How much money you would require in today's value for your international vacation?";
    } else {
      text = "";
    }
    return text;
  }

  String getYearsLabelText() {
    String text = "";
    if (goalName == "Dream Home") {
      text = "After how many years you want to build your dream house?";
    } else if (goalName == "Child Education") {
      text = "After how many years from now would you need this money?";
    } else if (goalName == "Retirement Planning") {
      text = "After how many years from now your planning to retire?";
    } else if (goalName == "Child Education") {
      text = "After how many years from now would you need this money?";
    } else if (goalName == "Build Wealth") {
      text = "After how many years from now would you need this money?";
    } else if (goalName == "Emergency Fund") {
      text = "How many years away from now you want to achieve this goal?";
    } else if (goalName == "Wedding") {
      text = "After how many years from now your planning your wedding?";
    } else if (goalName == "International Vacation") {
      text = "After how many years from now you are planning the vacation?";
    } else {
      text = "";
    }
    return text;
  }
}
