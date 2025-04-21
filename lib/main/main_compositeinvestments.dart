import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Compositedge XTS"
    ..appClientName = "compositeinvestments"
    ..appArn = "78898"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/compositeinvestments_logo.png"
    ..apiKey = "b5144a63-4162-4ca4-91ca-eefe41f7bc7f"
    ..appTheme = LightBlueTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}

