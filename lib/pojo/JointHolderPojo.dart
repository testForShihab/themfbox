class JointHolderPojo {
  int? jointHolderId;
  String? jointHolderName;
  String? jointHolderPan;
  String? jointHolderDob;
  String? jointHolderEmail;
  String? jointHolderEmailRelation;
  String? jointHolderMobile;
  String? jointHolderMobileRelation;
  String? jointHolderPlaceBirth;
  String? jointHolderCountryBirth;
  String? jointHolderOccupation;
  String? jointHolderIncome;
  String? jointHolderSourceWealth;
  String? jointHolderAddressType;
  String? jointHolderPolitical;

  JointHolderPojo(
      {this.jointHolderId,
      this.jointHolderName,
      this.jointHolderPan,
      this.jointHolderDob,
      this.jointHolderEmail,
      this.jointHolderEmailRelation,
      this.jointHolderMobile,
      this.jointHolderMobileRelation,
      this.jointHolderPlaceBirth,
      this.jointHolderCountryBirth,
      this.jointHolderOccupation,
      this.jointHolderIncome,
      this.jointHolderSourceWealth,
      this.jointHolderAddressType,
      this.jointHolderPolitical});

  JointHolderPojo.fromJson(Map<String, dynamic> json) {
    jointHolderId = json['joint_holder_id'];
    jointHolderName = json['joint_holder_name'];
    jointHolderPan = json['joint_holder_pan'];
    jointHolderDob = json['joint_holder_dob'];
    jointHolderEmail = json['joint_holder_email'];
    jointHolderEmailRelation = json['joint_holder_email_relation'];
    jointHolderMobile = json['joint_holder_mobile'];
    jointHolderMobileRelation = json['joint_holder_mobile_relation'];
    jointHolderPlaceBirth = json['joint_holder_place_birth'];
    jointHolderCountryBirth = json['joint_holder_country_birth'];
    jointHolderOccupation = json['joint_holder_occupation'];
    jointHolderIncome = json['joint_holder_income'];
    jointHolderSourceWealth = json['joint_holder_source_wealth'];
    jointHolderAddressType = json['joint_holder_address_type'];
    jointHolderPolitical = json['joint_holder_political'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['joint_holder_id'] = jointHolderId;
    data['joint_holder_name'] = jointHolderName;
    data['joint_holder_pan'] = jointHolderPan;
    data['joint_holder_dob'] = jointHolderDob;
    data['joint_holder_email'] = jointHolderEmail;
    data['joint_holder_email_relation'] = jointHolderEmailRelation;
    data['joint_holder_mobile'] = jointHolderMobile;
    data['joint_holder_mobile_relation'] = jointHolderMobileRelation;
    data['joint_holder_place_birth'] = jointHolderPlaceBirth;
    data['joint_holder_country_birth'] = jointHolderCountryBirth;
    data['joint_holder_occupation'] = jointHolderOccupation;
    data['joint_holder_income'] = jointHolderIncome;
    data['joint_holder_source_wealth'] = jointHolderSourceWealth;
    data['joint_holder_address_type'] = jointHolderAddressType;
    data['joint_holder_political'] = jointHolderPolitical;
    return data;
  }
}
