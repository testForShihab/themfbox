import 'package:flutter/material.dart';

class RpDeletableChip extends StatelessWidget {
  const RpDeletableChip(
      {super.key,
      required this.title,
      required this.visible,
      required this.onDelete});
  final String title;
  final bool visible;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: Row(
          children: [
            Text(title),
            SizedBox(width: 5),
            GestureDetector(onTap: onDelete, child: Icon(Icons.close, size: 20))
          ],
        ),
      ),
    );
  }
}
