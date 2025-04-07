class PerformanceReturnsPojo {
  String? inceptionDate;
  String? tra_InceptionDate;
  String? priceDate;
  String? schemeCompany;
  String? schemeAmfi;
  String? schemeAmfiShortName;
  String? schemeAmfiCode;
  String? schemeAmfiUrl;
  String? schemeCategory;
  String? schemeCategoryClass;
  String? schemeAssetDate;
  double? schemeAssets;
  String? logo;
  String? schemeRating;
  String? openOrClosed;
  double? returnsAbs;
  double? ter;
  String? terDate;
  double? price;
  String? riskometer;
  String? navTable;
  String? url;
  int? returnsAbsRank;
  int? returnsAbsTotalrank;
  String? doubleIn;

  PerformanceReturnsPojo(
      {this.inceptionDate,
      this.tra_InceptionDate,
      this.priceDate,
      this.schemeCompany,
      this.schemeAmfi,
      this.schemeAmfiShortName,
      this.schemeAmfiCode,
      this.schemeAmfiUrl,
      this.schemeCategory,
      this.schemeCategoryClass,
      this.schemeAssetDate,
      this.schemeAssets,
      this.logo,
      this.schemeRating,
      this.openOrClosed,
      this.returnsAbs,
      this.ter,
      this.terDate,
      this.price,
      this.riskometer,
      this.navTable,
      this.url,
      this.returnsAbsRank,
      this.returnsAbsTotalrank,
      this.doubleIn});

  PerformanceReturnsPojo.fromJson(Map<String, dynamic> json) {
    inceptionDate = json['scheme_inception_date'] ?? '';
    tra_InceptionDate = json['inception_date'] ?? '';
    priceDate = json['price_date'];
    schemeCompany = json['scheme_company'];
    schemeAmfi = json['scheme_amfi'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeAmfiCode = json['scheme_amfi_code'];
    schemeAmfiUrl = json['scheme_amfi_url'];
    schemeCategory = json['scheme_category'];
    schemeCategoryClass = json['scheme_category_class'];
    schemeAssetDate = json['scheme_asset_date'];
    schemeAssets = json['scheme_assets'];
    logo = json['logo'];
    schemeRating = json['scheme_rating'];
    openOrClosed = json['open_or_closed'];
    returnsAbs = json['returns_abs'];
    ter = json['ter'];
    terDate = json['ter_date'];
    price = json['price'];
    riskometer = json['riskometer'];
    navTable = json['nav_table'];
    url = json['url'];
    returnsAbsRank = json['returns_abs_rank'];
    returnsAbsTotalrank = json['returns_abs_totalrank'];
    doubleIn = json['double_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scheme_inception_date'] = inceptionDate;
    data['price_date'] = priceDate;
    data['scheme_company'] = schemeCompany;
    data['scheme_amfi'] = schemeAmfi;
    data['scheme_amfi_short_name'] = schemeAmfiShortName;
    data['scheme_amfi_code'] = schemeAmfiCode;
    data['scheme_amfi_url'] = schemeAmfiUrl;
    data['scheme_category'] = schemeCategory;
    data['scheme_category_class'] = schemeCategoryClass;
    data['scheme_asset_date'] = schemeAssetDate;
    data['scheme_assets'] = schemeAssets;
    data['logo'] = logo;
    data['scheme_rating'] = schemeRating;
    data['open_or_closed'] = openOrClosed;
    data['returns_abs'] = returnsAbs;
    data['ter'] = ter;
    data['ter_date'] = terDate;
    data['price'] = price;
    data['riskometer'] = riskometer;
    data['nav_table'] = navTable;
    data['url'] = url;
    data['returns_abs_rank'] = returnsAbsRank;
    data['returns_abs_totalrank'] = returnsAbsTotalrank;
    data['double_in'] = doubleIn;
    return data;
  }
}
