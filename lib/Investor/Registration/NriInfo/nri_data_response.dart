// To parse this JSON data, do
//
//     final nriDataResponse = nriDataResponseFromJson(jsonString);

import 'dart:convert';

NriDataResponse nriDataResponseFromJson(String str) =>
    NriDataResponse.fromJson(json.decode(str));

String nriDataResponseToJson(NriDataResponse data) =>
    json.encode(data.toJson());

class NriDataResponse {
  int? status;
  String? statusMsg;
  String? msg;
  NriData? result;

  NriDataResponse({
    this.status,
    this.statusMsg,
    this.msg,
    this.result,
  });

  factory NriDataResponse.fromJson(Map<String, dynamic> json) =>
      NriDataResponse(
        status: json["status"],
        statusMsg: json["status_msg"],
        msg: json["msg"],
        result:
            json["result"] == null ? null : NriData.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_msg": statusMsg,
        "msg": msg,
        "result": result?.toJson(),
      };
}

class NriData {
  String? nriAddress1;
  String? nriAddress2;
  String? nriAddress3;
  String? nriCity;
  String? nriState;
  String? nriPincode;
  String? nriCountry;

  NriData({
    this.nriAddress1,
    this.nriAddress2,
    this.nriAddress3,
    this.nriCity,
    this.nriState,
    this.nriPincode,
    this.nriCountry,
  });

  factory NriData.fromJson(Map<String, dynamic> json) => NriData(
        nriAddress1: json["nri_address1"],
        nriAddress2: json["nri_address2"],
        nriAddress3: json["nri_address3"],
        nriCity: json["nri_city"],
        nriState: json["nri_state"],
        nriPincode: json["nri_pincode"],
        nriCountry: json["nri_country"],
      );

  Map<String, dynamic> toJson() => {
        "nri_address1": nriAddress1,
        "nri_address2": nriAddress2,
        "nri_address3": nriAddress3,
        "nri_city": nriCity,
        "nri_state": nriState,
        "nri_pincode": nriPincode,
        "nri_country": nriCountry,
      };
}
