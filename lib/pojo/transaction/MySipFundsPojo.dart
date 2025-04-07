class MySipFundsPojo {
  String? amcName;
  String? amcLogo;
  String? schemeAmfiCode;
  String? schemeAmfi;
  String? schemeAmfiShortName;
  String? schemeCategory;

  MySipFundsPojo(
      {this.amcName,
      this.amcLogo,
      this.schemeAmfiCode,
      this.schemeAmfi,
      this.schemeAmfiShortName,
      this.schemeCategory});

  MySipFundsPojo.fromJson(Map<String, dynamic> json) {
    amcName = json['amc_name'];
    amcLogo = json['amc_logo'];
    schemeAmfiCode = json['scheme_amfi_code'];
    schemeAmfi = json['scheme_amfi'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeCategory = json['scheme_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amc_name'] = amcName;
    data['amc_logo'] = amcLogo;
    data['scheme_amfi_code'] = schemeAmfiCode;
    data['scheme_amfi'] = schemeAmfi;
    data['scheme_amfi_short_name'] = schemeAmfiShortName;
    data['scheme_category'] = schemeCategory;
    return data;
  }
}
