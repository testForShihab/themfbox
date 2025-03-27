import 'package:flutter/material.dart';
import 'package:mymfbox2_0/Investor/sipPortfolioSummary/SipSummary.dart';
import 'package:mymfbox2_0/Investor/sipPortfolioSummary/StpSummary.dart';
import 'package:mymfbox2_0/Investor/sipPortfolioSummary/SwpSummary.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class SipPortfolioSummary extends StatefulWidget {
  const SipPortfolioSummary({super.key, required this.selectType});

  final String selectType;
  @override
  State<SipPortfolioSummary> createState() => _SipPortfolioSummaryState();
}

class _SipPortfolioSummaryState extends State<SipPortfolioSummary> {
  List typeList = ["SIP", "STP", "SWP"];
  String selectedType = "";


  @override
  void initState() {
    super.initState();
    selectedType = widget.selectType;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: invAppBar(
          title: "$selectedType Portfolio Summary",
          showCartIcon: false,
          showNotiIcon: false),
      body: Column(
        children: [
          topArea(),
          if (selectedType == 'SIP') Expanded(child: SipSummary()),
          if (selectedType == 'STP') Expanded(child: StpSummary()),
          if (selectedType == 'SWP') Expanded(child: SwpSummary()),
        ],
      ),
    );
  }

  Widget topArea() {
    return Container(
      color: Config.appTheme.themeColor,
      padding: EdgeInsets.only(left: 16, bottom: 16),
      child: Row(
        children: List.generate(
            typeList.length,
            (index) => Expanded(
                  child: rpButon(
                      title: typeList[index],
                      isSelected: selectedType == typeList[index]),
                )),
      ),
    );
  }

  Widget rpButon({required String title, required bool isSelected}) {
    Color fgColor =
        (isSelected) ? Config.appTheme.themeColor : Config.appTheme.overlay85;
    Color bgColor =
        (isSelected) ? Config.appTheme.overlay85 : Config.appTheme.themeColor;

    return GestureDetector(
      onTap: () {
        selectedType = title;
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: bgColor,
            border: Border.all(color: Config.appTheme.overlay85)),
        child: Center(
            child: Text(
          title,
          style: AppFonts.f50014Black.copyWith(color: fgColor),
        )),
      ),
    );
  }
}
