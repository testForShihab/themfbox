import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Registration/NriInfo/nri_data_response.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/Config.dart';

import '../../../api/onBoarding/CommonOnBoardApi.dart';
import '../../../rp_widgets/CalculateButton.dart';
import '../../../rp_widgets/RpSmallTf.dart';
import '../../../utils/AppFonts.dart';
import '../../../utils/Utils.dart';
import 'nri_country_list_response.dart';

class NriInfo extends StatefulWidget {
  const NriInfo({super.key});

  @override
  State<NriInfo> createState() => _NriInfoState();
}

class _NriInfoState extends State<NriInfo> {
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  String user_name = GetStorage().read("user_name");
  String bse_nse_mfu_flag = Get.arguments;

  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final address3Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinController = TextEditingController();

  String countryCode = "";

  ExpansionTileController countryController = ExpansionTileController();
  List<CountryData> countryList = [];
  String selectedCountry = '';

  NriData nriInfo = NriData();

  Future getNriCountry() async {
    if (countryList.isNotEmpty) return -1;

    Map data = await CommonOnBoardApi.getNriNreCountryList(
        client_name: client_name,
        bse_nse_mfu_flag: bse_nse_mfu_flag,
        user_id: user_id);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    List list = data['list'];
    countryList = list.map((e) {
      return CountryData.fromJson(e);
    }).toList();

    final country = countryList.firstWhereOrNull((e) => e.code == 'IND');
    selectedCountry = country?.desc ?? '';
    countryCode = country?.code ?? '';

    return 0;
  }

