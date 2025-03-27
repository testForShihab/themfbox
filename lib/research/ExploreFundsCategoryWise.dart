import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/research/trailingReturns/TrailingReturns.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class ExploreFundsCategoryWise extends StatefulWidget {
  const ExploreFundsCategoryWise({super.key});

  @override
  State<ExploreFundsCategoryWise> createState() =>
      _ExploreFundsCategoryWiseState();
}

class _ExploreFundsCategoryWiseState extends State<ExploreFundsCategoryWise> {
  String client_name = GetStorage().read("client_name");
  late double devWidth, devHeight;
  String selectedCategory = "Equity Schemes";
  String selectedTrailingReturns = 'Trailing Returns';
  String selectedSubCategory = "Equity: Large Cap";
  List allCategories = [];
  List subCategoryList = [];

  Future getDatas() async {
    EasyLoading.isShow;
    await getBroadCategoryList();
    await getCategoryList();
    EasyLoading.dismiss();
    return 0;
  }

  Future getBroadCategoryList() async {
    if (allCategories.isNotEmpty) return 0;
    Map data = await Api.getBroadCategoryList(client_name: client_name);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    allCategories = data['list'];

    return 0;
  }

  Future getCategoryList() async {
    if (subCategoryList.isNotEmpty) return 0;

    Map data = await Api.getCategoryList(
        category: selectedCategory, client_name: client_name);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    subCategoryList = data['list'];
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: appBar(),
            body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${subCategoryList.length} Items",
                            style: AppFonts.f40013
                                .copyWith(color: AppColors.arrowGrey),
                          ),
                        ],
                      ),
                    ),
                    subCategoryCard(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget categoryCard() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allCategories.length,
        itemBuilder: (context, index) {
          Map temp = allCategories[index];

          return (selectedCategory == temp['name'])
              ? selectedCategoryChip("${temp['name']}", "")
              : InkWell(
                  onTap: () async {
                    selectedCategory = temp['name'];
                    print("selectedCategoryyyy $selectedCategory");
                    subCategoryList = [];
                    await getCategoryList();
                    setState(() {});
                  },
                  child: categoryChip("${temp['name']}", ""));
        },
      ),
    );
  }

  Widget subCategoryCard() {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 16, 8), // Set padding on all sides
      child: SizedBox(
        height: devHeight,
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: subCategoryList.length,
          itemBuilder: (context, index) {
            String temp = subCategoryList[index];
            String subCategory = temp;
            if (temp.contains(":")) {
              List list = subCategoryList[index].split(":");
              // category = list[0];
              subCategory = list[1].trim();
            }

            String selCategory = selectedCategory.contains(' ')
                ? selectedCategory.split(' ')[0]
                : selectedCategory;
            String category = selCategory;
            return InkWell(
              onTap: () async {
                Get.to(TrailingReturns(
                    defaultCategory: category,
                    defaultSubCategory: subCategory));
                setState(() {});
              },
              child: Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Color(0xffF8DFD5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(Icons.bar_chart, color: Colors.red, size: 20),
                  ),
                  SizedBox(width: 8), // Add spacing between icon and text
                  Expanded(
                      child: Text(
                    " $subCategory",
                    style: AppFonts.f50014Black,
                  )),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Config.appTheme.placeHolderInputTitleAndArrow,
                  )
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              DottedLine(verticalPadding: 4),
        ),
      ),
    );
  }

  Widget invBtnchipArea() {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allCategories.length,
        itemBuilder: (context, index) {
          Map temp = allCategories[index];

          return (selectedCategory == temp['name'])
              ? selectedCategoryChip("${temp['name']}", "${temp['count']}")
              : InkWell(
                  onTap: () async {
                    selectedCategory = temp['name'];
                    subCategoryList = [];
                    await getCategoryList();
                    setState(() {});
                  },
                  child: categoryChip("${temp['name']}", "${temp['count']}"));
        },
      ),
    );
  }

  Widget selectedCategoryChip(String name, String count) {
    List l = name.split(" ");

    name = "${l[0]}";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          color: Config.appTheme.themeColor,
          borderRadius: BorderRadius.circular(8)),
      child: Text(
        "$name",
        style: AppFonts.f50014Black.copyWith(color: Colors.white),
      ),
    );
  }

  Widget categoryChip(String name, String count) {
    List l = name.split(" ");
    if (l.length > 2)
      name = "${l[0]}";
    else
      name = "${l[0]}";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          color: Color(0XFFF1F1F1), borderRadius: BorderRadius.circular(8)),
      child: Text(
        "$name",
        style: AppFonts.f50014Black,
      ),
    );
  }

  appBar() {
    return PreferredSize(
      preferredSize: Size(devWidth, 90),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          top: 34,
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back)),
                Text("Explore Funds Category Wise",
                    style: AppFonts.appBarTitle.copyWith(fontSize: 18)),
              ],
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                left: 16,
              ),
              child: categoryCard(),
            ),
          ],
        ),
      ),
    );
  }
}
