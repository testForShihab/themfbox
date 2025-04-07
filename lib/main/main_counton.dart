import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';
import 'main_common.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Counton ACE"
    ..appClientName = "counton"
    ..appArn = "104466"
    //..appLogo = "https://themfbox.com/resources/bootstrap/images/countonace-logo.png"
     ..appLogo = "assets/countonace-logo.png"
    ..apiKey = "70732c09-87d6-4208-b843-72aef02fb2dc"
    ..theme = ThemeData.dark()
    ..appTheme = CountonTheme()
    ..supportEmail = "info@countonace.com"
    ..supportMobile = "+91-98180 98099"
    ..privacyPolicy = "https://www.countonace.com/privacy-policies"
    ..pdfURL = "https://api.themfbox.com"
    ..companyName = "Counton Ace Private Limited"
    ..address1 = "A15/19 LGF, Vasant Vihar"
    ..address2 = "New Delhi - 110057"
      ..website = "https://www.countonace.com"

  );
}
