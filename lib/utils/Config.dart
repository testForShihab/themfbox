import 'package:mymfbox2_0/utils/AppThemes.dart';

class Config {
  static String app_title = "";
  static String app_client_name = "";
  static String appArn = "";
  static String appLogo = "";
  static double app_logo_size = 24;
  static double appbar_logo_size = 38;
  static String app_icon = "";
  static bool isPanKycValid = true;
  static String supportEmail = "";
  static String supportMobile = "";
  static String privacyPolicy = "";
  static String pdfURL = "";
  static String companyName = "";
  static String address1 = "";
  static String address2 = "";
  static String pincode = "";
  static String city = "";
  static String state = "";
  static String website = "";
  static AppTheme appTheme = GreenTheme();

  static String apiKey = "";

  static bool isEkycProduction = false;
  static String ekycUsername = "";
  static String ekycPassword = "";
  static String ekycChannelUrl = "";
  static String ekycOnboardingUrl = "";
  static String ekycFileUploadUrl = "";

  static String TYPE_ID_INVESTOR = "1";
  static String TYPE_ID_RM = "2";
  static String TYPE_ID_FAMILY = "3";
  static String TYPE_ID_SUBBROKER = "4";
  static String TYPE_ID_ADMIN = "5";
  static String TYPE_ID_BRANCH = "7";
  static String TYPE_ID_AGENT_MANAGER = "8";

  static List<String> getEmpanelledAmcList(String arn) {
    List<String> amcList = [];
    if (arn == "104466") {
      amcList.add("aditya");
      amcList.add("axis");
      amcList.add("baroda");
      amcList.add("canara");
      amcList.add("dsp");
      amcList.add("edelweiss");
      amcList.add("franklin");
      amcList.add("hdfc");
      amcList.add("icici");
      amcList.add("invesco");
      amcList.add("kotak");
      amcList.add("mirae");
      amcList.add("nippon");
      amcList.add("pgim");
      amcList.add("ppfas");
      amcList.add("parag parikh");
      amcList.add("sbi");
      amcList.add("uti");
      amcList.add("tata");
    } else {}
    return amcList;
  }

  static List<String> empanelledAmcList = [];
  static List<String> empanelledAmcSearchList = [];
  static List<String> empanelledNFOList = [];
}
