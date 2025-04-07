import 'dart:convert';

TopLumpsumResponse toplumpsumResponseFromJson(String str) =>
    TopLumpsumResponse.fromJson(json.decode(str));

String toplumpsumResponseToJson(TopLumpsumResponse data) =>
    json.encode(data.toJson());

class TopLumpsumResponse {
  int? status;
  String? statusMsg;
  String? msg;
  List<Summary>? summary;
  List<LumpsumDetails>? list;

  TopLumpsumResponse({
    this.status,
    this.statusMsg,
    this.msg,
    this.summary,
    this.list,
  });

  factory TopLumpsumResponse.fromJson(Map<String, dynamic> json) =>
      TopLumpsumResponse(
        status: json["status"],
        statusMsg: json["status_msg"],
        msg: json["msg"],
        summary: json["summary"] == null
            ? []
            : List<Summary>.from(
                json["summary"]!.map((x) => Summary.fromJson(x))),
        list: json["list"] == null
            ? []
            : List<LumpsumDetails>.from(
                json["list"]!.map((x) => LumpsumDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_msg": statusMsg,
        "msg": msg,
        "summary": summary == null
            ? []
            : List<dynamic>.from(summary!.map((x) => x.toJson())),
        "list": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class LumpsumDetails {
  String? schemeAmfi;
  String? schemeAmfiShortName;
  String? schemeCategory;
  String? schemeCompany;
  double? schemeAssets;
  String? schemeInceptionDate;
  String? logo;
  String? schemeRating;
  double? returnsAbs;
  double? ter;
  int? returnsAbsRank;
  int? returnsAbsTotalrank;
  String? doubleIn;
  double? currentValue;

  LumpsumDetails({
    this.schemeAmfi,
    this.schemeAmfiShortName,
    this.schemeCategory,
    this.schemeCompany,
    this.schemeAssets,
    this.schemeInceptionDate,
    this.logo,
    this.schemeRating,
    this.returnsAbs,
    this.ter,
    this.returnsAbsRank,
    this.returnsAbsTotalrank,
    this.doubleIn,
    this.currentValue,
  });

  factory LumpsumDetails.fromJson(Map<String, dynamic> json) => LumpsumDetails(
        schemeAmfi: json["scheme_amfi"],
        schemeAmfiShortName: json["scheme_amfi_short_name"],
        schemeCategory: json["scheme_category"],
        schemeCompany: json["scheme_company"],
        schemeAssets: json["scheme_assets"]?.toDouble(),
        schemeInceptionDate: json["scheme_inception_date"],
        logo: json["logo"],
        schemeRating: json["scheme_rating"],
        returnsAbs: json["returns_abs"]?.toDouble(),
        ter: json["ter"]?.toDouble(),
        returnsAbsRank: json["returns_abs_rank"],
        returnsAbsTotalrank: json["returns_abs_totalrank"],
        doubleIn: json["double_in"],
        currentValue: json["current_value"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "scheme_amfi": schemeAmfi,
        "scheme_amfi_short_name": schemeAmfiShortName,
        "scheme_category": schemeCategory,
        "scheme_company": schemeCompany,
        "scheme_assets": schemeAssets,
        "scheme_inception_date": schemeInceptionDate,
        "logo": logo,
        "scheme_rating": schemeRating,
        "returns_abs": returnsAbs,
        "ter": ter,
        "returns_abs_rank": returnsAbsRank,
        "returns_abs_totalrank": returnsAbsTotalrank,
        "double_in": doubleIn,
        "current_value": currentValue,
      };
}

class Summary {
  String? title;
  double? value;
  int? currentCost;
  int? currentValue;

  Summary({
    this.title,
    this.value,
    this.currentCost,
    this.currentValue,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        title: json["title"],
        value: json["value"]?.toDouble(),
        currentCost: json["current_cost"],
        currentValue: json["current_value"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "current_cost": currentCost,
        "current_value": currentValue,
      };
}
