import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "SpringPad Mutual Fund"
    ..appClientName = "springpad"
    ..appArn = "256518"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/springpad_logo.png"
    ..apiKey = "dbbd1844-35be-4c81-980d-b007fcc5c15a"
    ..theme = ThemeData.dark()
    ..appTheme = OrangeTheme()
    ..supportEmail = "hello@springpad.in"
    ..supportMobile = "+91 6003151154"
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
