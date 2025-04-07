import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/onBoarding/CommonOnBoardApi.dart';
import 'package:mymfbox2_0/api/onBoarding/nse/NseOnBoardApi.dart';
import 'package:mymfbox2_0/pojo/JointHolderPojo.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/CalculateButton.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpSmallTf.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import 'add_joint_holder_info_details_page.dart';

class JointHolderInfo extends StatefulWidget {
  const JointHolderInfo({super.key});

  @override
  State<JointHolderInfo> createState() => _JointHolderInfoState();
}

class _JointHolderInfoState extends State<JointHolderInfo> {
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  String bse_nse_mfu_flag = Get.arguments ?? " ";

  String mobileRelation = "";
  String mobileRelationCode = "";

  String emailRelation = "";
  String emailRelationCode = "";

  String birthCountry = "India";
  String birthCountryCode = "IN";

  String employementStatus = "Agriculturist";
  String employementStatusCode = "4";

  String annualSalary = "Below 1 Lakh";
  String annualSalaryCode = "BL";

  String incomeSource = "";
  String incomeSourceCode = "";

  String politicalRelation = "";
  String politicalRelationCode = "";

  TextStyle successStyle = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 12, color: AppColors.textGreen);
  TextStyle errorStyle = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 12, color: AppColors.lossRed);

  ExpansionTileController mobileRelationController = ExpansionTileController();
  ExpansionTileController countryOfBrithController = ExpansionTileController();
  ExpansionTileController genderController = ExpansionTileController();
  ExpansionTileController emailRelationController = ExpansionTileController();
  ExpansionTileController empStatusController = ExpansionTileController();
  ExpansionTileController annualSalaryController = ExpansionTileController();
  ExpansionTileController sourceIncomeController = ExpansionTileController();
  ExpansionTileController politicalRelationshipController =
      ExpansionTileController();

  Future checkPanKycStatus(String pan) async {
    EasyLoading.show();

    Map data = await CommonOnBoardApi.checkPanKycStatus(
        user_id: user_id, client_name: client_name, pan: pan);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    EasyLoading.dismiss();

    return data['msg'];
  }

  List mobileRelationList = [];

  Future getRelationList() async {
    if (mobileRelationList.isNotEmpty) return -1;

    Map data = await CommonOnBoardApi.getEmailOrMobileRelation(
        client_name: client_name, bse_nse_mfu_flag: bse_nse_mfu_flag);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    mobileRelationList = data['list'];

    return 0;
  }

  List countryList = [];

  Future getCountryList() async {
    if (countryList.isNotEmpty) return -1;

    // Map data = await CommonOnBoardApi.getCountryList(
    //     user_id: user_id,
    //     client_name: client_name,
    //     bse_nse_mfu_flag: bse_nse_mfu_flag);
    //
    // if (data['status'] != 200) {
    //   Utils.showError(context, data['msg']);
    //   return -1;
    // }
    //
    // countryList = data['list'];

    return 0;
  }

  Future saveJointHolderInfo(List<String> list) async {
    Map data = await NseOnBoardApi.saveJointHolderInfo(
        user_id: user_id,
        client_name: client_name,
        investor_id: user_id,
        joint_holder_details: list,
        bse_nse_mfu_flag: bse_nse_mfu_flag);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    return 0;
  }

  Future getAddressList() async {
    if (addressTypeList.isNotEmpty) return -1;

    Map data = await CommonOnBoardApi.getAddressType(
        client_name: client_name, bse_nse_mfu_flag: bse_nse_mfu_flag);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    addressTypeList = data['list'];

    return 0;
  }

  List empStatusList = [];

  Future getEmpStatusList() async {
    if (empStatusList.isNotEmpty) return -1;

    Map data = await CommonOnBoardApi.getEmploymentStatus(
        client_name: client_name, bse_nse_mfu_flag: bse_nse_mfu_flag);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    empStatusList = data['list'];

    return 0;
  }

  List annualSalaryList = [];

  Future getAnnualSalaryList() async {
    if (annualSalaryList.isNotEmpty) return -1;

    Map data = await CommonOnBoardApi.getAnnualSalary(
        client_name: client_name, bse_nse_mfu_flag: bse_nse_mfu_flag);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    annualSalaryList = data['list'];

    return 0;
  }

  List incomeSourceList = [];

  Future getIncomeSourceList() async {
    if (incomeSourceList.isNotEmpty) return -1;

    Map data = await CommonOnBoardApi.getSourceOfIncome(
        client_name: client_name, bse_nse_mfu_flag: bse_nse_mfu_flag);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    incomeSourceList = data['list'];

    return 0;
  }

  List politicalRelationList = [];

  Future getPoliticalRelationList() async {
    if (politicalRelationList.isNotEmpty) return -1;

    Map data = await CommonOnBoardApi.getPoliticalRelationship(
        client_name: client_name, bse_nse_mfu_flag: bse_nse_mfu_flag);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    politicalRelationList = data['list'];

    return 0;
  }

  showBtmSheet(
    context,
  ) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (context) {
          return AspectRatio(
            aspectRatio: 2 / 3.5,
            child: AddJoinHolderInfoDetailPage(
              modelId: 0,
              model: JointHolderPojo(),
              title: 'title',
              userId: user_id,
              bseNseMfuFlag: bse_nse_mfu_flag,
              clientName: client_name,
            ),
          );
        });
  }

  Future getDatas() async {
    // await getRelationList();
    // await getCountryList();
    // await getEmpStatusList();
    // await getAddressList();
    // await getAnnualSalaryList();
    // await getIncomeSourceList();
    // await getPoliticalRelationList();
    return 0;
  }

  List<JointHolderPojo> jointHoldersList = [];
  late double devHeight, devWidth;

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;
    devHeight = MediaQuery.sizeOf(context).height;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: rpAppBar(
                title: 'Joint Holder Info',
                bgColor: Config.appTheme.themeColor,
                foregroundColor: Colors.white),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (jointHoldersList.isEmpty)
                        applicantCard(
                            title: "2nd",
                            img: "assets/applicant2.png",
                            trailing: addButton("2nd"),
                            onTap: () {
                              showBtmSheet(context);
                            }),
                      Visibility(
                        visible: jointHoldersList.isNotEmpty,
                        child: ListView.builder(
                          itemCount: jointHoldersList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            String title = (index == 0) ? "2nd" : "3rd";
                            String img = "assets/applicant${index + 2}.png";

                            return applicantCard(
                                onTap: () {
                                  showBtmSheet(context);
                                },
                                title: title,
                                img: img,
                                trailing: removeButton(index));
                          },
                        ),
                      ),
                      Visibility(
                        visible: jointHoldersList.length == 1,
                        child: PlainButton(
                          text: "Add 3rd Applicant",
                          onPressed: () {
                            addBottomSheet("3rd");
                          },
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Visibility(
                    visible: jointHoldersList.isNotEmpty,
                    child: CalculateButton(
                        onPress: () async {
                          List<String> list = [];
                          jointHoldersList.forEach((element) {
                            Map<String, dynamic> data = element.toJson();
                            list.add(jsonEncode(data));
                          });
                          int res = await saveJointHolderInfo(list);
                          if (res == 0) Get.back();
                        },
                        text: "CONTINUE"))
              ],
            ),
          );
        });
  }

  Widget applicantCard({
    required String title,
    required String img,
    Widget trailing = const SizedBox(),
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Image.asset(img, height: 32),
            SizedBox(width: 10),
            Text("$title Applicant", style: AppFonts.f50014Black),
            Spacer(),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget addButton(String title) {
    return InkWell(
      onTap: () {
        addBottomSheet(title);
      },
      child: Text(
        "Add",
        style: AppFonts.f40013.copyWith(
            color: Config.appTheme.themeColor,
            decoration: TextDecoration.underline),
      ),
    );
  }

  Widget removeButton(int index) {
    return InkWell(
      onTap: () {
        jointHoldersList.removeAt(index);
        setState(() {});
      },
      child: Text(
        "Remove",
        style: AppFonts.f40013.copyWith(
            color: Config.appTheme.themeColor,
            decoration: TextDecoration.underline),
      ),
    );
  }

  String name = "", mobile = "", email = "", birthPlace = "";
  String pan = "", kycStatus = "";
  String successMsg = "The PAN is KYC complaint.";
  DateTime dob = DateTime(2002, 6, 18);

  addBottomSheet(String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: cornerBorder),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SizedBox(
              height: devHeight * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BottomSheetTitle(title: "$title Applicant Details"),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          AmountInputCard(
                              title: "Applicant Name as on PAN Card",
                              keyboardType: TextInputType.name,
                              suffixText: "",
                              onChange: (val) => name = val,
                              borderRadius: BorderRadius.circular(20),
                              hasSuffix: false),
                          SizedBox(height: 16),
                          AmountInputCard(
                            title: "PAN Number",
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                            ],
                            initialValue: "",
                            suffixText: "",
                            hasSuffix: false,
                            textCapitalization: TextCapitalization.characters,
                            maxLength: 10,
                            keyboardType: TextInputType.name,
                            borderRadius: BorderRadius.circular(20),
                            subTitle: Text(
                              kycStatus,
                              style: (kycStatus == successMsg)
                                  ? successStyle
                                  : errorStyle,
                            ),
                            onChange: (val) async {
                              pan = val;
                              if (pan.length != 10) return;
                              kycStatus = await checkPanKycStatus(pan);
                              bottomState(() {});
                            },
                          ),
                          SizedBox(height: 16),
                          dateCard(
                            title: "Applicant DOB",
                            dob: dob,
                            onTap: () async {
                              DateTime? temp = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2002, 06, 18),
                                  firstDate: DateTime(1880),
                                  lastDate: DateTime.now());
                              if (temp == null) return;
                              dob = temp;
                              bottomState(() {});
                            },
                          ),
                          AmountInputCard(
                            title: "Applicant Mobile Number",
                            initialValue: "",
                            suffixText: "",
                            hasSuffix: false,
                            keyboardType: TextInputType.phone,
                            borderRadius: BorderRadius.circular(20),
                            onChange: (val) => mobile = val,
                          ),
                          SizedBox(height: 16),

                          // #region mobileRelationTile
                          mobileRelationTile(context, bottomState),
                          // #endregion

                          SizedBox(height: 16),
                          AmountInputCard(
                            title: "Applicant Email Id",
                            initialValue: "",
                            suffixText: "",
                            hasSuffix: false,
                            keyboardType: TextInputType.emailAddress,
                            borderRadius: BorderRadius.circular(20),
                            onChange: (val) => email = val,
                          ),
                          SizedBox(height: 16),

                          // #region emailRelationTile
                          emailRelationTile(context, bottomState),
                          // #endregion

                          SizedBox(height: 16),
                          // #region birthCountry
                          countryOfBrithTile(context, bottomState),
                          // #endregion

                          SizedBox(height: 16),
                          AmountInputCard(
                              title: "Applicant Place (City) of Birth",
                              initialValue: birthPlace,
                              suffixText: "",
                              hasSuffix: false,
                              keyboardType: TextInputType.name,
                              borderRadius: BorderRadius.circular(20),
                              maxLength: 50,
                              onChange: (val) => birthPlace = val),

                          SizedBox(height: 16),
                          // #region addressType tile
                          addressTile(context, bottomState),
                          // #endregion

                          SizedBox(height: 16),
                          // #region empStatusTile
                          employementStatusTile(context, bottomState),
                          // #endregion

                          SizedBox(height: 16),
                          // #region annualSalaryTile
                          annualSalaryTile(context, bottomState),
                          // #endregion

                          SizedBox(height: 16),
                          // #region incomeSourceTile
                          incomeSourceTile(context, bottomState),
                          // #endregion

                          SizedBox(height: 16),
                          // #region politicalRelationTile
                          politicalRelationTile(context, bottomState),
                          // #endregion
                        ],
                      ),
                    ),
                    CalculateButton(
                        onPress: () async {
                          JointHolderPojo holder = JointHolderPojo(
                            jointHolderId: jointHoldersList.length + 1,
                            jointHolderName: name,
                            jointHolderPan: pan,
                            jointHolderDob: convertDtToStr(dob),
                            jointHolderEmail: email,
                            jointHolderEmailRelation: emailRelationCode,
                            jointHolderMobile: mobile,
                            jointHolderMobileRelation: mobileRelationCode,
                            jointHolderPlaceBirth: birthPlace,
                            jointHolderCountryBirth: birthCountryCode,
                            jointHolderOccupation: employementStatusCode,
                            jointHolderIncome: annualSalaryCode,
                            jointHolderSourceWealth: incomeSourceCode,
                            jointHolderAddressType: addressTypeCode,
                            jointHolderPolitical: politicalRelationCode,
                          );

                          jointHoldersList.add(holder);
                          Get.back();
                          setState(() {});
                        },
                        text: "SUBMIT DETAILS")
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget emailRelationTile(BuildContext context, bottomState) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: emailRelationController,
          title: Text("Email Relation", style: AppFonts.f50014Black),
          subtitle: Text(emailRelation, style: AppFonts.f50012),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: mobileRelationList.length,
              itemBuilder: (context, index) {
                Map map = mobileRelationList[index];
                String desc = map['desc'];
                String code = map['code'];

                return InkWell(
                  onTap: () {
                    emailRelation = desc;
                    emailRelationCode = code;
                    emailRelationController.collapse();
                    bottomState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: code,
                        groupValue: emailRelationCode,
                        onChanged: (value) {
                          emailRelation = desc;
                          emailRelationCode = code;
                          emailRelationController.collapse();
                          bottomState(() {});
                        },
                      ),
                      Text(desc, style: AppFonts.f50014Grey),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  String countrySearchKey = "";

  Widget countryOfBrithTile(BuildContext context, bottomState) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: countryOfBrithController,
          title: Text("Country of Birth", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(birthCountry, style: AppFonts.f50012),
            ],
          ),
          childrenPadding: EdgeInsets.all(16),
          children: [
            RpSmallTf(
              initialValue: countrySearchKey,
              onChange: (val) {
                countrySearchKey = val;
                bottomState(() {});
              },
              borderColor: Colors.black,
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Scrollbar(
                child: ListView.builder(
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: countryList.length,
                  // itemCount: 10,
                  itemBuilder: (context, index) {
                    Map map = countryList[index];

                    String desc = map['country_name'];
                    String code = map['country_code'];

                    return Visibility(
                      visible: searchVisibility(desc, countrySearchKey),
                      child: InkWell(
                        onTap: () {
                          birthCountry = desc;
                          birthCountryCode = code;
                          countryOfBrithController.collapse();
                          bottomState(() {});
                        },
                        child: Row(
                          children: [
                            Radio(
                              value: code,
                              groupValue: birthCountryCode,
                              onChanged: (value) {
                                birthCountry = desc;
                                birthCountryCode = code;
                                countryOfBrithController.collapse();
                                bottomState(() {});
                              },
                            ),
                            Expanded(
                                child: Text(desc, style: AppFonts.f50014Grey)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  searchVisibility(String title, String searchKey) {
    title = title.toLowerCase();
    searchKey = searchKey.toLowerCase();

    if (searchKey.isEmpty)
      return true;
    else {
      return title.contains(searchKey);
    }
  }

  Widget mobileRelationTile(BuildContext context, bottomState) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: mobileRelationController,
          title: Text("Mobile Relation", style: AppFonts.f50014Black),
          subtitle: Text(mobileRelation, style: AppFonts.f50012),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: mobileRelationList.length,
              itemBuilder: (context, index) {
                Map map = mobileRelationList[index];
                String desc = map['desc'];
                String code = map['code'];

                return InkWell(
                  onTap: () {
                    mobileRelation = desc;
                    mobileRelationCode = code;
                    mobileRelationController.collapse();
                    bottomState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: code,
                        groupValue: mobileRelationCode,
                        onChanged: (value) {
                          mobileRelation = desc;
                          mobileRelationCode = code;
                          mobileRelationController.collapse();
                          bottomState(() {});
                        },
                      ),
                      Text(desc, style: AppFonts.f50014Grey),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  List addressTypeList = [];
  String addressType = "";
  String addressTypeCode = "";
  ExpansionTileController addressController = ExpansionTileController();

  Widget addressTile(BuildContext context, bottomState) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: addressController,
            title: Text("Address Type", style: AppFonts.f50014Black),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(addressType, style: AppFonts.f50012),
              ],
            ),
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: addressTypeList.length,
                  itemBuilder: (context, index) {
                    Map map = addressTypeList[index];

                    String desc = map['desc'];
                    String code = map['code'];

                    return InkWell(
                      onTap: () {
                        addressType = desc;
                        addressTypeCode = code;
                        addressController.collapse();
                        bottomState(() {});
                      },
                      child: Row(
                        children: [
                          Radio(
                            value: code,
                            groupValue: addressTypeCode,
                            onChanged: (value) {
                              addressType = desc;
                              addressTypeCode = code;
                              addressController.collapse();
                              bottomState(() {});
                            },
                          ),
                          Text(desc, style: AppFonts.f50014Grey),
                        ],
                      ),
                    );
                  })
            ],
          )),
    );
  }

  Widget employementStatusTile(BuildContext context, bottomState) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: empStatusController,
          title: Text("Employment Status", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(employementStatus, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: empStatusList.length,
              itemBuilder: (context, index) {
                Map map = empStatusList[index];
                String desc = map['desc'];
                String code = map['code'];

                return InkWell(
                  onTap: () {
                    employementStatus = desc;
                    employementStatusCode = code;
                    empStatusController.collapse();
                    bottomState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: code,
                        groupValue: employementStatusCode,
                        onChanged: (value) {
                          employementStatus = desc;
                          employementStatusCode = code;
                          empStatusController.collapse();
                          bottomState(() {});
                        },
                      ),
                      Text(desc, style: AppFonts.f50014Grey),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget annualSalaryTile(BuildContext context, bottomState) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: annualSalaryController,
          title: Text("Annual Salary", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(annualSalary, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: annualSalaryList.length,
              itemBuilder: (context, index) {
                Map map = annualSalaryList[index];
                String desc = map['desc'];
                String code = map['code'];

                return InkWell(
                  onTap: () {
                    annualSalary = desc;
                    annualSalaryCode = code;
                    annualSalaryController.collapse();
                    bottomState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: code,
                        groupValue: annualSalaryCode,
                        onChanged: (value) {
                          annualSalary = desc;
                          annualSalaryCode = code;
                          annualSalaryController.collapse();
                          bottomState(() {});
                        },
                      ),
                      Text(desc, style: AppFonts.f50014Grey),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget incomeSourceTile(BuildContext context, bottomState) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: sourceIncomeController,
          title: Text("Source of Income", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(incomeSource, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: incomeSourceList.length,
              itemBuilder: (context, index) {
                Map map = incomeSourceList[index];
                String desc = map['desc'];
                String code = map['code'];

                return InkWell(
                  onTap: () {
                    incomeSource = desc;
                    incomeSourceCode = code;
                    sourceIncomeController.collapse();
                    bottomState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: code,
                        groupValue: incomeSourceCode,
                        onChanged: (value) {
                          incomeSource = desc;
                          incomeSourceCode = code;
                          sourceIncomeController.collapse();
                          bottomState(() {});
                        },
                      ),
                      Text(desc, style: AppFonts.f50014Grey),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget politicalRelationTile(BuildContext context, bottomState) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: politicalRelationshipController,
          title: Text("Political Relationship", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(politicalRelation, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: politicalRelationList.length,
              itemBuilder: (context, index) {
                Map map = politicalRelationList[index];

                String desc = map['desc'];
                String code = map['code'];

                return InkWell(
                  onTap: () {
                    politicalRelation = desc;
                    politicalRelationCode = code;
                    politicalRelationshipController.collapse();
                    bottomState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: code,
                        groupValue: politicalRelationCode,
                        onChanged: (value) {
                          politicalRelation = desc;
                          politicalRelationCode = code;
                          politicalRelationshipController.collapse();
                          bottomState(() {});
                        },
                      ),
                      Expanded(child: Text(desc, style: AppFonts.f50014Grey)),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget dateCard({
    required String title,
    required DateTime dob,
    Function()? onTap,
  }) {
    String subTitle = dob.toString().split(" ").first;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: devWidth,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppFonts.f50014Black),
            SizedBox(height: 4),
            Text(subTitle, style: AppFonts.f50012),
          ],
        ),
      ),
    );
  }
}
