import 'package:flutter/material.dart';
import 'package:mymfbox2_0/rp_widgets/CalculatorTf.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';

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
  });

  final String title, suffixText;
  final Function(String) tfOnChange;
  final TextEditingController controller;
  final double sliderValue;
  final double sliderMaxValue;
  final Function(double) sliderOnChange;

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
            onChange: tfOnChange,
            controller: controller,
            suffixText: suffixText,
          ),
          Slider(
            value: sliderValue,
            min: 0,
            max: sliderMaxValue,
            onChanged: sliderOnChange,
          )
        ],
      ),
    );
  }
}
