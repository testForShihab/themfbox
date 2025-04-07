import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Sugam MF"
    ..appClientName = "sugamnivesh"
    ..appArn = "251214"
    ..appLogo = "assets/sugam_nivesh.png"
   // ..appLogo = "https://themfbox.com/resources/bootstrap/images/sugamnivesh_logo.png"
    ..apiKey = "77243c69-dc0c-45ac-8062-da430dd4af91"
    ..appTheme = sugamNiveshTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com"
    );
}
