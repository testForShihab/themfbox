import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';

class RpPurchaseListTile extends StatelessWidget {
  const RpPurchaseListTile({
    super.key,
    required this.leading,
    required this.l1,
    required this.l2,
  });
  final Widget leading;
  final String l1, l2;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        leading,
        SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l1,
                  style: AppFonts.f50014Black, maxLines: 3, softWrap: true),
              Visibility(
                  visible: l2.isNotEmpty,
                  child: Text(l2,
                      style:
                          AppFonts.f40013.copyWith(color: Color(0xff242424)))),
            ],
          ),
        ),
      ],
    );
  }
}
