import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/advisor/proposal/Lumpsum/LumpsumProposalInput.dart';
import 'package:mymfbox2_0/advisor/proposal/LumpsumPlusSIPProposal/LumpsumPlusSipProposalInput.dart';
import 'package:mymfbox2_0/advisor/proposal/SIP/SipProposalInput.dart';
import 'package:mymfbox2_0/advisor/proposal/STP/StpProposalInput.dart';
import 'package:mymfbox2_0/advisor/proposal/SWP/SwpProposalInput.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpSmallTf.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

class InvestmentProposal extends StatefulWidget {
  const InvestmentProposal({super.key});

  @override
  State<InvestmentProposal> createState() => _InvestmentProposalState();
}

class _InvestmentProposalState extends State<InvestmentProposal> {
  String client_name = GetStorage().read("client_name");
  int user_id = GetStorage().read("mfd_id");

  List invTypeList = [
    "Lumpsum",
    "SIP",
    "STP",
    "SWP",
    "Lumpsum + SIP",
  ];
  String invType = "Lumpsum";

  ExpansionTileController typeController = ExpansionTileController();
  ExpansionTileController nameController = ExpansionTileController();

  List investorList = [];

  int page_id = 1;
  String searchKey = "";
  bool isFirst = true;
  String investorName = "Select";
  int investorId = 0;

  Future getInitialInvestor() async {
    if (!isFirst) return 0;

    Map data = await AdminApi.getInvestors(
        page_id: page_id,
        client_name: client_name,
        user_id: user_id,
        branch: "",
        rmList: []);

    investorList = data['list'];
    isFirst = false;

    return 0;
  }

  Future fetchMoreInvestor() async {
    page_id++;
    Map data = await AdminApi.getInvestors(
        page_id: page_id,
        client_name: client_name,
        user_id: user_id,
        branch: "",
        rmList: []);

    List list = data['list'];

    investorList.addAll(list);
    investorList = investorList.toSet().toList();
    setState(() {});
  }

  Future searchInvestor() async {
    investorList = [];

    EasyLoading.show(status: "Searching for `$searchKey`");
    Map data = await AdminApi.getInvestors(
        page_id: page_id,
        client_name: client_name,
        user_id: user_id,
        search: searchKey,
        branch: "",
        rmList: []);
    EasyLoading.dismiss();

    List list = data['list'];

    investorList = list;
    setState(() {});

    return 0;
  }

  Timer? searchOnStop;

  searchHandler() {
    const duration = Duration(milliseconds: 1000);
    if (searchOnStop != null) {
      setState(() {
        searchOnStop!.cancel();
      });
    }
    setState(() {
      searchOnStop = Timer(duration, () async {
        await searchInvestor();
      });
    });
  }

  late double devHeight;
  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
        future: getInitialInvestor(),
        builder: (context, snapshot) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: rpAppBar(
                title: "Investment Proposal",
                bgColor: Config.appTheme.themeColor,
                foregroundColor: Colors.white),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  invTypeExpansionTile(context),
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        controller: nameController,
                        title: Text("Client Name", style: AppFonts.f50014Black),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(investorName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Config.appTheme.themeColor)),
                            // DottedLine(),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
                            child: RpSmallTf(
                              onChange: (val) {
                                searchKey = val;
                                searchHandler();
                              },
                              borderColor: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 350,
                            child: ListView.builder(
                              itemCount: investorList.length,
                              itemBuilder: (context, index) {
                                String name = investorList[index]['name'];
                                int id = investorList[index]['id'];

                                return InkWell(
                                  onTap: () {
                                    investorName = name;
                                    investorId = id;
                                    nameController.collapse();
                                    setState(() {});
                                  },
                                  child: ListTile(
                                    leading: InitialCard(title: (name == "") ? "." : name),
                                    title: Text(name),
                                  ),
                                );
                              },
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (searchKey.isNotEmpty) return;

                              EasyLoading.show();
                              await fetchMoreInvestor();
                              EasyLoading.dismiss();
                            },
                            child: Text(
                              "Load More Results",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Config.appTheme.themeColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (investorName == "Select") {
                            EasyLoading.showError("Please select Investor");
                            return;
                          }
                          if (invType == "Lumpsum")
                            Get.to(() => LumpsumProposalInput(
                                invId: investorId,
                                invName: investorName,
                                invType: invType));

                          if (invType == "SIP")
                            Get.to(SipProposalInput(
                                invId: investorId,
                                invName: investorName,
                                invType: invType));
                          if (invType == 'STP')
                            Get.to(() => StpProposalInput(
                                invId: investorId,
                                invName: investorName,
                                invType: invType));
                          if (invType == 'SWP')
                            Get.to(() => SwpProposalInput(
                                invId: investorId, invName: investorName));
                          if (invType == 'Lumpsum + SIP')
                            Get.to(() => LumpsumPlusSipProposalInput(
                                invId: investorId,
                                invName: investorName,
                                invType: invType));
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Config.appTheme.themeColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          "CONTINUE",
                          style: AppFonts.f50014Black
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget invTypeExpansionTile(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: typeController,
          title: Text("Select Investment Options", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(invType,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Config.appTheme.themeColor)),
              // DottedLine(),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemCount: invTypeList.length,
              itemBuilder: (context, index) {
                String temp = invTypeList[index];

                return InkWell(
                  onTap: () {
                    invType = temp;
                    typeController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: invType,
                        onChanged: (value) {
                          invType = temp;
                          typeController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(
                        temp,
                        style: AppFonts.f50014Black.copyWith(
                            color: invType == temp
                                ? Config.appTheme.themeColor
                                : Config.appTheme.readableGreyTitle),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
