import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Finvision"
    ..appClientName = "finvision"
    ..appArn = "170464"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/finvision-logo.png"
    ..apiKey = "609d34b4-9769-4128-a478-9fab27729c28"
    ..appTheme = FortuneTheme()
    ..supportEmail = "admin@finvision.in"
    ..supportMobile = "+91 7508055826"
    ..privacyPolicy = "https://iinvestoffice.com/privacypolicy/F0056.html"
    ..pdfURL = "https://api.themfbox.com");
}
