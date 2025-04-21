import 'package:flutter/material.dart';

class AppTheme {
  final Color themeColor;
  final Color themeColorDark;
  final Color themeColor25;
  final Color universalTitle;
  final Color readableGreyTitle;
  final Color placeHolderInputTitleAndArrow;
  final Color lineColor;
  final Color Bg2Color;
  final Color overlay85;
  final Color mainBgColor;
  final Color whiteOverlay;
  final Color defaultProfit;
  final Color defaultLoss;
  final Color themeProfit;
  final Color themeLoss;

  AppTheme({
    required this.themeColor,
    required this.themeColorDark,
    required this.themeColor25,
    required this.universalTitle,
    required this.readableGreyTitle,
    required this.placeHolderInputTitleAndArrow,
    required this.lineColor,
    required this.Bg2Color,
    required this.overlay85,
    required this.mainBgColor,
    required this.whiteOverlay,
    required this.defaultProfit,
    required this.defaultLoss,
    required this.themeProfit,
    required this.themeLoss,
  });
}

class BlueTheme extends AppTheme {
  BlueTheme()
      : super(
      themeColor: Color(0xff0040B0),
      themeColorDark: Color(0xff072460),
      themeColor25: Color(0xffbfcfeb),
      universalTitle: Color(0xff242424),
      readableGreyTitle: Color(0xff646c6c),
      placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
      lineColor: Color(0XFFDFDFDF),
      Bg2Color: Color(0xffF1F1F1),
      overlay85: Color(0xffD9E3F3),
      mainBgColor: Color(0xffECF0F0),
      whiteOverlay: Color(0xffFFFFFF),
      defaultProfit: Color(0xff3CB66D),
      defaultLoss: Color(0xffFF0000),
      themeProfit: Color(0xff3CB66D),
      themeLoss: Color(0xffF3857B));
}

class SolidBlueTheme extends AppTheme {
  SolidBlueTheme()
      : super(
            themeColor: Color.fromARGB(255, 19, 20, 160),
            themeColorDark: Color(0xff072460),
            themeColor25: Color(0xffbfcfeb),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffD9E3F3),
            mainBgColor: Color(0xffECF0F0),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffFF0000),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffF3857B));
}
class CoralTheme extends AppTheme {
  CoralTheme()
      : super(
      themeColor: Color(0xff01579B),
      themeColorDark: Color(0xff014174),
      themeColor25: Color(0xffbfcfeb),
      universalTitle: Color(0xff242424),
      readableGreyTitle: Color(0xff646c6c),
      placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
      lineColor: Color(0XFFDFDFDF),
      Bg2Color: Color(0xffF1F1F1),
      overlay85: Color(0xffc4e5ff),
      mainBgColor: Color(0xffECF0F0),
      whiteOverlay: Color(0xffFFFFFF),
      defaultProfit: Color(0xff3CB66D),
      defaultLoss: Color(0xffFF0000),
      themeProfit: Color(0xff3CB66D),
      themeLoss: Color(0xffF3857B));
}

class RedTheme extends AppTheme {
  RedTheme()
      : super(
            themeColor: Color(0xff5A0404),
            themeColorDark: Color(0xff7B0404),
            themeColor25: Color(0xffd6c0c0),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffE6DADA),
            mainBgColor: Color(0xffF4ECEC),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffFF6657));
}

class RaspberryTheme extends AppTheme {
  RaspberryTheme()
      : super(
            themeColor: Color(0xff9B015D),
            themeColorDark: Color(0xff730043),
            themeColor25: Color(0xffe6bfd6),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffF0D9E7),
            mainBgColor: Color(0xffECE8EC),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffF3857B));
}

class PurpleTheme extends AppTheme {
  PurpleTheme()
      : super(
            themeColor: Color(0xff7800A4),
            themeColorDark: Color(0xff560078),
            themeColor25: Color(0xffddbfe8),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffEBD9F1),
            mainBgColor: Color(0xffECE6EC),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffF3857B));
}

class DarkOrangeTheme extends AppTheme {
  DarkOrangeTheme()
      : super(
            themeColor: Color(0xffC35500),
            themeColorDark: Color(0xffE66604),
            themeColor25: Color(0xfff0d4bf),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffF6E6D9),
            mainBgColor: Color(0xffF0ECE6),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xff7D0003));
}

