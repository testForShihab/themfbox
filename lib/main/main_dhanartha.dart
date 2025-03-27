import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "wealthygain"
    ..appClientName = "dhanartha"
    ..appArn = "267466"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/wealthgain-logo.jpg"
    ..apiKey = "3481555d-0da3-4bc8-ad86-e489f233dbf5"
    ..theme = ThemeData.dark()
    ..appTheme = GoldTheme()
    ..supportEmail = "dhanarthafinserve@gmail.com"
    ..supportMobile = "+91 9482593044"
    ..privacyPolicy = "https://www.wealthygain.com/privacy-policies/"
    ..pdfURL = "https://api.themfbox.com");
}
