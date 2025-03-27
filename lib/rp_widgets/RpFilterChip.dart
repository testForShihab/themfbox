import 'package:flutter/material.dart';

import 'package:mymfbox2_0/utils/AppFonts.dart';

class RpFilterChip extends StatelessWidget {
  const RpFilterChip({
    super.key,
    required this.selectedSort,
    this.hasClose = true,
    this.onClose,
    this.margin = const EdgeInsets.only(right: 8),
  });

  final String selectedSort;
  final bool hasClose;
  final Function()? onClose;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClose,
      child: Container(
        margin: margin,
        padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.white)),
        child: Row(
          children: [
            Text(selectedSort,
                style: AppFonts.f40013.copyWith(color: Colors.black)),
            SizedBox(width: 4),
            if (hasClose) Icon(Icons.close, size: 16)
          ],
        ),
      ),
    );
  }
}
