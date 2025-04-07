import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class RpSelectableChip extends StatelessWidget {
  const RpSelectableChip({
    super.key,
    this.onTap,
    required this.isSelected,
    required this.title,
    this.value = "",
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final Function()? onTap;
  final bool isSelected;
  final String title, value;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    Color fgColor = (isSelected) ? Colors.white : Colors.black;
    Color bgColor =
        (isSelected) ? Config.appTheme.themeColor : Color(0XFFF1F1F1);

    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(right: 14),
          padding: padding,
          decoration: BoxDecoration(
              color: bgColor, borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: AppFonts.f50014Black.copyWith(color: fgColor)),
              if (value.isNotEmpty)
                Text(
                  value,
                  style: AppFonts.f40013.copyWith(color: fgColor),
                )
            ],
          ),
        ));
  }
}
