class CartPojo {
  int? id;
  int? userId;
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
  String? paymentMode;
  String? bankName;
  String? bankAccountNumber;
  String? bankIfsc;
  String? schemeLogo;
  String? toSchemeLogo;

  CartPojo(
      {this.id,
      this.userId,
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
      this.paymentMode,
      this.bankName,
      this.bankAccountNumber,
      this.bankIfsc,
      this.schemeLogo,
      this.toSchemeLogo});

  CartPojo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
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
    paymentMode = json['payment_mode'];
    bankName = json['bank_name'];
    bankAccountNumber = json['bank_account_number'];
    bankIfsc = json['bank_ifsc'];
    schemeLogo = json['scheme_logo'];
    toSchemeLogo = json['to_scheme_logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
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
    data['payment_mode'] = paymentMode;
    data['bank_name'] = bankName;
    data['bank_account_number'] = bankAccountNumber;
    data['bank_ifsc'] = bankIfsc;
    data['scheme_logo'] = schemeLogo;
    data['to_scheme_logo'] = toSchemeLogo;
    return data;
  }
}
