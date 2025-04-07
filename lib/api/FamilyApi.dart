import 'dart:convert';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:http/http.dart' as http;

class FamilyApi {
  static Future getSummaryDetails({
    required int user_id,
    required String client_name,
    required String folio_type,
    required DateTime selected_date,
  }) async {
    String date =
        "${selected_date.day}-${selected_date.month}-${selected_date.year}";

    String url =
        "${ApiConfig.apiUrl}/family/getSummaryDetails?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&folio_type=$folio_type&selected_date=$date";

    print("getSummaryDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSummaryDetails response = $data");

    return data;
  }

  static Future getMembersDetails({
    required int user_id,
    required String client_name,
    required String folio_type,
    required DateTime selected_date,
  }) async {
    String date =
        "${selected_date.day}-${selected_date.month}-${selected_date.year}";

    String url =
        "${ApiConfig.apiUrl}/family/getMembersDetails?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&folio_type=$folio_type&selected_date=$date";

    print("getMembersDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getMembersDetails response= $data");

    return data;
  }

  static Future getSipMasterDetails(
      {required int user_id, required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/family/getSipMasterDetails?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&max_count=All";

    print("getSipMasterDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSipMasterDetails response = $data");

    return data;
  }

  static Future getMasterPortfolio(
      {required int user_id, required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/family/getMasterPortfolio?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&frequency=Last 6 Months";

    print("getMasterPortfolio url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getMasterPortfolio response = $data");

    return data;
  }

  static Future getBroadCategoryWisePortfolio({
    required int user_id,
    required String client_name,
    required String folio_type,
    required DateTime selected_date,
  }) async {
    String date =
        "${selected_date.day}-${selected_date.month}-${selected_date.year}";

    String url =
        "${ApiConfig.apiUrl}/family/getBroadCategoryWisePortfolio?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&folio_type=$folio_type&selected_date=$date";

    print("getBroadCategoryWisePortfolio url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getBroadCategoryWisePortfolio response = $data");

    return data;
  }

  static Future getCategoryWisePorfolio({
    required int user_id,
    required String client_name,
    required String broad_category,
  }) async {
    if (broad_category != "All") broad_category += " Schemes";

    String url =
        "${ApiConfig.apiUrl}/family/getCategoryWisePorfolio?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&broad_category=$broad_category";

    print("getCategoryWisePorfolio url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getCategoryWisePorfolio response = $data");

    return data;
  }

  static Future getAmcWisePortfolio(
      {required int user_id, required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/family/getAmcWisePortfolio?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";

    print("getAmcWisePortfolio url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAmcWisePortfolio response = $data");

    return data;
  }

  static Future getMfPortfolioHistory(
      {required int user_id,
      required String client_name,
      required String frequency}) async {
    String url =
        "${ApiConfig.apiUrl}/family/getMfPortfolioHistory?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&frequency=$frequency";

    print("getMfPortfolioHistory url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getMfPortfolioHistory response = $data");

    return data;
  }
}
