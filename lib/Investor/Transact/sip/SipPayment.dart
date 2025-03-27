import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/sip/BseSipPayment.dart';
import 'package:mymfbox2_0/Investor/transact/sip/SipPaymentSuccess.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/login/CheckAuth.dart';
import 'package:mymfbox2_0/login/CheckUserType.dart';
import 'package:mymfbox2_0/pojo/NewCartPojo.dart';
import 'package:mymfbox2_0/pojo/transaction/BankInfoPojo.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/CalculateButton.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/MarketTypeCard.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import '../../../rp_widgets/AmountInputCard.dart';
import '../../../rp_widgets/InvAppBar.dart';
import '../../../utils/AppFonts.dart';
import '../../../utils/Config.dart';

class SipPayment extends StatefulWidget {
  const SipPayment({super.key});
  @override
  State<SipPayment> createState() => _SipPaymentState();
}

class _SipPaymentState extends State<SipPayment> {
  int user_id = GetStorage().read('user_id');
  String client_name = GetStorage().read('client_name');
  Map client_code_map = GetStorage().read("client_code_map");

  ExpansionTileController bankController = ExpansionTileController();
  ExpansionTileController paymentController = ExpansionTileController();
  final ExpansionTileController _mandateController = ExpansionTileController();

  late double devHeight, devWidth;

  String firstPayment = "SIP with first payment";
  List firstPaymentList = [
    "SIP with first payment",
    "SIP without first payment",
  ];

