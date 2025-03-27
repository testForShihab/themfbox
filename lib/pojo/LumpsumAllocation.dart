class LumpsumAllocationPojo {
  String? schemeCompany;
  String? schemeAmfi;
  String? schemeAmfiShortName;
  String? logo;
  String? schemeBroadCategory;
  String? amfiCategory;
  String? riskometer;
  num? percentage;
  num? amount;
  num? catAvg;
  num? yr1Return;
  num? yr3Return;
  num? yr5Return;
  num? futureValue;
  num? investedAmount;

  LumpsumAllocationPojo({
    this.schemeCompany,
    this.schemeAmfi,
    this.schemeAmfiShortName,
    this.logo,
    this.schemeBroadCategory,
    this.amfiCategory,
    this.riskometer,
    this.percentage,
    this.amount,
    this.catAvg,
    this.yr1Return,
    this.yr3Return,
    this.yr5Return,
    this.futureValue,
    this.investedAmount,
  });

  LumpsumAllocationPojo.fromJson(Map<String, dynamic> json) {
    schemeCompany = json['scheme_company'];
    schemeAmfi = json['scheme_amfi'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    logo = json['logo'];
    schemeBroadCategory = json['scheme_broad_category'];
    amfiCategory = json['amfi_category'];
    riskometer = json['riskometer'];
    percentage = json['percentage'];
    amount = json['amount'];
    catAvg = json['cat_avg'];
    yr1Return = json['yr1_return'];
    yr3Return = json['yr3_return'];
    yr5Return = json['yr5_return'];
    futureValue = json['future_value'];
    investedAmount = json['invested_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scheme_company'] = schemeCompany;
    data['scheme_amfi'] = schemeAmfi;
    data['scheme_amfi_short_name'] = schemeAmfiShortName;
    data['logo'] = logo;
    data['scheme_broad_category'] = schemeBroadCategory;
    data['amfi_category'] = amfiCategory;
    data['riskometer'] = riskometer;
    data['percentage'] = percentage;
    data['amount'] = amount;
    data['cat_avg'] = catAvg;
    data['yr1_return'] = yr1Return;
    data['yr3_return'] = yr3Return;
    data['yr5_return'] = yr5Return;
    data['future_value'] = futureValue;
    data['invested_amount'] = investedAmount;
    return data;
  }
}
