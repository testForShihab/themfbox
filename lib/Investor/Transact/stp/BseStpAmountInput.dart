import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/StpCart.dart';
import 'package:mymfbox2_0/Investor/transact/cart/MyCart.dart';
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

import '../../../rp_widgets/CircularDateCard.dart';
import '../../../rp_widgets/RupeeCard.dart';

class BseStpAmountInput extends StatefulWidget {
  const BseStpAmountInput(
      {super.key,
      required this.fromSchemeAmfiShortName,
      required this.fromSchemeAmfi,
      required this.toSchemeAmfiShortName,
      required this.totalAmount,
      required this.totalUnits,
      required this.toSchemeAmfi,
      required this.folio,
      required this.amccode,
      required this.amcName,
      required this.logo});
  final String fromSchemeAmfiShortName;
  final String fromSchemeAmfi;
  final String toSchemeAmfiShortName;
  final String toSchemeAmfi;
  final num totalAmount, totalUnits;
  final String folio;
  final String amccode, amcName;
  final String logo;
  @override
  State<BseStpAmountInput> createState() => _BseStpAmountInputState();
}

class _BseStpAmountInputState extends State<BseStpAmountInput> {
  String client_name = GetStorage().read('client_name');
  int user_id = GetStorage().read('user_id');
  Map client_code_map = GetStorage().read('client_code_map');
  late double devHeight, devWidth;

  num amount = 0;
  String trnxType = "Amount";
  String stpInstallmentValue = '';
  DateTime stpStartDate = DateTime.now();
  DateTime stpEndDate = DateTime.now();
  String stpEndType = "Until Cancelled";
  List stpEndTypeList = ["Until Cancelled", "Specific Date"];

  TextEditingController amountController = TextEditingController();
  TextEditingController transferController = TextEditingController();

  ExpansionTileController frequencyController = ExpansionTileController();
  ExpansionTileController stpDateController = ExpansionTileController();
  ExpansionTileController stpEndDateController = ExpansionTileController();
  String frequency = "Monthly";

  num minAmount = 0;

  @override
  void initState() {
    //  implement initState
    super.initState();
    DateTime now = DateTime.now();
    stpEndDate = DateTime(now.year + 30, now.month, now.day);
    //folio = widget.folio;
  }

  Future getStpMinAmount() async {
    String toDividendCode = Utils.getDividendCode(
        schemeAmfi: widget.toSchemeAmfi,
        marketType: client_code_map['bse_nse_mfu_flag'],
        payout: toPayout);
    Map data = await TransactionApi.getStpMinAmount(
      user_id: user_id,
      client_name: client_name,
      scheme_name: widget.fromSchemeAmfi,
      purchase_type: (widget.folio.contains("New")) ? "FP" : "AP",
      amount: "${widget.totalAmount}",
      dividend_code: toDividendCode,
      amc_code: "${widget.amccode}",
    );
    if (data['status'] != SUCCESS) {
      minAmount = 0;
      return -1;
    }
    minAmount = data['min_amount'];
    return 0;
  }

  List dateAndFreq = [];
  Map selectedFreqMap = {};
  List dateList = [];
  String bse_nse_mfu = " ";
  Future getStpSchemeFrequency() async {
    String marketType = client_code_map['bse_nse_mfu_flag'];
    bse_nse_mfu = client_code_map['bse_nse_mfu_flag'];
    String toDividendCode = Utils.getDividendCode(
        schemeAmfi: widget.toSchemeAmfi,
        marketType: client_code_map['bse_nse_mfu_flag'],
        payout: toPayout);
    if (dateAndFreq.isNotEmpty) return 0;
    Map data = await TransactionApi.getStpSchemeFrequency(
      user_id: user_id,
      client_name: client_name,
      amc_name: (marketType == "BSE") ? widget.amcName : widget.amccode,
      scheme_name: widget.toSchemeAmfi,
      dividend_code: toDividendCode,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
    );

    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    dateAndFreq = data['list'];
    selectedFreqMap = dateAndFreq.first;
  }

