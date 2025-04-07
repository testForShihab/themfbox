import 'package:flutter/material.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';

class SearchText extends StatefulWidget {
  const SearchText({
    Key? key,
    this.hintText = "",
    this.bgColor = Colors.white,
    this.onChange,
  }) : super(key: key);

  final String hintText;
  final Color bgColor;
  final Function(String)? onChange;

  @override
  _SearchTextState createState() => _SearchTextState();
}

class _SearchTextState extends State<SearchText> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    return Container(
      width: devWidth * 0.90,
      height: 46,
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: widget.bgColor),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.black),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                onChanged: widget.onChange,
                style: AppFonts.f40013.copyWith(
                  fontSize: 14,
                  color: _isFocused ? Colors.black : Color(0xFFB4B4B4),
                ),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: widget.bgColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: widget.bgColor),
                  ),
                  hintStyle: TextStyle(
                    color: _isFocused ? Colors.black : AppColors.arrowGrey,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _isFocused = true;
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    _isFocused = false;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
