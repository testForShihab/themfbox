import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "KURAL"
    ..appClientName = "kuralinvestments"
    ..appArn = "279754"
    ..appLogo = "https://themfbox.com/resources/bootstrap/images/kuralinvestments_logo.png"
    ..apiKey = "cb84c033-06f2-4585-a301-611abb89fa7f"
    ..appTheme = NavyblueTheme()
    ..supportEmail = "support@kuralinvestments.com"
    ..supportMobile = "9444976547"
    ..privacyPolicy = "https://www.kuralinvestments.com/privacy-policy"
    ..pdfURL = "https://api.themfbox.com");
}
