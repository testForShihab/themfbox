class AssociateWiseAUMPojo {
  String? subbrokerName;
  double? netBrokerage;
  String? branch;
  String? rmName;

  AssociateWiseAUMPojo({this.subbrokerName, this.netBrokerage, this.branch, this.rmName});

  AssociateWiseAUMPojo.fromJson(Map<String, dynamic> json) {
    subbrokerName = json['subbroker_name'];
    netBrokerage = json['net_brokerage'];
    branch = json['branch'];
    rmName = json['rm_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subbroker_name'] = this.subbrokerName;
    data['net_brokerage'] = this.netBrokerage;
    data['branch'] = this.branch;
    data['rm_name'] = this.rmName;
    return data;
  }
}