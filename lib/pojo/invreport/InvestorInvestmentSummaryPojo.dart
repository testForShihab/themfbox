class InvestorInvestmentSummaryPojo {
  num? status;
  String? statusMsg;
  String? msg;
  num? totCurrentValue;
  num? netInvestment;
  num? totPurchase;
  num? totSwitchIn;
  num? totSwitchOut;
  num? totRedemption;
  num? totDividends;
  num? totAbsRet;
  num? totCagr;
  num? overallGain;
  List<SList>? assetClassList;
  List<SList>? categoryResList;
  List<SList>? amcResList;
  ListClass? list;

  InvestorInvestmentSummaryPojo({
     this.status,
     this.statusMsg,
     this.msg,
     this.totCurrentValue,
     this.netInvestment,
     this.totPurchase,
     this.totSwitchIn,
     this.totSwitchOut,
     this.totRedemption,
     this.totDividends,
     this.totAbsRet,
     this.totCagr,
     this.overallGain,
     this.assetClassList,
     this.categoryResList,
     this.amcResList,
     this.list,
  });

}

class SList {
  dynamic invName;
  String? amc;
  String? amcLogo;
  String? category;
  dynamic scheme;
  num? purchaseCost;
  num? marketValue;
  num? xirr;
  num? absoluteReturn;
  num? allocation;
  String? purchaseCostStr;
  String? marketValueStr;

  SList({
     this.invName,
     this.amc,
     this.amcLogo,
     this.category,
     this.scheme,
     this.purchaseCost,
     this.marketValue,
     this.xirr,
     this.absoluteReturn,
     this.allocation,
     this.purchaseCostStr,
     this.marketValueStr,
  });

}

