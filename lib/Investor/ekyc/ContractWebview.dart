import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/ekyc/EkycSuccess.dart';
import 'package:mymfbox2_0/api/EkycApi.dart';
import 'package:mymfbox2_0/login/CheckAuth.dart';
import 'package:mymfbox2_0/login/CheckUserType.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContractWebview extends StatefulWidget {
  const ContractWebview({super.key, required this.url});
  final String url;
  @override
  State<ContractWebview> createState() => _ContractWebviewState();
}

class _ContractWebviewState extends State<ContractWebview> {
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  String ekyc_id = GetStorage().read("ekyc_id");

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
        onPageStarted: (String url) {
          print("request url for ekyc contract onPageStarted = $url");
        },
        onPageFinished: (String url) {
          print("request url for ekyc contract onPageFinished = $url");
        },
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) async {
          String url = request.url;
          print("request url for ekyc contract onNavigationRequest = $url");

          if (url
              .startsWith("https://api.mymfbox.com/ekyc/step10-declaration")) {
            Get.back();
            Get.back();
            int res = await step10APi();
            if (res == 0) {
              Get.offAll(CheckUserType());
              Get.to(() => EkycSuccess());
            }
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
          title: "Contract Preview",
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
          title: Text('Go Back'),
          content: Text('Are you sure you want to cancel'),
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

  Future step10APi() async {
    Map data = await EkycApi.step10Declaration(
        user_id: user_id, client_name: client_name, ekyc_id: ekyc_id);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    return 0;
  }
}
