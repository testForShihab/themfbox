import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Savers Point"
    ..appClientName = "saverspoint"
    ..appArn = "292842"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/saverspoint_logo.png"
    ..apiKey = ""
    ..appTheme = PurpleTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
