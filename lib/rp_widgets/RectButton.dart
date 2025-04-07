import 'package:flutter/material.dart';

class RectButton extends StatelessWidget {
  const RectButton(
      {super.key,
      required this.leading,
      required this.title,
      required this.fgColor,
      required this.bgColor,
      this.onPressed,
      this.trailing,
      this.imgSize = 30});
  final String leading, title;
  final Color fgColor, bgColor;
  final Widget? trailing;
  final double imgSize;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onPressed,
      child: Container(
        width: devWidth,
        height: 50,
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: bgColor)),
        child: Center(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Image.asset(leading, height: imgSize),
              SizedBox(width: 10),
              Text(title,
                  style:
                      TextStyle(color: fgColor, fontWeight: FontWeight.w500)),
              Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
        )),
      ),
    );
  }
}
