import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Registration/InvestorInfo/InvestorInfoPojo.dart';
import 'package:mymfbox2_0/Investor/Registration/Models/country_code_model.dart';
import 'package:mymfbox2_0/Investor/Registration/PersonalInfo/MinorInfo.dart';
import 'package:mymfbox2_0/Investor/Registration/PersonalInfo/PersonalInfoPojo.dart';
import 'package:mymfbox2_0/api/onBoarding/CommonOnBoardApi.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/CalculateButton.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/Loading.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpSmallTf.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class CompanyInfo extends StatefulWidget {
  CompanyInfo({super.key, required this.selectedInfo});

  String? selectedInfo;

  @override
  State<CompanyInfo> createState() => _CompanyInfoState();
}

class _CompanyInfoState extends State<CompanyInfo> {
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  String user_name = GetStorage().read("user_name");
  String bse_nse_mfu_flag = Get.arguments;

  ExpansionTileController genderController = ExpansionTileController();
  ExpansionTileController mobileRelationController = ExpansionTileController();
  ExpansionTileController emailRelationController = ExpansionTileController();
  ExpansionTileController countryOfBrithController = ExpansionTileController();
  ExpansionTileController empStatusController = ExpansionTileController();
  ExpansionTileController annualSalaryController = ExpansionTileController();
  ExpansionTileController sourceIncomeController = ExpansionTileController();
  ExpansionTileController politicalRelationshipController =
      ExpansionTileController();

  DateTime? dob;
  DateTime networthdate = DateTime.now();
  TextEditingController dobController = TextEditingController();
  TextEditingController netdobController = TextEditingController();

  DateTime selectedFolioDate = DateTime.now();
  ExpansionTileController controller1 = ExpansionTileController();
  ExpansionTileController controller2 = ExpansionTileController();
  bool isToday = true;
  String formattedDate = "";

  String mobileRelation = "";
  String mobileRelationCode = "";

  String employementStatus = "Agriculturist";
  String employementStatusCode = "4";

  String emailRelation = "";
  String emailRelationCode = "";
  String birthCountry = "India";
  String birthCountryCode = "IND";

  String annualSalary = "Below 1 Lakh";
  String annualSalaryCode = "BL";

  String incomeSource = "";
  String incomeSourceCode = "";

  String politicalRelation = "";
  String politicalRelationCode = "";

  String mobile = "",
      email = "",
      birthPlace = "",
      networth_amount = "",
      companyInfo = "";

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

  List countryList = [];

