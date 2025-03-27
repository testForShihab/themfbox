class RmWiseSipPojo {
  num? userId;
  String? rmName;
  String? branch;
  num? amount;
  num? sipCounts;
  num? currentCost;
  num? currentValue;
  num? absReturn;

  RmWiseSipPojo(
      {this.userId,
        this.rmName,
        this.branch,
        this.amount,
        this.sipCounts,
        this.currentCost,
        this.currentValue,
        this.absReturn});

  RmWiseSipPojo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    rmName = json['rm_name'];
    branch = json['branch'];
    amount = json['amount'];
    sipCounts = json['sip_counts'];
    currentCost = json['current_cost'];
    currentValue = json['current_value'];
    absReturn = json['abs_return'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['rm_name'] = this.rmName;
    data['branch'] = this.branch;
    data['amount'] = this.amount;
    data['sip_counts'] = this.sipCounts;
    data['current_cost'] = this.currentCost;
    data['current_value'] = this.currentValue;
    data['abs_return'] = this.absReturn;
    return data;
  }
}