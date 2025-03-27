// To parse this JSON data, do
//
//     final guardianRelationResponse = guardianRelationResponseFromJson(jsonString);

import 'dart:convert';

GuardianRelationResponse guardianRelationResponseFromJson(String str) =>
    GuardianRelationResponse.fromJson(json.decode(str));

String guardianRelationResponseToJson(GuardianRelationResponse data) =>
    json.encode(data.toJson());

class GuardianRelationResponse {
  int? status;
  String? statusMsg;
  String? msg;
  List<GuardianDetails>? list;

  GuardianRelationResponse({
    this.status,
    this.statusMsg,
    this.msg,
    this.list,
  });

  factory GuardianRelationResponse.fromJson(Map<String, dynamic> json) =>
      GuardianRelationResponse(
        status: json["status"],
        statusMsg: json["status_msg"],
        msg: json["msg"],
        list: json["list"] == null
            ? []
            : List<GuardianDetails>.from(
                json["list"]!.map((x) => GuardianDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_msg": statusMsg,
        "msg": msg,
        "list": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class GuardianDetails {
  String? desc;
  String? code;

  GuardianDetails({
    this.desc,
    this.code,
  });

  factory GuardianDetails.fromJson(Map<String, dynamic> json) =>
      GuardianDetails(
        desc: json["desc"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "desc": desc,
        "code": code,
      };
}
