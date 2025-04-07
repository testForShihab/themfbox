import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/Investor/Transact/sip/BseSipAmountInput.dart';
import 'package:mymfbox2_0/Investor/Transact/sip/SipAmountInput.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/pojo/transaction/MySipFundsPojo.dart';
import 'package:mymfbox2_0/rp_widgets/AppBarColumn.dart';
import 'package:mymfbox2_0/rp_widgets/RpSmallTf.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpPurchaseListTile.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class NewSipTransaction extends StatefulWidget {
  const NewSipTransaction({super.key});

  @override
  State<NewSipTransaction> createState() => _NewSipTransactionState();
}

class _NewSipTransactionState extends State<NewSipTransaction> {
  late double devWidth, devHeight;
  int user_id = GetStorage().read("user_id") ?? 0;
  String client_name = GetStorage().read("client_name");
  Map client_code_map = GetStorage().read('client_code_map');

  String selectedAmcName = "All";
  String selectedAmcCode = "";
  String selectedCategory = "All";
  //String selectedSubCategory = "Equity: Large Cap";

  List amcList = [];
  List categoryList = [];
  // List performanceList = [];

  List<MySipFundsPojo> sipPojoList = [];

  bool isLoading = true;
  Future getDatas() async {
    EasyLoading.show();

    await getAllAmc();
    await getCategoryList();
    await getSipSchemes();

    EasyLoading.dismiss();
    isLoading = false;
    return 0;
  }

  Future getAllAmc() async {
    if (amcList.isNotEmpty) return 0;

    Map data = await TransactionApi.getSipAmc(
      client_name: client_name,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
    );

    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    amcList = data['list'];
    if (amcList.length > 2) {
      selectedAmcName = amcList[1]['amc_name'];
      selectedAmcCode = amcList[1]['amc_code'];
    }
    selectedAmcName = amcList[0]['amc_name'];
    selectedAmcCode = amcList[0]['amc_code'];

    return 0;
  }

  Future getCategoryList() async {
    if (categoryList.isNotEmpty) return 0;
    Map data = await TransactionApi.getSipCategory(
      amc_code: selectedAmcCode,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      client_name: client_name,
    );
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    categoryList = data['list'];
    categoryList.insert(0, "All");
    print("categoryList = $categoryList");
    return 0;
  }

  Future getSipSchemes() async {
    if (sipPojoList.isNotEmpty) return 0;

    Map data = await TransactionApi.getSipSchemes(
      amc_name: (client_code_map['bse_nse_mfu_flag'] == "MFU")
          ? selectedAmcCode
          : selectedAmcName,
      category: selectedCategory,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      client_name: client_name,
    );

    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    List list = data['scheme_list'];
    convertListToObj(list);
    return 0;
  }

  convertListToObj(List list) {
    sipPojoList = [];
    for (var element in list) {
      sipPojoList.add(MySipFundsPojo.fromJson(element));
    }
  }

  String getFirst13(String text) {
    String s = text;
    if (s.length > 13) s = s.substring(0, 13);
    return s;
  }

  String searchKey = "";

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;
    devHeight = MediaQuery.sizeOf(context).height;

