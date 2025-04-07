class RiskWiseAumPojo {
  String? risk;
  num? aumAmount;
  num? returns;

  RiskWiseAumPojo({this.risk, this.aumAmount});

  RiskWiseAumPojo.fromJson(Map<String, dynamic> json) {
    risk = json['risk'];
    aumAmount = json['aum_amount'];
    returns = json['returns'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['risk'] = risk;
    data['aum_amount'] = aumAmount;
    data['returns'] = returns;
    return data;
  }
}
