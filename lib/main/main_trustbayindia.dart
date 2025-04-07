import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Trustbay"
    ..appClientName = "trustbayindia"
    ..appArn = "263259"
    ..appLogo = "assets/trustbayindia_logo.png"
    ..apiKey = "5c1c994a-193b-404d-99f4-81a6e14dc3d0"
    ..appTheme = TrustbayTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..companyName = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}

