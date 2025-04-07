import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/FundDetails.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/Investor/sipPortfolioSummary/SipPortfolioSummary.widgets.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/pojo/OnlineTransactionRestrictionPojo.dart';
import 'package:mymfbox2_0/research/SchemeInfo.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../rp_widgets/RpListTile.dart';

class SipSummary extends StatefulWidget {
  const SipSummary({super.key});
  @override
  State<SipSummary> createState() => _SipSummaryState();
}

class _SipSummaryState extends State<SipSummary> {
  late double devHeight, devWidth;
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  DateTime selectedFolioDate = DateTime.now();

  int currentIndex = 0;
  Map sipSummary = {};
  List sipList = [];
  bool isFirst = true;

  Future getMutualFundPortfolio() async {
    if (!isFirst) return 0;
    EasyLoading.show();
    Map data = await InvestorApi.getMutualFundPortfolio(
        user_id: user_id,
        client_name: client_name,
        selected_date: selectedFolioDate,
        folio_type: "Live",
        broker_code: "");

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    sipSummary = data['sip_summary'];
    sipList = data['sip_scheme_summary'];

    /*for (var scheme in list) {
       if (scheme['isSip'])
         sipList.add(scheme);
     }*/
    isFirst = false;
    EasyLoading.dismiss();

    return 0;
  }

