import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "ANIRAM"
    ..appClientName = "aniram"
    ..appArn = "2130"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/aniram-logo.png"
    ..apiKey = "da541300-4cde-4df4-ba4c-1ee96a70b1e4"
    ..theme = ThemeData.dark()
    ..appTheme = RedTheme()
    ..supportEmail = "youraniram@gmail.com"
    ..supportMobile = "+91 8489858585"
    ..privacyPolicy = "https://www.aniram.in/privacy-policy/"
    ..address1 ="New No.15, Old No.8, Second Trust Link Street,"
    ..address2 ="Mandavelli, Chennai - 600028"
    ..companyName = "ANIRAM"
    ..website = "https://www.aniram.in"
    ..pdfURL = "https://api.themfbox.com",);
}
