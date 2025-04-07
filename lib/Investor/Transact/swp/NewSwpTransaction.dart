import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/switch/SwitchAmountInput.dart';
import 'package:mymfbox2_0/api/transaction/NseTransactionApi.dart';
import 'package:mymfbox2_0/pojo/transaction/MySipFundsPojo.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpPurchaseListTile.dart';
import 'package:mymfbox2_0/rp_widgets/RpSmallTf.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class NewSwpTransaction extends StatefulWidget {
  const NewSwpTransaction({
    super.key,
    required this.amcName,
    required this.amcCode,
    required this.currValue,
    required this.units,
    required this.schemeAmfi,
    required this.schemeAmfiShortName,
    required this.folio,
  });

  final String amcName;
  final String amcCode;
  final num currValue, units;
  final String schemeAmfi, schemeAmfiShortName;
  final String folio;

  @override
  State<NewSwpTransaction> createState() => _NewSwpTransactionState();
}

class _NewSwpTransactionState extends State<NewSwpTransaction> {
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");

  late String amc;
  String selectedCategory = "All";
  List categoryList = [];
  List<MySipFundsPojo> sipPojoList = [];

  Future getCategoryList() async {
    if (categoryList.isNotEmpty) return 0;
    Map data = await NseTransactionApi.getStpCategoryByAmcCode(
        user_id: user_id, client_name: client_name, amc_name: amc);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    categoryList = data['list'];
    categoryList.insert(0, "All");
    print("categoryList = $categoryList");
    return 0;
  }

  Future getSwitchSchemes() async {
    if (sipPojoList.isNotEmpty) return 0;

    EasyLoading.show();
    Map data = await NseTransactionApi.getStpSchemesByAmcCodeAndCategory(
        user_id: user_id,
        client_name: client_name,
        amc_name: amc,
        category: selectedCategory);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    List list = data['list'];
    convertListToObj(list);
    EasyLoading.dismiss();
    return 0;
  }

  convertListToObj(List list) {
    sipPojoList = [];
    for (var element in list) {
      sipPojoList.add(MySipFundsPojo.fromJson(element));
    }
  }

  Future getDatas() async {
    await getCategoryList();
    await getSwitchSchemes();

    return 0;
  }

  @override
  void initState() {
    //  implement initState
    super.initState();
  }

  late double devHeight;
  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: invAppBar(
                title:
                    Utils.getFirst13("Select Scheme to Transfer", count: 20)),
            body: SideBar(
              child: Column(
                children: [
                  topFilterArea(),
                  Expanded(
                    child: Container(
                      color: Config.appTheme.mainBgColor,
                      child: ListView.builder(
                          // shrinkWrap: true,
                          itemCount: sipPojoList.length,
                          // physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return fundCard(sipPojoList[index]);
                          }),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  searchFilter(String title) {
    title = title.toLowerCase();
    searchKey = searchKey.toLowerCase();

    if (searchKey.isEmpty)
      return true;
    else
      return title.contains(searchKey);
  }

  Widget fundCard(MySipFundsPojo sipFund) {
    String shortName = "${sipFund.schemeAmfiShortName}";

    return Visibility(
      visible: searchFilter(shortName),
      child: InkWell(
        onTap: () {
          Get.to(() => SwitchAmountInput(
              fromSchemeAmfiShortName: "",
              fromSchemeAmfi: "",
              toSchemeAmfiShortName: "",
              totalAmount: 0,
              totalUnits: 0,
              toSchemeAmfi: "",
              folio: "",
              logo: ""));
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              //1st row
              RpPurchaseListTile(
                leading: Image.network(
                  sipFund.amcLogo ?? "",
                  height: 32,
                  errorBuilder: (context, error, stackTrace) => Text("null"),
                ),
                l1: shortName,
                l2: "${sipFund.schemeCategory?.replaceAll(":", " •")}",
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      child: Text("Start STP",
                          style: AppFonts.f50014Black
                              .copyWith(color: Config.appTheme.themeColor))),
                  Icon(Icons.arrow_forward_ios,
                      color: AppColors.arrowGrey, size: 18)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String searchKey = "";
  Widget topFilterArea() {
    return Container(
      color: Config.appTheme.themeColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: appBarColumn(
                      "AMC",
                      Utils.getFirst13(amc, count: 12),
                      Icon(Icons.keyboard_arrow_down,
                          color: Config.appTheme.themeColor),
                      enabled: false),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showCategoryBottomSheet();
                    },
                    child: appBarColumn(
                        "Category",
                        Utils.getFirst13(selectedCategory),
                        Icon(Icons.keyboard_arrow_down,
                            color: Config.appTheme.themeColor)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 50,
              child: RpSmallTf(
                hintText: "Search",
                onChange: (val) {
                  searchKey = val;
                  setState(() {});
                },
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget appBarColumn(String title, String value, Widget suffix,
      {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: AppFonts.f40013.copyWith(color: Colors.white)),
        Container(
          padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: (enabled)
                ? Config.appTheme.overlay85
                : Config.appTheme.themeColor25,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Row(
              children: [
                Text(value,
                    style: TextStyle(
                        color: Config.appTheme.themeColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Spacer(),
                suffix
              ],
            ),
          ),
        )
      ],
    );
  }

  String categorySearchKey = "";
  showCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      builder: (context) {
        return StatefulBuilder(builder: (_, bottomState) {
          return Container(
            height: devHeight * 0.7,
            padding: EdgeInsets.all(7),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("  Select Category",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.close))
                  ],
                ),
                Divider(),
                // RpSmallTf(
                //   onChange: (val) {
                //     categorySearchKey = val;
                //     bottomState(() {});
                //   },
                //   initialValue: categorySearchKey,
                //   filled: true,
                //   fillColor: Colors.white,
                // ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: categoryList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      // String temp = categoryList[index].split(":").last;
                      String title = categoryList[index];

                      return InkWell(
                        onTap: () async {
                          selectedCategory = title;
                          sipPojoList = [];
                          bottomState(() {});
                          EasyLoading.show();
                          await getSwitchSchemes();
                          EasyLoading.dismiss();

                          Get.back();
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Radio(
                                value: title,
                                groupValue: selectedCategory,
                                activeColor: Config.appTheme.themeColor,
                                onChanged: (val) async {
                                  selectedCategory = title;
                                  sipPojoList = [];
                                  bottomState(() {});
                                  EasyLoading.show();
                                  await getSwitchSchemes();
                                  EasyLoading.dismiss();

                                  Get.back();
                                  setState(() {});
                                }),
                            Expanded(
                              child: Text(categoryList[index]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }
}
