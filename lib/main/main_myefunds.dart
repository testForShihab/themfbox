import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Myefunds"
    ..appClientName = "myefunds"
    ..appArn = "115979"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/myefunds_logo.png"
    ..apiKey = "46fa4a67-35be-48a0-be12-2b8b719e77f9"
    ..appTheme = RedTheme()
    ..supportEmail = "myefunds.com@gmail.com"
    ..supportMobile = "8864881234"
    ..privacyPolicy = "https://www.myefunds.com/privacy-policies"
    ..pdfURL = "https://api.themfbox.com");
}

