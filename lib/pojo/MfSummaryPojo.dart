class MfSummaryPojo {
  num? totalCurrCost;
  num? totalCurrValue;
  num? totalDivReinv;
  num? totalDivPaid;
  num? totalUnrealisedGain;
  num? totalRealisedGain;
  num? totalXirr;
  num? dayChangeValue;
  num? dayChangePercentage;
  num? total_abs_rtn;

  MfSummaryPojo(
      {this.totalCurrCost,
      this.totalCurrValue,
      this.totalDivReinv,
      this.totalDivPaid,
      this.totalUnrealisedGain,
      this.totalRealisedGain,
      this.totalXirr,
      this.dayChangeValue,
      this.dayChangePercentage,
      this.total_abs_rtn});

  MfSummaryPojo.fromJson(Map<String, dynamic> json) {
    totalCurrCost = json['total_curr_cost'];
    totalCurrValue = json['total_curr_value'];
    totalDivReinv = json['total_div_reinv'];
    totalDivPaid = json['total_div_paid'];
    totalUnrealisedGain = json['total_unrealised_gain'];
    totalRealisedGain = json['total_realised_gain'];
    totalXirr = json['total_xirr'];
    dayChangeValue = json['day_change_value'];
    dayChangePercentage = json['day_change_percentage'];
    total_abs_rtn = json['total_abs_rtn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_curr_cost'] = totalCurrCost;
    data['total_curr_value'] = totalCurrValue;
    data['total_div_reinv'] = totalDivReinv;
    data['total_div_paid'] = totalDivPaid;
    data['total_unrealised_gain'] = totalUnrealisedGain;
    data['total_realised_gain'] = totalRealisedGain;
    data['total_xirr'] = totalXirr;
    data['day_change_value'] = dayChangeValue;
    data['day_change_percentage'] = dayChangePercentage;
    return data;
  }
}
