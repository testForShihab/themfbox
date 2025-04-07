import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/LumpsumCart.dart';
import 'package:mymfbox2_0/Investor/transact/cart/MyCart.dart';
import 'package:mymfbox2_0/utils/Config.dart';

RxInt cartCount = 0.obs;

invAppBar({
  String? title,
  Widget? leading,
  Widget? bottomSpace,
  Color? bgColor,
  Color fgColor = Colors.white,
  double toolbarHeight = 60,
  bool showNotiIcon = false,
  bool showCartIcon = true,
  List<Widget>? actions,
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle.dark,
}) {
  return AppBar(
    leadingWidth: 0,
    toolbarHeight: toolbarHeight,
    backgroundColor: Config.appTheme.themeColor,
    foregroundColor: fgColor,
    leading: SizedBox(),
    scrolledUnderElevation: 0,
    bottomOpacity: 0,
    systemOverlayStyle: systemUiOverlayStyle,
    title: Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: leading ??
                  GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back)),
            ),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Text("$title",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18,color:Config.appTheme.whiteOverlay)),
            ),
            Spacer(),
            if (showNotiIcon) Icon(Icons.notifications_none, color: fgColor),
            if (showCartIcon)
              IconButton(
                icon: Badge(
                    label: Obx(() {
                      return Text("${cartCount.value}");
                    }),
                    child: Icon(Icons.shopping_cart,color: Config.appTheme.whiteOverlay,)),
                onPressed: () {
                  Get.to(() => MyCart(
                        defaultPage: LumpsumCart(),
                      ));
                },
              ),
            if (actions != null) ...actions,
          ],
        ),
        if (bottomSpace != null) bottomSpace,
      ],
    ),
  );
}
