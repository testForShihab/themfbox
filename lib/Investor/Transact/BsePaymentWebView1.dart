import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/lumpsum/LumpsumPayment.dart';
import 'package:mymfbox2_0/Investor/Transact/lumpsum/LumpsumPaymentSuccess.dart';
import 'package:mymfbox2_0/login/CheckAuth.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/TransactionApi.dart';
import '../../utils/Utils.dart';
import 'PaymentWebView.dart';

class BsePaymentWebView1 extends StatefulWidget {
  const BsePaymentWebView1({super.key, required this.url, required this.paymentId});
  final String url;
  final String paymentId;
  @override
  State<BsePaymentWebView1> createState() => _BsePaymentWebView1State();
}

class _BsePaymentWebView1State extends State<BsePaymentWebView1> {
  WebViewController? controller = WebViewController();

  int user_id = GetStorage().read('user_id');
  String client_name = GetStorage().read('client_name');
  Map client_code_map = GetStorage().read('client_code_map');

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(Uri.parse(widget.url))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            print("Page started loading: $url");
          },
          onPageFinished: (String url) {
            print("Page finished loading: $url");
            _injectJavaScript();
          },
          onWebResourceError: (WebResourceError error) {
            print("Error loading page: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) async {
            print("Navigation request: ${request.url}");

            return NavigationDecision.navigate;
          },
        ),
      );
    setState(() {});
  }

  void _injectJavaScript() {
    controller?.runJavaScript('''
      document.getElementById('form1').onsubmit = function(event) {
        event.preventDefault();
        var action = this.action;
        window.location.href = action;
      };
    ''');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config.appTheme.themeColor,
        foregroundColor: Colors.white,
        leading: SizedBox(),
        title: Text("Payment"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                exitAlert();
              },
              icon: Icon(Icons.close))
        ],
      ),
      body: (controller == null)
          ? Text("Loading..")
          : WebViewWidget(controller: controller!),
    );
  }

  exitAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm"),
          content: Text("Are you Sure to cancel ?"),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("No")),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Config.appTheme.themeColor,
                    foregroundColor: Colors.white),
                onPressed: () {
                  for (int i = 0; i < 3; i++) Get.back();
                },
                child: Text("Yes"))
          ],
        );
      },
    );
  }
}