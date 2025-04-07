
class GoalSIPAmountResponce {
  int? status;
  String? statusMsg;
  String? msg;
  int? pageid;
  int? pageCount;
  int? totalCount;
  bool? validScheme;
  double? targetAmount;
  double? inflation;
  int? years;
  double? sipAmount;

  GoalSIPAmountResponce(
      {this.status,
        this.statusMsg,
        this.msg,
        this.pageid,
        this.pageCount,
        this.totalCount,
        this.validScheme,
        this.targetAmount,
        this.inflation,
        this.years,
        this.sipAmount});

  GoalSIPAmountResponce.fromJson(Map<String?, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    pageid = json['pageid'];
    pageCount = json['pageCount'];
    totalCount = json['totalCount'];
    validScheme = json['validScheme'];
    targetAmount = json['target_amount'];
    inflation = json['inflation'];
    years = json['years'];
    sipAmount = json['sip_amount'];
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
    data['target_amount'] = this.targetAmount;
    data['inflation'] = this.inflation;
    data['years'] = this.years;
    data['sip_amount'] = this.sipAmount;
    return data;
  }
}