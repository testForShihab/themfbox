// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mymfbox2_0/login/CheckUserType.dart';
import 'package:mymfbox2_0/login/Login.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';

import '../utils/Utils.dart';

class Biometric extends StatefulWidget {
  const Biometric({super.key});
  @override
  State<Biometric> createState() => _BiometricState();
}

class _BiometricState extends State<Biometric> {
  int? type_id = GetStorage().read('type_id');
  String name = "";
  int? adminAsInvestor = GetStorage().read('adminAsInvestor');
  int? adminAsFamily = GetStorage().read('adminAsFamily');
  bool isLocalAuthDone = GetStorage().read('isLocalAuthDone') ?? false;

  late double devHeight, devWidth;
  final LocalAuthentication auth = LocalAuthentication();

  String getName() {
    if (type_id == UserType.ADMIN) return GetStorage().read('mfd_name') ?? "";
    if (type_id == UserType.INVESTOR)
      return GetStorage().read('user_name') ?? "";
    if (type_id == UserType.FAMILY)
      return GetStorage().read('family_name') ?? "";
    return "";
  }

  Future authenticate() async {
    bool authSuccess = false;

    bool isDeviceSupported = await auth.isDeviceSupported();

    if(!isDeviceSupported) return true;

    bool canCheckBiometrics = await auth.canCheckBiometrics;
    List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
    bool useBiometricsAuth = availableBiometrics.isNotEmpty ? true : false;
    print("canCheckBiometrics = $canCheckBiometrics");
    print("availableBiometrics = $availableBiometrics");
    for (var biometric in availableBiometrics) {
      print("biometric = $biometric");
    }
    print("useBiometricsAuth = $useBiometricsAuth");


    try {

      if(useBiometricsAuth){
        authSuccess = await auth.authenticate(
          localizedReason: 'Please authenticate to continue',
          options: const AuthenticationOptions(
            stickyAuth: false,
            biometricOnly: true, // This forces biometric authentication when available
            useErrorDialogs: true,
          ),
        );
      } else {
        authSuccess = await auth.authenticate(
          localizedReason: 'Please authenticate to continue',
          options: const AuthenticationOptions(
            stickyAuth: false,
            biometricOnly: false, // This forces biometric authentication when available
            useErrorDialogs: true,
          ),
        );
      }


    } catch (e) {
      PlatformException pe = e as PlatformException;
      if (pe.code == "auth_in_progress") await auth.stopAuthentication();
      print("lock exception = $e");
    }
    return authSuccess;
  }

  // Future attempt4() async {
  //   bool authSuccess = false;
  //   try {
  //     authSuccess = await auth.authenticate(
  //         localizedReason: "Unlock your device",
  //         options: AuthenticationOptions(stickyAuth: false));
  //   } catch (e) {
  //     PlatformException pe = e as PlatformException;
  //     if (pe.code == "auth_in_progress") await auth.stopAuthentication();
  //     print("lock exception = $e");
  //   }
  //   return authSuccess;
  // }

  @override
  void initState() {
    //  implement initState
    super.initState();
    name = getName();
    Future.delayed(Duration.zero, () async {
      bool authResult = await authenticate();
      if (authResult) {
        Get.offAll(() => CheckUserType());
      }
    });
  }

  @override
  void dispose() {
    //  implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    String clientName = Config.app_client_name;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        height: devHeight,
        width: devWidth,
        decoration: BoxDecoration(
          image: (Config.app_client_name == "vbuildwealth"|| Config.app_client_name == "perpetualinvestments")
              ? DecorationImage(
                  image: AssetImage("assets/orange-bg.png"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Config.appTheme.themeColor, BlendMode.color))
              :(Config.app_client_name == "themfbox") ? DecorationImage(
              image: AssetImage("assets/green-bg.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Config.appTheme.themeColor , BlendMode.color)): DecorationImage(
              image: AssetImage("assets/white-bg.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Config.appTheme.overlay85 , BlendMode.color)),
        ),
        child: Column(
          children: [
            SizedBox(height: devHeight * 0.1),
            clientName == "ajfunds"
                ? Container(
                    height: setImageSize(80),
                    width: setImageSize(80),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: (Config.appLogo.contains("http"))
                          ? Image.network(
                              Config.appLogo,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              Config.appLogo,
                              fit: BoxFit.cover,
                            ),
                    ),
                  )
                : Container(
                    color: logobgcolor,
                    padding: EdgeInsets.all(2),
                    child: (Config.appLogo.contains("http"))
                        ? Image.network(Config.appLogo,
                            height: setImageSize(60))
                        : (Config.app_client_name == "themfbox") ? Image.asset(Config.appLogo)
                        : Image.asset(Config.appLogo,width:setImageSize(400))),
            SizedBox(height: devHeight * 0.06),
            Text(name,
                style: TextStyle(
                    color: (Config.app_client_name == "themfbox") ? Colors.white : Config.appTheme.themeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            SizedBox(height: devHeight * 0.01),
            Text("Unlock your device", style: TextStyle(color: (Config.app_client_name == "themfbox") ? Colors.white : Config.appTheme.themeColor)),
            SizedBox(height: devHeight * 0.05),
            Expanded(
              child: Container(
                width: devWidth,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    SizedBox(height: devHeight * 0.02),
                    SizedBox(height: devHeight * 0.03),
                    SizedBox(
                      width: devWidth,
                      height: 55,
                      child: TextButton(
                        onPressed: () async {
                          bool authResult = await authenticate();
                          if (authResult) Get.offAll(() => CheckUserType());
                        },
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), //
                            ),
                            padding: EdgeInsets.symmetric(vertical: 18),
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.fingerprint),
                            Text("Unlock your device",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: devHeight * 0.05),
                    InkWell(
                      onTap: () {
                        GetStorage().erase();
                        Get.offAll(() => Login());
                      },
                      child: Text(
                        "Logout",
                        style: TextStyle(
                            fontSize: 16,
                            color: Config.appTheme.themeColor,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
