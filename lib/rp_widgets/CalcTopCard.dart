import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class CalcTopCard extends StatelessWidget {
  const CalcTopCard({super.key, required this.title, required this.isFilled});
  final String title;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: EdgeInsets.fromLTRB(22, 0, 0, 16),
      decoration: BoxDecoration(
          color: (isFilled) ? Colors.white : null,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(8)),
      child: Text(title,
          style: TextStyle(
              color: (isFilled) ? Config.appTheme.themeColor : Colors.white,
              fontWeight: FontWeight.w500)),
    );
  }
}
