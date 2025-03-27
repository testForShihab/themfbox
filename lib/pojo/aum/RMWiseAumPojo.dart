class RmWiseAUMPojo {
  String? rmName;
  num? netBrokerage;
  String? branch;

  RmWiseAUMPojo({this.rmName, this.netBrokerage, this.branch});

  RmWiseAUMPojo.fromJson(Map<String, dynamic> json) {
    rmName = json['rm_name'];
    netBrokerage = json['net_brokerage'];
    branch = json['branch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rm_name'] = rmName;
    data['net_brokerage'] = netBrokerage;
    data['branch'] = branch;
    return data;
  }
}