import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "SRN CAPITAL"
    ..appClientName = "srncapitaldistributionservicespvtltd"
    ..appArn = "164476"
    ..appLogo = "https://api.mymfbox.com/images/logo/srncap.png"
    ..apiKey = "a4f1f3b8-390d-41b7-b492-09ace01b0b6d"
    ..appTheme = DarkOrange()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
