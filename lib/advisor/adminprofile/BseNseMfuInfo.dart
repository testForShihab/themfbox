import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/advisor/WebViewContent.dart';
import 'package:mymfbox2_0/advisor/adminprofile/MailBackInformation.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import 'AdminProfile.pojo.dart';

class BseNseMfuInfo extends StatefulWidget {
  final DetailsPojo detailsPojo;
  const BseNseMfuInfo({Key? key, required this.detailsPojo}) : super(key: key);
  @override
  State<BseNseMfuInfo> createState() => _BseNseMfuInfoState();
}

class _BseNseMfuInfoState extends State<BseNseMfuInfo> {
  late double devWidth, devHeight;
  bool isLoading = true;
  List typeList = [];
  TextEditingController arnController = TextEditingController();

  String client_name = GetStorage().read("client_name");

  DetailsPojo oldDetailsPojo = DetailsPojo();
  Map allDetails = {};
  List arnList = [];
  String selectedArn = "";
  Map selectedDetails = {};

  String nsePassword = "",
      bsePassword = "",
      mfuPassword = "",
      riaNsePassword = "";

  @override
  void initState() {
    //  implement initState
    super.initState();
    oldDetailsPojo = widget.detailsPojo;
    Map temp = widget.detailsPojo.toJson();
    allDetails = apiConvertor(temp);
    arnList = allDetails['arn_list'];
    selectedArn = arnList.first;
    selectedDetails = allDetails[selectedArn];
    nsePassword = selectedDetails["nse_password"];
    bsePassword = selectedDetails["bse_password"];
    mfuPassword = selectedDetails["mfu_password"];
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "BSE | NSE | MFU Information",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: arnList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        String title = arnList[index];
                        bool isSelected = (selectedArn == title);

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                          child: MyProfileButton(
                            title: title,
                            isSelected: isSelected,
                            onPressed: () {
                              selectedArn = title;
                              selectedDetails = allDetails[selectedArn];
                              setState(() {});
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  bseDetailsCard(),
                  nseDetailsCard(),
                  mfuDetailsCard(),
                  riaNseDetailsCard(),
                  SizedBox(height: 16),
                ],
              ),
            ),
            CalculateButton(
              onPress: () async {
                int res = await updateBseNseDetails();
                if (res == -1) return;
                Get.back();
                EasyLoading.showSuccess("Details Updated Successfully");
              },
              text: "UPDATE DETAILS",
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            )
          ],
        ),
      ),
    );
  }

  Future updateBseNseDetails() async {
    int flag = arnList.indexOf(selectedArn) + 1;

    Map data = await AdminApi.updateBseNseDetails(
        bse_psswd: bsePassword,
        nse_psswd: nsePassword,
        ria_nse_psswd: riaNsePassword,
        flag: flag,
        mfu_psswd: mfuPassword,
        client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    return 0;
  }

  Map apiConvertor(Map data) {
    Map myResponse = {};
    List arnList = [
      data['broker_code1'],
      data['broker_code2'],
      data['broker_code3'],
      data['broker_code4'],
      data['broker_code5'],
    ];
    arnList.removeWhere((element) => element == "");
    myResponse['arn_list'] = arnList;
    myResponse[data['broker_code1']] = {
      "nse_user_id": data["nse_appln_id"],
      "nse_password": data['nse_password'],
      "bse_user_id": data["bse_userid"],
      "bse_member_id": data['bse_memberid'],
      "bse_password": data['bse_password'],
      "mfu_user_id": data['mfu_userid'],
      "mfu_password": data['mfu_password']
    };
    if (data['broker_code2'] != "")
      myResponse[data['broker_code2']] = {
        "nse_user_id": data["nse_appln_id1"],
        "nse_password": data['nse_password1'],
        "bse_user_id": data["bse_userid1"],
        "bse_member_id": data['bse_memberid1'],
        "bse_password": data['bse_password1'],
        "mfu_user_id": data['mfu_userid1'],
        "mfu_password": data['mfu_password1']
      };
    if (data['broker_code3'] != "")
      myResponse[data['broker_code3']] = {
        "nse_user_id": data["nse_appln_id2"],
        "nse_password": data['nse_password2'],
        "bse_user_id": data["bse_userid2"],
        "bse_member_id": data['bse_memberid2'],
        "bse_password": data['bse_password2'],
        "mfu_user_id": data['mfu_userid2'],
        "mfu_password": data['mfu_password2']
      };

    return myResponse;
  }

  Widget bseDetailsCard() {
    if (selectedDetails['bse_user_id'] == "") return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "BSE Details",
          style: AppFonts.f50014Grey,
        ),
        SizedBox(height: 16),
        GestureDetector(
            onTap: () {
              String url = "https://bsestarmf.in/index.aspx";
              Get.to(WebviewContent(
                disqusUrl: url,
                webViewTitle: 'BSE',
                showIcon: false,
              ));
            },
            child: Text(
              "Visit BSE StAR MF Portal",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationColor: Config.appTheme.themeColor,
                  color: Config.appTheme.themeColor),
            )),
        SizedBox(height: 16),
        ReadOnlyTf(
            title: "Bse User Id", value: "${selectedDetails['bse_user_id']}"),
        SizedBox(height: 16),
        ReadOnlyTf(
            title: "Bse Member Id", value: selectedDetails['bse_member_id']),
        SizedBox(height: 16),
        AmountInputCard(
          title: "Bse Password",
          initialValue: bsePassword,
          hasSuffix: false,
          borderRadius: BorderRadius.circular(20),
          suffixText: "",
          onChange: (val) => bsePassword = val,
          keyboardType: TextInputType.name,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget nseDetailsCard() {
    if (selectedDetails['nse_user_id'] == "") return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nse Details",
          style: AppFonts.f50014Grey,
        ),
        SizedBox(height: 16),
        ReadOnlyTf(title: "NSE User Id", value: selectedDetails['nse_user_id']),
        SizedBox(height: 16),
        AmountInputCard(
          title: "NSE Password",
          initialValue: nsePassword,
          hasSuffix: false,
          borderRadius: BorderRadius.circular(20),
          suffixText: "",
          onChange: (val) => nsePassword = val,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget riaNseDetailsCard() {
    if (oldDetailsPojo.riaCode == "") return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "RIA Details",
          style: AppFonts.f50014Grey,
        ),
        SizedBox(height: 16),
        ReadOnlyTf(
            title: "RIA NSE User Id", value: "${oldDetailsPojo.riaNseApplnId}"),
        SizedBox(height: 16),
        AmountInputCard(
          title: "RIA NSE Password",
          initialValue: "${oldDetailsPojo.riaNsePassword}",
          hasSuffix: false,
          borderRadius: BorderRadius.circular(20),
          suffixText: "",
          onChange: (val) => riaNsePassword = val,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget mfuDetailsCard() {
    if (selectedDetails['mfu_user_id'] == "") return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "MFU Details",
          style: AppFonts.f50014Grey,
        ),
        SizedBox(height: 16),
        ReadOnlyTf(title: "MFU User Id", value: selectedDetails['mfu_user_id']),
        SizedBox(height: 16),
        AmountInputCard(
          title: "MFU Password",
          initialValue: mfuPassword,
          hasSuffix: false,
          borderRadius: BorderRadius.circular(20),
          suffixText: "",
          onChange: (val) => mfuPassword = val,
          keyboardType: TextInputType.name,
        ),
      ],
    );
  }
}
