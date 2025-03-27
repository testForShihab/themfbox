import 'dart:convert';

RelationshipProofResponse relationshipProofResponseFromJson(String str) =>
    RelationshipProofResponse.fromJson(json.decode(str));

String relationshipProofResponseToJson(RelationshipProofResponse data) =>
    json.encode(data.toJson());

class RelationshipProofResponse {
  int? status;
  String? statusMsg;
  String? msg;
  List<ProofDetails>? list;

  RelationshipProofResponse({
    this.status,
    this.statusMsg,
    this.msg,
    this.list,
  });

  factory RelationshipProofResponse.fromJson(Map<String, dynamic> json) =>
      RelationshipProofResponse(
        status: json["status"],
        statusMsg: json["status_msg"],
        msg: json["msg"],
        list: json["list"] == null
            ? []
            : List<ProofDetails>.from(
                json["list"]!.map((x) => ProofDetails.fromJson(x))),
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

class ProofDetails {
  String? desc;
  String? code;

  ProofDetails({
    this.desc,
    this.code,
  });

  factory ProofDetails.fromJson(Map<String, dynamic> json) => ProofDetails(
        desc: json["desc"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "desc": desc,
        "code": code,
      };
}
