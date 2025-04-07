// ignore_for_file: unnecessary_this

class AmcPojo {
  int? id;
  int? mfCompanyId;
  String? mfCompanyName;
  String? amcCode;
  String? registrar;
  int? dividendFlag;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mf_company_id'] = mfCompanyId;
    data['mf_company_name'] = mfCompanyName;
    data['amc_code'] = amcCode;
    data['registrar'] = registrar;
    data['dividend_flag'] = dividendFlag;
    return data;
  }
}

class DetailsPojo {
  String? name;
  String? pan;
  String? riskProfile;
  String? investorPhoto;
  String? companyName;
  String? companyPhone;
  String? companyMail;
  String? companyAddress1;
  String? companyAddress2;
  String? brokerCode1;
  String? brokerCode2;
  String? brokerCode3;
  String? brokerCode4;
  String? brokerCode5;
  String? euin1;
  String? euin2;
  String? euin3;
  String? euin4;
  String? euin5;
  String? bseUserid;
  String? bseMemberid;
  String? bsePassword;
  String? bseUserid1;
  String? bseMemberid1;
  String? bsePassword1;
  String? bseUserid2;
  String? bseMemberid2;
  String? bsePassword2;
  String? nseApplnId;
  String? nsePassword;
  String? nseApplnId1;
  String? nsePassword1;
  String? nseApplnId2;
  String? nsePassword2;
  String? camsMailbackEmail;
  String? karvyMailbackEmail;
  String? karvyMemberId;
  String? karvyPassword;
  String? camsMailbackEmail1;
  String? karvyMailbackEmail1;
  String? karvyMemberId1;
  String? karvyPassword1;
  String? camsMailbackEmail2;
  String? karvyMailbackEmail2;
  String? karvyMemberId2;
  String? karvyPassword2;
  String? camsMailbackEmail3;
  String? karvyMailbackEmail3;
  String? karvyMemberId3;
  String? karvyPassword3;
  String? camsMailbackEmail4;
  String? karvyMailbackEmail4;
  String? karvyMemberId4;
  String? karvyPassword4;
  String? senderName;
  String? senderMail;
  String? fundUid1;
  String? fundPassword1;
  String? fundSecurityAns1;
  String? fundUid2;
  String? fundPassword2;
  String? fundSecurityAns2;
  String? fundUid3;
  String? fundPassword3;
  String? fundSecurityAns3;
  String? mfuUserid;
  String? mfuUserid1;
  String? mfuUserid2;
  String? mfuPassword;
  String? mfuPassword1;
  String? mfuPassword2;
  String? credentialFlag;
  String? arnFlag;
  String? fundType;
  String? riaCode;
  String? riaNseApplnId;
  String? riaNsePassword;
  String? amcNames;

  DetailsPojo(
      {this.name,
      this.pan,
      this.riskProfile,
      this.investorPhoto,
      this.companyName,
      this.companyPhone,
      this.companyMail,
      this.companyAddress1,
      this.companyAddress2,
      this.brokerCode1,
      this.brokerCode2,
      this.brokerCode3,
      this.brokerCode4,
      this.brokerCode5,
      this.euin1,
      this.euin2,
      this.euin3,
      this.euin4,
      this.euin5,
      this.bseUserid,
      this.bseMemberid,
      this.bsePassword,
      this.bseUserid1,
      this.bseMemberid1,
      this.bsePassword1,
      this.bseUserid2,
      this.bseMemberid2,
      this.bsePassword2,
      this.nseApplnId,
      this.nsePassword,
      this.nseApplnId1,
      this.nsePassword1,
      this.nseApplnId2,
      this.nsePassword2,
      this.camsMailbackEmail,
      this.karvyMailbackEmail,
      this.karvyMemberId,
      this.karvyPassword,
      this.camsMailbackEmail1,
      this.karvyMailbackEmail1,
      this.karvyMemberId1,
      this.karvyPassword1,
      this.camsMailbackEmail2,
      this.karvyMailbackEmail2,
      this.karvyMemberId2,
      this.karvyPassword2,
      this.camsMailbackEmail3,
      this.karvyMailbackEmail3,
      this.karvyMemberId3,
      this.karvyPassword3,
      this.camsMailbackEmail4,
      this.karvyMailbackEmail4,
      this.karvyMemberId4,
      this.karvyPassword4,
      this.senderName,
      this.senderMail,
      this.fundUid1,
      this.fundPassword1,
      this.fundSecurityAns1,
      this.fundUid2,
      this.fundPassword2,
      this.fundSecurityAns2,
      this.fundUid3,
      this.fundPassword3,
      this.fundSecurityAns3,
      this.mfuUserid,
      this.mfuUserid1,
      this.mfuUserid2,
      this.mfuPassword,
      this.mfuPassword1,
      this.mfuPassword2,
      this.credentialFlag,
      this.arnFlag,
      this.fundType,
      this.riaCode,
      this.riaNseApplnId,
      this.riaNsePassword,
      this.amcNames});

