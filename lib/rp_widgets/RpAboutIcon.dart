import 'package:flutter/material.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';

class RpAboutIcon extends StatelessWidget {
  const RpAboutIcon({super.key, required this.context, this.text});
  final BuildContext context;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showAboutBottomSheet();
        },
        child: Icon(Icons.pending_outlined));
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
