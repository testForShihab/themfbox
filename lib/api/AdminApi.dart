// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation
import 'dart:convert';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:http/http.dart' as http;
import 'package:mymfbox2_0/superadmin/SuperAdminDashboard.data.dart';

class AdminApi {
  static Future getDashboardData(
      {required String user_id, required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getDashboardDetails?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";
    print("getDashboardDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getDashboardDetails response = $data");

    return data;
  }

  static Future getAumSummaryDetails(
      {required String user_id, required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getAumSummaryDetails?user_id=$user_id"
        "&client_name=$client_name&key=${ApiConfig.apiKey}";

    print("getAumSummaryDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAumSummaryDetails Response = $data");

    return data;
  }

  static Future getBranchWiseAUM(
      {required int user_id,
      required String client_name,
      required int page_id,
      required String sort_by}) async {
    String url = "${ApiConfig.apiUrl}/advisor/getBranchWiseAUM?user_id=$user_id"
        "&client_name=$client_name&key=${ApiConfig.apiKey}"
        "&page_id=$page_id&sort_by=$sort_by";

    print("getBranchWiseAUM url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getBranchWiseAUM Response =  $data");
    return data;
  }

  static Future getRMWiseAUM(
      {required int user_id,
      required String client_name,
      required int page_id,
      required String sort_by}) async {
    String url = "${ApiConfig.apiUrl}/advisor/getRMWiseAUM?user_id=$user_id"
        "&client_name=$client_name&key=${ApiConfig.apiKey}&page_id=$page_id&sort_by=$sort_by";

    print("getRMWiseAUM url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getRMWiseAUM Response =  $data");
    return data;
  }

  static Future getAssociateAum({
    required int user_id,
    required String client_name,
    required int page_id,
    required String sort_by,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getAssociateWiseAUM?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&page_id=$page_id&sort_by=$sort_by";

    print("getAssociateAum url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAssociateAum Response =  $data");
    return data;
  }

  static Future getInvestors(
      {required int page_id,
      required String client_name,
      required int user_id,
      String search = "",
      String sortby = "alphabet-az",
      String subbroker_name = "",
      String start_date="",
      String end_date="",
      required List rmList,
      required String branch}) async {
    String rm = "";
    if (rmList.isNotEmpty) rm = rmList.join(",");

    String url =
        "${ApiConfig.apiUrl}/advisor/getInvestors?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&pageid=$page_id&user_id=$user_id"
        "&max_count=&search=$search&sort_by=$sortby&branch=$branch"
        "&rm_name=$rm&subbroker_name=$subbroker_name&start_date=$start_date&end_date=$end_date";

    print("getInvestors url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getInvestors response = $data");
    return data;
  }

  static Future getInvestorsSummaryDetails(
      {required int user_id, required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getInvestorsSummaryDetails?key=${ApiConfig.apiKey}&client_name=$client_name&pageid=1&user_id=$user_id&max_count=";

    print("getInvestorsSummaryDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getInvestorsSummaryDetails response = $data");
    return data;
  }

  static Future getNonSipDetails({
    required int user_id,
    required String client_name,
    String branch = "",
    String rmList = "",
    String sub_broker_name = "",
    String broker_code = "",
    required int page_id,
    String search = "",
    String sort_by = "Aum",
    String option = "",
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getNonSipDetails?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&branch=$branch&rm_name=$rmList&sub_broker_name=$sub_broker_name&broker_code=$broker_code"
        "&page_id=$page_id&search=$search&sort_by=$sort_by&option=$option";
    print("getNonSipDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getNonSipDetails response = $data");
    return data;
  }

  static Future getNonElssDetails({
    required int user_id,
    required String client_name,
    String branch = "",
    String rmList = "",
    String sub_broker_name = "",
    String broker_code = "",
    required int page_id,
    String search = "",
    String sort_by = "Aum",
    String option = "",
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getNonElssInvestorsDetails?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&branch=$branch&rm_name=$rmList&sub_broker_name=$sub_broker_name&broker_code=$broker_code"
        "&page_id=$page_id&search=$search&sort_by=$sort_by&option=$option";
    print("getNonElssInvestorsDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getNonElssInvestorsDetails response = $data");
    return data;
  }

  static Future getAllRMDetails({
    required int user_id,
    required String client_name,
    String branch = "",
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getAllRMDetails?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&branch=$branch";
    print("getAllRMDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAllRMDetails response = $data");
    return data;
  }

  static Future getAllSubbrokerDetails({
    required int user_id,
    required String client_name,
    String branch = "",
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getAllSubbrokerDetails?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&branch=$branch";
    print("getAllRMDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAllRMDetails response = $data");
    return data;
  }

  static Future getAllFamilies(
      {required int user_id,
      required String client_name,
      required int page_id,
      String branch = "",
      String rmList = "",
      String subbroker_name = "",
      String search = "",
      String sortby = "alphabet-az"}) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getFamilyInvestors?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&pageid=$page_id&user_id=$user_id&max_count=&search=$search"
        "&sort_by=$sortby&branch=$branch&rmList=$rmList&subbroker_name=$subbroker_name";

    print("getAllFamilies url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAllFamilies response = $data");
    return data;
  }

  static Future getFamilyDetails(
      {required int user_id, required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getFamilyDetails?user_id=$user_id&key=${ApiConfig.apiKey}&client_name=$client_name";

    print("getFamilyDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getFamilyDetails response = $data");
    return data;
  }

  static Future getSchemesWiseInvestors({
    required String sort_by,
    required int user_id,
    required String client_name,
    required String scheme_name,
    required String branch_name,
    required String broker_code,
    required String subbroker_name,
    required String rm_name,
  }) async {
    String encodedSchemes = Uri.encodeComponent(scheme_name);
    String url =
        "${ApiConfig.apiUrl}/advisor/getSchemesWiseInvestors?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&"
        "scheme_name=$encodedSchemes&branch_name=$branch_name&broker_code=$broker_code&subbroker_name=$subbroker_name&rm_name=$rm_name";

    print("getSchemesWiseInvestors url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSchemesWiseInvestors response = $data");

    return data;
  }

  static Future getActiveSipDetails({
    required int user_id,
    required String client_name,
    required String branch,
    required String rm_name,
    required String sip_date,
    required String amc_name,
    required String start_date,
    required String end_date,
    required String broker_code,
    required String sub_broker_name,
    required int page_id,
    required String search,
    required String sort_by,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getActiveSipDetails?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name"
        "&branch=$branch&rm_name=$rm_name&sub_broker_name=$sub_broker_name"
        "&sip_date=$sip_date&amc_name=$amc_name&page_id=$page_id&sort_by=$sort_by"
        "&start_date=$start_date&end_date=$end_date&broker_code=$broker_code&search=$search";

    print("getActiveSipDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getActiveSipDetails response = $data");
    return data;
  }

  static Future getSipStartingShortlyDetails({
    required int user_id,
    required String client_name,
    required String sip_date,
    required String amc_name,
    required String start_date,
    required String end_date,
    required String broker_code,
    required int page_id,
    required String search,
    required String branch,
    required String rm_name,
    required String sub_broker_name,
    required String sort_by,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getSipStartingShortlyDetails?key=${ApiConfig.apiKey}" +
            "&user_id=$user_id&client_name=$client_name" +
            "&rm_name=$rm_name&sip_date=$sip_date&amc_name=$amc_name&page_id=$page_id" +
            "&start_date=$start_date&end_date=$end_date&broker_code=$broker_code&search=$search" +
            "&branch=$branch&sub_broker_name=$sub_broker_name&sort_by=$sort_by";

    print("getSipStartingShortlyDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSipStartingShortlyDetails response = $data");
    return data;
  }

  static Future getClosedSipDetails({
    required int user_id,
    required String client_name,
    required String sip_date,
    required String amc_name,
    required String start_date,
    required String end_date,
    required String broker_code,
    required int page_id,
    required String search,
    required String branch,
    required String rm_name,
    required String sub_broker_name,
    required String sort_by,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getClosedSipDetails?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&page_id=$page_id"
        "&rm_name=$rm_name&sip_date=$sip_date&amc_name=$amc_name"
        "&start_date=$start_date&end_date=$end_date&"
        "broker_code=$broker_code&search=$search"
        "&sub_broker_name=$sub_broker_name&branch=$branch&sort_by=$sort_by";

    print("getClosedSipDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getClosedSipDetails response = $data");
    return data;
  }

  static Future getSipMissingReportDetails({
    required int user_id,
    required String client_name,
    required String sip_date,
    required String amc_name,
    required String start_date,
    required String end_date,
    required String broker_code,
    required int page_id,
    required String search,
    required String branch,
    required String rm_name,
    required String sub_broker_name,
    required String sort_by,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getSipMissingReportDetails?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&page_id=$page_id&sort_by=$sort_by"
        "&rm_name=$rm_name&sip_date=$sip_date&amc_name=$amc_name&branch=$branch&sub_broker_name=$sub_broker_name"
        "&start_date=$start_date&end_date=$end_date&broker_code=$broker_code&search=$search";

    print("getSipMissingReportDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSipMissingReportDetails response = $data");
    return data;
  }

  static Future getSipBounceReoprtDetails({
    required int user_id,
    required String client_name,
    required String sip_date,
    required String amc_name,
    required String start_date,
    required String end_date,
    required String broker_code,
    required int page_id,
    required String search,
    required String branch,
    required String rm_name,
    required String sub_broker_name,
    required String sort_by,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getSipBounceReoprtDetails?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&page_id=$page_id&sort_by=$sort_by"
        "&rm_name=$rm_name&sip_date=$sip_date&amc_name=$amc_name&branch=$branch&sub_broker_name=$sub_broker_name"
        "&start_date=$start_date&end_date=$end_date&broker_code=$broker_code&search=$search";

    print("getSipBounceReoprtDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSipBounceReoprtDetails response = $data");
    return data;
  }

  static Future getActiveStpReport({
    required int user_id,
    required String client_name,
    required String rm_name,
    required String start_date,
    required String end_date,
    required String broker_code,
    required int page_id,
    required String branch,
    required String sub_broker_name,
    required String amc,
    required String sort_by,
    required String search,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getActiveStpReport?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&page_id=$page_id&branch=$branch"
        "&sub_broker_name=$sub_broker_name&rm_name=$rm_name&start_date=$start_date"
        "&end_date=$end_date&broker_code=$broker_code&amc_name=$amc&sort_by=$sort_by&search=$search";

    print("getActiveStpReport url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getActiveStpReport response = $data");
    return data;
  }

  static Future getClosedStpReport({
    required int user_id,
    required String client_name,
    required String rm_name,
    required String start_date,
    required String end_date,
    required String broker_code,
    required String branch,
    required String sub_broker_name,
    required int page_id,
    required String amc,
    required String sort_by,
    required String search,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getClosedStpReport?user_id=$user_id&client_name=$client_name&key=${ApiConfig.apiKey}" +
            "&rm_name=$rm_name&start_date&end_date&broker_code=$broker_code&page_id=$page_id" +
            "&branch=$branch&sub_broker_name=$sub_broker_name"
                "&amc_name=$amc&sort_by=$sort_by&search=$search";

    print("getClosedStpReport url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getClosedStpReport response = $data");
    return data;
  }

  static Future getSipExpiringShortlyDetails({
    required int user_id,
    required String client_name,
    required String amc_name,
    required String start_date,
    required String end_date,
    required String broker_code,
    required int page_id,
    required String search,
    required String branch,
    required String rm_name,
    required String sub_broker_name,
    required String sort_by,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getSipExpiringShortlyDetails?key=${ApiConfig.apiKey}" +
            "&user_id=$user_id&client_name=$client_name&page_id=$page_id" +
            "&rm_name=$rm_name&amc_name=$amc_name" +
            "&start_date=$start_date&end_date=$end_date&broker_code=$broker_code&search=$search"
                "&branch=$branch&sub_broker_name=$sub_broker_name&sort_by=$sort_by";

    print("getSipExpiringShortlyDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSipExpiringShortlyDetails response = $data");
    return data;
  }

  static Future getActiveSwpReport({
    required int user_id,
    required String client_name,
    required String branch,
    required String rm_name,
    required String sip_date,
    required String amc_name,
    required String start_date,
    required String end_date,
    required String broker_code,
    required String sub_broker_name,
    required int page_id,
    required String search,
    required String sort_by,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getActiveSwpReport?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&search=$search&sort_by=$sort_by"
        "&branch=$branch&rm_name=$rm_name&sub_broker_name=$sub_broker_name"
        "&sip_date=$sip_date&amc_name=$amc_name&page_id=$page_id"
        "&start_date=$start_date&end_date=$end_date&broker_code=$broker_code";

    print("getActiveSwpReport url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getActiveSwpReport response = $data");
    return data;
  }

  static Future getClosedSwpReport({
    required int user_id,
    required String client_name,
    required String sip_date,
    required String amc_name,
    required String start_date,
    required String end_date,
    required String broker_code,
    required String branch,
    required String rm_name,
    required String sub_broker_name,
    required int page_id,
    required String search,
    required String sort_by,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getClosedSwpReport?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&search=$search&sort_by=$sort_by"
        "&rm_name=$rm_name&sip_date=$sip_date&amc_name=$amc_name&start_date=$start_date&end_date=$end_date"
        "&broker_code=$broker_code&branch=$branch&rm=$rm_name&sub_broker_name=$sub_broker_name&page_id=$page_id";

    print("getClosedSwpReport url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getClosedSwpReport response = $data");
    return data;
  }

  static Future getCategoryList({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/article/getCategoryList?user_id=$user_id&client_name=$client_name&key=${ApiConfig.apiKey}";

    print("getCategoryList url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getCategoryList response = $data");
    return data;
  }

  static Future getAuthorList({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/article/getAuthorList?user_id=$user_id&client_name=$client_name&key=${ApiConfig.apiKey}";
    print("getAuthorList url = $url");

    http.Response response = await http.post(Uri.parse((url)));
    Map data = jsonDecode(response.body);
    print("getAuthorList response = $data");
    return data;
  }

  static Future getArticles(
      {required int user_id,
      required String client_name,
      required int page_id,
      required String type,
      required String category,
      required String author,
      required String search}) async {
    String url =
        "${ApiConfig.apiUrl}/article/getArticles?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&page_id=$page_id&type=$type&category=$category&author=$author&search=$search";
    print("getArticles url = $url");
    http.Response response = await http.post(Uri.parse((url)));
    Map data = jsonDecode(response.body);
    print("getArticles response = $data");
    return data;
  }

  static Future getArticlesDetails({
    required int article_id,
    required String client_name,
    required int user_id,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/article/getArticlesDetails?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&article_id=$article_id";
    print("getArticlesDetails url = $url");
    http.Response response = await http.post(Uri.parse((url)));
    Map data = jsonDecode(response.body);
    print("getArticlesDetails response = $data");
    return data;
  }

  static Future getNews({
    required int user_id,
    required String client_name,
    required String category,
    required String search,
    required int page_id,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/news/getNews?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&category=$category&search=$search&page_id=$page_id";
    print("getNews url = $url");
    http.Response response = await http.post(Uri.parse((url)));
    Map data = jsonDecode(response.body);
    print("getNews response = $data");
    return data;
  }

  static Future getNewsDetails({
    required int user_id,
    required String client_name,
    required int news_id,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/news/getNewsDetails?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&news_id=$news_id";
    print("getNewsDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getNewsDetails response = $data");
    return data;
  }

  static Future getInvestorsBirthday({
    required int user_id,
    required String client_name,
    required int page_id,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getInvestorsBirthday?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&page_id=$page_id";
    print("getInvestorsBirthday url = $url");
    http.Response response = await http.post(Uri.parse((url)));
    Map data = jsonDecode(response.body);
    print("getInvestorsBirthday response = $data");
    return data;
  }

  static Future getInvestorsAnniversary({
    required int user_id,
    required String client_name,
    required int page_id,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getInvestorsAnniversary?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&page_id=$page_id";
    print("getInvestorsAnniversary url = $url");
    http.Response response = await http.post(Uri.parse((url)));
    Map data = jsonDecode(response.body);
    print("getInvestorsAnniversary response = $data");
    return data;
  }

  static Future getSipDueDetails({
    required int user_id,
    required String client_name,
    required int due_period,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getSipDueDetails?client_name=$client_name&user_id=$user_id&key=${ApiConfig.apiKey}&due_period=$due_period";
    print("getSipDueDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSipDueDetails Response = $data");
    return data;
  }

  static Future getNegativePositiveReturnFolios(
      {required int user_id,
      required String client_name,
      required String start_range,
      required String end_range,
      required String option,
      required String rm_name,
      required int page_id,
      String max_count = "",
      required String search,
      required String sort_by}) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getNegativePositiveReturnFolios?key=${ApiConfig.apiKey}" +
            "&user_id=$user_id&client_name=$client_name" +
            "&start_range=$start_range&end_range=$end_range&option=$option&rm_name=$rm_name" +
            "&page_id=$page_id&max_count=$max_count&search=$search&sort_by=$sort_by";

    print("getNegativePositiveReturnFolios url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getNegativePositiveReturnFolios Response = $data");
    return data;
  }

  static Future getPortfolioAnalysisReport({
    required int user_id,
    required String client_name,
    required String benchmark_code,
    required String name_pan,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getPortfolioAnalysisReport?&client_name=$client_name&user_id=$user_id&key=${ApiConfig.apiKey}&benchmark_code=$benchmark_code&name_pan=$name_pan";
    print("getPortfolioAnalysisReport url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getPortfolioAnalysisReport Response = $data");
    return data;
  }

  static Future getIndividualXIRR({
    required String client_name,
    required int user_id,
    required String pan,
    required String name,
    required String start_date,
    required String end_date,
    required String option,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getIndividualXIRR?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id&pan=$pan&name=$name&start_date=$start_date&end_date=$end_date&option=$option";
    print("getIndividualXIRR url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getIndividualXIRR response = $data");
    return data;
  }

  static Future getNegativePositiveRMFilter({
    required String client_name,
    required int user_id,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getNegativePositiveRMFilter?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id";
    print("getNegativePositiveRMFilter url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getNegativePositiveRMFilter response = $response");
    return data;
  }

  static Future getFamilyXIRR({
    required int user_id,
    required String client_name,
    required String pan,
    required String name,
    required String start_date,
    required String end_date,
    required String option,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getFamilyXIRR?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id&pan=$pan&name=$name&start_date=$start_date&end_date=$end_date&option=$option";
    print("getFamilyXIRR url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getFamilyXIRR Response = $data");
    return data;
  }

  static Future getCompareFunds({
    required int user_id,
    required String client_name,
    required String scheme,
    required String amount,
    required String start_date,
    required String end_date,
  }) async {
    String encodedSchemes = Uri.encodeComponent(scheme);
    String url =
        "${ApiConfig.apiUrl}/advisor/getCompareFunds?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id&scheme=$encodedSchemes&amount=$amount&start_date=$start_date&end_date=$end_date";
    print("getCompareFunds url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getCompareFunds Response  = $data");
    return data;
  }

  static Future getTransactionReport({
    required int user_id,
    required String client_name,
    required String start_date,
    required String end_date,
    required String branch,
    required String rm_name,
    required String subbroker_name,
    required String purchase_type,
    required String registrar,
    required String investor_id,
    required String amc_name,
    required int page_id,
    required String sortDirection,
    required String sort_by,
    required String search,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getTransactionReport?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id"
        "&start_date=$start_date&end_date=$end_date"
        "&branch=$branch&rm_name=$rm_name&subbroker_name=$subbroker_name&purchase_type=$purchase_type"
        "&registrar=$registrar&investor_id=$investor_id&amc_name=$amc_name&page_id=$page_id&sortDirection=$sortDirection";
    print("getTransactionReport url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getTransactionReport Response  = $data");
    return data;
  }

  static Future getTransactionRejectionReport({
    required int user_id,
    required String client_name,
    required String start_date,
    required String end_date,
    required String purchase_type,
    required int page_id,
  })async{
    String url = "${ApiConfig.apiUrl}/advisor/getTransactionRejectionReport?key=${ApiConfig.apiKey}&client_name=$client_name"
        "&user_id=$user_id&start_date=$start_date&end_date=$end_date&purchase_type=$purchase_type&page_id=$page_id";
    print("getTransactionRejectionReport url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getTransactionRejectionReport response = $data");
    return data;
  }

  static Future getModelPortfolio({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getModelPortfolio?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";
    print("getModelPortfolio url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getModelPortfolio Response  = $data");
    return data;
  }

  static Future getNewSchemeForModelPortfolio({
    required int user_id,
    required String client_name,
    required String scheme,
  }) async {
     String encodedSchemes = Uri.encodeComponent(scheme);
    String url =
        "${ApiConfig.apiUrl}/advisor/getNewSchemeForModelPortfolio?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&scheme=$encodedSchemes";
    print("getNewSchemeForModelPortfolio url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getNewSchemeForModelPortfolio response = $data");
    return data;
  }

  static Future downloadSIPCalcResult({
    required int user_id,
    required int sip_amount,
    required double interest_rate,
    required int period,
    required String client_name,
    required String type,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/download/downloadSIPCalcResult?key=ca8f4555-99f0-4b3b-b7a0-3a6880cec417&sip_amount=$sip_amount"
        "&interest_rate=$interest_rate&period=$period&type=$type&user_id=$user_id&client_name=$client_name";
    print("downloadSIPCalcResult url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("downloadSIPCalcResult Response  = $data");
    return data;
  }

  static Future sendInvestorBirthDayOrAnniversaryEmail({
    required int user_id,
    required String client_name,
    required String user_ids,
    required String type,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/sendInvestorBirthDayOrAnniversaryEmail?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&user_ids=$user_ids&type=$type";
    print("sendInvestorBirthDayOrAnniversaryEmail url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("sendInvestorBirthDayOrAnniversaryEmail Response  = $data");
    return data;
  }

  static Future getRmWiseSipDetails({
    required int user_id,
    required String client_name,
    required int page_id,
    required String sort_by,
    String branch = "",
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getRmWiseSipDetails?key=${ApiConfig.apiKey}&user_id=$user_id"
        "&client_name=$client_name&sort_by=$sort_by&page_id=$page_id&branch=$branch";
    print("getRmWiseSipDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getRmWiseSipDetails response = $data");
    return data;
  }

  static Future getBranchWiseSipDetails(
      {required int user_id,
      required String client_name,
      required int page_id,
      required String sort_by}) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getBranchWiseSipDetails?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name"
        "&page_id=$page_id&sort_by=$sort_by";
    print("getBranchWiseSipDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getBranchWiseSipDetails response = $data");
    return data;
  }

  static Future getSubBrokerWiseSipDetails({
    required int user_id,
    required String client_name,
    required String rm_name,
    required String sort_by,
    required int page_id,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getSubBrokerWiseSipDetails?key=${ApiConfig.apiKey}&user_id=$user_id"
        "&client_name=$client_name&rm_name=$rm_name&sort_by=$sort_by&page_id=$page_id";
    print("getSubBrokerWiseSipDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSubBrokerWiseSipDetails resposne = $data");
    return data;
  }

  static Future getClientWiseSipDetails({
    required int user_id,
    required String client_name,
    required int page_id,
    required String sort_by,
    required String branch,
    required String rm_name,
    required String subbroker_name,
    required String search,
    required String scheme_name,
    required String amc,
    required String broker_code,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getClientWiseSipDetails?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&page_id=$page_id&sort_by=$sort_by&amc=$amc"
        "&branch=$branch&rm_name=$rm_name&subbroker_name=$subbroker_name&search=$search"
        "&scheme_name=$scheme_name&broker_code=$broker_code";

    print("getClientWiseSipDetails url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getClientWiseSipDetails Response  = $data");
    return data;
  }

  static Future getFamilyWiseSipDetails({
    required int user_id,
    required String client_name,
    required int page_id,
    required String sort_by,
    required String branch,
    required String rm_name,
    required String sub_broker_name,
    required String search,
    required String amc,
    required String broker_code,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getFamilyWiseSipReport?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&page_id=$page_id"
        "&sort_by=$sort_by&branch=$branch&rm_name=$rm_name&sub_broker_name=$sub_broker_name"
        "&search=$search&amc=$amc&broker_code=$broker_code";

    print("getFamilyWiseSipDetails url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getFamilyWiseSipDetails Response  = $data");
    return data;
  }

  static Future getRatingWiseSipDetails({
    required int user_id,
    required String client_name,
    required String max_count,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getRatingWiseSipDetails?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&max_count=$max_count";

    print("getRatingWiseSipDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getRatingWiseSipDetails Response  = $data");
    return data;
  }

  static Future getAdminProfileDetails({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getAdminProfileDetails?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";
    print("getAdminProfileDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAdminProfileDetails Response = $data");
    return data;
  }

  static Future updateProfile({required Map inputData}) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/updateProfile?key=${ApiConfig.apiKey}";

    inputData.forEach((key, value) {
      url += "&$key=$value";
    });

    print("updateProfile url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("updateProfile Response = $data");
    return data;
  }

  static Future updateBseNseDetails({
    required String bse_psswd,
    required String nse_psswd,
    required String ria_nse_psswd,
    required int flag,
    required String mfu_psswd,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/updateBseNseDetails?key=${ApiConfig.apiKey}&bse_psswd=$bse_psswd&nse_psswd=$nse_psswd&ria_nse_psswd=$ria_nse_psswd&flag=$flag&mfu_psswd=$mfu_psswd&client_name=$client_name";
    print("updateBseNseDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("updateBseNseDetails Response = $data");
    return data;
  }

  static Future updatemailback({
    required String fund_uid,
    required String fund_password,
    required String fund_security_ans,
    required int flag,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/updatemailback?key=${ApiConfig.apiKey}&fund_uid=$fund_uid&fund_password=$fund_password&fund_security_ans=$fund_security_ans&flag=$flag&client_name=$client_name";
    print("updatemailback url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("updatemailback Response = $data");
    return data;
  }

  static Future saveAmcTableDetails({
    required String amc_array,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/saveAmcTableDetails?key=${ApiConfig.apiKey}&amc_array=$amc_array&client_name=$client_name";
    print("saveAmcTableDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("saveAmcTableDetails Response = $data");
    return data;
  }

  static Future getAllOnlineRestrictions({
    required int user_id,
    required String client_name,
    required String branch,
    required String rm_name,
    required String subbroker_name,
    required int page_id,
    required String search,
    required String sort_by,
    required String broker_code,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/getAllOnlineRestrictions?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&branch=$branch&rm_name=$rm_name&subbroker_name=$subbroker_name&page_id=$page_id&search=$search&sort_by=$sort_by&broker_code=$broker_code";
    print("getAllOnlineRestrictions url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAllOnlineRestrictions response = $data");
    return data;
  }

  static Future updateOnlineRestrictionsByUserId({
    required num user_id,
    required String client_name,
    String purchase_allowed = "",
    String redeem_allowed = "",
    String switch_allowed = "",
    String stp_allowed = "",
    String swp_allowed = "",
    String mf_oneday_change = "",
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/updateOnlineRestrictionsByUserId?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&purchase_allowed=$purchase_allowed&redeem_allowed=$redeem_allowed&switch_allowed=$switch_allowed"
        "&stp_allowed=$stp_allowed&swp_allowed=$swp_allowed&mf_oneday_change=$mf_oneday_change";
    print("updateOnlineRestrictionsByUserId url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("updateOnlineRestrictionsByUserId response = $data");
    return data;
  }

  static Future createClient({
    required int mfd_id,
    required String client_name,
    required String investor_id,
    required String name,
    required String pan,
    required String mobile,
    required String alter_mobile,
    required String email,
    required String alter_email,
    required String rm_name,
    required String subbroker_name,
    required int status,
    required String address1,
    required String address2,
    required String address3,
    required String city,
    required String pincode,
    required String state,
    required String country,
    required String phone_off,
    required String phone_res,
    required String dob,
    required String anniversary_date,
    required String occupation,
    required String guard_name,
    required String guard_pan,
    required String cust_type,
    required String cus_ref,
    required int login_status,
    required String? salutation,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/v1/createClient?key=${ApiConfig.apiKey}&user_id=$mfd_id&client_name=$client_name&id=$investor_id&name=$name&pan=$pan"
        "&mobile=$mobile&alter_mobile=$alter_mobile&email=$email&alter_email=$alter_email&rm_name=$rm_name&subbroker_name=$subbroker_name&status=$status&address1=$address1&address2=$address2&address3=$address3"
        "&city=$city&pincode=$pincode&state=$state&country=$country&phone_off=$phone_off&phone_res=$phone_res&dob=$dob&anniversary_date=$anniversary_date"
        "&occupation=$occupation&guard_name=$guard_name&guard_pan=$guard_pan&cust_type=$cust_type&cus_ref=$cus_ref&login_status=$login_status&salutation=$salutation";
    print("createClient url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("createClient response = $data");
    return data;
  }

  static Future getInvestorSummaryPdf({
    required String investor_details,
    required String mobile,
    required String type,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/download/getInvestorSummaryPdf?key=${ApiConfig.apiKey}&investor_details=$investor_details&mobile=$mobile&type=$type&client_name=$client_name";
    print("getInvestorSummaryPdf url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getInvestorSummaryPdf response = $data");
    return data;
  }

  static Future deleteUser({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/advisor/deleteUser?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";
    print("getInvestorSummaryPdf url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getInvestorSummaryPdf response = $data");
    return data;
  }

  static Future getAdvisorsList(
      {required int user_id,
      required int page_id,
      required String search}) async {
    String url =
        "${ApiConfig.apiUrl}/superadmin/getAdvisorsList?key=ca8f4555-99f0-4b3b-b7a0-3a6880cec417"
        "&user_id=$user_id&search=$search&page_id=$page_id&sort_by";

    print("getAdvisorsList url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAdvisorsList response = $data");
    return data;
  }
}
