import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/login/ForgotPasswordOtp.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:mymfbox2_0/rp_widgets/RpTextField.dart';

import '../utils/Constants.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late double devHeight, devWidth;
  FocusNode focusNode = FocusNode();
  Color borderColor = Colors.grey;
  String mobileNo = "";
  bool hasError = false;
  bool arnError = false;
  FocusNode focusNode2 = FocusNode();
  Color borderColor1 = Colors.grey;
  Color borderColor2 = Colors.grey;

  String clientName = Config.app_client_name;
  String appArn = "${Config.appArn}";
  TextEditingController mobController = TextEditingController();
  String arn = "";

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
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

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
                :(Config.app_client_name == "themfbox") ? DecorationImage(
                    image: AssetImage("assets/green-bg.png"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Config.appTheme.themeColor , BlendMode.color))
                : DecorationImage(
                    image: AssetImage("assets/white-bg.png"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Config.appTheme.overlay85 , BlendMode.color)),
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
              Text("Forgot Password",
                  style: TextStyle(
                      color: (Config.app_client_name == "themfbox") ? Colors.white : Config.appTheme.themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              SizedBox(height: devHeight * 0.01),
              Text("Please Enter Mobile No",
                  style: TextStyle(color: (Config.app_client_name == "themfbox") ? Colors.white : Config.appTheme.themeColor)),
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
                          focusNode: focusNode,
                          borderColor: borderColor,
                          maxLines: 1,
                          maxLength: 10,
                          capitalization: TextCapitalization.characters,
                          onChange: (val) => mobileNo = val,
                          label: "Mobile / PAN"),
                      Visibility(
                        visible: hasError,
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Text("Invalid Mobile / PAN",
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: arnError,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: RpTextField(
                              focusNode: focusNode2,
                              borderColor: borderColor2,
                              inputType: TextInputType.number,
                              onChange: (val) => arn = val,
                              label: "ARN Number"),
                        ),
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: devWidth,
                        child: TextButton(
                          onPressed: () async {
                            if (mobileNo.length != 10) {
                              hasError = true;
                              setState(() {});
                              return;
                            }
                          //num mobileNumber = num.parse(mobileNo);
                            EasyLoading.show();

                            Map data = await Api.sendPasswordChangeOTP(
                              user_id: "",
                              mobile: mobileNo,
                              client_name: clientName,
                              broker_code: arn,
                            );

                            if (data['status'] == 400 &&
                                data['msg'].contains(
                                    'Multiple Users are registered with us')) {
                              Utils.showError(context, "${data['msg']}");
                              arnError = true;
                              setState(() {});
                              return;
                            }

                            /*data = await Api.sendPasswordChangeOTP(
                              user_id: "",
                              mobile: mobileNumber,
                              client_name: clientName,
                              broker_code: arn,
                            );*/

                            if (data['status'] != 200) {
                              Utils.showError(context, "${data['msg']}");
                              return;
                            }
                            EasyLoading.dismiss();

                            Get.to(() => ForgotPasswordOtp(
                                  mobile_number: mobileNo,
                                  broker_code: arn,
                                ));
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
