import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/TransactController.dart';
import 'package:mymfbox2_0/Investor/transact/cart/MyCart.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/SipCart.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/CalculateButton.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RupeeCard.dart';
import 'package:mymfbox2_0/rp_widgets/SchemeNameCard.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../../rp_widgets/CircularDateCard.dart';

class BseSipAmountInput extends StatefulWidget {
  const BseSipAmountInput({
    super.key,
    required this.logo,
    required this.shortName,
    required this.schemeAmfi,
    this.folio = "New Folio",
    this.isNfo = false,
    required this.amc,
    this.trnx_type,
  });
  final String? trnx_type;
  final String shortName, logo;
  final String schemeAmfi, folio;
  final String amc;
  final bool isNfo;
  @override
  State<BseSipAmountInput> createState() => _BseSipAmountInputState();
}

class _BseSipAmountInputState extends State<BseSipAmountInput> {
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  Map client_code_map = GetStorage().read('client_code_map');

  num amount = 0;
  bool radioButtonValue = false;
  List folioList = [];
  late String folio;

  String frequency = "";
  String frequencyCode = "";


  ExpansionTileController payoutController = ExpansionTileController();
  List payoutList = [];
  String payout = "";
  String dividend_code = "";

  Future getFolioList() async {
    if (folioList.isNotEmpty) return 0;

    Map data = await TransactionApi.getUserFolio(
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      amc: widget.amc,
      client_name: client_name,
      user_id: user_id,
      investor_code: client_code_map['investor_code'],
    );

    if (data['status'] != 200) {
      if (!widget.isNfo) Utils.showError(context, data['msg']);
      return -1;
    }

    folioList = data['list'];
    folioList.insert(0, {"folio_no": "New Folio"});
    return 0;
  }

  List sipEndTypeList = ["Until Cancelled", "Specific Date"];
  String sipEndType = "Until Cancelled";
  DateTime sipStartDate = DateTime.now();
  DateTime sipEndDate = DateTime.now();

  // Map selectedFreqMap = {};

  List dateList = [];

  List? schemeList;

  late double devHeight, devWidth;
  num minAmount = 0;
  num minInstall = 0;
  num maxInstall = 0;

  Future getMinAmount() async {
    Map data = await TransactionApi.getSipMinAmount(
      scheme_name: widget.schemeAmfi.trim(),
      purchase_type: (folio.contains("New")) ? "FP" : "AP",
      frequency: frequencyCode,
      amount: "$amount",
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      client_name: client_name,
      dividend_code: dividend_code,
    );

    if (data['status'] != SUCCESS) {
      if (!widget.isNfo) Utils.showError(context, data['msg']);
      minAmount = 0;
      return -1;
    }
    minAmount = data['min_amount'];
    minInstall = data['min_install'];
    maxInstall = data['max_install'];

    return 0;
  }

  List dateAndFreq = [];
  Future getSipDatesAndFrequency() async {
    if (dateAndFreq.isNotEmpty) return 0;
    EasyLoading.show();
    String schemAmfi = Uri.encodeComponent(widget.schemeAmfi);
    Map data = await TransactionApi.getSipDatesAndFrequency(
      scheme: schemAmfi,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      client_name: client_name,
      nfo_flag: (widget.isNfo) ? "Y" : "N",
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    dateAndFreq = data['list'];
    Map temp = dateAndFreq.first;
    frequency = temp['sip_frequency'];
    frequencyCode = temp['sip_frequency_code'];
    dateList = temp['sip_dates'].split(",");

    EasyLoading.dismiss();
    return 0;
  }

  Future getSipDividendSchemeoptions() async{
    Map data = await TransactionApi.getSipDividendSchemeoptions(
        scheme_name: widget.schemeAmfi,
        bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
        client_name: client_name,
        user_id: user_id);

    if(data['status'] != 200){
      if (!widget.isNfo) Utils.showError(context, data['msg']);
      return -1;
    }

    payoutList = data['result'];
    dividend_code = dividend_code.isEmpty ? payoutList[0]['dividend_code'] : dividend_code;
    print("dividend_code $dividend_code");

    //await getMinAmount();
    return 0;
  }

  Future findSipEndDate() async {
    // Perform the API call to fetch the SIP end date
    Map data = await TransactionApi.findSipEndDate(
      user_id: user_id,
      sip_type: (tenure == "SIP Tenure") ? "Tenure" : "Perpetual",
      install: (tenure == "SIP Tenure" && noOfMonth == "") ? "480" : (noOfMonth != "") ? noOfMonth : "0",
      client_name: client_name,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      frequency: frequency,
      start_date: transactController.startDate.value.toString().split(" ")[0],
    );

    // If the API response status is not 200, show an error
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    // Parse the SIP end date from the response and store it
    sipEndDate = DateTime.parse(data['msg']);
    print('SIP selected end date $sipEndDate');
  }


  Future getDatas() async {
    // EasyLoading.show();

    await getFolioList();
    await getSipDatesAndFrequency();
    await getMinAmount();
    await getSipDividendSchemeoptions();


    // EasyLoading.dismiss();
    return 0;
  }

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    sipEndDate = DateTime(now.year + 40, now.month, now.day);
    folio = widget.folio;
    
    // Initialize start date to 7 days from now
    transactController.startDate.value = DateTime.now().add(Duration(days: 7));
  }

