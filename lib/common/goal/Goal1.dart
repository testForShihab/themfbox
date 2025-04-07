import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/common/goal/Goal2.dart';
import 'package:mymfbox2_0/common/goal/GoalDetailsResponce.dart';
import 'package:mymfbox2_0/research/FundsCard.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:http/http.dart' as Http;
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../rp_widgets/AdminAppBar.dart';
import '../../rp_widgets/RpAppBar.dart';
import '../../utils/AppThemes.dart';

class Goal1 extends StatefulWidget {
  Goal1({
    this.name,
    this.image,
    this.postion,
  });

  String? name;
  String? image;
  String? postion;

  @override
  _Goal1State createState() => _Goal1State();
}

class _Goal1State extends State<Goal1> {
  late String val;
  int user_id = GetStorage().read("user_id");
  String user_name = GetStorage().read("user_name");
  String user_mobile = GetStorage().read("user_mobile");
  String client_name = GetStorage().read("client_name");
  String? admin_id = GetStorage().read("admin_id");
  String? admin_type_id = GetStorage().read("admin_type_id");

  late GoalDetailsResponce goalDetailsResponce;
  List<Goal> goalList = [];

  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () {
      init(context);
    });
  }

  void init(BuildContext context) async {
    GoalDetailsResponce goalDetailsResponce = await httpgetGoalDetails(context);
    setState(() {
      goalList = goalDetailsResponce.goalList!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: (user_id != 0)
          ? adminAppBar(title: "Goals",hasAction: false)
          : rpAppBar(title: "Goals"),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 6,
            ),
            goalList.isNotEmpty
                ? Container(
                    padding:
                        EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 0),
                    child: Text("You are on track with your Goals",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w500,
                            color: Color(0XFF3B3B3B))),
                  )
                : Container(),
            goalList.isNotEmpty
                ? Container(
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: goalList.length,
                      itemBuilder: (BuildContext context, index) {
                        return getGoalsList(goalList[index], context);
                      },
                    ),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 0),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text("Start planning for your goals",
                        textAlign: TextAlign.start, style: AppFonts.f40016),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FundCard(
                        title: "Dream Home",
                        icon: Image.asset(
                          'assets/mf_goal_home.png',
                          color: Colors.white,
                        ),
                        goTo: Goal2(
                          goalName: "Dream Home",
                          planName: "Dream Home",
                          amount: "",
                          years: "",
                          inflation: 5.0,
                          risk: "",
                          age: '',
                        ),
                      ),
                      FundCard(
                        title: "Child Education",
                        icon: Image.asset(
                          'assets/mf_goal_education.png',
                          color: Colors.white,
                        ),
                        goTo: Goal2(
                          goalName: "Child Education",
                          planName: "Child Education",
                          amount: "",
                          years: "",
                          inflation: 5.0,
                          risk: "",
                          age: '',
                        ),
                      ),
                      FundCard(
                        title: "Retirement Planning",
                        icon: Image.asset(
                          'assets/mf_goal_retirement.png',
                          color: Colors.white,
                        ),
                        goTo: Goal2(
                          goalName: "Retirement Planning",
                          planName: "Retirement Planning",
                          amount: "",
                          years: "",
                          inflation: 5.0,
                          risk: "",
                          age: '',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FundCard(
                        title: "Build Wealth",
                        icon: Image.asset(
                          'assets/mf_save_tax.png',
                          color: Colors.white,
                        ),
                        goTo: Goal2(
                          goalName: "Build Wealth",
                          planName: "Build Wealth",
                          amount: "",
                          years: "",
                          inflation: 5.0,
                          risk: "",
                          age: '',
                        ),
                      ),
                      FundCard(
                        title: "Emergency Fund",
                        icon: Image.asset(
                          'assets/mf_emergency_fund.png',
                          color: Colors.white,
                        ),
                        goTo: Goal2(
                          goalName: "Emergency Fund",
                          planName: "Emergency Fund",
                          amount: "",
                          years: "",
                          inflation: 5.0,
                          risk: "",
                          age: '',
                        ),
                      ),
                      FundCard(
                        title: "Wedding",
                        icon: Image.asset(
                          'assets/mf_wedding.png',
                          color: Colors.white,
                        ),
                        goTo: Goal2(
                          goalName: "Wedding",
                          planName: "Wedding",
                          amount: "",
                          years: "",
                          inflation: 5.0,
                          risk: "",
                          age: '',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FundCard(
                        title: "International Vacation",
                        icon: Image.asset(
                          'assets/mf_vacation.png',
                          color: Colors.white,
                        ),
                        goTo: Goal2(
                          goalName: "International Vacation",
                          planName: "International Vacation",
                          amount: "",
                          years: "",
                          inflation: 5.0,
                          risk: "",
                          age: '',
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Expanded(child: SizedBox()),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getGoalsList(Goal goal, BuildContext context) {
    NumberFormat numberFormat =
        NumberFormat.currency(locale: "HI", symbol: "", decimalDigits: 0);
    var format = new NumberFormat("#,##,000");

    String? goalName = goal.goalName;
    String? amount = goal.amount;
    String? targetedAmount = goal.targetAmount;
    String? achievedAmount = goal.achievedAmount;
    String? timeHorizon = goal.horizon;
    String? sipAmount = goal.sipAmount;
    String? riskProfile = goal.risk;
    String? achievedpercentage = goal.achievedPercentage;
    double? target = double.parse(targetedAmount!).roundToDouble();
    double? achieved = double.parse(achievedAmount!).roundToDouble();
    String? cleanedInflation =
        (goal.inflation)?.replaceAll(RegExp(r'[^\d.]'), '');
    double inflation = double.parse(cleanedInflation!).roundToDouble();
    //double inflation = double.parse(goal.inflation).roundToDouble();
    //double inflation = double.parse(goal.inflation).roundToDouble();
    double? sip = double.parse(goal.sipAmount!).roundToDouble();

    //double achievedPercentage = double.parse(goal.achievedPercentage).roundToDouble();
    // double existingCurrentValue = double.parse(goal.existingSchemeCurrentValue).roundToDouble();

    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text("$goalName",
                        textAlign: TextAlign.left,
                        maxLines: 3,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF666666))),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(top: 2),
                    // child: Text('\u{20B9} ' + numberFormat.format(email),
                    child: Text('\u20B9' + numberFormat.format(achieved),
                        textAlign: TextAlign.end,
                        maxLines: 2,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF666666))),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  alignment: Alignment.topCenter,
                  color: Colors.white,
                  child: Text("Goal Progress",
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF9099A7))),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    color: Colors.white,
                    child: Text("${achievedpercentage!}%",
                        textAlign: TextAlign.end,
                        maxLines: 2,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF666666))),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 10),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTickMarkColor: Colors.transparent,
                  inactiveTickMarkColor: Colors.transparent,
                  activeTrackColor: Color(0xFFFBC441),
                  inactiveTrackColor: Color(0xFFF2F2F2),
                  trackHeight: 4,
                  thumbColor: Colors.transparent,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
                ),
                child: Slider(
                    value: inflation,
                    min: 0,
                    max: 100,
                    label: 'Label',
                    onChanged: (values) {
                      setState(() {
                        values = inflation;
                      });
                    }),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Target Amount",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w400,
                                color: Color(0XFF9099A7)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            numberFormat.format(target),
                            // Text('\u{20B9} ' + sipAmount,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w400,
                                color: Color(0XFF666666)),
                          )
                        ],
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Time Horizon",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w400,
                                color: Color(0XFF9AAEC7)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "$timeHorizon Years",
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w400,
                                color: Color(0XFF666666)),
                          )
                        ],
                      )),
                  Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "SIP Amount",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w400,
                                color: Color(0XFF9AAEC7)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            numberFormat.format(sip),
                            maxLines: 2,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w400,
                                color: Color(0XFF1FC094)),
                          )
                        ],
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Risk Profile",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w400,
                              color: Color(0XFF9099A7)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          riskProfile!,
                          // Text('\u{20B9} ' + sipAmount,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w400,
                              color: Color(0XFF666666)),
                        )
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<GoalDetailsResponce> httpgetGoalDetails(BuildContext context) async {
    String url =
        "https://mfportfolio.in/api/getGoalDetails?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";
    EasyLoading.show(
      status: 'loading...',
    );
    print("url - " + url);
    Http.Response response = await Http.post(Uri.parse(url));
    print("response = " + response.body);
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      return GoalDetailsResponce.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
}
