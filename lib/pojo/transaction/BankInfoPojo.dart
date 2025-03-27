class BankInfoPojo {
  String? bankName;
  String? bankCode;
  String? bankMode;
  String? bankBranch;
  String? bankAccountNumber;
  String? bankAccountHolderName;
  String? bankAccountType;
  String? bankIfscCode;
  String? bankMicrCode;
  num? xsipOtmFlag;
  String? xsipOtm;
  num? xsipOtmApproved;
  num? emandateOtmFlag;
  String? emandateOtm;
  num? emandateOtmApproved;
  num? nseAchFlag;
  String? nseAch;
  num? nseAchApproved;
  num? mfuMandateFlag;
  String? mfuMandate;
  num? mfuMandateApproved;

  BankInfoPojo(
      {this.bankName,
      this.bankCode,
      this.bankMode,
      this.bankBranch,
      this.bankAccountNumber,
      this.bankAccountHolderName,
      this.bankAccountType,
      this.bankIfscCode,
      this.bankMicrCode,
      this.xsipOtmFlag,
      this.xsipOtm,
      this.xsipOtmApproved,
      this.emandateOtmFlag,
      this.emandateOtm,
      this.emandateOtmApproved,
      this.nseAchFlag,
      this.nseAch,
      this.nseAchApproved,
      this.mfuMandateFlag,
      this.mfuMandate,
      this.mfuMandateApproved});

  BankInfoPojo.fromJson(Map<String, dynamic> json) {
    bankName = json['bank_name'];
    bankCode = json['bank_code'];
    bankMode = json['bank_mode'];
    bankBranch = json['bank_branch'];
    bankAccountNumber = json['bank_account_number'];
    bankAccountHolderName = json['bank_account_holder_name'];
    bankAccountType = json['bank_account_type'];
    bankIfscCode = json['bank_ifsc_code'];
    bankMicrCode = json['bank_micr_code'];
    xsipOtmFlag = json['xsip_otm_flag'];
    xsipOtm = json['xsip_otm'];
    xsipOtmApproved = json['xsip_otm_approved'];
    emandateOtmFlag = json['emandate_otm_flag'];
    emandateOtm = json['emandate_otm'];
    emandateOtmApproved = json['emandate_otm_approved'];
    nseAchFlag = json['nse_ach_flag'];
    nseAch = json['nse_ach'];
    nseAchApproved = json['nse_ach_approved'];
    mfuMandateFlag = json['mfu_mandate_flag'];
    mfuMandate = json['mfu_mandate'];
    mfuMandateApproved = json['mfu_mandate_approved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bank_name'] = bankName;
    data['bank_code'] = bankCode;
    data['bank_mode'] = bankMode;
    data['bank_branch'] = bankBranch;
    data['bank_account_number'] = bankAccountNumber;
    data['bank_account_holder_name'] = bankAccountHolderName;
    data['bank_account_type'] = bankAccountType;
    data['bank_ifsc_code'] = bankIfscCode;
    data['bank_micr_code'] = bankMicrCode;
    data['xsip_otm_flag'] = xsipOtmFlag;
    data['xsip_otm'] = xsipOtm;
    data['xsip_otm_approved'] = xsipOtmApproved;
    data['emandate_otm_flag'] = emandateOtmFlag;
    data['emandate_otm'] = emandateOtm;
    data['emandate_otm_approved'] = emandateOtmApproved;
    data['nse_ach_flag'] = nseAchFlag;
    data['nse_ach'] = nseAch;
    data['nse_ach_approved'] = nseAchApproved;
    data['mfu_mandate_flag'] = mfuMandateFlag;
    data['mfu_mandate'] = mfuMandate;
    data['mfu_mandate_approved'] = mfuMandateApproved;
    return data;
  }
}
