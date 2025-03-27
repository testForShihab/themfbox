// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/pojo/aum/CategoryWiseAum.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpFilterChip.dart';
import 'package:mymfbox2_0/rp_widgets/RpSelectableChip.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class BroadCategoryAum extends StatefulWidget {
  const BroadCategoryAum(
      {super.key, required this.broadCategoryList, this.selectedCategory});
  final List broadCategoryList;
  final String? selectedCategory;
  @override
  State<BroadCategoryAum> createState() => _BroadCategoryAumState();
}

class _BroadCategoryAumState extends State<BroadCategoryAum> {
  int user_id = GetStorage().read("mfd_id");
  String client_name = GetStorage().read("client_name");

  List broadCategoryList = [], categoryList = [];
  late String selectedCategory;
  String selectedSort = "AUM";
  List<CategoryWiseAumPojo> categoryPojoList = [];
  bool isLoading = true;
  bool filterContainer = true;
  @override
  void initState() {
    //  implement initState
    super.initState();
    broadCategoryList = widget.broadCategoryList;
    selectedCategory = widget.selectedCategory ?? "All";
  }

  Future getCategoryList() async {
    if (categoryList.isNotEmpty) return 0;

    isLoading = true;
    Map data = await Api.getCategoryWiseAUM(
        user_id: "$user_id",
        client_name: client_name,
        broad_category: selectedCategory,
        max_count: "");
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }

    categoryList = data['list'];
    convertListToObj();
    applySort();

