import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "MFUNDZ"
    ..appClientName = "wealthscienceindia"
    ..appArn = "110120"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/logo-mfundz.png"
    ..apiKey = "58ab46bb-f8eb-4af0-affa-b179660aaf29"
    ..appTheme = LightBlueTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
