import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "WCFW"
    ..appClientName = "wecare"
    ..appArn = "249212"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/wecare-logo-new.png"
    ..apiKey = "96b927af-d566-41aa-8f2e-8066db56cd13"
    ..appTheme = DarkOrangeTheme()
    ..supportEmail = "info@wcfw.in"
    ..supportMobile = "+91-9824129366"
    ..privacyPolicy = "https://www.wecarefreedom.com/privacy-policy.php"
    ..pdfURL = "https://api.themfbox.com");
}
