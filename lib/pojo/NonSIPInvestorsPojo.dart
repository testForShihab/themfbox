class NonSIPInvestorsPojo {
  num? userId;
  String? invName;
  String? invPan;
  String? invMobile;
  String? invEmail;
  String? invCity;
  String? invBranch;
  String? invRmName;
  String? invSubBrokerName;
  num? aumAmount;
  String? street1;
  String? street2;
  String? street3;
  String? state;
  String? pincode;
  num? typeId;
  String? dob;
  String? createdDate;

  NonSIPInvestorsPojo(
      {this.userId,
        this.invName,
        this.invPan,
        this.invMobile,
        this.invEmail,
        this.invCity,
        this.invBranch,
        this.invRmName,
        this.invSubBrokerName,
        this.aumAmount,
        this.street1,
        this.street2,
        this.street3,
        this.state,
        this.pincode,
        this.typeId,
        this.dob,
        this.createdDate});

  NonSIPInvestorsPojo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    invName = json['inv_name'];
    invPan = json['inv_pan'];
    invMobile = json['inv_mobile'];
    invEmail = json['inv_email'];
    invCity = json['inv_city'];
    invBranch = json['inv_branch'];
    invRmName = json['inv_rm_name'];
    invSubBrokerName = json['inv_sub_broker_name'];
    aumAmount = json['aum_amount'];
    street1 = json['street1'];
    street2 = json['street2'];
    street3 = json['street3'];
    state = json['state'];
    pincode = json['pincode'];
    typeId = json['type_id'];
    dob = json['dob'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['inv_name'] = this.invName;
    data['inv_pan'] = this.invPan;
    data['inv_mobile'] = this.invMobile;
    data['inv_email'] = this.invEmail;
    data['inv_city'] = this.invCity;
    data['inv_branch'] = this.invBranch;
    data['inv_rm_name'] = this.invRmName;
    data['inv_sub_broker_name'] = this.invSubBrokerName;
    data['aum_amount'] = this.aumAmount;
    data['street1'] = this.street1;
    data['street2'] = this.street2;
    data['street3'] = this.street3;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['type_id'] = this.typeId;
    data['dob'] = this.dob;
    data['created_date'] = this.createdDate;
    return data;
  }
}