import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "Allworth Finserve"
    ..appClientName = "allworth"
    ..appArn = "261883"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/allworth-logo.png"
    ..apiKey = "d397d267-06ff-41e3-bff1-88194604d232"
    ..appTheme = BeigeTheme()
    ..supportEmail = "info@allworthfinserve.com"
    ..supportMobile = "+91 9918906241"
    ..privacyPolicy = "http://allworthfinserve.com/privacy-policy"
    ..pdfURL = "https://api.themfbox.com");
}
