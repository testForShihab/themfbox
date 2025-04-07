class OnlineTransactionRestrictionPojo {
  num? userId;
  String? name;
  String? pan;
  String? mobile;
  String? email;
  String? branch;
  String? rmName;
  String? subbrokerName;
  num? purchaseAllowed;
  num? redeemAllowed;
  num? switchAllowed;
  num? stpAllowed;
  num? swpAllowed;
  num? oneDayChange;
  String? bseNseCode;

  OnlineTransactionRestrictionPojo(
      {this.userId,
        this.name,
        this.pan,
        this.mobile,
        this.email,
        this.branch,
        this.rmName,
        this.subbrokerName,
        this.purchaseAllowed,
        this.redeemAllowed,
        this.switchAllowed,
        this.stpAllowed,
        this.swpAllowed,
        this.oneDayChange,
        this.bseNseCode});

  OnlineTransactionRestrictionPojo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    pan = json['pan'];
    mobile = json['mobile'];
    email = json['email'];
    branch = json['branch'];
    rmName = json['rm_name'];
    subbrokerName = json['subbroker_name'];
    purchaseAllowed = json['purchase_allowed'];
    redeemAllowed = json['redeem_allowed'];
    switchAllowed = json['switch_allowed'];
    stpAllowed = json['stp_allowed'];
    swpAllowed = json['swp_allowed'];
    oneDayChange = json['one_day_change'];
    bseNseCode = json['bse_nse_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['pan'] = this.pan;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['branch'] = this.branch;
    data['rm_name'] = this.rmName;
    data['subbroker_name'] = this.subbrokerName;
    data['purchase_allowed'] = this.purchaseAllowed;
    data['redeem_allowed'] = this.redeemAllowed;
    data['switch_allowed'] = this.switchAllowed;
    data['stp_allowed'] = this.stpAllowed;
    data['swp_allowed'] = this.swpAllowed;
    data['one_day_change'] = this.oneDayChange;
    data['bse_nse_code'] = this.bseNseCode;
    return data;
  }
}