class PinkTheme extends AppTheme {
  PinkTheme()
      : super(
            themeColor: Color(0xffE91E63),
            themeColorDark: Color(0xffBD0040),
            themeColor25: Color(0xfff9c7d8),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffFCDDE8),
            mainBgColor: Color(0xffF2ECEF),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xff7D0003));
}

class CyanTheme extends AppTheme {
  CyanTheme()
      : super(
            themeColor: Color(0xff7DF9FF),
            themeColorDark: Color(0xff06A0B7),
            themeColor25: Color(0xffbfeef4),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffD9F5F9),
            mainBgColor: Color(0xffECF2F4),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffAD0000));
}

class OrangeTheme extends AppTheme {
  OrangeTheme()
      : super(
            themeColor: Color(0xffFF9800),
            themeColorDark: Color(0xffE88D06),
            themeColor25: Color(0xfffde5bf),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffFFF0D9),
            mainBgColor: Color(0xffFCF3EC),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffAD0000));
}

class DarkGreyTheme extends AppTheme {
  DarkGreyTheme()
      : super(
            themeColor: Color(0xff1A2733),
            themeColorDark: Color(0xff7B0404),
            themeColor25: Color(0xffc6c9cc),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffb7b7b7),
            mainBgColor: Color(0xffECECF2),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffFF6657));
}

class BeigeTheme extends AppTheme {
  BeigeTheme()
      : super(
            themeColor: Color(0xffB7B734),
            themeColorDark: Color(0xff93932A),
            themeColor25: Color(0xffEBEBB8),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffFFFFFF),
            mainBgColor: Color(0xffECECF2),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffFF6657));
}

class BlueirisTheme extends AppTheme {
  BlueirisTheme()
      : super(
            themeColor: Color(0xff332A99),
            themeColorDark: Color(0xff272075),
            themeColor25: Color(0xffBFBBED),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffDDDFE1),
            mainBgColor: Color(0xffECECF2),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffFF6657));
}

class BurntOrange extends AppTheme {
  BurntOrange()
      : super(
            themeColor: Color(0xffC54119),
            themeColorDark: Color(0xff9D3314),
            themeColor25: Color(0xffF8D6CB),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffDDDFE1),
            mainBgColor: Color(0xffECECF2),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffFF6657));
}

class RoseWaterTheme extends AppTheme {
  RoseWaterTheme()
      : super(
            themeColor: Color(0xffD43D68),
            themeColorDark: Color(0xff6F1931),
            themeColor25: Color(0xffEDAEC0),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xfff6d8e0),
            mainBgColor: Color(0xffECECF2),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffFF6657));
}

class NavyblueTheme extends AppTheme {
  NavyblueTheme()
      : super(
            themeColor: Color(0xff191970),
            themeColorDark: Color(0xff212196),
            themeColor25: Color(0xffAFAFED),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffDDDFE1),
            mainBgColor: Color(0xffECECF2),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffFF6657));
}

class PloutiaTheme extends AppTheme {
  PloutiaTheme()
      : super(
            themeColor: Color(0xff25966B),
            themeColorDark: Color(0xff19694A),
            themeColor25: Color(0xffD1E1DA),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffD1E1DA),
            mainBgColor: Color(0xffECECF2),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffFF6657));
}

class InvestateaseTheme extends AppTheme {
  InvestateaseTheme()
      : super(
      themeColor: Color(0xff5fae19),
      themeColorDark: Color(0xff29a329),
      themeColor25: Color(0xffD1E1DA),
      universalTitle: Color(0xff242424),
      readableGreyTitle: Color(0xff646c6c),
      placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
      lineColor: Color(0XFFDFDFDF),
      Bg2Color: Color(0xffF1F1F1),
      overlay85: Color(0xffDDDFE1),
      mainBgColor: Color(0xffECECF2),
      whiteOverlay: Color(0xffFFFFFF),
      defaultProfit: Color(0xff3CB66D),
      defaultLoss: Color(0xffD10B0B),
      themeProfit: Color(0xff3CB66D),
      themeLoss: Color(0xffFF6657));
}
//#2d5c68
class nextFreedomTheme extends AppTheme{
  nextFreedomTheme()
  : super(
      themeColor: Color(0xff2d5c68),
      themeColorDark: Color(0xff9ecad5),
      themeColor25: Color(0xfff0f7f9),
      universalTitle: Color(0xff242424),
      readableGreyTitle: Color(0xff646c6c),
      placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
      lineColor: Color(0XFFDFDFDF),
      Bg2Color: Color(0xffF1F1F1),
      overlay85: Color(0xffDDDFE1),
      mainBgColor: Color(0xffECECF2),
      whiteOverlay: Color(0xffFFFFFF),
      defaultProfit: Color(0xff3CB66D),
      defaultLoss: Color(0xffD10B0B),
      themeProfit: Color(0xff3CB66D),
      themeLoss: Color(0xffFF6657));
}

