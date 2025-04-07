import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Nrizen MyMF"
    ..appClientName = "nrizen"
    ..appArn = "280759"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/eureka_logo.png"
    ..apiKey = "55690141-bda1-468b-a48f-e3db276012d5"
    ..theme = ThemeData.dark()
    ..appTheme = RaspberryTheme()
    ..supportEmail = "info@nrizen.com"
    ..supportMobile = "(033) 40006800"
    ..privacyPolicy = "https://www.eurekasec.com/privacy-policy-2/"
    ..pdfURL = "https://api.themfbox.com");
}
