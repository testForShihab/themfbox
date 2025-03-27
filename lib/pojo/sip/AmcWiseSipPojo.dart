// ignore_for_file: unnecessary_this

class AmcWiseSipPojo {
  String? amcName;
  String? amcShortName;
  String? amcLogo;
  num? totalSipAmount;
  num? totalSip;
  num? percentage;

  AmcWiseSipPojo(
      {this.amcName,
      this.amcShortName,
      this.amcLogo,
      this.totalSipAmount,
      this.totalSip,
      this.percentage});

  AmcWiseSipPojo.fromJson(Map<String, dynamic> json) {
    amcName = json['amc_name'];
    amcShortName = json['amc_short_name'];
    amcLogo = json['amc_logo'];
    totalSipAmount = json['total_sip_amount'];
    totalSip = json['total_sip'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amc_name'] = amcName;
    data['amc_short_name'] = this.amcShortName;
    data['amc_logo'] = this.amcLogo;
    data['total_sip_amount'] = this.totalSipAmount;
    data['total_sip'] = this.totalSip;
    data['percentage'] = this.percentage;
    return data;
  }
}
