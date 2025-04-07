import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/InvestorDashboard.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../api/TransactionApi.dart';
import '../../rp_widgets/ColumnText.dart';
import '../../rp_widgets/PlainButton.dart';
import '../../rp_widgets/RpAppBar.dart';
import '../../utils/AppFonts.dart';
import '../../utils/Utils.dart';
import 'BsePaymentWebView1.dart';
import 'lumpsum/BseLumpsumPaymentSuccess.dart';


class BsePaymentWebView extends StatefulWidget {
  const BsePaymentWebView({super.key, required this.url, required this.paymentId,required this.purchase_type});
  final String url;
  final String paymentId;
  final String purchase_type;
  @override
  State<BsePaymentWebView> createState() => _BsePaymentWebViewState();
}

class _BsePaymentWebViewState extends State<BsePaymentWebView> {
  WebViewController? controller = WebViewController();
  late double devWidth, devHeight;

  int user_id = GetStorage().read('user_id');
  String client_name = GetStorage().read('client_name');
  Map client_code_map = GetStorage().read('client_code_map');
  String purchase_type = '';
  int secondsElapsed = 0;
  Timer? timer;
  bool isLoading = true;

  Future<void> refreshPayment() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      controller?.loadRequest(Uri.parse(widget.url));
    } catch (e) {
      Utils.showError(context, "Failed to refresh payment");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    //  implement initState
    super.initState();
    purchase_type = widget.purchase_type;
    print("purchase_type-- $purchase_type");

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

          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith('https://bsestarmf.in/2FA_PurchaseAuthentication.aspx')) {
              Get.back();
              print("purchase_type--- $purchase_type");
              if(purchase_type=='SIP Purchase' || purchase_type== 'Lumpsum Purchase' ) {
                print("Came here");
                // Navigate to a new page showing the payment card
                Get.to(() => PaymentCardPage(
                  devWidth: devWidth,
                  paymentId: widget.paymentId,
                  purchase_type: widget.purchase_type,
                ));
              }
              if(purchase_type=='Redemption Purchase' || purchase_type== 'Switch Purchase' ){
                Get.to(BseLumpsumPaymentSuccess(paymentId: widget.paymentId ,purchase_type: purchase_type,));
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    setState(() {});
  }


  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;
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
                 refreshPayment();
              },
              icon: Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                exitAlert();
              },
              icon: Icon(Icons.close))
        ],
      ),
      body: (controller == null && isLoading)
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
                  for (int i = 0; i < 2; i++) Get.back();
                },
                child: Text("Yes"))
          ],
        );
      },
    );
  }
}


class PaymentCardPage extends StatefulWidget {
  const PaymentCardPage({super.key,required this.devWidth,required this.paymentId,required this.purchase_type});
  final double devWidth;
  final String paymentId;
  final String purchase_type;

  @override
  State<PaymentCardPage> createState() => _PaymentCardPageState();
}

class _PaymentCardPageState extends State<PaymentCardPage> {

  WebViewController? controller = WebViewController();
  late double devWidth, devHeight;

  int user_id = GetStorage().read('user_id');
  String client_name = GetStorage().read('client_name');
  Map client_code_map = GetStorage().read('client_code_map');
  String purchase_type = '';

  int secondsElapsed = 0;
  Timer? timer;
  bool isLoading = true;

  Future makeBsePayment() async {
    EasyLoading.show();
    Map data = await TransactionApi.generateBsePaymentGatewayLink(
      user_id: user_id,
      client_name: client_name,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      investor_code: client_code_map['investor_code'],
      broker_code: client_code_map['broker_code'],
      order_no: widget.paymentId,
      purchase_type: widget.purchase_type,

    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    EasyLoading.dismiss();

    Map result = data['result'];
    print("result $result");
    data['payment_link'] = result['payment_link'];

    return data;
  }

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
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.appTheme.themeColor,
      appBar: rpAppBar(
          title: "Order Successful",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/Registration_Success.png", height: 180),
            Container(
              width: widget.devWidth,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                border: Border.all(color: Config.appTheme.themeColor),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Your authentication was successful.',
                      style: AppFonts.f70018Black.copyWith(
                          fontSize: 22,
                          color: Config.appTheme.themeColor),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    paymentCard(),
                    SizedBox(height: 16),
                    Container(
                      width: widget.devWidth,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Config.appTheme.lineColor),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lightbulb_circle),
                              SizedBox(width: 10),
                              Text("Next Steps",
                                  style: AppFonts.f50014Black)
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "1. Lumpsum Purchase order placed Successfully.",
                            style: AppFonts.f50012.copyWith(
                                color: Config.appTheme.readableGreyTitle),
                          ),
                          Text(
                              "2. You need to authenticate first. Once authenticated, it will be reflected in your portfolio within 2-3 working days.")
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    RpFilledButton(
                      text: "DASHBOARD",
                      onPressed: () {
                        Get.to(InvestorDashboard());
                      },
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentCard() {
    Map client_code_map = GetStorage().read('client_code_map');

    return Container(
      width: widget.devWidth,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          border: Border.all(color: Config.appTheme.lineColor),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Status",
              style: AppFonts.f50014Black),
          SizedBox(height: 10),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: TextStyle(fontSize: 15, color: Colors.green,height: 1.5,), // Default style for the text
              children: [
                TextSpan(
                  text: 'Your authentication was successful. Click the ', // Regular text
                ),
                TextSpan(
                  text: 'Make Payment', // Bold text
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' button to proceed with the payment.', // Regular text
                ),
              ],
            ),
          ),

          if (client_code_map['bse_nse_mfu_flag'].toUpperCase() == "BSE")
            ...[
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.lightbulb_circle),
                  SizedBox(width: 10),
                  Text("Steps to Make the Payment:",
                      style: AppFonts.f50014Black)
                ],
              ),
              SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: TextStyle(fontSize: 12, color: Colors.black,height: 1.5,), // Default style for the text
                  children: [
                    TextSpan(
                      text: '1. Click the ', // Regular text
                    ),
                    TextSpan(
                      text: 'Make Payment', // Bold text
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' button once it has finished loading.', // Regular text
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: TextStyle(fontSize: 12, color: Colors.black,height: 1.5,), // Default style for the text
                  children: [
                    TextSpan(
                      text: '2. A payment link will open, where you can complete the payment for your order.', // Regular text
                    ),

                  ],
                ),
              ),

              SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: TextStyle(fontSize: 12, color: Colors.black,height: 1.5,), // Default style for the text
                  children: [
                    TextSpan(
                      text: '3. Once the payment is successful, click the ', // Regular text
                    ),
                    TextSpan(
                      text: 'Back', // Bold text
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '  button to return.', // Regular text
                    ),
                  ],
                ),
              ),

              SizedBox(height: 5,),
              authenticationButton(),
            ]
        ],
      ),
    );
  }

  Widget authenticationButton(){

    return Container(
      width: widget.devWidth,
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
            if (!isLoading) {

              Map result = await makeBsePayment();
              //if (result.isEmpty) return;

              String url = result['payment_link'];
              print("url $url");
              //Get.back();
              //Get.to(() => BsePaymentWebView1(url: url, paymentId: result['payment_id']));

              await launchUrlString(url);
              print("launch url $url");

              Future.delayed(Duration(seconds: 8), () {
                Get.to(BseLumpsumPaymentSuccess(paymentId: widget.paymentId ,purchase_type: purchase_type,));
              });

            }
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
              : Text('Make Payment'),
        ),
      ),
    );
  }
}

