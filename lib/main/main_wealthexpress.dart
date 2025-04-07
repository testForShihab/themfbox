import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Luxe Avenues"
    ..appClientName = "wealthexpress"
    ..appArn = "114834"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/wealth-express.png"
    ..apiKey = "106c592a-9dbd-4556-a01b-cdeb6f76c2ef"
    ..theme = ThemeData.dark()
    ..appTheme = DarkGreyTheme()
    ..supportEmail = "theluxeavenues@gmail.com"
    ..supportMobile = "+91 9692900001,0674-2361687"
    ..privacyPolicy = "https://www.luxeavenues.com/privacy-policy"
    ..pdfURL = "https://api.themfbox.com");
}
