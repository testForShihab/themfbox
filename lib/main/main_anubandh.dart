import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Moneys Matter"
    ..appClientName = "anubandh"
    ..appArn = "175737"
    ..appLogo = "assets/anubandh_logo.png"
    ..apiKey = "e3b1507c-358c-4143-8bf6-03e790e181d1"
    ..appTheme = AnubandhTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
