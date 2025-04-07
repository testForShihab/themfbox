import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "FISPL"
    ..appClientName = "fortuneinvestment"
    ..appArn = "197457"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/fortuneinvestment_logo.png"
    //..appLogo = "assets/fortuneinvestment_logo.png"
    ..apiKey = "d9bff0e0-3b72-4afe-95fa-750df197058d"
    ..theme = ThemeData.dark()
    ..appTheme = FortuneTheme()
    ..supportEmail = "service@fortuneinvestment.in"
    ..supportMobile = "+91-9884234686"
    ..privacyPolicy = "https://fortuneinvestment.in/detail/297486/privacy-policy"
    ..pdfURL = "https://api.themfbox.com");
}
