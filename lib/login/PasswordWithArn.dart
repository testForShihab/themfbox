import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/login/CheckAuth.dart';
import 'package:mymfbox2_0/login/ForgotPassword.dart';
import 'package:mymfbox2_0/rp_widgets/RpTextField.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../api/ApiConfig.dart';
import '../utils/Constants.dart';

class PasswordWithArn extends StatefulWidget {
  const PasswordWithArn({super.key, required this.mobile});
  final String mobile;
  @override
  State<PasswordWithArn> createState() => _PasswordWithArnState();
}

class _PasswordWithArnState extends State<PasswordWithArn> {
  late double devHeight, devWidth;
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  Color borderColor1 = Colors.grey;
  Color borderColor2 = Colors.grey;
  String password = "", arn = "";
  bool isVisible = false;
  bool hasError = false;
  String mobile_pan = '';

  @override
  void initState() {
    //  implement initState
    super.initState();
    mobile_pan = widget.mobile;
    focusNode1.addListener(() {
      setState(() {
        borderColor1 =
            (focusNode1.hasFocus) ? Config.appTheme.themeColor : Colors.grey;
      });
    });
    focusNode2.addListener(() {
      setState(() {
        borderColor2 =
            (focusNode1.hasFocus) ? Config.appTheme.themeColor : Colors.grey;
      });
    });
  }

  @override
  void dispose() {
    //  implement dispose
    focusNode1.dispose();
    focusNode2.dispose();
    super.dispose();
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
            image: (Config.app_client_name == "vbuildwealth"|| Config.app_client_name == "perpetualinvestments")
                ? DecorationImage(
                    image: AssetImage("assets/orange-bg.png"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Config.appTheme.themeColor, BlendMode.color))
                : (Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32") ? DecorationImage(
                image: AssetImage("assets/green-bg.png"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Config.appTheme.themeColor, BlendMode.color))
                : DecorationImage(
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
                padding: EdgeInsets.all(4),
                child: (Config.appLogo.contains("http"))
                    ? Image.network(Config.appLogo, height: setImageSize(100))
                    : (Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32") ?Image.asset(Config.appLogo)
                    : Image.asset(Config.appLogo,width:setImageSize(350)),
              ),
              SizedBox(height: devHeight * 0.06),
              Text("Login",
                  style: TextStyle(
                      color: (Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32") ? Colors.white : Config.appTheme.themeColor ,
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
              SizedBox(height: devHeight * 0.01),
              Text("Welcome Back",
                  style: TextStyle(
                      color: (Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32") ? Colors.white : Config.appTheme.themeColor,
                      fontWeight: FontWeight.w500,fontSize: 18)),
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
                          focusNode: focusNode1,
                          obscureText: !isVisible,
                          borderColor: borderColor1,
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
                      SizedBox(height: devHeight * 0.03),
                      RpTextField(
                          focusNode: focusNode2,
                          borderColor: borderColor2,
                          inputType: TextInputType.number,
                          onChange: (val) => arn = val,
                          label: "ARN Number"),
                      SizedBox(height: devHeight * 0.03),
                      continueBtn(),
                      SizedBox(height: devHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(ForgotPassword(mobile: mobile_pan,));
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
                      )
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
    return SizedBox(
      width: devWidth,
      child: TextButton(
        onPressed: () async {
          if(password.isEmpty){
            Utils.showError(context, "Please enter your password");
            return;
          }

          if(arn.isEmpty){
            Utils.showError(context, "Please enter ARN number");
            return;
          }
          print("password $password");
          password = Uri.encodeComponent(password);
          print("password ${Uri.encodeComponent(password)}");

          await login();
        },
        style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // <-- Radius
            ),
            backgroundColor: Config.appTheme.universalTitle,
            foregroundColor: Colors.white),
        child: Text("Login",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Future login() async {
    if (password.isEmpty) {
      hasError = true;
      setState(() {});
      return;
    }
    EasyLoading.show();
    Map data = await Api.login(
        mobile: widget.mobile, password: password, broker_code: arn);
    EasyLoading.dismiss();

    if (data['status'] == 200) {
      await writeDataLocally(data);
      // int type_id = GetStorage().read('type_id');
      // if (type_id == 5 || type_id == 2) Get.offAll(() => AdminDashboard());
      // if (type_id == 1) Get.offAll(() => InvestorDashboard());
      // if (type_id == 3) Get.offAll(() => FamilyDashboard());

      Get.to(() => CheckAuth());
    } else {
      Utils.showError(context, data['msg']);
    }
  }

  Future writeDataLocally(Map data) async {
    Map<String, dynamic> user = data['user'];
    int type_id = user['type_id'];

    await GetStorage().write("isLoggedIn", true);
    await GetStorage().write("type_id", type_id);
    await GetStorage().write('client_name', user['client_name']);
    Config.app_client_name = user['client_name'];
    //OneSignal.login("${user['user_id']}");

    if (type_id != 1 && type_id != 3) {
      await GetStorage().write("mfd_id", user['user_id']);
      await GetStorage().write("mfd_name", user['name']);
      await GetStorage().write("mfd_pan", user['pan']);
      await GetStorage().write("mfd_mobile", user['mobile']);
    } else if (type_id == 1) {
      await GetStorage().write("user_id", user['user_id']);
      await GetStorage().write("user_name", user['name']);
      await GetStorage().write("user_email", user['email']);

      await commonDatas(user);
    } else if (type_id == 3) {
      await GetStorage().write("family_id", user['user_id']);
      await GetStorage().write("family_name", user['name']);

      await commonDatas(user);
    }
  }

  Future commonDatas(Map user) async {
    await GetStorage().write("user_pan", user['pan']);
    await GetStorage().write("user_mobile", user['mobile']);
    await GetStorage().write("user_email", user['email']);
  }
}
