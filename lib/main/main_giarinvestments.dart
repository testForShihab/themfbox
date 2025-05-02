import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "GIAR INVESTMENTS"
    ..appClientName = "giarinvestments"
    ..appArn = "309543"
    ..appLogo = "https://api.mymfbox.com/images/logo/giar.png"
    ..apiKey = "1049d2a5-ea02-4c99-b3ef-4f2bf0804545"
    ..theme = ThemeData.dark()
    ..appTheme = BlueTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = "https://www.giarinvestments.com/privacy-policy"
    ..pdfURL = "https://api.themfbox.com");
}
