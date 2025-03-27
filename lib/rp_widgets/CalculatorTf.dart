import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class CalculatorTf extends StatelessWidget {
  const CalculatorTf({
    super.key,
    this.controller,
    this.onChange,
    this.suffixText = "Years",
    this.borderRadius,
    this.initialValue,
    this.maxLength,
    this.keyboardType = TextInputType.number,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.isTextTheme = false,
    this.hasSuffix = true,
    this.hintTitle,
    this.inputFormatters = const [],
  });

  final TextEditingController? controller;
  final Function(String)? onChange;
  final String suffixText;
  final bool hasSuffix;
  final BorderRadius? borderRadius;
  final TextInputType keyboardType;
  final String? initialValue;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final bool readOnly;
  final bool isTextTheme;
  final String? hintTitle;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
        borderRadius: borderRadius ??
            BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
        borderSide: BorderSide(color: AppColors.lineColor));

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            inputFormatters: inputFormatters,
            controller: controller,
            onChanged: onChange,
            maxLength: maxLength,
            readOnly: readOnly,
            style: AppFonts.f50014Black.copyWith(
              color: isTextTheme
                  ? Config.appTheme.themeColor
                  : Colors.black, // Set text color based on isTextTheme
            ),
            textCapitalization: textCapitalization,
            initialValue: initialValue,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              counterText: "",
              contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              focusedBorder: border,
              enabledBorder: border,
              hintText: hintTitle,
            ),
          ),
        ),
        Visibility(visible: hasSuffix, child: endGrey(suffixText))
      ],
    );
  }
}

Widget endGrey(String suffix) {
  return Container(
    padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
    decoration: BoxDecoration(
      color: Config.appTheme.mainBgColor,
      border: Border.all(color: Color(0XFFDFDFDF)),
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    child: Text(suffix),
  );
}
