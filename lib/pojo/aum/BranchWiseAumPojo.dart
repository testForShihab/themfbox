class BranchWiseAumPojo {
  String? branch;
  double? netBrokerage;

  BranchWiseAumPojo({this.branch, this.netBrokerage});

  BranchWiseAumPojo.fromJson(Map<String, dynamic> json) {
    branch = json['branch'];
    netBrokerage = json['net_brokerage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['branch'] = branch;
    data['net_brokerage'] = netBrokerage;
    return data;
  }
}