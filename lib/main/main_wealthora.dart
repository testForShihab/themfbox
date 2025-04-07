import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "WEALTHORA - MUTUAL FUNDS & SIP"
    ..appClientName = "wealthora"
    ..appArn = "251997"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/wealthora_logo.png"
    ..apiKey = "c1bea8f2-bb99-44f3-bdfe-16f1b26acdcc"
    ..theme = ThemeData.dark()
    ..appTheme = DarkGreyTheme()
    ..supportEmail = "care.wealthora@gmail.com"
    ..supportMobile = "+91 9918800285"
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
