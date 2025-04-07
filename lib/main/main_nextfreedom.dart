import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(
      FlavorConfig()
    ..appTitle = "Freedom Gurukul"
    ..appClientName = "nextfreedom"
    ..appArn = "270604"
    ..appLogo = "https://api.mymfbox.com/images/logo/nextfreedom.png"
    ..apiKey = "cc223622-3db2-45ea-b344-1ecd8b3037ce"
    ..appTheme = nextFreedomTheme()
    ..supportEmail = "nflxarn@gmail.com"
    ..supportMobile = "+91 96112 35245"
    ..privacyPolicy = "https://freedomlifex.com/privacy-policies"
    ..pdfURL = "https://api.themfbox.com");
}
