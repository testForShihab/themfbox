import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/pojo/NewCartPojo.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/MarketTypeCard.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../BsePaymentWebView.dart';

class SipPaymentSuccess extends StatefulWidget {
  const SipPaymentSuccess({super.key, required this.paymentId, this.msg = ""});
  final String paymentId;
  final String msg;
  @override
  State<SipPaymentSuccess> createState() => _SipPaymentSuccessState();
}

class _SipPaymentSuccessState extends State<SipPaymentSuccess> {
  late double devWidth, devHeight;
  // late SuccessPojo successPojo;
  int user_id = GetStorage().read('user_id');
  String client_name = GetStorage().read('client_name');
  Map client_code_map = GetStorage().read('client_code_map');

  Result result = Result();
  SchemeList scheme1 = SchemeList();
  String bse_nse_mfu_flag = "";
  String investor_code = "";
  String broker_code = "";
  bool isLoading = true;
  int secondsElapsed = 0;
  Timer? timer;
  bool isFirst = true;


  Future getCartStatusByUserId() async {
    if (!isFirst) return;
    Map<String, dynamic> data = await TransactionApi.getCartStatusByUserId(
      user_id: user_id,
      client_name: client_name,
      paymentId: widget.paymentId,
      purchase_type: "SIP Purchase",
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    GetCartByUserIdPojo cart = GetCartByUserIdPojo.fromJson(data);
    result = cart.result!.first;
    scheme1 = result.schemeList!.first;
    bse_nse_mfu_flag = scheme1.vendor!;
    investor_code = scheme1.investorCode!;
    broker_code = scheme1.brokerCode!;

    return 0;
  }

  Future generateBseAuthenticationLink() async{

    Map data = await TransactionApi.generateBseAuthenticationLink(
        user_id: user_id,
        client_name: client_name,
        bse_nse_mfu_flag: bse_nse_mfu_flag,
        investor_code: investor_code,
        broker_code: broker_code);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return;
    }


    return data;

  }

  @override
  void initState() {
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

    Future.delayed(Duration(seconds: 8), () {
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

    return FutureBuilder(
        future: getCartStatusByUserId(),
        builder: (context, snapshot) {
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
                    width: devWidth,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                      border: Border.all(color: Config.appTheme.themeColor),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Order Placed Successfully',
                            style: AppFonts.f70018Black.copyWith(
                                fontSize: 22,
                                color: Config.appTheme.themeColor),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          if (result.schemeList != null)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: result.schemeList!.length,
                              itemBuilder: (context, index) {
                                SchemeList scheme = result.schemeList![index];

                                return cartItem(scheme);
                              },
                            ),
                          bankCard(),
                          paymentCard(),
                          arnEuin(),
                          SizedBox(height: 16),
                          MarketTypeCard(client_code_map: client_code_map),
                          SizedBox(height: 16),
                          Container(
                            width: devWidth,
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
                                  "1. SIP Purchase order placed Successfully.",
                                  style: AppFonts.f50012.copyWith(
                                      color: Config.appTheme.readableGreyTitle),
                                ),
                                Text(
                                    "2. Your portfolio will be updated within 2-3 working days.")
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          RpFilledButton(
                            text: "DASHBOARD",
                            onPressed: () {
                              Get.back();
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
        });
  }

  Widget arnEuin() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          border: Border.all(color: Config.appTheme.lineColor),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
            child:
                ColumnText(title: "ARN Number", value: "${result.brokerCode}"),
          ),
          Expanded(
            child: ColumnText(title: "EUIN", value: "${scheme1.euinCode}"),
          ),
        ],
      ),
    );
  }

  Widget paymentCard() {
    String status = widget.msg;
    if (status.isEmpty) status = "${scheme1.status}";

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
            title: "Payment Status",
            value: status,
            valueStyle: AppFonts.f50014Black
                .copyWith(color: Config.appTheme.defaultProfit),
          ),
          if (client_code_map['bse_nse_mfu_flag'].toUpperCase() == "BSE")
            ...[
              SizedBox(height: 5,),
              authenticationButton(),
            ]
        ],
      ),
    );
  }

  Widget bankCard() {
    String bankName = "${scheme1.bankName}";
    String accNo = "${scheme1.bankAccountNumber}";

    String last4Digit = accNo.substring(accNo.length - 4);

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
          ColumnText(title: "Bank", value: "$bankName (**$last4Digit)"),
          SizedBox(height: 16),
          ColumnText(title: "Payment Mode", value: "${scheme1.paymentMode}"),
        ],
      ),
    );
  }

  Widget cartItem(SchemeList scheme) {
    String name = scheme.schemeAmfiShortName ?? "";
    if (name.isEmpty) name = scheme.schemeName ?? "";

    String amount = "";
    if (scheme.trnxType!.contains("Units"))
      amount = "${scheme.units} Units";
    else {
      amount = Utils.formatNumber(num.parse(scheme.amount ?? "0"));
      amount = "$rupee $amount";
    }

    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Config.appTheme.themeColor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               // Image.network("${scheme.schemeLogo}", height: 28),
                Utils.getImage("${scheme.schemeLogo}",28),
                SizedBox(width: 10),
                Expanded(
                  child: ColumnText(
                    title: name,
                    value: "Folio : ${scheme.folioNo}",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013.copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Text("${scheme1.purchaseType} : ",
                    style: AppFonts.f40013.copyWith(color: Colors.black)),
                Text(amount,
                    style: AppFonts.f50012.copyWith(color: Colors.black))
              ],
            ),
          ],
        ),
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
            if (!isLoading) {
              Map response = await generateBseAuthenticationLink();
              Map result = response['result'];
              String url = result['payment_link'];
              Get.to(() => BsePaymentWebView(
                url: url,
                paymentId: response['payment_id'],
                purchase_type: "SIP Purchase",
              ));
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
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            ],
          )
              : Text('AUTHENTICATE YOUR ORDERS'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
