import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mymfbox2_0/api/ApiConfig.dart';

class NseTransactionApi {
  static Future getLumpsumMinAmountBySchemeName({
    required int user_id,
    required String client_name,
    required String scheme_name,
    required String purchase_type,
  }) async {
    String encodedName = scheme_name.replaceAll("&", "%26");
    String url =
        "${ApiConfig.apiUrl}/nse/common/getLumpsumMinAmountBySchemeName?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&scheme_name=$encodedName&purchase_type=$purchase_type";

    print("getLumpsumMinAmountBySchemeName url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getLumpsumMinAmountBySchemeName Response = $data");

    return data;
  }

  static Future getSipCategoryByAmcCode({
    required int user_id,
    required String client_name,
    required String amc_code,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/nse/common/getSipCategoryByAmcCode?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&amc_code=$amc_code";

    print("getSipCategoryByAmcCode url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getSipCategoryByAmcCode Response = $data");

    return data;
  }

  static Future getSipSchemesByAmcCodeAndCategory({
    required int user_id,
    required String client_name,
    required String amc_name,
    required String category,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/nse/common/getSipSchemesByAmcCodeAndCategory?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&amc_name=$amc_name&category=$category";

    print("getSipSchemesByAmcCodeAndCategory url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getSipSchemesByAmcCodeAndCategory Response = $data");

    return data;
  }

  static Future getSipMinAmountBySchemeName({
    required int user_id,
    required String client_name,
    required String scheme_name,
    required String purchase_type,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/nse/common/getSipMinAmountBySchemeName?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&scheme_name=$scheme_name&purchase_type=$purchase_type";

    print("getSipMinAmountBySchemeName url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getSipMinAmountBySchemeName Response = $data");

    return data;
  }

  static Future getNseMandateInfo({
    required int user_id,
    required String client_name,
    required String iin_number,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/nse/common/getNseMandateInfo?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&iin_number=$iin_number";

    print("getNseMandateInfo url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getNseMandateInfo Response = $data");

    return data;
  }

  static Future getSipDatesAndFrequency({
    required int user_id,
    required String client_name,
    required String scheme,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/nse/common/getSipDatesAndFrequency?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&scheme=$scheme";

    print("getSipDatesAndFrequency url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getSipDatesAndFrequency Response = $data");

    return data;
  }

  static Future addNseBank({
    required int user_id,
    required String client_name,
    required String? iin_number,
    required String ifsc_code,
    required String micr_code,
    required String bank_name,
    required String bank_address,
    required String branch_name,
    required String bank_branch,
    required String account_number,
    required String bank_account_holder_name,
    required String account_type,
    required String bank_code,
    required String process_mode,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/nse/common/addNseBank?key=${ApiConfig.apiKey}&client_name=$client_name&iin_number=$iin_number&ifsc_code=$ifsc_code"
        "&micr_code=$micr_code&bank_name=$bank_name&bank_address=$bank_address&branch_nam$branch_name&bank_branch=$bank_branch&account_number=$account_number"
        "&bank_account_holder_name=$bank_account_holder_name&account_type=$account_type&bank_code=$bank_code&process_mode=$process_mode";

    print("GetNseAddBank url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getNseAddBank Response = $data");
    return data;
  }

  static Future generateNseMandate(
      {required int user_id,
      required String client_name,
      required String iin_number,
      required String account_number}) async {
    String url =
        "${ApiConfig.apiUrl}/nse/common/generateNseMandate?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&user_id=$user_id&iin_number=$iin_number&account_number=$account_number";

    print("generateNseMandate url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("generateNseMandate Response = $data");
    return data;
  }

  static Future multipleSchemesSwitch({
    required int user_id,
    required String client_name,
    required String iin_number,
    required String broker_code,
    required String euin_code,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/nse/transaction/multipleSchemesSwitch?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&iin_number=$iin_number"
        "&broker_code=$broker_code&euin_code=$euin_code";

    print("multipleSchemesSwitch url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("multipleSchemesSwitch Response = $data");

    return data;
  }

  static Future getSwitchCategoryByAmcCode({
    required int user_id,
    required String client_name,
    required String amc_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/nse/common/getSwitchCategoryByAmcCode?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&amc_name=$amc_name";

    print("getSwitchCategoryByAmcCode url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getSwitchCategoryByAmcCode Response = $data");

    return data;
  }

  static Future getSwitchSchemesByAmcCodeAndCategory({
    required int user_id,
    required String client_name,
    required String amc_name,
    required String category,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/nse/common/getSwitchSchemesByAmcCodeAndCategory?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&amc_name=$amc_name&category=$category";

    print("getSwitchSchemesByAmcCodeAndCategory url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getSwitchSchemesByAmcCodeAndCategory Response = $data");

    return data;
  }

  static Future getStpCategoryByAmcCode({
    required int user_id,
    required String client_name,
    required String amc_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/nse/common/getStpCategoryByAmcCode?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&amc_name=$amc_name";

    print("getStpCategoryByAmcCode url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getStpCategoryByAmcCode Response = $data");

    return data;
  }

  static Future getStpSchemesByAmcCodeAndCategory({
    required int user_id,
    required String client_name,
    required String amc_name,
    required String category,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/nse/common/getStpSchemesByAmcCodeAndCategory?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&amc_name=$amc_name&category=$category";

    print("getStpSchemesByAmcCodeAndCategory url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getStpSchemesByAmcCodeAndCategory Response = $data");

    return data;
  }


}
