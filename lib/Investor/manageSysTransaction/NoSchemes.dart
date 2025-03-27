import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';

class NoSchemes extends StatelessWidget {
  const NoSchemes({super.key, required this.img, required this.name});
  final String img, name;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Image.asset(img, color: Colors.grey[400], height: 50),
          SizedBox(height: 16),
          Text("You Currently have No $name", style: AppFonts.f40013)
        ],
      ),
    );
  }
}
