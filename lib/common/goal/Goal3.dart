import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/common/goal/Goal2.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../utils/AppFonts.dart';
import '../../utils/Config.dart';

class Goals3 extends StatefulWidget {
  final String? goalName;
  final String? planName;
  final String? amount;
  final String? years;
  final double? inflation;
  final String? risk;
  final String? age;

  Goals3(
      {this.goalName,
      this.planName,
      this.amount,
      this.years,
      this.inflation,
      this.risk,
      this.age});

  @override
  Goals3State createState() => Goals3State();
}

class Goals3State extends State<Goals3> {
  String goalName = "";
  String risk = "Aggressive";
  String age = "";
  String amount = "";
  String years = "";
  double inflation = 0.0;

  late double devHeight, devWidth;

  String investYourMoney = "None";
  int step1Value = 0;
  String businessOrEmployee =
      "Most concerned about your investment losing value";
  int step2Value = 0;
  String investmentsRiskHigherReturns = "Sell all of my investments";
  int step3Value = 0;
  String longTermHolding = "Never";
  int step4Value = 0;
  String incomeStopsTodayExpenses = "Strongly disagree with the statement";
  int step5Value = 0;
  String wouldYouInvest =
      "I get stressed and avoid making financial decisions.";
  int step6Value = 0;

  List<String> spinnerInvestYourMoney = [
    "None",
    "Limited",
    "Good",
    "Extensive"
  ];

  List<String> spinnerBusinessOrEmployee = [
    "Most concerned about your investment losing value",
    "Equally concerned about your investment losing or gaining value",
    "Most concerned about your investment gaining value",
  ];

  List<String> spinnerInvestmentsRiskHigherReturns = [
    "Sell all of my investments",
    "Sell some of my investments",
    "Will wait and take no action immediately",
    "Will invest more",
  ];

  List<String> spinner_long_term_holding = [
    "Never",
    "1-3 years",
    "3-5 years",
    "5+ years"
  ];

  List<String> spinner_income_stops_today_expenses = [
    "Strongly disagree with the statement",
    "Disagree with the statement",
    "Agree with the statement",
    "Strongly agree with the statement"
  ];

  List<String> spinner_Would_you_invest = [
    "I get stressed and avoid making financial decisions.",
    "I ask for advice from my friends and family.",
    "I seek professional advice.",
    "I am knowledgeable about investments and use my own expertise.",
  ];
  int user_id = GetStorage().read("mfd_id") ?? 0;

  @override
  void initState() {
    super.initState();
    // scheme = widget.scheme;
    init();
  }

