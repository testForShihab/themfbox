import 'package:intl/intl.dart';

class SipPojo {
  String? schemeAmfi;
  String? schemeAmfiShortName;
  String? schemeCompany;
  String? schemeAmfiCode;
  String? logo;
  String? sipDate;
  String? sipFrequency;
  num? sipAmount;
  String? folio;
  String? trnxDate;
  String? trnxType;
  num? trnxAmount;
  String? sipDateWithFrequency;
  String? startdate;
  String? enddate;

  SipPojo({
    this.schemeAmfi,
    this.schemeAmfiShortName,
    this.schemeCompany,
    this.schemeAmfiCode,
    this.logo,
    this.sipDate,
    this.sipAmount,
    this.folio,
    this.sipFrequency,
    this.trnxDate,
    this.trnxType,
    this.trnxAmount,
    this.sipDateWithFrequency,
    this.startdate,
    this.enddate,
  });

  SipPojo.fromJson(Map<String, dynamic> json) {
    schemeAmfi = json['scheme_amfi'];
    schemeAmfiShortName = json['scheme_amfi_short_name'];
    schemeCompany = json['scheme_company'];
    schemeAmfiCode = json['scheme_amfi_code'];
    logo = json['logo'];
    sipDate = json['sip_date'];
    sipAmount = json['sip_amount'];
    folio = json['folio'];
    trnxDate = json['trnx_date'];
    trnxType = json['trnx_type'];
    sipFrequency = json['sip_frequency'];
    trnxAmount = json['trnx_amount'];
    sipDateWithFrequency = json['sip_date_with_frequency'];
    startdate = json['start_date'];
    enddate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scheme_amfi'] = schemeAmfi;
    data['scheme_amfi_short_name'] = schemeAmfiShortName;
    data['scheme_company'] = schemeCompany;
    data['scheme_amfi_code'] = schemeAmfiCode;
    data['logo'] = logo;
    data['sip_date'] = sipDate;
    data['sip_amount'] = sipAmount;
    data['folio'] = folio;
    data['trnx_date'] = trnxDate;
    data['trnx_type'] = trnxType;
    data['trnx_amount'] = trnxAmount;
    data['sip_frequency'] = this.sipFrequency;
    data['sip_date_with_frequency'] = this.sipDateWithFrequency;
    data['start_date'] = startdate;
    data['end_date'] = enddate;
    return data;
  }
}
