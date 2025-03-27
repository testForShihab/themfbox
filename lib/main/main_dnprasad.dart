import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "D N PRASAD"
    ..appClientName = "dnprasad"
    ..appArn = "13495"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/dn-prasad-logo.png"
    ..apiKey = "7b1d74ee-803f-42c9-a59c-0c3a5cd33964"
    ..theme = ThemeData.dark()
    ..appTheme = BlueTheme()
    ..supportEmail = "prasaddn1967@gmail.com"
    ..supportMobile = "+91 - 9343334339"
    ..privacyPolicy = "http://www.dnprasad.co.in/privacy.html"
    ..pdfURL = "https://api.themfbox.com");
}
