import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class RpListTile1 extends StatelessWidget {
  const RpListTile1({super.key, required this.title, this.leading});
  final Widget title;
  final Widget? leading;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leading ??
            Image.asset('assets/note.png',
                color: Config.appTheme.themeColor, height: 28),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
          ],
        ),
        Spacer(),
        Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
      ],
    );
  }
}
