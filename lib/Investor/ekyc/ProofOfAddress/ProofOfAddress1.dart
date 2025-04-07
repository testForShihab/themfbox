import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/ekyc/ProofOfIdentity/goToDigiLocker.dart';
import 'package:mymfbox2_0/api/EkycApi.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class ProofOfAddress1 extends StatelessWidget {
  const ProofOfAddress1({super.key});

  @override
  Widget build(BuildContext context) {
    int user_id = GetStorage().read("user_id");
    String client_name = GetStorage().read("client_name");
    String ekyc_id = GetStorage().read("ekyc_id");

    List points = [
      "1. Once you click on the below button, you will be redirected to DigiLocker website via Signzy.",
      "2. Login into your DigiLocker account and complete the process.",
      "3. Once you have completed the process, you will be automatically redirected. ",
      "4. Your Aadhaar details fetched from DigiLocker will be auto filled, which you need to verify and continue further.",
    ];
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
        title: "Proof Of Address",
        bgColor: Config.appTheme.themeColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Signzy requires to access your DigiLocker Account. Please login below to permit the access.",
              style: AppFonts.f50014Grey,
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_circle),
                      SizedBox(width: 10),
                      Text("Instructions", style: AppFonts.f50014Black)
                    ],
                  ),
                  SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: points.length,
                    itemBuilder: (context, index) {
                      return Text(points[index], style: AppFonts.f50014Grey);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(height: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            RpFilledButton(
                onPressed: () async {
                  Map data = await EkycApi.getDigiLockerAadhaarUrl(
                    user_id: user_id,
                    client_name: client_name,
                    ekyc_id: ekyc_id,
                  );
                  if (data['status'] != 200) {
                    Utils.showError(context, data['msg']);
                    return -1;
                  }
                  String url = data['url'];
                  Get.to(() => GoToDigiLocker(
                        url: url,
                        type: "AADHAR",
                      ));
                },
                text: "FETCH AADHAAR FROM DIGILOCKER",
                padding: EdgeInsets.symmetric(vertical: 12))
          ],
        ),
      ),
    );
  }
}
