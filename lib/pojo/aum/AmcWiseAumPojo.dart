class AmcWiseAumPojo {
  int? id;
  String? companyCode;
  String? companyName;
  String? aumYear;
  String? aumMonth;
  String? aumMonthStr;
  String? financialYear;
  String? financialDate;
  num? aumAmount;
  String? clientName;
  String? brokerCode;
  String? createdDate;
  String? aumAmountStr;
  String? aumPercentage;
  String? amcLogo;
  String? amcShortName;
  String? amcName;
  num? aumCurrentCost;

  AmcWiseAumPojo({
    this.id,
    this.companyCode,
    this.companyName,
    this.aumYear,
    this.aumMonth,
    this.aumMonthStr,
    this.financialYear,
    this.financialDate,
    this.aumAmount,
    this.clientName,
    this.brokerCode,
    this.createdDate,
    this.aumAmountStr,
    this.aumPercentage,
    this.amcLogo,
    this.amcShortName,
    this.amcName,
    this.aumCurrentCost,
  });

  AmcWiseAumPojo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyCode = json['company_code'];
    companyName = json['company_name'];
    aumYear = json['aum_year'];
    aumMonth = json['aum_month'];
    aumMonthStr = json['aum_month_str'];
    financialYear = json['financial_year'];
    financialDate = json['financial_date'];
    aumAmount = json['aum_amount'];
    clientName = json['client_name'];
    brokerCode = json['broker_code'];
    createdDate = json['created_date'];
    aumAmountStr = json['aum_amount_str'];
    aumPercentage = json['aum_percentage'];
    amcLogo = json['amc_logo'];
    amcShortName = json['amc_short_name'];
    amcName = json['amc_name'];
    aumCurrentCost = json['aum_current_cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_code'] = companyCode;
    data['company_name'] = companyName;
    data['aum_year'] = aumYear;
    data['aum_month'] = aumMonth;
    data['aum_month_str'] = aumMonthStr;
    data['financial_year'] = financialYear;
    data['financial_date'] = financialDate;
    data['aum_amount'] = aumAmount;
    data['client_name'] = clientName;
    data['broker_code'] = brokerCode;
    data['created_date'] = createdDate;
    data['aum_amount_str'] = aumAmountStr;
    data['aum_percentage'] = aumPercentage;
    data['amc_logo'] = amcLogo;
    data['amc_short_name'] = amcShortName;
    data['amc_name'] = amcName;
    data['aum_current_cost'] = aumCurrentCost;
    return data;
  }
}
