import 'package:flutter/material.dart';
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
                    title:
                        "How many Crores (at current value) you would need to consider yourself wealthy",
                    initialValue: "50000000",
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
                    suffixText: 'Years',
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
                    title: "Age when you want to become a Crorepati",
                    controller: ageBecomeController,
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
                    title: "Expected Annual Inflation Rate",
                    sliderValue: annualInflationRate.toDouble(),
                    controller: annualInflationRateController,
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
                      annualInflationRate = val.round();
                      annualInflationRateController.text =
                          "$annualInflationRate";
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  SliderInputCard(
                    title: "Expected Annual Rate of Return",
                    sliderValue: annualRateReturn.toDouble(),
                    controller: annualRateReturnController,
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
                      annualRateReturn = val.round();
                      annualRateReturnController.text = "$annualRateReturn";
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Your Current Savings",
                    initialValue: "2500000",
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
    List l = [
      amountRetire,
      ageToday,
      ageBecome,
      annualInflationRate,
      annualRateReturn,
      currentSavings
    ];
    if (l.contains(null)) {
      EasyLoading.showError("All Fields are mandatory!");
      return false;
    }
    if (l.contains(0)) {
      EasyLoading.showError("Zero Not Allowed");
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
