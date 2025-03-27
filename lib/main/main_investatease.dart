import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Invest At Ease"
    ..appClientName = "investatease"
    ..appArn = "111970"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/investatease_logo.png"
    ..apiKey = "b7aac94c-f7b9-409b-89b4-44fe22b2065d"
    ..theme = ThemeData.dark()
    ..appTheme = InvestateaseTheme()
    ..supportEmail = "info@investatease.in"
    ..supportMobile = "9920968996"
    ..privacyPolicy = "https://www.investatease.in/privacy-policy.php"
    ..pdfURL = "https://api.themfbox.com");
}
