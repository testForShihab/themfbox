class OldActiveSipPojo {
  OldActiveSipPojo(
      {required this.investorName,
      required this.pan,
      required this.email,
      required this.mobile,
      required this.userBranch,
      required this.rmName,
      required this.subbrokerName,
      required this.productCode,
      required this.schemeName,
      required this.logo,
      required this.folio,
      required this.regDate,
      required this.startDate,
      required this.endDate,
      required this.closedDate,
      required this.autoDebitDate,
      required this.amount,
      required this.monthlySipAmount,
      required this.remarks,
      required this.topUpAmount,
      required this.bank,
      required this.branch,
      required this.chequeMicr,
      required this.status,
      required this.currentCost,
      required this.currentValue,
      required this.xirr,
      required this.frequency});

  String? investorName;
  String? pan;
  String? email;
  String? mobile;
  String? userBranch;
  String? rmName;
  String? subbrokerName;
  String? productCode;
  String? schemeName;
  String? logo;
  String? folio;
  String? regDate;
  String? startDate;
  String? endDate;
  String? closedDate;
  String? autoDebitDate;
  num? amount;
  num? monthlySipAmount;
  String? remarks;
  num? topUpAmount;
  String? bank;
  String? branch;
  String? chequeMicr;
  String? status;
  num? currentCost;
  num? currentValue;
  num? xirr;
  String? frequency;
  String? displayDate;

  OldActiveSipPojo.fromJson(Map<String, dynamic> json) {
    investorName = json['investor_name'] ?? json['name'] ?? json['inv_name'];
    pan = json['pan'];
    email = json['email'];
    mobile = json['mobile'];
    userBranch = json['user_branch'];
    rmName = json['rm_name'];
    subbrokerName = json['subbroker_name'];
    productCode = json['product_code'];
    schemeName = json['scheme_name'] ?? json['scheme'];
    logo = json['logo'] ?? json['scheme_logo'];
    folio = json['folio'] ?? json['folio_no'];
    regDate = json['reg_date'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    closedDate = json['closed_date'];
    autoDebitDate = json['auto_debit_date'];
    amount = json['amount'];
    monthlySipAmount = json['monthly_sip_amount'];
    remarks = json['remarks'];
    topUpAmount = json['top_up_amount'];
    bank = json['bank'];
    branch = json['branch'];
    chequeMicr = json['cheque_micr'];
    status = json['status'];
    currentCost = json['current_cost'];
    currentValue = json['current_value'];
    xirr = json['xirr'];
    frequency = json['frequency'];
    displayDate = json['auto_debit_date'] ?? json['start_day'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['investor_name'] = investorName;
    data['pan'] = pan;
    data['email'] = email;
    data['mobile'] = mobile;
    data['user_branch'] = userBranch;
    data['rm_name'] = rmName;
    data['subbroker_name'] = subbrokerName;
    data['product_code'] = productCode;
    data['scheme_name'] = schemeName;
    data['logo'] = logo;
    data['folio'] = folio;
    data['reg_date'] = regDate;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['closed_date'] = closedDate;
    data['auto_debit_date'] = autoDebitDate;
    data['amount'] = amount;
    data['monthly_sip_amount'] = monthlySipAmount;
    data['remarks'] = remarks;
    data['top_up_amount'] = topUpAmount;
    data['bank'] = bank;
    data['branch'] = branch;
    data['cheque_micr'] = chequeMicr;
    data['status'] = status;
    data['current_cost'] = currentCost;
    data['current_value'] = currentValue;
    data['xirr'] = xirr;
    data['frequency'] = frequency;
    data['displayDate'] = displayDate;
    return data;
  }
}
