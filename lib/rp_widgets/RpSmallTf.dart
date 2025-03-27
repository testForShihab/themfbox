import 'package:flutter/material.dart';

class RpSmallTf extends StatelessWidget {
  const RpSmallTf({
    super.key,
    required this.onChange,
    this.initialValue,
    this.filled,
    this.fillColor,
    this.contentPadding,
    this.hintText,
    this.borderColor = Colors.transparent,
  });
  final Function(String) onChange;
  final String? initialValue, hintText;
  final bool? filled;
  final Color? fillColor;
  final EdgeInsets? contentPadding;
  final Color borderColor;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextFormField(
        onChanged: onChange,
        initialValue: initialValue,
        decoration: InputDecoration(
            fillColor: fillColor,
            filled: filled,
            hintText: hintText,
            prefixIcon: Icon(Icons.search),
            // suffixIcon: Icon(Icons.close, color: Config.appTheme.themeColor),
            contentPadding: contentPadding ?? EdgeInsets.fromLTRB(10, 2, 12, 2),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: borderColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: borderColor)),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