  GetCartByUserIdPojo cart = GetCartByUserIdPojo();
  Result result = Result();
  Future getCartByUserId() async {
    if (cart.msg != null) return 0;

    Map<String, dynamic> data = await InvestorApi.getCartByUserId(
      user_id: user_id,
      investor_id: user_id,
      client_name: client_name,
      purchase_type: "SIP Purchase",
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

  Future getPaymentModes() async{
    Map data = await TransactionApi.getPaymentModes(
      user_id: user_id,
      client_name: client_name,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      purchase_type: 'SIP Purchase',
    );
    if(data['status'] != 200){
      Utils.showError(context, data['msg']);
      return -1;
    }
    paymentModeList = data['list'];
    return 0;
  }

  Future makePayment() async {

    if(paymentMode == "Net Banking" && paymentType == "Immediate Payment"){
      paymentType = "Immediate";
    } else if(paymentMode == "Net Banking" && paymentType == "EMAIL"){
      paymentType = "EMAIL";
    }else{
      paymentType = "";
    }

    EasyLoading.show();

    String first_order_flag = "Y";
    if (firstPayment.contains("without")) {
      paymentMode = "Debit Mandate";
      first_order_flag = "N";
    }

    Map data = await TransactionApi.multipleSipPurchase(
      user_id: user_id,
      client_name: client_name,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      investor_code: client_code_map['investor_code'],
      payment_type: paymentType /*(paymentMode == "Net Banking") ? paymentType : ""*/,
      payment_mode: paymentCode,
      umrn_code: selectedMandate['mandate_id'] ?? "",
      bank_account_number: selectedBank.bankAccountNumber!,
      cheque_no: (paymentMode == "Cheque" || paymentMode == "Demand Draft") ? chequeNo! : "",
      cheque_date: (paymentMode == "Cheque") ?  Utils.getchequeFormattedDate(date: selectedChequeDate ?? cheque_date) : "",
      dd_charge: (paymentMode == "Demand Draft") ? ddCharge! : "",
      broker_code: arn,
      euin_code: euin,
      upi_id: "",
      ach_from_date: newMandate ? convertDtToStr(startDate.value) : "",
      ach_to_date: newMandate ? convertDtToStr(endDate.value) : "",
      ach_amount: mandateAmount,
      ach_mandate_id: newMandate ? "New" : "",
      first_order_flag: first_order_flag,
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

  List bankList = [];
  BankInfoPojo selectedBank = BankInfoPojo();
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
    if (mandateList.isNotEmpty) selectedMandate = mandateList.first;
    return 0;
  }

  @override
  void initState() {
    super.initState();
  }

  Future getDatas() async {
    EasyLoading.show();

    await getArnList();
    await getEuinList();
    await getBankList();
    await getMandateInfo();
    await getCartByUserId();
    await getPaymentModes();

    EasyLoading.dismiss();

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;
    if (client_code_map['bse_nse_mfu_flag'] == 'BSE') return BseSipPayment();

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            extendBody: true,
            appBar: invAppBar(title: "SIP Order Details"),
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
                        firstPaymentExpansionTile(context),
                        paymentModeExpansionTile(context),
                        //SizedBox(height: 16),
                        if (client_code_map['bse_nse_mfu_flag'].toUpperCase() != "BSE")...[
                          extraTile(),
                            SizedBox(height: 16),
                          ],

                        bankExpansionTile(context),
                        SizedBox(height: 16),
                        mandateExpansionTile(context),
                        if (newMandate) ...registerMandate(),
                       // DottedLine(verticalPadding: 16),
                        SizedBox(height: 16),
                        arnExpansionTile(),
                        SizedBox(height: 16),
                        euinExpansionTile(),
                      ],
                    ),
                  ),
                  CalculateButton(
                    text: "Invest Now",
                    onPress: () {
                      if (newMandate) {
                        if (mandateAmount == 0) {
                          Utils.showError(
                              context, "Please Enter Mandate Amount");
                          return;
                        }
                      }
                      if (!newMandate && mandateList.isEmpty) {
                        Utils.showError(context, "Please select Mandate");
                        return;
                      }

                      // if (selectedMandate['mandate_approved'] == 0) {
                      //   if (fromDate.contains("Select Start Date")) {
                      //     Utils.showError(context, "Please select Start Date");
                      //     return;
                      //   }
                      //   if (endDate.contains("Select End Cancelled")) {
                      //     Utils.showError(context, "Please Select End Date");
                      //     return;
                      //   }
                      //   if (mandateamount == 0) {
                      //     Utils.showError(
                      //         context, "Please enter the Mandate Amount");
                      //     return;
                      //   }
                      // }
                      confirmAlert();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  List<Widget> registerMandate() {
    return [
      SizedBox(height: 16),
      mandateStartDateTile(),
      SizedBox(height: 16),
      mandateEndDateTile(),
      SizedBox(height: 16),
      mandateAmountTile(),
    ];
  }

  num mandateAmount = 0;
  Widget mandateAmountTile() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              alignment: Alignment.topLeft,
              child: Text("Mandate Amount",
                  style: AppFonts.f50014Black, textAlign: TextAlign.start)),
          SizedBox(height: 16),
          Row(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Config.appTheme.mainBgColor,
                    border: Border(
                      left: BorderSide(
                          width: 1, color: Config.appTheme.lineColor),
                      top: BorderSide(
                          width: 1, color: Config.appTheme.lineColor),
                      bottom: BorderSide(
                          width: 1, color: Config.appTheme.lineColor),
                    ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        topLeft: Radius.circular(16)),
                  ),
                  child: Text(rupee, style: AppFonts.f50014Grey)),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.numberWithOptions(),
                  onChanged: (val) => mandateAmount = num.tryParse(val) ?? 0,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Config.appTheme.lineColor, width: 1),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
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
                      hintText: 'Enter Mandate Amount'),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          /* Container(
            alignment: Alignment.topLeft,
            child: InkWell(
                onTap: () {
                  showAboutSheet();
                },
                child: Text(
                  "Learn about Mandate Limit ?",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Config.appTheme.themeColor),
                )),
          ),*/
        ],
      ),
    );
  }

  Widget extraTile() {
    if (firstPayment.contains("without")) return SizedBox();
    if (paymentMode == "UPI") return upiInputTile();
    if (paymentMode == "RTGS/NEFT") return upiInputTile();
    if (paymentMode == "RTGS") return upiInputTile();
    if (paymentMode == "NEFT") return upiInputTile();
    if (paymentMode == "Online") return upiInputTile();
    if (paymentMode == "Net Banking") return upiInputTile();
    if (paymentMode == "Debit Mandate") return mandateExpansionTile(context);
    if(paymentMode == "Cheque") return chequeTile();
    if(paymentMode == "Demand Draft") return ddTile();
    if(paymentMode == "Instsa UPI") return upiInputTile();

    return Text("Invalid paymentMode = $paymentMode");
  }

  List paymentTypeList = ["EMAIL", "Immediate Payment"];
  String paymentType = "Immediate";
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
          keyboardType: TextInputType.number, suffixText: '',
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
                    Utils.getchequeFormattedDate(date: selectedChequeDate ?? cheque_date),
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
          title: "Cheque Number",
          onChange: (val) => chequeNo = val,
          hasSuffix: false,
          maxLength: 6,
          borderRadius: BorderRadius.circular(20),
          keyboardType: TextInputType.number, suffixText: '',
        ),
        SizedBox(height: 16),
        ddDateExpansionTile(context),
        SizedBox(height: 16),
        AmountInputCard(
          title: "DD Charge",
          onChange: (val) => ddCharge = val,
          hasSuffix: false,
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
                    Utils.getchequeFormattedDate(date: selectedddDate ?? dd_date),
                    style: AppFonts.f50012),
              ],
            ),
            children: [
              SizedBox(
                height: 200,
                child: ScrollDatePicker(
                  selectedDate: selectedddDate ?? dd_date!,
                  maximumDate: DateTime.now().add(Duration(days: 500)),
                  onDateTimeChanged: (value) {
                    setState(() {
                      selectedddDate = value;
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
              // Image.network("${scheme.schemeLogo}", height: 32),
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
          Text("Amount : $rupee ${Utils.formatNumber(amount)}",
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

  ExpansionTileController paymentModeController = ExpansionTileController();
  String paymentMode = "";
  String paymentCode = "";
  List paymentModeList = [];
  Widget paymentModeExpansionTile(BuildContext context) {
    if (firstPayment.contains("without")) return SizedBox();
    if(client_code_map['bse_nse_mfu_flag'] == "MFU"){
      paymentMode = "Net Banking";
      paymentCode = "Net Banking";
    }else if((client_code_map['bse_nse_mfu_flag'] == "NSE")){
      paymentMode = "Online";
      paymentCode = "Online";
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
              Text(paymentMode,
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
              itemCount: paymentModeList.length,
              itemBuilder: (context, index) {
                Map map = paymentModeList[index];
                String status = map['desc'];
                String status_code = map['code'];


                return InkWell(
                  onTap: () {
                    paymentMode = status;
                    paymentCode = status_code;
                    paymentModeController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: status,
                        groupValue: paymentMode,
                        onChanged: (value) {
                          paymentMode = status;
                          paymentCode = status_code;
                          paymentModeController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(status, style: AppFonts.f50014Black),
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

  Map selectedMandate = {};
  bool newMandate = false;

  Widget mandateExpansionTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          //controller: _mandateController,
          title: Text("Mandate ID", style: AppFonts.f50014Black),
          subtitle: Text(
            "${selectedMandate['mandate_id'] ?? "Mandate Not Available"}",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Config.appTheme.themeColor
            )
          ),
          childrenPadding: EdgeInsets.only(bottom: 16, right: 16),
          children: [
            if (mandateList.isEmpty)
              newMandateTile()
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: mandateList.length,
                itemBuilder: (context, index) {
                  Map mandate = mandateList[index];
                  String bankName = mandate['bank_name'];
                  String accNo = mandate['bank_account_number'];
                  String umrn = mandate['mandate_id'];
                  String amount = mandate['mandate_amount'];

                  String tempAccNo = accNo.substring(accNo.length - 4);
                  tempAccNo = "**$tempAccNo";

                  return Row(
                    children: [
                      Radio(
                        value: mandate,
                        groupValue: selectedMandate,
                        onChanged: (val) {
                          setState(() {
                            selectedMandate = mandate;
                          });
                        }
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Config.appTheme.lineColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(bankName, style: AppFonts.f50014Black),
                                  Text("$rupee $amount", style: AppFonts.f40013.copyWith(fontSize: 14)),
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

          ],
        ),
      ),
    );
  }

  Widget newMandateTile() {
    return Row(
      children: [
        Radio(
          value: true,
          groupValue: newMandate,
          onChanged: (value) {
            if (newMandate) return;
            newMandate = true;
            setState(() {});
          },
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              if (newMandate) return;
              newMandate = true;
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Config.appTheme.lineColor)),
              child: Text("Generate a New Mandate(Physical) to Register a SIP Investment",
                  style: AppFonts.f50014Black),
            ),
          ),
        ),
      ],
    );
  }

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

  ExpansionTileController startDateController = ExpansionTileController();
  Rx<DateTime> startDate = DateTime.now().add(Duration(days: 1)).obs;

  Widget mandateStartDateTile() {
    int endYear = DateTime.now().year + 40;
    int day = DateTime.now().day;
    int month = DateTime.now().month;
    int year = DateTime.now().year;

    return Obx(() {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: startDateController,
            title: Text("Mandate Start Date", style: AppFonts.f50014Black),
            subtitle: Text(Utils.getFormattedDate(date: startDate.value),
                style: AppFonts.f50012),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                child: ScrollDatePicker(
                    selectedDate: startDate.value,
                    minimumDate:
                        DateTime(year, month, day).add(Duration(days: 0)),
                    maximumDate: DateTime(endYear),
                    onDateTimeChanged: (val) {
                      startDate.value = val;
                    }),
              )
            ],
          ),
        ),
      );
    });
  }

  ExpansionTileController endDateController = ExpansionTileController();
  Rx<DateTime> endDate = DateTime.now().add(Duration(days: 365 * 40)).obs;

  Widget mandateEndDateTile() {
    int endYear = DateTime.now().year + 40;
    int day = DateTime.now().day;
    int month = DateTime.now().month;
    int year = DateTime.now().year;
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: endDateController,
            title: Text("Mandate End Date", style: AppFonts.f50014Black),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Utils.getFormattedDate(date: endDate.value),
                    style: AppFonts.f50012),
              ],
            ),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                child: ScrollDatePicker(
                    selectedDate: endDate.value,
                    minimumDate:
                        DateTime(year, month, day).add(Duration(days: 7)),
                    maximumDate: DateTime(endYear),
                    onDateTimeChanged: (val) {
                      endDate.value = val;
                    }),
              )
            ],
          ),
        ),
      );
    });
  }

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
              CalculateButton(
                  onPress: () async {
                    Map result = await makePayment();
                    if (result.isEmpty) return;

                    Get.offAll(() => CheckUserType());
                    Get.to(() => SipPaymentSuccess(
                        msg: result['msg'], paymentId: result['payment_id']));
                  },
                  text: "PLACE ORDER NOW")
            ],
          ),
        );
      },
    );
  }

  bool shouldOpenWebView() {
    return paymentMode == "Net Banking" &&
        client_code_map['bse_nse_mfu_flag'] != 'BSE';
  }

  ExpansionTileController arnController = ExpansionTileController();
  Widget arnExpansionTile() {
    if (arnList.isEmpty) return SizedBox();

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

  getMandateTitle(Map mandate) {
    String bank = mandate['bank_name'];
    String umrn = mandate['mandate_id'];

    return "$bank (UMRN: $umrn)";
  }

}
