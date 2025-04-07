import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/common/calculators/GoalBasedLumpsumCalculator/GoalLumpsumCalculatorOutput.dart';
import 'package:mymfbox2_0/rp_widgets/SliderInputCard.dart';
import 'package:mymfbox2_0/utils/Config.dart';

import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../input_formatters.dart';

class GoalBasedLumpsumCalculatorInput extends StatefulWidget {
  const GoalBasedLumpsumCalculatorInput({super.key});

  @override
  State<GoalBasedLumpsumCalculatorInput> createState() =>
      _GoalBasedLumpsumCalculatorState();
}

class _GoalBasedLumpsumCalculatorState
    extends State<GoalBasedLumpsumCalculatorInput> {
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

  num targetAmount = 5000000;
  num balance = 0;

  String distReturn1 = "0";

  String distReturn2 = "0";

  num currentSavings = 0;
  num energyCorpus = 0;

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Goal Based Lumpsum Calculator",
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
                    title: "Target Amount",
                    initialValue: "5000000",
                    inputFormatters: [
                      MaxValueFormatter(1000000000, isDecimal: false),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    suffixText:
                        Utils.formatNumber(targetAmount, isAmount: true),
                    onChange: (val) {
                      targetAmount = num.tryParse(val) ?? 0;
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
                    inputFormatters: [
                      MaxValueFormatter(50),
                      SingleDecimalFormatter(),
                    ],
                    title: "Expected Annual Rate of Return",
                    sliderValue: annualRateReturn.toDouble(),
                    controller: annualRateReturnController,
                    sliderMaxValue: 50,
                    suffixText: "%",
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
                      annualRateReturn = double.tryParse(val.toStringAsFixed(2)) ?? 0;
                      annualRateReturnController.text = "$annualRateReturn";
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        width: devWidth,
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: SizedBox(
            height: 45,
            child: ElevatedButton(
                onPressed: () async {
                  EasyLoading.show();

                  bool isValid = validator();
                  if (!isValid) return;

                  print('Target Amount = $targetAmount');
                  print('Investment Period = $investmentPeriod');
                  print('Annual Rate Return = $annualRateReturn');

                  Map data = await Api.getGoalBasedLumpsumCalculator(
                      target_amount: '$targetAmount',
                      years: '$investmentPeriod',
                      expected_return: '$annualRateReturn',
                      client_name: client_name);
                  Get.to(() => GoalLumpsumCalculatorOutput(
                      goalBasedLumpsumResult: data['result']));

                  EasyLoading.dismiss();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Config.appTheme.themeColor,
                    foregroundColor:
                        Colors.white // Set the background color here
                    ),
                child: Text("CALCULATE"))),
      ),
    );
  }

  // validator() {
  //   List l = [targetAmount, investmentPeriod, annualRateReturn];
  //   if (l.contains(null)) {
  //     EasyLoading.showError("All Fields are mandatory!");
  //     return false;
  //   }
  //   if (l.contains(0)) {
  //     EasyLoading.showError("Zero Not Allowed");
  //     return false;
  //   }
  //   return true;
  // }
  validator() {
    if (targetAmount == 0) {
      EasyLoading.showError("Target Amount is required and cannot be Empty or zero!");
      return false;
    }
    if (investmentPeriod == 0) {
      EasyLoading.showError("Investment Period is required and cannot be Empty or zero!");
      return false;
    }
    if (annualRateReturn == null) {
      EasyLoading.showError("Expected Annual Rate of Return is required and cannot be Empty or zero!");
      return false;
    } else if (annualRateReturn == 0) {
      EasyLoading.showError("Expected Annual Rate of Return is required and cannot be Empty or zero!");
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

