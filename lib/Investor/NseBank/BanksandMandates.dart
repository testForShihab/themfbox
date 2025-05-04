import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import '../../api/Api.dart';
import '../../api/onBoarding/CommonOnBoardApi.dart';
import '../../rp_widgets/AmountInputCard.dart';
import '../../rp_widgets/BottomSheetTitle.dart';
import '../../rp_widgets/CalculateButton.dart';
import '../../rp_widgets/ColumnText.dart';
import '../../rp_widgets/DottedLine.dart';
import '../../rp_widgets/InvAppBar.dart';
import '../../rp_widgets/RpSmallTf.dart';
import '../../utils/AppColors.dart';
import '../../utils/AppFonts.dart';
import '../../utils/Constants.dart';
import '../../utils/Utils.dart';
import 'MandateSuccess.dart';
import 'package:image_picker/image_picker.dart';

class BanksandMandates extends StatefulWidget {
  const BanksandMandates({super.key});

  @override
  State<BanksandMandates> createState() => _BanksandMandatesState();
}

class _BanksandMandatesState extends State<BanksandMandates> {
  final BanksmandateController controller = Get.put(BanksmandateController());
  late double devWidth, devHeight;
  String? name = GetStorage().read('user_name');
  String? pan = GetStorage().read("user_pan");

  // Add debounce timer
  Timer? _debounce;
  
  // Add debounced API call method
  // void _debouncedApiCall(String value) {
  //   if (_debounce?.isActive ?? false) _debounce?.cancel();
  //   _debounce = Timer(const Duration(milliseconds: 500), () {
  //     // Only make API call if the value has changed
  //     final newValue = int.tryParse(value) ?? 0;
  //     if (newValue != controller.mandateamount.value) {
  //       controller.updateMandateAmount(value);
  //     }
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   _debounce?.cancel();
  //   super.dispose();
  // }

  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  Map client_code_map = GetStorage().read('client_code_map') ?? {};

  String tax_status = GetStorage().read("tax_status");

  bool isLoading = true;

