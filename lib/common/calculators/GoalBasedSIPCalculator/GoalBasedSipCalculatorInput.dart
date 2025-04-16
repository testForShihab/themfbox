import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/common/calculators/GoalBasedSIPCalculator/GoalBasedSipCalculatorOutput.dart';
import 'package:mymfbox2_0/common/calculators/GoalBasedSIPCalculator/GoalBasedSipTopUpCalculatorOutput.dart';
import 'package:mymfbox2_0/rp_widgets/CalcTopCard.dart';
import 'package:mymfbox2_0/rp_widgets/SliderInputCard.dart';
import 'package:mymfbox2_0/utils/Config.dart';

import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../input_formatters.dart';

class GoalBasedSipCalculatorInput extends StatefulWidget {
  const GoalBasedSipCalculatorInput({super.key});

  @override
  State<GoalBasedSipCalculatorInput> createState() =>
      _GoalBasedSipCalculatorInputState();
}

class _GoalBasedSipCalculatorInputState
    extends State<GoalBasedSipCalculatorInput> {
  late double devHeight, devWidth;
  String client_name = GetStorage().read("client_name");

  TextEditingController currentAgeController = TextEditingController();
  int currentAge = 0;

  TextEditingController investmentPeriodController =
      TextEditingController(text: "30");
  int investmentPeriod = 30;

  TextEditingController annualRateReturnController =
      TextEditingController(text: "12");
  num annualRateReturn = 12;

  TextEditingController annualInflationRateController =
      TextEditingController(text: "5");
  num annualInflationRate = 5;

  TextEditingController annualTopUpController =
      TextEditingController(text: "10");
  num annualTopUp = 10;

  num targetAmount = 2500000;
  num balance = 0;

  String distReturn1 = "0";

  String distReturn2 = "0";

  num currentSavings = 0;
  num energyCorpus = 0;

  bool isAnnual = false;

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;
    devHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Goal Based SIP Calculator",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: devWidth,
              color: Config.appTheme.themeColor,
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        isAnnual = false;
                        setState(() {});
                      },
                      child: CalcTopCard(title: "SIP", isFilled: !isAnnual)),
                  InkWell(
                      onTap: () {
                        isAnnual = true;
                        setState(() {});
                      },
                      child: CalcTopCard(
                          title: "SIP Annual Top Up", isFilled: isAnnual)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Target Amount",
                    initialValue: Utils.formatNumber(2500000),
                    inputFormatters: [
                      MaxValueFormatter(
                        1000000000,
                        isDecimal: false,
                        isReadableInput: true,
                      ),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                      ReadableNumberFormatter(),
                    ],
                    suffixText:
                        Utils.formatNumber(targetAmount, isAmount: true),
                    onChange: (val) {
                      final tempText = val.split(',').join();
                      targetAmount = num.tryParse(tempText) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  SliderInputCard(
                    title: "Investment Period",
                    controller: investmentPeriodController,
                    sliderValue: investmentPeriod.toDouble(),
                    inputFormatters: [
                      MaxValueFormatter(100, isDecimal: false),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    suffixText: 'Years',
                    tfOnChange: (val) {
                      num temp = num.tryParse(val) ?? 0;

                      bool isValid = isValidSlider(temp);
                      if (!isValid) {
                        Utils.showError(context,
                            "Investment Period should be in-between 0-100");
                        return;
                      }
                      investmentPeriod = temp.round();
                      setState(() {});
                    },
                    sliderOnChange: (val) {
                      investmentPeriod = val.round();
                      investmentPeriodController.text = "$investmentPeriod";
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  SliderInputCard(
                      title: "Expected Annual Inflation Rate",
                      controller: annualInflationRateController,
                      inputFormatters: [
                        MaxValueFormatter(15),
                      ],
                      sliderMaxValue: 15,
                      sliderValue: annualInflationRate.toDouble(),
                      suffixText: "%",
                      tfOnChange: (val) {
                        num temp = num.tryParse(val) ?? 0;

                        bool isValid = isInflactionValidSlider(temp);
                        if (!isValid) {
                          Utils.showError(context,
                              "Expected Annual Inflation Rate should be in-between 0-15");
                          return;
                        }
                        annualInflationRate = temp;
                        setState(() {});
                      },
                      sliderOnChange: (val) {
                        annualInflationRate = val.round();
                        annualInflationRateController.text =
                            "$annualInflationRate";
                        setState(() {});
                      }),
                  SizedBox(height: 16),
                  SliderInputCard(
                    title: "Expected Annual Rate of Return",
                    sliderValue: annualRateReturn.toDouble(),
                    controller: annualRateReturnController,
                    inputFormatters: [
                      MaxValueFormatter(2000),
                      DoubleDecimalFormatter(),
                    ],
                    sliderMaxValue: 50,
                    suffixText: "%",
                    tfOnChange: (val) {
                      num temp = num.tryParse(val) ?? 0;

                      bool isValid = isValidSliderExpected(temp);

                      if (!isValid) {
                        Utils.showError(context,
                            "Expected Annual Rate of Return should be in-between 0-100");
                        annualRateReturnController.text = "50";
                        annualRateReturn = 50;
                        setState(() {});
                        return;
                      }

                      annualRateReturn = temp;
                      setState(() {});
                    },
                    sliderOnChange: (val) {
                      //annualRateReturn = val.round();
                      annualRateReturn =
                          double.tryParse(val.toStringAsFixed(2)) ?? 0;
                      annualRateReturnController.text = "$annualRateReturn";
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  if (!isAnnual) SizedBox(height: 16),
                  Visibility(
                    visible: isAnnual,
                    child: SliderInputCard(
                        title: "Annual Top Up",
                        controller: annualTopUpController,
                        sliderValue: annualTopUp.toDouble(),
                        inputFormatters: [
                          MaxValueFormatter(100),
                        ],
                        suffixText: "%",
                        sliderMaxValue: 100,
                        tfOnChange: (val) {
                          num temp = num.tryParse(val) ?? 0;

                          bool isValid = isValidSlider(temp);
                          if (!isValid) {
                            Utils.showError(context,
                                "Annual Top Up should be in-between 0-100");
                            annualTopUpController.text = "100";
                            annualTopUp = 100;
                            setState(() {});
                            return;
                          }
                          annualTopUp = temp;
                          setState(() {});
                        },
                        sliderOnChange: (val) {
                          annualTopUp = val.round();
                          annualTopUpController.text = "$annualTopUp";
                          setState(() {});
                        }),
                  ),
                ],
              ),
            ),
            Container(
              width: devWidth,
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: SizedBox(
                  height: 45,
                  child: ElevatedButton(
                      onPressed: () async {
                        EasyLoading.show();

                        print('Target Amount = $targetAmount');
                        print('Investment Period = $investmentPeriod');
                        print('Annual Inflation Rate  = $annualInflationRate');
                        print('Annual Rate Return = $annualRateReturn');
                        print('Annual Top Up Return = $annualTopUp');

                        bool isValid = validator();
                        if (!isValid) return;

                        Map data;
                        if (!isAnnual) {
                          data = await Api.getGoalBasedSipCalculator(
                              wealth_amount: '$targetAmount',
                              inflation_rate: '$annualInflationRate',
                              expected_return: '$annualRateReturn',
                              period: '$investmentPeriod',
                              client_name: client_name);
                          Get.to(() => GoalBasedSipCalculatorOutput(
                              goalBasedResult: data['result']));
                        } else {
                          data = await Api.getGoalBasedSipTopUpCalculator(
                              goal_amount: '$targetAmount',
                              inflation_rate: '$annualInflationRate',
                              expected_rate_of_return: '$annualRateReturn',
                              investment_period: '$investmentPeriod',
                              sip_topup_value: '$annualTopUp',
                              client_name: client_name);
                          print(
                            'annualTopUp' + '$annualTopUp',
                          );
                          Get.to(() => GoalBasedSipTopUpCalculatorOutput(
                                goalBasedSipTopUpResult: data['result'],
                                goalBasedAnnualtopUp: '$annualTopUp',
                                inflationRate: annualInflationRate,
                              ));
                        }
                        EasyLoading.dismiss();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Config.appTheme.themeColor,
                          foregroundColor:
                              Colors.white // Set the background color here
                          ),
                      child: Text("CALCULATE"))),
            ),
          ],
        ),
      ),
    );
  }

  validator() {
    /*  List l = [targetAmount, investmentPeriod, annualInflationRate, annualRateReturn,];
    if (isAnnual) {
      l.add(annualTopUp);
    }
    if (l.contains(null) || l.contains(0)) {
      EasyLoading.showError("All Fields are mandatory!");
      return false;
    }
     if (l.contains(0)) {
      EasyLoading.showError("Zero Not Allowed");
      return false;
    }
    return true;
   */
    if (targetAmount == 0) {
      EasyLoading.showError("Target Amount should not be 0");
      return false;
    }
    if (investmentPeriod == 0) {
      EasyLoading.showError("Investment Period should not be 0");
      return false;
    }
    if (annualRateReturn == 0) {
      EasyLoading.showError("Annual Rate Return should not be 0");
      return false;
    }
    if (isAnnual && annualTopUp == 0) {
      EasyLoading.showError("Annual Top Up should not be 0.");
      return false;
    }
    return true;
  }

  static bool isValidSlider(num temp) {
    if (temp < 0 || temp > 100)
      return false;
    else
      return true;
  }

  static bool isInflactionValidSlider(num temp) {
    if (temp < 0 || temp > 15)
      return false;
    else
      return true;
  }

  static bool isValidSliderExpected(num temp) {
    if (temp < 0 || temp > 50)
      return false;
    else
      return true;
  }
}