  init() async {
    goalName = widget.goalName!;
    age = widget.age!;
    amount = widget.amount!;
    years = widget.years!;
    inflation = widget.inflation!;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Invest in your Goals",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              goalName,
              style: AppFonts.f50014Black,
            ),
          ),
          SizedBox(
            height: devHeight * 0.75,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
                                child: Text(
                                  "1. Describe your knowledge of investments?",
                                  style: AppFonts.f50014Black,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                child: Container(
                                  height: 50.0,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    focusColor: Config.appTheme.themeColor,
                                    value: investYourMoney,
                                    style: AppFonts.f50014Black,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      size: 28,
                                    ),
                                    iconEnabledColor:
                                        Config.appTheme.themeColor,
                                    onChanged: (String? value) {
                                      setState(() {
                                        investYourMoney = value!;
                                        if (investYourMoney == "None") {
                                          step1Value = 1;
                                        } else if (investYourMoney ==
                                            "Limited") {
                                          step1Value = 2;
                                        } else if (investYourMoney == "Good") {
                                          step1Value = 3;
                                        } else if (investYourMoney ==
                                            "Extensive") {
                                          step1Value = 4;
                                        } else {
                                          step1Value = 0;
                                        }
                                      });
                                    },
                                    items: spinnerInvestYourMoney
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          //style: AppTheme.textStylePrimaryFont15,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "2.When you invest your money, you are?",
                                  style: AppFonts.f50014Black,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                child: Container(
                                  height: 50.0,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    focusColor: Config.appTheme.themeColor,
                                    value: businessOrEmployee,
                                    style: AppFonts.f50014Black,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      size: 28,
                                    ),
                                    iconEnabledColor:
                                        Config.appTheme.themeColor,
                                    onChanged: (String? value) {
                                      setState(() {
                                        businessOrEmployee = value!;

                                        if (businessOrEmployee ==
                                            "Most concerned about your investment losing value") {
                                          step2Value = 1;
                                        } else if (businessOrEmployee ==
                                            "Equally concerned about your investment losing or gaining value") {
                                          step2Value = 2;
                                        } else if (businessOrEmployee ==
                                            "Most concerned about your investment gaining value") {
                                          step2Value = 3;
                                        } else {
                                          step2Value = 0;
                                        }
                                      });
                                    },
                                    items: spinnerBusinessOrEmployee
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
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
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
                                child: Text(
                                  "3. If the market lost 25% in the last few months, and your investments also suffered the same - what would be your first impulse?",
                                  style: AppFonts.f50014Black,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                child: Container(
                                  height: 50.0,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    focusColor: Config.appTheme.themeColor,
                                    value: investmentsRiskHigherReturns,
                                    style: AppFonts.f50014Black,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      size: 28,
                                    ),
                                    iconEnabledColor:
                                        Config.appTheme.themeColor,
                                    onChanged: (String? value) {
                                      setState(() {
                                        investmentsRiskHigherReturns = value!;
                                        if (investmentsRiskHigherReturns ==
                                            "Sell all of my investments") {
                                          step3Value = 1;
                                        } else if (investmentsRiskHigherReturns ==
                                            "Sell some of my investments") {
                                          step3Value = 2;
                                        } else if (investmentsRiskHigherReturns ==
                                            "Will wait and take no action immediately") {
                                          step3Value = 3;
                                        } else if (investmentsRiskHigherReturns ==
                                            "Will invest more") {
                                          step3Value = 4;
                                        } else {
                                          step3Value = 0;
                                        }
                                      });
                                    },
                                    items: spinnerInvestmentsRiskHigherReturns
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
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
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
                                child: Text(
                                  "4. Have you ever invested in shares or mutual funds? If yes, for how many years?",
                                  style: AppFonts.f50014Black,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                child: Container(
                                  height: 50.0,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    focusColor: Config.appTheme.themeColor,
                                    value: longTermHolding,
                                    style: AppFonts.f50014Black,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      size: 28,
                                    ),
                                    iconEnabledColor:
                                        Config.appTheme.themeColor,
                                    onChanged: (String? value) {
                                      setState(() {
                                        longTermHolding = value!;
                                        if (longTermHolding == "Never") {
                                          step4Value = 1;
                                        } else if (longTermHolding ==
                                            "1-3 years") {
                                          step4Value = 2;
                                        } else if (longTermHolding ==
                                            "3-5 years") {
                                          step4Value = 3;
                                        } else if (longTermHolding ==
                                            "5+ years") {
                                          step4Value = 4;
                                        } else {
                                          step4Value = 0;
                                        }
                                      });
                                    },
                                    items: spinner_long_term_holding
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          //style: AppTheme.textStylePrimaryFont15,
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
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
                                child: Text(
                                    "5. To obtain a return of more than what you would receive as a bank fixed deposit, you must take risks?",
                                    style: AppFonts.f50014Black),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                child: Container(
                                  height: 50.0,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    focusColor: Config.appTheme.themeColor,
                                    value: incomeStopsTodayExpenses,
                                    style: AppFonts.f50014Black,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      size: 28,
                                    ),
                                    iconEnabledColor:
                                        Config.appTheme.themeColor,
                                    onChanged: (String? value) {
                                      setState(() {
                                        incomeStopsTodayExpenses = value!;
                                        if (incomeStopsTodayExpenses ==
                                            "Strongly disagree with the statement") {
                                          step5Value = 1;
                                        } else if (incomeStopsTodayExpenses ==
                                            "Disagree with the statement") {
                                          step5Value = 2;
                                        } else if (incomeStopsTodayExpenses ==
                                            "Agree with the statement") {
                                          step5Value = 3;
                                        } else if (incomeStopsTodayExpenses ==
                                            "Strongly agree with the statement") {
                                          step5Value = 4;
                                        } else {
                                          step5Value = 0;
                                        }
                                      });
                                    },
                                    items: spinner_income_stops_today_expenses
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
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
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                                child: Text(
                                    "6. How do you react to the idea of investments?",
                                    style: AppFonts.f50014Black),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                                child: Container(
                                  height: 50.0,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    focusColor: Config.appTheme.themeColor,
                                    value: wouldYouInvest,
                                    style: AppFonts.f50014Black,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      size: 28,
                                    ),
                                    iconEnabledColor:
                                        Config.appTheme.themeColor,
                                    onChanged: (String? value) {
                                      setState(() {
                                        wouldYouInvest = value!;
                                        if (wouldYouInvest ==
                                            "I get stressed and avoid making financial decisions.") {
                                          step6Value = 1;
                                        } else if (wouldYouInvest ==
                                            "I ask for advice from my friends and family.") {
                                          step6Value = 2;
                                        } else if (wouldYouInvest ==
                                            "I seek professional advice.") {
                                          step6Value = 3;
                                        } else if (wouldYouInvest ==
                                            "I am knowledgeable about investments and use my own expertise.") {
                                          step6Value = 4;
                                        } else {
                                          step6Value = 0;
                                        }
                                      });
                                    },
                                    items: spinner_Would_you_invest
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          //style: AppTheme.textStylePrimaryFont15,
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
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: CalculateButton(
        text: "Done",
        onPress: () {
          setState(() {
            int totalCount = step1Value +
                step2Value +
                step3Value +
                step4Value +
                step5Value +
                step6Value;

            // if(total_points <= 6)
            // {
            //   risk_profile = "Conservative";
            // }else if(total_points <= 12)
            // {
            //   risk_profile = "Moderately Conservative";
            // }else if(total_points <= 16)
            // {
            //   risk_profile = "Moderate";
            // }else if(total_points <= 20)
            // {
            //   risk_profile = "Moderately Aggressive";
            // }else
            // {
            //   risk_profile = "Aggressive";
            // }

            if (totalCount <= 6) {
              risk = "Conservative";
            } else if (totalCount <= 12) {
              risk = "Moderately Conservative";
            } else if (totalCount <= 16) {
              risk = "Moderate";
            } else if (totalCount <= 20) {
              risk = "Moderately Aggressive";
            } else {
              risk = "Aggressive";
            }
          });
          Get.off(Goal2(
            goalName: goalName,
            age: age,
            amount: amount,
            risk: risk,
            years: years,
            inflation: inflation,
          ));
        },
      ),
    );
  }
}