class ListClass {
  List<InvestorSchemeWisePortfolioResponse>? investorSchemeWisePortfolioResponses;
  num? id;
  dynamic typeId;
  String? investorName;
  String? investorPan;
  dynamic familyStatus;
  dynamic clientName;
  String? mobile;
  String? email;
  String? address1;
  String? address2;
  String? address3;
  String? city;
  String? pincode;
  String? state;
  String? phoneOffice;
  String? phoneResidence;
  String? dateOfBirth;
  String? guardianPan;
  dynamic brokerCode;
  String? occupation;
  dynamic bseActive;
  String? bseClientCode;
  dynamic nseActive;
  dynamic nseIinNumber;
  dynamic portfolioScore;
  dynamic bankName;
  dynamic bankBranch;
  dynamic accType;
  dynamic accNo;
  dynamic bankAddress1;
  dynamic bankAddress2;
  dynamic bankAddress3;
  dynamic bankCity;
  dynamic bankPincode;
  dynamic ifscCode;
  dynamic demat;
  dynamic nomName;
  dynamic relation;
  dynamic nomAddr1;
  dynamic nomAddr2;
  dynamic nomAddr3;
  dynamic nomCity;
  dynamic nomState;
  dynamic nomPincod;
  dynamic nomPhOff;
  dynamic nomPhRes;
  dynamic nomEmail;
  num? totalInvestedAmount;
  num? totalOriginalInvestedAmount;
  num? totalSwitchInAmount;
  num? totalSwitchOutAmount;
  num? totalRedemptionAmount;
  num? totalInflow;
  num? totalOutflow;
  num? totalNetInvestment;
  num? totalCurrentcost;
  num? totalCurrentValue;
  num? totalUnReliasedGain;
  num? totalReliasedGain;
  num? totalReliasedGainLoss;
  num? totalCagr;
  num? totalAbsoluteReturn;
  num? totalDividendReinvestment;
  num? totalDividendPaid;
  num? totalDividend;
  num? totalDividendPaidCurrentFy;
  num? totalDividendReinvestCurrentFy;
  num? totalDividendCurrentFy;
  num? equityTotalCurrentCost;
  num? equityTotalCurrentValue;
  num? equityTotalUnReliasedGain;
  num? equityTotalReliasedGain;
  num? equityTotalRedeemedReliasedGain;
  num? equityTotalCagr;
  num? equityTotalAbsoluteReturn;
  num? equityTotalDividendReinvestment;
  num? equityTotalDividendPaid;
  num? equityTotalDividend;
  num? equityTotalInflow;
  num? equityTotalInvestedAmount;
  num? equityStartValue;
  num? equityEndValue;
  num? debtTotalCurrentCost;
  num? debtTotalCurrentValue;
  num? debtTotalUnReliasedGain;
  num? debtTotalReliasedGain;
  num? debtTotalRedeemedReliasedGain;
  num? debtTotalCagr;
  num? debtTotalAbsoluteReturn;
  num? debtTotalDividendReinvestment;
  num? debtTotalDividendPaid;
  num? debtTotalDividend;
  num? debtTotalInflow;
  num? debtTotalInvestedAmount;
  num? debtStartValue;
  num? debtEndValue;
  num? hybridTotalCurrentCost;
  num? hybridTotalCurrentValue;
  num? hybridTotalUnReliasedGain;
  num? hybridTotalReliasedGain;
  num? hybridTotalRedeemedReliasedGain;
  num? hybridTotalCagr;
  num? hybridTotalAbsoluteReturn;
  num? hybridTotalDividendReinvestment;
  num? hybridTotalDividendPaid;
  num? hybridTotalDividend;
  num? hybridTotalInflow;
  num? hybridTotalInvestedAmount;
  num? hybridStartValue;
  num? hybridEndValue;
  num? solutionTotalCurrentCost;
  num? solutionTotalCurrentValue;
  num? solutionTotalUnReliasedGain;
  num? solutionTotalReliasedGain;
  num? solutionTotalRedeemedReliasedGain;
  num? solutionTotalCagr;
  num? solutionTotalAbsoluteReturn;
  num? solutionTotalDividendReinvestment;
  num? solutionTotalDividendPaid;
  num? solutionTotalDividend;
  num? solutionTotalInflow;
  num? solutionTotalInvestedAmount;
  num? solutionStartValue;
  num? solutionEndValue;
  num? otherTotalCurrentCost;
  num? otherTotalCurrentValue;
  num? otherTotalUnReliasedGain;
  num? otherTotalReliasedGain;
  num? otherTotalRedeemedReliasedGain;
  num? otherTotalCagr;
  num? otherTotalAbsoluteReturn;
  num? otherTotalDividendReinvestment;
  num? otherTotalDividendPaid;
  num? otherTotalDividend;
  num? otherTotalInflow;
  num? otherTotalInvestedAmount;
  num? otherStartValue;
  num? otherEndValue;
  String? equityTotalCurrentCostStr;
  String? equityTotalCurrentValueStr;
  String? equityTotalUnReliasedGainStr;
  String? equityTotalReliasedGainStr;
  String? equityTotalDividendReinvestmentStr;
  String? equityTotalDividendPaidStr;
  String? debtTotalCurrentCostStr;
  String? debtTotalCurrentValueStr;
  String? debtTotalUnReliasedGainStr;
  String? debtTotalReliasedGainStr;
  String? debtTotalDividendReinvestmentStr;
  String? debtTotalDividendPaidStr;
  String? hybridTotalCurrentCostStr;
  String? hybridTotalCurrentValueStr;
  String? hybridTotalUnReliasedGainStr;
  String? hybridTotalReliasedGainStr;
  String? hybridTotalDividendReinvestmentStr;
  String? hybridTotalDividendPaidStr;
  String? solutionTotalCurrentCostStr;
  String? solutionTotalCurrentValueStr;
  String? solutionTotalUnReliasedGainStr;
  String? solutionTotalReliasedGainStr;
  String? solutionTotalDividendReinvestmentStr;
  String? solutionTotalDividendPaidStr;
  String? otherTotalCurrentCostStr;
  String? otherTotalCurrentValueStr;
  String? otherTotalUnReliasedGainStr;
  String? otherTotalReliasedGainStr;
  String? otherTotalDividendReinvestmentStr;
  String? otherTotalDividendPaidStr;
  String? salutation;
  List<RList>? cagrList;
  num? familyPortfolioReturn;
  dynamic portfolioDayChangeValue;
  dynamic portfolioDayChangePercentage;
  String? totalOriginalInvestedAmountStr;
  String? totalSwitchInAmountStr;
  String? totalSwitchOutAmountStr;
  String? totalRedemptionAmountStr;
  String? totalCurrentcostStr;
  String? totalCurrentValueStr;
  String? totalDividendReinvestmentStr;
  String? totalDividendPaidStr;
  String? totalUnReliasedGainStr;
  String? totalReliasedGainStr;
  String? totalReliasedGainLossStr;
  dynamic equityList;
  dynamic debtList;
  dynamic hybridList;
  dynamic solutionList;
  dynamic otherList;
  bool? mfOnedayChange;
  num? totalSipAmount;
  dynamic notes;
  String? benchmarkStartNav;
  String? benchmarkEndNav;
  dynamic userId;

