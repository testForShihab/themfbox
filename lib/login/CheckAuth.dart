import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/login/Biometric.dart';
import 'package:mymfbox2_0/login/Login.dart';
import 'package:mymfbox2_0/utils/Constants.dart';

class CheckAuth extends StatefulWidget {
  const CheckAuth({super.key});

  @override
  State<CheckAuth> createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool? isLoggedIn;
  late Timer timer;

  @override
  void initState() {
    //  implement initState
    super.initState();

    isLoggedIn = GetStorage().read("isLoggedIn") ?? false;
  }

  void initTimer() {
    timer = Timer.periodic(Duration(minutes: APP_TIMEOUT), (timer) {
      print("timer ------>");
      print("timer after1 mins $APP_TIMEOUT min");
      int diff = checkLastAccessTime();
      if (diff >= APP_TIMEOUT) logOutUser();
    });
  }

  logOutUser() {
    Get.offAll(() => Biometric());
    timer.cancel();
  }

  int checkLastAccessTime() {
    //logic 6
    // DateTime dt = GetStorage().read("temp");
    // str = str ?? parse(dt);

    String? str = GetStorage().read("lastAccessTime");
    str = str ?? DateTime.now().toString();

    DateTime lastAccessTime = DateTime.parse(str);
    DateTime now = DateTime.now();
    Duration diff = now.difference(lastAccessTime);
    print("lastAccessTime = $lastAccessTime");
    print("diff.inMinutes = ${diff.inMinutes}");
    return diff.inMinutes;
  }

  resetTimer() async {
    await GetStorage().write("lastAccessTime", DateTime.now().toString());
    timer.cancel();
    initTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == true) {
      return Biometric();
    } else
      return Login();
  }
}