    return FutureBuilder(
      future: getDatas(),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Config.appTheme.mainBgColor,
          appBar: invAppBar(
            title: "Start SIP in New Scheme",
          ),
          body: SideBar(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topFilterArea(),
                (sipPojoList.isEmpty && !isLoading)
                    ? Center(child: EmptyCart())
                    : Expanded(
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
                      ),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  searchFilter(String title) {
    title = title.toLowerCase();
    searchKey = searchKey.toLowerCase();

    if (searchKey.isEmpty)
      return true;
    else
      return title.contains(searchKey);
  }

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
                    child: AppBarColumn(
                  title: "AMC",
                  value: Utils.getFirst13(selectedAmcName, count: 11),
                  suffix: Icon(
                    Icons.keyboard_arrow_down,
                    color: Config.appTheme.themeColor,
                  ),
                  onTap: () {
                    showDoubleFilter();
                  },
                )),
                SizedBox(width: 10),
                Expanded(
                    child: AppBarColumn(
                        title: "Category",
                        value: Utils.getFirst13(selectedCategory),
                        suffix: Icon(Icons.keyboard_arrow_down,
                            color: Config.appTheme.themeColor),
                        onTap: () {
                          showDoubleFilter();
                        })),
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
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget fundCard(MySipFundsPojo sipFund) {
    String name = "${sipFund.schemeAmfiShortName}";
    if (name.isEmpty) name = "${sipFund.schemeAmfi}";

    return Visibility(
      visible: searchFilter(name),
      child: InkWell(
        onTap: () {
          if (client_code_map['bse_nse_mfu_flag'].toUpperCase() == "BSE") {
            Get.to(() => BseSipAmountInput(
                  shortName: name,
                  logo: "${sipFund.amcLogo}",
                  schemeAmfi: "${sipFund.schemeAmfi}",
                  amc: "${sipFund.amcName}",
                ));
          } else {
            Get.to(() => SipAmountInput(
                  shortName: name,
                  logo: "${sipFund.amcLogo}",
                  schemeAmfi: "${sipFund.schemeAmfi}",
                  amc: "${sipFund.amcName}",
                ));
          }
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
                l1: name,
                l2: "${sipFund.schemeCategory?.replaceAll(":", " •")}",
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      child: Text("Start SIP",
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

  Widget appBarColumn(String title, String value, Widget suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: AppFonts.f40013.copyWith(color: Colors.white)),
        Container(
          padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Config.appTheme.overlay85,
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

  Widget smallTf(StateSetter bottomState, {Function(String?)? onChange}) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: TextFormField(
        onChanged: onChange,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Search",
            contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 12)),
      ),
    );
  }

  searchVisibility(String title, String searchKey) {
    title = title.toLowerCase();
    searchKey = searchKey.toLowerCase();

    if (searchKey.isEmpty)
      return true;
    else {
      return title.contains(searchKey);
    }
  }

  showDoubleFilter() {
    ExpansionTileController amcController = ExpansionTileController();
    ExpansionTileController categoryController = ExpansionTileController();
    String amcSearch = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: cornerBorder),
      builder: (context) {
        return StatefulBuilder(builder: (_, bottomState) {
          return Container(
            height: devHeight * 0.9,
            decoration: BoxDecoration(borderRadius: cornerBorder),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BottomSheetTitle(title: "Filter Schemes"),
                  SizedBox(height: 16),
                  // amc filter
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        controller: amcController,
                        onExpansionChanged: (val) {},
                        title: Text("AMC Name", style: AppFonts.f50014Black),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(selectedAmcName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Config.appTheme.themeColor)),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
                            child: SizedBox(
                              height: 40,
                              child: TextFormField(
                                initialValue: amcSearch,
                                onChanged: (val) {
                                  amcSearch = val;
                                  bottomState(() {});
                                },
                                decoration: InputDecoration(
                                    // suffixIcon: Icon(Icons.close,
                                    //     color: Config.appTheme.themeColor),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 2, 12, 2),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 400,
                            child: ListView.builder(
                              shrinkWrap: true,
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: amcList.length,
                              itemBuilder: (context, index) {
                                Map data = amcList[index];
                                String name = data['amc_name'];
                                String code = data['amc_code'];
                                String img = data['amc_logo'];

                                return Visibility(
                                  visible: searchVisibility(name, amcSearch),
                                  child: InkWell(
                                    onTap: () async {
                                      selectedAmcName = name;
                                      selectedAmcCode = code;
                                      EasyLoading.show();
                                      categoryList = [];
                                      await getCategoryList();
                                      EasyLoading.dismiss();
                                      bottomState(() {});
                                      amcController.collapse();
                                    },
                                    child: Row(
                                      children: [
                                        Radio(
                                            value: code,
                                            groupValue: selectedAmcCode,
                                            onChanged: (val) async {
                                              selectedAmcName = name;
                                              selectedAmcCode = code;
                                              EasyLoading.show();
                                              categoryList = [];
                                              await getCategoryList();
                                              EasyLoading.dismiss();
                                              bottomState(() {});
                                              amcController.collapse();
                                            }),
                                        //Image.network(img, height: 32),
                                        //SizedBox(width: 10),
                                        Expanded(
                                            child: Text(name,
                                                style: AppFonts.f50014Grey)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),
                  // category filter
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          controller: categoryController,
                          title: Text("Category"),
                          subtitle: Text(selectedCategory,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Config.appTheme.themeColor)),
                          children: [
                            SizedBox(
                              height: 400,
                              child: ListView.builder(
                                shrinkWrap: true,
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: categoryList.length,
                                itemBuilder: (context, index) {
                                  String name = categoryList[index];

                                  return InkWell(
                                    onTap: () {
                                      selectedCategory = name;
                                      categoryController.collapse();
                                      bottomState(() {});
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 1),
                                      child: Row(
                                        children: [
                                          Radio(
                                              value: name,
                                              groupValue: selectedCategory,
                                              onChanged: (val) {
                                                selectedCategory = name;
                                                categoryController.collapse();
                                                bottomState(() {});
                                              }),
                                          Expanded(
                                              child: Text(name,
                                                  style: AppFonts.f50014Grey)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        )),
                  ),

                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                            child: PlainButton(
                          text: "CLEAR ALL",
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        )),
                        SizedBox(width: 10),
                        Expanded(
                            child: RpFilledButton(
                          onPressed: () async {
                            sipPojoList = [];
                            await getSipSchemes();
                            Get.back();
                            setState(() {});
                          },
                          text: "APPLY",
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget selectedCategoryChip(String name, String count) {
    List l = name.split(" ");
    if (l.length > 2)
      name = "${l[0]} ${l[1]}";
    else
      name = "${l[0]}";

    return Container(
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          color: Config.appTheme.themeColor,
          borderRadius: BorderRadius.circular(8)),
      child: Text("$name ($count)", style: TextStyle(color: Colors.white)),
    );
  }

  Widget categoryChip(String name, String count) {
    List l = name.split(" ");
    if (l.length > 2)
      name = "${l[0]} ${l[1]}";
    else
      name = "${l[0]}";

    return Container(
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          color: Color(0XFFF1F1F1), borderRadius: BorderRadius.circular(8)),
      child: Text("$name ($count)"),
    );
  }

  Widget amcView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: amcList.length,
      itemBuilder: (context, index) {
        String title = amcList[index];
        return InkWell(
          onTap: () {},
          child: Row(
            children: [
              Radio(
                value: title,
                activeColor: Config.appTheme.themeColor,
                onChanged: (val) {},
                groupValue: "sortBy",
              ),
              Flexible(child: Text(title)),
            ],
          ),
        );
      },
    );
  }
}
