class PersonalInfoPojo {
  String? name;
  String? dob;
  String? gender;
  String? email;
  String? emailRelation;
  String? emailRelationDesc;
  String? mobile;
  String? mobileRelation;
  String? mobileRelationDesc;
  String? alterMobile;
  String? alterEmail;
  String? phoneOffice;
  String? phoneResidence;
  String? placeBirth;
  String? countryBirth;
  String? countryBirthCode;
  String? occupation;
  String? occupationCode;
  String? occupationOther;
  String? income;
  String? incomeCode;
  String? sourceWealth;
  String? sourceWealthCode;
  String? sourceWealthOther;
  String? politicalStatus;
  String? politicalStatusCode;
  String? guardName;
  String? guardPan;
  String? guardDob;
  String? guardRelation;
  String? guardRelationProof;
  String? fatherName;
  String? addressType;
  String? addressTypeDesc;
  String? networthDob;
  String? networthAmount;
  String? mobileIsdCode;
  String? guardMob;
  String? guardEmail;

  PersonalInfoPojo({
    this.name,
    this.dob,
    this.gender,
    this.email,
    this.emailRelation,
    this.emailRelationDesc,
    this.mobile,
    this.mobileRelation,
    this.alterMobile,
    this.alterEmail,
    this.phoneOffice,
    this.phoneResidence,
    this.placeBirth,
    this.countryBirth,
    this.countryBirthCode,
    this.occupation,
    this.occupationCode,
    this.occupationOther,
    this.income,
    this.incomeCode,
    this.sourceWealth,
    this.sourceWealthCode,
    this.sourceWealthOther,
    this.politicalStatus,
    this.politicalStatusCode,
    this.guardName,
    this.guardPan,
    this.guardDob,
    this.guardRelation,
    this.guardRelationProof,
    this.fatherName,
    this.addressType,
    this.addressTypeDesc,
    this.networthDob,
    this.networthAmount,
    this.mobileRelationDesc,
    this.mobileIsdCode,
    this.guardMob,
    this.guardEmail,
  });

  PersonalInfoPojo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dob = json['dob'];
    gender = json['gender'];
    email = json['email'];
    emailRelation = json['email_relation'];
    emailRelationDesc = json['email_relation_desc'];
    mobile = json['mobile'];
    mobileRelation = json['mobile_relation'];
    mobileRelationDesc = json['mobile_relation_desc'];
    alterMobile = json['alter_mobile'];
    alterEmail = json['alter_email'];
    phoneOffice = json['phone_office'];
    phoneResidence = json['phone_residence'];
    placeBirth = json['place_birth'];
    countryBirth = json['country_birth'];
    countryBirthCode = json['country_birth_code'];
    occupation = json['occupation'];
    occupationCode = json['occupation_code'];
    occupationOther = json['occupation_other'];
    income = json['income'];
    incomeCode = json['income_code'];
    sourceWealth = json['source_wealth'];
    sourceWealthCode = json['source_wealth_code'];
    sourceWealthOther = json['source_wealth_other'];
    politicalStatus = json['political_status'];
    politicalStatusCode = json['political_status_code'];
    guardName = json['guard_name'];
    guardPan = json['guard_pan'];
    guardDob = json['guard_dob'];
    guardRelation = json['guard_relation'];
    guardRelationProof = json['guard_relation_proof'];
    fatherName = json['father_name'];
    addressType = json['address_type'];
    addressTypeDesc = json['address_type_desc'];
    networthDob = json['networth_dob'];
    networthAmount = json['networth_amount'];
    mobileIsdCode = json['mobile_isd_code'];
    guardMob = json['guard_mobile'];
    guardEmail = json['guard_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['dob'] = dob;
    data['gender'] = gender;
    data['email'] = email;
    data['email_relation'] = emailRelation;
    data['email_relation_desc'] = emailRelationDesc;
    data['mobile'] = mobile;
    data['mobile_relation'] = mobileRelation;
    data['mobile_relation_desc'] = mobileRelationDesc;
    data['alter_mobile'] = alterMobile;
    data['alter_email'] = alterEmail;
    data['phone_office'] = phoneOffice;
    data['phone_residence'] = phoneResidence;
    data['place_birth'] = placeBirth;
    data['country_birth'] = countryBirth;
    data['country_birth_code'] = countryBirthCode;
    data['occupation'] = occupation;
    data['occupation_code'] = occupationCode;
    data['occupation_other'] = occupationOther;
    data['income'] = income;
    data['income_code'] = incomeCode;
    data['source_wealth'] = sourceWealth;
    data['source_wealth_code'] = sourceWealthCode;
    data['source_wealth_other'] = sourceWealthOther;
    data['political_status'] = politicalStatus;
    data['political_status_code'] = politicalStatusCode;
    data['guard_name'] = guardName;
    data['guard_pan'] = guardPan;
    data['guard_dob'] = guardDob;
    data['guard_relation'] = guardRelation;
    data['guard_relation_proof'] = guardRelationProof;
    data['father_name'] = fatherName;
    data['address_type'] = addressType;
    data['address_type_desc'] = addressTypeDesc;
    data['networth_dob'] = networthDob;
    data['networth_amount'] = networthAmount;
    data['mobile_isd_code'] = mobileIsdCode;
    data['guard_mobile'] = guardMob;
    data['guard_email'] = guardEmail;
    return data;
  }
}
