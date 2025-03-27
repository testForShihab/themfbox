import 'package:mymfbox2_0/utils/AppThemes.dart';
import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Finzyme"
    ..appClientName = "finzyme"
    ..appArn = "276965"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/finzyme_logo.png"
    ..apiKey = "7c5fc90f-eb13-4e88-b314-66bef7d65b0c"
    ..theme = ThemeData.dark()
    ..appTheme = GoldTheme()
    ..supportEmail = "support@finzyme.net"
    ..supportMobile = "+91-6267522970"
    ..privacyPolicy = "https://finzyme.net/privacy-policy"
    ..pdfURL = "https://api.themfbox.com");
}
