import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Smartreturnz"
    ..appClientName = "smartreturnz"
    ..appArn = "310633"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/smartreturnz_logo.png"
    ..apiKey = "5b52bbc9-b43f-4618-9a46-12e3fa480c38"
    ..appTheme = RedTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
