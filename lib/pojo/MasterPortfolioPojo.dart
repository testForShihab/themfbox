import 'dart:core';

class MasterPostfolioPojo {
  num? status;
  String? statusMsg;
  String? msg;
  num? totalCurrentCost;
  num? totalCurrentValue;
  num? totalCurrentGain;
  MutualFund? mutualFund;
  Equity? equity;
  PrivateEquity? privateEquity;
  Structured? structured;
  Pms? pms;
  Commodity? commodity;
  Gold? gold;
  Nps? nps;
  Aif? aif;
  RealestatePms? realestatePms;
  PostOffice? postOffice;
  Fd? fd;
  Bond? bond;
  Realestate? realestate;
  LifeInsurance? lifeInsurance;
  GeneralInsurance? generalInsurance;
  HealthInsurance? healthInsurance;
  Loan? loan;
  Ncd? ncd;
  Trade? trade;

  MasterPostfolioPojo(
      {this.status,
      this.statusMsg,
      this.msg,
      this.totalCurrentCost,
      this.totalCurrentValue,
      this.totalCurrentGain,
      this.mutualFund,
      this.equity,
      this.privateEquity,
      this.structured,
      this.pms,
      this.commodity,
      this.gold,
      this.nps,
      this.aif,
      this.realestatePms,
      this.postOffice,
      this.fd,
      this.bond,
      this.realestate,
      this.lifeInsurance,
      this.generalInsurance,
      this.healthInsurance,
      this.loan,
      this.ncd,
      this.trade});

  MasterPostfolioPojo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    totalCurrentCost = json['total_current_cost'];
    totalCurrentValue = json['total_current_value'];
    totalCurrentGain = json['total_current_gain'];
    mutualFund = json['mutual_fund'] != null ? MutualFund.fromJson(json['mutual_fund']) : null;
    equity = json['equity'] != null ? Equity.fromJson(json['equity']) : null;
    privateEquity = json['private_equity'] != null ? PrivateEquity.fromJson(json['private_equity']) : null;
    structured = json['structured'] != null ? Structured.fromJson(json['structured']) : null;
    pms = json['pms'] != null ? Pms.fromJson(json['pms']) : null;
    commodity = json['commodity'] != null ? Commodity.fromJson(json['commodity']) : null;
    gold = json['gold'] != null ? Gold.fromJson(json['gold']) : null;
    nps = json['nps'] != null ? Nps.fromJson(json['nps']) : null;
    aif = json['aif'] != null ? Aif.fromJson(json['aif']) : null;
    realestatePms = json['realestate_pms'] != null ? RealestatePms.fromJson(json['realestate_pms']) : null;
    postOffice = json['post_office'] != null ? PostOffice.fromJson(json['post_office']) : null;
    fd = json['fd'] != null ? Fd.fromJson(json['fd']) : null;
    bond = json['bond'] != null ? Bond.fromJson(json['bond']) : null;
    realestate = json['realestate'] != null ? Realestate.fromJson(json['realestate']) : null;
    lifeInsurance = json['life_insurance'] != null ? LifeInsurance.fromJson(json['life_insurance']) : null;
    generalInsurance = json['general_insurance'] != null ? GeneralInsurance.fromJson(json['general_insurance']) : null;
    healthInsurance = json['health_insurance'] != null ? HealthInsurance.fromJson(json['health_insurance']) : null;
    loan = json['loan'] != null ? Loan.fromJson(json['loan']) : null;
    ncd = json['ncd'] != null ? Ncd.fromJson(json['ncd']) : null;
    trade = json['trade'] != null ? Trade.fromJson(json['trade']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_msg'] = statusMsg;
    data['msg'] = msg;
    data['total_current_cost'] = totalCurrentCost;
    data['total_current_value'] = totalCurrentValue;
    data['total_current_gain'] = totalCurrentGain;

    if(mutualFund != null) {
      data['mutual_fund'] = mutualFund!.toJson();
    }
    if(equity != null) {
      data['equity'] = equity!.toJson();
    }
    if(privateEquity != null) {
      data['private_equity'] = privateEquity!.toJson();
    }
    if(structured != null) {
      data['structured'] = structured!.toJson();
    }
    if(pms != null) {
      data['pms'] = pms!.toJson();
    }
    if(commodity != null) {
      data['commodity'] = commodity!.toJson();
    }
    if(gold != null) {
      data['gold'] = gold!.toJson();
    }
    if(nps != null) {
      data['nps'] = nps!.toJson();
    }
    if(aif != null) {
      data['aif'] = aif!.toJson();
    }
    if(realestatePms != null) {
      data['realestate_pms'] = realestatePms!.toJson();
    }
    if(postOffice != null) {
      data['post_office'] = postOffice!.toJson();
    }
    if(fd != null) {
      data['fd'] = fd!.toJson();
    }
    if(bond != null) {
      data['bond'] = bond!.toJson();
    }
    if(realestate != null) {
      data['realestate'] = realestate!.toJson();
    }
    if(lifeInsurance != null) {
      data['life_insurance'] = lifeInsurance!.toJson();
    }
    if(generalInsurance != null) {
      data['general_insurance'] = generalInsurance!.toJson();
    }
    if(healthInsurance != null) {
      data['health_insurance'] = healthInsurance!.toJson();
    }
    if(loan != null) {
      data['loan'] = loan!.toJson();
    }
    if(ncd != null) {
      data['ncd'] = ncd!.toJson();
    }
    if(trade != null) {
      data['trade'] = trade!.toJson();
    }
    return data;
  }
}

class MutualFund {
  num? mutualFundInvestedValue;
  num? mutualFundCurrentValue;
  num? mutualFundUnrealised;
  num? mutualFundRealised;
  num? mutualFundCagr;
  num? mutualFundReturn;
  num? mutualFundOneDayChangeValue;
  num? mutualFundOneDayChangePercentage;

  MutualFund(
      {this.mutualFundInvestedValue,
      this.mutualFundCurrentValue,
      this.mutualFundUnrealised,
      this.mutualFundRealised,
      this.mutualFundCagr,
      this.mutualFundReturn,
      this.mutualFundOneDayChangeValue,
      this.mutualFundOneDayChangePercentage});

  MutualFund.fromJson(Map<String, dynamic> json) {
    mutualFundInvestedValue = json['mutual_fund_invested_value'];
    mutualFundCurrentValue = json['mutual_fund_current_value'];
    mutualFundUnrealised = json['mutual_fund_unrealised'];
    mutualFundRealised = json['mutual_fund_realised'];
    mutualFundCagr = json['mutual_fund_cagr'];
    mutualFundReturn = json['mutual_fund_return'];
    mutualFundOneDayChangeValue = json['mutual_fund_one_day_change_value'];
    mutualFundOneDayChangePercentage =
        json['mutual_fund_one_day_change_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mutual_fund_invested_value'] = mutualFundInvestedValue;
    data['mutual_fund_current_value'] = mutualFundCurrentValue;
    data['mutual_fund_unrealised'] = mutualFundUnrealised;
    data['mutual_fund_realised'] = mutualFundRealised;
    data['mutual_fund_cagr'] = mutualFundCagr;
    data['mutual_fund_return'] = mutualFundReturn;
    data['mutual_fund_one_day_change_value'] = mutualFundOneDayChangeValue;
    data['mutual_fund_one_day_change_percentage'] = mutualFundOneDayChangePercentage;
    return data;
  }
}

class Equity {
  num? equityTotalShares;
  num? equityTotalCurrentCost;
  num? equityTotalCurrentValue;
  num? equityTotalUnrealisedProfitLoss;
  num? equityTotalReturn;
  num? equityTotalXirr;
  List<EquityList>? equityList;

  Equity(
      {this.equityTotalShares,
      this.equityTotalCurrentCost,
      this.equityTotalCurrentValue,
      this.equityTotalUnrealisedProfitLoss,
      this.equityTotalReturn,
      this.equityTotalXirr,
      this.equityList});

