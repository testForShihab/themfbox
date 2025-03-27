import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/TransactController.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/SwpCart.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/MyCart.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/rp_widgets/CalculateButton.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:mymfbox2_0/rp_widgets/RupeeCard.dart';

class SwpAmountInput extends StatefulWidget {
  const SwpAmountInput(
      {super.key,
      required this.logo,
      required this.currValue,
      required this.units,
      required this.schemeAmfiShortName,
      required this.schemeAmfi,
      required this.folio,
      required this.amcName,
      required this.amcCode});

  final num currValue, units;
  final String logo, schemeAmfiShortName;
  final String amcName, amcCode;
  final String schemeAmfi, folio;
  @override
  State<SwpAmountInput> createState() => _SwpAmountInputState();
}

class _SwpAmountInputState extends State<SwpAmountInput> {
  String client_name = GetStorage().read('client_name');
  int user_id = GetStorage().read('user_id');
  Map client_code_map = GetStorage().read('client_code_map');
  late double devHeight, devWidth;

  num amount = 0;
  String trnxType = "Amount";

  DateTime swpEndDate = DateTime.now();
  String swpEndType = "Until Cancelled";
  List swpEndTypeList = ["Until Cancelled", "Specific Date"];

  TextEditingController amountController = TextEditingController();
  TextEditingController transferController = TextEditingController();

  ExpansionTileController frequencyController = ExpansionTileController();
  ExpansionTileController swpDateController = ExpansionTileController();
  ExpansionTileController swpEndDateController = ExpansionTileController();
  String frequency = "Monthly";
  String frequencyCode = "";
  num minAmount = 0;

  @override
  void initState() {
    //  implement initState
    super.initState();
    DateTime now = DateTime.now();
    swpEndDate = DateTime(now.year + 30, now.month, now.day);
  }

  /* Future getSwpMinAmount() async {

    Map data = await TransactionApi.getSwpMinAmount(
      user_id: user_id,
      client_name: client_name,
      scheme_name:"${widget.schemeAmfi}",
      amc_name: '${widget.amcName}',
    );
    if (data['status'] != SUCCESS) {
      minAmount = 0;
      return -1;
    }
    minAmount = data['min_amount'];
    return 0;
  }*/

