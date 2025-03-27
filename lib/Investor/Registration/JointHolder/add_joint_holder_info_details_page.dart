import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/Investor/Registration/Models/country_code_model.dart';
import 'package:mymfbox2_0/pojo/JointHolderPojo.dart';

import '../../../api/onBoarding/CommonOnBoardApi.dart';
import '../../../rp_widgets/AmountInputCard.dart';
import '../../../rp_widgets/BottomSheetTitle.dart';
import '../../../rp_widgets/CalculateButton.dart';
import '../../../rp_widgets/RpSmallTf.dart';
import '../../../utils/AppColors.dart';
import '../../../utils/AppFonts.dart';
import '../../../utils/Config.dart';
import '../../../utils/Utils.dart';
import 'Controller/JoinHolderDataController/join_holder_data_controller.dart';
import 'Models/address_type_response.dart';
import 'Models/annual_salary_response.dart';
import 'Models/email_relation_response.dart';
import 'Models/employment_status_response.dart';
import 'Models/mobile_relation_response.dart';
import 'Models/political_relation_response_model.dart';
import 'Models/source_of_income_response.dart';

class AddJoinHolderInfoDetailPage extends StatefulWidget {
  final JointHolderPojo model;
  final String title;
  final int userId;
  final String clientName;
  final String bseNseMfuFlag;
  final bool isEdit;
  final int modelId;

  const AddJoinHolderInfoDetailPage({
    super.key,
    required this.model,
    required this.title,
    required this.userId,
    required this.clientName,
    required this.bseNseMfuFlag,
    required this.modelId,
    this.isEdit = false,
  });

  @override
  State<AddJoinHolderInfoDetailPage> createState() =>
      _AddJoinHolderInfoDetailPageState();
}

