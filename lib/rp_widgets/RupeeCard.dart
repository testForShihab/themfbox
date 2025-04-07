import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class RupeeCard extends StatelessWidget {
  const RupeeCard({
    super.key,
    required this.title,
    this.text = "Min Investment",
    required this.minAmount,
    this.onChange,
    this.initialValue = "",
    required this.hintTitle,
    this.showText = true,
  });
  final String title, initialValue, text, hintTitle;
  final num minAmount;
  final Function(String)? onChange;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppFonts.f50014Black),
          SizedBox(height: 16),
          Row(
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(16, 9.5, 16, 9.5),
                  decoration: BoxDecoration(
                    color: Config.appTheme.mainBgColor,
                    border: Border(
                      left: BorderSide(
                          width: 2,
                          color: Config.appTheme.lineColor),
                      top: BorderSide(
                          width: 2,
                          color: Config.appTheme.lineColor),
                      bottom: BorderSide(
                          width: 2,
                          color: Config.appTheme.lineColor),
                    ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        topLeft: Radius.circular(25)),
                  ),
                  child: Text(rupee,  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey))),
              Expanded(
                child: TextFormField(
                  maxLength: 9,
                  keyboardType: TextInputType.numberWithOptions(),
                  initialValue: initialValue,
                  onChanged: onChange,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      counterText: "",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Config.appTheme.lineColor, width: 1),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Config.appTheme.lineColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      hintText: hintTitle),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (showText)
            Text("$text ₹ ${Utils.formatNumber(minAmount)}",
                style: AppFonts.f50012
                    .copyWith(color: Config.appTheme.readableGreyTitle)),
        ],
      ),
    );
  }
}
