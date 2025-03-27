import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/rp_widgets/ClosedSidebar.dart';
import 'package:mymfbox2_0/rp_widgets/OpenSideBar.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key, required this.child});
  final Widget child;
  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  late double devWidth;
  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          widget.child,
          Positioned(
            top: adminTop,
            left: adminLeft,
            right: adminRight,
            child: Draggable(
              feedback: adminSideBar(),
              childWhenDragging: SizedBox(),
              child: adminSideBar(),
              onDragEnd: (details) {
                double dx = details.offset.dx;
                adminTop = details.offset.dy;

                if (adminTop > 700) adminTop = 500;
                if (dx > devWidth / 2) changeAdminToRight();
                if (dx < devWidth / 2) changeToLeft();

                setState(() {});
              },
            ),
          ),
          Positioned(
            top: familyTop,
            left: familyLeft,
            right: familyRight,
            child: Draggable(
                feedback: familySideBar(),
                childWhenDragging: SizedBox(),
                child: familySideBar(),
                onDragEnd: (details) {
                  double dx = details.offset.dx;
                  familyTop = details.offset.dy;

                  if (familyTop > 700) familyTop = 600;
                  if (dx > devWidth / 2) changeFamilyToRight();
                  if (dx < devWidth / 2) changeFamilyToLeft();

                  setState(() {});
                }),
          ),
        ],
      ),
    );
  }

  bool isAdminOpen = false;
  double adminTop = 100;
  double? adminLeft;
  double? adminRight;
  bool adminRightToLeft = true;

  Widget adminSideBar() {
    Iterable keys = GetStorage().getKeys();
    bool adminAsInvestor = keys.contains("adminAsInvestor");
    bool adminAsFamily = keys.contains("adminAsFamily");
    String? name = "";
    if (adminAsInvestor) name = GetStorage().read("user_name");
    if (adminAsFamily) name = GetStorage().read("family_name");

    return Visibility(
        visible: adminAsInvestor || adminAsFamily,
        child: (isAdminOpen)
            ? OpenSideBar(
                name: "$name",
                leftBorder: adminLeftBorder,
                rightBorder: adminRightBorder,
                rightToLeft: adminRightToLeft,
                onClose: () {
                  isAdminOpen = false;
                  setState(() {});
                },
              )
            : ClosedSideBar(
                name: "$name",
                leftBorder: adminLeftBorder,
                rightBorder: adminRightBorder,
                onTap: () {
                  isAdminOpen = true;
                  setState(() {});
                },
              ));
  }

  double adminLeftBorder = 0;
  double adminRightBorder = 30;

  changeAdminToRight() {
    adminLeftBorder = 30;
    adminRightBorder = 0;
    adminLeft = null;
    adminRight = 0;
    adminRightToLeft = false;
  }

  changeToLeft() {
    adminLeftBorder = 0;
    adminRightBorder = 30;
    adminLeft = 0;
    adminRight = null;
    adminRightToLeft = true;
  }

  bool isFamilyOpen = false;
  double familyTop = 200;
  double? familyLeft;
  double? familyRight;
  bool familyRightToLeft = true;

  Widget familySideBar() {
    Iterable keys = GetStorage().getKeys();
    String? fHeadName = GetStorage().read('user_name');

    return Visibility(
        visible: keys.contains("familyAsInvestor"),
        child: (isFamilyOpen)
            ? OpenSideBar(
                name: "$fHeadName",
                leftBorder: familyLeftBorder,
                rightBorder: familyRightBorder,
                rightToLeft: familyRightToLeft,
                top: 200,
                exitText: "Family",
                onClose: () {
                  isFamilyOpen = false;
                  setState(() {});
                },
              )
            : ClosedSideBar(
                name: "$fHeadName",
                leftBorder: familyLeftBorder,
                rightBorder: familyRightBorder,
                top: 300,
                onTap: () {
                  isFamilyOpen = true;
                  setState(() {});
                },
              ));
  }

  double familyLeftBorder = 0;
  double familyRightBorder = 30;

  changeFamilyToRight() {
    familyLeftBorder = 30;
    familyRightBorder = 0;
    familyLeft = null;
    familyRight = 0;
    familyRightToLeft = false;
  }

  changeFamilyToLeft() {
    familyLeftBorder = 0;
    familyRightBorder = 30;
    familyLeft = 0;
    familyRight = null;
    familyRightToLeft = true;
  }
}
