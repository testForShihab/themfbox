import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/EkycApi.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpSmallTf.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class Declaration extends StatefulWidget {
  const Declaration({super.key});

  @override
  State<Declaration> createState() => _DeclarationState();
}

class _DeclarationState extends State<Declaration> {
  int user_id = GetStorage().read('user_id');
  String client_name = GetStorage().read('client_name');
  String ekyc_id = GetStorage().read('ekyc_id');

  bool sameAddress = false;
  String tin = "", birthPlace = "";
  String address = "", city = "", district = "", postalCode = "";

  List countryList = [];
  Future getCountryList() async {
    if (countryList.isNotEmpty) return 0;

    Map data = await EkycApi.getCountryList(
        user_id: user_id, client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    countryList = data['list'];
    return 0;
  }

  List stateList = [];
  Future getStateList() async {
    if (stateList.isNotEmpty) return 0;

    Map data =
        await EkycApi.getStateList(user_id: user_id, client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    stateList = data['list'];
    return 0;
  }

  Future getDatas() async {
    await getCountryList();
    await getStateList();
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: rpAppBar(
              title: "Declaration",
              bgColor: Config.appTheme.themeColor,
              foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("FATCA/CRS Details", style: AppFonts.f50014Grey),
                        SizedBox(height: 16),
                        pepRadioTile(),
                        SizedBox(height: 16),
                        rpepRadioTile(),
                        SizedBox(height: 16),
                        outsideIndiaRadioTile(),
                        DottedLine(verticalPadding: 4),
                        if (outsideIndia) ...additionalDetails(),
                        Text("FATCA Address", style: AppFonts.f50014Grey),
                        Row(
                          children: [
                            Checkbox(
                                value: sameAddress,
                                onChanged: (val) {
                                  sameAddress = !sameAddress;
                                  setState(() {});
                                }),
                            Text("Same as correspondence address",
                                style: AppFonts.f50014Grey),
                          ],
                        ),
                        Visibility(
                            visible: !sameAddress,
                            child: Column(
                              children: [
                                AmountInputCard(
                                  title: "Address",
                                  suffixText: "",
                                  hasSuffix: false,
                                  borderRadius: BorderRadius.circular(20),
                                  onChange: (val) {},
                                ),
                                SizedBox(height: 16),
                                AmountInputCard(
                                  title: "City/Town/Vilage",
                                  suffixText: "",
                                  hasSuffix: false,
                                  borderRadius: BorderRadius.circular(20),
                                  onChange: (val) {},
                                ),
                                SizedBox(height: 16),
                                AmountInputCard(
                                  title: "District",
                                  suffixText: "",
                                  hasSuffix: false,
                                  borderRadius: BorderRadius.circular(20),
                                  onChange: (val) {},
                                ),
                                SizedBox(height: 16),
                                //state list
                                //country list
                                AmountInputCard(
                                  title: "Postal Zip Code",
                                  suffixText: "",
                                  hasSuffix: false,
                                  borderRadius: BorderRadius.circular(20),
                                  onChange: (val) {},
                                ),
                                SizedBox(height: 16),
                              ],
                            )),
                        DottedLine(),
                        Text('Related Person Details',
                            style: AppFonts.f50014Grey),
                        SizedBox(height: 16),
                        relativeRadioTile(),
                      ],
                    ),
                  ),
                  CalculateButton(
                    text: "CONTINUE",
                    onPress: () async {
                      int res = await updateDeclarationWithProof();
                      if (res == 0) Get.back();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future updateDeclarationWithProof() async {
    EasyLoading.show();

    Map data = await EkycApi.updateDeclarationWithProof(
        user_id: user_id,
        client_name: client_name,
        ekyc_id: ekyc_id,
        pepPerson: pep ? "YES" : "NO",
        rpepPerson: rpep ? "YES" : "NO",
        resOutside: outsideIndia ? "YES" : "NO",
        relPerson: isrelative ? "YES" : "NO",
       /* countryCodeJurisdictionResidence: jCountryCode,
        countryJurisdictionResidence: jCountry,
        taxIdentificationNumber: tin,*/
        placeOfBirth: birthPlace,
        countryCodeOfBirth: birthCountryCode,
        countryOfBirth: birthCountry,
        addressCity: city,
        addressDistrict: district,
        addressStateCode: stateCode,
        addressState: state,
        addressCountryCode: "",
        addressCountry: "",
        addressPincode: postalCode,
        address: address,
        addressType: "",
        relatedPersonType: "",
        relatedPersonName: "",
        relatedPersonKycNumberExists: "",
        relatedPersonKycNumber: "",
        relatedPersonTitle: "",
        relatedPersonIdentityProofType: "",
        proofType: "",
        proofName: "",
        proofDob: "",
        proofNumber: "",
        fatherName: "",
        proofDistrict: "",
        proofCity: "",
        proofPincode: "",
        proofState: "",
        proofAddress: "",
        issueDate: "",
        expiryDate: "");

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    EasyLoading.dismiss();
    return 0;
  }

  bool pep = true;
  Widget pepRadioTile() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Are you a politically exposed person (PEP) ?",
              style: AppFonts.f50014Black),
          Row(
            children: [
              Radio(
                  value: true,
                  groupValue: pep,
                  onChanged: (val) {
                    pep = val as bool;
                    setState(() {});
                  }),
              Text("Yes", style: AppFonts.f50014Black),
              Radio(
                  value: false,
                  groupValue: pep,
                  onChanged: (val) {
                    pep = val as bool;
                    setState(() {});
                  }),
              Text("No", style: AppFonts.f50014Black)
            ],
          ),
        ],
      ),
    );
  }

  bool rpep = true;
  Widget rpepRadioTile() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Are you a related to a politically exposed person (RPEP) ?",
              style: AppFonts.f50014Black),
          Row(
            children: [
              Radio(
                  value: true,
                  groupValue: rpep,
                  onChanged: (val) {
                    rpep = val as bool;
                    setState(() {});
                  }),
              Text("Yes", style: AppFonts.f50014Black),
              Radio(
                  value: false,
                  groupValue: rpep,
                  onChanged: (val) {
                    rpep = val as bool;
                    setState(() {});
                  }),
              Text("No", style: AppFonts.f50014Black)
            ],
          ),
        ],
      ),
    );
  }

  bool outsideIndia = true;
  Widget outsideIndiaRadioTile() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Are you a resident outside India?",
              style: AppFonts.f50014Black),
          Row(
            children: [
              Radio(
                  value: true,
                  groupValue: outsideIndia,
                  onChanged: (val) {
                    outsideIndia = val as bool;
                    setState(() {});
                  }),
              Text("Yes", style: AppFonts.f50014Black),
              Radio(
                  value: false,
                  groupValue: outsideIndia,
                  onChanged: (val) {
                    outsideIndia = val as bool;
                    setState(() {});
                  }),
              Text("No", style: AppFonts.f50014Black)
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> additionalDetails() {
    return [
      Text("Additional Details", style: AppFonts.f50014Grey),
      SizedBox(height: 16),
      countryExpansionTile(),
      SizedBox(height: 16),
      AmountInputCard(
        title: "Tax Identification Number",
        suffixText: "",
        hasSuffix: false,
        borderRadius: BorderRadius.circular(20),
        onChange: (val) => tin = val,
        keyboardType: TextInputType.name,
      ),
      SizedBox(height: 16),
      AmountInputCard(
        title: "Place/City of Birth",
        suffixText: "",
        hasSuffix: false,
        borderRadius: BorderRadius.circular(20),
        onChange: (val) => city = val,
        keyboardType: TextInputType.name,
      ),
      SizedBox(height: 16),
      bCountryExpansionTile(),
      SizedBox(height: 16),
      stateExpansionTile(),
      DottedLine(verticalPadding: 4),
    ];
  }

  ExpansionTileController jCountryController = ExpansionTileController();
  String jCountry = "";
  String jCountryCode = "";
  String jSearchKey = "";

  Widget countryExpansionTile() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: jCountryController,
          title: Text("Country of Jurisdiction of Residence",
              style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(jCountry, style: AppFonts.f50012),
            ],
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: RpSmallTf(
                initialValue: jSearchKey,
                onChange: (val) {
                  jSearchKey = val;
                  setState(() {});
                },
                borderColor: Colors.black,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: countryList.length,
              // itemCount: 10,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Map map = countryList[index];
                String country = map['country_name'];
                String code = map['country_code'];

                return Visibility(
                  visible: Utils.searchVisibility(country, jSearchKey),
                  child: InkWell(
                    onTap: () {
                      jCountry = country;
                      jCountryCode = code;
                      jCountryController.collapse();
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        Radio(
                          value: country,
                          groupValue: jCountry,
                          onChanged: (value) {
                            jCountry = country;
                            jCountryCode = code;
                            jCountryController.collapse();
                            setState(() {});
                          },
                        ),
                        Text(country),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ExpansionTileController bcountryController = ExpansionTileController();
  String birthCountry = "";
  String birthCountryCode = "";
  Widget bCountryExpansionTile() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: bcountryController,
          title: Text("Country of Birth", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(birthCountry, style: AppFonts.f50012),
            ],
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: countryList.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Map map = countryList[index];
                String country = map['country_name'];
                String code = map['country_code'];

                return InkWell(
                  onTap: () {
                    birthCountry = country;
                    birthCountryCode = code;
                    bcountryController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: country,
                        groupValue: birthCountry,
                        onChanged: (value) {
                          birthCountry = country;
                          birthCountryCode = code;
                          bcountryController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(country),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ExpansionTileController stateController = ExpansionTileController();
  String state = "";
  String stateCode = "";
  String stateSearchKey = "";
  Widget stateExpansionTile() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: stateController,
          title: Text("State", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(state, style: AppFonts.f50012),
            ],
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: RpSmallTf(
                initialValue: stateSearchKey,
                onChange: (val) {
                  stateSearchKey = val;
                  setState(() {});
                },
                borderColor: Colors.black,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: stateList.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Map map = stateList[index];
                String country = map['country_name'];
                String code = map['country_code'];

                return Visibility(
                  visible: Utils.searchVisibility(country, stateSearchKey),
                  child: InkWell(
                    onTap: () {
                      state = country;
                      stateCode = code;
                      stateController.collapse();
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        Radio(
                          value: country,
                          groupValue: jCountry,
                          onChanged: (value) {
                            state = country;
                            stateCode = code;
                            stateController.collapse();
                            setState(() {});
                          },
                        ),
                        Text(country),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  bool isrelative = false;
  Widget relativeRadioTile() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Are you a related person to this investor ?",
              style: AppFonts.f50014Black),
          Row(
            children: [
              Radio(
                  value: true,
                  groupValue: isrelative,
                  onChanged: (val) {
                    // isrelative = val as bool;
                    // setState(() {});
                  }),
              Text("Yes", style: AppFonts.f50014Black),
              Radio(
                  value: false,
                  groupValue: isrelative,
                  onChanged: (val) {
                    // isrelative = val as bool;
                    // setState(() {});
                  }),
              Text("No", style: AppFonts.f50014Black)
            ],
          ),
        ],
      ),
    );
  }
}
