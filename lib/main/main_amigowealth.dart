import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Amigo Wealth"
    ..appClientName = "amigowealth"
    ..appArn = "323240"
    ..appLogo = "https://api.mymfbox.com/images/logo/amigowealth.png"
    ..apiKey = "49e17b6d-a032-4399-935b-70e6793a4689"
    ..appTheme = DarkGreyTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
