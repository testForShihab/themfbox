import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/Investor/ekyc/ProofOfAddress/FinalAadhar.dart';
import 'package:mymfbox2_0/Investor/ekyc/ProofOfIdentity/FinalPan.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoToDigiLocker extends StatefulWidget {
  const GoToDigiLocker({super.key, required this.url, required this.type});
  final String url, type;
  @override
  State<GoToDigiLocker> createState() => _GoToDigiLockerState();
}

class _GoToDigiLockerState extends State<GoToDigiLocker> {
  late final WebViewController _controller;

  String url = "";

  @override
  void initState() {
    super.initState();
    url = widget.url;

    _controller = WebViewController();
    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    _controller.setBackgroundColor(const Color(0x00000000));
    _controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // EasyLoading.showProgress(progress / 100);
          // if (progress == 100) {
          //   EasyLoading.dismiss();
          // }
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          print("request url for ekyc = ${request.url}");

          if (request.url.startsWith(
              "https://digilocker.signzy.tech/digilocker-auth-complete?code")) {
            if (widget.type == "PAN") Get.off(() => FinalPan());
            if (widget.type == "AADHAR") Get.off(() => FinalAadhar());
          }
          return NavigationDecision.navigate;
        },
      ),
    );
    _controller.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("Back button pressed"); // Debug print
        bool? shouldPop = await _showExitConfirmationDialog(context);
        print("Should pop: $shouldPop"); // Debug print
        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: rpAppBar(
          title: "Fetch ${widget.type} from DigiLocker",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white,
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) {
    print("Showing exit confirmation dialog"); // Debug print
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Go Back?'),
          content: Text(
              'Are you sure you want to cancel fetching PAN from DigiLocker ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                print("User pressed No"); // Debug print
                Navigator.of(context).pop(false); // User pressed No
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                print("User pressed Yes"); // Debug print
                Navigator.of(context).pop(true); // User pressed Yes
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
