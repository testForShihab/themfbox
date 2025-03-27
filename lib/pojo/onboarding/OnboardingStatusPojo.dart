class OnboardingStatusPojo {
  int? status;
  String? statusMsg;
  String? msg;
  Result? result;

  OnboardingStatusPojo({this.status, this.statusMsg, this.msg, this.result});

  OnboardingStatusPojo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status_msg'] = statusMsg;
    data['msg'] = msg;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  int? userId;
  String? clientName;
  String? vendor;
  String? title;
  String? logo;
  String? taxStatus;
  String? holdingNature;
  bool? investorInfo;
  bool? personalInfo;
  bool? contactInfo;
  bool? nriInfo;
  bool? jointHolderInfo;
  bool? nomieeInfo;
  bool? bankInfo;
  bool? signatureInfo;
  bool? hasNominee;
  bool? hasNri;
  bool? hasJointHolder;
  bool? isAllStepsCompleted;
  bool? isAllRegistrationCompleted;
  List<MenuList>? menuList;

  Result(
      {this.userId,
      this.clientName,
      this.vendor,
      this.title,
      this.logo,
      this.taxStatus,
      this.holdingNature,
      this.investorInfo,
      this.personalInfo,
      this.contactInfo,
      this.nriInfo,
      this.jointHolderInfo,
      this.nomieeInfo,
      this.bankInfo,
      this.signatureInfo,
      this.hasNominee,
      this.hasNri,
      this.hasJointHolder,
      this.isAllStepsCompleted,
      this.isAllRegistrationCompleted,
      this.menuList});

  Result.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    clientName = json['client_name'];
    vendor = json['vendor'];
    title = json['title'];
    logo = json['logo'];
    taxStatus = json['tax_status'];
    holdingNature = json['holding_nature'];
    investorInfo = json['investor_info'];
    personalInfo = json['personal_info'];
    contactInfo = json['contact_info'];
    nriInfo = json['nri_info'];
    jointHolderInfo = json['joint_holder_info'];
    nomieeInfo = json['nomiee_info'];
    bankInfo = json['bank_info'];
    signatureInfo = json['signature_info'];
    hasNominee = json['has_nominee'];
    hasNri = json['has_nri'];
    hasJointHolder = json['has_joint_holder'];
    isAllStepsCompleted = json['is_all_steps_completed'];
    isAllRegistrationCompleted = json['is_all_registration_completed'];
    if (json['menu_list'] != null) {
      menuList = <MenuList>[];
      json['menu_list'].forEach((v) {
        menuList!.add(MenuList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['client_name'] = clientName;
    data['vendor'] = vendor;
    data['title'] = title;
    data['logo'] = logo;
    data['tax_status'] = taxStatus;
    data['holding_nature'] = holdingNature;
    data['investor_info'] = investorInfo;
    data['personal_info'] = personalInfo;
    data['contact_info'] = contactInfo;
    data['nri_info'] = nriInfo;
    data['joint_holder_info'] = jointHolderInfo;
    data['nomiee_info'] = nomieeInfo;
    data['bank_info'] = bankInfo;
    data['signature_info'] = signatureInfo;
    data['has_nominee'] = hasNominee;
    data['has_nri'] = hasNri;
    data['has_joint_holder'] = hasJointHolder;
    data['is_all_steps_completed'] = isAllStepsCompleted;
    data['is_all_registration_completed'] = isAllRegistrationCompleted;
    if (menuList != null) {
      data['menu_list'] = menuList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuList {
  String? bseNseMfu;
  String? logo;
  String? taxStatus;
  String? taxStatusCode;
  String? title;
  bool? isCompleted;
  bool? enabled;
  bool? completed;
  bool? checkRequiredOrNot;

  MenuList(
      {this.bseNseMfu,
      this.logo,
      this.taxStatus,
      this.taxStatusCode,
      this.title,
      this.isCompleted,
      this.enabled,
      this.completed,
      this.checkRequiredOrNot});

  MenuList.fromJson(Map<String, dynamic> json) {
    bseNseMfu = json['bse_nse_mfu'];
    logo = json['logo'];
    taxStatus = json['tax_status'];
    taxStatusCode = json['tax_status_code'];
    title = json['title'];
    isCompleted = json['isCompleted'];
    enabled = json['enabled'];
    completed = json['completed'];
    checkRequiredOrNot = json['checkRequiredOrNot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bse_nse_mfu'] = bseNseMfu;
    data['logo'] = logo;
    data['tax_status'] = taxStatus;
    data['tax_status_code'] = taxStatusCode;
    data['title'] = title;
    data['isCompleted'] = isCompleted;
    data['enabled'] = enabled;
    data['completed'] = completed;
    data['checkRequiredOrNot'] = checkRequiredOrNot;
    return data;
  }
}
