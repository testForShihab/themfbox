import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class CircularDateCard extends StatelessWidget {
  const CircularDateCard(this.date,
      {super.key, required this.onTap, required this.isSelected});
  final Function() onTap;
  final String date;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    if (isSelected)
      return filledDateCard(date);
    else
      return Container(
        height: 45,
        width: 45,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Config.appTheme.lineColor)),
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(date, style: AppFonts.f50014Black),
          ),
        ),
      );
  }
}

Widget filledDateCard(String date) {
  return Container(
    height: 45,
    width: 45,
    margin: EdgeInsets.all(8),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Config.appTheme.themeColor,
    ),
    child: Center(
      child:
          Text(date, style: AppFonts.f50014Black.copyWith(color: Colors.white)),
    ),
  );
}
