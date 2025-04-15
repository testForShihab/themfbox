import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/InvestorDashboard.dart';
import 'package:mymfbox2_0/Investor/InvestorMenu/riskProfile/RiskProfile.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import '../../../api/InvestorApi.dart';
import '../../../api/ReportApi.dart';
import '../../../utils/Utils.dart';

class RiskProfileScore extends StatefulWidget {
  final String responsemsg;

  const RiskProfileScore({super.key, required this.responsemsg});

  @override
  State<RiskProfileScore> createState() => _RiskProfileScoreState();
}

class _RiskProfileScoreState extends State<RiskProfileScore> {
  int count = 5;

  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  bool isLoading = true;
  Future getDatas() async {
    try {
      await getRiskProfileStatus();
    } catch (e) {
      print("getMasterPortfolio exception = $e");
    }
    isLoading = false;
    return 0;
  }

  String score = " ";
  Future getRiskProfileStatus() async {
    Map data = await InvestorApi.getRiskProfileStatus(
        user_id: user_id, client_name: client_name);
    score = "${data['result']['total_mark']}";
    print("score = $score");
  }
  late double devHeight;

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    double devWidth = MediaQuery.sizeOf(context).width;
    var msg = widget.responsemsg;
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
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
                    Text("Risk Profile", style: AppFonts.appBarTitle),
                    SizedBox(width: 12),
                  ],
                ),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    children: [
                      Text("Based on your responses,\n Your Risk Profile is",
                          textAlign: TextAlign.center,
                          style: AppFonts.f50014Grey),
                      SizedBox(height: 20),
                      selectRiskImage(msg),
                      SizedBox(height: 20),
                      Text("Risk Score: $score",
                          style: TextStyle(fontSize: 14)),
                      SizedBox(height: 45),
                      InkWell(
                        onTap: () {
                          Get.to(RiskProfile());
                        },
                        child: Text("Retake Risk Assessment?",
                            style: TextStyle(
                              fontSize: 16,
                              color: Config.appTheme.themeColor,
                              decoration: TextDecoration.underline,
                            )),
                      ),
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                          width: devWidth* 0.2,
                          child: InkWell(
                            onTap: () {
                              Get.to(InvestorDashboard());
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8.1),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Config.appTheme.themeColor,width: 1.8,)
                                ),
                                child: Center(
                                    child: Text(
                                      "Home",
                                      textAlign: TextAlign.center,
                                      style: AppFonts.f50014Black.copyWith(color:Config.appTheme.themeColor ,fontSize: 14,),
                                    ))),
                          ),
                                                ),
                          SizedBox(width: 15),
                          SizedBox(
                            width: devWidth* 0.4,
                            child: InkWell(
                              onTap: () async {
                                EasyLoading.show();
                                Map data = await ReportApi.downloadRiskProfilePdf(
                                  user_id: user_id,
                                  client_name: client_name,
                                );
                                if (data['status'] != 200) {
                                  Utils.showError(context, data['msg']);
                                  return;
                                }
                                EasyLoading.dismiss();
                                // Get.back();
                                rpDownloadFile(
                                    url: data['msg'], context: context, index: 1);
                                setState(() {});
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Config.appTheme.themeColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                      child: Text(
                                        "Download Report",
                                        textAlign: TextAlign.center,
                                        style: AppFonts.f50014Black.copyWith(color: Colors.white,fontSize: 14,),
                                      ))),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: devHeight * 0.2),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget selectRiskImage(String message) {
    String normalizedMessage = message.trim().toLowerCase();
    if (normalizedMessage.contains("conservative") &&
        normalizedMessage.contains("moderately")) {
      return Image.asset("assets/moderately_conservative.png", width: 280);
    } else if (normalizedMessage.contains("conservative")) {
      return Image.asset("assets/conservative.png", width: 280);
    } else if (normalizedMessage.contains("moderate") &&
        normalizedMessage.contains("aggressive")) {
      return Image.asset("assets/moderately_aggressive.png", width: 280);
    } else if (normalizedMessage.contains("moderate")) {
      return Image.asset("assets/moderate.png", width: 280);
    } else if (normalizedMessage.contains("aggressive")) {
      return Image.asset("assets/aggressive.png", width: 280);
    }
    return SizedBox();
  }
}
