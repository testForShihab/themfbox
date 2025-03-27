import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/ExistingTransaction.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/MyCart.dart';
import 'package:mymfbox2_0/Investor/Transact/switch/SwitchPayment.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/pojo/NewCartPojo.dart';
import 'package:mymfbox2_0/rp_widgets/RupeeTf.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class SwitchCart extends StatefulWidget {
  const SwitchCart({super.key});

  @override
  State<SwitchCart> createState() => _SwitchCartState();
}

class _SwitchCartState extends State<SwitchCart> {
  String client_name = GetStorage().read("client_name");
  int user_id = GetStorage().read('user_id');

  num total = 0;
  late double devWidth, devHeight;

  GetCartByUserIdPojo cart = GetCartByUserIdPojo();

  ExpansionTileController folioController = ExpansionTileController();

  Future getCartByUserId() async {
    if (cart.msg != null) return 0;

    Map<String, dynamic> data = await InvestorApi.getCartByUserId(
      user_id: user_id,
      investor_id: user_id,
      client_name: client_name,
      purchase_type: PurchaseType.switchPurchase,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    cart = GetCartByUserIdPojo.fromJson(data);

    return 0;
  }

  @override
  void initState() {
    //  implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;
    return FutureBuilder(
        future: getCartByUserId(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            // appBar: invAppBar(title: "Lumpsum Cart"),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  overallArea(),
                  SizedBox(height: 16),
                ],
              ),
            ),
          );
        });
  }

  Widget overallArea() {
    List? overallList = cart.result;
    if (overallList == null)
      return Utils.shimmerWidget(200, margin: EdgeInsets.all(16));
    if (overallList.isEmpty)
      return Center(
          child: Padding(
        padding: EdgeInsets.only(top: 16),
        child: EmptyCart(),
      ));

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: overallList.length,
      itemBuilder: (context, index) {
        Result result = overallList[index];
        List<SchemeList> schemeList = result.schemeList ?? [];
          String? bsensemfu = result.bseNseMfuFlag ;
          print("bsensemfu $bsensemfu");

        return Container(
          color: Colors.white,
          child: Column(
            children: [
              MarketTypeCard(client_code_map: result.toJson()),
              Divider(height: 0, color: Config.appTheme.lineColor),
              DeleteAllCart(
                carttype: PurchaseType.switchPurchase,
                bsensemfu: bsensemfu,
                onDelete: () {
                  Get.back();
                  Get.to(() => MyCart(
                      defaultTitle: "Switch", defaultPage: SwitchCart()));
                },
              ),
              schemeArea(schemeList, result),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (result.bseNseMfuFlag == "NSE")
                          Expanded(
                              child: getButton(
                            type: ButtonType.plain,
                            text: "ADD MORE",
                            result: result,
                          )),
                        SizedBox(width: 10),
                        Expanded(
                            child: getButton(
                          type: ButtonType.filled,
                          text: "CONTINUE",
                          result: result,
                        ))
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              )
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(height: 16),
    );
  }

  String amountType = "";
  editBottomSheet(SchemeList scheme, Result result) async {
    amountType = "${scheme.amountType}";
    num totalAmount = num.tryParse(scheme.totalAmount ?? "0") ?? 0;
    num totalUnits = num.tryParse(scheme.totalUnits ?? "0") ?? 0;
    if (amountType == 'Amount') {
      amount = "${scheme.amount}";
      amountController.text = "${scheme.amount}";
    } else {
      amount = "${scheme.units}";
      amountController.text = "${scheme.units}";
    }
    Map client_code_map = result.toJson();
    client_code_map.remove('scheme_list');

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return Column(
              children: [
                BottomSheetTitle(title: "Edit"),
                amtUnitsInput(scheme, bottomState),
                CalculateButton(
                    onPress: () async {
                      num tempAmount = num.tryParse(amount) ?? 0;
                      if (amount.isEmpty) {
                        Utils.showError(context, "Please enter $amountType");
                        return;
                      }
                      if (amountType == 'Amount' && tempAmount > totalAmount) {
                        Utils.showError(context, "Max amount is $totalAmount");
                        return;
                      }
                      if (amountType == 'Units' && tempAmount > totalUnits) {
                        Utils.showError(context, "Max units is $totalUnits");
                        return;
                      }

                      int res = await saveCartByUserId(
                          tempAmount: tempAmount,
                          context: context,
                          scheme: scheme,
                          client_code_map: client_code_map);
                      if (res == -1) return;

                      Get.back();
                      cart.msg = null;
                      setState(() {});
                    },
                    text: "UPDATE"),
              ],
            );
          },
        );
      },
    );
  }

  Future saveCartByUserId({
    required num tempAmount,
    required BuildContext context,
    required SchemeList scheme,
    required Map client_code_map,
  }) async {
    EasyLoading.show();
    Map data = await TransactionApi.saveCartByUserId(
      user_id: user_id,
      client_name: client_name,
      cart_id: "${scheme.id}",
      purchase_type: PurchaseType.switchPurchase,
      scheme_name: "${scheme.schemeName}",
      to_scheme_name: "${scheme.toSchemeName}",
      folio_no: "${scheme.folioNo}",
      amount: amountType.contains("Units") ? "0" : "$tempAmount",
      units: !amountType.contains("Units") ? "" : "$tempAmount",
      frequency: "",
      sip_date: "",
      start_date: "",
      end_date: "",
      trnx_type: "",
      until_cancelled: "",
      total_amount: "${scheme.totalAmount}",
      total_units: "${scheme.totalUnits}",
      scheme_reinvest_tag: "${scheme.schemeReinvestTag}",
      to_scheme_reinvest_tag: "${scheme.toSchemeReinvestTag}",
      client_code_map: client_code_map,
      context: context,
      amount_type: amountType,
    );
    EasyLoading.dismiss();

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    return 0;
  }

  List amountTypeList = ["Amount", "Units", "All Units"];
  String amount = "";
  TextEditingController amountController = TextEditingController();

  Widget amtUnitsInput(SchemeList item, Function bottomState) {
    num? totalAmount = num.tryParse(item.totalAmount ?? "0");

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            child: ListView.builder(
              itemCount: amountTypeList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                String title = amountTypeList[index];
                bool isSelected = title == amountType;

                return Row(
                  children: [
                    Radio(
                        value: title,
                        groupValue: amountType,
                        onChanged: (val) {
                          amountType = title;
                          if (title == "All Units") allUnitSelected(item);
                          bottomState(() {});
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
              readOnly: amountType == 'All Units',
              controller: amountController,
              onChange: (val) => amount = val,
              hintText: "Enter Redemption $amountType"),
          SizedBox(height: 8),
          /*SizedBox(height: 16),
          Text("Min Redemption of $rupee $totalAmount, Multiple of $rupee 1",
              style: AppFonts.f50012
                  .copyWith(color: Config.appTheme.readableGreyTitle))*/
        ],
      ),
    );
  }

  void allUnitSelected(SchemeList item) {
    amountController.text = "${item.totalUnits}";
    amount = "${item.totalUnits}";
  }

  getTotal(List schemeList) {
    num total = 0;
    for (SchemeList element in schemeList) {
      total += num.tryParse(element.amount ?? "0") ?? 0;
    }
    return Utils.formatNumber(total);
  }

  Widget getButton({
    required ButtonType type,
    required String text,
    required Result result,
  }) {
    EdgeInsets padding = EdgeInsets.symmetric(horizontal: 12, vertical: 16);

    if (type == ButtonType.plain) {
      return PlainButton(
        text: text,
        padding: padding,
        onPressed: () {
          Get.to(ExistingTransaction());
        },
      );
    } else {
      return RpFilledButton(
        text: text,
        padding: padding,
        onPressed: () async {
          Map client_code_map = result.toJson();
          client_code_map.remove('scheme_list');
          await GetStorage().write('client_code_map', client_code_map);

          if (result.schemeList!.length > 1 &&
              client_code_map['bse_nse_mfu_flag'] != "NSE")
            return Utils.showError(context,
                "Multiple Switchs are not allowed. Please select only one scheme.");

          Get.to(() => SwitchPayment());
        },
      );
    }
  }

  Widget schemeArea(List<SchemeList> schemeList, Result result) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: schemeList.length,
        itemBuilder: (context, index) {
          SchemeList scheme = schemeList[index];

          return schemeCard(scheme, result);
        },
      ),
    );
  }

  Widget schemeCard(SchemeList scheme, Result result) {
    String displayAmount = "";
    if (scheme.amountType == 'Amount') {
      amount = "${scheme.amount}";
      displayAmount = "$rupee $amount";
      if (!mounted) amountController.text = "${scheme.amount}";
    } else {
      amount = "${scheme.units}";
      displayAmount = "$amount Units";
      if (!mounted) amountController.text = "${scheme.units}";
    }

    return InkWell(
      onTap: () async {
        editBottomSheet(scheme, result);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Config.appTheme.themeColor,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Image.network("${scheme.schemeLogo}", height: 32),
                Utils.getImage("${scheme.schemeLogo}", 32),
                SizedBox(width: 10),
                Expanded(
                  child: ColumnText(
                    title: "${scheme.schemeName}",
                    value: "Folio : ${scheme.folioNo}",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013,
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      await deleteAlert(scheme);
                    },
                    icon: Icon(Icons.delete_forever))
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
                Expanded(child: Text("${scheme.toSchemeAmfiShortName}"))
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Switch : $displayAmount",
                    style: AppFonts.f50012.copyWith(color: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  deleteAlert(SchemeList item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete"),
          content: Text("Are you sure to delete ?"),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('Cancel')),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Config.appTheme.themeColor,
                    foregroundColor: Colors.white),
                onPressed: () async {
                  Map data = await InvestorApi.deleteCartById(
                      user_id: user_id,
                      client_name: client_name,
                      investor_id: user_id,
                      context: context,
                      cart_id: item.id ?? 0);
                  if (data['status'] != 200) {
                    Utils.showError(context, data['msg']);
                    return;
                  }
                  Get.back();
                  EasyLoading.showToast(data['msg'],
                      toastPosition: EasyLoadingToastPosition.bottom);

                  cart.msg = null;

                  Get.back();
                  Get.to(() => MyCart(
                      defaultTitle: "Switch", defaultPage: SwitchCart()));
                },
                child: Text('Delete'))
          ],
        );
      },
    );
  }
}
