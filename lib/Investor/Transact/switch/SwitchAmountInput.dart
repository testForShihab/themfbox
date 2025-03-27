import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/transact/cart/MyCart.dart';
import 'package:mymfbox2_0/Investor/transact/cart/SwitchCart.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/rp_widgets/CalculateButton.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RupeeTf.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class SwitchAmountInput extends StatefulWidget {
  const SwitchAmountInput({
    super.key,
    required this.fromSchemeAmfiShortName,
    required this.fromSchemeAmfi,
    required this.toSchemeAmfiShortName,
    required this.totalAmount,
    required this.totalUnits,
    required this.toSchemeAmfi,
    required this.folio,
    required this.logo,
    this.isNfo = false,
  });
  final String fromSchemeAmfiShortName;
  final String fromSchemeAmfi;
  final String toSchemeAmfiShortName;
  final String toSchemeAmfi;
  final num totalAmount, totalUnits;
  final String folio;
  final String logo;
  final bool isNfo;
  @override
  State<SwitchAmountInput> createState() => _SwitchAmountInputState();
}

class _SwitchAmountInputState extends State<SwitchAmountInput> {

  String client_name = GetStorage().read('client_name');
  int user_id = GetStorage().read('user_id');
  Map client_code_map = GetStorage().read('client_code_map');

  List amountTypeList = ["Amount", "Units", "All Units"];
  String amount = "";
  String trnxType = "Amount";
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    //  implement initState
    super.initState();
  }

  late double devHeight, devWidth;
  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: invAppBar(title: "Switch"),
      body: SideBar(
        child: SizedBox(
          height: devHeight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      schemeInfoCard(),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                              child: ListView.separated(
                                itemCount: amountTypeList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  String title = amountTypeList[index];
                                  bool isSelected = title == trnxType;

                                  return Row(
                                    children: [
                                      Radio(
                                          value: title,
                                          groupValue: trnxType,
                                          onChanged: (val) {
                                            trnxType = title;
                                            if (title == "All Units")
                                              allUnitSelected();
                                            else {
                                              amountController.clear();
                                              amount = "";
                                            }
                                            setState(() {});
                                          }),
                                      Text(
                                        title,
                                        style: (isSelected)
                                            ? AppFonts.f50014Theme
                                            : AppFonts.f50014Grey,
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        SizedBox(width: 5),
                              ),
                            ),
                            SizedBox(height: 16),
                            RupeeTf(
                                readOnly: trnxType == 'All Units',
                                controller: amountController,
                                onChange: (val) => amount = val,
                                hintText: "Enter $trnxType to Switch"),
                            SizedBox(height: 16),
                            Text(
                                "Max Switch (Amount - $rupee ${widget.totalAmount}, Units - ${widget.totalUnits})",
                                style: AppFonts.f50012.copyWith(
                                    color: Config.appTheme.readableGreyTitle))
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      toPayoutExpansionTile(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: CalculateButton(
          onPress: () async {
            if (amount.isEmpty) {
              Utils.showError(context, "Please enter $trnxType");
              return;
            }
            num tempAmount = num.tryParse(amount) ?? 0;
            if (trnxType == 'Units' && tempAmount > widget.totalUnits) {
              Utils.showError(context, "Max units is ${widget.totalUnits}");
              return;
            }
            if (trnxType == 'Amount' && tempAmount > widget.totalAmount) {
              Utils.showError(context, "Max amount is ${widget.totalAmount}");
              return;
            }

            int res = await saveCartByUserId(tempAmount, context);
            if (res == -1) return;

            Get.off(() => MyCart(
                  defaultTitle: "Switch",
                  defaultPage: SwitchCart(),
                ));
          },
          text: "CONTINUE"),
    );
  }

  Future saveCartByUserId(num tempAmount, BuildContext context) async {
    String fromDividendCode = Utils.getDividendCode(
        schemeAmfi: widget.fromSchemeAmfi,
        marketType: client_code_map['bse_nse_mfu_flag'],
        payout: fromPayout);
    String toDividendCode = Utils.getDividendCode(
        schemeAmfi: widget.toSchemeAmfi,
        marketType: client_code_map['bse_nse_mfu_flag'],
        payout: toPayout);

    EasyLoading.show();
    Map data = await TransactionApi.saveCartByUserId(
      user_id: user_id,
      client_name: client_name,
      cart_id: "",
      purchase_type: PurchaseType.switchPurchase,
      scheme_name: widget.fromSchemeAmfi,
      to_scheme_name: widget.toSchemeAmfi,
      folio_no: widget.folio,
      amount: trnxType.contains("Units") ? "0" : "$tempAmount",
      units: !trnxType.contains("Units") ? "" : "$tempAmount",
      frequency: "",
      sip_date: "",
      start_date: "",
      end_date: "",
      trnx_type: "",
      until_cancelled: "",
      total_amount: "${widget.totalAmount}",
      total_units: "${widget.totalUnits}",
      scheme_reinvest_tag: fromDividendCode,
      to_scheme_reinvest_tag: toDividendCode,
      client_code_map: client_code_map,
      context: context,
      amount_type: trnxType,
    );
    EasyLoading.dismiss();

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
    // if (widget.isNfo) return SizedBox();

    String schemeAmfi = widget.toSchemeAmfi;
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
    // if (widget.isNfo) return SizedBox();

    String schemeAmfi = widget.fromSchemeAmfi;
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
    amountController.text = "${widget.totalUnits}";
    amount = "${widget.totalUnits}";
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
              Expanded(child: Text(widget.toSchemeAmfiShortName))
            ],
          )
        ],
      ),
    );
  }
}
