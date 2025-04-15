import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "THARA"
    ..appClientName = "gururamfinancial"
    ..appArn = "265132"
    ..appLogo = "assets/thara_logo.png"
    ..apiKey = "2670245e-c4ba-4449-bbf2-b2565f11585b"
    ..appTheme = RedTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
