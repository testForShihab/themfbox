import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class AppBarColumn extends StatelessWidget {
  const AppBarColumn({
    super.key,
    required this.title,
    required this.value,
    this.suffix,
    this.enabled = true,
    required this.onTap,
  });
  final String title, value;
  final Widget? suffix;
  final bool enabled;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(title, style: AppFonts.f40013.copyWith(color: Colors.white)),
          Container(
            padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: enabled
                  ? Config.appTheme.overlay85
                  : Config.appTheme.overlay85.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Row(
                children: [
                  Text(value,
                      style: TextStyle(
                          color: Config.appTheme.themeColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Spacer(),
                  suffix ??
                      Icon(Icons.keyboard_arrow_down,
                          color: Config.appTheme.themeColor)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
