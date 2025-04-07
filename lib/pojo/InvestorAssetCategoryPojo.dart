class InvestorAssetCategoryPojo {
  num? status;
  String? statusMsg;
  String? msg;
  num? currentCost;
  num? currentValue;
  num? unrealisedGain;
  num? realisedGain;
  num? absoluteReturn;
  num? portfolioWeight;
  num? xirr;
  List<BroadCategoryList>? broadCategoryList;

  InvestorAssetCategoryPojo(
      {this.status,
        this.statusMsg,
        this.msg,
        this.currentCost,
        this.currentValue,
        this.unrealisedGain,
        this.realisedGain,
        this.absoluteReturn,
        this.portfolioWeight,
        this.xirr,
        this.broadCategoryList});

  InvestorAssetCategoryPojo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    currentCost = json['current_cost'];
    currentValue = json['current_value'];
    unrealisedGain = json['unrealised_gain'];
    realisedGain = json['realised_gain'];
    absoluteReturn = json['absolute_return'];
    xirr = json['xirr'];
    portfolioWeight = json['portfolio_weight'];
    if (json['list'] != null) {
      broadCategoryList = <BroadCategoryList>[];
      json['list'].forEach((v) {
        broadCategoryList!.add(new BroadCategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_msg'] = this.statusMsg;
    data['msg'] = this.msg;
    data['current_cost'] = this.currentCost;
    data['current_value'] = this.currentValue;
    data['unrealised_gain'] = this.unrealisedGain;
    data['realised_gain'] = this.realisedGain;
    data['absolute_return'] = this.absoluteReturn;
    data['xirr'] = this.xirr;
    data['portfolio_weight'] = this.portfolioWeight;
    if (this.broadCategoryList != null) {
      data['list'] = this.broadCategoryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BroadCategoryList {
  String? broadCategory;
  num? currentCost;
  num? currentValue;
  num? unrealisedGain;
  num? realisedGain;
  num? absRtn;
  num? portfolioWeight;
  List<CategoryList>? categoryList;

  BroadCategoryList(
      {this.broadCategory,
        this.currentCost,
        this.currentValue,
        this.unrealisedGain,
        this.realisedGain,
        this.absRtn,
        this.portfolioWeight,
        this.categoryList});

  BroadCategoryList.fromJson(Map<String, dynamic> json) {
    broadCategory = json['broad_category'];
    currentCost = json['current_cost'];
    currentValue = json['current_value'];
    unrealisedGain = json['unrealised_gain'];
    realisedGain = json['realised_gain'];
    absRtn = json['abs_rtn'];
    portfolioWeight = json['portfolio_weight'];
    if (json['category_list'] != null) {
      categoryList = <CategoryList>[];
      json['category_list'].forEach((v) {
        categoryList!.add(new CategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['broad_category'] = this.broadCategory;
    data['current_cost'] = this.currentCost;
    data['current_value'] = this.currentValue;
    data['unrealised_gain'] = this.unrealisedGain;
    data['realised_gain'] = this.realisedGain;
    data['abs_rtn'] = this.absRtn;
    data['portfolio_weight'] = this.portfolioWeight;
    if (this.categoryList != null) {
      data['category_list'] =
          this.categoryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryList {
  String? category;
  num? currentCost;
  num? currentValue;
  num? unrealisedGain;
  num? realisedGain;
  num? absRtn;
  num? portfolioWeight;
  List<SchemeList>? schemeList;

  CategoryList(
      {this.category,
        this.currentCost,
        this.currentValue,
        this.unrealisedGain,
        this.realisedGain,
        this.absRtn,
        this.portfolioWeight,
        this.schemeList});

  CategoryList.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    currentCost = json['current_cost'];
    currentValue = json['current_value'];
    unrealisedGain = json['unrealised_gain'];
    realisedGain = json['realised_gain'];
    absRtn = json['abs_rtn'];
    portfolioWeight = json['portfolio_weight'];
    if (json['scheme_list'] != null) {
      schemeList = <SchemeList>[];
      json['scheme_list'].forEach((v) {
        schemeList!.add(new SchemeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['current_cost'] = this.currentCost;
    data['current_value'] = this.currentValue;
    data['unrealised_gain'] = this.unrealisedGain;
    data['realised_gain'] = this.realisedGain;
    data['abs_rtn'] = this.absRtn;
    data['portfolio_weight'] = this.portfolioWeight;
    if (this.schemeList != null) {
      data['scheme_list'] = this.schemeList!.map((v) => v.toJson()).toList();
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
  num? units;
  num? avgNav;
  num? currentCost;
  num? dividend;
  num? latestNav;
  String? navDate;
  num? currentValue;
  num? unrealisedGain;
  num? realisedGain;
  num? absRtn;
  num? xirr;
  num? schemeWeight;


  SchemeList(
      {this.schemeAmfi,
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
        this.schemeWeight,
        this.xirr});

  SchemeList.fromJson(Map<String, dynamic> json) {
    schemeAmfi = json['scheme_amfi'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    logo = json['logo'];
    investorName = json['investor_name'];
    folioNo = json['folio_no'];
    startDate = json['start_date'];
    units = json['units'];
    avgNav = json['avg_nav'];
    currentCost = json['current_cost'];
    dividend = json['dividend'];
    latestNav = json['latest_nav'];
    navDate = json['nav_date'];
    currentValue = json['current_value'];
    unrealisedGain = json['unrealised_gain'];
    realisedGain = json['realised_gain'];
    absRtn = json['abs_rtn'];
    schemeWeight = json['scheme_weight'];
    xirr = json['xirr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheme_amfi'] = this.schemeAmfi;
    data['scheme_amfi_short_name'] = this.schemeAmfiShortName;
    data['logo'] = this.logo;
    data['investor_name'] = this.investorName;
    data['folio_no'] = this.folioNo;
    data['start_date'] = this.startDate;
    data['units'] = this.units;
    data['avg_nav'] = this.avgNav;
    data['current_cost'] = this.currentCost;
    data['dividend'] = this.dividend;
    data['latest_nav'] = this.latestNav;
    data['nav_date'] = this.navDate;
    data['current_value'] = this.currentValue;
    data['unrealised_gain'] = this.unrealisedGain;
    data['realised_gain'] = this.realisedGain;
    data['abs_rtn'] = this.absRtn;
    data['xirr'] = this.xirr;
    data['scheme_weight'] = this.schemeWeight;
    return data;
  }
}