  DetailsPojo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    pan = json['pan'];
    riskProfile = json['risk_profile'];
    investorPhoto = json['investor_photo'];
    companyName = json['company_name'];
    companyPhone = json['company_phone'];
    companyMail = json['company_mail'];
    companyAddress1 = json['company_address1'];
    companyAddress2 = json['company_address2'];
    brokerCode1 = json['broker_code1'];
    brokerCode2 = json['broker_code2'];
    brokerCode3 = json['broker_code3'];
    brokerCode4 = json['broker_code4'];
    brokerCode5 = json['broker_code5'];
    euin1 = json['euin1'];
    euin2 = json['euin2'];
    euin3 = json['euin3'];
    euin4 = json['euin4'];
    euin5 = json['euin5'];
    bseUserid = json['bse_userid'];
    bseMemberid = json['bse_memberid'];
    bsePassword = json['bse_password'];
    bseUserid1 = json['bse_userid1'];
    bseMemberid1 = json['bse_memberid1'];
    bsePassword1 = json['bse_password1'];
    bseUserid2 = json['bse_userid2'];
    bseMemberid2 = json['bse_memberid2'];
    bsePassword2 = json['bse_password2'];
    nseApplnId = json['nse_appln_id'];
    nsePassword = json['nse_password'];
    nseApplnId1 = json['nse_appln_id1'];
    nsePassword1 = json['nse_password1'];
    nseApplnId2 = json['nse_appln_id2'];
    nsePassword2 = json['nse_password2'];
    camsMailbackEmail = json['cams_mailback_email'];
    karvyMailbackEmail = json['karvy_mailback_email'];
    karvyMemberId = json['karvy_member_id'];
    karvyPassword = json['karvy_password'];
    camsMailbackEmail1 = json['cams_mailback_email1'];
    karvyMailbackEmail1 = json['karvy_mailback_email1'];
    karvyMemberId1 = json['karvy_member_id1'];
    karvyPassword1 = json['karvy_password1'];
    camsMailbackEmail2 = json['cams_mailback_email2'];
    karvyMailbackEmail2 = json['karvy_mailback_email2'];
    karvyMemberId2 = json['karvy_member_id2'];
    karvyPassword2 = json['karvy_password2'];
    camsMailbackEmail3 = json['cams_mailback_email3'];
    karvyMailbackEmail3 = json['karvy_mailback_email3'];
    karvyMemberId3 = json['karvy_member_id3'];
    karvyPassword3 = json['karvy_password3'];
    camsMailbackEmail4 = json['cams_mailback_email4'];
    karvyMailbackEmail4 = json['karvy_mailback_email4'];
    karvyMemberId4 = json['karvy_member_id4'];
    karvyPassword4 = json['karvy_password4'];
    senderName = json['sender_name'];
    senderMail = json['sender_mail'];
    fundUid1 = json['fund_uid1'];
    fundPassword1 = json['fund_password1'];
    fundSecurityAns1 = json['fund_security_ans1'];
    fundUid2 = json['fund_uid2'];
    fundPassword2 = json['fund_password2'];
    fundSecurityAns2 = json['fund_security_ans2'];
    fundUid3 = json['fund_uid3'];
    fundPassword3 = json['fund_password3'];
    fundSecurityAns3 = json['fund_security_ans3'];
    mfuUserid = json['mfu_userid'];
    mfuUserid1 = json['mfu_userid1'];
    mfuUserid2 = json['mfu_userid2'];
    mfuPassword = json['mfu_password'];
    mfuPassword1 = json['mfu_password1'];
    mfuPassword2 = json['mfu_password2'];
    credentialFlag = json['credential_flag'];
    arnFlag = json['arn_flag'];
    fundType = json['fund_type'];
    riaCode = json['ria_code'];
    riaNseApplnId = json['ria_nse_appln_id'];
    riaNsePassword = json['ria_nse_password'];
    amcNames = json['amc_names'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pan': pan,
      'risk_profile': riskProfile,
      'investor_photo': investorPhoto,
      'company_name': companyName,
      'company_phone': companyPhone,
      'company_mail': companyMail,
      'company_address1': companyAddress1,
      'company_address2': companyAddress2,
      'broker_code1': brokerCode1,
      'broker_code2': brokerCode2,
      'broker_code3': brokerCode3,
      'broker_code4': brokerCode4,
      'broker_code5': brokerCode5,
      'euin1': euin1,
      'euin2': euin2,
      'euin3': euin3,
      'euin4': euin4,
      'euin5': euin5,
      'bse_userid': bseUserid,
      'bse_memberid': bseMemberid,
      'bse_password': bsePassword,
      'bse_userid1': bseUserid1,
      'bse_memberid1': bseMemberid1,
      'bse_password1': bsePassword1,
      'bse_userid2': bseUserid2,
      'bse_memberid2': bseMemberid2,
      'bse_password2': bsePassword2,
      'nse_appln_id': nseApplnId,
      'nse_password': nsePassword,
      'nse_appln_id1': nseApplnId1,
      'nse_password1': nsePassword1,
      'nse_appln_id2': nseApplnId2,
      'nse_password2': nsePassword2,
      'cams_mailback_email': camsMailbackEmail,
      'karvy_mailback_email': karvyMailbackEmail,
      'karvy_member_id': karvyMemberId,
      'karvy_password': karvyPassword,
      'cams_mailback_email1': camsMailbackEmail1,
      'karvy_mailback_email1': karvyMailbackEmail1,
      'karvy_member_id1': karvyMemberId1,
      'karvy_password1': karvyPassword1,
      'cams_mailback_email2': camsMailbackEmail2,
      'karvy_mailback_email2': karvyMailbackEmail2,
      'karvy_member_id2': karvyMemberId2,
      'karvy_password2': karvyPassword2,
      'cams_mailback_email3': camsMailbackEmail3,
      'karvy_mailback_email3': karvyMailbackEmail3,
      'karvy_member_id3': karvyMemberId3,
      'karvy_password3': karvyPassword3,
      'cams_mailback_email4': camsMailbackEmail4,
      'karvy_mailback_email4': karvyMailbackEmail4,
      'karvy_member_id4': karvyMemberId4,
      'karvy_password4': karvyPassword4,
      'sender_name': senderName,
      'sender_mail': senderMail,
      'fund_uid1': fundUid1,
      'fund_password1': fundPassword1,
      'fund_security_ans1': fundSecurityAns1,
      'fund_uid2': fundUid2,
      'fund_password2': fundPassword2,
      'fund_security_ans2': fundSecurityAns2,
      'fund_uid3': fundUid3,
      'fund_password3': fundPassword3,
      'fund_security_ans3': fundSecurityAns3,
      'mfu_userid': mfuUserid,
      'mfu_userid1': mfuUserid1,
      'mfu_userid2': mfuUserid2,
      'mfu_password': mfuPassword,
      'mfu_password1': mfuPassword1,
      'mfu_password2': mfuPassword2,
      'credential_flag': credentialFlag,
      'arn_flag': arnFlag,
      'fund_type': fundType,
      'ria_code': riaCode,
      'ria_nse_appln_id': riaNseApplnId,
      'ria_nse_password': riaNsePassword,
      'amc_names': amcNames,
    };
  }
}

