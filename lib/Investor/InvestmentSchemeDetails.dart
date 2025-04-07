import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/Config.dart';

import '../pojo/InvestmentSummaryPojo.dart';
import '../rp_widgets/ColumnText.dart';
import '../rp_widgets/DottedLine.dart';
import '../rp_widgets/RpChip.dart';
import '../rp_widgets/SideBar.dart';
import '../utils/AppFonts.dart';
import '../utils/Constants.dart';
import '../utils/Utils.dart';

class InvestmentSchemeDetails extends StatefulWidget {
  const InvestmentSchemeDetails({
    super.key,
    required this.generalScheme,
    required this.trnxList,
  });

  final GeneralSchemeList generalScheme;
  final List<TrnxList> trnxList;

  @override
  State<InvestmentSchemeDetails> createState() => _InvestmentSchemeDetailsState();
}

class _InvestmentSchemeDetailsState extends State<InvestmentSchemeDetails> {
  late GeneralSchemeList scheme;
  late List<TrnxList> trnxList;

  @override
  void initState() {
    super.initState();
    scheme = widget.generalScheme;
    trnxList = widget.trnxList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: AppBar(
        backgroundColor: Config.appTheme.themeColor,
        foregroundColor: Colors.white,
      ),
      body: SideBar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              greencard(),
              SizedBox(height: 20),
              transactionList()
            ],
          ),
        ),
      ),
    );
  }

  Widget greencard(){
    String? schemeName = scheme.schemeAmfiShortName;
    if (schemeName!.isEmpty) schemeName = scheme.schemeAmfi;
    return Container(
      color: Config.appTheme.themeColor,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Utils.getImage("${scheme.logo}", 32),
              SizedBox(width: 10),
              Expanded(
                child: ColumnText(
                  title: schemeName!,
                  value: "Folio : ${scheme.folioNo}",
                  titleStyle:AppFonts.appBarTitle.copyWith(color: Colors.white),
                  valueStyle:  AppFonts.f40013.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          /*Row(
            children: [
              Expanded(
                child: ColumnText(
                  title: "Current Cost",
                  value:
                  "$rupee ${Utils.formatNumber((scheme.?.round()))}",
                  titleStyle:
                  AppFonts.f40013.copyWith(color: Color(0XFFDEE6E6)),
                  valueStyle: AppFonts.f50014Grey.copyWith(color: Colors.white),
                ),
              ),
              Expanded(
                child: ColumnText(
                  title: "Current Value",
                  value:
                  "$rupee ${Utils.formatNumber((scheme.marketValue?.round()))}",
                  alignment: CrossAxisAlignment.center,
                  titleStyle:
                  AppFonts.f40013.copyWith(color: Color(0XFFDEE6E6)),
                  valueStyle: AppFonts.f50014Grey.copyWith(color: Colors.white),
                ),
              ),
              Expanded(
                child: ColumnText(
                  title: "XIRR",
                  value: "${scheme.xirr}%",
                  alignment: CrossAxisAlignment.end,
                  titleStyle:
                  AppFonts.f40013.copyWith(color: Color(0XFFDEE6E6)),
                  valueStyle: AppFonts.f50014Grey.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),*/
        ],
      ),
    );
  }

 Widget transactionList() {
   return ListView.builder(
     shrinkWrap: true,
     physics: NeverScrollableScrollPhysics(),
     itemCount: trnxList.length,
     itemBuilder: (context, index) {
       TrnxList trnx = trnxList[index];
       return transactionTile(trnx);
     },
   );
 }

  Widget transactionTile(TrnxList trnx) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Colors.white),
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${trnx.transactionDate}" ,style: AppFonts.f50014Theme),
                  RpChip(label: "${trnx.transactionType}"),
                ],
              ),
              SizedBox(height: 5),
              rpRow(
                  lhead: "NAV",
                  lSubHead: "${trnx.purchasePrice}",
                  rhead: "Units",
                  rSubHead: "${Utils.formatNumber(trnx.totalUnits)}",
                  chead: "Cumulative Units",
                  cSubHead: "${Utils.formatNumber(trnx.purchaseUnits)}",),
              SizedBox(height: 16,),
              rpRow(
                  lhead: "Amount",
                  lSubHead:"${Utils.formatNumber(trnx.purchaseAmount?.round())}",
                  rhead: "TDS",
                  rSubHead: "${trnx.tdsAmount}",
                  chead: "STT",
                  cSubHead: "${trnx.sttAmount}",),
              SizedBox(height: 16,),
              rpRow(
                lhead: "ARN Number",
                lSubHead:"${trnx.brokerCode}",
                rhead: "",
                rSubHead: "",
                chead: "",
                cSubHead: "",),
            ],
          ),
        )
      ],
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
       Expanded(
           child: ColumnText(
               title: lhead,
               value: lSubHead,
               alignment: CrossAxisAlignment.start)),
       Expanded(
           child: ColumnText(
             title: rhead,
             value: rSubHead,
             alignment: CrossAxisAlignment.center,
             valueStyle: valueStyle,
             titleStyle: titleStyle,
           )),
       Expanded(
           child: ColumnText(
               title: chead,
               value: cSubHead,
               alignment: CrossAxisAlignment.end)),
     ],
   );
 }


}
