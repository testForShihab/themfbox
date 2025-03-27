import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/common/calculators/LoanEmiCalculator/LoanEmiCalculatorOutput.dart';
import 'package:mymfbox2_0/rp_widgets/SliderInputCard.dart';
import 'package:mymfbox2_0/utils/Config.dart';

import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/CalculateButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class LoanEmiCalculatorInput extends StatefulWidget {
  const LoanEmiCalculatorInput({super.key});

  @override
  State<LoanEmiCalculatorInput> createState() => _LoanEmiCalculatorInputState();
}

class _LoanEmiCalculatorInputState extends State<LoanEmiCalculatorInput> {
  late double devHeight, devWidth;
  String client_name = GetStorage().read("client_name");
  TextEditingController currentAgeController = TextEditingController();
  int currentAge = 0;

  TextEditingController annualInterestRateController =
      TextEditingController(text: "12.5");
  num annualInterestRate = 12.5;

  TextEditingController loanTenureController =
      TextEditingController(text: "20");
  int loanTenure = 20;

  num loanAmount = 2500000;
  num balance = 0;

  String distReturn1 = "0";

  String distReturn2 = "0";

  num currentSavings = 0;
  num energyCorpus = 0;

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Loan EMI Calculator",
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
                    title: "Loan Amount",
                    initialValue: "2500000",
                    suffixText: Utils.formatNumber(loanAmount, isAmount: true),
                    onChange: (val) {
                      loanAmount = num.tryParse(val) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  SliderInputCard(
                      title: "Annual Interest Rate",
                      controller: annualInterestRateController,
                      sliderValue: annualInterestRate.toDouble(),
                      suffixText: "%",
                      tfOnChange: (val) {
                        num temp = num.tryParse(val) ?? 0;

                        bool isValid = isValidSlider(temp);
                        if (!isValid) {
                          Utils.showError(context,
                              "Annual Interest Rate should be in-between 0-100");
                          return;
                        }
                        annualInterestRate = temp;
                        setState(() {});
                      },
                      sliderOnChange: (val) {
                        annualInterestRate = val.round();
                        annualInterestRateController.text =
                            "$annualInterestRate";
                        setState(() {});
                      }),
                  SizedBox(height: 16),
                  SliderInputCard(
                    title: "Loan Tenure",
                    controller: loanTenureController,
                    sliderValue: loanTenure.toDouble(),
                    suffixText: "Years",
                    tfOnChange: (val) {
                      num temp = num.tryParse(val) ?? 0;

                      bool isValid = isValidSlider(temp);
                      if (!isValid) {
                        Utils.showError(
                            context, "Loan Tenure should be in-between 0-100");
                        return;
                      }
                      loanTenure = temp.round();
                      setState(() {});
                    },
                    sliderOnChange: (val) {
                      loanTenure = val.round();
                      loanTenureController.text = "$loanTenure";
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomSheet: CalculateButton(
        onPress: () async {
          bool isValid = validator();
          if (!isValid) return;
          print('Loan Amount = $loanAmount');
          print('Annual Interest Rate = $annualInterestRate');
          print('Loan Tenure  = $loanTenure');

          Map data = await Api.getEmiCalculator(
              loan_amount: '$loanAmount',
              interest_rate: '$annualInterestRate',
              loan_tenure_type: 'year',
              loan_tenure: '$loanTenure',
          client_name: client_name);
          Get.to(() =>
              LoanEmiCalculatorOutput(loanEmiCalculatorResult: data['result']));
        },
      ),
    );
  }

  validator() {
    List l = [loanAmount, annualInterestRate, loanTenure];
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
