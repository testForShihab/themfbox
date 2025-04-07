import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import 'NoSchemes.dart';

class SwpSysTrnx extends StatefulWidget {
  const SwpSysTrnx({super.key});

  @override
  State<SwpSysTrnx> createState() => _SwpSysTrnxState();
}

class _SwpSysTrnxState extends State<SwpSysTrnx> {
  int user_id = GetStorage().read('user_id');
  String client_name = GetStorage().read('client_name');
  Map client_code_map = GetStorage().read('client_code_map');

  List overAllList = [];

  Future getSipStpSwpCancelSchemes() async {
    Map data = await TransactionApi.getSipStpSwpCancelSchemes(
        client_name: client_name,
        user_id: user_id,
        bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
        sys_option: "SWP");

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    overAllList = data['result'];
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSipStpSwpCancelSchemes(),
      builder: (context, snapshot) {
        if (overAllList.isEmpty)
          return NoSchemes(img: "assets/swp_cancellation.png", name: "SWP");
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
                child: Image.asset("assets/48.png", width: 32),
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
                      title: "End Date", value: "${scheme.endDate}")),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text("SIP Registration Number : ",
                  style: AppFonts.f40013.copyWith(color: Colors.black)),
              Text("${scheme.transactionNumber}",
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
              actionBtn(icon: Icons.pause_circle_outline, label: "Pause SWP"),
              actionBtn(
                  icon: Icons.delete_forever_outlined, label: "Cancel SWP"),
            ],
          ),
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
  }
}