class LightBlueTheme extends AppTheme {
  LightBlueTheme()
      : super(
            themeColor: Color(0xff336699),
            themeColorDark: Color(0xff19334d),
            themeColor25: Color(0xffcceeff),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffcceeff),
            mainBgColor: Color(0xffECECF2),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffFF6657));
}

//finatrium
class GoldTheme extends AppTheme {
  GoldTheme()
      : super(
            themeColor: Color(0xFFD8AC31),
            themeColorDark: Color(0xffb79129),
            themeColor25: Color(0xFFEBD9A8),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffDDDFE1),
            mainBgColor: Color(0xffECECF2),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffFF6657));
}

class UparjanTheme extends AppTheme {
  UparjanTheme()
      : super(
            themeColor: Color(0xff916ad7),
            themeColorDark: Color(0xff382953),
            themeColor25: Color(0xfff2ebff),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffDDDFE1),
            mainBgColor: Color(0xffECECF2),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffFF6657));
}

class DarkBlueTheme extends AppTheme {
  DarkBlueTheme()
      : super(
            themeColor: Color(0xff000066),
            themeColorDark: Color(0xff000033),
            themeColor25: Color(0xffccccff),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffe5e5ff),
            mainBgColor: Color(0xffECECF2),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffFF6657));
}

class FinatriumTheme extends AppTheme {
  FinatriumTheme()
      : super(
            themeColor: Color(0xff000000),
            themeColorDark: Color(0xff7B0404),
            themeColor25: Color(0xffc6c9cc),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffDDDFE1),
            mainBgColor: Color(0xffECECF2),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffFF6657));
}

class FortuneTheme extends AppTheme {
  FortuneTheme()
      : super(
            themeColor: Color(0xFF77B934),
            themeColorDark: Color(0xFF639b2b),
            themeColor25: Color(0xffc8d7d7),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffDEE6E6),
            mainBgColor: Color(0xffECF0F0),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff2A7F4C),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffF3857B));
}

class AjTheme extends AppTheme {
  AjTheme()
      : super(
            themeColor: Color(0XFF496182),
            themeColorDark: Color(0XFF2b394d),
            themeColor25: Color(0xffc8d7d7),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffDEE6E6),
            mainBgColor: Color(0xffECF0F0),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffF3857B));
}

class AjfundsproTheme extends AppTheme {
  AjfundsproTheme()
      : super(
            themeColor: Color(0XFF496182),
            themeColorDark: Color(0XFF2b394d),
            themeColor25: Color(0xffc8d7d7),
            universalTitle: Color(0xff242424),
            readableGreyTitle: Color(0xff646c6c),
            placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
            lineColor: Color(0XFFDFDFDF),
            Bg2Color: Color(0xffF1F1F1),
            overlay85: Color(0xffDEE6E6),
            mainBgColor: Color(0xffECF0F0),
            whiteOverlay: Color(0xffFFFFFF),
            defaultProfit: Color(0xff3CB66D),
            defaultLoss: Color(0xffD10B0B),
            themeProfit: Color(0xff3CB66D),
            themeLoss: Color(0xffF3857B));
}

class CountonTheme extends AppTheme {
  CountonTheme()
      : super(
      themeColor: Color(0xff2E3E4E),//1b2f00 //black - 2E3E4E //green - 529100
      themeColorDark: Color(0xff529100),//2E3E4E
      themeColor25: Color(0xfff1ffdf),
      universalTitle: Color(0xff242424),
      readableGreyTitle: Color(0xff646c6c),
      placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
      lineColor: Color(0XFFDFDFDF),
      Bg2Color: Color(0xffF1F1F1),
      overlay85: Color(0xffDEE6E6),
      mainBgColor: Color(0xffECF0F0),
      whiteOverlay: Color(0xffFFFFFF),
      defaultProfit: Color(0xff3CB66D),
      defaultLoss: Color(0xffD10B0B),
      themeProfit: Color(0xff3CB66D),
      themeLoss: Color(0xffF3857B));
}

