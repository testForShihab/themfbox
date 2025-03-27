import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:http/http.dart' as Http;
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/common/goal/Goal5.dart';
// import 'package:mymfbox2_0/common/goal/Goal5Nse.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import '../../rp_widgets/AdminAppBar.dart';
import '../../rp_widgets/Loading.dart';
import '../../rp_widgets/RpAppBar.dart';
import '../../utils/Config.dart';
import 'Goal2.dart';
import 'GoalSIPAmountResponce.dart';

class Goal4 extends StatefulWidget {
  final String? goalName;
  final String? planName;
  final String? amount;
  final String? age;
  final String? years;
  final double? inflation;
  final String? risk;

  Goal4(
      {this.goalName,
      this.planName,
      this.amount,
      this.age,
      this.years,
      this.inflation,
      this.risk});

  @override
  Goal4State createState() => Goal4State();
}

class Goal4State extends State<Goal4> {
  late GoalSIPAmountResponce goalSIPAmountResponce;

  int? user_id = GetStorage().read("user_id");
  String? user_name = GetStorage().read("user_name");
  String? client_name = GetStorage().read("client_name");

  String? admin_id = GetStorage().read("admin_id");
  String? admin_type_id = GetStorage().read("admin_type_id");

  String? user_bse_or_nse = GetStorage().read("user_bse_or_nse");

  NumberFormat numberFormat =
      NumberFormat.currency(locale: "HI", symbol: "", decimalDigits: 0);

  late TextEditingController textFieldController;

  String? amount = "";
  String? goal = "";
  double inflation = 0.0;
  String? risk = "";
  String? years = "";
  String? goalName = "";
  String? age = "";

