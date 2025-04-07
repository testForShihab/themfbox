import 'dart:convert';

import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:http/http.dart' as http;

class PropoaslApi {
  static Future investmentProposalRecommendedSchemes({
    required String user_id,
    required num amount,
    required num period,
    required String risk_profile,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/proposal/investmentProposalRecommendedSchemes?key=${ApiConfig.apiKey}&user_id=$user_id&amount=$amount&period=$period&risk_profile=$risk_profile&client_name=$client_name";

    print("investmentProposalRecommendedSchemes url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("investmentProposalRecommendedSchemes response = $data");

    return data;
  }

  static Future autoSuggestScheme({
    required int user_id,
    required String query,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/proposal/autoSuggestScheme?key=${ApiConfig.apiKey}&user_id=$user_id&query=$query&client_name=$client_name";

    print("autoSuggestScheme url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("autoSuggestScheme response = $data");

    return data;
  }

  static Future autoSuggestAllMfSchemes({
    required int user_id,
    required String query,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/autoSuggestAllMfSchemes?key=${ApiConfig.apiKey}&user_id=$user_id&query=$query&client_name=$client_name";

    print("autoSuggestAllMfSchemes url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("autoSuggestAllMfSchemes response = $data");

    return data;
  }



  static Future investmentProposalLumpsumPortfolioAnalysis({
    required num user_id,
    required num inv_amount,
    required num period,
    required String risk_profile,
    required String scheme_code,
    required String amount,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/proposal/investmentProposalLumpsumPortfolioAnalysis?key=${ApiConfig.apiKey}&user_id=$user_id&inv_amount=$inv_amount&period=$period&risk_profile=$risk_profile&client_name=$client_name&scheme_code=$scheme_code&amount=$amount";

    print("investmentProposalLumpsumPortfolioAnalysis url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("investmentProposalLumpsumPortfolioAnalysis response = $data");

    return data;
  }

  static Future investmentProposalSipPortfolioAnalysis({
    required num user_id,
    required num inv_amount,
    required num period,
    required String risk_profile,
    required String scheme_code,
    required String amount,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/proposal/investmentProposalSipPortfolioAnalysis?key=${ApiConfig.apiKey}" +
            "&user_id=$user_id" +
            "&inv_amount=$inv_amount" +
            "&period=$period" +
            "&risk_profile=$risk_profile&client_name=$client_name&scheme_code=$scheme_code&amount=$amount";

    print("investmentProposalSipPortfolioAnalysis url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("investmentProposalSipPortfolioAnalysis response = $data");

    return data;
  }

  static Future investmentProposalStpPortfolioAnalysis({
    required int user_id,
    required String from_scheme_name,
    required String to_scheme_name,
    required num lumpsum_amount,
    required num stp_amount,
    required num from_return,
    required num to_return,
    required num stp_months,
    required String stp_frequency,
    required num investment_period,
    required String client_name,
  }) async {
    String url = "${ApiConfig.apiUrl}/proposal/investmentProposalStpPortfolioAnalysis?key=${ApiConfig.apiKey}" +
        "&user_id=$user_id" +
        "&from_scheme_name=Aditya Birla Sun Life ELSS Tax Saver Fund - Growth Option" +
        "&to_scheme_name=Aditya Birla Sun Life Floating Rate Fund-Direct Plan-Growth" +
        "&lumpsum_amount=$lumpsum_amount&stp_amount=$stp_amount&from_return=$from_return" +
        "&to_return=$to_return&stp_months=$stp_months&stp_frequency=$stp_frequency&stp_investment_horizon=$investment_period&client_name=$client_name";

    print("investmentProposalStpPortfolioAnalysis url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("investmentProposalStpPortfolioAnalysis response = $data");

    return data;
  }

  static Future investmentProposalSwpPortfolioAnalysis({
    required int user_id,
    required String client_name,
    required String scheme_amfi,
    required num period,
    required num lumpsum_amount,
    required num swp_amount,
    required num swp_return,
    required String swp_frequency,
    required String lumpsum_date,
    required String swp_start_date,
    required String swp_end_date,
    required String swp_date,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/proposal/investmentProposalSwpPortfolioAnalysis?key=${ApiConfig.apiKey}" +
            "&user_id=$user_id" +
            "&client_name=$client_name" +
            "&scheme_amfi=$scheme_amfi" +
            "&period=$period&lumpsum_amount=$lumpsum_amount&swp_amount=$swp_amount" +
            "&swp_return=$swp_return&swp_frequency=$swp_frequency&lumpsum_date=$lumpsum_date&swp_start_date=$swp_start_date&swp_end_date=$swp_end_date&swp_date=$swp_date";

    print("investmentProposalStpPortfolioAnalysis url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("investmentProposalStpPortfolioAnalysis response = $data");

    return data;
  }
}
