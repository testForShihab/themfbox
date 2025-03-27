class FamilyDataPojo {
  int? id;
  num? typeId;
  String? salutation;
  String? name;
  String? pan;
  String? email;
  String? mobile;
  String? branch;
  String? rmName;
  String? subBrokerName;
  String? aadhaar;
  String? dob;
  String? password;
  String? city;
  String? clientName;
  num? bseCustomer;
  num? nseCoustomer;
  String? nseIinNumber;
  String? bseClientCode;
  String? loginid;
  num? hniClients;
  num? hufClients;
  num? currentValue;
  num? investedAmount;
  num? unrealisedProfit;
  num? realisedProfit;
  num? cagr;
  int? familyMemberCount;
  String? relation;
  String? createdOn;
  num? dayChangeValue;
  num? dayChangePercentage;
  num? currentCost;
  num? unRealisedGain;
  num? familyMfHoldings;
  num? portfolioReturn;
  String? address;

  FamilyDataPojo({
    this.id,
    this.typeId,
    this.salutation,
    this.name,
    this.pan,
    this.email,
    this.mobile,
    this.branch,
    this.rmName,
    this.subBrokerName,
    this.aadhaar,
    this.dob,
    this.password,
    this.city,
    this.clientName,
    this.bseCustomer,
    this.nseCoustomer,
    this.nseIinNumber,
    this.bseClientCode,
    this.loginid,
    this.hniClients,
    this.hufClients,
    this.currentValue,
    this.investedAmount,
    this.unrealisedProfit,
    this.realisedProfit,
    this.cagr,
    this.familyMemberCount,
    this.relation,
    this.createdOn,
    this.dayChangeValue,
    this.dayChangePercentage,
    this.currentCost,
    this.unRealisedGain,
    this.familyMfHoldings,
    this.portfolioReturn,
    this.address,
  });

  FamilyDataPojo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeId = json['type_id'];
    salutation = json['salutation'];
    name = json['name'];
    pan = json['pan'];
    email = json['email'];
    mobile = json['mobile'];
    branch = json['branch'];
    rmName = json['rm_name'];
    subBrokerName = json['sub_broker_name'];
    aadhaar = json['aadhaar'];
    dob = json['dob'];
    password = json['password'];
    city = json['city'];
    clientName = json['client_name'];
    bseCustomer = json['bse_customer'];
    nseCoustomer = json['nse_coustomer'];
    nseIinNumber = json['nse_iin_number'];
    bseClientCode = json['bse_client_code'];
    loginid = json['loginid'];
    hniClients = json['hni_clients'];
    hufClients = json['huf_clients'];
    currentValue = json['curr_value'] ?? json['current_value'];
    investedAmount = json['invested_amount'];
    unrealisedProfit = json['unrealised_profit'];
    realisedProfit = json['realised_profit'];
    cagr = json['cagr'];
    familyMemberCount = json['family_member_count'];
    relation = json['relation'];
    createdOn = json['created_on'];
    dayChangeValue = json['day_change_value'];
    dayChangePercentage = json['day_change_percentage'];
    currentCost = json['curr_cost'];
    unRealisedGain = json['unrealised_gain'];
    familyMfHoldings = json['family_mf_holdings'];
    portfolioReturn = json['portfolio_return'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type_id'] = typeId;
    data['salutation'] = salutation;
    data['name'] = name;
    data['pan'] = pan;
    data['email'] = email;
    data['mobile'] = mobile;
    data['branch'] = branch;
    data['rm_name'] = rmName;
    data['sub_broker_name'] = subBrokerName;
    data['aadhaar'] = aadhaar;
    data['dob'] = dob;
    data['password'] = password;
    data['city'] = city;
    data['client_name'] = clientName;
    data['bse_customer'] = bseCustomer;
    data['nse_coustomer'] = nseCoustomer;
    data['nse_iin_number'] = nseIinNumber;
    data['bse_client_code'] = bseClientCode;
    data['loginid'] = loginid;
    data['hni_clients'] = hniClients;
    data['huf_clients'] = hufClients;
    data['curr_value'] = currentValue;
    data['invested_amount'] = investedAmount;
    data['unrealised_profit'] = unrealisedProfit;
    data['realised_profit'] = realisedProfit;
    data['cagr'] = cagr;
    data['family_member_count'] = familyMemberCount;
    data['relation'] = relation;
    data['created_on'] = createdOn;
    data['day_change_value'] = dayChangeValue;
    data['day_change_percentage'] = dayChangePercentage;
    data['curr_cost'] = currentCost;
    data['unrealised_gain'] = unRealisedGain;
    data['family_mf_holdings'] = familyMfHoldings;
    data['portfolio_return'] = portfolioReturn;
    data['address'] = address;
    return data;
  }
}
