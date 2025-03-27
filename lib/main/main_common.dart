import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/login/CheckAuth.dart';
import 'package:mymfbox2_0/redux/AppState.dart';
import 'package:mymfbox2_0/redux/CartCountPojo.dart';
import 'package:mymfbox2_0/redux/Reducers.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import '../FlavorConfig.dart';

var flavorConfigProvider;

void mainCommon(FlavorConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  flavorConfigProvider = StateProvider((ref) => config);

  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  Config.app_title = config.appTitle;
  Config.app_client_name = config.appClientName;
  Config.appLogo = config.appLogo;

  print("----------------");
  print(Config.app_client_name);
  print("-----------------");

  Config.appArn = config.appArn;
  ApiConfig.apiKey = config.apiKey;

  Config.supportEmail = config.supportEmail;
  Config.supportMobile = config.supportMobile;

  Config.privacyPolicy = config.privacyPolicy;
  Config.pdfURL = config.pdfURL;
  Config.appTheme = config.appTheme;
  Config.appLogo = config.appLogo;
  Config.address1 = config.address1;
  Config.address2 = config.address2;
  Config.pincode = config.pincode;
  Config.companyName = config.companyName;
  Config.city = config.city;
  Config.state = config.state;
  Config.website = config.website;

  print("Config.app_title = ${Config.app_title}");
  print(Config.app_client_name);
  print(Config.appArn);
  print(Config.appLogo);
  print(Config.app_icon);
  print(Config.appbar_logo_size);
  print(ApiConfig.apiKey);

  print("App Theme = ${config.appTheme}");

  configEasyLoading();

  runApp(
    ProviderScope(
      child: Splash(),
    ),
  );
}

/*void main() async {
  runApp(Splash());
}*/

void configEasyLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 35.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Config.appTheme.themeColor
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.black.withOpacity(0.10)
    ..userInteractions = true
    ..maskType = EasyLoadingMaskType.custom
    ..dismissOnTap = true;
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  final navigatorKey = GlobalKey<NavigatorState>();

  // static void navToStartPage() {
  //   //GetStorage().erase();

  //   Get.offAll(() => Login());
  // }

  late Timer timer;

  @override
  void initState() {
    super.initState();
    initLocalAuth();
    removeStorage('adminAsInvestor');
    removeStorage('adminAsFamily');
    removeStorage('familyAsInvestor');
  }

  initLocalAuth() async {
    await GetStorage().write('isLocalAuthDone', false);
  }

  removeStorage(String key) {
    if (GetStorage().read(key) != null) GetStorage().remove(key);
  }

  @override
  void dispose() {
    //  implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // navigatorObservers: [rpGetObserver],
      builder: EasyLoading.init(
        builder: (context, child) {
          initScaleFactor();
          return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(Utils.getTextScaler)),
              child: child!);
        },
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorSchemeSeed: Config.appTheme.themeColor,
        fontFamily: 'SpaceGrotesk',
        useMaterial3: true,
      ),
      home: CheckAuth(),
    );
  }

  initScaleFactor() {
    double devWidth = MediaQuery.sizeOf(context).width;
    if (devWidth < 400) {
      Utils.getTextScaler = 0.85;
      Utils.getImageScaler = 0.85;
      Utils.isSmallDevice = true;
    }
  }
}

// class RpGetObserver extends GetObserver {
//   String client_name = GetStorage().read("client_name") ?? "null";

//   @override
//   void didPush(Route route, Route? previousRoute) {
//     //  implement didPush
//     super.didPush(route, previousRoute);
//     String routeName = route.settings.name ?? "";
//     print("page pushed = $routeName");
//     int user_id = getUserId();

//     Api.writeNavigationLog(
//         user_id: user_id, client_name: client_name, routeName: routeName);
//   }
// }

//SELECT company_name,client_name,broker_code,logo,api_key,mail_support_email,company_phone FROM mfportfolio.bse_nse_key;
