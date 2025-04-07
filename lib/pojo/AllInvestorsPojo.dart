class AllInvestorsPojo {
  int? id;
  String? name;
  String? pan;
  String? mobile;
  String? email;
  int? typeId;
  String? rmName;
  String? subbrokerName;
  String? dob;
  String? bseCode;
  String? nseCode;
  String? password;
  String? registerSource;
  String? createdDate;
  String? salutation;
  String? bseNseCode;
  num? aum;
  String? branch;
  String? address;
  String? bseClientCode;
  String? bseCustomer;
  String? bseActive;
  String? nseCustomer;
  String? nseActive;
  String? nseIinNumber;
  String? mfuCustomer;
  String? mfuActive;
  String? mfuCanNumber;
  String? bseNseMfu;

  AllInvestorsPojo(
      {this.id,
      this.name,
      this.pan,
      this.mobile,
      this.email,
      this.typeId,
      this.rmName,
      this.subbrokerName,
      this.dob,
      this.bseCode,
      this.nseCode,
      this.password,
      this.registerSource,
      this.createdDate,
      this.salutation,
      this.bseNseCode,
      this.aum,
      this.branch,
      this.address,
      this.bseClientCode,
      this.bseCustomer,
      this.bseActive,
      this.nseCustomer,
      this.nseActive,
      this.nseIinNumber,
      this.mfuCustomer,
      this.mfuActive,
      this.mfuCanNumber,
      this.bseNseMfu});

  AllInvestorsPojo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pan = json['pan'];
    mobile = json['mobile'];
    email = json['email'];
    typeId = json['type_id'];
    rmName = json['rm_name'];
    subbrokerName = json['subbroker_name'];
    dob = json['dob'];
    bseCode = json['bse_code'];
    nseCode = json['nse_code'];
    password = json['password'];
    registerSource = json['register_source'];
    createdDate = json['created_date'];
    salutation = json['salutation'];
    bseNseCode = json['bse_nse_code'];
    aum = json['aum'];
    branch = json['branch'];
    address = json['address'];
    bseClientCode = json['bse_client_code'];
    bseCustomer = json['bse_customer'];
    bseActive = json['bse_active'];
    nseCustomer = json['nse_customer'];
    nseActive = json['nse_active'];
    nseIinNumber = json['nse_iin_number'];
    mfuCustomer = json['mfu_customer'];
    mfuActive = json['mfu_active'];
    mfuCanNumber = json['mfu_can_number'];
    bseNseMfu = json['bse_nse_mfu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pan'] = pan;
    data['mobile'] = mobile;
    data['email'] = email;
    data['type_id'] = typeId;
    data['rm_name'] = rmName;
    data['subbroker_name'] = subbrokerName;
    data['dob'] = dob;
    data['bse_code'] = bseCode;
    data['nse_code'] = nseCode;
    data['password'] = password;
    data['register_source'] = registerSource;
    data['created_date'] = createdDate;
    data['salutation'] = salutation;
    data['bse_nse_code'] = bseNseCode;
    data['aum'] = aum;
    data['branch'] = branch;
    data['address'] = address;
    data['bse_client_code'] = bseClientCode;
    data['bse_customer'] = bseCustomer;
    data['bse_active'] = bseActive;
    data['nse_customer'] = nseCustomer;
    data['nse_active'] = nseActive;
    data['nse_iin_number'] = nseIinNumber;
    data['mfu_customer'] = mfuCustomer;
    data['mfu_active'] = mfuActive;
    data['mfu_can_number'] = mfuCanNumber;
    data['bse_nse_mfu'] = bseNseMfu;
    return data;
  }
}