  Future getCountryList() async {
    if (countryList.isNotEmpty) return -1;

    CountryListResponse res = await CommonOnBoardApi.getCountryList(
        user_id: user_id,
        client_name: client_name,
        bse_nse_mfu_flag: bse_nse_mfu_flag);

    if (res.status != 200) {
      Utils.showError(context, res.msg ?? '');
      return -1;
    }

    countryList = res.list ?? [];

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

  Future savePersonalInfo() async {
    EasyLoading.show();

    Map data = await CommonOnBoardApi.savePersonalInfo(
        user_id: user_id,
        client_name: client_name,
        name: user_name,
        dob: formattedDate,
        gender: gender[0],
        email: email,
        email_relation: emailRelationCode,
        mobile: mobile,
        mobile_relation: mobileRelationCode,
        alter_mobile: "",
        alter_email: "",
        phone_office: "",
        phone_residence: "",
        place_birth: birthPlace,
        country_birth: birthCountry,
        country_birth_code: birthCountryCode,
        occupation: employementStatus,
        occupation_code: employementStatusCode,
        occupation_other: "",
        income: annualSalary,
        income_code: annualSalaryCode,
        source_wealth: incomeSource,
        source_wealth_code: incomeSourceCode,
        source_wealth_other: "",
        political_status: politicalRelation,
        political_status_code: politicalRelationCode,
        guard_name: "",
        guard_pan: "",
        guard_dob: "",
        guard_relation: "",
        guard_relation_proof: "",
        father_name: "",
        address_type_desc: addressType,
        address_type: addressTypeCode,
        networth_dob: convertDtToStr(networthdate),
        networth_amount: networth_amount,
        mobile_isd_code: '',
        bse_nse_mfu_flag: bse_nse_mfu_flag,
        guard_account_relation: '');
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    EasyLoading.dismiss();
    return 0;
  }

  PersonalInfoPojo personalInfo = PersonalInfoPojo();

  Future getPersonalInfo() async {
    if (personalInfo.gender != null) return 0;

    Map data = await CommonOnBoardApi.getPersonalInfo(
        user_id: user_id,
        client_name: client_name,
        bse_nse_mfu_flag: bse_nse_mfu_flag);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    Map<String, dynamic> result = data['result'];

    personalInfo = PersonalInfoPojo.fromJson(result);

    fillData();

    return 0;
  }

  InvestorInfoPojo investorInfo = InvestorInfoPojo();

  Future getInvestorInfo() async {
    if (investorInfo.name != null) return 0;

    Map data = await CommonOnBoardApi.getInvestorInfo(
        user_id: user_id,
        client_name: client_name,
        bse_nse_mfu_flag: bse_nse_mfu_flag);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    Map<String, dynamic> result = data['result'];
    investorInfo = InvestorInfoPojo.fromJson(result);

    return 0;
  }

  void fillData() {
    if (personalInfo.dob!.isNotEmpty)
      dob = convertStrToDt("${personalInfo.dob}");
    dobController.text = "${personalInfo.dob}";
    gender = getGenderByCode(personalInfo.gender);
    mobile = "${personalInfo.mobile}";
    mobileRelation = "${personalInfo.mobileRelationDesc}";
    mobileRelationCode = "${personalInfo.mobileRelation}";
    addressTypeCode = "${personalInfo.addressType}";
    addressType = "${personalInfo.addressTypeDesc}";
    email = "${personalInfo.email}";
    emailRelation = "${personalInfo.emailRelationDesc}";
    emailRelationCode = "${personalInfo.emailRelation}";
    birthCountry = "${personalInfo.countryBirth}";
    birthCountryCode = "${personalInfo.countryBirthCode}";
    birthPlace = "${personalInfo.placeBirth}";
    employementStatus = "${personalInfo.occupation}";
    employementStatusCode = "${personalInfo.occupationCode}";
    annualSalary = "${personalInfo.income}";
    annualSalaryCode = "${personalInfo.incomeCode}";
    incomeSource = "${personalInfo.sourceWealth}";
    incomeSourceCode = "${personalInfo.sourceWealthCode}";
    politicalRelation = "${personalInfo.politicalStatus}";
    politicalRelationCode = "${personalInfo.politicalStatusCode}";
    networth_amount = '${personalInfo.networthAmount}';
    if ((personalInfo.networthDob?.isNotEmpty) ?? false) {
      networthdate = convertStrToDt(personalInfo.networthDob ?? '');
      netdobController.text = convertDtToStr(networthdate);
    }
  }

  String getGenderByCode(String? code) {
    if (code == "M") return "Male";
    if (code == "F") return "Female";
    if (code == "O") return "Others";
    return "Invalid";
  }

  Future getDatas() async {
    EasyLoading.show();

    await getInvestorInfo();
    await getCountryList();
    await getRelationList();
    await getAddressList();
    await getEmpStatusList();
    await getAnnualSalaryList();
    await getIncomeSourceList();
    await getPoliticalRelationList();
    await getPersonalInfo();

    EasyLoading.dismiss();

    return 0;
  }

  String first15char(String text) {
    String s = text;
    if (s.length > 15) s = '${s.substring(0, 15)}...';
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: rpAppBar(
                title: "Personal Info (${first15char(widget.selectedInfo!)})",
                bgColor: Config.appTheme.themeColor,
                foregroundColor: Colors.white),
            body: (!snapshot.hasData)
                ? Loading()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              AmountInputCard(
                                title: "Name as on PAN",
                                initialValue: user_name,
                                suffixText: "",
                                hasSuffix: false,
                                readOnly: true,
                                keyboardType: TextInputType.name,
                                borderRadius: BorderRadius.circular(20),
                                onChange: (val) {},
                              ),
                              SizedBox(height: 16),
                              AmountInputCard(
                                title: "Mobile Number",
                                initialValue: mobile,
                                suffixText: "",
                                maxLength: 10,
                                hasSuffix: false,
                                keyboardType: TextInputType.phone,
                                borderRadius: BorderRadius.circular(20),
                                onChange: (val) => mobile = val,
                              ),
                              SizedBox(height: 16),
                              mobileRelationTile(context),
                              SizedBox(height: 16),
                              AmountInputCard(
                                title: "Email Id",
                                initialValue: email,
                                suffixText: "",
                                hasSuffix: false,
                                keyboardType: TextInputType.emailAddress,
                                borderRadius: BorderRadius.circular(20),
                                onChange: (val) => email = val,
                              ),
                              SizedBox(height: 16),
                              emailRelationTile(context),
                              SizedBox(height: 16),
                              addressTile(context),
                              DottedLine(verticalPadding: 8),
                              SizedBox(height: 16),
                              countryOfBrithTile(context),
                              SizedBox(height: 16),
                              AmountInputCard(
                                  title: "Place (City) of Birth",
                                  initialValue: birthPlace,
                                  suffixText: "",
                                  hasSuffix: false,
                                  keyboardType: TextInputType.name,
                                  borderRadius: BorderRadius.circular(20),
                                  onChange: (val) => birthPlace = val),
                              DottedLine(verticalPadding: 8),
                              employementStatusTile(context),
                              SizedBox(height: 16),
                              annualSalaryTile(context),
                              SizedBox(height: 16),
                              incomeSourceTile(context),
                              DottedLine(verticalPadding: 8),
                              AmountInputCard(
                                title: "Net Worth Amount (in lakhs)",
                                initialValue: networth_amount,
                                suffixText: "",
                                hasSuffix: false,
                                maxLength: 10,
                                keyboardType: TextInputType.phone,
                                borderRadius: BorderRadius.circular(20),
                                onChange: (val) => networth_amount = val,
                              ),
                              SizedBox(height: 16),
                              dateInput(
                                title: "Net worth date",
                                controller: netdobController,
                                initialValue: "",
                                onTap: () async {
                                  DateTime? dt = await showDatePicker(
                                    context: context,
                                    initialDate: networthdate,
                                    firstDate: DateTime(1890),
                                    lastDate: DateTime.now(),
                                  );
                                  if (dt == null) return;

                                  networthdate = dt;
                                  netdobController.text =
                                      convertDtToStr(networthdate);
                                  setState(() {});
                                },
                              ),
                              SizedBox(height: 16),
                              politicalRelationTile(context),
                              SizedBox(height: 32),
                            ],
                          ),
                        ),
                        CalculateButton(
                          text: "CONTINUE",
                          onPress: () async {
                            int isValid = validator();
                            if (isValid != 0) {
                              Utils.showError(
                                  context, "All Fields are Mandatory");
                              return;
                            }
                            if (!email.isEmail) {
                              Utils.showError(context, "Invalid email id");
                              return;
                            }

                            // if (dob == null ||
                            //     (dob?.toString() ?? '').isEmpty) {
                            //   Utils.showError(context, "Please Select DOB");
                            //   return;
                            // }
                            if (mobile.length != 10) {
                              Utils.showError(context, "Invalid Mobile Number");
                              return;
                            }

                            int res = await savePersonalInfo();
                            if (res == 0) Get.back();
                          },
                        )
                      ],
                    ),
                  ),
          );
        });
  }

  int validator() {
    List list = [
      gender,
      mobileRelation,
      addressType,
      email,
      emailRelation,
      birthCountry,
      birthPlace,
      employementStatus,
      annualSalary,
      incomeSource,
      politicalRelation
    ];
    if (list.contains(""))
      return -1;
    else
      return 0;
  }

  List addressTypeList = [];
  String addressType = "";
  String addressTypeCode = "";
  ExpansionTileController addressController = ExpansionTileController();

  Widget addressTile(BuildContext context) {
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
                        setState(() {});
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
                              setState(() {});
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

  Widget dateInput(
      {required String title,
      Function()? onTap,
      String? initialValue,
      TextEditingController? controller}) {
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

  OutlineInputBorder borderStyle = OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.lineColor),
      borderRadius: BorderRadius.circular(20));

  List genderList = [
    "Male",
    "Female",
    "Other",
  ];
  String gender = "Male";

  Widget genderTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: genderController,
          title: Text("Gender", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(gender, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: genderList.length,
              itemBuilder: (context, index) {
                String temp = genderList[index];

                return InkWell(
                  onTap: () {
                    gender = temp;
                    genderController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: gender,
                        onChanged: (value) {
                          gender = temp;
                          genderController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(temp, style: AppFonts.f50014Grey),
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

  List mobileRelationList = [];

  Widget mobileRelationTile(BuildContext context) {
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
                    setState(() {});
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
                          setState(() {});
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

  Widget emailRelationTile(BuildContext context) {
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
                    setState(() {});
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
                          setState(() {});
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

  Widget countryOfBrithTile(BuildContext context) {
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
                setState(() {});
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
                    CountryDetails country = countryList[index];

                    return Visibility(
                      visible: searchVisibility(
                          country.countryName ?? '', countrySearchKey),
                      child: InkWell(
                        onTap: () {
                          birthCountry = country.countryName ?? '';
                          birthCountryCode = country.countryCode ?? '';
                          countryOfBrithController.collapse();
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Radio(
                              value: country.countryCode,
                              groupValue: birthCountryCode,
                              onChanged: (value) {
                                birthCountry = country.countryName ?? "";
                                birthCountryCode = country.countryCode ?? '';
                                countryOfBrithController.collapse();
                                setState(() {});
                              },
                            ),
                            Expanded(
                                child: Text(country.countryName ?? '',
                                    style: AppFonts.f50014Grey)),
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

  Widget employementStatusTile(BuildContext context) {
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
                    setState(() {});
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
                          setState(() {});
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

  Widget annualSalaryTile(BuildContext context) {
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
                    setState(() {});
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
                          setState(() {});
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

  Widget incomeSourceTile(BuildContext context) {
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
                    setState(() {});
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
                          setState(() {});
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

  Widget politicalRelationTile(BuildContext context) {
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
                    setState(() {});
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
                          setState(() {});
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
}
