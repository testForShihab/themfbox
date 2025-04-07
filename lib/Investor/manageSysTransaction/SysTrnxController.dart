import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/manageSysTransaction/CancelSIPSuccess.dart';
import 'package:mymfbox2_0/Investor/manageSysTransaction/SipSysTrnx.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/research/SchemeInfo.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../login/CheckUserType.dart';
import '../../rp_widgets/AmountInputCard.dart';

class SysTrnxController extends GetxController {
  int user_id = GetStorage().read('user_id');
  String client_name = GetStorage().read('client_name');
  Map client_code_map = GetStorage().read('client_code_map');

  Rx<DateTime> pauseFrom = DateTime.now().obs;
  Rx<DateTime> pauseTo = DateTime.now().obs;

  Future showPauseAlert({
    required Map client_code_map,
    required SchemePojo scheme,
  }) async {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text("Pause SIP"),
        content: SizedBox(
          height: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Pause From"),
              Obx(() => dateCard(pauseFrom.value, () async {
                    DateTime? dt = await showDatePicker(
                        context: Get.context!,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030));
                    if (dt != null) pauseFrom.value = dt;
                  })),
              SizedBox(height: 16),
              Text("Pause To"),
              Obx(() => dateCard(pauseTo.value, () async {
                    DateTime? dt = await showDatePicker(
                        context: Get.context!,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2025));
                    if (dt != null) pauseTo.value = dt;
                  })),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Get.back(),
              child: Text("Back", style: AppFonts.f50014Theme)),
          TextButton(
              onPressed: () async {
                EasyLoading.show();

                Map data = await TransactionApi.pauseSip(
                  user_id: user_id,
                  client_name: client_name,
                  bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
                  pause_from_date: convertDtToStr(pauseFrom.value),
                  pause_to_date: convertDtToStr(pauseTo.value),
                  trxn_no: "${scheme.transactionNumber}",
                  investor_code: client_code_map['investor_code'],
                  scheme_name: "${scheme.schemeName}",
                  folio_no: "${scheme.folioNo}",
                  scheme_code: "${scheme.schemeCode}",
                  unique_number: "${scheme.uniqueNumber}",
                );

                if (data['status'] != 200) {
                  Utils.showError(Get.context!, data['msg']);
                  return;
                }
                Get.back();
                EasyLoading.showSuccess("Paused Successfully");
              },
              child: Text("Pause",
                  style: AppFonts.f50014Theme
                      .copyWith(color: Config.appTheme.defaultLoss))),
        ],
      ),
    );
  }

  String installment = "";

  Future bsePauseAlert({
    required SchemePojo scheme,
    required Map client_code_map,
  })async{
     Get.dialog(
       AlertDialog(
         backgroundColor: Colors.white,
         surfaceTintColor: Colors.white,
         title: Text("Pause SIP"),
         content: SizedBox(
           height: 120,
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               AmountInputCard(
                 title: "Number of Installment To Pause",
                 hasSuffix: false,
                 initialValue: installment,
                 borderRadius: BorderRadius.circular(8),
                 onChange: (val) {
                   installment = val;
                  // int month = int.tryParse(installment) ?? 0;
                 }, suffixText: '',
               ),

             ],
           ),
         ),
         actions: [
           TextButton(
               onPressed: () => Get.back(),
               child: Text("Back", style: AppFonts.f50014Theme)),
           TextButton(
               onPressed: () async {
                 EasyLoading.show();

                 Map data = await TransactionApi.bseSipPause(
                   user_id: user_id,
                   client_name: client_name,
                   bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
                   sip_reg_no: "${scheme.sipRegNo}",
                   amount: '${scheme.amountUnits}',
                   start_date: '${scheme.startDate}',
                   frequency: '${scheme.frequency}',
                   firstOrderFlag: '${scheme.firstOrderFlag}',
                   mandate_id: '${scheme.mandateid}',
                   no_of_install: '${scheme.installment}',
                   no_of_install_pause: installment, investor_code: client_code_map['investor_code'],
                 );

                 if (data['status'] != 200) {
                   Utils.showError(Get.context!, data['msg']);
                   return;
                 }
                 Get.back();
                 EasyLoading.showSuccess("Paused Successfully");
               },
               child: Text("Pause",
                   style: AppFonts.f50014Theme
                       .copyWith(color: Config.appTheme.defaultLoss))),
         ],
       ),
     );
}

  Widget dateCard(DateTime dt, Function() onTap) {
    String displayDate = dt.toString().split(" ").first;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(8)),
        width: double.maxFinite,
        padding: EdgeInsets.all(16),
        child: Text(displayDate, style: AppFonts.f50014Theme),
      ),
    );
  }

  RxString cancelReason = "".obs;
  RxString cancelReasonCode = "".obs;

  cancelBottomSheet(Map client_code_map,SchemePojo scheme) async {
    List reasonList = [];
    EasyLoading.show();
    Map data = await TransactionApi.getCancelSipReason(
        user_id: user_id,
        client_name: client_name,
        bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag']);
    reasonList = data['list'];
    EasyLoading.dismiss();

    Get.bottomSheet(
        Container(
          height: 700,
          decoration: BoxDecoration(
            color: Config.appTheme.mainBgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              BottomSheetTitle(
                title: "Cancel Reason",
                hasReset: true,
                resetText: "Submit",
                onReset: () async {
                  await cancelAlert(client_code_map,scheme,cancelReasonCode);
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

                        return Obx(() {
                          return Row(
                            children: [
                              Radio(
                                value: code,
                                groupValue: cancelReasonCode.value,
                                onChanged: (value) {
                                  cancelReason.value = reason;
                                  cancelReasonCode.value = code;
                                },
                              ),
                              Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        cancelReason.value = reason;
                                        cancelReasonCode.value = code;
                                      },
                                      child: Text(reason)))
                            ],
                          );
                        });
                      },
                    ),
                    Obx(() {
                      if (cancelReason.value.contains("Other"))
                        return Padding(
                          padding: EdgeInsets.all(16),
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Specify Reason"),
                          ),
                        );
                      else
                        return SizedBox();
                    })
                  ],
                ),
              ))
            ],
          ),
        ),
        isScrollControlled: true);
  }

  /*Future cancelSip() async {
      Map data = await TransactionApi.multipleSystematicCancellation(
          client_name: client_name,
          user_id: user_id,
          option: "SIP",
          trxn_no: "${selectedPojo!.transactionNumber}",
          investor_code: client_code_map['investor_code'],
          scheme_name: "${selectedPojo!.schemeName}",
          folio_no: "${selectedPojo!.folioNo}",
          scheme_code: "${selectedPojo!.schemeCode}",
          unique_number: "${selectedPojo!.uniqueNumber}",
          cancel_reason: cancelReasonCode,
          other_reason: otherReason,
          bse_nse_mfu_flag: "${client_code_map['bse_nse_mfu_flag']}");

      if (data['status'] != 200) {
        Utils.showError(context, data['msg']);
        return -1;
      }

      return 0;
    }*/

  Future cancelAlert(Map client_code_map,SchemePojo scheme,RxString cancelReasonCode) async {

    String cancellingReaseon = cancelReasonCode.toString();
    print("cancellingReaseon $cancellingReaseon");
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
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
              Map data = await TransactionApi.multipleSystematicCancellation(
                  client_name: client_name,
                  user_id: user_id,
                  option: "SIP",
                  sip_reg_no: (client_code_map['bse_nse_mfu_flag'] == "BSE") ? scheme.sipRegNo : "",
                  trxn_no: "${scheme.transactionNumber}",
                  investor_code: client_code_map['investor_code'],
                  scheme_name: "${scheme.schemeName}",
                  folio_no: "${scheme.folioNo}",
                  scheme_code: "${scheme.schemeCode}",
                  unique_number: "${scheme.uniqueNumber}",
                  cancel_reason: cancellingReaseon,
                  other_reason: "",
                  bse_nse_mfu_flag: "${client_code_map['bse_nse_mfu_flag']}");

              if (data['status'] != 200) {
                Utils.showError(Get.context!, data['msg']);
                return;
              }else{
                Get.offAll(() => CheckUserType());
                Get.to(() => CancelSIPSuccess(msg: data['msg']));
              }

            },
            child: Text(
              "YES, CANCEL",
              style: AppFonts.f50014Theme
                  .copyWith(color: Config.appTheme.defaultLoss),
            )),
      ],
    ));
  }
}
