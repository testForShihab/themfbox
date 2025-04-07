import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class SchemeNameCard extends StatelessWidget {
  const SchemeNameCard(
      {super.key, required this.logo, required this.shortName});
  final String logo, shortName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Config.appTheme.themeColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.network(logo, height: 32),
              SizedBox(width: 10),
              Expanded(
                  child: Text(shortName,
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ],
      ),
    );
  }
}
