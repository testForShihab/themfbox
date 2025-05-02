import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mymfbox2_0/Family/FamilyDashboard.dart';
import 'package:mymfbox2_0/Investor/InvestorDashboard.dart';
import 'package:mymfbox2_0/advisor/dashboard/AdminDashboard.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
//import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pinput/pinput.dart';

import '../api/ApiConfig.dart';
import '../utils/Constants.dart';

class LoginWithOtp extends StatefulWidget {
  const LoginWithOtp({
    super.key,
    required this.mobile_number,
    required this.broker_code,
  });
  final num mobile_number;
  final String broker_code;
  @override
  State<LoginWithOtp> createState() => _LoginWithOtpState();
}

class _LoginWithOtpState extends State<LoginWithOtp> {
  late double devHeight, devWidth;
  String mobileNo = "";
  String clientName = Config.app_client_name;
  String appArn = "ARN-${Config.appArn}";
  bool brokerCode = false;
  TextEditingController textController = TextEditingController();
  String otpNo = "";
  final otpFocusNode = FocusNode();
  bool arnError = false;
  String broker_code = "";
  RxBool isLoading = false.obs;
  int secondsElapsed = 30;
  Timer? timer;

  @override
  void initState() {
    //  implement initState
    super.initState();

    mobileNo = widget.mobile_number.toString();
    broker_code = widget.broker_code;

    setState(() {
      isLoading.value = true;
      secondsElapsed = 30;
    });

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (secondsElapsed > 1) {
          secondsElapsed--;
        } else {
          timer?.cancel();
        }
      });
    });

    Future.delayed(Duration(seconds: 30), () {
      setState(() {
        isLoading.value = false;
      });
      timer?.cancel();
    });

  }

  Future login() async {
    String mobNumber = widget.mobile_number.toString();
    // EasyLoading.show();
    isLoading.value = true;

    Map data = await Api.login(
        mobile: mobNumber,
        password: otpNo,
        is_otp: "Y",
        broker_code: broker_code);
    isLoading.value = false;
    // EasyLoading.dismiss();

    if (data['status'] == 200) {
      await writeDataLocally(data);
      int type_id = GetStorage().read('type_id');
      if (type_id == 5 || type_id == 2) Get.offAll(() => AdminDashboard());
      if (type_id == 1) Get.offAll(() => InvestorDashboard());
      if (type_id == 3) Get.offAll(() => FamilyDashboard());
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

    if (type_id == 5 || type_id == 2) {
      await GetStorage().write("mfd_id", user['user_id']);
      await GetStorage().write("mfd_name", user['name']);
      await GetStorage().write("mfd_pan", user['pan']);
      await GetStorage().write("mfd_mobile", user['mobile']);
    } else if (type_id == 1) {
      await GetStorage().write("user_id", user['user_id']);
      await GetStorage().write("user_name", user['name']);

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
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    print("clientName  $clientName");
    print("arn  $appArn");
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: devHeight,
          width: devWidth,
          decoration: BoxDecoration(
              image: (Config.app_client_name == "vbuildwealth"|| Config.app_client_name == "perpetualinvestments") ? DecorationImage(
                  image: AssetImage("assets/orange-bg.png"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Config.appTheme.themeColor, BlendMode.color))
                  :(Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32") ?  DecorationImage(
                      image: AssetImage("assets/green-bg.png"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Config.appTheme.themeColor , BlendMode.color))
                  : DecorationImage(
                      image: AssetImage("assets/white-bg.png"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Config.appTheme.overlay85 , BlendMode.color))
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
              Text("Mobile OTP Verification",
                  style: TextStyle(
                      color: (Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32") ? Colors.white : Config.appTheme.themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              SizedBox(height: devHeight * 0.01),
              Text("Please Enter OTP", style: TextStyle(color: (Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32") ? Colors.white : Config.appTheme.themeColor)),
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
                      Pinput(
                        obscureText: true,
                        obscuringCharacter: "*",
                        cursor: cursor(),
                        preFilledWidget: preFillWidget(),
                        showCursor: true,
                        autofocus: true,
                        onChanged: (val) {
                          if (val.isEmpty) {
                            // Clear the PIN when it's empty
                            otpNo = ''; // Clear the value
                          }
                        },
                        onCompleted: (val) async {
                          print("otp $val");
                          otpNo = val;
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
                      SizedBox(height: 32),
                      SizedBox(
                        width: devWidth,
                        child: TextButton(
                          onPressed: () async {
                            if (otpNo.length != 4) {
                              Utils.showError(context, "Invalid OTP");
                              return;
                            }
                            num mobileNumber = num.parse(mobileNo);
                            EasyLoading.show();
                            await login();
                            EasyLoading.dismiss();
                          },
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // <-- Radius
                              ),
                              backgroundColor: Config.appTheme.universalTitle,
                              foregroundColor: Colors.white),
                          child: Text("Verify OTP",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      SizedBox(height: devHeight * 0.05),
                      (isLoading == true)
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive OTP? 00:${secondsElapsed}s",
                          ),
                          SizedBox(width: 15),
                          SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 5,
                            ),
                          )
                        ],
                      )
                          : resendOtp(),

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

  Widget resendOtp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Didn't receive OTP? "),
        GestureDetector(
          onTap: () async {
            num mobileNumber = num.parse(mobileNo);
            Map data = await Api.sendPasswordChangeOTP(
              user_id: "",
              mobile: mobileNo,
              client_name: clientName,
              broker_code: broker_code,
            );

            if (data['status'] == 400 &&
                data['msg'].contains('Multiple Users are registered with us')) {
              Utils.showError(context, "${data['msg']}");
              arnError = true;
              setState(() {});
              return;
            }

            if (data['status'] != 200) {
              Utils.showError(context, "${data['msg']}");
              return;
            }
            if(data['status'] == 200) showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm'),
                  content: Text('OTP sent successfully'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
            /*Fluttertoast.showToast(
                msg: "Otp sent Successfully",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Config.appTheme.themeColor,
                textColor: Colors.white,
                fontSize: 16.0);*/
          },
          child: Text(
            "Resend",
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
