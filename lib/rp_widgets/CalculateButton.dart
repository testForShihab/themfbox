import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class CalculateButton extends StatelessWidget {
  const CalculateButton(
      {super.key,
      required this.onPress,
      this.text = "CALCULATE",
      this.shape,
      this.textStyle});
  final Function() onPress;
  final String text;
  final OutlinedBorder? shape;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.sizeOf(context).width;

    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: SizedBox(
          height: 45,
          child: ElevatedButton(
              onPressed: onPress,
              style: ElevatedButton.styleFrom(
                backgroundColor: Config.appTheme.themeColor,
                foregroundColor: Colors.white,
                shape: shape,
              ),
              child: Text(text, style: textStyle))),
    );
  }
}
