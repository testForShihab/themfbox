import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "NEOWEALTH PRIVATE LIMITED"
    ..appClientName = "neowealth"
    ..appArn = "159890"
    ..appLogo =
        "https://www.neowealth.in/resources/images/logo/neowealth-logo-new.jpg"
    ..apiKey = "1f036c13-6a5b-4f7b-8c41-041397e967a6"
    ..appTheme = NavyblueTheme()
    ..supportEmail = "neowealthmf@gmail.com"
    ..supportMobile = "8051588888"
    ..privacyPolicy = "https://www.neowealth.in/privacy-policy"
    ..pdfURL = "https://api.themfbox.com");
}
