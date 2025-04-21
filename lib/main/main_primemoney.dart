import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Prime Money"
    ..appClientName = "primemoney"
    ..appArn = "172227"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/prime-money-logo.png"
    ..apiKey = ""
    ..appTheme = PurpleTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
