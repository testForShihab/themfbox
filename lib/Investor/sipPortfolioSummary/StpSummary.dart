import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/FundDetails.dart';
import 'package:mymfbox2_0/Investor/sipPortfolioSummary/SipPortfolioSummary.widgets.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/pojo/MfSchemeSummaryPojo.dart';
import 'package:mymfbox2_0/pojo/MfSummaryPojo.dart';
import 'package:mymfbox2_0/rp_widgets/NoData.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../pojo/OnlineTransactionRestrictionPojo.dart';
import '../../research/SchemeInfo.dart';
import '../../rp_widgets/RpListTile.dart';

class StpSummary extends StatefulWidget {
  const StpSummary({super.key});
  @override
  State<StpSummary> createState() => _StpSummaryState();
}

class _StpSummaryState extends State<StpSummary> {
  late double devHeight, devWidth;
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  bool isFirst = true;
  int currentIndex = 0;
  Map stpSummary = {};
  List stpList = [];

  Future getStpSwpSummary() async {
    if (!isFirst) return 0;
    Map data = await InvestorApi.getStpSwpSummary(
        user_id: user_id, client_name: client_name, summary_type: 'STP');

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    stpSummary = data['summary'];
    stpList = data['list'];
    isFirst = false;
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
    await getStpSwpSummary();
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
              amount: stpSummary['amount'] ?? 0,
              currCost: stpSummary['currentcost_total'] ?? 0,
              currValue: stpSummary['currentvalue_total'] ?? 0,
              gainLoss: stpSummary['unrelaised_total'] ?? 0,
              xirr: stpSummary['total_xirr'] ?? 0,
              totalCount: stpList.length,
              type: 'STP',
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Text(" ${stpList.length} Items", style: f40012),
                  Spacer(),
                  SortButton(onTap: () {
                    showSortFilter();
                  }),
                 /* SizedBox(width: 10),
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
            stpList.length == 0
                ? NoData()
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: stpList.length,
                      itemBuilder: (context, index) {
                        return schemeCard(stpList[index]);
                      },
                    ),
                  ),
            SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget schemeCard(stpList) {
    String? amfi_scheme_name = stpList['scheme_amfi_short_name'];
    String encodedName = amfi_scheme_name!.replaceAll("&", "%26");
    double? day_change = stpList['day_change_value'];

    String amfi_short_name =  stpList['scheme_name'];
    String encoded_amfi = amfi_short_name.replaceAll("&", "%26");

    return InkWell(
      onTap: () {
        Get.to(() => FundDetails(
            schemeAmfiCode: "${stpList['scheme_amfi_code']}",
            schemeName: "${stpList['scheme_name']}",
            schemeCategory: "${stpList['scheme_category']}",
            schemeAmcLogo: "${stpList['logo']}",
            currCost: stpList['current_cost'] ?? 0,
            currValue: stpList['current_value'] ?? 0,
            xirr: "${stpList['xirr']}",
            folio: "${stpList['folio_no']}", folioType: '',));
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            InkWell(
              onTap: (){
                Get.to(SchemeInfo(
                  schemeName: encoded_amfi,
                  schemeLogo: "${stpList['logo']}",
                  schemeShortName: encodedName));
              },
              child: RpListTile(
                showArrow: true,
                subTitle: Text("Folio : ${stpList['folio_no']}",
                    style: f40012.copyWith(color: Colors.black)),
                leading: Image.network(
                  stpList['logo'] ?? "",
                  height: 32,
                ),
                title: Text(
                  "${stpList['scheme_amfi_short_name']}",
                  style: AppFonts.f50014Grey.copyWith(color: Colors.blue),
                  maxLines: 3,
                ),),
            ),

            // Text("Monthly STP of ₹5,000 on 12th",style:AppFonts.f50012 .copyWith(color: Config.appTheme.themeColor)),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
              child: Column(
                children: [
                  SizedBox(height: 16,),
                  rpRow(
                      lhead: "Units",
                      lSubHead: Utils.formatNumber(stpList['units']),
                      rhead: "Current Cost",
                      rSubHead: "$rupee ${Utils.formatNumber(stpList['current_cost'])}",
                      chead: "Current Value",
                      cSubHead: "$rupee ${Utils.formatNumber(stpList['current_value'])}"),

                  SizedBox(height: 16,),
                  rpRow(
                      lhead: "Unrealised Gain",
                      lSubHead: "$rupee ${Utils.formatNumber(stpList['unrealised_gain'])}",
                      rhead: "Realised Gain",
                      rSubHead: "$rupee ${Utils.formatNumber(stpList['realised_gain'])}",
                      chead: "Abs Rtn (%)",
                      cSubHead: Utils.formatNumber(stpList['absolute_return'])),

                  SizedBox(height: 16,),
                  rpRow(
                      lhead: "XIRR (%)",
                      lSubHead: Utils.formatNumber(stpList['xirr']),
                      rhead: (userData.oneDayChange == 1 || ((keys.contains("adminAsInvestor")) || (keys.contains("adminAsFamily")) != false))
                          ? "1 Day Change" : " ",
                      rSubHead: (userData.oneDayChange == 1 || ((keys.contains("adminAsInvestor")) || (keys.contains("adminAsFamily")) != false))
                          ? "$rupee ${Utils.formatNumber(stpList['day_change_value'])}" : " ",titleStyle: AppFonts.f40014,
                      valueStyle:AppFonts.f50016Grey.copyWith(color: (day_change! < 0) ? Config.appTheme.defaultLoss : Config.appTheme.defaultProfit),
                      chead: "", cSubHead: ""),
                ],
              ),
            ),
          ],
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

  List sortOptions = [
    "Current Value",
    "Current Cost",
    "A to Z",
    "XIRR",
    "Absolute Return",
    "Unrealized Gain"
  ];

  String selectedSort = "";

  void applySort() {
    if (selectedSort == "Current Cost") {
      stpList.sort(
        (a, b) => (b['current_cost'] as double)
            .compareTo(a['current_cost'] as double),
      );
    } else if (selectedSort == "Current Value") {
      stpList.sort(
        (a, b) => (b['current_value'] as double)
            .compareTo(a['current_value'] as double),
      );
    } else if (selectedSort == "A to Z") {
      stpList.sort(
        (a, b) => (a['scheme_amfi_short_name'] as String)
            .compareTo(b['scheme_amfi_short_name'] as String),
      );
    } else if (selectedSort == "XIRR") {
      stpList.sort(
        (a, b) => (b['xirr'] as double).compareTo(a['xirr'] as double),
      );
    } else if (selectedSort == "Absolute Return") {
      stpList.sort(
        (a, b) => (b['absoluteReturn'] as double? ?? 0)
            .compareTo(a['absoluteReturn'] as double? ?? 0),
      );
    } else if (selectedSort == "Unrealized Gain") {
      stpList.sort(
        (a, b) => (b['unrealised_gain'] as double)
            .compareTo(a['unrealised_gain'] as double),
      );
    }
  }

  Map viewOptions = {
    "XIRR": 'xirr',
    "Unrealized Gain": 'unrealised_gain',
    "Abs Return": 'absolute_return',
  };
  String selectedView = "XIRR";
}
