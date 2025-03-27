import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Wealth Journee"
    ..appClientName = "rkfinserve"
    ..appArn = "83054"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/rkfinserve_logo.png"
    ..apiKey = "a3f77057-bc65-40e0-baaf-cecc9312df7f"
    ..appTheme = BlueTheme()
    ..supportEmail = "Invest@wealthjournee.com"
    ..supportMobile = "+91 9500075461"
    ..privacyPolicy = "https://www.wealthjournee.com/privacy-policy"
    ..pdfURL = "https://api.themfbox.com");
}
