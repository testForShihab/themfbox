import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Greenmint Finserve"
    ..appClientName = "greenmint"
    ..appArn = "257131"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/greenmint_logo.png"
    ..apiKey = "751c537f-adf6-461d-9942-90405cac566c"
    ..theme = ThemeData.dark()
    ..appTheme = OrangeTheme()
    ..supportEmail = "info@greenmintfinserve.com"
    ..supportMobile = "+91 9310202040"
    ..privacyPolicy = "https://www.greenmintfinserve.com/privacy-policies/"
    ..pdfURL = "https://api.themfbox.com");
}
