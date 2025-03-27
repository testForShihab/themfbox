class SipDueReportResponse {
  num? status;
  String? statusMsg;
  String? msg;
  List<SipDueList>? list;

  SipDueReportResponse({this.status, this.statusMsg, this.msg, this.list});

  SipDueReportResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    if (json['list'] != null) {
      list = <SipDueList>[];
      json['list'].forEach((v) {
        list!.add(new SipDueList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_msg'] = this.statusMsg;
    data['msg'] = this.msg;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SipDueList {
  num? userId;
  String? investorName;
  String? pan;
  String? productCode;
  num? amcName;
  num? amcShortName;
  String? schemeName;
  num? toSchemeName;
  String? folio;
  String? regDate;
  String? startDate;
  String? endDate;
  String? closedDate;
  String? autoDebitDate;
  num? amount;
  num? amountStr;
  String? remarks;
  num? topUpAmount;
  String? bank;
  String? branch;
  String? chequeMicr;
  String? status;
  String? dueDate;
  num? sipFlag;
  String? email;
  String? mobile;
  num? userBranch;
  num? rmName;
  num? subbrokerName;
  num? clientName;
  num? currentCost;
  num? currentValue;
  num? xirr;
  String? logo;
  num? amcSipPer;
  num? startDte;
  num? endDte;
  num? closedDte;
  num? siptrxnno;
  num? frequency;
  num? sipActive;
  num? accHolderName;
  num? sipFrequency;
  String? schemeAmfiShortName;
  String? schemeCommonName;
  String? schemeAmfiCode;
  String? schemeCategory;
  String? schemeBroadCategory;

  SipDueList(
      {this.userId,
        this.investorName,
        this.pan,
        this.productCode,
        this.amcName,
        this.amcShortName,
        this.schemeName,
        this.toSchemeName,
        this.folio,
        this.regDate,
        this.startDate,
        this.endDate,
        this.closedDate,
        this.autoDebitDate,
        this.amount,
        this.amountStr,
        this.remarks,
        this.topUpAmount,
        this.bank,
        this.branch,
        this.chequeMicr,
        this.status,
        this.dueDate,
        this.sipFlag,
        this.email,
        this.mobile,
        this.userBranch,
        this.rmName,
        this.subbrokerName,
        this.clientName,
        this.currentCost,
        this.currentValue,
        this.xirr,
        this.logo,
        this.amcSipPer,
        this.startDte,
        this.endDte,
        this.closedDte,
        this.siptrxnno,
        this.frequency,
        this.sipActive,
        this.accHolderName,
        this.sipFrequency,
        this.schemeAmfiShortName,
        this.schemeCommonName,
        this.schemeAmfiCode,
        this.schemeCategory,
        this.schemeBroadCategory});

  SipDueList.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    investorName = json['investor_name'];
    pan = json['pan'];
    productCode = json['product_code'];
    amcName = json['amc_name'];
    amcShortName = json['amc_short_name'];
    schemeName = json['scheme_name'];
    toSchemeName = json['to_scheme_name'];
    folio = json['folio'];
    regDate = json['reg_date'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    closedDate = json['closed_date'];
    autoDebitDate = json['auto_debit_date'];
    amount = json['amount'];
    amountStr = json['amount_str'];
    remarks = json['remarks'];
    topUpAmount = json['top_up_amount'];
    bank = json['bank'];
    branch = json['branch'];
    chequeMicr = json['cheque_micr'];
    status = json['status'];
    dueDate = json['due_date'];
    sipFlag = json['sip_flag'];
    email = json['email'];
    mobile = json['mobile'];
    userBranch = json['user_branch'];
    rmName = json['rm_name'];
    subbrokerName = json['subbroker_name'];
    clientName = json['client_name'];
    currentCost = json['current_cost'];
    currentValue = json['current_value'];
    xirr = json['xirr'];
    logo = json['logo'];
    amcSipPer = json['amc_sip_per'];
    startDte = json['start_dte'];
    endDte = json['end_dte'];
    closedDte = json['closed_dte'];
    siptrxnno = json['siptrxnno'];
    frequency = json['frequency'];
    sipActive = json['sip_active'];
    accHolderName = json['acc_holder_name'];
    sipFrequency = json['sip_frequency'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeCommonName = json['scheme_common_name'];
    schemeAmfiCode = json['scheme_amfi_code'];
    schemeCategory = json['scheme_category'];
    schemeBroadCategory = json['scheme_broad_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['investor_name'] = this.investorName;
    data['pan'] = this.pan;
    data['product_code'] = this.productCode;
    data['amc_name'] = this.amcName;
    data['amc_short_name'] = this.amcShortName;
    data['scheme_name'] = this.schemeName;
    data['to_scheme_name'] = this.toSchemeName;
    data['folio'] = this.folio;
    data['reg_date'] = this.regDate;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['closed_date'] = this.closedDate;
    data['auto_debit_date'] = this.autoDebitDate;
    data['amount'] = this.amount;
    data['amount_str'] = this.amountStr;
    data['remarks'] = this.remarks;
    data['top_up_amount'] = this.topUpAmount;
    data['bank'] = this.bank;
    data['branch'] = this.branch;
    data['cheque_micr'] = this.chequeMicr;
    data['status'] = this.status;
    data['due_date'] = this.dueDate;
    data['sip_flag'] = this.sipFlag;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['user_branch'] = this.userBranch;
    data['rm_name'] = this.rmName;
    data['subbroker_name'] = this.subbrokerName;
    data['client_name'] = this.clientName;
    data['current_cost'] = this.currentCost;
    data['current_value'] = this.currentValue;
    data['xirr'] = this.xirr;
    data['logo'] = this.logo;
    data['amc_sip_per'] = this.amcSipPer;
    data['start_dte'] = this.startDte;
    data['end_dte'] = this.endDte;
    data['closed_dte'] = this.closedDte;
    data['siptrxnno'] = this.siptrxnno;
    data['frequency'] = this.frequency;
    data['sip_active'] = this.sipActive;
    data['acc_holder_name'] = this.accHolderName;
    data['sip_frequency'] = this.sipFrequency;
    data['scheme_amfi_short_name'] = this.schemeAmfiShortName;
    data['scheme_common_name'] = this.schemeCommonName;
    data['scheme_amfi_code'] = this.schemeAmfiCode;
    data['scheme_category'] = this.schemeCategory;
    data['scheme_broad_category'] = this.schemeBroadCategory;
    return data;
  }
}