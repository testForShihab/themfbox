import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "MAA Finvest"
    ..appClientName = "maafinvest"
    ..appArn = "23179"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/maafinvest-logo.png"
    ..apiKey = "ced8fa53-908d-466f-a4bf-35fe7fe3dc65"
    ..appTheme = RedTheme()
    ..supportEmail = "info@maafinvest.com"
    ..supportMobile = "+91-9036797691"
    ..privacyPolicy = "https://www.maafinvest.com/privacy_policies"
    ..pdfURL = "https://api.themfbox.com");
}


