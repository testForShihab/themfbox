import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "MYMF"
    ..appClientName = "eureka"
    ..appArn = "77441"
    ..appLogo = "assets/eureka_logo.png"
    //..appLogo = "https://themfbox.com/resources/bootstrap/images/eureka_logo.png"
    ..apiKey = "50732c09-87d6-4208-b843-72aef02fb2cd"
    ..theme = ThemeData.dark()
    ..appTheme = LightBlueTheme()
    ..supportEmail = "info@eurekasec.com"
    ..supportMobile = "+91 3366 280000"
    ..privacyPolicy = "https://www.eurekasec.com/privacy-policy-2/"
    ..pdfURL = "https://api.themfbox.com");
}
