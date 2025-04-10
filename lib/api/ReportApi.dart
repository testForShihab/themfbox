import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/pojo/gain_loss_report_response.dart';

import '../pojo/gain_loss_fy_list.response.dart';

class ReportApi {
  static Future getTrasanctions({
    required int user_id,
    required String client_name,
    required String financial_year,
    required String transaction_type,
    required String purchase_type,
    required String start_date,
    required String end_date,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/family/getTrasanctions?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name" +
            "&financial_year=$financial_year&transaction_type=$transaction_type&purchase_type=$purchase_type&start_date=$start_date&end_date=$end_date";
    print("getTrasanctions url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getTrasanctions response = $data");
    return data;
  }

  static Future getInvestorFinancialYears({
    required int user_id,
    required String client_name,
    String all_flag = "N",
  }) async {
    String url =
        "${ApiConfig.apiUrl}/family/getInvestorFinancialYears?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&all_flag=$all_flag";
    print("getInvestorFinancialYears url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getInvestorFinancialYears response = $data");
    return data;
  }

  static Future getSipReport({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/family/getSipReport?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";

    print("getSipReport url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getSipReport response = $data");
    return data;
  }

  static Future getMfDividendReport({
    required int user_id,
    required String client_name,
    required String start_date,
    required String end_date,
    required String financial_year,
    required String filterType,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getMfDividendReport?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&financial_year=$financial_year&filterType=$filterType&start_date=$start_date&end_date=$end_date";
    print("getMfDividendReport url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getMfDividendReport response = $data");
    return data;
  }

  static Future getInvestmentSummary({
    required int user_id,
    required String client_name,
    required String type,
    required String folio_type,
    required String selected_date,
    required String summary_type,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/$type/getInvestmentSummary?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name"
        "&folio_type=$folio_type&selected_date=$selected_date&summary_type=$summary_type";

    print("getInvestmentSummary url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getInvestmentSummary response = $data");
    return data;
  }

  static Future FamilyPortfolioAssetCategoryAllocation({
    required int user_id,
    required String client_name,
    String? folio_type,
    String? selected_date,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/family/getPortfolioAssetCategoryAllocation?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&selected_date=$selected_date"
        "&folio_type=$folio_type";

    print("FamilyPortfolioAssetCategoryAllocationPojo url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("FamilyPortfolioAssetCategoryAllocationPojo response = $data");
    return data;
  }

  static Future getPortfolioAssetCategoryAllocation({
    required int user_id,
    required String client_name,
    required String selected_date,
    required String folio_type,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getPortfolioAssetCategoryAllocation?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&user_id=$user_id&selected_date=$selected_date&folio_type=$folio_type";
    print("getPortfolioAssetCategoryAllocation url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getPortfolioAssetCategoryAllocation response = $data");
    return data;
  }

  static Future getInvestorCode({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getInvestorCode?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";

    print("getInvestorClientCode url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getInvestorClientCode response = $data");
    return data;
  }

  static Future getMfTaxReport({
    required int user_id,
    required String client_name,
    required String financial_year,
    required String option,
    required String start_date,
    required String end_date,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getMfTaxReport?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id&financial_year=$financial_year&option=$option&start_date=$start_date&end_date=$end_date";
    print("getMfTaxReport url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getMfTaxReport response = $data");
    return data;
  }

  static Future getMfTransactionReport({
    required int user_id,
    required String client_name,
    required String financial_year,
    required String transaction_type,
    required String start_date,
    required String end_date,
    required String purchase_type,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getMfTransactionReport?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id&financial_year=$financial_year&transaction_type=$transaction_type&purchase_type=$purchase_type&start_date=$start_date&end_date=$end_date";
    print("getMfTransactionReport url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getMfTransactionReport response = $data");
    return data;
  }

  static Future<GainLossReportResponse> getMfGainLossReport({
    required int user_id,
    required String client_name,
    required String financial_year,
    required String option,
    required String start_date,
    required String end_date,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/v1/getMfGainLossReport?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&financial_year=$financial_year&option=$option&start_date=$start_date&end_date=$end_date";
    print("getMfGainLossReport url = $url");

    http.Response response = await http.post(Uri.parse(url));
    print('- ' * 100);
    print('response: $response');
    final res = GainLossReportResponse.fromJson(jsonDecode(response.body));
    print('res: $res');
    Map data = jsonDecode(response.body);

    print("getMfGainLossReport response = $data");
    return res;
  }

  static Future getElssStatementReport(
      {required int user_id,
      required String client_name,
      required String financial_year,
      required String option,
      required String start_date,
      required String end_date}) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getElssStatementReport?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&financial_year=$financial_year&user_id=$user_id&option=$option&start_date=$start_date&end_date=$end_date";
    print("getElssStatementReport url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getElssStatementReport response = $data");
    return data;
  }

  static Future getFolioMasterReport({
    required String client_name,
    required int user_id,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getFolioMasterReport?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id";
    print("getFolioMasterReport url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getFolioMasterReport response = $data");
    return data;
  }

  static Future getMfNotionalGainLossReport(
      {required int user_id,
      required String client_name,
      required String report_type,
      required String folio_type,
      required String folio_scheme_code_array,
      required String red_amt_array}) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getMfNotionalGainLossReport?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&user_id=$user_id&report_type=$report_type&folio_type=$folio_type&folio_scheme_code_array=$folio_scheme_code_array&red_amt_array=$red_amt_array";
    print("getMfNotionalGainLossReport url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getMfNotionalGainLossReport response = $data");
    return data;
  }

  static Future getInvestorInvestmentSummary({
    required int user_id,
    required String client_name,
    required String financial_year,
    required String folio_type,
    required String selected_date,
    required String summary_type,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getInvestmentSummary?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id&financial_year=$financial_year&folio_type=$folio_type&selected_date=$selected_date&summary_type=$summary_type";
    print("getInvestmentSummary url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getInvestmentSummary response = $data");
    return data;
  }

  static Future getFolioSchemeDetails({
    required int user_id,
    required String client_name,
    required String folio_type,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getFolioSchemeDetails?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&user_id=$user_id&folio_type=$folio_type";
    print("getFolioSchemeDetails url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getFolioSchemeDetails response = $data");
    return data;
  }

  static Future<GainLossFyResponse> getGainLossFinancialYears({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/getGainLossFinancialYears?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&user_id=$user_id";

    print("getGainLossFinancialYears url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);
    final res = GainLossFyResponse.fromJson(data);

    print("getGainLossFinancialYears response = $data");
    return res;
  }

  static Future getInvestorSummaryPdf({
    required String email,
    required int user_id,
    required String user_mobile,
    required String type,
    required String client_name,
    required String report_type,
    String? selected_date,
    String? folio_type,
  }) async {
    Map map = {'email': email, 'user_id': user_id};
    List list = [map];
    String invDetails = jsonEncode(list);

    String url =
        "${ApiConfig.apiUrl}/investor/download/getInvestorSummaryPdf?key=${ApiConfig.apiKey}"
        "&investor_details=$invDetails&mobile=$user_mobile&type=$type&client_name=$client_name&selected_date=$selected_date&folio_type=$folio_type&report_type=$report_type";

    print("getInvestorSummaryPdf url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getInvestorSummaryPdf response = $data");
    return data;
  }

  static Future downloadInvestmentSummary({
    required String email,
    required int user_id,
    required String user_mobile,
    required String type,
    required String client_name,
    required String folio,
    required String selected_date,
    required String selectedSummaryType,
  }) async {
    Map map = {'email': email, 'user_id': user_id};
    List list = [map];
    String invDetails = jsonEncode(list);

    String url =
        "${ApiConfig.apiUrl}/investor/download/downloadInvestmentSummary?key=${ApiConfig.apiKey}&type=$type"
        "&user_id=$user_id&client_name=$client_name&folio_type=$folio&selected_date=$selected_date&summary_type=$selectedSummaryType";

    print("downloadInvestmentSummary url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("downloadInvestmentSummary response = $data");
    return data;
  }

  static Future downloadLongShortTermHoldingsPdf({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/download/downloadLongShortTermHoldingsPdf?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";
    print("downloadLongShortTermHoldingsPdf url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("downloadLongShortTermHoldingsPdf response = $data");
    return data;
  }

  static Future downloadNotionalReportPdf({
    required int user_id,
    required String client_name,
    required String type,
    required String selectedReportType,
    required String selectedFolioType,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/download/downloadNotionalReportPdf?key=${ApiConfig.apiKey}&client_name=$client_name&userid=$user_id&report_type=$selectedReportType&folio_type=$selectedFolioType&folio_scheme_code_array="
        "&red_amt_array=&type=$type";

    print("downloadNotionalReportPdf url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("downloadNotionalReportPdf response = $data");
    return data;
  }

  static Future downloadElssStatementPdf({
    required int user_id,
    required String client_name,
    required String financial_year,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/download/downloadElssStatementPdf?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id&type=pdf&financial_year=$financial_year";
    print("downloadElssStatementPdf url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("downloadElssStatementPdf response = $data");
    return data;
  }

  static Future downloadMonthlyTransactionPdf({
    required int user_id,
    required String client_name,
    required String selectedFinancialYear,
    required String type,
    required String transaction_type,
    required String start_date,
    required String end_date,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/download/downloadMonthlyTransactionPdf?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id&type=$type&financial_year=$selectedFinancialYear&transaction_type=$transaction_type&purchase_type=All&start_date=$start_date&end_date=$end_date&folio=&scheme_code=";

    print("downloadMonthlyTransactionPdf url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("downloadMonthlyTransactionPdf response = $data");
    return data;
  }

  static Future downloadDatewiseTransactionPdf({
    required int user_id,
    required String client_name,
    required String type,
    required String startDate,
    required String endDate,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/download/downloadDatewiseTransactionPdf?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id&type=$type&transaction_type=Date&purchase_type=All&start_date=$startDate&end_date=$endDate";

    print("downloadDatewiseTransactionPdf url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("downloadDatewiseTransactionPdf response = $data");
    return data;
  }

  static Future downLoadCompareMutualFundPdf({
    required int userId,
    required String clientName,
    required String schemes,
    required int amount,
    required String startDate,
    required String endDate,
  }) async {
    // String scheme = '';
    // for (int i = 0; i < schemes.length; i++) {
    //   if (i == schemes.length - 1) {
    //     scheme += schemes[i];
    //   } else {
    //     scheme += '${schemes[i]},';
    //   }
    // }

    String url =
        "${ApiConfig.apiUrl}/admin/download/downloadCompareFundsPDF?key=${ApiConfig.apiKey}&user_id=$userId&client_name=$clientName&schemes=$schemes&amount=$amount&start_date=$startDate&end_date=$endDate&test_api=1";

    print("downloadGainLossReportPDF url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("downloadGainLossReportPDF response = $data");
    return data;
  }

  static Future downloadGainLossReportPDF({
    required int user_id,
    required String client_name,
    required String type,
    required financial_year,
    required String option,
    required String startDate,
    required String endDate,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/download/downloadGainLossReportPDF?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id"
        "&type=pdf&financial_year=$financial_year&option=$option&content_option=&start_date=$startDate&end_date=$endDate";

    print("downloadGainLossReportPDF url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("downloadGainLossReportPDF response = $data");
    return data;
  }

  static Future downloadPortfolioTaxPdf({
    required int user_id,
    required String client_name,
    required String type,
    required String startDate,
    required String endDate,
    required String option,
    required String financial_year,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/download/downloadPortfolioTaxPdf?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&type=$type&financial_year=$financial_year&start_date=$startDate"
        "&end_date=$endDate"
        "&option=$option"
        "&content_option="
        "";

    print("downloadPortfolioTaxPdf url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("downloadPortfolioTaxPdf response = $data");
    return data;
  }

  static Future downloadDividendReportPdf({
    required int user_id,
    required String client_name,
    required String type,
    required String startDate,
    required String endDate,
    required String selectedFinancialYear,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/investor/download/downloadDividendReportPdf?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&type=$type&financial_year=$selectedFinancialYear&start_date="
        "&end_date="
        "&filterType=";

    print("downloadDividendReportPdf url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("downloadDividendReportPdf response = $data");
    return data;
  }

  static Future getFamilySummary({
    required int user_id,
    required String client_name,
    required String email,
    required String mobile,
    required String type,
  }) async {
    Map map = {'email': email, 'user_id': user_id};
    List list = [map];
    String invDetails = jsonEncode(list);

    String url =
        "${ApiConfig.apiUrl}/admin/family/getFamilySummary?key=${ApiConfig.apiKey}"
        "&investor_details=$invDetails&mobile=$mobile&type=$type&client_name=$client_name";

    print("downloadDividendReportPdf url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("downloadDividendReportPdf response = $data");
    return data;
  }

  static Future downloadFamilySIPReportPdf({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/admin/family/downloadFamilySIPReportPdf?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";

    print("downloadFamilySIPReportPdf url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("downloadFamilySIPReportPdf response = $data");
    return data;
  }

  static Future downloadFamilyPortfolioTransactionPdf(
      {required int user_id,
      required String client_name,
      required String transaction_type,
      required String start_date,
      required String end_date,
      required String purchase_type,
      required String financial_year}) async {
    String url =
        "${ApiConfig.apiUrl}/admin/family/downloadFamilyPortfolioTransactionPdf?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id&financial_year=$financial_year&transaction_type=$transaction_type&purchase_type=$purchase_type&start_date=$start_date&end_date=$end_date";

    print("downloadFamilyPortfolioTransactionPdf url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("downloadFamilyPortfolioTransactionPdf response = $data");
    return data;
  }

  static Future downloadFamilyPortfolioTransactionExcel({
    required int user_id,
    required String client_name,
    required String financial_year,
    required String report_type,
    required String start_date,
    required String end_date,
    required String purchase_type,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/admin/family/downloadFamilyPortfolioTransactionExcel?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name"
        "&financial_year=$financial_year&start_date=$start_date&end_date=$end_date&report_type=$report_type&purchase_type=$purchase_type";

    print("downloadFamilyPortfolioTransactionExcel url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("downloadFamilyPortfolioTransactionExcel response = $data");
    return data;
  }

  static Future downloadFamilyInvestmentSummaryPdf({
    required int user_id,
    required String client_name,
    required String email,
    required String mobile,
    required String folio_type,
    required String selected_date,
    required String summary_type,
  }) async {
    Map map = {'email': email, 'user_id': user_id};
    List list = [map];
    String invDetails = jsonEncode(list);

    String url =
        "${ApiConfig.apiUrl}/admin/family/downloadFamilyInvestmentSummaryPdf?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&folio_type=$folio_type&selected_date=$selected_date&summary_type=$summary_type";

    print("downloadFamilyInvestmentSummaryPdf url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("downloadFamilyInvestmentSummaryPdf response = $data");
    return data;
  }


  static Future downloadFamilyCurrentPortfolio({
    required int user_id,
    required String client_name,
    required String type,
    required String folio_type,
  }) async {
    // Map map = {'email': email, 'user_id': user_id};
    // List list = [map];
    // String invDetails = jsonEncode(list);

    String url =
        "${ApiConfig.apiUrl}/admin/family/downloadFamilyPortfolio?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&type=$type&folio_type=$folio_type&test_api=1";


    print("downloadFamilyCurrentPortfolio url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("downloadFamilyCurrentPortfolio response = $data");
    return data;
  }

  static Future downloadFamilyPortfolioAssetCategoryAllocation({
    required int user_id,
    required String client_name,
    required String type,
    required String folio_type,
    required String selected_date,
  }) async {

    String url =
        "${ApiConfig.apiUrl}/admin/family/downloadPortfolioAssetCategoryAllocationPdfExcelEmail?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&folio_type=$folio_type"
        "&report_option=Combined&selected_date=$selected_date&type=$type";

    print("downloadFamilyPortfolioAssetCategoryAllocation url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("downloadFamilyPortfolioAssetCategoryAllocation response = $data");
    return data;
  }

  static Future downloadRiskProfilePdf({
    required int user_id,
    required String client_name,
  }) async {

    String url =
        "${ApiConfig.apiUrl}/investor/common/downloadRiskProfilePdf?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name";
    print("downloadRiskProfilePdf url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("downloadRiskProfilePdf response = $data");
    return data;
  }

  static Future familyCurrentPortfolio({
    required int user_id,
    required String client_name,
    String? selected_date,
    String? folio_type,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/family/getMutualFundPortfolio?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&user_id=$user_id"
        "&selected_date=$selected_date&folio_type=$folio_type";
    print("familyCurrentPortfolio url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getfamilyCurrentPortfolio response = $data");
    return data;
  }

// Admin level Reports
  static Future getSipDueReport({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/admin/download/getSipDueReport?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";

    print("getSipDueReport url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getSipDueReport response = $data");
    return data;
  }

  static Future individualXirrReport({
    required int user_id,
    required String client_name,
    required String type,
    required String start_date,
    required String end_date,
    required String option,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/admin/download/individualXirrReport?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&type=$type&start_date=$start_date&end_date=$end_date&option=$option";

    print("individualXirrReport url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("individualXirrReport response = $data");
    return data;
  }

  static Future familyXirrReport({
    required int user_id,
    required String client_name,
    required String type,
    required String start_date,
    required String end_date,
    required String option,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/admin/download/familyXirrReport?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&type=$type&start_date=$start_date&end_date=$end_date&option=$option";

    print("familyXirrReport url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("familyXirrReport response = $data");
    return data;
  }
}
