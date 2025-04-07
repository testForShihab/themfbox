class CartSchemePojo {
  String? schemeName;
  String? schemeReinvestTag;
  num? amount;
  String? sipDate;
  String? startDate;
  String? endDate;
  String? installment;
  String? sipTenure;

  CartSchemePojo(
      {this.schemeName,
      this.schemeReinvestTag,
      this.amount,
      this.sipDate,
      this.startDate,
      this.endDate,
      this.installment,
      this.sipTenure});

  CartSchemePojo.fromJson(Map<String, dynamic> json) {
    schemeName = json['scheme_name'];
    schemeReinvestTag = json['scheme_reinvest_tag'];
    amount = json['amount'];
    sipDate = json['sip_date'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    installment = json['installment'];
    sipTenure = json['sip_tenure'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scheme_name'] = schemeName;
    data['scheme_reinvest_tag'] = schemeReinvestTag;
    data['amount'] = amount;
    data['sip_date'] = sipDate;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['installment'] = installment;
    data['sip_tenure'] = sipTenure;
    return data;
  }
}

// String inv_name
// String tax_status
// String tax_status_code
// String holding_nature
// String holding_nature_code
// String broker_code
// String investor_code