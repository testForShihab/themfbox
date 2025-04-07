class FamilyCurrentPortfolioPojo {
  num? status;
  String? statusMsg;
  String? msg;
  MfSummary? mfSummary;
  SipSummary? sipSummary;
  List<MfSchemeSummary>? mfSchemeSummary;
  List<SipSchemeSummaryPojo>? sipSchemeSummary;

  FamilyCurrentPortfolioPojo(
      {this.status,
        this.statusMsg,
        this.msg,
        this.mfSummary,
        this.sipSummary,
        this.mfSchemeSummary,
        this.sipSchemeSummary});

  FamilyCurrentPortfolioPojo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    mfSummary = json['mf_summary'] != null
        ? new MfSummary.fromJson(json['mf_summary'])
        : null;
    sipSummary = json['sip_summary'] != null
        ? new SipSummary.fromJson(json['sip_summary'])
        : null;
    if (json['mf_scheme_summary'] != null) {
      mfSchemeSummary = <MfSchemeSummary>[];
      json['mf_scheme_summary'].forEach((v) {
        mfSchemeSummary!.add(new MfSchemeSummary.fromJson(v));
      });
    }
    if (json['sip_scheme_summary'] != null) {
      sipSchemeSummary = <SipSchemeSummaryPojo>[];
      json['sip_scheme_summary'].forEach((v) {
        sipSchemeSummary!.add(new SipSchemeSummaryPojo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_msg'] = this.statusMsg;
    data['msg'] = this.msg;
    if (this.mfSummary != null) {
      data['mf_summary'] = this.mfSummary!.toJson();
    }
    if (this.sipSummary != null) {
      data['sip_summary'] = this.sipSummary!.toJson();
    }
    if (this.mfSchemeSummary != null) {
      data['mf_scheme_summary'] =
          this.mfSchemeSummary!.map((v) => v.toJson()).toList();
    }
    if (this.sipSchemeSummary != null) {
      data['sip_scheme_summary'] =
          this.sipSchemeSummary!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MfSummary {
  num? totalCurrCost;
  num? totalCurrValue;
  num? totalDivReinv;
  num? totalDivPaid;
  num? totalUnrealisedGain;
  num? totalRealisedGain;
  num? totalAbsRtn;
  num? totalXirr;
  num? dayChangeValue;
  num? dayChangePercentage;

  MfSummary(
      {this.totalCurrCost,
        this.totalCurrValue,
        this.totalDivReinv,
        this.totalDivPaid,
        this.totalUnrealisedGain,
        this.totalRealisedGain,
        this.totalAbsRtn,
        this.totalXirr,
        this.dayChangeValue,
        this.dayChangePercentage});

  MfSummary.fromJson(Map<String, dynamic> json) {
    totalCurrCost = json['total_curr_cost'];
    totalCurrValue = json['total_curr_value'];
    totalDivReinv = json['total_div_reinv'];
    totalDivPaid = json['total_div_paid'];
    totalUnrealisedGain = json['total_unrealised_gain'];
    totalRealisedGain = json['total_realised_gain'];
    totalAbsRtn = json['total_abs_rtn'];
    totalXirr = json['total_xirr'];
    dayChangeValue = json['day_change_value'];
    dayChangePercentage = json['day_change_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_curr_cost'] = this.totalCurrCost;
    data['total_curr_value'] = this.totalCurrValue;
    data['total_div_reinv'] = this.totalDivReinv;
    data['total_div_paid'] = this.totalDivPaid;
    data['total_unrealised_gain'] = this.totalUnrealisedGain;
    data['total_realised_gain'] = this.totalRealisedGain;
    data['total_abs_rtn'] = this.totalAbsRtn;
    data['total_xirr'] = this.totalXirr;
    data['day_change_value'] = this.dayChangeValue;
    data['day_change_percentage'] = this.dayChangePercentage;
    return data;
  }
}

class SipSummary {
  num? sipCurrValue;
  num? sipCurrCost;
  num? sipAmount;
  num? sipCount;
  num? sipXirr;
  num? sipDayChangeAmount;
  num? sipDayChangePercentage;
  num? sipGainLoss;

  SipSummary(
      {this.sipCurrValue,
        this.sipCurrCost,
        this.sipAmount,
        this.sipCount,
        this.sipXirr,
        this.sipDayChangeAmount,
        this.sipDayChangePercentage,
        this.sipGainLoss});

  SipSummary.fromJson(Map<String, dynamic> json) {
    sipCurrValue = json['sip_curr_value'];
    sipCurrCost = json['sip_curr_cost'];
    sipAmount = json['sip_amount'];
    sipCount = json['sip_count'];
    sipXirr = json['sip_xirr'];
    sipDayChangeAmount = json['sip_day_change_amount'];
    sipDayChangePercentage = json['sip_day_change_percentage'];
    sipGainLoss = json['sip_gain_loss'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sip_curr_value'] = this.sipCurrValue;
    data['sip_curr_cost'] = this.sipCurrCost;
    data['sip_amount'] = this.sipAmount;
    data['sip_count'] = this.sipCount;
    data['sip_xirr'] = this.sipXirr;
    data['sip_day_change_amount'] = this.sipDayChangeAmount;
    data['sip_day_change_percentage'] = this.sipDayChangePercentage;
    data['sip_gain_loss'] = this.sipGainLoss;
    return data;
  }
}

class MfSchemeSummary{
  num? userId;
  String? investorName;
  String? pan;
  String? salutation;
  String? familyStatus;
  num? currentCost;
  num? currentValue;
  num? unrealisedGain;
  num? realisedGain;
  double? absRtn;
  double? xirr;
  List<SchemeList>? schemeList;

  MfSchemeSummary(
      {this.userId,
        this.investorName,
        this.pan,
        this.salutation,
        this.familyStatus,
        this.currentCost,
        this.currentValue,
        this.unrealisedGain,
        this.realisedGain,
        this.absRtn,
        this.xirr,
        this.schemeList});

  MfSchemeSummary.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    investorName = json['investor_name'];
    pan = json['pan'];
    salutation = json['salutation'];
    familyStatus = json['family_status'];
    currentCost = json['current_cost'];
    currentValue = json['current_value'];
    unrealisedGain = json['unrealised_gain'];
    realisedGain = json['realised_gain'];
    absRtn = json['abs_rtn'];
    xirr = json['xirr'];
    if (json['scheme_list'] != null) {
      schemeList = <SchemeList>[];
      json['scheme_list'].forEach((v) {
        schemeList!.add(new SchemeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['investor_name'] = this.investorName;
    data['pan'] = this.pan;
    data['salutation'] = this.salutation;
    data['family_status'] = this.familyStatus;
    data['current_cost'] = this.currentCost;
    data['current_value'] = this.currentValue;
    data['unrealised_gain'] = this.unrealisedGain;
    data['realised_gain'] = this.realisedGain;
    data['abs_rtn'] = this.absRtn;
    data['xirr'] = this.xirr;
    if (this.schemeList != null) {
      data['scheme_list'] = this.schemeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class SipSchemeSummaryPojo {
  num? userId;
  String? investorName;
  String? pan;
  String? salutation;
  String? familyStatus;
  num? sipAmount;
  num? currentCost;
  num? currentValue;
  num? unrealisedGain;
  num? realisedGain;
  double? absRtn;
  double? xirr;
  List<SchemeList>? schemeList;

  SipSchemeSummaryPojo(
      {this.userId,
        this.investorName,
        this.pan,
        this.salutation,
        this.familyStatus,
        this.sipAmount,
        this.currentCost,
        this.currentValue,
        this.unrealisedGain,
        this.realisedGain,
        this.absRtn,
        this.xirr,
        this.schemeList});

  SipSchemeSummaryPojo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    investorName = json['investor_name'];
    pan = json['pan'];
    salutation = json['salutation'];
    familyStatus = json['family_status'];
    sipAmount = json['sip_amount'];
    currentCost = json['current_cost'];
    currentValue = json['current_value'];
    unrealisedGain = json['unrealised_gain'];
    realisedGain = json['realised_gain'];
    absRtn = json['abs_rtn'];
    xirr = json['xirr'];
    if (json['scheme_list'] != null) {
      schemeList = <SchemeList>[];
      json['scheme_list'].forEach((v) {
        schemeList!.add(new SchemeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['investor_name'] = this.investorName;
    data['pan'] = this.pan;
    data['salutation'] = this.salutation;
    data['family_status'] = this.familyStatus;
    data['sip_amount'] = this.sipAmount;
    data['current_cost'] = this.currentCost;
    data['current_value'] = this.currentValue;
    data['unrealised_gain'] = this.unrealisedGain;
    data['realised_gain'] = this.realisedGain;
    data['abs_rtn'] = this.absRtn;
    data['xirr'] = this.xirr;
    if (this.schemeList != null) {
      data['scheme_list'] = this.schemeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class SchemeList {
  String? schemeAmfi;
  String? schemeAmfiCode;
  String? schemeAmfiShortName;
  String? schemeAmc;
  String? schemeAmcCode;
  String? schemeAmcLogo;
  String? schemeBroadCategory;
  String? schemeCategory;
  String? folio;
  String? brokerCode;
  num? currCost;
  num? currValue;
  double? units;
  num? unrealisedProfitLoss;
  num? realisedProfitLoss;
  num? realisedGainLoss;
  double? dayChangeValue;
  double? dayChangePercentage;
  double? absoluteReturn;
  double? xirr;
  bool? isSip;

  SchemeList(
      {this.schemeAmfi,
        this.schemeAmfiCode,
        this.schemeAmfiShortName,
        this.schemeAmc,
        this.schemeAmcCode,
        this.schemeAmcLogo,
        this.schemeBroadCategory,
        this.schemeCategory,
        this.folio,
        this.brokerCode,
        this.currCost,
        this.currValue,
        this.units,
        this.unrealisedProfitLoss,
        this.realisedProfitLoss,
        this.realisedGainLoss,
        this.dayChangeValue,
        this.dayChangePercentage,
        this.absoluteReturn,
        this.xirr,
        this.isSip});

  SchemeList.fromJson(Map<String, dynamic> json) {
    schemeAmfi = json['scheme_amfi'];
    schemeAmfiCode = json['scheme_amfi_code'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeAmc = json['scheme_amc'];
    schemeAmcCode = json['scheme_amc_code'];
    schemeAmcLogo = json['scheme_amc_logo'];
    schemeBroadCategory = json['scheme_broad_category'];
    schemeCategory = json['scheme_category'];
    folio = json['folio'];
    brokerCode = json['broker_code'];
    currCost = json['curr_cost'];
    currValue = json['curr_value'];
    units = json['units'];
    unrealisedProfitLoss = json['unrealisedProfitLoss'];
    realisedProfitLoss = json['realisedProfitLoss'];
    realisedGainLoss = json['realisedGainLoss'];
    dayChangeValue = json['day_change_value'];
    dayChangePercentage = json['day_change_percentage'];
    absoluteReturn = json['absolute_return'];
    xirr = json['xirr'];
    isSip = json['isSip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheme_amfi'] = this.schemeAmfi;
    data['scheme_amfi_code'] = this.schemeAmfiCode;
    data['scheme_amfi_short_name'] = this.schemeAmfiShortName;
    data['scheme_amc'] = this.schemeAmc;
    data['scheme_amc_code'] = this.schemeAmcCode;
    data['scheme_amc_logo'] = this.schemeAmcLogo;
    data['scheme_broad_category'] = this.schemeBroadCategory;
    data['scheme_category'] = this.schemeCategory;
    data['folio'] = this.folio;
    data['broker_code'] = this.brokerCode;
    data['curr_cost'] = this.currCost;
    data['curr_value'] = this.currValue;
    data['units'] = this.units;
    data['unrealisedProfitLoss'] = this.unrealisedProfitLoss;
    data['realisedProfitLoss'] = this.realisedProfitLoss;
    data['realisedGainLoss'] = this.realisedGainLoss;
    data['day_change_value'] = this.dayChangeValue;
    data['day_change_percentage'] = this.dayChangePercentage;
    data['absolute_return'] = this.absoluteReturn;
    data['xirr'] = this.xirr;
    data['isSip'] = this.isSip;
    return data;
  }
}


