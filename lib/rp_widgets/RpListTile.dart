import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class RpListTile extends StatelessWidget {
  const RpListTile({
    super.key,
    required this.title,
    this.subTitle,
    this.leading,
    this.showArrow = true,
  });
  final Widget title;
  final Widget? subTitle;
  final Widget? leading;
  final bool showArrow;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leading ??
            Image.asset('assets/note.png',
                color: Config.appTheme.themeColor, height: 28),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              subTitle ?? Text("data"),
            ],
          ),
        ),
        if (showArrow)
          Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
      ],
    );
  }
}

class MFRpListTile extends StatelessWidget {
  const MFRpListTile({
    super.key,
    required this.title,
    this.subTitle,
    this.showArrow = true,
  });
  final Widget title;
  final Widget? subTitle;
  final bool showArrow;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              subTitle ?? Text("data"),
            ],
          ),
        ),
        if (showArrow)
          Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
      ],
    );
  }
}