  String? target_amount = "";
  String? sip_amount = "";
  bool isLoading = true;
  String? platformType = "";
  List<String?> bse_nse_type = [];
  late Map<String?, String?> apiValueDescriptions;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      init();
    });
  }

  init() async {
    amount = widget.amount;
    goal = widget.goalName;
    risk = widget.risk;
    years = widget.years;
    goalName = widget.planName;
    inflation = widget.inflation!;
    age = widget.age;

    print("amount = ${amount!}");
    print("goal = ${goal!}");
    print("risk = ${risk!}");
    print("inflation = $inflation");
    print("years = ${years!}");
    print("goal_name = ${goalName!}");

    goalSIPAmountResponce = await getGoalSIPAmount();
    setState(() {
      target_amount = numberFormat.format(goalSIPAmountResponce.targetAmount);
      sip_amount = numberFormat.format(goalSIPAmountResponce.sipAmount);
      isLoading = false;
    });

    apiValueDescriptions = {
      'bse': 'BSE StAR MF Platform',
      'nse': 'NSENMF Platform',
      'mfu': 'MF Utilities Platform'
    };

    bse_nse_type = user_bse_or_nse!.split(",");
    print("print the type---->$user_bse_or_nse");
    if (bse_nse_type.contains('bse')) {
      apiValueDescriptions['bse'];
    } else if (bse_nse_type.contains('nse')) {
      apiValueDescriptions['nse'];
    } else if (bse_nse_type.contains('mfu')) {
      apiValueDescriptions['mfu'];
    } else {}
  }

  void resetSelectedOption() {
    platformType = "";
  }

  @override
  Widget build(BuildContext context) {
    // var numberFormat = NumberFormat("#,##,000");
    if (isLoading) return Loading();
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "${widget.goalName!}Goals",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      bottomNavigationBar: Material(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CalculateButton(
            text: "Recalculate ",
            onPress: () {
              Get.to(Goal2(
                goalName: widget.goalName!,
                planName: widget.planName,
                amount: widget.amount,
                years: widget.years,
                age: widget.age,
                inflation: widget.inflation,
                risk: widget.risk,
              ));
            },
          ),
          if (Config.appArn != "177080")
            if (client_name != "fortuneinvestment")
              if (client_name != "finvision")
                if (!(admin_type_id != '5' && client_name == 'candcfinancial'))
                  CalculateButton(
                      text: "Show Recommended Funds",
                      onPress: () {
                        Get.to(
                          Goal5(
                            mobile: user_name ?? '',
                            years: years ?? '',
                            sipAmount:
                                goalSIPAmountResponce.sipAmount!.toDouble(),
                            risk: risk ?? '',
                            age: age ?? '',
                            targetAmount: goalSIPAmountResponce.targetAmount!,
                          ),
                        );

                        // if (marketType == 'nse') Get.to(Goal5Nse());

                        // user_bse_or_nse = user_bse_or_nse!.trim();
                        /* if (user_bse_or_nse?.toLowerCase() == "nse") {
                                String? strSipAmout = goalSIPAmountResponce.sipAmount.toString();
                                double? dobTargetAmount = goalSIPAmountResponce.targetAmount;
                                Get.to(
                                  Goal5Nse(
                                    goalName: widget.goalName,
                                    planName: widget.planName,
                                    amount: widget.amount,
                                    years: widget.years,
                                    age: widget.age,
                                    inflation: widget.inflation,
                                    risk: widget.risk,
                                    sipAmount: strSipAmout,
                                    targetAmount: dobTargetAmount,
                                  ),
                                );
                              } else if (user_bse_or_nse.toLowerCase() == "bse") {
                                print("181 if true");
                                Get.to(
                                  Goal5Bse(
                                    goalName: widget.goalName,
                                    planName: widget.planName,
                                    amount: widget.amount,
                                    years: widget.years,
                                    age: widget.age,
                                    inflation: widget.inflation,
                                    risk: widget.risk,
                                    sipAmount:
                                    goalSIPAmountResponce.sipAmount.toString?(),
                                    targetAmount:
                                    goalSIPAmountResponce.targetAmount,
                                  ),
                                );
                              } else if (user_bse_or_nse.toLowerCase() == "mfu") {
                                Get.to(
                                  Goal5Mfu(
                                    goalName: widget.goalName,
                                    planName: widget.planName,
                                    amount: widget.amount,
                                    years: widget.years,
                                    age: widget.age,
                                    inflation: widget.inflation,
                                    risk: widget.risk,
                                    sipAmount:
                                    goalSIPAmountResponce.sipAmount.toString?(),
                                    targetAmount:
                                    goalSIPAmountResponce.targetAmount,
                                  ),
                                );
                              }  else if(user_bse_or_nse.contains(',')){

                                resetSelectedOption();
                                showPlatformSIPDialog(context);
                                //Navigator.pop(context);
                              }else {
                                print("all false 214");
                              }*/
                      }),
        ],
      )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            //padding: EdgeInsets.only(top: 8,bottom: 8),
                            child: ColumnText(
                              title: "Your Targeted Amount (in today's value)",
                              titleStyle: AppFonts.f50014Black,
                              value:
                                  "\u{20B9} ${numberFormat.format(int.parse(amount!.trim()))}",
                              alignment: CrossAxisAlignment.center,
                              valueStyle: AppFonts.f50014Black.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Config.appTheme.themeColor),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: ColumnText(
                              title: "Number of Years You Need To Save",
                              value: "${years!} Years",
                              alignment: CrossAxisAlignment.center,
                              titleStyle: AppFonts.f50014Black,
                              valueStyle: AppFonts.f50014Black.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Config.appTheme.themeColor),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: ColumnText(
                              title:
                                  "Future Value (adjusting for $inflation% inflation)",
                              value: "\u{20B9} $target_amount",
                              alignment: CrossAxisAlignment.center,
                              titleStyle: AppFonts.f50014Black,
                              valueStyle: AppFonts.f50014Black.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Config.appTheme.themeColor),
                            ),
                          ),
                        ]),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 0),
                    decoration: BoxDecoration(
                        color: Color(0xFFECFBF5),
                        borderRadius: BorderRadius.all(
                            Radius.circular(5)), //BorderRadius.Only
                        border: Border.all(color: Color(0XFFD7E9E4))),
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(18.0),
                                child: Image(
                                  image: AssetImage("assets/goal4_image.png"),
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'You need to save',
                                          style: AppFonts.f50014Grey
                                              .copyWith(fontSize: 14),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          child: Text(
                                              "\u{20B9} ${sip_amount!} Monthly",
                                              textAlign: TextAlign.left,
                                              style: AppFonts.f70018Green),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void showPlatformSIPDialog(BuildContext buildContext) {
    showModalBottomSheet(
      enableDrag: true,
      context: buildContext,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      //backgroundColor: Utils.pageBgColor,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.750,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(16, 22, 16, 22),
                  height: 65,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(
                        "Choose Investment Platform",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w500,
                          color: Color(0XFF3B3B3B),
                        ),
                      )),
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Icon(
                            Icons.close,
                            size: 24,
                            color: Color(0XFF3B3B3B),
                          ),
                        ),
                        onTap: () {
                          Get.back();
                        },
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: bse_nse_type.length,
                      itemBuilder: (context, index) {
                        final platform = bse_nse_type[index];
                        return RadioListTile(
                          title:
                              Text(apiValueDescriptions[platform] ?? 'Unknown'),
                          // Set title dynamically
                          value: platform,
                          groupValue: platformType,
                          onChanged: (value) {
                            /*if (value == 'nse') {
                              String? strSipAmout = goalSIPAmountResponce.sipAmount.toString();
                              double? dobTargetAmount = goalSIPAmountResponce.targetAmount;
                              Get.to(
                                Goal5Nse(
                                  goalName: widget.goalName,
                                  planName: widget.planName,
                                  amount: widget.amount,
                                  years: widget.years,
                                  age: widget.age,
                                  inflation: widget.inflation,
                                  risk: widget.risk,
                                  sipAmount: strSipAmout,
                                  targetAmount: dobTargetAmount,
                                ),
                              );
                            } else if (value == "bse") {
                              print("181 if true");
                              Get.to(
                                Goal5Bse(
                                  goalName: widget.goalName,
                                  planName: widget.planName,
                                  amount: widget.amount,
                                  years: widget.years,
                                  age: widget.age,
                                  inflation: widget.inflation,
                                  risk: widget.risk,
                                  sipAmount:
                                  goalSIPAmountResponce.sipAmount.toString?(),
                                  targetAmount:
                                  goalSIPAmountResponce.targetAmount,
                                ),
                              );
                            } else if (value == "mfu") {
                              Get.to(
                                Goal5Mfu(
                                  goalName: widget.goalName,
                                  planName: widget.planName,
                                  amount: widget.amount,
                                  years: widget.years,
                                  age: widget.age,
                                  inflation: widget.inflation,
                                  risk: widget.risk,
                                  sipAmount:
                                  goalSIPAmountResponce.sipAmount.toString?(),
                                  targetAmount:
                                  goalSIPAmountResponce.targetAmount,
                                ),
                              );
                            }
                            else{}
                            setDialogState(() {
                              platformType = value;
                            });*/
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Future<GoalSIPAmountResponce> getGoalSIPAmount() async {
    EasyLoading.show(
      status: 'loading...',
    );
    String? url =
        "https://mfportfolio.in/api/getGoalSIPAmount?key=${ApiConfig.apiKey}&amount=$amount&goal=$goal&inflation=$inflation&risk=$risk&years=$years";
    print("url - " + url);
    Http.Response response = await Http.post(Uri.parse(url));
    print(response.body);
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      return GoalSIPAmountResponce.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
}
