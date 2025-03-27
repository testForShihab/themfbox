import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Envista Financials"
    ..appClientName = "envistafinserv"
    ..appArn = "276017"
    ..appLogo = "assets/logo_envistafinserv.png"
    ..apiKey = "bf23103b-a435-4137-b3c9-7b432ac41ad6"
    ..appTheme = RedTheme()
    ..supportEmail = "service@envistafinancials.com"
    ..supportMobile = "+91 9916909188"
    ..privacyPolicy = "https://www.envistafinancials.com/privacy_policy"
    ..pdfURL = "https://api.themfbox.com");
}
