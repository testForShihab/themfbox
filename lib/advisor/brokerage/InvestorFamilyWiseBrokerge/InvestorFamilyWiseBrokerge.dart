import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/advisor/brokerage/InvestorFamilyWiseBrokerge/FamilyWiseBrokerage.dart';
import 'package:mymfbox2_0/advisor/brokerage/InvestorFamilyWiseBrokerge/InvestorWiseBrokerage.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/AmcChip.dart';
import 'package:mymfbox2_0/rp_widgets/SelectedAmcChip.dart';

import '../../../utils/Utils.dart';

class InvestorFamilyWiseBrokerage extends StatefulWidget {
  const InvestorFamilyWiseBrokerage(
      {super.key,
      this.selectedInvType = "Investor",
      required this.selectedMonth});
  final String selectedInvType, selectedMonth;
  @override
  State<InvestorFamilyWiseBrokerage> createState() =>
      _InvestorFamilyWiseBrokerageState();
}

class _InvestorFamilyWiseBrokerageState
    extends State<InvestorFamilyWiseBrokerage> {
  int mfd_id = getUserId();
  String client_name = GetStorage().read("client_name");

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedInvType = widget.selectedInvType;
  }

  List invBtnList = [
    "Investor",
    "Family",
  ];

  @override
  void dispose() {
    super.dispose();
  }

  late double devWidth, devHeight;
  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: adminAppBar(
          title: "Investor/Family Wise Brokerage",
          bgColor: Colors.white,
          hasAction: false),
      body: Column(
        children: [
          chipArea(),
          selectedInvType == "Investor"
              ? Expanded(
                  child: InvestorWiseBrokerage(
                      selectedMonth: widget.selectedMonth))
              : Expanded(
                  child:
                      FamilyWiseBrokerage(selectedMonth: widget.selectedMonth)),
        ],
      ),
    );
  }

  String selectedMonth = "";

  String selectedInvType = "Investor";
  Widget chipArea() {
    return Container(
      margin: EdgeInsets.only(left: 16, bottom: 16),
      height: 36,
      child: ListView.builder(
        itemCount: invBtnList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          String title = invBtnList[index];
          bool isSelectedInv = (selectedInvType == title);

          if (isSelectedInv)
            return SelectedAmcChip(
              title: title,
              value: "",
              hasValue: false,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            );
          else
            return AmcChip(
              title: title,
              value: '',
              hasValue: false,
              onTap: () async {
                selectedInvType = title;
                setState(() {});
              },
              titleStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            );
        },
      ),
    );
  }
}
