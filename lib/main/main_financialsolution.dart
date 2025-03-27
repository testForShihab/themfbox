import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Smart Financial Services"
    ..appClientName = "financialsolution"
    ..appArn = "174799"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/financialsolution-logo.png"
    ..apiKey = "dbcfa7df-b4d8-4f05-8b97-02189430c21c"
    ..theme = ThemeData.dark()
    ..appTheme = BlueirisTheme()
    ..supportEmail = "smartfin360@gmail.com"
    ..supportMobile = "+91 97350 51089"
    ..privacyPolicy = "https://www.thesmartfinservices.com/privacy_policy/"
    ..pdfURL = "https://api.themfbox.com");
}
