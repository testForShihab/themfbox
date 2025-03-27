import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Finatrium"
    ..appClientName = "finatrium"
    ..appArn = "226762"
    ..appLogo = "assets/finatrium.png"
    ..apiKey = "d3196fa1-5a98-471a-9329-4276eb584901"
    ..theme = ThemeData.dark()
    ..appTheme = DarkGreyTheme()
    ..supportEmail = "support@finatrium.in"
    ..supportMobile = "+91 99622 00762"
    ..privacyPolicy = "https://www.finatrium.in/privacy-policy.php"
    ..pdfURL = "https://api.themfbox.com");
}
