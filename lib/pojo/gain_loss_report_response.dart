import 'dart:convert';

GainLossReportResponse gainLossReportResponseFromJson(String str) =>
    GainLossReportResponse.fromJson(json.decode(str));

String gainLossReportResponseToJson(GainLossReportResponse data) =>
    json.encode(data.toJson());

class GainLossReportResponse {
  int? status;
  String? statusMsg;
  String? msg;
  GainLossDetails? result;

  GainLossReportResponse({
    this.status,
    this.statusMsg,
    this.msg,
    this.result,
  });

  factory GainLossReportResponse.fromJson(Map<String, dynamic> json) =>
      GainLossReportResponse(
        status: json["status"],
        statusMsg: json["status_msg"],
        msg: json["msg"],
        result: json["result"] == null
            ? null
            : GainLossDetails.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_msg": statusMsg,
        "msg": msg,
        "result": result?.toJson(),
      };
}

class GainLossDetails {
  double? totalGainLoss;
  double? totalStGain;
  double? totalLtGain;
  SchemeData? debtResult;
  SchemeData? equityResult;

  GainLossDetails({
    this.totalGainLoss,
    this.totalStGain,
    this.totalLtGain,
    this.debtResult,
    this.equityResult,
  });

  factory GainLossDetails.fromJson(Map<String, dynamic> json) =>
      GainLossDetails(
        totalGainLoss: json["total_gain_loss"]?.toDouble(),
        totalStGain: json["total_st_gain"]?.toDouble(),
        totalLtGain: json["total_lt_gain"]?.toDouble(),
        debtResult: json["debt_result"] == null
            ? null
            : SchemeData.fromJson(json["debt_result"]),
        equityResult: json["equity_result"] == null
            ? null
            : SchemeData.fromJson(json["equity_result"]),
      );

  Map<String, dynamic> toJson() => {
        "total_gain_loss": totalGainLoss,
        "total_st_gain": totalStGain,
        "total_lt_gain": totalLtGain,
        "debt_result": debtResult?.toJson(),
        "equity_result": equityResult?.toJson(),
      };
}

class SchemeData {
  String? category;
  double? stSoldTotal;
  double? stPurchaseTotal;
  double? stGainTotal;
  double? stLossTotal;
  double? ltSoldTotal;
  double? ltPurchaseTotal;
  double? ltGainTotal;
  double? ltLossTotal;
  double? overallGainLoss;
  List<SchemeDetails>? list;

  SchemeData({
    this.category,
    this.stSoldTotal,
    this.stPurchaseTotal,
    this.stGainTotal,
    this.stLossTotal,
    this.ltSoldTotal,
    this.ltPurchaseTotal,
    this.ltGainTotal,
    this.ltLossTotal,
    this.overallGainLoss,
    this.list,
  });

  factory SchemeData.fromJson(Map<String, dynamic> json) => SchemeData(
        category: json["category"],
        stSoldTotal: json["st_sold_total"]?.toDouble(),
        stPurchaseTotal: json["st_purchase_total"]?.toDouble(),
        stGainTotal: json["st_gain_total"]?.toDouble(),
        stLossTotal: json["st_loss_total"],
        ltSoldTotal: json["lt_sold_total"],
        ltPurchaseTotal: json["lt_purchase_total"],
        ltGainTotal: json["lt_gain_total"],
        ltLossTotal: json["lt_loss_total"],
        overallGainLoss: json["overall_gain_loss"]?.toDouble(),
        list: json["list"] == null
            ? []
            : List<SchemeDetails>.from(
                json["list"]!.map((x) => SchemeDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "st_sold_total": stSoldTotal,
        "st_purchase_total": stPurchaseTotal,
        "st_gain_total": stGainTotal,
        "st_loss_total": stLossTotal,
        "lt_sold_total": ltSoldTotal,
        "lt_purchase_total": ltPurchaseTotal,
        "lt_gain_total": ltGainTotal,
        "lt_loss_total": ltLossTotal,
        "overall_gain_loss": overallGainLoss,
        "list": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class SchemeDetails {
  String? schemeAmfi;
  String? schemeAmfiShortName;
  String? folioNo;
  String? logo;
  double? stSold;
  double? stPurchase;
  double? stGain;
  double? stLoss;
  double? ltSold;
  double? ltPurchase;
  double? ltGain;
  double? ltLoss;
  double? totalGainLoss;

  SchemeDetails({
    this.schemeAmfi,
    this.schemeAmfiShortName,
    this.folioNo,
    this.logo,
    this.stSold,
    this.stPurchase,
    this.stGain,
    this.stLoss,
    this.ltSold,
    this.ltPurchase,
    this.ltGain,
    this.ltLoss,
    this.totalGainLoss,
  });

  factory SchemeDetails.fromJson(Map<String, dynamic> json) => SchemeDetails(
        schemeAmfi: json["scheme_amfi"],
        schemeAmfiShortName: json["scheme_amfi_short_name"],
        folioNo: json["folio_no"],
        logo: json["logo"],
        stSold: json["st_sold"]?.toDouble(),
        stPurchase: json["st_purchase"]?.toDouble(),
        stGain: json["st_gain"]?.toDouble(),
        stLoss: json["st_loss"],
        ltSold: json["lt_sold"],
        ltPurchase: json["lt_purchase"],
        ltGain: json["lt_gain"],
        ltLoss: json["lt_loss"],
        totalGainLoss: json["total_gain_loss"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "scheme_amfi": schemeAmfi,
        "scheme_amfi_short_name": schemeAmfiShortName,
        "folio_no": folioNo,
        "logo": logo,
        "st_sold": stSold,
        "st_purchase": stPurchase,
        "st_gain": stGain,
        "st_loss": stLoss,
        "lt_sold": ltSold,
        "lt_purchase": ltPurchase,
        "lt_gain": ltGain,
        "lt_loss": ltLoss,
        "total_gain_loss": totalGainLoss,
      };
}
