import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/common/calculators/RetirementCalculator/RetirementCalculatorOutput.dart';
import 'package:mymfbox2_0/rp_widgets/SliderInputCard.dart';
import 'package:mymfbox2_0/utils/Config.dart';

import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../input_formatters.dart';

class RetirementCalculatorInput extends StatefulWidget {
  const RetirementCalculatorInput({super.key});

  @override
  State<RetirementCalculatorInput> createState() =>
      _RetirementCalculatorInputState();
}

class _RetirementCalculatorInputState extends State<RetirementCalculatorInput> {
  late double devHeight, devWidth;
  String client_name = GetStorage().read("client_name");

  TextEditingController currentAgeController = TextEditingController();
  int currentAge = 0;

  TextEditingController ageTodayController = TextEditingController(text: "25");
  int ageToday = 25;

  TextEditingController annualInflationRateController =
      TextEditingController(text: "7.5");
  num annualInflationRate = 7.5;

  TextEditingController retireAgeController = TextEditingController(text: "75");
  int retireAge = 75;

  TextEditingController annualRateReturnController =
      TextEditingController(text: "12.5");
  num annualRateReturn = 12.5;

  num amountRetire = 20000000;
  num balance = 0;

  String distReturn1 = "0";

  String distReturn2 = "0";

  num currentSavings = 100000;
  num energyCorpus = 0;

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Retirement Calculator",
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
                    title: "Amount you want to retire with",
                    initialValue: "20000000",
                    inputFormatters: [
                      MaxValueFormatter(1000000000, isDecimal: false),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    suffixText:
                        Utils.formatNumber(amountRetire, isAmount: true),
                    onChange: (val) {
                      amountRetire = num.tryParse(val) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  SliderInputCard(
                    title: "Your age today",
                    controller: ageTodayController,
                    sliderValue: ageToday.toDouble(),
                    inputFormatters: [
                      MaxValueFormatter(100, isDecimal: false),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    suffixText: "Years",
                    tfOnChange: (val) {
                      num temp = num.tryParse(val) ?? 0;

                      bool isValid = isValidSlider(temp);
                      if (!isValid) {
                        Utils.showError(
                            context, "Age should be in-between 0-100");
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
                      title: "Age Your Plan to retire at",
                      inputFormatters: [
                        MaxValueFormatter(100, isDecimal: false),
                        NoLeadingZeroInputFormatter(),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: retireAgeController,
                      sliderValue: retireAge.toDouble(),
                      suffixText: "Years",
                      tfOnChange: (val) {
                        num temp = num.tryParse(val) ?? 0;

                        bool isValid = isValidSlider(temp);
                        if (!isValid) {
                          Utils.showError(
                              context, "Age should be in-between 0-100");
                          return;
                        }
                        retireAge = temp.round();
                        setState(() {});
                      },
                      sliderOnChange: (val) {
                        retireAge = val.round();
                        retireAgeController.text = "$retireAge";
                        setState(() {});
                      }),
                  SizedBox(height: 16),
                  SliderInputCard(
                    title: "Expected Annual Inflation Rate",
                    sliderValue: annualInflationRate.toDouble(),
                    inputFormatters: [
                      MaxValueFormatter(15),
                      SingleDecimalFormatter(),
                    ],
                    controller: annualInflationRateController,
                    sliderMaxValue: 15,
                    suffixText: "%",
                    tfOnChange: (val) {
                      num temp = num.tryParse(val) ?? 0;
                      bool isValid = isValidSlider(temp);

                      if (!isValid) {
                        Utils.showError(context,
                            "Expected Annual Inflation Rate should be in-between 0-100");
                        return;
                      }

                      annualInflationRate = temp;
                      setState(() {});
                    },
                    sliderOnChange: (val) {
                      // annualInflationRate = val.round();
                      annualInflationRate =
                          double.tryParse(val.toStringAsFixed(2)) ?? 0;
                      annualInflationRateController.text =
                          "$annualInflationRate";
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  SliderInputCard(
                    title: "Expected Annual Rate of Return",
                    sliderValue: annualRateReturn.toDouble(),
                    inputFormatters: [
                      MaxValueFormatter(50),
                      SingleDecimalFormatter(),
                    ],
                    controller: annualRateReturnController,
                    suffixText: "%",
                    sliderMaxValue: 50,
                    tfOnChange: (val) {
                      num temp = num.tryParse(val) ?? 0;
                      bool isValid = isValidSlider(temp);

                      if (!isValid) {
                        Utils.showError(context,
                            "Expected Annual Rate of Return should be in-between 0-100");
                        return;
                      }

                      annualRateReturn = temp;
                      setState(() {});
                    },
                    sliderOnChange: (val) {
                      // annualRateReturn = val.round();
                      annualRateReturn =
                          double.tryParse(val.toStringAsFixed(2)) ?? 0;
                      annualRateReturnController.text = "$annualRateReturn";
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Your Current Savings",
                    initialValue: "100000",
                    inputFormatters: [
                      MaxValueFormatter(100000000, isDecimal: false),
                      // NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
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
                        bool isValid = validator();
                        if (!isValid) return;
                        print('Amount Retire = $amountRetire');
                        print('Age Today = $ageToday');
                        print('Retire Age = $retireAge');
                        print('Annual Inflation Rate = $annualInflationRate');
                        print('Annual Rate Return = $annualRateReturn');
                        print('Current Savings = $currentSavings');
                        Map data = await Api.getRetirementCalculator(
                            current_age: '$ageToday',
                            retirement_age: '$retireAge',
                            wealth_amount: '$amountRetire',
                            inflation_rate: '$annualInflationRate',
                            expected_return: '$annualRateReturn',
                            savings_amount: '$currentSavings',
                            client_name: client_name);
                        Get.to(() => RetirementCalculatorOutput(
                            expectedReturn: annualRateReturn,
                            retirementCalculatorResult: data['result']));
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

  // validator() {
  //   List l = [
  //     amountRetire,
  //     ageToday,
  //     retireAge,
  //     annualInflationRate,
  //     annualRateReturn,
  //     // currentSavings
  //   ];
  //   if (l.contains(null)) {
  //     EasyLoading.showError("All Fields are mandatory!");
  //     return false;
  //   }
  //   if (l.contains(0)) {
  //     EasyLoading.showError("Zero Not Allowed");
  //     return false;
  //   }
  //   if (ageToday >= retireAge) {
  //     EasyLoading.showError(
  //         "Please enter the retirement age not less than the current age");
  //     return false;
  //   }
  //   return true;
  // }

  validator() {
    if (amountRetire == null || amountRetire == 0) {
      EasyLoading.showError(
          "Amount Retire  is required and cannot be Empty or zero!");
      return false;
    }
    if (ageToday == null || ageToday == 0) {
      EasyLoading.showError(
          "Retirement age is required and cannot be Empty or zero!");
      return false;
    } else if (ageToday >= retireAge) {
      EasyLoading.showError(
          "Please enter the retirement age not less than the current age");
      return false;
    }

    if (retireAge == null || retireAge == 0) {
      EasyLoading.showError(
          "Retire Age is required and cannot be Empty or zero!");
      return false;
    }

    // if (annualInflationRate == '') {
    //   EasyLoading.showError(
    //       "Annual Inflation Rate is required and cannot be Empty!");
    //   return false;
    // }
    if (annualRateReturn == null || annualRateReturn == 0) {
      EasyLoading.showError(
          "Annual Rate Return is required and cannot be Empty or zero!");
      return false;
    }
    if (currentSavings >= amountRetire) {
      EasyLoading.showError(
          "Please enter the savings amount less then the retirement amount");
      return false;
    }

    return true;
  }

  bool isValidSlider(num temp) {
    if (temp < 0 || temp > 100)
      return false;
    else
      return true;
  }
}

class SingleDecimalFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    if (text.indexOf('.') != text.lastIndexOf('.')) {
      return oldValue;
    }

    if (text.contains('.')) {
      final parts = text.split('.');
      if (parts.length > 1 && parts[1].length > 2) {
        return oldValue;
      }
    }

    return newValue;
  }
}
