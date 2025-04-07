import 'dart:convert';

import '../../../../pojo/JointHolderPojo.dart';

JointHolderDetailsResponse jointHolderDetailsResponseFromJson(String str) =>
    JointHolderDetailsResponse.fromJson(json.decode(str));

String jointHolderDetailsResponseToJson(JointHolderDetailsResponse data) =>
    json.encode(data.toJson());

class JointHolderDetailsResponse {
  int? status;
  String? statusMsg;
  String? msg;
  List<JoinHolderDetails>? list;

  JointHolderDetailsResponse({
    this.status,
    this.statusMsg,
    this.msg,
    this.list,
  });

  List<JointHolderPojo> get joinHolders =>
      list?.map((e) =>
          JointHolderPojo(
            jointHolderAddressType: e.jointHolderAddressType,
            jointHolderCountryBirth: e.jointHolderCountryBirth,
            jointHolderDob: e.jointHolderDob,
            jointHolderEmail: e.jointHolderEmail,
            jointHolderEmailRelation: e.jointHolderEmailRelation,
            jointHolderId: e.jointHolderId,
            jointHolderIncome: e.jointHolderIncome,
            jointHolderMobile: e.jointHolderMobile,
            jointHolderMobileRelation: e.jointHolderMobileRelation,
            jointHolderName: e.jointHolderName,
            jointHolderOccupation: e.jointHolderOccupation,
            jointHolderPan: e.jointHolderPan,
            jointHolderPlaceBirth: e.jointHolderPlaceBirth,
            jointHolderPolitical: e.jointHolderPolitical,
            jointHolderSourceWealth: e.jointHolderSourceWealth,
          )).toList() ?? [];

  factory JointHolderDetailsResponse.fromJson(Map<String, dynamic> json) =>
      JointHolderDetailsResponse(
        status: json["status"],
        statusMsg: json["status_msg"],
        msg: json["msg"],
        list: json["list"] == null
            ? []
            : List<JoinHolderDetails>.from(
            json["list"]!.map((x) => JoinHolderDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {
        "status": status,
        "status_msg": statusMsg,
        "msg": msg,
        "list": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class JoinHolderDetails {
  int? jointHolderId;
  String? jointHolderName;
  String? jointHolderPan;
  String? jointHolderDob;
  String? jointHolderEmail;
  String? jointHolderEmailRelation;
  String? jointHolderMobile;
  String? jointHolderMobileIsdCode;
  String? jointHolderMobileRelation;
  String? jointHolderPlaceBirth;
  String? jointHolderCountryBirth;
  String? jointHolderOccupation;
  String? jointHolderIncome;
  String? jointHolderSourceWealth;
  String? jointHolderAddressType;
  String? jointHolderPolitical;

  JoinHolderDetails({
    this.jointHolderId,
    this.jointHolderName,
    this.jointHolderPan,
    this.jointHolderDob,
    this.jointHolderEmail,
    this.jointHolderEmailRelation,
    this.jointHolderMobile,
    this.jointHolderMobileIsdCode,
    this.jointHolderMobileRelation,
    this.jointHolderPlaceBirth,
    this.jointHolderCountryBirth,
    this.jointHolderOccupation,
    this.jointHolderIncome,
    this.jointHolderSourceWealth,
    this.jointHolderAddressType,
    this.jointHolderPolitical,
  });

  factory JoinHolderDetails.fromJson(Map<String, dynamic> json) =>
      JoinHolderDetails(
        jointHolderId: json["joint_holder_id"],
        jointHolderName: json["joint_holder_name"],
        jointHolderPan: json["joint_holder_pan"],
        jointHolderDob: json["joint_holder_dob"],
        jointHolderEmail: json["joint_holder_email"],
        jointHolderEmailRelation: json["joint_holder_email_relation"],
        jointHolderMobile: json["joint_holder_mobile"],
        jointHolderMobileIsdCode: json["joint_holder_mobile_isd_code"],
        jointHolderMobileRelation: json["joint_holder_mobile_relation"],
        jointHolderPlaceBirth: json["joint_holder_place_birth"],
        jointHolderCountryBirth: json["joint_holder_country_birth"],
        jointHolderOccupation: json["joint_holder_occupation"],
        jointHolderIncome: json["joint_holder_income"],
        jointHolderSourceWealth: json["joint_holder_source_wealth"],
        jointHolderAddressType: json["joint_holder_address_type"],
        jointHolderPolitical: json["joint_holder_political"],
      );

  Map<String, dynamic> toJson() =>
      {
        "joint_holder_id": jointHolderId,
        "joint_holder_name": jointHolderName,
        "joint_holder_pan": jointHolderPan,
        "joint_holder_dob": jointHolderDob,
        "joint_holder_email": jointHolderEmail,
        "joint_holder_email_relation": jointHolderEmailRelation,
        "joint_holder_mobile": jointHolderMobile,
        "joint_holder_mobile_isd_code": jointHolderMobileIsdCode,
        "joint_holder_mobile_relation": jointHolderMobileRelation,
        "joint_holder_place_birth": jointHolderPlaceBirth,
        "joint_holder_country_birth": jointHolderCountryBirth,
        "joint_holder_occupation": jointHolderOccupation,
        "joint_holder_income": jointHolderIncome,
        "joint_holder_source_wealth": jointHolderSourceWealth,
        "joint_holder_address_type": jointHolderAddressType,
        "joint_holder_political": jointHolderPolitical,
      };
}
