import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

PreferredSizeWidget rpAppBar(
    {required String title,
    Color? foregroundColor,
    Color? bgColor,
    bool isFilled = false,
    bool isShare = false,
    double devWidth = 100,
    String name = "",
    SystemUiOverlayStyle? systemUiOverlayStyle,
    List<Widget>? actions}) {
  if (isFilled) {
    return PreferredSize(
        preferredSize: Size(devWidth, 60),
        child: Container(
          color: Config.appTheme.themeColor,
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: [
              AppBar(
                toolbarHeight: 0,
                elevation: 0,
                leadingWidth: 0,
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Config.appTheme.themeColor),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/profilePic.png"),
                      radius: 25,
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Family of $name",
                          style: AppFonts.appBarTitle
                              .copyWith(color: Colors.white)),
                      Text("Good Morning",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: Colors.white)),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.notifications_none, color: Colors.white),
                ],
              )
            ],
          ),
        ));
  }

  return AppBar(
    backgroundColor: bgColor ?? Config.appTheme.mainBgColor,
    elevation: 0,
    leading: SizedBox(),
    scrolledUnderElevation: 0,
    leadingWidth: 0,
    actions: actions,
    systemOverlayStyle: systemUiOverlayStyle,
    foregroundColor: foregroundColor ?? Colors.black,
    title: GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back,
                color: foregroundColor ?? Config.appTheme.themeColor, size: 26),
          ),
          SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Text(
              title,
              style: AppFonts.appBarTitle,
            ),
          ),
        ],
      ),
    ),
  );
}
