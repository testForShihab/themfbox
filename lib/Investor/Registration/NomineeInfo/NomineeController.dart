import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';

class NomineeController {
  Rx<String> relation = "".obs;
  Rx<String> relationCode = "".obs;
  NomineeController(
      {String defaultDesc = "FATHER", String defaultCode = "MFU01"}) {
    relation.value = defaultDesc;
    relationCode.value = defaultCode;
  }

  ExpansionTileController relationController = ExpansionTileController();

  void setDefault({required String defaultDesc, required String defaultCode}) {
    relation.value = defaultDesc;
    relationCode.value = defaultCode;
    print("relation.value ${relation.value}");
  }

  Widget nomineeRelationTile(
    BuildContext context, {
    required String title,
    required List relationList,
  }) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Obx(() {
          return ExpansionTile(
            controller: relationController,
            title: Text(title, style: AppFonts.f50014Black),
            subtitle: Text(relation.value, style: AppFonts.f50012),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: relationList.length,
                itemBuilder: (context, index) {
                  Map map = relationList[index];
                  String desc = map['desc'];
                  String code = map['code'];
                  print("relation.value1 $desc");
                  print("relation.value2 $code");

                  return InkWell(
                    onTap: () {
                      relation.value = desc;
                      relationCode.value = code;
                      relationController.collapse();
                    },
                    child: Row(
                      children: [
                        Radio(
                          value: code,
                          groupValue: relationCode.value,
                          onChanged: (value) {
                            relation.value = desc;
                            relationCode.value = code;
                            relationController.collapse();
                          },
                        ),
                        Text(desc, style: AppFonts.f50014Grey),
                      ],
                    ),
                  );
                },
              )
            ],
          );
        }),
      ),
    );
  }
}
