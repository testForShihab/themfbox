import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../rp_widgets/ColumnText.dart';
import '../../../rp_widgets/DottedLine.dart';
import '../../../rp_widgets/NoData.dart';
import '../../../rp_widgets/SideBar.dart';
import '../../../utils/AppFonts.dart';
import '../../../utils/Config.dart';
import '../../../utils/Constants.dart';
import '../../../utils/Utils.dart';

class FamilyPortfolioAssetCategoryAllocationDetails extends StatefulWidget {
  final List<Map<String, dynamic>> schemeList;
  final String folioType;
  final String categoryName;

  FamilyPortfolioAssetCategoryAllocationDetails({
    super.key,
    required this.schemeList,
    required this.folioType,
    required this.categoryName,
  });

  @override
  State<FamilyPortfolioAssetCategoryAllocationDetails> createState() =>
      _FamilyPortfolioAssetCategoryAllocationDetailsState();
}

class _FamilyPortfolioAssetCategoryAllocationDetailsState
    extends State<FamilyPortfolioAssetCategoryAllocationDetails> {
  late double devWidth ,devHeight;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: AppBar(
          backgroundColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white,
          elevation: 0,
          title: Expanded(
            child: Text(
              widget.categoryName,
              style: AppFonts.f70018Green.copyWith(color: Colors.white),
            ),
          )),
      body: SideBar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: (widget.schemeList.isEmpty)
                ? NoData(text:'No data Available')
                :ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.schemeList.length,
              itemBuilder: (context, index) {
                return folioDetails(widget.schemeList[index]);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget folioDetails(Map<String, dynamic> scheme) {
    return (isLoading)
        ? Utils.shimmerWidget(devHeight,
        margin: EdgeInsets.zero)
        :Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Utils.getImage(scheme['logo'], 32),
              SizedBox(width: 10),
              Expanded(
                child: ColumnText(
                  title: scheme['scheme_amfi_short_name'] ?? '',
                  value: "Folio: ${scheme['folio_no'] ?? ''}",
                  titleStyle: AppFonts.f50014Black,
                  valueStyle: AppFonts.f40013,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Text(
                "Investor Name :",
                style: AppFonts.f40013,
              ),
              SizedBox(width: 5),
              Text(scheme['investor_name'] ?? '',
                  style: AppFonts.f50014Grey.copyWith(color: Colors.black)),
            ],
          ),
          SizedBox(height: 16),
          rpRow(
            lhead: "Start Date",
            lSubHead: scheme['start_date'] ?? '',
            rhead: "Units",
            rSubHead: "${scheme['units'] ?? 0.0}",
            chead: "Avg NAV",
            cSubHead: "${scheme['avg_nav'] ?? 0.0}",
          ),
          rpDottedLine(),
          rpRow(
            lhead: "Current Cost",
            lSubHead: Utils.formatNumber(scheme['current_cost'] ?? 0.0),
            rhead: "Dividend",
            rSubHead: "${Utils.formatNumber(scheme['dividend'] ?? 0.0)}",
            chead: "Latest NAV",
            cSubHead: "${scheme['latest_nav'] ?? 0.0}",
          ),
          rpDottedLine(),
          rpRow(
            lhead: "NAV Date",
            lSubHead: "${scheme['nav_date'] ?? 0.0}",
            rhead: "Current Value",
            rSubHead: Utils.formatNumber(scheme['current_value'] ?? 0.0),
            chead: "Unrealised Gain",
            cSubHead: Utils.formatNumber(scheme['unrealised_gain'] ?? 0.0),
          ),

          rpDottedLine(),
          rpRow(
            lhead: "Realised Gain",
            lSubHead: Utils.formatNumber(scheme['realised_gain'] ?? 0.0),
            rhead: "Absolute Return",
            rSubHead: "${scheme['abs_rtn']}%",
            chead: "XIRR",
            cSubHead: "${scheme['xirr']}%",
          ),

          // rpDottedLine(),
        ],
      ),
    );
  }

  // Widget rpRow({
  //   required String lhead,
  //   required String lSubHead,
  //   String? rhead,
  //   String? rSubHead,
  // }) {
  //   return Row(
  //     children: [
  //       Expanded(child: ColumnText(title: lhead, value: lSubHead)),
  //       if (rhead != null && rSubHead != null)
  //       Expanded(child: ColumnText(title: rhead, value: rSubHead)),
  //     ],
  //   );
  // }

  Widget rpDottedLine() {
    return Column(
      children: [
        SizedBox(height: 5),
        DottedLine(),
        SizedBox(height: 5),
      ],
    );
  }

  Widget rpRow({
    String? lhead,
    String? lSubHead,
    String? rhead,
    String? rSubHead,
    String? chead,
    String? cSubHead,
    final TextStyle? valueStyle,
    final TextStyle? titleStyle,
  }) {
    return Row(
      children: [
        if (lhead != null && lSubHead != null)
          Expanded(
              child: ColumnText(
            title: lhead,
            value: lSubHead,
            alignment: CrossAxisAlignment.start,
            valueStyle: valueStyle,
            titleStyle: titleStyle,
          )),
        if (rhead != null && rSubHead != null)
          Expanded(
              child: ColumnText(
            title: rhead,
            value: rSubHead,
            alignment: CrossAxisAlignment.center,
            valueStyle: valueStyle,
            titleStyle: titleStyle,
          )),
        if (chead != null && cSubHead != null)
          Expanded(
              child: ColumnText(
            title: chead,
            value: cSubHead,
            alignment: CrossAxisAlignment.end,
            valueStyle: valueStyle,
            titleStyle: titleStyle,
          )),
      ],
    );
  }
}
