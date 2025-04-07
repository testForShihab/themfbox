import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Rurash Wealth"
    ..appClientName = "rurashfinancials"
    ..appArn = "164104"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/rurashfinancials_logo.png"
    ..apiKey = "50b5bae1-e974-4656-b448-cf2edc0713cc"
    ..appTheme = RedTheme()
    ..supportEmail = "madhav@rurashfin.com"
    ..supportMobile = "9930909077"
    ..privacyPolicy = "https://rurashfin.com/privacy-policy/"
    ..pdfURL = "https://api.themfbox.com");
}


