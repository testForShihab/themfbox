import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile2.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../rp_widgets/AdminAppBar.dart';
import '../../rp_widgets/DottedLine.dart';
import '../../rp_widgets/InitialCard.dart';
import '../../rp_widgets/SearchField.dart';
import '../../utils/AppFonts.dart';
import '../../utils/Constants.dart';

class AllRM extends StatefulWidget {
  const AllRM({super.key});

  @override
  State<AllRM> createState() => _AllRMState();
}

class _AllRMState extends State<AllRM> {
  int user_id = GetStorage().read("mfd_id");
  String client_name = GetStorage().read("client_name");
  String mobile = GetStorage().read("mfd_mobile");
  int type_id = GetStorage().read("type_id");

  bool isLoading = true;

  List rmList = [];
  Future getAllRMDetails() async {
    if (rmList.isNotEmpty) return 0;

    Map data = await AdminApi.getAllRMDetails(

        client_name: client_name,
        branch: "", user_id: user_id);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    rmList = data['list'];

    return 0;
  }

  Timer? searchOnStop;
  String searchKey = "";
  searchHandler(String search) {
    searchKey = search;

    const duration = Duration(milliseconds: 1000);
    if (searchOnStop != null) {
      searchOnStop!.cancel();
    }

    searchOnStop = Timer(duration, () async {
      EasyLoading.show(status: "searching for `$searchKey`");
      await getAllRMDetails();
      EasyLoading.dismiss();

      setState(() {});
    });
  }

  bool isFirst = true;
  Future getDatas() async{
    if (!isFirst) return 0;

    await getAllRMDetails();
    isFirst = false;
    return 0;
  }

  late double devHeight,devWidth;

  @override
  Widget build(BuildContext context) {

    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;

    return FutureBuilder(
        future: getDatas(),
        builder: (context,snapshot){
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: adminAppBar(title: "All RM", bgColor: Colors.white),
            body: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SearchField(
                    hintText: "Search",
                    onChange: searchHandler,
                  ),
                ),
                countLine(),
                listArea(),
              ],
            ),
          );
        });
  }

  Widget countLine() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${rmList.length} Items",
              style: AppFonts.f40013),
        ],
      ),
    );
  }

  Widget listArea() {
    return Expanded(
      child: SingleChildScrollView(
        //controller: scrollController,
        child: /*(isLoading)
            ? Utils.shimmerWidget(devHeight)
            :*/ ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: rmList.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> data = rmList[index];

            return InkWell(
              onTap: (){
                showRMMembers(data);
              },
              child: RpListTile2(
                  leading: InitialCard(title: "${data['name']}"),
                  l1: "${data['name']}",
                  l2: "",
                  r1: "",
                  r2: ""),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: DottedLine(verticalPadding: 8),
          ),
        ),
      ),
    );
  }

  showRMMembers(Map data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Config.appTheme.mainBgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (context) {
        return StatefulBuilder(builder: (context, bottomState) {
          return SizedBox(
            // height: (isExpanded) ? devHeight * 0.9 : devHeight * 0.6,
            height: devHeight * 0.3,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.close))
                      ],
                    ),
                  ),
                  infoRow(lHead: "RM Name", lSubHead: data['rm_name'],rHead: "Branch",rSubHead: data['branch']),
                  infoRow(lHead: "PAN", lSubHead: data['pan'],rHead: "Mobile",rSubHead: data['mobile']),
                  infoRow(lHead: "user_id", lSubHead: data['user_id'].toString(),rHead: "password",rSubHead: data['password']),
                  infoRow(lHead: "Email", lSubHead: data['email']),

                  SizedBox(height: 16,),
                 ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget infoRow({
    required String lHead,
    required String lSubHead,
    TextStyle? lStyle,
    String rHead = "",
    String rSubHead = "",
    TextStyle? rStyle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Row(
        children: [
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lHead),
                  Text(lSubHead, style: lStyle ?? AppFonts.f50014Black),
                ],
              )),
          Visibility(
            visible: rHead.isNotEmpty,
            child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rHead),
                    Text(rSubHead, style: rStyle ?? AppFonts.f50014Black),
                  ],
                )),
          ),
        ],
      ),
    );
  }

}
