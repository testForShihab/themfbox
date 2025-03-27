import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Wert Finserve"
    ..appClientName = "wertfinserve"
    ..appArn = "99790"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/wertfinserve_logo.png"
    ..apiKey = "83a65903-3703-44f8-a431-553626f3de36"
    ..appTheme = GoldTheme()
    ..supportEmail = "wertfinserve@gmail.com"
    ..supportMobile = "9985000645"
    ..privacyPolicy =
        "https://www.freeprivacypolicy.com/live/6f283ec6-b025-46ac-977e-e55b861b570b"
    ..pdfURL = "https://api.themfbox.com");
}
