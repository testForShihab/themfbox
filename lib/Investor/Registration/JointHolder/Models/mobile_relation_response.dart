// To parse this JSON data, do
//
//     final mobileRelationResponse = mobileRelationResponseFromJson(jsonString);

import 'dart:convert';

MobileRelationResponse mobileRelationResponseFromJson(String str) =>
    MobileRelationResponse.fromJson(json.decode(str));

String mobileRelationResponseToJson(MobileRelationResponse data) =>
    json.encode(data.toJson());

class MobileRelationResponse {
  int? status;
  String? statusMsg;
  String? msg;
  List<MobileRelationDetails>? list;

  MobileRelationResponse({
    this.status,
    this.statusMsg,
    this.msg,
    this.list,
  });

  factory MobileRelationResponse.fromJson(Map<String, dynamic> json) =>
      MobileRelationResponse(
        status: json["status"],
        statusMsg: json["status_msg"],
        msg: json["msg"],
        list: json["list"] == null
            ? []
            : List<MobileRelationDetails>.from(
                json["list"]!.map((x) => MobileRelationDetails.fromJson(x))),
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

class MobileRelationDetails {
  String? desc;
  String? code;

  MobileRelationDetails({
    this.desc,
    this.code,
  });

  factory MobileRelationDetails.fromJson(Map<String, dynamic> json) =>
      MobileRelationDetails(
        desc: json["desc"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "desc": desc,
        "code": code,
      };
}
