import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Maruthi Finance"
    ..appClientName = "maruthi"
    ..appArn = "30118"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/maruthi-fin-logo.png"
    ..apiKey = "4a2f4b32-61d4-4a10-96e3-52f1e9e14a29"
    ..theme = ThemeData.dark()
    ..appTheme = BlueirisTheme()
    ..supportEmail = "startasipnow@gmail.com"
    ..supportMobile = "+91 9842470518"
    ..privacyPolicy = "https://www.maruthifinserv.com/privacy-policy"
    ..pdfURL = "https://api.themfbox.com");
}
