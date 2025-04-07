import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/research/SchemeInfo.dart';

import '../pojo/SchemeInfoPojo.dart';

class ResearchApi {
  static Future getTopLumpsumFunds({
    required String amount,
    required String category,
    required String period,
    required String amc,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getTopLumpsumFunds?key=${ApiConfig.apiKey}"
        "&amount=$amount&category=$category&period=$period&amc=$amc"
        "&client_name=$client_name";

    print("getTopLumpsumFunds url= $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getTopLumpsumFunds Response = $data");
    return data;
  }

  static Future getRollingReturnsVsCategory(
      {required String schemes,
      required String category,
      required String start_date,
      required String client_name,
      required String period}) async {
    String encodedSchemes = Uri.encodeComponent(schemes);

    String url =
        "${ApiConfig.apiUrl}/mfresearch/getRollingReturnsVsCategory?&key=${ApiConfig.apiKey}"
        "&schemes=$encodedSchemes&category=$category&start_date=$start_date"
        "&period=$period&client_name=$client_name";

    print("getRollingReturnsVsCategory url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getRollingReturnsVsCategory Response = $data");
    return data;
  }

  static Future getRollingReturnsVsBenchmark(
      {required String scheme_name,
      required String start_date,
      required String period,
      required String client_name}) async {
    String encodedSchemes = Uri.encodeComponent(scheme_name);
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getRollingReturnsVsBenchmark?&key=${ApiConfig.apiKey}"
        "&scheme_name=$encodedSchemes&start_date=$start_date&period=$period&client_name=$client_name";
    print("getRollingReturnsVsBenchmark url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getRollingReturnsVsBenchmark Response = $data");
    return data;
  }

  static Future getRollingReturnsSchemes({required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getRollingReturnsSchemes?&key=${ApiConfig.apiKey}&client_name=$client_name";

    print("getRollingReturnsSchemes url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getRollingReturnsSchemes Response = $data");
    return data;
  }

  static Future getSchemeInceptionAndLatestNavDate({
    required String scheme_name,
    required String start_date,
    required String clientName,
  }) async {
    String encodedSchemes = Uri.encodeComponent(scheme_name);
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getSchemeInceptionAndLatestNavDate?&key=${ApiConfig.apiKey}&scheme_name=$encodedSchemes&start_date=$start_date&client_name=$clientName";
    print("getSchemeInceptionAndLatestNavDate url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSchemeInceptionAndLatestNavDate Response = $data");
    return data;
  }

  static Future getCategoryMonitors(
      {required String broadCategory,
      required String period,
      required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getCategoryMonitors?key=${ApiConfig.apiKey}"
        "&broad_category=$broadCategory&period=$period&client_name=$client_name";

    print("getCategoryMonitors request = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getCategoryMonitors response = $data");
    return data;
  }

  static Future getCategoryReturns(
      {required int user_id,
      required String client_name,
      required String Category,
      required String period}) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getCategoryReturns?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&category=$Category&period=$period";
    print("getCategoryReturns request = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getCategoryReturns response = $data");
    return data;
  }

  static Future getBenchmarkMonitors(
      {required String benchmark,
      required String period,
      required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getBenchmarkMonitors?key=${ApiConfig.apiKey}"
        "&benchmark=$benchmark&period=$period&client_name=$client_name";

    print("getBenchmarkMonitors request = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getBenchmarkMonitors response = $data");
    return data;
  }

  static Future getSIPReturnCalculator(
      {required String user_id,
      required String client_name,
      required String category,
      required String fund,
      required String amount,
      required String frequency,
      required String startdate,
      required String enddate}) async {
    String encodedFund = Uri.encodeComponent(fund);
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getSIPReturnCalculator?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name" +
            "&category=$category&fund=$encodedFund&amount=$amount&frequency=$frequency&startdate=$startdate&enddate=$enddate";
    print("getSIPReturnCalculator url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSIPReturnCalculator response = $data");
    return data;
  }

  static Future getLumpSumReturns(
      {required int user_id,
      required String client_name,
      required String scheme,
      required String amount,
      required String startdate,
      required String enddate}) async {
    String encodedScheme = Uri.encodeComponent(scheme);
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getLumpSumReturns?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name" +
            "&scheme=$encodedScheme&amount=$amount&startdate=$startdate&enddate=$enddate";
    print("getLumpSumReturns url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getLumpSumReturns response = $data");
    return data;
  }

  static Future getMfLongShortTermHoldings({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getMfLongShortTermHoldings?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";
    print("getMfLongShortTermHoldings url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getMfLongShortTermHoldings response = $data");
    return data;
  }

  static Future getAllAmc({required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getAllAmc?key=${ApiConfig.apiKey}&client_name=$client_name";

    print("getAllAmc url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getAllAmc response = $data");
    return data;
  }

  static Future getSTPReturns({
    required int user_id,
    required String client_name,
    required String from_scheme,
    required String to_scheme,
    required String initial_amount,
    required String transfer_amount,
    required String frequency,
    required String from_date,
    required String to_date,
    required String init_start_date,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getSTPReturns?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name" +
            "&from_scheme=$from_scheme&to_scheme=$to_scheme&initial_amount=$initial_amount&transfer_amount=$transfer_amount"
                "&frequency=$frequency&from_date=$from_date&to_date=$to_date&init_start_date =$init_start_date";
    print("getSTPReturns url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSTPReturns response = $data");
    return data;
  }

  static Future getSwpReturns({
    required int user_id,
    required String client_name,
    required String scheme_name,
    required String initial_amount,
    required String withdrawal_amount,
    required String frequency,
    required String from_date,
    required String to_date,
    required String init_start_date,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getSwpReturns?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name" +
            "&scheme_name=$scheme_name&initial_amount=$initial_amount&withdrawal_amount=$withdrawal_amount"
                "&frequency=$frequency&from_date=$from_date&to_date=$to_date&init_start_date =$init_start_date";
    print("getSwpReturns url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSwpReturns response = $data");
    return data;
  }

  static Future<SchemeInfoPojo> getSchemeInfo({
    required int user_id,
    required String client_name,
    required String scheme,
  }) async {

    String encodedSchemes = Uri.encodeComponent(scheme);
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getSchemeInfo?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&scheme=$encodedSchemes";
    print("getSchemeInfo url = $url");
    http.Response response = await http.post(Uri.parse(url));
    final res = SchemeInfoPojo.fromJson(jsonDecode(response.body));
    Map data = jsonDecode(response.body);
    print("getSchemeInfo response = $data");
    return res;
  }

  static Future getLumpsumReturnsTableCalc({
    required int user_id,
    required String client_name,
    required String scheme,
    required String amount,
    required String period,
  }) async {
    String encodedSchemes = Uri.encodeComponent(scheme);
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getLumpsumReturnsTableCalc?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&scheme=$encodedSchemes&amount=$amount&period=$period";
    print("getLumpsumReturnsTableCalc url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getLumpsumReturnsTableCalc response = $data");
    return data;
  }

  static Future getSIPReturnsTableCalc({
    required int user_id,
    required String client_name,
    required String scheme,
    required String amount,
    required String period,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getSIPReturnsTableCalc?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&scheme=$scheme&amount=$amount&period=$period";
    print("getSIPReturnsTableCalc url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSIPReturnsTableCalc response = $data");
    return data;
  }

  static Future getPortfolioAnalysis({
    required int user_id,
    required String client_name,
    required String scheme,
  }) async {
    String encodedSchemes = Uri.encodeComponent(scheme);
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getPortfolioAnalysis?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&scheme=$encodedSchemes";
    print("getPortfolioAnalysis url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getPortfolioAnalysis response = $data");
    return data;
  }

  static Future getNavMovementGraph({
    required int user_id,
    required String client_name,
    required String scheme,
    required String period,
  }) async {
    String encodedSchemes = Uri.encodeComponent(scheme);
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getNavMovementGraph?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&scheme=$encodedSchemes&period=$period";

    print("getNavMovementGraph url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getNavMovementGraph response = $data");
    return data;
  }

  static Future getLumpsumReturnsPeriodAndAmount({
    required int user_id,
    required String client_name,
    required String scheme_name,
  }) async {
    String encodedSchemes = Uri.encodeComponent(scheme_name);
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getLumpsumReturnsPeriodAndAmount?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&scheme_name=$encodedSchemes";

    print("getLumpsumReturnsPeriodAndAmount url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getLumpsumReturnsPeriodAndAmount response = $data");
    return data;
  }

  static Future getSipReturnsPeriodAndAmount({
    required int user_id,
    required String client_name,
    required String scheme_name,
  }) async {
    String encodedSchemes = Uri.encodeComponent(scheme_name);
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getSipReturnsPeriodAndAmount?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&scheme_name=$encodedSchemes";

    print("getSipReturnsPeriodAndAmount url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getSipReturnsPeriodAndAmount response = $data");
    return data;
  }

  static Future getAmcWiseExplore({
    required String client_name,
    required String amc,
    required String broad_category,
    required String sort_by,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/mfresearch/getAmcWiseExplore?key=${ApiConfig.apiKey}&client_name=$client_name&amc=$amc&broad_category=$broad_category&sort_by=$sort_by";
    print("getAmcWiseExplore url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getAmcWiseExplore response = $data");
    return data;
  }
}
