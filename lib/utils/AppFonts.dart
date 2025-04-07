import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class AppFonts {
  static Color brokerageBorder = Color(0XFFDFDFDF);
  static Color brokerageBackground = Color(0XFFFFFFFF);

  static Color investorBorder = Color(0XFFDFDFDF);
  static Color investorBackground = Color(0XFFFFFFFF);

  static Color sipBorder = Color(0XFFDFDFDF);
  static Color sipBackground = Color(0XFFFFFFFF);

  static Color last30Border = Color(0XFFDFDFDF);
  static Color last30Background = Color(0XFFFFFFFF);

  // color
  // static Color brokerageBorder = Color(0XFFDFDFDF);
  // static Color brokerageBackground = Color(0XFFD8EBF0);

  // static Color investorBorder = Color(0XFFDFDFDF);
  // static Color investorBackground = Color(0XFFDFF0DF);

  // static Color sipBorder = Color(0XFFDFDFDF);
  // static Color sipBackground = Color(0XFFFAEBD3);

  // static Color last30Border = Color(0XFFDFDFDF);
  // static Color last30Background = Color(0XFFD9DDF1);
  //end color

  static TextStyle appBarTitle =
      TextStyle(fontWeight: FontWeight.w500, fontSize: 20);

  static TextStyle f40016 =
      TextStyle(fontWeight: FontWeight.w400, fontSize: 18);

  static TextStyle f70024 =
      TextStyle(fontWeight: FontWeight.w700, fontSize: 24);

  static TextStyle f50014Grey = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 16, color: AppColors.readableGrey);

  static TextStyle f50016Grey = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 17, color: AppColors.readableGrey);

  static TextStyle f50014Black =
      TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black);

  static TextStyle f50014Theme = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: Config.appTheme.themeColor);

  static TextStyle f40013 = TextStyle(
      fontWeight: FontWeight.w400, fontSize: 14, color: AppColors.readableGrey);

  static TextStyle f40014 = TextStyle(
      fontWeight: FontWeight.w400, fontSize: 16, color: AppColors.readableGrey);

  static TextStyle f50012 = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: Config.appTheme.themeColor);

  static TextStyle f50012Grey = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: Config.appTheme.readableGreyTitle);

  static TextStyle f70018Black =
      TextStyle(fontWeight: FontWeight.w700, fontSize: 18);

  static TextStyle f70018Green = TextStyle(
      fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.textGreen);
}

// need to change

const TextStyle cardHeadingSmall =
    TextStyle(fontWeight: FontWeight.w500, fontSize: 14);

const TextStyle f40012 = TextStyle(
    fontWeight: FontWeight.w400, fontSize: 12, color: Color(0xffB4B4B4));
