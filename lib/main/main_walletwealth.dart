import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Wallet Wealth"
    ..appClientName = "walletwealth"
    ..appArn = "173466"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/walletwealth_logo.png"
    ..apiKey = "ab3f35d4-93af-434c-9ab9-7aa33ce8f85f"
    ..theme = ThemeData.dark()
    ..appTheme = BlueTheme()
    ..supportEmail = "sridharan@walletwealth.co.in"
    ..supportMobile = "+91 9940116967"
    ..privacyPolicy = "https://www.walletwealth.co.in/privacy_policy"
    ..pdfURL = "https://api.themfbox.com");
}
