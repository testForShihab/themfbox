import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Murti Investment"
    ..appClientName = "murtiinvestment"
    ..appArn = "57538"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/murtiinvestment_logo.png"
    ..apiKey = "6432e1c6-d918-46b3-b617-a471290d4c83"
    ..appTheme = RedTheme()
    ..supportEmail = "patelrh24@gmail.com"
    ..supportMobile = "9978124864"
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
