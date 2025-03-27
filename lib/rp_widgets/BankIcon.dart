import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class BankIcon extends StatelessWidget {
  const BankIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          color: Config.appTheme.mainBgColor,
          borderRadius: BorderRadius.circular(5)),
      child: Icon(Icons.account_balance, color: Config.appTheme.themeColor),
    );
  }
}
