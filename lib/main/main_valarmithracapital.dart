import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Digifund"
    ..appClientName = "valarmithracapital"
    ..appArn = "66455"
    ..appLogo = "assets/valarmithracapital_logo.png"
    ..apiKey = "1ac8da4e-bbad-44d6-8061-76a0b33539ec"
    ..appTheme = CoralTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}