class _AddJoinHolderInfoDetailPageState
    extends State<AddJoinHolderInfoDetailPage> {
  @override
  void initState() {
    super.initState();

    final pojo = widget.model;
    print(pojo.jointHolderName ?? '');
    panNameController.text = pojo.jointHolderName ?? '';
    panNumberController.text = pojo.jointHolderPan ?? '';
    mobController.text = pojo.jointHolderMobile ?? '';
    emailController.text = pojo.jointHolderEmail ?? '';
    placeOfBirthController.text = pojo.jointHolderPlaceBirth ?? '';
    dob = parseDate(pojo.jointHolderDob ?? '10-10-2002');
  }

  DateTime parseDate(String dateString) {
    try {
      return DateFormat("dd-MM-yyyy").parse(dateString);
    } catch (e) {
      throw FormatException("Invalid date format: $dateString");
    }
  }

  ExpansionTileController addressTileController = ExpansionTileController();
  ExpansionTileController mobileRelationTileController =
      ExpansionTileController();
  ExpansionTileController emailRelationTileController =
      ExpansionTileController();
  ExpansionTileController countryOfBirthTileController =
      ExpansionTileController();
  ExpansionTileController employmentStatusTileController =
      ExpansionTileController();
  ExpansionTileController annualSalaryTileController =
      ExpansionTileController();
  ExpansionTileController incomeSourceTileController =
      ExpansionTileController();
  ExpansionTileController politicalRelationTileController =
      ExpansionTileController();

  TextEditingController panNameController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController mobController = TextEditingController();
  TextEditingController placeOfBirthController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  List<PoliticalDetails> politicalRelationList = [];
  PoliticalDetails? selectedPoliticalRelation;
  List<IncomeDetails> sourceOfIncomeList = [];
  IncomeDetails? selectedSourceOfIncome;
  List<SalaryDetails> annualSalaryList = [];
  SalaryDetails? selectedAnnualSalary;
  List<EmploymentDetails> employmentDataList = [];
  EmploymentDetails? selectedEmploymentStatus;
  List<CountryDetails> countryList = [];
  CountryDetails? selectedCountry;
  List<EmailRelationDetails> emailRelationList = [];
  EmailRelationDetails? selectedEmailRelation;
  List<MobileRelationDetails> mobileRelationList = [];
  MobileRelationDetails? selectedMobileRelation;
  List<AddressTypeData> addressTypeList = [];
  AddressTypeData? selectedAddress;

  String countrySearchKey = '';

  String successMsg = "The PAN is KYC complaint.";
  TextStyle successStyle = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 12, color: AppColors.textGreen);
  TextStyle errorStyle = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 12, color: AppColors.lossRed);

  String kycStatus = '';
  DateTime dob = DateTime.now();

  Future checkPanKycStatus(String pan) async {
    EasyLoading.show();

    Map data = await CommonOnBoardApi.checkPanKycStatus(
      user_id: widget.userId,
      client_name: widget.clientName,
      pan: pan,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    EasyLoading.dismiss();

    return data['msg'];
  }

  Future getAddressList() async {
    if (addressTypeList.isNotEmpty) return -1;

    Map data = await CommonOnBoardApi.getAddressType(
        client_name: widget.clientName, bse_nse_mfu_flag: widget.bseNseMfuFlag);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    final List tempList = data['list'];
    addressTypeList = tempList.map((e) => AddressTypeData.fromJson(e)).toList();

    if (widget.model.jointHolderAddressType != null) {
      selectedAddress = addressTypeList
          .firstWhere((e) => e.code == widget.model.jointHolderAddressType);
    }

    return 0;
  }

  Future getEmailOrMobileRelationList() async {
    if (mobileRelationList.isNotEmpty && emailRelationList.isNotEmpty)
      return -1;

    Map data = await CommonOnBoardApi.getEmailOrMobileRelation(
        client_name: widget.clientName, bse_nse_mfu_flag: widget.bseNseMfuFlag);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    final List tempList = data['list'];
    emailRelationList =
        tempList.map((e) => EmailRelationDetails.fromJson(e)).toList();
    if (widget.model.jointHolderEmailRelation != null) {
      selectedEmailRelation = emailRelationList.firstWhere(
          (e) => e.code == widget.model.jointHolderEmailRelation,
          orElse: () => emailRelationList[0]);
    }
    mobileRelationList =
        tempList.map((e) => MobileRelationDetails.fromJson(e)).toList();
    if (widget.model.jointHolderMobileRelation != null) {
      selectedMobileRelation = mobileRelationList.firstWhere(
          (e) => e.code == widget.model.jointHolderMobileRelation,
          orElse: () => mobileRelationList[0]);
    }

    return 0;
  }

  Future getCountryList() async {
    if (countryList.isNotEmpty) return -1;

    CountryListResponse res = await CommonOnBoardApi.getCountryList(
        user_id: widget.userId,
        client_name: widget.clientName,
        bse_nse_mfu_flag: widget.bseNseMfuFlag);

    if (res.status != 200) {
      Utils.showError(context, res.msg ?? '');
      return -1;
    }

    countryList = res.list ?? [];
    if (widget.model.jointHolderCountryBirth != null) {
      selectedCountry = countryList.firstWhere(
          (e) => e.countryCode == widget.model.jointHolderCountryBirth);
    } else {
      selectedCountry = countryList.firstWhere((e) => e.countryCode == 'IND');
    }

    return 0;
  }

  Future getEmpStatusList() async {
    if (employmentDataList.isNotEmpty) return -1;

    Map data = await CommonOnBoardApi.getEmploymentStatus(
        client_name: widget.clientName, bse_nse_mfu_flag: widget.bseNseMfuFlag);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    final List tempList = data['list'];
    employmentDataList =
        tempList.map((e) => EmploymentDetails.fromJson(e)).toList();

    if (widget.model.jointHolderOccupation != null) {
      selectedEmploymentStatus = employmentDataList
          .firstWhere((e) => e.code == widget.model.jointHolderOccupation);
    }

    return 0;
  }

  Future getAnnualSalaryList() async {
    if (annualSalaryList.isNotEmpty) return -1;

    Map data = await CommonOnBoardApi.getAnnualSalary(
        client_name: widget.clientName, bse_nse_mfu_flag: widget.bseNseMfuFlag);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    final List tempList = data['list'];
    annualSalaryList = tempList.map((e) => SalaryDetails.fromJson(e)).toList();

    if (widget.model.jointHolderIncome != null) {
      selectedAnnualSalary = annualSalaryList
          .firstWhere((e) => e.code == widget.model.jointHolderIncome);
    }

    return 0;
  }

  Future getIncomeSourceList() async {
    if (sourceOfIncomeList.isNotEmpty) return -1;

    Map data = await CommonOnBoardApi.getSourceOfIncome(
        client_name: widget.clientName, bse_nse_mfu_flag: widget.bseNseMfuFlag);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    final List tempList = data['list'];
    sourceOfIncomeList =
        tempList.map((e) => IncomeDetails.fromJson(e)).toList();

    if (widget.model.jointHolderSourceWealth != null) {
      selectedSourceOfIncome = sourceOfIncomeList
          .firstWhere((e) => e.code == widget.model.jointHolderSourceWealth);
    }

    return 0;
  }

  Future getPoliticalRelationList() async {
    if (politicalRelationList.isNotEmpty) return -1;

    Map data = await CommonOnBoardApi.getPoliticalRelationship(
        client_name: widget.clientName, bse_nse_mfu_flag: widget.bseNseMfuFlag);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    final List tempList = data['list'];
    politicalRelationList =
        tempList.map((e) => PoliticalDetails.fromJson(e)).toList();

    if (widget.model.jointHolderPolitical != null) {
      selectedPoliticalRelation = politicalRelationList
          .firstWhere((e) => e.code == widget.model.jointHolderPolitical);
    }

    return 0;
  }

  getData() async {
    await getEmpStatusList();
    await getCountryList();
    await getEmailOrMobileRelationList();
    await getAddressList();
    await getIncomeSourceList();
    await getAnnualSalaryList();
    await getPoliticalRelationList();
  }

  bool validate(context) {
    if (panNameController.text.isEmpty) {
      Utils.showError(context, 'Please Provide Pan Name');
      return false;
    }
    if (panNumberController.text.isEmpty) {
      Utils.showError(context, 'Please Provide Pan Number');
      return false;
    }
    if (mobController.text.isEmpty) {
      Utils.showError(context, 'Please Select Mobile Number');
      return false;
    }
    if (selectedMobileRelation == null) {
      Utils.showError(context, 'Please Select Mobile Relation');
      return false;
    }

    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(emailController.text);
    if (emailController.text.isEmpty || !emailValid) {
      Utils.showError(context, 'Please Provide a Valid Email');
      return false;
    }
    if (selectedEmailRelation == null) {
      Utils.showError(context, 'Please Select Email Relation');
      return false;
    }
    if (placeOfBirthController.text.isEmpty) {
      Utils.showError(context, 'Please Provide Place of Birth');
      return false;
    }

    if (selectedAddress == null) {
      Utils.showError(context, 'Please Select Address Type');
      return false;
    }

    if (selectedEmploymentStatus == null) {
      Utils.showError(context, 'Please Select Employment Status');
      return false;
    }

    if (selectedAnnualSalary == null) {
      Utils.showError(context, 'Please Select Annual Salary');
      return false;
    }

    if (selectedSourceOfIncome == null) {
      Utils.showError(context, 'Please Select Source of Income');
      return false;
    }

    if (selectedPoliticalRelation == null) {
      Utils.showError(context, 'Please Select Political Relation');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapShot) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  BottomSheetTitle(title: "${widget.title} Applicant Details"),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        AmountInputCard(
                            controller: panNameController,
                            title: "Applicant Name as on PAN Card",
                            keyboardType: TextInputType.name,
                            suffixText: "",
                            onChange: (val) => () {},
                            borderRadius: BorderRadius.circular(20),
                            hasSuffix: false),
                        SizedBox(height: 16),
                        AmountInputCard(
                          controller: panNumberController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          title: "PAN Number",
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
                            if (panNumberController.text.length != 10) return;
                            kycStatus = await checkPanKycStatus(
                                panNumberController.text);
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.maxFinite,
                          child: dateCard(
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
                              setState(() {});
                            },
                          ),
                        ),
                        AmountInputCard(
                          title: "Applicant Mobile Number",
                          controller: mobController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.singleLineFormatter,
                          ],
                          suffixText: "",
                          hasSuffix: false,
                          keyboardType: TextInputType.phone,
                          borderRadius: BorderRadius.circular(20),
                          onChange: (val) {},
                        ),
                        SizedBox(height: 16),

                        // #region mobileRelationTile
                        mobileRelationTile(context),
                        // #endregion

                        SizedBox(height: 16),
                        AmountInputCard(
                          title: "Applicant Email Id",
                          suffixText: "",
                          hasSuffix: false,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          borderRadius: BorderRadius.circular(20),
                          onChange: (val) => {},
                        ),
                        SizedBox(height: 16),

                        // #region emailRelationTile
                        emailRelationTile(context),
                        // #endregion

                        SizedBox(height: 16),
                        // #region birthCountry
                        countryOfBrithTile(context),
                        // #endregion

                        SizedBox(height: 16),
                        AmountInputCard(
                            title: "Applicant Place (City) of Birth",
                            suffixText: "",
                            controller: placeOfBirthController,
                            hasSuffix: false,
                            keyboardType: TextInputType.name,
                            borderRadius: BorderRadius.circular(20),
                            onChange: (val) => () {}),

                        SizedBox(height: 16),
                        // #region addressType tile
                        addressTile(context),
                        // #endregion

                        SizedBox(height: 16),
                        // #region empStatusTile
                        employmentStatusTile(context),
                        // #endregion

                        SizedBox(height: 16),
                        // #region annualSalaryTile
                        annualSalaryTile(context),
                        // #endregion

                        SizedBox(height: 16),
                        // #region incomeSourceTile
                        incomeSourceTile(context),
                        // #endregion

                        SizedBox(height: 16),
                        // #region politicalRelationTile
                        politicalRelationTile(context),
                        // #endregion
                      ],
                    ),
                  ),
                  if (widget.isEdit)
                    CalculateButton(
                      onPress: () async {
                        EasyLoading.show();
                        if (!validate(context)) return;
                        JointHolderPojo holder = JointHolderPojo(
                          jointHolderId: widget.modelId,
                          jointHolderName: panNameController.text,
                          jointHolderPan: panNumberController.text,
                          jointHolderDob: convertDtToStr(dob),
                          jointHolderEmail: emailController.text,
                          jointHolderEmailRelation:
                              selectedEmailRelation?.code ?? '',
                          jointHolderMobile: mobController.text,
                          jointHolderMobileRelation:
                              selectedMobileRelation?.code ?? '',
                          jointHolderPlaceBirth: placeOfBirthController.text,
                          jointHolderCountryBirth:
                              selectedCountry?.countryCode ?? '',
                          jointHolderOccupation:
                              selectedEmploymentStatus?.code ?? '',
                          jointHolderIncome: selectedAnnualSalary?.code ?? '',
                          jointHolderSourceWealth:
                              selectedSourceOfIncome?.code ?? '',
                          jointHolderAddressType: selectedAddress?.code ?? '',
                          jointHolderPolitical:
                              selectedPoliticalRelation?.code ?? '',
                        );

                        joinHolderDataController.updateDetails(holder);
                        Get.back();
                        EasyLoading.dismiss();
                      },
                      text: "UPDATE",
                    )
                  else
                    CalculateButton(
                      onPress: () async {
                        EasyLoading.show();
                        if (!validate(context)) return;
                        JointHolderPojo holder = JointHolderPojo(
                          jointHolderId: widget.modelId,
                          jointHolderName: panNameController.text,
                          jointHolderPan: panNumberController.text,
                          jointHolderDob: convertDtToStr(dob),
                          jointHolderEmail: emailController.text,
                          jointHolderEmailRelation:
                              selectedEmailRelation?.code ?? '',
                          jointHolderMobile: mobController.text,
                          jointHolderMobileRelation:
                              selectedMobileRelation?.code ?? '',
                          jointHolderPlaceBirth: placeOfBirthController.text,
                          jointHolderCountryBirth:
                              selectedCountry?.countryCode ?? '',
                          jointHolderOccupation:
                              selectedEmploymentStatus?.code ?? '',
                          jointHolderIncome: selectedAnnualSalary?.code ?? '',
                          jointHolderSourceWealth:
                              selectedSourceOfIncome?.code ?? '',
                          jointHolderAddressType: selectedAddress?.code ?? '',
                          jointHolderPolitical:
                              selectedPoliticalRelation?.code ?? '',
                        );

                        joinHolderDataController.addJoinHolder([holder]);
                        Get.back();

                        EasyLoading.dismiss();
                      },
                      text: "SUBMIT DETAILS",
                    )
                ],
              ),
            );
          }),
    );
  }

  Widget politicalRelationTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: politicalRelationTileController,
          title: Text("Political Relationship", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedPoliticalRelation?.desc ?? '',
                  style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: politicalRelationList.length,
              itemBuilder: (context, index) {
                PoliticalDetails data = politicalRelationList[index];
                return InkWell(
                  onTap: () {
                    selectedPoliticalRelation = data;
                    politicalRelationTileController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: data.code,
                        groupValue: selectedPoliticalRelation?.code,
                        onChanged: (value) {
                          selectedPoliticalRelation = data;
                          politicalRelationTileController.collapse();
                          setState(() {});
                        },
                      ),
                      Expanded(
                          child: Text(data.desc ?? '',
                              style: AppFonts.f50014Grey)),
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
          controller: incomeSourceTileController,
          title: Text("Source of Income", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedSourceOfIncome?.desc ?? '', style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: sourceOfIncomeList.length,
              itemBuilder: (context, index) {
                IncomeDetails incomeData = sourceOfIncomeList[index];
                return InkWell(
                  onTap: () {
                    selectedSourceOfIncome = incomeData;
                    incomeSourceTileController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: incomeData.code,
                        groupValue: selectedSourceOfIncome?.code,
                        onChanged: (value) {
                          selectedSourceOfIncome = incomeData;
                          incomeSourceTileController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(incomeData.desc ?? '', style: AppFonts.f50014Grey),
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
          controller: annualSalaryTileController,
          title: Text("Annual Salary", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedAnnualSalary?.desc ?? '', style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: annualSalaryList.length,
              itemBuilder: (context, index) {
                SalaryDetails salaryData = annualSalaryList[index];

                return InkWell(
                  onTap: () {
                    selectedAnnualSalary = salaryData;
                    annualSalaryTileController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: salaryData.code,
                        groupValue: selectedAnnualSalary?.code,
                        onChanged: (value) {
                          selectedAnnualSalary = salaryData;
                          annualSalaryTileController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(salaryData.desc ?? '', style: AppFonts.f50014Grey),
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

  Widget employmentStatusTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: employmentStatusTileController,
          title: Text("Employment Status", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedEmploymentStatus?.desc ?? '',
                  style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: employmentDataList.length,
              itemBuilder: (context, index) {
                EmploymentDetails empData = employmentDataList[index];

                return InkWell(
                  onTap: () {
                    selectedEmploymentStatus = empData;
                    employmentStatusTileController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: empData.code,
                        groupValue: selectedEmploymentStatus?.code,
                        onChanged: (value) {
                          selectedEmploymentStatus = empData;
                          employmentStatusTileController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(empData.desc ?? '', style: AppFonts.f50014Grey),
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

  searchVisibility(String title, String searchKey) {
    title = title.toLowerCase();
    searchKey = searchKey.toLowerCase();

    if (searchKey.isEmpty)
      return true;
    else {
      return title.contains(searchKey);
    }
  }

  Widget countryOfBrithTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: countryOfBirthTileController,
          title: Text("Country of Birth", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedCountry?.countryName ?? '', style: AppFonts.f50012),
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
                    CountryDetails countryData = countryList[index];

                    return Visibility(
                      visible: searchVisibility(
                          countryData.countryName ?? '', countrySearchKey),
                      child: InkWell(
                        onTap: () {
                          selectedCountry = countryData;
                          countryOfBirthTileController.collapse();
                          countrySearchKey = '';
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Radio(
                              value: countryData.countryCode,
                              groupValue: selectedCountry?.countryCode,
                              onChanged: (value) {
                                countryOfBirthTileController.collapse();
                                countrySearchKey = '';
                                setState(() {});
                              },
                            ),
                            Expanded(
                              child: Text(countryData.countryName ?? '',
                                  style: AppFonts.f50014Grey),
                            ),
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

  Widget emailRelationTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: emailRelationTileController,
          title: Text("Email Relation", style: AppFonts.f50014Black),
          subtitle:
              Text(selectedEmailRelation?.desc ?? '', style: AppFonts.f50012),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: mobileRelationList.length,
              itemBuilder: (context, index) {
                EmailRelationDetails emailData = emailRelationList[index];
                return InkWell(
                  onTap: () {
                    selectedEmailRelation = emailData;
                    emailRelationTileController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: emailData.code,
                        groupValue: selectedEmailRelation?.code,
                        onChanged: (value) {
                          selectedEmailRelation = emailData;
                          emailRelationTileController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(emailData.desc ?? '', style: AppFonts.f50014Grey),
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

  Widget mobileRelationTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: mobileRelationTileController,
          title: Text("Mobile Relation", style: AppFonts.f50014Black),
          subtitle:
              Text(selectedMobileRelation?.desc ?? '', style: AppFonts.f50012),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: mobileRelationList.length,
              itemBuilder: (context, index) {
                MobileRelationDetails mobileData = mobileRelationList[index];

                return InkWell(
                  onTap: () {
                    selectedMobileRelation = mobileData;
                    mobileRelationTileController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: mobileData.code,
                        groupValue: selectedMobileRelation?.code,
                        onChanged: (value) {
                          selectedMobileRelation = mobileData;
                          mobileRelationTileController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(mobileData.desc ?? '', style: AppFonts.f50014Grey),
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

  Widget addressTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: addressTileController,
            title: Text("Address Type", style: AppFonts.f50014Black),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(selectedAddress?.desc ?? '', style: AppFonts.f50012),
              ],
            ),
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: addressTypeList.length,
                  itemBuilder: (context, index) {
                    AddressTypeData addressData = addressTypeList[index];

                    return InkWell(
                      onTap: () {
                        selectedAddress = addressData;
                        addressTileController.collapse();
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Radio(
                            value: addressData.code,
                            groupValue: selectedAddress?.code,
                            onChanged: (value) {
                              selectedAddress = addressData;
                              addressTileController.collapse();
                              setState(() {});
                            },
                          ),
                          Text(addressData.desc ?? '',
                              style: AppFonts.f50014Grey),
                        ],
                      ),
                    );
                  })
            ],
          )),
    );
  }
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
