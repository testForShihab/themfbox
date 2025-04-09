import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class AumCard extends StatefulWidget {
  const AumCard({super.key, required this.dashboardData});
  final Map dashboardData;

  @override
  State<AumCard> createState() => _AumCardState();
}

class _AumCardState extends State<AumCard> {
  int type_id = GetStorage().read("type_id");

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    String aum =
        Utils.formatNumber(widget.dashboardData['aum_total'], isShortAmount: false);

    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // color: Config.appTheme.themeColor,
          image: DecorationImage(
            image: (Config.app_client_name != "vbuildwealth")
                ? AssetImage("assets/aumCardBg.png")
                : AssetImage("assets/aumOrangeBg.png"),
            fit: BoxFit.cover,
            colorFilter:
                ColorFilter.mode(Config.appTheme.themeColor, BlendMode.color),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Mutual Fund AUM",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
              ),
              //if(type_id == UserType.ADMIN || type_id == UserType.RM || type_id == UserType.BRANCH)
              Icon(Icons.arrow_forward, color: Colors.white)
            ],
          ),
          SizedBox(height: 12),
          Text(
            "$rupee $aum",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 25),
          ),
          if(type_id == UserType.ADMIN)
          dayChange(),
        ],
      ),
    );
  }

  Widget dayChange() {
    String change =
        Utils.formatNumber(widget.dashboardData['aum_change_value'], isAmount: true);
    num changePercentage = widget.dashboardData['aum_change_percentage'] ?? 0;

    return Row(
      children: [
        Text(
          "1 Day Change: ",
          style: TextStyle(
              color: Config.appTheme.whiteOverlay,
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
        Text(
          "$rupee $change",
          style: TextStyle(
              color: Config.appTheme.whiteOverlay,
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
        // Icon(Icons.arrow_drop_up, color: Color(0xffB1E33D)),
        Text(" ($changePercentage %)",
            style: TextStyle(
                color: changePercentage.isNegative
                    ? Config.appTheme.defaultLoss
                    : Config.appTheme.themeProfit,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
        Icon(
          changePercentage.isNegative
              ? Icons.arrow_downward
              : Icons.arrow_upward,
          size: 15,
          color: changePercentage.isNegative
              ? Config.appTheme.defaultLoss
              : Config.appTheme.themeProfit,
        )
      ],
    );
  }
}
