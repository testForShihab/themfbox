// To parse this JSON data, do
//
//     final employmentStatusResponse = employmentStatusResponseFromJson(jsonString);

import 'dart:convert';

EmploymentStatusResponse employmentStatusResponseFromJson(String str) =>
    EmploymentStatusResponse.fromJson(json.decode(str));

String employmentStatusResponseToJson(EmploymentStatusResponse data) =>
    json.encode(data.toJson());

class EmploymentStatusResponse {
  int? status;
  String? statusMsg;
  String? msg;
  List<EmploymentDetails>? list;

  EmploymentStatusResponse({
    this.status,
    this.statusMsg,
    this.msg,
    this.list,
  });

  factory EmploymentStatusResponse.fromJson(Map<String, dynamic> json) =>
      EmploymentStatusResponse(
        status: json["status"],
        statusMsg: json["status_msg"],
        msg: json["msg"],
        list: json["list"] == null
            ? []
            : List<EmploymentDetails>.from(
                json["list"]!.map((x) => EmploymentDetails.fromJson(x))),
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

class EmploymentDetails {
  String? desc;
  String? code;

  EmploymentDetails({
    this.desc,
    this.code,
  });

  factory EmploymentDetails.fromJson(Map<String, dynamic> json) =>
      EmploymentDetails(
        desc: json["desc"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "desc": desc,
        "code": code,
      };
}
