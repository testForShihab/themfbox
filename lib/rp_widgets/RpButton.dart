import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class RpButton extends StatelessWidget {
  const RpButton({super.key, this.onTap, required this.isFilled});
  final Function()? onTap;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.sizeOf(context).width;
    return (isFilled) ? filledButton(devWidth) : plainButton(devWidth);
  }

  Widget plainButton(double devWidth) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: devWidth * 0.15, vertical: 2),
        decoration: BoxDecoration(
            border: Border.all(color: Config.appTheme.themeColor),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            "Cancel",
            style: AppFonts.f50014Black
                .copyWith(color: Config.appTheme.themeColor),
          ),
        ),
      ),
    );
  }

  Widget filledButton(double devWidth) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: devWidth * 0.15, vertical: 2),
          decoration: BoxDecoration(
              color: Config.appTheme.themeColor,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            "Apply",
            style: AppFonts.f50014Black.copyWith(color: Colors.white),
          ))),
    );
  }
}