  ListClass({
     this.investorSchemeWisePortfolioResponses,
     this.id,
     this.typeId,
     this.investorName,
     this.investorPan,
     this.familyStatus,
     this.clientName,
     this.mobile,
     this.email,
     this.address1,
     this.address2,
     this.address3,
     this.city,
     this.pincode,
     this.state,
     this.phoneOffice,
     this.phoneResidence,
     this.dateOfBirth,
     this.guardianPan,
     this.brokerCode,
     this.occupation,
     this.bseActive,
     this.bseClientCode,
     this.nseActive,
     this.nseIinNumber,
     this.portfolioScore,
     this.bankName,
     this.bankBranch,
     this.accType,
     this.accNo,
     this.bankAddress1,
     this.bankAddress2,
     this.bankAddress3,
     this.bankCity,
     this.bankPincode,
     this.ifscCode,
     this.demat,
     this.nomName,
     this.relation,
     this.nomAddr1,
     this.nomAddr2,
     this.nomAddr3,
     this.nomCity,
     this.nomState,
     this.nomPincod,
     this.nomPhOff,
     this.nomPhRes,
     this.nomEmail,
     this.totalInvestedAmount,
     this.totalOriginalInvestedAmount,
     this.totalSwitchInAmount,
     this.totalSwitchOutAmount,
     this.totalRedemptionAmount,
     this.totalInflow,
     this.totalOutflow,
     this.totalNetInvestment,
     this.totalCurrentcost,
     this.totalCurrentValue,
     this.totalUnReliasedGain,
     this.totalReliasedGain,
     this.totalReliasedGainLoss,
     this.totalCagr,
     this.totalAbsoluteReturn,
     this.totalDividendReinvestment,
     this.totalDividendPaid,
     this.totalDividend,
     this.totalDividendPaidCurrentFy,
     this.totalDividendReinvestCurrentFy,
     this.totalDividendCurrentFy,
     this.equityTotalCurrentCost,
     this.equityTotalCurrentValue,
     this.equityTotalUnReliasedGain,
     this.equityTotalReliasedGain,
     this.equityTotalRedeemedReliasedGain,
     this.equityTotalCagr,
     this.equityTotalAbsoluteReturn,
     this.equityTotalDividendReinvestment,
     this.equityTotalDividendPaid,
     this.equityTotalDividend,
     this.equityTotalInflow,
     this.equityTotalInvestedAmount,
     this.equityStartValue,
     this.equityEndValue,
     this.debtTotalCurrentCost,
     this.debtTotalCurrentValue,
     this.debtTotalUnReliasedGain,
     this.debtTotalReliasedGain,
     this.debtTotalRedeemedReliasedGain,
     this.debtTotalCagr,
     this.debtTotalAbsoluteReturn,
     this.debtTotalDividendReinvestment,
     this.debtTotalDividendPaid,
     this.debtTotalDividend,
     this.debtTotalInflow,
     this.debtTotalInvestedAmount,
     this.debtStartValue,
     this.debtEndValue,
     this.hybridTotalCurrentCost,
     this.hybridTotalCurrentValue,
     this.hybridTotalUnReliasedGain,
     this.hybridTotalReliasedGain,
     this.hybridTotalRedeemedReliasedGain,
     this.hybridTotalCagr,
     this.hybridTotalAbsoluteReturn,
     this.hybridTotalDividendReinvestment,
     this.hybridTotalDividendPaid,
     this.hybridTotalDividend,
     this.hybridTotalInflow,
     this.hybridTotalInvestedAmount,
     this.hybridStartValue,
     this.hybridEndValue,
     this.solutionTotalCurrentCost,
     this.solutionTotalCurrentValue,
     this.solutionTotalUnReliasedGain,
     this.solutionTotalReliasedGain,
     this.solutionTotalRedeemedReliasedGain,
     this.solutionTotalCagr,
     this.solutionTotalAbsoluteReturn,
     this.solutionTotalDividendReinvestment,
     this.solutionTotalDividendPaid,
     this.solutionTotalDividend,
     this.solutionTotalInflow,
     this.solutionTotalInvestedAmount,
     this.solutionStartValue,
     this.solutionEndValue,
     this.otherTotalCurrentCost,
     this.otherTotalCurrentValue,
     this.otherTotalUnReliasedGain,
     this.otherTotalReliasedGain,
     this.otherTotalRedeemedReliasedGain,
     this.otherTotalCagr,
     this.otherTotalAbsoluteReturn,
     this.otherTotalDividendReinvestment,
     this.otherTotalDividendPaid,
     this.otherTotalDividend,
     this.otherTotalInflow,
     this.otherTotalInvestedAmount,
     this.otherStartValue,
     this.otherEndValue,
     this.equityTotalCurrentCostStr,
     this.equityTotalCurrentValueStr,
     this.equityTotalUnReliasedGainStr,
     this.equityTotalReliasedGainStr,
     this.equityTotalDividendReinvestmentStr,
     this.equityTotalDividendPaidStr,
     this.debtTotalCurrentCostStr,
     this.debtTotalCurrentValueStr,
     this.debtTotalUnReliasedGainStr,
     this.debtTotalReliasedGainStr,
     this.debtTotalDividendReinvestmentStr,
     this.debtTotalDividendPaidStr,
     this.hybridTotalCurrentCostStr,
     this.hybridTotalCurrentValueStr,
     this.hybridTotalUnReliasedGainStr,
     this.hybridTotalReliasedGainStr,
     this.hybridTotalDividendReinvestmentStr,
     this.hybridTotalDividendPaidStr,
     this.solutionTotalCurrentCostStr,
     this.solutionTotalCurrentValueStr,
     this.solutionTotalUnReliasedGainStr,
     this.solutionTotalReliasedGainStr,
     this.solutionTotalDividendReinvestmentStr,
     this.solutionTotalDividendPaidStr,
     this.otherTotalCurrentCostStr,
     this.otherTotalCurrentValueStr,
     this.otherTotalUnReliasedGainStr,
     this.otherTotalReliasedGainStr,
     this.otherTotalDividendReinvestmentStr,
     this.otherTotalDividendPaidStr,
     this.salutation,
     this.cagrList,
     this.familyPortfolioReturn,
     this.portfolioDayChangeValue,
     this.portfolioDayChangePercentage,
     this.totalOriginalInvestedAmountStr,
     this.totalSwitchInAmountStr,
     this.totalSwitchOutAmountStr,
     this.totalRedemptionAmountStr,
     this.totalCurrentcostStr,
     this.totalCurrentValueStr,
     this.totalDividendReinvestmentStr,
     this.totalDividendPaidStr,
     this.totalUnReliasedGainStr,
     this.totalReliasedGainStr,
     this.totalReliasedGainLossStr,
     this.equityList,
     this.debtList,
     this.hybridList,
     this.solutionList,
     this.otherList,
     this.mfOnedayChange,
     this.totalSipAmount,
     this.notes,
     this.benchmarkStartNav,
     this.benchmarkEndNav,
     this.userId,
  });

}

