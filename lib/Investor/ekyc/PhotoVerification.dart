import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/EkycApi.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class PhotoVerification extends StatefulWidget {
  const PhotoVerification({super.key});

  @override
  State<PhotoVerification> createState() => _PhotoVerificationState();
}

class _PhotoVerificationState extends State<PhotoVerification> {
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
        title: "Photo Verification",
        bgColor: Config.appTheme.themeColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Upload or capture your photo using camera.",
                style: AppFonts.f40013),
            (userImg != null) ? imgCard() : emptyCard(),
          ],
        ),
      ),
      bottomSheet: Visibility(
        visible: userImg != null,
        child: CalculateButton(
          onPress: () async {
            String res = await uploadFileImage();
            if (res.isEmpty) return;
            int temp = await uploadPhotoImage(res);
            if (temp == 0) Get.back();
          },
          text: "CONTINUE",
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }

  File? userImg;
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
              BottomSheetTitle(title: "Upload Photo"),
              Column(
                children: [
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
                ],
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

  Future uploadFileImage() async {
    EasyLoading.show();

    Map data = await EkycApi.uploadFileImage(
      user_id: user_id,
      client_name: client_name,
      image_type: "user_image",
      file_path: userImg!.path,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return "";
    }

    EasyLoading.dismiss();
    return data['msg'];
  }

  Future uploadPhotoImage(String res) async {
    EasyLoading.show();
    Map data = await EkycApi.uploadPhotoImage(
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

  Future getImageFromUser({required ImageSource source}) async {
    XFile? xFile = await ImagePicker().pickImage(source: source);

    if (xFile == null) return;

    userImg = File(xFile.path);
    Get.back();
    setState(() {});
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
                userImg!,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ],
      ),
    );
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
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Config.appTheme.mainBgColor,
            ),
            child: Column(
              children: [
                Image.asset("assets/registration/photo_verification.png",
                    height: 32, color: Colors.grey),
                Text("No Photo Added", style: AppFonts.f40013),
                SizedBox(height: 16),
                RpFilledButton(
                    text: "ADD NOW",
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
}
