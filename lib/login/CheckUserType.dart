import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/OneSignalApi.dart';
import 'package:mymfbox2_0/family/FamilyDashboard.dart';
import 'package:mymfbox2_0/Investor/InvestorDashboard.dart';
import 'package:mymfbox2_0/advisor/dashboard/AdminDashboard.dart';
import 'package:mymfbox2_0/login/Login.dart';
import 'package:mymfbox2_0/rp_widgets/ClosedSidebar.dart';
import 'package:mymfbox2_0/rp_widgets/OpenSideBar.dart';
import 'package:mymfbox2_0/superadmin/SuperAdminDashboard.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/PushNotifications.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class CheckUserType extends StatefulWidget {
  const CheckUserType({super.key});

  @override
  State<CheckUserType> createState() => _CheckUserTypeState();
}

class _CheckUserTypeState extends State<CheckUserType> {
  int type_id = 0;
  int? adminAsInvestor, adminAsFamily;
  bool superAdminAsAdmin = GetStorage().read("superAdminAsAdmin") ?? false;
  @override
  void initState() {
    //  implement initState
    super.initState();
    type_id = GetStorage().read("type_id") ?? 0;
    print("type_id in CheckUserType = $type_id");
    adminAsInvestor = GetStorage().read("adminAsInvestor");
    adminAsFamily = GetStorage().read("adminAsFamily");

    if (type_id == UserType.INVESTOR || type_id == UserType.FAMILY)
      Future.delayed(Duration.zero, () async {
        int res = await initializeOneSignal();
        print("OneSignal Init Status = $res");
        if (res == 0) {
          int res2 = await saveUserSubscriptionId();
          print("OneSignal saveUserSubscriptionId Status = $res2");
        }
      });
  }

  Future initializeOneSignal() async {
    String client_name = GetStorage().read("client_name") ?? "";
    if (client_name.isEmpty) return -1;

    Map data = await OneSignalApi.getAppId(client_name: client_name);
    if (data['status'] != 200) return -2;

    String appId = data['one_signal_app_id'] ?? "";
    if (appId.isEmpty) return -3;

    await PushNotification.init(appId);

    return 0;
  }

  Future saveUserSubscriptionId() async {
    int user_id = getUserId();
    String client_name = GetStorage().read("client_name") ?? "";
    if (user_id.isNegative) return -1;
    if (client_name.isEmpty) return -2;
    String subsId = await PushNotification.getSubsId();
    if (subsId.isEmpty) return -3;

    String os = Platform.isAndroid ? "android" : "ios";

    String model = "", brand = "";
    if (os == "android") {
      AndroidDeviceInfo android = await DeviceInfoPlugin().androidInfo;
      model = android.model;
      brand = android.brand;
    } else {
      IosDeviceInfo ios = await DeviceInfoPlugin().iosInfo;
      model = ios.model;
      brand = "Apple";
    }

    Map data = await OneSignalApi.saveUserSubscriptionId(
      user_id: user_id,
      client_name: client_name,
      one_signal_subs_id: subsId,
      mobile_os: os,
      model: model,
      brand: brand,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -4;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SideBarController());
    if (type_id == UserType.INVESTOR) return InvestorDashboard();
    if (hasAdminAccess) {
      if (adminAsInvestor != null) return InvestorDashboard();
      if (adminAsFamily != null) return FamilyDashboard();
      return AdminDashboard();
    }
    if (type_id == 3) return FamilyDashboard();
    if (type_id == 9) {
      if (adminAsInvestor != null) return InvestorDashboard();
      if (adminAsFamily != null) return FamilyDashboard();
      if (superAdminAsAdmin) return AdminDashboard();

      return SuperAdminDashboard();
    }

    return Login();
  }

  bool get hasAdminAccess {
    List allowedList = [
      UserType.ADMIN,
      UserType.RM,
      UserType.ASSOCIATE,
      UserType.BRANCH
    ];

    return allowedList.contains(type_id);
  }
}

class SideBarController extends GetxController {
  RxBool isAdminOpen = false.obs;

  void toggleAdminOpen() {
    isAdminOpen.value = !isAdminOpen.value;
  }
}

class AdminSideBar extends StatelessWidget {
  const AdminSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final SideBarController controller = Get.find();

    return (controller.isAdminOpen.value)
        ? OpenSideBar(
            name: "name",
            onClose: () => controller.toggleAdminOpen(),
          )
        : ClosedSideBar(
            name: "name",
            onTap: () => controller.toggleAdminOpen(),
          );
  }
}
