import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Shubh Financial Hub"
    ..appClientName = "shubhfinancialhub"
    ..appArn = "116312"
    ..appLogo = "https://api.mymfbox.com/images/logo/amigowealth.png"
    ..apiKey = "b909358e-e905-4f7d-ba51-e413bdde41f1"
    ..appTheme = PloutiaTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
