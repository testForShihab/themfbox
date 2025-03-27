import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "GroWealthy"
    ..appClientName = "investbull"
    ..appArn = "273843"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/investbull_logo.png"
    ..apiKey = "328e2029-a1dc-4940-ab6f-627e91b7817b"
    ..appTheme = PloutiaTheme()
    ..supportEmail = "Info@investbull.in"
    ..supportMobile = "+91 9962299623"
    ..privacyPolicy = "https://investbull.in/?page_id=639"
    ..pdfURL = "https://api.themfbox.com");
}
