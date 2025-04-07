class NseBankInfoPojo {
  String? bankName;
  String? bankCode;
  String? bankMode;
  String? bankBranch;
  String? bankAddress;
  String? bankAccountNumber;
  String? bankAccountHolderName;
  String? bankAccountType;
  String? bankIfscCode;
  String? bankMicrCode;
  String? defaultBank;
  String? xsipOtmFlag;
  String? xsipOtm;
  String? xsipOtmApproved;
  String? xsipOtmCreatedDate;
  String? emandateOtmFlag;
  String? emandateOtm;
  String? emandateOtmApproved;
  String? emandateOtmCreatedDate;
  int? nseAchFlag;
  String? nseAch;
  String? nseAchAmount;
  int? nseAchApproved;
  String? nseAchCreatedDate;

  NseBankInfoPojo(
      {this.bankName,
      this.bankCode,
      this.bankMode,
      this.bankBranch,
      this.bankAddress,
      this.bankAccountNumber,
      this.bankAccountHolderName,
      this.bankAccountType,
      this.bankIfscCode,
      this.bankMicrCode,
      this.defaultBank,
      this.xsipOtmFlag,
      this.xsipOtm,
      this.xsipOtmApproved,
      this.xsipOtmCreatedDate,
      this.emandateOtmFlag,
      this.emandateOtm,
      this.emandateOtmApproved,
      this.emandateOtmCreatedDate,
      this.nseAchFlag,
      this.nseAch,
      this.nseAchAmount,
      this.nseAchApproved,
      this.nseAchCreatedDate});

  NseBankInfoPojo.fromJson(Map<String, dynamic> json) {
    bankName = json['bank_name'];
    bankCode = json['bank_code'];
    bankMode = json['bank_mode'];
    bankBranch = json['bank_branch'];
    bankAddress = json['bank_address'];
    bankAccountNumber = json['bank_account_number'];
    bankAccountHolderName = json['bank_account_holder_name'];
    bankAccountType = json['bank_account_type'];
    bankIfscCode = json['bank_ifsc_code'];
    bankMicrCode = json['bank_micr_code'];
    defaultBank = json['default_bank'];
    xsipOtmFlag = json['xsip_otm_flag'];
    xsipOtm = json['xsip_otm'];
    xsipOtmApproved = json['xsip_otm_approved'];
    xsipOtmCreatedDate = json['xsip_otm_created_date'];
    emandateOtmFlag = json['emandate_otm_flag'];
    emandateOtm = json['emandate_otm'];
    emandateOtmApproved = json['emandate_otm_approved'];
    emandateOtmCreatedDate = json['emandate_otm_created_date'];
    nseAchFlag = json['nse_ach_flag'];
    nseAch = json['nse_ach'];
    nseAchAmount = json['nse_ach_amount'];
    nseAchApproved = json['nse_ach_approved'];
    nseAchCreatedDate = json['nse_ach_created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bank_name'] = this.bankName;
    data['bank_code'] = this.bankCode;
    data['bank_mode'] = this.bankMode;
    data['bank_branch'] = this.bankBranch;
    data['bank_address'] = this.bankAddress;
    data['bank_account_number'] = this.bankAccountNumber;
    data['bank_account_holder_name'] = this.bankAccountHolderName;
    data['bank_account_type'] = this.bankAccountType;
    data['bank_ifsc_code'] = this.bankIfscCode;
    data['bank_micr_code'] = this.bankMicrCode;
    data['default_bank'] = this.defaultBank;
    data['xsip_otm_flag'] = this.xsipOtmFlag;
    data['xsip_otm'] = this.xsipOtm;
    data['xsip_otm_approved'] = this.xsipOtmApproved;
    data['xsip_otm_created_date'] = this.xsipOtmCreatedDate;
    data['emandate_otm_flag'] = this.emandateOtmFlag;
    data['emandate_otm'] = this.emandateOtm;
    data['emandate_otm_approved'] = this.emandateOtmApproved;
    data['emandate_otm_created_date'] = this.emandateOtmCreatedDate;
    data['nse_ach_flag'] = this.nseAchFlag;
    data['nse_ach'] = this.nseAch;
    data['nse_ach_amount'] = this.nseAchAmount;
    data['nse_ach_approved'] = this.nseAchApproved;
    data['nse_ach_created_date'] = this.nseAchCreatedDate;
    return data;
  }
}
