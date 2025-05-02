import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mymfbox2_0/rp_widgets/CalculatorTf.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';

import '../utils/Config.dart';

class SliderInputCard extends StatelessWidget {
  const SliderInputCard({
    super.key,
    required this.title,
    required this.tfOnChange,
    required this.controller,
    required this.sliderValue,
    required this.sliderOnChange,
    required this.suffixText,
    this.sliderMaxValue = 100,
    this.sliderMinValue = 0,
    this.inputFormatters = const [],
  });

  final String title, suffixText;
  final Function(String) tfOnChange;
  final TextEditingController controller;
  final double sliderValue;
  final double sliderMaxValue;
  final double sliderMinValue;
  final Function(double) sliderOnChange;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
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
            inputFormatters: inputFormatters,
            onChange: tfOnChange,
            controller: controller,
            suffixText: suffixText,
          ),
          Slider(
            activeColor: Config.appTheme.buttonColor,
            value: sliderValue,
            min: sliderMinValue,
            max: sliderMaxValue,
            onChanged: sliderOnChange,
          )
        ],
      ),
    );
  }
}
