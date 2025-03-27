import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class RatingChip extends StatelessWidget {
  const RatingChip({
    super.key,
    required this.rating,
  });
  final String rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
          color: Color(0xffEDFFFF),
          borderRadius: BorderRadius.horizontal(left: Radius.circular(15))),
      child: Row(children: [
        Text(rating, style: AppFonts.f50012),
        Icon(Icons.star, color: Config.appTheme.themeColor)
      ]),
    );
  }
}
