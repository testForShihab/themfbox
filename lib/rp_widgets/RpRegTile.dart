import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class RpRegTile extends StatelessWidget {
  const RpRegTile(
      {super.key,
      this.leading,
      required this.title,
      required this.isCompleted,
      this.onTap,
      required this.subTitle});
  final Widget? leading;
  final String title;
  final bool isCompleted;
  final Function()? onTap;
  final Widget subTitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          (isCompleted)
              ? Image.asset("assets/registration/check_circle.png", height: 50)
              : CircleAvatar(
                  backgroundColor: Config.appTheme.themeColor,
                  radius: 25,
                  child: leading,
                ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppFonts.f50014Black,
              ),
              subTitle
            ],
          )
        ],
      ),
    );
  }
}
