class ActiveStpPojo {
  ActiveStpPojo(
      {required this.userId,
      required this.userName,
      required this.pan,
      required this.folioNo,
      required this.scheme,
      required this.rmName,
      required this.branch,
      required this.subbrokerName,
      required this.regDate,
      required this.fromDate,
      required this.toDate,
      required this.periodDay,
      required this.frequency,
      required this.amount,
      required this.prodcode,
      required this.toSchemeName,
      required this.periodDayWithFrequency,
      });

  String? userId;
  String? userName;
  String? pan;
  String? folioNo;
  String? scheme;
  String? rmName;
  String? branch;
  String? subbrokerName;
  String? regDate;
  String? fromDate;
  String? toDate;
  String? periodDay;
  String? frequency;
  num? amount;
  String? prodcode;
  String? toSchemeName;
  String? schemeLogo;
  String? periodDayWithFrequency;

  ActiveStpPojo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    pan = json['pan'];
    folioNo = json['folio_no'];
    scheme = json['scheme'];
    rmName = json['rm_name'];
    branch = json['branch'];
    subbrokerName = json['subbroker_name'];
    regDate = json['reg_date'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    periodDay = json['period_day'];
    frequency = json['frequency'];
    amount = json['amount'];
    prodcode = json['prodcode'];
    toSchemeName = json['to_scheme_name'];
    schemeLogo = json['scheme_logo'];
    periodDayWithFrequency = json['period_day_with_frequency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['pan'] = pan;
    data['folio_no'] = folioNo;
    data['scheme'] = scheme;
    data['rmName'] = rmName;
    data['branch'] = branch;
    data['subbrokerName'] = subbrokerName;
    data['reg_date'] = regDate;
    data['from_date'] = fromDate;
    data['to_date'] = toDate;
    data['period_day'] = periodDay;
    data['frequency'] = frequency;
    data['amount'] = amount;
    data['prodcode'] = prodcode;
    data['to_scheme_name'] = toSchemeName;
    data['scheme_logo'] = schemeLogo;
    data['period_day_with_frequency'] = this.periodDayWithFrequency;
    return data;
  }
}
