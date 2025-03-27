import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class SelectedAmcChip extends StatelessWidget {
  const SelectedAmcChip(
      {super.key,
      required this.title,
      required this.value,
      this.titleStyle,
      this.valueStyle,
      this.hasValue = true,
      this.padding = const EdgeInsets.fromLTRB(10, 8, 10, 8)});
  final String title, value;
  final EdgeInsets padding;
  final TextStyle? titleStyle, valueStyle;
  final bool hasValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: EdgeInsets.fromLTRB(0, 0, 14, 0),
      decoration: BoxDecoration(
          color: Config.appTheme.themeColor,
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          Visibility(visible: hasValue, child: Text(value, style: valueStyle))
        ],
      ),
    );
  }
}
