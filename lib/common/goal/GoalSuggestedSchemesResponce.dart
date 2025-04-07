class GoalSuggestedSchemesResponce {
  int? status;
  String? statusMsg;
  String? msg;
  int? pageid;
  int? pageCount;
  int? totalCount;
  bool? validScheme;
  List<GoalSchemeList>? goalSchemeList;

  GoalSuggestedSchemesResponce(
      {this.status,
      this.statusMsg,
      this.msg,
      this.pageid,
      this.pageCount,
      this.totalCount,
      this.validScheme,
      this.goalSchemeList});

  GoalSuggestedSchemesResponce.fromJson(Map<String?, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    pageid = json['pageid'];
    pageCount = json['pageCount'];
    totalCount = json['totalCount'];
    validScheme = json['validScheme'];
    if (json['goal_scheme_list'] != null) {
      goalSchemeList = <GoalSchemeList>[];
      json['goal_scheme_list'].forEach((v) {
        goalSchemeList?.add(new GoalSchemeList.fromJson(v));
      });
    }
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['status'] = this.status;
    data['status_msg'] = this.statusMsg;
    data['msg'] = this.msg;
    data['pageid'] = this.pageid;
    data['pageCount'] = this.pageCount;
    data['totalCount'] = this.totalCount;
    data['validScheme'] = this.validScheme;
    if (this.goalSchemeList != null) {
      data['goal_scheme_list'] =
          this.goalSchemeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GoalSchemeList {
  String? schemeName;
  String? category;
  double? allocationPercentage;
  int? allocationAmount;
  String? sipDates;
  double? sipMinAmount;
  double? sipMaxAmount;
  int? sipMinGap;
  int? sipMaxGap;
  int? sipMinNo;
  int? sipMaxNo;
  String? amcLogo;

  String? sipDate;

  GoalSchemeList(
      {this.schemeName,
      this.category,
      this.allocationPercentage,
      this.allocationAmount,
      this.sipDates,
      this.sipMinAmount,
      this.sipMaxAmount,
      this.sipMinGap,
      this.sipMaxGap,
      this.sipMinNo,
      this.sipMaxNo,
      this.amcLogo});

  GoalSchemeList.fromJson(Map<String?, dynamic> json) {
    schemeName = json['scheme_name'];
    category = json['category'];
    allocationPercentage = json['allocation_percentage'];
    allocationAmount = json['allocation_amount'];
    sipDates = json['sip_dates'];
    sipMinAmount = json['sip_min_amount'];
    sipMaxAmount = json['sip_max_amount'];
    sipMinGap = json['sip_min_gap'];
    sipMaxGap = json['sip_max_gap'];
    sipMinNo = json['sip_min_no'];
    sipMaxNo = json['sip_max_no'];
    amcLogo = json['amc_logo'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['scheme_name'] = this.schemeName;
    data['category'] = this.category;
    data['allocation_percentage'] = this.allocationPercentage;
    data['allocation_amount'] = this.allocationAmount;
    data['sip_dates'] = this.sipDates;
    data['sip_min_amount'] = this.sipMinAmount;
    data['sip_max_amount'] = this.sipMaxAmount;
    data['sip_min_gap'] = this.sipMinGap;
    data['sip_max_gap'] = this.sipMaxGap;
    data['sip_min_no'] = this.sipMinNo;
    data['sip_max_no'] = this.sipMaxNo;
    data['amc_logo'] = this.amcLogo;
    return data;
  }
}
