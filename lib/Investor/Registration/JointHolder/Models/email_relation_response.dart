// To parse this JSON data, do
//
//     final emailRelationResponse = emailRelationResponseFromJson(jsonString);

import 'dart:convert';

EmailRelationResponse emailRelationResponseFromJson(String str) =>
    EmailRelationResponse.fromJson(json.decode(str));

String emailRelationResponseToJson(EmailRelationResponse data) =>
    json.encode(data.toJson());

class EmailRelationResponse {
  int? status;
  String? statusMsg;
  String? msg;
  List<EmailRelationDetails>? list;

  EmailRelationResponse({
    this.status,
    this.statusMsg,
    this.msg,
    this.list,
  });

  factory EmailRelationResponse.fromJson(Map<String, dynamic> json) =>
      EmailRelationResponse(
        status: json["status"],
        statusMsg: json["status_msg"],
        msg: json["msg"],
        list: json["list"] == null
            ? []
            : List<EmailRelationDetails>.from(
                json["list"]!.map((x) => EmailRelationDetails.fromJson(x))),
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

class EmailRelationDetails {
  String? desc;
  String? code;

  EmailRelationDetails({
    this.desc,
    this.code,
  });

  factory EmailRelationDetails.fromJson(Map<String, dynamic> json) =>
      EmailRelationDetails(
        desc: json["desc"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "desc": desc,
        "code": code,
      };
}
