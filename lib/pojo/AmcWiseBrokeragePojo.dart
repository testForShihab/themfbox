class AmcWiseBrokerageResponse {
  String? amcName;
  String? month;
  String? logo;
  num? brokerageAmount;

  AmcWiseBrokerageResponse(
      {this.amcName, this.month, this.logo, this.brokerageAmount});

  AmcWiseBrokerageResponse.fromJson(Map<String, dynamic> json) {
    amcName = json['amc_name'];
    month = json['month'];
    logo = json['logo'];
    brokerageAmount = json['brokerage_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amc_name'] = this.amcName;
    data['month'] = this.month;
    data['logo'] = this.logo;
    data['brokerage_amount'] = this.brokerageAmount;
    return data;
  }
}

