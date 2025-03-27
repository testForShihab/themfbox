class CartCountPojo {
  int? totalCount;
  int? lumpsumCount;
  int? sipCount;
  int? redeemCount;
  int? switchCount;
  int? stpCount;
  int? swpCount;

  CartCountPojo(
      {this.totalCount,
      this.lumpsumCount,
      this.sipCount,
      this.redeemCount,
      this.switchCount,
      this.stpCount,
      this.swpCount});

  CartCountPojo.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    lumpsumCount = json['lumpsum_count'];
    sipCount = json['sip_count'];
    redeemCount = json['redeem_count'];
    switchCount = json['switch_count'];
    stpCount = json['stp_count'];
    swpCount = json['swp_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_count'] = totalCount;
    data['lumpsum_count'] = lumpsumCount;
    data['sip_count'] = sipCount;
    data['redeem_count'] = redeemCount;
    data['switch_count'] = switchCount;
    data['stp_count'] = stpCount;
    data['swp_count'] = swpCount;
    return data;
  }
}
