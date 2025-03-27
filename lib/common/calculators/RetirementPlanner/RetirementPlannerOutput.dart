import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/ShareWidget.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import 'package:mymfbox2_0/api/ApiConfig.dart';

import '../../../Investor/sipPortfolioSummary/SipPortfolioSummary.widgets.dart';
import '../../../pojo/UserDataPojo.dart';

class RetirementPlannerOutput extends StatefulWidget {
  const RetirementPlannerOutput(
      {super.key,
      required this.currentAge,
      required this.retirementAge,
      required this.endAge,
      required this.targetAmount,
      required this.result,
      required this.currentInvestment,
      required this.monthlyExpense,
      required this.energyCorpus,
      required this.inflation});
  final int currentAge, retirementAge, endAge;
  final num targetAmount,
      currentInvestment,
      monthlyExpense,
      energyCorpus,
      inflation;
  final Map result;

  @override
  State<RetirementPlannerOutput> createState() =>
      _RetirementPlannerOutputState();
}

class _RetirementPlannerOutputState extends State<RetirementPlannerOutput> {
  late double devHeight, devWidth;
  late num targetAmount, futureValue, endAge, monthlyExpense;
  late Map result;
  late String currentInvestment;
  late num s1AccReturn, s2AccReturn;
  late num s1DistributionReturn, s2DistributionReturn;
  late String s1CorpusAmt, s2CorpusAmt;
  late String s1CorpusBal, s2CorpusBal;
  late String s1Sip, s2Sip;
  late String s1Lumpsum, s2Lumpsum;
  late List yearList = [];
  String client_name = GetStorage().read("client_name");
  int selectedScenario = 1;
  int type_id = GetStorage().read("type_id");
  UserDataPojo userDataPojo = UserDataPojo();

