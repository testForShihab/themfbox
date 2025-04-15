// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:http/http.dart' as http;
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class InvestorApi {

  int user_id = GetStorage().read("user_id");

  static Future getMutualFundPortfolio({
    required int user_id,
    required String client_name,
    required DateTime selected_date,
    required String folio_type,
    required String broker_code,
  }) async {
    String date =
        "${selected_date.day}-${selected_date.month}-${selected_date.year}";

    String url =
        "${ApiConfig.apiUrl}/investor/getMutualFundPortfolio?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name"
        "&selected_date=$date&folio_type=$folio_type&broker_code=$broker_code";

    print("getMutualFundPortfolio url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getMutualFundPortfolio response = $data");
    return data;
  }

  static Future getExistingSchemes({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
    required String investor_code,
    required String tax_status_code,
    required String holding_nature_code,
    required String broker_code,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/v1/getExistingSchemes?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag"
        "&investor_code=$investor_code&tax_status_code=$tax_status_code&holding_nature_code=$holding_nature_code&broker_code=$broker_code";
    print("getExistingSchemes url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getExistingSchemes response = $data");
    return data;
  }

  static Future getStpSwpSummary({
    required int user_id,
    required String client_name,
    required String summary_type,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getStpSwpSummary?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&type=$summary_type";

    print("getStpSwpSummary url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getStpSwpSummary response = $data");
    return data;
  }

  static Future getMasterPortfolio(
      {required int user_id, required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getMasterPortfolio?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";

    print("getMasterPortfolio url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getMasterPortfolio response = $data");
    return data;
  }

  static Future getSipMasterDetails(
      {required int user_id,
      required String client_name,
      String max_count = "All"}) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getSipMasterDetails?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&max_count=$max_count";

    print("getSipMasterDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSipMasterDetails response = $data");
    return data;
  }

  static Future getTransactionDetails(
      {required int user_id,
      required String client_name,
      String max_count = "All"}) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getTransactionDetails?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&max_count=$max_count";

    print("getTransactionDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getTransactionDetails response = $data");
    return data;
  }

  static Future getSchemeTransactions(
      {required int user_id,
      required String client_name,
      required String folio,
      required String scheme_code,
      required String folio_type}) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getSchemeTransactions?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&folio=$folio&scheme_code=$scheme_code&folio_type=$folio_type";

    print("getSchemeTransactions url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSchemeTransactions response = $data");
    return data;
  }

  static Future getAmcWisePortfolio(
      {required int user_id, required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getAmcWisePortfolio?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name";

    print("getAmcWisePortfolio url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAmcWisePortfolio response = $data");

    return data;
  }

  static Future getCategoryList({required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getCategoryList?key=${ApiConfig.apiKey}&client_name=$client_name";

    print("getCategoryList url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getCategoryList Response = $data");

    return data;
  }

  static Future getRiskProfileStatus(
      {required int user_id, required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/investor/common/getRiskProfileStatus?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";
    print("getRiskProfileStatus url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getRiskProfileStatus Response = $data");
    return data;
  }

  static Future saveCartByUserId({
    required int user_id,
    required int investor_id,
    required String client_name,
    required String cart_id,
    required String purchase_type,
    required String vendor,
    required String scheme_name,
    required String to_scheme_name,
    required String folio_no,
    required num amount,
    required String units,
    required String frequency,
    required String sip_date,
    required String start_date,
    required String end_date,
    required String trnx_type,
    required String until_cancelled,
    num total_amount = 0,
    num total_units = 0,
    String to_scheme_reinvest_tag = "",
  }) async {
    String url =
        "${ApiConfig.apiUrl}/common/transaction/saveCartByUserId?key=${ApiConfig.apiKey}&user_id=$user_id"
        "&investor_id=$investor_id&client_name=$client_name&cart_id=$cart_id&purchase_type=$purchase_type"
        "&vendor=$vendor&scheme_name=$scheme_name&to_scheme_name=$to_scheme_name&folio_no=$folio_no&amount=$amount"
        "&units=$units&frequency=$frequency&sip_date=$sip_date&start_date=$start_date&end_date=$end_date"
        "&trnx_type=$trnx_type&until_cancel=$until_cancelled&total_amount=$total_amount"
        "&total_units=$total_units&to_scheme_reinvest_tag=$to_scheme_reinvest_tag";

    print("saveCartByUserId url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("saveCartByUserId Response = $data");

    return data;
  }

  static Future getCartByUserId({
    required int user_id,
    required int investor_id,
    required String client_name,
    required String purchase_type,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getCartByUserId?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&investor_id=$investor_id&purchase_type=$purchase_type";

    print("getCartByUserId url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getCartByUserId Response = $data");

    return data;
  }

  static Future deleteCartById({
    required int user_id,
    required String client_name,
    required int investor_id,
    required int cart_id,
    required BuildContext context,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/deleteCartById?key=${ApiConfig.apiKey}&user_id=$user_id"
        "&client_name=$client_name&investor_id=$investor_id&cart_id=$cart_id";

    print("deleteCartById url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("deleteCartById Response = $data");

    cartCount.value -= 1;

    return data;
  }

  static Future getUser({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/getUser?user_id=$user_id&key=${ApiConfig.apiKey}&client_name=$client_name";

    print("getUser url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getUser Response = $data");

    return data;
  }

  static Future getBroadCategoryWisePortfolio({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getBroadCategoryWisePortfolio?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";
    print("getBroadCategoryWisePortfolio url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getBroadCategoryWisePortfolio response = $data");

    return data;
  }

  static Future getCategoryWisePortfolio({
    required int user_id,
    required String client_name,
    required String broad_category,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getCategoryWisePorfolio?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&broad_category=$broad_category";
    print("getCategoryWisePorfolio url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getCategoryWisePorfolio response = $data");

    return data;
  }

  static Future getTopSectors(
      {required int user_id, required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getTopSectors?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";
    print("getTopSectors url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getTopSectors response = $data");

    return data;
  }

  static Future getTopHoldings(
      {required int user_id, required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getTopHoldings?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";

    print("getTopHoldings url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getTopSectors response = $data");

    return data;
  }

  static Future saveRiskProfile(
      {required int user_id,
      required String client_name,
      required int questionId,
      required int answerId}) async {
    String url =
        "${ApiConfig.apiUrl}/investor/common/saveRiskProfile?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&question_id=$questionId&answer_id=$answerId";

    print("saveRiskProfile url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("saveRiskProfile Response = $data");

    return data;
  }

  static Future getPortfolioAnalysisGraphData({
    required int user_id,
    required String client_name,
    required String frequency,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getPortfolioAnalysisGraphData?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&frequency=$frequency";

    print("getPortfolioAnalysisGraphData url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getPortfolioAnalysisGraphData Response = $data");

    return data;
  }

  static Future getOnlineRestrictionsByUserId({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/common/getOnlineRestrictionsByUserId?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";

    print("getOnlineRestrictionsByUserId url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getOnlineRestrictionsByUserId response = $data");

    return data;
  }

  static Future getWhatsappShareLink({
    required num user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getWhatsappShareLink?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";
    print("getWhatsappShareLink url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getWhatsappShareLink response = $data");
    return data;
  }

  static Future deleteAllCart({
    required int user_id,
    required String client_name,
    required String cart_type,
    required String bse_nse_mfu_flag,
    required BuildContext context,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/v1/deleteAllCart?key=${ApiConfig.apiKey}&user_id=$user_id&bse_nse_mfu_flag=$bse_nse_mfu_flag&client_name=$client_name&cart_type=$cart_type";

    print("deleteAllCart url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("deleteAllCart Response = $data");

    return data;
  }

  static Future getContactDetailsByClientName({
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getContactDetailsByClientName?key=${ApiConfig.apiKey}&client_name=$client_name";
    print("getContactDetailsByClientName url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getContactDetailsByClientName response = $data");
    return data;
  }

  static Future getMfPortfolioHistory(
      {required int user_id,
      required String client_name,
      required String frequency}) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getMfPortfolioHistory?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&frequency=$frequency";

    print("getMfPortfolioHistory url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getMfPortfolioHistory response = $data");

    return data;
  }

  static Future getMfInvestmentPerformance({
    required String period,
    required String amount,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getMfInvestmentPerformance?key=${ApiConfig.apiKey}&period=$period&amount=$amount&client_name=$client_name";

    print("getMfInvestmentPerformance url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getMfInvestmentPerformance response = $data");

    return data;
  }

  static Future getMfInvestmentPerformanceByScheme({
    required String period,
    required num amount,
    required String client_name,
    required String scheme_code,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getMfInvestmentPerformanceByScheme?key=${ApiConfig.apiKey}&period=$period&amount=$amount&client_name=$client_name&scheme_code=$scheme_code";

    print("getMfInvestmentPerformanceByScheme url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getMfInvestmentPerformanceByScheme response = $data");

    return data;
  }

  static Future getMfInvestmentPerformanceByCategory({
    required String period,
    required num amount,
    required String client_name,
    required String category,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getMfInvestmentPerformanceByCategory?key=${ApiConfig.apiKey}&period=$period&amount=$amount&client_name=$client_name&category=$category";

    print("getMfInvestmentPerformanceByCategory url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getMfInvestmentPerformanceByCategory response = $data");

    return data;
  }

  static Future getMfInvestmentPerformanceByAmc({
    required String period,
    required num amount,
    required String client_name,
    required String amc_code,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getMfInvestmentPerformanceByAmc?key=${ApiConfig.apiKey}&period=$period&amount=$amount&client_name=$client_name&amc_code=$amc_code";

    print("getMfInvestmentPerformanceByAmc url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getMfInvestmentPerformanceByAmc response = $data");

    return data;
  }

  static Future getDirectEquityTransactionDetails(
      {required int user_id, required String client_name ,required String company_name}) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getDirectEquityTransactionDetails?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&company_name=$company_name";

    print("getDirectEquityTransactionDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getDirectEquityTransactionDetails response = $data");
    return data;
  }

}
