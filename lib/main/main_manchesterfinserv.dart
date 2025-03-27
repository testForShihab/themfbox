import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "MANCHESTER FINANCIAL SERVICES"
    ..appClientName = "manchesterfinserv"
    ..appArn = "264470"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/manchesterfinserv_logo.png"
    ..apiKey = "89ed784a-9dbb-480e-8236-711b9cc17cde"
    ..appTheme = PurpleTheme()
    ..supportEmail = "antonyraj@manchesterfinserv.com"
    ..supportMobile = "+91 9894919018"
    ..privacyPolicy = "https://www.manchesterfinserv.com/privacy.php"
    ..pdfURL = "https://api.themfbox.com");
}
