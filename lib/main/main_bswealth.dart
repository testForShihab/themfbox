import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "BSWEALTH"
    ..appClientName = "bswealth"
    ..appArn = "286116"
    ..appLogo = "assets/bswealth.png"
    ..apiKey = "226c0c55-3bc9-4bb8-9a77-091cce2445bb"
    ..appTheme = DropletTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..companyName = ""
    ..address1 = ""
    ..address2 = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
