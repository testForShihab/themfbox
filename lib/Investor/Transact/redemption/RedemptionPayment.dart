import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/redemption/RedemptionPaymentSuccess.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/login/CheckAuth.dart';
import 'package:mymfbox2_0/login/CheckUserType.dart';
import 'package:mymfbox2_0/pojo/NewCartPojo.dart';
import 'package:mymfbox2_0/pojo/UserDataPojo.dart';
import 'package:mymfbox2_0/pojo/transaction/BankInfoPojo.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/CalculateButton.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/MarketTypeCard.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../../rp_widgets/InvAppBar.dart';
import '../../../utils/AppFonts.dart';
import '../../../utils/Config.dart';
import '../BsePaymentWebView.dart';

class RedemptionPayment extends StatefulWidget {
  const RedemptionPayment({super.key});

  @override
  State<RedemptionPayment> createState() => _RedemptionPaymentState();
}

class _RedemptionPaymentState extends State<RedemptionPayment> {
  int user_id = GetStorage().read('user_id');
  String client_name = GetStorage().read('client_name');
  Map client_code_map = GetStorage().read('client_code_map');
  bool isExpanded = true ;

  ExpansionTileController paymentModeController = ExpansionTileController();

  late double devHeight, devWidth;

  BankInfoPojo selectedBank = BankInfoPojo();
  List<BankInfoPojo> bankList = [];

  GetCartByUserIdPojo cart = GetCartByUserIdPojo();
  Result result = Result();
  Future getCartByUserId() async {
    if (cart.msg != null) return 0;

    Map<String, dynamic> data = await InvestorApi.getCartByUserId(
      user_id: user_id,
      investor_id: user_id,
      client_name: client_name,
      purchase_type: PurchaseType.redemption,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    cart = GetCartByUserIdPojo.fromJson(data);
    filterByInvestorCode();

    return 0;
  }

  filterByInvestorCode() {
    cart.result!.removeWhere(
        (element) => element.investorCode != client_code_map['investor_code']);

    result = cart.result!.first;
  }

  late String arn;
  List arnList = [];
  Future getArnList() async {
    if (arnList.isNotEmpty) return 0;
    Map data = await Api.getArnList(client_name: client_name);
    try {
      if (data['status'] != 200) {
        Utils.showError(context, data['msg']);
        return 0;
      }
      arnList = [
        data['broker_code_1'],
        data['broker_code_2'],
        data['broker_code_3']
      ];
      arnList.removeWhere((element) => element.isEmpty);
      arn = arnList.first;
    } catch (e) {
      print("getArnList exception = $e");
    }
    return 0;
  }

  String euin = "";
  List euinList = [];
  Future getEuinList() async {
    if (euinList.isNotEmpty) return 0;
    Map data =
        await Api.getEuinList(client_name: client_name, broker_code: arn);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }

    euinList = data['list'];
    euin = euinList.first;
    return 0;
  }

