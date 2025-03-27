// To parse this JSON data, do
//
//     final annualSalaryResponse = annualSalaryResponseFromJson(jsonString);

import 'dart:convert';

AnnualSalaryResponse annualSalaryResponseFromJson(String str) =>
    AnnualSalaryResponse.fromJson(json.decode(str));

String annualSalaryResponseToJson(AnnualSalaryResponse data) =>
    json.encode(data.toJson());

class AnnualSalaryResponse {
  int? status;
  String? statusMsg;
  String? msg;
  List<SalaryDetails>? list;

  AnnualSalaryResponse({
    this.status,
    this.statusMsg,
    this.msg,
    this.list,
  });

  factory AnnualSalaryResponse.fromJson(Map<String, dynamic> json) =>
      AnnualSalaryResponse(
        status: json["status"],
        statusMsg: json["status_msg"],
        msg: json["msg"],
        list: json["list"] == null
            ? []
            : List<SalaryDetails>.from(
                json["list"]!.map((x) => SalaryDetails.fromJson(x))),
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

class SalaryDetails {
  String? desc;
  String? code;

  SalaryDetails({
    this.desc,
    this.code,
  });

  factory SalaryDetails.fromJson(Map<String, dynamic> json) => SalaryDetails(
        desc: json["desc"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "desc": desc,
        "code": code,
      };
}
