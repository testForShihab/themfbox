import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import '../../utils/AppFonts.dart';
import 'AdminProfile.pojo.dart';

class AmcEmpanelled extends StatefulWidget {
  final List allAmc;
  final List activeAmc;

  const AmcEmpanelled(
      {super.key, required this.allAmc, required this.activeAmc});

  @override
  State<AmcEmpanelled> createState() => _AmcEmpanelledState();
}

class _AmcEmpanelledState extends State<AmcEmpanelled> {
  String client_name = GetStorage().read("client_name");
  num amcLength = 0;
  num count = 0;

  // DetailsPojo oldDetailsPojo = DetailsPojo();
  AmcEmpanalledPojo amcEmpanalledPojo = AmcEmpanalledPojo();

  List activeAmc = [], nonActiveAmc = [];

  removeActiveFromAll() {
    List activeNames = [];
    activeAmc.forEach((element) {
      activeNames.add(element['amc_name']);
    });

    nonActiveAmc.removeWhere(
        (element) => activeNames.contains(element['mf_company_name']));
  }

  @override
  void initState() {
    //  implement initState
    super.initState();
    activeAmc = widget.activeAmc;
    nonActiveAmc = widget.allAmc;
    removeActiveFromAll();
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "AMC Empanalled",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text("${activeAmc.length} AMCs Empanelled"),
              if (activeAmc.isEmpty) nothingCard(),
              SizedBox(height: 16),
              activeArea(),
              SizedBox(height: 32),
              Text("${nonActiveAmc.length} AMCs Non Empanelled"),
              SizedBox(height: 16),
              nonActiveArea(),
              SizedBox(height: 82),
            ],
          ),
        ),
      ),
      bottomSheet: CalculateButton(
        onPress: () async {
          int res = await updateDetails();
          if (res == -1) return;
          Get.back();
          EasyLoading.showSuccess("Details Updated Successfully");
        },
        text: "SAVE",
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Future updateDetails() async {
    List names = [];
    activeAmc.forEach((element) {
      names.add(element['amc_name']);
    });

    Map data = await AdminApi.saveAmcTableDetails(
        amc_array: names.join(","), client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    return 0;
  }

  Widget activeArea() {
    return ListView.separated(
      itemCount: activeAmc.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        Map data = activeAmc[index];
        String title = data['amc_name'];
        String logo = data['logo'];

        return Row(
          children: [
            Checkbox(
                value: true,
                onChanged: (val) {
                  bool selected = val ?? false;
                  if (!selected) {
                    Map temp = {'mf_company_name': title, 'amc_logo': logo};
                    nonActiveAmc.insert(0, temp);
                    activeAmc.removeAt(index);
                    setState(() {});
                  }
                }),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Config.appTheme.lineColor)),
                child: Row(
                  children: [
                    Image.network(logo, width: 32),
                    SizedBox(width: 8),
                    Text(title, style: AppFonts.f50014Black),
                  ],
                ),
              ),
            )
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(height: 16),
    );
  }

  bool isChecked = false;
  late double devHeight, devWidth;

  Widget nonActiveArea() {
    return (nonActiveAmc.isEmpty)
        ? NoData()
        : ListView.separated(
            itemCount: nonActiveAmc.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Map data = nonActiveAmc[index];
              String title = data['mf_company_name'];
              String logo = data['amc_logo'];

              return Row(
                children: [
                  Checkbox(
                      value: false,
                      onChanged: (val) {
                        bool selected = val ?? false;
                        if (selected) {
                          Map temp = {'amc_name': title, 'logo': logo};
                          activeAmc.add(temp);
                          nonActiveAmc.removeAt(index);
                          setState(() {});
                        }
                      }),
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Config.appTheme.lineColor)),
                      child: Row(
                        children: [
                          Image.network(logo, width: 32),
                          SizedBox(width: 8),
                          Expanded(
                              child: Text(title, style: AppFonts.f50014Black)),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(height: 16),
          );
  }

  Widget nothingCard() {
    return Container(
      width: devWidth,
      margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Image.asset("assets/unpublished.png",
              color: Colors.grey[400], height: 50),
          SizedBox(height: 16),
          Text("No AMC Empanalled.",
              textAlign: TextAlign.center, style: AppFonts.f40013)
        ],
      ),
    );
  }

  // return ListView.builder(
  //   shrinkWrap: true,
  //   itemCount: selectedAmcList.length,
  //   itemBuilder: (context, index) {
  //     final selectedItem = selectedAmcList[index];
  //     return Container(
  //       color: Config.appTheme.mainBgColor,
  //       padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
  //       child: Row(
  //         children: [
  //           Expanded(
  //             child: Container(
  //               padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
  //               color: Colors.white,
  //               child: Row(
  //                 children: [
  //                   Expanded(
  //                     child: Text(
  //                       selectedItem,
  //                       style: AppFonts.f40013.copyWith(color: Colors.black),
  //                     ),
  //                   ),
  //                   SizedBox(width: 8),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   },
  // );
}
