import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Sugam MF"
    ..appClientName = "sugamnivesh"
    ..appArn = "251214"
    ..appLogo = "assets/sugamnivesh_logo.png"
   // ..appLogo = "https://themfbox.com/resources/bootstrap/images/sugamnivesh_logo.png"
    ..apiKey = "77243c69-dc0c-45ac-8062-da430dd4af91"
    ..appTheme = FortuneTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com"
    ..companyName = ""
    ..address1 = ""
    ..address2 = ""
    ..website = ""
    );
}
