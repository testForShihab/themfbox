import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/signup/MobileOtp.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:mymfbox2_0/rp_widgets/RpTextField.dart';

class BasicDetails extends StatefulWidget {
  const BasicDetails({super.key, required this.arn});
  final String arn;
  @override
  State<BasicDetails> createState() => _BasicDetailsState();
}

class _BasicDetailsState extends State<BasicDetails> {
  String client_name = GetStorage().read("client_name");

  late double devHeight, devWidth;
  List<FocusNode> focusNode = [];
  List<Color> borderColor = [];
  String name = "", mobile = "";
  String email = "", password = "";
  Map signUpData = {};
  bool isVisible = false;

  @override
  void initState() {
    //  implement initState
    super.initState();
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
              Text("Sign Up",
                  style: TextStyle(
                      color: (Config.app_client_name == "themfbox") ? Colors.white : Config.appTheme.themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              SizedBox(height: devHeight * 0.01),
              Text("Please enter your details to continue",
                  style: TextStyle(color:
                      (Config.app_client_name == "themfbox") ? Colors.white : Config.appTheme.themeColor)),
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
                          focusNode: focusNode[0],
                          borderColor: borderColor[0],
                          onChange: (val) => name = val,
                          // readOnly: widget.name.isNotEmpty,
                          // initialValue: widget.name,
                          label: "Name"),
                      SizedBox(height: devHeight * 0.03),
                      RpTextField(
                          focusNode: focusNode[1],
                          borderColor: borderColor[1],
                          maxLength: 10,
                          inputType: TextInputType.phone,
                          onChange: (val) => mobile = val,
                          label: "Mobile Number"),
                      SizedBox(height: devHeight * 0.03),
                      RpTextField(
                          focusNode: focusNode[2],
                          borderColor: borderColor[2],
                          maxLines: 1,
                          inputType: TextInputType.emailAddress,
                          onChange: (val) => email = val,
                          label: "Email ID"),
                      SizedBox(height: devHeight * 0.03),
                      RpTextField(
                          focusNode: focusNode[3],
                          borderColor: borderColor[3],
                          onChange: (val) => password = val,
                          obscureText: !isVisible,
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
                      SizedBox(
                        width: devWidth,
                        child: TextButton(
                          onPressed: () async {
                            signUpData['name'] = name;
                            signUpData['arn'] = widget.arn;
                            signUpData['mobile'] = mobile;
                            signUpData['email'] = email;
                            signUpData['password'] = Uri.encodeComponent(password);

                            print("signUpData = $signUpData");
                            if (mobile.length != 10) {
                              Utils.showError(context, "Invalid Mobile Number");
                              return;
                            }
                            if (!email.isEmail) {
                              Utils.showError(context, "Invalid Email ID");
                              return;
                            }
                            if (password.length < 6) {
                              Utils.showError(context,
                                  "Password must be atleast 6 characters");
                              return;
                            }
                            EasyLoading.show();
                            Map data =
                                await Api.checkIfMobileOrEmailAlreadyExist(
                                    email: email,
                                    mobile: mobile,
                                    client_name: client_name);
                            if (data['status'] == SUCCESS) {
                              Map mobileOtp = await Api.sendMobileOtp(
                                  mobile: mobile, client_name: client_name);

                              if (mobileOtp['status'] == SUCCESS) {
                                Get.to(MobileOtp(signUpData: signUpData));
                              } else {
                                Utils.showError(context, data['msg']);
                                return;
                              }
                            } else {
                              Utils.showError(context, data['msg']);
                            }
                            EasyLoading.dismiss();

                            // Get.to(MobileOtp());
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8), //
                              ),
                              padding: EdgeInsets.symmetric(vertical: 18),
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white),
                          child: Text("Sign Up",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      SizedBox(height: devHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?"),
                          Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                color: Config.appTheme.themeColor),
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
