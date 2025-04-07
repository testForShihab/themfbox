import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/Investor/manageSysTransaction/SysTrnxController.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import 'NoSchemes.dart';

class SipSysTrnx extends StatefulWidget {
  const SipSysTrnx({super.key});

  @override
  State<SipSysTrnx> createState() => _SipSysTrnxState();
}

class _SipSysTrnxState extends State<SipSysTrnx> {
  int user_id = GetStorage().read('user_id');
  String client_name = GetStorage().read('client_name');
  Map client_code_map = GetStorage().read('client_code_map');

  List overAllList = [];
  // SchemePojo? selectedPojo;

  bool isLoading = true;
  Future getSipStpSwpCancelSchemes() async {
    if (overAllList.isNotEmpty) return 0;

    isLoading = true;
    Map data = await TransactionApi.getSipStpSwpCancelSchemes(
        client_name: client_name,
        user_id: user_id,
        bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
        sys_option: "SIP");

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    overAllList = data['result'];
    isLoading = false;
    return 0;
  }

  Future multipleSystematicCancellation() async {
    isLoading = true;
  }

  late double devHeight;
  SysTrnxController controller = Get.put(SysTrnxController());
  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;

    return FutureBuilder(
      future: getSipStpSwpCancelSchemes(),
      builder: (context, snapshot) {
        if (isLoading) return Utils.shimmerWidget(devHeight - 160);
        if (overAllList.isEmpty)
          return NoSchemes(img: "assets/sipFund.png", name: "SIP");
        return Expanded(child: SingleChildScrollView(child: overallArea()));
      },
    );
  }

  Widget overallArea() {
    return ListView.separated(
      itemCount: overAllList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        Map result = overAllList[index];
        List schemeList = result['scheme_list'];

        return Column(
          children: [
            MarketTypeCard(client_code_map: result),
            Divider(height: 0, color: Config.appTheme.lineColor),
            schemeArea(schemeList)
          ],
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 32),
    );
  }

  Widget schemeArea(List schemeList) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: schemeList.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> map = schemeList[index];
          SchemePojo scheme = SchemePojo.fromJson(map);

          return schemeCard(scheme);
        },
      ),
    );
  }

  Widget schemeCard(SchemePojo scheme, {bool hasActions = true}) {
    String temp = scheme.amountUnits ?? "0";
    //String sipAmount = Utils.formatNumber(temp as num?);
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(
            color: Config.appTheme.lineColor,
          )),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Utils.getImage("${scheme.schemeLogo}", 32),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ColumnText(
                  title: "${scheme.schemeName}",
                  value: "Folio : ${scheme.folioNo}",
                  titleStyle: AppFonts.f50014Black,
                  valueStyle: AppFonts.f40013,
                ),
              ),
              if (hasActions)
                InkWell(
                    onTap: () {
                      actionBottomSheet(scheme);
                    },
                    child: Icon(Icons.more_vert))
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: ColumnText(
                      title: "Start Date", value: "${scheme.startDate}")),
              Expanded(
                  child: ColumnText(
                      title: "SIP Amount", value: "$rupee $temp")),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text("SIP Registration Number : ",
                  style: AppFonts.f40013.copyWith(color: Colors.black)),
              Text("${scheme.sipRegNo}",
                  style: AppFonts.f50012.copyWith(color: Colors.black))
            ],
          )
        ],
      ),
    );
  }

  actionBottomSheet(SchemePojo scheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: 450,
          child: Column(
            children: [
              BottomSheetTitle(title: "SIP Actions"),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: schemeCard(scheme, hasActions: false),
              ),
              InkWell(
                  onTap: () async {
                    if(client_code_map['bse_nse_mfu_flag'] != "BSE")
                    await controller.showPauseAlert(client_code_map: client_code_map, scheme: scheme);
                    if(client_code_map['bse_nse_mfu_flag'] == "BSE")
                    await controller.bsePauseAlert(scheme: scheme, client_code_map: client_code_map);
                  },
                  child: actionBtn(
                      icon: Icons.pause_circle_outline, label: "Pause SIP")),
              GestureDetector(
                onTap: () async {
                  controller.cancelBottomSheet( client_code_map, scheme);
                  // cancelReasonBottomSheet();
                },
                child: actionBtn(
                    icon: Icons.delete_forever_outlined, label: "Cancel SIP"),
              ),
            ],
          ),
        );
      },
    );
  }

  // Future cancelSip() async {
  //   Map data = await TransactionApi.multipleSystematicCancellation(
  //       client_name: client_name,
  //       user_id: user_id,
  //       option: "SIP",
  //       trxn_no: "${selectedPojo!.transactionNumber}",
  //       investor_code: client_code_map['investor_code'],
  //       scheme_name: "${selectedPojo!.schemeName}",
  //       folio_no: "${selectedPojo!.folioNo}",
  //       scheme_code: "${selectedPojo!.schemeCode}",
  //       unique_number: "${selectedPojo!.uniqueNumber}",
  //       cancel_reason: cancelReasonCode,
  //       other_reason: otherReason,
  //       bse_nse_mfu_flag: "${client_code_map['bse_nse_mfu_flag']}");

  //   if (data['status'] != 200) {
  //     Utils.showError(context, data['msg']);
  //     return -1;
  //   }

  //   return 0;
  // }

  String cancelReason = "";
  String cancelReasonCode = "";
  double bottomSheetHeight = 764;
  String otherReason = "";

  cancelReasonBottomSheet() async {
    List reasonList = [];
    Map data = await TransactionApi.getCancelSipReason(
        user_id: user_id,
        client_name: client_name,
        bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag']);
    reasonList = data['list'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SizedBox(
              height: bottomSheetHeight,
              child: Column(
                children: [
                  BottomSheetTitle(
                    title: "Cancel Reason",
                    hasReset: true,
                    resetText: "Submit",
                    onReset: () async {
                      await cancelAlert();
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: reasonList.length,
                            itemBuilder: (context, index) {
                              Map temp = reasonList[index];
                              String reason = temp['desc'];
                              String code = temp['code'];

                              return Row(
                                children: [
                                  Radio(
                                    value: code,
                                    groupValue: cancelReasonCode,
                                    onChanged: (value) {
                                      cancelReason = reason;
                                      cancelReasonCode = code;
                                      bottomState(() {});
                                    },
                                  ),
                                  Expanded(
                                      child: GestureDetector(
                                          onTap: () {
                                            cancelReason = reason;
                                            cancelReasonCode = code;
                                            bottomState(() {});
                                          },
                                          child: Text(reason)))
                                ],
                              );
                            },
                          ),
                          if (cancelReason.contains("Other"))
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Focus(
                                onFocusChange: (keyboardOpen) {
                                  if (keyboardOpen)
                                    bottomSheetHeight = 800;
                                  else
                                    bottomSheetHeight = 500;
                                  bottomState(() {});
                                },
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Reason",
                                  ),
                                  onChanged: (val) => otherReason = val,
                                ),
                              ),
                            ),
                          if (bottomSheetHeight != 500) SizedBox(height: 310),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  cancelAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          title: Text("Cancel SIP ?",
              style: AppFonts.f50014Black.copyWith(fontSize: 18)),
          content: Text(
            "Cancelling will stop all your upcoming investments in this SIP. Proceed to cancel.",
            style: AppFonts.f50014Grey.copyWith(fontWeight: FontWeight.w400),
          ),
          actions: [
            TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "NO",
                  style: AppFonts.f50014Theme,
                )),
            TextButton(
                onPressed: () async {
                  // int res = await cancelSip();
                  // if (res == -1) return;
                  // EasyLoading.showSuccess("Cancelled Successfully");

                },
                child: Text(
                  "YES, CANCEL",
                  style: AppFonts.f50014Theme
                      .copyWith(color: Config.appTheme.defaultLoss),
                )),
          ],
        );
      },
    );
  }

  Widget actionBtn({required IconData icon, required String label}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: Config.appTheme.themeColor,
          ),
          SizedBox(width: 10),
          Text(label, style: AppFonts.f50014Theme),
        ],
      ),
    );
  }
}

