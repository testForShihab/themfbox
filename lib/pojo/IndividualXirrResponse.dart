class IndividualXirrResponse {
  IndividualXirrResponse({
     this.status,
     this.statusMsg,
     this.msg,
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
     this.list,
  });

   num? status;
   String? statusMsg;
   String? msg;
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
   ListClass? list;

  factory IndividualXirrResponse.fromJson(Map<String, dynamic> json){
    return IndividualXirrResponse(
      status: json["status"],
      statusMsg: json["status_msg"],
      msg: json["msg"],
      totalInvCost: json["total_inv_cost"],
      totalCurrVal: json["total_curr_val"],
      invCostAsOn: json["inv_cost_as_on"],
      currValAsOn: json["curr_val_as_on"],
      totalGainLoss: json["total_gain_loss"],
      totalAbsRet: json["total_abs_ret"],
      totalXirr: json["total_xirr"],
      totalPurchase: json["total_purchase"],
      totalRedemption: json["total_redemption"],
      totalDivPay: json["total_div_pay"],
      list: json["list"] == null ? null : ListClass.fromJson(json["list"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "status_msg": statusMsg,
    "msg": msg,
    "total_inv_cost": totalInvCost,
    "total_curr_val": totalCurrVal,
    "inv_cost_as_on": invCostAsOn,
    "curr_val_as_on": currValAsOn,
    "total_gain_loss": totalGainLoss,
    "total_abs_ret": totalAbsRet,
    "total_xirr": totalXirr,
    "total_purchase": totalPurchase,
    "total_redemption": totalRedemption,
    "total_div_pay": totalDivPay,
    "list": list?.toJson(),
  };

}

class ListClass {
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

   dynamic investorSchemeWisePortfolioResponses;
   dynamic id;
   dynamic typeId;
   dynamic investorName;
   dynamic investorPan;
   dynamic familyStatus;
   dynamic clientName;
   dynamic mobile;
   dynamic email;
   dynamic address1;
   dynamic address2;
   dynamic address3;
   dynamic city;
   dynamic pincode;
   dynamic state;
   dynamic phoneOffice;
   dynamic phoneResidence;
   dynamic dateOfBirth;
   dynamic guardianPan;
   dynamic brokerCode;
   dynamic occupation;
   dynamic bseActive;
   dynamic bseClientCode;
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
   dynamic salutation;
   dynamic cagrList;
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
   List<DebtListElement>? equityList;
   List<DebtListElement>? debtList;
   List<DebtListElement>? hybridList;
   List<dynamic>? solutionList;
   List<dynamic>? otherList;
   bool? mfOnedayChange;
   num? totalSipAmount;
   dynamic notes;
   String? benchmarkStartNav;
   String? benchmarkEndNav;
   dynamic userId;

  factory ListClass.fromJson(Map<String, dynamic> json){
    return ListClass(
      investorSchemeWisePortfolioResponses: json["investorSchemeWisePortfolioResponses"],
      id: json["id"],
      typeId: json["type_id"],
      investorName: json["investorName"],
      investorPan: json["investorPan"],
      familyStatus: json["family_status"],
      clientName: json["client_name"],
      mobile: json["mobile"],
      email: json["email"],
      address1: json["address1"],
      address2: json["address2"],
      address3: json["address3"],
      city: json["city"],
      pincode: json["pincode"],
      state: json["state"],
      phoneOffice: json["phone_office"],
      phoneResidence: json["phone_residence"],
      dateOfBirth: json["date_of_birth"],
      guardianPan: json["guardian_pan"],
      brokerCode: json["broker_code"],
      occupation: json["occupation"],
      bseActive: json["bse_active"],
      bseClientCode: json["bse_client_code"],
      nseActive: json["nse_active"],
      nseIinNumber: json["nse_iin_number"],
      portfolioScore: json["portfolio_score"],
      bankName: json["bank_name"],
      bankBranch: json["bank_branch"],
      accType: json["acc_type"],
      accNo: json["acc_no"],
      bankAddress1: json["bank_address1"],
      bankAddress2: json["bank_address2"],
      bankAddress3: json["bank_address3"],
      bankCity: json["bank_city"],
      bankPincode: json["bank_pincode"],
      ifscCode: json["ifsc_code"],
      demat: json["demat"],
      nomName: json["nom_name"],
      relation: json["relation"],
      nomAddr1: json["nom_addr1"],
      nomAddr2: json["nom_addr2"],
      nomAddr3: json["nom_addr3"],
      nomCity: json["nom_city"],
      nomState: json["nom_state"],
      nomPincod: json["nom_pincod"],
      nomPhOff: json["nom_ph_off"],
      nomPhRes: json["nom_ph_res"],
      nomEmail: json["nom_email"],
      totalInvestedAmount: json["totalInvestedAmount"],
      totalOriginalInvestedAmount: json["totalOriginalInvestedAmount"],
      totalSwitchInAmount: json["totalSwitchInAmount"],
      totalSwitchOutAmount: json["totalSwitchOutAmount"],
      totalRedemptionAmount: json["totalRedemptionAmount"],
      totalInflow: json["totalInflow"],
      totalOutflow: json["totalOutflow"],
      totalNetInvestment: json["totalNetInvestment"],
      totalCurrentcost: json["totalCurrentcost"],
      totalCurrentValue: json["totalCurrentValue"],
      totalUnReliasedGain: json["totalUnReliasedGain"],
      totalReliasedGain: json["totalReliasedGain"],
      totalReliasedGainLoss: json["totalReliasedGainLoss"],
      totalCagr: json["totalCAGR"],
      totalAbsoluteReturn: json["totalAbsoluteReturn"],
      totalDividendReinvestment: json["totalDividendReinvestment"],
      totalDividendPaid: json["totalDividendPaid"],
      totalDividend: json["totalDividend"],
      totalDividendPaidCurrentFy: json["totalDividendPaidCurrentFY"],
      totalDividendReinvestCurrentFy: json["totalDividendReinvestCurrentFY"],
      totalDividendCurrentFy: json["totalDividendCurrentFY"],
      equityTotalCurrentCost: json["equity_total_current_cost"],
      equityTotalCurrentValue: json["equity_total_current_value"],
      equityTotalUnReliasedGain: json["equity_total_unReliasedGain"],
      equityTotalReliasedGain: json["equity_total_ReliasedGain"],
      equityTotalRedeemedReliasedGain: json["equity_total_Redeemed_ReliasedGain"],
      equityTotalCagr: json["equity_total_CAGR"],
      equityTotalAbsoluteReturn: json["equity_total_AbsoluteReturn"],
      equityTotalDividendReinvestment: json["equity_total_dividendReinvestment"],
      equityTotalDividendPaid: json["equity_total_dividendPaid"],
      equityTotalDividend: json["equity_total_dividend"],
      equityTotalInflow: json["equity_total_inflow"],
      equityTotalInvestedAmount: json["equity_total_invested_amount"],
      equityStartValue: json["equity_start_value"],
      equityEndValue: json["equity_end_value"],
      debtTotalCurrentCost: json["debt_total_current_cost"],
      debtTotalCurrentValue: json["debt_total_current_value"],
      debtTotalUnReliasedGain: json["debt_total_unReliasedGain"],
      debtTotalReliasedGain: json["debt_total_ReliasedGain"],
      debtTotalRedeemedReliasedGain: json["debt_total_Redeemed_ReliasedGain"],
      debtTotalCagr: json["debt_total_CAGR"],
      debtTotalAbsoluteReturn: json["debt_total_AbsoluteReturn"],
      debtTotalDividendReinvestment: json["debt_total_dividendReinvestment"],
      debtTotalDividendPaid: json["debt_total_dividendPaid"],
      debtTotalDividend: json["debt_total_dividend"],
      debtTotalInflow: json["debt_total_inflow"],
      debtTotalInvestedAmount: json["debt_total_invested_amount"],
      debtStartValue: json["debt_start_value"],
      debtEndValue: json["debt_end_value"],
      hybridTotalCurrentCost: json["hybrid_total_current_cost"],
      hybridTotalCurrentValue: json["hybrid_total_current_value"],
      hybridTotalUnReliasedGain: json["hybrid_total_unReliasedGain"],
      hybridTotalReliasedGain: json["hybrid_total_ReliasedGain"],
      hybridTotalRedeemedReliasedGain: json["hybrid_total_Redeemed_ReliasedGain"],
      hybridTotalCagr: json["hybrid_total_CAGR"],
      hybridTotalAbsoluteReturn: json["hybrid_total_AbsoluteReturn"],
      hybridTotalDividendReinvestment: json["hybrid_total_dividendReinvestment"],
      hybridTotalDividendPaid: json["hybrid_total_dividendPaid"],
      hybridTotalDividend: json["hybrid_total_dividend"],
      hybridTotalInflow: json["hybrid_total_inflow"],
      hybridTotalInvestedAmount: json["hybrid_total_invested_amount"],
      hybridStartValue: json["hybrid_start_value"],
      hybridEndValue: json["hybrid_end_value"],
      solutionTotalCurrentCost: json["solution_total_current_cost"],
      solutionTotalCurrentValue: json["solution_total_current_value"],
      solutionTotalUnReliasedGain: json["solution_total_unReliasedGain"],
      solutionTotalReliasedGain: json["solution_total_ReliasedGain"],
      solutionTotalRedeemedReliasedGain: json["solution_total_Redeemed_ReliasedGain"],
      solutionTotalCagr: json["solution_total_CAGR"],
      solutionTotalAbsoluteReturn: json["solution_total_AbsoluteReturn"],
      solutionTotalDividendReinvestment: json["solution_total_dividendReinvestment"],
      solutionTotalDividendPaid: json["solution_total_dividendPaid"],
      solutionTotalDividend: json["solution_total_dividend"],
      solutionTotalInflow: json["solution_total_inflow"],
      solutionTotalInvestedAmount: json["solution_total_invested_amount"],
      solutionStartValue: json["solution_start_value"],
      solutionEndValue: json["solution_end_value"],
      otherTotalCurrentCost: json["other_total_current_cost"],
      otherTotalCurrentValue: json["other_total_current_value"],
      otherTotalUnReliasedGain: json["other_total_unReliasedGain"],
      otherTotalReliasedGain: json["other_total_ReliasedGain"],
      otherTotalRedeemedReliasedGain: json["other_total_Redeemed_ReliasedGain"],
      otherTotalCagr: json["other_total_CAGR"],
      otherTotalAbsoluteReturn: json["other_total_AbsoluteReturn"],
      otherTotalDividendReinvestment: json["other_total_dividendReinvestment"],
      otherTotalDividendPaid: json["other_total_dividendPaid"],
      otherTotalDividend: json["other_total_dividend"],
      otherTotalInflow: json["other_total_inflow"],
      otherTotalInvestedAmount: json["other_total_invested_amount"],
      otherStartValue: json["other_start_value"],
      otherEndValue: json["other_end_value"],
      equityTotalCurrentCostStr: json["equity_total_current_cost_str"],
      equityTotalCurrentValueStr: json["equity_total_current_value_str"],
      equityTotalUnReliasedGainStr: json["equity_total_unReliasedGain_str"],
      equityTotalReliasedGainStr: json["equity_total_ReliasedGain_str"],
      equityTotalDividendReinvestmentStr: json["equity_total_dividendReinvestment_str"],
      equityTotalDividendPaidStr: json["equity_total_dividendPaid_str"],
      debtTotalCurrentCostStr: json["debt_total_current_cost_str"],
      debtTotalCurrentValueStr: json["debt_total_current_value_str"],
      debtTotalUnReliasedGainStr: json["debt_total_unReliasedGain_str"],
      debtTotalReliasedGainStr: json["debt_total_ReliasedGain_str"],
      debtTotalDividendReinvestmentStr: json["debt_total_dividendReinvestment_str"],
      debtTotalDividendPaidStr: json["debt_total_dividendPaid_str"],
      hybridTotalCurrentCostStr: json["hybrid_total_current_cost_str"],
      hybridTotalCurrentValueStr: json["hybrid_total_current_value_str"],
      hybridTotalUnReliasedGainStr: json["hybrid_total_unReliasedGain_str"],
      hybridTotalReliasedGainStr: json["hybrid_total_ReliasedGain_str"],
      hybridTotalDividendReinvestmentStr: json["hybrid_total_dividendReinvestment_str"],
      hybridTotalDividendPaidStr: json["hybrid_total_dividendPaid_str"],
      solutionTotalCurrentCostStr: json["solution_total_current_cost_str"],
      solutionTotalCurrentValueStr: json["solution_total_current_value_str"],
      solutionTotalUnReliasedGainStr: json["solution_total_unReliasedGain_str"],
      solutionTotalReliasedGainStr: json["solution_total_ReliasedGain_str"],
      solutionTotalDividendReinvestmentStr: json["solution_total_dividendReinvestment_str"],
      solutionTotalDividendPaidStr: json["solution_total_dividendPaid_str"],
      otherTotalCurrentCostStr: json["other_total_current_cost_str"],
      otherTotalCurrentValueStr: json["other_total_current_value_str"],
      otherTotalUnReliasedGainStr: json["other_total_unReliasedGain_str"],
      otherTotalReliasedGainStr: json["other_total_ReliasedGain_str"],
      otherTotalDividendReinvestmentStr: json["other_total_dividendReinvestment_str"],
      otherTotalDividendPaidStr: json["other_total_dividendPaid_str"],
      salutation: json["salutation"],
      cagrList: json["cagr_list"],
      familyPortfolioReturn: json["family_portfolio_return"],
      portfolioDayChangeValue: json["portfolio_day_change_value"],
      portfolioDayChangePercentage: json["portfolio_day_change_percentage"],
      totalOriginalInvestedAmountStr: json["totalOriginalInvestedAmount_str"],
      totalSwitchInAmountStr: json["totalSwitchInAmount_str"],
      totalSwitchOutAmountStr: json["totalSwitchOutAmount_str"],
      totalRedemptionAmountStr: json["totalRedemptionAmount_str"],
      totalCurrentcostStr: json["totalCurrentcost_str"],
      totalCurrentValueStr: json["totalCurrentValue_str"],
      totalDividendReinvestmentStr: json["totalDividendReinvestment_str"],
      totalDividendPaidStr: json["totalDividendPaid_str"],
      totalUnReliasedGainStr: json["totalUnReliasedGain_str"],
      totalReliasedGainStr: json["totalReliasedGain_str"],
      totalReliasedGainLossStr: json["totalReliasedGainLoss_str"],
      equityList: json["equity_list"] == null ? [] : List<DebtListElement>.from(json["equity_list"]!.map((x) => DebtListElement.fromJson(x))),
      debtList: json["debt_list"] == null ? [] : List<DebtListElement>.from(json["debt_list"]!.map((x) => DebtListElement.fromJson(x))),
      hybridList: json["hybrid_list"] == null ? [] : List<DebtListElement>.from(json["hybrid_list"]!.map((x) => DebtListElement.fromJson(x))),
      solutionList: json["solution_list"] == null ? [] : List<dynamic>.from(json["solution_list"]!.map((x) => x)),
      otherList: json["other_list"] == null ? [] : List<dynamic>.from(json["other_list"]!.map((x) => x)),
      mfOnedayChange: json["mf_oneday_change"],
      totalSipAmount: json["totalSipAmount"],
      notes: json["notes"],
      benchmarkStartNav: json["benchmarkStartNav"],
      benchmarkEndNav: json["benchmarkEndNav"],
      userId: json["user_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "investorSchemeWisePortfolioResponses": investorSchemeWisePortfolioResponses,
    "id": id,
    "type_id": typeId,
    "investorName": investorName,
    "investorPan": investorPan,
    "family_status": familyStatus,
    "client_name": clientName,
    "mobile": mobile,
    "email": email,
    "address1": address1,
    "address2": address2,
    "address3": address3,
    "city": city,
    "pincode": pincode,
    "state": state,
    "phone_office": phoneOffice,
    "phone_residence": phoneResidence,
    "date_of_birth": dateOfBirth,
    "guardian_pan": guardianPan,
    "broker_code": brokerCode,
    "occupation": occupation,
    "bse_active": bseActive,
    "bse_client_code": bseClientCode,
    "nse_active": nseActive,
    "nse_iin_number": nseIinNumber,
    "portfolio_score": portfolioScore,
    "bank_name": bankName,
    "bank_branch": bankBranch,
    "acc_type": accType,
    "acc_no": accNo,
    "bank_address1": bankAddress1,
    "bank_address2": bankAddress2,
    "bank_address3": bankAddress3,
    "bank_city": bankCity,
    "bank_pincode": bankPincode,
    "ifsc_code": ifscCode,
    "demat": demat,
    "nom_name": nomName,
    "relation": relation,
    "nom_addr1": nomAddr1,
    "nom_addr2": nomAddr2,
    "nom_addr3": nomAddr3,
    "nom_city": nomCity,
    "nom_state": nomState,
    "nom_pincod": nomPincod,
    "nom_ph_off": nomPhOff,
    "nom_ph_res": nomPhRes,
    "nom_email": nomEmail,
    "totalInvestedAmount": totalInvestedAmount,
    "totalOriginalInvestedAmount": totalOriginalInvestedAmount,
    "totalSwitchInAmount": totalSwitchInAmount,
    "totalSwitchOutAmount": totalSwitchOutAmount,
    "totalRedemptionAmount": totalRedemptionAmount,
    "totalInflow": totalInflow,
    "totalOutflow": totalOutflow,
    "totalNetInvestment": totalNetInvestment,
    "totalCurrentcost": totalCurrentcost,
    "totalCurrentValue": totalCurrentValue,
    "totalUnReliasedGain": totalUnReliasedGain,
    "totalReliasedGain": totalReliasedGain,
    "totalReliasedGainLoss": totalReliasedGainLoss,
    "totalCAGR": totalCagr,
    "totalAbsoluteReturn": totalAbsoluteReturn,
    "totalDividendReinvestment": totalDividendReinvestment,
    "totalDividendPaid": totalDividendPaid,
    "totalDividend": totalDividend,
    "totalDividendPaidCurrentFY": totalDividendPaidCurrentFy,
    "totalDividendReinvestCurrentFY": totalDividendReinvestCurrentFy,
    "totalDividendCurrentFY": totalDividendCurrentFy,
    "equity_total_current_cost": equityTotalCurrentCost,
    "equity_total_current_value": equityTotalCurrentValue,
    "equity_total_unReliasedGain": equityTotalUnReliasedGain,
    "equity_total_ReliasedGain": equityTotalReliasedGain,
    "equity_total_Redeemed_ReliasedGain": equityTotalRedeemedReliasedGain,
    "equity_total_CAGR": equityTotalCagr,
    "equity_total_AbsoluteReturn": equityTotalAbsoluteReturn,
    "equity_total_dividendReinvestment": equityTotalDividendReinvestment,
    "equity_total_dividendPaid": equityTotalDividendPaid,
    "equity_total_dividend": equityTotalDividend,
    "equity_total_inflow": equityTotalInflow,
    "equity_total_invested_amount": equityTotalInvestedAmount,
    "equity_start_value": equityStartValue,
    "equity_end_value": equityEndValue,
    "debt_total_current_cost": debtTotalCurrentCost,
    "debt_total_current_value": debtTotalCurrentValue,
    "debt_total_unReliasedGain": debtTotalUnReliasedGain,
    "debt_total_ReliasedGain": debtTotalReliasedGain,
    "debt_total_Redeemed_ReliasedGain": debtTotalRedeemedReliasedGain,
    "debt_total_CAGR": debtTotalCagr,
    "debt_total_AbsoluteReturn": debtTotalAbsoluteReturn,
    "debt_total_dividendReinvestment": debtTotalDividendReinvestment,
    "debt_total_dividendPaid": debtTotalDividendPaid,
    "debt_total_dividend": debtTotalDividend,
    "debt_total_inflow": debtTotalInflow,
    "debt_total_invested_amount": debtTotalInvestedAmount,
    "debt_start_value": debtStartValue,
    "debt_end_value": debtEndValue,
    "hybrid_total_current_cost": hybridTotalCurrentCost,
    "hybrid_total_current_value": hybridTotalCurrentValue,
    "hybrid_total_unReliasedGain": hybridTotalUnReliasedGain,
    "hybrid_total_ReliasedGain": hybridTotalReliasedGain,
    "hybrid_total_Redeemed_ReliasedGain": hybridTotalRedeemedReliasedGain,
    "hybrid_total_CAGR": hybridTotalCagr,
    "hybrid_total_AbsoluteReturn": hybridTotalAbsoluteReturn,
    "hybrid_total_dividendReinvestment": hybridTotalDividendReinvestment,
    "hybrid_total_dividendPaid": hybridTotalDividendPaid,
    "hybrid_total_dividend": hybridTotalDividend,
    "hybrid_total_inflow": hybridTotalInflow,
    "hybrid_total_invested_amount": hybridTotalInvestedAmount,
    "hybrid_start_value": hybridStartValue,
    "hybrid_end_value": hybridEndValue,
    "solution_total_current_cost": solutionTotalCurrentCost,
    "solution_total_current_value": solutionTotalCurrentValue,
    "solution_total_unReliasedGain": solutionTotalUnReliasedGain,
    "solution_total_ReliasedGain": solutionTotalReliasedGain,
    "solution_total_Redeemed_ReliasedGain": solutionTotalRedeemedReliasedGain,
    "solution_total_CAGR": solutionTotalCagr,
    "solution_total_AbsoluteReturn": solutionTotalAbsoluteReturn,
    "solution_total_dividendReinvestment": solutionTotalDividendReinvestment,
    "solution_total_dividendPaid": solutionTotalDividendPaid,
    "solution_total_dividend": solutionTotalDividend,
    "solution_total_inflow": solutionTotalInflow,
    "solution_total_invested_amount": solutionTotalInvestedAmount,
    "solution_start_value": solutionStartValue,
    "solution_end_value": solutionEndValue,
    "other_total_current_cost": otherTotalCurrentCost,
    "other_total_current_value": otherTotalCurrentValue,
    "other_total_unReliasedGain": otherTotalUnReliasedGain,
    "other_total_ReliasedGain": otherTotalReliasedGain,
    "other_total_Redeemed_ReliasedGain": otherTotalRedeemedReliasedGain,
    "other_total_CAGR": otherTotalCagr,
    "other_total_AbsoluteReturn": otherTotalAbsoluteReturn,
    "other_total_dividendReinvestment": otherTotalDividendReinvestment,
    "other_total_dividendPaid": otherTotalDividendPaid,
    "other_total_dividend": otherTotalDividend,
    "other_total_inflow": otherTotalInflow,
    "other_total_invested_amount": otherTotalInvestedAmount,
    "other_start_value": otherStartValue,
    "other_end_value": otherEndValue,
    "equity_total_current_cost_str": equityTotalCurrentCostStr,
    "equity_total_current_value_str": equityTotalCurrentValueStr,
    "equity_total_unReliasedGain_str": equityTotalUnReliasedGainStr,
    "equity_total_ReliasedGain_str": equityTotalReliasedGainStr,
    "equity_total_dividendReinvestment_str": equityTotalDividendReinvestmentStr,
    "equity_total_dividendPaid_str": equityTotalDividendPaidStr,
    "debt_total_current_cost_str": debtTotalCurrentCostStr,
    "debt_total_current_value_str": debtTotalCurrentValueStr,
    "debt_total_unReliasedGain_str": debtTotalUnReliasedGainStr,
    "debt_total_ReliasedGain_str": debtTotalReliasedGainStr,
    "debt_total_dividendReinvestment_str": debtTotalDividendReinvestmentStr,
    "debt_total_dividendPaid_str": debtTotalDividendPaidStr,
    "hybrid_total_current_cost_str": hybridTotalCurrentCostStr,
    "hybrid_total_current_value_str": hybridTotalCurrentValueStr,
    "hybrid_total_unReliasedGain_str": hybridTotalUnReliasedGainStr,
    "hybrid_total_ReliasedGain_str": hybridTotalReliasedGainStr,
    "hybrid_total_dividendReinvestment_str": hybridTotalDividendReinvestmentStr,
    "hybrid_total_dividendPaid_str": hybridTotalDividendPaidStr,
    "solution_total_current_cost_str": solutionTotalCurrentCostStr,
    "solution_total_current_value_str": solutionTotalCurrentValueStr,
    "solution_total_unReliasedGain_str": solutionTotalUnReliasedGainStr,
    "solution_total_ReliasedGain_str": solutionTotalReliasedGainStr,
    "solution_total_dividendReinvestment_str": solutionTotalDividendReinvestmentStr,
    "solution_total_dividendPaid_str": solutionTotalDividendPaidStr,
    "other_total_current_cost_str": otherTotalCurrentCostStr,
    "other_total_current_value_str": otherTotalCurrentValueStr,
    "other_total_unReliasedGain_str": otherTotalUnReliasedGainStr,
    "other_total_ReliasedGain_str": otherTotalReliasedGainStr,
    "other_total_dividendReinvestment_str": otherTotalDividendReinvestmentStr,
    "other_total_dividendPaid_str": otherTotalDividendPaidStr,
    "salutation": salutation,
    "cagr_list": cagrList,
    "family_portfolio_return": familyPortfolioReturn,
    "portfolio_day_change_value": portfolioDayChangeValue,
    "portfolio_day_change_percentage": portfolioDayChangePercentage,
    "totalOriginalInvestedAmount_str": totalOriginalInvestedAmountStr,
    "totalSwitchInAmount_str": totalSwitchInAmountStr,
    "totalSwitchOutAmount_str": totalSwitchOutAmountStr,
    "totalRedemptionAmount_str": totalRedemptionAmountStr,
    "totalCurrentcost_str": totalCurrentcostStr,
    "totalCurrentValue_str": totalCurrentValueStr,
    "totalDividendReinvestment_str": totalDividendReinvestmentStr,
    "totalDividendPaid_str": totalDividendPaidStr,
    "totalUnReliasedGain_str": totalUnReliasedGainStr,
    "totalReliasedGain_str": totalReliasedGainStr,
    "totalReliasedGainLoss_str": totalReliasedGainLossStr,
    "equity_list": equityList?.map((x) => x.toJson()).toList(),
    "debt_list": debtList?.map((x) => x.toJson()).toList(),
    "hybrid_list": hybridList?.map((x) => x.toJson()).toList(),
    "solution_list": solutionList?.map((x) => x).toList(),
    "other_list": otherList?.map((x) => x).toList(),
    "mf_oneday_change": mfOnedayChange,
    "totalSipAmount": totalSipAmount,
    "notes": notes,
    "benchmarkStartNav": benchmarkStartNav,
    "benchmarkEndNav": benchmarkEndNav,
    "user_id": userId,
  };
}

class DebtListElement {
  DebtListElement({
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
     this.monthlyAmt,
  });

   String? scheme;
   String? schemeAmfiShortName;
   String? schemeClass;
   String? schemeCode;
   dynamic schemeRegistrar;
   dynamic schemeAmfiCommon;
   String? amcCode;
   dynamic amcName;
   String? foliono;
   dynamic amcLogo;
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
   dynamic investmentReStartDate;
   dynamic lastInvestmentDate;
   dynamic lastTransactionDate;
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
   dynamic averageDays;
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
   dynamic isinNo;
   dynamic schemeAmfiCode;
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
   String? invCostStartDate;
   String? invCostEndDate;
   String? currValueStartDate;
   String? currValueEndDate;
   dynamic sipRowMergedCount;
   num? totalCurrentCostStartDate;
   num? totalCurrentValueStartDate;
   num? totalCurrentCostEndDate;
   num? totalCurrentValueEndDate;
   num? totalPurcahse;
   num? totalRedemption;
   num? totalDivInvest;
   num? totalDivPaid;
   num? totalGainLoss;
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
   dynamic loadFreeUnits;
   dynamic joint1Name;
   dynamic joint1Pan;
   dynamic joint2Name;
   dynamic joint2Pan;
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
   dynamic allocation;
   dynamic xirrList;
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
   dynamic investorSchemeWiseTransactionResponses;
   dynamic familyInvestorSchemeWiseTransactionResponses;
   dynamic transactionList;
   dynamic schemeXirrList;
   dynamic invTransactionList;
   dynamic nseIinNumber;
   dynamic bseClientCode;
   dynamic mfuCanNumber;
   dynamic monthlyAmt;

  factory DebtListElement.fromJson(Map<String, dynamic> json){
    return DebtListElement(
      scheme: json["scheme"],
      schemeAmfiShortName: json["scheme_amfi_short_name"],
      schemeClass: json["scheme_class"],
      schemeCode: json["scheme_code"],
      schemeRegistrar: json["scheme_registrar"],
      schemeAmfiCommon: json["scheme_amfi_common"],
      amcCode: json["amc_code"],
      amcName: json["amc_name"],
      foliono: json["foliono"],
      amcLogo: json["amc_logo"],
      schemeWeight: json["scheme_weight"],
      schemeRating: json["scheme_rating"],
      schemeScore: json["scheme_score"],
      schemeReview: json["scheme_review"],
      schemeBenchmarkName: json["scheme_benchmark_name"],
      schemeBenchmarkCode: json["scheme_benchmark_code"],
      schemeRiskProfile: json["scheme_risk_profile"],
      notes: json["notes"],
      brokerCode: json["broker_code"],
      investmentStartDate: DateTime.tryParse(json["investmentStartDate"] ?? ""),
      investmentReStartDate: json["investmentReStartDate"],
      lastInvestmentDate: json["lastInvestmentDate"],
      lastTransactionDate: json["lastTransactionDate"],
      investmentStartNav: json["investmentStartNav"],
      investmentStartValue: json["investmentStartValue"],
      totalInflow: json["totalInflow"],
      totalOutflow: json["totalOutflow"],
      partialInflow: json["partialInflow"],
      partialOutflow: json["partialOutflow"],
      totalInvestedAmount: json["totalInvestedAmount"],
      totalOriginalInvestedAmount: json["totalOriginalInvestedAmount"],
      totalSwitchInAmount: json["totalSwitchInAmount"],
      totalSwitchOutAmount: json["totalSwitchOutAmount"],
      totalRedemptionAmount: json["totalRedemptionAmount"],
      totalUnits: json["totalUnits"],
      currentCostOfInvestment: json["currentCostOfInvestment"],
      purchaseNav: json["purchaseNav"],
      dividendReinvestment: json["dividendReinvestment"],
      dividendPaid: json["dividendPaid"],
      latestNav: json["latestNav"],
      latestNavDate: DateTime.tryParse(json["latestNavDate"] ?? ""),
      totalCurrentValue: json["totalCurrentValue"],
      unrealisedProfitLoss: json["unrealisedProfitLoss"],
      realisedProfitLoss: json["realisedProfitLoss"],
      realisedGainLoss: json["realisedGainLoss"],
      cagr: json["cagr"],
      totalCagr: json["total_cagr"],
      absoluteReturn: json["absolute_return"],
      totalAbsoluteReturn: json["total_absolute_return"],
      averageDays: json["average_days"],
      isSipScheme: json["isSipScheme"],
      isActiveSipScheme: json["isActiveSipScheme"],
      isDividendScheme: json["isDividendScheme"],
      isDividendDeclared: json["isDividendDeclared"],
      isDividendPayout: json["isDividendPayout"],
      isDividendReinvest: json["isDividendReinvest"],
      isNegativeTransaction: json["isNegativeTransaction"],
      isDeamtAccount: json["isDeamtAccount"],
      goalName: json["goal_name"],
      schemeCompany: json["scheme_company"],
      schemeAdvisorkhojCategory: json["scheme_advisorkhoj_category"],
      isinNo: json["isin_no"],
      schemeAmfiCode: json["scheme_amfi_code"],
      taxCategory: json["tax_category"],
      sipAmount: json["sip_amount"],
      totalSipAmount: json["total_sip_amount"],
      totalSipAmountStr: json["total_sip_amount_str"],
      sipFrequency: json["sip_frequency"],
      totalDividendPaid: json["total_dividend_paid"],
      totalDividendReinvest: json["total_dividend_reinvest"],
      totalDividendPaidCurrentFy: json["total_dividend_paid_current_fy"],
      totalDividendReinvestCurrentFy: json["total_dividend_reinvest_current_fy"],
      isStpInScheme: json["isStpInScheme"],
      isStpOutScheme: json["isStpOutScheme"],
      isActiveStpScheme: json["isActiveStpScheme"],
      stpAmount: json["stp_amount"],
      isSwpScheme: json["isSwpScheme"],
      isActiveSwpScheme: json["isActiveSwpScheme"],
      swpAmount: json["swp_amount"],
      userId: json["user_id"],
      investorName: json["investorName"],
      investorPan: json["investorPan"],
      investorBranch: json["investor_branch"],
      investorRmName: json["investor_rm_name"],
      investorSubbrokerName: json["investor_subbroker_name"],
      isManualEntry: json["isManualEntry"],
      accHolderName: json["acc_holder_name"],
      bankName: json["bank_name"],
      bankBranchName: json["bank_branch_name"],
      invCostStartDate: json["invCostStartDate"],
      invCostEndDate: json["invCostEndDate"],
      currValueStartDate: json["currValueStartDate"],
      currValueEndDate: json["currValueEndDate"],
      sipRowMergedCount: json["sip_row_merged_count"],
      totalCurrentCostStartDate: json["total_current_cost_start_date"],
      totalCurrentValueStartDate: json["total_current_value_start_date"],
      totalCurrentCostEndDate: json["total_current_cost_end_date"],
      totalCurrentValueEndDate: json["total_current_value_end_date"],
      totalPurcahse: json["total_purcahse"],
      totalRedemption: json["total_redemption"],
      totalDivInvest: json["total_div_invest"],
      totalDivPaid: json["total_div_paid"],
      totalGainLoss: json["total_gain_loss"],
      totalAbsReturn: json["total_abs_return"],
      schemeDatesArray: json["scheme_dates_array"],
      schemeAmountArray: json["scheme_amount_array"],
      sensex: json["sensex"],
      shortTermUnits: json["short_term_units"],
      shortTermAmount: json["short_term_amount"],
      longTermUnits: json["long_term_units"],
      longTermAmount: json["long_term_amount"],
      notionalUnits: json["notional_units"],
      notionalAmount: json["notional_amount"],
      prevLatestNav: json["prev_latestNav"],
      dayChangeValue: json["day_change_value"],
      dayChangePercentage: json["day_change_percentage"],
      loadFreeUnits: json["loadFreeUnits"],
      joint1Name: json["joint1_name"],
      joint1Pan: json["joint1_pan"],
      joint2Name: json["joint2_name"],
      joint2Pan: json["joint2_pan"],
      taxStatus: json["tax_status"],
      holdingNature: json["holding_nature"],
      nominee1Name: json["nominee1_name"],
      nominee1Relation: json["nominee1_relation"],
      nominee1Percentage: json["nominee1_percentage"],
      nominee2Name: json["nominee2_name"],
      nominee2Relation: json["nominee2_relation"],
      nominee2Percentage: json["nominee2_percentage"],
      nominee3Name: json["nominee3_name"],
      nominee3Relation: json["nominee3_relation"],
      nominee3Percentage: json["nominee3_percentage"],
      allocation: json["allocation"],
      xirrList: json["xirr_list"],
      folioList: json["folio_list"],
      currentNav: json["currentNav"],
      currentNavDate: json["currentNavDate"],
      schemePan: json["scheme_pan"],
      arnNumber: json["arn_number"],
      schemeBenchmarkFlag: json["scheme_benchmark_flag"],
      benchmarkName: json["benchmark_name"],
      benchmarkCode: json["benchmark_code"],
      benchmarkCurrentCostOfInvestment: json["benchmark_currentCostOfInvestment"],
      benchmarkTotalCurrentValue: json["benchmark_totalCurrentValue"],
      benchmarkAbsoluteReturn: json["benchmark_absolute_return"],
      benchmarkCagr: json["benchmark_cagr"],
      totalOriginalInvestedAmountStr: json["totalOriginalInvestedAmount_str"],
      totalSwitchInAmountStr: json["totalSwitchInAmount_str"],
      totalSwitchOutAmountStr: json["totalSwitchOutAmount_str"],
      totalRedemptionAmountStr: json["totalRedemptionAmount_str"],
      currentCostOfInvestmentStr: json["currentCostOfInvestment_str"],
      totalCurrentValueStr: json["totalCurrentValue_str"],
      unrealisedProfitLossStr: json["unrealisedProfitLoss_str"],
      realisedProfitLossStr: json["realisedProfitLoss_str"],
      realisedGainLossStr: json["realisedGainLoss_str"],
      totalDividendReinvestStr: json["total_dividend_reinvest_str"],
      totalDividendPaidStr: json["total_dividend_paid_str"],
      totalUnitsStr: json["totalUnits_str"],
      purchaseNavStr: json["purchaseNav_str"],
      latestNavStr: json["latestNav_str"],
      investmentStartDateStr: json["investmentStartDate_str"],
      investmentReStartDateStr: json["investmentReStartDate_str"],
      latestNavDateStr: json["latestNavDate_str"],
      currentNavStr: json["currentNav_str"],
      longTermUnitsStr: json["long_term_units_str"],
      longTermAmountStr: json["long_term_amount_str"],
      totalInflowStr: json["totalInflow_str"],
      totalOutflowStr: json["totalOutflow_str"],
      invCostStartDateStr: json["invCostStartDate_str"],
      invCostEndDateStr: json["invCostEndDate_str"],
      currValueStartDateStr: json["currValueStartDate_str"],
      currValueEndDateStr: json["currValueEndDate_str"],
      benchmarkTotalCurrentValueStr: json["benchmark_totalCurrentValue_str"],
      schemeBankDetails: json["scheme_bank_details"],
      tagName: json["tag_name"],
      investorSchemeWiseTransactionResponses: json["investorSchemeWiseTransactionResponses"],
      familyInvestorSchemeWiseTransactionResponses: json["familyInvestorSchemeWiseTransactionResponses"],
      transactionList: json["transaction_list"],
      schemeXirrList: json["scheme_xirr_list"],
      invTransactionList: json["inv_transaction_list"],
      nseIinNumber: json["nse_iin_number"],
      bseClientCode: json["bse_client_code"],
      mfuCanNumber: json["mfu_can_number"],
      monthlyAmt: json["monthly_amt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "scheme": scheme,
    "scheme_amfi_short_name": schemeAmfiShortName,
    "scheme_class": schemeClass,
    "scheme_code": schemeCode,
    "scheme_registrar": schemeRegistrar,
    "scheme_amfi_common": schemeAmfiCommon,
    "amc_code": amcCode,
    "amc_name": amcName,
    "foliono": foliono,
    "amc_logo": amcLogo,
    "scheme_weight": schemeWeight,
    "scheme_rating": schemeRating,
    "scheme_score": schemeScore,
    "scheme_review": schemeReview,
    "scheme_benchmark_name": schemeBenchmarkName,
    "scheme_benchmark_code": schemeBenchmarkCode,
    "scheme_risk_profile": schemeRiskProfile,
    "notes": notes,
    "broker_code": brokerCode,
    "investmentStartDate": investmentStartDate?.toIso8601String(),
    "investmentReStartDate": investmentReStartDate,
    "lastInvestmentDate": lastInvestmentDate,
    "lastTransactionDate": lastTransactionDate,
    "investmentStartNav": investmentStartNav,
    "investmentStartValue": investmentStartValue,
    "totalInflow": totalInflow,
    "totalOutflow": totalOutflow,
    "partialInflow": partialInflow,
    "partialOutflow": partialOutflow,
    "totalInvestedAmount": totalInvestedAmount,
    "totalOriginalInvestedAmount": totalOriginalInvestedAmount,
    "totalSwitchInAmount": totalSwitchInAmount,
    "totalSwitchOutAmount": totalSwitchOutAmount,
    "totalRedemptionAmount": totalRedemptionAmount,
    "totalUnits": totalUnits,
    "currentCostOfInvestment": currentCostOfInvestment,
    "purchaseNav": purchaseNav,
    "dividendReinvestment": dividendReinvestment,
    "dividendPaid": dividendPaid,
    "latestNav": latestNav,
    "latestNavDate": latestNavDate?.toIso8601String(),
    "totalCurrentValue": totalCurrentValue,
    "unrealisedProfitLoss": unrealisedProfitLoss,
    "realisedProfitLoss": realisedProfitLoss,
    "realisedGainLoss": realisedGainLoss,
    "cagr": cagr,
    "total_cagr": totalCagr,
    "absolute_return": absoluteReturn,
    "total_absolute_return": totalAbsoluteReturn,
    "average_days": averageDays,
    "isSipScheme": isSipScheme,
    "isActiveSipScheme": isActiveSipScheme,
    "isDividendScheme": isDividendScheme,
    "isDividendDeclared": isDividendDeclared,
    "isDividendPayout": isDividendPayout,
    "isDividendReinvest": isDividendReinvest,
    "isNegativeTransaction": isNegativeTransaction,
    "isDeamtAccount": isDeamtAccount,
    "goal_name": goalName,
    "scheme_company": schemeCompany,
    "scheme_advisorkhoj_category": schemeAdvisorkhojCategory,
    "isin_no": isinNo,
    "scheme_amfi_code": schemeAmfiCode,
    "tax_category": taxCategory,
    "sip_amount": sipAmount,
    "total_sip_amount": totalSipAmount,
    "total_sip_amount_str": totalSipAmountStr,
    "sip_frequency": sipFrequency,
    "total_dividend_paid": totalDividendPaid,
    "total_dividend_reinvest": totalDividendReinvest,
    "total_dividend_paid_current_fy": totalDividendPaidCurrentFy,
    "total_dividend_reinvest_current_fy": totalDividendReinvestCurrentFy,
    "isStpInScheme": isStpInScheme,
    "isStpOutScheme": isStpOutScheme,
    "isActiveStpScheme": isActiveStpScheme,
    "stp_amount": stpAmount,
    "isSwpScheme": isSwpScheme,
    "isActiveSwpScheme": isActiveSwpScheme,
    "swp_amount": swpAmount,
    "user_id": userId,
    "investorName": investorName,
    "investorPan": investorPan,
    "investor_branch": investorBranch,
    "investor_rm_name": investorRmName,
    "investor_subbroker_name": investorSubbrokerName,
    "isManualEntry": isManualEntry,
    "acc_holder_name": accHolderName,
    "bank_name": bankName,
    "bank_branch_name": bankBranchName,
    "invCostStartDate": invCostStartDate,
    "invCostEndDate": invCostEndDate,
    "currValueStartDate": currValueStartDate,
    "currValueEndDate": currValueEndDate,
    "sip_row_merged_count": sipRowMergedCount,
    "total_current_cost_start_date": totalCurrentCostStartDate,
    "total_current_value_start_date": totalCurrentValueStartDate,
    "total_current_cost_end_date": totalCurrentCostEndDate,
    "total_current_value_end_date": totalCurrentValueEndDate,
    "total_purcahse": totalPurcahse,
    "total_redemption": totalRedemption,
    "total_div_invest": totalDivInvest,
    "total_div_paid": totalDivPaid,
    "total_gain_loss": totalGainLoss,
    "total_abs_return": totalAbsReturn,
    "scheme_dates_array": schemeDatesArray,
    "scheme_amount_array": schemeAmountArray,
    "sensex": sensex,
    "short_term_units": shortTermUnits,
    "short_term_amount": shortTermAmount,
    "long_term_units": longTermUnits,
    "long_term_amount": longTermAmount,
    "notional_units": notionalUnits,
    "notional_amount": notionalAmount,
    "prev_latestNav": prevLatestNav,
    "day_change_value": dayChangeValue,
    "day_change_percentage": dayChangePercentage,
    "loadFreeUnits": loadFreeUnits,
    "joint1_name": joint1Name,
    "joint1_pan": joint1Pan,
    "joint2_name": joint2Name,
    "joint2_pan": joint2Pan,
    "tax_status": taxStatus,
    "holding_nature": holdingNature,
    "nominee1_name": nominee1Name,
    "nominee1_relation": nominee1Relation,
    "nominee1_percentage": nominee1Percentage,
    "nominee2_name": nominee2Name,
    "nominee2_relation": nominee2Relation,
    "nominee2_percentage": nominee2Percentage,
    "nominee3_name": nominee3Name,
    "nominee3_relation": nominee3Relation,
    "nominee3_percentage": nominee3Percentage,
    "allocation": allocation,
    "xirr_list": xirrList,
    "folio_list": folioList,
    "currentNav": currentNav,
    "currentNavDate": currentNavDate,
    "scheme_pan": schemePan,
    "arn_number": arnNumber,
    "scheme_benchmark_flag": schemeBenchmarkFlag,
    "benchmark_name": benchmarkName,
    "benchmark_code": benchmarkCode,
    "benchmark_currentCostOfInvestment": benchmarkCurrentCostOfInvestment,
    "benchmark_totalCurrentValue": benchmarkTotalCurrentValue,
    "benchmark_absolute_return": benchmarkAbsoluteReturn,
    "benchmark_cagr": benchmarkCagr,
    "totalOriginalInvestedAmount_str": totalOriginalInvestedAmountStr,
    "totalSwitchInAmount_str": totalSwitchInAmountStr,
    "totalSwitchOutAmount_str": totalSwitchOutAmountStr,
    "totalRedemptionAmount_str": totalRedemptionAmountStr,
    "currentCostOfInvestment_str": currentCostOfInvestmentStr,
    "totalCurrentValue_str": totalCurrentValueStr,
    "unrealisedProfitLoss_str": unrealisedProfitLossStr,
    "realisedProfitLoss_str": realisedProfitLossStr,
    "realisedGainLoss_str": realisedGainLossStr,
    "total_dividend_reinvest_str": totalDividendReinvestStr,
    "total_dividend_paid_str": totalDividendPaidStr,
    "totalUnits_str": totalUnitsStr,
    "purchaseNav_str": purchaseNavStr,
    "latestNav_str": latestNavStr,
    "investmentStartDate_str": investmentStartDateStr,
    "investmentReStartDate_str": investmentReStartDateStr,
    "latestNavDate_str": latestNavDateStr,
    "currentNav_str": currentNavStr,
    "long_term_units_str": longTermUnitsStr,
    "long_term_amount_str": longTermAmountStr,
    "totalInflow_str": totalInflowStr,
    "totalOutflow_str": totalOutflowStr,
    "invCostStartDate_str": invCostStartDateStr,
    "invCostEndDate_str": invCostEndDateStr,
    "currValueStartDate_str": currValueStartDateStr,
    "currValueEndDate_str": currValueEndDateStr,
    "benchmark_totalCurrentValue_str": benchmarkTotalCurrentValueStr,
    "scheme_bank_details": schemeBankDetails,
    "tag_name": tagName,
    "investorSchemeWiseTransactionResponses": investorSchemeWiseTransactionResponses,
    "familyInvestorSchemeWiseTransactionResponses": familyInvestorSchemeWiseTransactionResponses,
    "transaction_list": transactionList,
    "scheme_xirr_list": schemeXirrList,
    "inv_transaction_list": invTransactionList,
    "nse_iin_number": nseIinNumber,
    "bse_client_code": bseClientCode,
    "mfu_can_number": mfuCanNumber,
    "monthly_amt": monthlyAmt,
  };
}
