import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "JUST INVEST ONLINE"
    ..appClientName = "justinvest"
    ..appArn = "125375"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/just-invest-logo.png"
    ..apiKey = "21e02092-9168-46f0-ba91-92310212918b"
    ..theme = ThemeData.dark()
    ..appTheme = OrangeTheme()
    ..supportEmail = "info@justinvestonline.com"
    ..supportMobile = "+91 9886441717"
    ..privacyPolicy = "https://www.justinvestonline.com/privacy-policy"
    ..pdfURL = "https://api.themfbox.com");
}
