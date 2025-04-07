import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/advisor/WebViewContent.dart';
import 'package:mymfbox2_0/advisor/adminprofile/AdminProfile.pojo.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class MailBackInformation extends StatefulWidget {
  final DetailsPojo detailsPojo;
  const MailBackInformation({super.key, required this.detailsPojo});

  @override
  State<MailBackInformation> createState() => _MailBackInformationState();
}

class _MailBackInformationState extends State<MailBackInformation> {
  late double devWidth, devHeight;
  bool isLoading = true;
  String selectedType = "ARN-XXXXX";
  String client_name = GetStorage().read("client_name");

  TextEditingController fundsNetUserIdController = TextEditingController();
  TextEditingController fundsNetPasswordController = TextEditingController();
  TextEditingController fundsNetSecurityAnswerController =
      TextEditingController();

  Map allDetails = {};
  String selectedArn = "";
  Map selectedDetails = {};
  List arnList = [];

  @override
  void initState() {
    //  implement initState
    super.initState();
    Map temp = widget.detailsPojo.toJson();
    allDetails = apiConvertor(temp);
    arnList = allDetails['arn_list'];
    selectedArn = arnList.first;
    selectedDetails = allDetails[selectedArn];
    print("selectedDetails $selectedDetails");
    fundsNetUserIdController.text = selectedDetails['fund_uid'] ?? "";
    fundsNetPasswordController.text = selectedDetails['fund_password'] ?? "";
    fundsNetSecurityAnswerController.text =
        selectedDetails['fund_security_ans'] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: AppBar(
        leading: SizedBox(),
        leadingWidth: 0,
        backgroundColor: Config.appTheme.themeColor,
        foregroundColor: Colors.white,
        title: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Row(
            children: [
              Icon(Icons.arrow_back),
              SizedBox(width: 10),
              Text("Mailback Information", style: AppFonts.appBarTitle),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              color: Config.appTheme.mainBgColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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

                              fundsNetUserIdController.text =
                                  selectedDetails['fund_uid'];
                              fundsNetPasswordController.text =
                                  selectedDetails['fund_password'];
                              fundsNetSecurityAnswerController.text =
                                  selectedDetails['fund_security_ans'];

                              setState(() {});
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Text(
                    "ARN Details",
                    style: AppFonts.f50014Black.copyWith(
                      color: Config.appTheme.readableGreyTitle,
                    ),
                  ),
                  SizedBox(height: 16),
                  ReadOnlyTf(title: "ARN Number", value: selectedArn),
                  SizedBox(height: 16),
                  ReadOnlyTf(
                      title: "EUIN Number", value: selectedDetails['euin']),
                  DottedLine(verticalPadding: 16),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Text(
                      "CAMS Details",
                      style: AppFonts.f50014Black.copyWith(
                        color: Config.appTheme.readableGreyTitle,
                      ),
                    ),
                  ),
                  ReadOnlyTf(
                      title: "CAMS Mailback Email",
                      value: selectedDetails['cams_mailback_email']),
                  DottedLine(verticalPadding: 16),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Text(
                      "K-Fintech Details",
                      style: AppFonts.f50014Black.copyWith(
                        color: Config.appTheme.readableGreyTitle,
                      ),
                    ),
                  ),
                  ReadOnlyTf(
                      title: "K-Fintech Mailback Email",
                      value: selectedDetails['karvy_mailback_email']),
                  SizedBox(height: 16),
                  ReadOnlyTf(
                      title: "K-Fintech Member Id",
                      value: selectedDetails['karvy_member_id']),
                  SizedBox(height: 16),
                  ReadOnlyTf(
                      title: "K-Fintech Password",
                      value: selectedDetails['karvy_password']),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: DottedLine(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "CAMS FundsNet",
                        style: AppFonts.f50014Black.copyWith(
                          color: Config.appTheme.readableGreyTitle,
                        ),
                      ),
                      SizedBox(height: 16),
                      GestureDetector(
                          onTap: () {
                            String url =
                                "https://fundsnet.camsonline.com/ecrms/index.aspx";
                            Get.to(WebviewContent(
                              disqusUrl: url,
                              webViewTitle: 'BSE',
                              showIcon: false,
                            ));
                          },
                          child: Text(
                            "Visit CAMS FundsNet Portal",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: Config.appTheme.themeColor,
                                color: Config.appTheme.themeColor),
                          )),
                    ],
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "FundsNet User Id",
                    controller: fundsNetUserIdController,
                    //  initialValue: selectedDetails['fund_uid'] ?? "",
                    hasSuffix: false,
                    borderRadius: BorderRadius.circular(10),
                    suffixText: "",
                    onChange: (val) {
                      setState(() {});
                      fundsNetUserIdController.text = val;
                    },
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "FundsNet Password",
                    controller: fundsNetPasswordController,
                    // initialValue: selectedDetails['fund_password'],
                    hasSuffix: false,
                    borderRadius: BorderRadius.circular(10),
                    suffixText: "",
                    onChange: (val) {
                      setState(() {});
                      fundsNetPasswordController.text = val;
                    },
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "FundsNet Security Answer",
                    controller: fundsNetSecurityAnswerController,
                    // initialValue: selectedDetails['fund_security_ans'],
                    hasSuffix: false,
                    borderRadius: BorderRadius.circular(10),
                    suffixText: "",
                    onChange: (val) {
                      setState(() {});
                      fundsNetSecurityAnswerController.text = val;
                    },
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            CalculateButton(
              onPress: () async {
                int res = await updateInfo();
                if (res == -1) return;
                Get.back();
                EasyLoading.showSuccess("Details Updated Successfully");
              },
              text: "UPDATE DETAILS",
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
          ],
        ),
      ),
    );
  }

  Future updateInfo() async {
    int flag = arnList.indexOf(selectedArn) + 1;

    if (fundsNetUserIdController.text.isEmpty) {
      Utils.showError(context, "Please Enter the FundsNet User Id");
      return -1;
    }
    if (fundsNetPasswordController.text.isEmpty) {
      Utils.showError(context, "Please Enter the FundsNet Password");
      return -1;
    }
    if (fundsNetSecurityAnswerController.text.isEmpty) {
      Utils.showError(context, "Please Enter the FundsNet Security Answer");
      return -1;
    }

    Map data = await AdminApi.updatemailback(
        fund_uid: fundsNetUserIdController.text,
        fund_password: fundsNetPasswordController.text,
        fund_security_ans: fundsNetSecurityAnswerController.text,
        flag: flag,
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
      "euin": data["euin1"],
      "cams_mailback_email": data['cams_mailback_email'],
      "karvy_mailback_email": data['karvy_mailback_email'],
      "fund_uid": data["fund_uid1"],
      "fund_password": data['fund_password1'],
      "fund_security_ans": data['fund_security_ans1'],
      "karvy_member_id": data['karvy_member_id'],
      "karvy_password": data['karvy_password'],
    };
    if (data['broker_code2'] != "")
      myResponse[data['broker_code2']] = {
        "euin": data["euin2"],
        "cams_mailback_email": data['cams_mailback_email1'],
        "karvy_mailback_email": data['karvy_mailback_email'],
        "fund_uid": data['fund_uid2'],
        "fund_password": data['fund_password2'],
        "fund_security_ans": data['fund_security_ans2'],
        "karvy_member_id": data['karvy_member_id1'],
        "karvy_password": data['karvy_password1'],
      };
    if (data['broker_code3'] != "")
      myResponse[data['broker_code3']] = {
        "euin": data["euin3"],
        "cams_mailback_email": data['cams_mailback_email2'],
        "karvy_mailback_email": data['karvy_mailback_email2'],
        "fund_uid": data['fund_uid3'],
        "fund_password": data['fund_password3'],
        "fund_security_ans": data['fund_security_ans3'],
        "karvy_member_id": data['karvy_member_id2'],
        "karvy_password": data['karvy_password2'],
      };

    if (data['broker_code4'] != "")
      myResponse[data['broker_code4']] = {
        "euin": data["euin4"],
        "cams_mailback_email": data['cams_mailback_email3'],
        "karvy_mailback_email": data['karvy_mailback_email3'],
        "fund_uid": data['fund_uid4'],
        "fund_password": data['fund_password4'],
        "fund_security_ans": data['fund_security_ans4'],
        "karvy_member_id": data['karvy_member_id3'],
        "karvy_password": data['karvy_password3'],
      };

    if (data['broker_code5'] != "")
      myResponse[data['broker_code5']] = {
        "euin": data['euin5'],
        "cams_mailback_email": data['cams_mailback_email4'],
        "karvy_mailback_email": data['karvy_mailback_email4'],
        "fund_uid": data['fund_uid5'],
        "fund_password": data['fund_password5'],
        "fund_security_ans": data['fund_security_ans5'],
        "karvy_member_id": data['karvy_member_id4'],
        "karvy_password": data['karvy_password4'],
      };
    return myResponse;
  }
}

class MyProfileButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onPressed;

  const MyProfileButton({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          isSelected ? Config.appTheme.themeColor : Colors.white,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          isSelected ? Colors.white : Config.appTheme.themeColor,
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Config.appTheme.themeColor),
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
    );
  }
}

class ReadOnlyTf extends StatelessWidget {
  const ReadOnlyTf({super.key, required this.title, required this.value});
  final String title, value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppFonts.f50014Black),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Config.appTheme.Bg2Color,
                borderRadius: BorderRadius.circular(22)),
            child: Text(value, style: AppFonts.f50014Theme),
          )
        ],
      ),
    );
  }
}
