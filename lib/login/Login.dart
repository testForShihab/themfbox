// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/login/OtpWithArn.dart';
import 'package:mymfbox2_0/login/Password.dart';
import 'package:mymfbox2_0/login/PasswordWithArn.dart';
import 'package:mymfbox2_0/signup/SignUp.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:mymfbox2_0/rp_widgets/RpTextField.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/AppFonts.dart';
import '../utils/Constants.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late double devHeight, devWidth;
  FocusNode focusNode = FocusNode();
  Color borderColor = Colors.grey;
  String mobile = "";
  bool isError = false;
  TextEditingController mobileController = TextEditingController();

  @override
  void initState() {
    //  implement initState
    super.initState();
    focusNode.addListener(() {
      setState(() {
        borderColor =
            (focusNode.hasFocus) ? Config.appTheme.themeColor : Colors.grey;
      });
    });
  }

  @override
  void dispose() {
    // : implement dispose
    focusNode.dispose();
    super.dispose();
  }

  RxBool isLoading = false.obs;

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

                    : (Config.app_client_name == "themfbox") ? DecorationImage(
                        image: AssetImage("assets/green-bg.png"),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Config.appTheme.themeColor, BlendMode.color))
                    : DecorationImage(
                        image: AssetImage('assets/white-bg.png'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Config.appTheme.overlay85,BlendMode.color)),
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
              SizedBox(height: devHeight * 0.02),
              Text("Login",
                  style: TextStyle(
                      color:
                      (Config.app_client_name == "themfbox") ? Colors.white : Config.appTheme.themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
              SizedBox(height: devHeight * 0.01),
              Text("Welcome Back",
                  style: TextStyle(
                      color: (Config.app_client_name == "themfbox") ? Colors.white  : Config.appTheme.themeColor,
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
                          borderColor: borderColor,
                          controller: mobileController,
                          capitalization: TextCapitalization.characters,
                          label: (clientName != 'trianglewealth')
                              ? "PAN / Mobile"
                              : "PAN",
                          maxLength: 10,
                          onChange: (val) => mobile = val),
                      Visibility(
                        visible: isError,
                        child: Row(
                          children: [
                            Text(" Please Enter a valid PAN / Mobile",
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      continueBtn(onPress: () async {
                        if (isLoading.value) return;

                        if (mobile.isEmpty) {
                          borderColor = Colors.red;
                          isError = true;
                          setState(() {});
                          return;
                        }
                        if (mobile == "SUPERADMIN") {
                          if (Config.appArn.isNotEmpty) {
                            Utils.showError(context, "Login Not Allowed");
                            return;
                          }
                        }
                        await httpValidateUserId();
                      }),
                      orLine(),
                      continueBtn(
                          onPress: () {
                            Get.to(() => OtpWithArn());
                          },
                          text: "Login With OTP",
                          hasCallIcon: true),
                      SizedBox(height: devHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? "),
                          InkWell(
                            onTap: () {
                              Get.to(() => SignUp());
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  color: Config.appTheme.themeColor),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: devHeight * 0.02),
                      if (Config.app_client_name != "themfbox") topCard(),
                      SizedBox(height: devHeight * 0.01),
                      // Visibility(
                      //     visible: kDebugMode,
                      //     child: ElevatedButton(
                      //         onPressed: () async {
                      //           /*double devicePixelRatio =
                      //               MediaQuery.of(context).devicePixelRatio;
                      //           EasyLoading.showInfo(
                      //               "devHeight= $devHeight\ndevWidth= $devWidth\ndevicePixelRatio=$devicePixelRatio");*/

                      //           // mobile = "COUNTONADM";
                      //           mobile = "ADVISORBAS";

                      //           await httpValidateUserId();
                      //         },
                      //         child: Text("easy login"))),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      //bottomSheet: topCard(),
    );
  }

  Widget orLine() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider()),
          Text("OR"),
          Expanded(child: Divider()),
        ],
      ),
    );
  }

  Widget continueBtn(
      {required Function() onPress,
      String text = "Continue",
      bool hasCallIcon = false}) {
    return Obx(() {
      return SizedBox(
        width: devWidth,
        child: TextButton(
          onPressed: onPress,
          style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // <-- Radius
              ),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white),
          child: (isLoading.value && text != "Login With OTP")
              ? SpinKitThreeBounce(color: Colors.white, size: 22)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (hasCallIcon) ...[
                      Icon(Icons.call),
                      SizedBox(width: 8),
                    ],
                    Text(text,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
        ),
      );
    });
  }

  String websiteName = Config.website;
  Widget topCard() {
    String slashLine = " | ";
    return Container(
      color: Colors.white,
      child: SizedBox(
        height: devHeight * 0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text(
              Config.companyName,
              style: AppFonts.f40016
                  .copyWith(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            SizedBox(height: 2),
            Text(Config.address1,
                style: AppFonts.f50014Grey.copyWith(color: Colors.black)),
            SizedBox(height: 2),
            Text(Config.address2,
                style: AppFonts.f50014Grey.copyWith(color: Colors.black)),
            SizedBox(height: 2),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: Config.supportEmail,
                    style: AppFonts.f50014Grey.copyWith(color: Colors.blueAccent),
                    recognizer: TapGestureRecognizer()
                      ..onTap =
                          () => _launchEmailClient(context, Config.supportEmail),
                  ),
                  TextSpan(
                      text: (Config.supportMobile.isEmpty)
                          ? ""
                          : slashLine,
                      style: AppFonts.f50014Grey.copyWith(color: Colors.black)),
                  TextSpan(
                      text: Config.supportMobile,
                      style: AppFonts.f50014Grey.copyWith(color: Colors.blueAccent),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _launchPhoneDialer(Config.supportMobile);
                        }),
                ],
              ),
            ),
            SizedBox(height: 2),
            InkWell(
                onTap: () {
                  _launchURL(context, websiteName);
                },
                child: Text(
                  websiteName,
                  style: AppFonts.f50014Grey.copyWith(color: Colors.blueAccent),
                )),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _launchPhoneDialer(String phoneNumber) async {
    final Uri _phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(_phoneUri)) {
      await launchUrl(_phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  void _launchEmailClient(BuildContext context, String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: <String, String>{
        'subject': '',
        'body': '',
      },
    );

    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open email client.'),
        ),
      );
    }
  }

  void _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);

    try {
      // Use canLaunchUrl from url_launcher
      // bool canLaunchUrl = await canLaunch('http://themfbox.eurekasec.com');
      final bool canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch $url'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error launching URL: $e'),
        ),
      );
    }
  }

  Future normalLogin() async {}

  Future httpValidateUserId() async {
    // EasyLoading.show();
    isLoading.value = true;
    Map data = await Api.validateUserId(mobile: mobile);
    isLoading.value = false;
    // EasyLoading.dismiss();
    print("validateUserId response = $data");
    // print(object)
    if (data['status'] != 200)
      Utils.showError(context, data['msg']);
    else if (data['msg'] == 'Multiple') {
      //Get.to(PasswordWithArn(mobile: mobile));
      Get.to(() => PasswordWithArn(mobile: mobile));
    } else if (data['msg'] == 'Single') Get.to(() => Password(mobile: mobile));
  }
}
