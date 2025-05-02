import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/login/Login.dart';
import 'package:mymfbox2_0/rp_widgets/RpTextField.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../api/ApiConfig.dart';
import '../utils/Constants.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({
    super.key,
    required this.mobile_number,
    required this.broker_code,
  });

  final String mobile_number;
  final String broker_code;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late double devHeight, devWidth;
  List<FocusNode> focusNode = [];
  List<Color> borderColor = [];
  String password = "", confirmPassword = "";
  List<bool> isVisible = [];
  bool hasError = false;
  late String mobileNumber;
  late String broker_code;

  @override
  void initState() {
    //  implement initState
    super.initState();

    mobileNumber = widget.mobile_number;
    broker_code = widget.broker_code;

    for (int i = 0; i < 3; i++) {
      focusNode.add(FocusNode());
      borderColor.add(Colors.grey);
      isVisible.add(false);

      focusNode[i].addListener(() {
        setState(() {
          borderColor[i] = (focusNode[i].hasFocus)
              ? Config.appTheme.themeColor
              : Colors.grey;
        });
      });
    }
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
            image: (Config.app_client_name == "vbuildwealth" || Config.app_client_name == "perpetualinvestments")
                ? DecorationImage(
                image: AssetImage("assets/orange-bg.png"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Config.appTheme.themeColor, BlendMode.color))
                :(Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32") ? DecorationImage(
                    image: AssetImage("assets/green-bg.png"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Config.appTheme.themeColor , BlendMode.color))
                :DecorationImage(
                    image: AssetImage("assets/white-bg.png"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Config.appTheme.overlay85 , BlendMode.color)) ),
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
                          : (Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32") ? Image.asset(Config.appLogo)
                          :  Image.asset(Config.appLogo,width:setImageSize(400))),
              SizedBox(height: devHeight * 0.06),
              Text("Change Password",
                  style: TextStyle(
                      color: (Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32") ? Colors.white : Config.appTheme.themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              SizedBox(height: devHeight * 0.01),
              Text("Please Change Your Password",
                  style: TextStyle(color: (Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32") ? Colors.white : Config.appTheme.themeColor,)),
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

                      //old password
                      RpTextField(
                          focusNode: focusNode[0],
                          obscureText: !isVisible[0],
                          borderColor: borderColor[0],
                          onChange: (val) => password = val,
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible[0] = !isVisible[0];
                                });
                              },
                              icon: (isVisible[0])
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off)),
                          label: "Password*"),
                      SizedBox(height: devHeight * 0.02),

                      //new password
                      RpTextField(
                          focusNode: focusNode[1],
                          obscureText: !isVisible[1],
                          borderColor: borderColor[1],
                          onChange: (val) => confirmPassword = val,
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible[1] = !isVisible[1];
                                });
                              },
                              icon: (isVisible[1])
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off)),
                          label: "Confirm Password*"),
                      SizedBox(height: 24),
                      SizedBox(
                        width: devWidth,
                        child: TextButton(
                          onPressed: () async {
                            if (password.isEmpty || confirmPassword.isEmpty) {
                              Utils.showError(
                                  context, "All Fields are mandatory");
                              return;
                            }
                            if (password != confirmPassword) {
                              Utils.showError(context, "Password Mismatch");
                              return;
                            }

                            if (password.length < 6) {
                              Utils.showError(context,
                                  "Password must be atleast 6 characters");
                              return;
                            }

                            EasyLoading.show();
                            Map data = await Api.changePasswordUsingOTP(
                                user_id: "",
                                mobile: mobileNumber,
                                client_name: clientName,
                                broker_code: broker_code,
                                password: Uri.encodeComponent(password));
                            if (data['status'] != 200) {
                              Utils.showError(context, "${data['msg']}");
                              return;
                            } else {
                              Get.to(Login());
                            }

                            EasyLoading.dismiss();
                          },
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // <-- Radius
                              ),
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white),
                          child: Text("Change Password",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      SizedBox(height: devHeight * 0.03),
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
}
