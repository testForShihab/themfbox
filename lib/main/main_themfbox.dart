import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "theMFbox"
    ..appClientName = "themfbox"
    ..appArn = ""
    ..appLogo = "https://api.mymfbox.com/images/logo/app_logo_new.png"
    ..apiKey = "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32"
    ..appTheme = GreenTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
