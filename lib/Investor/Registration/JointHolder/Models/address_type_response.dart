// To parse this JSON data, do
//
//     final addressTypeResponse = addressTypeResponseFromJson(jsonString);

import 'dart:convert';

AddressTypeResponse addressTypeResponseFromJson(String str) =>
    AddressTypeResponse.fromJson(json.decode(str));

String addressTypeResponseToJson(AddressTypeResponse data) =>
    json.encode(data.toJson());

class AddressTypeResponse {
  int? status;
  String? statusMsg;
  String? msg;
  List<AddressTypeData>? list;

  AddressTypeResponse({
    this.status,
    this.statusMsg,
    this.msg,
    this.list,
  });

  factory AddressTypeResponse.fromJson(Map<String, dynamic> json) =>
      AddressTypeResponse(
        status: json["status"],
        statusMsg: json["status_msg"],
        msg: json["msg"],
        list: json["list"] == null
            ? []
            : List<AddressTypeData>.from(
                json["list"]!.map((x) => AddressTypeData.fromJson(x))),
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

class AddressTypeData {
  String? desc;
  String? code;

  AddressTypeData({
    this.desc,
    this.code,
  });

  factory AddressTypeData.fromJson(Map<String, dynamic> json) =>
      AddressTypeData(
        desc: json["desc"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "desc": desc,
        "code": code,
      };
}
