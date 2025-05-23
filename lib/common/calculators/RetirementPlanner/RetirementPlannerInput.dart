import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/common/calculators/RetirementPlanner/RetirementPlannerOutput.dart';
import 'package:mymfbox2_0/rp_widgets/CalculatorTf.dart';
import 'package:mymfbox2_0/rp_widgets/SliderInputCard.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';

import '../../input_formatters.dart';

class RetirementPlannerInput extends StatefulWidget {
  const RetirementPlannerInput({super.key});

  @override
  State<RetirementPlannerInput> createState() => _RetirementPlannerInputState();
}

class _RetirementPlannerInputState extends State<RetirementPlannerInput> {
  late double devHeight, devWidth;
  String client_name = GetStorage().read("client_name");
  TextEditingController currentAgeController =
      TextEditingController(text: "30");
  int currentAge = 30;

  TextEditingController retirementAgeController =
      TextEditingController(text: "60");
  int retirementAge = 60;

  TextEditingController endAgeController = TextEditingController(text: "85");
  int endAge = 85;

  TextEditingController inflationController = TextEditingController(text: "6");
  num inflation = 6;

  num monthlyExpense = 100000;
  num balance = 5000000;

  String accuReturn1 = "12";
  String distReturn1 = "7";

  String accuReturn2 = "10";
  String distReturn2 = "8";

