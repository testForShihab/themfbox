import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class RpChip extends StatelessWidget {
  const RpChip(
      {super.key, required this.label, this.padding = const EdgeInsets.all(2)});
  final String label;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label,
          style: AppFonts.f40013.copyWith(color: Config.appTheme.themeColor)),
      padding: padding,
      backgroundColor: Color(0xFFECFFFF),
      shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Color(0xFFECFFFF),
          ),
          borderRadius: BorderRadius.circular(12)),
    );
  }
}
