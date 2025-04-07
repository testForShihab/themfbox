import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Wealth Doctor"
    ..appClientName = "ploutia"
    ..appArn = "304099"
    ..appLogo = "assets/ploutia/logo.png"
    ..apiKey = "10b1deac-743a-417d-bf39-479eb6862c4c"
    ..theme = ThemeData.dark()
    ..appTheme = PloutiaTheme()
    ..supportEmail = "contact@ploutia.com"
    ..supportMobile = "+91 8147049936"
    ..privacyPolicy = "https://ploutia.com/privacy-policy"
    ..pdfURL = "https://api.themfbox.com");
}
