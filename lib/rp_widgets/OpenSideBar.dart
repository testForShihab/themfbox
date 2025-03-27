import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/family/FamilyDashboard.dart';
import 'package:mymfbox2_0/login/CheckUserType.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:slide_action/slide_action.dart';

class OpenSideBar extends StatelessWidget {
  const OpenSideBar(
      {super.key,
      this.onClose,
      required this.name,
      this.top = 400,
      this.exitText = "Admin",
      this.rightBorder = 30,
      this.leftBorder = 0,
      this.rightToLeft = false});
  final Function()? onClose;
  final String name, exitText;
  final double top;
  final double rightBorder, leftBorder;
  final bool rightToLeft;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: 200,
      child: SlideAction(
        rightToLeft: rightToLeft,
        trackHeight: 70,
        trackBuilder:
            (BuildContext context, SlideActionStateMixin currentState) {
          return Container(
            padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(rightBorder),
                  left: Radius.circular(leftBorder),
                )),
            child: Row(
              children: [
                // GestureDetector(
                //   onTap: () {
                //     isOpen = false;
                //     setState(() {});
                //   },
                //   child: CircleAvatar(
                //     backgroundColor: Colors.white,
                //     child: Text("RT", style: TextStyle(color: Colors.green)),
                //   ),
                // ),
                if (!rightToLeft) SizedBox(width: 55),
                Column(
                  children: [
                    Text(
                      Utils.getFirst13(name),
                      style: AppFonts.f50014Grey
                          .copyWith(color: Colors.white, fontSize: 12),
                    ),
                    SizedBox(height: 5),
                    InkWell(
                      onTap: () async {
                        if (exitText == "Family") {
                          GetStorage().remove("familyAsInvestor");
                          Get.offAll(() => FamilyDashboard());
                          return;
                        }

                        Iterable keys = GetStorage().getKeys();

                        if (keys.contains("adminAsInvestor"))
                          await GetStorage().remove("adminAsInvestor");
                        if (keys.contains("adminAsFamily"))
                          await GetStorage().remove("adminAsFamily");
                        if (keys.contains("familyAsInvestor"))
                          await GetStorage().remove("familyAsInvestor");

                        await removeAllUserData();

                        Get.offAll(() => CheckUserType());
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Color(0xffC41E3A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text("Exit to $exitText",
                            style: AppFonts.f50014Grey
                                .copyWith(color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
        thumbBuilder:
            (BuildContext context, SlideActionStateMixin currentState) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 35,
              child: Text(name[0], style: TextStyle(color: Colors.green)),
            ),
          );
        },
        action: onClose,
      ),
    );
  }

  Future removeAllUserData() async {
    EasyLoading.show();

    Iterable<String> keys = GetStorage().getKeys();
    List toRemove = [];

    // ignore: avoid_function_literals_in_foreach_calls
    keys.forEach((element) async {
      if (element.startsWith("user")) toRemove.add(element);
    });

    keys.forEach((element) async {
      if (element.startsWith("family")) toRemove.add(element);
    });

    // ignore: avoid_function_literals_in_foreach_calls
    toRemove.forEach((element) async {
      await GetStorage().remove(element);
    });

    EasyLoading.dismiss();
  }
}
