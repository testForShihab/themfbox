import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppThemes.dart';

enum Endpoints { items, details }

class FlavorConfig {
  String appTitle = "";
  String appClientName = "";
  String appArn = "";
  String appLogo = "";
  ThemeData? theme;
  AppTheme appTheme = GreenTheme();

  String apiKey = "";

  String supportEmail = "";
  String supportMobile = "";

  String privacyPolicy = "";
  String pdfURL = "";

  String companyName = "";
  String address1 = "";
  String address2 = "";
  String address3 = "";
  String city = "";
  String state = "";
  String pincode = "";
  String website = "";

  FlavorConfig();
}
