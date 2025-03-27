class AumSummaryResponse {
  int status;
  String statusMsg;
  String msg;
  String aumMonth;
  int aumTotal;
  int aumChangeValue;
  double aumChangePercentage;
  int aumInvestedAmount;

  AumSummaryResponse({
    required this.status,
    required this.statusMsg,
    required this.msg,
    required this.aumMonth,
    required this.aumTotal,
    required this.aumChangeValue,
    required this.aumChangePercentage,
    required this.aumInvestedAmount,
  });

}