import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/MutualFundScreen.dart';
import 'package:mymfbox2_0/Investor/masterPortfolio/FDHoldings.dart';
import 'package:mymfbox2_0/Investor/masterPortfolio/NPSHoldings.dart';
import 'package:mymfbox2_0/Investor/masterPortfolio/PMSHoldings.dart';
import 'package:mymfbox2_0/Investor/masterPortfolio/StructuredHoldings.dart';
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
import '../api/ReportApi.dart';
import '../pojo/OnlineTransactionRestrictionPojo.dart';
import '../rp_widgets/DayChange.dart';
import 'masterPortfolio/AlternateInvestmentFunds.dart';
import 'masterPortfolio/CommotityHoldings.dart';
import 'masterPortfolio/EquitySharesHoldings.dart';
import 'masterPortfolio/GeneralInsuranceHoldings.dart';
import 'masterPortfolio/HealthInsuranceHoldings.dart';
import 'masterPortfolio/LiabilitiesHoldings.dart';
import 'masterPortfolio/LifeInsuranceHoldings.dart';
import 'masterPortfolio/NonConvertibleDebenturesHoldings.dart';
import 'masterPortfolio/PhysicalBondsHoldings.dart';
import 'masterPortfolio/PostOfficeHoldings.dart';
import 'masterPortfolio/RealEstateHoldings.dart';
import 'masterPortfolio/RealEstatePMSHoldings.dart';
import 'masterPortfolio/TradedBondsHoldings.dart';

class InvestorMasterPortfolio extends StatefulWidget {
  const InvestorMasterPortfolio({super.key, required this.showAppBar,});
  final bool showAppBar;
  @override
  State<InvestorMasterPortfolio> createState() => _InvestorMasterPortfolioState();
}

