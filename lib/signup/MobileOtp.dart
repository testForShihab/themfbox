import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/signup/EmailOtp.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:pinput/pinput.dart';

class MobileOtp extends StatefulWidget {
  const MobileOtp({super.key, required this.signUpData});
  final Map signUpData;
  @override
  State<MobileOtp> createState() => _MobileOtpState();
}

class _MobileOtpState extends State<MobileOtp> {
  String client_name = GetStorage().read("client_name");

  TextEditingController otpController = TextEditingController();

  late double devHeight, devWidth;
  List<FocusNode> focusNode = [];
  List<Color> borderColor = [];
  String password = "";
  final controller = TextEditingController();
  final otpFocusNode = FocusNode();
  Map signUpData = {};
  Timer? timer;
  int secLeft = 60;

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
    if (timer != null) timer!.cancel();
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
                : (Config.app_client_name == "themfbox") ? DecorationImage(
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
                          : (Config.app_client_name == "themfbox") ?Image.asset(Config.appLogo)
                          : Image.asset(Config.appLogo, width: setImageSize(350)),
              ),
              SizedBox(height: devHeight * 0.06),
              Text("Verify Mobile Number",
                  style: TextStyle(
                      color:
                      (Config.app_client_name == "themfbox") ? Colors.white : Config.appTheme.themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              SizedBox(height: devHeight * 0.01),
              Text("Please enter the OTP sent to ${signUpData['mobile']}",
                  style: TextStyle(
                    color: (Config.app_client_name == "themfbox") ? Colors.white : Config.appTheme.themeColor,
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
                          print("otp = $val");
                          EasyLoading.show();

                          Map mobResp = await Api.verifyMobileOtp(
                              mobile: signUpData['mobile'],
                              otp: val,
                              client_name: client_name);
                          if (mobResp['status'] == SUCCESS) {
                            Map emailResp = await Api.sendEmailOTP(
                                name: signUpData['name'],
                                email: signUpData['email'],
                                client_name: client_name);

                            EasyLoading.dismiss();

                            Get.to(EmailOtp(signUpData: signUpData));
                          } else {
                            EasyLoading.dismiss();
                            otpController.clear();
                            Utils.showError(context, mobResp['msg']);
                          }
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Didn't receive OTP? "),
                          InkWell(
                            onTap: () async {
                              if (secLeft > 0) return;
                              secLeft = 60;
                              timer =
                                  Timer.periodic(Duration(seconds: 1), (timer) {
                                if (secLeft <= 0) timer.cancel();
                                setState(() {
                                  secLeft--;
                                });
                              });
                              Map mobileOtp = await Api.sendMobileOtp(
                                  mobile: signUpData['mobile'],
                                  client_name: client_name);
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
                      ),
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
