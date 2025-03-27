import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(
      FlavorConfig()
    ..appTitle = "Savings Chanakya"
    ..appClientName = "fiducial"
    ..appArn = "77440"
    ..appLogo =
        "https://themfbox.savingschanakya.com/resources/bootstrap/images/Savings-Chanakya-logo.jpg"
    ..apiKey = "3c10621d-fcf3-4220-9508-ff126cebf9c0"
    ..theme = ThemeData.dark()
    ..appTheme = RaspberryTheme()
    ..supportEmail = "savings@savingschanakya.com"
    ..supportMobile = "+91 9894706962"
    ..privacyPolicy = "https://www.savingschanakya.com/privacy-policy"
    ..pdfURL = "https://api.themfbox.com");
}
