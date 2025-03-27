import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Dreamz Finmart"
    ..appClientName = "dreamzfinmart"
    ..appArn = "282045"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/dreamzfinmart_logo.png"
    ..apiKey = "6e93d4f9-6921-44bf-b367-e75f7d3e0c51"
    ..appTheme = DarkBlueTheme()
    ..supportEmail = "dreamzfinmart@gmail.com"
    ..supportMobile = "9842526928"
    ..privacyPolicy = "https://www.dreamzfin.com/privacy-policy"
    ..pdfURL = "https://api.themfbox.com");
}
