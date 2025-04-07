import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class RpDivider extends StatelessWidget {
  const RpDivider({super.key, this.height = 50, this.width = 2});
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.only(left: 23),
      color: Config.appTheme.themeColor,
    );
  }
}
