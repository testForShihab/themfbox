import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class InitialCard extends StatelessWidget {
  const InitialCard(
      {super.key, this.title = "AA", this.bgColor, this.icon, this.size = 40});
  final String title;
  final Color? bgColor;
  final Widget? icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    assert(title.isNotEmpty, "title cannot be empty");

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          color: bgColor ?? Config.appTheme.mainBgColor,
          borderRadius: BorderRadius.circular(10)),
      child: Center(
          child: icon ??
              Text(title[0],
                  style: TextStyle(
                      color: (bgColor == null)
                          ? Config.appTheme.themeColor
                          : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16))),
    );
  }
}
