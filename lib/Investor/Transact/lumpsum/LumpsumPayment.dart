import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/lumpsum/LumpsumPaymentSuccess.dart';
import 'package:mymfbox2_0/Investor/Transact/PaymentWebView.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/login/CheckUserType.dart';
import 'package:mymfbox2_0/pojo/NewCartPojo.dart';
import 'package:mymfbox2_0/pojo/UserDataPojo.dart';
import 'package:mymfbox2_0/pojo/transaction/BankInfoPojo.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/CalculateButton.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/MarketTypeCard.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import '../../../rp_widgets/InvAppBar.dart';
import '../../../utils/AppFonts.dart';
import '../../../utils/Config.dart';

class LumpsumPayment extends StatefulWidget {
  const LumpsumPayment({super.key});

  @override
  State<LumpsumPayment> createState() => _LumpsumPaymentState();
}

class _LumpsumPaymentState extends State<LumpsumPayment> {
  int user_id = GetStorage().read('user_id');
  String client_name = GetStorage().read('client_name');
  Map client_code_map = GetStorage().read('client_code_map');

  late Future _dataFuture;
  ExpansionTileController bankController = ExpansionTileController();

  late double devHeight, devWidth;

  BankInfoPojo selectedBank = BankInfoPojo();
  List<BankInfoPojo> bankList = [];

  GetCartByUserIdPojo cart = GetCartByUserIdPojo();
  Result result = Result();

  String paymentMode = "Net Banking";
  String paymentCode = "";

  Future getCartByUserId() async {
    if (cart.msg != null) return 0;

    Map<String, dynamic> data = await InvestorApi.getCartByUserId(
      user_id: user_id,
      investor_id: user_id,
      client_name: client_name,
      purchase_type: PurchaseType.lumpsum,
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
      // arn = arnList.first;
      arn = client_code_map['broker_code'];
    } catch (e) {
      print("getArnList exception = $e");
    }
    return 0;
  }

  String euin = "";
  List euinList = [];

  Future getEuinList() async {
    if (euinList.isNotEmpty) return 0;
    print("arn $arn");
    Map data = await Api.getEuinList(
        client_name: client_name, broker_code: client_code_map['broker_code']);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }

    euinList = data['list'];
    euin = euinList.first;
    return 0;
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

  List mandateList = [];

