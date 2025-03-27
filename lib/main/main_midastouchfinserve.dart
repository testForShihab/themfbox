import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "MIDAS TOUCH"
    ..appClientName = "midastouchfinserve"
    ..appArn = "65381"
  ..appLogo = "https://themfbox.com/resources/bootstrap/images/midastouchfinserve_logo.png"
    ..apiKey = "a248e9ac-7af1-4e31-bae3-92500c12e483"
    ..theme = ThemeData.dark()
    ..appTheme = LightBlueTheme()
    ..supportEmail = "services@midastouchfinserve.com"
    ..supportMobile = "+91 8692858555"
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
