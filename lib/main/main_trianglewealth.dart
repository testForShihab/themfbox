import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Triangle Wealth"
    ..appClientName = "trianglewealth"
    ..appArn = "170827"
    ..appLogo = "https://api.mymfbox.com/images/logo/trianglewealth.png"
    ..apiKey = "657d7c43-0961-4be4-b66a-d09614614b2c"
    ..theme = ThemeData.dark()
    ..appTheme = PloutiaTheme()
    ..supportEmail = "services@trianglewealth.in"
    ..supportMobile = "+91 9980676676"
    ..privacyPolicy = "https://trianglewealth.in/privacy-policy.php"
    ..pdfURL = "https://api.themfbox.com");
}
