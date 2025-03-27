import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../rp_widgets/ColumnText.dart';
import '../../api/onBoarding/CommonOnBoardApi.dart';
import '../../utils/Utils.dart';
import '../Transact/BsePaymentWebView.dart';
import 'Signature/Signature.dart';
class BSERegistrationSuccessful extends StatefulWidget {
  const BSERegistrationSuccessful({super.key, required this.msg,});
  final String msg;

  @override
  State<BSERegistrationSuccessful> createState() => _BSERegistrationSuccessfulState();
}
class _BSERegistrationSuccessfulState extends State<BSERegistrationSuccessful> {
  late double devWidth, devHeight;
  Map client_code_map = GetStorage().read('client_code_map');
  bool isLoading = true;
  String clientName = GetStorage().read("client_name");
  int userId = GetStorage().read("user_id");

  int secondsElapsed = 0;
  Timer? timer;
  bool isFirst = true;

  String url = "";

  @override
  void initState() {
    // implement initState
    super.initState();

    setState(() {
      isLoading = true;
      secondsElapsed = 0;
    });

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        secondsElapsed++;
      });
    });

    Future.delayed(Duration(seconds: 10), () {
      setState(() {
        isLoading = false;
      });
      timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Config.appTheme.themeColor,
      appBar: rpAppBar(
          title: "Registration Successful",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            contentArea(),
            SizedBox(height: 16),
            paymentCard(),
           //paymentCard(),
          ],
        ),
      ),
    );
  }
  Widget contentArea() {
    return Container(
      color: Config.appTheme.themeColor,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/Registration_Success.png", height: 180),
          Container(
            width: devWidth,
            height: devHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(26),
                topRight: Radius.circular(26),
              ),
              border: Border.all(color: Config.appTheme.themeColor),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 14, 32, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Thanks for completing the registration process.',
                    style: AppFonts.f70018Black.copyWith(
                        fontSize: 20, color: Config.appTheme.themeColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.msg,
                    style: AppFonts.f40013.copyWith(
                        fontWeight: FontWeight.w700, color: Color(0xff242424)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: devWidth,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Config.appTheme.themeColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: AppFonts.f50014Black.copyWith(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        print("print the button data");
                        EasyLoading.show();
                        Map data = await CommonOnBoardApi.getNomineeAuthenticationLink(
                            user_id: userId,
                            client_name: clientName,
                            investor_code: '');

                        if (data['status'] != 200) {
                          Utils.showError(context, data['msg']);
                          Navigator.pushNamed(context,data['msg']);
                        }

                        Map<String, dynamic> result = data['result'];
                        url = result['payment_link'];
                        await launchUrlString(url);
                        EasyLoading.dismiss();
                        print("payment link ${result['payment_link']}");

                        //String url = widget.payment_link;

                        Future.delayed(Duration(seconds: 8), () {
                          Get.to(BseAuthSuccess());
                        });
                      },
                      child: isLoading
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Loading... ${secondsElapsed}s',
                          ),
                          SizedBox(width: 15),
                          SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 5,
                            ),
                          )
                        ],
                      )
                          : Text('Nominee Authentication'),

                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentCard() {

   print("came here");
    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          border: Border.all(color: Config.appTheme.lineColor),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColumnText(
            title: "Nominee Authentication (Mandatory)",
            value: "Please click the button and you will be redirected to the Authentication page. Verify with the OTP received to your mobile. Once verification is done Successfully you will be redirected to this page again and then you can close this page.",
            valueStyle: AppFonts.f50014Black.copyWith(color: Config.appTheme.defaultProfit),
          ),
              SizedBox(height: 10),
              //authenticationButton(),
        ],
      ),
    );
  }

}

class BseAuthSuccess extends StatefulWidget {
  const BseAuthSuccess({super.key});

  @override
  State<BseAuthSuccess> createState() => _BseAuthSuccessState();
}

class _BseAuthSuccessState extends State<BseAuthSuccess> {
  File? signatureImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: rpAppBar(
        title: "Authentication Steps",
        bgColor: Config.appTheme.themeColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [



            _buildAuthenticationCard("UCC Authentication (Mandatory)",
            "Please do the UCC Authentication via link received in email/mobile from BSE STARMF. After completing the UCC authentication, "
            "Please do any one of the following process -Option1: ELOG Authentication OR Option2: Signature Upload"),

            SizedBox(height: 20),
            Text(
              "Please complete any one of the authentication options below: ELOG or Signature Upload",
              style: AppFonts.f50014Black.copyWith(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),
            _buildAuthenticationCard(
              "Option1: ELOG Authentication",
              "Please do the ELOG Authentication via link received in email/mobile from BSE STARMF. After completing the ELOG authentication.",
            ),

            SizedBox(height: 20,),

            Center(child: Text("--------------- OR ---------------")),

            SizedBox(height: 20),
            _buildSignatureUploadSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthenticationCard(String title, String description) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Config.appTheme.lineColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppFonts.f50014Black.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: Colors.black,height: 1.5,), // Default style for the text
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureUploadSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Config.appTheme.lineColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Option2: Signature Upload",
            style: AppFonts.f50014Black.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "Please upload your signature image in .jpg/.jpeg/.png(signed in blue ink) for affixing on the account opening form (AOF) and submitting to BSE STARMF",
            style: AppFonts.f50012.copyWith(
              color: Config.appTheme.readableGreyTitle,
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Config.appTheme.themeColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // Add signature upload functionality here
                //showUploadOption();
                Get.to(Signature());
              },
              child: Text("Upload Signature"),
            ),
          ),
          if (signatureImage != null) ...[
            SizedBox(height: 16),
            Text(
              "Verify your signature",
              style: AppFonts.f50012.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Image.file(
              signatureImage!,
              height: 100,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ],
          SizedBox(height: 16),
          Text(
            "Note - The above signature will be used to digitally sign the investor's application form.",
            style: AppFonts.f50012.copyWith(
              color: Config.appTheme.readableGreyTitle,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  void showUploadOption() {
    // Implement the signature upload functionality here
    // You can reuse the existing showUploadOption code from BsebankInfo.dart
    // or implement a new one specific to signature upload
  }
}

