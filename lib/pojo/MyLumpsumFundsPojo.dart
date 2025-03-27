class MyLumpsumFundsPojo {
  int? id;
  String? amcCode;
  String? amcName;
  String? productCode;
  String? productName;
  String? category;
  String? schemeAmfiCode;
  String? schemeAmfi;
  String? schemeAmfiShortName;
  String? systematicFrequencies;
  String? sipDates;
  String? stpDates;
  String? swpDates;
  String? purchaseAllowed;
  String? switchAllowed;
  String? redemptionAllowed;
  String? sipAllowed;
  String? stpAllowed;
  String? swpAllowed;
  String? reinvestTag;
  String? productCategory;
  String? isin;
  String? lastModifiedDate;
  String? activeFlag;
  String? assetClass;
  String? subFundCode;
  String? planType;
  String? insuranceEnabled;
  String? rtaCode;
  String? nfoEnabled;
  String? nfoCloseDate;
  String? nfoSipEffectiveDate;
  String? allowFreedomSip;
  String? allowFreedomSwp;
  String? allowDonor;
  String? amcLogo;

  MyLumpsumFundsPojo(
      {this.id,
      this.amcCode,
      this.amcName,
      this.productCode,
      this.productName,
      this.category,
      this.schemeAmfiCode,
      this.schemeAmfi,
      this.schemeAmfiShortName,
      this.systematicFrequencies,
      this.sipDates,
      this.stpDates,
      this.swpDates,
      this.purchaseAllowed,
      this.switchAllowed,
      this.redemptionAllowed,
      this.sipAllowed,
      this.stpAllowed,
      this.swpAllowed,
      this.reinvestTag,
      this.productCategory,
      this.isin,
      this.lastModifiedDate,
      this.activeFlag,
      this.assetClass,
      this.subFundCode,
      this.planType,
      this.insuranceEnabled,
      this.rtaCode,
      this.nfoEnabled,
      this.nfoCloseDate,
      this.nfoSipEffectiveDate,
      this.allowFreedomSip,
      this.allowFreedomSwp,
      this.allowDonor,
      this.amcLogo});

  MyLumpsumFundsPojo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amcCode = json['amc_code'];
    amcName = json['amc_name'];
    productCode = json['product_code'];
    productName = json['product_name'];
    category = json['category'];
    schemeAmfiCode = json['scheme_amfi_code'];
    schemeAmfi = json['scheme_amfi'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    systematicFrequencies = json['systematic_frequencies'];
    sipDates = json['sip_dates'];
    stpDates = json['stp_dates'];
    swpDates = json['swp_dates'];
    purchaseAllowed = json['purchase_allowed'];
    switchAllowed = json['switch_allowed'];
    redemptionAllowed = json['redemption_allowed'];
    sipAllowed = json['sip_allowed'];
    stpAllowed = json['stp_allowed'];
    swpAllowed = json['swp_allowed'];
    reinvestTag = json['reinvest_tag'];
    productCategory = json['product_category'];
    isin = json['isin'];
    lastModifiedDate = json['last_modified_date'];
    activeFlag = json['active_flag'];
    assetClass = json['asset_class'];
    subFundCode = json['sub_fund_code'];
    planType = json['plan_type'];
    insuranceEnabled = json['insurance_enabled'];
    rtaCode = json['rta_code'];
    nfoEnabled = json['nfo_enabled'];
    nfoCloseDate = json['nfo_close_date'];
    nfoSipEffectiveDate = json['nfo_sip_effective_date'];
    allowFreedomSip = json['allow_freedom_sip'];
    allowFreedomSwp = json['allow_freedom_swp'];
    allowDonor = json['allow_donor'];
    amcLogo = json['amc_logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amc_code'] = amcCode;
    data['amc_name'] = amcName;
    data['product_code'] = productCode;
    data['product_name'] = productName;
    data['category'] = category;
    data['scheme_amfi_code'] = schemeAmfiCode;
    data['scheme_amfi'] = schemeAmfi;
    data['scheme_amfi_short_name'] = schemeAmfiShortName;
    data['systematic_frequencies'] = systematicFrequencies;
    data['sip_dates'] = sipDates;
    data['stp_dates'] = stpDates;
    data['swp_dates'] = swpDates;
    data['purchase_allowed'] = purchaseAllowed;
    data['switch_allowed'] = switchAllowed;
    data['redemption_allowed'] = redemptionAllowed;
    data['sip_allowed'] = sipAllowed;
    data['stp_allowed'] = stpAllowed;
    data['swp_allowed'] = swpAllowed;
    data['reinvest_tag'] = reinvestTag;
    data['product_category'] = productCategory;
    data['isin'] = isin;
    data['last_modified_date'] = lastModifiedDate;
    data['active_flag'] = activeFlag;
    data['asset_class'] = assetClass;
    data['sub_fund_code'] = subFundCode;
    data['plan_type'] = planType;
    data['insurance_enabled'] = insuranceEnabled;
    data['rta_code'] = rtaCode;
    data['nfo_enabled'] = nfoEnabled;
    data['nfo_close_date'] = nfoCloseDate;
    data['nfo_sip_effective_date'] = nfoSipEffectiveDate;
    data['allow_freedom_sip'] = allowFreedomSip;
    data['allow_freedom_swp'] = allowFreedomSwp;
    data['allow_donor'] = allowDonor;
    data['amc_logo'] = amcLogo;
    return data;
  }
}
