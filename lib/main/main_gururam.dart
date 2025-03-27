import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Gururam"
    ..appClientName = "gururamfinancial"
    ..appArn = "265132"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/gururamfinancial_logo.png"
    ..apiKey = "2670245e-c4ba-4449-bbf2-b2565f11585b"
    ..theme = ThemeData.dark()
    ..appTheme = RaspberryTheme()
    ..supportEmail = "gururamforyou@gmail.com"
    ..supportMobile = "+91 9677267889"
    ..privacyPolicy =
        "https://www.freeprivacypolicy.com/live/e71fdc31-2060-4573-ad19-4b94d1ca9d9d"
    ..pdfURL = "https://api.themfbox.com");
}
