import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "BOHO FINSERV"
    ..appClientName = "bohofinserv"
    ..appArn = "14352"
    ..appLogo = "assets/bohofinserv_logo.png"
    ..apiKey = "ab494338-fc64-45af-8a60-d56c3fd70a1d"
    ..theme = ThemeData.dark()
    ..appTheme = BohoTheme()
    ..supportEmail = "info@bohoindia.com"
    ..supportMobile = "+91 9845124741"
    ..privacyPolicy = "https://www.bohoindia.com/content/include/privacypol.htm"
    ..pdfURL = "https://api.themfbox.com");
}
