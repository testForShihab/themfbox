class CategoryWiseAumPojo {
  String? categoryName;
  String? aumMonth;
  num? aumAmount;
  num? percent;
  String? broadCategory;

  CategoryWiseAumPojo(
      {this.categoryName,
      this.aumMonth,
      this.aumAmount,
      this.percent,
      this.broadCategory});

  CategoryWiseAumPojo.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    aumMonth = json['aum_month'];
    aumAmount = json['aum_amount'];
    percent = json['percent'];
    broadCategory = json['broadCategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_name'] = categoryName;
    data['aum_month'] = aumMonth;
    data['aum_amount'] = aumAmount;
    data['percent'] = percent;
    data['broadCategory'] = broadCategory;
    return data;
  }
}
