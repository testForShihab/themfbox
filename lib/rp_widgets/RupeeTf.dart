import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';

class RupeeTf extends StatelessWidget {
  const RupeeTf({
    super.key,
    required this.readOnly,
    required this.controller,
    required this.onChange,
    required this.hintText,
  });
  final bool readOnly;
  final TextEditingController controller;
  final Function(String) onChange;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11.5),
            decoration: BoxDecoration(
              color: Config.appTheme.mainBgColor,
              border: Border(
                left: BorderSide(width: 1, color: Config.appTheme.lineColor),
                top: BorderSide(width: 1, color: Config.appTheme.lineColor),
                bottom: BorderSide(width: 1, color: Config.appTheme.lineColor),
              ),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  topLeft: Radius.circular(25)),
            ),
            child: Text(rupee, style: AppFonts.f50014Grey)),
        Expanded(
          child: TextFormField(
            maxLength: 9,
            keyboardType: TextInputType.numberWithOptions(),
            readOnly: readOnly,
            controller: controller,
            onChanged: onChange,
            decoration: InputDecoration(
              counterText: '',
                contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Config.appTheme.lineColor, width: 1),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Config.appTheme.lineColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                hintText: hintText),
          ),
        ),
      ],
    );
  }
}
