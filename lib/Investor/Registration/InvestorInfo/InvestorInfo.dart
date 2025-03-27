import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Registration/InvestorInfo/InvestorInfoPojo.dart';
import 'package:mymfbox2_0/Investor/Registration/InvestorInfo/MfuInvestorInfo.dart';
import 'package:mymfbox2_0/api/onBoarding/CommonOnBoardApi.dart';
import 'package:mymfbox2_0/api/onBoarding/nse/NseOnBoardApi.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/CalculateButton.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class InvestorInfo extends StatefulWidget {
  const InvestorInfo({super.key});

  @override
  State<InvestorInfo> createState() => _InvestorInfoState();
}

class _InvestorInfoState extends State<InvestorInfo> {
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  String user_pan = GetStorage().read("user_pan");
  String bse_nse_mfu_flag = Get.arguments;
  String client_code = "";
  Iterable keys = GetStorage().getKeys();

  ExpansionTileController taxStatusController = ExpansionTileController();
  ExpansionTileController holdingNatureController = ExpansionTileController();

  List taxStatusList = [];

  String taxStatus = "";
  String taxStatusCode = "";

  List holdingNatureList = [];
  String holdingNature = "";
  String holdingNatureCode = "";

  String kycStatus = "";
  String successMsg = "The PAN is KYC complaint.";