  @override
  void dispose() {
    super.dispose();
  }

  TransactController transactController = Get.put(TransactController());

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: invAppBar(title: "Start SIP"),
            body: SideBar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SchemeNameCard(
                              logo: widget.logo, shortName: widget.shortName),
                          SizedBox(height: 16),
                          RupeeCard(
                            title: "SIP Amount",
                            minAmount: minAmount,
                            hintTitle: "Enter SIP Amount",
                            onChange: (val) {
                              amount = num.tryParse(val) ?? 0;
                            },
                            showText: !widget.isNfo,
                          ),
                          SizedBox(height: 16),
                          payoutExpansionTile(),
                          SizedBox(height: 16),
                          frequencyExpansionTile(context),
                          SizedBox(height: 16),

                          InkWell(
                              onTap: () async {
                                DateTime? temp = await showDatePicker(
                                    context: Get.context!,
                                    firstDate: DateTime.now().add(Duration(days: 7)),
                                    initialDate: transactController.startDate.value,
                                    lastDate: DateTime(2030)
                                );
                                if (temp == null) return;

                                transactController.setStartDateWithCallback(temp, () async {
                                    await findSipEndDate();
                                    setState(() {});
                                });
                              },
                              child: transactController.rpDatePicker("SIP Start Date")
                          ),


                          SizedBox(height: 16),

