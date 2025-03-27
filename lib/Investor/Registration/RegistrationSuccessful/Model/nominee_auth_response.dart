// To parse this JSON data, do
//
//     final nomineeAuthenticationResponse = nomineeAuthenticationResponseFromJson(jsonString);

import 'dart:convert';

NomineeAuthenticationResponse nomineeAuthenticationResponseFromJson(
        String str) =>
    NomineeAuthenticationResponse.fromJson(json.decode(str));

String nomineeAuthenticationResponseToJson(
        NomineeAuthenticationResponse data) =>
    json.encode(data.toJson());

class NomineeAuthenticationResponse {
  int? status;
  String? statusMsg;
  String? msg;
  String? paymentId;
  AuthDetails? result;

  NomineeAuthenticationResponse({
    this.status,
    this.statusMsg,
    this.msg,
    this.paymentId,
    this.result,
  });

  factory NomineeAuthenticationResponse.fromJson(Map<String, dynamic> json) =>
      NomineeAuthenticationResponse(
        status: json["status"],
        statusMsg: json["status_msg"],
        msg: json["msg"],
        paymentId: json["payment_id"],
        result: json["result"] == null
            ? null
            : AuthDetails.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_msg": statusMsg,
        "msg": msg,
        "payment_id": paymentId,
        "result": result?.toJson(),
      };
}

class AuthDetails {
  String? paymentLink;
  String? transactionNumber;

  AuthDetails({
    this.paymentLink,
    this.transactionNumber,
  });

  factory AuthDetails.fromJson(Map<String, dynamic> json) => AuthDetails(
        paymentLink: json["payment_link"],
        transactionNumber: json["transaction_number"],
      );

  Map<String, dynamic> toJson() => {
        "payment_link": paymentLink,
        "transaction_number": transactionNumber,
      };
}