class RList {
  DateTime? trxnDate;
  num? amount;

  RList({
     this.trxnDate,
     this.amount,
  });

}

class InvestorSchemeWisePortfolioResponse {
  String? scheme;
  String? schemeAmfiShortName;
  String? schemeClass;
  String? schemeCode;
  String? schemeRegistrar;
  String? schemeAmfiCommon;
  String? amcCode;
  dynamic amcName;
  String? foliono;
  String? amcLogo;
  dynamic schemeWeight;
  dynamic schemeRating;
  dynamic schemeScore;
  dynamic schemeReview;
  dynamic schemeBenchmarkName;
  dynamic schemeBenchmarkCode;
  dynamic schemeRiskProfile;
  dynamic notes;
  dynamic brokerCode;
  DateTime? investmentStartDate;
  DateTime? investmentReStartDate;
  DateTime? lastInvestmentDate;
  DateTime? lastTransactionDate;
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
  DateTime? latestNavDate;
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
  dynamic goalName;
  String? schemeCompany;
  String? schemeAdvisorkhojCategory;
  String? isinNo;
  String? schemeAmfiCode;
  dynamic taxCategory;
  num? sipAmount;
  dynamic totalSipAmount;
  dynamic totalSipAmountStr;
  dynamic sipFrequency;
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
  dynamic userId;
  dynamic investorName;
  dynamic investorPan;
  dynamic investorBranch;
  dynamic investorRmName;
  dynamic investorSubbrokerName;
  bool? isManualEntry;
  dynamic accHolderName;
  dynamic bankName;
  dynamic bankBranchName;
  dynamic invCostStartDate;
  dynamic invCostEndDate;
  dynamic currValueStartDate;
  dynamic currValueEndDate;
  dynamic sipRowMergedCount;
  dynamic totalCurrentCostStartDate;
  dynamic totalCurrentValueStartDate;
  dynamic totalCurrentCostEndDate;
  dynamic totalCurrentValueEndDate;
  dynamic totalPurcahse;
  dynamic totalRedemption;
  dynamic totalDivInvest;
  dynamic totalDivPaid;
  dynamic totalGainLoss;
  dynamic totalAbsReturn;
  dynamic schemeDatesArray;
  dynamic schemeAmountArray;
  dynamic sensex;
  dynamic shortTermUnits;
  dynamic shortTermAmount;
  dynamic longTermUnits;
  dynamic longTermAmount;
  dynamic notionalUnits;
  dynamic notionalAmount;
  dynamic prevLatestNav;
  dynamic dayChangeValue;
  dynamic dayChangePercentage;
  num? loadFreeUnits;
  dynamic jonum1Name;
  dynamic jonum1Pan;
  dynamic jonum2Name;
  dynamic jonum2Pan;
  dynamic taxStatus;
  dynamic holdingNature;
  dynamic nominee1Name;
  dynamic nominee1Relation;
  dynamic nominee1Percentage;
  dynamic nominee2Name;
  dynamic nominee2Relation;
  dynamic nominee2Percentage;
  dynamic nominee3Name;
  dynamic nominee3Relation;
  dynamic nominee3Percentage;
  num? allocation;
  List<RList>? xirrList;
  dynamic folioList;
  num? currentNav;
  dynamic currentNavDate;
  dynamic schemePan;
  dynamic arnNumber;
  dynamic schemeBenchmarkFlag;
  dynamic benchmarkName;
  dynamic benchmarkCode;
  dynamic benchmarkCurrentCostOfInvestment;
  dynamic benchmarkTotalCurrentValue;
  dynamic benchmarkAbsoluteReturn;
  dynamic benchmarkCagr;
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
  dynamic totalInflowStr;
  dynamic totalOutflowStr;
  dynamic invCostStartDateStr;
  dynamic invCostEndDateStr;
  dynamic currValueStartDateStr;
  dynamic currValueEndDateStr;
  dynamic benchmarkTotalCurrentValueStr;
  dynamic schemeBankDetails;
  dynamic tagName;
  List<InvestorSchemeWiseTransactionResponse>? investorSchemeWiseTransactionResponses;
  dynamic familyInvestorSchemeWiseTransactionResponses;
  dynamic transactionList;
  dynamic schemeXirrList;
  dynamic invTransactionList;
  dynamic nseIinNumber;
  dynamic bseClientCode;
  dynamic monthlyAmt;

