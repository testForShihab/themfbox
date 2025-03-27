import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/advisor/BirthdayAnniversary.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

adminAppBar({
  Widget? leading,
  required String title,
  String subTitle = "",
  Color? bgColor,
  Color fgColor = Colors.black,
  bool hasAction = true,
  Color? arrowColor,
  Widget? suffix,
}) {
  return AppBar(
    elevation: 0,
    backgroundColor: bgColor ?? Config.appTheme.mainBgColor,
    leadingWidth: 0,
    scrolledUnderElevation: 0,
    foregroundColor: fgColor,
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            (fgColor == Colors.black) ? Brightness.dark : Brightness.light),
    leading: SizedBox(),
    title: Row(
      children: [
        leading ??
            GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back,
                color: arrowColor ?? Config.appTheme.themeColor,
              ),
            ),
        SizedBox(width: 8),
        GestureDetector(
          onTap: () => Get.back(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              if (subTitle.isNotEmpty)
                Text(subTitle,
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 14)),
            ],
          ),
        ),
        Spacer(),
        if (hasAction)
          Row(
            children: [
              InkWell(
                  onTap: () {
                    Get.to(() => BirthdayAnniversary());
                  },
                  child: Image.asset("assets/cake.png",
                      height: 40 * Utils.getImageScaler)),
              /*Image.asset("assets/notifications.png",
                  height: 40 * Utils.getImageScaler),*/
              // SizedBox(width: 12),
            ],
          ),
        if (!hasAction && suffix != null) suffix
      ],
    ),
  );
}
