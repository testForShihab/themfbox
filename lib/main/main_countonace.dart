import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Counton ACE"
    ..appClientName = "counton"
    ..appArn = "104466"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/countonace-logo.png"
    ..apiKey = "70732c09-87d6-4208-b843-72aef02fb2dc"
    ..theme = ThemeData.dark()
    ..appTheme = PloutiaTheme()
    ..supportEmail = "info@countonace.com"
    ..supportMobile = "+91 9818098099"
    ..privacyPolicy = "https://www.countonace.com/privacy-policies/"
    ..pdfURL = "https://api.themfbox.com");
}