  Future getNriInfo() async {
    if (nriInfo.nriState != null) return 0;

    Map data = await CommonOnBoardApi.getNriInfo(
      user_id: user_id,
      client_name: client_name,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    Map<String, dynamic> result = data['result'];
    nriInfo = NriData.fromJson(result);

    return 0;
  }

  CountryData? findCountryWithCode(String code) {
    if (code.isEmpty) return null;
    return countryList.firstWhere((e) => e.code == code);
  }

  fillData() {
    address1Controller.text = nriInfo.nriAddress1 ?? '';
    address2Controller.text = nriInfo.nriAddress2 ?? '';
    address3Controller.text = nriInfo.nriAddress3 ?? '';
    cityController.text = nriInfo.nriCity ?? '';
    stateController.text = nriInfo.nriState ?? '';
    pinController.text = nriInfo.nriPincode ?? '';
    final country = findCountryWithCode(nriInfo.nriCountry ?? '');
    if (country != null) {
      selectedCountry = country.desc ?? '';
      countryCode = country.code ?? '';
    }
  }

  Future saveNriInfo() async {
    EasyLoading.show();

    Map data = await CommonOnBoardApi.saveNriInfo(
        user_id: user_id,
        client_name: client_name,
        bse_nse_mfu_flag: bse_nse_mfu_flag,
        nri_address1: address1Controller.text,
        nri_address2: address2Controller.text,
        nri_address3: address3Controller.text,
        nri_city: cityController.text,
        nri_state: stateController.text,
        nri_pincode: pinController.text,
        nri_country: countryCode);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    EasyLoading.dismiss();
    return 0;
  }

  Future getData() async {
    if (countryList.isNotEmpty) return;
    EasyLoading.show();
    await getNriCountry();
    await getNriInfo();
    fillData();
    EasyLoading.dismiss();
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: rpAppBar(
                title: 'NRI Info',
                bgColor: Config.appTheme.themeColor,
                foregroundColor: Colors.white),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        AmountInputCard(
                          title: 'NRI Address Line 1',
                          suffixText: '',
                          // initialValue: address1,
                          controller: address1Controller,
                          hasSuffix: false,
                          keyboardType: TextInputType.name,
                          borderRadius: BorderRadius.circular(20),
                          onChange: (val) {},
                        ),
                        SizedBox(height: 8),
                        AmountInputCard(
                            title: 'NRI Address Line 2 [Optional]',
                            suffixText: '',
                            // initialValue: address2,
                            controller: address2Controller,
                            hasSuffix: false,
                            keyboardType: TextInputType.name,
                            borderRadius: BorderRadius.circular(20),
                            onChange: (val) => {}),
                        SizedBox(height: 8),
                        AmountInputCard(
                            title: 'NRI Address Line 3 [Optional]',
                            suffixText: '',
                            // initialValue: address3,
                            controller: address3Controller,
                            hasSuffix: false,
                            keyboardType: TextInputType.name,
                            borderRadius: BorderRadius.circular(20),
                            onChange: (val) => {}),
                        SizedBox(height: 8),
                        AmountInputCard(
                          title: 'NRI City',
                          suffixText: '',
                          // initialValue: nriCity,
                          controller: cityController,
                          hasSuffix: false,
                          keyboardType: TextInputType.name,
                          borderRadius: BorderRadius.circular(20),
                          onChange: (val) => {},
                        ),
                        SizedBox(height: 8),
                        AmountInputCard(
                          title: 'NRI State',
                          suffixText: '',
                          // initialValue: nriState,
                          controller: stateController,
                          hasSuffix: false,
                          keyboardType: TextInputType.name,
                          borderRadius: BorderRadius.circular(20),
                          onChange: (val) => {},
                        ),
                        SizedBox(height: 8),
                        AmountInputCard(
                          title: 'NRI Pincode',
                          suffixText: '',
                          // initialValue: nriPincode,
                          controller: pinController,
                          hasSuffix: false,
                          keyboardType: TextInputType.number,
                          borderRadius: BorderRadius.circular(20),
                          onChange: (val) => {},
                        ),
                        SizedBox(height: 8),
                        countryOfBrithTile(context),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                  CalculateButton(
                    text: "CONTINUE",
                    onPress: () async {
                      int isValid = validator();
                      if (isValid != 0) {
                        Utils.showError(context, "All Fields are Mandatory");
                        return;
                      }

                      int res = await saveNriInfo();
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
      address1Controller.text,
      cityController.text,
      stateController.text,
      pinController.text,
    ];

    print("list = $list");
    if (list.contains(""))
      return -1;
    else
      return 0;
  }

  Widget countryTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: countryController,
          title: Text("NRI Country", style: AppFonts.f50014Black),
          subtitle: Text(selectedCountry, style: AppFonts.f50012),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: countryList.length,
              itemBuilder: (context, index) {
                CountryData data = countryList[index];
                String desc = data.desc ?? '';
                String code = data.code ?? '';

                return InkWell(
                  onTap: () {
                    selectedCountry = desc;
                    countryCode = code;
                    countryController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: code,
                        groupValue: countryCode,
                        onChanged: (value) {
                          selectedCountry = desc;
                          countryCode = code;
                          countryController.collapse();
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

  searchVisibility(String title, String searchKey) {
    title = title.toLowerCase();
    searchKey = searchKey.toLowerCase();

    if (searchKey.isEmpty)
      return true;
    else {
      return title.contains(searchKey);
    }
  }

  String countrySearchKey = "";

  Widget countryOfBrithTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: countryController,
          title: Text("NRI Country", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedCountry, style: AppFonts.f50012),
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
                    CountryData data = countryList[index];
                    String desc = data.desc ?? '';
                    String code = data.code ?? '';

                    return true
                        ? Visibility(
                            visible: searchVisibility(desc, countrySearchKey),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  countryCode = code;
                                  selectedCountry = desc;
                                });
                              },
                              child: Row(
                                children: [
                                  Radio(
                                    value: code,
                                    groupValue: countryCode,
                                    onChanged: (val) {
                                      setState(() {
                                        countryCode = code;
                                        selectedCountry = desc;
                                      });
                                    },
                                  ),
                                  Expanded(
                                      child: Text(desc,
                                          style: AppFonts.f50014Grey)),
                                ],
                              ),
                            ),
                          )
                        : Visibility(
                            visible: searchVisibility(desc, countrySearchKey),
                            child: InkWell(
                              onTap: () {
                                log('+ ' * 100);
                                selectedCountry = desc;
                                countryCode = code;
                                setState(() {});
                                countryController.collapse();
                              },
                              child: Row(
                                children: [
                                  Radio(
                                    value: code,
                                    groupValue: countryCode,
                                    onChanged: (value) {
                                      log('.. ' * 100);
                                      log('code: $code');
                                      log('desc: $desc');
                                      selectedCountry = desc;
                                      countryCode = code;
                                      countryController.collapse();
                                      setState(() {});
                                    },
                                  ),
                                  Expanded(
                                      child: Text(desc,
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
}