  TextStyle successStyle = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 12, color: AppColors.textGreen);
  TextStyle errorStyle = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 12, color: AppColors.lossRed);

  Future checkPanKycStatus() async {
    EasyLoading.show();

    Map data = await CommonOnBoardApi.checkPanKycStatus(
        user_id: user_id, client_name: client_name, pan: user_pan);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    kycStatus = data['msg'];

    EasyLoading.dismiss();

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
    fillData();

    return 0;
  }

  void fillData() {
    taxStatus = "${investorInfo.taxStatusDes}";
    taxStatusCode = "${investorInfo.taxStatus}";
    holdingNature = "${investorInfo.holdingNatureDesc}";
    holdingNatureCode = "${investorInfo.holdingNature}";
    arn = "${investorInfo.brokerCode}";
  }

  List arnList = [];
  Future getArnCode() async {
    Map data = await CommonOnBoardApi.getArnCode(
      client_name: client_name,
      bse_nse_mfu_flag: bse_nse_mfu_flag,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    arnList = data['broker_code_list'];
    arn = arnList.first;

    return 0;
  }

  Future getTaxStatus() async {
    if (taxStatusList.isNotEmpty) return -1;
    Map data = await CommonOnBoardApi.getTaxStatus(
      client_name: client_name,
      bse_nse_mfu_flag: bse_nse_mfu_flag,
      inv_category: "",
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    taxStatusList = data['tax_list'];
    Map map = taxStatusList.first;
    taxStatus = map['tax_status'];
    taxStatusCode = map['tax_status_code'];

    return 0;
  }

  Future getHoldingNature() async {
    if (holdingNatureList.isNotEmpty) return -1;
    Map data = await CommonOnBoardApi.getHoldingNature(
      client_name: client_name,
      bse_nse_mfu_flag: bse_nse_mfu_flag,
      tax_status_code: taxStatusCode,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    holdingNatureList = data['list'];
    Map map = holdingNatureList.first;
    holdingNature = map['desc'];
    holdingNatureCode = map['code'];

    return 0;
  }

  Future getDatas() async {
    EasyLoading.show();

    await getArnCode();
    await getTaxStatus();
    await getHoldingNature();
    await getInvestorInfo();
    await checkPanKycStatus();

    EasyLoading.dismiss();

    return 0;
  }

  Future saveInvestorInfo() async {
    EasyLoading.show();

    Map data = await CommonOnBoardApi.saveInvestorInfo(
      user_id: user_id,
      client_name: client_name,
      tax_status: taxStatusCode,
      tax_status_des: taxStatus,
      holding_nature: holdingNatureCode,
      holding_nature_desc: holdingNature,
      broker_code: arn,
      pan: user_pan,
      bse_client_code: (bse_nse_mfu_flag == "BSE" && ((keys.contains("adminAsInvestor")) || (keys.contains("adminAsFamily")) == true)) ? client_code : "",
      inv_category: "",
      bse_nse_mfu_flag: bse_nse_mfu_flag,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    EasyLoading.dismiss();
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    if (bse_nse_mfu_flag == "MFU") return MfuInvestorInfo();

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: rpAppBar(
                title: "Investor Info",
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
                      if(bse_nse_mfu_flag == "BSE" && ((keys.contains("adminAsInvestor")) || (keys.contains("adminAsFamily")) == true))  AmountInputCard(
                          title: "BSE Client Code (Optional)",
                          initialValue: client_code ?? "",
                          suffixText: "",
                          hasSuffix: false,
                          keyboardType: TextInputType.name,
                          borderRadius: BorderRadius.circular(20),
                          onChange: (val) => client_code = val,
                        ),
                        SizedBox(height: 16),
                        arnTile(context),
                        SizedBox(height: 16),
                        taxStatusTile(context),
                        SizedBox(height: 16),
                        holdingNatureTile(context),
                        SizedBox(height: 16),
                        AmountInputCard(
                          title: "PAN Number",
                          initialValue: user_pan,
                          //readOnly: true,
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
                          onChange: (val) {},
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  CalculateButton(
                    text: "CONTINUE",
                    onPress: () async {
                      int res = await saveInvestorInfo();
                      if (res == 0) Get.back();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  alreadyHasBottomSheet({required String msg, required List iinList}) {
    String iin = iinList.first;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, bottomState) {
          return Column(
            children: [
              BottomSheetTitle(title: "Already Registered"),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(msg),
                    SizedBox(height: 16),
                    DropdownButtonFormField(
                      decoration: InputDecoration(),
                      value: iin,
                      items: iinList
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        iin = "$val";
                        bottomState(() {});
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: PlainButton(
                          text: "Cancel",
                          onPressed: () async {
                            await saveInvestorInfo();
                            Get.back();
                            Get.back();
                          },
                          padding: EdgeInsets.symmetric(vertical: 8)),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: RpFilledButton(
                          text: "Continue",
                          onPressed: () async {
                            Map data = await NseOnBoardApi
                                .getNseUserDetailsByIINNumberAndBrokerCode(
                                    investor_id: user_id,
                                    client_name: client_name,
                                    iin_no: iin);
                            if (data['status'] != 200) {
                              Utils.showError(context, data['msg']);
                              return 0;
                            }
                          },
                          padding: EdgeInsets.symmetric(vertical: 8)),
                    )
                  ],
                ),
              )
            ],
          );
        });
      },
    );
  }

  ExpansionTileController arnController = ExpansionTileController();
  String arn = "";
  Widget arnTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: arnController,
          title: Text("ARN Number", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(arn, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: arnList.length,
              itemBuilder: (context, index) {
                String title = arnList[index];

                return InkWell(
                  onTap: () {
                    arn = title;
                    arnController.collapse();
                    // validateTaxStatus();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: title,
                        groupValue: arn,
                        onChanged: (val) {
                          arn = title;
                          arnController.collapse();
                          // validateTaxStatus();
                          setState(() {});
                        },
                      ),
                      Text(title, style: AppFonts.f50014Grey),
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

  Widget taxStatusTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: taxStatusController,
          title: Text("Tax Status", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(taxStatus, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: taxStatusList.length,
              itemBuilder: (context, index) {
                Map map = taxStatusList[index];
                String status = map['tax_status'];
                String statusCode = map['tax_status_code'];

                return InkWell(
                  onTap: () async {
                    taxStatus = status;
                    taxStatusCode = statusCode;
                    taxStatusController.collapse();
                    // validateTaxStatus();
                    holdingNatureList = [];
                    await getHoldingNature();
                    setState(() {});

                  },
                  child: Row(
                    children: [
                      Radio(
                        value: status,
                        groupValue: taxStatus,
                        onChanged: (val) async {
                          taxStatus = status;
                          taxStatusCode = statusCode;
                          taxStatusController.collapse();
                          // validateTaxStatus();
                          holdingNatureList = [];
                          await getHoldingNature();
                          setState(() {});

                        },
                      ),
                      Text(status, style: AppFonts.f50014Grey),
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

  validateTaxStatus() {
    List list = ["Individual", "NRO", "NRE"];
    if (!list.contains(taxStatus)) {
      holdingNature = "change nature";
      holdingNatureCode = "change nature code";
      setState(() {});
    }
  }

  Widget holdingNatureTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: holdingNatureController,
          title: Text("Holding Nature", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(holdingNature, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: holdingNatureList.length,
              itemBuilder: (context, index) {
                Map map = holdingNatureList[index];

                String status = map['desc'];
                String statusCode = map['code'];

                return InkWell(
                  onTap: () {
                    holdingNature = status;
                    holdingNatureCode = statusCode;
                    holdingNatureController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: status,
                        groupValue: holdingNature,
                        onChanged: (value) {
                          holdingNature = status;
                          holdingNatureCode = statusCode;
                          holdingNatureController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(status, style: AppFonts.f50014Grey),
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