  @override
  void initState() {
    // implement initState
    super.initState();
    targetAmount = widget.targetAmount;
    result = widget.result;
    s1AccReturn = result['scenario_1_accumulation_return'];
    s2AccReturn = result['scenario_2_accumulation_return'];
    s1DistributionReturn = result['scenario_1_distribution_return'] ?? 0;
    s2DistributionReturn = result['scenario_2_distribution_return'] ?? 0;
    futureValue = result['future_value_savings_amt'];
    currentInvestment = Utils.formatNumber(widget.currentInvestment);
    s1CorpusAmt = Utils.formatNumber(result['scenario1_corpus_amount']);
    s2CorpusAmt = Utils.formatNumber(result['scenario2_corpus_amount']);
    s1CorpusBal = Utils.formatNumber(result['scenario1_corpus_amount_balance']);
    s2CorpusBal = Utils.formatNumber(result['scenario2_corpus_amount_balance']);
    s1Sip = Utils.formatNumber(result['scenario1_sip_amount']);
    s2Sip = Utils.formatNumber(result['scenario2_sip_amount']);
    s1Lumpsum = Utils.formatNumber(result['scenario1_lumpsum_amount']);
    s2Lumpsum = Utils.formatNumber(result['scenario2_lumpsum_amount']);

    yearList = result['swp_cash_flow_list'];
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: rpAppBar(
          title: "Retirement Planner",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white,
          actions: [
            if ((type_id == UserType.ADMIN) &&
                (!keys.contains("adminAsInvestor")))
              GestureDetector(
                  onTap: () {
                    String url =
                        "${ApiConfig.apiUrl}/download/downloadRetirementPlan?key=${ApiConfig.apiKey}"
                        "&current_age=${widget.currentAge}"
                        "&retirement_age=${widget.retirementAge}"
                        "&annuity_ends_age=${widget.endAge}"
                        "&current_monthly_expense=${widget.monthlyExpense}"
                        "&balance_required=$targetAmount"
                        "&inflation_rate=${widget.inflation}"
                        "&scenario1_accumulation_return=${result['scenario_1_accumulation_return']}"
                        "&scenario1_distribution_return=${result['scenario_1_distribution_return']}"
                        "&scenario2_accumulation_return=${result['scenario_2_accumulation_return']}"
                        "&scenario2_distribution_return=${result['scenario_2_distribution_return']}"
                        "&current_savings_amount=${widget.currentInvestment}"
                        "&emergency_corpus_required=${widget.energyCorpus}"
                        "&client_name=$client_name";
                    print("downloadRetirementPlan $url");
                    SharedWidgets().shareBottomSheet(context, url);
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Icon(Icons.share))),
          ]),
      body: Container(
        color: Config.appTheme.mainBgColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Config.appTheme.themeColor,
                child: Container(
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Target Amount (Inflation Adjusted)",
                              style: AppFonts.f40013,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$rupee ${Utils.formatNumber(targetAmount)}",
                              style:
                                  AppFonts.f50014Black.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        DottedLine(),
                        SizedBox(
                          height: 4.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ColumnText(
                                title: "Current Age",
                                value: "${widget.currentAge} Years"),
                            ColumnText(
                              title: "Retirement Age",
                              value: "${widget.retirementAge} Years",
                              alignment: CrossAxisAlignment.center,
                            ),
                            ColumnText(
                              title: "Annuity Ends At",
                              value: "${widget.endAge} Years",
                              alignment: CrossAxisAlignment.end,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: devWidth,
                margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                padding: EdgeInsets.all(16.0), // Add padding
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white30, //Color(0xFFE1E1E1),
                    width: 2.0, // Set border width
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Current Investments",
                          style: AppFonts.f50014Black,
                        ),
                        Text(
                          "$rupee $currentInvestment",
                          style: AppFonts.f50014Black,
                        ),
                      ],
                    ),
                    DottedLine(verticalPadding: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Expected Future Value of Current Investments at Retirement (A)",
                            style: AppFonts.f50014Black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Assuming $s1AccReturn% Return",
                            style: AppFonts.f40013,
                          ),
                        ),
                        Text(
                          "$rupee ${Utils.formatNumber(futureValue)}",
                          style: AppFonts.f50014Black,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              corpusCard(),
              investmentCard(),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 4, 16),
                padding: EdgeInsets.all(16.0), // Add padding
                child: Column(
                  children: [
                    Text(
                      "SIP Calculator Top Up Amount Invested Summary",
                      style: AppFonts.f50014Grey,
                    ),
                    SizedBox(height: 10.0),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: getButton(1),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: getButton(2),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Distribution Return at ${selectedScenario == 1 ? s1DistributionReturn : s2DistributionReturn} %",
                          style: AppFonts.f40013,
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: yearList.length,
                      itemBuilder: (context, index) {
                        Map data = yearList[index];

                        return yearTile(data);
                      },
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

  Widget getButton(int scenario) {
    if (selectedScenario == scenario)
      return RpFilledButton(
        text: "Scenario $scenario",
        padding: EdgeInsets.zero,
      );
    else
      return PlainButton(
          text: "Scenario $scenario",
          padding: EdgeInsets.zero,
          onPressed: () {
            selectedScenario = scenario;
            print("selectedScenario $selectedScenario");
            setState(() {});
          });
  }

  Widget investmentCard() {
    return Container(
      width: devWidth,
      margin: EdgeInsets.fromLTRB(16, 0, 16, 6),
      padding: EdgeInsets.all(16.0), // Add padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Available Investment Options",
            style: AppFonts.f50014Black,
          ),
          SizedBox(height: 20.0),
          Text(
            "Monthly SIP Till Age ${widget.retirementAge}",
            style: AppFonts.f50014Black
                .copyWith(color: Config.appTheme.themeColor),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Scenario 1 at $s1AccReturn%",
                value: "$rupee $s1Sip",
                valueStyle: AppFonts.f70018Black,
              ),
              ColumnText(
                title: "Scenario 2 at $s2AccReturn%",
                value: "$rupee $s2Sip",
                valueStyle: AppFonts.f70018Black,
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
          DottedLine(verticalPadding: 4),
          Text(
            "Lumpsum Investment",
            style: AppFonts.f50014Black
                .copyWith(color: Config.appTheme.themeColor),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Scenario 1 at $s1AccReturn%",
                value: "$rupee $s1Lumpsum",
                valueStyle: AppFonts.f70018Black,
              ),
              ColumnText(
                title: "Scenario 2 at $s2AccReturn%",
                value: "$rupee $s2Lumpsum",
                valueStyle: AppFonts.f70018Black,
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget yearTile(Map data) {
    int year = data['period'];
    num eoy = data['scenario${selectedScenario}_year_end_balance'];
    num bal = data['scenario${selectedScenario}_emergency_corpus_balance'];
    num amount = data['scenario${selectedScenario}_swp_amount'] ?? 0;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16.0), // Add padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Year ${year + 1}",
                style: AppFonts.f50014Black
                    .copyWith(color: Config.appTheme.themeColor),
              ),
              RichText(
                text: TextSpan(
                  text: "$rupee ${Utils.formatNumber(amount, isAmount: false)}",
                  style: AppFonts.f50014Black,
                  children: <TextSpan>[
                    TextSpan(
                      text: '/ Month',
                      style: AppFonts.f40013,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Balance EOY",
                value: "$rupee ${Utils.formatNumber(eoy)}",
                valueStyle: AppFonts.f50014Black,
              ),
              ColumnText(
                title: "Balance Emergency Corpus",
                value: "$rupee ${Utils.formatNumber(bal)}",
                valueStyle: AppFonts.f50014Black,
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget corpusCard() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.all(16.0), // Add padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Retirement Corpus Required (B)",
            style: AppFonts.f50014Black,
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Scenario 1 at $s1DistributionReturn%",
                value: "$rupee $s1CorpusAmt",
                valueStyle: AppFonts.f50014Black,
              ),
              ColumnText(
                title: "Scenario 2 at $s2DistributionReturn%",
                value: "$rupee $s2CorpusAmt",
                valueStyle: AppFonts.f50014Black,
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
          DottedLine(verticalPadding: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Balance Retirement Corpus Required (C=B-A)",
                  style: AppFonts.f50014Black,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Scenario 1 at $s1DistributionReturn%",
                value: "$rupee $s1CorpusBal",
                valueStyle: AppFonts.f50014Black,
              ),
              ColumnText(
                title: "Scenario 2 at $s2DistributionReturn%",
                value: "$rupee $s2CorpusBal",
                valueStyle: AppFonts.f50014Black,
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
