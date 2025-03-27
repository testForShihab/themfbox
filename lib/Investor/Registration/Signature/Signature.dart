import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mymfbox2_0/Investor/Registration/Signature/UpdateSignature.dart';
import 'package:mymfbox2_0/Investor/Registration/Signature/UserSignatureArea.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/onBoarding/CommonOnBoardApi.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../../login/CheckUserType.dart';
import '../RegistrationSuccessful.dart';

class Signature extends StatefulWidget {
  const Signature({super.key});

  @override
  State<Signature> createState() => _SignatureState();
}

class _SignatureState extends State<Signature> {
  String user_name = GetStorage().read("user_name") ?? "";
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  Map client_code_map = GetStorage().read('client_code_map');

  GlobalKey<SfSignaturePadState> key = GlobalKey<SfSignaturePadState>();

/*  Map existingSign = {};
  Future getSignature() async {
    Map data = await CommonOnBoardApi.getSignature(
        client_name: client_name,
        user_id: user_id,
        user_type: "Primary Holder");

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    existingSign = data['result'];
    return 0;
  }*/

  @override
  Widget build(BuildContext context) {

    return Scaffold(

            backgroundColor: Config.appTheme.mainBgColor,
            appBar: rpAppBar(
                title: "Signature",
                bgColor: Config.appTheme.themeColor,
                foregroundColor: Colors.white),
            body: Column(
              children: [
                (signatureImg != null) ? imgCard() : emptyCard(),
                SizedBox(height: 16),
                if (signatureImg != null)
                  CalculateButton(
                      onPress: () async {
                        String fileName = await uploadSignature(context);
                        int res = await saveSignature(fileName);
                        if (res == 0) Get.back();

                        EasyLoading.show();
                        Map uploaddata = await CommonOnBoardApi.uploadBseAOF(
                          user_id: user_id,
                          client_name: client_name,
                          bse_nse_mfu_flag: "BSE",
                        );
                        if (uploaddata['status'] != 200) {
                          Utils.showError(context, uploaddata['msg']);
                          return -1;
                        }
                        String uploadurl = uploaddata['msg'];

                        EasyLoading.dismiss();
                        Get.offAll(() => CheckUserType());
                        Get.to(() => RegistrationSuccessful(msg: uploadurl));

                      },
                      text: "Continue")
              ],
            ),
          );

  }

  Future uploadSignature(BuildContext context) async {
    Map data = await CommonOnBoardApi.uploadSignature(
        client_name: client_name,
        user_id: user_id,
        user_type: "Primary Holder",
        file_path: signatureImg!.path);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return "";
    }
    Map result = data['result'];
    String fileName = result['file_name'];
    return fileName;
  }

  Future saveSignature(String fileName) async {
    Map data = await CommonOnBoardApi.saveSignatureImage(
        user_id: user_id,
        client_name: client_name,
        user_type: "Primary holder",
        file_name: fileName);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    return 0;
  }



  Widget emptyCard() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset("assets/registration/n1.png", height: 32),
              SizedBox(width: 10),
              ColumnText(
                title: "Primary Holder",
                value: user_name,
                titleStyle: AppFonts.f50014Black,
                valueStyle: AppFonts.f40013,
              )
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Config.appTheme.mainBgColor,
            ),
            child: Column(
              children: [
                Image.asset("assets/registration/signature_info.png",
                    height: 32, color: Colors.grey),
                Text("No Signature Added", style: AppFonts.f40013),
                SizedBox(height: 16),
                RpFilledButton(
                    text: "SIGN NOW",
                    onPressed: () {
                      showUploadOption();
                    },
                    padding: EdgeInsets.symmetric(vertical: 10))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget imgCard() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset("assets/registration/n1.png", height: 32),
              SizedBox(width: 10),
              ColumnText(
                title: "Primary Holder",
                value: user_name,
                titleStyle: AppFonts.f50014Black,
                valueStyle: AppFonts.f40013,
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  showUploadOption();
                },
                child: Text("Retake",
                    style: AppFonts.f40013.copyWith(
                        color: Config.appTheme.themeColor,
                        decoration: TextDecoration.underline)),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Config.appTheme.mainBgColor,
            ),
            child: SizedBox(
              height: 200,
              width: double.maxFinite,
              child: Image.file(
                signatureImg!,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }

  File? signatureImg;
  showUploadOption() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Config.appTheme.mainBgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      )),
      builder: (context) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Upload Signature",
                      style: AppFonts.f50014Black.copyWith(fontSize: 18)),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Get.back();
                    },
                  )
                ],
              ),
            ),

            // RpListTile(title: Text("data"),subTitle: Text(),)
            Column(
              children: [
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: ListTile(
                    onTap: () async {
                      await getImageFromUser(source: ImageSource.gallery);
                    },
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    leading: Icon(Icons.image_outlined,
                        color: Config.appTheme.themeColor, size: 28),
                    title: Text("Upload From Gallery",
                        style: AppFonts.f50014Black
                            .copyWith(color: Config.appTheme.themeColor)),
                    subtitle: Text("Upload Signature done on white paper"),
                    subtitleTextStyle: AppFonts.f40013,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: ListTile(
                    onTap: () async {
                      await getImageFromUser(source: ImageSource.camera);
                    },
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    leading: Icon(Icons.image_outlined,
                        color: Config.appTheme.themeColor, size: 28),
                    title: Text("Open Camera",
                        style: AppFonts.f50014Black
                            .copyWith(color: Config.appTheme.themeColor)),
                    subtitle: Text("Sign on white paper and click from camera"),
                    subtitleTextStyle: AppFonts.f40013,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: ListTile(
                    onTap: () {
                      Get.to(() => UserSignatureArea())!.then((value) {
                        if (value == null) return;

                        print("came back from sign");
                        signatureImg = File(value.path);
                        Get.back();
                        setState(() {});
                        print("came back from sign ended");
                      });
                    },
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    leading: Icon(Icons.draw,
                        color: Config.appTheme.themeColor, size: 28),
                    title: Text("Sign Digitally",
                        style: AppFonts.f50014Black
                            .copyWith(color: Config.appTheme.themeColor)),
                    subtitle: Text(
                        "Sign digitally on screen as your hand signature."),
                    subtitleTextStyle: AppFonts.f40013,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future getImageFromUser({required ImageSource source}) async {
    XFile? xFile = await ImagePicker().pickImage(source: source);

    if (xFile == null) return;

    signatureImg = File(xFile.path);
    Get.back();
    setState(() {});
  }
}