class AmcEmpanalledPojo {
  int? status;
  String? statusMsg;
  String? msg;
  List<AmcNames>? amcNames;

  AmcEmpanalledPojo({this.status, this.statusMsg, this.msg, this.amcNames});

  AmcEmpanalledPojo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    if (json['amc_names'] != null) {
      amcNames = <AmcNames>[];
      json['amc_names'].forEach((v) {
        amcNames!.add(new AmcNames.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_msg'] = this.statusMsg;
    data['msg'] = this.msg;
    if (this.amcNames != null) {
      data['amc_names'] = this.amcNames!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AmcNames {
  int? id;
  int? mfCompanyId;
  String? mfCompanyName;
  String? amcCode;
  String? registrar;
  int? dividendFlag;

  AmcNames(
      {this.id,
        this.mfCompanyId,
        this.mfCompanyName,
        this.amcCode,
        this.registrar,
        this.dividendFlag});

  AmcNames.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mfCompanyId = json['mf_company_id'];
    mfCompanyName = json['mf_company_name'];
    amcCode = json['amc_code'];
    registrar = json['registrar'];
    dividendFlag = json['dividend_flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mf_company_id'] = this.mfCompanyId;
    data['mf_company_name'] = this.mfCompanyName;
    data['amc_code'] = this.amcCode;
    data['registrar'] = this.registrar;
    data['dividend_flag'] = this.dividendFlag;
    return data;
  }
}
