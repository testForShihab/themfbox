import 'package:flutter/material.dart';

import '../FlavorConfig.dart';
import 'main_common.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Reachyourgoals"
    ..appClientName = "reachyourgoals"
    ..appArn = "190821"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/Reach-Your-Goals-Logo.jpg"
    ..apiKey = "40a276d9-36c1-4594-904b-18754f8abbc5"
    ..theme = ThemeData.dark()
    ..supportEmail = "rygwealthmanagers@gmail.com"
    ..supportMobile = "+91 9051 332626"
    ..privacyPolicy = "https://reachyourgoals.in/privacy-policies"
    ..pdfURL = "https://api.themfbox.com");
}
