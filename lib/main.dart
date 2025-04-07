import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mymfbox2_0/advisor/dashboard/AdminDashboard.dart';
import 'package:mymfbox2_0/utils/Config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  configEasyLoading();
  runApp(const MyApp());
}

configEasyLoading() {}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    //  implement initState
    GestureBinding.instance.pointerRouter.addGlobalRoute((event) {
      print("globalTap called = $event");
    });
    print("global init state called");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Config.appTheme.themeColor,
          textTheme: GoogleFonts.spaceGroteskTextTheme()),
      home: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            print("onTap called");
          },
          onScaleStart: (e) {
            print("onTap called scale");
          },
          child: AdminDashboard()),
      builder: (w, c) {
        EasyLoading.instance
          ..indicatorType = EasyLoadingIndicatorType.ring
          ..loadingStyle = EasyLoadingStyle.custom
          ..indicatorSize = 35.0
          ..radius = 10.0
          ..progressColor = Config.appTheme.themeColor
          ..backgroundColor = Colors.white
          ..indicatorColor = Config.appTheme.themeColor
          ..textColor = Config.appTheme.themeColor
          ..maskColor = Colors.black.withOpacity(0.25)
          ..userInteractions = true
          ..maskType = EasyLoadingMaskType.custom
          ..dismissOnTap = true;
        return FlutterEasyLoading(child: c);
      },
    );
  }
}
