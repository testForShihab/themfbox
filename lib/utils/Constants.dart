import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/utils/Config.dart';

const String researchTitle =
    "Mutual fund research typically involves analyzing various aspects of mutual funds to make informed investment decisions. Here are some ways in which MF research can be helpful:";

const String calcDescription =
    "These calculators can swiftly calculate complex equations and provide accurate results with just a few inputs. These help you save time and ensure accuracy, reducing the possibility of calculation errors while calculating various outputs.";

const rupee = "\u20b9";
const percentage = "\u0025";
// final numberFormat = NumberFormat("#,##0");

const API_KEY = "";

const int SUCCESS = 200;
const int FAIL = 400;

const int crore = 10000000;
const int lakh = 100000;

String client_name = Config.app_client_name;

const List monthList = [
  "temp",
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
];

Map mobileRelationMap = {
  "Self": "SE",
  "Spouse": "SP",
};

Map emailRelationMap = {
  "Self": "SE",
  "Spouse": "SP",
  "Dependent Children": "DC",
  "Dependent Siblings": "DS",
  "Dependent Parents": "DP",
  "Guardian": "GD",
  "PMS": "PM",
  "Custodian": "CD",
  "POA": "PO"
};

Map addressTypeMap = {
  "Residential or Business": "1",
  "Residential": "2",
  "Business": "3",
  "Registered office": "4",
  "Unspecified": "5"
};

Map employementStatusMap = {
  "Agriculturist": "4",
  "Business": "1",
  "Business Manufacturing": "1A",
  "Business Trading": "1B",
  "Forex Dealer": "43",
  "Government Service": "2A",
  "Housewife": "6",
  "Non-Government Service": "2B",
  "Not Specified": "9",
  "Others": "8",
  "Private Sector Service": "41",
  "Profession - Engineering": "3C",
  "Profession - Finance": "3B",
  "Profession - Legal": "3D",
  "Profession - Medicine": "3A",
  "Professional": "3",
  "Public Sector / Government Service": "42",
  "Retired": "5",
  "Service": "2",
  "Student": "7"
};
Map annualSalaryMap = {
  "Below 1 Lakh": "BL",
  "1 - 5 Lakhs": "5L",
  "5 - 10 Lakhs": "10L",
  "10 - 25 Lakhs": "25L",
  "5 Lakhs - 1 Crore": "1C",
  "Above 1 Crore": "A1C",
};

Map incomeSourceMap = {
  "Salary": "SA",
  "Business Income": "BI",
  "Gift": "GI",
  "Ancestral Property": "AP",
  "Rental Income": "RI",
  "Prize Money": "PM",
  "Royalty": "RO",
  "Others": "OT"
};

Map politicalRelationMap = {
  "I am politically exposed person": "PE",
  "I am related to politically exposed person": "RP",
  "Not Applicable": "NA",
};

Map frequencyMap = {
  "Monthly (OM)": "OM",
  "Quarterly (Q)": "Q",
  "Weekly (OW)": "OW",
  "Week Days (WD)": "WD",
  "Fortnightly (TM)": "TM",
  "Business Days (BZ)": "BZ",
  "Daily (D)": "D",
  "Yearly (Y)": "Y",
  "Half Yearly (H)": "H",
};

BorderRadius cornerBorder = BorderRadius.only(
    topLeft: Radius.circular(15), topRight: Radius.circular(15));

enum ButtonType {
  plain,
  filled,
}

class PurchaseType {
  static String redemption = "Redemption Purchase";
  static String lumpsum = "Lumpsum Purchase";
  static String sip = "SIP Purchase";
  static String switchPurchase = "Switch Purchase";
  static String stp = "STP Purchase";
  static String swp = "SWP Purchase";
}

int APP_TIMEOUT = 1;

class UserType {
  static int INVESTOR = 1;
  static int RM = 2;
  static int FAMILY = 3;
  static int ASSOCIATE = 4;
  static int ADMIN = 5;
  static int BACKOFFICE = 6;
  static int BRANCH = 7;
}

class ReportType {
  static String DOWNLOAD = "download";
  static String EMAIL = "Email";
  static String EXCEL = "Excel";
}

const List RemoveWhitebg = [
  'nidhicapital',
  'walletwealth',
  'wealthforest',
  'finzyme',
  'mrSmart',
  'finatrium',
  'giarinvestments',
  'perpetualinvestments',
  'welmentcapital',
  'counton',
  'swarajwealth',
  'bohofinserv',
  'mkcapitalservices',
  'sugamnivesh',
  'aniram',
  'midastouchfinserve',
  'valarmithracapital',
  'dropletwealth',
  'anubandh',
  'bharatfinancialservices',
  'dishaawreeenterprisellp',
  'keenvestor',
  'eureka',
  'amigowealth',
  'assetvilla',
  'finsshipfinancialservices',
  'priyabratathatoi',
  'saverspoint',
  'ankitkumar',
  'srncapitaldistributionservicespvtltd',
  'meharsolutio',
  'themfbox',
  'mfonline',
  'gstdostprivatelimited',
  'wealthfincorp'
];

Color logobgcolor =
    RemoveWhitebg.contains(client_name) ? Colors.transparent : Colors.white;
