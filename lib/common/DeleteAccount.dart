import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/Config.dart';

import '../rp_widgets/BottomSheetTitle.dart';
import '../rp_widgets/CalculateButton.dart';
import '../rp_widgets/ColumnText.dart';
import '../utils/AppFonts.dart';
import '../utils/Constants.dart';
import '../utils/Utils.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});
  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  late double devHeight, devWidth;
  FocusNode focusNode = FocusNode();
  Color borderColor = Colors.grey;
  String reason = "";
  bool hasError = false;
  int userId = getUserId();
  String clientName = GetStorage().read("client_name");

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

  Future deleteUser() async {
    Map data =
        await AdminApi.deleteUser(user_id: userId, client_name: clientName);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config.appTheme.themeColor,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        elevation: 0,
      ),
      body: SideBar(
        child: SingleChildScrollView(
          child: Container(
            height: devHeight,
            width: devWidth,
            decoration: BoxDecoration(
              color: Config.appTheme.themeColor,
              // image: DecorationImage(
              //     image: AssetImage("assets/green-bg.png"), fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                SizedBox(height: devHeight * 0.05),
                // Image.asset("assets/logo.png", height: 60),
                // SizedBox(height: devHeight * 0.06),
                Text("Manage Account",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                SizedBox(height: devHeight * 0.01),
                Text("Are you sure to delete your account?",
                    style: TextStyle(color: Colors.white)),
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
                        TextField(
                          focusNode: focusNode,
                          maxLines: 5,
                          maxLength: 200,
                          onChanged: (val) => reason = val,
                          decoration: InputDecoration(
                              hintText: "Reason for Deleting Account *",
                              border: OutlineInputBorder()),
                        ),
                        Visibility(
                          visible: hasError,
                          child: Row(
                            children: [
                              SizedBox(width: 5),
                              Text("Please Enter Password",
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                        SizedBox(height: devHeight * 0.03),
                        SizedBox(
                          width: devWidth,
                          height: 55,
                          child: TextButton(
                            onPressed: () async {
                              deleteAccount();
                              /*await showDialog(
                                context: context,
                                builder: (BuildContext ctx) {
                                  return AlertDialog(
                                    title: Text("Delete"),
                                    content: Text(
                                        "You request has been accepted and it's in under proccess."),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () async {
                                            Get.back();
                                            await deleteUser();
                                          },
                                          child: Text("Ok")),
                                    ],
                                  );
                                },
                              );

                              Get.back();*/
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: Color(0XFFD10B0B),
                                foregroundColor: Colors.white),
                            child: Text("Continue",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
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

  deleteAccount() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              BottomSheetTitle(title: "Confirm"),
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Config.appTheme.themeColor)),
                child: ColumnText(
                  title: "You are about to Delete the account",
                  value: "Please check all the details carefully",
                  titleStyle: AppFonts.f50014Black,
                  valueStyle: AppFonts.f40013,
                ),
              ),
              CalculateButton(
                  onPress: () async {
                    Get.back();
                    await deleteUser();
                    EasyLoading.showInfo("You request has been accepted and it's in under proccess.");
                    reason = "";
                    Get.back();

                  },
                  text: "Confirm")
            ],
          ),
        );
      },
    );
  }
}
