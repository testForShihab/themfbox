import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class EkycSuccess extends StatefulWidget {
  const EkycSuccess({super.key});

  @override
  State<EkycSuccess> createState() => _EkycSuccessState();
}

class _EkycSuccessState extends State<EkycSuccess> {
  late double devWidth, devHeight;

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Config.appTheme.themeColor,
      appBar: rpAppBar(
          title: "eKYC Submitted Successfully",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [contentArea()],
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
                    'Thanks for completing the eKYC process.',
                    style: AppFonts.f70018Black.copyWith(
                        fontSize: 20, color: Config.appTheme.themeColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Next Step: Your KYC should be completed within next 2-3 business days. After that you can register for mutual fund investment account.",
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
                      child: Text("DASHBOARD"),
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
}
