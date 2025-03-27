import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Apni Tijori"
    ..appClientName = "sudhanshu"
    ..appArn = "148438"
    ..appLogo =
        "https://api.mymfbox.com/images/logo/apni.png"
    ..apiKey = "e9652782-60de-4fb4-97e2-c04df0ce59dc"
    ..appTheme = LightBlueTheme()
    ..supportEmail = "jaininvestmentalwar@gmail.com"
    ..supportMobile = "9950577217"
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
