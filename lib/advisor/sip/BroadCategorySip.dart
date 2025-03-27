import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/advisor/sip/SchemeWiseSip.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpSelectableChip.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../utils/Constants.dart';

class BroadCategorySip extends StatefulWidget {
  const BroadCategorySip(
      {super.key,
      required this.broadCategoryList,
      required this.selectedBroadCategory});
  final List broadCategoryList;
  final String selectedBroadCategory;

  @override
  State<BroadCategorySip> createState() => _BroadCategorySipState();
}

class _BroadCategorySipState extends State<BroadCategorySip> {
  int user_id = GetStorage().read("mfd_id");
  String client_name = GetStorage().read("client_name");

  late List broadCategoryList;

  @override
  void initState() {
    //  implement initState
    super.initState();
    broadCategoryList = widget.broadCategoryList;
    selectedBroadCategory = widget.selectedBroadCategory;
  }

  List categoryList = [];
  bool isLoading = true;
  Future getCategoryWiseSipDetails() async {
    if (categoryList.isNotEmpty) return 0;

    isLoading = true;
    Map data = await Api.getCategoryWiseSipDetails(
      user_id: user_id,
      client_name: client_name,
      maxCount: 'All',
      broad_category: selectedBroadCategory,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    isLoading = false;

    categoryList = data['list'];

    return 0;
  }

  late double devHeight, devWidth;
  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
        future: getCategoryWiseSipDetails(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: adminAppBar(
                title: "Broad Category Wise SIP",
                bgColor: Colors.white,
                hasAction: false),
            body: Column(
              children: [
                chipArea(),
                SizedBox(height: 16),
                //sortLine(),
                countLine(),
                listArea(),
                SizedBox(height: 16),
              ],
            ),
          );
        });
  }

  String selectedBroadCategory = "";
  Widget chipArea() {
    return Container(
      height: 54,
      padding: EdgeInsets.only(left: 16),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: broadCategoryList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          Map data = broadCategoryList[index];
          String title = data['scheme_broad_category'];
          double percentage = data['percentage'];
          String displayTitle = title.replaceAll("Schemes", "").trim();

          return RpSelectableChip(
            title: displayTitle,
            padding: EdgeInsets.symmetric(horizontal: 32),
            isSelected: selectedBroadCategory == title,
            value: "${percentage.toStringAsFixed(2)} %",
            onTap: () {
              selectedBroadCategory = title;
              categoryList = [];
              setState(() {});
            },
          );
        },
      ),
    );
  }

  Widget sortLine() {
    return Container(
      height: 60,
      width: devWidth,
      color: Config.appTheme.mainBgColor,
      padding: EdgeInsets.only(left: 15),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SortButton(onTap: () {}, title: "Sort By"),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget countLine() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Visibility(
        visible: !isLoading,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${categoryList.length} Items", style: AppFonts.f40013),
          ],
        ),
      ),
    );
  }

  Widget listArea() {
    return Expanded(
      child: SingleChildScrollView(
        child: (isLoading)
            ? Utils.shimmerWidget(devHeight)
            : ListView.builder(
                shrinkWrap: true,
                itemCount: categoryList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  Map data = categoryList[index];
                  String title = data['scheme_category'];
                  num percentage = data['percentage'];
                  String amount = Utils.formatNumber(data['amount']);

                  return ListTile(
                    onTap: () {
                      Get.to(() => SchemeWiseSip(amc: "", category: title));
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(title, style: AppFonts.f50014Black),
                        ),
                        Column(
                          children: [
                            Text(
                              textAlign:TextAlign.end,
                              "${percentage.toStringAsFixed(2)}%",
                              style:AppFonts.f50014Black.copyWith(
                              )
                            ),
                            Text("$rupee $amount" ,style: AppFonts.f40013,)
                          ],
                        )

                      ],
                    ),
                    subtitle: percentageBar(percentage.toDouble(), index),
                    // trailing: Icon(Icons.arrow_forward_ios, size: 15),
                  );
                },
              ),
      ),
    );
  }

  double multiplier = 10;

  Widget percentageBar(double percent, int index) {
    double total = devWidth - 32;

    if (index == 0) {
      multiplier = Utils.getMultiplier(percent);
      print("multiplier $multiplier");
    }

    percent = (total * percent) / 100;
    return Stack(
      children: [
        Container(
          height: 7,
          width: total,
          decoration: BoxDecoration(
              color: Color(0xffDFDFDF),
              borderRadius: BorderRadius.circular(10)),
        ),
        Container(
          height: 7,
          width: (percent * multiplier),
          // width: percent,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(10)),
        ),
      ],
    );
  }
}
