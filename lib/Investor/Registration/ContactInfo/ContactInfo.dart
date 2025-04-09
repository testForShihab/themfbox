import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Registration/ContactInfo/ContactInfoPojo.dart';
import 'package:mymfbox2_0/api/onBoarding/CommonOnBoardApi.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/Loading.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import 'package:mymfbox2_0/rp_widgets/CalculateButton.dart';

class ContactInfo extends StatefulWidget {
  const ContactInfo({super.key});

  @override
  State<ContactInfo> createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  String bse_nse_mfu_flag = Get.arguments;
  ExpansionTileController addressController = ExpansionTileController();

  String addressType = 'Residential or Business';
  String addressTypeCode = "1";

  String pincode = "",
      city = "",
      state = "",
      stateCode = "",
      address1 = "",
      address2 = "",
      address3 = "",
      country = "India";

  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  Future getCityStateByPincode() async {
    Map data = await CommonOnBoardApi.getCityStateByPincode(
      user_id: user_id,
      client_name: client_name,
      pincode: pincode,
      bse_nse_mfu_flag: bse_nse_mfu_flag,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    city = data['result']['city'];
    state = data['result']['state'];
    stateCode = data['result']['state_code'];

    cityController.text = city;
    stateController.text = state;

    return 0;
  }

  Future saveContactInfo() async {
    EasyLoading.show();
    Map data = await CommonOnBoardApi.saveContactInfo(
      user_id: user_id,
      client_name: client_name,
      pincode: pincode,
      city: city,
      state: state,
      state_code: stateCode,
      address1: address1,
      address2: address2,
      address3: address3,
      country: "India",
      bse_nse_mfu_flag: bse_nse_mfu_flag,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    EasyLoading.dismiss();
    return 0;
  }

  ContactInfoPojo contactInfo = ContactInfoPojo();

  Future getContactInfo() async {
    if (contactInfo.pincode != null) return 0;

    Map data = await CommonOnBoardApi.getContactInfo(
        user_id: user_id,
        client_name: client_name,
        bse_nse_mfu_flag: bse_nse_mfu_flag);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    Map<String, dynamic> result = data['result'];
    contactInfo = ContactInfoPojo.fromJson(result);

    fillData();

    return 0;
  }

  void fillData() {
    pincode = "${contactInfo.pincode}";
    city = "${contactInfo.city}";
    cityController.text = city;
    state = "${contactInfo.state}";
    stateController.text = state;
    stateCode = "${contactInfo.stateCode}";
    address1 = "${contactInfo.address1}";
    address2 = "${contactInfo.address2}";
    address3 = "${contactInfo.address3}";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getContactInfo(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: rpAppBar(
                title: 'Contact Info',
                bgColor: Config.appTheme.themeColor,
                foregroundColor: Colors.white),
            body: (!snapshot.hasData)
                ? Loading()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              AmountInputCard(
                                title: 'Pin Code',
                                suffixText: '',
                                initialValue: pincode,
                                hasSuffix: false,
                                keyboardType: TextInputType.number,
                                borderRadius: BorderRadius.circular(20),
                                onChange: (val) async {
                                  pincode = val;
                                  if (pincode.length != 6) return;
                                  await getCityStateByPincode();
                                  setState(() {});
                                },
                              ),
                              SizedBox(height: 16),
                              AmountInputCard(
                                title: 'City',
                                controller: cityController,
                                suffixText: '',
                                hasSuffix: false,
                                keyboardType: TextInputType.name,
                                borderRadius: BorderRadius.circular(20),
                                onChange: (val) {
                                  setState(() {
                                    city = val;
                                  });
                                  cityController.text = val;
                                },
                              ),
                              SizedBox(height: 16),
                              AmountInputCard(
                                title: 'State',
                                controller: stateController,
                                suffixText: '',
                                hasSuffix: false,
                                keyboardType: TextInputType.name,
                                borderRadius: BorderRadius.circular(20),
                                onChange: (val) {
                                  setState(() {
                                    state = val;
                                  });
                                  stateController.text = val;
                                },
                              ),
                              SizedBox(height: 16),
                              AmountInputCard(
                                title: 'Address Line 1',
                                suffixText: '',
                                initialValue: address1,
                                hasSuffix: false,
                                keyboardType: TextInputType.name,
                                borderRadius: BorderRadius.circular(20),
                                onChange: (val) => address1 = val,
                              ),
                              SizedBox(height: 16),
                              AmountInputCard(
                                title: 'Address Line 2 [Optional]',
                                suffixText: '',
                                initialValue: address2,
                                hasSuffix: false,
                                keyboardType: TextInputType.name,
                                borderRadius: BorderRadius.circular(20),
                                onChange: (val) => address2 = val,
                              ),
                              SizedBox(height: 16),
                              AmountInputCard(
                                title: 'Address Line 3 [Optional]',
                                suffixText: '',
                                initialValue: address3,
                                hasSuffix: false,
                                keyboardType: TextInputType.name,
                                borderRadius: BorderRadius.circular(20),
                                onChange: (val) => address3 = val,
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                        CalculateButton(
                          text: "CONTINUE",
                          onPress: () async {
                            await getCityStateByPincode();
                            print("stateCode- $stateCode");
                            if (pincode.isEmpty) {
                              Utils.showError(context, "Please Enter Pincode");
                              return;
                            }
                            if (city.isEmpty) {
                              Utils.showError(context, "Please Enter City");
                              return;
                            }
                            if (state.isEmpty) {
                              Utils.showError(context, "Please Enter State");
                              return;
                            }
                            if (address1.isEmpty) {
                              Utils.showError(
                                  context, "Please Enter Address Line 1");
                              return;
                            }
                            int res = await saveContactInfo();
                            if (res == 0) Get.back();
                          },
                        )
                      ],
                    ),
                  ),
          );
        });
  }
}