  Future getIinNumber() async {
    Map data =
        await InvestorApi.getUser(user_id: user_id, client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    Map<String, dynamic> user = data['user'];
    UserDataPojo userDataPojo = UserDataPojo.fromJson(user);

    return userDataPojo.nseIinNumber;
  }

  Future getBankList() async {
    if (bankList.isNotEmpty) return 0;

    Map data = await TransactionApi.getBankInfo(
      user_id: user_id,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      investor_code: client_code_map['investor_code'],
      client_name: client_name,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    List list = data['list'];
    convertToObj(list);
    selectedBank = bankList.first;
    return 0;
  }

  convertToObj(List list) {
    list.forEach((element) {
      bankList.add(BankInfoPojo.fromJson(element));
    });
  }

  @override
  void initState() {
    super.initState();
    arn = client_code_map['broker_code'];
    if (client_code_map['bse_nse_mfu_flag'].toUpperCase() == "BSE"){
      isExpanded = false;
    }
  }

  Future getDatas() async {
    await getCartByUserId();
    await getBankList();
    await getArnList();
    await getEuinList();
    return 0;
  }

  Future makePayment() async{
    EasyLoading.show();

    Map data = await TransactionApi.multipleRedemtion(
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      user_id: user_id,
      client_name: client_name,
      bank_account_number: "${selectedBank.bankAccountNumber}",
      investor_code: client_code_map['investor_code'],
      broker_code: arn,
      euin_code: euin,
      bank_name: "${selectedBank.bankName}",
      bank_ifsc_code: "${selectedBank.bankIfscCode}",
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return;
    }
    EasyLoading.dismiss();

    return data;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            extendBody: true,
            appBar: invAppBar(title: "Redemption Order Details"),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MarketTypeCard(client_code_map: client_code_map),
                  Divider(height: 0, color: Config.appTheme.lineColor),
                  schemeExpansionTile(context),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        if (client_code_map['bse_nse_mfu_flag'].toUpperCase() == "BSE")
                        ...[
                          //DottedLine(verticalPadding: 8),
                          bankExpansionTile(context),
                        ],
                          SizedBox(height: 16),
                          arnExpansionTile(),
                          SizedBox(height: 16),
                          euinExpansionTile(),
                      ],
                    ),
                  ),
                  CalculateButton(
                    text: "Proceed",
                    onPress: () {
                      confirmAlert();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget schemeExpansionTile(BuildContext context) {
    List schemeList = result.schemeList ?? [];

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        collapsedBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        leading: Image.asset(
          "assets/redemption.png",
          color: Config.appTheme.themeColor,
          height: 36,
        ),
        /*title:
            Text("$rupee ${getTotal(schemeList)}", style: AppFonts.f50014Black),*/
        title: Text("${schemeList.length} Schemes", style: AppFonts.f50012),
        initiallyExpanded: isExpanded ,
        childrenPadding: EdgeInsets.all(16),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: schemeList.length,
            itemBuilder: (context, index) {
              SchemeList scheme = schemeList[index];

              return schemeCard(scheme);
            },
          )
        ],
      ),
    );
  }

  Widget schemeCard(SchemeList scheme) {
    String amount = "";
    String displayAmount = "";
    if (scheme.amountType == 'Amount') {
      amount = "${scheme.amount}";
      displayAmount = "$rupee $amount";
    }
    else if (scheme.amountType == 'Units') {
      amount = "${scheme.units}";
      displayAmount = "$amount Units";
    }
    else {
      amount = "${scheme.units}";
      displayAmount = "$amount All Units";
    }

    return Container(
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
              )
            ],
          ),
          SizedBox(height: 10),
          Text("Redemption : $displayAmount",
              style: AppFonts.f50012.copyWith(color: Colors.black)),
        ],
      ),
    );
  }

  getTotal(List schemeList) {
    num total = 0;
    for (SchemeList element in schemeList) {
      total += num.tryParse(element.amount ?? "0") ?? 0;
    }
    return Utils.formatNumber(total);
  }

  String authmsg = "";

  confirmAlert() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              BottomSheetTitle(title: "Confirm Order"),
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Config.appTheme.themeColor)),
                child: ColumnText(
                  title: "You are about to place the order.",
                  value: "Please check all the details carefully",
                  titleStyle: AppFonts.f50014Black,
                  valueStyle: AppFonts.f40013,
                ),
              ),
              if (client_code_map['bse_nse_mfu_flag'].toUpperCase() != "BSE")
                CalculateButton(
                  onPress: () async {
                    EasyLoading.showInfo("Processing..");
                    Map response = await makePayment();
                    if (result == null) return;

                    Get.offAll(() => CheckUserType());
                    Get.to(() => RedemptionPaymentSuccess(
                        msg: response['msg'], paymentId: response['payment_id'] ?? ""));
                  },
                  text: "PLACE ORDER NOW"),

              if (client_code_map['bse_nse_mfu_flag'].toUpperCase() == "BSE")
                CalculateButton(
                  onPress: ()async{
                    EasyLoading.showInfo("Processing..");
                    Map response = await makePayment();
                    if (result == null) return;

                    Get.offAll(() => CheckUserType());
                    Get.to(() => RedemptionPaymentSuccess(
                        msg: response['msg'], paymentId: response['payment_id'] ?? "",
                        broker_code:arn,
                        bse_nse_mfu_flag:client_code_map['bse_nse_mfu_flag'],
                        investor_code:client_code_map['investor_code'],
                    ));



                 /* EasyLoading.showInfo("Processing..");
                  EasyLoading.show(status: 'loading...'); // Show loading indicator

                    Map response = await makePayment();
                    Map result = response['result'];
                    String statusMsg = response['status_msg'];
                    String msg = response['msg'];
                    EasyLoading.dismiss();
                    if(response.isEmpty) return;

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("$statusMsg"),
                        content: Text(msg), // Display status_msg here
                        actions: [
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              EasyLoading.show(status: 'loading...');
                              await Future.delayed(Duration(seconds: 8));
                              EasyLoading.dismiss();
                              String url = result['payment_link'];
                              print("url $url");
                              Get.to(() => RedemtionAuthentication(
                                  userid: user_id,
                                  clientname: client_name,
                                  bsensemfuflag: client_code_map['bse_nse_mfu_flag'],
                                  investorcode: client_code_map['investor_code'],
                                  brokercode: arn));

                             // Get.to(() => BsePaymentWebView(url: url, paymentId: response['payment_id'],purchase_type: "Redemption Purchase",));
                            },

                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );*/
                     /* if(response['msg'] == "Authentication") {
                        authmsg = response['msg'];
                        String url = result['payment_link'];
                        print("url $url");
                        Get.to(() => BsePaymentWebView(url: url, paymentId: response['payment_id'],purchase_type: "Redemption Purchase",));

                    }*/
                      },
                  text: "PLACE ORDER NOW"),
            ],
          ),
        );
      },
    );
  }

  ExpansionTileController arnController = ExpansionTileController();
  Widget arnExpansionTile() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: arnController,
          enabled: false,
          title: Text("Select ARN Number", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(arn,
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
              itemCount: arnList.length,
              itemBuilder: (context, index) {
                String temp = arnList[index];

                return InkWell(
                  onTap: () async {
                    arn = temp;
                    arnController.collapse();
                    await getEuinList();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: arn,
                        onChanged: (value) async {
                          arn = temp;
                          arnController.collapse();
                          await getEuinList();
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

  ExpansionTileController euinController = ExpansionTileController();
  Widget euinExpansionTile() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: euinController,
          title: Text("Select EUIN", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(euin,
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
              itemCount: euinList.length,
              itemBuilder: (context, index) {
                String temp = euinList[index];

                return InkWell(
                  onTap: () {
                    euin = temp;
                    euinController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: euin,
                        onChanged: (value) {
                          euin = temp;
                          euinController.collapse();
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

  ExpansionTileController bankController = ExpansionTileController();
  Widget bankExpansionTile(BuildContext context) {
    if (selectedBank.bankName == null)
      return Utils.shimmerWidget(100, margin: EdgeInsets.zero);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: bankController,
          title: Text("Bank Details", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${getBankTitle(selectedBank)}",
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
              itemCount: bankList.length,
              itemBuilder: (context, index) {
                BankInfoPojo bank = bankList[index];
                String title = getBankTitle(bank);

                return InkWell(
                  onTap: () {
                    selectedBank = bank;

                    bankController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: bank,
                        groupValue: selectedBank,
                        onChanged: (value) {
                          selectedBank = bank;
                          bankController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(title),
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

  getBankTitle(BankInfoPojo bank) {
    String accNo = bank.bankAccountNumber ?? "nullll";
    String endDigit = accNo.substring(accNo.length - 4);

    return "${bank.bankName} (**$endDigit)";
  }
}
