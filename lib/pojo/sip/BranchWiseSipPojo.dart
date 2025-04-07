class BranchWiseSipPojo {
  String? branch;
  num? amount;
  num? sipCounts;
  num? currentCost;
  num? currentValue;
  num? absReturn;

  BranchWiseSipPojo(
      {this.branch,
        this.amount,
        this.sipCounts,
        this.currentCost,
        this.currentValue,
        this.absReturn});

  BranchWiseSipPojo.fromJson(Map<String, dynamic> json) {
    branch = json['branch'];
    amount = json['amount'];
    sipCounts = json['sip_counts'];
    currentCost = json['current_cost'];
    currentValue = json['current_value'];
    absReturn = json['abs_return'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branch'] = this.branch;
    data['amount'] = this.amount;
    data['sip_counts'] = this.sipCounts;
    data['current_cost'] = this.currentCost;
    data['current_value'] = this.currentValue;
    data['abs_return'] = this.absReturn;
    return data;
  }
}