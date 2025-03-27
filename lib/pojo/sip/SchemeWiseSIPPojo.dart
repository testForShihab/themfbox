class SchemeWiseSIPPojo {
  String? schemeAmfi;
  String? schemeAmfiShortName;
  String? schemeCompany;
  String? schemeAmfiCode;
  String? logo;
  num? sipCounts;
  num? sipCurrValue;

  SchemeWiseSIPPojo(
      {this.schemeAmfi,
      this.schemeAmfiShortName,
      this.schemeCompany,
      this.schemeAmfiCode,
      this.logo,
      this.sipCounts,
      this.sipCurrValue});

  SchemeWiseSIPPojo.fromJson(Map<String, dynamic> json) {
    schemeAmfi = json['scheme_amfi'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeCompany = json['scheme_company'];
    schemeAmfiCode = json['scheme_amfi_code'];
    logo = json['logo'];
    sipCounts = json['sip_counts'];
    sipCurrValue = json['sip_curr_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scheme_amfi'] = schemeAmfi;
    data['scheme_amfi_short_name'] = schemeAmfiShortName;
    data['scheme_company'] = schemeCompany;
    data['scheme_amfi_code'] = schemeAmfiCode;
    data['logo'] = logo;
    data['sip_counts'] = sipCounts;
    data['sip_curr_value'] = sipCurrValue;
    return data;
  }
}
