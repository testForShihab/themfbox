import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:http_parser/src/media_type.dart';

class TransactionApi {
  static Future getLumpsumAmc({
    required String bse_nse_mfu_flag,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getLumpsumAmc?key=${ApiConfig.apiKey}"
        "&bse_nse_mfu_flag=$bse_nse_mfu_flag&client_name=$client_name";
    print("getLumpsumAmc url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getLumpsumAmc reponse = $data");

    return data;
  }

  static Future getPaymentModes({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
    required String purchase_type,
    String nfo_flag = "N",
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getPaymentModes?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag&purchase_type=$purchase_type&nfo_flag=$nfo_flag";

    print("getPaymentModes url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getPaymentModes reponse = $data");

    return data;
  }

  //getStpDays

  static Future getStpDays({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
  })async{
    String url = "${ApiConfig.apiUrl}/transact/getStpDays?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";
    print("getStpDays url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getStpDays response = $data");
    return data;
  }

  static Future getLumpsumCategory({
    required String amc_code,
    required String bse_nse_mfu_flag,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getLumpsumCategory?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag&amc_code=$amc_code";

    print("getLumpsumCategory url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getLumpsumCategory reponse = $data");

    return data;
  }

  static Future getLumpsumSchemes({
    required String amc_name,
    required String category,
    required String bse_nse_mfu_flag,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getLumpsumSchemes?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&amc_name=$amc_name&category=$category&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getLumpsumSchemes url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getLumpsumSchemes reponse = $data");

    return data;
  }

  static Future getLumpsumMinAmount(
      {required String scheme_name,
      required String purchase_type,
      required String bse_nse_mfu_flag,
      required String amount,
      required String reinvest_tag,
      required String client_name}) async {
    //if (scheme_name.contains("&")) scheme_name = scheme_name.replaceAll("&", "%26");
   /* if (scheme_name.contains(" "))  scheme_name = scheme_name.replaceAll(" ", "%20");
    if (scheme_name.contains("&"))  scheme_name = scheme_name.replaceAll("&", "%26");
    if (scheme_name.contains("-"))  scheme_name = scheme_name.replaceAll("-", "%2D");
    if (scheme_name.contains("("))  scheme_name = scheme_name.replaceAll("(", "%28");
    if (scheme_name.contains(")"))  scheme_name = scheme_name.replaceAll(")", "%29");
    if (scheme_name.contains("."))  scheme_name = scheme_name.replaceAll(".", "%2E");
    if (scheme_name.contains("/"))  scheme_name = scheme_name.replaceAll("/", "%2F");
    if (scheme_name.contains(":"))  scheme_name = scheme_name.replaceAll(":", "%3A");
    if (scheme_name.contains("+"))  scheme_name = scheme_name.replaceAll("+", "%2B");
    if (scheme_name.contains("'"))  scheme_name = scheme_name.replaceAll("'", "%27");
    if (scheme_name.contains("%"))  scheme_name = scheme_name.replaceAll("%", "%25");*/

    scheme_name = Uri.encodeComponent(scheme_name);

    String url =
        "${ApiConfig.apiUrl}/transact/getLumpsumMinAmount?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&scheme_name=$scheme_name&purchase_type=$purchase_type"
        "&bse_nse_mfu_flag=$bse_nse_mfu_flag&amount=$amount&reinvest_tag=$reinvest_tag";

    print("getLumpsumMinAmount url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getLumpsumMinAmount Response = $data");

    return data;
  }

  static Future getSipAmc({
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getSipAmc?key=${ApiConfig.apiKey}&bse_nse_mfu_flag=$bse_nse_mfu_flag&client_name=$client_name";

    print("getSipAmc url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getSipAmc reponse = $data");

    return data;
  }

  static Future getUserFolio({
    required String bse_nse_mfu_flag,
    required int user_id,
    required String amc,
    required String client_name,
    required String investor_code,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getUserFolio?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&investor_code=$investor_code"
        "&amc_name=$amc&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getUserFolio url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getUserFolio Response = $data");

    return data;
  }

  static Future getSipCategory({
    required String amc_code,
    required String bse_nse_mfu_flag,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getSipCategory?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag&amc_code=$amc_code";

    print("getSipCategory url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getSipCategory reponse = $data");

    return data;
  }

  static Future getSipSchemes({
    required String amc_name,
    required String category,
    required String bse_nse_mfu_flag,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getSipSchemes?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&amc_name=$amc_name&category=$category&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getSipSchemes url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getSipSchemes reponse = $data");

    return data;
  }

  static Future saveCartByUserId({
    required int user_id,
    required String client_name,
    required String purchase_type,
    required String scheme_name,
    required String scheme_reinvest_tag,
    required String folio_no,
    required String amount,
    required String trnx_type,
    required String cart_id,
    required String to_scheme_name,
    required String units,
    required String frequency,
    required String sip_date,
    required String start_date,
    required String end_date,
    required String total_amount,
    required String total_units,
    required String until_cancelled,
    required Map client_code_map,
    required BuildContext context,
    String amount_type = "",
    String nfo_flag = "N",
    String installment = "",
    String sip_tenure = "",
    String to_scheme_reinvest_tag = "",
    String stp_date = "",
    String stp_type = "",
    String stp_installment = '',
    String swp_date = '',
    String sip_first_date = "",
    String sip_second_date = "",
  }) async {
    if (scheme_name.contains("&")) scheme_name = scheme_name.replaceAll("&", "%26");
    if(to_scheme_name.contains("&")) to_scheme_name = to_scheme_name.replaceAll("&", "%26");
    String url =
        "${ApiConfig.apiUrl}/transact/saveCartByUserId?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&cart_id=$cart_id"
        "&purchase_type=$purchase_type&scheme_name=$scheme_name"
        "&scheme_reinvest_tag=$scheme_reinvest_tag&to_scheme_name=$to_scheme_name"
        "&folio_no=$folio_no&amount=$amount&units=$units&frequency=$frequency"
        "&sip_date=$sip_date&start_date=$start_date&end_date=$end_date"
        "&trnx_type=$trnx_type&total_amount=$total_amount"
        "&total_units=$total_units&nfo_flag=$nfo_flag&installment=$installment&"
        "sip_tenure=$sip_tenure&amount_type=$amount_type&to_scheme_reinvest_tag=$to_scheme_reinvest_tag"
        "&stp_date=$stp_date&stp_type=$stp_type&stp_installment=$stp_installment&swp_date=$swp_date"
        "&until_cancel=$until_cancelled &sip_first_date=$sip_first_date&sip_second_date=$sip_second_date";

    client_code_map.forEach((key, value) => url += "&$key=$value");

    print("saveCartByUserId url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);

    print("saveCartByUserId response = $data");
    if (data['status'] == 200) cartCount.value += 1;

    return data;
  }

  static Future getBankInfo({
    required int user_id,
    required String bse_nse_mfu_flag,
    required String investor_code,
    required String client_name,
  }) async {
    String url = "${ApiConfig.apiUrl}/transact/getBankInfo?"
        "key=${ApiConfig.apiKey}&"
        "user_id=$user_id&"
        "client_name=$client_name&"
        "bse_nse_mfu_flag=$bse_nse_mfu_flag&"
        "investor_code=$investor_code";

    print("getBankInfo url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getBankInfo Response = $data");

    return data;
  }

  static Future getLumpsumDividendSchemeoptions({
    required String scheme_name,
    required String bse_nse_mfu_flag,
    required String client_name,
    required int user_id,
  })async{
    scheme_name = Uri.encodeComponent(scheme_name);
    String url = "${ApiConfig.apiUrl}/transact/getLumpsumDividendSchemeoptions?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag&scheme_name=$scheme_name";

    print("getLumpsumDividendSchemeoptions url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getLumpsumDividendSchemeoptions Response = $data");

    return data;

  }

  static Future getSipDividendSchemeoptions({
    required String scheme_name,
    required String bse_nse_mfu_flag,
    required String client_name,
    required int user_id,
  })async{
    scheme_name = Uri.encodeComponent(scheme_name);
    String url = "${ApiConfig.apiUrl}/transact/getSipDividendSchemeoptions?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag&scheme_name=$scheme_name";

    print("getSipDividendSchemeoptions url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getSipDividendSchemeoptions Response = $data");

    return data;

  }

  static Future getSipMinAmount({
    required String scheme_name,
    required String frequency,
    required String amount,
    required String purchase_type,
    required String bse_nse_mfu_flag,
    required String client_name,
    required String dividend_code,
  }) async {
    scheme_name = Uri.encodeComponent(scheme_name);

    String url = "${ApiConfig.apiUrl}/transact/getSipMinAmount?"
        "key=${ApiConfig.apiKey}&"
        "client_name=$client_name&"
        "scheme_name=$scheme_name&"
        "frequency=$frequency&"
        "amount=$amount&"
        "purchase_type=$purchase_type&dividend_code=$dividend_code&"
        "bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getSipMinAmount url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getSipMinAmount Response = $data");

    return data;
  }

  static Future getSipDatesAndFrequency({
    required String scheme,
    required String bse_nse_mfu_flag,
    String nfo_flag = "N",
    required String client_name,
  }) async {
    String url = "${ApiConfig.apiUrl}/transact/getSipDatesAndFrequency?"
        "key=${ApiConfig.apiKey}&"
        "client_name=$client_name&"
        "scheme=$scheme&"
        "bse_nse_mfu_flag=$bse_nse_mfu_flag&"
        "nfo_flag=$nfo_flag";

    print("getSipDatesAndFrequency url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);

    print("getSipDatesAndFrequency Response = $data");

    return data;
  }

  static Future findSipEndDate({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
    required String frequency,
    required String start_date,
    required String sip_type,
    required String install,
  }) async {
    String url = "${ApiConfig.apiUrl}/transact/findSipEndDate?"
        "key=${ApiConfig.apiKey}&"
        "user_id=$user_id&"
        "client_name=$client_name&"
        "bse_nse_mfu_flag=$bse_nse_mfu_flag&"
        "frequency=$frequency&"
        "start_date=$start_date&"
        "sip_type=$sip_type&"
        "install=$install";

    print("findSipEndDate url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);

    print("findSipEndDate Response = $data");

    return data;

  }

  static Future multipleLumpsumPurchase({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
    required String investor_code,
    required String payment_type,
    required String payment_mode,
    required String umrn_code,
    required String bank_account_number,
    required String cheque_no,
    required String cheque_date,
    required String dd_charge,
    required String broker_code,
    required String euin_code,
    required String upi_id,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/v1/multipleLumpsumPurchase?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&"
        "client_name=$client_name&"
        "bse_nse_mfu_flag=$bse_nse_mfu_flag&"
        "investor_code=$investor_code&"
        "payment_type=$payment_type&"
        "payment_mode=$payment_mode&"
        "umrn_code=$umrn_code&"
        "cheque_no=$cheque_no&"
        "cheque_date=$cheque_date&"
        "dd_charge=$dd_charge&"
        "broker_code=$broker_code&"
        "euin_code=$euin_code&"
        "upi_id=$upi_id&"
        "bank_account_number=$bank_account_number";

    print("multipleLumpsumPurchase url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);

    print("multipleLumpsumPurchase Response = $data");

    return data;
  }

  static Future generateBsePaymentGatewayLink({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
    required String investor_code,
    required String broker_code,
    required String order_no,
    required String purchase_type,
   })async{
        String url = "${ApiConfig.apiUrl}/transact/v1/generateBsePaymentGatewayLink?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name"
            "&bse_nse_mfu_flag=$bse_nse_mfu_flag&investor_code=$investor_code&order_no=$order_no&broker_code=$broker_code&purchase_type=$purchase_type";
        print("generateBsePaymentGatewayLink url = $url");

        http.Response response = await http.post(Uri.parse(url));
        Map<String, dynamic> data = jsonDecode(response.body);
        print("generateBsePaymentGatewayLink response = $data");
        return data;
   }

  static Future getCartStatusByUserId({
    required int user_id,
    required String client_name,
    required String paymentId,
    required String purchase_type,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getCartStatusByUserId?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&"
        "client_name=$client_name&"
        "payment_id=$paymentId&"
        "purchase_type=$purchase_type";

    print("getCartStatusByUserId url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);

    print("getCartStatusByUserId Response = $data");

    return data;
  }

  static Future getMandateInfo({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
    required String investor_code,
    required String account_number,
    String mandate_flag = "",
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getMandateInfo?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&"
        "client_name=$client_name&"
        "bse_nse_mfu_flag=$bse_nse_mfu_flag&"
        "investor_code=$investor_code&"
        "account_number=$account_number&mandate_flag=$mandate_flag";

    print("getMandateInfo url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);

    print("getMandateInfo Response = $data");

    return data;
  }

  static Future getNfoLumpsumSchemes({
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getNfoLumpsumSchemes?key=${ApiConfig.apiKey}&"
        "client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getNfoLumpsumSchemes url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);

    print("getNfoLumpsumSchemes Response = $data");

    return data;
  }

  static Future multipleSipPurchase({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
    required String investor_code,
    required String payment_type,
    required String payment_mode,
    required String umrn_code,
    required String bank_account_number,
    required String cheque_no,
    required String cheque_date,
    required String dd_charge,
    required String broker_code,
    required String euin_code,
    required String upi_id,
    required String first_order_flag,
    required String ach_from_date,
    required String ach_to_date,
    required num ach_amount,
    required String ach_mandate_id,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/v1/multipleSipPurchase?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&"
        "bse_nse_mfu_flag=$bse_nse_mfu_flag&investor_code=$investor_code&"
        "payment_type=$payment_type&"
        "payment_mode=$payment_mode&"
        "umrn_code=$umrn_code&"
        "broker_code=$broker_code&euin_code=$euin_code&"
        "bank_account_number=$bank_account_number&cheque_no=$cheque_no&"
        "cheque_date=$cheque_date&dd_charge=$dd_charge&upi_id=$upi_id&"
        "first_order_flag=$first_order_flag&ach_from_date=$ach_from_date&ach_to_date=$ach_to_date&ach_amount=$ach_amount&ach_mandate_id=$ach_mandate_id";

    print("multipleSipPurchase url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("multipleSipPurchase Response = $data");

    return data;
  }

  static Future getNfoSipSchemes({
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getNfoSipSchemes?key=${ApiConfig.apiKey}&"
        "client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getNfoSipSchemes url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getNfoSipSchemes Response = $data");

    return data;
  }

  static Future multipleRedemtion({
    required String bse_nse_mfu_flag,
    required int user_id,
    required String client_name,
    required String bank_account_number,
    required String investor_code,
    required String broker_code,
    required String euin_code,
    required String bank_name,
    required String bank_ifsc_code,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/v1/multipleRedemtion?key=${ApiConfig.apiKey}&"
        "bse_nse_mfu_flag=$bse_nse_mfu_flag&user_id=$user_id&client_name=$client_name&"
        "bank_account_number=$bank_account_number&investor_code=$investor_code&"
        "broker_code=$broker_code&euin_code=$euin_code&bank_name=$bank_name&bank_ifsc_code=$bank_ifsc_code";

    print("multipleRedemtion url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("multipleRedemtion Response = $data");

    return data;
  }

  static Future getRedemtionSchemeHoldingUnits({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
    required String folio_no,
    required String scheme_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/v1/getRedemtionSchemeHoldingUnits?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag&"
        "folio_no=$folio_no&scheme_name=$scheme_name";

    print("getRedemtionSchemeHoldingUnits url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getRedemtionSchemeHoldingUnits Response = $data");

    return data;
  }


  static Future generateBseAuthenticationLink({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
    required String investor_code,
    required String broker_code,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/v1/generateBseAuthenticationLink?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag"
        "&investor_code=$investor_code&broker_code=$broker_code";

    print("generateBseAuthenticationLink url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("generateBseAuthenticationLink Response = $data");

    return data;

  }

  static Future getSipDays({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
    required String frequency,
    required String start_date,

  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getSipDays?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag&frequency=$frequency&start_date=$start_date";

    print("getSipDays url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getSipDays Response = $data");

    return data;

  }

  static Future getBankMandateTypes({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,

  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getBankMandateTypes?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getBankMandateTypes = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getBankMandateTypes = $data");

    return data;

  }

  static Future getBankMandateOptions({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,

  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getBankMandateOptions?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getBankMandateOptions url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getBankMandateOptions Response = $data");

    return data;

  }

  static Future getSwitchToSchemes({
    required String client_name,
    required String bse_nse_mfu_flag,
    required String amc_code,
    required String category,
    required int user_id,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getSwitchToSchemes?key=${ApiConfig.apiKey}&"
        "client_name=$client_name&user_id=$user_id&bse_nse_mfu_flag=$bse_nse_mfu_flag"
        "&category=$category&amc_code=$amc_code";

    print("getSwitchToSchemes url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSwitchToSchemes Response = $data");
    return data;
  }

  static Future multipleSwitch({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
    required String investor_code,
    required String broker_code,
    required String euin_code,
    required String swit_option,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/v1/multipleSwitch?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag&"
        "investor_code=$investor_code&broker_code=$broker_code&"
        "euin_code=$euin_code&swit_option=$swit_option";

    print("multipleSwitch url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("multipleSwitch Response = $data");
    return data;
  }

  static Future addMoreBank({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
    required String investor_code,
    required String ifsc_code,
    required String micr_code,
    required String bank_name,
    required String bank_address,
    required String account_number,
    required String branch_name,
    required String account_holder_name,
    required String account_type,
    required String bank_code,
    required String bank_proof,
    required String process_mode,
    required String broker_code,
    required String euin_code,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/v1/addMoreBank?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id&bse_nse_mfu_flag=$bse_nse_mfu_flag"
        "&investor_code=$investor_code&ifsc_code=$ifsc_code&micr_code=$micr_code&bank_name=$bank_name&bank_address=$bank_address&branch_name=$branch_name"
        "&account_number=$account_number&account_holder_name=$account_holder_name&account_type=$account_type&bank_code=$bank_code&bank_proof=$bank_proof"
        "&process_mode=$process_mode&broker_code=$broker_code&euin_code=$euin_code";

    print("addMoreBank url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("addMoreBank response=$data");
    return data;
  }

  static Future uploadCancelledCheque({
    required int user_id,
    required String client_name,
    required String file_path,
  })async{
    String url = "${ApiConfig.apiUrl}/transact/v1/mfu/uploadCancelledCheque?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id";

    http.MultipartRequest request =
    http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(await http.MultipartFile.fromPath('file', file_path,
        contentType: MediaType('image', 'png')));

    http.StreamedResponse response = await request.send();

    String resString = await response.stream.bytesToString();


    print("uploadCancelledCheque url = $url");

    Map data = jsonDecode(resString);
    print("uploadCancelledCheque response=$data");
    return data;

  }

  static Future sendChequeToMfu({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
    required String image_names,
    required String investor_code
  })async{
      String url = "${ApiConfig.apiUrl}/transact/v1/sendChequeToMfu?key=${ApiConfig.apiKey}&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag&image_names=$image_names&investor_code=$investor_code&user_id=$user_id";
      print("sendChequeToMfu url = $url");
      http.Response response = await http.post(Uri.parse(url));
      Map data = jsonDecode(response.body);
      print("sendChequeToMfu response=$data");
      return data;
  }

  static Future generateBankMandate({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
    required String investor_code,
    required String ach_from_date,
    required String ach_to_date,
    required String amount,
    required String branch_name,
    required String account_number,
    required String account_holder_name,
    required String micr_code,
    required String bank_name,
    required String euin_code,
    required String broker_code,
    required String mandate_option,
    required String mandate_type,
    required String until_cancelled,
    required String account_type,
    required String ifsc_code,
    required String bank_code,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/v1/generateBankMandate?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag&investor_code=$investor_code"
        "&ach_from_date=$ach_from_date&ach_to_date=$ach_to_date&amount=$amount&ifsc_code=$ifsc_code&bank_code=$bank_code&mandate_option=$mandate_option&branch_name=$branch_name&account_number=$account_number&account_holder_name=$account_holder_name"
        "&account_type=$account_type&until_cancelled=$until_cancelled&mandate_type=$mandate_type&broker_code=$broker_code&euin_code=$euin_code&bank_name=$bank_name&micr_code=$micr_code";

    print("generateBankMandate url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("generateBankMandate response=$data");
    return data;
  }

  static Future deleteBankDetails({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
    required String investor_code,
    required String bank_code,
    required String bank_account_number,
    required String bank_account_type,
    required String bank_branch,
    required String bank_ifsc_code,
    required String bank_micr_code,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/deleteBankDetails?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag"
        "&investor_code=$investor_code&bank_code=$bank_code&bank_account_number=$bank_account_number&bank_account_type=$bank_account_type&bank_branch=$bank_branch"
        "&bank_ifsc_code=$bank_ifsc_code&bank_micr_code=$bank_micr_code";
    print("deleteBankDetails url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("deleteBankDetails response = $data");
    return data;
  }

  static Future deleteBankMandate({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
    required String investor_code,
    required String bank_account_number,
    required String umrn_no,
    required String option,
  }) async {
       String url = "${ApiConfig.apiUrl}/transact/deleteBankMandate?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag"
           "&investor_code=$investor_code&bank_account_number=$bank_account_number&umrn_no=$umrn_no&option=$option";

       print("deleteBankMandate url = $url");
       http.Response response = await http.post(Uri.parse(url));
       Map data = jsonDecode(response.body);
       print("deleteBankMandate response = $data");
       return data;
  }

  static Future getStpCategory({
    required String bse_nse_mfu_flag,
    required String client_name,
    required String amc_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getStpCategory?key=${ApiConfig.apiKey}"
        "&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag&amc_name=$amc_name";

    print("getStpCategory url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getStpCategory reponse = $data");

    return data;
  }

  static Future getStpSchemes({
    required String client_name,
    required String bse_nse_mfu_flag,
    required String amc_name,
    required String category,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getStpSchemes?key=${ApiConfig.apiKey}&"
        "client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag"
        "&category=$category&amc_name=$amc_name";

    print("getStpSchemes url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getStpSchemes Response = $data");
    return data;
  }

  static Future getStpMinAmount({
    required int user_id,
    required String scheme_name,
    required String amount,
    required String purchase_type,
    required String amc_code,
    required String client_name,
    required String dividend_code,
  }) async {
    if (scheme_name.contains("&"))
      scheme_name = scheme_name.replaceAll("&", "%26");

    String url = "${ApiConfig.apiUrl}/transact/getStpMinAmount?"
        "key=${ApiConfig.apiKey}&"
        "user_id=$user_id&"
        "client_name=$client_name&"
        "scheme_name=$scheme_name&"
        "amount=$amount&"
        "purchase_type=$purchase_type&"
        "dividend_code=$dividend_code&"
        "amc_code=$amc_code";

    print("getStpMinAmount url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getStpMinAmount Response = $data");

    return data;
  }

  static Future getStpSchemeFrequency({
    required int user_id,
    required String client_name,
    required String amc_name,
    required String scheme_name,
    required String dividend_code,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getStpSchemeFrequency?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&amc_name=$amc_name&"
        "scheme_name=$scheme_name&dividend_code=$dividend_code&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getStpSchemeFrequency url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getStpSchemeFrequency Response = $data");

    return data;
  }

  static Future multipleStp({
    required int user_id,
    required String client_name,
    required String broker_code,
    required String euin_code,
    required String investor_code,
    required String bank_account_number,
    required String bse_nse_mfu_flag,
    required String first_order_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/v1/multipleStp?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name"
        "&broker_code=$broker_code&euin_code=$euin_code&bse_nse_mfu_flag=$bse_nse_mfu_flag"
        "&investor_code=$investor_code&bank_account_number=$bank_account_number&first_order_flag=$first_order_flag";

    print("multipleStp url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("multipleStp Response = $data");
    return data;
  }

  static Future getSwpMinAmount({
    required int user_id,
    required String client_name,
    required String amc_name,
    required String scheme_name,
  }) async {
    if (scheme_name.contains("&"))
      scheme_name = scheme_name.replaceAll("&", "%26");

    String url = "${ApiConfig.apiUrl}/transact/getSwpMinAmount?"
        "key=${ApiConfig.apiKey}&"
        "user_id=$user_id&"
        "client_name=$client_name&"
        "scheme_name=$scheme_name&"
        "amc_name=$amc_name";

    print("getSwpMinAmount url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getSwpMinAmount Response = $data");

    return data;
  }

  static Future getSwpSchemeFrequency({
    required int user_id,
    required String client_name,
    required String amc_name,
    required String scheme_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getSwpSchemeFrequency?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&amc_name=$amc_name&"
        "scheme_name=$scheme_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("getSwpSchemeFrequency url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getSwpSchemeFrequency Response = $data");

    return data;
  }

  static Future multipleSwp({
    required int user_id,
    required String client_name,
    required String broker_code,
    required String euin_code,
    required String investor_code,
    required String bank_account_number,
    required String bse_nse_mfu_flag,
    required String firstOrderFlag,
    required String payment_mode,
    required String payment_type,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/v1/multipleSwp?key=${ApiConfig.apiKey}&"
        "user_id=$user_id&client_name=$client_name"
        "&broker_code=$broker_code&euin_code=$euin_code&bse_nse_mfu_flag=$bse_nse_mfu_flag"
        "&investor_code=$investor_code&bank_account_number=$bank_account_number"
        "&firstOrderFlag=$firstOrderFlag&payment_mode=$payment_mode&payment_type=$payment_type";

    print("multipleSwp url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("multipleSwp Response = $data");
    return data;
  }

  static Future getSipStpSwpCancelSchemes({
    required String client_name,
    required int user_id,
    required String bse_nse_mfu_flag,
    required String sys_option,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getSipStpSwpCancelSchemes?key=${ApiConfig.apiKey}&client_name=$client_name&user_id=$user_id&bse_nse_mfu_flag=$bse_nse_mfu_flag&sys_option=$sys_option";
    print("getSipStpSwpCancelSchemes url $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getSipStpSwpCancelSchemes response = $data");
    return data;
  }

  static Future multipleSystematicCancellation({
    required String client_name,
    required int user_id,
    required String option,
    required String trxn_no,
    required String investor_code,
    required String scheme_name,
    required String folio_no,
    required String scheme_code,
    required String unique_number,
    required String cancel_reason,
    required String other_reason,
    required String bse_nse_mfu_flag,
    String? sip_reg_no = "",
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/multipleSystematicCancellation?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name&option=$option&trxn_no=$trxn_no"
        "&investor_code=$investor_code&sip_reg_no=$sip_reg_no&scheme_name=$scheme_name&folio_no=$folio_no&scheme_code=$scheme_code&unique_number=$unique_number&cancel_reason=$cancel_reason&other_reason=$other_reason&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("multipleSystematicCancellation url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("multipleSystematicCancellation reponse = $data");
    return data;
  }

  static Future getCancelSipReason({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getCancelSipReason?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&bse_nse_mfu_flag=$bse_nse_mfu_flag";

    print("multipleSystematicCancellation url $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("multipleSystematicCancellation reponse = $data");
    return data;
  }

  static Future pauseSip({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
    required String trxn_no,
    required String investor_code,
    required String scheme_name,
    required String folio_no,
    required String scheme_code,
    required String pause_from_date,
    required String pause_to_date,
    required String unique_number,
  }) async {
    String url = "${ApiConfig.apiUrl}/transact/pauseSip?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name"
        "&bse_nse_mfu_flag=$bse_nse_mfu_flag&trxn_no=$trxn_no"
        "&investor_code=$investor_code&scheme_name=$scheme_name"
        "&folio_no=$folio_no&scheme_code=$scheme_code&pause_from_date=$pause_from_date"
        "&pause_to_date=$pause_to_date&unique_number=$unique_number";

    print("pauseSip url $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("pauseSip reponse = $data");
    return data;
  }

  static bseSipPause({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
    required String sip_reg_no,
    required String amount,
    required String start_date,
    required String frequency,
    required String firstOrderFlag,
    required String mandate_id,
    required String no_of_install,
    required String no_of_install_pause,
    required String investor_code,
  }) async {
    String url = "${ApiConfig.apiUrl}/transact/pauseSip?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name"
        "&bse_nse_mfu_flag=$bse_nse_mfu_flag&sip_reg_no=$sip_reg_no&amount=$amount&start_date=$start_date&frequency=$frequency"
        "&firstOrderFlag=$firstOrderFlag&mandate_id=$mandate_id&no_of_install=$no_of_install&no_of_install_pause=$no_of_install_pause&investor_code=$investor_code";

    print("pauseSip url $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("pauseSip reponse = $data");
    return data;
  }
}
