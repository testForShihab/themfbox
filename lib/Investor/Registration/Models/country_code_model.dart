// To parse this JSON data, do
//
//     final countryListResponse = countryListResponseFromJson(jsonString);

import 'dart:convert';

CountryListResponse countryListResponseFromJson(String str) =>
    CountryListResponse.fromJson(json.decode(str));

String countryListResponseToJson(CountryListResponse data) =>
    json.encode(data.toJson());

class CountryListResponse {
  int? status;
  String? statusMsg;
  String? msg;
  List<CountryDetails>? list;

  CountryListResponse({
    this.status,
    this.statusMsg,
    this.msg,
    this.list,
  });

  factory CountryListResponse.fromJson(Map<String, dynamic> json) =>
      CountryListResponse(
        status: json["status"],
        statusMsg: json["status_msg"],
        msg: json["msg"],
        list: json["list"] == null
            ? []
            : List<CountryDetails>.from(
                json["list"]!.map((x) => CountryDetails.fromJson(x))),
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

class CountryDetails {
  String? countryName;
  String? countryCode;

  CountryDetails({
    this.countryName,
    this.countryCode,
  });

  factory CountryDetails.fromJson(Map<String, dynamic> json) => CountryDetails(
        countryName: json["country_name"],
        countryCode: json["country_code"],
      );

  Map<String, dynamic> toJson() => {
        "country_name": countryName,
        "country_code": countryCode,
      };
}
