import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/Investor/MutualFundScreen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class PushNotification {
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future init(String app_id) async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(app_id);
    await OneSignal.Notifications.requestPermission(true);
    OneSignal.Notifications.addClickListener((event) {
      Map? actions = event.notification.additionalData;
      print("additionalData = $actions");
      print("body = ${event.notification.body}");
      print("category = ${event.notification.category}");
      print("collapseId = ${event.notification.collapseId}");
      print("actionId = ${event.result.actionId}");
      if (actions != null) {
        String page = actions['page'];

        if (page == 'MFPortfolio') Get.to(() => MutualFundScreen());
      }
    });
  }

  static Future getSubsId() async {
    String subsId = await OneSignal.User.getOnesignalId() ?? "";
    return subsId;
  }
}
