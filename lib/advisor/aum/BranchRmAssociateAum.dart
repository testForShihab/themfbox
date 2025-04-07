import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/advisor/aum/AssociateWiseAum.dart';
import 'package:mymfbox2_0/advisor/aum/BranchWiseAum.dart';
import 'package:mymfbox2_0/advisor/aum/RmWiseAum.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpSelectableChip.dart';
import 'package:mymfbox2_0/utils/Constants.dart';

class BranchRmAssociateAum extends StatefulWidget {
  const BranchRmAssociateAum({super.key,required this.selectedBranch});

  final String selectedBranch;

  @override
  State<BranchRmAssociateAum> createState() => _BranchRmAssociateAum();
}

class _BranchRmAssociateAum extends State<BranchRmAssociateAum> {
  int type_id = GetStorage().read("type_id");

  String appBarTitle = "";
  List<String> branchTypeList = []; // Keep as List<String>
  String selectedChip = "";
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    if (type_id == UserType.ADMIN)
      branchTypeList = ["Branch", "RM", "Associate"];
    if (type_id == UserType.BRANCH) branchTypeList = ["RM", "Associate"];
    if (type_id == UserType.RM) branchTypeList = ["Associate"];

    //selectedChip = branchTypeList.first;
    selectedChip = widget.selectedBranch;
    appBarTitle = "${branchTypeList.join("/")} Wise AUM";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: adminAppBar(
          hasAction: false, title: appBarTitle, bgColor: Colors.white),
      body: Column(
        children: [
          chipArea(),
          // Use IndexedStack to switch between widgets based on selectedIndex
          if (selectedChip == 'Branch') Expanded(child: BranchWiseAum()),
          if (selectedChip == 'RM') Expanded(child: RmWiseAum()),
          if (selectedChip == 'Associate') Expanded(child: AssociateWiseAum()),
          // Expanded(
          //   child: IndexedStack(
          //     index: selectedIndex,
          //     children: [
          //       BranchWiseAum(),   // Index 0
          //       RmWiseAum(),       // Index 1
          //       AssociateWiseAum(), // Index 2
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget chipArea() {
    return Container(
      height: 36,
      margin: const EdgeInsets.only(left: 16, bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: branchTypeList.length,
        itemBuilder: (context, index) {
          String title = branchTypeList[index];

          return RpSelectableChip(
            onTap: () {
              setState(() {
                selectedChip = title;
                selectedIndex =
                    index; // Update the selected index based on chip selection
              });
              print("Chip tapped: $title");
              print("Selected Branch Type after tap: $selectedChip");
            },
            isSelected: selectedChip == title,
            title: title,
          );
        },
      ),
    );
  }
}
