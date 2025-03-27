class GetCartByUserIdPojo {
  int? status;
  String? statusMsg;
  String? msg;
  List<Result>? result;

  GetCartByUserIdPojo({this.status, this.statusMsg, this.msg, this.result});

  GetCartByUserIdPojo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_msg'] = statusMsg;
    data['msg'] = msg;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? invName;
  String? taxStatus;
  String? taxStatusCode;
  String? holdingNature;
  String? holdingNatureCode;
  String? brokerCode;
  String? investorCode;
  String? logo;
  String? bseNseMfuFlag;
  List<SchemeList>? schemeList;

  Result(
      {this.invName,
      this.taxStatus,
      this.taxStatusCode,
      this.holdingNature,
      this.holdingNatureCode,
      this.brokerCode,
      this.investorCode,
      this.logo,
      this.bseNseMfuFlag,
      this.schemeList});

  Result.fromJson(Map<String, dynamic> json) {
    invName = json['inv_name'];
    taxStatus = json['tax_status'];
    taxStatusCode = json['tax_status_code'];
    holdingNature = json['holding_nature'];
    holdingNatureCode = json['holding_nature_code'];
    brokerCode = json['broker_code'];
    investorCode = json['investor_code'];
    logo = json['logo'];
    bseNseMfuFlag = json['bse_nse_mfu_flag'];
    if (json['scheme_list'] != null) {
      schemeList = <SchemeList>[];
      json['scheme_list'].forEach((v) {
        schemeList!.add(SchemeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['inv_name'] = invName;
    data['tax_status'] = taxStatus;
    data['tax_status_code'] = taxStatusCode;
    data['holding_nature'] = holdingNature;
    data['holding_nature_code'] = holdingNatureCode;
    data['broker_code'] = brokerCode;
    data['investor_code'] = investorCode;
    data['logo'] = logo;
    data['bse_nse_mfu_flag'] = bseNseMfuFlag;
    if (schemeList != null) {
      data['scheme_list'] = schemeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SchemeList {
  int? id;
  int? userId;
  String? name;
  String? taxStatusCode;
  String? taxStatusDesc;
  String? holdingNatureCode;
  String? holdingNatureDesc;
  String? purchaseType;
  String? trnxType;
  String? vendor;
  String? productName;
  String? schemeName;
  String? schemeAmfiShortName;
  String? schemeProductCode;
  String? schemeCompany;
  String? schemeCompanyCode;
  String? schemeReinvestTag;
  String? toProductName;
  String? toSchemeName;
  String? toSchemeAmfiShortName;
  String? toSchemeProductCode;
  String? toSchemeCompany;
  String? toSchemeCompanyCode;
  String? toSchemeReinvestTag;
  String? folioNo;
  String? amountType;
  String? amount;
  String? totalAmount;
  String? units;
  String? totalUnits;
  String? frequency;
  String? sipDate;
  String? startDate;
  String? endDate;
  bool? untilCancel;
  String? status;
  bool? active;
  String? statusDate;
  String? clientName;
  String? investorCode;
  String? brokerCode;
  String? euinCode;
  String? paymentType;
  String? paymentMode;
  String? bankName;
  String? bankAccountNumber;
  String? bankIfsc;
  String? paymentId;
  String? bankMandate;
  String? installment;
  String? startDay;
  String? startMonth;
  String? startYear;
  String? endDay;
  String? endMonth;
  String? endYear;
  String? tenure;
  String? schemeLogo;
  String? toSchemeLogo;
  String? stpDate;
  bool? nfoFlag;

  SchemeList({
    this.id,
    this.userId,
    this.name,
    this.taxStatusCode,
    this.taxStatusDesc,
    this.holdingNatureCode,
    this.holdingNatureDesc,
    this.purchaseType,
    this.trnxType,
    this.vendor,
    this.productName,
    this.schemeName,
    this.schemeAmfiShortName,
    this.schemeProductCode,
    this.schemeCompany,
    this.schemeCompanyCode,
    this.schemeReinvestTag,
    this.toProductName,
    this.toSchemeName,
    this.toSchemeAmfiShortName,
    this.toSchemeProductCode,
    this.toSchemeCompany,
    this.toSchemeCompanyCode,
    this.toSchemeReinvestTag,
    this.folioNo,
    this.amountType,
    this.amount,
    this.totalAmount,
    this.units,
    this.totalUnits,
    this.frequency,
    this.sipDate,
    this.startDate,
    this.endDate,
    this.untilCancel,
    this.status,
    this.active,
    this.statusDate,
    this.clientName,
    this.investorCode,
    this.brokerCode,
    this.euinCode,
    this.paymentType,
    this.paymentMode,
    this.bankName,
    this.bankAccountNumber,
    this.bankIfsc,
    this.paymentId,
    this.bankMandate,
    this.installment,
    this.startDay,
    this.startMonth,
    this.startYear,
    this.endDay,
    this.endMonth,
    this.endYear,
    this.tenure,
    this.schemeLogo,
    this.toSchemeLogo,
    this.stpDate,
    this.nfoFlag,
  });

  SchemeList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    taxStatusCode = json['tax_status_code'];
    taxStatusDesc = json['tax_status_desc'];
    holdingNatureCode = json['holding_nature_code'];
    holdingNatureDesc = json['holding_nature_desc'];
    purchaseType = json['purchase_type'];
    trnxType = json['trnx_type'];
    vendor = json['vendor'];
    productName = json['product_name'];
    schemeName = json['scheme_name'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeProductCode = json['scheme_product_code'];
    schemeCompany = json['scheme_company'];
    schemeCompanyCode = json['scheme_company_code'];
    schemeReinvestTag = json['scheme_reinvest_tag'];
    toProductName = json['to_product_name'];
    toSchemeName = json['to_scheme_name'];
    toSchemeAmfiShortName = json['to_scheme_amfi_short_name'];
    toSchemeProductCode = json['to_scheme_product_code'];
    toSchemeCompany = json['to_scheme_company'];
    toSchemeCompanyCode = json['to_scheme_company_code'];
    toSchemeReinvestTag = json['to_scheme_reinvest_tag'];
    folioNo = json['folio_no'];
    amountType = json['amount_type'];
    amount = json['amount'];
    totalAmount = json['total_amount'];
    units = json['units'];
    totalUnits = json['total_units'];
    frequency = json['frequency'];
    sipDate = json['sip_date'];

    startDate = json['start_date'];
    endDate = json['end_date'];
    untilCancel = json['until_cancel'];
    status = json['status'];
    active = json['active'];
    statusDate = json['status_date'];
    clientName = json['client_name'];
    investorCode = json['investor_code'];
    brokerCode = json['broker_code'];
    euinCode = json['euin_code'];
    paymentType = json['payment_type'];
    paymentMode = json['payment_mode'];
    bankName = json['bank_name'];
    bankAccountNumber = json['bank_account_number'];
    bankIfsc = json['bank_ifsc'];
    paymentId = json['payment_id'];
    bankMandate = json['bank_mandate'];
    installment = json['installment'];
    startDay = json['start_day'];
    startMonth = json['start_month'];
    startYear = json['start_year'];
    endDay = json['end_day'];
    endMonth = json['end_month'];
    endYear = json['end_year'];
    tenure = json['tenure'];
    schemeLogo = json['scheme_logo'];
    toSchemeLogo = json['to_scheme_logo'];
    stpDate = json['stp_date'];
    nfoFlag = json['nfo_flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['tax_status_code'] = taxStatusCode;
    data['tax_status_desc'] = taxStatusDesc;
    data['holding_nature_code'] = holdingNatureCode;
    data['holding_nature_desc'] = holdingNatureDesc;
    data['purchase_type'] = purchaseType;
    data['trnx_type'] = trnxType;
    data['vendor'] = vendor;
    data['product_name'] = productName;
    data['scheme_name'] = schemeName;
    data['scheme_amfi_short_name'] = schemeAmfiShortName;
    data['scheme_product_code'] = schemeProductCode;
    data['scheme_company'] = schemeCompany;
    data['scheme_company_code'] = schemeCompanyCode;
    data['scheme_reinvest_tag'] = schemeReinvestTag;
    data['to_product_name'] = toProductName;
    data['to_scheme_name'] = toSchemeName;
    data['to_scheme_amfi_short_name'] = toSchemeAmfiShortName;
    data['to_scheme_product_code'] = toSchemeProductCode;
    data['to_scheme_company'] = toSchemeCompany;
    data['to_scheme_company_code'] = toSchemeCompanyCode;
    data['to_scheme_reinvest_tag'] = toSchemeReinvestTag;
    data['folio_no'] = folioNo;
    data['amount_type'] = amountType;
    data['amount'] = amount;
    data['total_amount'] = totalAmount;
    data['units'] = units;
    data['total_units'] = totalUnits;
    data['frequency'] = frequency;
    data['sip_date'] = sipDate;

    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['until_cancel'] = untilCancel;
    data['status'] = status;
    data['active'] = active;
    data['status_date'] = statusDate;
    data['client_name'] = clientName;
    data['investor_code'] = investorCode;
    data['broker_code'] = brokerCode;
    data['euin_code'] = euinCode;
    data['payment_type'] = paymentType;
    data['payment_mode'] = paymentMode;
    data['bank_name'] = bankName;
    data['bank_account_number'] = bankAccountNumber;
    data['bank_ifsc'] = bankIfsc;
    data['payment_id'] = paymentId;
    data['bank_mandate'] = bankMandate;
    data['installment'] = installment;
    data['start_day'] = startDay;
    data['start_month'] = startMonth;
    data['start_year'] = startYear;
    data['end_day'] = endDay;
    data['end_month'] = endMonth;
    data['end_year'] = endYear;
    data['tenure'] = tenure;
    data['scheme_logo'] = schemeLogo;
    data['to_scheme_logo'] = toSchemeLogo;
    data['stp_date'] = stpDate;
    data['nfo_flag'] = nfoFlag;
    return data;
  }
}
