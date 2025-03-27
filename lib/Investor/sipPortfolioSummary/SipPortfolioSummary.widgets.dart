import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

String selectedView = "XIRR";
Map viewOptions = {
  "XIRR": 'xirr',
  "Gain/Loss": 'realisedGainLoss',
  "Abs Return": 'absolute_return'
};
Iterable keys = GetStorage().getKeys();
Widget summaryCard({
  num? currValue,
  num? currCost,
  num? amount,
  num? gainLoss,
  num? xirr,
  num? dayChangeAmount,
  num? dayChangePercentage,
  num? totalCount,
  String? type,
  num? oneDayChange,
}) {
  String tempCurrValue = Utils.formatNumber(currValue);
  String tempCurrCost = Utils.formatNumber(currCost);
  String tempSipAmount = Utils.formatNumber(amount);
  num tempGainLoss = gainLoss!.round();
  num tempXirr = xirr ?? 0;


  return Container(
    color: Config.appTheme.themeColor,
    child: Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
          color: Config.appTheme.overlay85,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Current Value as on ${Utils.getFormattedDate()}",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: AppColors.readableGrey,
              )),
          SizedBox(height: 10),
          Text(
            "$rupee $tempCurrValue",
            style: AppFonts.f70024.copyWith(color: Config.appTheme.themeColor),
          ),
         /* if((type == 'SIP') &&(oneDayChange == 1 || ((keys.contains("adminAsInvestor")) || (keys.contains("adminAsFamily")) != false)) )
          dayChange(dayChangeAmount, dayChangePercentage),*/
          SizedBox(height: 5),
          DottedLine(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(title: "Current Cost", value: "$rupee $tempCurrCost"),
              ColumnText(
                  title: "Unrealized Gain",
                  value: "$rupee ${Utils.formatNumber(tempGainLoss)}",
                  alignment: CrossAxisAlignment.center),
              ColumnText(
                  title: "XIRR",
                  value: "${tempXirr.toStringAsFixed(2)} %",
                  alignment: CrossAxisAlignment.end),
            ],
          ),
          DottedLine(),
          Row(
            children: [
              Text("Total ${totalCount} ${type}s worth : ",
                  style: f40012.copyWith(color: AppColors.readableGrey)),
              SizedBox(width: 10),
              Text("$rupee $tempSipAmount",
                  style: AppFonts.f50014Grey.copyWith(color: Colors.black))
            ],
          ),
        ],
      ),
    ),
  );
}

Widget dayChange(num? amount, num? percentage) {
  String dayChangeAmount = Utils.formatNumber(amount!.round());
  num dayChangePercentage = percentage ?? 0;

  return Row(
    children: [
      Text(
        "1 Day Change ",
        style: TextStyle(
            color: AppColors.readableGrey,
            fontWeight: FontWeight.w500,
            fontSize: 12),
      ),
      Text(
        "$rupee $dayChangeAmount",
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      Text(" (${dayChangePercentage.toStringAsFixed(2)}%)",
          style: AppFonts.f50014Black.copyWith(
              fontSize: 13,
              color: (dayChangePercentage > 0)
                  ? Config.appTheme.defaultProfit
                  : Config.appTheme.defaultLoss)),
    ],
  );
}
