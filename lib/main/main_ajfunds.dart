import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "AJ Funds Pro"
    ..appClientName = "ajfunds"
    ..appArn = "15329"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/aj-funds-logo.png"
    ..apiKey = "cf5c5342-e7e4-4bf2-9b9e-0479d11ed0ab"
    ..theme = ThemeData.dark()
    ..appTheme = AjfundsproTheme()
    ..supportEmail = "service@ajfp.in"
    ..supportMobile = "+91 7904446917"
    ..privacyPolicy = "https://www.ajfp.in/privacy-policy"
    ..pdfURL = "https://api.themfbox.com");
}
