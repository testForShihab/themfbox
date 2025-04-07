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

class FinalAadhar extends StatefulWidget {
  const FinalAadhar({super.key});

  @override
  State<FinalAadhar> createState() => _FinalAadharState();
}

class _FinalAadharState extends State<FinalAadhar> {
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  String ekyc_id = GetStorage().read("ekyc_id");

  AadharCardPojo aadharCardPojo = AadharCardPojo();
  TextEditingController dobController = TextEditingController();

  RxBool panLoading = true.obs;
  RxString panError = "".obs;
  Future getDigiLockerPanDetails() async {
    if (aadharCardPojo.msg != null) return 0;

    panLoading.value = true;

    await Future.delayed(Duration(seconds: 2));

    Map data = await EkycApi.getDigiLockerAadhaarDetails(
        user_id: user_id, client_name: client_name, ekyc_id: ekyc_id);

    if (data['status'] != 200) {
      panError.value = data['msg'] ?? "Api Exception";
      panLoading.value = false;
      return -1;
    }

    aadharCardPojo = AadharCardPojo.fromJson(data as Map<String, dynamic>);

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
              title: "Proof Of Address",
              bgColor: Config.appTheme.themeColor,
              foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Fetch AADHAR from DigiLocker",
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
                              "Your AADHAR Details have been fetched from DigiLocker.",
                              style: AppFonts.f50014Theme),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    detailsCard(),
                    SizedBox(height: 16),
                    // fatherNameCard(),
                    // SizedBox(height: 16),
                    // if (panLoading.isFalse && aadharCardPojo.dob!.isEmpty)
                    //   dateInput(
                    //     title: "DOB",
                    //     controller: dobController,
                    //     onTap: () async {
                    //       DateTime? dob = await showDatePicker(
                    //         context: context,
                    //         initialDate: DateTime(2002, 06, 18),
                    //         firstDate: DateTime(1890),
                    //         lastDate: DateTime.now(),
                    //       );
                    //       if (dob == null) return;

                    //       aadharCardPojo.dob = convertDtToStr(dob);
                    //       dobController.text = convertDtToStr(dob);
                    //       setState(() {});
                    //     },
                    //   ),
                    // SizedBox(height: 16),
                    Text(
                        "Note: Please check the auto-filled data before you proceed.",
                        style: AppFonts.f50012.copyWith(
                            color: Config.appTheme.readableGreyTitle)),
                    SizedBox(height: 16),
                    RpFilledButton(
                      text: "CONTINUE",
                      onPressed: () async {
                        int res = await saveAadhar();
                        if (res == 0) {
                          for (int i = 0; i < 2; i++) Get.back();
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

    String fatherName = aadharCardPojo.fatherName ?? "";

    if (fatherName.isNotEmpty) return SizedBox();

    return AmountInputCard(
      title: "Father's Name",
      suffixText: "",
      hasSuffix: false,
      keyboardType: TextInputType.name,
      borderRadius: BorderRadius.circular(20),
      onChange: (val) => aadharCardPojo.fatherName = val,
      maxLength: 10,
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
              "${aadharCardPojo.pdfUrl}"),
        ),
      );
    });
  }

  Widget detailsCard() {
    return Obx(() {
      if (panLoading.isTrue)
        return Utils.shimmerWidget(300, margin: EdgeInsets.zero);
      if (panError.isNotEmpty) return Text(panError.value);

      String name = aadharCardPojo.name ?? "";
      String dob = aadharCardPojo.dob ?? "";
      String aadhar = aadharCardPojo.aadhaarLastFour ?? "";

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
            localColumnText("Name as on PAN", "${aadharCardPojo.name}"),
            localColumnText("DOB", "${aadharCardPojo.dob}"),
            localColumnText("AADHAR", "${aadharCardPojo.aadhaarLastFour}"),
            localColumnText("Address", "${aadharCardPojo.address}",
                bottomPadding: 0),
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

  Future saveAadhar() async {
    EasyLoading.show();
    Map data = await EkycApi.updateAadhaar(
        user_id: user_id,
        client_name: client_name,
        district: "district",
        name: "${aadharCardPojo.name}",
        ekyc_id: ekyc_id,
        father_name: "${aadharCardPojo.fatherName}",
        dob: "${aadharCardPojo.dob}",
        city: "${aadharCardPojo.addressDetails!.city}",
        pincode: "${aadharCardPojo.addressDetails!.pincode}",
        state: "${aadharCardPojo.addressDetails!.state}",
        address: "${aadharCardPojo.address}",
        aadhaar: "${aadharCardPojo.aadhaarLastFour}");

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    await updateSameAddress();
    EasyLoading.dismiss();

    return 0;
  }

  Future updateSameAddress() async{
    EasyLoading.show();
    Map data = await EkycApi.updateSameAddress(user_id: user_id, client_name: client_name, ekyc_id: ekyc_id);

    if(data['status'] != 200){
      Utils.showError(context, data['msg']);
      return -1;
    }
      EasyLoading.dismiss();
      return 0;
  }
}

class AadharCardPojo {
  int? status;
  String? statusMsg;
  String? msg;
  String? ekycId;
  String? pdfUrl;
  String? name;
  String? dob;
  String? fatherName;
  String? aadhaarLastFour;
  String? address;
  AddressDetails? addressDetails;

  AadharCardPojo(
      {this.status,
      this.statusMsg,
      this.msg,
      this.ekycId,
      this.pdfUrl,
      this.name,
      this.dob,
      this.fatherName,
      this.aadhaarLastFour,
      this.address,
      this.addressDetails});

  AadharCardPojo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    ekycId = json['ekyc_id'];
    pdfUrl = json['pdf_url'];
    name = json['name'];
    dob = json['dob'];
    fatherName = json['father_name'];
    aadhaarLastFour = json['aadhaar_last_four'];
    address = json['address'];
    addressDetails = json['address_details'] != null
        ? AddressDetails.fromJson(json['address_details'])
        : null;
  }
}

class AddressDetails {
  String? address;
  String? city;
  String? district;
  String? state;
  String? stateCode;
  String? country;
  String? countryCode;
  String? pincode;

  AddressDetails(
      {this.address,
      this.city,
      this.district,
      this.state,
      this.stateCode,
      this.country,
      this.countryCode,
      this.pincode});

  AddressDetails.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    city = json['city'];
    district = json['district'];
    state = json['state'];
    stateCode = json['state_code'];
    country = json['country'];
    countryCode = json['country_code'];
    pincode = json['pincode'];
  }
}
