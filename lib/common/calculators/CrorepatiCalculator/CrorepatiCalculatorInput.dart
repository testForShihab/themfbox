import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/common/calculators/CrorepatiCalculator/CrorepatiCalculatorOutput.dart';
import 'package:mymfbox2_0/rp_widgets/SliderInputCard.dart';
import 'package:mymfbox2_0/utils/Config.dart';

import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../input_formatters.dart';

class CrorepatiCalculatorInput extends StatefulWidget {
  const CrorepatiCalculatorInput({super.key});

  @override
  State<CrorepatiCalculatorInput> createState() =>
      _CrorepatiCalculatorInputState();
}

class _CrorepatiCalculatorInputState extends State<CrorepatiCalculatorInput> {
  late double devHeight, devWidth;
  String client_name = GetStorage().read("client_name");
  TextEditingController currentAgeController = TextEditingController();
  int currentAge = 0;

  TextEditingController ageTodayController = TextEditingController(text: "30");
  int ageToday = 30;

  TextEditingController annualInflationRateController =
      TextEditingController(text: "5");
  num annualInflationRate = 5;

  TextEditingController ageBecomeController = TextEditingController(text: "60");
  int ageBecome = 60;

  TextEditingController annualRateReturnController =
      TextEditingController(text: "12");
  num annualRateReturn = 12;

  num amountRetire = 50000000;
  num balance = 0;

  String distReturn1 = "0";

  String distReturn2 = "0";