  Future getMandateList() async {
    if (mandateList.isNotEmpty) return -1;
    Map data = await TransactionApi.getMandateInfo(
      user_id: user_id,
      client_name: client_name,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      investor_code: client_code_map['investor_code'],
      account_number: selectedBank.bankAccountNumber ?? "",
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    mandateList = data['list'];
    if (mandateList.isNotEmpty) {
      selectedMandate = mandateList.first;
    }
    setState(() {});
    return 0;
  }

  Future getPaymentModes() async {
    Map data = await TransactionApi.getPaymentModes(
      user_id: user_id,
      client_name: client_name,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'], purchase_type: 'Lumpsum Purchase',
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    paymentModeList = data['list'];

    for (var map in paymentModeList) {
      if (map['desc'] == paymentMode) {
        paymentCode = map['code'];
        break;
      }
    }

    return 0;
  }

  Future makePayment() async {
    if (paymentMode == "Net Banking" && paymentType == "Immediate Payment") {
      paymentType = "Immediate";
    } else if (paymentMode == "Net Banking" && paymentType == "EMAIL") {
      paymentType = "EMAIL";
    } else {
      paymentType = "";
    }
    EasyLoading.show();
    Map data = await TransactionApi.multipleLumpsumPurchase(
      user_id: user_id,
      client_name: client_name,
      payment_mode: (client_code_map['bse_nse_mfu_flag'] == "BSE") ? "" : paymentCode,
      payment_type: (client_code_map['bse_nse_mfu_flag'] == "BSE") ? "" : paymentType,
      umrn_code: (paymentMode == "Debit Mandate") ? "${selectedMandate['mandate_id']}" : "",
      bank_account_number: "${selectedBank.bankAccountNumber}",
      investor_code: client_code_map['investor_code'],
      cheque_no: (paymentMode == "Cheque" || paymentMode == "Demand Draft")
          ? chequeNo!
          : "",
      cheque_date: (paymentMode == "Cheque" || paymentMode == "Demand Draft")
          ? Utils.getchequeFormattedDate(date: selectedChequeDate)
          : "",
      dd_charge: (paymentMode == "Demand Draft") ? ddCharge! : "",
      broker_code: client_code_map['broker_code'],
      euin_code: euin,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      upi_id: upi,
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
    _dataFuture = getDatas();
  }

  Future getDatas() async {
    if (client_code_map['bse_nse_mfu_flag'].toUpperCase() != "BSE")
    await getPaymentModes();
    await getCartByUserId();
    await getBankList();
    await getArnList();
    await getEuinList();
    if(paymentMode == "Debit Mandate") await getMandateList();
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;

    return FutureBuilder(
        future: _dataFuture,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            extendBody: true,
            appBar: invAppBar(title: "Lumpsum Order Details"),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MarketTypeCard(client_code_map: client_code_map),
                  Divider(height: 0, color: Config.appTheme.lineColor),
                  schemeExpansionTile(context),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        if (client_code_map['bse_nse_mfu_flag'].toUpperCase() !=
                            "BSE")
                          bankExpansionTile(context),
                        SizedBox(height: 16),
                        if (client_code_map['bse_nse_mfu_flag'].toUpperCase() !=
                            "BSE")
                          paymentModeExpansionTile(context),
                        if (client_code_map['bse_nse_mfu_flag'].toUpperCase() !=
                            "BSE")
                          SizedBox(height: 16),
                        if (client_code_map['bse_nse_mfu_flag'].toUpperCase() !=
                            "BSE")
                          extraTile(),
                        SizedBox(height: 16),
                        // DottedLine(verticalPadding: 8),
                        arnExpansionTile(),
                        SizedBox(height: 16),
                        euinExpansionTile(),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  CalculateButton(
                    text: /*(client_code_map['bse_nse_mfu_flag'].toUpperCase() != "BSE")
                        ? "Place Order"
                        : */
                        "Proceed",
                    onPress: () {
                      if (paymentMode == "Cheque" && (chequeNo == null)) {
                        Utils.showError(context, "Enter cheque number");
                        return;
                      }

                      if (paymentMode == "Demand Draft" &&
                          (ddCharge == null || chequeNo == null)) {
                        Utils.showError(context,
                            "Please fill all the Demand Draft details ");
                        return;
                      }

                      confirmAlert();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget extraTile() {
    if (paymentMode == "UPI") return upiInputTile();
    if (paymentMode == "RTGS/NEFT") return upiInputTile();
    if (paymentMode == "RTGS") return upiInputTile();
    if (paymentMode == "NEFT") return upiInputTile();
    if (paymentMode == "Net Banking") return paymentTypeExpansionTile(context);
    if (paymentMode == "Debit Mandate") return mandateExpansionTile();
    if (paymentMode == "Cheque") return chequeTile();
    if (paymentMode == "Demand Draft") return ddTile();
    if (paymentMode == "Instsa UPI") return upiInputTile();

    return Text("Invalid paymentMode = $paymentMode");
  }

  String? chequeNo;

  Widget chequeTile() {
    return Column(
      children: [
        AmountInputCard(
          title: "Cheque/DD Number",
          onChange: (val) => chequeNo = val,
          hasSuffix: false,
          borderRadius: BorderRadius.circular(20),
          maxLength: 6,
          keyboardType: TextInputType.number,
          suffixText: '',
        ),
        SizedBox(height: 16),
        chequeDateExpansionTile(context),
      ],
    );
  }

  ExpansionTileController chequeDatecontroller = ExpansionTileController();
  late DateTime cheque_date;
  DateTime selectedChequeDate = DateTime.now();

  Widget chequeDateExpansionTile(BuildContext context) {
    print("cheque date ${selectedChequeDate.toString()}");

    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: chequeDatecontroller,
            title: Text("Cheque/DD Date", style: AppFonts.f50014Black),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    Utils.getchequeFormattedDate(
                        date: selectedChequeDate ?? cheque_date),
                    style: AppFonts.f50012),
              ],
            ),
            children: [
              SizedBox(
                height: 200,
                child: ScrollDatePicker(
                  selectedDate: selectedChequeDate ?? cheque_date!,
                  maximumDate: DateTime.now().add(Duration(days: 500)),
                  onDateTimeChanged: (value) {
                    setState(() {
                      selectedChequeDate = value;
                    });
                  },
                ),
              ),
            ],
          )),
    );
  }

  String? ddCharge;

  Widget ddTile() {
    return Column(
      children: [
        AmountInputCard(
          title: "Cheque/DD Number",
          onChange: (val) => chequeNo = val,
          hasSuffix: false,
          maxLength: 6,
          borderRadius: BorderRadius.circular(20),
          keyboardType: TextInputType.number,
          suffixText: '',
        ),
        SizedBox(height: 16),
        ddDateExpansionTile(context),
        SizedBox(height: 16),
        AmountInputCard(
          title: "DD Charge",
          onChange: (val) => ddCharge = val,
          hasSuffix: false,
          maxLength: 9,
          borderRadius: BorderRadius.circular(20),
          keyboardType: TextInputType.number,
          suffixText: '',
        ),
      ],
    );
  }

  ExpansionTileController ddDatecontroller = ExpansionTileController();
  late DateTime dd_date;
  DateTime selectedddDate = DateTime.now();

  Widget ddDateExpansionTile(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: ddDatecontroller,
            title: Text("Cheque/DD Date", style: AppFonts.f50014Black),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    Utils.getchequeFormattedDate(
                        date: selectedChequeDate ?? dd_date),
                    style: AppFonts.f50012),
              ],
            ),
            children: [
              SizedBox(
                height: 200,
                child: ScrollDatePicker(
                  selectedDate: selectedChequeDate ?? dd_date!,
                  maximumDate: DateTime.now().add(Duration(days: 500)),
                  onDateTimeChanged: (value) {
                    setState(() {
                      selectedChequeDate = value;
                    });
                  },
                ),
              ),
            ],
          )),
    );
  }

  String upi = "";

  Widget upiInputTile() {
    if (client_code_map['bse_nse_mfu_flag'] != "BSE") return SizedBox();

    return AmountInputCard(
      title: "UPI ID",
      suffixText: "suffixText",
      onChange: (val) => upi = val,
      hasSuffix: false,
      borderRadius: BorderRadius.circular(20),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget schemeExpansionTile(BuildContext context) {
    List schemeList = result.schemeList ?? [];

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        collapsedBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        leading: Image.asset(
          "assets/lumpsumFund.png",
          color: Config.appTheme.themeColor,
          height: 36,
        ),
        title:
            Text("$rupee ${getTotal(schemeList)}", style: AppFonts.f50014Black),
        subtitle: Text("${schemeList.length} Schemes", style: AppFonts.f50012),
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
          Text("Lumpsum : $rupee ${Utils.formatNumber(amount)}",
              style: AppFonts.f50012.copyWith(color: Colors.black)),
        ],
      ),
    );
  }

  ExpansionTileController mandateController = ExpansionTileController();
  Map selectedMandate = {};

  Widget mandateExpansionTile() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: mandateController,
          title: Text("Mandate ID", style: AppFonts.f50014Black),
          subtitle: Text("${selectedMandate['mandate_id'] ?? "No Mandate Available"}",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Config.appTheme.themeColor)),
          childrenPadding: EdgeInsets.only(bottom: 16, right: 16),
          children: [
            ListView.builder(
              itemCount: mandateList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {

                Map mandate = mandateList[index];
                String bankName = mandate['bank_name'];
                String accNo = mandate['bank_account_number'];
                String umrn = mandate['mandate_id'];
                num amount = num.tryParse(mandate['mandate_amount']) ?? 0;


                String tempAccNo = accNo.substring(accNo.length - 4);
                tempAccNo = "**$tempAccNo";

                return Row(
                  children: [
                    Radio(
                        value: mandate,
                        groupValue: selectedMandate,
                        onChanged: (val) async{
                          selectedMandate = mandate;

                          setState(() {});
                        }),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: Config.appTheme.lineColor)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(bankName, style: AppFonts.f50014Black.copyWith(fontSize: 13)),
                                Text("$rupee ${Utils.formatNumber(amount)}",
                                    style:
                                        AppFonts.f40013.copyWith(fontSize: 14))
                              ],
                            ),
                            SizedBox(height: 5),
                            Text("$tempAccNo | UMRN : $umrn")
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 15),
          ],
        ),
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

                      Map result = await makePayment();

                      if (result.isEmpty) return;

                      String url = result['payment_link'];

                      if (shouldOpenWebView()) {
                        Get.back();
                        Get.to(() => PaymentWebView(
                            url: url, paymentId: result['payment_id']));
                      } else {
                        Get.offAll(() => CheckUserType());
                        Get.to(() => LumpsumPaymentSuccess(
                            msg: result['msg'],
                            paymentId: result['payment_id']));
                      }
                    },
                    text: "PLACE ORDER NOW"),
              if (client_code_map['bse_nse_mfu_flag'].toUpperCase() == "BSE")
                CalculateButton(
                    text: "PLACE ORDER NOW",
                    onPress: () async {
                      EasyLoading.showInfo("Processing..");
                      //EasyLoading.show(status: 'loading...'); // Show loading indicator

                      // await Future.delayed(Duration(seconds: 8));
                      Map result = await makePayment();
                      //  EasyLoading.dismiss();

                      if (result.isEmpty) return;
                      Get.offAll(() => CheckUserType());
                      Get.to(() => LumpsumPaymentSuccess(
                            msg: result['msg'],
                            paymentId: result['payment_id'],
                            broker_code: arn,
                            bse_nse_mfu_flag:
                                client_code_map['bse_nse_mfu_flag'],
                            investor_code: client_code_map['investor_code'],
                          ));
                      /*if(result['msg'] == "Authentication") {
                      authmsg = result['msg'];
                      String url = result['payment_link'];
                      if (shouldOpenWebView()) {
                        Get.to(() => BsePaymentWebView(url: url, paymentId: result['payment_id'],purchase_type: "Lumpsum Purchase",));
                      }
                    }*/
                    }),
            ],
          ),
        );
      },
    );
  }

  bool shouldOpenWebView() {
    return paymentMode == "Net Banking" && paymentType == "Immediate" ||
        (client_code_map['bse_nse_mfu_flag'] == 'BSE' &&
            authmsg == "Authentication");
  }

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
              itemCount: bankList.length,
              itemBuilder: (context, index) {
                BankInfoPojo bank = bankList[index];
                String title = getBankTitle(bank);

                return InkWell(
                  onTap: () async {
                    selectedBank = bank;
                    mandateList = [];
                    selectedMandate = {};

                    setState(() {});
                    await getMandateList();

                    bankController.collapse();
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: bank,
                        groupValue: selectedBank,
                        onChanged: (value) async {
                          selectedBank = bank;
                          mandateList = [];
                          selectedMandate = {};

                          setState(() {});
                          await getMandateList();
                          bankController.collapse();
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



  List paymentModeList = [];
  ExpansionTileController paymentModeController = ExpansionTileController();

  Widget paymentModeExpansionTile(BuildContext context) {
    print("paymentCode $paymentCode");
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: paymentModeController,
          title: Text("Payment Mode", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(paymentMode, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: paymentModeList.length,
              itemBuilder: (context, index) {
                Map map = paymentModeList[index];
                String status = map['desc'];
                String statusCode = map['code'];

                return InkWell(
                  onTap: () async {
                    paymentMode = status;
                    paymentCode = statusCode;
                    print("statusCode $paymentCode");
                    paymentModeController.collapse();
                    if(paymentMode == "Debit Mandate") {
                      await getMandateList();
                    }
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: status,
                        groupValue: paymentMode,
                        onChanged: (val) async {
                          paymentMode = status;
                          paymentCode = statusCode;
                          paymentModeController.collapse();
                          if(paymentMode == "Debit Mandate") {
                            await getMandateList();
                          }
                          setState(() {});
                        },
                      ),
                      Text(status, style: AppFonts.f50014Grey),
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

  List paymentTypeList = ["EMAIL", "Immediate Payment"];
  String paymentType = "Immediate Payment";
  ExpansionTileController paymentTypeController = ExpansionTileController();

  Widget paymentTypeExpansionTile(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: paymentTypeController,
          title: Text("Payment Type", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(paymentType,
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
              itemCount: paymentTypeList.length,
              itemBuilder: (context, index) {
                String temp = paymentTypeList[index];
                String displayText = temp;
                if (displayText == "EMAIL") displayText = "Link On Email";

                return InkWell(
                  onTap: () {
                    paymentType = temp;
                    paymentTypeController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: paymentType,
                        onChanged: (value) {
                          paymentType = temp;
                          paymentTypeController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(displayText),
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
               physics: NeverScrollableScrollPhysics(),
              itemCount: euinList.length,
              itemBuilder: (context, index) {
                String temp = euinList[index];

                return InkWell(
                  onTap: () {
                    setState(() {
                      euin = temp;
                    });
                    euinController.collapse();
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: euin,
                        onChanged: (value) {
                          setState(() {
                            euin = temp;
                          });
                          euinController.collapse();
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
}
