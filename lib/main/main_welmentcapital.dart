import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Welment Capital"
    ..appClientName = "welmentcapital"
    ..appArn = "311879"
    ..appLogo = "assets/welmentcapital.png"
    ..apiKey = "67f8bbba-ce4b-4615-bec9-cf7d9c58e8c3"
    ..theme = ThemeData.dark()
    ..appTheme = BlackTheme()
    ..supportEmail = "welment.capital@gmail.com"
    ..supportMobile = "+91 7003688685"
    ..privacyPolicy = "https://www.walletwealth.co.in/privacy_policy"
    ..pdfURL = "https://api.themfbox.com");
}
