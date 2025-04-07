import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/pojo/MasterPortfolioPojo.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:mymfbox2_0/rp_widgets/SipRoundIcon.dart';
import 'masterPortfolio/GeneralInsuranceHoldings.dart';
import 'masterPortfolio/HealthInsuranceHoldings.dart';
import 'masterPortfolio/LifeInsuranceHoldings.dart';

class InsuranceBoho extends StatefulWidget {
  const InsuranceBoho({
    super.key,
    required this.showAppBar,
  });
  final bool showAppBar;
  @override
  State<InsuranceBoho> createState() => _InsuranceBohoState();
}

class _InsuranceBohoState extends State<InsuranceBoho> {
  late double devHeight, devWidth;
  Map rowValue = {};

  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  bool isFirst = true;
  bool isLoading = true;
  num total = 0;
  MasterPostfolioPojo masterPostfolioPojo = MasterPostfolioPojo();

  MutualFund mutualFund = MutualFund();
  Fd fd = Fd();
  Pms pms = Pms();
  Structured structured = Structured();
  Nps nps = Nps();
  Equity equity = Equity();
  Commodity commodity = Commodity();
  Gold gold = Gold();
  Aif aif = Aif();
  RealestatePms realestatePms = RealestatePms();
  PostOffice postOffice = PostOffice();
  Bond bond = Bond();
  Realestate realestate = Realestate();
  LifeInsurance lifeInsurance = LifeInsurance();
  GeneralInsurance generalInsurance = GeneralInsurance();
  HealthInsurance healthInsurance = HealthInsurance();
  Loan loan = Loan();
  Ncd ncd = Ncd();
  Trade trade = Trade();

  Future getDatas() async {
    await getMasterPortfolio();
    return 0;
  }

  Future getMasterPortfolio() async {
    if (!isFirst) return 0;
    Map<String, dynamic> data = await InvestorApi.getMasterPortfolio(
        user_id: user_id, client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }

    masterPostfolioPojo = MasterPostfolioPojo.fromJson(data);
    total = masterPostfolioPojo.totalCurrentValue ?? 0;

    lifeInsurance = masterPostfolioPojo.lifeInsurance ?? LifeInsurance();
    generalInsurance =
        masterPostfolioPojo.generalInsurance ?? GeneralInsurance();
    healthInsurance = masterPostfolioPojo.healthInsurance ?? HealthInsurance();

    isFirst = false;
    isLoading = false;
    print("pms holdings ${pms.pmsList?.length}");
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return SideBar(
            child: Scaffold(
              backgroundColor: Config.appTheme.mainBgColor,
              appBar:
                  (widget.showAppBar) ? invAppBar(title: "Insurance") : null,
              body: SingleChildScrollView(
                child: Container(
                  color: Config.appTheme.mainBgColor,
                  child: Column(
                    children: [
                      // investmentCard(),
                      summaryCard(
                        title: "Life Insurance",
                        value: lifeInsurance.totalLifeRiskCover,
                        cost: lifeInsurance.totalLifePremiumPerYear,
                        gainLoss: lifeInsurance.totalLifePremiumPaid,
                        firstTitle: "Total Premium / Year",
                        secondTitle: "Total Premium paid",
                        goTo: LifeInsuranceHoldings(),
                      ),
                      summaryCard(
                        title: "Health Insurance",
                        value: healthInsurance.totalHealthRiskCover,
                        cost: healthInsurance.totalHealthPremiumPaid,
                        gainLoss: healthInsurance.totalHealthPremiumPerYear,
                        firstTitle: "Total Premium / Year	",
                        secondTitle: "Total Premium paid",
                        goTo: HealthInsuranceHoldings(),
                      ),
                      summaryCard(
                        title: "General Insurance",
                        value: generalInsurance.totalGeneralRiskCover,
                        cost: generalInsurance.totalGeneralPremiumPerYear,
                        gainLoss: generalInsurance.totalGeneralPremiumPaid,
                        firstTitle: "Premium Paid",
                        secondTitle: "Premium Per Year",
                        goTo: GeneralInsuranceHoldings(),
                      ),

                      SizedBox(height: 16)
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget investmentCard() {
    return Container(
      color: Config.appTheme.themeColor,
      width: devWidth,
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 10, 16, 16),
        decoration: BoxDecoration(
          color: Config.appTheme.overlay85,
          borderRadius: BorderRadius.circular(10),
        ),
        child: (isLoading)
            ? Utils.shimmerWidget(130, margin: EdgeInsets.zero)
            : Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "My Investments",
                          style: TextStyle(
                              color: Config.appTheme.themeColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: devHeight * 0.02),
                    Text(
                      "$rupee ${Utils.formatNumber(total)}",
                      style: TextStyle(
                          color: Config.appTheme.themeColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 32),
                    ),
                    Text(
                      "As on ${Utils.getFormattedDate()} ",
                      style: TextStyle(
                          color: AppColors.readableGrey,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget summaryCard({
    required String title,
    num? value,
    num? cost,
    num? xirr,
    num? gainLoss = 0.0,
    num? dayChangeValue,
    num? dayChangePerc,
    String firstTitle = "",
    String secondTitle = "",
    String thirdTitle = "",
    String percent = "",
    String rupee = "",
    required Widget goTo,
  }) {
    String valueStr;

    if (value == null)
      valueStr = "...";
    else
      valueStr = Utils.formatNumber(value);

    if (isLoading)
      return Utils.shimmerWidget(200,
          margin: EdgeInsets.fromLTRB(16, 16, 16, 0));

    return InkWell(
      onTap: () {
        Get.to(goTo);
      },
      child: Visibility(
        visible: (value != 0) && (value != null),
        child: Stack(
          children: [
            Container(
              width: devWidth,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SipRoundIcon(),
                      SizedBox(width: 10),
                      Text(title,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          )),
                      Spacer(),
                      Icon(Icons.arrow_forward,
                          color: Config.appTheme.themeColor)
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "$rupee $valueStr",
                    style: AppFonts.f70024
                        .copyWith(color: Config.appTheme.themeColor),
                  ),
                  dayChange(value: dayChangeValue, percentage: dayChangePerc),
                  SizedBox(height: 5),
                  SizedBox(
                    height: 20,
                    child: ListView.builder(
                        itemCount: 100,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Text("-",
                            style: TextStyle(color: Colors.grey[400]))),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      columnText(
                          "$firstTitle", "$rupee ${Utils.formatNumber(cost)}"),
                      columnText("$secondTitle",
                          "${rupee} ${Utils.formatNumber(gainLoss)}",
                          alignment: CrossAxisAlignment.center),
                      columnText(
                        "$thirdTitle",
                        "${xirr ?? ""} ${percent}",
                        alignment: CrossAxisAlignment.end,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget columnText(String title, String value,
      {CrossAxisAlignment? alignment}) {
    return Column(
      crossAxisAlignment: alignment ?? CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.f40013,
        ),
        Text(value, style: AppFonts.f50014Grey.copyWith(color: Colors.black))
      ],
    );
  }

  Widget dayChange({num? value, num? percentage}) {
    return Visibility(
      visible: percentage != null,
      child: Row(
        children: [
          Text(
            "1 Day Change ",
            style: TextStyle(
                color: AppColors.readableGrey,
                fontWeight: FontWeight.w500,
                fontSize: 12),
          ),
          Text(
            "$rupee ${Utils.formatNumber(value)}",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          Text(
            " ($percentage%)",
            style: TextStyle(
                color: Color(0xff3CB66D),
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  bool isOpen = false;
}
