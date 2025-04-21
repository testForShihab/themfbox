import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Prime Money Mf Online"
    ..appClientName = "primemoney"
    ..appArn = "172227"
    ..appLogo = "https://api.mymfbox.com/images/logo/primemoney.png"
    ..apiKey = "787245b3-34d1-49d5-856f-caadf8705218"
    ..appTheme = DropletTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com");
}
