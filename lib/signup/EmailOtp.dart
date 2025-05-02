import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mymfbox2_0/Investor/InvestorDashboard.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/login/Login.dart';
import 'package:mymfbox2_0/pojo/UserDataPojo.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:pinput/pinput.dart';

import '../api/ApiConfig.dart';

class EmailOtp extends StatefulWidget {
  const EmailOtp({super.key, required this.signUpData});
  final Map signUpData;
  @override
  State<EmailOtp> createState() => _EmailOtpState();
}

class _EmailOtpState extends State<EmailOtp> {
  String client_name = GetStorage().read("client_name");

  late double devHeight, devWidth;
  List<FocusNode> focusNode = [];
  List<Color> borderColor = [];
  String password = "";
  final controller = TextEditingController();
  final otpFocusNode = FocusNode();
  Map signUpData = {};
  Timer? timer;
  int secLeft = 60;
  TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    //  implement initState
    super.initState();
    signUpData = widget.signUpData;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secLeft == 0) timer.cancel();
      setState(() {
        secLeft--;
      });
    });

    for (int i = 0; i < 4; i++) {
      focusNode.add(FocusNode());
      focusNode[i].addListener(() {
        setState(() {
          borderColor[i] = (focusNode[i].hasFocus)
              ? Config.appTheme.themeColor
              : Colors.grey;
        });
      });
      borderColor.add(Colors.grey);
    }
  }

  @override
  void dispose() {
    //  implement dispose
    for (int i = 0; i < 4; i++) focusNode[i].dispose();
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
                          : Image.asset(Config.appLogo, width: setImageSize(350)),
              ),
              SizedBox(height: devHeight * 0.06),
              Text("Verify Email ID",
                  style: TextStyle(
                      color:
                      (Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32") ? Colors.white : Config.appTheme.themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              SizedBox(height: devHeight * 0.01),
              Text("Please enter the OTP sent to",
                  style: TextStyle(
                    color:
                    (Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32") ? Colors.white : Config.appTheme.themeColor,
                  )),
              Text("${signUpData['email']}",
                  style: TextStyle(
                    color:
                    (Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32") ? Colors.white : Config.appTheme.themeColor,
                  )),
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
                      Pinput(
                        controller: otpController,
                        cursor: cursor(),
                        preFilledWidget: preFillWidget(),
                        showCursor: true,
                        autofocus: true,
                        onCompleted: (val) async {
                          EasyLoading.show();

                          Map data = await Api.verifyEmailOtp(
                              email: signUpData['email'],
                              otp: val,
                              client_name: client_name);

                          if(data['status'] != 200){
                            EasyLoading.dismiss();
                            Utils.showError(context, data['msg']);
                            return;
                          }

                          if (data['status'] == SUCCESS) {
                            Map registerUser = await Api.registerUser(
                                signUpData: signUpData,
                                client_name: client_name);
                            if (registerUser['status'] == SUCCESS) {
                              Map<String, dynamic>? user = registerUser['user'];
                              if (user == null) {
                                Utils.showError(context,
                                    "Unable to create user. Please contact admin.");
                                return;
                              }
                              await writeDataLocally(user);


                              Get.to(InvestorDashboard());
                            } else{
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Alert'),
                                    content: Text(registerUser['msg']),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('ok'),
                                        onPressed: () {
                                          Get.to(Login());
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                             /* Utils.showError(context, registerUser['msg']);
                              return;*/
                            }
                          } else {
                            otpController.clear();
                            Utils.showError(context, data['msg']);
                            return;
                          }
                          EasyLoading.dismiss();
                        },
                        pinAnimationType: PinAnimationType.slide,
                        focusNode: otpFocusNode,
                        defaultPinTheme: PinTheme(
                          width: 56,
                          height: 56,
                          textStyle: GoogleFonts.poppins(
                            fontSize: 22,
                            color: Config.appTheme.themeColor,
                          ),
                          decoration: const BoxDecoration(),
                        ),
                      ),
                      SizedBox(height: devHeight * 0.05),
                      resendOtp(),
                      SizedBox(height: devHeight * 0.05),
                      /* Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? "),
                          Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                color: Config.appTheme.themeColor),
                          )
                        ],
                      )*/
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

  Future<void> writeDataLocally(Map<String, dynamic> user) async {
    await GetStorage().write('user_id', user['user_id']);
    await GetStorage().write('user_name', user['name']);
    await GetStorage().write('user_pan', user['pan']);
    await GetStorage().write('type_id', user['type_id']);
    await GetStorage().write('client_name', user['client_name']);
  }

  Widget resendOtp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Didn't receive OTP? "),
        InkWell(
          onTap: () async {
            if (secLeft > 0) return;
            secLeft = 60;
            timer = Timer.periodic(Duration(seconds: 1), (timer) {
              if (secLeft <= 0) timer.cancel();
              setState(() {
                secLeft--;
              });
            });

            Map otpResp = await Api.sendEmailOTP(
                client_name: client_name,
                email: signUpData['email'],
                name: signUpData['name']);
            if (otpResp['status'] == FAIL) {
              Utils.showError(context, otpResp['msg']);
            }
          },
          child: Text(
            (secLeft >= 0) ? "$secLeft" : "Resend",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                color: Config.appTheme.themeColor),
          ),
        )
      ],
    );
  }

  Widget preFillWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56,
          height: 3,
          decoration: BoxDecoration(
            color: Config.appTheme.themeColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }

  Widget cursor() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 3,
          width: 55,
          decoration: BoxDecoration(
            color: Config.appTheme.themeColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }
}
