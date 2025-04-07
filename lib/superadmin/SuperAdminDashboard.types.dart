class AdvisorPojo {
  String? companyName;
  String? clientName;
  String? themfboxUrl;
  String? logo;
  String? appType;
  String? androidLink;
  String? iosLink;
  String? supportMobile;
  String? supportEmail;
  int? loginUserId;
  String? loginMobile;
  String? loginPan;
  String? password;
  String? brokerCode;
  int? investorCount;
  double? totalAum;
  String? rmName;
  String? apiKey;
  bool? brokerageFlag;
  bool? mfresearchFlag;
  bool? calculatorFlag;
  bool? goalsFlag;
  bool? riskProfileFlag;
  AdminPojo? adminUsers;
  List<AdminPojo>? branchUsers;
  List<AdminPojo>? rmUsers;
  List<AdminPojo>? subbrokerUsers;

  AdvisorPojo({
    this.companyName,
    this.clientName,
    this.themfboxUrl,
    this.logo,
    this.appType,
    this.androidLink,
    this.iosLink,
    this.supportMobile,
    this.supportEmail,
    this.loginUserId,
    this.loginMobile,
    this.loginPan,
    this.password,
    this.brokerCode,
    this.investorCount,
    this.totalAum,
    this.rmName,
    this.apiKey,
    this.brokerageFlag,
    this.mfresearchFlag,
    this.calculatorFlag,
    this.goalsFlag,
    this.riskProfileFlag,
    this.adminUsers,
    this.branchUsers,
    this.rmUsers,
    this.subbrokerUsers,
  });

  AdvisorPojo.fromJson(Map<String, dynamic> json) {
    companyName = json['company_name'];
    clientName = json['client_name'];
    themfboxUrl = json['themfbox_url'];
    logo = json['logo'];
    appType = json['app_type'];
    androidLink = json['android_link'];
    iosLink = json['ios_link'];
    supportMobile = json['support_mobile'];
    supportEmail = json['support_email'];
    loginUserId = json['login_user_id'];
    loginMobile = json['login_mobile'];
    loginPan = json['login_pan'];
    password = json['password'];
    brokerCode = json['broker_code'];
    investorCount = json['investor_count'];
    totalAum = json['total_aum'];
    rmName = json['rm_name'];
    apiKey = json['api_key'];
    brokerageFlag = json['brokerage_flag'];
    mfresearchFlag = json['mfresearch_flag'];
    calculatorFlag = json['calculator_flag'];
    goalsFlag = json['goals_flag'];
    riskProfileFlag = json['risk_profile_flag'];
    adminUsers = json['admin_user'] != null
        ? AdminPojo.fromJson(json['admin_user'])
        : null;
    branchUsers = json['branch_users'] != null
        ? (json['branch_users'] as List)
            .map((i) => AdminPojo.fromJson(i))
            .toList()
        : null;
    rmUsers = json['rm_users'] != null
        ? (json['rm_users'] as List).map((i) => AdminPojo.fromJson(i)).toList()
        : null;
    subbrokerUsers = json['subbroker_users'] != null
        ? (json['subbroker_users'] as List)
            .map((i) => AdminPojo.fromJson(i))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_name'] = companyName;
    data['client_name'] = clientName;
    data['themfbox_url'] = themfboxUrl;
    data['logo'] = logo;
    data['app_type'] = appType;
    data['android_link'] = androidLink;
    data['ios_link'] = iosLink;
    data['support_mobile'] = supportMobile;
    data['support_email'] = supportEmail;
    data['login_user_id'] = loginUserId;
    data['login_mobile'] = loginMobile;
    data['login_pan'] = loginPan;
    data['password'] = password;
    data['broker_code'] = brokerCode;
    data['investor_count'] = investorCount;
    data['total_aum'] = totalAum;
    data['rm_name'] = rmName;
    data['api_key'] = apiKey;
    data['brokerage_flag'] = brokerageFlag;
    data['mfresearch_flag'] = mfresearchFlag;
    data['calculator_flag'] = calculatorFlag;
    data['goals_flag'] = goalsFlag;
    data['risk_profile_flag'] = riskProfileFlag;
    if (adminUsers != null) {
      data['admin_user'] = adminUsers!.toJson();
    }
    if (branchUsers != null) {
      data['branch_users'] = branchUsers!.map((e) => e.toJson()).toList();
    }
    if (rmUsers != null) {
      data['rm_users'] = rmUsers!.map((e) => e.toJson()).toList();
    }
    if (subbrokerUsers != null) {
      data['subbroker_users'] = subbrokerUsers!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class AdminPojo {
  int? typeId;
  int? userId;
  String? name;
  String? pan;
  String? mobile;
  String? password;
  String? clientName;

  AdminPojo(
      {this.typeId,
      this.userId,
      this.name,
      this.pan,
      this.mobile,
      this.password,
      this.clientName});

  AdminPojo.fromJson(Map<String, dynamic> json) {
    typeId = json['type_id'];
    userId = json['user_id'];
    name = json['name'];
    pan = json['pan'];
    mobile = json['mobile'];
    password = json['password'];
    clientName = json['client_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type_id'] = typeId;
    data['user_id'] = userId;
    data['name'] = name;
    data['pan'] = pan;
    data['mobile'] = mobile;
    data['password'] = password;
    data['client_name'] = clientName;
    return data;
  }
}
