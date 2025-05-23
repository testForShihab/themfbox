import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/common/calculators/CompoundingCalculator/CompoundingCalculatorOutput.dart';
import 'package:mymfbox2_0/rp_widgets/SliderInputCard.dart';
import 'package:mymfbox2_0/utils/Config.dart';

import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/CalculatorTf.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../input_formatters.dart';

class CompoundingCalculatorInput extends StatefulWidget {
  const CompoundingCalculatorInput({super.key});

  @override
  State<CompoundingCalculatorInput> createState() =>
      _CompoundingCalculatorInputState();
}

class _CompoundingCalculatorInputState
    extends State<CompoundingCalculatorInput> {
  late double devHeight, devWidth;
  int compoundInterval = 1; // Default selected value
  TextEditingController currentAgeController = TextEditingController();
  String client_name = GetStorage().read("client_name");
  int currentAge = 0;

  TextEditingController noOfYearsController = TextEditingController(text: "20");
  int noOfYears = 20;

  TextEditingController annualRateReturnController = TextEditingController();
  int annualRateReturn = 0;

  TextEditingController annualInterestRateController =
      TextEditingController(text: "12.5");
  num annualInterestRate = 12.5;

  num principalAmount = 2500000;
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
      extendBody: true,
      appBar: rpAppBar(
          title: "Compounding Calculator",
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
                    title: "Principal Amount (Rs)",
                    initialValue: Utils.formatNumber(2500000),
                    inputFormatters: [
                      MaxValueFormatter(
                        100000000,
                        isDecimal: false,
                        isReadableInput: true,
                      ),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                      ReadableNumberFormatter(),
                    ],
                    suffixText:
                        Utils.formatNumber(principalAmount, isAmount: true),
                    onChange: (val) {
                      final tempVal = val.split(',').join();
                      principalAmount = num.tryParse(tempVal) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  SliderInputCard(
                      title: "Interest Rate (% per annum)",
                      controller: annualInterestRateController,
                      sliderValue: annualInterestRate.toDouble(),
                      suffixText: "%",
                      sliderMaxValue: 20,
                      inputFormatters: [
                        MaxValueFormatter(20),
                        DoubleDecimalFormatter(),
                      ],
                      tfOnChange: (val) {
                        num temp = num.tryParse(val) ?? 0;
                        bool isValid = israteValidSlider(temp);
                        if (!isValid && temp <= 0) {
                          Utils.showError(context,
                              "Annual Interest Rate should be in-between 0-20 %");
                          return;
                        }
                        annualInterestRate = temp;
                        setState(() {});
                      },
                      sliderOnChange: (val) {
                        annualInterestRate =
                            double.tryParse(val.toStringAsFixed(2)) ?? 0;
                        annualInterestRateController.text =
                            "$annualInterestRate";
                        setState(() {});
                      }),
                  SizedBox(height: 16),
                  SliderInputCard(
                    title: "Period (in years)",
                    controller: noOfYearsController,
                    sliderValue: noOfYears.toDouble(),
                    suffixText: "Years",
                    inputFormatters: [
                      MaxValueFormatter(30, isDecimal: false),
                      NoLeadingZeroInputFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    tfOnChange: (val) {
                      num temp = num.tryParse(val) ?? 0;
                      bool isValid = isValidSlider(temp);

                      if (!isValid) {
                        Utils.showError(context,
                            "Number of Years should be in-between 0-100");
                        return;
                      }
                      noOfYears = temp.round();
                      setState(() {});
                    },
                    sliderOnChange: (val) {
                      noOfYears = val.round();
                      noOfYearsController.text = "$noOfYears";
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: devWidth,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Compound interval", style: AppFonts.f50014Black),
                        Row(
                          children: [
                            Radio(
                              value: 1,
                              groupValue: compoundInterval,
                              onChanged: (value) {
                                setState(() {
                                  compoundInterval = value!;
                                });
                              },
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    compoundInterval = 1;
                                  });
                                },
                                child: Text('Yearly',
                                    style: AppFonts.f50014Grey.copyWith(
                                        color: Config.appTheme.themeColor))),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 2,
                              groupValue: compoundInterval,
                              onChanged: (value) {
                                setState(() {
                                  compoundInterval = value!;
                                });
                              },
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    compoundInterval = 2;
                                  });
                                },
                                child: Text('Half Yearly',
                                    style: AppFonts.f50014Grey.copyWith(
                                        color: Config.appTheme.themeColor))),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 3,
                              groupValue: compoundInterval,
                              onChanged: (value) {
                                setState(() {
                                  compoundInterval = value!;
                                });
                              },
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    compoundInterval = 3;
                                  });
                                },
                                child: Text('Quarterly',
                                    style: AppFonts.f50014Grey.copyWith(
                                        color: Config.appTheme.themeColor))),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 4,
                              groupValue: compoundInterval,
                              onChanged: (value) {
                                setState(() {
                                  compoundInterval = value!;
                                });
                              },
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    compoundInterval = 4;
                                  });
                                },
                                child: Text('Monthly',
                                    style: AppFonts.f50014Grey.copyWith(
                                        color: Config.appTheme.themeColor))),
                          ],
                        ),
                      ],
                    ),
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

                        print('Principal Amount = $principalAmount');
                        print('Annual Interest Rate  = $annualInterestRate');
                        print('no Of Years = $noOfYears');
                        String cmpInterval;
                        switch (compoundInterval) {
                          case 1:
                            cmpInterval = 'Yearly';
                          case 2:
                            cmpInterval = 'Half Yearly';
                          case 3:
                            cmpInterval = 'Quarterly';
                          case 4:
                            cmpInterval = 'Monthly';
                          default:
                            cmpInterval = '';
                        }
                        print('Compound Interval = $cmpInterval');
                        Map data = await Api.getCompoundingCalculator(
                            principal_amount: '$principalAmount',
                            interest_rate: '$annualInterestRate',
                            period: '$noOfYears',
                            compound_interval: cmpInterval,
                            client_name: client_name);

                        Get.to(() => CompoundingCalculatorOutput(
                            compoundingCalculatorResult: data['result']));

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
    /* List l = [principalAmount, annualInterestRate, noOfYears];
    if (l.contains(null)) {
      EasyLoading.showError("All Fields are mandatory!");
      return false;
    }
    if (l.contains(0)) {
      EasyLoading.showError("Zero Not Allowed");
      return false;
    }*/

    if (principalAmount <= 0) {
      EasyLoading.showError("Principal Amount should be greater than 0");
      return false;
    }

    if (annualInterestRate <= 0) {
      EasyLoading.showError("Annual Interest Rate should be greater than 0");
      return false;
    }
    if (noOfYears <= 0) {
      EasyLoading.showError("Number of Years should be greater than 0");
      return false;
    }
    return true;
  }

  Widget radioInputCard(
      {required String title,
      Function(String)? onChange,
      required String suffixText}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppFonts.f50014Black),
          SizedBox(height: 5),
          CalculatorTf(
            onChange: onChange,
            suffixText: suffixText,
          )
        ],
      ),
    );
  }
}

bool isValidSlider(num temp) {
  if (temp < 0 || temp > 30)
    return false;
  else
    return true;
}

bool israteValidSlider(num temp) {
  if (temp < 0 || temp > 20)
    return false;
  else
    return true;
}
