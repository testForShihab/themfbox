import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/pojo/CartPojo.dart';
import 'package:mymfbox2_0/pojo/transaction/SuccessPojo.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({super.key, required this.successPojo});
  final SuccessPojo successPojo;
  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  late double devWidth, devHeight;
  late SuccessPojo successPojo;
  String user_name = GetStorage().read('user_name');

  late Map transactionList;

  @override
  void initState() {
    // implement initState
    super.initState();
    successPojo = widget.successPojo;
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
                    'Order Placed Successfully',
                    style: AppFonts.f70018Black.copyWith(
                        fontSize: 22, color: Config.appTheme.themeColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: successPojo.cart!.length,
                    itemBuilder: (context, index) {
                      CartPojo cart = successPojo.cart![index];

                      return cartItem(cart);
                    },
                  ),
                  bankCard(),
                  paymentCard(),
                  arnEuin(),
                  SizedBox(height: 16),
                  Container(
                    width: devWidth,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        border: Border.all(color: Config.appTheme.lineColor),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Image.asset("assets/registration/nse_logo.png",
                            height: 34),
                        SizedBox(width: 10),
                        ColumnText(
                          title: user_name,
                          value: "${successPojo.arn}-SINGLE-ARN-XXXX",
                          titleStyle: AppFonts.f50014Black,
                          valueStyle: AppFonts.f50012
                              .copyWith(color: Config.appTheme.themeColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
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
                            Text("Next Steps", style: AppFonts.f50014Black)
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "1. Redemption order placed successfully.",
                          style: AppFonts.f50012.copyWith(
                              color: Config.appTheme.readableGreyTitle),
                        ),
                        Text(
                            "2. Please authorise the transaction by clicking on the link sent to your email or sms sent to registered mobile.")
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  RpFilledButton(
                    text: "DASHBOARD",
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
            child: ColumnText(title: "ARN Number", value: "${successPojo.arn}"),
          ),
          Expanded(
            child: ColumnText(title: "EUIN", value: "${successPojo.euin}"),
          ),
        ],
      ),
    );
  }

  Widget paymentCard() {
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
            value: "Successful",
            valueStyle: AppFonts.f50014Black
                .copyWith(color: Config.appTheme.defaultProfit),
          ),
        ],
      ),
    );
  }

  Widget bankCard() {
    if (successPojo.bank == null) return SizedBox();
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
          ColumnText(title: "Bank", value: "${successPojo.bank}"),
          SizedBox(height: 16),
          ColumnText(
              title: "Payment Mode", value: "${successPojo.paymentMode}"),
        ],
      ),
    );
  }

  Widget cartItem(CartPojo item) {
    String amount = "";
    if (item.trnxType!.contains("Units"))
      amount = "${item.units} Units";
    else {
      amount = Utils.formatNumber(num.parse(item.amount ?? ""));
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
                Image.network("${item.schemeLogo}", height: 28),
                SizedBox(width: 10),
                Expanded(
                  child: ColumnText(
                    title: "${item.schemeAmfiShortName}",
                    value: "Folio : ${item.folioNo}",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013.copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Text("${item.purchaseType} : ",
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
