import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/Investor/Transact/lumpsum/LumpsumPaymentSuccess.dart';

import 'package:mymfbox2_0/login/CheckAuth.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../InvestorDashboard.dart';

class PaymentWebView extends StatefulWidget {
  const PaymentWebView({super.key, required this.url, required this.paymentId});
  final String url;
  final String paymentId;
  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  WebViewController? controller = WebViewController();

  @override
  void initState() {
    //  implement initState
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
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(
                'https://api.mymfbox.com/transact/updateBulkLumpsumPurchasePaymentStatus')) {
              if (request.url.contains("PaymentStatus=SUCCESS")) {
                Get.offAll(() => CheckAuth());
                Get.to(() => LumpsumPaymentSuccess(paymentId: widget.paymentId));
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => InvestorDashboard());
        return false;
      },
      child: Scaffold(
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
      ),
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
                  // for (int i = 0; i < 3; i++) Get.back();
                  Get.off(() => InvestorDashboard());
                },
                child: Text("Yes"))
          ],
        );
      },
    );
  }
}