  InvestorSchemeWisePortfolioResponse({
     this.scheme,
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
     this.jonum1Name,
     this.jonum1Pan,
     this.jonum2Name,
     this.jonum2Pan,
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
     this.monthlyAmt,
  });

}

class InvestorSchemeWiseTransactionResponse {
  dynamic schemeAmfiShortName;
  dynamic purchaseAveragePrice;
  dynamic totalAmount;
  dynamic currentCost;
  dynamic currentValue;
  dynamic totalInflowAmount;
  dynamic userId;
  dynamic branch;
  dynamic rmName;
  dynamic subbrokerName;
  dynamic redemptionDate;
  dynamic redemptionNav;
  dynamic redemptionUnits;
  dynamic redemptionAmount;
  String? indAmt;
  String? totalAmountStr;
  dynamic logo;
  num? amount;
  dynamic totalUnits;
  DateTime? traddate;
  num? purprice;
  TrxnType? trxnType;
  num? units;
  dynamic tax;
  dynamic stt;
  dynamic stampDuty;
  dynamic invName;
  dynamic folioNo;
  String? trxnSuffi;
  dynamic loads;
  num? totalTax;
  dynamic registrar;
  dynamic scheme;
  dynamic trxnNatur;
  String? traddateStr;
  String? purpriceStr;
  String? unitsStr;
  String? stampDutyStr;
  String? totalTaxStr;
  String? sttStr;
  String? totalUnitsStr;
  dynamic scanrefno;
  dynamic brokcode;
  dynamic bankName;
  dynamic accountNumber;
  dynamic trxnmode;
  dynamic amcCode;
  dynamic prodcode;
  dynamic trxntype;
  dynamic trxnno;
  dynamic trxnstat;
  dynamic usercode;
  dynamic usrtrxno;
  dynamic postdate;
  dynamic subbrok;
  dynamic brokperc;
  dynamic brokcomm;
  dynamic altfolio;
  dynamic repDate;
  dynamic time1;
  dynamic trxnsubtyp;
  dynamic applicatio;
  dynamic te15H;
  dynamic micrNo;
  dynamic remarks;
  dynamic swflag;
  dynamic oldFolio;
  dynamic seqNo;
  dynamic reinvestF;
  dynamic multBrok;
  dynamic location;
  dynamic schemeTyp;
  dynamic taxStatus;
  dynamic pan;
  dynamic invIin;
  dynamic targSrcS;
  dynamic ticobTrty;
  dynamic ticobTrno;
  dynamic ticobPost;
  dynamic dpId;
  dynamic trxnCharg;
  dynamic eligibAmt;
  dynamic srcOfTxn;
  dynamic siptrxnno;
  dynamic terLocati;
  dynamic euin;
  dynamic euinValid;
  dynamic euinOpted;
  dynamic subBrkAr;
  dynamic amountStr;