  List investorList = [];
  late Map<String, dynamic> datas;
  OnlineTransactionRestrictionPojo userData =
      OnlineTransactionRestrictionPojo();
  Future getAllOnlineRestrictions() async {
    Map data = await InvestorApi.getOnlineRestrictionsByUserId(
      user_id: user_id,
      client_name: client_name,
    );

    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      return 0;
    }
    investorList = data['list'];
    datas = investorList[0];
    userData = OnlineTransactionRestrictionPojo.fromJson(datas);
    return 0;
  }

  Future getDatas(BuildContext context) async {
    await getMutualFundPortfolio();
    await getAllOnlineRestrictions();

    return 0;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: getDatas(context),
      builder: (context, snapshot) {
        return Column(
          children: [
            summaryCard(
              amount: sipSummary['sip_amount'] ?? 0,
              currCost: sipSummary['sip_curr_cost'] ?? 0,
              currValue: sipSummary['sip_curr_value'] ?? 0,
              gainLoss: sipSummary['sip_gain_loss'] ?? 0,
              xirr: sipSummary['sip_xirr'] ?? 0,
              totalCount: sipList.length,
              type: 'SIP',
           /*  dayChangeAmount: sipSummary['sip_day_change_amount'] ?? 0,
              dayChangePercentage: sipSummary['sip_day_change_percentage'] ?? 0,
              oneDayChange: userData.oneDayChange,*/
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Text("${sipList.length} Items", style: f40012),
                  Spacer(),
                  SortButton(onTap: () {
                    showSortFilter();
                  }),
                /*  SizedBox(width: 10),
                  SortButton(
                    onTap: () {
                      currentIndex++;
                      if (currentIndex > 2) currentIndex = 0;
                      selectedView = viewOptions.keys.elementAt(currentIndex);
                      setState(() {});
                    },
                    title: selectedView,
                  ),*/
                ],
              ),
            ),
            (sipList.isEmpty)
                ? NoData()
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: sipList.length,
                      itemBuilder: (context, index) {
                        return schemeCard(sipList[index]);
                      },
                    ),
                  ),
            SizedBox(height: 16),
          ],
        );
      },
    );
  }

  double xirrvalue = 0.0;
  Widget schemeCard(scheme) {
    String cost = Utils.formatNumber(scheme['curr_cost']);
    String value = Utils.formatNumber(scheme['curr_value']);
    xirrvalue = scheme['xirr'];
    String? amfiSchemeName = scheme['scheme_amfi'];
    String encodedName = amfiSchemeName!.replaceAll("&", "%26");
    double day_change = scheme['day_change_value'];

    String amfiShortName =  scheme['scheme_amfi_short_name'];
    String encoded_amfi = amfiShortName.replaceAll("&", "%26");

    print("Daychange - ${scheme['day_change_percentage']}");

    return SingleChildScrollView(
      child: InkWell(
        onTap: () {
          Get.to(() => FundDetails(
                schemeAmfiCode: "${scheme['scheme_amfi_code']}",
                schemeName: "${scheme['scheme_amfi']}",
                schemeCategory: "${scheme['scheme_category']}",
                schemeAmcLogo: "${scheme['scheme_amc_logo']}",
                currCost: scheme['curr_cost'] ?? 0,
                currValue: scheme['curr_value'] ?? 0,
                xirr: scheme['xirr'].toString(),
                folio: scheme['folio'],
                oneDayChange: userData.oneDayChange ?? 0, folioType: "",
              ));
        },
        child: Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){
                  Get.to(SchemeInfo(
                      schemeName: encodedName,
                       schemeLogo: "${scheme['scheme_amc_logo']}",
                      schemeShortName: encoded_amfi));
                },
                child: RpListTile(
                  showArrow: true,
                  subTitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Folio : ${scheme['folio']}",
                          style: f40012.copyWith(color: Colors.black)),
                      Text("SIP Date : ${scheme['sip_ecs_date']} , Frequency - ${scheme['sip_frequency']}",
                          style: f40012.copyWith(color: Colors.black)),
                    ],
                  ),
                  leading: Image.network(
                    "${scheme['scheme_amc_logo']}" ?? "",
                    height: 32,
                  ),
                  title: Text(
                    "${scheme['scheme_amfi_short_name']}",
                    style: AppFonts.f50014Grey.copyWith(color: Colors.blue),
                    maxLines: 3,
                  ),),
              ),

              //Text("Monthly SIP of ₹5,000 on 12th" ,style: AppFonts.f50012.copyWith(color: Config.appTheme.themeColor)),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 12),
                child: Column(
                  children: [
                    SizedBox(height: 16,),
                    rpRow(
                        lhead: "Units",
                        lSubHead: Utils.formatNumber(scheme['units']),
                        rhead: "Current Cost",
                        rSubHead: "$rupee $cost",
                        chead: "Current Value",
                        cSubHead: "$rupee $value"),
                    SizedBox(height: 16,),
                    rpRow(
                        lhead: "Unrealised Gain",
                        lSubHead: "$rupee ${Utils.formatNumber(scheme['unrealisedProfitLoss']) }",
                        rhead: "Realised Gain",
                        rSubHead: "$rupee ${Utils.formatNumber(scheme['realisedProfitLoss'])}",
                        chead: "Abs Rtn(%)",
                        cSubHead: Utils.formatNumber(scheme['absolute_return'])),

                    SizedBox(height: 16,),
                    rpRow(
                        lhead: "XIRR(%)",
                        lSubHead: Utils.formatNumber(scheme['xirr']),
                        rhead: (userData.oneDayChange == 1 || ((keys.contains("adminAsInvestor")) || (keys.contains("adminAsFamily")) != false)) ? "1 Day Change" : " ",
                        rSubHead: (userData.oneDayChange == 1 || ((keys.contains("adminAsInvestor")) || (keys.contains("adminAsFamily")) != false)) ? "$rupee ${Utils.formatNumber(scheme['day_change_value'])}" : " " ,titleStyle: AppFonts.f40014,
                        valueStyle: AppFonts.f50016Grey.copyWith(color: (day_change < 0) ? Config.appTheme.defaultLoss : Config.appTheme.defaultProfit),
                        chead: "SIP Amount", cSubHead: "$rupee ${Utils.formatNumber(scheme['sip_amount'])}"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rpRow({
    required String lhead,
    required String lSubHead,
    required String rhead,
    required String rSubHead,
    required String chead,
    required String cSubHead,
    final TextStyle? valueStyle,
    final TextStyle? titleStyle,
  }) {
    return Row(
      children: [
        Expanded(child: ColumnText(title: lhead, value: lSubHead,alignment: CrossAxisAlignment.start)),
        Expanded(child: ColumnText(title: rhead, value: rSubHead,alignment: CrossAxisAlignment.center,valueStyle: valueStyle,titleStyle: titleStyle,)),
        Expanded(child: ColumnText(title: chead,value: cSubHead,alignment: CrossAxisAlignment.end)),
      ],
    );
  }

  List sortOptions = [
    "Current Value",
    "Current Cost",
    "A to Z",
    "XIRR",
    "Absolute Return",
    "Gain/Loss"
  ];
  String selectedSort = "";
  showSortFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return Container(
              height: devHeight * 0.5,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Sort & Filter",
                          style: AppFonts.f40016
                              .copyWith(fontWeight: FontWeight.w500)),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.close),
                      )
                    ],
                  ),
                  Divider(),
                  ListView.builder(
                    itemCount: sortOptions.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      String title = sortOptions[index];
                      return InkWell(
                        onTap: () {
                          selectedSort = title;
                          applySort();
                          setState(() {});
                          Get.back();
                        },
                        child: Row(
                          children: [
                            Radio(
                              value: title,
                              groupValue: selectedSort,
                              onChanged: (value) {
                                selectedSort = title;
                                applySort();
                                setState(() {});
                                Get.back();
                              },
                            ),
                            Text(title)
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  applySort() {
    if (selectedSort == "Current Cost") {
      sipList.sort(
        (a, b) => (b['curr_cost']).compareTo(a['curr_cost']),
      );
    }
    if (selectedSort == "Current Value") {
      sipList.sort(
        (a, b) => (b['curr_value']).compareTo(a['curr_value']),
      );
    }
    if (selectedSort == "A to Z") {
      sipList.sort(
        (a, b) => (a['scheme_amfi_short_name'] ?? '')
            .compareTo(b['scheme_amfi_short_name'] ?? ''),
      );
    }
    if (selectedSort == "XIRR") {
      sipList.sort(
        (a, b) => (b['xirr'] ?? 0).compareTo(a['xirr'] ?? 0),
      );
    }
    if (selectedSort == "Absolute Return") {
      sipList.sort(
        (a, b) =>
            (b['absolute_return'] ?? 0).compareTo(a['absolute_return'] ?? 0),
      );
    }
    if (selectedSort == "Gain/Loss") {
      sipList.sort(
        (a, b) => (b['unrealisedProfitLoss'] ?? 0)
            .compareTo(a['unrealisedProfitLoss'] ?? 0),
      );
    }
  }

  Map viewOptions = {
    "XIRR": 'xirr',
    "Unrealized Gain": 'unrealisedProfitLoss',
    "Abs Return": 'absolute_return'
  };
  String selectedView = "XIRR";
}
