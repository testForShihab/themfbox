import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/research/MfResearch.dart';
import 'package:mymfbox2_0/utils/Config.dart';

import '../../utils/AppFonts.dart';

class ResearchCard extends StatelessWidget {
  ResearchCard(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle,
      required this.color,
      required this.isWhite,
      this.goTo = const MfResearch(),
      this.extraText = ""});
  final String title, subTitle, image;
  bool isWhite = true;
  Color color;
  final Widget goTo;
  final String extraText;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: 178,
      child: InkWell(
        onTap: () {
          Get.to(() => goTo);
        },
        child: Card(
          //elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: color,
          surfaceTintColor: color,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              height: 100,
                              padding: EdgeInsets.fromLTRB(9, 24, 9, 0),
                              decoration: BoxDecoration(
                                gradient: (isWhite)
                                    ? LinearGradient(
                                        begin: Alignment.bottomRight,
                                        stops: [
                                            0.2,
                                            0.9
                                          ],
                                        colors: [
                                            Config.appTheme.themeColorDark
                                                .withOpacity(.9),
                                            Config.appTheme.themeColor
                                                .withOpacity(.1)
                                          ])
                                    : LinearGradient(
                                        begin: Alignment.bottomRight,
                                        stops: [
                                            0.2,
                                            0.9
                                          ],
                                        colors: [
                                            Colors.black.withOpacity(.9),
                                            Config.appTheme.universalTitle
                                                .withOpacity(.1)
                                          ]),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(50),
                                    bottomLeft: Radius.circular(50)),
                              ),
                              child: Image.asset(image,
                                  height: 40,
                                  width: 55,
                                  color: Config.appTheme.whiteOverlay)),
                          Spacer(),
                          Container(
                              padding: EdgeInsets.only(bottom: 28),
                              child: Icon(Icons.arrow_forward,
                                  color: Colors.white))
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(title,
                          style: AppFonts.f40016
                              .copyWith(color: Config.appTheme.whiteOverlay)),
                      if (extraText.isNotEmpty)
                        Text("($extraText)",
                            style: AppFonts.f40016.copyWith(
                                color: Config.appTheme.whiteOverlay,
                                fontSize: 13)),
                      SizedBox(height: 5),
                      Text(subTitle,
                          style: AppFonts.f40016.copyWith(
                              color: Config.appTheme.whiteOverlay,
                              fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
