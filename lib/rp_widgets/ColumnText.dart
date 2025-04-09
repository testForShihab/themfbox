import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';

class ColumnText extends StatelessWidget {
  const ColumnText({
    super.key,
    required this.title,
    required this.value,
    this.alignment,
    this.titleStyle,
    this.valueStyle,
    this.hasRightPadding = false,
  });

  final String title, value;
  final CrossAxisAlignment? alignment;
  final bool hasRightPadding;

  final TextStyle? titleStyle, valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: hasRightPadding ? 10 : 0),
      child: Column(
        crossAxisAlignment: alignment ?? CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle ?? AppFonts.f40013,
            softWrap: true,
            maxLines: 3,
          ),
          Text(value,
              style: valueStyle ??
                  AppFonts.f50014Grey.copyWith(color: Colors.black))
        ],
      ),
    );
  }
}

class AdminColumnText extends StatelessWidget {
  const AdminColumnText({
    super.key,
    required this.title,
    required this.value,
    this.alignment,
    this.titleStyle,
    this.valueStyle,
  });

  final String title, value;
  final CrossAxisAlignment? alignment;
  final TextStyle? titleStyle, valueStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment ?? CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: AppFonts.f70024.copyWith(fontSize: 18),
              softWrap: true,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

          ],
        ),

        Row(
          children: [
            Text(
              value,
              style: valueStyle ??
                  TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
            ),
            SizedBox(width: 5,),
            Icon(
              Icons.arrow_forward,
              size: 16,
              color: Colors.black,
            ),
          ],
        ),

        SizedBox(height: 8,),

      ],
    );
  }
}

class RowText extends StatelessWidget {
  const RowText({
    super.key,
    required this.title,
    required this.value,
    this.alignment,
    this.titleStyle,
    this.valueStyle,
    this.hasRightPadding = false,
  });

  final String title, value;
  final CrossAxisAlignment? alignment;
  final bool hasRightPadding;

  final TextStyle? titleStyle, valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom:12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle ??  AppFonts.f50014Grey.copyWith(color: Colors.black),
            softWrap: true,
            maxLines: 3,
          ),
          Text(value,
              style: valueStyle ??
                  AppFonts.f50014Grey.copyWith(color: Colors.black))
        ],
      ),
    );
  }
}

