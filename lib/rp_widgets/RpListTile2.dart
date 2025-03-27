import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';

class RpListTile2 extends StatelessWidget {
  ///used in invFamWise Brokerage
  const RpListTile2({
    super.key,
    required this.leading,
    required this.l1,
    required this.l2,
    required this.r1,
    required this.r2,
    this.padding = const EdgeInsets.fromLTRB(16, 6, 16, 6),
    this.hasArrow = true,
    this.gap = 0,
  });
  final Widget leading;
  final String l1, l2;
  final String r1, r2;
  final EdgeInsets padding;
  final bool hasArrow;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          leading,
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l1, style: AppFonts.f50014Black),
                if (l2.isNotEmpty) Text(l2, style: AppFonts.f40013),
              ],
            ),
          ),
          SizedBox(width: gap),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(r1, style: AppFonts.f50014Black),
              if (r2.isNotEmpty) Text(r2, style: AppFonts.f40013),
            ],
          ),
          if (hasArrow) SizedBox(width: 5),
          if (hasArrow)
            Icon(Icons.arrow_forward_ios, color: AppColors.arrowGrey, size: 18)
        ],
      ),
    );
  }
}
