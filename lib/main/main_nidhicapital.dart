import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Nidhi Capital - Mutual Funds"
    ..appClientName = "nidhicapital"
    ..appArn = "116800"
    ..appLogo = "https://api.mymfbox.com/images/logo/nidhic_apital.png"
    ..apiKey = "cb79bf4e-0010-47b3-8a3e-1600f2b968bc"
    ..appTheme = LightBlueTheme()
    ..supportEmail = "nidhiconsultantsmf@gmail.com"
    ..supportMobile = "9834697282"
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
