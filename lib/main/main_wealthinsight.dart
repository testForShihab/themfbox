import 'package:flutter/material.dart';
import 'package:mymfbox2_0/FlavorConfig.dart';
import 'package:mymfbox2_0/main/main_common.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

void main() {
  mainCommon(FlavorConfig()
    ..appTitle = "RB Wealth Insight"
    ..appClientName = "wealthinsight"
    ..appArn = "73912"
    ..appLogo =
        "https://themfbox.com/resources/bootstrap/images/wealthinsight-logo.png"
    ..apiKey = "0900d31a-d521-4415-b34b-9740f5b8b8e9"
    ..theme = ThemeData.dark()
    ..appTheme = BlueirisTheme()
    ..supportMobile = "Phone: +91 080-43467000 / +91 9538867003"
    ..supportEmail = "admin@wealthinsight.co.in"
    ..privacyPolicy = "https://www.wealthinsight.co.in/privacy-policies"
    ..pdfURL = "https://api.themfbox.com");
}
