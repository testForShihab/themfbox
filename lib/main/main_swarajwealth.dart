import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Swaraj FinPro"
    ..appClientName = "swarajwealth"
    ..appArn = "91802"
    ..appLogo = "assets/swarajwealth_logo.png"
    ..apiKey = "03443817-15e2-41cf-9df1-00998b2e19b4"
    ..theme = ThemeData.dark()
    ..appTheme = SwarajTheme()
    ..supportEmail = "swarajfinpro@gmail.com"
    ..supportMobile = "9993025625, 9630054050"
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
