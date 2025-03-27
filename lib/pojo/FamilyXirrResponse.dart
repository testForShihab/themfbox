import 'dart:core';

class FamilyXirrResponse {
  num? status;
  String? statusMsg;
  String? msg;
  String? familyHead;
  num? noOfFamilyMembers;
  num? totalInvCost;
  num? totalCurrVal;
  num? invCostAsOn;
  num? currValAsOn;
  num? totalGainLoss;
  num? totalAbsRet;
  num? totalXirr;
  num? totalPurchase;
  num? totalRedemption;
  num? totalDivPay;
  List<FamilyList>? list;

  FamilyXirrResponse(
      {this.status,
      this.statusMsg,
      this.msg,
      this.familyHead,
      this.noOfFamilyMembers,
      this.totalInvCost,
      this.totalCurrVal,
      this.invCostAsOn,
      this.currValAsOn,
      this.totalGainLoss,
      this.totalAbsRet,
      this.totalXirr,
      this.totalPurchase,
      this.totalRedemption,
      this.totalDivPay,
      this.list});

  FamilyXirrResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    familyHead = json['family_head'];
    noOfFamilyMembers = json['no_of_family_members'];
    totalInvCost = json['total_inv_cost'];
    totalCurrVal = json['total_curr_val'];
    invCostAsOn = json['inv_cost_as_on'];
    currValAsOn = json['curr_val_as_on'];
    totalGainLoss = json['total_gain_loss'];
    totalAbsRet = json['total_abs_ret'];
    totalXirr = json['total_xirr'];
    totalPurchase = json['total_purchase'];
    totalRedemption = json['total_redemption'];
    totalDivPay = json['total_div_pay'];
    if (json['list'] != null) {
      list = <FamilyList>[];
      json['list'].forEach((v) {
        list!.add(new FamilyList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_msg'] = this.statusMsg;
    data['msg'] = this.msg;
    data['family_head'] = this.familyHead;
    data['no_of_family_members'] = this.noOfFamilyMembers;
    data['total_inv_cost'] = this.totalInvCost;
    data['total_curr_val'] = this.totalCurrVal;
    data['inv_cost_as_on'] = this.invCostAsOn;
    data['curr_val_as_on'] = this.currValAsOn;
    data['total_gain_loss'] = this.totalGainLoss;
    data['total_abs_ret'] = this.totalAbsRet;
    data['total_xirr'] = this.totalXirr;
    data['total_purchase'] = this.totalPurchase;
    data['total_redemption'] = this.totalRedemption;
    data['total_div_pay'] = this.totalDivPay;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FamilyList {
  num? id;
  num? typeId;
  String? investorName;
  String? familyStatus;
  String? investorPan;
  String? icsdGrandTotal;
  String? ccsdGrandTotal;
  String? ccedGrandTotal;
  String? icedGrandTotal;
  String? purchaseGrandTotal;
  String? redemGrandTotal;
  String? divPayGrandTotal;
  String? divReinvGrandTotal;
  String? gainLossGrandTotal;
  num? absRtnGrandTotal;
  num? xirrRtnGrandTotal;
  num? familyXirr;
  List<InvestorSchemeWisePortfolioResponses>?
      investorSchemeWisePortfolioResponses;

  FamilyList(
      {this.id,
      this.typeId,
      this.investorName,
        this.familyStatus,
      this.investorPan,
      this.icsdGrandTotal,
      this.ccsdGrandTotal,
      this.ccedGrandTotal,
      this.icedGrandTotal,
      this.purchaseGrandTotal,
      this.redemGrandTotal,
      this.divPayGrandTotal,
      this.divReinvGrandTotal,
      this.gainLossGrandTotal,
      this.absRtnGrandTotal,
      this.xirrRtnGrandTotal,
      this.familyXirr,
      this.investorSchemeWisePortfolioResponses});

  FamilyList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeId = json['type_id'];
    investorName = json['investorName'];
    familyStatus = json['family_status'];
    investorPan = json['investorPan'];
    icsdGrandTotal = json['icsdGrandTotal'];
    ccsdGrandTotal = json['ccsdGrandTotal'];
    ccedGrandTotal = json['ccedGrandTotal'];
    icedGrandTotal = json['icedGrandTotal'];
    purchaseGrandTotal = json['purchaseGrandTotal'];
    redemGrandTotal = json['redemGrandTotal'];
    divPayGrandTotal = json['divPayGrandTotal'];
    divReinvGrandTotal = json['divReinvGrandTotal'];
    gainLossGrandTotal = json['gainLossGrandTotal'];
    absRtnGrandTotal = json['absRtnGrandTotal'];
    xirrRtnGrandTotal = json['xirrRtnGrandTotal'];
    familyXirr = json['family_xirr'];
    if (json['investorSchemeWisePortfolioResponses'] != null) {
      investorSchemeWisePortfolioResponses =
          <InvestorSchemeWisePortfolioResponses>[]
              as List<InvestorSchemeWisePortfolioResponses>?;
      json['investorSchemeWisePortfolioResponses'].forEach((v) {
        investorSchemeWisePortfolioResponses!
            .add(new InvestorSchemeWisePortfolioResponses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type_id'] = this.typeId;
    data['investorName'] = this.investorName;
    data['family_status'] = this.familyStatus;
    data['investorPan'] = this.investorPan;
    data['icsdGrandTotal'] = this.icsdGrandTotal;
    data['ccsdGrandTotal'] = this.ccsdGrandTotal;
    data['ccedGrandTotal'] = this.ccedGrandTotal;
    data['icedGrandTotal'] = this.icedGrandTotal;
    data['purchaseGrandTotal'] = this.purchaseGrandTotal;
    data['redemGrandTotal'] = this.redemGrandTotal;
    data['divPayGrandTotal'] = this.divPayGrandTotal;
    data['divReinvGrandTotal'] = this.divReinvGrandTotal;
    data['gainLossGrandTotal'] = this.gainLossGrandTotal;
    data['absRtnGrandTotal'] = this.absRtnGrandTotal;
    data['xirrRtnGrandTotal'] = this.xirrRtnGrandTotal;
    data['family_xirr'] = this.familyXirr;
    if (this.investorSchemeWisePortfolioResponses != null) {
      data['investorSchemeWisePortfolioResponses'] = this
          .investorSchemeWisePortfolioResponses!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class InvestorSchemeWisePortfolioResponses {
  String? scheme;
  String? schemeAmfiShortName;
  String? schemeClass;
  String? schemeCode;
  num? schemeRegistrar;
  num? schemeAmfiCommon;
  String? amcCode;
  num? amcName;
  String? foliono;
  String? amcLogo;
  num? schemeWeight;
  num? schemeRating;
  num? schemeScore;
  num? schemeReview;
  num? schemeBenchmarkName;
  num? schemeBenchmarkCode;
  num? schemeRiskProfile;
  num? notes;
  num? brokerCode;
  String? investmentStartDate;
  num? investmentReStartDate;
  num? lastInvestmentDate;
  num? lastTransactionDate;
  num? investmentStartNav;
  num? investmentStartValue;
  num? totalInflow;
  num? totalOutflow;
  num? partialInflow;
  num? partialOutflow;
  num? totalInvestedAmount;
  num? totalOriginalInvestedAmount;
  num? totalSwitchInAmount;
  num? totalSwitchOutAmount;
  num? totalRedemptionAmount;
  num? totalUnits;
  num? currentCostOfInvestment;
  num? purchaseNav;
  num? dividendReinvestment;
  num? dividendPaid;
  num? latestNav;
  String? latestNavDate;
  num? totalCurrentValue;
  num? unrealisedProfitLoss;
  num? realisedProfitLoss;
  num? realisedGainLoss;
  num? cagr;
  num? totalCagr;
  num? absoluteReturn;
  num? totalAbsoluteReturn;
  num? averageDays;
  bool? isSipScheme;
  bool? isActiveSipScheme;
  bool? isDividendScheme;
  bool? isDividendDeclared;
  bool? isDividendPayout;
  bool? isDividendReinvest;
  bool? isNegativeTransaction;
  bool? isDeamtAccount;
  num? goalName;
  String? schemeCompany;
  String? schemeAdvisorkhojCategory;
  num? isinNo;
  num? schemeAmfiCode;
  num? taxCategory;
  num? sipAmount;
  num? totalSipAmount;
  num? totalSipAmountStr;
  num? sipFrequency;
  num? totalDividendPaid;
  num? totalDividendReinvest;
  num? totalDividendPaidCurrentFy;
  num? totalDividendReinvestCurrentFy;
  bool? isStpInScheme;
  bool? isStpOutScheme;
  bool? isActiveStpScheme;
  num? stpAmount;
  bool? isSwpScheme;
  bool? isActiveSwpScheme;
  num? swpAmount;
  num? userId;
  num? investorName;
  num? investorPan;
  num? investorBranch;
  num? investorRmName;
  num? investorSubbrokerName;
  bool? isManualEntry;
  num? accHolderName;
  num? bankName;
  num? bankBranchName;
  String? invCostStartDate;
  String? invCostEndDate;
  String? currValueStartDate;
  String? currValueEndDate;
  num? sipRowMergedCount;
  num? totalCurrentCostStartDate;
  num? totalCurrentValueStartDate;
  num? totalCurrentCostEndDate;
  num? totalCurrentValueEndDate;
  num? totalPurcahse;
  num? totalRedemption;
  num? totalDivInvest;
  num? totalDivPaid;
  num? totalGainLoss;
  num? totalAbsReturn;
  dynamic schemeDatesArray;
  List? schemeAmountArray;
  num? sensex;
  num? shortTermUnits;
  num? shortTermAmount;
  num? longTermUnits;
  num? longTermAmount;
  num? notionalUnits;
  num? notionalAmount;
  num? prevLatestNav;
  num? dayChangeValue;
  num? dayChangePercentage;
  num? loadFreeUnits;
  num? joint1Name;
  num? joint1Pan;
  num? joint2Name;
  num? joint2Pan;
  num? taxStatus;
  num? holdingNature;
  num? nominee1Name;
  num? nominee1Relation;
  num? nominee1Percentage;
  num? nominee2Name;
  num? nominee2Relation;
  num? nominee2Percentage;
  num? nominee3Name;
  num? nominee3Relation;
  num? nominee3Percentage;
  num? allocation;
  num? xirrList;
  num? folioList;
  num? currentNav;
  num? currentNavDate;
  num? schemePan;
  num? arnNumber;
  num? schemeBenchmarkFlag;
  num? benchmarkName;
  num? benchmarkCode;
  num? benchmarkCurrentCostOfInvestment;
  num? benchmarkTotalCurrentValue;
  num? benchmarkAbsoluteReturn;
  num? benchmarkCagr;
  String? totalOriginalInvestedAmountStr;
  String? totalSwitchInAmountStr;
  String? totalSwitchOutAmountStr;
  String? totalRedemptionAmountStr;
  String? currentCostOfInvestmentStr;
  String? totalCurrentValueStr;
  String? unrealisedProfitLossStr;
  String? realisedProfitLossStr;
  String? realisedGainLossStr;
  String? totalDividendReinvestStr;
  String? totalDividendPaidStr;
  String? totalUnitsStr;
  String? purchaseNavStr;
  String? latestNavStr;
  String? investmentStartDateStr;
  String? investmentReStartDateStr;
  String? latestNavDateStr;
  String? currentNavStr;
  String? longTermUnitsStr;
  String? longTermAmountStr;
  num? totalInflowStr;
  num? totalOutflowStr;
  num? invCostStartDateStr;
  num? invCostEndDateStr;
  num? currValueStartDateStr;
  num? currValueEndDateStr;
  num? benchmarkTotalCurrentValueStr;
  num? schemeBankDetails;
  num? tagName;
  num? investorSchemeWiseTransactionResponses;
  num? familyInvestorSchemeWiseTransactionResponses;
  num? transactionList;
  num? schemeXirrList;
  num? invTransactionList;
  num? nseIinNumber;
  num? bseClientCode;
  num? mfuCanNumber;
  num? monthlyAmt;

  InvestorSchemeWisePortfolioResponses(
      {this.scheme,
      this.schemeAmfiShortName,
      this.schemeClass,
      this.schemeCode,
      this.schemeRegistrar,
      this.schemeAmfiCommon,
      this.amcCode,
      this.amcName,
      this.foliono,
      this.amcLogo,
      this.schemeWeight,
      this.schemeRating,
      this.schemeScore,
      this.schemeReview,
      this.schemeBenchmarkName,
      this.schemeBenchmarkCode,
      this.schemeRiskProfile,
      this.notes,
      this.brokerCode,
      this.investmentStartDate,
      this.investmentReStartDate,
      this.lastInvestmentDate,
      this.lastTransactionDate,
      this.investmentStartNav,
      this.investmentStartValue,
      this.totalInflow,
      this.totalOutflow,
      this.partialInflow,
      this.partialOutflow,
      this.totalInvestedAmount,
      this.totalOriginalInvestedAmount,
      this.totalSwitchInAmount,
      this.totalSwitchOutAmount,
      this.totalRedemptionAmount,
      this.totalUnits,
      this.currentCostOfInvestment,
      this.purchaseNav,
      this.dividendReinvestment,
      this.dividendPaid,
      this.latestNav,
      this.latestNavDate,
      this.totalCurrentValue,
      this.unrealisedProfitLoss,
      this.realisedProfitLoss,
      this.realisedGainLoss,
      this.cagr,
      this.totalCagr,
      this.absoluteReturn,
      this.totalAbsoluteReturn,
      this.averageDays,
      this.isSipScheme,
      this.isActiveSipScheme,
      this.isDividendScheme,
      this.isDividendDeclared,
      this.isDividendPayout,
      this.isDividendReinvest,
      this.isNegativeTransaction,
      this.isDeamtAccount,
      this.goalName,
      this.schemeCompany,
      this.schemeAdvisorkhojCategory,
      this.isinNo,
      this.schemeAmfiCode,
      this.taxCategory,
      this.sipAmount,
      this.totalSipAmount,
      this.totalSipAmountStr,
      this.sipFrequency,
      this.totalDividendPaid,
      this.totalDividendReinvest,
      this.totalDividendPaidCurrentFy,
      this.totalDividendReinvestCurrentFy,
      this.isStpInScheme,
      this.isStpOutScheme,
      this.isActiveStpScheme,
      this.stpAmount,
      this.isSwpScheme,
      this.isActiveSwpScheme,
      this.swpAmount,
      this.userId,
      this.investorName,
      this.investorPan,
      this.investorBranch,
      this.investorRmName,
      this.investorSubbrokerName,
      this.isManualEntry,
      this.accHolderName,
      this.bankName,
      this.bankBranchName,
      this.invCostStartDate,
      this.invCostEndDate,
      this.currValueStartDate,
      this.currValueEndDate,
      this.sipRowMergedCount,
      this.totalCurrentCostStartDate,
      this.totalCurrentValueStartDate,
      this.totalCurrentCostEndDate,
      this.totalCurrentValueEndDate,
      this.totalPurcahse,
      this.totalRedemption,
      this.totalDivInvest,
      this.totalDivPaid,
      this.totalGainLoss,
      this.totalAbsReturn,
      this.schemeDatesArray,
      this.schemeAmountArray,
      this.sensex,
      this.shortTermUnits,
      this.shortTermAmount,
      this.longTermUnits,
      this.longTermAmount,
      this.notionalUnits,
      this.notionalAmount,
      this.prevLatestNav,
      this.dayChangeValue,
      this.dayChangePercentage,
      this.loadFreeUnits,
      this.joint1Name,
      this.joint1Pan,
      this.joint2Name,
      this.joint2Pan,
      this.taxStatus,
      this.holdingNature,
      this.nominee1Name,
      this.nominee1Relation,
      this.nominee1Percentage,
      this.nominee2Name,
      this.nominee2Relation,
      this.nominee2Percentage,
      this.nominee3Name,
      this.nominee3Relation,
      this.nominee3Percentage,
      this.allocation,
      this.xirrList,
      this.folioList,
      this.currentNav,
      this.currentNavDate,
      this.schemePan,
      this.arnNumber,
      this.schemeBenchmarkFlag,
      this.benchmarkName,
      this.benchmarkCode,
      this.benchmarkCurrentCostOfInvestment,
      this.benchmarkTotalCurrentValue,
      this.benchmarkAbsoluteReturn,
      this.benchmarkCagr,
      this.totalOriginalInvestedAmountStr,
      this.totalSwitchInAmountStr,
      this.totalSwitchOutAmountStr,
      this.totalRedemptionAmountStr,
      this.currentCostOfInvestmentStr,
      this.totalCurrentValueStr,
      this.unrealisedProfitLossStr,
      this.realisedProfitLossStr,
      this.realisedGainLossStr,
      this.totalDividendReinvestStr,
      this.totalDividendPaidStr,
      this.totalUnitsStr,
      this.purchaseNavStr,
      this.latestNavStr,
      this.investmentStartDateStr,
      this.investmentReStartDateStr,
      this.latestNavDateStr,
      this.currentNavStr,
      this.longTermUnitsStr,
      this.longTermAmountStr,
      this.totalInflowStr,
      this.totalOutflowStr,
      this.invCostStartDateStr,
      this.invCostEndDateStr,
      this.currValueStartDateStr,
      this.currValueEndDateStr,
      this.benchmarkTotalCurrentValueStr,
      this.schemeBankDetails,
      this.tagName,
      this.investorSchemeWiseTransactionResponses,
      this.familyInvestorSchemeWiseTransactionResponses,
      this.transactionList,
      this.schemeXirrList,
      this.invTransactionList,
      this.nseIinNumber,
      this.bseClientCode,
      this.mfuCanNumber,
      this.monthlyAmt});

  InvestorSchemeWisePortfolioResponses.fromJson(Map<String, dynamic> json) {
    scheme = json['scheme'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeClass = json['scheme_class'];
    schemeCode = json['scheme_code'];
    schemeRegistrar = json['scheme_registrar'];
    schemeAmfiCommon = json['scheme_amfi_common'];
    amcCode = json['amc_code'];
    amcName = json['amc_name'];
    foliono = json['foliono'];
    amcLogo = json['amc_logo'];
    schemeWeight = json['scheme_weight'];
    schemeRating = json['scheme_rating'];
    schemeScore = json['scheme_score'];
    schemeReview = json['scheme_review'];
    schemeBenchmarkName = json['scheme_benchmark_name'];
    schemeBenchmarkCode = json['scheme_benchmark_code'];
    schemeRiskProfile = json['scheme_risk_profile'];
    notes = json['notes'];
    brokerCode = json['broker_code'];
    investmentStartDate = json['investmentStartDate'];
    investmentReStartDate = json['investmentReStartDate'];
    lastInvestmentDate = json['lastInvestmentDate'];
    lastTransactionDate = json['lastTransactionDate'];
    investmentStartNav = json['investmentStartNav'];
    investmentStartValue = json['investmentStartValue'];
    totalInflow = json['totalInflow'];
    totalOutflow = json['totalOutflow'];
    partialInflow = json['partialInflow'];
    partialOutflow = json['partialOutflow'];
    totalInvestedAmount = json['totalInvestedAmount'];
    totalOriginalInvestedAmount = json['totalOriginalInvestedAmount'];
    totalSwitchInAmount = json['totalSwitchInAmount'];
    totalSwitchOutAmount = json['totalSwitchOutAmount'];
    totalRedemptionAmount = json['totalRedemptionAmount'];
    totalUnits = json['totalUnits'];
    currentCostOfInvestment = json['currentCostOfInvestment'];
    purchaseNav = json['purchaseNav'];
    dividendReinvestment = json['dividendReinvestment'];
    dividendPaid = json['dividendPaid'];
    latestNav = json['latestNav'];
    latestNavDate = json['latestNavDate'];
    totalCurrentValue = json['totalCurrentValue'];
    unrealisedProfitLoss = json['unrealisedProfitLoss'];
    realisedProfitLoss = json['realisedProfitLoss'];
    realisedGainLoss = json['realisedGainLoss'];
    cagr = json['cagr'];
    totalCagr = json['total_cagr'];
    absoluteReturn = json['absolute_return'];
    totalAbsoluteReturn = json['total_absolute_return'];
    averageDays = json['average_days'];
    isSipScheme = json['isSipScheme'];
    isActiveSipScheme = json['isActiveSipScheme'];
    isDividendScheme = json['isDividendScheme'];
    isDividendDeclared = json['isDividendDeclared'];
    isDividendPayout = json['isDividendPayout'];
    isDividendReinvest = json['isDividendReinvest'];
    isNegativeTransaction = json['isNegativeTransaction'];
    isDeamtAccount = json['isDeamtAccount'];
    goalName = json['goal_name'];
    schemeCompany = json['scheme_company'];
    schemeAdvisorkhojCategory = json['scheme_advisorkhoj_category'];
    isinNo = json['isin_no'];
    schemeAmfiCode = json['scheme_amfi_code'];
    taxCategory = json['tax_category'];
    sipAmount = json['sip_amount'];
    totalSipAmount = json['total_sip_amount'];
    totalSipAmountStr = json['total_sip_amount_str'];
    sipFrequency = json['sip_frequency'];
    totalDividendPaid = json['total_dividend_paid'];
    totalDividendReinvest = json['total_dividend_reinvest'];
    totalDividendPaidCurrentFy = json['total_dividend_paid_current_fy'];
    totalDividendReinvestCurrentFy = json['total_dividend_reinvest_current_fy'];
    isStpInScheme = json['isStpInScheme'];
    isStpOutScheme = json['isStpOutScheme'];
    isActiveStpScheme = json['isActiveStpScheme'];
    stpAmount = json['stp_amount'];
    isSwpScheme = json['isSwpScheme'];
    isActiveSwpScheme = json['isActiveSwpScheme'];
    swpAmount = json['swp_amount'];
    userId = json['user_id'];
    investorName = json['investorName'];
    investorPan = json['investorPan'];
    investorBranch = json['investor_branch'];
    investorRmName = json['investor_rm_name'];
    investorSubbrokerName = json['investor_subbroker_name'];
    isManualEntry = json['isManualEntry'];
    accHolderName = json['acc_holder_name'];
    bankName = json['bank_name'];
    bankBranchName = json['bank_branch_name'];
    invCostStartDate = json['invCostStartDate'];
    invCostEndDate = json['invCostEndDate'];
    currValueStartDate = json['currValueStartDate'];
    currValueEndDate = json['currValueEndDate'];
    sipRowMergedCount = json['sip_row_merged_count'];
    totalCurrentCostStartDate = json['total_current_cost_start_date'];
    totalCurrentValueStartDate = json['total_current_value_start_date'];
    totalCurrentCostEndDate = json['total_current_cost_end_date'];
    totalCurrentValueEndDate = json['total_current_value_end_date'];
    totalPurcahse = json['total_purcahse'];
    totalRedemption = json['total_redemption'];
    totalDivInvest = json['total_div_invest'];
    totalDivPaid = json['total_div_paid'];
    totalGainLoss = json['total_gain_loss'];
    totalAbsReturn = json['total_abs_return'];
    schemeDatesArray = json['scheme_dates_array'];
    schemeAmountArray = json['scheme_amount_array'];
    sensex = json['sensex'];
    shortTermUnits = json['short_term_units'];
    shortTermAmount = json['short_term_amount'];
    longTermUnits = json['long_term_units'];
    longTermAmount = json['long_term_amount'];
    notionalUnits = json['notional_units'];
    notionalAmount = json['notional_amount'];
    prevLatestNav = json['prev_latestNav'];
    dayChangeValue = json['day_change_value'];
    dayChangePercentage = json['day_change_percentage'];
    loadFreeUnits = json['loadFreeUnits'];
    joint1Name = json['joint1_name'];
    joint1Pan = json['joint1_pan'];
    joint2Name = json['joint2_name'];
    joint2Pan = json['joint2_pan'];
    taxStatus = json['tax_status'];
    holdingNature = json['holding_nature'];
    nominee1Name = json['nominee1_name'];
    nominee1Relation = json['nominee1_relation'];
    nominee1Percentage = json['nominee1_percentage'];
    nominee2Name = json['nominee2_name'];
    nominee2Relation = json['nominee2_relation'];
    nominee2Percentage = json['nominee2_percentage'];
    nominee3Name = json['nominee3_name'];
    nominee3Relation = json['nominee3_relation'];
    nominee3Percentage = json['nominee3_percentage'];
    allocation = json['allocation'];
    xirrList = json['xirr_list'];
    folioList = json['folio_list'];
    currentNav = json['currentNav'];
    currentNavDate = json['currentNavDate'];
    schemePan = json['scheme_pan'];
    arnNumber = json['arn_number'];
    schemeBenchmarkFlag = json['scheme_benchmark_flag'];
    benchmarkName = json['benchmark_name'];
    benchmarkCode = json['benchmark_code'];
    benchmarkCurrentCostOfInvestment =
        json['benchmark_currentCostOfInvestment'];
    benchmarkTotalCurrentValue = json['benchmark_totalCurrentValue'];
    benchmarkAbsoluteReturn = json['benchmark_absolute_return'];
    benchmarkCagr = json['benchmark_cagr'];
    totalOriginalInvestedAmountStr = json['totalOriginalInvestedAmount_str'];
    totalSwitchInAmountStr = json['totalSwitchInAmount_str'];
    totalSwitchOutAmountStr = json['totalSwitchOutAmount_str'];
    totalRedemptionAmountStr = json['totalRedemptionAmount_str'];
    currentCostOfInvestmentStr = json['currentCostOfInvestment_str'];
    totalCurrentValueStr = json['totalCurrentValue_str'];
    unrealisedProfitLossStr = json['unrealisedProfitLoss_str'];
    realisedProfitLossStr = json['realisedProfitLoss_str'];
    realisedGainLossStr = json['realisedGainLoss_str'];
    totalDividendReinvestStr = json['total_dividend_reinvest_str'];
    totalDividendPaidStr = json['total_dividend_paid_str'];
    totalUnitsStr = json['totalUnits_str'];
    purchaseNavStr = json['purchaseNav_str'];
    latestNavStr = json['latestNav_str'];
    investmentStartDateStr = json['investmentStartDate_str'];
    investmentReStartDateStr = json['investmentReStartDate_str'];
    latestNavDateStr = json['latestNavDate_str'];
    currentNavStr = json['currentNav_str'];
    longTermUnitsStr = json['long_term_units_str'];
    longTermAmountStr = json['long_term_amount_str'];
    totalInflowStr = json['totalInflow_str'];
    totalOutflowStr = json['totalOutflow_str'];
    invCostStartDateStr = json['invCostStartDate_str'];
    invCostEndDateStr = json['invCostEndDate_str'];
    currValueStartDateStr = json['currValueStartDate_str'];
    currValueEndDateStr = json['currValueEndDate_str'];
    benchmarkTotalCurrentValueStr = json['benchmark_totalCurrentValue_str'];
    schemeBankDetails = json['scheme_bank_details'];
    tagName = json['tag_name'];
    investorSchemeWiseTransactionResponses =
        json['investorSchemeWiseTransactionResponses'];
    familyInvestorSchemeWiseTransactionResponses =
        json['familyInvestorSchemeWiseTransactionResponses'];
    transactionList = json['transaction_list'];
    schemeXirrList = json['scheme_xirr_list'];
    invTransactionList = json['inv_transaction_list'];
    nseIinNumber = json['nse_iin_number'];
    bseClientCode = json['bse_client_code'];
    mfuCanNumber = json['mfu_can_number'];
    monthlyAmt = json['monthly_amt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheme'] = this.scheme;
    data['scheme_amfi_short_name'] = this.schemeAmfiShortName;
    data['scheme_class'] = this.schemeClass;
    data['scheme_code'] = this.schemeCode;
    data['scheme_registrar'] = this.schemeRegistrar;
    data['scheme_amfi_common'] = this.schemeAmfiCommon;
    data['amc_code'] = this.amcCode;
    data['amc_name'] = this.amcName;
    data['foliono'] = this.foliono;
    data['amc_logo'] = this.amcLogo;
    data['scheme_weight'] = this.schemeWeight;
    data['scheme_rating'] = this.schemeRating;
    data['scheme_score'] = this.schemeScore;
    data['scheme_review'] = this.schemeReview;
    data['scheme_benchmark_name'] = this.schemeBenchmarkName;
    data['scheme_benchmark_code'] = this.schemeBenchmarkCode;
    data['scheme_risk_profile'] = this.schemeRiskProfile;
    data['notes'] = this.notes;
    data['broker_code'] = this.brokerCode;
    data['investmentStartDate'] = this.investmentStartDate;
    data['investmentReStartDate'] = this.investmentReStartDate;
    data['lastInvestmentDate'] = this.lastInvestmentDate;
    data['lastTransactionDate'] = this.lastTransactionDate;
    data['investmentStartNav'] = this.investmentStartNav;
    data['investmentStartValue'] = this.investmentStartValue;
    data['totalInflow'] = this.totalInflow;
    data['totalOutflow'] = this.totalOutflow;
    data['partialInflow'] = this.partialInflow;
    data['partialOutflow'] = this.partialOutflow;
    data['totalInvestedAmount'] = this.totalInvestedAmount;
    data['totalOriginalInvestedAmount'] = this.totalOriginalInvestedAmount;
    data['totalSwitchInAmount'] = this.totalSwitchInAmount;
    data['totalSwitchOutAmount'] = this.totalSwitchOutAmount;
    data['totalRedemptionAmount'] = this.totalRedemptionAmount;
    data['totalUnits'] = this.totalUnits;
    data['currentCostOfInvestment'] = this.currentCostOfInvestment;
    data['purchaseNav'] = this.purchaseNav;
    data['dividendReinvestment'] = this.dividendReinvestment;
    data['dividendPaid'] = this.dividendPaid;
    data['latestNav'] = this.latestNav;
    data['latestNavDate'] = this.latestNavDate;
    data['totalCurrentValue'] = this.totalCurrentValue;
    data['unrealisedProfitLoss'] = this.unrealisedProfitLoss;
    data['realisedProfitLoss'] = this.realisedProfitLoss;
    data['realisedGainLoss'] = this.realisedGainLoss;
    data['cagr'] = this.cagr;
    data['total_cagr'] = this.totalCagr;
    data['absolute_return'] = this.absoluteReturn;
    data['total_absolute_return'] = this.totalAbsoluteReturn;
    data['average_days'] = this.averageDays;
    data['isSipScheme'] = this.isSipScheme;
    data['isActiveSipScheme'] = this.isActiveSipScheme;
    data['isDividendScheme'] = this.isDividendScheme;
    data['isDividendDeclared'] = this.isDividendDeclared;
    data['isDividendPayout'] = this.isDividendPayout;
    data['isDividendReinvest'] = this.isDividendReinvest;
    data['isNegativeTransaction'] = this.isNegativeTransaction;
    data['isDeamtAccount'] = this.isDeamtAccount;
    data['goal_name'] = this.goalName;
    data['scheme_company'] = this.schemeCompany;
    data['scheme_advisorkhoj_category'] = this.schemeAdvisorkhojCategory;
    data['isin_no'] = this.isinNo;
    data['scheme_amfi_code'] = this.schemeAmfiCode;
    data['tax_category'] = this.taxCategory;
    data['sip_amount'] = this.sipAmount;
    data['total_sip_amount'] = this.totalSipAmount;
    data['total_sip_amount_str'] = this.totalSipAmountStr;
    data['sip_frequency'] = this.sipFrequency;
    data['total_dividend_paid'] = this.totalDividendPaid;
    data['total_dividend_reinvest'] = this.totalDividendReinvest;
    data['total_dividend_paid_current_fy'] = this.totalDividendPaidCurrentFy;
    data['total_dividend_reinvest_current_fy'] =
        this.totalDividendReinvestCurrentFy;
    data['isStpInScheme'] = this.isStpInScheme;
    data['isStpOutScheme'] = this.isStpOutScheme;
    data['isActiveStpScheme'] = this.isActiveStpScheme;
    data['stp_amount'] = this.stpAmount;
    data['isSwpScheme'] = this.isSwpScheme;
    data['isActiveSwpScheme'] = this.isActiveSwpScheme;
    data['swp_amount'] = this.swpAmount;
    data['user_id'] = this.userId;
    data['investorName'] = this.investorName;
    data['investorPan'] = this.investorPan;
    data['investor_branch'] = this.investorBranch;
    data['investor_rm_name'] = this.investorRmName;
    data['investor_subbroker_name'] = this.investorSubbrokerName;
    data['isManualEntry'] = this.isManualEntry;
    data['acc_holder_name'] = this.accHolderName;
    data['bank_name'] = this.bankName;
    data['bank_branch_name'] = this.bankBranchName;
    data['invCostStartDate'] = this.invCostStartDate;
    data['invCostEndDate'] = this.invCostEndDate;
    data['currValueStartDate'] = this.currValueStartDate;
    data['currValueEndDate'] = this.currValueEndDate;
    data['sip_row_merged_count'] = this.sipRowMergedCount;
    data['total_current_cost_start_date'] = this.totalCurrentCostStartDate;
    data['total_current_value_start_date'] = this.totalCurrentValueStartDate;
    data['total_current_cost_end_date'] = this.totalCurrentCostEndDate;
    data['total_current_value_end_date'] = this.totalCurrentValueEndDate;
    data['total_purcahse'] = this.totalPurcahse;
    data['total_redemption'] = this.totalRedemption;
    data['total_div_invest'] = this.totalDivInvest;
    data['total_div_paid'] = this.totalDivPaid;
    data['total_gain_loss'] = this.totalGainLoss;
    data['total_abs_return'] = this.totalAbsReturn;
    data['scheme_dates_array'] = this.schemeDatesArray;
    data['scheme_amount_array'] = this.schemeAmountArray;
    data['sensex'] = this.sensex;
    data['short_term_units'] = this.shortTermUnits;
    data['short_term_amount'] = this.shortTermAmount;
    data['long_term_units'] = this.longTermUnits;
    data['long_term_amount'] = this.longTermAmount;
    data['notional_units'] = this.notionalUnits;
    data['notional_amount'] = this.notionalAmount;
    data['prev_latestNav'] = this.prevLatestNav;
    data['day_change_value'] = this.dayChangeValue;
    data['day_change_percentage'] = this.dayChangePercentage;
    data['loadFreeUnits'] = this.loadFreeUnits;
    data['joint1_name'] = this.joint1Name;
    data['joint1_pan'] = this.joint1Pan;
    data['joint2_name'] = this.joint2Name;
    data['joint2_pan'] = this.joint2Pan;
    data['tax_status'] = this.taxStatus;
    data['holding_nature'] = this.holdingNature;
    data['nominee1_name'] = this.nominee1Name;
    data['nominee1_relation'] = this.nominee1Relation;
    data['nominee1_percentage'] = this.nominee1Percentage;
    data['nominee2_name'] = this.nominee2Name;
    data['nominee2_relation'] = this.nominee2Relation;
    data['nominee2_percentage'] = this.nominee2Percentage;
    data['nominee3_name'] = this.nominee3Name;
    data['nominee3_relation'] = this.nominee3Relation;
    data['nominee3_percentage'] = this.nominee3Percentage;
    data['allocation'] = this.allocation;
    data['xirr_list'] = this.xirrList;
    data['folio_list'] = this.folioList;
    data['currentNav'] = this.currentNav;
    data['currentNavDate'] = this.currentNavDate;
    data['scheme_pan'] = this.schemePan;
    data['arn_number'] = this.arnNumber;
    data['scheme_benchmark_flag'] = this.schemeBenchmarkFlag;
    data['benchmark_name'] = this.benchmarkName;
    data['benchmark_code'] = this.benchmarkCode;
    data['benchmark_currentCostOfInvestment'] =
        this.benchmarkCurrentCostOfInvestment;
    data['benchmark_totalCurrentValue'] = this.benchmarkTotalCurrentValue;
    data['benchmark_absolute_return'] = this.benchmarkAbsoluteReturn;
    data['benchmark_cagr'] = this.benchmarkCagr;
    data['totalOriginalInvestedAmount_str'] =
        this.totalOriginalInvestedAmountStr;
    data['totalSwitchInAmount_str'] = this.totalSwitchInAmountStr;
    data['totalSwitchOutAmount_str'] = this.totalSwitchOutAmountStr;
    data['totalRedemptionAmount_str'] = this.totalRedemptionAmountStr;
    data['currentCostOfInvestment_str'] = this.currentCostOfInvestmentStr;
    data['totalCurrentValue_str'] = this.totalCurrentValueStr;
    data['unrealisedProfitLoss_str'] = this.unrealisedProfitLossStr;
    data['realisedProfitLoss_str'] = this.realisedProfitLossStr;
    data['realisedGainLoss_str'] = this.realisedGainLossStr;
    data['total_dividend_reinvest_str'] = this.totalDividendReinvestStr;
    data['total_dividend_paid_str'] = this.totalDividendPaidStr;
    data['totalUnits_str'] = this.totalUnitsStr;
    data['purchaseNav_str'] = this.purchaseNavStr;
    data['latestNav_str'] = this.latestNavStr;
    data['investmentStartDate_str'] = this.investmentStartDateStr;
    data['investmentReStartDate_str'] = this.investmentReStartDateStr;
    data['latestNavDate_str'] = this.latestNavDateStr;
    data['currentNav_str'] = this.currentNavStr;
    data['long_term_units_str'] = this.longTermUnitsStr;
    data['long_term_amount_str'] = this.longTermAmountStr;
    data['totalInflow_str'] = this.totalInflowStr;
    data['totalOutflow_str'] = this.totalOutflowStr;
    data['invCostStartDate_str'] = this.invCostStartDateStr;
    data['invCostEndDate_str'] = this.invCostEndDateStr;
    data['currValueStartDate_str'] = this.currValueStartDateStr;
    data['currValueEndDate_str'] = this.currValueEndDateStr;
    data['benchmark_totalCurrentValue_str'] =
        this.benchmarkTotalCurrentValueStr;
    data['scheme_bank_details'] = this.schemeBankDetails;
    data['tag_name'] = this.tagName;
    data['investorSchemeWiseTransactionResponses'] =
        this.investorSchemeWiseTransactionResponses;
    data['familyInvestorSchemeWiseTransactionResponses'] =
        this.familyInvestorSchemeWiseTransactionResponses;
    data['transaction_list'] = this.transactionList;
    data['scheme_xirr_list'] = this.schemeXirrList;
    data['inv_transaction_list'] = this.invTransactionList;
    data['nse_iin_number'] = this.nseIinNumber;
    data['bse_client_code'] = this.bseClientCode;
    data['mfu_can_number'] = this.mfuCanNumber;
    data['monthly_amt'] = this.monthlyAmt;
    return data;
  }
}
