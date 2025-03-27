import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';

import '../utils/Config.dart';
import '../utils/Constants.dart';
import 'BottomSheetTitle.dart';

class NoData extends StatelessWidget {
  const NoData({super.key, this.margin = const EdgeInsets.all(16),this.text ="No data available"});
  final EdgeInsets margin;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.maxFinite,
        margin: margin,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Icon(Icons.close),
            SizedBox(height: 10),
            Text(text, style: AppFonts.f40013),
          ],
        ),
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Icon(Icons.close),
            SizedBox(
              height: 10,
            ),
            Text(
              "No Scheme Available",
              style: AppFonts.f40013,
            ),
          ],
        ),
      ),
    );
  }
}

class MfAboutIcon extends StatelessWidget {
  const MfAboutIcon({super.key, required this.context, this.text});
  final BuildContext context;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showAboutBottomSheet();
      },
      child: Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
    );
  }

  showAboutBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          decoration:
              BoxDecoration(color: Colors.white, borderRadius: cornerBorder),
          child: Column(
            children: [
              BottomSheetTitle(title: "About"),
              Divider(
                height: 0,
                color: Config.appTheme.lineColor,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 24, 16),
                child: Text(
                  text ??
                      """
Most consistent funds consisting of Top 10 Mutual Fund Schemes in each category have been chosen based on average rolling returns and consistency with which funds have beaten category average returns. 

 We have ranked schemes based on these two parameters using our proprietary algorithm and are showing the most consistent schemes for each category. Note that we have ranked schemes which have performance track records of at least 5 years (consistency cannot be measured unless a scheme has sufficiently long track record covering multiple market cycles e.g. bull market, bear market, sideways market etc.). 

Also note that, schemes whose AUMs have not yet reached Rs 500 Crores have been excluded from the ranking.
 """,
                  textAlign: TextAlign.justify,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