class AbhivirudhiTheme extends AppTheme {
  AbhivirudhiTheme()
      : super(
      themeColor: Color(0xff602060),
      themeColorDark: Color(0xff993399),
      themeColor25: Color(0xffecc6ec),
      universalTitle: Color(0xff242424),
      readableGreyTitle: Color(0xff646c6c),
      placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
      lineColor: Color(0XFFDFDFDF),
      Bg2Color: Color(0xffF1F1F1),
      overlay85: Color(0xffDEE6E6),
      mainBgColor: Color(0xffECF0F0),
      whiteOverlay: Color(0xffFFFFFF),
      defaultProfit: Color(0xff3CB66D),
      defaultLoss: Color(0xffD10B0B),
      themeProfit: Color(0xff3CB66D),
      themeLoss: Color(0xffF3857B));
}

class FinvisionTheme extends AppTheme {
  FinvisionTheme()
      : super(
      themeColor: Color(0xff77b934),
      themeColorDark: Color(0xff248f24),
      themeColor25: Color(0xffC8E6C9),
      universalTitle: Color(0xff242424),
      readableGreyTitle: Color(0xff646c6c),
      placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
      lineColor: Color(0XFFDFDFDF),
      Bg2Color: Color(0xffF1F1F1),
      overlay85: Color(0xffDEE6E6),
      mainBgColor: Color(0xffECF0F0),
      whiteOverlay: Color(0xffFFFFFF),
      defaultProfit: Color(0xff3CB66D),
      defaultLoss: Color(0xffD10B0B),
      themeProfit: Color(0xff3CB66D),
      themeLoss: Color(0xffF3857B));
}

class PerpetualTheme extends AppTheme {
  PerpetualTheme()
      : super(
      themeColor: Color(0xff7DF9FF),
      themeColorDark: Color(0xff06A0B7),
      themeColor25: Color(0xffbfeef4),
      universalTitle: Color(0xff242424),
      readableGreyTitle: Color(0xff646c6c),
      placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
      lineColor: Color(0XFFDFDFDF),
      Bg2Color: Color(0xffF1F1F1),
      overlay85: Color(0xffD9F5F9),
      mainBgColor: Color(0xffECF2F4),
      whiteOverlay: Color(0xffFFFFFF),
      defaultProfit: Color(0xff3CB66D),
      defaultLoss: Color(0xffD10B0B),
      themeProfit: Color(0xff3CB66D),
      themeLoss: Color(0xffAD0000));
}

class DropletTheme extends AppTheme {
  DropletTheme()
      : super(
      themeColor: Color(0xff475ab5),
      themeColorDark: Color(0xff202952),
      themeColor25: Color(0xffb6bee3),
      universalTitle: Color(0xff242424),
      readableGreyTitle: Color(0xff646c6c),
      placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
      lineColor: Color(0XFFDFDFDF),
      Bg2Color: Color(0xffF1F1F1),
      overlay85: Color(0xffD9F5F9),
      mainBgColor: Color(0xffECF2F4),
      whiteOverlay: Color(0xffFFFFFF),
      defaultProfit: Color(0xff3CB66D),
      defaultLoss: Color(0xffD10B0B),
      themeProfit: Color(0xff3CB66D),
      themeLoss: Color(0xffAD0000));
}

class BlackTheme extends AppTheme {
  BlackTheme()
      : super(
      themeColor: Color(0xff000000),
      themeColorDark: Color(0xff7B0404),
      themeColor25: Color(0xffc6c9cc),
      universalTitle: Color(0xff242424),
      readableGreyTitle: Color(0xff646c6c),
      placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
      lineColor: Color(0XFFDFDFDF),
      Bg2Color: Color(0xffF1F1F1),
      overlay85: Color(0xffDDDFE1),
      mainBgColor: Color(0xffECECF2),
      whiteOverlay: Color(0xffFFFFFF),
      defaultProfit: Color(0xff3CB66D),
      defaultLoss: Color(0xffD10B0B),
      themeProfit: Color(0xff3CB66D),
      themeLoss: Color(0xffFF6657));
}

