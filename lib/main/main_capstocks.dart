import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Capstocks MF Plus"
    ..appClientName = "capstocks"
    ..appArn = "20149"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/capstocks-logo.png"
    ..apiKey = "3f0acb11-4c71-427e-bdc2-b08ff3c3cefb"
    ..appTheme = BlueTheme()
    ..supportEmail = "mutualfund@capstocks.com"
    ..supportMobile = "9847319187"
    ..privacyPolicy = "https://www.capstocks.com/privacy-policy.aspx"
    ..pdfURL = "https://api.themfbox.com");
}