class SchemePojo {
  String? transactionNumber;
  String? folioNo;
  String? schemeName;
  String? schemeCode;
  String? amountUnits;
  String? startDate;
  String? endDate;
  String? frequency;
  String? frequencyCode;
  String? umrnNo;
  String? uniqueNumber;
  String? firstOrderFlag;
  String? installment;
  String? transactionDate;
  String? toSchemeName;
  String? toSchemeCode;
  String? amcCode;
  String? extUniqueRefNo;
  String? uniqueRefNo;
  String? trxnRefNo;
  String? groupOrderNo;
  String? schemeLogo;
  String? sipRegNo;
  String? mandateid;

  SchemePojo.fromJson(Map<String, dynamic> json) {
    transactionNumber = json['transaction_number'];
    folioNo = json['folio_no'];
    schemeName = json['scheme_name'];
    schemeCode = json['scheme_code'];
    amountUnits = json['amount_units'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    frequency = json['frequency'];
    frequencyCode = json['frequency_code'];
    umrnNo = json['umrn_no'];
    uniqueNumber = json['unique_number'];
    firstOrderFlag = json['first_order_flag'];
    installment = json['installment'];
    transactionDate = json['transaction_date'];
    toSchemeName = json['to_scheme_name'];
    toSchemeCode = json['to_scheme_code'];
    amcCode = json['amc_code'];
    extUniqueRefNo = json['ext_unique_ref_no'];
    uniqueRefNo = json['unique_ref_no'];
    trxnRefNo = json['trxn_ref_no'];
    groupOrderNo = json['group_order_no'];
    schemeLogo = json['scheme_logo'];
    sipRegNo = json['sip_reg_no'];
    mandateid = json['mandate_id'];
  }
}
