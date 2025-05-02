import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/InvestorDashboard.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/pojo/CartPojo.dart';
import 'package:mymfbox2_0/pojo/transaction/SuccessPojo.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../Transact/BsePaymentWebView.dart';

class MandateSuccess extends StatefulWidget {
   MandateSuccess({super.key,this.paymentLink = "",
     required this.deleteMessage,
     required this. bankaccName,
     required this. number,
     required this. ifscCode,
     required this.pagename,
     this.mandateAmount = 0,
     this.mandate_id = '',
     this.investor_code = '',
     this.mandatetype = ''});

  final String? deleteMessage;
  final String? pagename;
  final String bankaccName ;
  final String number;
  final String? ifscCode;
  final String mandate_id;
  final String investor_code;
  final String mandatetype;
  String paymentLink;
  num mandateAmount;

  @override
  State<MandateSuccess> createState() => _MandateSuccessState();
}

class _MandateSuccessState extends State<MandateSuccess> {
  late double devWidth, devHeight;
  String user_name = GetStorage().read('user_name');
  Map client_code_map = GetStorage().read('client_code_map');
  int user_id = GetStorage().read('user_id');
  String client_name = GetStorage().read('client_name');
  bool isLoading = true;
  int secondsElapsed = 0;
  Timer? timer;

  late Map transactionList;

  String responseMsg = '';
  String mandateid = '';
  String investor_code = '';
  String pagename = "";
  String mandatetype = "";
  Map mandateDetails = {};
  num mandateAmount = 0;

  String bankaccName = "";
  String number = "";
  String? ifscCode = "";

  Future generateBseAchAuthLink() async {
    Map data = await TransactionApi.generateBseAchAuthLink(
        user_id: user_id,
        client_name: client_name,
        bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
        mandate_id: widget.mandate_id,
        investor_code: widget.investor_code);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return;
    }


    return data;
  }


  @override
  void initState() {
    // implement initState
    super.initState();
    responseMsg = widget.deleteMessage!;
    pagename = widget.pagename!;
    mandateAmount = widget.mandateAmount;
    bankaccName = widget.bankaccName;
    number = widget.number;
    ifscCode = widget.ifscCode;
    investor_code = widget.investor_code;
    mandateid = widget.mandate_id;
    mandatetype = widget.mandatetype;

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
    String last4Digit = number.substring(number.length - 4);

    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => InvestorDashboard());
        return false;
      },
      child: Scaffold(
        backgroundColor: Config.appTheme.themeColor,
        appBar: rpAppBar(
            title: pagename,
            bgColor: Config.appTheme.themeColor,
            foregroundColor: Colors.white),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/Registration_Success.png", height: 180),
              Container(
                width: devWidth,
                height: devHeight,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  border: Border.all(color: Config.appTheme.themeColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$pagename Successfully',
                      style: AppFonts.f70018Black.copyWith(
                          fontSize: 22,
                          color: Config.appTheme.themeColor),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 16),
                    Container(
                      width: devWidth,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(color: Config.appTheme.lineColor),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 8,),
                          rpRow(lhead: "Bank Name", lSubHead: bankaccName!,rhead: "Bank Account Number", rSubHead: "(**$last4Digit)"),
                          SizedBox(height: 8,),
                          rpRow(lhead: "IFSC Code", lSubHead: ifscCode!,rhead: (mandateAmount != 0) ? "Mandate Amount" : "", rSubHead: (mandateAmount != 0) ? mandateAmount.toString() : ""),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    paymentCard(),
                    if(pagename =="Mandate Deleted") SizedBox(height: 16,),
                   if(pagename =="Mandate Deleted") Container(
                      width: devWidth,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(color: Config.appTheme.lineColor),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lightbulb_circle),
                              SizedBox(width: 10),
                              Text("Note : ", style: AppFonts.f50014Black)
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "1. Mandate details are erased from our system only.",
                            style: AppFonts.f50012.copyWith(
                                color: Config.appTheme.readableGreyTitle),
                          ),
                          SizedBox(height: 10),
                          Text(
                              "2. It will not delete from ${client_code_map['bse_nse_mfu_flag']} platform.",
                            style: AppFonts.f50012.copyWith(
                                color: Config.appTheme.readableGreyTitle),
                          )
                        ],
                      ),
                    ),

                    SizedBox(height: 16),
                    InkWell(
                      onTap: (){
                        Get.to(InvestorDashboard());
                      },
                      child: RpFilledButton(
                        color: Config.appTheme.buttonColor,
                        text: "DASHBOARD",
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rpRow({
    required String lhead,
    required String lSubHead,
    required String rhead,
    required String rSubHead,
  }) {
    return Row(
      children: [
        Expanded(child: ColumnText(title: lhead, value: lSubHead)),
        Expanded(child: ColumnText(title: rhead, value: rSubHead)),
      ],
    );
  }

  Widget paymentCard() {

    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
     // margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          border: Border.all(color: Config.appTheme.lineColor),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(responseMsg,style: AppFonts.f50014Black
              .copyWith(color: Config.appTheme.defaultProfit),textAlign: TextAlign.center,),
          if (client_code_map['bse_nse_mfu_flag'].toUpperCase() == "BSE" && pagename == "Mandate Generated"  && mandatetype == "EMANDATE" )
            ...[
              SizedBox(height: 5,),
              authenticationButton(),
            ]
          /*ColumnText(
            alignment: CrossAxisAlignment.center,
            title: "",
            value: responseMsg,
            valueStyle: AppFonts.f50014Black
                .copyWith(color: Config.appTheme.defaultProfit),
          ),*/
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
            if (!isLoading) {
              Map response = await generateBseAchAuthLink();
              Map result = response['result'];
              String url = result['payment_link'];
              Get.to(() => BsePaymentWebView(
                url: url,
                paymentId: response['payment_id'],
                purchase_type: "Mandate Generated",
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
              : Text('AUTHENTICATE YOUR MANDATE'),
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


