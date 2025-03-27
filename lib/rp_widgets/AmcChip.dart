import 'package:flutter/material.dart';

class AmcChip extends StatelessWidget {
  const AmcChip(
      {super.key,
      required this.title,
      required this.value,
      this.titleStyle,
      this.hasValue = true,
      this.onTap,
      this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 10)});
  final String title, value;
  final Function()? onTap;
  final EdgeInsets padding;
  final bool hasValue;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        margin: EdgeInsets.fromLTRB(0, 0, 14, 0),
        decoration: BoxDecoration(
            color: Color(0XFFF1F1F1), borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Text(title, style: titleStyle),
            Visibility(visible: hasValue, child: Text(value))
          ],
        ),
      ),
    );
  }
}
