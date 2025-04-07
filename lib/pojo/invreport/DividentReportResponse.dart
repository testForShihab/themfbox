class DividendReportResponse {
  num? status;
  String? statusMsg;
  String? msg;
  num? portfolioDividendPaid;
  num? portfolioDividendReinv;
  num? portfolioDividend;
  List<SchemeWisePortfolioResponses>? schemeWisePortfolioResponses;

  DividendReportResponse(
      {this.status,
      this.statusMsg,
      this.msg,
      this.portfolioDividendPaid,
      this.portfolioDividendReinv,
      this.portfolioDividend,
      this.schemeWisePortfolioResponses});

  DividendReportResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    portfolioDividendPaid = json['portfolio_dividend_paid'];
    portfolioDividendReinv = json['portfolio_dividend_reinv'];
    portfolioDividend = json['portfolio__dividend'];
    if (json['schemeWisePortfolioResponses'] != null) {
      schemeWisePortfolioResponses = <SchemeWisePortfolioResponses>[];
      json['schemeWisePortfolioResponses'].forEach((v) {
        schemeWisePortfolioResponses!
            .add(new SchemeWisePortfolioResponses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_msg'] = this.statusMsg;
    data['msg'] = this.msg;
    data['portfolio_dividend_paid'] = this.portfolioDividendPaid;
    data['portfolio_dividend_reinv'] = this.portfolioDividendReinv;
    data['portfolio__dividend'] = this.portfolioDividend;
    if (this.schemeWisePortfolioResponses != null) {
      data['schemeWisePortfolioResponses'] =
          this.schemeWisePortfolioResponses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SchemeWisePortfolioResponses {
  String? scheme;
  String? amcLogo;
  String? folio;
  String? transactionType;
  String? dividendDate;
  String? dividendDateStr;
  num? amount;
  num? nav;
  num? dividendYield;
  num? divUnits;
  num? tds;
  num? stt;

  SchemeWisePortfolioResponses(
      {this.scheme,
      this.amcLogo,
      this.folio,
      this.transactionType,
      this.dividendDate,
      this.dividendDateStr,
      this.amount,
      this.nav,
      this.dividendYield,
      this.divUnits,
      this.tds,
      this.stt});

  SchemeWisePortfolioResponses.fromJson(Map<String, dynamic> json) {
    scheme = json['scheme'];
    amcLogo = json['amc_logo'];
    folio = json['folio'];
    transactionType = json['transaction_type'];
    dividendDate = json['dividend_date'];
    dividendDateStr = json['dividend_date_str'];
    amount = json['amount'];
    nav = json['nav'];
    dividendYield = json['dividend_yield'];
    divUnits = json['div_units'];
    tds = json['tds'];
    stt = json['stt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheme'] = this.scheme;
    data['amc_logo'] = this.amcLogo;
    data['folio'] = this.folio;
    data['transaction_type'] = this.transactionType;
    data['dividend_date'] = this.dividendDate;
    data['amount'] = this.amount;
    data['nav'] = this.nav;
    data['dividend_yield'] = this.dividendYield;
    data['div_units'] = this.divUnits;
    data['tds'] = this.tds;
    data['stt'] = this.stt;
    return data;
  }
}