  Equity.fromJson(Map<String, dynamic> json) {
    equityTotalShares = json['equity_total_shares'];
    equityTotalCurrentCost = json['equity_total_current_cost'];
    equityTotalCurrentValue = json['equity_total_current_value'];
    equityTotalUnrealisedProfitLoss =
        json['equity_total_unrealised_profit_loss'];
    equityTotalReturn = json['equity_total_return'];
    equityTotalXirr = json['equity_total_xirr'];
    if (json['list'] != null) {
      equityList = <EquityList>[];
      json['list'].forEach((v) {
        equityList!.add(EquityList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['equity_total_shares'] = equityTotalShares;
    data['equity_total_current_cost'] = equityTotalCurrentCost;
    data['equity_total_current_value'] = equityTotalCurrentValue;
    data['equity_total_unrealised_profit_loss'] = equityTotalUnrealisedProfitLoss;
    data['equity_total_return'] = equityTotalReturn;
    data['equity_total_xirr'] = equityTotalXirr;
    if(equityList != null) {
      data['equityList'] = equityList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EquityList {
  String? name;
  String? pan;
  String? exchangeType;
  String? equityHolderName;
  String? companyName;
  String? companyCode;
  String? sector;
  String? purchaseDate;
  num? share;
  num? price;
  String? regNo;
  String? trxnType;
  String? brokerName;
  String? dematBankName;
  num? positiveAmount;
  num? positiveUnits;
  num? totalInflow;
  num? totalOutflow;
  num? totalUnits;
  num? purchasePrice;
  num? currentCost;
  num? currentValue;
  num? reliasedProfitLoss;
  num? unReliasedProfitLoss;
  num? absoluteReturn;
  String? latestDate;
  num? latestNav;
  num? xirrValue;
  List<CagrList>? cagrList;
  String? purchasePriceStr;
  String? totalUnitsStr;
  String? currentCostStr;
  String? currentValueStr;
  String? latestNavStr;
  String? unReliasedProfitLossStr;

  EquityList(
      {this.name,
      this.pan,
      this.exchangeType,
      this.equityHolderName,
      this.companyName,
      this.companyCode,
      this.sector,
      this.purchaseDate,
      this.share,
      this.price,
      this.regNo,
      this.trxnType,
      this.brokerName,
      this.dematBankName,
      this.positiveAmount,
      this.positiveUnits,
      this.totalInflow,
      this.totalOutflow,
      this.totalUnits,
      this.purchasePrice,
      this.currentCost,
      this.currentValue,
      this.reliasedProfitLoss,
      this.unReliasedProfitLoss,
      this.absoluteReturn,
      this.latestDate,
      this.latestNav,
      this.xirrValue,
      this.cagrList,
      this.purchasePriceStr,
      this.totalUnitsStr,
      this.currentCostStr,
      this.currentValueStr,
      this.latestNavStr,
      this.unReliasedProfitLossStr});

  EquityList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    pan = json['pan'];
    exchangeType = json['exchange_type'];
    equityHolderName = json['equity_holder_name'];
    companyName = json['company_name'];
    companyCode = json['company_code'];
    sector = json['sector'];
    purchaseDate = json['purchase_date'];
    share = json['share'];
    price = json['price'];
    regNo = json['reg_no'];
    trxnType = json['trxn_type'];
    brokerName = json['broker_name'];
    dematBankName = json['demat_bank_name'];
    positiveAmount = json['positive_amount'];
    positiveUnits = json['positive_units'];
    totalInflow = json['total_inflow'];
    totalOutflow = json['total_outflow'];
    totalUnits = json['total_units'];
    purchasePrice = json['purchase_price'];
    currentCost = json['current_cost'];
    currentValue = json['current_value'];
    reliasedProfitLoss = json['reliasedProfitLoss'];
    unReliasedProfitLoss = json['unReliasedProfitLoss'];
    absoluteReturn = json['absolute_return'];
    latestDate = json['latest_date'];
    latestNav = json['latest_nav'];
    xirrValue = json['xirrValue'];
    if (json['cagr_list'] != null) {
      cagrList = <CagrList>[];
      json['cagr_list'].forEach((v) {
        cagrList!.add(CagrList.fromJson(v));
      });
    }
    purchasePriceStr = json['purchase_price_str'];
    totalUnitsStr = json['total_units_str'];
    currentCostStr = json['current_cost_str'];
    currentValueStr = json['current_value_str'];
    latestNavStr = json['latest_nav_str'];
    unReliasedProfitLossStr = json['unReliasedProfitLoss_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['pan'] = pan;
    data['exchange_type'] = exchangeType;
    data['equity_holder_name'] = equityHolderName;
    data['company_name'] = companyName;
    data['company_code'] = companyCode;
    data['sector'] = sector;
    data['purchase_date'] = purchaseDate;
    data['share'] = share;
    data['price'] = price;
    data['reg_no'] = regNo;
    data['trxn_type'] = trxnType;
    data['broker_name'] = brokerName;
    data['demat_bank_name'] = dematBankName;
    data['positive_amount'] = positiveAmount;
    data['positive_units'] = positiveUnits;
    data['total_inflow'] = totalInflow;
    data['total_outflow'] = totalOutflow;
    data['total_units'] = totalUnits;
    data['purchase_price'] = purchasePrice;
    data['current_cost'] = currentCost;
    data['current_value'] = currentValue;
    data['reliasedProfitLoss'] = reliasedProfitLoss;
    data['unReliasedProfitLoss'] = unReliasedProfitLoss;
    data['absolute_return'] = absoluteReturn;
    data['latest_date'] = latestDate;
    data['latest_nav'] = latestNav;
    data['xirrValue'] = xirrValue;
    if(cagrList != null) {
      data['cagr_list'] = cagrList!.map((v) => v.toJson()).toList();
    }
    data['purchase_price_str'] = purchasePriceStr;
    data['total_units_str'] = totalUnitsStr;
    data['current_cost_str'] = currentCostStr;
    data['current_value_str'] = currentValueStr;
    data['latest_nav_str'] = latestNavStr;
    data['unReliasedProfitLoss_str'] = unReliasedProfitLossStr;
    return data;
  }
}

class CagrList {
  String? trxnType;
  String? trxnDate;
  num? nav;
  num? units;
  num? amount;
  num? stampDuty;
  num? trCharges;
  num? stt;
  num? checkUnits;
  num? totalUnits;

  CagrList(
      {this.trxnType,
      this.trxnDate,
      this.nav,
      this.units,
      this.amount,
      this.stampDuty,
      this.trCharges,
      this.stt,
      this.checkUnits,
      this.totalUnits});

  CagrList.fromJson(Map<String, dynamic> json) {
    trxnType = json['trxn_type'];
    trxnDate = json['trxn_date'];
    nav = json['nav'];
    units = json['units'];
    amount = json['amount'];
    stampDuty = json['stamp_duty'];
    trCharges = json['tr_charges'];
    stt = json['stt'];
    checkUnits = json['check_units'];
    totalUnits = json['total_units'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trxn_type'] = trxnType;
    data['trxn_date'] = trxnDate;
    data['nav'] = nav;
    data['units'] = units;
    data['amount'] = amount;
    data['stamp_duty'] = stampDuty;
    data['tr_charges'] = trCharges;
    data['stt'] = stt;
    data['check_units'] = checkUnits;
    data['total_units'] = totalUnits;
    return data;
  }
}

class PrivateEquity {
  String? name;
  String? pan;
  String? exchangeType;
  String? equityHolderName;
  String? companyName;
  String? companyCode;
  String? sector;
  String? purchaseDate;
  num? share;
  num? price;
  String? regNo;
  String? trxnType;
  String? brokerName;
  String? dematBankName;
  num? positiveAmount;
  num? positiveUnits;
  num? totalInflow;
  num? totalOutflow;
  num? totalUnits;
  num? purchasePrice;
  num? currentCost;
  num? currentValue;
  num? reliasedProfitLoss;
  num? unReliasedProfitLoss;
  num? absoluteReturn;
  String? latestDate;
  num? latestNav;
  num? xirrValue;
  List<CagrList>? cagrList;
  String? purchasePriceStr;
  String? totalUnitsStr;
  String? currentCostStr;
  String? currentValueStr;
  String? latestNavStr;
  String? unReliasedProfitLossStr;

  PrivateEquity(
      {this.name,
      this.pan,
      this.exchangeType,
      this.equityHolderName,
      this.companyName,
      this.companyCode,
      this.sector,
      this.purchaseDate,
      this.share,
      this.price,
      this.regNo,
      this.trxnType,
      this.brokerName,
      this.dematBankName,
      this.positiveAmount,
      this.positiveUnits,
      this.totalInflow,
      this.totalOutflow,
      this.totalUnits,
      this.purchasePrice,
      this.currentCost,
      this.currentValue,
      this.reliasedProfitLoss,
      this.unReliasedProfitLoss,
      this.absoluteReturn,
      this.latestDate,
      this.latestNav,
      this.xirrValue,
      this.cagrList,
      this.purchasePriceStr,
      this.totalUnitsStr,
      this.currentCostStr,
      this.currentValueStr,
      this.latestNavStr,
      this.unReliasedProfitLossStr});

  PrivateEquity.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    pan = json['pan'];
    exchangeType = json['exchange_type'];
    equityHolderName = json['equity_holder_name'];
    companyName = json['company_name'];
    companyCode = json['company_code'];
    sector = json['sector'];
    purchaseDate = json['purchase_date'];
    share = json['share'];
    price = json['price'];
    regNo = json['reg_no'];
    trxnType = json['trxn_type'];
    brokerName = json['broker_name'];
    dematBankName = json['demat_bank_name'];
    positiveAmount = json['positive_amount'];
    positiveUnits = json['positive_units'];
    totalInflow = json['total_inflow'];
    totalOutflow = json['total_outflow'];
    totalUnits = json['total_units'];
    purchasePrice = json['purchase_price'];
    currentCost = json['current_cost'];
    currentValue = json['current_value'];
    reliasedProfitLoss = json['reliasedProfitLoss'];
    unReliasedProfitLoss = json['unReliasedProfitLoss'];
    absoluteReturn = json['absolute_return'];
    latestDate = json['latest_date'];
    latestNav = json['latest_nav'];
    xirrValue = json['xirrValue'];
    if (json['list'] != null) {
      cagrList = <CagrList>[];
      json['list'].forEach((v) {
        cagrList!.add(CagrList.fromJson(v));
      });
    }
    purchasePriceStr = json['purchase_price_str'];
    totalUnitsStr = json['total_units_str'];
    currentCostStr = json['current_cost_str'];
    currentValueStr = json['current_value_str'];
    latestNavStr = json['latest_nav_str'];
    unReliasedProfitLossStr = json['unReliasedProfitLoss_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['pan'] = pan;
    data['exchange_type'] = exchangeType;
    data['equity_holder_name'] = equityHolderName;
    data['company_name'] = companyName;
    data['company_code'] = companyCode;
    data['sector'] = sector;
    data['purchase_date'] = purchaseDate;
    data['share'] = share;
    data['price'] = price;
    data['reg_no'] = regNo;
    data['trxn_type'] = trxnType;
    data['broker_name'] = brokerName;
    data['demat_bank_name'] = dematBankName;
    data['positive_amount'] = positiveAmount;
    data['positive_units'] = positiveUnits;
    data['total_inflow'] = totalInflow;
    data['total_outflow'] = totalOutflow;
    data['total_units'] = totalUnits;
    data['purchase_price'] = purchasePrice;
    data['current_cost'] = currentCost;
    data['current_value'] = currentValue;
    data['reliasedProfitLoss'] = reliasedProfitLoss;
    data['unReliasedProfitLoss'] = unReliasedProfitLoss;
    data['absolute_return'] = absoluteReturn;
    data['latest_date'] = latestDate;
    data['latest_nav'] = latestNav;
    data['xirrValue'] = xirrValue;
    if(cagrList != null) {
      data['cagr_list'] = cagrList!.map((v) => v.toJson()).toList();
    }
    data['purchase_price_str'] = purchasePriceStr;
    data['total_units_str'] = totalUnitsStr;
    data['current_cost_str'] = currentCostStr;
    data['current_value_str'] = currentValueStr;
    data['latest_nav_str'] = latestNavStr;
    data['unReliasedProfitLoss_str'] = unReliasedProfitLossStr;
    return data;
  }
}

class Structured {
  num? structuredCurrentCost;
  num? structuredCurrentValue;
  num? structuredDividendValue;
  num? structuredUnrealised;
  num? structuredMaturityValue;
  num? structuredReturn;
  num? xirrValue;
  List<StructuredList>? structuredList;

  Structured(
      {this.structuredCurrentCost,
      this.structuredCurrentValue,
      this.structuredDividendValue,
      this.structuredUnrealised,
      this.structuredMaturityValue,
      this.structuredReturn,
      this.xirrValue,
      this.structuredList});

  Structured.fromJson(Map<String, dynamic> json) {
    structuredCurrentCost = json['structured_current_cost'];
    structuredCurrentValue = json['structured_current_value'];
    structuredDividendValue = json['structured_dividend_value'];
    structuredUnrealised = json['structured_unrealised'];
    structuredMaturityValue = json['structured_maturity_value'];
    structuredReturn = json['structured_return'];
    xirrValue = json['xirrValue'];
    if (json['list'] != null) {
      structuredList = <StructuredList>[];
      json['list'].forEach((v) {
        structuredList!.add(StructuredList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['structured_current_cost'] = structuredCurrentCost;
    data['structured_current_value'] = structuredCurrentValue;
    data['structured_dividend_value'] = structuredDividendValue;
    data['structured_unrealised'] = structuredUnrealised;
    data['structured_maturity_value'] = structuredMaturityValue;
    data['structured_return'] = structuredReturn;
    data['xirrValue'] = xirrValue;
    if(structuredList != null) {
      data['structuredList'] = structuredList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StructuredList {
  num? id;
  String? name;
  String? pan;
  String? investorName;
  String? serviceProviderName;
  String? transactionDate;
  String? trxnType;
  String? schemeName;
  num? amount;
  num? tenure;
  String? tenureType;
  String? maturityDate;
  num? maturityValue;
  String? currentValueDate;
  num? currentValue;
  num? dividendValue;
  num? initialNiftyValue;
  num? currentNiftyValue;
  String? clientName;
  num? userId;
  num? gainLoss;
  String? amountStr;
  String? currentValueStr;
  String? maturityValueStr;
  String? gainLossStr;
  String? dividendValueStr;

  StructuredList(
      {this.id,
      this.name,
      this.pan,
      this.investorName,
      this.serviceProviderName,
      this.transactionDate,
      this.trxnType,
      this.schemeName,
      this.amount,
      this.tenure,
      this.tenureType,
      this.maturityDate,
      this.maturityValue,
      this.currentValueDate,
      this.currentValue,
      this.dividendValue,
      this.initialNiftyValue,
      this.currentNiftyValue,
      this.clientName,
      this.userId,
      this.gainLoss,
      this.amountStr,
      this.currentValueStr,
      this.maturityValueStr,
      this.gainLossStr,
      this.dividendValueStr});

  StructuredList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pan = json['pan'];
    investorName = json['investor_name'];
    serviceProviderName = json['service_provider_name'];
    transactionDate = json['transaction_date'];
    trxnType = json['trxn_type'];
    schemeName = json['scheme_name'];
    amount = json['amount'];
    tenure = json['tenure'];
    tenureType = json['tenure_type'];
    maturityDate = json['maturity_date'];
    maturityValue = json['maturity_value'];
    currentValueDate = json['current_value_date'];
    currentValue = json['current_value'];
    dividendValue = json['dividend_value'];
    initialNiftyValue = json['initial_nifty_value'];
    currentNiftyValue = json['current_nifty_value'];
    clientName = json['client_name'];
    userId = json['user_id'];
    gainLoss = json['gainLoss'];
    amountStr = json['amount_str'];
    currentValueStr = json['current_value_str'];
    maturityValueStr = json['maturity_value_str'];
    gainLossStr = json['gainLoss_str'];
    dividendValueStr = json['dividend_value_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pan'] = pan;
    data['investor_name'] = investorName;
    data['service_provider_name'] = serviceProviderName;
    data['transaction_date'] = transactionDate;
    data['trxn_type'] = trxnType;
    data['scheme_name'] = schemeName;
    data['amount'] = amount;
    data['tenure'] = tenure;
    data['tenure_type'] = tenureType;
    data['maturity_date'] = maturityDate;
    data['maturity_value'] = maturityValue;
    data['current_value_date'] = currentValueDate;
    data['current_value'] = currentValue;
    data['dividend_value'] = dividendValue;
    data['initial_nifty_value'] = initialNiftyValue;
    data['current_nifty_value'] = currentNiftyValue;
    data['client_name'] = clientName;
    data['user_id'] = userId;
    data['gainLoss'] = gainLoss;
    data['amount_str'] = amountStr;
    data['current_value_str'] = currentValueStr;
    data['maturity_value_str'] = maturityValueStr;
    data['gainLoss_str'] = gainLossStr;
    data['dividend_value_str'] = dividendValueStr;
    return data;
  }
}

class Pms {
  num? pmsCurrentCost;
  num? pmsCurrentValue;
  num? pmsUnrealised;
  num? pmsDividend;
  num? pmsGainLoss;
  num? pmsAbsRet;
  num? pmsXirrValue;
  List<PmsList>? pmsList;

  Pms(
      {this.pmsCurrentCost,
      this.pmsCurrentValue,
      this.pmsUnrealised,
      this.pmsDividend,
      this.pmsGainLoss,
      this.pmsAbsRet,
      this.pmsXirrValue,
      this.pmsList});

  Pms.fromJson(Map<String, dynamic> json) {
    pmsCurrentCost = json['pms_current_cost'];
    pmsCurrentValue = json['pms_current_value'];
    pmsUnrealised = json['pms_unrealised'];
    pmsDividend = json['pms_dividend'];
    pmsGainLoss = json['pms_gain_loss'];
    pmsAbsRet = json['pms_abs_ret'];
    pmsXirrValue = json['pms_xirrValue'];
    if (json['list'] != null) {
      pmsList = <PmsList>[];
      json['list'].forEach((v) {
        pmsList!.add(PmsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pms_current_cost'] = pmsCurrentCost;
    data['pms_current_value'] = pmsCurrentValue;
    data['pms_unrealised'] = pmsUnrealised;
    data['pms_dividend'] = pmsDividend;
    data['pms_gain_loss'] = pmsGainLoss;
    data['pms_abs_ret'] = pmsAbsRet;
    data['pms_xirrValue'] = pmsXirrValue;
    if(pmsList != null) {
      data['pmsList'] = pmsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PmsList {
  num? id;
  String? name;
  String? pan;
  String? investorName;
  String? serviceProviderName;
  String? transactionDate;
  String? schemeName;
  num? amount;
  String? maturityDate;
  num? maturityValue;
  String? trxnType;
  String? currentValueDate;
  num? currentValue;
  num? dividendValue;
  String? clientName;
  num? userId;
  String? pmsAccNo;
  String? transactionDateStr;
  num? unRealisedGain;
  num? absReturn;
  num? xirr;
  String? amountStr;
  String? currentValueStr;
  String? unRealisedGainStr;
  String? dividendValueStr;
  num? holdingAmount;
  String? holdingAmountStr;

  PmsList(
      {this.id,
      this.name,
      this.pan,
      this.investorName,
      this.serviceProviderName,
      this.transactionDate,
      this.schemeName,
      this.amount,
      this.maturityDate,
      this.maturityValue,
      this.trxnType,
      this.currentValueDate,
      this.currentValue,
      this.dividendValue,
      this.clientName,
      this.userId,
      this.pmsAccNo,
      this.transactionDateStr,
      this.unRealisedGain,
      this.absReturn,
      this.xirr,
      this.amountStr,
      this.currentValueStr,
      this.unRealisedGainStr,
      this.dividendValueStr,
      this.holdingAmount,
      this.holdingAmountStr});

  PmsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pan = json['pan'];
    investorName = json['investor_name'];
    serviceProviderName = json['service_provider_name'];
    transactionDate = json['transaction_date'];
    schemeName = json['scheme_name'];
    amount = json['amount'];
    maturityDate = json['maturity_date'];
    maturityValue = json['maturity_value'];
    trxnType = json['trxn_type'];
    currentValueDate = json['current_value_date'];
    currentValue = json['current_value'];
    dividendValue = json['dividend_value'];
    clientName = json['client_name'];
    userId = json['user_id'];
    pmsAccNo = json['pms_acc_no'];
    transactionDateStr = json['transaction_date_str'];
    unRealisedGain = json['unRealisedGain'];
    absReturn = json['abs_return'];
    xirr = json['xirr'];
    amountStr = json['amount_str'];
    currentValueStr = json['current_value_str'];
    unRealisedGainStr = json['unRealisedGain_str'];
    dividendValueStr = json['dividend_value_str'];
    holdingAmount = json['holding_amount'];
    holdingAmountStr = json['holding_amount_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pan'] = pan;
    data['investor_name'] = investorName;
    data['service_provider_name'] = serviceProviderName;
    data['transaction_date'] = transactionDate;
    data['scheme_name'] = schemeName;
    data['amount'] = amount;
    data['maturity_date'] = maturityDate;
    data['maturity_value'] = maturityValue;
    data['trxn_type'] = trxnType;
    data['current_value_date'] = currentValueDate;
    data['current_value'] = currentValue;
    data['dividend_value'] = dividendValue;
    data['client_name'] = clientName;
    data['user_id'] = userId;
    data['pms_acc_no'] = pmsAccNo;
    data['transaction_date_str'] = transactionDateStr;
    data['unRealisedGain'] = unRealisedGain;
    data['abs_return'] = absReturn;
    data['xirr'] = xirr;
    data['amount_str'] = amountStr;
    data['current_value_str'] = currentValueStr;
    data['unRealisedGain_str'] = unRealisedGainStr;
    data['dividend_value_str'] = dividendValueStr;
    data['holding_amount'] = holdingAmount;
    data['holding_amount_str'] = holdingAmountStr;
    return data;
  }
}

class Commodity {
  num? commodityShares;
  num? commodityCurrentCost;
  num? commodityCurrentValue;
  num? commodityUnrealised;
  num? commodityReturn;
  num? commodityXirr;
  List<CommodityList>? commodityList;

  Commodity(
      {this.commodityShares,
      this.commodityCurrentCost,
      this.commodityCurrentValue,
      this.commodityUnrealised,
      this.commodityReturn,
      this.commodityXirr,
      this.commodityList});

  Commodity.fromJson(Map<String, dynamic> json) {
    commodityShares = json['commodity_shares'];
    commodityCurrentCost = json['commodity_current_cost'];
    commodityCurrentValue = json['commodity_current_value'];
    commodityUnrealised = json['commodity_unrealised'];
    commodityReturn = json['commodity_return'];
    commodityXirr = json['commodity_xirr'];
    if (json['list'] != null) {
      commodityList = <CommodityList>[];
      json['list'].forEach((v) {
        commodityList!.add(CommodityList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commodity_shares'] = commodityShares;
    data['commodity_current_cost'] = commodityCurrentCost;
    data['commodity_current_value'] = commodityCurrentValue;
    data['commodity_unrealised'] = commodityUnrealised;
    data['commodity_return'] = commodityReturn;
    data['commodity_xirr'] = commodityXirr;
    if(commodityList != null) {
      data['commodityList'] = commodityList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommodityList {
  num? id;
  String? name;
  String? pan;
  String? investorName;
  String? commodityName;
  String? purchaseDate;
  num? quantity;
  num? price;
  String? trxnType;
  num? positiveAmount;
  num? positiveUnits;
  num? totalInflow;
  num? totalOutflow;
  num? totalUnits;
  num? purchasePrice;
  num? currentCost;
  num? currentValue;
  num? reliasedProfitLoss;
  num? unReliasedProfitLoss;
  String? latestDate;
  num? latestNav;
  num? xirrValue;

  CommodityList(
      {this.id,
      this.name,
      this.pan,
      this.investorName,
      this.commodityName,
      this.purchaseDate,
      this.quantity,
      this.price,
      this.trxnType,
      this.positiveAmount,
      this.positiveUnits,
      this.totalInflow,
      this.totalOutflow,
      this.totalUnits,
      this.purchasePrice,
      this.currentCost,
      this.currentValue,
      this.reliasedProfitLoss,
      this.unReliasedProfitLoss,
      this.latestDate,
      this.latestNav,
      this.xirrValue});

  CommodityList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pan = json['pan'];
    investorName = json['investor_name'];
    commodityName = json['commodity_name'];
    purchaseDate = json['purchase_date'];
    quantity = json['quantity'];
    price = json['price'];
    trxnType = json['trxn_type'];
    positiveAmount = json['positive_amount'];
    positiveUnits = json['positive_units'];
    totalInflow = json['total_inflow'];
    totalOutflow = json['total_outflow'];
    totalUnits = json['total_units'];
    purchasePrice = json['purchase_price'];
    currentCost = json['current_cost'];
    currentValue = json['current_value'];
    reliasedProfitLoss = json['reliasedProfitLoss'];
    unReliasedProfitLoss = json['unReliasedProfitLoss'];
    latestDate = json['latest_date'];
    latestNav = json['latest_nav'];
    xirrValue = json['xirrValue'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pan'] = pan;
    data['investor_name'] = investorName;
    data['commodity_name'] = commodityName;
    data['purchase_date'] = purchaseDate;
    data['quantity'] = quantity;
    data['price'] = price;
    data['trxn_type'] = trxnType;
    data['positive_amount'] = positiveAmount;
    data['positive_units'] = positiveUnits;
    data['total_inflow'] = totalInflow;
    data['total_outflow'] = totalOutflow;
    data['total_units'] = totalUnits;
    data['purchase_price'] = purchasePrice;
    data['current_cost'] = currentCost;
    data['current_value'] = currentValue;
    data['reliasedProfitLoss'] = reliasedProfitLoss;
    data['unReliasedProfitLoss'] = unReliasedProfitLoss;
    data['latest_date'] = latestDate;
    data['latest_nav'] = latestNav;
    data['xirrValue'] = xirrValue;

    return data;
  }
}

class Gold {
  num? goldTotalCurrentCost;
  num? goldTotalCurrentValue;
  num? goldTotalUnrealisedProfitLoss;
  num? goldTotalReturn;
  num? goldXirr;
  List<GoldList>? goldList;

  Gold(
      {this.goldTotalCurrentCost,
      this.goldTotalCurrentValue,
      this.goldTotalUnrealisedProfitLoss,
      this.goldTotalReturn,
      this.goldXirr,
      this.goldList});

  Gold.fromJson(Map<String, dynamic> json) {
    goldTotalCurrentCost = json['gold_total_current_cost'];
    goldTotalCurrentValue = json['gold_total_current_value'];
    goldTotalUnrealisedProfitLoss = json['gold_total_unrealised_profit_loss'];
    goldTotalReturn = json['gold_total_return'];
    goldXirr = json['gold_xirr'];
    if (json['list'] != null) {
      goldList = <GoldList>[];
      json['list'].forEach((v) {
        goldList!.add(GoldList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gold_total_current_cost'] = goldTotalCurrentCost;
    data['gold_total_current_value'] = goldTotalCurrentValue;
    data['gold_total_unrealised_profit_loss'] = goldTotalUnrealisedProfitLoss;
    data['gold_total_return'] = goldTotalReturn;
    data['gold_xirr'] = goldXirr;
    if(goldList != null) {
      data['goldList'] = goldList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GoldList {
  num? id;
  num? userId;
  String? name;
  String? pan;
  String? goldType;
  String? investorName;
  String? exchangeType;
  String? companyName;
  String? companyCode;
  String? schemeName;
  String? schemeCode;
  String? folioNo;
  String? purchaseDate;
  num? quantity;
  num? price;
  String? trxnType;
  num? amount;
  num? positiveAmount;
  num? positiveUnits;
  num? totalInflow;
  num? totalOutflow;
  num? totalUnits;
  num? purchasePrice;
  num? currentCost;
  num? currentValue;
  num? reliasedProfitLoss;
  num? unReliasedProfitLoss;
  String? latestDate;
  num? latestNav;
  num? xirrValue;

  GoldList(
      {this.id,
      this.userId,
      this.name,
      this.pan,
      this.goldType,
      this.investorName,
      this.exchangeType,
      this.companyName,
      this.companyCode,
      this.schemeName,
      this.schemeCode,
      this.folioNo,
      this.purchaseDate,
      this.quantity,
      this.price,
      this.trxnType,
      this.amount,
      this.positiveAmount,
      this.positiveUnits,
      this.totalInflow,
      this.totalOutflow,
      this.totalUnits,
      this.purchasePrice,
      this.currentCost,
      this.currentValue,
      this.reliasedProfitLoss,
      this.unReliasedProfitLoss,
      this.latestDate,
      this.latestNav,
      this.xirrValue,
      });

  GoldList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    pan = json['pan'];
    goldType = json['gold_type'];
    investorName = json['investor_name'];
    exchangeType = json['exchange_type'];
    companyName = json['company_name'];
    companyCode = json['company_code'];
    schemeName = json['scheme_name'];
    schemeCode = json['scheme_code'];
    folioNo = json['folio_no'];
    purchaseDate = json['purchase_date'];
    quantity = json['quantity'];
    price = json['price'];
    trxnType = json['trxn_type'];
    amount = json['amount'];
    positiveAmount = json['positive_amount'];
    positiveUnits = json['positive_units'];
    totalInflow = json['total_inflow'];
    totalOutflow = json['total_outflow'];
    totalUnits = json['total_units'];
    purchasePrice = json['purchase_price'];
    currentCost = json['current_cost'];
    currentValue = json['current_value'];
    reliasedProfitLoss = json['reliasedProfitLoss'];
    unReliasedProfitLoss = json['unReliasedProfitLoss'];
    latestDate = json['latest_date'];
    latestNav = json['latest_nav'];
    xirrValue = json['xirrValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['pan'] = pan;
    data['gold_type'] = goldType;
    data['investor_name'] = investorName;
    data['exchange_type'] = exchangeType;
    data['company_name'] = companyName;
    data['company_code'] = companyCode;
    data['scheme_name'] = schemeName;
    data['scheme_code'] = schemeCode;
    data['folio_no'] = folioNo;
    data['purchase_date'] = purchaseDate;
    data['quantity'] = quantity;
    data['price'] = price;
    data['trxn_type'] = trxnType;
    data['amount'] = amount;
    data['positive_amount'] = positiveAmount;
    data['positive_units'] = positiveUnits;
    data['total_inflow'] = totalInflow;
    data['total_outflow'] = totalOutflow;
    data['total_units'] = totalUnits;
    data['purchase_price'] = purchasePrice;
    data['current_cost'] = currentCost;
    data['current_value'] = currentValue;
    data['reliasedProfitLoss'] = reliasedProfitLoss;
    data['unReliasedProfitLoss'] = unReliasedProfitLoss;
    data['latest_date'] = latestDate;
    data['latest_nav'] = latestNav;
    data['xirrValue'] = xirrValue;
    return data;
  }
}

class Nps {
  num? npsCurrentCost;
  num? npsCurrentValue;
  num? npsUnrealised;
  num? npsRealised;
  num? npsTotalReturn;
  num? npsXirr;
  List<NpsList>? npsList;

  Nps(
      {this.npsCurrentCost,
      this.npsCurrentValue,
      this.npsUnrealised,
      this.npsRealised,
      this.npsTotalReturn,
      this.npsXirr,
      this.npsList});

  Nps.fromJson(Map<String, dynamic> json) {
    npsCurrentCost = json['nps_current_cost'];
    npsCurrentValue = json['nps_current_value'];
    npsUnrealised = json['nps_unrealised'];
    npsRealised = json['nps_realised'];
    npsTotalReturn = json['nps_total_return'];
    npsXirr = json['nps_xirr'];
    if (json['list'] != null) {
      npsList = <NpsList>[];
      json['list'].forEach((v) {
        npsList!.add(NpsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nps_current_cost'] = npsCurrentCost;
    data['nps_current_value'] = npsCurrentValue;
    data['nps_unrealised'] = npsUnrealised;
    data['nps_realised'] = npsRealised;
    data['nps_total_return'] = npsTotalReturn;
    data['nps_xirr'] = npsXirr;
    if(npsList != null) {
      data['npsList'] = npsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NpsList {
  num? id;
  String? name;
  String? pan;
  String? investorName;
  String? pranNumber;
  String? investorDob;
  String? pensionFundName;
  String? accountType;
  String? investmentOption;
  String? investmentDate;
  String? scheme1;
  String? scheme2;
  String? scheme3;
  String? scheme4;
  num? scheme1Percent;
  num? scheme2Percent;
  num? scheme3Percent;
  num? scheme4Percent;
  num? contributionCount;
  num? totalContributionAmount;
  num? totalWithdrawalAmount;
  String? totalCurrentValueDate;
  num? totalCurrentValue;
  num? schemeEAmount;
  num? schemeEUnits;
  num? schemeENav;
  num? schemeCAmount;
  num? schemeCUnits;
  num? schemeCNav;
  num? schemeGAmount;
  num? schemeGUnits;
  num? schemeGNav;
  num? schemeAAmount;
  num? schemeAUnits;
  num? schemeANav;
  String? nomineeName;
  String? nomineeRelation;
  String? clientName;
  num? userId;
  String? totalContributionAmountStr;
  String? totalWithdrawalAmountStr;
  String? totalCurrentValueStr;
  String? totalGainLossStr;

  NpsList(
      {this.id,
      this.name,
      this.pan,
      this.investorName,
      this.pranNumber,
      this.investorDob,
      this.pensionFundName,
      this.accountType,
      this.investmentOption,
      this.investmentDate,
      this.scheme1,
      this.scheme2,
      this.scheme3,
      this.scheme4,
      this.scheme1Percent,
      this.scheme2Percent,
      this.scheme3Percent,
      this.scheme4Percent,
      this.contributionCount,
      this.totalContributionAmount,
      this.totalWithdrawalAmount,
      this.totalCurrentValueDate,
      this.totalCurrentValue,
      this.schemeEAmount,
      this.schemeEUnits,
      this.schemeENav,
      this.schemeCAmount,
      this.schemeCUnits,
      this.schemeCNav,
      this.schemeGAmount,
      this.schemeGUnits,
      this.schemeGNav,
      this.schemeAAmount,
      this.schemeAUnits,
      this.schemeANav,
      this.nomineeName,
      this.nomineeRelation,
      this.clientName,
      this.userId,
      this.totalContributionAmountStr,
      this.totalWithdrawalAmountStr,
      this.totalCurrentValueStr,
      this.totalGainLossStr});

  NpsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pan = json['pan'];
    investorName = json['investor_name'];
    pranNumber = json['pran_number'];
    investorDob = json['investor_dob'];
    pensionFundName = json['pension_fund_name'];
    accountType = json['account_type'];
    investmentOption = json['investment_option'];
    investmentDate = json['investment_date'];
    scheme1 = json['scheme1'];
    scheme2 = json['scheme2'];
    scheme3 = json['scheme3'];
    scheme4 = json['scheme4'];
    scheme1Percent = json['scheme1_percent'];
    scheme2Percent = json['scheme2_percent'];
    scheme3Percent = json['scheme3_percent'];
    scheme4Percent = json['scheme4_percent'];
    contributionCount = json['contribution_count'];
    totalContributionAmount = json['total_contribution_amount'];
    totalWithdrawalAmount = json['total_withdrawal_amount'];
    totalCurrentValueDate = json['total_current_value_date'];
    totalCurrentValue = json['total_current_value'];
    schemeEAmount = json['scheme_e_amount'];
    schemeEUnits = json['scheme_e_units'];
    schemeENav = json['scheme_e_nav'];
    schemeCAmount = json['scheme_c_amount'];
    schemeCUnits = json['scheme_c_units'];
    schemeCNav = json['scheme_c_nav'];
    schemeGAmount = json['scheme_g_amount'];
    schemeGUnits = json['scheme_g_units'];
    schemeGNav = json['scheme_g_nav'];
    schemeAAmount = json['scheme_a_amount'];
    schemeAUnits = json['scheme_a_units'];
    schemeANav = json['scheme_a_nav'];
    nomineeName = json['nominee_name'];
    nomineeRelation = json['nominee_relation'];
    clientName = json['client_name'];
    userId = json['user_id'];
    totalContributionAmountStr = json['total_contribution_amount_str'];
    totalWithdrawalAmountStr = json['total_withdrawal_amount_str'];
    totalCurrentValueStr = json['total_current_value_str'];
    totalGainLossStr = json['total_gain_loss_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pan'] = pan;
    data['investor_name'] = investorName;
    data['pran_number'] = pranNumber;
    data['investor_dob'] = investorDob;
    data['pension_fund_name'] = pensionFundName;
    data['account_type'] = accountType;
    data['investment_option'] = investmentOption;
    data['investment_date'] = investmentDate;
    data['scheme1'] = scheme1;
    data['scheme2'] = scheme2;
    data['scheme3'] = scheme3;
    data['scheme4'] = scheme4;
    data['scheme1_percent'] = scheme1Percent;
    data['scheme2_percent'] = scheme2Percent;
    data['scheme3_percent'] = scheme3Percent;
    data['scheme4_percent'] = scheme4Percent;
    data['contribution_count'] = contributionCount;
    data['total_contribution_amount'] = totalContributionAmount;
    data['total_withdrawal_amount'] = totalWithdrawalAmount;
    data['total_current_value_date'] = totalCurrentValueDate;
    data['total_current_value'] = totalCurrentValue;
    data['scheme_e_amount'] = schemeEAmount;
    data['scheme_e_units'] = schemeEUnits;
    data['scheme_e_nav'] = schemeENav;
    data['scheme_c_amount'] = schemeCAmount;
    data['scheme_c_units'] = schemeCUnits;
    data['scheme_c_nav'] = schemeCNav;
    data['scheme_g_amount'] = schemeGAmount;
    data['scheme_g_units'] = schemeGUnits;
    data['scheme_g_nav'] = schemeGNav;
    data['scheme_a_amount'] = schemeAAmount;
    data['scheme_a_units'] = schemeAUnits;
    data['scheme_a_nav'] = schemeANav;
    data['nominee_name'] = nomineeName;
    data['nominee_relation'] = nomineeRelation;
    data['client_name'] = clientName;
    data['user_id'] = userId;
    data['total_contribution_amount_str'] = totalContributionAmountStr;
    data['total_withdrawal_amount_str'] = totalWithdrawalAmountStr;
    data['total_current_value_str'] = totalCurrentValueStr;
    data['total_gain_loss_str'] = totalGainLossStr;
    return data;
  }
}

class Aif {
  num? aifCurrCost;
  num? aifCurrValue;
  num? aifUnrealised;
  num? aifMaturityValue;
  num? aifAbs;
  num? aifXirr;
  List<AifList>? aifList;

  Aif(
      {this.aifCurrCost,
      this.aifCurrValue,
      this.aifUnrealised,
      this.aifMaturityValue,
      this.aifAbs,
      this.aifXirr,
      this.aifList});

  Aif.fromJson(Map<String, dynamic> json) {
    aifCurrCost = json['aif_curr_cost'];
    aifCurrValue = json['aif_curr_value'];
    aifUnrealised = json['aif_unrealised'];
    aifMaturityValue = json['aif_maturity_value'];
    aifAbs = json['aif_abs'];
    aifXirr = json['aif_xirr'];
    if (json['list'] != null) {
      aifList = <AifList>[];
      json['list'].forEach((v) {
        aifList!.add(AifList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aif_curr_cost'] = aifCurrCost;
    data['aif_curr_value'] = aifCurrValue;
    data['aif_unrealised'] = aifUnrealised;
    data['aif_maturity_value'] = aifMaturityValue;
    data['aif_abs'] = aifAbs;
    data['aif_xirr'] = aifXirr;
    if(aifList != null) {
      data['aifList'] = aifList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AifList {
  num? userId;
  String? investorName;
  String? providerName;
  String? fundName;
  num? commitedAmt;
  num? setupCost;
  num? contributedAmt;
  num? outstandingCapAmt;
  num? totalUnits;
  num? distributedAmt;
  num? realisedGainAmt;
  num? currentValue;
  num? currNav;
  num? tdsAmt;
  String? currNavDate;
  num? xirr;
  String? commitedAmtStr;
  String? setupCostStr;
  String? contributedAmtStr;
  String? outstandingCapAmtStr;
  String? distributedAmtStr;
  String? realisedGainAmtStr;
  String? tdsAmtStr;
  String? currentValueStr;

  AifList(
      {this.userId,
      this.investorName,
      this.providerName,
      this.fundName,
      this.commitedAmt,
      this.setupCost,
      this.contributedAmt,
      this.outstandingCapAmt,
      this.totalUnits,
      this.distributedAmt,
      this.realisedGainAmt,
      this.currentValue,
      this.currNav,
      this.tdsAmt,
      this.currNavDate,
      this.xirr,
      this.commitedAmtStr,
      this.setupCostStr,
      this.contributedAmtStr,
      this.outstandingCapAmtStr,
      this.distributedAmtStr,
      this.realisedGainAmtStr,
      this.tdsAmtStr,
      this.currentValueStr});

  AifList.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    investorName = json['investor_name'];
    providerName = json['provider_name'];
    fundName = json['fund_name'];
    commitedAmt = json['commited_amt'];
    setupCost = json['setup_cost'];
    contributedAmt = json['contributed_amt'];
    outstandingCapAmt = json['outstanding_cap_amt'];
    totalUnits = json['total_units'];
    distributedAmt = json['distributed_amt'];
    realisedGainAmt = json['realised_gain_amt'];
    currentValue = json['current_value'];
    currNav = json['curr_nav'];
    tdsAmt = json['tds_amt'];
    currNavDate = json['curr_nav_date'];
    xirr = json['xirr'];
    commitedAmtStr = json['commited_amt_str'];
    setupCostStr = json['setup_cost_str'];
    contributedAmtStr = json['contributed_amt_str'];
    outstandingCapAmtStr = json['outstanding_cap_amt_str'];
    distributedAmtStr = json['distributed_amt_str'];
    realisedGainAmtStr = json['realised_gain_amt_str'];
    tdsAmtStr = json['tds_amt_str'];
    currentValueStr = json['current_value_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['investor_name'] = investorName;
    data['provider_name'] = providerName;
    data['fund_name'] = fundName;
    data['commited_amt'] = commitedAmt;
    data['setup_cost'] = setupCost;
    data['contributed_amt'] = contributedAmt;
    data['outstanding_cap_amt'] = outstandingCapAmt;
    data['total_units'] = totalUnits;
    data['distributed_amt'] = distributedAmt;
    data['realised_gain_amt'] = realisedGainAmt;
    data['current_value'] = currentValue;
    data['curr_nav'] = currNav;
    data['tds_amt'] = tdsAmt;
    data['curr_nav_date'] = currNavDate;
    data['xirr'] = xirr;
    data['commited_amt_str'] = commitedAmtStr;
    data['setup_cost_str'] = setupCostStr;
    data['contributed_amt_str'] = contributedAmtStr;
    data['outstanding_cap_amt_str'] = outstandingCapAmtStr;
    data['distributed_amt_str'] = distributedAmtStr;
    data['realised_gain_amt_str'] = realisedGainAmtStr;
    data['tds_amt_str'] = tdsAmtStr;
    data['current_value_str'] = currentValueStr;
    return data;
  }
}

class RealestatePms {
  num? realEstatePmsCurrentCost;
  num? realEstatePmsCurrentValue;
  num? realEstatePmsUnrealised;
  num? realEstatePmsMaturityValue;
  num? realEstatePmsReturn;
  num? realEstateXirr;
  List<RealestatePmsList>? realestatePmsList;

  RealestatePms(
      {this.realEstatePmsCurrentCost,
      this.realEstatePmsCurrentValue,
      this.realEstatePmsUnrealised,
      this.realEstatePmsMaturityValue,
      this.realEstatePmsReturn,
      this.realEstateXirr,
      this.realestatePmsList});

  RealestatePms.fromJson(Map<String, dynamic> json) {
    realEstatePmsCurrentCost = json['real_estate_pms_current_cost'];
    realEstatePmsCurrentValue = json['real_estate_pms_current_value'];
    realEstatePmsUnrealised = json['real_estate_pms_unrealised'];
    realEstatePmsMaturityValue = json['real_estate_pms_maturity_value'];
    realEstatePmsReturn = json['real_estate_pms_return'];
    realEstateXirr = json['real_estate_xirr'];
    if (json['list'] != null) {
      realestatePmsList = <RealestatePmsList>[];
      json['list'].forEach((v) {
        realestatePmsList!.add(RealestatePmsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['real_estate_pms_current_cost'] = realEstatePmsCurrentCost;
    data['real_estate_pms_current_value'] = realEstatePmsCurrentValue;
    data['real_estate_pms_unrealised'] = realEstatePmsUnrealised;
    data['real_estate_pms_maturity_value'] = realEstatePmsMaturityValue;
    data['real_estate_pms_return'] = realEstatePmsReturn;
    data['real_estate_xirr'] = realEstateXirr;
    if(realestatePmsList != null) {
      data['realestatePmsList'] = realestatePmsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RealestatePmsList {
  num? id;
  String? name;
  String? pan;
  String? investorName;
  String? providerName;
  String? purchaseDate;
  String? strategy;
  num? amount;
  String? maturityDate;
  num? maturityValue;
  String? currentValueDate;
  num? currentValue;
  String? clientName;
  num? userId;
  String? amountStr;
  String? currentValueStr;
  String? gainLossStr;
  String? maturityValueStr;

  RealestatePmsList(
      {this.id,
      this.name,
      this.pan,
      this.investorName,
      this.providerName,
      this.purchaseDate,
      this.strategy,
      this.amount,
      this.maturityDate,
      this.maturityValue,
      this.currentValueDate,
      this.currentValue,
      this.clientName,
      this.userId,
      this.amountStr,
      this.currentValueStr,
      this.gainLossStr,
      this.maturityValueStr});

  RealestatePmsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pan = json['pan'];
    investorName = json['investor_name'];
    providerName = json['provider_name'];
    purchaseDate = json['purchase_date'];
    strategy = json['strategy'];
    amount = json['amount'];
    maturityDate = json['maturity_date'];
    maturityValue = json['maturity_value'];
    currentValueDate = json['current_value_date'];
    currentValue = json['current_value'];
    clientName = json['client_name'];
    userId = json['user_id'];
    amountStr = json['amount_str'];
    currentValueStr = json['current_value_str'];
    gainLossStr = json['gain_loss_str'];
    maturityValueStr = json['maturity_value_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pan'] = pan;
    data['investor_name'] = investorName;
    data['provider_name'] = providerName;
    data['purchase_date'] = purchaseDate;
    data['strategy'] = strategy;
    data['amount'] = amount;
    data['maturity_date'] = maturityDate;
    data['maturity_value'] = maturityValue;
    data['current_value_date'] = currentValueDate;
    data['current_value'] = currentValue;
    data['client_name'] = clientName;
    data['user_id'] = userId;
    data['amount_str'] = amountStr;
    data['current_value_str'] = currentValueStr;
    data['gain_loss_str'] = gainLossStr;
    data['maturity_value_str'] = maturityValueStr;
    return data;
  }
}

class PostOffice {
  num? postalTotalCurrentCost;
  num? postalTotalCurrentValue;
  num? postalTotalUnrealisedProfitLoss;
  num? postalTotalReturn;
  num? postalTotalXirr;
  List<PostOfficeList>? postOfficelist;

  PostOffice(
      {this.postalTotalCurrentCost,
      this.postalTotalCurrentValue,
      this.postalTotalUnrealisedProfitLoss,
      this.postalTotalReturn,
      this.postalTotalXirr,
      this.postOfficelist});

  PostOffice.fromJson(Map<String, dynamic> json) {
    postalTotalCurrentCost = json['postal_total_current_cost'];
    postalTotalCurrentValue = json['postal_total_current_value'];
    postalTotalUnrealisedProfitLoss =
        json['postal_total_unrealised_profit_loss'];
    postalTotalReturn = json['postal_total_return'];
    postalTotalXirr = json['postal_total_xirr'];
    if (json['list'] != null) {
      postOfficelist = <PostOfficeList>[];
      json['list'].forEach((v) {
        postOfficelist!.add(PostOfficeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['postal_total_current_cost'] = postalTotalCurrentCost;
    data['postal_total_current_value'] = postalTotalCurrentValue;
    data['postal_total_unrealised_profit_loss'] = postalTotalUnrealisedProfitLoss;
    data['postal_total_return'] = postalTotalReturn;
    data['postal_total_xirr'] = postalTotalXirr;
    if(postOfficelist != null) {
      data['postOfficelist'] = postOfficelist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostOfficeList {
  num? id;
  String? name;
  String? pan;
  String? policyHolderName;
  String? policyNumber;
  String? schemeName;
  String? postOfficeName;
  String? startDate;
  num? amount;
  num? interest;
  String? maturityDate;
  num? maturityAmount;
  String? policyTerm;
  String? nomineeName;
  String? nomineeRelation;
  num? active;
  String? preMaturityDate;
  num? preMaturityAmount;
  num? currentCost;
  num? currentValue;
  num? unReliasedProfitLoss;

  PostOfficeList(
      {this.id,
      this.name,
      this.pan,
      this.policyHolderName,
      this.policyNumber,
      this.schemeName,
      this.postOfficeName,
      this.startDate,
      this.amount,
      this.interest,
      this.maturityDate,
      this.maturityAmount,
      this.policyTerm,
      this.nomineeName,
      this.nomineeRelation,
      this.active,
      this.preMaturityDate,
      this.preMaturityAmount,
      this.currentCost,
      this.currentValue,
      this.unReliasedProfitLoss});

  PostOfficeList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pan = json['pan'];
    policyHolderName = json['policy_holder_name'];
    policyNumber = json['policy_number'];
    schemeName = json['scheme_name'];
    postOfficeName = json['post_office_name'];
    startDate = json['start_date'];
    amount = json['amount'];
    interest = json['interest'];
    maturityDate = json['maturity_date'];
    maturityAmount = json['maturity_amount'];
    policyTerm = json['policy_term'];
    nomineeName = json['nominee_name'];
    nomineeRelation = json['nominee_relation'];
    active = json['active'];
    preMaturityDate = json['pre_maturity_date'];
    preMaturityAmount = json['pre_maturity_amount'];
    currentCost = json['current_cost'];
    currentValue = json['current_value'];
    unReliasedProfitLoss = json['unReliasedProfitLoss'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pan'] = pan;
    data['policy_holder_name'] = policyHolderName;
    data['policy_number'] = policyNumber;
    data['scheme_name'] = schemeName;
    data['post_office_name'] = postOfficeName;
    data['start_date'] = startDate;
    data['amount'] = amount;
    data['interest'] = interest;
    data['maturity_date'] = maturityDate;
    data['maturity_amount'] = maturityAmount;
    data['policy_term'] = policyTerm;
    data['nominee_name'] = nomineeName;
    data['nominee_relation'] = nomineeRelation;
    data['active'] = active;
    data['pre_maturity_date'] = preMaturityDate;
    data['pre_maturity_amount'] = preMaturityAmount;
    data['current_cost'] = currentCost;
    data['current_value'] = currentValue;
    data['unReliasedProfitLoss'] = unReliasedProfitLoss;
    return data;
  }
}

class Fd {
  num? fdTotalCurrentCost;
  num? fdTotalCurrentValue;
  num? fdTotalUnrealisedProfitLoss;
  num? fdTotalMaturityValue;
  num? fdTotalReturn;
  num? xirrValue;
  List<FdList>? fdList;

  Fd(
      {this.fdTotalCurrentCost,
      this.fdTotalCurrentValue,
      this.fdTotalUnrealisedProfitLoss,
      this.fdTotalMaturityValue,
      this.fdTotalReturn,
      this.xirrValue,
      this.fdList});

  Fd.fromJson(Map<String, dynamic> json) {
    fdTotalCurrentCost = json['fd_total_current_cost'];
    fdTotalCurrentValue = json['fd_total_current_value'];
    fdTotalUnrealisedProfitLoss = json['fd_total_unrealised_profit_loss'];
    fdTotalMaturityValue = json['fd_total_maturity_value'];
    fdTotalReturn = json['fd_total_return'];
    xirrValue = json['xirrValue'];
    if (json['list'] != null) {
      fdList = <FdList>[];
      json['list'].forEach((v) {
        fdList!.add(FdList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fd_total_current_cost'] = fdTotalCurrentCost;
    data['fd_total_current_value'] = fdTotalCurrentValue;
    data['fd_total_unrealised_profit_loss'] = fdTotalUnrealisedProfitLoss;
    data['fd_total_maturity_value'] = fdTotalMaturityValue;
    data['fd_total_return'] = fdTotalReturn;
    data['xirrValue'] = xirrValue;
    if(fdList != null) {
      data['fdList'] = fdList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FdList {
  num? id;
  String? name;
  String? pan;
  String? investmentType;
  String? investorName;
  String? issuerName;
  String? schemeName;
  String? fdNumber;
  String? startDate;
  num? amount;
  num? interest;
  String? interestFrequency;
  String? maturityDate;
  num? maturityAmount;
  String? tenure;
  String? nomineeName;
  String? nomineeRelation;
  num? active;
  String? preMaturityDate;
  num? preMaturityAmount;
  num? currentCost;
  num? currentValue;
  num? unReliasedProfitLoss;
  num? reliasedProfitLoss;
  num? noOfDays;
  num? absReturn;
  num? xIRR;
  String? interestType;
  String? frequency;
  String? startDateStr;
  String? maturityDateStr;
  String? amountStr;
  String? currentCostStr;
  String? currentValueStr;
  String? maturityAmountStr;
  String? profitLossStr;
  num? xirr;

  FdList(
      {this.id,
      this.name,
      this.pan,
      this.investmentType,
      this.investorName,
      this.issuerName,
      this.schemeName,
      this.fdNumber,
      this.startDate,
      this.amount,
      this.interest,
      this.interestFrequency,
      this.maturityDate,
      this.maturityAmount,
      this.tenure,
      this.nomineeName,
      this.nomineeRelation,
      this.active,
      this.preMaturityDate,
      this.preMaturityAmount,
      this.currentCost,
      this.currentValue,
      this.unReliasedProfitLoss,
      this.reliasedProfitLoss,
      this.noOfDays,
      this.absReturn,
      this.xIRR,
      this.interestType,
      this.frequency,
      this.startDateStr,
      this.maturityDateStr,
      this.amountStr,
      this.currentCostStr,
      this.currentValueStr,
      this.maturityAmountStr,
      this.profitLossStr,
      this.xirr});

  FdList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pan = json['pan'];
    investmentType = json['investment_type'];
    investorName = json['investor_name'];
    issuerName = json['issuer_name'];
    schemeName = json['scheme_name'];
    fdNumber = json['fd_number'];
    startDate = json['start_date'];
    amount = json['amount'];
    interest = json['interest'];
    interestFrequency = json['interest_frequency'];
    maturityDate = json['maturity_date'];
    maturityAmount = json['maturity_amount'];
    tenure = json['tenure'];
    nomineeName = json['nominee_name'];
    nomineeRelation = json['nominee_relation'];
    active = json['active'];
    preMaturityDate = json['pre_maturity_date'];
    preMaturityAmount = json['pre_maturity_amount'];
    currentCost = json['current_cost'];
    currentValue = json['current_value'];
    unReliasedProfitLoss = json['unReliasedProfitLoss'];
    reliasedProfitLoss = json['reliasedProfitLoss'];
    noOfDays = json['no_of_days'];
    absReturn = json['abs_return'];
    xIRR = json['XIRR'];
    interestType = json['interest_type'];
    frequency = json['frequency'];
    startDateStr = json['start_date_str'];
    maturityDateStr = json['maturity_date_str'];
    amountStr = json['amount_str'];
    currentCostStr = json['current_cost_str'];
    currentValueStr = json['current_value_str'];
    maturityAmountStr = json['maturity_amount_str'];
    profitLossStr = json['profitLoss_str'];
    xirr = json['xirr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pan'] = pan;
    data['investment_type'] = investmentType;
    data['investor_name'] = investorName;
    data['issuer_name'] = issuerName;
    data['scheme_name'] = schemeName;
    data['fd_number'] = fdNumber;
    data['start_date'] = startDate;
    data['amount'] = amount;
    data['interest'] = interest;
    data['interest_frequency'] = interestFrequency;
    data['maturity_date'] = maturityDate;
    data['maturity_amount'] = maturityAmount;
    data['tenure'] = tenure;
    data['nominee_name'] = nomineeName;
    data['nominee_relation'] = nomineeRelation;
    data['active'] = active;
    data['pre_maturity_date'] = preMaturityDate;
    data['pre_maturity_amount'] = preMaturityAmount;
    data['current_cost'] = currentCost;
    data['current_value'] = currentValue;
    data['unReliasedProfitLoss'] = unReliasedProfitLoss;
    data['reliasedProfitLoss'] = reliasedProfitLoss;
    data['no_of_days'] = noOfDays;
    data['abs_return'] = absReturn;
    data['XIRR'] = xIRR;
    data['interest_type'] = interestType;
    data['frequency'] = frequency;
    data['start_date_str'] = startDateStr;
    data['maturity_date_str'] = maturityDateStr;
    data['amount_str'] = amountStr;
    data['current_cost_str'] = currentCostStr;
    data['current_value_str'] = currentValueStr;
    data['maturity_amount_str'] = maturityAmountStr;
    data['profitLoss_str'] = profitLossStr;
    data['xirr'] = xirr;
    return data;
  }
}

class Bond {
  num? bondsTotalCurrentCost;
  num? bondsTotalCurrentValue;
  num? bondsTotalUnrealisedProfitLoss;
  num? bondsTotalMaturityValue;
  num? bondsTotalReturn;
  num? bondsXirrValue;
  List<BondList>? bondList;

  Bond(
      {this.bondsTotalCurrentCost,
      this.bondsTotalCurrentValue,
      this.bondsTotalUnrealisedProfitLoss,
      this.bondsTotalMaturityValue,
      this.bondsTotalReturn,
      this.bondsXirrValue,
      this.bondList});

  Bond.fromJson(Map<String, dynamic> json) {
    bondsTotalCurrentCost = json['bonds_total_current_cost'];
    bondsTotalCurrentValue = json['bonds_total_current_value'];
    bondsTotalUnrealisedProfitLoss = json['bonds_total_unrealised_profit_loss'];
    bondsTotalMaturityValue = json['bonds_total_maturity_value'];
    bondsTotalReturn = json['bonds_total_return'];
    bondsXirrValue = json['bonds_xirrValue'];
    if (json['list'] != null) {
      bondList = <BondList>[];
      json['list'].forEach((v) {
        bondList!.add(BondList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bonds_total_current_cost'] = bondsTotalCurrentCost;
    data['bonds_total_current_value'] = bondsTotalCurrentValue;
    data['bonds_total_unrealised_profit_loss'] = bondsTotalUnrealisedProfitLoss;
    data['bonds_total_maturity_value'] = bondsTotalMaturityValue;
    data['bonds_total_return'] = bondsTotalReturn;
    data['bonds_xirrValue'] = bondsXirrValue;
    if(bondList != null) {
      data['bondList'] = bondList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BondList {
  num? id;
  String? name;
  String? pan;
  String? investmentType;
  String? investorName;
  String? issuerName;
  String? schemeName;
  String? fdNumber;
  String? startDate;
  num? amount;
  num? interest;
  String? interestFrequency;
  String? maturityDate;
  num? maturityAmount;
  String? tenure;
  String? nomineeName;
  String? nomineeRelation;
  num? active;
  String? preMaturityDate;
  num? preMaturityAmount;
  num? currentCost;
  num? currentValue;
  num? unReliasedProfitLoss;
  num? reliasedProfitLoss;
  num? noOfDays;
  num? absReturn;
  num? xIRR;
  String? interestType;
  String? startDateStr;
  String? maturityDateStr;
  String? amountStr;
  String? currentCostStr;
  String? currentValueStr;
  String? maturityAmountStr;
  String? profitLossStr;

  BondList(
      {this.id,
      this.name,
      this.pan,
      this.investmentType,
      this.investorName,
      this.issuerName,
      this.schemeName,
      this.fdNumber,
      this.startDate,
      this.amount,
      this.interest,
      this.interestFrequency,
      this.maturityDate,
      this.maturityAmount,
      this.tenure,
      this.nomineeName,
      this.nomineeRelation,
      this.active,
      this.preMaturityDate,
      this.preMaturityAmount,
      this.currentCost,
      this.currentValue,
      this.unReliasedProfitLoss,
      this.reliasedProfitLoss,
      this.noOfDays,
      this.absReturn,
      this.xIRR,
      this.interestType,
      this.startDateStr,
      this.maturityDateStr,
      this.amountStr,
      this.currentCostStr,
      this.currentValueStr,
      this.maturityAmountStr,
      this.profitLossStr});

  BondList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pan = json['pan'];
    investmentType = json['investment_type'];
    investorName = json['investor_name'];
    issuerName = json['issuer_name'];
    schemeName = json['scheme_name'];
    fdNumber = json['fd_number'];
    startDate = json['start_date'];
    amount = json['amount'];
    interest = json['interest'];
    interestFrequency = json['interest_frequency'];
    maturityDate = json['maturity_date'];
    maturityAmount = json['maturity_amount'];
    tenure = json['tenure'];
    nomineeName = json['nominee_name'];
    nomineeRelation = json['nominee_relation'];
    active = json['active'];
    preMaturityDate = json['pre_maturity_date'];
    preMaturityAmount = json['pre_maturity_amount'];
    currentCost = json['current_cost'];
    currentValue = json['current_value'];
    unReliasedProfitLoss = json['unReliasedProfitLoss'];
    reliasedProfitLoss = json['reliasedProfitLoss'];
    noOfDays = json['no_of_days'];
    absReturn = json['abs_return'];
    xIRR = json['XIRR'];
    interestType = json['interest_type'];
    startDateStr = json['start_date_str'];
    maturityDateStr = json['maturity_date_str'];
    amountStr = json['amount_str'];
    currentCostStr = json['current_cost_str'];
    currentValueStr = json['current_value_str'];
    maturityAmountStr = json['maturity_amount_str'];
    profitLossStr = json['profitLoss_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pan'] = pan;
    data['investment_type'] = investmentType;
    data['investor_name'] = investorName;
    data['issuer_name'] = issuerName;
    data['scheme_name'] = schemeName;
    data['fd_number'] = fdNumber;
    data['start_date'] = startDate;
    data['amount'] = amount;
    data['interest'] = interest;
    data['interest_frequency'] = interestFrequency;
    data['maturity_date'] = maturityDate;
    data['maturity_amount'] = maturityAmount;
    data['tenure'] = tenure;
    data['nominee_name'] = nomineeName;
    data['nominee_relation'] = nomineeRelation;
    data['active'] = active;
    data['pre_maturity_date'] = preMaturityDate;
    data['pre_maturity_amount'] = preMaturityAmount;
    data['current_cost'] = currentCost;
    data['current_value'] = currentValue;
    data['unReliasedProfitLoss'] = unReliasedProfitLoss;
    data['reliasedProfitLoss'] = reliasedProfitLoss;
    data['no_of_days'] = noOfDays;
    data['abs_return'] = absReturn;
    data['XIRR'] = xIRR;
    data['interest_type'] = interestType;
    data['start_date_str'] = startDateStr;
    data['maturity_date_str'] = maturityDateStr;
    data['amount_str'] = amountStr;
    data['current_cost_str'] = currentCostStr;
    data['current_value_str'] = currentValueStr;
    data['maturity_amount_str'] = maturityAmountStr;
    data['profitLoss_str'] = profitLossStr;
    return data;
  }
}

class Realestate {
  num? propertyTotalHoldingArea;
  num? propertyTotalCurrentCost;
  num? propertyTotalCurrentValue;
  num? propertyTotalUnrealisedProfitLoss;
  num? propertyTotalReturn;
  num? propertyXirr;
  List<RealestateList>? realestateList;

  Realestate(
      {this.propertyTotalHoldingArea,
      this.propertyTotalCurrentCost,
      this.propertyTotalCurrentValue,
      this.propertyTotalUnrealisedProfitLoss,
      this.propertyTotalReturn,
      this.propertyXirr,
      this.realestateList});

  Realestate.fromJson(Map<String, dynamic> json) {
    propertyTotalHoldingArea = json['property_total_holding_area'];
    propertyTotalCurrentCost = json['property_total_current_cost'];
    propertyTotalCurrentValue = json['property_total_current_value'];
    propertyTotalUnrealisedProfitLoss =
        json['property_total_unrealised_profit_loss'];
    propertyTotalReturn = json['property_total_return'];
    propertyXirr = json['property_xirr'];
    if (json['list'] != null) {
      realestateList = <RealestateList>[];
      json['list'].forEach((v) {
        realestateList!.add(RealestateList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['property_total_holding_area'] = propertyTotalHoldingArea;
    data['property_total_current_cost'] = propertyTotalCurrentCost;
    data['property_total_current_value'] = propertyTotalCurrentValue;
    data['property_total_unrealised_profit_loss'] = propertyTotalUnrealisedProfitLoss;
    data['property_total_return'] = propertyTotalReturn;
    data['property_xirr'] = propertyXirr;
    if(realestateList != null) {
      data['realestateList'] = realestateList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RealestateList {
  num? id;
  String? name;
  String? pan;
  String? investorName;
  String? propertyName;
  String? propertyType;
  String? purchaseDate;
  num? area;
  num? price;
  String? trxnType;
  String? amount;
  num? additionalCost;
  num? currentRate;
  String? measure;
  num? xirr;
  num? totalHoldingArea;
  num? currentCost;
  num? currentValue;
  num? unReliasedProfitLoss;

  RealestateList(
      {this.id,
      this.name,
      this.pan,
      this.investorName,
      this.propertyName,
      this.propertyType,
      this.purchaseDate,
      this.area,
      this.price,
      this.trxnType,
      this.amount,
      this.additionalCost,
      this.currentRate,
      this.measure,
      this.xirr,
      this.totalHoldingArea,
      this.currentCost,
      this.currentValue,
      this.unReliasedProfitLoss});

  RealestateList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pan = json['pan'];
    investorName = json['investor_name'];
    propertyName = json['property_name'];
    propertyType = json['property_type'];
    purchaseDate = json['purchase_date'];
    area = json['area'];
    price = json['price'];
    trxnType = json['trxn_type'];
    amount = json['amount'];
    additionalCost = json['additional_cost'];
    currentRate = json['current_rate'];
    measure = json['measure'];
    xirr = json['xirr'];
    totalHoldingArea = json['total_holding_area'];
    currentCost = json['current_cost'];
    currentValue = json['current_value'];
    unReliasedProfitLoss = json['unReliasedProfitLoss'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pan'] = pan;
    data['investor_name'] = investorName;
    data['property_name'] = propertyName;
    data['property_type'] = propertyType;
    data['purchase_date'] = purchaseDate;
    data['area'] = area;
    data['price'] = price;
    data['trxn_type'] = trxnType;
    data['amount'] = amount;
    data['additional_cost'] = additionalCost;
    data['current_rate'] = currentRate;
    data['measure'] = measure;
    data['xirr'] = xirr;
    data['total_holding_area'] = totalHoldingArea;
    data['current_cost'] = currentCost;
    data['current_value'] = currentValue;
    data['unReliasedProfitLoss'] = unReliasedProfitLoss;
    return data;
  }
}

class LifeInsurance {
  num? totalLifeRiskCover;
  num? totalLifePremiumPerYear;
  num? totalLifePremiumPaid;
  List<LifeInsuranceList>? lifeInsuranceList;

  LifeInsurance(
      {this.totalLifeRiskCover,
      this.totalLifePremiumPerYear,
      this.totalLifePremiumPaid,
      this.lifeInsuranceList});

  LifeInsurance.fromJson(Map<String, dynamic> json) {
    totalLifeRiskCover = json['total_life_risk_cover'];
    totalLifePremiumPerYear = json['total_life_premium_per_year'];
    totalLifePremiumPaid = json['total_life_premium_paid'];
    if (json['list'] != null) {
      lifeInsuranceList = <LifeInsuranceList>[];
      json['list'].forEach((v) {
        lifeInsuranceList!.add(LifeInsuranceList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_life_risk_cover'] = totalLifeRiskCover;
    data['total_life_premium_per_year'] = totalLifePremiumPerYear;
    data['total_life_premium_paid'] = totalLifePremiumPaid;
    if(lifeInsuranceList != null) {
      data['lifeInsuranceList'] = lifeInsuranceList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LifeInsuranceList {
  String? pan;
  String? name;
  String? insurerName;
  String? policyNumber;
  String? companyName;
  String? productName;
  String? productType;
  String? transactionType;
  String? startDate;
  String? transactionDate;
  num? riskCoverage;
  num? premiumAmount;
  num? totalAmount;
  String? premiumMode;
  num? premiumTerm;
  num? policyTerm;
  String? nomineeName;
  String? nomineeRelation;
  String? policyStatus;
  String? maturityDate;
  num? maturityAmount;
  num? premiumAmountYearly;
  num? totalPremiumPaid;

  LifeInsuranceList(
      {this.pan,
      this.name,
      this.insurerName,
      this.policyNumber,
      this.companyName,
      this.productName,
      this.productType,
      this.transactionType,
      this.startDate,
      this.transactionDate,
      this.riskCoverage,
      this.premiumAmount,
      this.totalAmount,
      this.premiumMode,
      this.premiumTerm,
      this.policyTerm,
      this.nomineeName,
      this.nomineeRelation,
      this.policyStatus,
      this.maturityDate,
      this.maturityAmount,
      this.premiumAmountYearly,
      this.totalPremiumPaid});

  LifeInsuranceList.fromJson(Map<String, dynamic> json) {
    pan = json['pan'];
    name = json['name'];
    insurerName = json['insurer_name'];
    policyNumber = json['policy_number'];
    companyName = json['company_name'];
    productName = json['product_name'];
    productType = json['product_type'];
    transactionType = json['transaction_type'];
    startDate = json['start_date'];
    transactionDate = json['transaction_date'];
    riskCoverage = json['risk_coverage'];
    premiumAmount = json['premium_amount'];
    totalAmount = json['total_amount'];
    premiumMode = json['premium_mode'];
    premiumTerm = json['premium_term'];
    policyTerm = json['policy_term'];
    nomineeName = json['nominee_name'];
    nomineeRelation = json['nominee_relation'];
    policyStatus = json['policy_status'];
    maturityDate = json['maturity_date'];
    maturityAmount = json['maturity_amount'];
    premiumAmountYearly = json['premium_amount_yearly'];
    totalPremiumPaid = json['total_premium_paid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pan'] = pan;
    data['name'] = name;
    data['insurer_name'] = insurerName;
    data['policy_number'] = policyNumber;
    data['company_name'] = companyName;
    data['product_name'] = productName;
    data['product_type'] = productType;
    data['transaction_type'] = transactionType;
    data['start_date'] = startDate;
    data['transaction_date'] = transactionDate;
    data['risk_coverage'] = riskCoverage;
    data['premium_amount'] = premiumAmount;
    data['total_amount'] = totalAmount;
    data['premium_mode'] = premiumMode;
    data['premium_term'] = premiumTerm;
    data['policy_term'] = policyTerm;
    data['nominee_name'] = nomineeName;
    data['nominee_relation'] = nomineeRelation;
    data['policy_status'] = policyStatus;
    data['maturity_date'] = maturityDate;
    data['maturity_amount'] = maturityAmount;
    data['premium_amount_yearly'] = premiumAmountYearly;
    data['total_premium_paid'] = totalPremiumPaid;
    return data;
  }
}

class GeneralInsurance {
  num? totalGeneralRiskCover;
  num? totalGeneralPremiumPerYear;
  num? totalGeneralPremiumPaid;
  List<GeneralInsuranceList>? generalInsuranceList;

  GeneralInsurance(
      {this.totalGeneralRiskCover,
      this.totalGeneralPremiumPerYear,
      this.totalGeneralPremiumPaid,
      this.generalInsuranceList});

  GeneralInsurance.fromJson(Map<String, dynamic> json) {
    totalGeneralRiskCover = json['total_general_risk_cover'];
    totalGeneralPremiumPerYear = json['total_general_premium_per_year'];
    totalGeneralPremiumPaid = json['total_general_premium_paid'];
    if (json['list'] != null) {
      generalInsuranceList = <GeneralInsuranceList>[];
      json['list'].forEach((v) {
        generalInsuranceList!.add(GeneralInsuranceList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_general_risk_cover'] = totalGeneralRiskCover;
    data['total_general_premium_per_year'] = totalGeneralPremiumPerYear;
    data['total_general_premium_paid'] = totalGeneralPremiumPaid;
    if(generalInsuranceList != null) {
      data['list'] = generalInsuranceList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GeneralInsuranceList {
  num? id;
  String? name;
  String? pan;
  String? insuranceType;
  String? insurerName;
  String? insurer2Name;
  String? insurer3Name;
  String? insurer4Name;
  String? proposerName;
  String? policyNumber;
  String? companyName;
  String? productName;
  String? startDate;
  num? riskCoverage;
  num? premiumAmount;
  num? policyTerm;
  String? nomineeName;
  String? nomineeRelation;
  num? active;
  String? maturityDate;
  String? renewalDate;
  String? policyType;
  String? premiumMode;
  String? paymentMode;
  String? carModel;
  String? engineNumber;
  String? carRegNumber;
  String? policyIssuanceDate;
  num? netPremiumAmount;
  String? policyStatus;
  String? noOfLives;
  String? transactionType;
  String? clientName;
  num? premiumTerm;
  num? totalAmount;
  String? transactionDate;
  String? renewalPolicyNumber;
  num? userId;
  String? remarks;
  String? riskStr;
  String? premiumStr;
  String? rmName;
  String? riskCoverageStr;
  String? totalAmountStr;
  String? premiumPerYrStr;
  String? netPremiumAmountStr;
  num? premiumPerYr;

  GeneralInsuranceList(
      {this.id,
      this.name,
      this.pan,
      this.insuranceType,
      this.insurerName,
      this.insurer2Name,
      this.insurer3Name,
      this.insurer4Name,
      this.proposerName,
      this.policyNumber,
      this.companyName,
      this.productName,
      this.startDate,
      this.riskCoverage,
      this.premiumAmount,
      this.policyTerm,
      this.nomineeName,
      this.nomineeRelation,
      this.active,
      this.maturityDate,
      this.renewalDate,
      this.policyType,
      this.premiumMode,
      this.paymentMode,
      this.carModel,
      this.engineNumber,
      this.carRegNumber,
      this.policyIssuanceDate,
      this.netPremiumAmount,
      this.policyStatus,
      this.noOfLives,
      this.transactionType,
      this.clientName,
      this.premiumTerm,
      this.totalAmount,
      this.transactionDate,
      this.renewalPolicyNumber,
      this.userId,
      this.remarks,
      this.riskStr,
      this.premiumStr,
      this.rmName,
      this.riskCoverageStr,
      this.totalAmountStr,
      this.premiumPerYrStr,
      this.netPremiumAmountStr,
      this.premiumPerYr});

  GeneralInsuranceList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pan = json['pan'];
    insuranceType = json['insurance_type'];
    insurerName = json['insurer_name'];
    insurer2Name = json['insurer2_name'];
    insurer3Name = json['insurer3_name'];
    insurer4Name = json['insurer4_name'];
    proposerName = json['proposer_name'];
    policyNumber = json['policy_number'];
    companyName = json['company_name'];
    productName = json['product_name'];
    startDate = json['start_date'];
    riskCoverage = json['risk_coverage'];
    premiumAmount = json['premium_amount'];
    policyTerm = json['policy_term'];
    nomineeName = json['nominee_name'];
    nomineeRelation = json['nominee_relation'];
    active = json['active'];
    maturityDate = json['maturity_date'];
    renewalDate = json['renewal_date'];
    policyType = json['policy_type'];
    premiumMode = json['premium_mode'];
    paymentMode = json['payment_mode'];
    carModel = json['car_model'];
    engineNumber = json['engine_number'];
    carRegNumber = json['car_reg_number'];
    policyIssuanceDate = json['policy_issuance_date'];
    netPremiumAmount = json['net_premium_amount'];
    policyStatus = json['policy_status'];
    noOfLives = json['no_of_lives'];
    transactionType = json['transaction_type'];
    clientName = json['client_name'];
    premiumTerm = json['premium_term'];
    totalAmount = json['total_amount'];
    transactionDate = json['transaction_date'];
    renewalPolicyNumber = json['renewal_policy_number'];
    userId = json['user_id'];
    remarks = json['remarks'];
    riskStr = json['risk_str'];
    premiumStr = json['premium_str'];
    rmName = json['rm_name'];
    riskCoverageStr = json['risk_coverage_str'];
    totalAmountStr = json['total_amount_str'];
    premiumPerYrStr = json['premium_per_yr_str'];
    netPremiumAmountStr = json['net_premium_amount_str'];
    premiumPerYr = json['premium_per_yr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pan'] = pan;
    data['insurance_type'] = insuranceType;
    data['insurer_name'] = insurerName;
    data['insurer2_name'] = insurer2Name;
    data['insurer3_name'] = insurer3Name;
    data['insurer4_name'] = insurer4Name;
    data['proposer_name'] = proposerName;
    data['policy_number'] = policyNumber;
    data['company_name'] = companyName;
    data['product_name'] = productName;
    data['start_date'] = startDate;
    data['risk_coverage'] = riskCoverage;
    data['premium_amount'] = premiumAmount;
    data['policy_term'] = policyTerm;
    data['nominee_name'] = nomineeName;
    data['nominee_relation'] = nomineeRelation;
    data['active'] = active;
    data['maturity_date'] = maturityDate;
    data['renewal_date'] = renewalDate;
    data['policy_type'] = policyType;
    data['premium_mode'] = premiumMode;
    data['payment_mode'] = paymentMode;
    data['car_model'] = carModel;
    data['engine_number'] = engineNumber;
    data['car_reg_number'] = carRegNumber;
    data['policy_issuance_date'] = policyIssuanceDate;
    data['net_premium_amount'] = netPremiumAmount;
    data['policy_status'] = policyStatus;
    data['no_of_lives'] = noOfLives;
    data['transaction_type'] = transactionType;
    data['client_name'] = clientName;
    data['premium_term'] = premiumTerm;
    data['total_amount'] = totalAmount;
    data['transaction_date'] = transactionDate;
    data['renewal_policy_number'] = renewalPolicyNumber;
    data['user_id'] = userId;
    data['remarks'] = remarks;
    data['risk_str'] = riskStr;
    data['premium_str'] = premiumStr;
    data['rm_name'] = rmName;
    data['risk_coverage_str'] = riskCoverageStr;
    data['total_amount_str'] = totalAmountStr;
    data['premium_per_yr_str'] = premiumPerYrStr;
    data['net_premium_amount_str'] = netPremiumAmountStr;
    data['premium_per_yr'] = premiumPerYr;
    return data;
  }
}

class HealthInsurance {
  num? totalHealthRiskCover;
  num? totalHealthPremiumPerYear;
  num? totalHealthPremiumPaid;
  List<HealthInsuranceList>? healthInsuranceList;

  HealthInsurance(
      {this.totalHealthRiskCover,
      this.totalHealthPremiumPerYear,
      this.totalHealthPremiumPaid,
      this.healthInsuranceList});

  HealthInsurance.fromJson(Map<String, dynamic> json) {
    totalHealthRiskCover = json['total_health_risk_cover'];
    totalHealthPremiumPerYear = json['total_health_premium_per_year'];
    totalHealthPremiumPaid = json['total_health_premium_paid'];
    if (json['list'] != null) {
      healthInsuranceList = <HealthInsuranceList>[];
      json['list'].forEach((v) {
        healthInsuranceList!.add(HealthInsuranceList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_health_risk_cover'] = totalHealthRiskCover;
    data['total_health_premium_per_year'] = totalHealthPremiumPerYear;
    data['total_health_premium_paid'] = totalHealthPremiumPaid;
    if (healthInsuranceList != null) {
      data['list'] = healthInsuranceList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HealthInsuranceList {
  num? id;
  String? name;
  String? pan;
  String? insuranceType;
  String? insurerName;
  String? insurer2Name;
  String? insurer3Name;
  String? insurer4Name;
  String? proposerName;
  String? policyNumber;
  String? companyName;
  String? productName;
  String? startDate;
  num? riskCoverage;
  num? premiumAmount;
  num? policyTerm;
  String? nomineeName;
  String? nomineeRelation;
  num? active;
  String? maturityDate;
  String? renewalDate;
  String? policyType;
  String? premiumMode;
  String? paymentMode;
  String? carModel;
  String? engineNumber;
  String? carRegNumber;
  String? policyIssuanceDate;
  num? netPremiumAmount;
  String? policyStatus;
  String? noOfLives;
  String? transactionType;
  String? clientName;
  num? premiumTerm;
  num? totalAmount;
  String? transactionDate;
  String? renewalPolicyNumber;
  num? userId;
  String? remarks;
  String? riskStr;
  String? premiumStr;
  String? rmName;
  String? riskCoverageStr;
  String? totalAmountStr;
  String? premiumPerYrStr;
  String? netPremiumAmountStr;
  num? premiumPerYr;

  HealthInsuranceList(
      {this.id,
      this.name,
      this.pan,
      this.insuranceType,
      this.insurerName,
      this.insurer2Name,
      this.insurer3Name,
      this.insurer4Name,
      this.proposerName,
      this.policyNumber,
      this.companyName,
      this.productName,
      this.startDate,
      this.riskCoverage,
      this.premiumAmount,
      this.policyTerm,
      this.nomineeName,
      this.nomineeRelation,
      this.active,
      this.maturityDate,
      this.renewalDate,
      this.policyType,
      this.premiumMode,
      this.paymentMode,
      this.carModel,
      this.engineNumber,
      this.carRegNumber,
      this.policyIssuanceDate,
      this.netPremiumAmount,
      this.policyStatus,
      this.noOfLives,
      this.transactionType,
      this.clientName,
      this.premiumTerm,
      this.totalAmount,
      this.transactionDate,
      this.renewalPolicyNumber,
      this.userId,
      this.remarks,
      this.riskStr,
      this.premiumStr,
      this.rmName,
      this.riskCoverageStr,
      this.totalAmountStr,
      this.premiumPerYrStr,
      this.netPremiumAmountStr,
      this.premiumPerYr});

  HealthInsuranceList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pan = json['pan'];
    insuranceType = json['insurance_type'];
    insurerName = json['insurer_name'];
    insurer2Name = json['insurer2_name'];
    insurer3Name = json['insurer3_name'];
    insurer4Name = json['insurer4_name'];
    proposerName = json['proposer_name'];
    policyNumber = json['policy_number'];
    companyName = json['company_name'];
    productName = json['product_name'];
    startDate = json['start_date'];
    riskCoverage = json['risk_coverage'];
    premiumAmount = json['premium_amount'];
    policyTerm = json['policy_term'];
    nomineeName = json['nominee_name'];
    nomineeRelation = json['nominee_relation'];
    active = json['active'];
    maturityDate = json['maturity_date'];
    renewalDate = json['renewal_date'];
    policyType = json['policy_type'];
    premiumMode = json['premium_mode'];
    paymentMode = json['payment_mode'];
    carModel = json['car_model'];
    engineNumber = json['engine_number'];
    carRegNumber = json['car_reg_number'];
    policyIssuanceDate = json['policy_issuance_date'];
    netPremiumAmount = json['net_premium_amount'];
    policyStatus = json['policy_status'];
    noOfLives = json['no_of_lives'];
    transactionType = json['transaction_type'];
    clientName = json['client_name'];
    premiumTerm = json['premium_term'];
    totalAmount = json['total_amount'];
    transactionDate = json['transaction_date'];
    renewalPolicyNumber = json['renewal_policy_number'];
    userId = json['user_id'];
    remarks = json['remarks'];
    riskStr = json['risk_str'];
    premiumStr = json['premium_str'];
    rmName = json['rm_name'];
    riskCoverageStr = json['risk_coverage_str'];
    totalAmountStr = json['total_amount_str'];
    premiumPerYrStr = json['premium_per_yr_str'];
    netPremiumAmountStr = json['net_premium_amount_str'];
    premiumPerYr = json['premium_per_yr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pan'] = pan;
    data['insurance_type'] = insuranceType;
    data['insurer_name'] = insurerName;
    data['insurer2_name'] = insurer2Name;
    data['insurer3_name'] = insurer3Name;
    data['insurer4_name'] = insurer4Name;
    data['proposer_name'] = proposerName;
    data['policy_number'] = policyNumber;
    data['company_name'] = companyName;
    data['product_name'] = productName;
    data['start_date'] = startDate;
    data['risk_coverage'] = riskCoverage;
    data['premium_amount'] = premiumAmount;
    data['policy_term'] = policyTerm;
    data['nominee_name'] = nomineeName;
    data['nominee_relation'] = nomineeRelation;
    data['active'] = active;
    data['maturity_date'] = maturityDate;
    data['renewal_date'] = renewalDate;
    data['policy_type'] = policyType;
    data['premium_mode'] = premiumMode;
    data['payment_mode'] = paymentMode;
    data['car_model'] = carModel;
    data['engine_number'] = engineNumber;
    data['car_reg_number'] = carRegNumber;
    data['policy_issuance_date'] = policyIssuanceDate;
    data['net_premium_amount'] = netPremiumAmount;
    data['policy_status'] = policyStatus;
    data['no_of_lives'] = noOfLives;
    data['transaction_type'] = transactionType;
    data['client_name'] = clientName;
    data['premium_term'] = premiumTerm;
    data['total_amount'] = totalAmount;
    data['transaction_date'] = transactionDate;
    data['renewal_policy_number'] = renewalPolicyNumber;
    data['user_id'] = userId;
    data['remarks'] = remarks;
    data['risk_str'] = riskStr;
    data['premium_str'] = premiumStr;
    data['rm_name'] = rmName;
    data['risk_coverage_str'] = riskCoverageStr;
    data['total_amount_str'] = totalAmountStr;
    data['premium_per_yr_str'] = premiumPerYrStr;
    data['net_premium_amount_str'] = netPremiumAmountStr;
    data['premium_per_yr'] = premiumPerYr;
    return data;
  }
}

class Loan {
  num? totalLoanAmount;
  num? totalEmi;
  num? totalLoanBalance;
  List<LoanList>? loanList;

  Loan({this.totalLoanAmount, this.totalEmi, this.totalLoanBalance, this.loanList});

  Loan.fromJson(Map<String, dynamic> json) {
    totalLoanAmount = json['total_loan_amount'];
    totalEmi = json['total_emi'];
    totalLoanBalance = json['total_loan_balance'];
    if (json['list'] != null) {
      loanList = <LoanList>[];
      json['list'].forEach((v) {
        loanList!.add(LoanList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_loan_amount'] = totalLoanAmount;
    data['total_emi'] = totalEmi;
    data['total_loan_balance'] = totalLoanBalance;
    if (loanList != null) {
      data['list'] = loanList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LoanList {
  num? id;
  String? name;
  String? pan;
  String? loanerName;
  String? accountNumber;
  String? issuerName;
  num? amount;
  String? startDate;
  String? endDate;
  num? interest;
  num? tenure;
  num? emi;
  num? emiDate;
  num? active;
  num? loanBalance;
  num? loanPaid;
  String? clientName;
  num? userId;

  LoanList(
      {this.id,
      this.name,
      this.pan,
      this.loanerName,
      this.accountNumber,
      this.issuerName,
      this.amount,
      this.startDate,
      this.endDate,
      this.interest,
      this.tenure,
      this.emi,
      this.emiDate,
      this.active,
      this.loanBalance,
      this.loanPaid,
      this.clientName,
      this.userId});

  LoanList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pan = json['pan'];
    loanerName = json['loaner_name'];
    accountNumber = json['account_number'];
    issuerName = json['issuer_name'];
    amount = json['amount'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    interest = json['interest'];
    tenure = json['tenure'];
    emi = json['emi'];
    emiDate = json['emi_date'];
    active = json['active'];
    loanBalance = json['loan_balance'];
    loanPaid = json['loan_paid'];
    clientName = json['client_name'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pan'] = pan;
    data['loaner_name'] = loanerName;
    data['account_number'] = accountNumber;
    data['issuer_name'] = issuerName;
    data['amount'] = amount;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['interest'] = interest;
    data['tenure'] = tenure;
    data['emi'] = emi;
    data['emi_date'] = emiDate;
    data['active'] = active;
    data['loan_balance'] = loanBalance;
    data['loan_paid'] = loanPaid;
    data['client_name'] = clientName;
    data['user_id'] = userId;
    return data;
  }
}

class Ncd {
  num? ncdTotalCurrentCost;
  num? ncdTotalCurrentValue;
  num? ncdTotalUnrealisedProfitLoss;
  num? ncdTotalMaturityValue;
  num? ncdTotalReturn;
  num? ncdXirrValue;
  List<NCDList>? ncdList;

  Ncd(
      {this.ncdTotalCurrentCost,
      this.ncdTotalCurrentValue,
      this.ncdTotalUnrealisedProfitLoss,
      this.ncdTotalMaturityValue,
      this.ncdTotalReturn,
      this.ncdXirrValue,
      this.ncdList});

  Ncd.fromJson(Map<String, dynamic> json) {
    ncdTotalCurrentCost = json['ncd_total_current_cost'];
    ncdTotalCurrentValue = json['ncd_total_current_value'];
    ncdTotalUnrealisedProfitLoss = json['ncd_total_unrealised_profit_loss'];
    ncdTotalMaturityValue = json['ncd_total_maturity_value'];
    ncdTotalReturn = json['ncd_total_return'];
    ncdXirrValue = json['ncd_xirrValue'];
    if (json['list'] != null) {
      ncdList = <NCDList>[];
      json['list'].forEach((v) {
        ncdList!.add(NCDList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ncd_total_current_cost'] = ncdTotalCurrentCost;
    data['ncd_total_current_value'] = ncdTotalCurrentValue;
    data['ncd_total_unrealised_profit_loss'] = ncdTotalUnrealisedProfitLoss;
    data['ncd_total_maturity_value'] = ncdTotalMaturityValue;
    data['ncd_total_return'] = ncdTotalReturn;
    data['ncd_xirrValue'] = ncdXirrValue;
    if (ncdList != null) {
      data['list'] = ncdList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NCDList {
  num? id;
  String? name;
  String? pan;
  String? investmentType;
  String? investorName;
  String? issuerName;
  String? schemeName;
  String? fdNumber;
  String? startDate;
  num? amount;
  num? interest;
  String? interestFrequency;
  String? maturityDate;
  num? maturityAmount;
  String? tenure;
  String? nomineeName;
  String? nomineeRelation;
  num? active;
  String? preMaturityDate;
  num? preMaturityAmount;
  num? currentCost;
  num? currentValue;
  num? unReliasedProfitLoss;
  num? reliasedProfitLoss;
  num? noOfDays;
  num? absReturn;
  num? xIRR;
  String? interestType;
  String? startDateStr;
  String? maturityDateStr;
  String? amountStr;
  String? currentCostStr;
  String? currentValueStr;
  String? maturityAmountStr;
  String? profitLossStr;

  NCDList(
      {this.id,
      this.name,
      this.pan,
      this.investmentType,
      this.investorName,
      this.issuerName,
      this.schemeName,
      this.fdNumber,
      this.startDate,
      this.amount,
      this.interest,
      this.interestFrequency,
      this.maturityDate,
      this.maturityAmount,
      this.tenure,
      this.nomineeName,
      this.nomineeRelation,
      this.active,
      this.preMaturityDate,
      this.preMaturityAmount,
      this.currentCost,
      this.currentValue,
      this.unReliasedProfitLoss,
      this.reliasedProfitLoss,
      this.noOfDays,
      this.absReturn,
      this.xIRR,
      this.interestType,
      this.startDateStr,
      this.maturityDateStr,
      this.amountStr,
      this.currentCostStr,
      this.currentValueStr,
      this.maturityAmountStr,
      this.profitLossStr,
      });

  NCDList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pan = json['pan'];
    investmentType = json['investment_type'];
    investorName = json['investor_name'];
    issuerName = json['issuer_name'];
    schemeName = json['scheme_name'];
    fdNumber = json['fd_number'];
    startDate = json['start_date'];
    amount = json['amount'];
    interest = json['interest'];
    interestFrequency = json['interest_frequency'];
    maturityDate = json['maturity_date'];
    maturityAmount = json['maturity_amount'];
    tenure = json['tenure'];
    nomineeName = json['nominee_name'];
    nomineeRelation = json['nominee_relation'];
    active = json['active'];
    preMaturityDate = json['pre_maturity_date'];
    preMaturityAmount = json['pre_maturity_amount'];
    currentCost = json['current_cost'];
    currentValue = json['current_value'];
    unReliasedProfitLoss = json['unReliasedProfitLoss'];
    reliasedProfitLoss = json['reliasedProfitLoss'];
    noOfDays = json['no_of_days'];
    absReturn = json['abs_return'];
    xIRR = json['XIRR'];
    interestType = json['interest_type'];
    startDateStr = json['start_date_str'];
    maturityDateStr = json['maturity_date_str'];
    amountStr = json['amount_str'];
    currentCostStr = json['current_cost_str'];
    currentValueStr = json['current_value_str'];
    maturityAmountStr = json['maturity_amount_str'];
    profitLossStr = json['profitLoss_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pan'] = pan;
    data['investment_type'] = investmentType;
    data['investor_name'] = investorName;
    data['issuer_name'] = issuerName;
    data['scheme_name'] = schemeName;
    data['fd_number'] = fdNumber;
    data['start_date'] = startDate;
    data['amount'] = amount;
    data['interest'] = interest;
    data['interest_frequency'] = interestFrequency;
    data['maturity_date'] = maturityDate;
    data['maturity_amount'] = maturityAmount;
    data['tenure'] = tenure;
    data['nominee_name'] = nomineeName;
    data['nominee_relation'] = nomineeRelation;
    data['active'] = active;
    data['pre_maturity_date'] = preMaturityDate;
    data['pre_maturity_amount'] = preMaturityAmount;
    data['current_cost'] = currentCost;
    data['current_value'] = currentValue;
    data['unReliasedProfitLoss'] = unReliasedProfitLoss;
    data['reliasedProfitLoss'] = reliasedProfitLoss;
    data['no_of_days'] = noOfDays;
    data['abs_return'] = absReturn;
    data['XIRR'] = xIRR;
    data['interest_type'] = interestType;
    data['start_date_str'] = startDateStr;
    data['maturity_date_str'] = maturityDateStr;
    data['amount_str'] = amountStr;
    data['current_cost_str'] = currentCostStr;
    data['current_value_str'] = currentValueStr;
    data['maturity_amount_str'] = maturityAmountStr;
    data['profitLoss_str'] = profitLossStr;
    return data;
  }
}

class Trade {
  num? tradebondsTotalInvestedAmount;
  num? tradebondsTotalCurrentValue;
  num? tradebondsTotalUnrealisedGain;
  num? tradebondsTotalMaturityAmount;
  num? tradebondsTotalReturn;
  num? tradebondsXirrValue;
  List<TradeList>? tradeList;

  Trade(
      {this.tradebondsTotalInvestedAmount,
      this.tradebondsTotalCurrentValue,
      this.tradebondsTotalUnrealisedGain,
      this.tradebondsTotalMaturityAmount,
      this.tradebondsTotalReturn,
      this.tradebondsXirrValue,
      this.tradeList});

  Trade.fromJson(Map<String, dynamic> json) {
    tradebondsTotalInvestedAmount = json['tradebonds_total_invested_amount'];
    tradebondsTotalCurrentValue = json['tradebonds_total_current_value'];
    tradebondsTotalUnrealisedGain = json['tradebonds_total_unrealised_gain'];
    tradebondsTotalMaturityAmount = json['tradebonds_total_maturity_amount'];
    tradebondsTotalReturn = json['tradebonds_total_return'];
    tradebondsXirrValue = json['tradebonds_xirrValue'];
    if (json['list'] != null) {
      tradeList = <TradeList>[];
      json['list'].forEach((v) {
        tradeList!.add(TradeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tradebonds_total_invested_amount'] = tradebondsTotalInvestedAmount;
    data['tradebonds_total_current_value'] = tradebondsTotalCurrentValue;
    data['tradebonds_total_unrealised_gain'] = tradebondsTotalUnrealisedGain;
    data['tradebonds_total_maturity_amount'] = tradebondsTotalMaturityAmount;
    data['tradebonds_total_return'] = tradebondsTotalReturn;
    data['tradebonds_xirrValue'] = tradebondsXirrValue;
    if(tradeList != null) {
      data['tradeList'] = tradeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TradeList {
  num? id;
  num? userId;
  String? name;
  String? pan;
  String? investorName;
  String? secondHolderName;
  String? thirdHolderName;
  String? isin;
  String? companyName;
  String? securityCode;
  String? faceValue;
  String? interestRate;
  String? interestType;
  String? interestFrequency;
  String? allotmentDate;
  String? redemptionDate;
  num? investedAmount;
  num? purchaseCost;
  num? maturityAmount;
  String? nomineeName;
  String? nomineeRelation;
  num? active;
  String? clientName;
  num? currentValue;
  num? unrealisedGain;
  num? absReturn;
  num? xirr;
  String? investedAmountStr;
  String? purchaseCostStr;
  String? maturityAmountStr;

  TradeList(
      {this.id,
      this.userId,
      this.name,
      this.pan,
      this.investorName,
      this.secondHolderName,
      this.thirdHolderName,
      this.isin,
      this.companyName,
      this.securityCode,
      this.faceValue,
      this.interestRate,
      this.interestType,
      this.interestFrequency,
      this.allotmentDate,
      this.redemptionDate,
      this.investedAmount,
      this.purchaseCost,
      this.maturityAmount,
      this.nomineeName,
      this.nomineeRelation,
      this.active,
      this.clientName,
      this.currentValue,
      this.unrealisedGain,
      this.absReturn,
      this.xirr,
      this.investedAmountStr,
      this.purchaseCostStr,
      this.maturityAmountStr});

  TradeList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    pan = json['pan'];
    investorName = json['investor_name'];
    secondHolderName = json['second_holder_name'];
    thirdHolderName = json['third_holder_name'];
    isin = json['isin'];
    companyName = json['company_name'];
    securityCode = json['security_code'];
    faceValue = json['face_value'];
    interestRate = json['interest_rate'];
    interestType = json['interest_type'];
    interestFrequency = json['interest_frequency'];
    allotmentDate = json['allotment_date'];
    redemptionDate = json['redemption_date'];
    investedAmount = json['invested_amount'];
    purchaseCost = json['purchase_cost'];
    maturityAmount = json['maturity_amount'];
    nomineeName = json['nominee_name'];
    nomineeRelation = json['nominee_relation'];
    active = json['active'];
    clientName = json['client_name'];
    currentValue = json['current_value'];
    unrealisedGain = json['unrealised_gain'];
    absReturn = json['abs_return'];
    xirr = json['xirr'];
    investedAmountStr = json['invested_amount_str'];
    purchaseCostStr = json['purchase_cost_str'];
    maturityAmountStr = json['maturity_amount_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['pan'] = pan;
    data['investor_name'] = investorName;
    data['second_holder_name'] = secondHolderName;
    data['third_holder_name'] = thirdHolderName;
    data['isin'] = isin;
    data['company_name'] = companyName;
    data['security_code'] = securityCode;
    data['face_value'] = faceValue;
    data['interest_rate'] = interestRate;
    data['interest_type'] = interestType;
    data['interest_frequency'] = interestFrequency;
    data['allotment_date'] = allotmentDate;
    data['redemption_date'] = redemptionDate;
    data['invested_amount'] = investedAmount;
    data['purchase_cost'] = purchaseCost;
    data['maturity_amount'] = maturityAmount;
    data['nominee_name'] = nomineeName;
    data['nominee_relation'] = nomineeRelation;
    data['active'] = active;
    data['client_name'] = clientName;
    data['current_value'] = currentValue;
    data['unrealised_gain'] = unrealisedGain;
    data['abs_return'] = absReturn;
    data['xirr'] = xirr;
    data['invested_amount_str'] = investedAmountStr;
    data['purchase_cost_str'] = purchaseCostStr;
    data['maturity_amount_str'] = maturityAmountStr;
    return data;
  }
}
