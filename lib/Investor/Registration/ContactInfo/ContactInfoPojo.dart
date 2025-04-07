class ContactInfoPojo {
  String? pincode;
  String? city;
  String? state;
  String? stateCode;
  String? address1;
  String? address2;
  String? address3;
  String? country;

  ContactInfoPojo(
      {this.pincode,
      this.city,
      this.state,
      this.stateCode,
      this.address1,
      this.address2,
      this.address3,
      this.country});

  ContactInfoPojo.fromJson(Map<String, dynamic> json) {
    pincode = json['pincode'];
    city = json['city'];
    state = json['state'];
    stateCode = json['state_code'];
    address1 = json['address1'];
    address2 = json['address2'];
    address3 = json['address3'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pincode'] = pincode;
    data['city'] = city;
    data['state'] = state;
    data['state_code'] = stateCode;
    data['address1'] = address1;
    data['address2'] = address2;
    data['address3'] = address3;
    data['country'] = country;
    return data;
  }
}
