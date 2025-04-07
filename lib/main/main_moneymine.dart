import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Money Mine Investments"
    ..appClientName = "moneymine"
    ..appArn = "104793"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/moneymine-logo.png"
    ..apiKey = "d7ff5cc6-9c5c-11ec-b909-0242ac120002"
    ..appTheme = DarkGreyTheme()
    ..supportEmail = "pranesh@moneymineinvestments.com"
    ..supportMobile = "9150561059"
    ..privacyPolicy = "https://www.moneymineinvestments.com/privacy-policy"
    ..pdfURL = "https://api.themfbox.com");
}
// https://api.mymfbox.com/images/clients/mymfbox.png