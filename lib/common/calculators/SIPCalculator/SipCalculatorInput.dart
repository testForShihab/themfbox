import 'package:flutter/material.dart';
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
                      title: "How much can you invest through monthly SIP?",
                      initialValue: "25000",
                      suffixText:
                          Utils.formatNumber(investMonthlySip, isAmount: true),
                      onChange: (val) {
                        investMonthlySip = num.tryParse(val) ?? 0;
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 16),
                    SliderInputCard(
                      title: "How many months will you continue the SIP?",
                      controller: monthContinueSipController,
                      sliderValue: monthContinueSip.toDouble(),
                      sliderMaxValue: 900,
                      suffixText: "Months",
                      tfOnChange: (val) {
                        num temp = num.tryParse(val) ?? 0;

                        bool isValid = isValidSliderSip(temp);
                        if (!isValid) {
                          Utils.showError(
                              context, "Value should be in-between 0-100");
                          return;
                        }
                        monthContinueSip = temp.round();
                        setState(() {});
                      },
                      sliderOnChange: (val) {
                        monthContinueSip = val.round();
                        monthContinueSipController.text = "$monthContinueSip";
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 16),
                    SliderInputCard(
                        title: "Expected Annual Rate of Return",
                        controller: expectAnnualRateController,
                        sliderValue: expectAnnualRate.toDouble(),
                        suffixText: "%",
                        tfOnChange: (val) {
                          num temp = num.tryParse(val) ?? 0;

                          bool isValid = Utils.isValidSlider(temp);
                          if (!isValid) {
                            Utils.showError(context,
                                "Expected Annual Rate of Return should be in-between 0-100");
                            return;
                          }
                          // expectAnnualRate = temp.round();
                          expectAnnualRate = temp;
                          setState(() {});
                        },
                        sliderOnChange: (val) {
                          expectAnnualRate = val.round();
                          expectAnnualRateController.text = "$expectAnnualRate";
                          setState(() {});
                        }),
                    SizedBox(height: 16),
                    Visibility(
                      visible: isAnnual,
                      child: SliderInputCard(
                          title: "Annual Top Up",
                          controller: annualTopUpController,
                          sliderValue: annualTop.toDouble(),
                          suffixText: "%",
                          tfOnChange: (val) {
                            num temp = num.tryParse(val) ?? 0;

                            bool isValid = Utils.isValidSlider(temp);
                            if (!isValid) {
                              Utils.showError(context,
                                  "Annual Top Up should be in-between 0-100");
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
                    backgroundColor: Config.appTheme.themeColor,
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

  validator() {
    List l = [investMonthlySip, monthContinueSip, expectAnnualRate];
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
}
