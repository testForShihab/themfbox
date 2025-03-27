import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/ekyc/AadharESign.dart';
import 'package:mymfbox2_0/Investor/ekyc/Declaration.dart';
import 'package:mymfbox2_0/Investor/ekyc/EkycPersonalInfo.dart';
import 'package:mymfbox2_0/Investor/ekyc/EkycSignature.dart';
import 'package:mymfbox2_0/Investor/ekyc/EkycSuccess.dart';
import 'package:mymfbox2_0/Investor/ekyc/PhotoVerification.dart';
import 'package:mymfbox2_0/Investor/ekyc/ProofOfAddress/ProofOfAddress1.dart';
import 'package:mymfbox2_0/Investor/ekyc/ProofOfIdentity/ProofOfIdentity1.dart';
import 'package:mymfbox2_0/advisor/dashboard/ApiTest.dart';
import 'package:mymfbox2_0/api/EkycApi.dart';
import 'package:mymfbox2_0/rp_widgets/CalculateButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpDivider.dart';
import 'package:mymfbox2_0/rp_widgets/RpRegTile.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class Ekyc extends StatefulWidget {
  const Ekyc({super.key});

  @override
  State<Ekyc> createState() => _EkycState();
}

class _EkycState extends State<Ekyc> {
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");

  List process = [];
  bool is_all_steps_completed = false;
  bool is_registration_completed = false;
  bool isKycComplaint = false;

  Future getEkycStatus() async {
    Map data = await EkycApi.getOnBoardingStatus(
        user_id: user_id, client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    Map summary = data['summary'];

    is_all_steps_completed = summary['is_all_steps_completed'];
    is_registration_completed = summary['is_registration_completed'];
    isKycComplaint = summary['isKycComplaint'];

    process = data['list'];
    String ekyc_id = data['ekyc_id'];
    await GetStorage().write("ekyc_id", ekyc_id);

    return 0;
  }

  late double devWidth;
  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;

    return FutureBuilder(
        future: getEkycStatus(),
        builder: (context, snapshot) {
          if (is_all_steps_completed &&
              is_registration_completed &&
              !isKycComplaint) return EkycSuccess();

          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: rpAppBar(
              title: "eKYC for Mutual Funds",
              bgColor: Config.appTheme.themeColor,
              foregroundColor: Colors.white,
            ),
            body: (process.isEmpty)
                ? Utils.shimmerWidget(400, margin: EdgeInsets.all(16))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Start your investment journey in simple steps",
                                style:
                                    AppFonts.f50014Black.copyWith(fontSize: 18),
                              ),
                              Text(
                                "Complete KYC at your convenience",
                                style: AppFonts.f40013,
                              ),
                              SizedBox(height: 16),
                              processCard(),
                              SizedBox(height: 16),
                              Text(
                                "We request you to make sure that you fulfill these criteria's before you start the eKYC process.",
                                style: AppFonts.f50014Theme,
                              ),
                              SizedBox(height: 16),
                              detialsCard(),
                              SizedBox(height: 26),
                              poweredByCard(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        });
  }

  Widget poweredByCard() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Powered by",
            style: AppFonts.f40013.copyWith(
              color: AppColors.arrowGrey,
            ),
          ),
          SizedBox(height: 8), // Add some space between the rows
          Image.asset("assets/registration/signzy.png", height: 32)
        ],
      ),
    );
  }

  Widget detialsCard() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.check_circle_outline,
              color: AppColors.textGreen,
            ),
            title: Text(
              'Your mobile number should be linked with your aadhaar.',
              style: AppFonts.f40013.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.check_circle_outline,
              color: AppColors.textGreen,
            ),
            title: Text('Your PAN should be linked with aadhaar.',
                style: AppFonts.f40013.copyWith(fontWeight: FontWeight.w500)),
          ),
          ListTile(
            leading: Icon(
              Icons.check_circle_outline,
              color: AppColors.textGreen,
            ),
            title: Text('The image of your signature on a plain paper.',
                style: AppFonts.f40013.copyWith(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget processCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: process.length,
        itemBuilder: (context, index) {
          Map item = process[index];

          String title = item['title'];
          bool isCompleted = item['is_completed'];
          String subTitle = item['sub_title'];
          String logo = getLogoFromTitle(title);
          bool isEnabled = item['is_enabled'];
          Widget goTo = getNextPageFromTitle(title);

          return Opacity(
            opacity: (isEnabled) ? 1 : 0.4,
            child: RpRegTile(
              title: title,
              onTap: () {
                // Get.to(() => EkycPersonalInfo());
                Get.to(goTo)?.then((value) {
                  setState(() {});
                });
              },
              isCompleted: isCompleted,
              subTitle: SizedBox(
                  width: devWidth * 0.6,
                  child: Text(subTitle, style: AppFonts.f40013)),
              leading: Image.asset(logo, height: 32),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Row(
          children: [RpDivider()],
        ),
      ),
    );
  }

  String getLogoFromTitle(String title) {
    Map logo = {
      "Proof of Identity": "assets/registration/investor_information.png",
      "Proof Of Address": "assets/registration/universal_local.png",
      "Personal Information": "assets/registration/personal_info.png",
      "Declaration": "assets/registration/editor_choice.png",
      "Signature": "assets/registration/signature_info.png",
      "Photo Verification": "assets/registration/photo_verification.png",
      "Aadhaar eSign": "assets/registration/stylus_note.png",
    };
    if (!logo.containsKey(title)) return "assets/empty.png";

    return logo[title];
  }

  Widget getNextPageFromTitle(String title) {
    Map logo = {
      "Proof of Identity": ProofOfIdentity1(),
      "Proof Of Address": ProofOfAddress1(),
      "Personal Information": EkycPersonalInfo(),
      "Declaration": Declaration(),
      "Signature": EkycSignature(),
      "Photo Verification": PhotoVerification(),
      "Aadhaar eSign": AadharESign(),
    };
    if (!logo.containsKey(title)) return ApiTest();

    return logo[title];
  }
}
