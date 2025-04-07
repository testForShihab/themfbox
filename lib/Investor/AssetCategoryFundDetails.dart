import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/pojo/InvestorAssetCategoryPojo.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DayChange.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/NoData.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';


class AssetCategoryFundDetails extends StatefulWidget {
  AssetCategoryFundDetails({
    super.key, required this.category, required this.folioType,
  });

  CategoryList category;
  String folioType;


  @override
  State<AssetCategoryFundDetails> createState() => _AssetCategoryFundDetailsState();
}

class _AssetCategoryFundDetailsState extends State<AssetCategoryFundDetails> {
  late double devWidth;
  late num oneDayChange;
  Iterable keys = GetStorage().getKeys();

  //same screen used for inv & family
  int userId = GetStorage().read('user_id') ?? GetStorage().read("family_id");
  Map result = {};
  String clientName = GetStorage().read("client_name");

  bool isLoading = true;
  List<dynamic> transctionData = [];
  CategoryList category = CategoryList();


  @override
  void initState() {
    super.initState();
    category = widget.category;

  }

  late Map transactionList;

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: AppBar(
        backgroundColor: Config.appTheme.themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Expanded(
          child: Text(
            "${category.category}",
            style: AppFonts.f70018Green.copyWith(color: Colors.white),
          ),
        )
      ),
      body: SideBar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: category.schemeList!.length,
                        itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          folioDetails(category.schemeList![index]),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget trnxArea() {
    if (transctionData.isEmpty) return NoData(margin: EdgeInsets.only(top: 16));

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: transctionData.length,
      itemBuilder: (context, index) {
        return transactionTile(index);
      },
    );
  }

  Widget transactionTile(int index) {
    double transNav = transctionData[index]['tranx_nav'];
    double tranxUnits = transctionData[index]['tranx_units'];
    return Container(
      width: devWidth,
      margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
      padding: EdgeInsets.all(16.0), // Add padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffECFFFF), // Background color
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                padding: EdgeInsets.all(8), // Adjust padding as needed
                child: Text(
                  '${transctionData[index]['tranx_type']}',
                  style: AppFonts.f50014Black
                      .copyWith(color: Config.appTheme.themeColor),
                ),
              ),
              Text(
                "$rupee ${Utils.formatNumber(transctionData[index]['tranx_amount'], isAmount: false)}",
                style:
                    AppFonts.f50014Black.copyWith(color: AppColors.textGreen),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Date",
                  value: transctionData[index]['tranx_date'],
                  titleStyle:
                      AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                  valueStyle: AppFonts.f50014Black),
              ColumnText(
                title: "NAV",
                value: '$transNav',
                alignment: CrossAxisAlignment.center,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black,
              ),
              ColumnText(
                title: "Units",
                value: Utils.formatNumber(tranxUnits),
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.arrowGrey),
                valueStyle: AppFonts.f50014Black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget folioDetails(SchemeList schemeList) {
    String schemeName = schemeList.schemeAmfiShortName ?? '';
    String folioNo = schemeList.folioNo ?? '';
    String startDate = schemeList.startDate ?? '';
    String totalUnits = Utils.formatNumber(schemeList.units ?? 0.0);
    num navUnits = schemeList.latestNav ?? 0.0;
    num navAvg = schemeList.avgNav ?? 0.0;
    String navDate = schemeList.navDate ?? '';
    String logo = schemeList.logo ?? '';
    String? unrealisedGain = Utils.formatNumber(schemeList.unrealisedGain);
    String absRtn = schemeList.absRtn.toString();
    String xiir = schemeList.xirr.toString();
    String currentValue = Utils.formatNumber(schemeList.currentValue);
    String currentCost = Utils.formatNumber(schemeList.currentCost);
    String dividend = schemeList.dividend.toString();
    String schemeWeight = schemeList.schemeWeight.toString();

  return SingleChildScrollView(
    child: Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              children: [
                // Image.network("${scheme.amcLogo}", height: 32),
                Utils.getImage(logo, 32),
                SizedBox(width: 10),
                Expanded(
                  child: ColumnText(
                    title: schemeName,
                    value: "Folio : $folioNo",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            rpRow(
              rhead: "Total Units",
              rSubHead: "$totalUnits",
              chead: "Latest NAV",
              cSubHead: "$navUnits",
              lhead: 'Start Date', lSubHead: startDate,
            ),
            rpDottedLine(),
            rpRow(
              lhead: "Current Cost",
              lSubHead: currentCost,
              chead: "Avg NAV",
              cSubHead: navAvg.toStringAsFixed(3),
              rhead: 'Dividend', rSubHead: dividend,
            ),
            rpDottedLine(),
            rpRow(
              rhead: "Current Value",
              rSubHead: currentValue,
              lhead: "NAV Date",
              lSubHead: navDate,
              chead: 'Unrealised Gain', cSubHead: unrealisedGain.toString(),
            ),
            rpDottedLine(),
            rpRow(
              lhead: "Abs Rtn", lSubHead: "$absRtn %",
              rhead: "Scheme Weight", rSubHead: schemeWeight,
              chead: 'XIRR', cSubHead: "$xiir %",
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
        Expanded(child: ColumnText(title: lhead, value: lSubHead,alignment: CrossAxisAlignment.start,valueStyle: valueStyle,titleStyle: titleStyle,)),
        Expanded(child: ColumnText(title: rhead, value: rSubHead,alignment: CrossAxisAlignment.center,valueStyle: valueStyle,titleStyle: titleStyle,)),
        Expanded(child: ColumnText(title: chead,value: cSubHead,alignment: CrossAxisAlignment.end,valueStyle: valueStyle,titleStyle: titleStyle,)),
      ],
    );
  }

  Widget rpDottedLine() {
    return Column(
      children: [
        SizedBox(height: 5),
        DottedLine(),
        SizedBox(height: 5),
      ],
    );
  }
}
