import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/transact/cart/MyCart.dart';
import 'package:mymfbox2_0/Investor/transact/cart/RedemptionCart.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/pojo/MfSchemeSummaryPojo.dart';
import 'package:mymfbox2_0/rp_widgets/CalculateButton.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RupeeTf.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class RedemptionAmountInput extends StatefulWidget {
  const RedemptionAmountInput(
      {super.key,
        required this.currValue,
        required this.units,
        required this.schemeAmfiShortName,
        required this.schemeAmfi,
        required this.logo,
        required this.folio});
  final num currValue, units;
  final String schemeAmfiShortName, schemeAmfi;
  final String logo, folio;

  @override
  State<RedemptionAmountInput> createState() => _RedemptionAmountInputState();
}

class _RedemptionAmountInputState extends State<RedemptionAmountInput> {
  String client_name = GetStorage().read('client_name');
  int user_id = GetStorage().read('user_id');
  String marketType = GetStorage().read("marketType");
  Map client_code_map = GetStorage().read('client_code_map');
  List amountTypeList = ["Amount", "Units", "All Units"];
  String trnxType = "Amount";
  TextEditingController amountController = TextEditingController();

  String amount = "";
  late MfSchemeSummaryPojo schemee;
  String scheme_reinvest_tag = '';
  num? currentValue;
  num? totalunits;
  bool isLoading = true;

  Future getRedemtionSchemeHoldingUnits() async {

    Map data = await TransactionApi.getRedemtionSchemeHoldingUnits(
        user_id: user_id, client_name: client_name,
        bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
        folio_no: widget.folio,
        scheme_name: widget.schemeAmfi);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    currentValue = data['result']['current_value'];
    totalunits = data['result']['total_units'];
    isLoading = false;
    return 0;
  }


  @override
  void initState() {
    super.initState();
  }



  List payoutList = ["Dividend Payout", "Dividend Reinvestment"];
  String payout = "Dividend Payout";
  String dividend_code = "Z";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:getRedemtionSchemeHoldingUnits(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: invAppBar(title: "Redemption"),
            body: SideBar(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        schemeInfoCard(),
                        SizedBox(height: 16),
                        amtUnitsInput()
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            bottomSheet: CalculateButton(

                onPress: () async {



                  scheme_reinvest_tag =Utils.getDividendCode(
                      schemeAmfi: widget.schemeAmfi,
                      marketType: client_code_map['bse_nse_mfu_flag'],
                      payout: payout);

                  num tempAmount = num.tryParse(amount) ?? 0;
                  print("tempAmount $tempAmount");
                  print("Amount $amount");
                  if (amount.isEmpty) {
                    Utils.showError(context, "Please enter $trnxType");
                    return;
                  }

                  if (trnxType == 'Units' && tempAmount > totalunits!) {
                    Utils.showError(context, "Max units is ${totalunits}");
                    return;
                  }
                  if (trnxType == 'Amount' && tempAmount > currentValue!) {
                    Utils.showError(context, "Max amount is ${currentValue}");
                    return;
                  }


                  EasyLoading.show();
                  Map data = await TransactionApi.saveCartByUserId(
                    user_id: user_id,
                    client_name: client_name,
                    purchase_type: PurchaseType.redemption,
                    scheme_name: widget.schemeAmfi,
                    scheme_reinvest_tag: Utils.getDividendCode(
                        schemeAmfi: widget.schemeAmfi,
                        marketType: client_code_map['bse_nse_mfu_flag'],
                        payout: payout),
                    folio_no: widget.folio,
                    amount: trnxType.contains("Amount") ? "$tempAmount" : "0",
                    trnx_type: '',
                    cart_id: "",
                    to_scheme_name: "",
                    units: trnxType.contains("Units") ? "$tempAmount" : "0",
                    frequency: "",
                    sip_date: "",
                    start_date: "",
                    end_date: "",
                    total_amount: "$currentValue",
                    total_units: "$totalunits",
                    until_cancelled: "",
                    client_code_map: client_code_map,
                    amount_type: trnxType,
                    context: context,
                  );
                  EasyLoading.dismiss();

                  if (data['status'] != 200) {
                    Utils.showError(context, data['msg']);
                    return;
                  }
                  Get.off(() => MyCart(
                      defaultTitle: "Redemption",
                      defaultPage: RedemptionCart()
                  ));
                  print("tempAmount $tempAmount");
                  print("Amount $amount");
                },
                text: "CONTINUE"),
          );
        }
    );
  }

  Widget amtUnitsInput() {
    // num currValue = widget.currValue;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Redemption Type:",style: AppFonts.f50014Theme.copyWith(color:Colors.black),),
          SizedBox(height: 8),
          SizedBox(
            height: 30,
            child: ListView.builder(
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
                          if (title == "All Units") allUnitSelected();
                          setState(() {});
                          if(title == "Amount" || title == "Units"){
                            amountController.clear();
                            amount = '';
                          }

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
            ),
          ),
          SizedBox(height: 16),
          RupeeTf(
              readOnly: trnxType == 'All Units',
              controller: amountController,
              onChange: (val) => amount = val,
              hintText: "Enter Redemption $trnxType"
          ),
          SizedBox(height: 8),
          /*SizedBox(height: 16),
          Text(
              "Min Redemption of $rupee ${Utils.formatNumber(currValue)}, Multiple of $rupee 1",
              style: AppFonts.f50012
                  .copyWith(color: Config.appTheme.readableGreyTitle))*/
        ],
      ),
    );
  }

  void allUnitSelected() {
    amountController.text = "$totalunits";
    amount = "$totalunits";
  }

  Widget schemeInfoCard() {
    // num currValue = widget.currValue ?? 0;

    return isLoading ?
    Utils.shimmerWidget(100) :
      Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Config.appTheme.themeColor)),
      child: Column(
        children: [
          Row(
            children: [
              Image.network(widget.logo, height: 32),
              SizedBox(width: 10),
              Expanded(
                child: ColumnText(
                  title: widget.schemeAmfiShortName,
                  value: "Folio : ${widget.folio}",
                  titleStyle: AppFonts.f50014Black,
                  valueStyle: AppFonts.f40013,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: ColumnText(
                      title: "Current Value",
                      value: "$rupee  ${Utils.formatNumber(currentValue)}")),
              Expanded(
                  child: ColumnText(
                      title: "Holding Units", value: "$totalunits")),
            ],
          ),
        ],
      ),
    );
  }
}

