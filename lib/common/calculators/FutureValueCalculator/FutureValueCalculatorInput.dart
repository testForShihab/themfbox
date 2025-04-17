import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/common/calculators/FutureValueCalculator/FutureValueCalculatorOutput.dart';
import 'package:mymfbox2_0/common/input_formatters.dart';
import 'package:mymfbox2_0/rp_widgets/SliderInputCard.dart';
import 'package:mymfbox2_0/utils/Config.dart';

import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/CalculateButton.dart';
import 'package:mymfbox2_0/rp_widgets/CalculatorTf.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class FutureValueCalculatorInput extends StatefulWidget {
  const FutureValueCalculatorInput({super.key});

  @override
  State<FutureValueCalculatorInput> createState() =>
      _FutureValueCalculatorInputState();
}

class _FutureValueCalculatorInputState
    extends State<FutureValueCalculatorInput> {
  late double devHeight, devWidth;
  String client_name = GetStorage().read("client_name");

  TextEditingController currentAgeController = TextEditingController();
  int currentAge = 0;

  TextEditingController numberOfYearsController =
      TextEditingController(text: "10");
  int numberOfYears = 10;

  TextEditingController annualInflationRateController =
      TextEditingController(text: "6");
  num annualInflationRate = 6;

  num currentCost = 2500000;
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
          title: "Future Value Calculator",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: SizedBox(
          height: devHeight - kToolbarHeight - 22,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    AmountInputCard(
                      title: "Current Cost",
                      initialValue: Utils.formatNumber(2500000),
                      inputFormatters: [
                        MaxValueFormatter(1000000000, isReadableInput: true),
                        NoLeadingZeroInputFormatter(),
                        FilteringTextInputFormatter.digitsOnly,
                        ReadableNumberFormatter(),
                      ],
                      suffixText:
                          Utils.formatNumber(currentCost, isAmount: true),
                      onChange: (val) {
                        final tempVal = val.split(',').join();
                        currentCost = num.tryParse(tempVal) ?? 0;
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 16),
                    SliderInputCard(
                      title: "Number of Years",
                      controller: numberOfYearsController,
                      sliderValue: numberOfYears.toDouble(),
                      suffixText: 'Years',
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
                              "Number of Years should be in-between 0-100");
                          return;
                        }

                        numberOfYears = temp.round();
                        setState(() {});
                      },
                      sliderOnChange: (val) {
                        numberOfYears = val.round();
                        numberOfYearsController.text = "$numberOfYears";
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 16),
                    SliderInputCard(
                        title: "The expected rate of inflation over the years",
                        controller: annualInflationRateController,
                        sliderValue: annualInflationRate.toDouble(),
                        suffixText: "%",
                        sliderMaxValue: 15,
                        inputFormatters: [
                          MaxValueFormatter(50, isDecimal: true),
                          DoubleDecimalFormatter(),
                        ],
                        tfOnChange: (val) {
                          num temp = num.tryParse(val) ?? 0;

                          bool isValid = isinflatioinValidSlider(temp);
                          if (!isValid) {
                            Utils.showError(context,
                                "Expected Annual Inflation Rate should be in-between 0-100");
                            return;
                          }
                          annualInflationRate = temp;
                          setState(() {});
                        },
                        sliderOnChange: (val) {
                          annualInflationRate =
                              double.tryParse(val.toStringAsFixed(2)) ?? 0;
                          annualInflationRateController.text =
                              "$annualInflationRate";
                          setState(() {});
                        }),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomSheet: CalculateButton(
        onPress: () async {
          EasyLoading.show();
          bool isValid = validator();
          if (!isValid) return;
          print('Current Cost = $currentCost');
          print('Number Of Years = $numberOfYears');
          print('Annual Inflation Rate  = $annualInflationRate');
          Map data = await Api.getFutureValueCalculator(
              current_cost: '$currentCost',
              inflation_rate: '$annualInflationRate',
              years: '$numberOfYears',
              client_name: client_name);

          Get.to(() =>
              FutureValueCalculatorOutput(futureValueResult: data['result']));
          EasyLoading.dismiss();
        },
      ),
    );
  }

  Widget sliderInputCard(
      {required String title,
      required double sliderValue,
      required TextEditingController controller,
      String suffixText = "Years",
      Function(String)? tfOnChange,
      Function(double)? sliderOnChange}) {
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
            onChange: tfOnChange,
            controller: controller,
            suffixText: suffixText,
          ),
          Slider(
            value: sliderValue,
            min: 0,
            max: 100,
            onChanged: sliderOnChange,
          )
        ],
      ),
    );
  }

  validator() {
    /*List l = [
      currentCost,
      numberOfYears,
      annualInflationRate,
    ];
    if (l.contains(null)) {
      EasyLoading.showError("All Fields are mandatory!");
      return false;
    }*/
    if (numberOfYears <= 0) {
      EasyLoading.showError("Please select number of years. Zero Not Allowed");
      return false;
    }

    if (annualInflationRate == 0) {
      EasyLoading.showError(
          "Please select annual inflation rate. Zero Not Allowed");
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

  bool isinflatioinValidSlider(num temp) {
    if (temp < 0 || temp > 15)
      return false;
    else
      return true;
  }
}