  List dateAndFreq = [];
  List dateList = [];
  Future getSwpSchemeFrequency() async {
    if (dateAndFreq.isNotEmpty) return 0;
    EasyLoading.show();
    String schemAmfiName = Uri.encodeComponent(widget.schemeAmfi);
    Map data = await TransactionApi.getSwpSchemeFrequency(
      user_id: user_id,
      client_name: client_name,
      amc_name: widget.amcName,
      scheme_name: schemAmfiName,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
    );

    if (data['status'] != SUCCESS) {
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
    //await getSwpMinAmount();
    await getSwpSchemeFrequency();
  }

  TransactController transactController = Get.put(TransactController());
  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: invAppBar(title: "Start SWP"),
      body: FutureBuilder(
          future: getDatas(),
          builder: (context, snapshot) {
            return SideBar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          schemeInfoCard(),
                          SizedBox(height: 16),
                          RupeeCard(
                            title: "SWP Amount",
                            minAmount: 0,
                            hintTitle: "Enter SWP Amount",
                            onChange: (val) {
                              amount = num.tryParse(val) ?? 0;
                            },
                            text: 'Min SWP',
                            showText: false,
                          ),
                          SizedBox(height: 16),
                          frequencyExpansionTile(context),
                          SizedBox(height: 16),
                          transactController.rpDatePicker("SWP Start Date"),
                          //swpDateExpansionTile(context),
                          SizedBox(height: 16),
                          swpEndDateExpansionTile(context),
                          SizedBox(height: 77),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      bottomSheet: CalculateButton(
          onPress: () async {
            DateTime swpStartDate = transactController.startDate.value;
            if (amount == 0) {
              Utils.showError(context, "Please Enter Amount");
              return;
            }
            /* if (amount < minAmount) {
                              Utils.showError(
                                  context, "Min Amount is $rupee $minAmount");
                              return;
                            }*/

            String staryDay = swpStartDate.day.toString().padLeft(2, '0');
            if (!dateList.contains(staryDay)) {
              Utils.showError(context,
                  "Selected Date Not Allowed. \n Allowed dates are $dateList");
              return;
            }
            int res = await saveCartByUserId();
            if (res == -1) return;

            Get.off(() => MyCart(
                  defaultTitle: "SWP",
                  defaultPage: SwpCart(),
                ));
            EasyLoading.showToast(
              "Added to cart",
              toastPosition: EasyLoadingToastPosition.bottom,
            );
          },
          text: "CONTINUE"),
    );
  }

  Future saveCartByUserId() async {
    DateTime swpStartDate = transactController.startDate.value;
    String fromDividendCode = Utils.getDividendCode(
        schemeAmfi: widget.schemeAmfi,
        marketType: client_code_map['bse_nse_mfu_flag'],
        payout: fromPayout);

    String folio = widget.folio;

    Map data = await TransactionApi.saveCartByUserId(
      user_id: user_id,
      client_name: client_name,
      cart_id: '',
      purchase_type: PurchaseType.swp,
      scheme_name: widget.schemeAmfi,
      to_scheme_name: '',
      folio_no: folio,
      amount: "$amount",
      units: "",
      frequency: frequencyCode,
      sip_date: swpDate,
      start_date: convertDtToStr(swpStartDate),
      end_date: convertDtToStr(swpEndDate),
      until_cancelled: swpEndType.contains('Until') ? "1" : "0",
      trnx_type: (folio.contains("New")) ? "FP" : "AP",
      client_code_map: client_code_map,
      total_amount: "$amount",
      total_units: "",
      scheme_reinvest_tag: fromDividendCode,
      to_scheme_reinvest_tag: '',
      context: context,
      amount_type: 'amount',
      stp_date: '',
      stp_type: 'amount',
      installment: '',
      swp_date: swpDate,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    return 0;
  }

  ExpansionTileController payoutController = ExpansionTileController();
  List payoutList = ["Dividend Payout", "Dividend Reinvestment"];
  String toPayout = "Dividend Payout";
  String fromPayout = "Dividend Payout";

  Widget toPayoutExpansionTile() {
    String schemeAmfi = "widget.toSchemeAmfi";
    List list = [
      "IDCW",
      "INCOME DISTRIBUTION",
    ];
    bool showPayoutOptions = false;
    for (String element in list) {
      if (schemeAmfi.toUpperCase().contains(element)) showPayoutOptions = true;
    }

    if (!showPayoutOptions) return SizedBox();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: payoutController,
          title: Text("To Scheme Payout", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(toPayout, style: AppFonts.f50012),
            ],
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: payoutList.length,
              itemBuilder: (context, index) {
                String temp = payoutList[index];

                return InkWell(
                  onTap: () {
                    toPayout = temp;
                    payoutController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: toPayout,
                        onChanged: (value) {
                          toPayout = temp;
                          payoutController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(temp, style: AppFonts.f50014Black),
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

  Widget fromPayoutExpansionTile() {
    String schemeAmfi = "widget.fromSchemeAmfi";
    List list = [
      "IDCW",
      "INCOME DISTRIBUTION",
    ];
    bool showPayoutOptions = false;
    for (String element in list) {
      if (schemeAmfi.toUpperCase().contains(element)) showPayoutOptions = true;
    }

    if (!showPayoutOptions) return SizedBox();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: payoutController,
          title: Text("From Payout", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fromPayout, style: AppFonts.f50012),
            ],
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: payoutList.length,
              itemBuilder: (context, index) {
                String temp = payoutList[index];

                return InkWell(
                  onTap: () {
                    fromPayout = temp;
                    payoutController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: fromPayout,
                        onChanged: (value) {
                          fromPayout = temp;
                          payoutController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(temp, style: AppFonts.f50014Black),
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

  void allUnitSelected() {
    amountController.text = "0";
    ;
  }

  Widget schemeInfoCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Config.appTheme.themeColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(widget.logo, height: 32),
              SizedBox(width: 10),
              ColumnText(
                title: widget.schemeAmfiShortName,
                value: "Folio : ${widget.folio}",
                titleStyle: AppFonts.f50014Black,
                valueStyle: AppFonts.f40013,
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: ColumnText(
                      title: "Current Value",
                      value: "$rupee ${widget.currValue}")),
              Expanded(
                  child: ColumnText(
                      title: "Free Units", value: "${widget.units}")),
            ],
          ),
        ],
      ),
    );
  }

  Widget frequencyExpansionTile(BuildContext context) {
    String title = frequency;

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: frequencyController,
          title: Text("SWP Frequency", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Config.appTheme.themeColor)),
              DottedLine(),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: dateAndFreq.length,
              itemBuilder: (context, index) {
                Map data = dateAndFreq[index];

                String tempCode = data['sip_frequency_code'];
                String temp = data['sip_frequency'];
                return InkWell(
                  onTap: () {
                    frequency = temp;
                    frequencyCode = tempCode;
                    dateList = data['sip_dates'].split(",");
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
                          dateList = data['sip_dates'].split(",");
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

  // getStartDate() {
  //   int date = int.parse(swpDate);
  //   DateTime minStart = DateTime.now().add(Duration(days: 7));

  //   if (minStart.day > date) {
  //     swpStartDate = DateTime(minStart.year, minStart.month + 1, date);
  //   } else
  //     swpStartDate = DateTime(minStart.year, minStart.month, date);
  // }

  String swpDate = "";
  // Widget swpDateExpansionTile(BuildContext context) {
  //   dateList = selectedFreqMap['sip_dates'].toString().split(",");
  //   return Container(
  //     decoration: BoxDecoration(
  //         color: Colors.white, borderRadius: BorderRadius.circular(10)),
  //     child: Theme(
  //       data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
  //       child: ExpansionTile(
  //         controller: swpDateController,
  //         title: Text("SWP Date", style: AppFonts.f50014Black),
  //         subtitle: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(swpDate,
  //                 style: TextStyle(
  //                     fontWeight: FontWeight.w500,
  //                     fontSize: 13,
  //                     color: Config.appTheme.themeColor)),
  //           ],
  //         ),
  //         expandedCrossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Wrap(
  //             children: [
  //               for (int i = 0; i < dateList.length; i++)
  //                 CircularDateCard(
  //                   dateList[i],
  //                   isSelected: swpDate == dateList[i],
  //                   onTap: () {
  //                     swpDate = dateList[i];
  //                     getStartDate();
  //                     // sipDateController.collapse();
  //                     setState(() {});
  //                   },
  //                 ),
  //             ],
  //           ),
  //           Text("Your SWP will start from ${convertDtToStr(swpStartDate)}",
  //               style: AppFonts.f50012
  //                   .copyWith(color: Config.appTheme.readableGreyTitle)),
  //           SizedBox(height: 16),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget swpEndDateExpansionTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: swpEndDateController,
          title: Text("SWP End Date", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(swpEndType, style: AppFonts.f50012),
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
                itemCount: swpEndTypeList.length,
                itemBuilder: (context, index) {
                  String temp = swpEndTypeList[index];

                  return Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: swpEndType,
                        onChanged: (value) {
                          swpEndType = temp;
                          if (swpEndType.contains("Until")) {
                            DateTime now = DateTime.now();
                            swpEndDate =
                                DateTime(now.year + 40, now.month, now.day);
                            swpEndDateController.collapse();
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
              visible: !swpEndType.contains("Until"),
              child: SizedBox(
                height: 200,
                child: ScrollDatePicker(
                    selectedDate: swpEndDate,
                    minimumDate: DateTime.now().add(Duration(days: 7)),
                    maximumDate: DateTime(2100),
                    onDateTimeChanged: (val) {
                      swpEndDate = val;
                      swpEndType = "${val.day}-${val.month}-${val.year}";
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
