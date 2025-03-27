import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Marina Wealth"
    ..appClientName = "marinawealth"
    ..appArn = "184136"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/favicon/marinawealth-favicon.png"
    ..apiKey = "46c882f9-c8a2-4368-97b2-9716d5722fa6"
    ..theme = ThemeData.dark()
    ..appTheme = BlueTheme()
    ..supportEmail = "support@marinawealth.com"
    ..supportMobile = "+91 98415-67379"
    ..privacyPolicy = "https://marinawealth.com/privacypolicy/"
    ..pdfURL = "https://api.themfbox.com");
}
