class TopConsistentFundPojo {
  int? status;
  String? statusMsg;
  String? msg;
  List<ConsistentFundsPojo>? consistentFunds;

  TopConsistentFundPojo(
      {this.status, this.statusMsg, this.msg, this.consistentFunds});

  TopConsistentFundPojo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    if (json['consistentFunds'] != null) {
      consistentFunds = <ConsistentFundsPojo>[];
      json['consistentFunds'].forEach((v) {
        consistentFunds!.add(new ConsistentFundsPojo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['status_msg'] = statusMsg;
    data['msg'] = msg;
    if (consistentFunds != null) {
      data['consistentFunds'] =
          consistentFunds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ConsistentFundsPojo {
  String? schemeAmfi;
  String? schemeAmfiShortName;
  num? schemeAssets;
  String? logo;
  String? schemeRating;
  num? returnsAbs;
  num? ter;
  num? returnsAbsRank;
  num? returnsAbsTotalrank;
  String? doubleIn;
  String? schemeInceptionDate;

  ConsistentFundsPojo({
    this.schemeAmfi,
    this.schemeAmfiShortName,
    this.schemeAssets,
    this.logo,
    this.schemeRating,
    this.returnsAbs,
    this.ter,
    this.returnsAbsRank,
    this.returnsAbsTotalrank,
    this.doubleIn,
    this.schemeInceptionDate,
  });

  ConsistentFundsPojo.fromJson(Map<String, dynamic> json) {
    schemeAmfi = json['scheme_amfi'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeAssets = json['scheme_assets'];
    logo = json['logo'];
    schemeRating = json['scheme_rating'];
    returnsAbs = json['returns_abs'];
    ter = json['ter'];
    returnsAbsRank = json['returns_abs_rank'];
    returnsAbsTotalrank = json['returns_abs_totalrank'];
    doubleIn = json['double_in'];
    schemeInceptionDate = json['scheme_inception_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scheme_amfi'] = schemeAmfi;
    data['scheme_amfi_short_name'] = schemeAmfiShortName;
    data['scheme_assets'] = schemeAssets;
    data['logo'] = logo;
    data['scheme_rating'] = schemeRating;
    data['returns_abs'] = returnsAbs;
    data['ter'] = ter;
    data['returns_abs_rank'] = returnsAbsRank;
    data['returns_abs_totalrank'] = returnsAbsTotalrank;
    data['double_in'] = doubleIn;
    data['scheme_inception_date'] = schemeInceptionDate;
    return data;
  }
}
