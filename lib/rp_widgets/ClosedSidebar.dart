import 'package:flutter/material.dart';

class ClosedSideBar extends StatelessWidget {
  const ClosedSideBar(
      {super.key,
      this.onTap,
      required this.name,
      this.top = 400,
      this.rightBorder = 30,
      this.leftBorder = 0});
  final Function()? onTap;
  final String name;
  final double top;
  final double rightBorder, leftBorder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.horizontal(
              right: Radius.circular(rightBorder),
              left: Radius.circular(leftBorder),
            )),
        padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white), shape: BoxShape.circle),
          child: Center(
              child: Text(name[0], style: TextStyle(color: Colors.white))),
        ),
      ),
    );
  }
}
