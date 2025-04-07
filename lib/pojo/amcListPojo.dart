class AmcList {
  String? amcName;
  num? value;
  num? percent;
  String? logo;

  AmcList({this.amcName, this.value, this.percent, this.logo});

  AmcList.fromJson(Map<String, dynamic> json) {
    amcName = json['amc_name'];
    value = json['value'];
    percent = json['percent'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amc_name'] = this.amcName;
    data['value'] = this.value;
    data['percent'] = this.percent;
    data['logo'] = this.logo;
    return data;
  }
}