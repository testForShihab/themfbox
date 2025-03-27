// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:mymfbox2_0/advisor/sip/BranchWiseSip.dart';
import 'package:mymfbox2_0/advisor/sip/RmWiseSip.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpSelectableChip.dart';

class BranchRmAssociateSip extends StatefulWidget {
  const BranchRmAssociateSip({super.key, this.selectedChip = "Branch"});
  final String selectedChip;
  @override
  State<BranchRmAssociateSip> createState() => _BranchRmAssociateSipState();
}

class _BranchRmAssociateSipState extends State<BranchRmAssociateSip> {
  @override
  void initState() {
    //  implement initState
    super.initState();
    selectedChip = widget.selectedChip;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: adminAppBar(
          hasAction: false, title: "Branch/RM wise SIP", bgColor: Colors.white),
      body: Column(
        children: [
          chipArea(),
          if (selectedChip == "Branch") Expanded(child: BranchWiseSip()),
          if (selectedChip == "RM") Expanded(child: RmWiseSip()),
          //  if (selectedChip == "Associate") Expanded(child: AssociateWiseSip()),
        ],
      ),
    );
  }

  List chipList = ["Branch", "RM"];
  String selectedChip = "Branch";

  Widget chipArea() {
    return Container(
      height: 36,
      margin: EdgeInsets.only(left: 16, bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: chipList.length,
        itemBuilder: (context, index) {
          String title = chipList[index];

          return RpSelectableChip(
              onTap: () {
                selectedChip = title;
                setState(() {});
              },
              isSelected: selectedChip == title,
              title: title);
        },
      ),
    );
  }
}
