import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mymfbox2_0/rp_widgets/CalculatorTf.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';

class AmountInputCard extends StatelessWidget {
  const AmountInputCard({
    super.key,
    required this.title,
    required this.suffixText,
    this.hasSuffix = true,
    this.borderRadius,
    this.keyboardType = TextInputType.number,
    this.initialValue,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    required this.onChange,
    this.subTitle = const SizedBox(),
    this.controller,
    this.readOnly = false,
    this.isTextTheme = false,
    this.hintTitle,
    this.inputFormatters = const [],
  });

  final String title, suffixText;
  final Function(String) onChange;
  final bool hasSuffix;
  final TextInputType keyboardType;
  final BorderRadius? borderRadius;
  final String? initialValue;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final Widget subTitle;
  final TextEditingController? controller;
  final bool readOnly;
  final bool isTextTheme;
  final String? hintTitle;
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
            onChange: onChange,
            suffixText: suffixText,
            hasSuffix: hasSuffix,
            textCapitalization: textCapitalization,
            borderRadius: borderRadius,
            keyboardType: keyboardType,
            initialValue: initialValue,
            maxLength: maxLength,
            controller: controller,
            readOnly: readOnly,
            isTextTheme: isTextTheme,
            hintTitle: hintTitle,
          ),
          subTitle,
        ],
      ),
    );
  }
}
