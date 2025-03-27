import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mymfbox2_0/Investor/Registration/Signature/UserSignatureArea.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/EkycApi.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class EkycSignature extends StatefulWidget {
  const EkycSignature({super.key});

  @override
  State<EkycSignature> createState() => _EkycSignatureState();
}

class _EkycSignatureState extends State<EkycSignature> {
  String user_name = GetStorage().read("user_name") ?? "";
  String client_name = GetStorage().read("client_name");
  int user_id = GetStorage().read("user_id");
  String ekyc_id = GetStorage().read("ekyc_id");
  String user_pan = GetStorage().read("user_pan");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Signature",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
                "Upload your scanned signature image or put your signature using scribbling pad.",
                style: AppFonts.f40013),
            (signatureImg != null) ? imgCard() : emptyCard(),
          ],
        ),
      ),
      bottomSheet: Visibility(
        visible: signatureImg != null,
        child: CalculateButton(
          onPress: () async {
            String res = await uploadFileImage();
            if (res.isEmpty) return;
            int temp = await uploadSignatureImage(res);
            if (temp == 0) Get.back();
          },
          text: "CONTINUE",
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  Future uploadFileImage() async {
    EasyLoading.show();

    Map data = await EkycApi.uploadFileImage(
      user_id: user_id,
      client_name: client_name,
      image_type: "signature",
      file_path: signatureImg!.path,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return "";
    }

    EasyLoading.dismiss();
    return data['msg'];
  }

  Future uploadSignatureImage(String res) async {
    EasyLoading.show();
    Map data = await EkycApi.uploadSignatureImage(
      user_id: user_id,
      client_name: client_name,
      ekyc_id: ekyc_id,
      image_name: res,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    EasyLoading.dismiss();
    return 0;
  }

  Widget emptyCard() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 16),
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
                title: user_name,
                value: user_pan,
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
      margin: EdgeInsets.only(top: 16),
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
                title: user_name,
                value: user_pan,
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
      isScrollControlled: true,
      backgroundColor: Config.appTheme.mainBgColor,
      shape: RoundedRectangleBorder(borderRadius: cornerBorder),
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              BottomSheetTitle(title: "Upload Signature"),
              SizedBox(height: 16),
              uploadTile(
                title: "Upload From Gallery",
                subTitle: "Upload Signature done on white paper",
                onTap: () async =>
                    await getImageFromUser(source: ImageSource.gallery),
              ),
              uploadTile(
                title: "Open Camera",
                subTitle: "Sign on white paper and click from camera",
                onTap: () async =>
                    await getImageFromUser(source: ImageSource.camera),
              ),
              uploadTile(
                title: "Sign Digitally",
                subTitle: "Sign digitally on screen as your hand signature.",
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
              ),
            ],
          ),
        );
      },
    );
  }

  Widget uploadTile({
    required String title,
    required String subTitle,
    required Function() onTap,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ListTile(
        onTap: onTap,
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: Icon(Icons.image_outlined,
            color: Config.appTheme.themeColor, size: 28),
        title: Text(title,
            style: AppFonts.f50014Black
                .copyWith(color: Config.appTheme.themeColor)),
        subtitle: Text(subTitle),
        subtitleTextStyle: AppFonts.f40013,
      ),
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
