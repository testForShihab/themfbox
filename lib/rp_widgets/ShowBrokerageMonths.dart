import 'package:flutter/material.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/utils/Constants.dart';

showBrokerageMonths(BuildContext context,
    {required String groupValue,
    Function(String?)? onChanged,
    required List monthList}) {
  double devHeight = MediaQuery.sizeOf(context).height;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, bottomState) {
          return Container(
            height: devHeight * 0.6,
            decoration: BoxDecoration(
              borderRadius: cornerBorder,
              // color: Colors.white,
            ),
            child: Column(
              children: [
                BottomSheetTitle(title: "Select Month"),
                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: monthList.length,
                      itemBuilder: (context, index) {
                        String title = monthList[index];

                        return InkWell(
                          onTap: () {
                            onChanged!(title);
                          },
                          child: Row(
                            children: [
                              Radio(
                                  value: title,
                                  groupValue: groupValue,
                                  onChanged: onChanged),
                              SizedBox(width: 5),
                              Text(title),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
