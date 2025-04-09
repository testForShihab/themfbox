// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:http_parser/http_parser.dart';

class Api {
  String client_name = GetStorage().read('client_name');

  static Future getAllBranch(
      {required String mobile, required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getAllBranch?key=${ApiConfig.apiKey}&mobile=$mobile&client_name=$client_name";
    print("getAllBranch url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAllBranch response = $data");

    return data;
  }

  static Future getAllRM(
      {required String mobile,
      required String client_name,
      String? branch}) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getAllRM?key=${ApiConfig.apiKey}&mobile=$mobile"
        "&client_name=$client_name&branch=$branch";
    print("getAllRM url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAllRM response = $data");

    return data;
  }

  static Future getAllSubbroker(
      {required String mobile,
      required String client_name,
      String rm_name = ""}) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getAllSubbroker?key=${ApiConfig.apiKey}"
        "&mobile=$mobile&client_name=$client_name&rm_name=$rm_name";
    print("getAllSubbroker url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAllSubBroker response = $data");

    return data;
  }

  static Future getAllSIPList(
      {required String mobile, required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/api/admin/getAllSIPList?key=29c5a2ec-3910-4d71-acf7-c6f51e3e9c32&mobile=$mobile&keyword=&client_name=$client_name&pageid=1&branch=&rm_name=&subbroker_name=";

    print("getAllSIPList url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    return data;
  }

  static Future validateUserId({required String mobile}) async {
    String key = ApiConfig.apiKey;
    if (mobile == "SUPERADMIN") key = "ca8f4555-99f0-4b3b-b7a0-3a6880cec417";

    String url =
        ApiConfig.apiUrl + "/validateUserId?mobile_pan=$mobile&key=$key";
    print("validateUserId url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    return data;
  }

  static Future login(
      {required String mobile,
      required String password,
      String is_otp = "",
      String broker_code = ""}) async {
    String key = ApiConfig.apiKey;
    if (mobile == "SUPERADMIN") key = "ca8f4555-99f0-4b3b-b7a0-3a6880cec417";

    String url =
        "${ApiConfig.apiUrl}/userLogin?mobile=$mobile&key=$key&password=$password&broker_code=$broker_code&is_otp=$is_otp";
    Map data = {};

    print("login url = $url");
    http.Response response = await http.post(Uri.parse(url));
    data = jsonDecode(response.body);
    print("login Response = $data");

    return data;
  }

  static Future validatePan({
    required String pan,
    required String broker_code,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/validatePan?key=${ApiConfig.apiKey}&pan=$pan&broker_code=$broker_code";

    print("validatePan url = $url");
    http.Response response = await http.post(Uri.parse(url));

    Map data = jsonDecode(response.body);
    print("validatePan Response = $data");

    return data;
  }

  static Future checkIfMobileOrEmailAlreadyExist(
      {required String email,
      required String mobile,
      required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/checkIfMobileOrEmailAlreadyExist?key=${ApiConfig.apiKey}&email=$email&mobile=$mobile&client_name=$client_name";

    print("checkIfMobileOrEmailAlreadyExist url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("checkIfMobileOrEmailAlreadyExist Response = $data");

    return data;
  }

  static Future sendMobileOtp(
      {required String mobile, required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/sendMobileOTP?key=${ApiConfig.apiKey}&mobile=$mobile&client_name=$client_name";

    print("sendMobileOTP url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("sendMobileOTP Response = $data");

    return data;
  }

  static Future sendEmailOTP(
      {required String name,
      required String email,
      required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/sendEmailOTP?key=${ApiConfig.apiKey}&name=$name&client_name=$client_name&email=$email";

    print("sendEmailOTP url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("sendEmailOTP Response = $data");

    return data;
  }

  static Future verifyMobileOtp(
      {required String mobile,
      required String otp,
      required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/verifyMobileOTP?key=${ApiConfig.apiKey}&mobile=$mobile&otp=$otp&client_name=$client_name";

    print("verifyMobileOtp url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("verifyMobileOtp Response = $data");

    return data;
  }

  static Future verifyEmailOtp(
      {required String email,
      required String otp,
      required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/verifyEmailOTP?key=${ApiConfig.apiKey}&email=$email&otp=$otp&client_name=$client_name";

    print("verifyEmailOtp url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("verifyEmailOtp Response = $data");

    return data;
  }

  static Future registerUser(
      {required Map signUpData, required String client_name}) async {
    String mobile = signUpData['mobile'];
    String pan = GetStorage().read("pan");
    String name = signUpData['name'];
    String email = signUpData['email'];
    String password = signUpData['password'];

    String url =
        "${ApiConfig.apiUrl}/registerUser?key=${ApiConfig.apiKey}&mobile=$mobile&pan=$pan&client_name=$client_name&email=$email&password=$password&name=$name";
    print("registerUser url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("registerUser Response = $data");

    return data;
  }

  static Future getCategoryList(
      {required String category, required String client_name}) async {
    if (!category.contains("Schemes")) category = "$category Schemes";
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getCategoryList?key=${ApiConfig.apiKey}&broad_category=$category&client_name=$client_name";
    print("getCategoryList url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getCategoryList Response = $data");

    return data;
  }

  static Future getTrailingReturns(
      {required String category,
      required String period,
      required List amcList,
      required String client_name}) async {
    String amc = "";
    if (amcList.isEmpty)
      amc = "ALL";
    else
      amc = amcList.join(",");

    String url =
        "${ApiConfig.apiUrl}/mfresearch/getSchemePerformanceReturns?key=${ApiConfig.apiKey}"
        "&category=$category&client_name=$client_name&period=$period&type=Open&maxno=1000&mode=Growth&amc=$amc";

    print("getTrailingReturns url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getTrailingReturns Response = $data");

    return data;
  }

  static Future getBroadCategoryList({
    required String client_name,
    int flag = 0,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getAllBroadCategory?key=${ApiConfig.apiKey}&client_name=$client_name&flag=$flag";

    print("getBroadCategoryList url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getBroadCategoryList Response = $data");

    return data;
  }

  static Future getTopAmc(
      {String count = "", required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getAmcCompaniesInAumOrder?key=${ApiConfig.apiKey}&max_count=$count&client_name=$client_name";
    print("getTopAmc url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getTopAmc Response = $data");

    return data;
  }

  static Future getAumHistoryByMonths({
    required int user_id,
    required String client_name,
    required String frequency,
    String type_user_name = "",
    String type = "",
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getAumHistoryByMonths?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&frequency=Last $frequency&"
        "type_user_name=$type_user_name&type=$type";

    print("getAumHistoryByMonths url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAumHistoryByMonths Response = $data");

    return data;
  }

  static Future getAMCMonthWiseAumHistory({
    required String user_id,
    required String client_name,
    required String fin_year,
    required String broker_code,
    required String amc,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getAMCMonthWiseAumHistory?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id&fin_year=$fin_year&broker_code=$broker_code&amc=$amc";
    print("getAMCMonthWiseAumHistory url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAMCMonthWiseAumHistory Response = $data");

    return data;
  }

  static Future getBroadCategoryWiseAUM(
      {required String user_id, required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getBroadCategoryWiseAUM?user_id=$user_id&client_name=$client_name&key=${ApiConfig.apiKey}";

    print("getBroadCategoryWiseAUM url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getBroadCategoryWiseAUM Response = $data");

    return data;
  }

  static Future getCategoryWiseAUM(
      {required String user_id,
      required String client_name,
      required String broad_category,
      required String max_count}) async {
    if (broad_category != "All") broad_category += " Schemes";
    String url =
        "${ApiConfig.apiUrl}/advisor/getCategoryWiseAUM?user_id=$user_id&client_name=$client_name&key=${ApiConfig.apiKey}&broad_category=$broad_category&max_count=$max_count";

    print("getCategoryWiseAUM url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getCategoryWiseAUM Response = $data");

    return data;
  }

  static Future getAMCWiseAum(
      {required String user_id,
      required String client_name,
      required String max_count,
      required String broker_code,
      required String sort_by}) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getAMCWiseAum?user_id=$user_id&client_name=$client_name&key=${ApiConfig.apiKey}&max_count=$max_count&sort_by=$sort_by&broker_code=$broker_code";

    print("getAMCWiseAum url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAMCWiseAum Response = $data");

    return data;
  }

  static Future getTopConsistentFund({
    required String subCategory,
    required String period,
    required String client_name,
  }) async {
    String url = "${ApiConfig.apiUrl}/mfresearch/getTopConsistentFund?"
        "key=${ApiConfig.apiKey}&category=$subCategory&period=$period&client_name=$client_name";
    print("getTopConsistentFund url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getTopConsistentFund Response = $data");
    return data;
  }

  static Future getSchemesWiseAUM({
    required int user_id,
    required String max_count,
    required String client_name,
    required String sort_by,
    required String amc,
    required String broad_category,
    required String category,
    required String riskometer,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getSchemesWiseAUM?user_id=$user_id&client_name=$client_name&key=${ApiConfig.apiKey}&max_count=$max_count&sort_by=$sort_by&amc=$amc"
        "&broad_category=$broad_category&category=$category&riskometer=$riskometer";

    print("getSchemesWiseAUM url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSchemesWiseAUM Response = $data");
    return data;
  }

  static Future getAnnualReturns({
    required String subCategory,
    required String period,
    required String maxno,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getAnnualReturnOfFunds?key=${ApiConfig.apiKey}&category=$subCategory&maxno=$maxno&client_name=$client_name&period=$period";
    print("getAnnualReturns url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getAnnualReturns Response =  $data");
    return data;
  }

  static Future getArnList({required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getClientByArnOrName?client_name=$client_name&key=${ApiConfig.apiKey}";

    print("getArnList url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getArnList Response =  $data");
    return data;
  }

  static Future getRikOMeterWiseAUM(
      {required int user_id, required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getRikOMeterWiseAUM?user_id=$user_id&client_name=$client_name&key=${ApiConfig.apiKey}";

    print("getRikOMeterWiseAUM url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getRikOMeterWiseAUM Response =  $data");
    return data;
  }

  static Future getTopSIPFunds({
    required String category,
    required String subCategory,
    required String period,
    required String amount,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getTopSIPFunds?key=${ApiConfig.apiKey}"
        "&amount=$amount&category=$subCategory&period=$period&client_name=$client_name";
    print("getTopSIPFunds url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getTopSIPFunds Response = $data");
    return data;
  }

  static Future getPurchaseAndRedemptionDetails(
      {required String client_name, required String days}) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getPurchaseAndRedemptionDetails?client_name=$client_name&days=$days&key=${ApiConfig.apiKey}";
    print("getPurchaseAndRedemptionDetails url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getPurchaseAndRedemptionDetails Response = $data");
    return data;
  }

  static Future getSipStpSwpSummaryDetails(
      {required int user_id, required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getSipStpSwpSummaryDetails?client_name=$client_name&user_id=$user_id&key=${ApiConfig.apiKey}";
    print("getSipStpSwpSummaryDetails url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSipStpSwpSummaryDetails Response = $data");
    return data;
  }

  static Future getAmcWiseSipDetails(
      {required int user_id,
      required String client_name,
      String broker_code = "",
      required String maxCount}) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getAmcWiseSipDetails?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id&max_count=$maxCount&broker_code=$broker_code";
    print("getAmcWiseSipDetails url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAmcWiseSipDetails Response = $data");
    return data;
  }

  static Future getBroadCategoryWiseSipDetails(
      {required int user_id, required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getBroadCategoryWiseSipDetails?client_name=$client_name&user_id=$user_id&key=${ApiConfig.apiKey}";
    print("getBroadCategoryWiseSipDetails url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getBroadCategoryWiseSipDetails Response = $data");
    return data;
  }

  static Future getCategoryWiseSipDetails({
    required int user_id,
    required String client_name,
    required String maxCount,
    required String broad_category,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getCategoryWiseSipDetails?key=${ApiConfig.apiKey}&"
        "client_name=$client_name&user_id=$user_id&max_count=$maxCount&broad_category=$broad_category";

    print("getCategoryWiseSipDetails url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getCategoryWiseSipDetails Response = $data");

    return data;
  }

  static Future changePassword(
      {required int user_id,
      required String client_name,
      required String old_password,
      required String new_password}) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/changePassword?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&old_password=$old_password&new_password=$new_password";

    print("changePassword url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("changePassword Response = $data");

    return data;
  }

  static Future getRetirementPlanning({
    required num currentAge,
    required num retirementAge,
    required num endAge,
    required num monthlyExpense,
    required num balance_required,
    required num inflation_rate,
    required String scenario1_accumulation_return,
    required String scenario1_distribution_return,
    required String scenario2_accumulation_return,
    required String scenario2_distribution_return,
    required num current_savings_amount,
    required num emergency_corpus_required,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/calculator/getRetirementPlanning?key=${ApiConfig.apiKey}"
        "&current_age=$currentAge"
        "&retirement_age=$retirementAge"
        "&annuity_ends_age=$endAge"
        "&current_monthly_expense=$monthlyExpense"
        "&balance_required=$balance_required"
        "&inflation_rate=$inflation_rate"
        "&scenario1_accumulation_return=$scenario1_accumulation_return"
        "&scenario1_distribution_return=$scenario1_distribution_return"
        "&scenario2_accumulation_return=$scenario2_accumulation_return"
        "&scenario2_distribution_return=$scenario2_distribution_return"
        "&current_savings_amount=$current_savings_amount"
        "&emergency_corpus_required=$emergency_corpus_required";
    "&client_name=$client_name";

    print("getRetirementPlanning url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getRetirementPlanning response = $data");

    return data;
  }

  static Future getLumpsumCalculator({
    required String lumpsum_amount,
    required String years,
    required String expected_return,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/calculator/getLumpsumCalculator?key=${ApiConfig.apiKey}"
        "&lumpsum_amount=$lumpsum_amount"
        "&years=$years"
        "&expected_return=$expected_return"
        "&client_name=$client_name";

    print("getLumpsumCalculator url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getLumpsumCalculator response = $data");

    return data;
  }

  static Future getCrorepatiCalculator({
    required String current_age,
    required String retirement_age,
    required String wealth_amount,
    required String inflation_rate,
    required String expected_return,
    required String savings_amount,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/calculator/getCrorepatiCalculator?key=${ApiConfig.apiKey}"
        "&current_age=$current_age"
        "&retirement_age=$retirement_age"
        "&wealth_amount=$wealth_amount&inflation_rate=$inflation_rate&expected_return=$expected_return"
        "&savings_amount=$savings_amount&client_name=$client_name";

    print("getCrorepatiCalculator url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getCrorepatiCalculator response = $data");

    return data;
  }

  static Future getGoalBasedSipCalculator({
    required String wealth_amount,
    required String inflation_rate,
    required String expected_return,
    required String period,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/calculator/getGoalBasedSipCalculator?key=${ApiConfig.apiKey}"
        "&wealth_amount=$wealth_amount"
        "&inflation_rate=$inflation_rate&expected_return=$expected_return&period=$period&client_name=$client_name";

    print("getGoalBasedSipCalculator url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getGoalBasedSipCalculator response = $data");

    return data;
  }

  static Future getGoalBasedSipTopUpCalculator({
    required String goal_amount,
    required String inflation_rate,
    required String expected_rate_of_return,
    required String investment_period,
    required String sip_topup_value,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/calculator/getGoalBasedSipTopUpCalculator?key=${ApiConfig.apiKey}" +
            "&goal_amount=$goal_amount" +
            "&inflation_rate=$inflation_rate" +
            "&expected_rate_of_return=$expected_rate_of_return" +
            "&investment_period=$investment_period&sip_topup_value=$sip_topup_value&client_name=$client_name";
    print("getGoalBasedSipTopUpCalculator url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getGoalBasedSipTopUpCalculator response = $data");
    return data;
  }

  static Future getGoalBasedLumpsumCalculator({
    required String target_amount,
    required String years,
    required String expected_return,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/calculator/getGoalBasedLumpsumCalculator?key=${ApiConfig.apiKey}"
        "&target_amount=$target_amount"
        "&years=$years"
        "&expected_return=$expected_return&client_name=$client_name";

    print("getGoalBasedLumpsumCalculator url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getGoalBasedLumpsumCalculator response = $data");
    return data;
  }

  static Future getFutureValueCalculator({
    required String current_cost,
    required String inflation_rate,
    required String years,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/calculator/getFutureValueCalculator?key=${ApiConfig.apiKey}" +
            "&current_cost=$current_cost" +
            "&inflation_rate=$inflation_rate" +
            "&years=$years&client_name=$client_name";
    print("getFutureValueCalculator url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getFutureValueCalculator response = $data");
    return data;
  }

  static Future getCompoundingCalculator({
    required String principal_amount,
    required String interest_rate,
    required String period,
    required String compound_interval,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/calculator/getCompoundingCalculator?key=${ApiConfig.apiKey}" +
            "&principal_amount=$principal_amount" +
            "&interest_rate=$interest_rate" +
            "&period=$period" +
            "&compound_interval=$compound_interval&client_name=$client_name";
    print("getCompoundingCalculator url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getCompoundingCalculator response = $data");
    return data;
  }

  static Future getNetworthCalculator({
    required String shares_equity_value,
    required String fixed_income_value,
    required String cash_value,
    required String property_value,
    required String gold_value,
    required String other_assets_value,
    required String home_loan_value,
    required String personal_other_loan_value,
    required String income_tax_value,
    required String outstanding_bill_value,
    required String credit_card_due_value,
    required String other_liabilities_value,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/calculator/getNetworthCalculator?key=${ApiConfig.apiKey}" +
            "&shares_equity_value=$shares_equity_value" +
            "&fixed_income_value=$fixed_income_value" +
            "&cash_value=$cash_value" +
            "&property_value=$property_value" +
            "&gold_value=$gold_value" +
            "&other_assets_value=$other_assets_value" +
            "&home_loan_value=$home_loan_value" +
            "&personal_other_loan_value=$personal_other_loan_value" +
            "&income_tax_value=$income_tax_value" +
            "&outstanding_bill_value=$outstanding_bill_value" +
            "&credit_card_due_value=$credit_card_due_value" +
            "&other_liabilities_value=$other_liabilities_value&client_name=$client_name";
    print("getNetworthCalculator url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getNetworthCalculator response = $data");
    return data;
  }

  static Future getEmiCalculator({
    required String loan_amount,
    required String interest_rate,
    required String loan_tenure_type,
    required String loan_tenure,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/calculator/getEmiCalculator?key=${ApiConfig.apiKey}" +
            "&loan_amount=$loan_amount" +
            "&interest_rate=$interest_rate" +
            "&loan_tenure_type=$loan_tenure_type" +
            "&loan_tenure=$loan_tenure&client_name=$client_name";
    print("getEmiCalculator url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getEmiCalculator response = $data");
    return data;
  }

  static Future getRetirementCalculator({
    required String current_age,
    required String retirement_age,
    required String wealth_amount,
    required String inflation_rate,
    required String expected_return,
    required String savings_amount,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/calculator/getRetirementCalculator?key=${ApiConfig.apiKey}" +
            "&current_age=$current_age" +
            "&retirement_age=$retirement_age" +
            "&wealth_amount=$wealth_amount" +
            "&inflation_rate=$inflation_rate" +
            "&expected_return=$expected_return" +
            "&savings_amount=$savings_amount&client_name=$client_name";
    print("getRetirementCalculator url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getRetirementCalculator response = $data");
    return data;
  }

  static Future getSipCalculator({
    required String sip_amount,
    required String interest_rate,
    required String period,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/calculator/getSipCalculator?key=${ApiConfig.apiKey}" +
            "&sip_amount=$sip_amount" +
            "&interest_rate=$interest_rate" +
            "&period=$period&client_name=$client_name";
    print("getSipCalculator url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSipCalculator response = $data");
    return data;
  }

  static Future getSipTopUpCalculator({
    required String sip_amount,
    required String interest_rate,
    required String period,
    required String sip_stepup_value,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/calculator/getSipTopUpCalculator?key=${ApiConfig.apiKey}" +
            "&sip_amount=$sip_amount" +
            "&interest_rate=$interest_rate" +
            "&period=$period" +
            "&sip_stepup_value=$sip_stepup_value&client_name=$client_name";

    print("getSipTopUpCalculator url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSipTopUpCalculator response = $data");
    return data;
  }

  static Future investmentProposalRecommendedSchemes({
    required String user_id,
    required num amount,
    required num period,
    required String risk_profile,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/proposal/investmentProposalRecommendedSchemes?key=${ApiConfig.apiKey}&user_id=$user_id&amount=$amount&period=$period"
        "&risk_profile=$risk_profile&client_name=$client_name";

    print("investmentProposalRecommendedSchemes url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("investmentProposalRecommendedSchemes response = $data");
    return data;
  }

  static Future getNfoDetails({required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getNfoDetails?key=${ApiConfig.apiKey}&client_name=$client_name";
    print("getNfoDetails url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getNfoDetails Response = $data");
    return data;
  }

  static Future sendPasswordChangeOTP(
      {required String user_id,
      required String mobile,
      required String client_name,
      required String broker_code}) async {
    String url =
        "${ApiConfig.apiUrl}/sendPasswordChangeOTP?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&mobile=$mobile&client_name=$client_name&broker_code=$broker_code";

    print("sendPasswordChangeOTP url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("sendPasswordChangeOTP response = $data");
    return data;
  }

  static Future verifyPasswordChangeOTP({
    required String user_id,
    required String mobile,
    required String client_name,
    required String otp,
    required String broker_code,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/verifyPasswordChangeOTP?key=${ApiConfig.apiKey}&user_id=$user_id&mobile=$mobile&client_name=$client_name&otp=$otp&broker_code=$broker_code";

    print("verifyPasswordChangeOTP url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("verifyPasswordChangeOTP response = $data");
    return data;
  }

  static Future changePasswordUsingOTP({
    required String user_id,
    required String mobile,
    required String client_name,
    required String broker_code,
    required String password,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/changePasswordUsingOTP?key=${ApiConfig.apiKey}&user_id=$user_id&mobile=$mobile&client_name=$client_name&broker_code=$broker_code&password=$password";
    print("changePasswordUsingOTP url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("changePasswordUsingOTP response = $data");
    return data;
  }

  static Future getTopSipFund(
      {required String category,
      required String period,
      required String amount,
      required String amc,
      required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getTopSIPFunds?amount=$amount&category=$category&period=$period&amc=$amc&key=${ApiConfig.apiKey}&client_name=$client_name";
    print("getSipFund url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSipFund Response = $data");
    return data;
  }

  static Future getEuinList({
    required String client_name,
    required String broker_code,
  }) async {
    // if (!broker_code.contains("arn")) broker_code = "ARN-$broker_code";

    String url =
        "${ApiConfig.apiUrl}/transact/getEuinByArn?key=${ApiConfig.apiKey}&client_name=$client_name&broker_code=$broker_code";

    print("getEuinList url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getEuinList Response = $data");
    return data;
  }

  static Future getCartCounts({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getCartCounts?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name";

    print("getCartCounts url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getCartCounts Response = $data");
    return data;
  }

  static Future uploadImage({
    required String client_name,
    required int user_id,
    required String file_path,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/support/uploadImage?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&filePath = $file_path";

    print("uploadImage url = $url filePath = $file_path");

    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(await http.MultipartFile.fromPath('file', file_path,
        contentType: MediaType('image', 'png')));

    http.StreamedResponse response = await request.send();

    String resString = await response.stream.bytesToString();

    Map data = jsonDecode(resString);
    print("upload response = $data");
    return data;
  }

  static Future saveSupport({
    required String client_name,
    required int user_id,
    required String subject,
    required String describtion,
    required String file_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/support/saveSupport?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id&subject=$subject&description=$describtion&file_names=$file_name";
    print("save support url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("save support response = $data");
    return data;
  }

  static Future getSchemeWiseSipDetails({
    required int user_id,
    required String client_name,
    required String amc_name,
    required String category,
    required String branch,
    required String rm_name,
    required String sub_broker_name,
    required String sip_date,
    required String start_date,
    required String end_date,
    required String broker_code,
    required int page_id,
    required String search,
    required String sort_by,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getSchemeWiseSipDetails?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&amc_name=$amc_name&"
        "category=$category&branch=$branch&rm_name=$rm_name&"
        "sub_broker_name=$sub_broker_name&sip_date=$sip_date&"
        "start_date=$start_date&end_date=$end_date&broker_code=$broker_code&page_id=$page_id&"
        "search=$search&sort_by=$sort_by";

    print("getSchemeWiseSipDetails url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getSchemeWiseSipDetails response = $data");
    return data;
  }

  static Future getAumFinYear({
    required String client_name,
    required int user_id,
    required String broker_code,
    required String amc,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getAumFinYear?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id&broker_code=$broker_code&amc=$amc";
    print("getAumFinYear url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAumFinYear response = $data");
    return data;
  }

  static Future getTaxPackageFinYear({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getTaxPackageFinYear?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";
    print("getTaxPackageFinYear url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getTaxPackageFinYear response = $data");
    return data;
  }

  static Future getTaxPackage({
    required int user_id,
    required String client_name,
    required String branch,
    required String rm_name,
    required String subbroker_name,
    required int page_id,
    required String search,
    required String sort_by,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getTaxPackage?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&branch=$branch&rm_name=$rm_name&subbroker_name=$subbroker_name&page_id=$page_id&search=$search&sort_by=$sort_by";
    print("getTaxPackage url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getTaxPackage response = $data");
    return data;
  }

  static Future sendOrDownloadTaxPackage({
    required int user_id,
    required String client_name,
    required String type,
    required String ids_arr,
    required String financial_year,
    required String sendClientMail,
    required String sendAdminMail,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/sendOrDownloadTaxPackage?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&type=$type&ids_arr=$ids_arr&financial_year=$financial_year&sendClientMail=$sendClientMail&sendAdminMail=$sendAdminMail";
    print("sendOrDownloadTaxPackage url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("sendOrDownloadTaxPackage response = $data");
    return data;
  }

  static Future getGroupEmailInvestor({
    required int user_id,
    required String client_name,
    required String branch,
    required String rm_name,
    required String subbroker_name,
    required int page_id,
    required String search,
    required String sort_by,
    required int customer_type,
    required String rating_type,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getGroupEmailInvestor?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&branch=$branch&rm_name=$rm_name&subbroker_name=$subbroker_name&page_id=$page_id&search=$search&sort_by=$sort_by&customer_type=$customer_type&rating_type=$rating_type";
    print("getGroupEmailInvestor url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getGroupEmailInvestor response = $data");
    return data;
  }

  static Future groupEmailCurrentPortfolioPDF({
    required String client_name,
    required String ids,
    required String financial_year,
    required String folio_type,
    required String selected_date,
    required String type,
    required String mail_content,
    required String content_option,
    required String download_type,
    required String sel_from_email,
    required String pdf_email_option,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/groupEmailCurrentPortfolioPDF?key=${ApiConfig.apiKey}&client_name=$client_name&ids=$ids&financial_year=$financial_year&folio_type=$folio_type&selected_date=$selected_date&type=$type&mail_content=$mail_content&content_option=$content_option&download_type=$download_type&sel_from_email=$sel_from_email&pdf_email_option=$pdf_email_option";
    print("groupEmailCurrentPortfolioPDF url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("groupEmailCurrentPortfolioPDF response = $data");
    return data;
  }

  static Future groupEmailCurrentPortfolioAssetCategoryBreakupPDF({
    required String client_name,
    required String ids,
    required String financial_year,
    required String folio_type,
    required String selected_date,
    required String type,
    required String mail_content,
    required String content_option,
    required String download_type,
    required String customer_type,
    required String sel_from_email,
    required String pdf_email_option,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/groupEmailCurrentPortfolioAssetCategoryBreakupPDF?key=${ApiConfig.apiKey}&client_name=$client_name&ids=$ids&financial_year=$financial_year&folio_type=$folio_type&selected_date=$selected_date&type=$type&mail_content=$mail_content&content_option=$content_option&download_type=$download_type&customer_type=$customer_type&sel_from_email=$sel_from_email&pdf_email_option=$pdf_email_option";
    print("groupEmailCurrentPortfolioAssetCategoryBreakupPDF url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("groupEmailCurrentPortfolioAssetCategoryBreakupPDF response = $data");
    return data;
  }

  static Future groupEmailTaxReportPDF({
    required String client_name,
    required String ids,
    required String financial_year,
    required String type,
    required String mail_content,
    required String content_option,
    required String sel_from_email,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/groupEmailTaxReportPDF?key=${ApiConfig.apiKey}&client_name=$client_name&ids=$ids&financial_year=$financial_year&type=$type&mail_content=$mail_content&content_option=$content_option&sel_from_email=$sel_from_email";
    print("groupEmailTaxReportPDF url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("groupEmailTaxReportPDF response = $data");
    return data;
  }

  static Future groupEmailTransactionReportPDF({
    required String client_name,
    required String ids,
    required String financial_year,
    required String folio_type,
    required String selected_date,
    required String type,
    required String mail_content,
    required String content_option,
    required String download_type,
    required String tran_folio,
    required String tran_scheme_code,
    required String start_date,
    required String end_date,
    required String sel_from_email,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/groupEmailTransactionReportPDF?key=${ApiConfig.apiKey}&client_name=$client_name&ids=$ids&financial_year=$financial_year&folio_type=$folio_type&selected_date=$selected_date&type=$type&mail_content=$mail_content&content_option=$content_option&download_type=$download_type&tran_folio=$tran_folio&tran_scheme_code=$tran_scheme_code&start_date=$start_date&end_date=$end_date&sel_from_email=$sel_from_email";
    print("groupEmailTransactionReportPDF url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("groupEmailTransactionReportPDF response = $data");
    return data;
  }

  static Future groupEmailElssStatementReportPDF({
    required String client_name,
    required String ids,
    required String financial_year,
    required String type,
    required String mail_content,
    required String content_option,
    required String download_type,
    required String selected_date,
    required String sel_from_email,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/groupEmailElssStatementReportPDF?key=${ApiConfig.apiKey}&client_name=$client_name&ids=$ids&financial_year=$financial_year&type=$type&mail_content=$mail_content&content_option=$content_option&download_type=$download_type&selected_date=$selected_date&sel_from_email=$sel_from_email";
    print("groupEmailElssStatementReportPDF url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("groupEmailElssStatementReportPDF response = $data");
    return data;
  }

  static Future sendFamilyEmailCurrentPortfolioReportPDF({
    required String client_name,
    required String ids,
    required String type,
    required String selected_date,
    required String mail_content,
    required String folio_type,
    required String content_option,
    required String download_type,
    required String email_option,
    required String sel_from_email,
    required String pdf_email_option,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/sendFamilyEmailCurrentPortfolioReportPDF?key=${ApiConfig.apiKey}&client_name=$client_name&ids=$ids&type=$type&selected_date=$selected_date&mail_content=$mail_content&folio_type=$folio_type&content_option=$content_option&download_type=$download_type&email_option=$email_option&sel_from_email=$sel_from_email&pdf_email_option=$pdf_email_option";
    print("sendFamilyEmailCurrentPortfolioReportPDF url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("sendFamilyEmailCurrentPortfolioReportPDF response = $data");
    return data;
  }

  static Future getWhatIfReport({
    required int user_id,
    required String client_name,
    required String selected_date,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getWhatIfReport?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&selected_date=$selected_date";
    print("getWhatIfReport url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getWhatIfReport response = $data");
    return data;
  }

  static Future writeNavigationLog(
      {required int user_id,
      required String client_name,
      required String routeName}) async {
    String url =
        "${ApiConfig.apiUrl}/log/saveLog?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name"
        "&title=$routeName&content=test_content";

    print("writeNavigationLog url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("writeNavigationLog response = $data");
    return data;
  }

  static Future getLatestVersion({required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/app/getLatestVersion?key=${ApiConfig.apiKey}&client_name=$client_name";
    print("getLatestVersion url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getLatestVersion response = $data");
    return data;
  }
}