    return 0;
  }

  convertListToObj() {
    categoryPojoList = [];
    for (var element in categoryList) {
      String name = element['category_name'];
      // convert debt: name --> name
      if (name.contains(":")) {
        element['category_name'] = name.split(":").last.trim();
        element['broadCategory'] = name.split(":").first.trim();
      }

      categoryPojoList.add(CategoryWiseAumPojo.fromJson(element));
    }
    categoryPojoList.sort((a, b) => b.aumAmount!.compareTo(a.aumAmount!));
  }

  Future getDatas() async {
    await getCategoryList();
    isLoading = false;
    return 0;
  }

  late double devHeight, devWidth;
  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: adminAppBar(
                title: "Broad Category Wise AUM",
                bgColor: Colors.white,
                hasAction: false),
            body: Column(
              children: [
                chipArea(),
                SizedBox(height: 16),
                sortLine(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Visibility(
                    visible: !isLoading,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${categoryPojoList.length} Items"),
                        Text("Total AUM $rupee ${calcTotalAUm()}",
                            style:
                                TextStyle(color: Config.appTheme.themeColor)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: listArea(),
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget listArea() {
    if (isLoading) return Utils.shimmerWidget(devHeight);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: categoryPojoList.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        CategoryWiseAumPojo data = categoryPojoList[index];
        String title = data.categoryName ?? "null";
        num percent = data.percent ?? 0;
        String amount = Utils.formatNumber(data.aumAmount);

        return ListTile(
          onTap: () {},
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(title, style: AppFonts.f50014Black),
              ),
              Text(
                "${percent.toStringAsFixed(2)}%",
                style: AppFonts.f50014Black,
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              percentageBar(percent.toDouble(), index),
              Text("($rupee $amount)", style: AppFonts.f40013),
            ],
          ),
          // trailing: Icon(Icons.arrow_forward_ios, size: 15),
        );
      },
    );
  }

  Widget chipArea() {
    return Container(
      height: 56,
      padding: EdgeInsets.only(left: 16),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: broadCategoryList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          Map category = broadCategoryList[index];
          String title = category['category_name'];
          if (title.length > 4) title = title.substring(0, title.length - 8);
          double percentage = category['category_percent'];
          String amount = Utils.formatNumber(category['category_value']);

          return RpSelectableChip(
            title: "$title ($percentage %)",
            isSelected: selectedCategory == title,
            value: "$rupee $amount",
            onTap: () {
              selectedCategory = title;
              categoryList = [];
              setState(() {});
            },
          );

          // return (selectedCategory == title)
          //     ? SelectedAmcChip(
          //         padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          //         title: title,
          //         valueStyle: TextStyle(color: Colors.white),
          //         value:
          //             "$percentage % ($rupee ${amount.toStringAsFixed(2)} Cr)")
          //     : AmcChip(
          //         padding: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          //         title: title,
          //         onTap: () {
          //           selectedCategory = title;
          //           categoryList = [];
          //           setState(() {});
          //         },
          //         value:
          //             "$percentage % ($rupee ${amount.toStringAsFixed(2)} Cr)");
        },
      ),
    );
  }

  Widget rpSelectableChip(
      {Function()? onTap,
      bool isSelected = false,
      required String title,
      String value = ""}) {
    Color fgColor = (isSelected) ? Colors.white : Colors.black;
    Color bgColor =
        (isSelected) ? Config.appTheme.themeColor : Color(0XFFF1F1F1);

    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(right: 14),
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 4),
          decoration: BoxDecoration(
              color: bgColor, borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: AppFonts.f50014Black.copyWith(color: fgColor)),
              if (value.isNotEmpty)
                Text(
                  value,
                  style: AppFonts.f40013.copyWith(color: fgColor),
                )
            ],
          ),
        ));
  }

  bool showSortChip = true;
  Widget sortLine() {
    return Container(
      height: 60,
      width: devWidth,
      color: Config.appTheme.mainBgColor,
      padding: EdgeInsets.only(left: 15),
      child: Row(
        children: [
          SortButton(onTap: () => sortBottomSheet(), title: "Sort By"),
          SizedBox(width: 8),
          if (showSortChip)
            RpFilterChip(
              selectedSort: selectedSort,
              hasClose: true,
              onClose: () {
                selectedSort = "Alphabet";
                showSortChip = false;
                applySort();
                setState(() {});
              },
            ),
        ],
      ),
    );
  }

  String calcTotalAUm() {
    num total = 0;
    for (CategoryWiseAumPojo element in categoryPojoList) {
      total += element.aumAmount ?? 0;
    }
    return Utils.formatNumber(total, isAmount: true);
  }

  sortBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: cornerBorder),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return Container(
              height: devHeight * 0.3,
              decoration: BoxDecoration(
                borderRadius: cornerBorder,
                color: Colors.white,
              ),
              child: Column(
                children: [
                  BottomSheetTitle(title: "Sort By"),
                  Divider(height: 0),
                  ListTile(
                    onTap: () {
                      selectSortAction("Alphabet");
                    },
                    leading: Radio(
                        value: "Alphabet",
                        groupValue: selectedSort,
                        onChanged: (val) {
                          selectSortAction("Alphabet");
                        }),
                    title: Text("Alphabet"),
                  ),
                  ListTile(
                    onTap: () {
                      selectSortAction("AUM");
                    },
                    leading: Radio(
                        value: "AUM",
                        groupValue: selectedSort,
                        onChanged: (val) {
                          selectSortAction("AUM");
                        }),
                    title: Text("AUM"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  selectSortAction(String title) {
    selectedSort = title;
    showSortChip = true;
    applySort();
    Get.back();
    setState(() {});
  }

  applySort() {
    if (selectedSort == 'Alphabet') {
      categoryPojoList
          .sort((a, b) => a.categoryName!.compareTo(b.categoryName!));
    }
    if (selectedSort == 'AUM') {
      categoryPojoList.sort((a, b) => b.aumAmount!.compareTo(a.aumAmount!));
    }
  }

  // double multiplier = 10;

  Widget percentageBar(double percent, int index) {
    double total = devWidth * 0.6;

    // if (index == 0) {
    //   multiplier = Utils.getMultiplier(percent);
    //   print("multiplier $multiplier");
    // }

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
          // width: (percent * multiplier),
          width: percent,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(10)),
        ),
      ],
    );
  }
}
