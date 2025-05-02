// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/login/Login.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:mymfbox2_0/rp_widgets/RpTextField.dart';

import '../api/ApiConfig.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late double devHeight, devWidth;
  List<FocusNode> focusNode = [];
  List<Color> borderColor = [];
  String oldPassword = "", newPassword = "", confirmPassword = "";
  List<bool> isVisible = [];
  bool hasError = false;
  late int user_id;
  String client_name = GetStorage().read("client_name");
  int? adminAsInvestor, adminAsFamily;
  bool? familyAsInvestor;

  @override
  void initState() {
    //  implement initState
    super.initState();

    getUserId();

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

  getUserId() {
    int type_id = GetStorage().read('type_id');
    adminAsInvestor = GetStorage().read("adminAsInvestor");
    adminAsFamily = GetStorage().read("adminAsFamily");
    familyAsInvestor = GetStorage().read('familyAsInvestor');

    if (type_id == 5) {
      if (adminAsInvestor != null)
        return user_id = GetStorage().read('user_id');
      if (adminAsFamily != null) {
        if (familyAsInvestor != null)
          return user_id = GetStorage().read('user_id');
        else
          return user_id = GetStorage().read('family_id');
      }
      return user_id = GetStorage().read("mfd_id");
    } else if (type_id == 3) {
      if (familyAsInvestor != null)
        return user_id = GetStorage().read('user_id');
      else
        return user_id = GetStorage().read('family_id');
    } else if (type_id == 1) {
      return user_id = GetStorage().read('user_id');
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return SideBar(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: devHeight,
            width: devWidth,
            decoration: BoxDecoration(
              image: (Config.app_client_name == "vbuildwealth" || Config.app_client_name == "perpetualinvestments") ? DecorationImage(
                        image: AssetImage("assets/orange-bg.png"),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Config.appTheme.themeColor, BlendMode.color))

                  : (Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32") ? DecorationImage(
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
                SizedBox(height: 45),
                Container(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back,
                        color: (Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32") ? Colors.white : Config.appTheme.themeColor ,)),
                ),

                SizedBox(height: devHeight * 0.1),
                // Image.asset("assets/logo.png", height: 60),
                // SizedBox(height: devHeight * 0.06),
                Text("Change Password",
                    style: TextStyle(
                        color: (Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32") ? Colors.white : Config.appTheme.themeColor ,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                SizedBox(height: devHeight * 0.01),
                Text("Please enter new password details",
                    style: TextStyle(
                      color: (Config.apiKey == "29c5a2ec-3910-4d71-acf7-c6f51e3e9c32") ? Colors.white : Config.appTheme.themeColor ,
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

                        //old password
                        RpTextField(
                            focusNode: focusNode[0],
                            obscureText: !isVisible[0],
                            borderColor: borderColor[0],
                            onChange: (val) => oldPassword = val,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisible[0] = !isVisible[0];
                                  });
                                },
                                icon: (isVisible[0])
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off)),
                            label: "Old Password*"),
                        SizedBox(height: devHeight * 0.02),
                        //

                        //new password
                        RpTextField(
                            focusNode: focusNode[1],
                            obscureText: !isVisible[1],
                            borderColor: borderColor[1],
                            onChange: (val) => newPassword = val,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisible[1] = !isVisible[1];
                                  });
                                },
                                icon: (isVisible[1])
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off)),
                            label: "New Password*"),
                        SizedBox(height: devHeight * 0.02),
                        //

                        RpTextField(
                            focusNode: focusNode[2],
                            obscureText: !isVisible[2],
                            borderColor: borderColor[2],
                            onChange: (val) => confirmPassword = val,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisible[2] = !isVisible[2];
                                  });
                                },
                                icon: (isVisible[2])
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off)),
                            label: "Confirm Password*"),

                        SizedBox(height: 20),
                        SizedBox(
                          width: devWidth,
                          child: TextButton(
                            onPressed: () async {

                              if(oldPassword.isEmpty){
                                Utils.showError(context, "Please enter the old password");
                                return;
                              }

                              if(newPassword.isEmpty){
                                Utils.showError(context, "Please enter the new password");
                                return;
                              }

                              if(confirmPassword.isEmpty){
                                Utils.showError(context, "Please enter the confirm password");
                                return;
                              }

                              if (newPassword != confirmPassword) {
                                Utils.showError(context, "New password and confirm password are not matched");
                                return;
                              }

                              if (newPassword.length < 6) {
                                Utils.showError(context, "Password must be atleast 6 characters");
                                return;
                              }

                              EasyLoading.show();
                              Map data = await Api.changePassword(
                                  user_id: user_id,
                                  client_name: client_name,
                                  old_password: oldPassword,
                                  new_password: newPassword);
                              if (data['status'] != 200) {
                                Utils.showError(context, "${data['msg']}");
                                return;
                              } else {
                                EasyLoading.showInfo("${data['msg']}", duration: Duration(seconds: 3));
                                Get.to(Login());
                              }

                              EasyLoading.dismiss();
                            },
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8), // <-- Radius
                                ),
                                backgroundColor: Config.appTheme.universalTitle,
                                foregroundColor: Colors.white
                            ),
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
      ),
    );
  }
}
