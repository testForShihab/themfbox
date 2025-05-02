import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/common/calculators/SIPCalculator/SipCalculatorOutput.dart';
import 'package:mymfbox2_0/common/calculators/SIPCalculator/SipTopUpCalculatorOutput.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/CalcTopCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/SliderInputCard.dart';
import 'package:mymfbox2_0/utils/Config.dart';

import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../../Investor/Registration/NomineeInfo/NomineeInfo.dart';
import '../../input_formatters.dart';

class SipCalculatorInput extends StatefulWidget {
  const SipCalculatorInput({super.key});

  @override
  State<SipCalculatorInput> createState() => _SipCalculatorInputState();
}

class _SipCalculatorInputState extends State<SipCalculatorInput> {
  late double devHeight, devWidth;
  String client_name = GetStorage().read("client_name");
  TextEditingController currentAgeController = TextEditingController();
  int currentAge = 0;

  TextEditingController monthContinueSipController =
      TextEditingController(text: "10");
  int monthContinueSip = 10;

  TextEditingController annualInflationRateController = TextEditingController();
  int annualInflationRate = 0;

  TextEditingController expectAnnualRateController =
      TextEditingController(text: "5");

  // int expectAnnualRate = 0;
  num expectAnnualRate = 5;

  TextEditingController annualTopUpController =
      TextEditingController(text: "10");
  num annualTop = 10;

  TextEditingController annualRateReturnController = TextEditingController();
  TextEditingController sipAmountController = TextEditingController(
    text: Utils.formatNumber(25000),
  );
  int annualRateReturn = 0;

  num investMonthlySip = 25000;
  num balance = 0;

  String distReturn1 = "0";

  String distReturn2 = "0";

  num currentSavings = 0;
  num energyCorpus = 0;

