import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "MF Online"
    ..appClientName = "mfonline"
    ..appArn = "160300"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/mfonline-logo.jpg"
    ..apiKey = "b89418cb-c576-47f0-894c-45c8686e1e47"
    ..appTheme = OrangeTheme()
    ..supportEmail = "info@mfonline.co.in"
    ..supportMobile = "9372968902"
    ..privacyPolicy = "https://www.mfonline.co.in/privacy-policies"
    ..pdfURL = "https://api.themfbox.com");
}


