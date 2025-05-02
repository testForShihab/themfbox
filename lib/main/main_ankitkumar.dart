import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Highlife Finserv"
    ..appClientName = "ankitkumar"
    ..appArn = "202058"
    ..appLogo = "https://api.mymfbox.com/images/logo/ankitkumar.png"
    ..apiKey = "81843a32-1fe1-4354-9157-d5d0f73b24bc"
    ..appTheme =  RedTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..companyName = ""
    ..address1 = ""
    ..address2 = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
