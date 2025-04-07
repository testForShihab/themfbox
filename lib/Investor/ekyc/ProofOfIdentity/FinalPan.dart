import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/EkycApi.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class FinalPan extends StatefulWidget {
  const FinalPan({super.key});

  @override
  State<FinalPan> createState() => _FinalPanState();
}

class _FinalPanState extends State<FinalPan> {
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  String ekyc_id = GetStorage().read("ekyc_id");

  PanCardPojo panCardPojo = PanCardPojo();
  TextEditingController dobController = TextEditingController();

  String father_name = "";
  DateTime? dob;

  RxBool panLoading = true.obs;
  RxString panError = "".obs;
  Future getDigiLockerPanDetails() async {
    if (panCardPojo.msg != null) return 0;

    panLoading.value = true;

    await Future.delayed(Duration(seconds: 2));

    Map data = await EkycApi.getDigiLockerPanDetails(
        user_id: user_id, client_name: client_name, ekyc_id: ekyc_id);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      panError.value = data['msg'] ?? "Api Exception";
      panLoading.value = false;
      return -1;
    }

    panCardPojo = PanCardPojo.fromJson(data as Map<String, dynamic>);

    panLoading.value = false;

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDigiLockerPanDetails(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: rpAppBar(
              title: "Proof Of Identity",
              bgColor: Config.appTheme.themeColor,
              foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Fetch PAN from DigiLocker",
                        style: AppFonts.f50014Grey),
                    SizedBox(height: 16),
                    pdfArea(),
                    SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/registration/investor_information.png",
                          width: 32,
                          color: Config.appTheme.themeColor,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                              "Your PAN Details have been fetched from DigiLocker.",
                              style: AppFonts.f50014Theme),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    detailsCard(),
                    SizedBox(height: 16),
                    fatherNameCard(),
                    SizedBox(height: 16),
                    if (panLoading.isFalse &&
                        panCardPojo.dob != null &&
                        panCardPojo.dob!.isEmpty)
                      dateInput(
                        title: "DOB",
                        controller: dobController,
                        onTap: () async {
                          dob = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2002, 06, 18),
                            firstDate: DateTime(1890),
                            lastDate: DateTime.now(),
                          );
                          if (dob == null) return;

                          dobController.text = convertDtToStr(dob!);
                          setState(() {});
                        },
                      ),
                    SizedBox(height: 16),
                    Text(
                        "Note: Please check the auto-filled data before you proceed.",
                        style: AppFonts.f50012.copyWith(
                            color: Config.appTheme.readableGreyTitle)),
                    SizedBox(height: 16),
                    if (panCardPojo.invName != null)
                      RpFilledButton(
                        text: "CONTINUE",
                        onPressed: () async {
                          int res = await savePan();
                          if (res == 0) {
                            for (int i = 0; i < 3; i++) Get.back();
                          }
                        },
                        padding: EdgeInsets.symmetric(vertical: 12),
                      )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget fatherNameCard() {
    if (panLoading.isTrue) return SizedBox();

    String temp = panCardPojo.fatherName ?? "";

    if (temp.isNotEmpty) return SizedBox();

    return AmountInputCard(
      title: "Father's Name",
      suffixText: "",
      hasSuffix: false,
      keyboardType: TextInputType.name,
      borderRadius: BorderRadius.circular(20),
      onChange: (val) => father_name = val,
      initialValue: "",
    );
  }

  Widget dateInput(
      {required String title,
      Function()? onTap,
      String? initialValue,
      TextEditingController? controller}) {
    OutlineInputBorder borderStyle = OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.lineColor),
        borderRadius: BorderRadius.circular(20));

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppFonts.f50014Black),
          SizedBox(height: 5),
          TextFormField(
            readOnly: true,
            onTap: onTap,
            controller: controller,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                focusedBorder: borderStyle,
                enabledBorder: borderStyle),
          ),
        ],
      ),
    );
  }

  Widget pdfArea() {
    return Obx(() {
      if (panLoading.isTrue)
        return Utils.shimmerWidget(300, margin: EdgeInsets.zero);
      if (panError.isNotEmpty) return Text(panError.value);

      return SizedBox(
        height: 400,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: PDF().cachedFromUrl(
              placeholder: (progress) =>
                  Utils.shimmerWidget(400, margin: EdgeInsets.zero),
              errorWidget: (error) {
                return Text("Error = $error");
              },
              "${panCardPojo.pdfUrl}"),
        ),
      );
    });
  }

  Widget detailsCard() {
    return Obx(() {
      if (panLoading.isTrue)
        return Utils.shimmerWidget(300, margin: EdgeInsets.zero);
      if (panError.isNotEmpty) return Text(panError.value);

      String name = panCardPojo.invName ?? "";
      String dob = panCardPojo.dob ?? "";
      String pan = panCardPojo.pan ?? "";
      String fatherName = panCardPojo.fatherName ?? "";

      return Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("The details are as follows:", style: AppFonts.f50014Black),
            SizedBox(height: 16),
            localColumnText("Name as on PAN", name),
            localColumnText("DOB", dob),
            localColumnText("PAN", pan),
            localColumnText("Father's Name", fatherName, bottomPadding: 0),
          ],
        ),
      );
    });
  }

  Widget localColumnText(String title, String value,
      {double bottomPadding = 16}) {
    if (value.isEmpty) return SizedBox();

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: ColumnText(title: title, value: value),
    );
  }

  Future savePan() async {
    if (panCardPojo.fatherName!.isEmpty) panCardPojo.fatherName = father_name;
    if (panCardPojo.dob!.isEmpty) panCardPojo.dob = convertDtToStr(dob!);

    EasyLoading.show();
    Map data = await EkycApi.updatePan(
      user_id: user_id,
      client_name: client_name,
      pan: "${panCardPojo.pan}",
      name: "${panCardPojo.invName}",
      ekyc_id: ekyc_id,
      father_name: "${panCardPojo.fatherName}",
      dob: "${panCardPojo.dob}",
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    EasyLoading.dismiss();

    return 0;
  }
}

class PanCardPojo {
  int? status;
  String? statusMsg;
  String? msg;
  String? ekycId;
  String? imagePath;
  String? invName;
  String? pan;
  String? fatherName;
  String? dob;
  // Null? ePanResponse;
  String? pdfUrl;

  PanCardPojo(
      {this.status,
      this.statusMsg,
      this.msg,
      this.ekycId,
      this.imagePath,
      this.invName,
      this.pan,
      this.fatherName,
      this.dob,
      // this.ePanResponse,
      this.pdfUrl});

  PanCardPojo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    ekycId = json['ekyc_id'];
    imagePath = json['imagePath'];
    invName = json['inv_name'];
    pan = json['pan'];
    fatherName = json['father_name'];
    dob = json['dob'];
    // ePanResponse = json['ePanResponse'];
    pdfUrl = json['pdf_url'];
  }
}
