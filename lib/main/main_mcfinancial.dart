import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "MCFINSERVE"
    ..appClientName = "mcfinancial"
    ..appArn = "73000"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/MC-Financial-Logo-Final.jpg"
    ..apiKey = "32c8f66c-1058-432e-9a63-073f2152d654"
    ..theme = ThemeData.dark()
    ..appTheme = BlueTheme()
    ..supportEmail = "mcfinserve@gmail.com"
    ..supportMobile = "+91 80174 86618"
    ..privacyPolicy = "https://www.mcfinserve.com/privacy-policy/"
    ..pdfURL = "https://api.themfbox.com");
}
