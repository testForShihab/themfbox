import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/LumpsumCart.dart';
import 'package:mymfbox2_0/Investor/transact/cart/MyCart.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/rp_widgets/CalculateButton.dart';
import 'package:mymfbox2_0/rp_widgets/MarketTypeCard.dart';
import 'package:mymfbox2_0/rp_widgets/RupeeCard.dart';
import 'package:mymfbox2_0/rp_widgets/SchemeNameCard.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../../rp_widgets/InvAppBar.dart';
import '../../../utils/Constants.dart';

class LumpsumAmountInput extends StatefulWidget {
  const LumpsumAmountInput({
    super.key,
    required this.trnx_type,
    this.folio = "New Folio",
    required this.amc,
    required this.schemeAmfiShortName,
    required this.logo,
    required this.schemeAmfi,
    required this.arn,
    this.isNfo = false,
  });

  final String trnx_type;
  final String schemeAmfi, schemeAmfiShortName;
  final String amc, arn;
  final String folio, logo;
  final bool isNfo;

  @override
  State<LumpsumAmountInput> createState() => _LumpsumAmountInputState();
}

class _LumpsumAmountInputState extends State<LumpsumAmountInput> {
  late double devHeight, devWidth;
  String client_name = GetStorage().read('client_name');
  int user_id = GetStorage().read('user_id');
  String user_name = GetStorage().read('user_name');
  Map client_code_map = GetStorage().read('client_code_map');

  String dividend_code = "";

  List folioList = [];
  late String folio;
  ExpansionTileController folioController = ExpansionTileController();

  num amount = 0;
  num minAmount = 0;
  bool showMinAmount = true;

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

  Future getLumpsumDividendSchemeoptions()async{
    Map data = await TransactionApi.getLumpsumDividendSchemeoptions(
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

  Future getMinAmount() async {
    Map data = await TransactionApi.getLumpsumMinAmount(
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      scheme_name: widget.schemeAmfi,
      purchase_type: (folio.contains('New')) ? "FP" : "AP",
      amount: "$amount",
      client_name: client_name,
      reinvest_tag: dividend_code,
    );

    if (data['status'] != 200) {
      if (!widget.isNfo) Utils.showError(context, data['msg']);
      return -1;
    }

      minAmount = data['min_amount'];


    return 0;
  }

  late String arn;

  Future getDatas() async {
    EasyLoading.show();
    await getLumpsumDividendSchemeoptions();
    await getFolioList();
    await getMinAmount();

     //if (!widget.isNfo) await getLumpsumDividendSchemeoptions();
    // if (!widget.isNfo) await getMinAmount();


    EasyLoading.dismiss();

    return 0;
  }

  @override
  void initState() {
    //  implement initState
    super.initState();

    folio = widget.folio;
    arn = widget.arn;

    setState(() {
      if((widget.isNfo) && (minAmount == 0)){
        showMinAmount = false;
      }else{
        showMinAmount = true;
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          print("Scheme name -------> ${widget.schemeAmfiShortName}");
          print("MinAmount -------> $minAmount");
          print("ShowMinAmount -------> $showMinAmount");
          print("isNfo -------> ${widget.isNfo}");
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            extendBody: true,
            appBar: invAppBar(title: "Lumpsum Purchase"),
            body: SideBar(
              child: SizedBox(
                height: devHeight,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MarketTypeCard(client_code_map: client_code_map),
                      Divider(height: 0),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            SchemeNameCard(
                                logo: widget.logo,
                                shortName: widget.schemeAmfi),
                            SizedBox(height: 16),
                            RupeeCard(
                              title: "Lumpsum Amount",
                              minAmount: minAmount,

                              hintTitle: 'Enter Lumpsum Amount',
                              onChange: (val) =>
                                  amount = num.tryParse(val) ?? 0,
                              showText: showMinAmount,
                            ),
                            payoutExpansionTile(),
                            folioExpansionTile(context),
                            SizedBox(height: 77),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomSheet: CalculateButton(
              text: "CONTINUE",
              onPress: () async {
                String minAmountStr = Utils.formatNumber(minAmount);
                if (amount == 0) {
                  Utils.showError(context, "Please Enter Amount");
                  return;
                }

                if (amount < minAmount) {
                  Utils.showError(
                      context, "Min Amount is $rupee $minAmountStr");
                  return;
                }

                dividend_code = Utils.getDividendCode(
                    schemeAmfi: widget.schemeAmfi,
                    marketType: client_code_map['bse_nse_mfu_flag'],
                    payout: payout);

                //if (widget.isNfo) dividend_code = "";

                EasyLoading.show();

                Map data = await TransactionApi.saveCartByUserId(
                  user_id: user_id,
                  client_name: client_name,
                  purchase_type: PurchaseType.lumpsum,
                  scheme_name: widget.schemeAmfi,
                  scheme_reinvest_tag: dividend_code,
                  folio_no: folio,
                  amount: "$amount",
                  trnx_type:folio.contains('New') ? "FP" : "AP" /*widget.trnx_type*/,
                  cart_id: "",
                  to_scheme_name: "",
                  units: "",
                  frequency: "",
                  sip_date: "",
                  start_date: "",
                  end_date: "",
                  total_amount: "$amount",
                  total_units: "0",
                  client_code_map: client_code_map,
                  until_cancelled: "",
                  context: context,
                  nfo_flag: (widget.isNfo) ? "Y" : "N",
                );

                if (data['status'] != 200) {
                  Utils.showError(context, data['msg']);
                  return;
                }
                Get.off(() => MyCart(
                      defaultPage: LumpsumCart(),
                    ));
                EasyLoading.showToast(data['msg'],
                    toastPosition: EasyLoadingToastPosition.bottom);
              },
            ),
          );
        });
  }

  ExpansionTileController payoutController = ExpansionTileController();
  List payoutList = [];
  String payout = "";

  Widget payoutExpansionTile() {
    // if (widget.isNfo) return SizedBox();
    if(payoutList.isEmpty) return SizedBox();
    payout = payout.isEmpty ? payoutList[0]["dividend_name"] : payout;

    if(payout== "Growth")
    {
      return SizedBox();
    }

    return Container(
      margin: EdgeInsets.only(top: 16),
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
                //String temp = payoutList[index];
                String temp = divTemp['dividend_name'];
                String dividend_temp = divTemp ['dividend_code'];

                return InkWell(
                  onTap: () async {
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



  Widget folioExpansionTile(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
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
              physics: NeverScrollableScrollPhysics(),
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

}
