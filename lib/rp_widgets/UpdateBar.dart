import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class UpdateBar extends StatelessWidget {
  const UpdateBar({super.key, required this.onUpdate, required this.onClose});

  final Function() onUpdate;
  final Function() onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Expanded(child: Text("App Update Available")),
          GestureDetector(
            onTap: onUpdate,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Config.appTheme.themeColor)),
              child:
                  Text("Update", style: AppFonts.f50012.copyWith(fontSize: 12)),
            ),
          ),
          SizedBox(width: 22),
          Container(
            padding: EdgeInsets.all(2),
            decoration:
                BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
            child: GestureDetector(
              onTap: onClose,
              child: Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