                          tenureExpansionTile(context),
                          if (tenure == "SIP Tenure")
                            Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: AmountInputCard(
                                maxLength: 9,
                                title: "No. of Installments",
                                suffixText: frequency ,
                                onChange: (val) async {
                                    noOfMonth = val;
                                    await findSipEndDate();

                                  setState(() {});
                                },
                              ),
                            ),
                          Container(
                              width: devWidth,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("SIP End Date",
                                      style: AppFonts.f50014Black),
                                  Text(sipEndDate.toString().split(" ")[0],
                                      style: AppFonts.f50012)
                                ],
                              )),
                          SizedBox(height: 16),
                          folioExpansionTile(context),
                          SizedBox(height: 77),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomSheet: CalculateButton(
              text: "CONTINUE",
              onPress: () async {
                DateTime sipStartDate = transactController.startDate.value;

                if (amount == 0) {
                  Utils.showError(context, "Please Enter Amount");
                  return;
                }

                if (amount < minAmount) {
                  Utils.showError(context, "Min Amount is $rupee $minAmount");
                  return;
                }

                String startDay = sipStartDate.day.toString();
                if (!dateList.contains(startDay)) {
                  Utils.showError(context,
                      "Selected Date Not Allowed. \n Allowed dates are $dateList");
                  return;
                }
                if (tenure == "SIP Tenure" && noOfMonth == "") {
                  Utils.showError(context, "Please enter the SIP installment");
                  return;
                }

                int installs = 0;
                if (tenure == "Perpetual") noOfMonth = getNoOfMonths(frequency);

                installs = int.tryParse(noOfMonth) ?? 0;

                /*if (tenure == "SIP Tenure" && installs < minInstall) {
                  Utils.showError(context,
                      "Minimum SIP installment is $minInstall. Please enter the valid SIP installment number.");
                  return;
                }
                if (tenure == "SIP Tenure" && installs > maxInstall) {
                  Utils.showError(context,
                      "Maximum installment is $maxInstall. Please enter the valid SIP installment number.");
                  return;
                }*/

                EasyLoading.show();

                int res = await saveCartByUserId();
                if (res == 0) {
                  Get.off(() => MyCart(
                        defaultTitle: "SIP",
                        defaultPage: SipCart(),
                      ));
                  EasyLoading.showToast(
                    "Added to cart",
                    toastPosition: EasyLoadingToastPosition.bottom,
                  );
                }
                EasyLoading.dismiss();
              },
            ),
          );
        });
  }

  String noOfMonth = "";

  ExpansionTileController tenureController = ExpansionTileController();
  List tenureList = ["Perpetual", "SIP Tenure"];
  String tenure = "Perpetual";

  Widget tenureExpansionTile(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: tenureController,
          title: Text("SIP Tenure", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tenure,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Config.appTheme.themeColor)),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: tenureList.length,
              itemBuilder: (context, index) {
                String temp = tenureList[index];

                return InkWell(
                  onTap: () async {
                    await transactController.preserveStartDate(() async {
                        tenure = temp;
                        tenureController.collapse();
                        await findSipEndDate();
                    });
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: tenure,
                        onChanged: (value) async {
                          tenure = temp;
                          tenureController.collapse();
                          await findSipEndDate();
                          setState(() {});
                        },
                      ),
                      Text(temp),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  String getNoOfMonths(String frequency) {
    Map map = {
      "MONTHLY": "360",
      "QUARTERLY": "120",
      "DAILY": "10950",
      "WEEKLY": "1440",
      "SEMI-ANNUALLY": "60",
      "ANNUALLY": "30"
    };
    if (map.keys.contains(frequency))
      return map[frequency];
    else
      return "360";
  }



  Widget payoutExpansionTile() {
    // if (widget.isNfo) return SizedBox();
    if(payoutList.isEmpty) return SizedBox();
    payout = payout.isEmpty ? payoutList[0]["dividend_name"] : payout;

    if(payout== "Growth")
     return SizedBox();

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: payoutController,
          title: Text("Payout", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(payout, style: AppFonts.f50012),
            ],
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: payoutList.length,
              itemBuilder: (context, index) {
                Map divTemp = payoutList[index];
                String temp = divTemp['dividend_name'];
                String dividend_temp = divTemp ['dividend_code'];

                return InkWell(
                  onTap: ()  async {
                    payout = temp;
                    dividend_code = dividend_temp;
                    payoutController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: payout,
                        onChanged: (value) async {
                          payout = temp;
                          dividend_code = dividend_temp;
                          payoutController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(temp),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future saveCartByUserId() async {
    DateTime sipStartDate = transactController.startDate.value;
    print("Sip tenure $tenure");

    Map data = await TransactionApi.saveCartByUserId(
      user_id: user_id,
      client_name: client_name,
      cart_id: '',
      purchase_type: PurchaseType.sip,
      scheme_name: widget.schemeAmfi,
      to_scheme_name: "",
      folio_no: folio,
      amount: "$amount",
      units: "",
      frequency: frequencyCode,
      sip_date: sipStartDate.day.toString(),
      start_date: convertDtToStr(sipStartDate),
      end_date: convertDtToStr(sipEndDate),
      until_cancelled: "0",//sipEndType.contains('Until') ? "1" : "0",
      trnx_type: (folio.contains("New")) ? "FP" : "AP",
      client_code_map: client_code_map,
      scheme_reinvest_tag: dividend_code,
      total_amount: "$amount",
      total_units: "",
      nfo_flag: (widget.isNfo) ? "Y" : "N",
      installment: noOfMonth,
      sip_tenure: tenure,
      context: context,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    return 0;
  }

  ExpansionTileController folioController = ExpansionTileController();
  Widget folioExpansionTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: folioController,
          enabled: widget.trnx_type != "AP",
          title: Text("Folio Number", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(folio,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Config.appTheme.themeColor)),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemCount: folioList.length,
              itemBuilder: (context, index) {
                Map map = folioList[index];
                String tempFolio = map['folio_no'];

                return InkWell(
                  onTap: () async {
                    folio = tempFolio;
                    folioController.collapse();
                    await getMinAmount();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: tempFolio,
                        groupValue: folio,
                        onChanged: (value) async {
                          folio = tempFolio;
                          folioController.collapse();
                          await getMinAmount();
                          setState(() {});
                        },
                      ),
                      Text(tempFolio),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  ExpansionTileController frequencyController = ExpansionTileController();
  Widget frequencyExpansionTile(BuildContext context) {
    String title = frequency;

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: frequencyController,
          title: Text("SIP Frequency", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: dateAndFreq.length,
              itemBuilder: (context, index) {
                Map data = dateAndFreq[index];
                String tempCode = data['sip_frequency_code'];
                String temp = data['sip_frequency'];

                return InkWell(
                  onTap: () async {
                    await transactController.preserveStartDate(() async {
                        frequency = temp;
                        frequencyCode = tempCode;
                        dateList = data['sip_dates'].split(",");
                        frequencyController.collapse();
                        await findSipEndDate();
                    });
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: tempCode,
                        groupValue: frequencyCode,
                        onChanged: (value) async {
                          frequency = temp;
                          frequencyCode = tempCode;
                          dateList = data['sip_dates'].split(",");
                          frequencyController.collapse();
                          await findSipEndDate();
                          setState(() {});
                        },
                      ),
                      Text(temp),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  ExpansionTileController sipDateController = ExpansionTileController();
  String sipDate = "";
  Widget sipDateExpansionTile(BuildContext context) {
    DateTime now = DateTime.now();
   // dateList = selectedFreqMap['sip_dates'].toString().split(",");

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: sipDateController,
          title: Text("SIP Date", style: AppFonts.f50014Black),
          subtitle: Text(sipDate,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Config.appTheme.themeColor)),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                DateTime? temp = await showDatePicker(
                    context: Get.context!,
                    firstDate: now.add(Duration(days: 1)),
                    initialDate: sipStartDate,
                    lastDate: DateTime(2030));
                if (temp == null) return;
                sipStartDate = temp;
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select Start Date", style: AppFonts.f50014Black),
                  Text("$sipStartDate", style: AppFonts.f50012)
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  getStartDate() {
    int date = int.parse(sipDate);
    DateTime minStart = DateTime.now().add(Duration(days: 7));

    if (minStart.day > date) {
      sipStartDate = DateTime(minStart.year, minStart.month + 1, date);
    } else
      sipStartDate = DateTime(minStart.year, minStart.month, date);
  }
}

/*
// ... existing code ...

if (tenure == "SIP Tenure")
  Padding(
    padding: EdgeInsets.only(bottom: 16),
    child: AmountInputCard(
      maxLength: 9,
      title: "No. of Installments",
      suffixText: frequency,
      onChange: (val) {
        noOfMonth = val;
        int installments = int.tryParse(noOfMonth) ?? 0;

        // Calculate months to add based on frequency
        int monthsToAdd = 0;
        switch (frequency) {
          case "MONTHLY":
            monthsToAdd = installments;
            break;
          case "QUARTERLY":
            monthsToAdd = installments * 3;
            break;
          case "SEMI-ANNUALLY":
            monthsToAdd = installments * 6;
            break;
          case "ANNUALLY":
            monthsToAdd = installments * 12;
            break;
          case "WEEKLY":
            // Convert weeks to months (approximately)
            monthsToAdd = (installments / 4).ceil();
            break;
          case "DAILY":
            // Convert days to months (approximately)
            monthsToAdd = (installments / 30).ceil();
            break;
          default:
            monthsToAdd = installments;
        }

        DateTime startDate = transactController.startDate.value;
        sipEndDate = DateTime(
          startDate.year,
          startDate.month + monthsToAdd,
          startDate.day,
        );
        setState(() {});
      },
    ),
  ),

// ... existing code ...
*/
