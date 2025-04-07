import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/common/calculators/CompoundingCalculator/CompoundingCalculatorInput.dart';
import 'package:mymfbox2_0/common/calculators/CrorepatiCalculator/CrorepatiCalculatorInput.dart';
import 'package:mymfbox2_0/common/calculators/FutureValueCalculator/FutureValueCalculatorInput.dart';
import 'package:mymfbox2_0/common/calculators/GoalBasedLumpsumCalculator/GoalLumpsumCalculatorInput.dart';
import 'package:mymfbox2_0/common/calculators/GoalBasedSIPCalculator/GoalBasedSipCalculatorInput.dart';
import 'package:mymfbox2_0/common/calculators/LoanEmiCalculator/LoanEmiCalculatorInput.dart';
import 'package:mymfbox2_0/common/calculators/LumpsumCalculator/LumpsumCalculatorInput.dart';
import 'package:mymfbox2_0/common/calculators/NetworthCalculator/NetworthCalculatorInput.dart';
import 'package:mymfbox2_0/common/calculators/RetirementCalculator/RetirementCalculatorInput.dart';
import 'package:mymfbox2_0/common/calculators/RetirementPlanner/RetirementPlannerInput.dart';
import 'package:mymfbox2_0/common/calculators/SIPCalculator/SipCalculatorInput.dart';
import 'package:mymfbox2_0/research/FundsCard.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';

class Calculators extends StatefulWidget {
  const Calculators({super.key});

  @override
  State<Calculators> createState() => _CalculatorsState();
}

class _CalculatorsState extends State<Calculators> {
  int user_id = GetStorage().read("mfd_id") ?? 0;
  late double devHeight, devWidth;

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    List<Color> topArcColors = [
      Color.fromRGBO(224, 224, 224, 1),
      Color.fromRGBO(224, 224, 224, 100),
    ];
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: (user_id != 0)
          ? adminAppBar(title: "Calculators" ,hasAction: false)
          : rpAppBar(title: "Calculators"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: devWidth * 0.03),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Config.appTheme.lineColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(calcDescription,
                      textAlign: TextAlign.justify,
                      style: AppFonts.f40013.copyWith(color: Colors.black)),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  FundCard(
                    title: "SIP\nCalculator",
                    icon: Image.asset('assets/sipWhiteCalc.png'),
                    topImg: "assets/ellipse.png",
                    iconColor: Colors.white,
                    goTo: SipCalculatorInput(),
                  ),
                  FundCard(
                    title: "Lumpsum\nCalculator",
                    icon: Image.asset('assets/lumpsumCalculators.png'),
                    topImg: "assets/ellipse.png",
                    iconColor: Colors.white,
                    goTo: LumpsumCalculatorInput(),
                  ),
                  FundCard(
                    title: "Become a\nCrorepati",
                    icon: Image.asset('assets/becomeACrorepati.png'),
                    topImg: "assets/ellipse.png",
                    iconColor: Colors.white,
                    goTo: CrorepatiCalculatorInput(),
                  ),
                ],
              ),
              SizedBox(
                width: devWidth,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(vertical: 16),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("  Popular Investment Calculators",
                          style: AppFonts.f40016.copyWith(fontSize: 18)),
                      SizedBox(height: 12),
                      Column(
                        children: [
                          Row(
                            children: [
                              FundCard(
                                title: "Goal Based\nSIP",
                                icon: Image.asset('assets/goalbased_sip.png',
                                    color: Config.appTheme.themeColor),
                                topImg: "assets/ellipse_grey.png",
                                goTo: GoalBasedSipCalculatorInput(),
                                color: Config.appTheme.Bg2Color,
                                titleColor: Config.appTheme.themeColor,
                                topArcColors: topArcColors,
                              ),
                              FundCard(
                                title: "Goal Based\nLumpsum",
                                icon: Image.asset(
                                    'assets/goalbased_lumpsum.png',
                                    color: Config.appTheme.themeColor),
                                topImg: "assets/ellipse_grey.png",
                                goTo: GoalBasedLumpsumCalculatorInput(),
                                color: Config.appTheme.Bg2Color,
                                titleColor: Config.appTheme.themeColor,
                                topArcColors: topArcColors,
                              ),
                              FundCard(
                                title: "Retirement\nCalculator",
                                icon: Image.asset(
                                    'assets/retirement_planner.png',
                                    color: Config.appTheme.themeColor),
                                topImg: "assets/ellipse_grey.png",
                                goTo: RetirementCalculatorInput(),
                                color: Config.appTheme.Bg2Color,
                                titleColor: Config.appTheme.themeColor,
                                topArcColors: topArcColors,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FundCard(
                                title: "Retirement\nPlanner",
                                icon: Image.asset(
                                    'assets/retirement_calculator.png',
                                    color: Config.appTheme.themeColor),
                                topImg: "assets/ellipse_grey.png",
                                goTo: RetirementPlannerInput(),
                                color: Config.appTheme.Bg2Color,
                                titleColor: Config.appTheme.themeColor,
                                topArcColors: topArcColors,
                              ),
                              Expanded(child: SizedBox()),
                              Expanded(child: SizedBox()),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: devWidth,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(vertical: 16),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(" Other Calculators",
                          style: AppFonts.f40016.copyWith(fontSize: 18)),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          FundCard(
                            title: "Loan EMI\nCalculator",
                            icon: Image.asset('assets/emi_calculator.png',
                                color: Config.appTheme.themeColor),
                            topImg: "assets/ellipse_grey.png",
                            goTo: LoanEmiCalculatorInput(),
                            color: Config.appTheme.Bg2Color,
                            titleColor: Config.appTheme.themeColor,
                            topArcColors: topArcColors,
                          ),
                          FundCard(
                            title: "Networth\nCalculator",
                            icon: Image.asset('assets/networth_calculator.png',
                                color: Config.appTheme.themeColor),
                            topImg: "assets/ellipse_grey.png",
                            goTo: NetworthCalculatorInput(),
                            color: Config.appTheme.Bg2Color,
                            titleColor: Config.appTheme.themeColor,
                            topArcColors: topArcColors,
                          ),
                          FundCard(
                            title: "Compound\nCalculator",
                            icon: Image.asset('assets/compound_calculator.png',
                                color: Config.appTheme.themeColor),
                            topImg: "assets/ellipse_grey.png",
                            goTo: CompoundingCalculatorInput(),
                            color: Config.appTheme.Bg2Color,
                            titleColor: Config.appTheme.themeColor,
                            topArcColors: topArcColors,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          FundCard(
                            title: "Future\nValue",
                            icon: Image.asset('assets/future_value.png',
                                color: Config.appTheme.themeColor),
                            topImg: "assets/ellipse_grey.png",
                            goTo: FutureValueCalculatorInput(),
                            color: Config.appTheme.Bg2Color,
                            titleColor: Config.appTheme.themeColor,
                            topArcColors: topArcColors,
                          ),
                          Expanded(child: SizedBox()),
                          Expanded(child: SizedBox()),
                        ],
                      ),
                      /*   Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Wrap(
                          children: [
                            sqCard("EMI\nCalculator",
                                goTo: LoanEmiCalculatorInput()),
                            sqCard("Networth\nCalculator",
                                goTo: NetworthCalculatorInput()),
                            sqCard("Compound\nCalculator",
                                goTo: CompoundingCalculatorInput()),
                            sqCard("Future\Value",
                                goTo: FutureValueCalculatorInput()),
                          ],
                        ),
                      )*/
                    ],
                  ),
                ),
              ),
              SizedBox(height: 60)
            ],
          ),
        ),
      ),
    );
  }
}
