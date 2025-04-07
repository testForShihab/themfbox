import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Droplet Wealth"
    ..appClientName = "dropletwealth"
    ..appArn = "133803"
    ..appLogo = "assets/droplet_logo.png"
    ..apiKey = "6ae6ea29-203a-4d2e-8567-f6734d10d9b5"
    ..theme = ThemeData.dark()
    ..appTheme = DarkBlueTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = "https://dropletwealth.com/privacy-policy/"
    ..pdfURL = "https://api.themfbox.com"

  );
}


