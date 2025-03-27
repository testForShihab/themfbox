import 'package:mymfbox2_0/utils/AppThemes.dart';
import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Fincare Capital"
    ..appClientName = "fincare"
    ..appArn = "88253"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/fincare_logo.png"
    ..apiKey = "7bd0f066-550d-4c53-a463-bc8dd7ea848e"
    ..theme = ThemeData.dark()
    ..appTheme = BlueTheme()
    ..supportEmail = "customercare@fincarecapital.com"
    ..supportMobile = "+91 9949247344"
    ..privacyPolicy = "https://www.fincarecapital.com/privacy-policy"
    ..pdfURL = "https://api.themfbox.com");
}
