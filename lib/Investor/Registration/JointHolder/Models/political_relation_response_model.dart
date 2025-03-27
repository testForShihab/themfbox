// To parse this JSON data, do
//
//     final politicalRelationResponse = politicalRelationResponseFromJson(jsonString);

import 'dart:convert';

PoliticalRelationResponse politicalRelationResponseFromJson(String str) =>
    PoliticalRelationResponse.fromJson(json.decode(str));

String politicalRelationResponseToJson(PoliticalRelationResponse data) =>
    json.encode(data.toJson());

class PoliticalRelationResponse {
  int? status;
  String? statusMsg;
  String? msg;
  List<PoliticalDetails>? list;

  PoliticalRelationResponse({
    this.status,
    this.statusMsg,
    this.msg,
    this.list,
  });

  factory PoliticalRelationResponse.fromJson(Map<String, dynamic> json) =>
      PoliticalRelationResponse(
        status: json["status"],
        statusMsg: json["status_msg"],
        msg: json["msg"],
        list: json["list"] == null
            ? []
            : List<PoliticalDetails>.from(
                json["list"]!.map((x) => PoliticalDetails.fromJson(x))),
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

class PoliticalDetails {
  String? desc;
  String? code;

  PoliticalDetails({
    this.desc,
    this.code,
  });

  factory PoliticalDetails.fromJson(Map<String, dynamic> json) =>
      PoliticalDetails(
        desc: json["desc"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "desc": desc,
        "code": code,
      };
}
