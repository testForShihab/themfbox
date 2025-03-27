class InvestorInfoPojo {
  String? name;
  String? brokerCode;
  String? taxStatus;
  String? taxStatusDes;
  String? holdingNatureDesc;
  String? holdingNature;
  String? pan;
  String? bseClientCode;
  String? invCategory;

  InvestorInfoPojo(
      {this.name,
      this.brokerCode,
      this.taxStatus,
      this.taxStatusDes,
      this.holdingNatureDesc,
      this.holdingNature,
      this.pan,
      this.bseClientCode,
      this.invCategory});

  InvestorInfoPojo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    brokerCode = json['broker_code'];
    taxStatus = json['tax_status'];
    taxStatusDes = json['tax_status_des'];
    holdingNatureDesc = json['holding_nature_desc'];
    holdingNature = json['holding_nature'];
    pan = json['pan'];
    bseClientCode = json['bse_client_code'];
    invCategory = json['inv_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['broker_code'] = brokerCode;
    data['tax_status'] = taxStatus;
    data['tax_status_des'] = taxStatusDes;
    data['holding_nature_desc'] = holdingNatureDesc;
    data['holding_nature'] = holdingNature;
    data['pan'] = pan;
    data['bse_client_code'] = bseClientCode;
    data['inv_category'] = invCategory;
    return data;
  }
}
