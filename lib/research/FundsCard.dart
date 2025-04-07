import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class FundCard extends StatelessWidget {
  FundCard(
      {super.key,
      required this.title,
      this.topImg = "assets/ellipse.png",
      this.goTo,
      this.color,
      this.iconColor,
      this.titleColor,
      this.topArcColors,
      required this.icon});
  final String title;
  final Widget icon;
  final Widget? goTo;
  final String topImg;
  Color? color;
  Color? iconColor;
  final Color? titleColor;
  final List<Color>? topArcColors;
  @override
  Widget build(BuildContext context) {
    color ??= Config.appTheme.themeColor;

    return Expanded(
      child: SizedBox(
        height: 145,
        child: InkWell(
          onTap: () {
            if (goTo != null) Get.to(goTo);
          },
          child: Card(
            color: color,
            surfaceTintColor: color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 60,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: topArcColors ??
                              [
                                Config.appTheme.themeColorDark,
                                Config.appTheme.themeColor
                              ]),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60),
                      ),
                    ),
                    child: icon,
                    // child: Image.asset(
                    //   icon,
                    //   height: 30,
                    // ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    title,
                    style: cardHeadingSmall.copyWith(
                        color: titleColor ?? Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
