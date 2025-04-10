// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class BrokerageCard extends StatelessWidget {
  const BrokerageCard({
    super.key,
    required this.title,
    required this.lHead,
    required this.lSubHead,
    required this.rHead,
    required this.rSubHead,
    this.padding = const EdgeInsets.only(right: 8),
    this.extraWidgets = const [],
    this.hasArrow = true,
    this.hasTitle = true,
    this.titleArrow = true,
    this.lHeadonTap,
    this.rHeadonTap,
  });
  final dynamic lHead, rHead;
  final dynamic lSubHead, rSubHead;
  final String title;
  final List<Widget> extraWidgets;
  final EdgeInsets padding;
  final bool hasArrow;
  final bool hasTitle;
  final Function()? lHeadonTap;
  final Function()? rHeadonTap;
  final bool titleArrow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Card(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 22, 16, 22),
          child: Column(
            children: [
              if(hasTitle)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: AppFonts.f40016.copyWith(fontWeight: FontWeight.w500),
                  ),
                  if (hasArrow)
                    Icon(Icons.arrow_forward, color: Config.appTheme.themeColor)
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      lHeadonTap?.call();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("$lHead", style: AppFonts.f70024.copyWith(fontSize: 18)),
                          ],
                        ),
                        Row(
                          children: [
                            Text("$lSubHead", style: AppFonts.f50014Grey),
                            SizedBox(width: 5), // Add spacing between text and icon
                            if (titleArrow)  Icon(Icons.arrow_forward, size: 14, color: Colors.black),
                          ],
                        ),
                      ],
                    ),
                  ),
                 GestureDetector(
                   onTap: (){
                     rHeadonTap?.call();
                   },
                   child:Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children: [
                       Row(
                         children: [
                           Text("$rHead", style: AppFonts.f70024.copyWith(fontSize: 18)),
                         ],
                       ),
                       Row(
                         children: [
                           Text("$rSubHead", style: AppFonts.f50014Grey),
                           SizedBox(width: 5), // Add spacing between text and icon
                           if (titleArrow) Icon(Icons.arrow_forward, size: 14, color: Colors.black),
                         ],
                       ),
                     ],
                   ),
                 )
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Row(
                  //   children: [
                  //     Text("$lSubHead", style: AppFonts.f50014Grey),
                  //     SizedBox(width: 5), // Add spacing between text and icon
                  //     Icon(Icons.arrow_forward, size: 14, color: Colors.black),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     Text("$rSubHead", style: AppFonts.f50014Grey),
                  //     SizedBox(width: 5), // Add spacing between text and icon
                  //     Icon(Icons.arrow_forward, size: 14, color: Colors.black),
                  //   ],
                  // ),
                ],
              ),

              ...extraWidgets
            ],
          ),
        ),
      ),
    );
  }
}
