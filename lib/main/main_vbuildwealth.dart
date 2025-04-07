import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Click4MF"
    ..appClientName = "vbuildwealth"
    ..appArn = "248080"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/click4mf_logo.png"
    ..apiKey = "f5e8c966-af6b-44d7-a52c-2150613a7d6d"
    ..appTheme = DarkOrangeTheme()
    ..supportEmail =  "info@click4mf.com"
    ..supportMobile = "+91-9884076737"
    ..privacyPolicy = "https://www.click4mf.com/privacy-policy"
    ..pdfURL = "https://api.themfbox.com");
}
