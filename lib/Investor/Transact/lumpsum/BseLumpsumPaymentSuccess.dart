import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/InvestorDashboard.dart';
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

class BseLumpsumPaymentSuccess extends StatefulWidget {
  const BseLumpsumPaymentSuccess(
      {super.key, required this.paymentId, this.msg = "", this.purchase_type = ""});
  final String paymentId;
  final String msg;
  final String purchase_type;
  @override
  State<BseLumpsumPaymentSuccess> createState() => _BseLumpsumPaymentSuccessState();
}

class _BseLumpsumPaymentSuccessState extends State<BseLumpsumPaymentSuccess> {
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
      purchase_type: "Lumpsum Purchase",
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

  String purchase_type = '';

  @override
  void initState() {
    // implement initState
    purchase_type = widget.purchase_type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Config.appTheme.themeColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50,),
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
                      'Order placed was successful.',
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
                   // bankCard(),
                    //paymentCard(),
                    //arnEuin(),
                    SizedBox(height: 16),
                    MarketTypeCard(client_code_map: client_code_map),
                    SizedBox(height: 16),
                    if(purchase_type !="Redemption Purchase")
                    Text(
                      'Once you have made the payment successfully, your order will be processed and your portfolio will be updated within 2-3 working days. \n\n Thank you for investing with us. \n\n You may safely close by clicking on the Dashboard button below',
                      style: AppFonts.f70018Black.copyWith(
                          fontSize: 14,
                          color: Config.appTheme.themeColor),
                      textAlign: TextAlign.center,
                    ),
                    if(purchase_type == "Redemption Purchase")
                      Container(
                        width: devWidth,
                        padding: EdgeInsets.fromLTRB(16,16,16,8),
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                            border: Border.all(color: Config.appTheme.lineColor),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Text('Redemption Status',
                              style: AppFonts.f70018Black.copyWith(
                                  fontSize: 16,
                                  color: Config.appTheme.themeColor),
                              textAlign: TextAlign.center,),
                            SizedBox(height: 10,),
                            Text(
                              'Your authentication was successful, and your redemption will be reflected in your portfolio within 2-3 working days.\n\n Thank you for investing with us. \n\n You may safely close by clicking on the Dashboard button below',
                              style: AppFonts.f70018Black.copyWith(
                                  fontSize: 14,
                                  color: Config.appTheme.themeColor),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 16),
                    RpFilledButton(
                      text: "DASHBOARD",
                      onPressed: () {
                        Get.offAll(InvestorDashboard());
                      },
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
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
                //Image.network("${scheme.schemeLogo}", height: 28),
                Utils.getImage("${scheme.schemeLogo}",32),
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
}
