import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mymfbox2_0/api/ApiConfig.dart';

class OneSignalApi {
  static Future getAppId({required String client_name}) async {
    String url =
        "${ApiConfig.apiUrl}/onesignal/getAppId?key=${ApiConfig.apiKey}&client_name=$client_name";

    print("getAppId url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("getAppId response = $data");

    return data;
  }

  static Future saveUserSubscriptionId({
    required int user_id,
    required String client_name,
    required String one_signal_subs_id,
    required String model,
    required String brand,
    required String mobile_os,
  }) async {
    String url =
        "${ApiConfig.apiUrl}/onesignal/saveUserSubscriptionId?key=${ApiConfig.apiKey}&client_name=$client_name"
        "&user_id=$user_id&one_signal_subscription_id=$one_signal_subs_id&model=$model&brand=$brand&mobile_os=$mobile_os";

    print("saveUserSubscriptionId url = $url");
    http.Response response = await http.post(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print("saveUserSubscriptionId response = $data");

    return data;
  }
}
