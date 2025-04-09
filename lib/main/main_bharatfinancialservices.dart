import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Finvisor-Smart Invest"
    ..appClientName = "bharatfinancialservices"
    ..appArn = "169636"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/bharatfinancialservices_logo.png"
    ..apiKey = "07499c22-282d-4696-9845-10c535e588b1"
    ..appTheme = DarkRoseTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
