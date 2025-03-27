import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/common/calculators/LumpsumCalculator/LumpsumCalculatorOutput.dart';
import 'package:mymfbox2_0/rp_widgets/SliderInputCard.dart';
import 'package:mymfbox2_0/utils/Config.dart';

import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/CalculateButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class LumpsumCalculatorInput extends StatefulWidget {
  const LumpsumCalculatorInput({super.key});

  @override
  State<LumpsumCalculatorInput> createState() => _LumpsumCalculatorInputState();
}

class _LumpsumCalculatorInputState extends State<LumpsumCalculatorInput> {
  late double devHeight, devWidth;
  String client_name = GetStorage().read("client_name");

  TextEditingController currentAgeController = TextEditingController();
  int currentAge = 0;

  TextEditingController yearsNeedAmtController =
      TextEditingController(text: "30");
  int yearsNeedAmt = 30;

  TextEditingController annualInflationRateController = TextEditingController();
  int annualInflationRate = 0;

  TextEditingController expectRateReturnController =
      TextEditingController(text: "12");
  num expectRateReturn = 12;

  TextEditingController annualRateReturnController = TextEditingController();
  int annualRateReturn = 0;

  num investLumpsumAmt = 5000000;
  num balance = 0;

  String distReturn1 = "0";

  String distReturn2 = "0";

  num currentSavings = 0;
  num energyCorpus = 0;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;
    devHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Lumpsum Calculator",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: SizedBox(
          height: devHeight - kToolbarHeight - 22,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      AmountInputCard(
                        title: "How much lumpsum amount you want to invest ?",
                        initialValue: "5000000",
                        suffixText: Utils.formatNumber(investLumpsumAmt,
                            isAmount: true),
                        onChange: (val) {
                          investLumpsumAmt = num.tryParse(val) ?? 0;
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 16),
                      SliderInputCard(
                        title: "After how many years you need this amount?",
                        controller: yearsNeedAmtController,
                        sliderValue: yearsNeedAmt.toDouble(),
                        suffixText: "Years",
                        tfOnChange: (val) {
                          num temp = num.tryParse(val) ?? 0;
                          print('temp $temp');
                          bool isValid = isValidSlider(temp);
                          if (!isValid) {
                            Utils.showError(
                                context, "Years should be in-between 0-100");
                            yearsNeedAmtController.text = "";
                            return;
                          }

                          yearsNeedAmt = temp.round();
                          setState(() {});
                        },
                        sliderOnChange: (val) {
                          yearsNeedAmt = val.round();
                          yearsNeedAmtController.text = "$yearsNeedAmt";
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 16),
                      SliderInputCard(
                          title: "Expected Rate of Return",
                          controller: expectRateReturnController,
                          sliderValue: expectRateReturn.toDouble(),
                          suffixText: "%",
                          tfOnChange: (val) {
                            num temp = num.tryParse(val) ?? 0;

                            bool isValid = isValidSlider(temp);
                            if (!isValid) {
                              Utils.showError(context,
                                  "Expected Rate of Return should be in-between 0-100");
                              return;
                            }
                            expectRateReturn = temp;
                            setState(() {});
                          },
                          sliderOnChange: (val) {
                            expectRateReturn = val.round();
                            expectRateReturnController.text =
                                "$expectRateReturn";
                            setState(() {});
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: CalculateButton(
        onPress: () async {
          print('invest lumpsum amt = $investLumpsumAmt');
          print('years need amt = $yearsNeedAmt');
          print('expect rate return= $expectRateReturn');
          bool isValid = validator();
          if (!isValid) return;

          Map data = await Api.getLumpsumCalculator(
              lumpsum_amount: '$investLumpsumAmt',
              years: '$yearsNeedAmt',
              expected_return: '$expectRateReturn',
              client_name: client_name);
          Get.to(() => LumpsumCalculatorOutput(lumpsumResult: data['result']));
        },
      ),
    );
  }

  validator() {
    List l = [investLumpsumAmt, yearsNeedAmt, expectRateReturn];
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
