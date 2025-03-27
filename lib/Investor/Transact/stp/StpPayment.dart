import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/switch/SwitchPaymentSuccess.dart';
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
import '../PaymentWebView.dart';
import 'StpPaymentSuccess.dart';

class StpPayment extends StatefulWidget {
  const StpPayment({super.key});

  @override
  State<StpPayment> createState() => _StpPaymentState();
}

class _StpPaymentState extends State<StpPayment> {
  int user_id = GetStorage().read('user_id');
  String client_name = GetStorage().read('client_name');
  Map client_code_map = GetStorage().read('client_code_map');

  ExpansionTileController paymentModeController = ExpansionTileController();

  late double devHeight, devWidth;

  BankInfoPojo selectedBank = BankInfoPojo();
  List<BankInfoPojo> bankList = [];
  String amount = "";
  TextEditingController amountController = TextEditingController();

  GetCartByUserIdPojo cart = GetCartByUserIdPojo();
  Result result = Result();
  Future getCartByUserId() async {
    if (cart.msg != null) return 0;

    Map<String, dynamic> data = await InvestorApi.getCartByUserId(
      user_id: user_id,
      investor_id: user_id,
      client_name: client_name,
      purchase_type: PurchaseType.stp,
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

  String iin = "";
  Future getUser() async {
    if (iin.isNotEmpty) return 0;
    Map data =
        await InvestorApi.getUser(user_id: user_id, client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    Map user = data['user'];
    iin = user['nse_iin_number'];

    return 0;
  }

  String bse_nse_mfu_flag = "";
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

  List mandateList = [];
  Future getMandateInfo() async {
    if (mandateList.isNotEmpty) return 0;

    Map data = await TransactionApi.getMandateInfo(
      user_id: user_id,
      client_name: client_name,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      investor_code: client_code_map['investor_code'],
      account_number: "${selectedBank.bankAccountNumber}",
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    mandateList = data['list'];
    //if (mandateList.isNotEmpty) selectedMandate = mandateList.first;
    return 0;
  }

  Future makePayment() async {
    EasyLoading.show();

    String first_order_flag = "Y";
    if (firstPayment.contains("without")) {
      first_order_flag = "N";
    }

    Map data = await TransactionApi.multipleStp(
      user_id: user_id,
      client_name: client_name,
      broker_code: arn,
      euin_code: euin,
      investor_code: client_code_map['investor_code'],
      bank_account_number: "${selectedBank.bankAccountNumber}",
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      first_order_flag: (bse_nse_mfu_flag == 'BSE') ? first_order_flag : " ",
    );


    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return {};
    }
    EasyLoading.dismiss();

    Map result = data['result'];
    data['payment_link'] = result['payment_link'];

    return data;
  }

  @override
  void initState() {
    super.initState();
    arn = client_code_map['broker_code'];
  }

  Future getDatas() async {
    await getCartByUserId();
    await getBankList();
    await getArnList();
    await getEuinList();
    await getUser();
    return 0;
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
            appBar: invAppBar(title: "STP Order Details"),
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
                        DottedLine(verticalPadding: 8),
                        arnExpansionTile(),
                        SizedBox(height: 16),
                        euinExpansionTile(),
                        SizedBox(height: 16),
                        if (client_code_map['bse_nse_mfu_flag'].toUpperCase() ==
                            'BSE')
                          firstPaymentExpansionTile(context),
                        if (client_code_map['bse_nse_mfu_flag'].toUpperCase() ==
                            'MFU')
                          bankExpansionTile(context),
                      ],
                    ),
                  ),
                  CalculateButton(
                    text: "Continue",
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
          "assets/startSTP.png",
          color: Config.appTheme.themeColor,
          height: 36,
        ),
        /*title:
            Text("$rupee ${getTotal(schemeList)}", style: AppFonts.f50014Black),*/
        title: Text("${schemeList.length} Schemes", style: AppFonts.f50012),
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
    num amount = num.parse(scheme.amount ?? "0");

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
              Text("STP : $amount",
                  style: AppFonts.f50012.copyWith(color: Colors.black)),
              Text("${scheme.startDate}", style: AppFonts.f50012)
            ],
          ),
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
              if (client_code_map['bse_nse_mfu_flag'].toUpperCase() != "BSE") CalculateButton(
                  onPress: () async {
                    EasyLoading.showInfo("Processing..");

                    Map result = await makePayment();
                    if (result.isEmpty) return;

                    String url = result['payment_link'];
                      Get.back();
                      Get.to(() => PaymentWebView(url: url, paymentId: result['payment_id']));

                    Get.offAll(() => CheckUserType());
                    Get.to(() => StpPaymentSuccess(
                        msg: result['msg'], paymentId: result['payment_id']));
                  },
                  text: "PLACE ORDER NOW"),

              if (client_code_map['bse_nse_mfu_flag'].toUpperCase() == "BSE") CalculateButton(
                  text: "PLACE ORDER NOW",
                  onPress: ()async{
                    EasyLoading.showInfo("Processing..");
                    EasyLoading.show(status: 'loading...'); // Show loading indicator

                    await Future.delayed(Duration(seconds: 8));
                    Map result = await makePayment();
                    EasyLoading.dismiss();

                    if(result.isEmpty) return;
                    if(result['msg'] == "Authentication") {
                      authmsg = result['msg'];
                      String url = result['payment_link'];
                        Get.to(() => BsePaymentWebView(url: url, paymentId: result['payment_id'],purchase_type: "STP Purchase",));

                    }
                  }),
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
                        onChanged: (value) {},
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

  ExpansionTileController paymentController = ExpansionTileController();
  String firstPayment = "STP with first payment";
  List firstPaymentList = [
    "STP with first payment",
    "STP without first payment",
  ];
  Widget firstPaymentExpansionTile(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: paymentController,
          title: Text("First Payment Option", style: AppFonts.f50014Black),
          subtitle: Text(firstPayment,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Config.appTheme.themeColor)),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: firstPaymentList.length,
              itemBuilder: (context, index) {
                String temp = firstPaymentList[index];

                return InkWell(
                  onTap: () {
                    firstPayment = temp;
                    paymentController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: firstPayment,
                        onChanged: (value) {
                          firstPayment = temp;
                          paymentController.collapse();
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

  getBankTitle(BankInfoPojo bank) {
    String accNo = bank.bankAccountNumber ?? "nullll";
    String endDigit = accNo.substring(accNo.length - 4);

    return "${bank.bankName} (**$endDigit)";
  }

  Map selectedMandate = {};
  ExpansionTileController bankController = ExpansionTileController();
  Widget bankExpansionTile(BuildContext context) {
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
                    mandateList = [];
                    selectedMandate = {};
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
                          mandateList = [];
                          selectedMandate = {};
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
}
