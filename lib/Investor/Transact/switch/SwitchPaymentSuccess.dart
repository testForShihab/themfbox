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

class SwitchPaymentSuccess extends StatefulWidget {
  const SwitchPaymentSuccess(
      {super.key, required this.paymentId, this.msg = ""});
  final String paymentId;
  final String msg;
  @override
  State<SwitchPaymentSuccess> createState() => _SwitchPaymentSuccessState();
}

class _SwitchPaymentSuccessState extends State<SwitchPaymentSuccess> {
  late double devWidth, devHeight;
  // late SuccessPojo successPojo;
  int user_id = GetStorage().read('user_id');
  String client_name = GetStorage().read('client_name');
  Map client_code_map = GetStorage().read('client_code_map');

  Result result = Result();
  SchemeList scheme1 = SchemeList();

  Future getCartStatusByUserId() async {
    Map<String, dynamic> data = await TransactionApi.getCartStatusByUserId(
      user_id: user_id,
      client_name: client_name,
      paymentId: widget.paymentId,
      purchase_type: PurchaseType.switchPurchase,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    GetCartByUserIdPojo cart = GetCartByUserIdPojo.fromJson(data);
    result = cart.result!.first;
    scheme1 = result.schemeList!.first;

    return 0;
  }

  @override
  void initState() {
    // implement initState
    super.initState();
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
                                  "1. Switch order placed Successfully.",
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
            title: "Switch Status",
            value: status,
            valueStyle: AppFonts.f50014Black
                .copyWith(color: Config.appTheme.defaultProfit),
          ),
        ],
      ),
    );
  }

  Widget cartItem(SchemeList scheme) {
    String name = scheme.schemeAmfiShortName ?? "";
    if (name.isEmpty) name = scheme.schemeName ?? "";

    String amount = "";
    if (scheme.amountType!.contains("Units"))
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
                //Image.network("${scheme.schemeLogo}", height: 28),
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
                Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Config.appTheme.themeColor)),
                    child: Icon(Icons.arrow_forward,
                        color: Config.appTheme.themeColor)),
                SizedBox(width: 10),
                Expanded(child: Text("${scheme.toSchemeAmfiShortName}"))
              ],
            ),
            SizedBox(height: 8),
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
}
