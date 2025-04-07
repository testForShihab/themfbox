class MfSchemeSummaryPojo {
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
  num? units;
  num? unrealisedProfitLoss;
  num? realisedProfitLoss;
  num? realisedGainLoss;
  num? absoluteReturn;
  num? xirr;
  bool? isSip;
  double? dayChangeValue;
  double? dayChangePercentage;
  bool? isManualEntry;

  MfSchemeSummaryPojo({
    this.schemeAmfi,
    this.schemeAmfiShortName,
    this.schemeAmc,
    this.schemeAmcLogo,
    this.schemeBroadCategory,
    this.schemeCategory,
    this.folio,
    this.currCost,
    this.currValue,
    this.xirr,
    this.schemeAmfiCode,
    this.realisedGainLoss,
    this.unrealisedProfitLoss,
    this.absoluteReturn,
    this.units,
    this.isSip,
    this.brokerCode,
    this.schemeAmcCode,
    this.dayChangeValue,
    this.dayChangePercentage,
    this.isManualEntry,
  });

  MfSchemeSummaryPojo.fromJson(Map<String, dynamic> json) {
    schemeAmfi = json['scheme_amfi'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeAmc = json['scheme_amc'];
    schemeAmcLogo = json['scheme_amc_logo'];
    schemeBroadCategory = json['scheme_broad_category'];
    schemeCategory = json['scheme_category'];
    folio = json['folio'];
    currCost = json['curr_cost'];
    currValue = json['curr_value'];
    xirr = json['xirr'];
    schemeAmfiCode = json['scheme_amfi_code'];
    realisedGainLoss = json['realisedGainLoss'];
    unrealisedProfitLoss = json['unrealisedProfitLoss'];
    absoluteReturn = json['absolute_return'];
    units = json['units'];
    isSip = json['isSip'];
    brokerCode = json['broker_code'];
    schemeAmcCode = json['scheme_amc_code'];
    dayChangeValue = json['day_change_value'];
    dayChangePercentage = json['day_change_percentage'];
    isManualEntry = json['isManualEntry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scheme_amfi'] = schemeAmfi;
    data['scheme_amfi_short_name'] = schemeAmfiShortName;
    data['scheme_amc'] = schemeAmc;
    data['scheme_amc_logo'] = schemeAmcLogo;
    data['scheme_broad_category'] = schemeBroadCategory;
    data['scheme_category'] = schemeCategory;
    data['folio'] = folio;
    data['curr_cost'] = currCost;
    data['curr_value'] = currValue;
    data['xirr'] = xirr;
    data['scheme_amfi_code'] = schemeAmfiCode;
    data['realisedGainLoss'] = realisedGainLoss;
    data['unrealisedProfitLoss'] = unrealisedProfitLoss;
    data['absolute_return'] = absoluteReturn;
    data['units'] = units;
    data['isSip'] = isSip;
    data['broker_code'] = brokerCode;
    data['scheme_amc_code'] = schemeAmcCode;
    data['day_change_value'] = this.dayChangeValue;
    data['day_change_percentage'] = this.dayChangePercentage;
    data['isManualEntry'] = this.isManualEntry;
    return data;
  }
}
