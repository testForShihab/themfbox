import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class BottomSheetTitle extends StatelessWidget {
  const BottomSheetTitle({
    super.key,
    required this.title,
    this.hasReset = false,
    this.onReset,
    this.padding = const EdgeInsets.all(16),
    this.resetText = "Reset",
  });
  final String title;
  final bool hasReset;
  final EdgeInsets padding;
  final Function()? onReset;
  final String resetText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      padding: padding,
      child: Row(
        children: [
          Text(title, style: AppFonts.f50014Black.copyWith(fontSize: 18)),
          Spacer(),
          if (hasReset)
            GestureDetector(
                onTap: onReset,
                child: Text(resetText, style: AppFonts.f50014Theme)),
          SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.close,
              color: Config.appTheme.placeHolderInputTitleAndArrow,
            ),
          )
        ],
      ),
    );
  }
}
