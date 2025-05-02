import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Moneykriya"
    ..appClientName = "moneykriya"
    ..appArn = "275328"
    ..appLogo = "assets/moneykriyalogo.png"
    ..apiKey = "d73b215e-1dc1-4b03-98ec-41886bd6c594"
    ..theme = ThemeData.dark()
    ..appTheme = nextFreedomTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = "https://www.moneykriya.com/privacy_policies"
    ..pdfURL = "https://api.themfbox.com");
}
