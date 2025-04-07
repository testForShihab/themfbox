import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Dakshin Capital"
    ..appClientName = "dakshin"
    ..appArn = "96025"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/dakshin-logo.jpg"
    ..apiKey = "d49b3c0f-09f7-4a29-8beb-39e7d506d043"
    ..appTheme = CoralTheme()
    ..supportEmail = "crm@dakshincapital.com"
    ..supportMobile = ""
    ..privacyPolicy = "https://www.dakshincapital.com/privacy_policy"
    ..pdfURL = "https://api.themfbox.com");
}

