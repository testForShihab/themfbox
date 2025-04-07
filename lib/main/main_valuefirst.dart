import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "VFI Money - Mutual Fund & SIP"
    ..appClientName = "valuefirst"
    ..appArn = "158172"
    ..appLogo = "assets/value_first.jpg"
    ..apiKey = "816d6c70-98a2-4bdd-9b73-0847dc1b74f7"
    ..theme = ThemeData.dark()
    ..appTheme = RoseWaterTheme()
    ..supportEmail = "support@valuefirstinvestments.com"
    ..supportMobile = "+91 9791964482"
    ..privacyPolicy =
        "https://www.freeprivacypolicy.com/live/eb33b4ad-9706-49a1-96b4-6a07b79f9e5b"
    ..pdfURL = "https://api.themfbox.com");
}