  ExpansionTileController bankController = ExpansionTileController();
  ExpansionTileController accountTypeController = ExpansionTileController();
  ExpansionTileController bankProofController = ExpansionTileController();
  DateTime startDate = DateTime.now();
  DateTime mfustartDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 2);
  List accountTypeList = [];

  String bankCode = "";
  String accountType = "Savings Account";
  String accountTypeCode = "SB";

  Map bankProofMap = {
    "Latest Bank Passbook": "14",
    "Latest Bank Account Statement": "15",
    "Cheque Copy": "77",
    "Bank Letter": "78"
  };

  String proofType = "Latest Bank Passbook";
  String proofTypeCode = "14";

  String ifsc = "",
      micr = "",
      bankName = "",
      branchName = "",
      bankAddress = "",
      accNumber = "",
      accHolderName = "",
      accDesc = "desc";

  Map selectedMandate = {};
  List mandateList = [];

  String arn = "";
  List arnList = [];

  ExpansionTileController mandateTypeController = ExpansionTileController();
  ExpansionTileController mandateOptController = ExpansionTileController();
  ExpansionTileController fromDateController = ExpansionTileController();
  ExpansionTileController mandateEndDateController = ExpansionTileController();
  ExpansionTileController createDeleteController = ExpansionTileController();



  String fromDate = "Select Start Date";
  String mandateEndDate = "Until Cancelled";


  // String mandateType = "E-Mandate";
  // String mandateTypecode = "E";
  // num mandateamount = 0;
  num minAmount = 0;

  List mandateTypeList = [];
  List mandateEndDateList = ["Until Cancelled", "Specific Date"];

  // Add a map to track uploaded files for each bank account
  Map<String, File?> bankChequeFiles = {};
  late Future future;

  // void _refreshData() {
  //   setState(() {
  //     future = getDatas();
  //   });
  // }

  @override
  void initState() {
    super.initState();
    future = getDatas();
    // Set initial values for all expansion tiles
    // mandateType = "E-Mandate"; // Default mandate type
    // mandateTypecode = "E"; // Default mandate type code

    // paymentMode = "NACH"; // Default payment mode
    // paymentModecode = "01"; // Default payment mode code

    //fromDate = "${startDate.day}-${startDate.month}-${startDate.year}";

    fromDate = convertDtToStr(startDate); // Default start date

    // Set initial end dates
    DateTime now = DateTime.now();
    endDate = DateTime(
        now.year + 40, now.month, now.day - 1); // Default end date for NSE/MFU
    bseendDate = DateTime(
        now.year + 40, now.month, now.day - 1); // Default end date for BSE
    //toDate = "${bseendDate.day}-${bseendDate.month}-${bseendDate.year}"; // Default BSE end date string
    toDate = convertDtToStr(bseendDate);
    mandateEndDate = "Until Cancelled";
    sipEndType = "Until Cancelled";

    // Set initial ARN if available
    if (client_code_map['broker_code'] != null) {
      arn = client_code_map['broker_code'];
    }

    getDatas().then((_) {
      if (euinList.isNotEmpty) {
        setState(() {
          euin = euinList.first;
        });
      }
    });

    // Show MFU alert dialog
    if (client_code_map['bse_nse_mfu_flag'].toUpperCase() == "MFU") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Important Notice",
                  style: AppFonts.f50014Black
                      .copyWith(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Text(
                  "Please note that, once you successfully add new bank details, you have to upload the cancel cheque image as proof for all your existing bank as well as the new bank. The upload facility is provided in this page.\n\n"
                  "After adding the proof, bank activation may take 5-7 working days. After bank activation only you will be able to transact using the new bank account.",
                  style: AppFonts.f40014,
                  textAlign: TextAlign.justify,
                ),
              ),
              actions: [
                TextButton(
                  child: Text("OK",
                      style: AppFonts.f50014Black
                          .copyWith(color: Config.appTheme.themeColor)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }

  Future getMandateinfo() async {
    // if (mandateList.isNotEmpty) return 0;

    final isBankOnlySelected = isBankSelected && !isMandateSelected;
    Map data = await TransactionApi.getMandateInfo(
      user_id: user_id,
      client_name: client_name,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      investor_code: client_code_map['investor_code'],
      account_number: '',
      mandate_flag: isBankOnlySelected ? 'N' : "Y",
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    mandateList = data['list'];
    if (mandateList.isNotEmpty) selectedMandate = mandateList.first;
    return 0;
  }

  Future getBankMandateTypes() async {
    if (mandateTypeList.isNotEmpty) return 0;

    Map data = await TransactionApi.getBankMandateTypes(
      user_id: user_id,
      client_name: client_name,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    mandateTypeList = List<Map<String, dynamic>>.from(data['list'].reversed);
    return 0;
  }

  Future getBankMandateOptions() async {
    if (paymentModeList.isNotEmpty) return 0;

    if (client_code_map['bse_nse_mfu_flag'] != "BSE") {
      Map data = await TransactionApi.getBankMandateOptions(
        user_id: user_id,
        client_name: client_name,
        bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      );
      if (data['status'] != 200) {
        Utils.showError(context, data['msg']);
        return -1;
      }

      paymentModeList = List<Map<String, dynamic>>.from(data['list']);
    }
    ;
    return 0;
  }

  String fileName = "";

  Future uploadCancelCheque(String filePath) async {
    Map data = await TransactionApi.uploadCancelledCheque(
      user_id: user_id,
      client_name: client_name,
      file_path: filePath,
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return "";
    }
    Map result = data['result'];
    fileName = result['file_name'];
    return fileName;
  }

  Future sendChequeToMfu(String fileName) async {
    Map data = await TransactionApi.sendChequeToMfu(
      user_id: user_id,
      client_name: client_name,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      image_names: fileName,
      investor_code: client_code_map['investor_code'],
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return "";
    }
    return 0;
  }

  num deleteCode = 0;
  var deleteMessage = "";

  Future deleteBankDetails(
      bankName, number, ifscCode, bank_code, micr_code, branch) async {
    print("bank code $bankCode");
    Map data = await TransactionApi.deleteBankDetails(
        user_id: user_id,
        client_name: client_name,
        bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
        investor_code: client_code_map['investor_code'],
        bank_code: bank_code,
        bank_account_number: number,
        bank_account_type: accountTypeCode,
        bank_branch: branch,
        bank_ifsc_code: ifscCode,
        bank_micr_code: micr_code);

    deleteCode = data['status'];
    deleteMessage = data['msg'];

    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      return -1;
    }

    return 0;
  }

  Future deleteBankMandate(number, umrn, delete_mandate_type) async {
    String formateMandateType = delete_mandate_type.replaceAll('-', '');

    // print("mandateType-- $mandateType");
    Map data = await TransactionApi.deleteBankMandate(
      user_id: user_id,
      client_name: client_name,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      investor_code: client_code_map['investor_code'],
      bank_account_number: number,
      umrn_no: umrn,
      option: formateMandateType,
    );

    deleteCode = data['status'];
    deleteMessage = data['msg'];

    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      return -1;
    }

    return 0;
  }

  Future getAccountType() async {
    if (accountTypeList.isNotEmpty) return 0;

    Map data = await CommonOnBoardApi.getBankAccountType(
        client_name: client_name,
        bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
        tax_status: tax_status);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    accountTypeList = data['list'];
    return 0;
  }

  Map bankMap = {};

  Future getBankList() async {
    if (bankMap.isNotEmpty) return 0;

    Map data = await CommonOnBoardApi.getBankList(
      user_id: user_id,
      client_name: client_name,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    List list = data['list'];
    for (var element in list) {
      String bank_name = element['bank_name'];
      String bank_code = element['bank_code'];

      bankMap[bank_name] = bank_code;
    }
    return 0;
  }

  String euin = "";
  List euinList = [];

  Future getEuinList() async {
    if (euinList.isNotEmpty) return 0;
    print("code ${client_code_map['broker_code']}");

    Map data = await Api.getEuinList(
        client_name: client_name, broker_code: client_code_map['broker_code']);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }

    euinList = data['list'];
    if (euinList.isNotEmpty) euin = euinList.first;
    return 0;
  }

  Future validateIfsc(String bankName, String ifsc) async {
    EasyLoading.show();

    Map data = await CommonOnBoardApi.validateIfscCode(
      user_id: user_id,
      client_name: client_name,
      ifsc: ifsc,
      bank_name: bankName,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    Map result = data['result'];
    branchName = result['branch'];
    bankAddress = result['address'];
    print("Add bank address $bankAddress");

    EasyLoading.dismiss();

    return 0;
  }

  int addCode = 0;
  String addMessage = "";

  Future addNseBankInfo() async {
    if (client_code_map['bse_nse_mfu_flag'] != "MFU") {
      proofTypeCode == "";
    } else {
      proofTypeCode == proofTypeCode;
    }

    EasyLoading.show();
    Map data = await TransactionApi.addMoreBank(
      user_id: user_id,
      client_name: client_name,
      ifsc_code: ifsc,
      micr_code: micr,
      bank_name: bankName,
      bank_code: bankCode,
      branch_name: branchName,
      bank_address: bankAddress,
      account_number: accNumber,
      account_type: accountTypeCode,
      process_mode: 'I',
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      investor_code: client_code_map['investor_code'],
      account_holder_name: name!,
      bank_proof: proofTypeCode,
      broker_code: client_code_map['broker_code'],
      euin_code: euin,
    );

    addCode = data['status'];
    addMessage = data['msg'];

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    EasyLoading.dismiss();
    return 0;
  }

  int mandateCode = 0;
  String mandateMessage = "";
  String bsePayment_link = "";
  String transaction_number = "";

  Future generateBankMandate(String ifscCode, number, bankaccName, holdername,
      branch, bankCode, mandateTypecode) async {
    Map data = await TransactionApi.generateBankMandate(
        user_id: user_id,
        client_name: client_name,
        account_holder_name: holdername,
        account_type: accountTypeCode,
        ach_from_date: client_code_map['bse_nse_mfu_flag'] == "MFU"
            ? convertDtToStr(mfustartDate)
            : convertDtToStr(startDate),
        ach_to_date: client_code_map['bse_nse_mfu_flag'] == "BSE"
            ? convertDtToStr(bseendDate)
            : convertDtToStr(endDate),
        amount: controller.mandateamount.value.toString(),
        bank_name: bankaccName,
        branch_name: branch,
        broker_code: client_code_map['broker_code'],
        euin_code: euin,
        ifsc_code: ifscCode,
        mandate_option: (client_code_map['bse_nse_mfu_flag'] == "BSE")
            ? ''
            : (client_code_map['bse_nse_mfu_flag'] == "NSE" &&
                    controller.mandateType.value == "Physical")
                ? ''
                : controller.paymentModecode.value,
        mandate_type: mandateTypecode,
        micr_code: micr_code,
        until_cancelled: mandateEndDate.contains('Until') ? "Y" : "N",
        account_number: number,
        bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
        investor_code: client_code_map['investor_code'],
        bank_code: bankCode);

    if (data['status'] != 200) {
      if (EasyLoading.isShow) EasyLoading.dismiss();

      Utils.showError(context, data['msg']);
      mandateCode = data['status'];
      mandateMessage = data['msg'];
      return -1;
    }
    mandateCode = data['status'];
    mandateMessage = data['msg'];

    if (client_code_map['bse_nse_mfu_flag'] == "BSE") {
      Map result = data['result'];
      bsePayment_link = result['payment_link'];
      transaction_number = result['transaction_number'];
    }

    EasyLoading.dismiss();
    return 0;
  }

  String bankBranchName = "";

  Future getDatas() async {
    isLoading = true;
    try {
      await getMandateinfo();
      await getBankList();
      await getBankMandateTypes();
      await getBankMandateOptions();
      await getEuinList();
      await getAccountType();

      // Set initial values after data is loaded
      if (mandateTypeList.isNotEmpty) {
        controller.mandateType.value = mandateTypeList.first['desc'];
        controller.mandateTypecode.value = mandateTypeList.first['code'];
      }

      if (paymentModeList.isNotEmpty) {
        controller.paymentMode.value = paymentModeList.first['desc'];
        controller.paymentModecode.value = paymentModeList.first['code'];
      }

      if (accountTypeList.isNotEmpty) {
        accountType = accountTypeList.first['desc'];
        accountTypeCode = accountTypeList.first['code'];
      }
    } catch (e) {
      print("getDatas Exception = $e");
    }
    isLoading = false;
    return 0;
  }

  bool isBankSelected = true;
  bool isMandateSelected = true;

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: invAppBar(title: "Banks & Mandates"),
            body: SideBar(
              child: Column(
                children: [
                  topCard(),
                  SizedBox(height: 16),
                  if (client_code_map['bse_nse_mfu_flag'].toUpperCase() ==
                      "MFU")
                    InkWell(
                      onTap: () => showUploadProofBottomSheet(),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Text("Upload Proof", style: AppFonts.f50014Black),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Config.appTheme.themeColor),
                                borderRadius: BorderRadius.circular(25),
                                color: Config.appTheme.themeColor,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Upload",
                                    style: AppFonts.f50014Grey.copyWith(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.upload,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                 /* Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            isBankSelected = !isBankSelected;
                            getDatas();
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              child: Row(
                                children: [
                                  if (isBankSelected) ...[
                                    Icon(
                                      Icons.done,
                                      size: 16,
                                    ),
                                    SizedBox(width: 5),
                                  ],
                                  Text('Banks'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            isMandateSelected = !isMandateSelected;
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              child: Row(
                                children: [
                                  if (isMandateSelected) ...[
                                    Icon(
                                      Icons.done,
                                      size: 16,
                                    ),
                                    SizedBox(width: 5),
                                  ],
                                  Text('Mandates'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),*/
                  SizedBox(height: 10),
                  Expanded(
                    child: (isLoading)
                        ? Utils.shimmerWidget(devHeight,
                            margin: EdgeInsets.fromLTRB(16, 0, 16, 16))
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: mandateList.length,
                            itemBuilder: (context, index) {
                              Map mandate = mandateList[index];
                              return getBankListDetails(mandate);
                            },
                          ),
                  ),
                  CalculateButton(
                    onPress: () async {
                      if (mandateList.length >= 3) {
                        Utils.showError(context,
                            "You have already added 3 bank accounts.You will not be allowed to add more than 3 bank details.");
                      } else {
                        await addNewBank(context);
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    text: "Add Bank",
                    textStyle:
                        AppFonts.f50014Black.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget topCard() {
    String bse_nse_mfu_flag = client_code_map['bse_nse_mfu_flag'];
    String? stsCode = "";
    String investor_code = client_code_map['investor_code'];
    String holding_nature = client_code_map['holding_nature'];

    if (bse_nse_mfu_flag == "NSE") stsCode = "IIN Number";
    if (bse_nse_mfu_flag == "BSE") stsCode = "Client Code";
    if (bse_nse_mfu_flag == "MFU") stsCode = "CAN Number";

    return Container(
      color: Config.appTheme.themeColor,
      child: Container(
        width: devWidth,
        margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Config.appTheme.themeColor25,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ColumnText(title: "Name", value: "$name"),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ColumnText(title: stsCode, value: investor_code),
                ),
                Expanded(
                  child: ColumnText(
                    title: "Holding Nature",
                    value: holding_nature,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String micr_code = "";
  String bank_code = "";

  Widget getBankListDetails(Map mandate) {
    String bankName = mandate['bank_name'];
    String? number = mandate['bank_account_number'];
    String? mask = number?.substring(number.length - 4);
    String ifscCode = mandate['bank_ifsc_code'];
    String umrn = mandate['mandate_id'] ?? "-";
    String amount = mandate['mandate_amount'];
    num? mandateAmount = num.tryParse(amount);
    print("mandate amount ${Utils.formatNumber(mandateAmount)}");
    String status = mandate['mandate_status'];
    String bankDefault = mandate['default_bank'];
    micr_code = mandate['bank_micr_code'];
    String bank_code = mandate['bank_code'];
    String branch = mandate['bank_branch'];
    String bankstatus = bankDefault == "Y" ? "primary" : "";
    String mandateDate = mandate['mandate_date'] ?? "";

    if (umrn.isEmpty) {
      umrn = "-";
    }
    if (amount.isEmpty) {
      amount = "-";
    }
//****$mask
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ColumnText(
                    title: bankName,
                    value: "Branch: $branch",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013,
                  ),
                ),
                if (client_code_map['bse_nse_mfu_flag'].toUpperCase() ==
                        "BSE" &&
                    bankDefault == "Y")
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.lightGreen,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    child: Text(
                      bankstatus,
                      style:
                          AppFonts.f50012.copyWith(color: AppColors.textGreen),
                    ),
                  ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    updateBankDetails(bankName, number, ifscCode, bank_code,
                        micr_code, branch, mandate, bankDefault);
                  },
                  child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                        size: 16,
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
                child: Text(
              "Account Number: $number",
              style: AppFonts.f40013,
            )),
            SizedBox(
              height: 5,
            ),
            Container(
              child: Text(
                "IFSC: $ifscCode | MICR Code: $micr_code",
                style: AppFonts.f40013,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnText(title: 'UMRN Number', value: umrn),
                ColumnText(
                  title: "Amount",
                  value: Utils.formatNumber(mandateAmount),
                  alignment: CrossAxisAlignment.end,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColumnText(title: "Mandate Date", value: mandateDate),
              ],
            ),
            Container(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed: () {
                  /*if (status == "Register") {
                    showMandateBottomSheet(context, mandate);
                  }*/
                  showMandateBottomSheet(context, mandate, status);
                },
                style: TextButton.styleFrom(
                    backgroundColor: Config.appTheme.buttonColor,
                    foregroundColor: Colors.white,
                    elevation: 3),
                child: Text(
                  status,
                  style: AppFonts.f50012.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Approved":
        return AppColors.lightGreen;
      case "Register":
        return AppColors.lightRed;
      default:
        return AppColors.lightOrange;
    }
  }

  Color getStatusTextColor(String status) {
    switch (status) {
      case "Approved":
        return AppColors.textGreen;
      case "Register":
        return AppColors.lossRed;
      case "Y":
        return AppColors.textGreen;
      default:
        return AppColors.orage;
    }
  }

  updateBankDetails(String bankName, number, ifscCode, bank_code, micr_code,
      branch, mandate, String bankDefault) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (context, bottomSheet) {
            return Container(
              height: devHeight * 0.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(15),
              )),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          )),
                      child: Row(
                        children: [
                          Text(
                            "Update Bank",
                            style: AppFonts.f40016
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(Icons.close)),
                        ],
                      ),
                    ),
                    /* Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        children: [
                          Image.asset("assets/setBank.png",
                              height: 32, color: Config.appTheme.themeColor),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Set Default Bank ",
                                  style: AppFonts.f50014Grey
                                      .copyWith(color: Colors.black)),
                            ],
                          ),
                        ],
                      ),
                    ),*/
                    Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(21),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: InkWell(
                        onTap: () {
                          Get.back();
                          deleteBankAlert(bankName, number, ifscCode, bank_code,
                              micr_code, branch, mandate, bankDefault);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_forever_outlined,
                              weight: 32,
                              color: Config.appTheme.themeColor,
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Delete Bank ",
                                    style: AppFonts.f50014Theme),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  deleteBankAlert(bankName, number, ifscCode, bank_code, micr_code, branch,
      mandate, String bankDefault) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              BottomSheetTitle(title: "Confirm"),
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Config.appTheme.themeColor)),
                child: ColumnText(
                  title: "You are about to delete the bank.",
                  value: "You will not be able to recover this information!",
                  titleStyle: AppFonts.f50014Black,
                  valueStyle: AppFonts.f40013,
                ),
              ),
              CalculateButton(
                  onPress: () async {
                    // if (bankDefault == "Y") {
                    //   Utils.showError(context,
                    //       "Default bank not able to delete. Please change your \ndefault bank for some other bank after you can \ndelete this bank.");
                    //   return;
                    // }
                    Get.back();
                    EasyLoading.show();
                    int res = await deleteBankDetails(bankName, number,
                        ifscCode, bank_code, micr_code, branch);
                    EasyLoading.dismiss();
                    if (res == -1) return;

                    if (deleteCode != 400) {
                      Get.to(() => MandateSuccess(
                            deleteMessage: deleteMessage,
                            pagename: "Bank Deleted",
                            mandateAmount: controller.mandateamount.value,
                            bankaccName: bankName,
                            number: number,
                            ifscCode: ifscCode,
                          ));
                      /*Get.dialog(AlertDialog(
                        title: Text('Success'),
                        content: Text(deleteMessage),
                        actions: [
                          TextButton(
                            child: Text(
                              "Ok",
                            ),
                            onPressed: () async {
                              Get.back();
                            },
                          )
                        ],
                      ));*/

                      mandateList = [];
                      setState(() {});
                      return;
                    }
                    // showCupertinoDialog(
                    //     barrierDismissible: true,
                    //     context: context,
                    //     builder: (_) => AlertDialog(
                    //           title: Text('Success'),
                    //           content: Text(" Deleted Successfully"),
                    //           actions: [
                    //             TextButton(
                    //               child: Text(
                    //                 "Ok",
                    //               ),
                    //               onPressed: () async {
                    //                 Get.back();
                    //               },
                    //             )
                    //           ],
                    //         ));
                    // Get.back();
                    // mandateList = [];
                    // await getMandateinfo();
                    // setState(() {});
                  },
                  text: "Delete Bank Now")
            ],
          ),
        );
      },
    );
  }

  addNewBank(context) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (context, bottomState) {
            return Container(
              height: 764,
              decoration: BoxDecoration(
                  // color: Config.appTheme.themeColor,
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Add Bank Details",
                            style: AppFonts.f40016
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(Icons.close)),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          bankTile(context, bottomState),
                          SizedBox(height: 16),
                          AmountInputCard(
                            title: "IFSC Code",
                            initialValue: ifsc,
                            suffixText: "",
                            maxLength: 11,
                            hasSuffix: false,
                            keyboardType: TextInputType.name,
                            borderRadius: BorderRadius.circular(20),
                            textCapitalization: TextCapitalization.characters,
                            onChange: (val) async {
                              ifsc = val;
                              if (ifsc.length != 11) return;
                              await validateIfsc(bankName,
                                  ifsc); // Validate and possibly update `bankAddress` and `branchName`
                              bottomState(() {});
                            },
                            subTitle: Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: AppColors.textGreen,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  "Branch: $branchName",
                                  style: AppFonts.f50012.copyWith(
                                      color: AppColors.textGreen, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          // Bank Address Input Card
                          if (bankAddress.isNotEmpty)
                            AmountInputCard(
                              title: "Bank Address",
                              suffixText: "",
                              hasSuffix: false,
                              borderRadius: BorderRadius.circular(20),
                              initialValue: bankAddress,
                              // Autofill the bank address
                              readOnly: false,
                              // Make the field editable
                              onChange: (val) {
                                bankAddress =
                                    val; // Update bankAddress as the user types
                                // Optionally, you can validate and store the updated address if needed
                              },
                            ),

                          SizedBox(height: 16),
                          AmountInputCard(
                            title: "Account Number",
                            initialValue: accNumber,
                            suffixText: "",
                            hasSuffix: false,
                            keyboardType: TextInputType.name,
                            borderRadius: BorderRadius.circular(20),
                            onChange: (val) => accNumber = val,
                            maxLength: 20,
                          ),
                          SizedBox(height: 16),
                          AmountInputCard(
                            title: "MICR Code",
                            initialValue: micr,
                            suffixText: "",
                            hasSuffix: false,
                            maxLength: 9,
                            keyboardType: TextInputType.name,
                            borderRadius: BorderRadius.circular(20),
                            onChange: (val) => micr = val,
                          ),
                          SizedBox(height: 16),
                          AmountInputCard(
                            title: "Account Holder Name",
                            initialValue: name,
                            suffixText: "",
                            hasSuffix: false,
                            keyboardType: TextInputType.name,
                            borderRadius: BorderRadius.circular(20),
                            onChange: (val) => name = val,
                          ),
                          SizedBox(height: 16),
                          accountTypeTile(context, bottomState),
                          SizedBox(height: 16),
                          if (client_code_map['bse_nse_mfu_flag'] == "MFU")
                            uploadedProof(context, bottomState),
                          SizedBox(height: 32),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    CalculateButton(
                      onPress: () async {
                        List list = [bankName, accNumber, name, accountType];
                        if (list.contains("")) {
                          print("accountType $accountType");
                          print("accHolderName $name");
                          print("accNumber $accNumber");
                          print("bankName $bankName");
                          Utils.showError(context, "All Fields are Mandatory");
                          return;
                        }
                        if (ifsc.length != 11) {
                          Utils.showError(
                              context, "Please Enter Valid IFSC Code");
                          return;
                        }

                        if (client_code_map['bse_nse_mfu_flag'].toUpperCase() ==
                                "MFU" &&
                            micr == "") {
                          Utils.showError(context, "Please enter MICR Code");
                          return;
                        }

                        Get.back();

                        int res = await addNseBankInfo();
                        if (res == -1) return;
                        if (addCode != 400) {
                          // EasyLoading.showInfo(addMessage);
                          Get.to(() => MandateSuccess(
                                deleteMessage: addMessage,
                                pagename: "Bank Added",
                                mandateAmount: controller.mandateamount.value,
                                bankaccName: bankName,
                                number: accNumber,
                                ifscCode: ifsc,
                              ));
                          mandateList = [];
                          setState(() {});
                          return;
                        }
                      },
                      text: "SUBMIT",
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            );
          });
        });
  }

  String? holderNames;
  String? branchNames = "";
  String bankSearch = "";

  Widget bankTile(BuildContext context, var bottomState) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: bankController,
          title: Text("Bank", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(bankName.isEmpty ? "Select Bank" : bankName,
                  style: AppFonts.f50012),
            ],
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: RpSmallTf(
                  initialValue: bankSearch,
                  borderColor: AppColors.lineColor,
                  onChange: (val) {
                    bankSearch = val.toLowerCase();
                    bottomState(() {});
                  }),
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: filterBank().length,
                itemBuilder: (context, index) {
                  List list = [];
                  if (bankSearch.isEmpty)
                    list = bankMap.keys.toList();
                  else
                    list = filterBank();

                  String temp = list[index];

                  return InkWell(
                    onTap: () {
                      bankName = temp;
                      bankCode = bankMap[bankName] ?? "";
                      bankController.collapse();
                      bottomState(() {});
                    },
                    child: Row(
                      children: [
                        Radio(
                          value: temp,
                          groupValue: bankName,
                          onChanged: (value) {
                            bankName = temp;
                            bankCode = bankMap[bankName];
                            bankController.collapse();
                            bottomState(() {});
                          },
                        ),
                        Expanded(child: Text(temp, style: AppFonts.f50014Grey)),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  List filterBank() {
    List list = bankMap.keys.toList();

    return list
        .where((element) => element.toLowerCase().contains(bankSearch))
        .toList();
  }

  Widget accountTypeTile(BuildContext context, StateSetter bottomState) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: accountTypeController,
          title: Text("Account Type", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(accountType, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: accountTypeList.length,
              itemBuilder: (context, index) {
                Map map = accountTypeList[index];

                String desc = map['desc'];
                String code = map['code'];

                return InkWell(
                  onTap: () {
                    bottomState(() {
                      accountType = desc;
                      accountTypeCode = code;
                    });
                    accountTypeController.collapse();
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: code,
                        groupValue: accountTypeCode,
                        onChanged: (val) {
                          bottomState(() {
                            accountType = desc;
                            accountTypeCode = code;
                          });
                          accountTypeController.collapse();
                        },
                      ),
                      Text(desc, style: AppFonts.f50014Grey),
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

  Widget uploadedProof(BuildContext context, StateSetter bottomState) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: bankProofController,
          title: Text("Bank Proof", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(proofType, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: bankProofMap.length,
              itemBuilder: (context, index) {
                String type = bankProofMap.keys.elementAt(index);
                String typeCode = bankProofMap.values.elementAt(index);
                return InkWell(
                  onTap: () {
                    bottomState(() {
                      proofType = type;
                      proofTypeCode = typeCode;
                    });
                    bankProofController.collapse();
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: type,
                        groupValue: proofType,
                        onChanged: (val) {
                          bottomState(() {
                            proofType = type;
                            proofTypeCode = typeCode;
                          });
                          bankProofController.collapse();
                        },
                      ),
                      Text(type, style: AppFonts.f50014Grey),
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

  bool showAdditionalFields = false;
  String selectedOption = "";
  List selectedOptionList = [
    "Create New Mandate in the same bank",
    "Delete the Existing Mandate Details",
  ];

  DateTime endDate = DateTime(
      DateTime.now().year + 40, DateTime.now().month, DateTime.now().day - 1);
  DateTime bseendDate = DateTime(
      DateTime.now().year + 40, DateTime.now().month, DateTime.now().day - 1);

  showMandateBottomSheet(context, Map mandate, String status) {
    selectedOption = "Create New Mandate in the same bank";
    showAdditionalFields = true;
    // Map<String, dynamic> currentState = {
    //   'mandateType': mandateType,
    //   'mandateTypecode': mandateTypecode,
    //   'amount': mandateamount,
    // };

    String ifscCode = mandate['bank_ifsc_code'];
    String? number = mandate['bank_account_number'];
    String? mask = number?.substring(number.length - 4);
    String? bankaccName = mandate['bank_name'];
    String? holderNames = mandate['bank_account_holder_name'];
    String? branch = mandate['bank_branch'];
    String? bankCode = mandate['bank_code'];
    String? micr = mandate['bank_micr_code'];
    String? umrn = mandate['mandate_id'];

    print("bank code $bankCode");

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (context, bottomSheet) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                height: devHeight * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Bank Mandate Registration",
                              style: AppFonts.f40016
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                            InkWell(
                                onTap: () {
                                  Get.back();
                                  selectedOption = " ";
                                  showAdditionalFields = false;
                                },
                                child: Icon(Icons.close)),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Container(
                              width: devWidth,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(mandate['bank_name'] ?? '',
                                          style: AppFonts.f50014Grey
                                              .copyWith(color: Colors.black)),
                                      Text(
                                          "****${mandate['bank_account_number']?.substring(mandate['bank_account_number'].length - 4) ?? ''} | ${mandate['bank_ifsc_code']}"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                    child: Text("Select Option",
                                        style: AppFonts.f50014Black),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: (status == "Generate")
                                        ? 1
                                        : selectedOptionList.length,
                                    itemBuilder: (context, index) {
                                      String temp = selectedOptionList[index];
                                      return InkWell(
                                        onTap: () {
                                          bottomSheet(() {
                                            selectedOption = temp;
                                            showAdditionalFields = selectedOption ==
                                                "Create New Mandate in the same bank";
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Radio(
                                              value: temp,
                                              groupValue: selectedOption,
                                              onChanged: (value) {
                                                bottomSheet(() {
                                                  selectedOption = temp;
                                                  showAdditionalFields =
                                                      selectedOption ==
                                                          "Create New Mandate in the same bank";
                                                });
                                              },
                                            ),
                                            Text(temp,
                                                style: AppFonts.f50014Grey),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            if (showAdditionalFields) ...[
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    controller: mandateTypeController,
                                    title: Text("Mandate Type",
                                        style: AppFonts.f50014Black),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                       Obx(() => Text(controller.mandateType.value,
                                            style: AppFonts.f50012),),
                                      ],
                                    ),
                                    children: [
                                      DottedLine(),
                                      ListView.builder(
                                        padding: EdgeInsets.all(0),
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: mandateTypeList.length,
                                        itemBuilder: (context, index) {
                                          String desc =
                                              mandateTypeList[index]['desc'];
                                          String code =
                                              mandateTypeList[index]['code'];

                                          return InkWell(
                                            onTap: () {
                                                // currentState['mandateType'] =
                                                //     desc;
                                                // currentState['mandateTypecode'] =
                                                //     code;
                                                controller.mandateType.value = desc;
                                                controller.mandateTypecode.value = code;
                                              mandateTypeController.collapse();
                                              // print(
                                              //     'mandatetype--$mandateTypecode');
                                            },
                                            child: Row(
                                              children: [
                                                Radio(
                                                  value: desc,
                                                  groupValue:
                                                  controller.mandateType.value,
                                                  onChanged: (value) {
                                                      // currentState[
                                                      //     'mandateType'] = desc;
                                                      // currentState[
                                                      //         'mandateTypecode'] =
                                                      //     code;
                                                      controller.mandateType.value = desc;
                                                      controller.mandateTypecode.value = code;
                                                    mandateTypeController
                                                        .collapse();
                                                    // print(
                                                    //     'mandatetype--$mandateTypecode');
                                                  },
                                                ),
                                                Text(desc,
                                                    style: AppFonts.f50014Grey),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                                  // Container(

                              SizedBox(height: 10),
                              mandateAmountTile(),
                              // Container(
                              //   padding: EdgeInsets.all(16),
                              //   decoration: BoxDecoration(
                              //     color: Colors.white,
                              //     borderRadius: BorderRadius.circular(10),
                              //   ),
                              //   child: Column(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     children: [
                              //       Container(
                              //           alignment: Alignment.topLeft,
                              //           child: Text("Mandate Amount",
                              //               style: AppFonts.f50014Black,
                              //               textAlign: TextAlign.start)),
                              //       SizedBox(height: 16),
                              //       Row(
                              //         children: [
                              //           Container(
                              //               padding: EdgeInsets.symmetric(
                              //                   horizontal: 16, vertical: 12),
                              //               decoration: BoxDecoration(
                              //                 color: Config.appTheme.mainBgColor,
                              //                 border: Border(
                              //                   left: BorderSide(
                              //                       width: 1,
                              //                       color: Config
                              //                           .appTheme.lineColor),
                              //                   top: BorderSide(
                              //                       width: 1,
                              //                       color: Config
                              //                           .appTheme.lineColor),
                              //                   bottom: BorderSide(
                              //                       width: 1,
                              //                       color: Config
                              //                           .appTheme.lineColor),
                              //                 ),
                              //                 borderRadius: BorderRadius.only(
                              //                     bottomLeft: Radius.circular(25),
                              //                     topLeft: Radius.circular(25)),
                              //               ),
                              //               child: Text(rupee,
                              //                   style: AppFonts.f50014Grey)),
                              //           Expanded(
                              //             child: TextFormField(
                              //               maxLength: 9,
                              //               keyboardType:
                              //                   TextInputType.numberWithOptions(),
                              //               controller: controller.mandateAmountController,
                              //               onChanged: (val) {
                              //                 // Use debounced API call
                              //                 _debouncedApiCall(val);
                              //               },
                              //               decoration: InputDecoration(
                              //                   counterText: "",
                              //                   contentPadding:
                              //                       EdgeInsets.fromLTRB(
                              //                           16, 8, 16, 8),
                              //                   enabledBorder: OutlineInputBorder(
                              //                     borderSide: BorderSide(
                              //                         color: Config
                              //                             .appTheme.lineColor,
                              //                         width: 1),
                              //                     borderRadius: BorderRadius.only(
                              //                       topRight: Radius.circular(25),
                              //                       bottomRight:
                              //                           Radius.circular(25),
                              //                     ),
                              //                   ),
                              //                   focusedBorder: OutlineInputBorder(
                              //                     borderSide: BorderSide(
                              //                       color:
                              //                           Config.appTheme.lineColor,
                              //                       width: 2,
                              //                     ),
                              //                     borderRadius: BorderRadius.only(
                              //                       topRight: Radius.circular(25),
                              //                       bottomRight:
                              //                           Radius.circular(25),
                              //                     ),
                              //                   ),
                              //                   hintText: 'Enter Mandate Amount'),
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              SizedBox(height: 10),
                              Obx(() {
                                final mandateType = controller.mandateType.value;
                                final bseNseMfuFlag = client_code_map['bse_nse_mfu_flag'];
                                
                                if ((bseNseMfuFlag == "NSE" && mandateType == "E-Mandate") ||
                                    bseNseMfuFlag == "MFU") {
                                  return mandateOptionTile(context, bottomSheet);
                                } else {
                                  return SizedBox.shrink();
                                }
                              }),
                              // if ((client_code_map['bse_nse_mfu_flag'] == "NSE" &&
                              //     controller.mandateType.value == "E-Mandate") ||
                              //     client_code_map['bse_nse_mfu_flag'] == "MFU")
                              //   Obx(() => mandateOptionTile(context, bottomSheet)),

                              mandateFromDateTile(bottomSheet),
                              SizedBox(
                                height: 10,
                              ),
                              if (client_code_map['bse_nse_mfu_flag'] != "BSE")
                                sipEndDateExpansionTile(bottomSheet),
                              if (client_code_map['bse_nse_mfu_flag'] == "BSE")
                                bseEndDateTile(bottomSheet),
                              SizedBox(
                                height: 10,
                              ),
                              arnExpansionTile(),
                              SizedBox(
                                height: 10,
                              ),
                              euinExpansionTile(bottomSheet),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: devWidth,
                        padding: EdgeInsets.all(16),
                        color: Colors.white,
                        child: SizedBox(
                          width: devWidth * 0.76,
                          height: 42,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Config.appTheme.themeColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              textStyle: AppFonts.f50014Black.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              List list = [startDate, controller.mandateamount.value];
                              // mandateType = currentState['mandateType'];
                              // mandateTypecode = currentState['mandateTypecode'];
                              // print("mandatetype-- $mandateType");
                              // print("mandateTypecode-- $mandateTypecode");

                              if (selectedOption ==
                                  "Delete the Existing Mandate Details") {
                                deleteAlert(number, umrn, mandate, controller.mandateamount.value,
                                    bankaccName, ifscCode);
                                return;
                              }

                              if (list.contains("")) {
                                Utils.showError(
                                    context, "All Fields are Mandatory");
                                return;
                              }
                              if (controller.mandateamount.value == 0) {
                                Utils.showError(
                                    context, "Please enter a mandate amount");
                                return;
                              }
                              await validateIfsc(bankaccName!, ifscCode);
                              print("came here $ifscCode");

                              if (selectedOption !=
                                  "Delete the Existing Mandate Details") {
                                if ((client_code_map['bse_nse_mfu_flag'] ==
                                            "BSE" &&
                                        status != "Pending") ||
                                    (client_code_map['bse_nse_mfu_flag'] !=
                                        "BSE")) {
                                  EasyLoading.show();
                                  int res = await generateBankMandate(
                                      ifscCode,
                                      number,
                                      bankaccName,
                                      holderNames,
                                      branch,
                                      bankCode,
                                      controller.mandateTypecode.value);
                                  EasyLoading.dismiss();
                                  if (res == -1) return;

                                  Navigator.pop(context);
                                  if (mandateCode == 200) {
                                    Get.to(() => MandateSuccess(
                                          paymentLink: bsePayment_link ?? "",
                                          deleteMessage: mandateMessage,
                                          pagename: "Mandate Generated",
                                          mandateAmount: controller.mandateamount.value,
                                          bankaccName: bankaccName,
                                          number: number!,
                                          ifscCode: ifscCode,
                                          mandate_id: transaction_number,
                                          investor_code:
                                              client_code_map['investor_code'],
                                          mandatetype:
                                          controller.mandateTypecode.value,
                                        ));
                                    return;
                                  }
                                } else if (client_code_map['bse_nse_mfu_flag'] ==
                                        "BSE" &&
                                    status == "Pending") {
                                  Utils.showError(context,
                                      "Please delete your existing mandate details and try again");
                                  return;
                                }
                              }
                            },
                            child: Text("SUBMIT"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
    /*.whenComplete(() => {
          setState(() {
            selectedOption = "";
            showAdditionalFields = false;
          })
    });*/
  }


  List paymentModeList = [];
  ExpansionTileController paymentModeController = ExpansionTileController();

  Widget mandateOptionTile(BuildContext context, StateSetter bottomSheet) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            controller: paymentModeController,
            title: Text("Mandate Option", style: AppFonts.f50014Black),
            subtitle: Obx(() =>  Text(controller.paymentMode.value.isEmpty ? "Select Option" : controller.paymentMode.value,
                 style: TextStyle(
                     fontWeight: FontWeight.w500,
                     fontSize: 13,
                     color: Config.appTheme.themeColor))),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: paymentModeList.length,
                itemBuilder: (context, index) {
                  String desc = paymentModeList[index]["desc"];
                  String code = paymentModeList[index]["code"];

                  return InkWell(
                    onTap: () {
                      controller.paymentMode.value = desc;
                      controller.paymentModecode.value = code;
                      paymentModeController.collapse();
                    },
                    child: Row(
                      children: [
                        Radio(
                          value: desc,
                          groupValue: controller.paymentMode.value,
                          onChanged: (value) {
                            controller.paymentMode.value = desc;
                              controller.paymentModecode.value = code;
                            paymentModeController.collapse();
                          },
                        ),
                        Text(desc),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      );
    });
  }

  deleteAlert(number, umrn, Map mandate, mandateamount, bankaccName, ifscCode) {
    String delete_mandate_type = mandate['mandate_type'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are you sure?"),
        content: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              WidgetSpan(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text:
                          "Mandate details are erased from our system only. It will not delete from ${client_code_map['bse_nse_mfu_flag']} platform.",
                      style: AppFonts.f40014.copyWith(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Config.appTheme.themeColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              EasyLoading.show();
              int res =
                  await deleteBankMandate(number, umrn, delete_mandate_type);
              EasyLoading.dismiss();
              if (res == -1) return;

              if (deleteCode != 400) {
                Navigator.of(context).pop();

                Get.to(() => MandateSuccess(
                      deleteMessage: deleteMessage,
                      pagename: "Mandate Deleted",
                      mandateAmount: mandateamount,
                      bankaccName: bankaccName,
                      number: number,
                      ifscCode: ifscCode,
                    ));
                print("mandate status ${MandateSuccess(
                  deleteMessage: deleteMessage,
                  pagename: "Mandate Deleted",
                  mandateAmount: mandateamount,
                  bankaccName: bankaccName,
                  number: number,
                  ifscCode: ifscCode,
                )}");

                /*Get.dialog(
                  AlertDialog(
                    title: Text('Success'),
                    content: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            WidgetSpan(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  textAlign: TextAlign.justify,
                                  text: deleteMessage,
                                  style: AppFonts.f40014.copyWith(color: Colors.black),
                                ),
                              ),
                            ),

                          ],
                        ),
                      )
                );*/
                mandateList = [];
                setState(() {});
                return;
              }
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget mandateFromDateTile(Function bottomState) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: fromDateController,
          title: Text("Mandate Start Date", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fromDate, style: AppFonts.f50012),
            ],
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: ScrollDatePicker(
                  selectedDate: client_code_map['bse_nse_mfu_flag'] == "MFU"
                      ? mfustartDate
                      : startDate,
                  minimumDate: client_code_map['bse_nse_mfu_flag'] == "MFU"
                      ? DateTime.now().add(Duration(days: 2))
                      : DateTime.now().add(Duration(days: 0)),
                  maximumDate: DateTime(2100),
                  onDateTimeChanged: (val) {
                    client_code_map['bse_nse_mfu_flag'] == "MFU"
                        ? mfustartDate = val
                        : startDate = val;
                    fromDate = "${val.day}-${val.month}-${val.year}";
                    bottomState(() {});
                  }),
            )
          ],
        ),
      ),
    );
  }

  String toDate = "Select End Date";

  Widget bseEndDateTile(Function bottomState) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: sipEndDateController,
          title: Text("Mandate End Date", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(toDate, style: AppFonts.f50012),
            ],
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: ScrollDatePicker(
                  selectedDate: bseendDate,
                  minimumDate: DateTime.now().add(Duration(days: 7)),
                  maximumDate: DateTime(2100),
                  onDateTimeChanged: (val) {
                    bseendDate = val;
                    toDate = "${val.day}-${val.month}-${val.year}";
                    bottomState(() {});
                  }),
            ),
          ],
        ),
      ),
    );
  }

  ExpansionTileController sipEndDateController = ExpansionTileController();
  List sipEndTypeList = ["Until Cancelled", "Specific Date"];
  String sipEndType = "Until Cancelled";

  // DateTime sipEndDate = DateTime.now();

  Widget sipEndDateExpansionTile(Function bottomState) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: sipEndDateController,
          title: Text("Mandate End Date", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sipEndType, style: AppFonts.f50012),
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
                itemCount: sipEndTypeList.length,
                itemBuilder: (context, index) {
                  String temp = sipEndTypeList[index];

                  return Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: sipEndType,
                        onChanged: (value) {
                          bottomState(() {
                            sipEndType = temp;
                            mandateEndDate =
                                temp; // Add this line to sync the values
                            if (sipEndType.contains("Until")) {
                              DateTime now = DateTime.now();
                              endDate = DateTime(
                                  now.year + 40, now.month, now.day - 1);
                              sipEndDateController.collapse();
                            }
                          });
                        },
                      ),
                      Text(temp),
                    ],
                  );
                },
              ),
            ),
            Visibility(
              visible: !sipEndType.contains("Until"),
              child: SizedBox(
                height: 200,
                child: ScrollDatePicker(
                    selectedDate: endDate,
                    minimumDate: DateTime.now().add(Duration(days: 7)),
                    maximumDate: DateTime(2100),
                    onDateTimeChanged: (val) {
                      bottomState(() {
                        endDate = val;
                        sipEndType = "${val.day}-${val.month}-${val.year}";
                        mandateEndDate =
                            sipEndType; // Add this line to sync the values
                      });
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  ExpansionTileController arnController = ExpansionTileController();

  Widget arnExpansionTile() {
    //if (arnList.isEmpty) return SizedBox();
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: arnController,
          title: Text("Select ARN Number", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(client_code_map['broker_code'],
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Config.appTheme.themeColor)),
            ],
          ),
        ),
      ),
    );
  }

  ExpansionTileController euinController = ExpansionTileController();

  Widget euinExpansionTile(StateSetter bottomSheet) {
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
                    bottomSheet(() {
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
                          bottomSheet(() {
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

  Widget mandateAmountTile() {
    return StatefulBuilder(builder: (context, setState) {
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
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          bottomLeft: Radius.circular(25),
                          topLeft: Radius.circular(25)),
                    ),
                    child: Text(rupee, style: AppFonts.f50014Grey)),
                Expanded(
                  child: TextFormField(
                    maxLength: 9,
                    keyboardType: TextInputType.numberWithOptions(),
                    onChanged: (val) {
                      // _debouncedApiCall(val);
                      // Update only the amount without triggering a full state rebuild
                      controller.mandateamount.value = int.tryParse(val) ?? 0;
                    },
                    decoration: InputDecoration(
                        counterText: "",
                        contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Config.appTheme.lineColor, width: 1),
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
                        hintText: 'Enter Mandate Amount'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      );
    });
  }

  showAboutSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            //color: Config.appTheme.themeColor,
            child: SizedBox(
              height: devHeight * 0.4,
              child: StatefulBuilder(builder: (_, bottomState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Learn about Mandate Limit",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(Icons.close))
                        ],
                      ),
                    ),
                    // Divider(),
                    Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      alignment: Alignment.center,
                      child: Text(
                        "  Mandate Limit: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n"
                        "\n  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                        maxLines: 20,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        });
  }

  void showUploadProofBottomSheet() {
    Map<String, String> uploadedFileNames = {};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            height: devHeight * 0.8,
            child: Column(
              children: [
                BottomSheetTitle(title: "Upload Proof"),
                Expanded(
                  child: ListView.builder(
                    itemCount: mandateList.length,
                    padding: EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      Map bank = mandateList[index];
                      String accountNumber = bank['bank_account_number'] ?? '';

                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Config.appTheme.lineColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(bank['bank_name'] ?? '',
                                style: AppFonts.f50014Black),
                            SizedBox(height: 8),
                            Text("Account Number: $accountNumber",
                                style: AppFonts.f40013),
                            SizedBox(height: 8),
                            Text("IFSC: ${bank['bank_ifsc_code'] ?? ''}",
                                style: AppFonts.f40013),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: uploadedFileNames
                                            .containsKey(accountNumber)
                                        ? null // Disable button if file is already uploaded
                                        : () async {
                                            try {
                                              final ImagePicker picker =
                                                  ImagePicker();
                                              final XFile? image =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.gallery);

                                              if (image != null) {
                                                // Check file size
                                                final File file =
                                                    File(image.path);
                                                final int fileSize =
                                                    await file.length();
                                                final double fileSizeInMB =
                                                    fileSize / (1024 * 1024);

                                                if (fileSizeInMB > 1.0) {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "File Size Too Large"),
                                                        content: Text(
                                                            "Please select an image less than 1MB in size."),
                                                        actions: [
                                                          TextButton(
                                                            child: Text("OK"),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  return;
                                                }

                                                EasyLoading.show();
                                                String fileName =
                                                    await uploadCancelCheque(
                                                        image.path);
                                                if (fileName.isNotEmpty) {
                                                  setState(() {
                                                    bankChequeFiles[
                                                        accountNumber] = file;
                                                    uploadedFileNames[
                                                            accountNumber] =
                                                        fileName;
                                                  });
                                                }
                                                EasyLoading.dismiss();
                                              }
                                            } catch (e) {
                                              EasyLoading.dismiss();
                                              Utils.showError(context,
                                                  "Error uploading cheque: $e");
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: uploadedFileNames
                                              .containsKey(accountNumber)
                                          ? Colors
                                              .grey // Change color when disabled
                                          : Config.appTheme.themeColor,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text(uploadedFileNames
                                            .containsKey(accountNumber)
                                        ? "Uploaded" // ✓Add checkmark to show success
                                        : "Upload Cheque"),
                                  ),
                                ),
                                //  if (bankChequeFiles[accountNumber] != null && !uploadedFileNames.containsKey(accountNumber)) ...[
                                SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      bankChequeFiles[accountNumber] = null;
                                      uploadedFileNames.remove(accountNumber);
                                    });
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        border: Border.all(color: Colors.red),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Icon(
                                        Icons.delete_forever,
                                        color: Colors.white,
                                        size: 16,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Show Upload All button only when all cheques are uploaded
                if (uploadedFileNames.length == mandateList.length)
                  CalculateButton(
                    onPress: () async {
                      EasyLoading.show();
                      try {
                        fileName = uploadedFileNames.values.join(',');
                        await sendChequeToMfu(fileName);
                        Utils.showError(context,
                            "Successfully uploaded all cheques to MFU");
                        Navigator.pop(context);
                      } catch (e) {
                        Utils.showError(
                            context, "Error sending cheques to MFU: $e");
                      }
                      EasyLoading.dismiss();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    text: "Upload All",
                    textStyle:
                        AppFonts.f50014Black.copyWith(color: Colors.white),
                  ),
              ],
            ),
          );
        });
      },
    );
  }
}
class BanksmandateController extends GetxController {
  final mandateType = "E-Mandate".obs;
  final mandateTypecode = "E".obs;
  final mandateamount = 0.obs;
  final mandateAmountController = TextEditingController();
  final paymentMode = ''.obs;
  final paymentModecode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with default values
    mandateType.value = "E-Mandate";
    mandateTypecode.value = "E";
    mandateamount.value = 0;
  }

  @override
  void onClose() {
    mandateAmountController.dispose();
    super.onClose();
  }

}
