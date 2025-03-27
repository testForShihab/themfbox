import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';


void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "AKG Financial Planners"
    ..appClientName = "uiventures"
    ..appArn = "130137"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/uiventures_logo.png"
    ..apiKey = "6cc86590-8c76-41ac-bd34-a12b3b1ece67"
    ..theme = ThemeData.dark()
    ..appTheme = PloutiaTheme()
    ..supportEmail = "cfp_anmol@arthkagyan.com"
    ..supportMobile = "+91 9797805289"
    ..privacyPolicy = "https://www.arthkagyan.com/privacy-policies"
    ..pdfURL = "https://api.themfbox.com");
}
