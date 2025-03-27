import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class ViewAllBtn extends StatelessWidget {
  const ViewAllBtn({super.key, this.onTap, this.text = "View All "});
  final Function()? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
            onPressed: onTap,
            child: Row(
              children: [
                Text(text,
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor)),
                Icon(Icons.arrow_forward,
                    size: 20, color: Config.appTheme.themeColor)
              ],
            )),
      ],
    );
  }
}
