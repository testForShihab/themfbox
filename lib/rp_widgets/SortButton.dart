import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class SortButton extends StatelessWidget {
  const SortButton({
    super.key,
    required this.onTap,
    this.title = " Sort & Filter",
    this.icon,
    this.padding = const EdgeInsets.fromLTRB(3, 2, 3, 2),
    this.textStyle,
  });
  final Function() onTap;
  final String title;
  final Widget? icon;
  final EdgeInsets padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Config.appTheme.themeColor)),
        child: Row(
          children: [
            Text(title,
                style:
                    textStyle ?? TextStyle(color: Config.appTheme.themeColor)),
            icon ??
                Icon(Icons.keyboard_arrow_down,
                    color: Config.appTheme.themeColor)
          ],
        ),
      ),
    );
  }
}