class _InvestorMasterPortfolioState extends State<InvestorMasterPortfolio> {
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
    isLoading = true;
    await getAllOnlineRestrictions();
    await getMasterPortfolio();
    await getInvestorClientCode();
    isLoading = false;
    return 0;
  }

  List clientCodeList = [];
  Future getInvestorClientCode() async {
    if (clientCodeList.isNotEmpty) return 0;

    Map data = await ReportApi.getInvestorCode(
        user_id: user_id, client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    clientCodeList = data['client_code_list'];
    if ((keys.contains("adminAsInvestor")) ||
        (keys.contains("adminAsFamily")) != true)
      await getAllOnlineRestrictions();
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

    mutualFund = masterPostfolioPojo.mutualFund ?? MutualFund();
    fd = masterPostfolioPojo.fd ?? Fd();
    pms = masterPostfolioPojo.pms ?? Pms();
    structured = masterPostfolioPojo.structured ?? Structured();
    nps = masterPostfolioPojo.nps ?? Nps();
    equity = masterPostfolioPojo.equity ?? Equity();
    commodity = masterPostfolioPojo.commodity ?? Commodity();
    gold = masterPostfolioPojo.gold ?? Gold();
    aif = masterPostfolioPojo.aif ?? Aif();
    realestate = masterPostfolioPojo.realestate ?? Realestate();
    realestatePms = masterPostfolioPojo.realestatePms ?? RealestatePms();
    postOffice = masterPostfolioPojo.postOffice ?? PostOffice();
    bond = masterPostfolioPojo.bond ?? Bond();
    lifeInsurance = masterPostfolioPojo.lifeInsurance ?? LifeInsurance();
    generalInsurance = masterPostfolioPojo.generalInsurance ?? GeneralInsurance();
    healthInsurance = masterPostfolioPojo.healthInsurance ?? HealthInsurance();
    loan = masterPostfolioPojo.loan ?? Loan();
    ncd = masterPostfolioPojo.ncd ?? Ncd();
    trade = masterPostfolioPojo.trade ?? Trade();

    isFirst = false;
    isLoading = false;
    print("pms holdings ${pms.pmsList?.length}");
    return 0;
  }

  Iterable keys = GetStorage().getKeys();
  List investorList = [];
  late Map<String, dynamic> datas;
    OnlineTransactionRestrictionPojo userData = OnlineTransactionRestrictionPojo();
  Future getAllOnlineRestrictions() async {
    if (!isFirst) return 0;
    Map data = await InvestorApi.getOnlineRestrictionsByUserId(
      user_id: user_id,
      client_name: client_name,
    );

    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      return 0;
    }
    investorList = data['list'];
    datas = investorList[0];
    userData = OnlineTransactionRestrictionPojo.fromJson(datas);
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
              appBar: (widget.showAppBar)
                  ? invAppBar(title: "Master Portfolio",showCartIcon: clientCodeList !=null && clientCodeList.isNotEmpty,)
                  : null,
              body: SingleChildScrollView(
                child: Container(
                  color: Config.appTheme.mainBgColor,
                  child: Column(
                    children: [
                      investmentCard(),
                      (isLoading)
                          ? Utils.shimmerWidget(devHeight,
                              margin: EdgeInsets.all(16))
                          : InkWell(
                              onTap: () async {
                                Get.to(MutualFundScreen());
                              },
                              child: summaryCard(
                                  title: "Mutual Fund",
                                  value: mutualFund.mutualFundCurrentValue,
                                  cost: mutualFund.mutualFundInvestedValue,
                                  gainLoss:
                                      mutualFund.mutualFundUnrealised?.toInt() ?? 0,
                                  xirr: mutualFund.mutualFundCagr,
                                  percent: "%",
                                  rupee: rupee,
                                  /*dayChangeValue:
                                      mutualFund.mutualFundOneDayChangeValue,
                                  dayChangePerc: mutualFund
                                      .mutualFundOneDayChangePercentage,*/
                                  goTo: MutualFundScreen(),
                                  secondTitle: "Unrealised Gain",
                                  thirdTitle: "XIRR",
                                  firstTitle: "Cost")),
                      summaryCard(
                        title: "Fixed Deposit",
                        value: fd.fdTotalCurrentValue,
                        cost: fd.fdTotalCurrentCost,
                        gainLoss: fd.fdTotalUnrealisedProfitLoss?.toInt(),
                        xirr: fd.fdTotalReturn,
                        firstTitle: "Invested",
                        secondTitle: "Gain/Loss",
                        thirdTitle: "Returns",
                        rupee: rupee,
                        percent: "%",
                        goTo: FDHoldings(),
                      ),
                      summaryCard(
                        title: "PMS Holdings",
                        value: pms.pmsCurrentValue?.round(),
                        cost: pms.pmsCurrentCost?.round(),
                        gainLoss: pms.pmsUnrealised?.toInt(),
                        xirr: pms.pmsDividend,
                        firstTitle: "Invested",
                        secondTitle: "Unrealised Gain/Loss",
                        thirdTitle: "Dividend",
                        rupee: rupee,
                        percent: "",
                        goTo: PMSHoldings(),
                      ),
                      summaryCard(
                        title: "Structured Holdings",
                        value: structured.structuredCurrentCost,
                        cost: structured.structuredCurrentCost,
                        gainLoss: structured.structuredUnrealised?.toInt(),
                        xirr: structured.structuredReturn,
                        firstTitle: "Invested",
                        secondTitle: "Gain/Loss",
                        rupee: rupee,
                        thirdTitle: "Returns",
                        percent: "%",
                        goTo: StructuredHoldings(),
                      ),
                      summaryCard(
                        title: "NPS Holdings",
                        value: nps.npsCurrentValue,
                        cost: nps.npsCurrentCost,
                        gainLoss: nps.npsUnrealised?.toInt(),
                        xirr: nps.npsTotalReturn,
                        firstTitle: "Invested",
                        secondTitle: "Gain/Loss",
                        thirdTitle: "Returns",
                        rupee: rupee,
                        percent: "%",
                        goTo: NPSHoldings(),
                      ),
                      summaryCard(
                        title: "Equity Shares",
                        value: equity.equityTotalCurrentValue,
                        cost: equity.equityTotalCurrentCost,
                        gainLoss: equity.equityTotalUnrealisedProfitLoss?.toInt(),
                        xirr: equity.equityTotalReturn,
                        firstTitle: "Invested",
                        secondTitle: "Gain/Loss",
                        rupee: rupee,
                        thirdTitle: "Returns",
                        percent: "%",
                        goTo: EquitySharesHoldings(),
                      ),
                      summaryCard(
                        title: "Commodity",
                        value: commodity.commodityCurrentValue,
                        cost: commodity.commodityCurrentCost,
                        gainLoss: commodity.commodityUnrealised?.toInt(),
                        rupee: rupee,
                        firstTitle: "Invested",
                        secondTitle: "Gain/Loss",
                        thirdTitle: "Shares",
                        xirr: commodity.commodityShares,
                        goTo: CommotityHoldings(),
                      ),
                      summaryCard(
                        title: "Alternate Investment Funds",
                        value: aif.aifCurrValue,
                        cost: aif.aifCurrCost,
                        gainLoss: aif.aifUnrealised,
                        xirr: aif.aifXirr,
                        rupee: rupee,
                        firstTitle: "Invested",
                        secondTitle: "Gain/Loss",
                        thirdTitle: "Returns",
                        percent: "%",
                        goTo: AlternateInvestmentFunds(),
                      ),
                      summaryCard(
                        title: "Real Estate PMS",
                        value: realestatePms.realEstatePmsCurrentValue,
                        cost: realestatePms.realEstatePmsCurrentCost,
                        gainLoss: realestatePms.realEstatePmsUnrealised,
                        xirr: realestatePms.realEstatePmsUnrealised,
                        rupee: rupee,
                        firstTitle: "Invested",
                        secondTitle: "Gain/Loss",
                        thirdTitle: "Returns",
                        percent: "%",
                        goTo: RealEstatePMSHoldings(),
                      ),
                      summaryCard(
                        title: "Post Office",
                        value: postOffice.postalTotalCurrentValue,
                        cost: postOffice.postalTotalCurrentCost,
                        gainLoss: postOffice.postalTotalUnrealisedProfitLoss,
                        xirr: postOffice.postalTotalReturn,
                        rupee: rupee,
                        firstTitle: "Invested",
                        secondTitle: "Gain/Loss",
                        thirdTitle: "Returns",
                        percent: "%",
                        goTo: PostOfficeHoldings(),
                      ),
                      summaryCard(
                        title: "Physical Bonds",
                        value: bond.bondsTotalCurrentValue,
                        cost: bond.bondsTotalCurrentCost,
                        gainLoss: bond.bondsTotalUnrealisedProfitLoss,
                        firstTitle: "Invested",
                        secondTitle: "Gain/Loss",
                        thirdTitle: "Returns",
                        goTo: PhysicalBondsHoldings(),
                      ),
                      summaryCard(
                        title: "Real Estate",
                        value: realestate.propertyTotalCurrentValue,
                        cost: realestate.propertyTotalCurrentCost,
                        gainLoss: realestate.propertyTotalUnrealisedProfitLoss,
                        xirr: realestate.propertyTotalReturn,
                        rupee: rupee,
                        firstTitle: "Invested",
                        secondTitle: "Gain/Loss",
                        thirdTitle: "Returns",
                        goTo: RealEstateHoldings(),
                      ),
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
                      summaryCard(
                        title: "Liabilities",
                        value: loan.totalLoanAmount,
                        cost: loan.totalEmi,
                        gainLoss: loan.totalLoanBalance,
                        rupee: rupee,
                        firstTitle: "Total EMI",
                        secondTitle: "Loan Balance",
                        goTo: LiabilitiesHoldings(),
                      ),
                      summaryCard(
                        title: "Non Convertible Debentures\n(NCD)",
                        value: ncd.ncdTotalCurrentValue,
                        cost: ncd.ncdTotalCurrentCost,
                        gainLoss: ncd.ncdTotalUnrealisedProfitLoss,
                        xirr: ncd.ncdTotalReturn,
                        rupee: rupee,
                        firstTitle: "Invested",
                        secondTitle: "Gain/Loss",
                        thirdTitle: "Returns",
                        percent: "%",
                        goTo: NonConvertibleDebenturesHoldings(),
                      ),
                      summaryCard(
                        title: "Traded Bonds",
                        value: trade.tradebondsTotalCurrentValue,
                        cost: trade.tradebondsTotalInvestedAmount,
                        gainLoss: trade.tradebondsTotalUnrealisedGain,
                        xirr: trade.tradebondsXirrValue,
                        rupee: rupee,
                        firstTitle: "Invested",
                        secondTitle: "Gain/Loss",
                        thirdTitle: "Returns",
                        percent: "%",
                        goTo: TradedBondsHoldings(),
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
                          "Current Value",
                          style: TextStyle(
                              color: Config.appTheme.themeColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: devHeight * 0.02),
                    Text(
                      "$rupee ${Utils.formatNumber(total.round())}",
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
    //num? dayChangeValue,
    //num? dayChangePerc,
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

    return InkWell(
      onTap: () {
        Get.to(goTo);
      },
      child: Visibility(
        visible: (value != 0) && (value != null),
        child: Container(
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
                  Icon(Icons.arrow_forward, color: Config.appTheme.themeColor)
                ],
              ),
              SizedBox(height: 16),
              Text(
                "$rupee $valueStr",
                style:
                    AppFonts.f70024.copyWith(color: Config.appTheme.themeColor),
              ),
              /*if (userData.oneDayChange == 1 ||
                  (keys.contains("adminAsInvestor") ||
                      keys.contains("adminAsFamily") != false))
              DayChange(
                change_value: dayChangeValue,
                percentage: dayChangePerc ?? 0,
              ),*/
              //dayChange(value: dayChangeValue, percentage: dayChangePerc),
              SizedBox(height: 5),
              SizedBox(
                height: 20,
                child: ListView.builder(
                    itemCount: 100,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) =>
                        Text("-", style: TextStyle(color: Colors.grey[400]))),
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
                color: (percentage! > 0)
                    ? Config.appTheme.defaultProfit
                    : Config.appTheme.defaultLoss,
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  bool isOpen = false;
}
