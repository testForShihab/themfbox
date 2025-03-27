import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "UPARJAN"
    ..appClientName = "uparjan"
    ..appArn = "269097"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/uparjan-logo.png"
    ..apiKey = "cac2b97e-d0dd-4e51-95f3-02298e3af0e8"
    ..theme = ThemeData.dark()
    ..appTheme = UparjanTheme()
    ..supportEmail = "enterprisesuparjan1@gmail.com"
    ..supportMobile = "+91 "
    ..privacyPolicy = "https://www.uparjanenterprise.com/privacy-policy/"
    ..pdfURL = "https://api.themfbox.com");
}
