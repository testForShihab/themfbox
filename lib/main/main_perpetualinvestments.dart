import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Perpetual Investments"
    ..appClientName = "perpetualinvestments"
    ..appArn = "189294"
    // ..appLogo = "https://themfbox.com/resources/bootstrap/images/perpetualinvestments_logo.png"
    //..appLogo = "https://api.mymfbox.com/images/logo/perpetual.png"
    ..appLogo = "assets/perpetual.png"
    ..apiKey = "536dd2f1-565b-4e6b-84ec-4480baf92d0e"
    ..theme = ThemeData.dark()
    ..appTheme = DarkOrangeTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
