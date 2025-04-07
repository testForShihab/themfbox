import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mymfbox2_0/api/ApiConfig.dart';

class GoalsApi {
  static Future getGoalSuggestedSchemes({
    required num sip_amount,
    required String risk,
    required String years,
    required String mobile,
    required String age,
    required String client_name,
  }) async {
    String url =
        "https://mfportfolio.in/api/getGoalSuggestedSchemes?key=${ApiConfig.apiKey}"
        "&sip_amount=$sip_amount&risk=$risk&years=$years&mobile=$mobile"
        "&age=$age&client_name=$client_name";

    print("getGoalSuggestedSchemes url = $url");

    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);

    print("getGoalSuggestedSchemes response = $data");

    return data;
  }

  static Future saveSipCartByUserId({
    required Map client_code_map,
    required int user_id,
    required Map body,
    required String client_name,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/transact/saveSipCartByUserId?key=${ApiConfig.apiKey}"
        "&user_id=$user_id&client_name=$client_name";

    client_code_map.forEach((key, value) => url += "&$key=$value");
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    print("saveSipCartByUserId url = $url");
    print("saveSipCartByUserId body = ${jsonEncode(body)}");

    http.Response response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: headers);
    Map data = jsonDecode(response.body);

    print("saveSipCartByUserId response = $data");

    return data;
  }
}
