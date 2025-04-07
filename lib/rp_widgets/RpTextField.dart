import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class RpTextField extends StatelessWidget {
  const RpTextField(
      {super.key,
      required this.focusNode,
      required this.borderColor,
      required this.onChange,
      this.suffixIcon,
      this.controller,
      this.initialValue,
      this.readOnly = false,
      this.inputType,
      this.maxLines,
      this.capitalization = TextCapitalization.none,
      this.obscureText = false,
      this.maxLength,
      required this.label});
  final FocusNode focusNode;
  final Color borderColor;
  final Function(String) onChange;
  final String label;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final TextCapitalization capitalization;
  final String? initialValue;
  final bool readOnly;
  final TextInputType? inputType;
  final int? maxLines;
  final int? maxLength;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(4),
      ),
      height: Utils.isSmallDevice ? 55 : 65,
      padding: EdgeInsets.only(left: 8, top: 8),
      child: TextFormField(
        maxLength: maxLength,
        focusNode: focusNode,
        onChanged: onChange,
        readOnly: readOnly,
        initialValue: initialValue,
        keyboardType: inputType,
        controller: controller,
        textCapitalization: capitalization,
        obscureText: obscureText,
        maxLines: (obscureText) ? 1 : maxLines,
        style: TextStyle(color: Colors.grey,fontSize: 20),
        decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.zero,
          //labelStyle: TextStyle(fontSize: 16),
          border: InputBorder.none,
          suffixIcon: suffixIcon,
          labelText: label,
          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        ),
      ),
    );
  }
}
