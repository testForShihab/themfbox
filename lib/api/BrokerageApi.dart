import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mymfbox2_0/api/ApiConfig.dart';

class BrokerageApi {
  static Future getBrokerageSummaryDetails({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getBrokerageSummaryDetails?user_id=$user_id&client_name=$client_name&key=${ApiConfig.apiKey}";

    print("getBrokerageSummaryDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getBrokerageSummaryDetails response = $data");
    return data;
  }

  static Future getAmcWiseBrokerage({
    required int user_id,
    required String client_name,
    String? month,
    required String max_count,
    required String sort_by,
    required String broker_code,
    String? fin_year,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getAmcWiseBrokerage?user_id=$user_id" +
            "&client_name=$client_name&key=${ApiConfig.apiKey}&month=$month&max_count=$max_count&sort_by=$sort_by&broker_code=$broker_code&fin_year=$fin_year";

    print("getAmcWiseBrokerage url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAmcWiseBrokerage response = $data");
    return data;
  }

  static Future getInvestorWiseBrokerage({
    required int user_id,
    required String client_name,
    required String month,
    required int page_id,
    String search = "",
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getInvestorWiseBrokerage?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&month=$month&page_id=$page_id&search=$search";

    print("getInvestorWiseBrokerage url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getInvestorWiseBrokerage response = $data");
    return data;
  }

  static Future getFamilyWiseBrokerage({
    required int user_id,
    required String client_name,
    required String month,
    required int page_id,
    String search = "",
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getFamilyWiseBrokerage?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&month=$month&page_id=$page_id&search=$search";

    print("getFamilyWiseBrokerage url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getFamilyWiseBrokerage response = $data");
    return data;
  }

  static Future getBranchRmSubBrokerWiseBrokerage({
    required int user_id,
    required String client_name,
     String? month,
    required String search,
    required String type,
      String? fin_year,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getBranchRmSubBrokerWiseBrokerage?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&month=$month&search=$search&type=$type&fin_year=$fin_year";

    print("getBranchRmSubBrokerWiseBrokerage url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getBranchRmSubBrokerWiseBrokerage response = $data");
    return data;
  }

  static Future getInvestorBrokerageDetails({
    required int login_user_id,
    required String client_name,
    required String month,
    required int user_id,
    required String type,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getInvestorBrokerageDetails?key=${ApiConfig.apiKey}&login_user_id=$login_user_id&client_name=$client_name&month=$month&user_id=$user_id&type=$type";

    print("getInvestorBrokerageDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getInvestorBrokerageDetails response = $data");
    return data;
  }

  static Future getBrokerageHistoryDetails({
    required int user_id,
    required String client_name,
    required String frequency,
    String amc_name = "",
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getBrokerageHistoryDetails?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&frequency=$frequency&amc_name=$amc_name";

    print("getBrokerageHistoryDetails url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getBrokerageHistoryDetails response = $data");
    return data;
  }

  static Future getBrokerageMonthList({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getBrokerageMonthList?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";

    print("getBrokerageMonthList url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getBrokerageMonthList response = $data");
    return data;
  }

  static Future getbrokerageFinancialYearList({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getbrokerageFinancialYearList?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";
    print("getbrokerageFinancialYearList url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getbrokerageFinancialYearList response = $data");
    return data;
  }
}
