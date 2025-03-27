class NomineePojo {
  int? nomineeId;
  String? nomineeType;
  String? nomineeTypeDesc;
  String? nomineeName;
  String? nomineeDob;
  String? nomineeGuardName;
  String? nomineeGuardPan;
  String? nomineeGuardDob;
  String? nomineeAddress1;
  String? nomineeAddress2;
  String? nomineeAddress3;
  String? nomineePincode;
  String? nomineeCity;
  String? nomineeState;
  String? nomineeRelation;
  num? nomineePercentage;
  String? guardRelation;

  NomineePojo(
      {this.nomineeId,
      this.nomineeType,
      this.nomineeTypeDesc,
      this.nomineeName,
      this.nomineeDob,
      this.nomineeGuardName,
      this.nomineeGuardPan,
      this.nomineeGuardDob,
      this.nomineeAddress1,
      this.nomineeAddress2,
      this.nomineeAddress3,
      this.nomineePincode,
      this.nomineeCity,
      this.nomineeState,
      this.nomineeRelation,
      this.nomineePercentage,
      this.guardRelation});

  NomineePojo.fromJson(Map<String, dynamic> json) {
    nomineeId = json['nominee_id'];
    nomineeType = json['nominee_type'];
    nomineeTypeDesc = json['nominee_type_desc'];
    nomineeName = json['nominee_name'];
    nomineeDob = json['nominee_dob'];
    nomineeGuardName = json['nominee_guard_name'];
    nomineeGuardPan = json['nominee_guard_pan'];
    nomineeGuardDob = json['nominee_guard_dob'];
    nomineeAddress1 = json['nominee_address1'];
    nomineeAddress2 = json['nominee_address2'];
    nomineeAddress3 = json['nominee_address3'];
    nomineePincode = json['nominee_pincode'];
    nomineeCity = json['nominee_city'];
    nomineeState = json['nominee_state'];
    nomineeRelation = json['nominee_relation'];
    nomineeRelation = json['nominee_relation'];
    guardRelation = json['nominee_guard_relation'];

    if (json['nominee_percentage'].runtimeType == String)
      nomineePercentage = num.tryParse(json['nominee_percentage']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nominee_id'] = nomineeId;
    data['nominee_type'] = nomineeType;
    data['nominee_type_desc'] = nomineeTypeDesc;
    data['nominee_name'] = nomineeName;
    data['nominee_dob'] = nomineeDob;
    data['nominee_guard_name'] = nomineeGuardName;
    data['nominee_guard_pan'] = nomineeGuardPan;
    data['nominee_guard_dob'] = nomineeGuardDob;
    data['nominee_address1'] = nomineeAddress1;
    data['nominee_address2'] = nomineeAddress2;
    data['nominee_address3'] = nomineeAddress3;
    data['nominee_pincode'] = nomineePincode;
    data['nominee_city'] = nomineeCity;
    data['nominee_state'] = nomineeState;
    data['nominee_relation'] = nomineeRelation;
    data['nominee_percentage'] = nomineePercentage;
    data['nominee_guard_relation'] = guardRelation;
    return data;
  }
}
