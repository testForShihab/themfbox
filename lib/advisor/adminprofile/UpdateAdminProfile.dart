// ignore_for_file: unnecessary_this

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'AdminProfile.pojo.dart';

class UpdateAdminProfile extends StatefulWidget {
  final DetailsPojo detailsPojo;
  const UpdateAdminProfile({Key? key, required this.detailsPojo})
      : super(key: key);

  @override
  State<UpdateAdminProfile> createState() => _UpdateAdminProfileState();
}

class _UpdateAdminProfileState extends State<UpdateAdminProfile> {
  bool investorcredential = false;
  late String checkCredential;
  DetailsPojo oldDetailsPojo = DetailsPojo();
  UpdateProfileDetailsPojo newDeatilsPojo = UpdateProfileDetailsPojo();
  String client_name = GetStorage().read('client_name');

  List fundlist = [
    "Regular Growth Plan",
    "Regular Growth & Dividend Plan",
    "Regular Plan & Direct Plan"
  ];
  String? selectedfundlist = "Select Fund Type";

  @override
  void initState() {
    //  implement initState
    super.initState();
    oldDetailsPojo = widget.detailsPojo;
    Map<String, dynamic> temp = oldDetailsPojo.toJson();
    newDeatilsPojo = UpdateProfileDetailsPojo.fromJson(temp);

    if (oldDetailsPojo.fundType == "1") {
      selectedfundlist = "Regular Growth Plan";
    } else if (oldDetailsPojo.fundType == "2") {
      selectedfundlist = "Regular Growth & Dividend Plan";
    } else if (oldDetailsPojo.fundType == "3") {
      selectedfundlist = "Regular Growth & Direct Plan";
    }
  }

