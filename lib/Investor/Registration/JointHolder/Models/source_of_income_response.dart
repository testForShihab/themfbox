// To parse this JSON data, do
//
//     final sourceOfIncomResponse = sourceOfIncomResponseFromJson(jsonString);

import 'dart:convert';

SourceOfIncomResponse sourceOfIncomResponseFromJson(String str) =>
    SourceOfIncomResponse.fromJson(json.decode(str));

String sourceOfIncomResponseToJson(SourceOfIncomResponse data) =>
    json.encode(data.toJson());

class SourceOfIncomResponse {
  int? status;
  String? statusMsg;
  String? msg;
  List<IncomeDetails>? list;

  SourceOfIncomResponse({
    this.status,
    this.statusMsg,
    this.msg,
    this.list,
  });

  factory SourceOfIncomResponse.fromJson(Map<String, dynamic> json) =>
      SourceOfIncomResponse(
        status: json["status"],
        statusMsg: json["status_msg"],
        msg: json["msg"],
        list: json["list"] == null
            ? []
            : List<IncomeDetails>.from(
                json["list"]!.map((x) => IncomeDetails.fromJson(x))),
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

class IncomeDetails {
  String? desc;
  String? code;

  IncomeDetails({
    this.desc,
    this.code,
  });

  factory IncomeDetails.fromJson(Map<String, dynamic> json) => IncomeDetails(
        desc: json["desc"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "desc": desc,
        "code": code,
      };
}
