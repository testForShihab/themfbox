import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "AaathiFinserv - MutualFund"
    ..appClientName = "aathifinserv"
    ..appArn = "306175"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/aathifinserv_logo.png"
    ..apiKey = "f75fce92-88ec-4c20-882c-cfabd334c7ae"
    ..appTheme = NavyblueTheme()
    ..supportEmail = "aathifinserv@gmail.com"
    ..supportMobile = "9789495161"
    ..privacyPolicy = "https://www.aathifinserv.com/privacy-policy"
    ..pdfURL = "https://api.themfbox.com");
}
