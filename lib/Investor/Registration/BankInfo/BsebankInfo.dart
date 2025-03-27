import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mymfbox2_0/Investor/Registration/BankInfo/MfuBankInfo.dart';
import 'package:mymfbox2_0/api/onBoarding/CommonOnBoardApi.dart';
import 'package:mymfbox2_0/pojo/onboarding/OnboardingStatusPojo.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/Loading.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpSmallTf.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class BseBankInfo extends StatefulWidget {
  const BseBankInfo({super.key});

  @override
  State<BseBankInfo> createState() => _BseBankInfoState();
}

class _BseBankInfoState extends State<BseBankInfo> {
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  String bse_nse_mfu_flag = Get.arguments;

  ExpansionTileController bankController = ExpansionTileController();
  ExpansionTileController accountTypeController = ExpansionTileController();

  List accountTypeList = [];

  String bankCode = "";
  String accountType = "";
  String accountTypeCode = "";

  String ifsc = "",
      micr = "",
      bankName = "",
      branchName = "",
      bankAddress = "",
      accNumber = "",
      accHolderName = "",
      accDesc = "desc";

  Map bankMap = {};
  Future getBankList() async {
    if (bankMap.isNotEmpty) return 0;

    Map data = await CommonOnBoardApi.getBankList(
      user_id: user_id,
      client_name: client_name,
      bse_nse_mfu_flag: bse_nse_mfu_flag,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    List list = data['list'];
    for (var element in list) {
      String bank_name = element['bank_name'];
      String bank_code = element['bank_code'];

      bankMap[bank_name] = bank_code;
    }
    return 0;
  }

  Future getAccountTypeList() async {
    if (accountTypeList.isNotEmpty) return -1;

    Map data = await CommonOnBoardApi.getBankAccountType(
        client_name: client_name,
        bse_nse_mfu_flag: bse_nse_mfu_flag,
        tax_status: tax_status);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    accountTypeList = data['list'];
    return 0;
  }

  Future validateIfsc() async {
    EasyLoading.show();

    Map data = await CommonOnBoardApi.validateIfscCode(
      user_id: user_id,
      client_name: client_name,
      ifsc: ifsc,
      bank_name: bankName,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    Map result = data['result'];
    branchName = result['branch'];
    bankAddress = result['centre'];
    micr = result['micr_code'];

    EasyLoading.dismiss();

    return 0;
  }

  Future saveBankInfo() async {
    EasyLoading.show();

    Map data = await CommonOnBoardApi.saveBankInfo(
      user_id: user_id,
      client_name: client_name,
      ifsc_code: ifsc,
      micr_code: micr,
      bank_name: bankName,
      bank_code: bankCode,
      branch_name: branchName,
      bank_address: bankAddress,
      account_number: accNumber,
      account_holder_name: accHolderName,
      account_type: accountTypeCode,
      bank_mode: "NODAL",
      bank_proof: '',
      bse_nse_mfu_flag: bse_nse_mfu_flag,
    );

    if (data['status'] != 200) {
      if (EasyLoading.isShow) EasyLoading.dismiss();
      Utils.showError(context, data['msg']);
      return -1;
    }
    EasyLoading.dismiss();
    return 0;
  }

  String tax_status = "";
  Future getInvestorInfo() async {
    if (tax_status.isNotEmpty) return 0;

    Map data = await CommonOnBoardApi.getInvestorInfo(
        user_id: user_id,
        client_name: client_name,
        bse_nse_mfu_flag: bse_nse_mfu_flag);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    Map result = data['result'];
    tax_status = result['tax_status'];

    return 0;
  }

  Map bankInfo = {};
  Future getBankInfo() async {
    if (bankInfo.isNotEmpty) return 0;

    Map data = await CommonOnBoardApi.getBankInfo(
        user_id: user_id,
        client_name: client_name,
        bse_nse_mfu_flag: bse_nse_mfu_flag);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    bankInfo = data['result'];

    fillData();
    return 0;
  }

  Result result = Result();
  List<MenuList> menuList = [];
  bool shouldShowCard = false;
  Future getOnboardingStatus() async {
    Map<String, dynamic> data = await CommonOnBoardApi.getOnBoardingStatus(
        user_id: user_id,
        client_name: client_name,
        bse_nse_mfu_flag: bse_nse_mfu_flag);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    OnboardingStatusPojo pojo = OnboardingStatusPojo.fromJson(data);
    result = pojo.result!;
    menuList = result.menuList ?? [];
    shouldShowCard = menuList.any(
        (menu) => menu.title == "Bank Details" && menu.checkRequiredOrNot!);
    return 0;
  }

  Future getDatas() async {
    await getBankList();
    await getInvestorInfo();
    await getAccountTypeList();
    await getBankInfo();
    await getOnboardingStatus();

    return 0;
  }

  void fillData() {
    bankName = bankInfo['bank_name'];
    bankCode = bankInfo['bank_code'];
    ifsc = bankInfo['ifsc_code'];
    branchName = bankInfo['branch_name'];
    bankAddress = bankInfo['bank_address'];
    accNumber = bankInfo['account_number'];
    accHolderName = bankInfo['account_holder_name'];
    accountTypeCode = bankInfo['account_type'];
    accountType = bankInfo['account_type_desc'];
  }

  late double devWidth, devHeight;

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;
    print("checkRequiredOrNot : $shouldShowCard");

    if (bse_nse_mfu_flag == "MFU") return MfuBankInfo();

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: rpAppBar(
                title: "Bank Details",
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
                              bankTile(context),
                              SizedBox(height: 16),
                              AmountInputCard(
                                  title: "IFSC Code",
                                  initialValue: ifsc,
                                  suffixText: "",
                                  hasSuffix: false,
                                  keyboardType: TextInputType.name,
                                  borderRadius: BorderRadius.circular(20),
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  onChange: (val) async {
                                    ifsc = val;
                                    if (ifsc.length != 11) return;
                                    await validateIfsc();
                                    setState(() {});
                                  },
                                  subTitle: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 16,
                                        color: AppColors.textGreen,
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        "Branch: $branchName",
                                        style: AppFonts.f50012.copyWith(
                                            color: AppColors.textGreen,
                                            fontSize: 12),
                                      ),
                                    ],
                                  )),
                              SizedBox(height: 16),
                              AmountInputCard(
                                title: "Account Number",
                                initialValue: accNumber,
                                suffixText: "",
                                hasSuffix: false,
                                keyboardType: TextInputType.name,
                                borderRadius: BorderRadius.circular(20),
                                onChange: (val) => accNumber = val,
                              ),
                              SizedBox(height: 16),
                              AmountInputCard(
                                title: "Account Holder Name",
                                initialValue: accHolderName,
                                suffixText: "",
                                hasSuffix: false,
                                keyboardType: TextInputType.name,
                                borderRadius: BorderRadius.circular(20),
                                onChange: (val) => accHolderName = val,
                              ),
                              SizedBox(height: 16),
                              accountTypeTile(context),
                              SizedBox(height: 16),
                              if (shouldShowCard) uploadContentTile(context),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                        Container(
                          width: devWidth,
                          padding: EdgeInsets.all(16),
                          color: Colors.white,
                          child: SizedBox(
                            width: devWidth * 0.76,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Config.appTheme.themeColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                textStyle: AppFonts.f50014Black.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                List list = [
                                  bankName,
                                  accNumber,
                                  accHolderName
                                ];
                                if (list.contains("")) {
                                  Utils.showError(
                                      context, "All Fields are Mandatory");
                                  return;
                                }

                                if (ifsc.length != 11) {
                                  Utils.showError(
                                      context, "Please Enter Valid IFSC Code");
                                  return;
                                }
                                if (shouldShowCard) {
                                  String fileName =
                                      await uploadCancelledCheque(context);
                                  int res1 = await saveCheque(fileName);
                                  if (res1 == -1) return;
                                }

                                int res2 = await saveBankInfo();
                                if (res2 == -1) return;
                                Get.back();
                              },
                              child: Text("CONTINUE"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        });
  }

  Future uploadCancelledCheque(BuildContext context) async {
    Map data = await CommonOnBoardApi.uploadCancelledCheque(
        client_name: client_name, user_id: user_id, file_path: chqImg!.path);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return "";
    }
    Map result = data['result'];
    String fileName = result['file_name'];
    return fileName;
  }

  Future saveCheque(String fileName) async {
    Map data = await CommonOnBoardApi.saveChequeImage(
        user_id: user_id, client_name: client_name, file_name: fileName);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    return 0;
  }

  Widget uploadContentTile(BuildContext context) {
    return Container(
      width: devWidth,
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset("assets/account_balance.png", height: 32),
              SizedBox(width: 10),
              Expanded(
                child: ColumnText(
                    title: "Upload Cancelled Cheque ",
                    value: "Please upload your cancelled cheque.",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013),
              ),
            ],
          ),
          SizedBox(height: 10),
          (chqImg != null) ? imgCard() : emptyCard(),
          SizedBox(height: 16)
        ],
      ),
    );
  }

  Widget imgCard() {
    return SizedBox(
      height: 200,
      width: double.maxFinite,
      child: Image.file(chqImg!, fit: BoxFit.fitWidth),
    );
  }

  Widget emptyCard() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Config.appTheme.mainBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 32),
          Image.asset("assets/checkbook.png", height: 40),
          Text(
            'No cancelled cheque added.',
            style: AppFonts.f40013,
          ),
          SizedBox(height: 8),
          SizedBox(
            width: devWidth * 0.76,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Config.appTheme.themeColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                textStyle: AppFonts.f50014Black.copyWith(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                showUploadOption();
              },
              child: Text("UPLOAD NOW"),
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  File? chqImg;
  showUploadOption() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Config.appTheme.mainBgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      )),
      builder: (context) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Upload Signature",
                      style: AppFonts.f50014Black.copyWith(fontSize: 18)),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Get.back();
                    },
                  )
                ],
              ),
            ),

            // RpListTile(title: Text("data"),subTitle: Text(),)
            Column(
              children: [
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: ListTile(
                    onTap: () async {
                      await getImageFromUser(source: ImageSource.gallery);
                    },
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    leading: Icon(Icons.image_outlined,
                        color: Config.appTheme.themeColor, size: 28),
                    title: Text("Upload From Gallery",
                        style: AppFonts.f50014Black
                            .copyWith(color: Config.appTheme.themeColor)),
                    subtitle: Text("Upload Signature done on white paper"),
                    subtitleTextStyle: AppFonts.f40013,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: ListTile(
                    onTap: () async {
                      await getImageFromUser(source: ImageSource.camera);
                    },
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    leading: Icon(Icons.image_outlined,
                        color: Config.appTheme.themeColor, size: 28),
                    title: Text("Open Camera",
                        style: AppFonts.f50014Black
                            .copyWith(color: Config.appTheme.themeColor)),
                    subtitle: Text("Sign on white paper and click from camera"),
                    subtitleTextStyle: AppFonts.f40013,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future getImageFromUser({required ImageSource source}) async {
    XFile? xFile = await ImagePicker().pickImage(source: source);

    if (xFile == null) return;

    chqImg = File(xFile.path);
    Get.back();
    setState(() {});
  }

  String bankSearch = "";
  Widget bankTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: bankController,
          title: Text("Bank", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(bankName, style: AppFonts.f50012),
            ],
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: RpSmallTf(
                  borderColor: Colors.black,
                  initialValue: bankSearch,
                  onChange: (val) {
                    bankSearch = val.toLowerCase();
                    setState(() {});
                  }),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: (bankSearch.isEmpty) ? 10 : filterBank().length,
              itemBuilder: (context, index) {
                List list = [];
                if (bankSearch.isEmpty)
                  list = bankMap.keys.toList();
                else
                  list = filterBank();

                String temp = list[index];
                return InkWell(
                  onTap: () {
                    bankName = temp;
                    bankCode = bankMap[bankName];
                    bankController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: bankName,
                        onChanged: (value) {
                          bankName = temp;
                          bankCode = bankMap[bankName];
                          bankController.collapse();
                          setState(() {});
                        },
                      ),
                      Expanded(child: Text(temp, style: AppFonts.f50014Grey)),
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

  List filterBank() {
    List list = bankMap.keys.toList();

    return list
        .where((element) => element.toLowerCase().contains(bankSearch))
        .take(10)
        .toList();
  }

  Widget accountTypeTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: accountTypeController,
          title: Text("Account Type", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(accountType, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: accountTypeList.length,
              itemBuilder: (context, index) {
                Map map = accountTypeList[index];

                String desc = map['desc'];
                String code = map['code'];

                return InkWell(
                  onTap: () {
                    accountType = desc;
                    accountTypeCode = code;
                    accountTypeController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: code,
                        groupValue: accountTypeCode,
                        onChanged: (val) {
                          accountType = desc;
                          accountTypeCode = code;
                          accountTypeController.collapse();
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
}
