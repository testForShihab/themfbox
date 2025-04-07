import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

import '../../../rp_widgets/ColumnText.dart';
class RegistrationSuccessful extends StatefulWidget {
  const RegistrationSuccessful({super.key, required this.msg});
  final String msg;
  @override
  State<RegistrationSuccessful> createState() => _RegistrationSuccessfulState();
}
class _RegistrationSuccessfulState extends State<RegistrationSuccessful> {
  late double devWidth, devHeight;
  Map client_code_map = GetStorage().read('client_code_map');
  bool isLoading = true;

  int secondsElapsed = 0;
  Timer? timer;
  bool isFirst = true;

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
           if(client_code_map['bse_nse_mfu_flag'] == "BSE") paymentCard(),
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
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("START INVESTING"),
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
            valueStyle: AppFonts.f50014Black
                .copyWith(color: Config.appTheme.defaultProfit),
          ),

              SizedBox(height: 10),
              authenticationButton(),

        ],
      ),
    );
  }

  Widget authenticationButton(){
    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: SizedBox(
        height: 45,
        child:ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Config.appTheme.themeColor,
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
          /*  if (!isLoading) {
              Map response = await generateBseAuthenticationLink();
              Map result = response['result'];
              String url = result['payment_link'];
              Get.to(() => BsePaymentWebView(
                url: url,
                paymentId: response['payment_id'],
                purchase_type: "Lumpsum Purchase",
              ));
            }*/
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
              : Text('AUTHENTICATE YOUR ORDERS'),
        ),
      ),
    );
  }

}