  InvestorSchemeWiseTransactionResponse({
     this.schemeAmfiShortName,
     this.purchaseAveragePrice,
     this.totalAmount,
     this.currentCost,
     this.currentValue,
     this.totalInflowAmount,
     this.userId,
     this.branch,
     this.rmName,
     this.subbrokerName,
     this.redemptionDate,
     this.redemptionNav,
     this.redemptionUnits,
     this.redemptionAmount,
     this.indAmt,
     this.totalAmountStr,
     this.logo,
     this.amount,
     this.totalUnits,
     this.traddate,
     this.purprice,
     this.trxnType,
     this.units,
     this.tax,
     this.stt,
     this.stampDuty,
     this.invName,
     this.folioNo,
     this.trxnSuffi,
     this.loads,
     this.totalTax,
     this.registrar,
     this.scheme,
     this.trxnNatur,
     this.traddateStr,
     this.purpriceStr,
     this.unitsStr,
     this.stampDutyStr,
     this.totalTaxStr,
     this.sttStr,
     this.totalUnitsStr,
     this.scanrefno,
     this.brokcode,
     this.bankName,
     this.accountNumber,
     this.trxnmode,
     this.amcCode,
     this.prodcode,
     this.trxntype,
     this.trxnno,
     this.trxnstat,
     this.usercode,
     this.usrtrxno,
     this.postdate,
     this.subbrok,
     this.brokperc,
     this.brokcomm,
     this.altfolio,
     this.repDate,
     this.time1,
     this.trxnsubtyp,
     this.applicatio,
     this.te15H,
     this.micrNo,
     this.remarks,
     this.swflag,
     this.oldFolio,
     this.seqNo,
     this.reinvestF,
     this.multBrok,
     this.location,
     this.schemeTyp,
     this.taxStatus,
     this.pan,
     this.invIin,
     this.targSrcS,
     this.ticobTrty,
     this.ticobTrno,
     this.ticobPost,
     this.dpId,
     this.trxnCharg,
     this.eligibAmt,
     this.srcOfTxn,
     this.siptrxnno,
     this.terLocati,
     this.euin,
     this.euinValid,
     this.euinOpted,
     this.subBrkAr,
     this.amountStr,
  });

}

enum TrxnType {
  ADDITIONAL_PURCHASE,
  ADDITIONAL_PURCHASE_SYSTEMATIC,
  DEMATERIALIZED,
  FRESH_PURCHASE,
  FRESH_PURCHASE_SYSTEMATIC,
  LATERAL_SHIFT_IN
}