  bool isAnnual = false;

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;
    print(investMonthlySip);

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      extendBody: true,
      // appBar: AppBar(
      //   title: Text("SIP Calculator"),
      //   backgroundColor: Config.appTheme.themeColor,
      //   foregroundColor: Colors.white,
      //   elevation: 0,
      // ),
      appBar: rpAppBar(
        title: "SIP Calculator",
        bgColor: Config.appTheme.themeColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        height: devHeight * 0.80,
        child: SingleChildScrollView(
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
                          monthContinueSip = 10;
                          monthContinueSipController.text = "10";
                          expectAnnualRate = 10;
                          expectAnnualRateController.text = "10";
                          setState(() {});
                        },
                        child: CalcTopCard(title: "SIP", isFilled: !isAnnual)),
                    InkWell(
                        onTap: () {
                          isAnnual = true;
                          monthContinueSip = 5;
                          monthContinueSipController.text = "5";
                          expectAnnualRate = 10;
                          expectAnnualRateController.text = "10";
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
                      title: "How much can you invest through monthly SIP? (Rs)",
                      controller: sipAmountController,
                      inputFormatters: [
                        MaxValueFormatter(
                          10000000,
                          isDecimal: false,
                          isReadableInput: true,
                        ),
                        NoLeadingZeroInputFormatter(),
                        FilteringTextInputFormatter.digitsOnly,
                        ReadableNumberFormatter(),
                      ],
                      suffixText:
                          Utils.formatNumber(investMonthlySip, isAmount: true),
                      onChange: (val) {
                        log(val);
                        final tempText = val.split(',').join();
                        investMonthlySip = num.tryParse(tempText) ?? 0;
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 16),
                    Visibility(
                      visible: !isAnnual,
                      child: SliderInputCard(
                        title: "How many months will you continue the SIP?",
                        controller: monthContinueSipController,
                        sliderValue: monthContinueSip.toDouble(),
                        inputFormatters: [
                          MaxValueFormatter(999, isDecimal: false),
                          NoLeadingZeroInputFormatter(),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        sliderMaxValue: 999,
                        suffixText: "Months",
                        tfOnChange: (val) {
                          num temp = num.tryParse(val) ?? 0;

                          monthContinueSip = temp.round();
                          setState(() {});
                        },
                        sliderOnChange: (val) {
                          monthContinueSip = val.round();
                          monthContinueSipController.text = "$monthContinueSip";
                          setState(() {});
                        },
                      ),
                    ),
                    Visibility(
                      visible: isAnnual,
                      child: SliderInputCard(
                        title: "How many years will you continue the SIP?",
                        controller: monthContinueSipController,
                        sliderValue: monthContinueSip.toDouble(),
                        inputFormatters: [
                          MaxValueFormatter(100, isDecimal: false),
                          NoLeadingZeroInputFormatter(),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        sliderMaxValue: 100,
                        suffixText: "Years",
                        tfOnChange: (val) {
                          num temp = num.tryParse(val) ?? 0;

                          monthContinueSip = temp.round();
                          setState(() {});
                        },
                        sliderOnChange: (val) {
                          monthContinueSip = val.round();
                          monthContinueSipController.text = "$monthContinueSip";
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    SliderInputCard(
                        title: "What rate of return do you expect? (% per annum)",
                        controller: expectAnnualRateController,
                        sliderValue: expectAnnualRate.toDouble(),
                        inputFormatters: [
                          MaxValueFormatter(2000),
                          DoubleDecimalFormatter(),
                        ],
                        sliderMaxValue: 20,
                        suffixText: "%",
                        tfOnChange: (val) {
                          num temp = num.tryParse(val) ?? 0;

                          bool isValid = isValidSliderExpected(temp);
                          if (!isValid) {
                            Utils.showError(context,
                                "Expected Annual Rate of Return should be in-between 0-20");
                            expectAnnualRateController.text = "20";
                            expectAnnualRate = 20;
                            setState(() {});
                            return;
                          }
                          // expectAnnualRate = temp.round();
                          expectAnnualRate = temp;
                          setState(() {});
                        },
                        sliderOnChange: (val) {
                          //expectAnnualRate = val.round();
                          expectAnnualRate =
                              double.tryParse(val.toStringAsFixed(2)) ?? 0;
                          expectAnnualRateController.text = "$expectAnnualRate";
                          //print("rate of return $expectAnnualRate");
                          setState(() {});
                        }),
                    SizedBox(height: 16),
                    Visibility(
                      visible: isAnnual,
                      child: SliderInputCard(
                          title: "How much percentage step up monthly SIP? (% per annum)",
                          controller: annualTopUpController,
                          sliderValue: annualTop.toDouble(),
                          inputFormatters: [
                            MaxValueFormatter(60),
                            NoLeadingZeroInputFormatter(),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          suffixText: "%",
                          sliderMaxValue: 60,
                          tfOnChange: (val) {
                            num temp = num.tryParse(val) ?? 0;

                            bool isValid = isValidSliderTopUp(temp);
                            if (!isValid) {
                              Utils.showError(context,
                                  "Annual Top Up should be in-between 0-60");
                              annualTopUpController.text = "60";
                              annualTop = 60;
                              setState(() {});
                              return;
                            }
                            annualTop = temp;
                            setState(() {});
                          },
                          sliderOnChange: (val) {
                            annualTop = val.round();
                            annualTopUpController.text = "$annualTop";
                            setState(() {});
                          }),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
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
                  print('invest monthly mip = $investMonthlySip');
                  print('month continue sip = $monthContinueSip');
                  print('expect annual rate= $expectAnnualRate');
                  print('Annual Top Up= $annualTop');

                  Map data;
                  if (isAnnual) {
                    data = await Api.getSipTopUpCalculator(
                        sip_amount: "$investMonthlySip",
                        interest_rate: "$expectAnnualRate",
                        period: "$monthContinueSip",
                        sip_stepup_value: "$annualTop",
                        client_name: client_name);
                    Get.to(() => SipTopUpCalculatorOutput(
                          sipTopUpResult: data['result'],
                          sipAnnualtopUp: '$annualTop',
                          sipTopUpexpectAnnualRate: '$expectAnnualRate',
                        ));
                  } else {
                    data = await Api.getSipCalculator(
                        sip_amount: '$investMonthlySip',
                        interest_rate: '$expectAnnualRate',
                        period: '$monthContinueSip',
                        client_name: client_name);

                    Get.to(
                        () => SipCalculatorOutput(apiResult: data['result']));
                  }
                  EasyLoading.dismiss();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Config.appTheme.buttonColor,
                    foregroundColor:
                        Colors.white // Set the background color here
                    ),
                child: Text("CALCULATE"))),
      ),
    );
  }

  static bool isValidSliderSip(num temp) {
    if (temp < 0 || temp > 999)
      return false;
    else
      return true;
  }

  static bool isValidSliderExpected(num temp) {
    if (temp < 0 || temp > 20)
      return false;
    else
      return true;
  }

  static bool isValidSliderTopUp(num temp) {
    if (temp < 0 || temp > 60)
      return false;
    else
      return true;
  }

/*  validator() {
    List l = [investMonthlySip, monthContinueSip, expectAnnualRate];
    if (l.contains(null) || l.contains(0)) {
      EasyLoading.showError("All Fields are mandatory!");
      return false;
    }
    */ /*  if (l.contains(0)) {
      EasyLoading.showError("Zero Not Allowed");
      return false;
    }*/ /*
    return true;
  }*/
  validator() {
    /*  List l = [investMonthlySip, monthContinueSip, expectAnnualRate];

   if (l.contains(null) || l.contains(0)) {
      EasyLoading.showError("All Fields are mandatory!");
      return false;
    }*/

    if (investMonthlySip == 0) {
      EasyLoading.showError("SIP Amount should not be 0");
      return false;
    }

    if (monthContinueSip == 0) {
      EasyLoading.showError("SIP months should not be 0.");
      return false;
    }

    if (expectAnnualRate == 0) {
      EasyLoading.showError("Annual Rate of Return should not be 0.");
      return false;
    }

    if (isAnnual && annualTop == 0) {
      EasyLoading.showError("Annual Top Up should not be 0.");
      return false;
    }
    return true;
  }
}