  Future updateProfile() async {
    newDeatilsPojo.clientName = client_name;
    Map data = await AdminApi.updateProfile(inputData: newDeatilsPojo.toJson());
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Profile",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  AmountInputCard(
                    title: "Company Name",
                    suffixText: "",
                    hintTitle: "Name",
                    hasSuffix: false,
                    initialValue: oldDetailsPojo.companyName,
                    keyboardType: TextInputType.name,
                    borderRadius: BorderRadius.circular(20),
                    onChange: (val) => newDeatilsPojo.companyName = val,
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Company Phone",
                    suffixText: "",
                    maxLength: 10,
                    hasSuffix: false,
                    hintTitle: "Enter Company Phone Number",
                    initialValue: oldDetailsPojo.companyPhone,
                    keyboardType: TextInputType.phone,
                    borderRadius: BorderRadius.circular(20),
                    onChange: (val) => newDeatilsPojo.companyPhone = val,
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Company Email ",
                    suffixText: "",
                    hintTitle: "Email",
                    hasSuffix: false,
                    initialValue: oldDetailsPojo.companyMail,
                    keyboardType: TextInputType.emailAddress,
                    borderRadius: BorderRadius.circular(20),
                    onChange: (val) => newDeatilsPojo.companyMail = val,
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Company Address 1",
                    suffixText: "",
                    hintTitle: "Enter Address Line 1",
                    hasSuffix: false,
                    initialValue: oldDetailsPojo.companyAddress1,
                    keyboardType: TextInputType.streetAddress,
                    borderRadius: BorderRadius.circular(20),
                    onChange: (val) => newDeatilsPojo.companyAddress1 = val,
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Company Address 2",
                    suffixText: "",
                    hintTitle: "Enter Address Line 2",
                    hasSuffix: false,
                    initialValue: oldDetailsPojo.companyAddress2,
                    keyboardType: TextInputType.streetAddress,
                    borderRadius: BorderRadius.circular(20),
                    onChange: (val) => newDeatilsPojo.companyAddress2 = val,
                  ),
                  SizedBox(height: 16),
                  DottedLine(),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Mail Sender Name",
                    initialValue: oldDetailsPojo.senderName,
                    suffixText: "",
                    hintTitle: 'Name',
                    hasSuffix: false,
                    keyboardType: TextInputType.name,
                    borderRadius: BorderRadius.circular(20),
                    onChange: (val) => newDeatilsPojo.senderName,
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Mail Sender Email",
                    suffixText: "",
                    initialValue: oldDetailsPojo.senderMail,
                    hintTitle: 'Email',
                    hasSuffix: false,
                    keyboardType: TextInputType.emailAddress,
                    borderRadius: BorderRadius.circular(20),
                    onChange: (val) => newDeatilsPojo.senderMail,
                  ),
                  SizedBox(height: 16),
                  ExpansionTile(
                    collapsedBackgroundColor: Colors.white,
                    collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.white,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Fund Type", style: AppFonts.f50014Black),
                        Text("$selectedfundlist",
                            style: AppFonts.f50012
                                .copyWith(color: Config.appTheme.themeColor)),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, top: 5, right: 16, bottom: 5),
                        child: DottedLine(),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: fundlist.length,
                        itemBuilder: (context, index) {
                          String selectedOption = fundlist[index];
                          return Row(
                            children: [
                              Radio(
                                  activeColor: Config.appTheme.themeColor,
                                  value: selectedOption,
                                  groupValue: selectedfundlist,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedfundlist = value as String?;
                                      if (selectedfundlist!
                                          .contains("Regular Growth Plan")) {
                                        newDeatilsPojo.fundType = "1";
                                      } else if (selectedfundlist!.contains(
                                          "Regular Growth & Dividend Plan")) {
                                        newDeatilsPojo.fundType = "2";
                                      } else if (selectedfundlist!.contains(
                                          "Regular Growth & Direct Plan")) {
                                        newDeatilsPojo.fundType = "3";
                                      }
                                    });
                                  }),
                              Text(selectedOption)
                            ],
                          );
                        },
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          activeColor: Config.appTheme.themeColor,
                          value: investorcredential,
                          onChanged: (val) {
                            setState(() {
                              investorcredential = val!;
                              print("Val $val");
                              print("investor credential $investorcredential");

                              if (investorcredential) {
                                newDeatilsPojo.credentialFlag = "1";
                              } else {
                                newDeatilsPojo.credentialFlag = "0";
                              }
                              print(
                                  "credentialFlag ${newDeatilsPojo.credentialFlag}");
                            });
                          }),
                      SizedBox(width: 10),
                      Text("Investor Credentials",
                          style: AppFonts.f50012.copyWith(color: Colors.black))
                    ],
                  ),
                  Container(
                    color: Colors.white,
                    height: 80,
                    padding: EdgeInsets.all(16),
                    child: RpFilledButton(
                      text: 'Update Details',
                      color: Config.appTheme.buttonColor,
                      onPressed: () async {
                        int res = await updateProfile();
                        if (res == -1) return;

                        showCupertinoDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Success'),
                            content: Text(
                                "Profile Details are Updated Successfully."),
                            actions: [
                              TextButton(
                                child: Text("Ok"),
                                onPressed: () {
                                  Get.back();
                                  Get.back();
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UpdateProfileDetailsPojo {
  String? clientName;
  String? companyName;
  String? companyPhone;
  String? companyMail;
  String? companyAddress1;
  String? companyAddress2;
  String? senderName;
  String? senderMail;
  String? credentialFlag;
  String? fundType;

  UpdateProfileDetailsPojo({
    this.clientName,
    this.companyName,
    this.companyPhone,
    this.companyMail,
    this.companyAddress1,
    this.companyAddress2,
    this.senderName,
    this.senderMail,
    this.credentialFlag,
    this.fundType,
  });

  UpdateProfileDetailsPojo.fromJson(Map<String, dynamic> json) {
    clientName = json['client_name'];
    companyName = json['company_name'];
    companyPhone = json['company_phone'];
    companyMail = json['company_mail'];
    companyAddress1 = json['company_address1'];
    companyAddress2 = json['company_address2'];
    senderName = json['sender_name'];
    senderMail = json['sender_mail'];
    credentialFlag = json['credential_flag'];
    fundType = json['fund_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['client_name'] = this.clientName;
    data['company_name'] = this.companyName;
    data['company_phone'] = this.companyPhone;
    data['company_mail'] = this.companyMail;
    data['company_address1'] = this.companyAddress1;
    data['company_address2'] = this.companyAddress2;
    data['sender_name'] = this.senderName;
    data['sender_mail'] = this.senderMail;
    data['credential_flag'] = this.credentialFlag;
    data['fund_type'] = this.fundType;
    return data;
  }
}
