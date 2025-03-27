class MFInvestPerformanceResponse {
  double? mfReturn;
  double? mfValue;
  double? benchmarkReturn;
  double? benchmarkValue;
  double? goldReturn;
  double? goldValue;
  double? fdReturn;
  double? fdValue;

  MFInvestPerformanceResponse(
      {this.mfReturn,
        this.mfValue,
        this.benchmarkReturn,
        this.benchmarkValue,
        this.goldReturn,
        this.goldValue,
        this.fdReturn,
        this.fdValue});

  MFInvestPerformanceResponse.fromJson(Map<String, dynamic> json) {
    mfReturn = json['mf_return'];
    mfValue = json['mf_value'];
    benchmarkReturn = json['benchmark_return'];
    benchmarkValue = json['benchmark_value'];
    goldReturn = json['gold_return'];
    goldValue = json['gold_value'];
    fdReturn = json['fd_return'];
    fdValue = json['fd_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mf_return'] = this.mfReturn;
    data['mf_value'] = this.mfValue;
    data['benchmark_return'] = this.benchmarkReturn;
    data['benchmark_value'] = this.benchmarkValue;
    data['gold_return'] = this.goldReturn;
    data['gold_value'] = this.goldValue;
    data['fd_return'] = this.fdReturn;
    data['fd_value'] = this.fdValue;
    return data;
  }
}