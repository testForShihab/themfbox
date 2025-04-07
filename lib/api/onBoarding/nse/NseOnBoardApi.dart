import 'dart:convert';

import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:http/http.dart' as http;

class NseOnBoardApi {
  static Future getCountryList({
    required int user_id,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/common/getCountryList?user_id=$user_id&client_name=$client_name&key=${ApiConfig.apiKey}";

    print("getCountryList url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getCountryList Response = $data");

    return data;
  }

  static Future getMyOrders({
    required int user_id,
    required String client_name,
    required String bse_nse_mfu_flag,
     required String investor_code
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/getMyOrders?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name"
        "&bse_nse_mfu_flag=$bse_nse_mfu_flag&investor_code=$investor_code";


    print("getMyOrdersNse url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getMyOrdersNse Response = $data");

    return data;
  }

  static Future getMyOrdersBse({
    required int user_id,
    required String client_name,
    required int investor_id,

  }) async {
    String url =
        "${ApiConfig.apiUrl}/bse/transaction/getMyOrders?key=${ApiConfig.apiKey}&user_id=$user_id"
        "&client_name=$client_name&investor_id=$investor_id";

    print("getMyOrdersBse url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getMyOrdersBse Response = $data");

    return data;
  }

  static Future getMyOrdersTransaction({
    required int user_id,
    required String client_name,
    required int investor_id,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/mfu/transaction/getMyOrders?key=${ApiConfig.apiKey}&user_id=$user_id"
        "&client_name=$client_name&investor_id=$investor_id";

    print("getMyOrdersTransaction url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getMyOrdersTransaction Response = $data");

    return data;
  }

  static Future getNseUserDetailsByIINNumberAndBrokerCode({
    required int investor_id,
    required String client_name,
    required String iin_no,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/nse/onboard/getNseUserDetailsByIINNumberAndBrokerCode?key=${ApiConfig.apiKey}"
        "&investor_id=$investor_id&client_name=$client_name&iin_no=$iin_no";

    print("getNseUserDetailsByIINNumberAndBrokerCode url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getNseUserDetailsByIINNumberAndBrokerCode Response = $data");

    return data;
  }

  static Future saveJointHolderInfo({
    required int user_id,
    required String client_name,
    required int investor_id,
    required String bse_nse_mfu_flag,
    required List<String> joint_holder_details,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onboard/saveJointHolderInfo?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name&investor_id=$investor_id&bse_nse_mfu_flag=$bse_nse_mfu_flag&joint_holder_details=$joint_holder_details";

    print("saveJointHolderInfo url= $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("saveJointHolderInfo Response = $data");

    return data;
  }
}
