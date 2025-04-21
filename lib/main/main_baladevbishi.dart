import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "BALADEV BISHI"
    ..appClientName = "baladevbishi"
    ..appArn = "126342"
    ..appLogo = "https://api.mymfbox.com/images/logo/baladevbishi.png"
    ..apiKey = "771478c6-6475-4fac-b734-5704b5ecd025"
    ..appTheme = DarkGreyTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
