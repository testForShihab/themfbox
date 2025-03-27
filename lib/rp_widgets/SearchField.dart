import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class SearchField extends StatelessWidget {
  SearchField({
    super.key,
    this.hintText = "",
    this.bgColor,
    this.onChange,
    this.controller,
  });

  final String hintText;
  Color? bgColor;
  final Function(String)? onChange;
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    bgColor ??= Config.appTheme.themeColor;

    double devWidth = MediaQuery.of(context).size.width;
    return Container(
      width: devWidth,
      height: 50,
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: bgColor ?? Config.appTheme.themeColor)),
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 5),
        child: Row(
          children: [
            Image.asset("assets/person_search.png",
                height: 30,
                color: (bgColor == Config.appTheme.themeColor)
                    ? null
                    : Colors.black),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: controller,
                onChanged: onChange,
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    hintText: hintText,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: bgColor!)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: bgColor!)),
                    hintStyle: TextStyle(
                        color: (bgColor == Config.appTheme.themeColor)
                            ? Colors.white
                            : Colors.black)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
