class AllLumpsumFundsPojo {
  String? schemeAmfi;
  String? schemeAmfiShortName;
  String? schemeCategory;
  String? schemeCompany;
  num? schemeAssets;
  String? logo;
  String? schemeRating;
  num? returnsAbs;
  num? ter;
  num? returnsAbsRank;
  num? returnsAbsTotalrank;
  String? doubleIn;
  num? currentValue;
  String? schemeInceptionDate;
  num? investedAmount;

  AllLumpsumFundsPojo({
    this.schemeAmfi,
    this.schemeAmfiShortName,
    this.schemeCategory,
    this.schemeCompany,
    this.schemeAssets,
    this.logo,
    this.schemeRating,
    this.returnsAbs,
    this.ter,
    this.returnsAbsRank,
    this.returnsAbsTotalrank,
    this.doubleIn,
    this.currentValue,
    this.schemeInceptionDate,
    this.investedAmount,
  });

  AllLumpsumFundsPojo.fromJson(Map<String, dynamic> json) {
    schemeAmfi = json['scheme_amfi'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeCategory = json['scheme_category'];
    schemeCompany = json['scheme_company'];
    schemeAssets = json['scheme_assets'];
    logo = json['logo'];
    schemeRating = json['scheme_rating'];
    returnsAbs = json['returns_abs'];
    ter = json['ter'];
    returnsAbsRank = json['returns_abs_rank'];
    returnsAbsTotalrank = json['returns_abs_totalrank'];
    doubleIn = json['double_in'];
    currentValue = json['current_value'];
    schemeInceptionDate = json['scheme_inception_date'];
    investedAmount = json['invested_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scheme_amfi'] = schemeAmfi;
    data['scheme_amfi_short_name'] = schemeAmfiShortName;
    data['scheme_category'] = schemeCategory;
    data['scheme_company'] = schemeCompany;
    data['scheme_assets'] = schemeAssets;
    data['logo'] = logo;
    data['scheme_rating'] = schemeRating;
    data['returns_abs'] = returnsAbs;
    data['ter'] = ter;
    data['returns_abs_rank'] = returnsAbsRank;
    data['returns_abs_totalrank'] = returnsAbsTotalrank;
    data['double_in'] = doubleIn;
    data['current_value'] = currentValue;
    data['scheme_inception_date'] = schemeInceptionDate;
    data['current_value'] = this.currentValue;
    return data;
  }
}
