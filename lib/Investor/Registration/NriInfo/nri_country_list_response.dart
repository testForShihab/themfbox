// To parse this JSON data, do
//
//     final nriCountryListResponse = nriCountryListResponseFromJson(jsonString);

import 'dart:convert';

NriCountryListResponse nriCountryListResponseFromJson(String str) =>
    NriCountryListResponse.fromJson(json.decode(str));

String nriCountryListResponseToJson(NriCountryListResponse data) =>
    json.encode(data.toJson());

class NriCountryListResponse {
  int? status;
  String? statusMsg;
  String? msg;
  List<CountryData>? list;

  NriCountryListResponse({
    this.status,
    this.statusMsg,
    this.msg,
    this.list,
  });

  factory NriCountryListResponse.fromJson(Map<String, dynamic> json) =>
      NriCountryListResponse(
        status: json["status"],
        statusMsg: json["status_msg"],
        msg: json["msg"],
        list: json["list"] == null
            ? []
            : List<CountryData>.from(
                json["list"]!.map((x) => CountryData.fromJson(x))),
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

class CountryData {
  String? desc;
  String? code;

  CountryData({
    this.desc,
    this.code,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
        desc: json["desc"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "desc": desc,
        "code": code,
      };
}
