import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/advisor/sip/activeSip/ActiveSip.dart';
import 'package:mymfbox2_0/advisor/sip/activeSip/BounceSip.dart';
import 'package:mymfbox2_0/advisor/sip/activeSip/ClosedSip.dart';
import 'package:mymfbox2_0/advisor/sip/activeSip/ExpiringSip.dart';
import 'package:mymfbox2_0/advisor/sip/activeSip/MissingSip.dart';
import 'package:mymfbox2_0/advisor/sip/activeSip/StartingShortly.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpSelectableChip.dart';
import 'package:mymfbox2_0/utils/Restrictions.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../../utils/Constants.dart';

class ActiveSipHome extends StatefulWidget {
  ActiveSipHome({super.key, this.defaultSelection = "Active SIP",this.startDate,this.end_date});
  final String defaultSelection;
  DateTime? startDate,end_date;

  @override
  State<ActiveSipHome> createState() => _ActiveSipHomeState();
}

class _ActiveSipHomeState extends State<ActiveSipHome> {
  int user_id = GetStorage().read("mfd_id") ?? 0;
  String client_name = GetStorage().read("client_name") ?? "null";
  String mobile = GetStorage().read("mfd_mobile") ?? "null";
  int type_id = GetStorage().read("type_id");

  DateTime? startDate,endDate;

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

  formatDate(DateTime dt) {
    return DateFormat("dd-MM-yyyy").format(dt);
  }

  @override
  void initState() {
    //  implement initState
    super.initState();
    selectedChip = widget.defaultSelection;
    if (type_id != UserType.ADMIN) {
      chipList.removeWhere((chip) => chip == "Inactive SIPs (Due to Bouncing)" || chip == "SIP Bounce Report");
    }
    startDate = widget.startDate;
    endDate = widget.end_date;

    print("start date $startDate");
    print("start date $endDate");

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: adminAppBar(title: "SIPs", bgColor: Colors.white),
            body: Column(
              children: [
                chipArea(),
                if (selectedChip == "Active SIP")
                  Expanded(
                      child: ActiveSip(
                    branchList: branchList,
                    rmList: rmList,
                    subBrokerList: subBrokerList,
                    amcList: amcList,
                    arnList: arnList,
                        start_date: startDate,
                        end_date: endDate,
                  )),
                if (selectedChip == "Closed SIP")
                  Expanded(
                      child: ClosedSip(
                        branchList: branchList,
                        rmList: rmList,
                        subBrokerList: subBrokerList,
                        amcList: amcList,
                        arnList: arnList,
                      )),
                if (selectedChip == "SIPs Starting Shortly")
                  Expanded(
                      child: StartingShortly(
                    branchList: branchList,
                    rmList: rmList,
                    subBrokerList: subBrokerList,
                    amcList: amcList,
                    arnList: arnList,
                  )),
                if (selectedChip == "SIPs Expiring Shortly")
                  Expanded(
                      child: ExpiringSip(
                    branchList: branchList,
                    rmList: rmList,
                    subBrokerList: subBrokerList,
                    amcList: amcList,
                    arnList: arnList,
                  )),

                if (selectedChip == "Inactive SIPs (Due to Bouncing)")
                  Expanded(
                    child: MissingSip(
                      branchList: branchList,
                      rmList: rmList,
                      subBrokerList: subBrokerList,
                      amcList: amcList,
                      arnList: arnList,
                    ),
                  ),
                if (selectedChip == "SIP Bounce Report")
                  Expanded(
                    child: BounceSip(
                      branchList: branchList,
                      rmList: rmList,
                      subBrokerList: subBrokerList,
                      amcList: amcList,
                      arnList: arnList,
                    ),
                  ),
              ],
            ),
          );
        });
  }

  List chipList = [
    "Active SIP",
    "Closed SIP",
    "SIPs Starting Shortly",
    "SIPs Expiring Shortly",
    "Inactive SIPs (Due to Bouncing)",
    "SIP Bounce Report",
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
