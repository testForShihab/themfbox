class FamilyWiseSipPojo {
  String? familyHeadName;
  num? familyMemberCount;
  num? familyTotalSipAmount;
  num? familyTotalSipCount;
  num? familyTotalCurrentCost;
  num? familyTotalCurrentValue;
  num? familyTotalAbsReturn;
  List<Member>? memberList;

  FamilyWiseSipPojo(
      {this.familyHeadName,
      this.familyMemberCount,
      this.familyTotalSipAmount,
      this.familyTotalSipCount,
        this.familyTotalCurrentCost,
        this.familyTotalCurrentValue,
        this.familyTotalAbsReturn,
      this.memberList});

  FamilyWiseSipPojo.fromJson(Map<String, dynamic> json) {
    familyHeadName = json['family_head_name'];
    familyMemberCount = json['family_member_count'];
    familyTotalSipAmount = json['family_total_sip_amount'];
    familyTotalSipCount = json['family_total_sip_count'];
    familyTotalCurrentCost = json['family_total_current_cost'];
    familyTotalCurrentValue = json['family_total_current_value'];
    familyTotalAbsReturn = json['family_total_abs_return'];
    if (json['list'] != null) {
      memberList = <Member>[];
      json['list'].forEach((v) {
        memberList!.add(Member.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['family_head_name'] = familyHeadName;
    data['family_member_count'] = familyMemberCount;
    data['family_total_sip_amount'] = familyTotalSipAmount;
    data['family_total_sip_count'] = familyTotalSipCount;
    data['family_total_current_cost'] = this.familyTotalCurrentCost;
    data['family_total_current_value'] = this.familyTotalCurrentValue;
    data['family_total_abs_return'] = this.familyTotalAbsReturn;
    if (memberList != null) {
      data['list'] = memberList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Member {
  num? userId;
  num? investorId;
  String? investorName;
  String? mappingName;
  String? pan;
  String? monthlySipAmount;
  num? count;
  String? currentInvestment;
  String? currentValue;
  String? absReturn;
  String? relation;
  List<SchemeWiseSip>? schemeWiseSip;

  Member(
      {this.userId,
      this.investorId,
      this.investorName,
      this.mappingName,
      this.pan,
      this.monthlySipAmount,
      this.count,
      this.currentInvestment,
      this.currentValue,
      this.absReturn,
      this.relation,
      this.schemeWiseSip});

  Member.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    investorId = json['investor_id'];
    investorName = json['investor_name'];
    mappingName = json['mapping_name'];
    pan = json['pan'];
    monthlySipAmount = json['monthly_sip_amount'];
    count = json['count'];
    currentInvestment = json['current_investment'];
    currentValue = json['current_value'];
    absReturn = json['abs_return'];
    relation = json['relation'];
    if (json['schemeWiseSip'] != null) {
      schemeWiseSip = <SchemeWiseSip>[];
      json['schemeWiseSip'].forEach((v) {
        schemeWiseSip!.add(SchemeWiseSip.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['investor_id'] = investorId;
    data['investor_name'] = investorName;
    data['mapping_name'] = mappingName;
    data['pan'] = pan;
    data['monthly_sip_amount'] = monthlySipAmount;
    data['count'] = count;
    data['current_investment'] = currentInvestment;
    data['current_value'] = currentValue;
    data['abs_return'] = absReturn;
    data['relation'] = relation;
    if (schemeWiseSip != null) {
      data['schemeWiseSip'] = schemeWiseSip!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SchemeWiseSip {
  num? userId;
  String? folio;
  String? schemeAmfiShortName;
  num? monthlySipAmount;
  String? period;
  String? logo;
  num? currentCost;
  num? currentValue;
  num? absReturn;
  num? sipAmount;
  String? startDate;
  String? endDate;

  SchemeWiseSip(
      {this.userId,
      this.folio,
      this.schemeAmfiShortName,
      this.monthlySipAmount,
      this.period,
      this.logo,
        this.currentCost,
        this.currentValue,
        this.absReturn,
        this.sipAmount,
        this.startDate,
        this.endDate,
      });

  SchemeWiseSip.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    folio = json['folio'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    monthlySipAmount = json['monthly_sip_amount'];
    period = json['period'];
    logo = json['logo'];
    currentCost = json['current_cost'];
    currentValue = json['current_value'];
    absReturn = json['abs_return'];
    sipAmount = json['sip_amount'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['folio'] = folio;
    data['scheme_amfi_short_name'] = schemeAmfiShortName;
    data['monthly_sip_amount'] = monthlySipAmount;
    data['period'] = period;
    data['logo'] = logo;
    data['current_cost'] = this.currentCost;
    data['current_value'] = this.currentValue;
    data['abs_return'] = this.absReturn;
    data['sip_amount'] = this.sipAmount;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}
