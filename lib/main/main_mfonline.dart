import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "MF Online"
    ..appClientName = "mfonline"
    ..appArn = "160300"
    ..appLogo = "assets/mf-online-logo.png"
    ..apiKey = "b89418cb-c576-47f0-894c-45c8686e1e47"
    ..appTheme = MfOnlineTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = "https://www.mfonline.co.in/privacy-policies"
    ..pdfURL = "https://api.themfbox.com");
}
