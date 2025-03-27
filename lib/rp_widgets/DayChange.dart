import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class DayChange extends StatelessWidget {
  const DayChange(
      {super.key,
      required this.change_value,
      required this.percentage,
      this.titleColor,
      this.textColor});
  final num? change_value;
  final num? percentage;
  final Color? textColor, titleColor;

  @override
  Widget build(BuildContext context) {
    String change = Utils.formatNumber(change_value);
    String perc;
    if (percentage != null)
      perc = percentage!.toStringAsFixed(2);
    else
      perc = "null";

    return Row(
      children: [
        Text(
          "1 Day Change ",
          style: TextStyle(
              color: titleColor ?? AppColors.readableGrey,
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
        Text(
          "$rupee $change",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor ?? Colors.black),
        ),
        Text(
          " ($perc%)",
          style: TextStyle(
              color: (percentage!.isNegative)
                  ? Config.appTheme.defaultLoss
                  : Config.appTheme.themeProfit,
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
