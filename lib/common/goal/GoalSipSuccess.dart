import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/InvestorDashboard.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../rp_widgets/AdminAppBar.dart';
import '../../rp_widgets/RpAppBar.dart';


class GoalSipSuccess extends StatefulWidget {

  GoalSipSuccess({
    this.goalName,
    this.sipAmount,
    this.transactionNo,
    this.msg,
  });

  String? goalName;
  String? sipAmount;
  String? transactionNo;
  String? msg;

  @override
  GoalSipSuccessState createState() => GoalSipSuccessState();

}

class GoalSipSuccessState extends State<GoalSipSuccess> {
  String user_id = GetStorage().read("user_id");
  String user_name = GetStorage().read("user_name");
  String user_mobile = GetStorage().read("user_mobile");
  String client_name = GetStorage().read("client_name");
  String admin_id = GetStorage().read("admin_id");
  String admin_type_id = GetStorage().read("admin_type_id");
  String user_pan = GetStorage().read("user_pan");

  NumberFormat numberFormat = NumberFormat.currency(locale: "HI", symbol: "", decimalDigits: 0);
  NumberFormat numberFormatWithDecimal = NumberFormat.currency(locale: "HI", symbol: "", decimalDigits: 2);

  String? goalName;
  String? sipAmount;
  String? transactionNo;
  String? msg;

  @override
  void initState() {
    super.initState();

    goalName = widget.goalName;
    sipAmount = widget.sipAmount;
    transactionNo = widget.transactionNo;
    msg = widget.msg;

    print("goalName = " + goalName!);
    print("sipAmount = " + sipAmount!);
    print("transactionNo = " + transactionNo!);
    print("msg = " + msg!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Config.appTheme.mainBgColor,
        appBar: (user_id != 0)
            ? adminAppBar(title: "SIP Successfull" ,hasAction: false)
            : rpAppBar(title: "SIP Successfull"),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Container(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 24),
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                       color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: new Text("SIP - Investment Successful",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1FC094))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: Image.asset(
                          "images/investSucces.png",
                          height: 200,
                          width: 200,
                          alignment: Alignment.center,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: const Divider(
                          color: Color(0XFF333333),
                          height: 1,
                          thickness: 0.2,
                          indent: 0,
                          endIndent: 0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 4, 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(4, 10, 0, 10),
                                child: Text("Goal - $goalName",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF666666),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Roboto')),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: const Divider(
                          color: Color(0XFF333333),
                          height: 1,
                          thickness: 0.2,
                          indent: 0,
                          endIndent: 0,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(20,10,10,10),
                            child: Row(
                              children: [
                                Text("Total Amount (SIP) : ", /*style: Utils.textStyleStatusPageKey,*/),
                                Text("$sipAmount", /*style: Utils.textStyleStatusPageValue,*/),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(20,10,10,10),
                            child: Row(
                              children: [
                                Text("Transaction No : ", /*style: Utils.textStyleStatusPageKey,*/),
                                Expanded(child: Text("$transactionNo", /*style: Utils.textStyleStatusPageValue, maxLines: 15,*/)),
                              ],
                            ),
                          ),
                          msg != null && msg!.isNotEmpty ?Padding(
                            padding: const EdgeInsets.fromLTRB(24,10,24,10),
                            child: Container(
                              child: Text('$msg',
                                textAlign: TextAlign.justify,
                                /*style: Utils.textStyleStatusPageKey,*/
                              ),
                            ),
                          ) : Container(),

                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            height: 50,
                            child: ElevatedButton(
                              child: Text("Okay,Looks Good!",
                                  /*style: AppTheme.textStylePrimaryFont15w400Roboto*/),
                              /*style: Utils.ElevatedButtonStylePlainBorder,*/
                              onPressed: () {
                                Get.offAll(InvestorDashboard());
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
