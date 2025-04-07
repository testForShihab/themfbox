import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "MutualFundJini"
    ..appClientName = "tradejini"
    ..appArn = "87156"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/tradejini-logo.png"
    ..apiKey = "4a3d6c5d-669c-468b-88fb-e3db276012d5"
    ..theme = ThemeData.dark()
    ..appTheme = PloutiaTheme()
    ..supportEmail = "mf@tradejini.com"
    ..supportMobile = "80-40204020"
    ..privacyPolicy = "https://mf.tradejini.com/resources/img/footer-pdf/privacy-policy.pdf"
    ..pdfURL = "https://api.themfbox.com");
}
