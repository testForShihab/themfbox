class InvestmentSummaryPojo {
  num? status;
  String? statusMsg;
  String? msg;
  Summary? summary;
  List<InvestorList>? investorList;
  List<BroadCategoryList>? broadCategoryList;
  List<CategoryList>? categoryList;
  List<AmcList>? amcList;
  List<SchemeList>? schemeList;
  List<GeneralList>? generalList;

  InvestmentSummaryPojo(
      {this.status,
        this.statusMsg,
        this.msg,
        this.summary,
        this.investorList,
        this.broadCategoryList,
        this.categoryList,
        this.amcList,
        this.schemeList,
        this.generalList,});

  InvestmentSummaryPojo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    summary =
    json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
    if (json['investor_list'] != null) {
      investorList = <InvestorList>[];
      json['investor_list'].forEach((v) {
        investorList!.add(InvestorList.fromJson(v));
      });
    }
    if (json['broad_category_list'] != null) {
      broadCategoryList = <BroadCategoryList>[];
      json['broad_category_list'].forEach((v) {
        broadCategoryList!.add(new BroadCategoryList.fromJson(v));
      });
    }
    if (json['category_list'] != null) {
      categoryList = <CategoryList>[];
      json['category_list'].forEach((v) {
        categoryList!.add(new CategoryList.fromJson(v));
      });
    }
    if (json['amc_list'] != null) {
      amcList = <AmcList>[];
      json['amc_list'].forEach((v) {
        amcList!.add(new AmcList.fromJson(v));
      });
    }
    if (json['scheme_list'] != null) {
      schemeList = <SchemeList>[];
      json['scheme_list'].forEach((v) {
        schemeList!.add(new SchemeList.fromJson(v));
      });
    }
    if (json['general_list'] != null) {
      generalList = <GeneralList>[];
      json['general_list'].forEach((v) {
        generalList!.add(new GeneralList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_msg'] = this.statusMsg;
    data['msg'] = this.msg;
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    if (this.investorList != null) {
      data['investor_list'] =
          this.investorList!.map((v) => v.toJson()).toList();
    }
    if (this.broadCategoryList != null) {
      data['broad_category_list'] =
          this.broadCategoryList!.map((v) => v.toJson()).toList();
    }
    if (this.categoryList != null) {
      data['category_list'] =
          this.categoryList!.map((v) => v.toJson()).toList();
    }
    if (this.amcList != null) {
      data['amc_list'] = this.amcList!.map((v) => v.toJson()).toList();
    }
    if (this.schemeList != null) {
      data['scheme_list'] = this.schemeList!.map((v) => v.toJson()).toList();
    }
    if (this.generalList != null) {
      data['general_list'] = this.generalList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Summary {
  num? totalPurchase;
  num? totalSwitchIn;
  num? totalSwitchOut;
  num? totalRedemption;
  num? totalDividendPayout;
  num? totalDividendReinvest;
  num? totalNetAmount;
  num? totalCurrentCost;
  num? totalCurrentValue;
  num? totalGain;
  num? absoluteReturn;
  num? portfolioReturn;
  num? totalDividend;

  Summary(
      {this.totalPurchase,
        this.totalSwitchIn,
        this.totalSwitchOut,
        this.totalRedemption,
        this.totalDividendPayout,
        this.totalDividendReinvest,
        this.totalNetAmount,
        this.totalCurrentCost,
        this.totalCurrentValue,
        this.totalGain,
        this.absoluteReturn,
        this.portfolioReturn,
        this.totalDividend});

  Summary.fromJson(Map<String, dynamic> json) {
    totalPurchase = json['total_purchase'];
    totalSwitchIn = json['total_switch_in'];
    totalSwitchOut = json['total_switch_out'];
    totalRedemption = json['total_redemption'];
    totalDividendPayout = json['total_dividend_payout'];
    totalDividendReinvest = json['total_dividend_reinvest'];
    totalNetAmount = json['total_net_amount'];
    totalCurrentCost = json['total_current_cost'];
    totalCurrentValue = json['total_current_value'];
    totalGain = json['total_gain'];
    absoluteReturn = json['absolute_return'];
    portfolioReturn = json['portfolio_return'];
    totalDividend = json['total_dividend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_purchase'] = this.totalPurchase;
    data['total_switch_in'] = this.totalSwitchIn;
    data['total_switch_out'] = this.totalSwitchOut;
    data['total_redemption'] = this.totalRedemption;
    data['total_dividend_payout'] = this.totalDividendPayout;
    data['total_dividend_reinvest'] = this.totalDividendReinvest;
    data['total_net_amount'] = this.totalNetAmount;
    data['total_current_cost'] = this.totalCurrentCost;
    data['total_current_value'] = this.totalCurrentValue;
    data['total_gain'] = this.totalGain;
    data['absolute_return'] = this.absoluteReturn;
    data['portfolio_return'] = this.portfolioReturn;
    data['total_dividend'] = this.totalDividend;
    return data;
  }
}

class GeneralList {
  num? userId;
  String? name;
  String? pan;
  List<GeneralSchemeList>? generalSchemeList;

  GeneralList({this.userId, this.name, this.pan, this.generalSchemeList});

  GeneralList.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    pan = json['pan'];
    if (json['general_list'] != null) {
      generalSchemeList = <GeneralSchemeList>[];
      json['general_list'].forEach((v) {
        generalSchemeList!.add(new GeneralSchemeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['pan'] = this.pan;
    if (this.generalSchemeList != null) {
      data['general_list'] = this.generalSchemeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GeneralSchemeList {
  String? schemeAmfi;
  String? schemeAmfiShortName;
  String? logo;
  String? folioNo;
  String? startDate;
  num? units;
  num? avgNav;
  num? avgDays;
  num? invAmt;
  num? switchAmtIn;
  num? redSwpAmt;
  num? switchAmtOut;
  num? dividend;
  num? lastestNav;
  num? currentValue;
  num? unrealisedGain;
  num? realisedGain;
  num? xirr;
  List<TrnxList>? trnxList;

  GeneralSchemeList(
      {this.schemeAmfi,
        this.schemeAmfiShortName,
        this.logo,
        this.folioNo,
        this.startDate,
        this.units,
        this.avgNav,
        this.avgDays,
        this.invAmt,
        this.switchAmtIn,
        this.redSwpAmt,
        this.switchAmtOut,
        this.dividend,
        this.lastestNav,
        this.currentValue,
        this.unrealisedGain,
        this.realisedGain,
        this.xirr,
        this.trnxList});

  GeneralSchemeList.fromJson(Map<String, dynamic> json) {
    schemeAmfi = json['scheme_amfi'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    logo = json['logo'];
    folioNo = json['folio_no'];
    startDate = json['start_date'];
    units = json['units'];
    avgNav = json['avg_nav'];
    avgDays = json['avg_days'];
    invAmt = json['inv_amt'];
    switchAmtIn = json['switch_amt_in'];
    redSwpAmt = json['red_swp_amt'];
    switchAmtOut = json['switch_amt_out'];
    dividend = json['dividend'];
    lastestNav = json['lastest_nav'];
    currentValue = json['current_value'];
    unrealisedGain = json['unrealised_gain'];
    realisedGain = json['realised_gain'];
    xirr = json['xirr'];
    if (json['trnxList'] != null) {
      trnxList = <TrnxList>[];
      json['trnxList'].forEach((v) {
        trnxList!.add(new TrnxList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheme_amfi'] = this.schemeAmfi;
    data['scheme_amfi_short_name'] = this.schemeAmfiShortName;
    data['logo'] = this.logo;
    data['folio_no'] = this.folioNo;
    data['start_date'] = this.startDate;
    data['units'] = this.units;
    data['avg_nav'] = this.avgNav;
    data['avg_days'] = this.avgDays;
    data['inv_amt'] = this.invAmt;
    data['switch_amt_in'] = this.switchAmtIn;
    data['red_swp_amt'] = this.redSwpAmt;
    data['switch_amt_out'] = this.switchAmtOut;
    data['dividend'] = this.dividend;
    data['lastest_nav'] = this.lastestNav;
    data['current_value'] = this.currentValue;
    data['unrealised_gain'] = this.unrealisedGain;
    data['realised_gain'] = this.realisedGain;
    data['xirr'] = this.xirr;
    if (this.trnxList != null) {
      data['trnxList'] = this.trnxList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class InvestorList {
  String? invName;
  String? userId;
  String? amc;
  String? amcLogo;
  String? category;
  String? scheme;
  String? schemeAmfiShortName;
  String? folioNo;
  String? schemeAmfiCode;
  num? purchaseCost;
  num? marketValue;
  num? xirr;
  num? absoluteReturn;
  num? allocation;
  String? purchaseCostStr;
  String? marketValueStr;
  String? arn;
  String? schemeRegistrar;
  List<TrnxList>? trnxList;

  InvestorList(
      {this.invName,
        this.userId,
        this.amc,
        this.amcLogo,
        this.category,
        this.scheme,
        this.schemeAmfiShortName,
        this.folioNo,
        this.schemeAmfiCode,
        this.purchaseCost,
        this.marketValue,
        this.xirr,
        this.absoluteReturn,
        this.allocation,
        this.purchaseCostStr,
        this.marketValueStr,
        this.arn,
        this.schemeRegistrar,
        this.trnxList});

  InvestorList.fromJson(Map<String, dynamic> json) {
    invName = json['inv_name'];
    userId = json['user_id'];
    amc = json['amc'];
    amcLogo = json['amc_logo'];
    category = json['category'];
    scheme = json['scheme'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    folioNo = json['folio_no'];
    schemeAmfiCode = json['scheme_amfi_code'];
    purchaseCost = json['purchase_cost'];
    marketValue = json['market_value'];
    xirr = json['xirr'];
    absoluteReturn = json['absolute_return'];
    allocation = json['allocation'];
    purchaseCostStr = json['purchase_cost_str'];
    marketValueStr = json['market_value_str'];
    arn = json['arn'];
    schemeRegistrar = json['scheme_registrar'];
    if (json['trnxList'] != null) {
      trnxList = <TrnxList>[];
      json['trnxList'].forEach((v) {
        trnxList!.add(TrnxList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inv_name'] = this.invName;
    data['user_id'] = this.userId;
    data['amc'] = this.amc;
    data['amc_logo'] = this.amcLogo;
    data['category'] = this.category;
    data['scheme'] = this.scheme;
    data['scheme_amfi_short_name'] = this.schemeAmfiShortName;
    data['folio_no'] = this.folioNo;
    data['scheme_amfi_code'] = this.schemeAmfiCode;
    data['purchase_cost'] = this.purchaseCost;
    data['market_value'] = this.marketValue;
    data['xirr'] = this.xirr;
    data['absolute_return'] = this.absoluteReturn;
    data['allocation'] = this.allocation;
    data['purchase_cost_str'] = this.purchaseCostStr;
    data['market_value_str'] = this.marketValueStr;
    data['arn'] = this.arn;
    data['scheme_registrar'] = this.schemeRegistrar;
    if (this.trnxList != null) {
      data['trnxList'] = this.trnxList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BroadCategoryList {
  String? invName;
  String? userId;
  String? amc;
  String? amcLogo;
  String? category;
  String? scheme;
  String? schemeAmfiShortName;
  String? folioNo;
  String? schemeAmfiCode;
  num? purchaseCost;
  num? marketValue;
  num? xirr;
  num? absoluteReturn;
  num? allocation;
  String? purchaseCostStr;
  String? marketValueStr;
  String? arn;
  String? schemeRegistrar;
  List<TrnxList>? trnxList;

  BroadCategoryList(
      {this.invName,
        this.userId,
        this.amc,
        this.amcLogo,
        this.category,
        this.scheme,
        this.schemeAmfiShortName,
        this.folioNo,
        this.schemeAmfiCode,
        this.purchaseCost,
        this.marketValue,
        this.xirr,
        this.absoluteReturn,
        this.allocation,
        this.purchaseCostStr,
        this.marketValueStr,
        this.arn,
        this.schemeRegistrar,
        this.trnxList});

  BroadCategoryList.fromJson(Map<String, dynamic> json) {
    invName = json['inv_name'];
    userId = json['user_id'];
    amc = json['amc'];
    amcLogo = json['amc_logo'];
    category = json['category'];
    scheme = json['scheme'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    folioNo = json['folio_no'];
    schemeAmfiCode = json['scheme_amfi_code'];
    purchaseCost = json['purchase_cost'];
    marketValue = json['market_value'];
    xirr = json['xirr'];
    absoluteReturn = json['absolute_return'];
    allocation = json['allocation'];
    purchaseCostStr = json['purchase_cost_str'];
    marketValueStr = json['market_value_str'];
    arn = json['arn'];
    schemeRegistrar = json['scheme_registrar'];
    if (json['trnxList'] != null) {
      trnxList = <TrnxList>[];
      json['trnxList'].forEach((v) {
        trnxList!.add(TrnxList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inv_name'] = this.invName;
    data['user_id'] = this.userId;
    data['amc'] = this.amc;
    data['amc_logo'] = this.amcLogo;
    data['category'] = this.category;
    data['scheme'] = this.scheme;
    data['scheme_amfi_short_name'] = this.schemeAmfiShortName;
    data['folio_no'] = this.folioNo;
    data['scheme_amfi_code'] = this.schemeAmfiCode;
    data['purchase_cost'] = this.purchaseCost;
    data['market_value'] = this.marketValue;
    data['xirr'] = this.xirr;
    data['absolute_return'] = this.absoluteReturn;
    data['allocation'] = this.allocation;
    data['purchase_cost_str'] = this.purchaseCostStr;
    data['market_value_str'] = this.marketValueStr;
    data['arn'] = this.arn;
    data['scheme_registrar'] = this.schemeRegistrar;
    if (this.trnxList != null) {
      data['trnxList'] = this.trnxList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryList {
  String? invName;
  String? userId;
  String? amc;
  String? amcLogo;
  String? category;
  String? scheme;
  String? schemeAmfiShortName;
  String? folioNo;
  String? schemeAmfiCode;
  num? purchaseCost;
  num? marketValue;
  num? xirr;
  num? absoluteReturn;
  num? allocation;
  String? purchaseCostStr;
  String? marketValueStr;
  String? arn;
  String? schemeRegistrar;
  List<TrnxList>? trnxList;

  CategoryList(
      {this.invName,
        this.userId,
        this.amc,
        this.amcLogo,
        this.category,
        this.scheme,
        this.schemeAmfiShortName,
        this.folioNo,
        this.schemeAmfiCode,
        this.purchaseCost,
        this.marketValue,
        this.xirr,
        this.absoluteReturn,
        this.allocation,
        this.purchaseCostStr,
        this.marketValueStr,
        this.arn,
        this.schemeRegistrar,
        this.trnxList});

  CategoryList.fromJson(Map<String, dynamic> json) {
    invName = json['inv_name'];
    userId = json['user_id'];
    amc = json['amc'];
    amcLogo = json['amc_logo'];
    category = json['category'];
    scheme = json['scheme'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    folioNo = json['folio_no'];
    schemeAmfiCode = json['scheme_amfi_code'];
    purchaseCost = json['purchase_cost'];
    marketValue = json['market_value'];
    xirr = json['xirr'];
    absoluteReturn = json['absolute_return'];
    allocation = json['allocation'];
    purchaseCostStr = json['purchase_cost_str'];
    marketValueStr = json['market_value_str'];
    arn = json['arn'];
    schemeRegistrar = json['scheme_registrar'];
    if (json['trnxList'] != null) {
      trnxList = <TrnxList>[];
      json['trnxList'].forEach((v) {
        trnxList!.add(TrnxList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inv_name'] = this.invName;
    data['user_id'] = this.userId;
    data['amc'] = this.amc;
    data['amc_logo'] = this.amcLogo;
    data['category'] = this.category;
    data['scheme'] = this.scheme;
    data['scheme_amfi_short_name'] = this.schemeAmfiShortName;
    data['folio_no'] = this.folioNo;
    data['scheme_amfi_code'] = this.schemeAmfiCode;
    data['purchase_cost'] = this.purchaseCost;
    data['market_value'] = this.marketValue;
    data['xirr'] = this.xirr;
    data['absolute_return'] = this.absoluteReturn;
    data['allocation'] = this.allocation;
    data['purchase_cost_str'] = this.purchaseCostStr;
    data['market_value_str'] = this.marketValueStr;
    data['arn'] = this.arn;
    data['scheme_registrar'] = this.schemeRegistrar;
    if (this.trnxList != null) {
      data['trnxList'] = this.trnxList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AmcList {
  String? invName;
  String? userId;
  String? amc;
  String? amcLogo;
  String? category;
  String? scheme;
  String? schemeAmfiShortName;
  String? folioNo;
  String? schemeAmfiCode;
  num? purchaseCost;
  num? marketValue;
  num? xirr;
  num? absoluteReturn;
  num? allocation;
  String? purchaseCostStr;
  String? marketValueStr;
  String? arn;
  String? schemeRegistrar;
  List<TrnxList>? trnxList;

  AmcList(
      {this.invName,
        this.userId,
        this.amc,
        this.amcLogo,
        this.category,
        this.scheme,
        this.schemeAmfiShortName,
        this.folioNo,
        this.schemeAmfiCode,
        this.purchaseCost,
        this.marketValue,
        this.xirr,
        this.absoluteReturn,
        this.allocation,
        this.purchaseCostStr,
        this.marketValueStr,
        this.arn,
        this.schemeRegistrar,
        this.trnxList});

  AmcList.fromJson(Map<String, dynamic> json) {
    invName = json['inv_name'];
    userId = json['user_id'];
    amc = json['amc'];
    amcLogo = json['amc_logo'];
    category = json['category'];
    scheme = json['scheme'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    folioNo = json['folio_no'];
    schemeAmfiCode = json['scheme_amfi_code'];
    purchaseCost = json['purchase_cost'];
    marketValue = json['market_value'];
    xirr = json['xirr'];
    absoluteReturn = json['absolute_return'];
    allocation = json['allocation'];
    purchaseCostStr = json['purchase_cost_str'];
    marketValueStr = json['market_value_str'];
    arn = json['arn'];
    schemeRegistrar = json['scheme_registrar'];
    if (json['trnxList'] != null) {
      trnxList = <TrnxList>[];
      json['trnxList'].forEach((v) {
        trnxList!.add(TrnxList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inv_name'] = this.invName;
    data['user_id'] = this.userId;
    data['amc'] = this.amc;
    data['amc_logo'] = this.amcLogo;
    data['category'] = this.category;
    data['scheme'] = this.scheme;
    data['scheme_amfi_short_name'] = this.schemeAmfiShortName;
    data['folio_no'] = this.folioNo;
    data['scheme_amfi_code'] = this.schemeAmfiCode;
    data['purchase_cost'] = this.purchaseCost;
    data['market_value'] = this.marketValue;
    data['xirr'] = this.xirr;
    data['absolute_return'] = this.absoluteReturn;
    data['allocation'] = this.allocation;
    data['purchase_cost_str'] = this.purchaseCostStr;
    data['market_value_str'] = this.marketValueStr;
    data['arn'] = this.arn;
    data['scheme_registrar'] = this.schemeRegistrar;
    if (this.trnxList != null) {
      data['trnxList'] = this.trnxList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SchemeList {
  String? invName;
  String? userId;
  String? amc;
  String? amcLogo;
  String? category;
  String? scheme;
  String? schemeAmfiShortName;
  String? folioNo;
  String? schemeAmfiCode;
  num? purchaseCost;
  num? marketValue;
  num? xirr;
  num? absoluteReturn;
  num? allocation;
  String? purchaseCostStr;
  String? marketValueStr;
  String? arn;
  String? schemeRegistrar;
  List<TrnxList>? trnxList;

  SchemeList(
      {this.invName,
        this.userId,
        this.amc,
        this.amcLogo,
        this.category,
        this.scheme,
        this.schemeAmfiShortName,
        this.folioNo,
        this.schemeAmfiCode,
        this.purchaseCost,
        this.marketValue,
        this.xirr,
        this.absoluteReturn,
        this.allocation,
        this.purchaseCostStr,
        this.marketValueStr,
        this.arn,
        this.schemeRegistrar,
        this.trnxList});

  SchemeList.fromJson(Map<String, dynamic> json) {
    invName = json['inv_name'];
    userId = json['user_id'];
    amc = json['amc'];
    amcLogo = json['amc_logo'];
    category = json['category'];
    scheme = json['scheme'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    folioNo = json['folio_no'];
    schemeAmfiCode = json['scheme_amfi_code'];
    purchaseCost = json['purchase_cost'];
    marketValue = json['market_value'];
    xirr = json['xirr'];
    absoluteReturn = json['absolute_return'];
    allocation = json['allocation'];
    purchaseCostStr = json['purchase_cost_str'];
    marketValueStr = json['market_value_str'];
    arn = json['arn'];
    schemeRegistrar = json['scheme_registrar'];
    if (json['trnxList'] != null) {
      trnxList = <TrnxList>[];
      json['trnxList'].forEach((v) {
        trnxList!.add(TrnxList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inv_name'] = this.invName;
    data['user_id'] = this.userId;
    data['amc'] = this.amc;
    data['amc_logo'] = this.amcLogo;
    data['category'] = this.category;
    data['scheme'] = this.scheme;
    data['scheme_amfi_short_name'] = this.schemeAmfiShortName;
    data['folio_no'] = this.folioNo;
    data['scheme_amfi_code'] = this.schemeAmfiCode;
    data['purchase_cost'] = this.purchaseCost;
    data['market_value'] = this.marketValue;
    data['xirr'] = this.xirr;
    data['absolute_return'] = this.absoluteReturn;
    data['allocation'] = this.allocation;
    data['purchase_cost_str'] = this.purchaseCostStr;
    data['market_value_str'] = this.marketValueStr;
    data['arn'] = this.arn;
    data['scheme_registrar'] = this.schemeRegistrar;
    if (this.trnxList != null) {
      data['trnxList'] = this.trnxList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrnxList {
  String? transactionDate;
  String? transactionType;
  num? purchasePrice;
  num? purchaseUnits;
  num? totalUnits;
  num? purchaseAmount;
  num? tdsAmount;
  num? sttAmount;
  String? brokerCode;

  TrnxList(
      {this.transactionDate,
        this.transactionType,
        this.purchasePrice,
        this.purchaseUnits,
        this.totalUnits,
        this.purchaseAmount,
        this.tdsAmount,
        this.sttAmount,
        this.brokerCode});

  TrnxList.fromJson(Map<String, dynamic> json) {
    transactionDate = json['transaction_date'];
    transactionType = json['transaction_type'];
    purchasePrice = json['purchase_price'];
    purchaseUnits = json['purchase_units'];
    totalUnits = json['total_units'];
    purchaseAmount = json['purchase_amount'];
    tdsAmount = json['tds_amount'];
    sttAmount = json['stt_amount'];
    brokerCode = json['broker_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_date'] = this.transactionDate;
    data['transaction_type'] = this.transactionType;
    data['purchase_price'] = this.purchasePrice;
    data['purchase_units'] = this.purchaseUnits;
    data['total_units'] = this.totalUnits;
    data['purchase_amount'] = this.purchaseAmount;
    data['tds_amount'] = this.tdsAmount;
    data['stt_amount'] = this.sttAmount;
    data['broker_code'] = this.brokerCode;
    return data;
  }
}

