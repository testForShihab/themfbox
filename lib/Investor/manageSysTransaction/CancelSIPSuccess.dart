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

class CancelSIPSuccess extends StatefulWidget {
  const CancelSIPSuccess(
      {super.key, this.msg = ""});
  final String msg;
  @override
  State<CancelSIPSuccess> createState() => _CancelSIPSuccessState();
}

class _CancelSIPSuccessState extends State<CancelSIPSuccess> {
  late double devWidth, devHeight;
  // late SuccessPojo successPojo;
  int user_id = GetStorage().read('user_id');
  String client_name = GetStorage().read('client_name');
  Map client_code_map = GetStorage().read('client_code_map');

  Result result = Result();
  SchemeList scheme1 = SchemeList();

  @override
  void initState() {
    // implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

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
                ),
                border: Border.all(color: Config.appTheme.themeColor),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Cancelled Successfully',
                      style: AppFonts.f70018Black.copyWith(
                          fontSize: 22,
                          color: Config.appTheme.themeColor),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    paymentCard(),
                    SizedBox(height: 16),
                    MarketTypeCard(client_code_map: client_code_map),
                    SizedBox(height: 16),
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
            title: status,
            value: status,
            valueStyle: AppFonts.f50014Black
                .copyWith(color: Config.appTheme.defaultProfit),
          ),
        ],
      ),
    );
  }

}
