class AssociateWiseSipPojo {
  num? userId;
  String? name;
  String? rmName;
  String? branch;
  num? amount;
  num? sipCounts;
  num? currentCost;
  num? currentValue;
  num? absReturn;

  AssociateWiseSipPojo(
      {this.userId,
        this.name,
        this.rmName,
        this.branch,
        this.amount,
        this.sipCounts,
        this.currentCost,
        this.currentValue,
        this.absReturn});

  AssociateWiseSipPojo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
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
    data['name'] = this.name;
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