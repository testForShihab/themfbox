import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "MUTUAL FUNDS KARO"
    ..appClientName = "mutualfundskaro"
    ..appArn = "182218"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/mutualfundskaro_logo.jpg"
    ..apiKey = "7ca2ec85-928f-41de-a930-bbafdcf3de88"
    ..theme = ThemeData.dark()
    ..appTheme = LightBlueTheme()
    ..supportEmail = "support@mutualfundskaro.com"
    ..supportMobile = "+91 9551666674"
    ..privacyPolicy = "https://www.mutualfundskaro.com/privacy_policies"
    ..pdfURL = "https://api.themfbox.com");
}