  num currentSavings = 1500000;
  num energyCorpus = 300000;

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Retirement Planner",
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
                  SliderInputCard(
                    title: "Current Age",
                    controller: currentAgeController,
                    sliderValue: currentAge.toDouble(),
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
                            context, "Current Age should be in-between 0-100");
                        return;
                      }
                      currentAge = temp.round();
                      setState(() {});
                    },
                    sliderOnChange: (val) {
                      currentAge = val.round();
                      currentAgeController.text = "$currentAge";
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  SliderInputCard(
                    title: "Retirement Age",
                    controller: retirementAgeController,
                    sliderValue: retirementAge.toDouble(),
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
                        Utils.showError(context,
                            "Retirement Age should be in-between 0-100");
                        return;
                      }
                      retirementAge = temp.round();
                      setState(() {});
                    },
                    sliderOnChange: (val) {
                      retirementAge = val.round();
                      retirementAgeController.text = "$retirementAge";
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  SliderInputCard(
                      title: "Annuity Ends at Age",
                      controller: endAgeController,
                      sliderValue: endAge.toDouble(),
                      suffixText: "Years",
                      inputFormatters: [
                        MaxValueFormatter(100, isDecimal: false),
                        NoLeadingZeroInputFormatter(),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      tfOnChange: (val) {
                        num temp = num.tryParse(val) ?? 0;

                        bool isValid = isValidSlider(temp);
                        if (!isValid) {
                          Utils.showError(context,
                              "Annuity Ends at Age should be in-between 0-100");
                          return;
                        }
                        endAge = temp.round();
                        setState(() {});
                      },
                      sliderOnChange: (val) {
                        endAge = val.round();
                        endAgeController.text = "$endAge";
                        setState(() {});
                      }),
                  SizedBox(height: 16),
                  AmountInputCard(
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
                    title: "Current Monthly Expense",
                    initialValue: Utils.formatNumber(100000),
                    suffixText:
                        Utils.formatNumber(monthlyExpense, isAmount: true),
                    onChange: (val) {
                      final tempVal = val.split(',').join();
                      monthlyExpense = num.tryParse(tempVal) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                      title: "Balance Required at Age $endAge",
                      initialValue: Utils.formatNumber(5000000),
                      inputFormatters: [
                        MaxValueFormatter(
                          1000000000,
                          isDecimal: false,
                          isReadableInput: true,
                        ),
                        FilteringTextInputFormatter.digitsOnly,
                        ReadableNumberFormatter(),
                      ],
                      suffixText: Utils.formatNumber(balance, isAmount: true),
                      onChange: (val) {
                        final tempVal = val.split(',').join();
                        balance = num.tryParse(tempVal) ?? 0;
                        setState(() {});
                      }),
                  SizedBox(height: 16),
                  SliderInputCard(
                    title: "Inflation Rate",
                    sliderValue: inflation.toDouble(),
                    controller: inflationController,
                    inputFormatters: [
                      MaxValueFormatter(15),
                      DoubleDecimalFormatter(),
                    ],
                    sliderMaxValue: 15,
                    suffixText: "%",
                    tfOnChange: (val) {
                      num temp = num.tryParse(val) ?? 0;
                      bool isValid = isValidSlider(temp);

                      if (!isValid) {
                        Utils.showError(context,
                            "Inflation Rate should be in-between 0-100");
                        return;
                      }

                      inflation = temp;
                      setState(() {});
                    },
                    sliderOnChange: (val) {
                      inflation = double.tryParse(val.toStringAsFixed(2)) ?? 0;
                      inflationController.text = "$inflation";
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  scenarioInputCard(
                    title: "Scenario 1",
                    initialValue1: "12",
                    initialValue2: "7",
                    st1: "Accumulation Return",
                    st2: "Distribution Return",
                    formatters: [
                      MaxValueFormatter(50, isDecimal: false),
                      DoubleDecimalFormatter(),
                    ],
                    onChange1: (val) => accuReturn1 = val,
                    onChange2: (val) => distReturn1 = val,
                  ),
                  SizedBox(height: 16),
                  scenarioInputCard(
                    title: "Scenario 2",
                    initialValue1: "10",
                    initialValue2: "8",
                    st1: "Accumulation Return",
                    st2: "Distribution Return",
                    formatters: [
                      MaxValueFormatter(50, isDecimal: false),
                      DoubleDecimalFormatter(),
                    ],
                    onChange1: (val) => accuReturn2 = val,
                    onChange2: (val) => distReturn2 = val,
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Current Savings",
                    initialValue: Utils.formatNumber(1500000),
                    inputFormatters: [
                      MaxValueFormatter(
                        100000000,
                        isDecimal: false,
                        isReadableInput: true,
                      ),
                      SingleLeadingZeroFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                      ReadableNumberFormatter(),
                    ],
                    onChange: (val) {
                      final tempVal = val.split(',').join();
                      currentSavings = num.tryParse(tempVal) ?? 0;
                      setState(() {});
                    },
                    suffixText:
                        Utils.formatNumber(currentSavings, isAmount: true),
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Emergency Corpus",
                    initialValue: Utils.formatNumber(300000),
                    inputFormatters: [
                      MaxValueFormatter(100000000,
                          isDecimal: false, isReadableInput: true),
                      SingleLeadingZeroFormatter(),
                      FilteringTextInputFormatter.digitsOnly,
                      ReadableNumberFormatter(),
                    ],
                    onChange: (val) {
                      final tempVal = val.split(',').join();
                      energyCorpus = num.tryParse(tempVal) ?? 0;
                      setState(() {});
                    },
                    suffixText:
                        Utils.formatNumber(energyCorpus, isAmount: true),
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

                        EasyLoading.show();
                        Map data = await Api.getRetirementPlanning(
                            currentAge: currentAge,
                            retirementAge: retirementAge,
                            endAge: endAge,
                            monthlyExpense: monthlyExpense,
                            balance_required: balance,
                            inflation_rate: inflation,
                            scenario1_accumulation_return: accuReturn1,
                            scenario1_distribution_return: distReturn1,
                            scenario2_accumulation_return: accuReturn2,
                            scenario2_distribution_return: distReturn2,
                            current_savings_amount: currentSavings,
                            emergency_corpus_required: energyCorpus,
                            client_name: client_name);
                        EasyLoading.dismiss();

                        print('currentAge = $currentAge');
                        print('retirementAge = $retirementAge');
                        print('endAge = $endAge');
                        print('monthlyExpense = $monthlyExpense');
                        print('balance = $balance');
                        print('inflation = $inflation');
                        print('accuReturn1 = $accuReturn1');
                        print('distReturn1 = $distReturn1');
                        print('accuReturn2 = $accuReturn2');
                        print('distReturn2 = $distReturn2');
                        print('currentSavings = $currentSavings');
                        print('energyCorpus = $energyCorpus');

                        Get.to(() => RetirementPlannerOutput(
                              currentAge: currentAge,
                              retirementAge: retirementAge,
                              endAge: endAge,
                              targetAmount: balance.toInt(),
                              currentInvestment: currentSavings,
                              monthlyExpense: monthlyExpense,
                              result: data['result'],
                              energyCorpus: energyCorpus,
                              inflation: inflation,
                            ));
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
    List l = [
      currentAge,
      retirementAge,
      endAge,
      monthlyExpense,
      // balance,
      // inflation,
      accuReturn1,
      distReturn1,
      // accuReturn2,
      // distReturn2,
      // currentSavings,
      // energyCorpus
    ];
    if (currentAge == 0) {
      EasyLoading.showError("Current age is mandatory");
      return false;
    }
    if (retirementAge == 0) {
      EasyLoading.showError("Retirement age is mandatory");
      return false;
    }
    if (currentAge >= retirementAge) {
      EasyLoading.showError(
          "Retirement age should be greater than current age");
      return false;
    }
    if (endAge < retirementAge) {
      EasyLoading.showError(
          "Annuity ends age should be greater than retirement age");
      return false;
    }
    if (endAge == 0) {
      EasyLoading.showError("Annuity ends age is mandatory");
      return false;
    }
    if (monthlyExpense == 0) {
      EasyLoading.showError("Current monthly expense is mandatory");
      return false;
    }
    if (accuReturn1.isEmpty ||
        accuReturn1 == '0' ||
        distReturn1.isEmpty ||
        distReturn1 == '0') {
      EasyLoading.showError("Scenario 1 is mandatory");
      return false;
    }
    if (l.contains(null) || l.contains(0)) {
      EasyLoading.showError("All Fields are mandatory!");
      return false;
    }
    // if (l.contains(0)) {
    //   EasyLoading.showError("Zero Not Allowed");
    //   return false;
    // }
    return true;
  }

  Widget scenarioInputCard({
    required String title,
    required String st1,
    required String st2,
    required String initialValue1,
    required String initialValue2,
    Function(String)? onChange1,
    Function(String)? onChange2,
    List<TextInputFormatter> formatters = const [],
  }) {
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
          SizedBox(height: 10),
          Text(st1, style: AppFonts.f50012),
          CalculatorTf(
            inputFormatters: formatters,
            initialValue: initialValue1,
            suffixText: "%",
            onChange: onChange1,
          ),
          SizedBox(height: 10),
          Text(st2, style: AppFonts.f50012),
          CalculatorTf(
            inputFormatters: formatters,
            initialValue: initialValue2,
            suffixText: "%",
            onChange: onChange2,
          ),
        ],
      ),
    );
  }

  bool isValidSlider(num temp) {
    if (temp < 0 || temp > 100)
      return false;
    else
      return true;
  }
}
