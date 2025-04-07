import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/advisor/swp/ActiveSwp.dart';
import 'package:mymfbox2_0/advisor/swp/ClosedSwp.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpSelectableChip.dart';
import 'package:mymfbox2_0/utils/Restrictions.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class ActiveSwpHome extends StatefulWidget {
  const ActiveSwpHome({super.key, this.defaultSelection = "Active SWPs"});
  final String defaultSelection;

  @override
  State<ActiveSwpHome> createState() => _ActiveSwpHomeState();
}

class _ActiveSwpHomeState extends State<ActiveSwpHome> {
  int user_id = GetStorage().read("mfd_id") ?? 0;
  String client_name = GetStorage().read("client_name") ?? "null";
  String mobile = GetStorage().read("mfd_mobile") ?? "null";

  List branchList = [];
  Future getAllBranch() async {
    if (branchList.isNotEmpty) return 0;
    Map data = await Api.getAllBranch(mobile: mobile, client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    branchList = data['list'];
    return 0;
  }

  List rmList = [];
  Future getAllRM() async {
    if (rmList.isNotEmpty) return 0;

    Map data = await Api.getAllRM(
        mobile: mobile, client_name: client_name, branch: "");

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    rmList = data['list'];
    return 0;
  }

  List subBrokerList = [];
  Future getAllSubBroker() async {
    if (subBrokerList.isNotEmpty) return 0;
    Map data =
        await Api.getAllSubbroker(mobile: mobile, client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    subBrokerList = data['list'];
    return 0;
  }

  List amcList = [];
  Future getAllAmc() async {
    if (amcList.isNotEmpty) return 0;

    Map data = await Api.getAmcWiseSipDetails(
        user_id: user_id,
        client_name: client_name,
        maxCount: 'All',
        broker_code: 'All');

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }

    amcList = data['list'];

    return 0;
  }

  List arnList = [];
  Future getArnList() async {
    if (arnList.isNotEmpty) return 0;

    Map data = await Api.getArnList(client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    arnList = [
      "All",
      data['broker_code_1'],
      data['broker_code_2'],
      data['broker_code_3']
    ];
    arnList.removeWhere((element) => element.isEmpty);

    return 0;
  }

  bool isFirst = true;
  Future getDatas() async {
    if (!isFirst) return 0;

    await Future.wait([
      if (Restrictions.isBranchApiAllowed) getAllBranch(),
      if (Restrictions.isRmApiAllowed) getAllRM(),
      if (Restrictions.isAssociateApiAllowed) getAllSubBroker(),
      getAllAmc(),
      getArnList(),
    ]);
    isFirst = false;
    return 0;
  }

  @override
  void initState() {
    //  implement initState
    super.initState();
    selectedChip = widget.defaultSelection;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: adminAppBar(title: "SWPs", bgColor: Colors.white),
            body: Column(
              children: [
                chipArea(),
                if (selectedChip == "Active SWPs")
                  Expanded(
                    child: ActiveSwp(
                        amcList: amcList,
                        subBrokerList: subBrokerList,
                        rmList: rmList,
                        branchList: branchList,
                        arnList: arnList),
                  ),
                if (selectedChip == "Closed SWPs")
                  Expanded(
                    child: ClosedSwp(
                        amcList: amcList,
                        subBrokerList: subBrokerList,
                        rmList: rmList,
                        branchList: branchList,
                        arnList: arnList),
                  ),
              ],
            ),
          );
        });
  }

  List chipList = [
    "Active SWPs",
    "Closed SWPs",
  ];
  String selectedChip = ""; // initialized in init state

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
