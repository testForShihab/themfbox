class FamilyPortfolioAssetCategoryAllocationPojo {
  int? status;
  String? statusMsg;
  String? msg;
  double? familyCurrentCost;
  double? familyCurrentValue;
  double? familyUnrealisedGain;
  double? familyRealisedGain;
  double? familyAbsoluteReturn;
  double? familyPortfolioWeight;
  List<AssetCategory>? assetCategories;

  FamilyPortfolioAssetCategoryAllocationPojo({
    this.status,
    this.statusMsg,
    this.msg,
    this.familyCurrentCost,
    this.familyCurrentValue,
    this.familyUnrealisedGain,
    this.familyRealisedGain,
    this.familyAbsoluteReturn,
    this.familyPortfolioWeight,
    this.assetCategories,
  });

  factory FamilyPortfolioAssetCategoryAllocationPojo.fromJson(Map<String, dynamic> json) {
    return FamilyPortfolioAssetCategoryAllocationPojo(
      status: json['status'],
      statusMsg: json['status_msg'],
      msg: json['msg'],
      familyCurrentCost: json['family_current_cost'],
      familyCurrentValue: json['family_current_value'],
      familyUnrealisedGain: json['family_unrealised_gain'],
      familyRealisedGain: json['family_realised_gain'],
      familyAbsoluteReturn: json['family_absolute_return'],
      familyPortfolioWeight: json['family_portfolio_weight'],
      assetCategories: json['list'] != null
          ? (json['list'] as List).map((v) => AssetCategory.fromJson(v)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_msg'] = statusMsg;
    data['msg'] = msg;
    data['family_current_cost'] = familyCurrentCost;
    data['family_current_value'] = familyCurrentValue;
    data['family_unrealised_gain'] = familyUnrealisedGain;
    data['family_realised_gain'] = familyRealisedGain;
    data['family_absolute_return'] = familyAbsoluteReturn;
    data['family_portfolio_weight'] = familyPortfolioWeight;
    if (assetCategories != null) {
      data['list'] = assetCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssetCategory {
  String broadCategory;
  double? currentCost;
  double? currentValue;
  double? unrealisedGain;
  double? realisedGain;
  double? absRtn;
  double? portfolioWeight;
  List<CategoryList>? categoryList;

  AssetCategory({
    required this.broadCategory,
    this.currentCost,
    this.currentValue,
    this.unrealisedGain,
    this.realisedGain,
    this.absRtn,
    this.portfolioWeight,
    this.categoryList,
  });

  factory AssetCategory.fromJson(Map<String, dynamic> json) {
    return AssetCategory(
      broadCategory: json['broad_category'],
      currentCost: json['current_cost'],
      currentValue: json['current_value'],
      unrealisedGain: json['unrealised_gain'],
      realisedGain: json['realised_gain'],
      absRtn: json['abs_rtn'],
      portfolioWeight: json['portfolio_weight'],
      categoryList: json['category_list'] != null
          ? (json['category_list'] as List).map((v) => CategoryList.fromJson(v)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['broad_category'] = broadCategory;
    data['current_cost'] = currentCost;
    data['current_value'] = currentValue;
    data['unrealised_gain'] = unrealisedGain;
    data['realised_gain'] = realisedGain;
    data['abs_rtn'] = absRtn;
    data['portfolio_weight'] = portfolioWeight;
    if (categoryList != null) {
      data['category_list'] = categoryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryList {
  String? category;
  double? currentCost;
  double? currentValue;
  double? unrealisedGain;
  double? realisedGain;
  List<SchemeList>? schemeList;

  CategoryList({
    this.category,
    this.currentCost,
    this.currentValue,
    this.unrealisedGain,
    this.realisedGain,
    this.schemeList,
  });

  factory CategoryList.fromJson(Map<String, dynamic> json) {
    return CategoryList(
      category: json['category'],
      currentCost: json['current_cost'],
      currentValue: json['current_value'],
      unrealisedGain: json['unrealised_gain'],
      realisedGain: json['realised_gain'],
      schemeList: json['scheme_list'] != null
          ? (json['scheme_list'] as List).map((v) => SchemeList.fromJson(v)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['current_cost'] = currentCost;
    data['current_value'] = currentValue;
    data['unrealised_gain'] = unrealisedGain;
    data['realised_gain'] = realisedGain;
    if (schemeList != null) {
      data['scheme_list'] = schemeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SchemeList {
  String? schemeAmfi;
  String? schemeAmfiShortName;
  String? logo;
  String? investorName;
  String? folioNo;
  String? startDate;
  double? units;
  double? avgNav;
  double? currentCost;
  double? dividend;
  double? latestNav;
  String? navDate;
  double? currentValue;
  double? unrealisedGain;
  double? realisedGain;
  double? absRtn;
  double? xirr;

  SchemeList({
    this.schemeAmfi,
    this.schemeAmfiShortName,
    this.logo,
    this.investorName,
    this.folioNo,
    this.startDate,
    this.units,
    this.avgNav,
    this.currentCost,
    this.dividend,
    this.latestNav,
    this.navDate,
    this.currentValue,
    this.unrealisedGain,
    this.realisedGain,
    this.absRtn,
    this.xirr,
  });

  factory SchemeList.fromJson(Map<String, dynamic> json) {
    return SchemeList(
      schemeAmfi: json['scheme_amfi'],
      schemeAmfiShortName: json['scheme_amfi_short_name'],
      logo: json['logo'],
      investorName: json['investor_name'],
      folioNo: json['folio_no'],
      startDate: json['start_date'],
      units: json['units'],
      avgNav: json['avg_nav'],
      currentCost: json['current_cost'],
      dividend: json['dividend'],
      latestNav: json['latest_nav'],
      navDate: json['nav_date'],
      currentValue: json['current_value'],
      unrealisedGain: json['unrealised_gain'],
      realisedGain: json['realised_gain'],
      absRtn: json['abs_rtn'],
      xirr: json['xirr'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scheme_amfi'] = schemeAmfi;
    data['scheme_amfi_short_name'] = schemeAmfiShortName;
    data['logo'] = logo;
    data['investor_name'] = investorName;
    data['folio_no'] = folioNo;
    data['start_date'] = startDate;
    data['units'] = units;
    data['avg_nav'] = avgNav;
    data['current_cost'] = currentCost;
    data['dividend'] = dividend;
    data['latest_nav'] = latestNav;
    data['nav_date'] = navDate;
    data['current_value'] = currentValue;
    data['unrealised_gain'] = unrealisedGain;
    data['realised_gain'] = realisedGain;
    data['abs_rtn'] = absRtn;
    data['xirr'] = xirr;
    return data;
  }
}