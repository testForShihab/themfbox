import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class SipRoundIcon extends StatelessWidget {
  const SipRoundIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Config.appTheme.themeColor),
            color: Config.appTheme.overlay85),
        child: Image.asset("assets/sipFund.png",
            color: Config.appTheme.themeColor, height: 30));
  }
}