  num currentSavings = 2500000;
  num energyCorpus = 0;

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Crorepati Calculator",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  AmountInputCard(
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
                    title:
                        "How much amount (at current value) you would need to consider yourself wealthy (Rs)",
                    initialValue: Utils.formatNumber(50000000),
                    suffixText:
                        Utils.formatNumber(amountRetire, isAmount: true),
                    // maxLength: 10,
                    onChange: (val) {
                      final tempText = val.split(',').join();
                      amountRetire = num.tryParse(tempText) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  SliderInputCard(
                    title: "Your current age (in years)",
                    controller: ageTodayController,
                    sliderValue: ageToday.toDouble(),
                    inputFormatters: [
                      MaxValueFormatter(100, isDecimal: false),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    suffixText: 'Years',
                    tfOnChange: (val) {
                      num temp = num.tryParse(val) ?? 0;

                      bool isValid = isValidSlider(temp);

                      if (ageTodayController.text.isEmpty) {
                        Utils.showError(context, "Please enter your age");
                        return;
                      }

                      if (!isValid) {
                        Utils.showError(
                            context, "Age should be in-between 10-100");
                        return;
                      }
                      ageToday = temp.round();
                      setState(() {});
                    },
                    sliderOnChange: (val) {
                      ageToday = val.round();
                      ageTodayController.text = "$ageToday";
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  SliderInputCard(
                    title: "The age when you want to become a Crorepati (in years)",
                    controller: ageBecomeController,
                    inputFormatters: [
                      MaxValueFormatter(100, isDecimal: false),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    sliderValue: ageBecome.toDouble(),
                    suffixText: 'Years',
                    tfOnChange: (val) {
                      num temp = num.tryParse(val) ?? 0;

                      bool isValid = isValidSlider(temp);
                      if (!isValid) {
                        Utils.showError(
                            context, "Age should be in-between 0-100");
                        return;
                      }
                      ageBecome = temp.round();
                      setState(() {});
                    },
                    sliderOnChange: (val) {
                      ageBecome = val.round();
                      ageBecomeController.text = "$ageBecome";
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  SliderInputCard(
                    title: "The expected rate of inflation over the years (% per annum)",
                    sliderValue: annualInflationRate.toDouble(),
                    controller: annualInflationRateController,
                    sliderMaxValue: 10,
                    inputFormatters: [
                      MaxValueFormatter(10),
                      DoubleDecimalFormatter(),
                    ],
                    suffixText: "%",
                    tfOnChange: (val) {
                      num temp = num.parse(val) ?? 0;
                      bool isValid = isinflationValidSlider(temp);

                      /*  if (!isValid) {
                        Utils.showError(context,
                            "Expected Annual Inflation Rate should be in-between 0-15");
                        return;
                      }*/
                      annualInflationRate = temp;
                      setState(() {});
                    },
                    sliderOnChange: (val) {
                      annualInflationRate =
                          double.tryParse(val.toStringAsFixed(2)) ?? 0;
                      annualInflationRateController.text =
                          "$annualInflationRate";

                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  SliderInputCard(
                    title:
                        "What rate of return would you expect your SIP investment to generate (% per annum)",
                    sliderValue: annualRateReturn.toDouble(),
                    inputFormatters: [
                      MaxValueFormatter(20),
                      DoubleDecimalFormatter(),
                    ],
                    controller: annualRateReturnController,
                    sliderMaxValue: 20,
                    suffixText: "%",
                    tfOnChange: (val) {
                      num temp = num.tryParse(val) ?? 0;
                      bool isValid = isreturnValidSlider(temp);

                      if (!isValid && temp <= 0) {
                        Utils.showError(context,
                            "Expected Annual Rate of Return should be in-between 1-20");
                        return;
                      }

                      annualRateReturn = temp;
                      setState(() {});
                    },
                    sliderOnChange: (val) {
                      annualRateReturn =
                          double.tryParse(val.toStringAsFixed(2)) ?? 0;
                      // annualRateReturn = val.round();
                      annualRateReturnController.text = "$annualRateReturn";

                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "How much savings you have now (Rs)",
                    initialValue: "2500000",
                    inputFormatters: [
                      MaxValueFormatter(10000000, isDecimal: false),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 10,
                    onChange: (val) {
                      currentSavings = num.tryParse(val) ?? 0;
                      setState(() {});
                    },
                    suffixText:
                        Utils.formatNumber(currentSavings, isAmount: true),
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
                        EasyLoading.isShow;
                        bool isValid = validator();
                        if (!isValid) return;

                        print('Amount Retire = $amountRetire');
                        print('Age Today = $ageToday');
                        print('Age Become  = $ageBecome');
                        print('Annual Inflation Rate = $annualInflationRate');
                        print('Annual Rate Return = $annualRateReturn');
                        print('Current Savings = $currentSavings');
                        Map data = await Api.getCrorepatiCalculator(
                            current_age: '$ageToday',
                            retirement_age: '$ageBecome',
                            wealth_amount: '$amountRetire',
                            inflation_rate: '$annualInflationRate',
                            expected_return: '$annualRateReturn',
                            savings_amount: '$currentSavings',
                            client_name: client_name);
                        Get.to(() => CrorepatiCalculatorOutput(
                            crorepatiCalculatorResult: data['result']));
                        EasyLoading.dismiss();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Config.appTheme.buttonColor,
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
    /*List l = [
      amountRetire,
      ageToday,
      ageBecome,
      //annualInflationRate,
     // annualRateReturn,
      // currentSavings
    ];
    if (l.contains(null) || l.contains(0)) {
      EasyLoading.showError("All Fields are mandatory!");
      return false;
    }*/

    if (amountRetire <= 0) {
      EasyLoading.showError(
          "Please enter the amount you consider yourself wealthy");
      return false;
    }

    if (ageTodayController.text.isEmpty || ageTodayController.text == "0") {
      EasyLoading.showError("Please enter your current age");
      return false;
    }

    if (ageBecomeController.text.isEmpty || ageBecomeController.text == "0") {
      EasyLoading.showError(
          "Please enter the age when you want to become a Crorepati");
      return false;
    }

    if (annualRateReturn > 50 || annualRateReturn <= 0.0) {
      EasyLoading.showError(
          "Please enter valid expected annual rate of return. It Should be in-between 1-20");
      return false;
    }
    if (ageToday >= ageBecome) {
      EasyLoading.showError(
          "Please enter the your Crorepati age not less than the current age");
      return false;
    }
    if (amountRetire <= currentSavings) {
      EasyLoading.showError(
          "Please enter the savings amount less than the wealth amount");
      return false;
    }

    /*if (l.contains(0)) {
      EasyLoading.showError("Zero Not Allowed");
      return false;
    }*/
    return true;
  }

  bool isValidSlider(num temp) {
    if (temp < 0 || temp > 100)
      return false;
    else
      return true;
  }

  bool isinflationValidSlider(num temp) {
    if (temp < 0 || temp > 10)
      return false;
    else
      return true;
  }

  bool isreturnValidSlider(num temp) {
    if (temp < 0 || temp > 20)
      return false;
    else
      return true;
  }
}
