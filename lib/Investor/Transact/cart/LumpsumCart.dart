import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/ExistingTransaction.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/MyCart.dart';
import 'package:mymfbox2_0/Investor/Transact/lumpsum/NewLumpsumTransaction.dart';
import 'package:mymfbox2_0/Investor/Transact/lumpsum/NfoLumpsum.dart';
import 'package:mymfbox2_0/Investor/transact/lumpsum/LumpsumPayment.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/pojo/NewCartPojo.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import '../../../utils/AppColors.dart';

class LumpsumCart extends StatefulWidget {
  const LumpsumCart({super.key});


  @override
  State<LumpsumCart> createState() => _LumpsumCartState();
}

class _LumpsumCartState extends State<LumpsumCart> {
  String client_name = GetStorage().read("client_name") ?? '';
  int user_id = GetStorage().read('user_id') ?? 0;
  Map client_code_map = GetStorage().read('client_code_map') ?? {};

  num total = 0;
  late double devWidth, devHeight;

  GetCartByUserIdPojo cart = GetCartByUserIdPojo();

  List folioList = [];
  String folio = "New Folio";
  Future getFolioList(SchemeList item) async {
    if (folioList.isNotEmpty) return 0;

    Map data = await TransactionApi.getUserFolio(
      bse_nse_mfu_flag: "${item.vendor}",
      user_id: user_id,
      amc: "${item.schemeCompany}",
      client_name: client_name,
      investor_code: "${item.investorCode}",
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    folioList = data['list'];
    return 0;
  }

  Future getLumpsumDividendSchemeoptions(SchemeList item)async{
    Map data = await TransactionApi.getLumpsumDividendSchemeoptions(
        scheme_name: "${item.schemeName}",
        bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
        client_name: client_name,
        user_id: user_id);

    if(data['status'] != 200){
      Utils.showError(context, data['msg']);
      return -1;
    }
    payoutList = data['result'];
    dividend_code = dividend_code.isEmpty ? payoutList[0]['dividend_code'] : dividend_code;
    print("dividend_code $dividend_code");

    //await getMinAmount();
    return 0;
  }

  Future getMinAmount(SchemeList item) async {
    Map data = await TransactionApi.getLumpsumMinAmount(
      scheme_name: "${item.schemeName}",
      purchase_type: /*(folio.contains('New')) ? "FP" : "AP"*/ "${item.trnxType}",
      bse_nse_mfu_flag: "${item.vendor}",
      amount: "${item.amount}",
      client_name: client_name,
      reinvest_tag: "${item.schemeReinvestTag}",
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    minAmount = data['min_amount'];

    return 0;
  }

  ExpansionTileController folioController = ExpansionTileController();

  Future getCartByUserId() async {
    if (cart.msg != null) return 0;

    Map<String, dynamic> data = await InvestorApi.getCartByUserId(
      user_id: user_id,
      investor_id: user_id,
      client_name: client_name,
      purchase_type: "Lumpsum Purchase",
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
                  //deleteAll(),
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
                carttype: PurchaseType.lumpsum,
                bsensemfu: bsensemfu,
                onDelete: () {
                  Get.back();
                  Get.to(() => MyCart(
                      defaultTitle: "Lumpsum", defaultPage: LumpsumCart()));
                },
              ),
              schemeArea(schemeList, result),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    DottedLine(),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Amount (${schemeList.length} Schemes)",
                          style: AppFonts.f40013.copyWith(fontSize: 16),
                        ),
                        Text("$rupee ${getTotal(schemeList)}",
                            style: AppFonts.f50014Black),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
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
                          text: "Invest Now",
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
          addMoreBottomSheet(result);
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

          Get.to(() => LumpsumPayment());
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
    num amount = num.parse(scheme.amount ?? "0");

    String transaction_type = "";
    print("transaction_type $transaction_type");
    if(scheme.trnxType == "FP"){
      transaction_type = "FRESH";
    }
    if(scheme.trnxType == "AP"){
      transaction_type = "ADDITIONAL";
    }

    return InkWell(
      onTap: () async {
        folioList = [];
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Lumpsum : $rupee ${Utils.formatNumber(amount)}",
                    style: AppFonts.f50012.copyWith(color: Colors.black)),

                Text("Purchase Type : $transaction_type",style: AppFonts.f50012.copyWith(color: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  addMoreBottomSheet(Result result) {
    List list = [
      {
        'img': "assets/existing_trnx.png",
        'title': "Select from Existing Folios",
      },
      {
        'img': "assets/lumpsumFund.png",
        'title': "Select New Scheme",
      },
      {
        'img': "assets/nfoFund.png",
        'title': "Select NFOs",
      },
    ];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: 350,
          child: Column(
            children: [
              BottomSheetTitle(title: "Add more funds to Lumpsum"),
              SizedBox(height: 16),
              ListView.builder(
                itemCount: list.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  Map data = list[index];
                  String title = data['title'];

                  return Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: ListTile(
                      onTap: () async {
                        Map client_code_map = result.toJson();
                        client_code_map.remove('scheme_list');
                        await GetStorage()
                            .write('client_code_map', client_code_map);

                        if (title.contains("Existing"))
                          Get.to(
                              () => ExistingTransaction(cameFrom: "Lumpsum"));
                        if (title.contains("New"))
                          Get.to(() => NewLumpsumTransaction());
                        if (title.contains("NFO")) Get.to(() => NfoLumpsum());
                      },
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      leading: Image.asset(
                        data['img'],
                        height: 32,
                        color: Config.appTheme.themeColor,
                      ),
                      title: Text(title, style: AppFonts.f50014Theme),
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
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
                      defaultTitle: "Lumpsum", defaultPage: LumpsumCart()));
                },
                child: Text('Delete'))
          ],
        );
      },
    );
  }

  num minAmount = 0;
  editBottomSheet(SchemeList item, Result result) async {
    num amount = num.tryParse(item.amount ?? "0") ?? 0;
    folio = item.folioNo ?? "";
    bool? nfoFlag = item.nfoFlag;

    EasyLoading.show();
    await getMinAmount(item);
    await getFolioList(item);
    await getLumpsumDividendSchemeoptions(item);
    EasyLoading.dismiss();
    Map client_code_map = result.toJson();
    client_code_map.remove('scheme_list');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: cornerBorder),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SizedBox(
              height: devHeight - 200,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BottomSheetTitle(title: "Edit Scheme"),
                    Divider(height: 0),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Lumpsum Amount',
                                  style: AppFonts.f50014Black),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  padding: EdgeInsets.fromLTRB(16, 9, 16, 9),
                                  decoration: BoxDecoration(
                                    color: Config.appTheme.mainBgColor,
                                    border: Border(
                                      left: BorderSide(
                                          width: 2,
                                          color: Config.appTheme.lineColor),
                                      top: BorderSide(
                                          width: 2,
                                          color: Config.appTheme.lineColor),
                                      bottom: BorderSide(
                                          width: 2,
                                          color: Config.appTheme.lineColor),
                                    ),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(25),
                                        topLeft: Radius.circular(25)),
                                  ),
                                  child: Text(
                                    rupee,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey),
                                  )),
                              Expanded(
                                child: TextFormField(
                                  maxLength: 9,
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) => amount = num.parse(val),
                                  initialValue: "$amount",
                                  decoration: InputDecoration(
                                      counterText: "",
                                      contentPadding:
                                          EdgeInsets.fromLTRB(16, 8, 16, 8),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Config.appTheme.lineColor,
                                            width: 2),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(25),
                                          bottomRight: Radius.circular(25),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Config.appTheme.lineColor,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(25),
                                          bottomRight: Radius.circular(25),
                                        ),
                                      ),
                                      hintText: 'Enter Lumpsum Amount'),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                         if (minAmount != 0)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  'Min Investment ₹ ${Utils.formatNumber(minAmount)}',
                                  style: AppFonts.f50012
                                      .copyWith(color: AppColors.readableGrey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    if (payoutList.isNotEmpty && payoutList[0]["dividend_name"] != "Growth") 
                      Column(
                        children: [
                          payoutExpansionTile(context, bottomState),
                          SizedBox(height: 16),
                        ],
                      ),
                    folioExpansionTile(context, bottomState, item),
                    SizedBox(height: 16),
                    Container(
                        color: Colors.white,
                        child: CalculateButton(
                          onPress: () async {
                            if (amount < minAmount) {
                              Utils.showError(
                                  context, "Min Amount is $rupee $minAmount");
                              return;
                            }
                            EasyLoading.show();

                            Map data = await TransactionApi.saveCartByUserId(
                                user_id: user_id,
                                client_name: client_name,
                                cart_id: "${item.id}",
                                purchase_type: "${item.purchaseType}",
                                scheme_name: "${item.schemeName}",
                                to_scheme_name: "${item.toSchemeName}",
                                folio_no: folio,
                                amount: "$amount",
                                units: "${item.units}",
                                frequency: "${item.frequency}",
                                sip_date: "${item.sipDate}",
                                start_date: "${item.startDate}",
                                trnx_type: folio.contains("New") ? "FP" : "AP",
                                end_date: "${item.endDate}",
                                scheme_reinvest_tag: dividend_code,
                                total_amount: "$amount",
                                total_units: "${item.totalUnits}",
                                client_code_map: client_code_map,
                                context: context,
                                until_cancelled: '',
                                nfo_flag: (nfoFlag ?? false) ? "Y" : "N",

                            );
                            print("nfo----${item.nfoFlag}");
                            print((nfoFlag ?? false) ? "Y" : "N");
                            print("client_code_map $client_code_map");

                            if (data['status'] != 200) {
                              Utils.showError(context, data['msg']);
                              return;
                            }

                            EasyLoading.dismiss();
                            Get.back();
                            cart.msg = null;
                            setState(() {});
                          },
                          text: "Update",
                        )),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget folioExpansionTile(
      BuildContext context, var bottomState, SchemeList item) {
    final trnxType = "${item.trnxType}";
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: folioController,
        //  enabled: trnxType !="AP",
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
            InkWell(
              onTap: () async {
                folio = "New Folio";
                folioController.collapse();
                await getMinAmount(item);
                bottomState(() {});
              },
              child: Row(
                children: [
                  Radio(
                    value: "New Folio",
                    groupValue: folio,
                    onChanged: (value) async {
                      folio = "New Folio";
                      folioController.collapse();
                      await getMinAmount(item);
                      bottomState(() {});
                    },
                  ),
                  Text("New Folio"),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemCount: folioList.length,
              itemBuilder: (context, index) {
                Map map = folioList[index];
                String tempFolio = map['folio_no'];
                String tempArn = map['broker_code'];

                return InkWell(
                  onTap: () async {
                    folio = tempFolio;
                    folioController.collapse();
                    await getMinAmount(item);
                    bottomState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: tempFolio,
                        groupValue: folio,
                        onChanged: (value) async {
                          folio = tempFolio;
                          folioController.collapse();
                          await getMinAmount(item);
                          bottomState(() {});
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

  ExpansionTileController payoutController = ExpansionTileController();
  List payoutList = [];
  String payout = "";
  String dividend_code ="";

  Widget payoutExpansionTile(BuildContext context, var bottomState) {
    if(payoutList.isEmpty) return SizedBox();
    payout = payout.isEmpty ? payoutList[0]["dividend_name"] : payout;

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
                //String temp = payoutList[index];
                String temp = divTemp['dividend_name'];
                String dividend_temp = divTemp ['dividend_code'];

                return InkWell(
                  onTap: () async {
                    payout = temp;
                    dividend_code = dividend_temp;
                    payoutController.collapse();
                    bottomState(() {});
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
                          bottomState(() {});
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
}
