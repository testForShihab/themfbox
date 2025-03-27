import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "RipponService"
    ..appClientName = "ripponservice"
    ..appArn = "295792"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/ripponservice_logo.png"
    ..apiKey = "61bf422f-38d0-451d-b729-92fa4aa8f082"
    ..appTheme = BurntOrange()
    ..supportEmail = "ripponservice@gmail.com"
    ..supportMobile = "9480654212"
    ..privacyPolicy = "https://www.ripponservice.com/privacy-policy"
    ..pdfURL = "https://api.themfbox.com");
}
