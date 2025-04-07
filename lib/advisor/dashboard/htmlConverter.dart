import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HtmlConverter extends StatefulWidget {
  const HtmlConverter({super.key});

  @override
  State<HtmlConverter> createState() => _HtmlConverterState();
}

class _HtmlConverterState extends State<HtmlConverter> {
  List list = [
    "option value=01>Residential/Business</option>",
    "option value=02>Residential</option>",
    "option value=03>Business</option>",
    "option value=04>Registered office</option>",
    "option value=05>Unspecified</option>",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("convert"),
          onPressed: () {
            Get.back();

            Map map = {};
            list.forEach((element) {
              int start1 = element.indexOf('>') + 1;
              int end1 = element.indexOf('<');

              int start2 = element.indexOf('=') + 1;
              int end2 = element.indexOf('>');

              String value = element.substring(start1, end1);
              String key = element.substring(start2, end2);

              map[value] = key;
            });
            print("map = ${jsonEncode(map)}");
          },
        ),
      ),
    );
  }
}
