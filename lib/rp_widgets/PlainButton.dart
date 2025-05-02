import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class PlainButton extends StatelessWidget {
   PlainButton(
      {super.key, required this.text, this.onPressed, this.padding,this.color});
  final String text;
  final Function()? onPressed;
  final EdgeInsets? padding;
  Color? color = Config.appTheme.buttonColor;

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.sizeOf(context).width;

    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: padding ??
            EdgeInsets.symmetric(horizontal: devWidth * 0.15, vertical: 2),
        decoration: BoxDecoration(
            border: Border.all(color: (color != Config.appTheme.buttonColor) ? Config.appTheme.themeColor:Config.appTheme.buttonColor),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppFonts.f50014Black
                .copyWith(color: color),
          ),
        ),
      ),
    );
  }
}

class RpFilledButton extends StatelessWidget {
   RpFilledButton(
      {super.key, this.onPressed, required this.text, this.padding,this.color});

  final Function()? onPressed;
  final EdgeInsets? padding;
  final String text;
  Color? color;
  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.sizeOf(context).width;

    return InkWell(
      onTap: onPressed,
      child: Container(
          padding: padding ??
              EdgeInsets.symmetric(horizontal: devWidth * 0.15, vertical: 2),
          decoration: BoxDecoration(
              color: (color == null) ? Config.appTheme.themeColor : color,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppFonts.f50014Black.copyWith(color: Colors.white),
          ))),
    );
  }
}
