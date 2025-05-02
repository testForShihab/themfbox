import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Wealth Fincorp"
    ..appClientName = "wealthfincorp"
    ..appArn = "115899"
    ..appLogo = "https://api.mymfbox.com/images/logo/wealthfincorp.png"
    ..apiKey = "49925313-7421-420f-b992-37408f9ab752"
    ..appTheme =  DarkBlueTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..companyName = ""
    ..address1 = ""
    ..address2 = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