  Future getDatas() async {
    await getStpMinAmount();
    await getStpSchemeFrequency();
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: invAppBar(title: "Start STP"),
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
                          title: "STP Amount",
                          minAmount: minAmount,
                          onChange: (val) {
                            amount = num.tryParse(val) ?? 0;
                          },
                          text: 'Min STP',
                          hintTitle: 'Enter STP Amount',
                        ),
                        SizedBox(height: 16),
                        toPayoutExpansionTile(),
                        SizedBox(height: 16),
                        frequencyExpansionTile(context),
                        SizedBox(height: 16),
                        /*stpDateExpansionTile(context),
                          SizedBox(height: 16),*/
                        if ((selectedFreqMap['sip_frequency_code'] == 'Daily' &&
                            bse_nse_mfu == 'BSE'))
                          stpEndDateExpansionTile(context),
                        SizedBox(height: 16),
                        if (selectedFreqMap['sip_frequency_code'] != 'Daily' &&
                            bse_nse_mfu == 'BSE')
                          installment(context),
                        SizedBox(height: 77),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomSheet: CalculateButton(
          onPress: () async {
            if (amount == 0) {
              Utils.showError(context, "Please Enter Amount");
              return;
            }
            if (amount < minAmount) {
              Utils.showError(context, "Min Amount is $rupee $minAmount");
              return;
            }
            if (amount < minAmount) {
              Utils.showError(context, "Min Amount is $rupee $minAmount");
            }
            if (bse_nse_mfu != 'BSE') if (stpDate.isEmpty) {
              Utils.showError(context, "Please Select STP Date");
              return;
            }

            int res = await saveCartByUserId();
            if (res == -1) return;

            Get.off(() => MyCart(
                  defaultTitle: "STP",
                  defaultPage: StpCart(),
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
    String fromDividendCode = Utils.getDividendCode(
        schemeAmfi: widget.fromSchemeAmfi,
        marketType: client_code_map['bse_nse_mfu_flag'],
        payout: fromPayout);
    String toDividendCode = Utils.getDividendCode(
        schemeAmfi: widget.toSchemeAmfi,
        marketType: client_code_map['bse_nse_mfu_flag'],
        payout: toPayout);
    String folio = widget.folio;

    Map data = await TransactionApi.saveCartByUserId(
      user_id: user_id,
      client_name: client_name,
      cart_id: '',
      purchase_type: PurchaseType.stp,
      scheme_name: widget.fromSchemeAmfi,
      to_scheme_name: widget.toSchemeAmfi,
      folio_no: folio,
      amount: "$amount",
      units: "",
      frequency: selectedFreqMap['sip_frequency_code'],
      sip_date: stpDate,
      start_date: convertDtToStr(stpStartDate),
      end_date: convertDtToStr(stpEndDate),
      until_cancelled: stpEndType.contains('Until') ? "1" : "0",
      trnx_type: (folio.contains("New")) ? "FP" : "AP",
      client_code_map: client_code_map,
      total_amount: "${widget.totalAmount}",
      total_units: "",
      scheme_reinvest_tag: fromDividendCode,
      to_scheme_reinvest_tag: toDividendCode,
      context: context,
      amount_type: 'amount',
      stp_date: stpDate,
      stp_type: 'amount',
      installment: stpInstallmentValue,
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
    String schemeAmfi = widget.toSchemeAmfi;
    List list = ["IDCW","INCOME DISTRIBUTION",];
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
    String schemeAmfi = widget.fromSchemeAmfi;
    List list = ["IDCW","INCOME DISTRIBUTION",];
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
    amountController.text = "${widget.totalUnits}";
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
                title: widget.fromSchemeAmfiShortName,
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
                      value: "$rupee ${widget.totalAmount}")),
              Expanded(
                  child: ColumnText(
                      title: "Free Units", value: "${widget.totalUnits}")),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Config.appTheme.themeColor)),
                  child: Icon(Icons.arrow_forward,
                      color: Config.appTheme.themeColor)),
              SizedBox(width: 10),
              Expanded(child: Text(widget.toSchemeAmfi))
            ],
          )
        ],
      ),
    );
  }

  Widget frequencyExpansionTile(BuildContext context) {
    String title = selectedFreqMap['sip_frequency'] ?? "";

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: frequencyController,
          title: Text("STP Frequency", style: AppFonts.f50014Black),
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

                String freqCode = data['sip_frequency_code'];
                String freq = data['sip_frequency'];

                return InkWell(
                  onTap: () {
                    selectedFreqMap = data;
                    dateList = data['sip_dates'].toString().split(",");
                    frequencyController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: data,
                        groupValue: selectedFreqMap,
                        onChanged: (value) {
                          selectedFreqMap = data;
                          dateList = data['sip_dates'].toString().split(",");
                          frequencyController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(freq),
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

  getStartDate() {
    int date = int.parse(stpDate);
    DateTime minStart = DateTime.now().add(Duration(days: 7));

    if (minStart.day > date) {
      stpStartDate = DateTime(minStart.year, minStart.month + 1, date);
    } else
      stpStartDate = DateTime(minStart.year, minStart.month, date);
  }

  String stpDate = "";
  Widget stpDateExpansionTile(BuildContext context) {
    dateList = selectedFreqMap['sip_dates'].toString().split(",");
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: stpDateController,
          title: Text("STP Date", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(stpDate,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Config.appTheme.themeColor)),
            ],
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                for (int i = 0; i < dateList.length; i++)
                  CircularDateCard(
                    dateList[i],
                    isSelected: stpDate == dateList[i],
                    onTap: () {
                      stpDate = dateList[i];
                      getStartDate();
                      // sipDateController.collapse();
                      setState(() {});
                    },
                  ),
              ],
            ),
            Text("Your StP will start from ${convertDtToStr(stpStartDate)}",
                style: AppFonts.f50012
                    .copyWith(color: Config.appTheme.readableGreyTitle)),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget stpEndDateExpansionTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: stpEndDateController,
          title: Text("STP End Date", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(stpEndType, style: AppFonts.f50012),
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
                itemCount: stpEndTypeList.length,
                itemBuilder: (context, index) {
                  String temp = stpEndTypeList[index];

                  return Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: stpEndType,
                        onChanged: (value) {
                          stpEndType = temp;
                          if (stpEndType.contains("Until")) {
                            DateTime now = DateTime.now();
                            stpEndDate =
                                DateTime(now.year + 40, now.month, now.day);
                            stpEndDateController.collapse();
                          }
                          print('endddd  $stpDate');
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
              visible: !stpEndType.contains("Until"),
              child: SizedBox(
                height: 200,
                child: ScrollDatePicker(
                    selectedDate: stpEndDate,
                    minimumDate: DateTime.now().add(Duration(days: 7)),
                    maximumDate: DateTime(2100),
                    onDateTimeChanged: (val) {
                      stpEndDate = val;
                      stpEndType = "${val.day}-${val.month}-${val.year}";
                      setState(() {});
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget installment(BuildContext context) {
    print("transferController $transferController");
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
            child:
                Text("Enter Number of Transfers:", style: AppFonts.f50014Black),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 20, 20),
            child: TextFormField(
              controller: transferController,
              keyboardType: TextInputType.numberWithOptions(),
              onChanged: (value) {
                stpInstallmentValue = value;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Config.appTheme.lineColor, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Config.appTheme.lineColor, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                hintText: 'Enter Number of Transfers',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
