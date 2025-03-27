class GoalDetailsResponce {
  int? status;
  String? statusMsg;
  String? msg;
  int? pageid;
  int? pageCount;
  int? totalCount;
  bool? validScheme;
  List<Goal>? goalList;

  GoalDetailsResponce(
      {this.status,
        this.statusMsg,
        this.msg,
        this.pageid,
        this.pageCount,
        this.totalCount,
        this.validScheme,
        this.goalList});

  GoalDetailsResponce.fromJson(Map<String?, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    pageid = json['pageid'];
    pageCount = json['pageCount'];
    totalCount = json['totalCount'];
    validScheme = json['validScheme'];
    if (json['goal_list'] != null) {
      goalList = <Goal>[];
      json['goal_list'].forEach((v) {
        goalList?.add(new Goal.fromJson(v));
      });
    }
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['status'] = this.status;
    data['status_msg'] = this.statusMsg;
    data['msg'] = this.msg;
    data['pageid'] = this.pageid;
    data['pageCount'] = this.pageCount;
    data['totalCount'] = this.totalCount;
    data['validScheme'] = this.validScheme;
    if (this.goalList != null) {
      data['goal_list'] = this.goalList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Goal {
  int? id;
  String? userId;
  String? name;
  String? pan;
  String? email;
  String? goal;
  String? goalName;
  String? amount;
  String? horizon;
  String? inflation;
  String? risk;
  String? targetAmount;
  String? achievedAmount;
  String? sipAmount;
  String? lumpsumAmount;
  String? schemeArray;
  String? categoryArray;
  String? percentageArray;
  String? amountArray;
  String? existingFolio;
  String? existingScheme;
  String? existingSchemeCode;
  String? existingSchemeSip;
  String? existingSchemeCurrentValue;
  String? authCode;
  String? age;
  String? retireAge;
  String? lifeAge;
  String? type;
  String? onlineInvest;
  String? createdDate;
  String? clientName;
  String? achievedPercentage;

  Goal(
      {this.id,
        this.userId,
        this.name,
        this.pan,
        this.email,
        this.goal,
        this.goalName,
        this.amount,
        this.horizon,
        this.inflation,
        this.risk,
        this.targetAmount,
        this.achievedAmount,
        this.sipAmount,
        this.lumpsumAmount,
        this.schemeArray,
        this.categoryArray,
        this.percentageArray,
        this.amountArray,
        this.existingFolio,
        this.existingScheme,
        this.existingSchemeCode,
        this.existingSchemeSip,
        this.existingSchemeCurrentValue,
        this.authCode,
        this.age,
        this.retireAge,
        this.lifeAge,
        this.type,
        this.onlineInvest,
        this.createdDate,
        this.clientName,
        this.achievedPercentage});

  Goal.fromJson(Map<String?, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    pan = json['pan'];
    email = json['email'];
    goal = json['goal'];
    goalName = json['goal_name'];
    amount = json['amount'];
    horizon = json['horizon'];
    inflation = json['inflation'];
    risk = json['risk'];
    targetAmount = json['target_amount'];
    achievedAmount = json['achieved_amount'];
    sipAmount = json['sip_amount'];
    lumpsumAmount = json['lumpsum_amount'];
    schemeArray = json['scheme_array'];
    categoryArray = json['category_array'];
    percentageArray = json['percentage_array'];
    amountArray = json['amount_array'];
    existingFolio = json['existing_folio'];
    existingScheme = json['existing_scheme'];
    existingSchemeCode = json['existing_scheme_code'];
    existingSchemeSip = json['existing_scheme_sip'];
    existingSchemeCurrentValue = json['existing_scheme_current_value'];
    authCode = json['auth_code'];
    age = json['age'];
    retireAge = json['retire_age'];
    lifeAge = json['life_age'];
    type = json['type'];
    onlineInvest = json['online_invest'];
    createdDate = json['created_date'];
    clientName = json['client_name'];
    achievedPercentage = json['achieved_percentage'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['pan'] = this.pan;
    data['email'] = this.email;
    data['goal'] = this.goal;
    data['goal_name'] = this.goalName;
    data['amount'] = this.amount;
    data['horizon'] = this.horizon;
    data['inflation'] = this.inflation;
    data['risk'] = this.risk;
    data['target_amount'] = this.targetAmount;
    data['achieved_amount'] = this.achievedAmount;
    data['sip_amount'] = this.sipAmount;
    data['lumpsum_amount'] = this.lumpsumAmount;
    data['scheme_array'] = this.schemeArray;
    data['category_array'] = this.categoryArray;
    data['percentage_array'] = this.percentageArray;
    data['amount_array'] = this.amountArray;
    data['existing_folio'] = this.existingFolio;
    data['existing_scheme'] = this.existingScheme;
    data['existing_scheme_code'] = this.existingSchemeCode;
    data['existing_scheme_sip'] = this.existingSchemeSip;
    data['existing_scheme_current_value'] = this.existingSchemeCurrentValue;
    data['auth_code'] = this.authCode;
    data['age'] = this.age;
    data['retire_age'] = this.retireAge;
    data['life_age'] = this.lifeAge;
    data['type'] = this.type;
    data['online_invest'] = this.onlineInvest;
    data['created_date'] = this.createdDate;
    data['client_name'] = this.clientName;
    data['achieved_percentage'] = this.achievedPercentage;
    return data;
  }
}