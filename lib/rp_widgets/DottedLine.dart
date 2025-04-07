import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class DottedLine extends StatelessWidget {
  const DottedLine(
      {super.key,
      this.height = 20,
      this.count = 100,
      this.verticalPadding = 0});
  final double height;
  final int count;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: SizedBox(
        height: height,
        child: ListView.builder(
            itemCount: count,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Text("-",
                style: TextStyle(
                    color: Config.appTheme.placeHolderInputTitleAndArrow))),
      ),
    );
  }
}