class WhiteTheme extends AppTheme {
  WhiteTheme()
      : super(
      themeColor: Color(0xff336699),
      themeColorDark: Color(0xffBABABA),
      themeColor25: Color(0xff00ffff),//light blue - CADCFC // pink - E47D98 // pastel pink - F9ECEE // soft blue - CEE6F2
      universalTitle: Color(0xff242424),
      readableGreyTitle: Color(0xff646c6c),
      placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
      lineColor: Color(0XFFDFDFDF),
      Bg2Color: Color(0xffF1F1F1),
      overlay85: Color(0xffD9F5F9),
      mainBgColor: Color(0xffECF2F4),
      whiteOverlay: Color(0xffFFFFFF),
      defaultProfit: Color(0xff3CB66D),
      defaultLoss: Color(0xffD10B0B),
      themeProfit: Color(0xff3CB66D),
      themeLoss: Color(0xffAD0000));
}

class SwarajTheme extends AppTheme {
  SwarajTheme()
      : super(
      themeColor: Color(0xff2898D4),
      themeColorDark: Color(0xffda770a),
      themeColor25: Color(0xffedf6fc),//light blue - CADCFC // pink - E47D98 // pastel pink - F9ECEE // soft blue - CEE6F2 //orange - da770a //blue - 2898d5
      universalTitle: Color(0xff242424),
      readableGreyTitle: Color(0xff646c6c),
      placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
      lineColor: Color(0XFFDFDFDF),
      Bg2Color: Color(0xffF1F1F1),
      overlay85: Color(0xffD9F5F9),
      mainBgColor: Color(0xffECF2F4),
      whiteOverlay: Color(0xffFFFFFF),
      defaultProfit: Color(0xff3CB66D),
      defaultLoss: Color(0xffD10B0B),
      themeProfit: Color(0xff3CB66D),
      themeLoss: Color(0xffAD0000));
}

class MkcapitalTheme extends AppTheme {
  MkcapitalTheme()
      : super(
      themeColor: Color(0xff008000),
      themeColorDark: Color(0xff004d00),
      themeColor25: Color(0xffD1E1DA),
      universalTitle: Color(0xff242424),
      readableGreyTitle: Color(0xff646c6c),
      placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
      lineColor: Color(0XFFDFDFDF),
      Bg2Color: Color(0xffF1F1F1),
      overlay85: Color(0xffDDDFE1),
      mainBgColor: Color(0xffECECF2),
      whiteOverlay: Color(0xffFFFFFF),
      defaultProfit: Color(0xff3CB66D),
      defaultLoss: Color(0xffD10B0B),
      themeProfit: Color(0xff3CB66D),
      themeLoss: Color(0xffFF6657));
}

class BohoTheme extends AppTheme {
  BohoTheme()
      : super(
      themeColor: Color(0xff427a32),
      themeColorDark: Color(0xff2a6a19),
      themeColor25: Color(0xffb8cdb2),
      universalTitle: Color(0xff242424),
      readableGreyTitle: Color(0xff646c6c),
      placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
      lineColor: Color(0XFFDFDFDF),
      Bg2Color: Color(0xffF1F1F1),
      overlay85: Color(0xffb8cdb2),
      mainBgColor: Color(0xffECECF2),
      whiteOverlay: Color(0xffFFFFFF),
      defaultProfit: Color(0xff3CB66D),
      defaultLoss: Color(0xffD10B0B),
      themeProfit: Color(0xff3CB66D),
      themeLoss: Color(0xffFF6657));
}

class GreenTheme extends AppTheme {
  GreenTheme()
      : super(
      themeColor: Color(0xff235f60),
      themeColorDark: Color(0xff05494B),
      themeColor25: Color(0xffc8d7d7),
      universalTitle: Color(0xff242424),
      readableGreyTitle: Color(0xff646c6c),
      placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
      lineColor: Color(0XFFDFDFDF),
      Bg2Color: Color(0xffF1F1F1),
      overlay85: Color(0xffDEE6E6),
      mainBgColor: Color(0xffECF0F0),
      whiteOverlay: Color(0xffFFFFFF),
      defaultProfit: Color(0xff3CB66D),
      defaultLoss: Color(0xffD10B0B),
      themeProfit: Color(0xff3CB66D),
      themeLoss: Color(0xffF3857B));
}

