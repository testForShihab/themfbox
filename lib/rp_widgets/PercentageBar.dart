import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class PercentageBar extends StatelessWidget {
  const PercentageBar(this.percent, {super.key, this.width});
  final double percent;
  final double? width;
  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.sizeOf(context).width;
    double total = width ?? devWidth * 0.6;

    double tempPercent = (total * percent) / 100;

    return Stack(
      children: [
        Container(
          height: 7,
          width: total,
          decoration: BoxDecoration(
              color: Color(0xffD9D9D9),
              borderRadius: BorderRadius.circular(10)),
        ),
        Container(
          height: 7,
          // width: (percent * multiplier),
          width: tempPercent,
          decoration: BoxDecoration(
              color: Config.appTheme.themeColorDark,
              borderRadius: BorderRadius.circular(10)),
        ),
      ],
    );
  }
}
