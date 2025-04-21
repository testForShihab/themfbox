import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Mr Smart"
    ..appClientName = "mrSmart"
    ..appArn = "188301"
    ..appLogo = "https://api.mymfbox.com/images/logo/mrsmart.png"
    ..apiKey = "21bed579-5c47-49bb-b37f-b492cba060ca"
    ..appTheme = AbhivirudhiTheme()
    ..supportEmail = ""
    ..supportMobile = ""
    ..privacyPolicy = ""
    ..pdfURL = "https://api.themfbox.com"
  );
}

