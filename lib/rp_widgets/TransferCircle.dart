import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class TransferCircle extends StatelessWidget {
  const TransferCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Config.appTheme.themeColor),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 5, vertical: 4), // Adjust padding as needed
          child: Icon(
            Icons.arrow_forward,
            color: Config.appTheme.themeColor,
            size: 18, // Adjust the size of the arrow icon as needed
          ),
        ),
      ),
    );
  }
}
