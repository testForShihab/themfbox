class SchemeWiseAumPojo {
  String? schemeName;
  String? schemeAmfiShortName;
  String? schemeAmfiCode;
  String? amcName;
  String? schemeBroadCategory;
  String? schemeSubCategory;
  num? marketValue;
  String? logo;
  num? returns;
  String? riskometer;

  SchemeWiseAumPojo(
      {this.schemeName,
      this.schemeAmfiShortName,
      this.schemeAmfiCode,
      this.amcName,
      this.schemeBroadCategory,
      this.schemeSubCategory,
      this.marketValue,
      this.logo,
      this.returns,
      this.riskometer});

  SchemeWiseAumPojo.fromJson(Map<String, dynamic> json) {
    schemeName = json['scheme_name'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeAmfiCode = json['scheme_amfi_code'];
    amcName = json['amc_name'];
    schemeBroadCategory = json['scheme_broad_category'];
    schemeSubCategory = json['scheme_sub_category'];
    marketValue = json['market_value'];
    logo = json['logo'];
    returns = json['returns'];
    riskometer = json['riskometer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scheme_name'] = schemeName;
    data['scheme_amfi_short_name'] = schemeAmfiShortName;
    data['scheme_amfi_code'] = schemeAmfiCode;
    data['amc_name'] = amcName;
    data['scheme_broad_category'] = schemeBroadCategory;
    data['scheme_sub_category'] = schemeSubCategory;
    data['market_value'] = marketValue;
    data['logo'] = logo;
    data['returns'] = returns;
    data['riskometer'] = riskometer;
    return data;
  }
}
