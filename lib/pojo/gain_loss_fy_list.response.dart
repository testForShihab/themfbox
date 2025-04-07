import 'dart:convert';

GainLossFyResponse gainLossFyResponseFromJson(String str) =>
    GainLossFyResponse.fromJson(json.decode(str));

String gainLossFyResponseToJson(GainLossFyResponse data) =>
    json.encode(data.toJson());

class GainLossFyResponse {
  int? status;
  String? statusMsg;
  String? msg;
  List<String>? list;

  GainLossFyResponse({
    this.status,
    this.statusMsg,
    this.msg,
    this.list,
  });

  factory GainLossFyResponse.fromJson(Map<String, dynamic> json) =>
      GainLossFyResponse(
        status: json["status"],
        statusMsg: json["status_msg"],
        msg: json["msg"],
        list: json["list"] == null
            ? []
            : List<String>.from(json["list"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_msg": statusMsg,
        "msg": msg,
        "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x)),
      };
}
