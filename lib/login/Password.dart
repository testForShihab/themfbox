import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
//import 'package:matomo_tracker/matomo_tracker.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/login/CheckAuth.dart';
import 'package:mymfbox2_0/login/ForgotPassword.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:mymfbox2_0/rp_widgets/RpTextField.dart';

import '../api/ApiConfig.dart';
import '../utils/Constants.dart';
//import 'package:onesignal_flutter/onesignal_flutter.dart';

class Password extends StatefulWidget {
  const Password({super.key, required this.mobile});
  final String mobile;
  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {

/*  with TraceableClientMixin @override
  String get actionName => Config.app_client_name + " Password Page"; // optional

  @override
  String get path => '/password';*/

  late double devHeight, devWidth;
  FocusNode focusNode = FocusNode();
  Color borderColor = Colors.grey;
  String password = "";
  bool isVisible = false;
  bool hasError = false;
  String mobile_pan = " ";
  RxBool isLoading = false.obs;

  @override
  void initState() {
    //  implement initState
    super.initState();
    mobile_pan = widget.mobile;
    focusNode.addListener(() {
      setState(() {
        borderColor =
            (focusNode.hasFocus) ? Config.appTheme.themeColor : Colors.grey;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    String clientName = Config.app_client_name;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: devHeight,
          width: devWidth,
          decoration: BoxDecoration(
            image: (Config.app_client_name == "vbuildwealth" ||
                    Config.app_client_name == "perpetualinvestments")
                ? DecorationImage(
                    image: AssetImage("assets/orange-bg.png"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Config.appTheme.themeColor, BlendMode.color))
                : (Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32")
                    ? DecorationImage(
                      image: AssetImage("assets/green-bg.png"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Config.appTheme.themeColor, BlendMode.color)) :
                    DecorationImage(
                        image: AssetImage("assets/white-bg.png"),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Config.appTheme.overlay85, BlendMode.color)),
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
                              height: setImageSize(100))
                          : (Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32")
                              ? Image.asset(Config.appLogo) : Image.asset(Config.appLogo,
                                  width: setImageSize(350)),
                    ),
              SizedBox(height: devHeight * 0.06),
              Text("Login",
                  style: TextStyle(
                      color: (Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32")
                          ? Colors.white
                          : Config.appTheme.themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
              SizedBox(height: devHeight * 0.01),
              Text("Welcome Back",
                  style: TextStyle(
                      color: (Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32")
                          ? Colors.white
                          : Config.appTheme.themeColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 18)),
              SizedBox(height: devHeight * 0.04),
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
                      RpTextField(
                          focusNode: focusNode,
                          obscureText: !isVisible,
                          borderColor: borderColor,
                          maxLines: 1,
                          onChange: (val) => password = val,
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              icon: (isVisible)
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off)),
                          label: "Password"),
                      Visibility(
                        visible: hasError,
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Text("Please Enter Password",
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      continueBtn(),
                      SizedBox(height: devHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              Get.to(() => ForgotPassword(mobile: mobile_pan,));
                            },
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  color: Config.appTheme.themeColor),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      /*Visibility(
                        visible: kDebugMode,
                        child: ElevatedButton(
                            onPressed: () async {
                              // password = "target@1000";
                              password = "123456";
                              await login();
                              print("password $password");
                            },
                            child: Text("Easy Pass")),
                      ),*/
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget continueBtn() {
    return Obx(() {
      return SizedBox(
        width: devWidth,
        child: TextButton(
          onPressed: () async {
            if (password.length < 6) {
              Utils.showError(context, "Password must be atleast 6 characters");
              return;
            }
            password = Uri.encodeComponent(password);

            await login();
          },
          style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // <-- Radius
              ),
              backgroundColor: Config.appTheme.universalTitle,
              foregroundColor: Colors.white),
          child: (isLoading.value)
              ? SpinKitThreeBounce(color: Colors.white, size: 22)
              : Text("Continue",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      );
    });
  }

  Future login() async {
    if (password.isEmpty) {
      hasError = true;
      setState(() {});
      return;
    }
    // EasyLoading.show();
    isLoading.value = true;
    Map data = await Api.login(mobile: widget.mobile, password: password);
    isLoading.value = false;
    // EasyLoading.dismiss();

    if (data['status'] == 200) {
      await writeDataLocally(data);
      // int type_id = GetStorage().read('type_id');
      // if (type_id == 5 || type_id == 2 || type_id == 4 || type_id == 7)
      //   Get.offAll(() => AdminDashboard());
      // if (type_id == 1) Get.offAll(() => InvestorDashboard());
      // if (type_id == 3) Get.offAll(() => FamilyDashboard());



      Get.offAll(() => CheckAuth());
    } else {
      Utils.showError(context, data['msg']);
    }
  }

  Future writeDataLocally(Map data) async {
    Map<String, dynamic> user = data['user'];
    int type_id = user['type_id'];

/*    int userId = user['user_id'];
    MatomoTracker.instance.setVisitorUserId(userId.toString());*/

    await GetStorage().write("isLoggedIn", true);
    await GetStorage().write("type_id", type_id);
    await GetStorage().write('client_name', user['client_name']);
    Config.app_client_name = user['client_name'];

    if (type_id == 9) {
      await GetStorage().write("sAdmin_id", user['user_id']);
      await GetStorage().write("sAdmin_name", user['name']);
      await GetStorage().write("sAdmin_pan", user['pan']);
      await GetStorage().write("sAdmin_mobile", user['mobile']);
    } else if (type_id != 1 && type_id != 3) {
      await GetStorage().write("mfd_id", user['user_id']);
      await GetStorage().write("mfd_name", user['name']);
      await GetStorage().write("mfd_pan", user['pan']);
      await GetStorage().write("mfd_mobile", user['mobile']);
    } else if (type_id == 1) {
      await GetStorage().write("user_id", user['user_id']);
      await GetStorage().write("user_name", user['name']);
    } else if (type_id == 3) {
      await GetStorage().write("family_id", user['user_id']);
      await GetStorage().write("family_name", user['name']);
    }
    await commonDatas(user);
  }

  Future commonDatas(Map user) async {
    await GetStorage().write("user_pan", user['pan']);
    await GetStorage().write("user_mobile", user['mobile']);
    await GetStorage().write("user_email", user['email']);
  }
}
