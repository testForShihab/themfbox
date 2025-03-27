import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Digifund"
    ..appClientName = "valarmithracapital"
    ..appArn = "66455"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/valarmithracapital_logo.png"
    ..apiKey = "1ac8da4e-bbad-44d6-8061-76a0b33539ec"
    ..theme = ThemeData.dark()
    ..appTheme = LightBlueTheme()
    ..supportEmail = "valarmithra@gmail.com"
    ..supportMobile = "+91 7871886763"
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com"
    // ..website ="https://valarmithracapital.themfbox.com"
    // ..address1 = "NO-19 JEYAM TOWERS"
    // ..address2 = "NORTH PRADHAKSHANAM ROAD"
    // ..pinocde = "639001"

  );
}
