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
import 'package:mymfbox2_0/rp_widgets/CalculateButton.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RupeeCard.dart';
import 'package:mymfbox2_0/rp_widgets/SchemeNameCard.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class SipAmountInput extends StatefulWidget {
  const SipAmountInput({
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
  State<SipAmountInput> createState() => _SipAmountInputState();
}

class _SipAmountInputState extends State<SipAmountInput> {
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  Map client_code_map = GetStorage().read('client_code_map');

  num amount = 0;
  bool radioButtonValue = false;
  List folioList = [];
  late String folio;
  List<int> disableWeekdays = [];


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
    // if (widget.trnx_type != "AP") {
    //   folioList.insert(0, {"folio_no": "New Folio"});
    // }
    folioList.insert(0, {"folio_no": "New Folio"});
    return 0;
  }

  List sipEndTypeList = ["Until Cancelled", "Specific Date"];
  String sipEndType = "Until Cancelled";

  String fornightlyFirstStartDate = "";
  List fornightlyFirstStartDateList = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"];

  String fornightlySecondStartDate = "";
  List fornightlySecondStartDateList = ["16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"];


  // Rx<DateTime> sipStartDate = DateTime.now().add(Duration(days: 7)).obs;
  DateTime sipEndDate = DateTime.now();

  String frequency = "";
  String frequencyCode = "";

  String sipDay = "";
  String sipDayCode = "";

  List dateList = [];

  List? schemeList;

  late double devHeight, devWidth;
  num minAmount = 0;

  Future getMinAmount() async {
    if(minAmount != 0) return 0;
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

  List sipdayList = [];
  Future getSipDays()async{
    print("sipdayList => ${transactController.startDate.value.toString().split(" ").first}");
    EasyLoading.isShow ;
    if(sipdayList.isNotEmpty) return 0;
    Map data = await TransactionApi.getSipDays(
        user_id: user_id,
        client_name: client_name,
        bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      start_date: transactController.startDate.value.toString().split(" ").first,
      frequency: frequency,
    );

    if(data['status'] != SUCCESS){
      Utils.showError(context, data['msg']);
      return -1;
    }

    sipdayList = data['list'];
    Map temp = sipdayList.first;
    sipDay = temp['desc'];
    sipDayCode = temp['code'];
    EasyLoading.dismiss();

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
      nfo_flag: (widget.isNfo) ? "Y" : "N",
      client_name: client_name,
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

  Future getDatas() async {
    EasyLoading.show();

    await getFolioList();
    await getSipDatesAndFrequency();
    if(client_code_map['bse_nse_mfu_flag'].toUpperCase() == "NSE")await getSipDays();
    await getSipDividendSchemeoptions();
    await getMinAmount();


    EasyLoading.dismiss();
    return 0;
  }
  late ExpansionTileController folioController;
  late ExpansionTileController frequencyController;
  late ExpansionTileController sipDateController;
  late ExpansionTileController sipEndDateController;
  late ExpansionTileController sipFornightlyFirstController;
  late ExpansionTileController sipFornightlySecondController;
  late ExpansionTileController sipDaysController;
  late ExpansionTileController payoutController;
  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    sipEndDate = DateTime(now.year + 30, now.month, now.day);
    folio = widget.folio;

    frequencyController = ExpansionTileController();
    folioController = ExpansionTileController();
    sipDateController = ExpansionTileController();
    sipEndDateController = ExpansionTileController();
    sipFornightlyFirstController = ExpansionTileController();
    sipFornightlySecondController = ExpansionTileController();
    sipDaysController = ExpansionTileController();
    payoutController = ExpansionTileController();

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
                          // if (widget.trnx_type != "AP")
                          folioExpansionTile(context),
                          // if (widget.trnx_type == "AP")
                          // folioExpansionTileAP(context),
                          SizedBox(height: 16),
                          payoutExpansionTile(),
                          frequencyExpansionTile(context),

                          SizedBox(height: 16,),
                          InkWell(
                              onTap: () async {
                                DateTime? temp = await showDatePicker(
                                    selectableDayPredicate: (DateTime dateTime) => !disableWeekdays.contains(dateTime.weekday),
                                    context: Get.context!,
                                    firstDate: DateTime.now().add(Duration(days: 7)),
                                    initialDate: transactController.startDate.value,
                                    lastDate: DateTime(2030)
                                );
                                if (temp == null) return;
                                transactController.setStartDateWithCallback(temp, () async {
                              if(frequency.toLowerCase() == "weekly") sipdayList = [];
                                  setState(() {});
                                });
                              },
                              child: transactController.rpDatePicker("SIP Start Date")
                          ),

                          Visibility(
                            visible: frequency.toLowerCase() == "weekly",
                            child: Column(
                              children: [
                                SizedBox(height: 16),
                                sipDaysExpansionTile(context),
                              ],
                            ),
                          ),

                          Visibility(
                              visible: (client_code_map['bse_nse_mfu_flag'] == "NSE" && frequency.toLowerCase() == "fortnightly"),
                              child: Column(
                                children: [
                                  SizedBox(height: 16),
                                  sipFornightlyFirstExpansionTile(context),
                                  SizedBox(height: 16),
                                  sipFornightlySecondExpansionTile(context),
                                ],
                              )),
                          SizedBox(height: 16),
                          sipEndDateExpansionTile(context),
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
                print("startDay => $sipStartDate");
                if (!dateList.contains(startDay)) {
                  Utils.showError(context,
                      "Selected Date Not Allowed. \n Allowed dates are $dateList");
                  return;
                }

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

  // Widget sipDatePicker() {
  //   DateTime now = DateTime.now();

  //   return Obx(() {
  //     String date = sipStartDate.value.toString().split(" ").first;
  //     return Container(
  //       width: double.maxFinite,
  //       padding: EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(8),
  //         color: Colors.white,
  //       ),
  //       child: InkWell(
  //         onTap: () async {
  //           DateTime? temp = await showDatePicker(
  //               context: context,
  //               firstDate: now.add(Duration(days: 7)),
  //               initialDate: sipStartDate.value,
  //               lastDate: DateTime(2026));
  //           if (temp == null) return;
  //           sipStartDate.value = temp;
  //         },
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text("SIP Start Date", style: AppFonts.f50014Black),
  //             Text(date, style: AppFonts.f50012)
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }

  List payoutList = [];
  String payout = "";
  String dividend_code = "";

  Widget payoutExpansionTile() {
    //if (widget.isNfo) return SizedBox();
    if(payoutList.isEmpty) return SizedBox();
    payout = payout.isEmpty ? payoutList[0]["dividend_name"] : payout;
    if(payout == "Growth") {return SizedBox();}

    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      sip_date: (frequency == "Weekly") ? sipDayCode : "",
      start_date: convertDtToStr(sipStartDate),
      end_date: convertDtToStr(sipEndDate),
      until_cancelled: sipEndType.contains('Until') ? "1" : "0",
      trnx_type: (folio.contains("New")) ? "FP" : "AP",
      client_code_map: client_code_map,
      scheme_reinvest_tag: dividend_code,
      total_amount: "$amount",
      total_units: "",
      nfo_flag: (widget.isNfo) ? "Y" : "N",
      context: context,
      sip_first_date: ((client_code_map['bse_nse_mfu_flag'] == "NSE") && (frequency.toLowerCase() == "fortnightly")) ? fornightlyFirstStartDate : "",
      sip_second_date: ((client_code_map['bse_nse_mfu_flag'] == "NSE") && (frequency.toLowerCase() == "fortnightly")) ? fornightlySecondStartDate : "",
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    return 0;
  }

  bool validator() {
    List l = [amount];
    if (l.contains(0))
      return false;
    else
      return true;
  }

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

  Widget folioExpansionTileAP(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: folioController,
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

  Widget frequencyExpansionTile(BuildContext context) {
    String title = frequency;

    if(frequency.toLowerCase() == "weekly"){
      disableWeekdays = [
        DateTime.sunday,
        DateTime.saturday
      ];
    }
    else {
      disableWeekdays = [];
    }

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
                  onTap: () {
                    frequency = temp;
                    frequencyCode = tempCode;
                    //dateList = data['sip_dates'].split(",");
                    frequencyController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: tempCode,
                        groupValue: frequencyCode,
                        onChanged: (value) {
                          frequency = temp;
                          frequencyCode = tempCode;
                          //dateList = data['sip_dates'].split(",");
                          frequencyController.collapse();
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

  Widget sipFornightlyFirstExpansionTile(BuildContext context){

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: sipFornightlyFirstController,
          title: Text("SIP First Start Date", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fornightlyFirstStartDate, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: fornightlyFirstStartDateList.length,
              itemBuilder: (context, index) {
                String temp = fornightlyFirstStartDateList[index];

                return InkWell(
                  onTap: () {
                    fornightlyFirstStartDate = temp;
                    sipFornightlyFirstController.collapse();
                    String sipSrtDate = transactController.startDate.value.toString().split(" ").first;
                    print("sipSrtDate => $sipSrtDate");
                    fornightlyFirstStartDate = sipSrtDate;

                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: fornightlyFirstStartDate,
                        onChanged: (value) {
                          fornightlyFirstStartDate = temp;
                          sipFornightlyFirstController.collapse();
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

  Widget sipFornightlySecondExpansionTile(BuildContext context){
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: sipFornightlySecondController,
          title: Text("SIP Second Start Date", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fornightlySecondStartDate, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: fornightlySecondStartDateList.length,
              itemBuilder: (context, index) {
                String temp = fornightlySecondStartDateList[index];

                return InkWell(
                  onTap: () {
                    fornightlySecondStartDate = temp;
                    sipFornightlySecondController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: fornightlySecondStartDate,
                        onChanged: (value) {
                          fornightlySecondStartDate = temp;
                          sipFornightlySecondController.collapse();
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

  Widget sipDaysExpansionTile(BuildContext context) {

    /*if(frequency != "Weekly") return SizedBox();*/
    String title = sipDay;


    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: sipDaysController,
          title: Text("SIP Day", style: AppFonts.f50014Black),
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
              itemCount: sipdayList.length,
              itemBuilder: (context, index) {
                Map data = sipdayList[index];

                String tempCode = data['code'];
                String temp = data['desc'];

                return InkWell(
                  onTap: () async {
                    sipDay = temp;
                    sipDayCode = tempCode;
                    sipDaysController.collapse();
                    await getSipDays();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: tempCode,
                        groupValue: sipDayCode,
                        onChanged: (value) async {
                          sipDay = temp;
                          sipDayCode = tempCode;
                          sipDaysController.collapse();
                          await getSipDays();
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

  // String sipDate = "";
  // Widget sipDateExpansionTile(BuildContext context) {
  //   dateList = selectedFreqMap['sip_dates'].toString().split(",");

  //   return Container(
  //     decoration: BoxDecoration(
  //         color: Colors.white, borderRadius: BorderRadius.circular(10)),
  //     child: Theme(
  //       data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
  //       child: ExpansionTile(
  //         controller: sipDateController,
  //         title: Text("SIP Date", style: AppFonts.f50014Black),
  //         subtitle: Text(sipDate,
  //             style: TextStyle(
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 13,
  //                 color: Config.appTheme.themeColor)),
  //         expandedCrossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Wrap(
  //             children: [
  //               for (int i = 0; i < dateList.length; i++)
  //                 CircularDateCard(
  //                   dateList[i],
  //                   isSelected: sipDate == dateList[i],
  //                   onTap: () {
  //                     sipDate = dateList[i];
  //                     getStartDate();
  //                     // sipDateController.collapse();
  //                     setState(() {});
  //                   },
  //                 ),
  //             ],
  //           ),
  //           Text("Your SIP will start from ${convertDtToStr(sipStartDate)}",
  //               style: AppFonts.f50012
  //                   .copyWith(color: Config.appTheme.readableGreyTitle)),
  //           SizedBox(height: 16),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // getStartDate() {
  //   int date = int.parse(sipDate);
  //   DateTime minStart = DateTime.now().add(Duration(days: 7));

  //   if (minStart.day > date) {
  //     sipStartDate = DateTime(minStart.year, minStart.month + 1, date);
  //   } else
  //     sipStartDate = DateTime(minStart.year, minStart.month, date);
  // }

  Widget sipEndDateExpansionTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: sipEndDateController,
          title: Text("SIP End Date", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sipEndType,style:  AppFonts.f50012),
             // Text((sipEndType.contains("Until")) ? Utils.getFormattedDate(date: sipEndDate) : sipEndType, style: AppFonts.f50012),
            ],
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              width: devWidth,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: sipEndTypeList.length,
                itemBuilder: (context, index) {
                  String temp = sipEndTypeList[index];

                  return Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: sipEndType,
                        onChanged: (value) {
                          sipEndType = temp;
                          if (sipEndType.contains("Until")) {
                            DateTime now = DateTime.now();
                            sipEndDate = DateTime(now.year + 40, now.month, now.day);
                            sipEndDateController.collapse();
                          }
                          setState(() {});
                        },
                      ),
                      Text(temp),
                    ],
                  );
                },
              ),
            ),
            Visibility(
              visible: !sipEndType.contains("Until"),
              child: SizedBox(
                height: 200,
                child: ScrollDatePicker(
                    selectedDate: sipEndDate,
                    minimumDate: DateTime.now().add(Duration(days: 7)),
                    maximumDate: DateTime(2100),
                    onDateTimeChanged: (val) {
                      sipEndDate = val;
                      sipEndType = "${val.day}-${val.month}-${val.year}";
                      setState(() {});
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