class sugamNiveshTheme extends AppTheme {
  sugamNiveshTheme()
      : super(
      themeColor: Color(0xff0C746C),//Grow#04b488 //0C746C //095C56 //0e8179
      themeColorDark: Color(0xff0e8179),
      themeColor25: Color(0xffc8d7d7),
      universalTitle: Color(0xff242424),
      readableGreyTitle: Color(0xff646c6c),
      placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
      lineColor: Color(0XFFDFDFDF),
      Bg2Color: Color(0xffF1F1F1),
      overlay85: Color(0xffFFFFFF),
      mainBgColor: Color(0xffECECF2),
      whiteOverlay: Color(0xffFFFFFF),
      defaultProfit: Color(0xff3CB66D),
      defaultLoss: Color(0xffD10B0B),
      themeProfit: Color(0xff3CB66D),
      themeLoss: Color(0xffFF6657));
}

class MsindiaTheme extends AppTheme {
  MsindiaTheme()
      : super(
      themeColor: Color(0xff332A99),
      themeColorDark: Color(0xff272075),
      themeColor25: Color(0xffBFBBED),
      universalTitle: Color(0xff242424),
      readableGreyTitle: Color(0xff646c6c),
      placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
      lineColor: Color(0XFFDFDFDF),
      Bg2Color: Color(0xffF1F1F1),
      overlay85: Color(0xffc1bfe0),
      mainBgColor: Color(0xffECECF2),
      whiteOverlay: Color(0xffFFFFFF),
      defaultProfit: Color(0xff3CB66D),
      defaultLoss: Color(0xffD10B0B),
      themeProfit: Color(0xff3CB66D),
      themeLoss: Color(0xffFF6657));
}


class TrustbayTheme extends AppTheme {
  TrustbayTheme()
      : super(
      themeColor: Color(0xff336699),
      themeColorDark: Color(0xff19334d),
      themeColor25: Color(0xffcceeff),
      universalTitle: Color(0xff242424),
      readableGreyTitle: Color(0xff646c6c),
      placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
      lineColor: Color(0XFFDFDFDF),
      Bg2Color: Color(0xffF1F1F1),
      overlay85: Color(0xffe0f5ff),
      mainBgColor: Color(0xffECECF2),
      whiteOverlay: Color(0xffFFFFFF),
      defaultProfit: Color(0xff3CB66D),
      defaultLoss: Color(0xffD10B0B),
      themeProfit: Color(0xff3CB66D),
      themeLoss: Color(0xffFF6657));
}


class AnubandhTheme extends AppTheme {
  AnubandhTheme()
      : super(
      themeColor: Color(0xff427a32),
      themeColorDark: Color(0xff2a6a19),
      themeColor25: Color(0xffb8cdb2),
      universalTitle: Color(0xff242424),
      readableGreyTitle: Color(0xff646c6c),
      placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
      lineColor: Color(0XFFDFDFDF),
      Bg2Color: Color(0xffF1F1F1),
      overlay85: Color(0xffb8cdb2),
      mainBgColor: Color(0xffECECF2),
      whiteOverlay: Color(0xffFFFFFF),
      defaultProfit: Color(0xff3CB66D),
      defaultLoss: Color(0xffD10B0B),
      themeProfit: Color(0xff3CB66D),
      themeLoss: Color(0xffFF6657));
}

class DarkRoseTheme extends AppTheme {
  DarkRoseTheme()
      : super(
      themeColor: Color(0xff9f0e54),
      themeColorDark: Color(0xff8b0c49),
      themeColor25: Color(0xffeeb7d2),
      universalTitle: Color(0xff242424),
      readableGreyTitle: Color(0xff646c6c),
      placeHolderInputTitleAndArrow: Color(0xffB4B4B4),
      lineColor: Color(0XFFDFDFDF),
      Bg2Color: Color(0xffF1F1F1),
      overlay85: Color(0xfffeeb7d2),
      mainBgColor: Color(0xffECECF2),
      whiteOverlay: Color(0xffFFFFFF),
      defaultProfit: Color(0xff3CB66D),
      defaultLoss: Color(0xffD10B0B),
      themeProfit: Color(0xff50FF00),
      themeLoss: Color(0xffFF6657));
}