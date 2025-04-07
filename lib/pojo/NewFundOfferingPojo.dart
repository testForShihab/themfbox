class NfoFundOfferingPojo {
  int? status;
  String? statusMsg;
  String? msg;
  List<NfoFundOffering>? nfoFundOffering;

  NfoFundOfferingPojo(
      {this.status, this.statusMsg, this.msg, this.nfoFundOffering});

  NfoFundOfferingPojo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    if (json['nfoFunds'] != null) {
      nfoFundOffering = <NfoFundOffering>[];
      json['nfoFunds'].forEach((v) {
        nfoFundOffering!.add(NfoFundOffering.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_msg'] = statusMsg;
    data['msg'] = msg;
    if (nfoFundOffering != null) {
      data['consistentFunds'] =
          nfoFundOffering!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NfoFundOffering {
  String? schemeAmfi;
  String? schemeAmfiShortName;
  num? sipMinimumAmount;
  num? lumpsumMinimumAmount;
  String? logo;
  String? benchmark;
  String? riskometer;
  String? fundManager;
  String? investmentObj;
  String? exitLoad;
  String? taxImplication;
  String? startDate;
  String? endDate;

  NfoFundOffering(
      {this.schemeAmfi,
      this.schemeAmfiShortName,
      this.sipMinimumAmount,
      this.lumpsumMinimumAmount,
      this.logo,
      this.benchmark,
      this.riskometer,
      this.fundManager,
      this.investmentObj,
      this.exitLoad,
      this.taxImplication,
        this.startDate,
        this.endDate});

  NfoFundOffering.fromJson(Map<String, dynamic> json) {
    schemeAmfi = json['scheme_amfi'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    sipMinimumAmount = json['sip_minimum_amount'];
    lumpsumMinimumAmount = json['lumpsum_minimum_amount'];
    logo = json['logo'];
    benchmark = json['benchmark'];
    riskometer = json['riskometer'];
    fundManager = json['fund_manager'];
    investmentObj = json['investment_obj'];
    exitLoad = json['exit_load'];
    taxImplication = json['tax_implication'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scheme_amfi'] = schemeAmfi;
    data['scheme_amfi_short_name'] = schemeAmfiShortName;
    data['sip_minimum_amount'] = sipMinimumAmount;
    data['lumpsum_minimum_amount'] = lumpsumMinimumAmount;
    data['logo'] = logo;
    data['benchmark'] = benchmark;
    data['riskometer'] = riskometer;
    data['fund_manager'] = fundManager;
    data['investment_obj'] = investmentObj;
    data['exit_load'] = exitLoad;
    data['tax_implication'] = taxImplication;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}
