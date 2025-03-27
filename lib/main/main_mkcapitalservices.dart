import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "MK Capital"
    ..appClientName = "mkcapitalservices"
    ..appArn = "284316"
    //..appLogo = "https://themfbox.com/resources/bootstrap/images/mkcapitalservices_logo.png"
    ..appLogo = "assets/mkcapitalservices_logo.png"
    ..apiKey = "60b715b4-8bc8-4a37-8bee-3e85d54d53ba"
    ..theme = ThemeData.dark()
    ..appTheme = CountonTheme()
    ..supportEmail = "ops@mkinfinity.com"
    ..supportMobile = "+91 9884048900"
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
