class TaxReportResponse {
  int? status;
  String? statusMsg;
  String? msg;
  int? portfolioLongGain;
  double? portfolioShortGain;
  double? portfolioGain;
  int? eqGain;
  int? eqStgGain;
  int? eqLtgGain;
  int? eqStgPurchaseAmount;
  int? eqStgSoldAmount;
  int? eqLtgPurchaseAmount;
  int? eqLtgSoldAmount;
  int? eqLtgIndexedAmount;
  double? debtGain;
  double? debtStgGain;
  int? debtLtgGain;
  double? debtStgPurchaseAmount;
  int? debtStgSoldAmount;
  int? debtLtgPurchaseAmount;
  int? debtLtgSoldAmount;
  int? debtLtgIndexedAmount;
  List<DebtSummaryList>? debtSummaryList;
  List<EquitySummaryList>? equitySummaryList;

  TaxReportResponse(
      {this.status,
        this.statusMsg,
        this.msg,
        this.portfolioLongGain,
        this.portfolioShortGain,
        this.portfolioGain,
        this.eqGain,
        this.eqStgGain,
        this.eqLtgGain,
        this.eqStgPurchaseAmount,
        this.eqStgSoldAmount,
        this.eqLtgPurchaseAmount,
        this.eqLtgSoldAmount,
        this.eqLtgIndexedAmount,
        this.debtGain,
        this.debtStgGain,
        this.debtLtgGain,
        this.debtStgPurchaseAmount,
        this.debtStgSoldAmount,
        this.debtLtgPurchaseAmount,
        this.debtLtgSoldAmount,
        this.debtLtgIndexedAmount,
        this.debtSummaryList,
        this.equitySummaryList});

  TaxReportResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    portfolioLongGain = json['portfolio_long_gain'];
    portfolioShortGain = json['portfolio_short_gain'];
    portfolioGain = json['portfolio_gain'];
    eqGain = json['eq_gain'];
    eqStgGain = json['eq_stg_gain'];
    eqLtgGain = json['eq_ltg_gain'];
    eqStgPurchaseAmount = json['eq_stg_purchase_amount'];
    eqStgSoldAmount = json['eq_stg_sold_amount'];
    eqLtgPurchaseAmount = json['eq_ltg_purchase_amount'];
    eqLtgSoldAmount = json['eq_ltg_sold_amount'];
    eqLtgIndexedAmount = json['eq_ltg_indexed_amount'];
    debtGain = json['debt_gain'];
    debtStgGain = json['debt_stg_gain'];
    debtLtgGain = json['debt_ltg_gain'];
    debtStgPurchaseAmount = json['debt_stg_purchase_amount'];
    debtStgSoldAmount = json['debt_stg_sold_amount'];
    debtLtgPurchaseAmount = json['debt_ltg_purchase_amount'];
    debtLtgSoldAmount = json['debt_ltg_sold_amount'];
    debtLtgIndexedAmount = json['debt_ltg_indexed_amount'];
    if (json['debt_summary_list'] != null) {
      debtSummaryList = <DebtSummaryList>[];
      json['debt_summary_list'].forEach((v) {
        debtSummaryList!.add(new DebtSummaryList.fromJson(v));
      });
    }
    if (json['equity_summary_list'] != null) {
      equitySummaryList = <EquitySummaryList>[];
      json['equity_summary_list'].forEach((v) {
        equitySummaryList!.add(new EquitySummaryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_msg'] = this.statusMsg;
    data['msg'] = this.msg;
    data['portfolio_long_gain'] = this.portfolioLongGain;
    data['portfolio_short_gain'] = this.portfolioShortGain;
    data['portfolio_gain'] = this.portfolioGain;
    data['eq_gain'] = this.eqGain;
    data['eq_stg_gain'] = this.eqStgGain;
    data['eq_ltg_gain'] = this.eqLtgGain;
    data['eq_stg_purchase_amount'] = this.eqStgPurchaseAmount;
    data['eq_stg_sold_amount'] = this.eqStgSoldAmount;
    data['eq_ltg_purchase_amount'] = this.eqLtgPurchaseAmount;
    data['eq_ltg_sold_amount'] = this.eqLtgSoldAmount;
    data['eq_ltg_indexed_amount'] = this.eqLtgIndexedAmount;
    data['debt_gain'] = this.debtGain;
    data['debt_stg_gain'] = this.debtStgGain;
    data['debt_ltg_gain'] = this.debtLtgGain;
    data['debt_stg_purchase_amount'] = this.debtStgPurchaseAmount;
    data['debt_stg_sold_amount'] = this.debtStgSoldAmount;
    data['debt_ltg_purchase_amount'] = this.debtLtgPurchaseAmount;
    data['debt_ltg_sold_amount'] = this.debtLtgSoldAmount;
    data['debt_ltg_indexed_amount'] = this.debtLtgIndexedAmount;
    if (this.debtSummaryList != null) {
      data['debt_summary_list'] =
          this.debtSummaryList!.map((v) => v.toJson()).toList();
    }
    if (this.equitySummaryList != null) {
      data['equity_summary_list'] =
          this.equitySummaryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DebtSummaryList {
  String? scheme;
  String? schemeAmfiCode;
  String? schemeAmfiShortName;
  Null? schemeCode;
  Null? schemeRegistrar;
  Null? isinNo;
  String? folio;
  Null? category;
  Null? transactionType;
  Null? soldDate;
  Null? soldRepeatedDate;
  double? soldUnits;
  int? soldAmount;
  Null? soldNav;
  Null? purchaseDate;
  double? purchaseUnits;
  double? purchaseAmount;
  Null? purchaseNav;
  Null? indexedNav;
  int? noOfDays;
  int? transactionCount;
  Null? stgPurchaseAmount;
  Null? stgSoldAmount;
  Null? ltgPurchaseAmount;
  Null? ltgSoldAmount;
  Null? stgTotalGain;
  double? stgGain;
  Null? ltgTotalGain;
  int? ltgGain;
  int? stgLoss;
  int? ltgLoss;
  Null? indexedCost;
  Null? indexedTotalGain;
  int? indexedGain;
  int? indexedLoss;
  int? totalTax;
  int? stt;
  Null? soldTransactionType;
  Null? purchaseTransactionType;
  Null? redeemedUnits;
  Null? grandfatheredUnits;
  Null? grandfatheredAmount;
  Null? grandfatheredNav;
  Null? purchaseDateStr;
  Null? soldDateStr;
  double? gainLoss;
  Null? latestNavDate;
  Null? latestNavDateStr;
  Null? latestNav;
  Null? whatIfAmount;
  Null? actualAmount;
  Null? gainLossAbsReturn;
  Null? whatIfAbsReturn;
  Null? schemeTotalUnits;
  Null? schemeCurrentValue;
  Null? xirr;
  Null? puramtStr;
  Null? soldamtStr;
  Null? gainlossStr;
  Null? whatifamountStr;
  Null? purchaseAmountStr;
  Null? soldAmountStr;
  Null? schemeTotalUnitsStr;
  Null? schemeCurrentValueStr;
  Null? gainLossStr;
  Null? whatIfAmountStr;
  Null? soldUnitsStr;
  Null? purchaseUnitsStr;
  Null? actualAmountStr;
  Null? redeemedUnitsStr;
  Null? ltgGainStr;
  String? amcLogo;
  List<TransactionList>? transactionList;

  DebtSummaryList(
      {this.scheme,
        this.schemeAmfiCode,
        this.schemeAmfiShortName,
        this.schemeCode,
        this.schemeRegistrar,
        this.isinNo,
        this.folio,
        this.category,
        this.transactionType,
        this.soldDate,
        this.soldRepeatedDate,
        this.soldUnits,
        this.soldAmount,
        this.soldNav,
        this.purchaseDate,
        this.purchaseUnits,
        this.purchaseAmount,
        this.purchaseNav,
        this.indexedNav,
        this.noOfDays,
        this.transactionCount,
        this.stgPurchaseAmount,
        this.stgSoldAmount,
        this.ltgPurchaseAmount,
        this.ltgSoldAmount,
        this.stgTotalGain,
        this.stgGain,
        this.ltgTotalGain,
        this.ltgGain,
        this.stgLoss,
        this.ltgLoss,
        this.indexedCost,
        this.indexedTotalGain,
        this.indexedGain,
        this.indexedLoss,
        this.totalTax,
        this.stt,
        this.soldTransactionType,
        this.purchaseTransactionType,
        this.redeemedUnits,
        this.grandfatheredUnits,
        this.grandfatheredAmount,
        this.grandfatheredNav,
        this.purchaseDateStr,
        this.soldDateStr,
        this.gainLoss,
        this.latestNavDate,
        this.latestNavDateStr,
        this.latestNav,
        this.whatIfAmount,
        this.actualAmount,
        this.gainLossAbsReturn,
        this.whatIfAbsReturn,
        this.schemeTotalUnits,
        this.schemeCurrentValue,
        this.xirr,
        this.puramtStr,
        this.soldamtStr,
        this.gainlossStr,
        this.whatifamountStr,
        this.purchaseAmountStr,
        this.soldAmountStr,
        this.schemeTotalUnitsStr,
        this.schemeCurrentValueStr,
        this.gainLossStr,
        this.whatIfAmountStr,
        this.soldUnitsStr,
        this.purchaseUnitsStr,
        this.actualAmountStr,
        this.redeemedUnitsStr,
        this.ltgGainStr,
        this.amcLogo,
        this.transactionList});

  DebtSummaryList.fromJson(Map<String, dynamic> json) {
    scheme = json['scheme'];
    schemeAmfiCode = json['scheme_amfi_code'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeCode = json['scheme_code'];
    schemeRegistrar = json['scheme_registrar'];
    isinNo = json['isin_no'];
    folio = json['folio'];
    category = json['category'];
    transactionType = json['transaction_type'];
    soldDate = json['sold_date'];
    soldRepeatedDate = json['sold_repeated_date'];
    soldUnits = json['sold_units'];
    soldAmount = json['sold_amount'];
    soldNav = json['sold_nav'];
    purchaseDate = json['purchase_date'];
    purchaseUnits = json['purchase_units'];
    purchaseAmount = json['purchase_amount'];
    purchaseNav = json['purchase_nav'];
    indexedNav = json['indexed_nav'];
    noOfDays = json['no_of_days'];
    transactionCount = json['transaction_count'];
    stgPurchaseAmount = json['stg_purchase_amount'];
    stgSoldAmount = json['stg_sold_amount'];
    ltgPurchaseAmount = json['ltg_purchase_amount'];
    ltgSoldAmount = json['ltg_sold_amount'];
    stgTotalGain = json['stg_total_gain'];
    stgGain = json['stg_gain'];
    ltgTotalGain = json['ltg_total_gain'];
    ltgGain = json['ltg_gain'];
    stgLoss = json['stg_loss'];
    ltgLoss = json['ltg_loss'];
    indexedCost = json['indexed_cost'];
    indexedTotalGain = json['indexed_total_gain'];
    indexedGain = json['indexed_gain'];
    indexedLoss = json['indexed_loss'];
    totalTax = json['total_tax'];
    stt = json['stt'];
    soldTransactionType = json['sold_transaction_type'];
    purchaseTransactionType = json['purchase_transaction_type'];
    redeemedUnits = json['redeemed_units'];
    grandfatheredUnits = json['grandfathered_units'];
    grandfatheredAmount = json['grandfathered_amount'];
    grandfatheredNav = json['grandfathered_nav'];
    purchaseDateStr = json['purchase_date_str'];
    soldDateStr = json['sold_date_str'];
    gainLoss = json['gain_loss'];
    latestNavDate = json['latest_nav_date'];
    latestNavDateStr = json['latest_nav_date_str'];
    latestNav = json['latest_nav'];
    whatIfAmount = json['what_if_amount'];
    actualAmount = json['actual_amount'];
    gainLossAbsReturn = json['gain_loss_abs_return'];
    whatIfAbsReturn = json['what_if_abs_return'];
    schemeTotalUnits = json['scheme_total_units'];
    schemeCurrentValue = json['scheme_current_value'];
    xirr = json['xirr'];
    puramtStr = json['puramt_str'];
    soldamtStr = json['soldamt_str'];
    gainlossStr = json['gainloss_str'];
    whatifamountStr = json['whatifamount_str'];
    purchaseAmountStr = json['purchase_amount_str'];
    soldAmountStr = json['sold_amount_str'];
    schemeTotalUnitsStr = json['scheme_total_units_str'];
    schemeCurrentValueStr = json['scheme_current_value_str'];
    gainLossStr = json['gain_loss_str'];
    whatIfAmountStr = json['what_if_amount_str'];
    soldUnitsStr = json['sold_units_str'];
    purchaseUnitsStr = json['purchase_units_str'];
    actualAmountStr = json['actual_amount_str'];
    redeemedUnitsStr = json['redeemed_units_str'];
    ltgGainStr = json['ltg_gain_str'];
    amcLogo = json['amc_logo'];
    if (json['transaction_list'] != null) {
      transactionList = <TransactionList>[];
      json['transaction_list'].forEach((v) {
        transactionList!.add(new TransactionList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheme'] = this.scheme;
    data['scheme_amfi_code'] = this.schemeAmfiCode;
    data['scheme_amfi_short_name'] = this.schemeAmfiShortName;
    data['scheme_code'] = this.schemeCode;
    data['scheme_registrar'] = this.schemeRegistrar;
    data['isin_no'] = this.isinNo;
    data['folio'] = this.folio;
    data['category'] = this.category;
    data['transaction_type'] = this.transactionType;
    data['sold_date'] = this.soldDate;
    data['sold_repeated_date'] = this.soldRepeatedDate;
    data['sold_units'] = this.soldUnits;
    data['sold_amount'] = this.soldAmount;
    data['sold_nav'] = this.soldNav;
    data['purchase_date'] = this.purchaseDate;
    data['purchase_units'] = this.purchaseUnits;
    data['purchase_amount'] = this.purchaseAmount;
    data['purchase_nav'] = this.purchaseNav;
    data['indexed_nav'] = this.indexedNav;
    data['no_of_days'] = this.noOfDays;
    data['transaction_count'] = this.transactionCount;
    data['stg_purchase_amount'] = this.stgPurchaseAmount;
    data['stg_sold_amount'] = this.stgSoldAmount;
    data['ltg_purchase_amount'] = this.ltgPurchaseAmount;
    data['ltg_sold_amount'] = this.ltgSoldAmount;
    data['stg_total_gain'] = this.stgTotalGain;
    data['stg_gain'] = this.stgGain;
    data['ltg_total_gain'] = this.ltgTotalGain;
    data['ltg_gain'] = this.ltgGain;
    data['stg_loss'] = this.stgLoss;
    data['ltg_loss'] = this.ltgLoss;
    data['indexed_cost'] = this.indexedCost;
    data['indexed_total_gain'] = this.indexedTotalGain;
    data['indexed_gain'] = this.indexedGain;
    data['indexed_loss'] = this.indexedLoss;
    data['total_tax'] = this.totalTax;
    data['stt'] = this.stt;
    data['sold_transaction_type'] = this.soldTransactionType;
    data['purchase_transaction_type'] = this.purchaseTransactionType;
    data['redeemed_units'] = this.redeemedUnits;
    data['grandfathered_units'] = this.grandfatheredUnits;
    data['grandfathered_amount'] = this.grandfatheredAmount;
    data['grandfathered_nav'] = this.grandfatheredNav;
    data['purchase_date_str'] = this.purchaseDateStr;
    data['sold_date_str'] = this.soldDateStr;
    data['gain_loss'] = this.gainLoss;
    data['latest_nav_date'] = this.latestNavDate;
    data['latest_nav_date_str'] = this.latestNavDateStr;
    data['latest_nav'] = this.latestNav;
    data['what_if_amount'] = this.whatIfAmount;
    data['actual_amount'] = this.actualAmount;
    data['gain_loss_abs_return'] = this.gainLossAbsReturn;
    data['what_if_abs_return'] = this.whatIfAbsReturn;
    data['scheme_total_units'] = this.schemeTotalUnits;
    data['scheme_current_value'] = this.schemeCurrentValue;
    data['xirr'] = this.xirr;
    data['puramt_str'] = this.puramtStr;
    data['soldamt_str'] = this.soldamtStr;
    data['gainloss_str'] = this.gainlossStr;
    data['whatifamount_str'] = this.whatifamountStr;
    data['purchase_amount_str'] = this.purchaseAmountStr;
    data['sold_amount_str'] = this.soldAmountStr;
    data['scheme_total_units_str'] = this.schemeTotalUnitsStr;
    data['scheme_current_value_str'] = this.schemeCurrentValueStr;
    data['gain_loss_str'] = this.gainLossStr;
    data['what_if_amount_str'] = this.whatIfAmountStr;
    data['sold_units_str'] = this.soldUnitsStr;
    data['purchase_units_str'] = this.purchaseUnitsStr;
    data['actual_amount_str'] = this.actualAmountStr;
    data['redeemed_units_str'] = this.redeemedUnitsStr;
    data['ltg_gain_str'] = this.ltgGainStr;
    data['amc_logo'] = this.amcLogo;
    if (this.transactionList != null) {
      data['transaction_list'] =
          this.transactionList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TransactionList {
  String? scheme;
  String? schemeAmfiCode;
  String? schemeAmfiShortName;
  Null? schemeCode;
  Null? schemeRegistrar;
  String? isinNo;
  String? folio;
  String? category;
  Null? transactionType;
  String? soldDate;
  String? soldRepeatedDate;
  double? soldUnits;
  int? soldAmount;
  double? soldNav;
  String? purchaseDate;
  double? purchaseUnits;
  double? purchaseAmount;
  double? purchaseNav;
  int? indexedNav;
  int? noOfDays;
  int? transactionCount;
  Null? stgPurchaseAmount;
  Null? stgSoldAmount;
  Null? ltgPurchaseAmount;
  Null? ltgSoldAmount;
  Null? stgTotalGain;
  double? stgGain;
  Null? ltgTotalGain;
  int? ltgGain;
  Null? stgLoss;
  Null? ltgLoss;
  Null? indexedCost;
  Null? indexedTotalGain;
  int? indexedGain;
  Null? indexedLoss;
  int? totalTax;
  int? stt;
  String? soldTransactionType;
  String? purchaseTransactionType;
  double? redeemedUnits;
  int? grandfatheredUnits;
  int? grandfatheredAmount;
  int? grandfatheredNav;
  Null? purchaseDateStr;
  Null? soldDateStr;
  Null? gainLoss;
  Null? latestNavDate;
  Null? latestNavDateStr;
  Null? latestNav;
  Null? whatIfAmount;
  double? actualAmount;
  Null? gainLossAbsReturn;
  Null? whatIfAbsReturn;
  Null? schemeTotalUnits;
  Null? schemeCurrentValue;
  Null? xirr;
  Null? puramtStr;
  Null? soldamtStr;
  Null? gainlossStr;
  Null? whatifamountStr;
  Null? purchaseAmountStr;
  Null? soldAmountStr;
  Null? schemeTotalUnitsStr;
  Null? schemeCurrentValueStr;
  Null? gainLossStr;
  Null? whatIfAmountStr;
  Null? soldUnitsStr;
  Null? purchaseUnitsStr;
  Null? actualAmountStr;
  Null? redeemedUnitsStr;
  Null? ltgGainStr;
  Null? amcLogo;
  Null? transactionList;

  TransactionList(
      {this.scheme,
        this.schemeAmfiCode,
        this.schemeAmfiShortName,
        this.schemeCode,
        this.schemeRegistrar,
        this.isinNo,
        this.folio,
        this.category,
        this.transactionType,
        this.soldDate,
        this.soldRepeatedDate,
        this.soldUnits,
        this.soldAmount,
        this.soldNav,
        this.purchaseDate,
        this.purchaseUnits,
        this.purchaseAmount,
        this.purchaseNav,
        this.indexedNav,
        this.noOfDays,
        this.transactionCount,
        this.stgPurchaseAmount,
        this.stgSoldAmount,
        this.ltgPurchaseAmount,
        this.ltgSoldAmount,
        this.stgTotalGain,
        this.stgGain,
        this.ltgTotalGain,
        this.ltgGain,
        this.stgLoss,
        this.ltgLoss,
        this.indexedCost,
        this.indexedTotalGain,
        this.indexedGain,
        this.indexedLoss,
        this.totalTax,
        this.stt,
        this.soldTransactionType,
        this.purchaseTransactionType,
        this.redeemedUnits,
        this.grandfatheredUnits,
        this.grandfatheredAmount,
        this.grandfatheredNav,
        this.purchaseDateStr,
        this.soldDateStr,
        this.gainLoss,
        this.latestNavDate,
        this.latestNavDateStr,
        this.latestNav,
        this.whatIfAmount,
        this.actualAmount,
        this.gainLossAbsReturn,
        this.whatIfAbsReturn,
        this.schemeTotalUnits,
        this.schemeCurrentValue,
        this.xirr,
        this.puramtStr,
        this.soldamtStr,
        this.gainlossStr,
        this.whatifamountStr,
        this.purchaseAmountStr,
        this.soldAmountStr,
        this.schemeTotalUnitsStr,
        this.schemeCurrentValueStr,
        this.gainLossStr,
        this.whatIfAmountStr,
        this.soldUnitsStr,
        this.purchaseUnitsStr,
        this.actualAmountStr,
        this.redeemedUnitsStr,
        this.ltgGainStr,
        this.amcLogo,
        this.transactionList});

  TransactionList.fromJson(Map<String, dynamic> json) {
    scheme = json['scheme'];
    schemeAmfiCode = json['scheme_amfi_code'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeCode = json['scheme_code'];
    schemeRegistrar = json['scheme_registrar'];
    isinNo = json['isin_no'];
    folio = json['folio'];
    category = json['category'];
    transactionType = json['transaction_type'];
    soldDate = json['sold_date'];
    soldRepeatedDate = json['sold_repeated_date'];
    soldUnits = json['sold_units'];
    soldAmount = json['sold_amount'];
    soldNav = json['sold_nav'];
    purchaseDate = json['purchase_date'];
    purchaseUnits = json['purchase_units'];
    purchaseAmount = json['purchase_amount'];
    purchaseNav = json['purchase_nav'];
    indexedNav = json['indexed_nav'];
    noOfDays = json['no_of_days'];
    transactionCount = json['transaction_count'];
    stgPurchaseAmount = json['stg_purchase_amount'];
    stgSoldAmount = json['stg_sold_amount'];
    ltgPurchaseAmount = json['ltg_purchase_amount'];
    ltgSoldAmount = json['ltg_sold_amount'];
    stgTotalGain = json['stg_total_gain'];
    stgGain = json['stg_gain'];
    ltgTotalGain = json['ltg_total_gain'];
    ltgGain = json['ltg_gain'];
    stgLoss = json['stg_loss'];
    ltgLoss = json['ltg_loss'];
    indexedCost = json['indexed_cost'];
    indexedTotalGain = json['indexed_total_gain'];
    indexedGain = json['indexed_gain'];
    indexedLoss = json['indexed_loss'];
    totalTax = json['total_tax'];
    stt = json['stt'];
    soldTransactionType = json['sold_transaction_type'];
    purchaseTransactionType = json['purchase_transaction_type'];
    redeemedUnits = json['redeemed_units'];
    grandfatheredUnits = json['grandfathered_units'];
    grandfatheredAmount = json['grandfathered_amount'];
    grandfatheredNav = json['grandfathered_nav'];
    purchaseDateStr = json['purchase_date_str'];
    soldDateStr = json['sold_date_str'];
    gainLoss = json['gain_loss'];
    latestNavDate = json['latest_nav_date'];
    latestNavDateStr = json['latest_nav_date_str'];
    latestNav = json['latest_nav'];
    whatIfAmount = json['what_if_amount'];
    actualAmount = json['actual_amount'];
    gainLossAbsReturn = json['gain_loss_abs_return'];
    whatIfAbsReturn = json['what_if_abs_return'];
    schemeTotalUnits = json['scheme_total_units'];
    schemeCurrentValue = json['scheme_current_value'];
    xirr = json['xirr'];
    puramtStr = json['puramt_str'];
    soldamtStr = json['soldamt_str'];
    gainlossStr = json['gainloss_str'];
    whatifamountStr = json['whatifamount_str'];
    purchaseAmountStr = json['purchase_amount_str'];
    soldAmountStr = json['sold_amount_str'];
    schemeTotalUnitsStr = json['scheme_total_units_str'];
    schemeCurrentValueStr = json['scheme_current_value_str'];
    gainLossStr = json['gain_loss_str'];
    whatIfAmountStr = json['what_if_amount_str'];
    soldUnitsStr = json['sold_units_str'];
    purchaseUnitsStr = json['purchase_units_str'];
    actualAmountStr = json['actual_amount_str'];
    redeemedUnitsStr = json['redeemed_units_str'];
    ltgGainStr = json['ltg_gain_str'];
    amcLogo = json['amc_logo'];
    transactionList = json['transaction_list'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheme'] = this.scheme;
    data['scheme_amfi_code'] = this.schemeAmfiCode;
    data['scheme_amfi_short_name'] = this.schemeAmfiShortName;
    data['scheme_code'] = this.schemeCode;
    data['scheme_registrar'] = this.schemeRegistrar;
    data['isin_no'] = this.isinNo;
    data['folio'] = this.folio;
    data['category'] = this.category;
    data['transaction_type'] = this.transactionType;
    data['sold_date'] = this.soldDate;
    data['sold_repeated_date'] = this.soldRepeatedDate;
    data['sold_units'] = this.soldUnits;
    data['sold_amount'] = this.soldAmount;
    data['sold_nav'] = this.soldNav;
    data['purchase_date'] = this.purchaseDate;
    data['purchase_units'] = this.purchaseUnits;
    data['purchase_amount'] = this.purchaseAmount;
    data['purchase_nav'] = this.purchaseNav;
    data['indexed_nav'] = this.indexedNav;
    data['no_of_days'] = this.noOfDays;
    data['transaction_count'] = this.transactionCount;
    data['stg_purchase_amount'] = this.stgPurchaseAmount;
    data['stg_sold_amount'] = this.stgSoldAmount;
    data['ltg_purchase_amount'] = this.ltgPurchaseAmount;
    data['ltg_sold_amount'] = this.ltgSoldAmount;
    data['stg_total_gain'] = this.stgTotalGain;
    data['stg_gain'] = this.stgGain;
    data['ltg_total_gain'] = this.ltgTotalGain;
    data['ltg_gain'] = this.ltgGain;
    data['stg_loss'] = this.stgLoss;
    data['ltg_loss'] = this.ltgLoss;
    data['indexed_cost'] = this.indexedCost;
    data['indexed_total_gain'] = this.indexedTotalGain;
    data['indexed_gain'] = this.indexedGain;
    data['indexed_loss'] = this.indexedLoss;
    data['total_tax'] = this.totalTax;
    data['stt'] = this.stt;
    data['sold_transaction_type'] = this.soldTransactionType;
    data['purchase_transaction_type'] = this.purchaseTransactionType;
    data['redeemed_units'] = this.redeemedUnits;
    data['grandfathered_units'] = this.grandfatheredUnits;
    data['grandfathered_amount'] = this.grandfatheredAmount;
    data['grandfathered_nav'] = this.grandfatheredNav;
    data['purchase_date_str'] = this.purchaseDateStr;
    data['sold_date_str'] = this.soldDateStr;
    data['gain_loss'] = this.gainLoss;
    data['latest_nav_date'] = this.latestNavDate;
    data['latest_nav_date_str'] = this.latestNavDateStr;
    data['latest_nav'] = this.latestNav;
    data['what_if_amount'] = this.whatIfAmount;
    data['actual_amount'] = this.actualAmount;
    data['gain_loss_abs_return'] = this.gainLossAbsReturn;
    data['what_if_abs_return'] = this.whatIfAbsReturn;
    data['scheme_total_units'] = this.schemeTotalUnits;
    data['scheme_current_value'] = this.schemeCurrentValue;
    data['xirr'] = this.xirr;
    data['puramt_str'] = this.puramtStr;
    data['soldamt_str'] = this.soldamtStr;
    data['gainloss_str'] = this.gainlossStr;
    data['whatifamount_str'] = this.whatifamountStr;
    data['purchase_amount_str'] = this.purchaseAmountStr;
    data['sold_amount_str'] = this.soldAmountStr;
    data['scheme_total_units_str'] = this.schemeTotalUnitsStr;
    data['scheme_current_value_str'] = this.schemeCurrentValueStr;
    data['gain_loss_str'] = this.gainLossStr;
    data['what_if_amount_str'] = this.whatIfAmountStr;
    data['sold_units_str'] = this.soldUnitsStr;
    data['purchase_units_str'] = this.purchaseUnitsStr;
    data['actual_amount_str'] = this.actualAmountStr;
    data['redeemed_units_str'] = this.redeemedUnitsStr;
    data['ltg_gain_str'] = this.ltgGainStr;
    data['amc_logo'] = this.amcLogo;
    data['transaction_list'] = this.transactionList;
    return data;
  }
}

class EquitySummaryList {
  String? scheme;
  String? schemeAmfiCode;
  String? schemeAmfiShortName;
  Null? schemeCode;
  Null? schemeRegistrar;
  Null? isinNo;
  String? folio;
  Null? category;
  Null? transactionType;
  Null? soldDate;
  Null? soldRepeatedDate;
  double? soldUnits;
  int? soldAmount;
  Null? soldNav;
  Null? purchaseDate;
  double? purchaseUnits;
  double? purchaseAmount;
  Null? purchaseNav;
  Null? indexedNav;
  int? noOfDays;
  int? transactionCount;
  Null? stgPurchaseAmount;
  Null? stgSoldAmount;
  Null? ltgPurchaseAmount;
  Null? ltgSoldAmount;
  Null? stgTotalGain;
  int? stgGain;
  Null? ltgTotalGain;
  double? ltgGain;
  int? stgLoss;
  int? ltgLoss;
  Null? indexedCost;
  Null? indexedTotalGain;
  int? indexedGain;
  int? indexedLoss;
  int? totalTax;
  double? stt;
  Null? soldTransactionType;
  Null? purchaseTransactionType;
  Null? redeemedUnits;
  Null? grandfatheredUnits;
  Null? grandfatheredAmount;
  Null? grandfatheredNav;
  Null? purchaseDateStr;
  Null? soldDateStr;
  double? gainLoss;
  Null? latestNavDate;
  Null? latestNavDateStr;
  Null? latestNav;
  Null? whatIfAmount;
  Null? actualAmount;
  Null? gainLossAbsReturn;
  Null? whatIfAbsReturn;
  Null? schemeTotalUnits;
  Null? schemeCurrentValue;
  Null? xirr;
  Null? puramtStr;
  Null? soldamtStr;
  Null? gainlossStr;
  Null? whatifamountStr;
  Null? purchaseAmountStr;
  Null? soldAmountStr;
  Null? schemeTotalUnitsStr;
  Null? schemeCurrentValueStr;
  Null? gainLossStr;
  Null? whatIfAmountStr;
  Null? soldUnitsStr;
  Null? purchaseUnitsStr;
  Null? actualAmountStr;
  Null? redeemedUnitsStr;
  Null? ltgGainStr;
  String? amcLogo;
  List<TransactionList>? transactionList;

  EquitySummaryList(
      {this.scheme,
        this.schemeAmfiCode,
        this.schemeAmfiShortName,
        this.schemeCode,
        this.schemeRegistrar,
        this.isinNo,
        this.folio,
        this.category,
        this.transactionType,
        this.soldDate,
        this.soldRepeatedDate,
        this.soldUnits,
        this.soldAmount,
        this.soldNav,
        this.purchaseDate,
        this.purchaseUnits,
        this.purchaseAmount,
        this.purchaseNav,
        this.indexedNav,
        this.noOfDays,
        this.transactionCount,
        this.stgPurchaseAmount,
        this.stgSoldAmount,
        this.ltgPurchaseAmount,
        this.ltgSoldAmount,
        this.stgTotalGain,
        this.stgGain,
        this.ltgTotalGain,
        this.ltgGain,
        this.stgLoss,
        this.ltgLoss,
        this.indexedCost,
        this.indexedTotalGain,
        this.indexedGain,
        this.indexedLoss,
        this.totalTax,
        this.stt,
        this.soldTransactionType,
        this.purchaseTransactionType,
        this.redeemedUnits,
        this.grandfatheredUnits,
        this.grandfatheredAmount,
        this.grandfatheredNav,
        this.purchaseDateStr,
        this.soldDateStr,
        this.gainLoss,
        this.latestNavDate,
        this.latestNavDateStr,
        this.latestNav,
        this.whatIfAmount,
        this.actualAmount,
        this.gainLossAbsReturn,
        this.whatIfAbsReturn,
        this.schemeTotalUnits,
        this.schemeCurrentValue,
        this.xirr,
        this.puramtStr,
        this.soldamtStr,
        this.gainlossStr,
        this.whatifamountStr,
        this.purchaseAmountStr,
        this.soldAmountStr,
        this.schemeTotalUnitsStr,
        this.schemeCurrentValueStr,
        this.gainLossStr,
        this.whatIfAmountStr,
        this.soldUnitsStr,
        this.purchaseUnitsStr,
        this.actualAmountStr,
        this.redeemedUnitsStr,
        this.ltgGainStr,
        this.amcLogo,
        this.transactionList});

  EquitySummaryList.fromJson(Map<String, dynamic> json) {
    scheme = json['scheme'];
    schemeAmfiCode = json['scheme_amfi_code'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeCode = json['scheme_code'];
    schemeRegistrar = json['scheme_registrar'];
    isinNo = json['isin_no'];
    folio = json['folio'];
    category = json['category'];
    transactionType = json['transaction_type'];
    soldDate = json['sold_date'];
    soldRepeatedDate = json['sold_repeated_date'];
    soldUnits = json['sold_units'];
    soldAmount = json['sold_amount'];
    soldNav = json['sold_nav'];
    purchaseDate = json['purchase_date'];
    purchaseUnits = json['purchase_units'];
    purchaseAmount = json['purchase_amount'];
    purchaseNav = json['purchase_nav'];
    indexedNav = json['indexed_nav'];
    noOfDays = json['no_of_days'];
    transactionCount = json['transaction_count'];
    stgPurchaseAmount = json['stg_purchase_amount'];
    stgSoldAmount = json['stg_sold_amount'];
    ltgPurchaseAmount = json['ltg_purchase_amount'];
    ltgSoldAmount = json['ltg_sold_amount'];
    stgTotalGain = json['stg_total_gain'];
    stgGain = json['stg_gain'];
    ltgTotalGain = json['ltg_total_gain'];
    ltgGain = json['ltg_gain'];
    stgLoss = json['stg_loss'];
    ltgLoss = json['ltg_loss'];
    indexedCost = json['indexed_cost'];
    indexedTotalGain = json['indexed_total_gain'];
    indexedGain = json['indexed_gain'];
    indexedLoss = json['indexed_loss'];
    totalTax = json['total_tax'];
    stt = json['stt'];
    soldTransactionType = json['sold_transaction_type'];
    purchaseTransactionType = json['purchase_transaction_type'];
    redeemedUnits = json['redeemed_units'];
    grandfatheredUnits = json['grandfathered_units'];
    grandfatheredAmount = json['grandfathered_amount'];
    grandfatheredNav = json['grandfathered_nav'];
    purchaseDateStr = json['purchase_date_str'];
    soldDateStr = json['sold_date_str'];
    gainLoss = json['gain_loss'];
    latestNavDate = json['latest_nav_date'];
    latestNavDateStr = json['latest_nav_date_str'];
    latestNav = json['latest_nav'];
    whatIfAmount = json['what_if_amount'];
    actualAmount = json['actual_amount'];
    gainLossAbsReturn = json['gain_loss_abs_return'];
    whatIfAbsReturn = json['what_if_abs_return'];
    schemeTotalUnits = json['scheme_total_units'];
    schemeCurrentValue = json['scheme_current_value'];
    xirr = json['xirr'];
    puramtStr = json['puramt_str'];
    soldamtStr = json['soldamt_str'];
    gainlossStr = json['gainloss_str'];
    whatifamountStr = json['whatifamount_str'];
    purchaseAmountStr = json['purchase_amount_str'];
    soldAmountStr = json['sold_amount_str'];
    schemeTotalUnitsStr = json['scheme_total_units_str'];
    schemeCurrentValueStr = json['scheme_current_value_str'];
    gainLossStr = json['gain_loss_str'];
    whatIfAmountStr = json['what_if_amount_str'];
    soldUnitsStr = json['sold_units_str'];
    purchaseUnitsStr = json['purchase_units_str'];
    actualAmountStr = json['actual_amount_str'];
    redeemedUnitsStr = json['redeemed_units_str'];
    ltgGainStr = json['ltg_gain_str'];
    amcLogo = json['amc_logo'];
    if (json['transaction_list'] != null) {
      transactionList = <TransactionList>[];
      json['transaction_list'].forEach((v) {
        transactionList!.add(new TransactionList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheme'] = this.scheme;
    data['scheme_amfi_code'] = this.schemeAmfiCode;
    data['scheme_amfi_short_name'] = this.schemeAmfiShortName;
    data['scheme_code'] = this.schemeCode;
    data['scheme_registrar'] = this.schemeRegistrar;
    data['isin_no'] = this.isinNo;
    data['folio'] = this.folio;
    data['category'] = this.category;
    data['transaction_type'] = this.transactionType;
    data['sold_date'] = this.soldDate;
    data['sold_repeated_date'] = this.soldRepeatedDate;
    data['sold_units'] = this.soldUnits;
    data['sold_amount'] = this.soldAmount;
    data['sold_nav'] = this.soldNav;
    data['purchase_date'] = this.purchaseDate;
    data['purchase_units'] = this.purchaseUnits;
    data['purchase_amount'] = this.purchaseAmount;
    data['purchase_nav'] = this.purchaseNav;
    data['indexed_nav'] = this.indexedNav;
    data['no_of_days'] = this.noOfDays;
    data['transaction_count'] = this.transactionCount;
    data['stg_purchase_amount'] = this.stgPurchaseAmount;
    data['stg_sold_amount'] = this.stgSoldAmount;
    data['ltg_purchase_amount'] = this.ltgPurchaseAmount;
    data['ltg_sold_amount'] = this.ltgSoldAmount;
    data['stg_total_gain'] = this.stgTotalGain;
    data['stg_gain'] = this.stgGain;
    data['ltg_total_gain'] = this.ltgTotalGain;
    data['ltg_gain'] = this.ltgGain;
    data['stg_loss'] = this.stgLoss;
    data['ltg_loss'] = this.ltgLoss;
    data['indexed_cost'] = this.indexedCost;
    data['indexed_total_gain'] = this.indexedTotalGain;
    data['indexed_gain'] = this.indexedGain;
    data['indexed_loss'] = this.indexedLoss;
    data['total_tax'] = this.totalTax;
    data['stt'] = this.stt;
    data['sold_transaction_type'] = this.soldTransactionType;
    data['purchase_transaction_type'] = this.purchaseTransactionType;
    data['redeemed_units'] = this.redeemedUnits;
    data['grandfathered_units'] = this.grandfatheredUnits;
    data['grandfathered_amount'] = this.grandfatheredAmount;
    data['grandfathered_nav'] = this.grandfatheredNav;
    data['purchase_date_str'] = this.purchaseDateStr;
    data['sold_date_str'] = this.soldDateStr;
    data['gain_loss'] = this.gainLoss;
    data['latest_nav_date'] = this.latestNavDate;
    data['latest_nav_date_str'] = this.latestNavDateStr;
    data['latest_nav'] = this.latestNav;
    data['what_if_amount'] = this.whatIfAmount;
    data['actual_amount'] = this.actualAmount;
    data['gain_loss_abs_return'] = this.gainLossAbsReturn;
    data['what_if_abs_return'] = this.whatIfAbsReturn;
    data['scheme_total_units'] = this.schemeTotalUnits;
    data['scheme_current_value'] = this.schemeCurrentValue;
    data['xirr'] = this.xirr;
    data['puramt_str'] = this.puramtStr;
    data['soldamt_str'] = this.soldamtStr;
    data['gainloss_str'] = this.gainlossStr;
    data['whatifamount_str'] = this.whatifamountStr;
    data['purchase_amount_str'] = this.purchaseAmountStr;
    data['sold_amount_str'] = this.soldAmountStr;
    data['scheme_total_units_str'] = this.schemeTotalUnitsStr;
    data['scheme_current_value_str'] = this.schemeCurrentValueStr;
    data['gain_loss_str'] = this.gainLossStr;
    data['what_if_amount_str'] = this.whatIfAmountStr;
    data['sold_units_str'] = this.soldUnitsStr;
    data['purchase_units_str'] = this.purchaseUnitsStr;
    data['actual_amount_str'] = this.actualAmountStr;
    data['redeemed_units_str'] = this.redeemedUnitsStr;
    data['ltg_gain_str'] = this.ltgGainStr;
    data['amc_logo'] = this.amcLogo;
    if (this.transactionList != null) {
      data['transaction_list'] =
          this.transactionList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}