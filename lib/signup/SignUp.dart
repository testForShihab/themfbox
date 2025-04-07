import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/signup/BasicDetails.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:mymfbox2_0/rp_widgets/RpTextField.dart';

import '../utils/Constants.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late double devHeight, devWidth;
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  Color borderColor1 = Colors.grey;
  Color borderColor2 = Colors.grey;
  String pan = "", arn = "";
  TextEditingController panController = TextEditingController();
  TextEditingController arnController =
      TextEditingController(text: Config.appArn);

  @override
  void initState() {
    //  implement initState
    super.initState();
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
            image: (Config.app_client_name == "vbuildwealth" ||
                    Config.app_client_name == "perpetualinvestments")
                ? DecorationImage(
                    image: AssetImage("assets/orange-bg.png"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Config.appTheme.themeColor, BlendMode.color))
                : (Config.app_client_name == "themfbox")
                    ? DecorationImage(
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
                          ? Image.network(Config.appLogo,
                              height: setImageSize(100))
                          : (Config.app_client_name == "themfbox")
                              ? Image.asset(Config.appLogo)
                              : Image.asset(Config.appLogo),
                    ),
              SizedBox(height: devHeight * 0.06),
              Text("Sign Up",
                  style: TextStyle(
                      color: (Config.app_client_name == "themfbox")
                          ? Colors.white
                          : Config.appTheme.themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              SizedBox(height: devHeight * 0.01),
              Text("Welcome",
                  style: TextStyle(
                    color: (Config.app_client_name == "themfbox")
                        ? Colors.white
                        : Config.appTheme.themeColor,
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
                      RpTextField(
                          focusNode: focusNode1,
                          borderColor: borderColor1,
                          maxLength: 10,
                          onChange: (val) {
                            pan = val;
                            // if (val.length == 5) {
                            //   panType = TextInputType.number;
                            //   focusNode1.unfocus();
                            //   Future.delayed(Duration(milliseconds: 500), () {
                            //     focusNode1.requestFocus();
                            //   });
                            // }
                            // if (val.length == 9) {
                            //   panType = TextInputType.name;
                            //   focusNode1.unfocus();
                            //   Future.delayed(Duration(milliseconds: 500), () {
                            //     focusNode1.requestFocus();
                            //   });
                            // }
                            // if (val.isEmpty) {
                            //   panType = TextInputType.name;
                            //   focusNode1.unfocus();
                            //   Future.delayed(Duration(milliseconds: 500), () {
                            //     focusNode1.requestFocus();
                            //   });
                            // }

                            // if (val.length >= 10) {
                            //   panController.text = val.substring(0, 10);
                            //   pan = panController.text;
                            //   return;
                            // }

                            // pan = val;
                          },
                          controller: panController,
                          capitalization: TextCapitalization.characters,
                          label: "PAN Number"),
                      SizedBox(height: devHeight * 0.03),
                      if (Config.appArn.isEmpty)
                        RpTextField(
                            focusNode: focusNode2,
                            borderColor: borderColor2,
                            controller: arnController,
                            maxLength: 6,
                            onChange: (val) {
                              arn = val;
                            },
                            readOnly: Config.appArn.isNotEmpty,
                            inputType: TextInputType.number,
                            label: "ARN Number"),
                      SizedBox(height: 24),
                      SizedBox(
                        width: devWidth,
                        child: TextButton(
                          onPressed: () async {
                            EasyLoading.show();
                            print("arn ${arnController.text}");
                            if (arn.isEmpty) arn = Config.appArn;

                            Map data = await Api.validatePan(
                              pan: pan,
                              broker_code: arn,
                            );
                            GetStorage().write("pan", pan);
                            EasyLoading.dismiss();
                            if (data['status'] == 400) {
                              Utils.showError(context, data['msg']);
                              return;
                            } else if (data['status'] == 200) {
                              await GetStorage()
                                  .write("client_name", data["client_name"]);
                              Get.to(BasicDetails(arn: arn));
                            }
                          },
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // <-- Radius
                              ),
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white),
                          child: Text("Continue",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      SizedBox(height: devHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? "),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Text(
                              "Login",
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
}
