import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/login/LoginWithOtp.dart';
import 'package:mymfbox2_0/rp_widgets/RpTextField.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../utils/Constants.dart';

class OtpWithArn extends StatefulWidget {
  const OtpWithArn({super.key});
  @override
  State<OtpWithArn> createState() => _OtpWithArnState();
}

class _OtpWithArnState extends State<OtpWithArn> {
  late double devHeight, devWidth;
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  Color borderColor1 = Colors.grey;
  Color borderColor2 = Colors.grey;
  String password = "", arn = "";
  bool isVisible = false;
  bool hasError = false;
  bool arnError = false;
  FocusNode focusNode = FocusNode();
  Color borderColor = Colors.grey;
  String mobile = "";
  String clientName = Config.app_client_name;
  TextEditingController mobileController = TextEditingController();
  bool isArn = false;
  RxBool isLoading = false.obs;

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

  Future sendPasswordChangeOTP() async {
    EasyLoading.show();
    num mobileNumber = num.parse(mobile);
    Map data = await Api.sendPasswordChangeOTP(
      user_id: "",
      mobile: mobileNumber,
      client_name: clientName,
      broker_code: arn,
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
    Get.to(() => LoginWithOtp(
          mobile_number: num.parse(mobile),
          broker_code: arn,
        ));
    EasyLoading.dismiss();
    return 0;
  }

  Future httpValidateUserId() async {
    EasyLoading.show();
    Map data = await Api.validateUserId(mobile: mobile);
    EasyLoading.dismiss();
    print("validateUserId response = $data");

    if (data['status'] != 200)
      Utils.showError(context, data['msg']);
    else if (data['msg'] == 'Multiple') {
      isArn = true;
      setState(() {});
    } else if (data['msg'] == 'Single') {
      await sendPasswordChangeOTP();
    }
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
            image: (Config.app_client_name == "vbuildwealth"|| Config.app_client_name == "perpetualinvestments")
                ? DecorationImage(
                    image: AssetImage("assets/orange-bg.png"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Config.appTheme.themeColor, BlendMode.color))
                :(Config.app_client_name == "themfbox") ? DecorationImage(
                    image: AssetImage("assets/green-bg.png"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Config.appTheme.themeColor , BlendMode.color))
                : DecorationImage(
                    image: AssetImage("assets/white-bg.png"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Config.appTheme.overlay85 , BlendMode.color))
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
                              height: setImageSize(60))
                          : (Config.app_client_name == "themfbox") ? Image.asset(Config.appLogo)
                          :  Image.asset(Config.appLogo,width:setImageSize(400))),

              SizedBox(height: devHeight * 0.06),
              Text("Login with Otp",
                  style: TextStyle(
                      color: (Config.app_client_name == "themfbox") ? Colors.white : Config.appTheme.themeColor ,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              SizedBox(height: devHeight * 0.01),
              Text("Welcome Back", style: TextStyle(color: (Config.app_client_name == "themfbox") ? Colors.white : Config.appTheme.themeColor ,)),
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
                          controller: mobileController,
                          inputType: TextInputType.phone,
                          label: "Mobile Number",
                          maxLength: 10,
                          onChange: (val) => mobile = val),
                      if (isArn) ...[
                        SizedBox(height: devHeight * 0.03),
                        RpTextField(
                            focusNode: focusNode2,
                            borderColor: borderColor2,
                            inputType: TextInputType.number,
                            onChange: (val) => arn = val,
                            label: "ARN Number"),
                      ],
                      SizedBox(height: devHeight * 0.03),
                      SizedBox(
                        width: devWidth,
                        child: TextButton(
                          onPressed: () async {
                            if (mobile.isEmpty) {
                              Utils.showError(
                                  context, "Please Enter Mobile Number.");
                              return;
                            }
                            if (mobile.length != 10) {
                              Utils.showError(
                                  context, "Please Enter Valid Mobile Number.");
                              return;
                            }
                            if (isArn) {
                              if (arn.isEmpty) {
                                Utils.showError(
                                    context, "Please Enter Valid ARN Number.");
                                return;
                              } else {
                                await sendPasswordChangeOTP();
                              }
                            } else {
                              await httpValidateUserId();
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
                          child: Text("Send OTP",
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

  Future writeDataLocally(Map data) async {
    Map<String, dynamic> user = data['user'];
    int type_id = user['type_id'];

    await GetStorage().write("isLoggedIn", true);
    await GetStorage().write("type_id", type_id);
    await GetStorage().write('client_name', user['client_name']);
    Config.app_client_name = user['client_name'];

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
    await GetStorage().write("user_email", user['email']);
    await GetStorage().write("user_dob", user['dob']);
    await GetStorage().write("user_addr", user['address']);
    await GetStorage().write("user_rmName", user['rmName']);

    await GetStorage().write("nse_customer", user['nse_customer']);
    await GetStorage().write("nse_active", user['nse_active']);
    await GetStorage().write("nse_iin_number", user['nse_iin_number']);

    await GetStorage().write("bse_customer", user['bse_customer']);
    await GetStorage().write("bse_active", user['bse_active']);
    await GetStorage().write("bse_client_code", user['bse_client_code']);

    await GetStorage().write("mfu_customer", user['mfu_customer']);
    await GetStorage().write("mfu_active", user['mfu_active']);
    await GetStorage().write("mfu_can_number", user['mfu_can_number']);

    await GetStorage().write("user_branch", user['branch']);
    await GetStorage().write("holding_nature", user['holding_nature']);
  }
}
