import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/transact/lumpsum/LumpsumAmountInput.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/NoData.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpSmallTf.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import '../../../pojo/transaction/MyLumpsumFundsPojo.dart';
import '../../../rp_widgets/RpPurchaseListTile.dart';
import '../../../utils/AppFonts.dart';
import '../../../utils/Constants.dart';
import '../../../utils/Utils.dart';

class NewLumpsumTransaction extends StatefulWidget {
  const NewLumpsumTransaction({super.key});

  @override
  State<NewLumpsumTransaction> createState() => _NewLumpsumTransactionState();
}

class _NewLumpsumTransactionState extends State<NewLumpsumTransaction> {
  late double devWidth, devHeight;
  int user_id = GetStorage().read("user_id") ?? 0;
  String client_name = GetStorage().read("client_name");
  Map client_code_map = GetStorage().read('client_code_map');

  String selectedAmcName = "All";
  String selectedAmcCode = "";
  String selectedCategory = "All";

  List amcList = [];
  List categoryList = [];

  bool isLoading = true;
  List<MyLumpsumFundsPojo> lumpsumPojoList = [];

  Future getDatas() async {
    isLoading = true;
    // EasyLoading.show();
    await getAllAmc();
    await getCategoryList();
    await getLumpsumFunds();
    // EasyLoading.dismiss();
    isLoading = false;
    return 0;
  }

  Future getAllAmc() async {
    if (amcList.isNotEmpty) return 0;

    Map data = await TransactionApi.getLumpsumAmc(
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
    Map data = await TransactionApi.getLumpsumCategory(
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

  Future getLumpsumFunds() async {
    if (lumpsumPojoList.isNotEmpty) return 0;

    Map data = await TransactionApi.getLumpsumSchemes(
      amc_name: selectedAmcName,
      category: selectedCategory,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      client_name: client_name,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    List list = data['scheme_list'];
    convertListToObj(list);
    return 0;
  }

  convertListToObj(List list) {
    lumpsumPojoList = [];
    for (var element in list) {
      lumpsumPojoList.add(MyLumpsumFundsPojo.fromJson(element));
    }
  }

  String getFirst13(String text) {
    String s = text;
    if (s.length > 13) s = s.substring(0, 13);
    return s;
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;
    devHeight = MediaQuery.sizeOf(context).height;

    return FutureBuilder(
      future: getDatas(),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Config.appTheme.themeColor,
          appBar: invAppBar(
            title: Utils.getFirst13("LumpSum in New Scheme", count: 18),
          ),
          body: SideBar(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topFilterArea(),
                schemeArea(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget schemeArea() {
    if (!isLoading && lumpsumPojoList.isEmpty)
      return Expanded(
        child: Container(
          color: Config.appTheme.mainBgColor,
          child: Column(
            children: [
              NoData(),
            ],
          ),
        ),
      );
    return Expanded(
      child: Container(
        color: Config.appTheme.mainBgColor,
        child: ListView.builder(
            itemCount: isLoading ? 5 : (lumpsumPojoList.length),
            itemBuilder: (context, index) {
              if (isLoading)
                return Utils.shimmerWidget(100, margin: EdgeInsets.all(16));
              return fundCard(lumpsumPojoList[index]);
            }),
      ),
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
                  child: GestureDetector(
                    onTap: () {
                      // showAmcFilter();
                      showDoubleFilter(1);
                    },
                    child: appBarColumn(
                        "AMC",
                        Utils.getFirst13(selectedAmcName, count: 12),
                        Icon(Icons.keyboard_arrow_down,
                            color: Config.appTheme.themeColor)),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // showCategoryBottomSheet();

                      showDoubleFilter(2);
                    },
                    child: appBarColumn(
                        "Category",
                        getFirst13(selectedCategory),
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

  Widget fundCard(MyLumpsumFundsPojo lumpsumFund) {
    String name = "${lumpsumFund.schemeAmfiShortName}";
    if (name.isEmpty) name = "${lumpsumFund.schemeAmfi}";

    return Visibility(
      visible: searchFilter(name),
      child: InkWell(
        onTap: () {
          Get.to(() => LumpsumAmountInput(
              schemeAmfi: "${lumpsumFund.schemeAmfi}",
              trnx_type: "FP",
              amc: "${lumpsumFund.amcName}",
              arn: "",
              schemeAmfiShortName: "${lumpsumFund.schemeAmfiShortName}",
              logo: "${lumpsumFund.amcLogo}"));
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
                  lumpsumFund.amcLogo ?? "",
                  height: 32,
                  errorBuilder: (context, error, stackTrace) => Text("null"),
                ),
                l1: name,
                l2: "${lumpsumFund.schemeCategory?.replaceAll(":", " •")}",
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      child: Text("Invest Lumpsum",
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

  showDoubleFilter(int type) {
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
                  if (type == 1)
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
                                          // Image.network(img, height: 32),
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
                  if (type == 2)
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
                            lumpsumPojoList = [];
                            await getLumpsumFunds();
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

  String amcSearchKey = "";

  showAmcFilter() {
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
                    Text("  AMC Filter",
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
                smallTf(
                  initialValue: amcSearchKey,
                  bottomState,
                  onChange: (val) {
                    amcSearchKey = val ?? "";
                    bottomState(() {});
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: amcList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Map data = amcList[index];

                      String name = data['amc_name'];
                      String logo = data['amc_logo'];
                      String code = data["amc_code"];

                      return Visibility(
                        visible: searchVisibility(name, amcSearchKey),
                        child: InkWell(
                          onTap: () async {
                            EasyLoading.show();

                            selectedAmcName = name;
                            selectedAmcCode = code;
                            categoryList = [];
                            lumpsumPojoList = [];
                            bottomState(() {});
                            await getLumpsumFunds();

                            EasyLoading.dismiss();

                            Get.back();
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Radio(
                                  value: name,
                                  groupValue: selectedAmcName,
                                  activeColor: Config.appTheme.themeColor,
                                  onChanged: (val) async {
                                    selectedAmcName = name;
                                    selectedAmcCode = code;
                                    categoryList = [];
                                    lumpsumPojoList = [];
                                    bottomState(() {});
                                    EasyLoading.show();

                                    selectedAmcName = name;
                                    lumpsumPojoList = [];
                                    bottomState(() {});
                                    await getLumpsumFunds();

                                    EasyLoading.dismiss();

                                    Get.back();
                                    setState(() {});
                                  }),
                              Image.network(logo, height: 30,
                                  errorBuilder: (context, error, stackTrace) {
                                print("error = $error");
                                print("stackTrace = $stackTrace");
                                return Text("null");
                              }),
                              SizedBox(width: 10),
                              Flexible(child: Text(name)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget smallTf(StateSetter bottomState,
      {Function(String?)? onChange, String initialValue = ""}) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: TextFormField(
        onChanged: onChange,
        initialValue: initialValue,
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
                smallTf(
                  bottomState,
                  onChange: (val) {
                    categorySearchKey = val ?? "";
                    bottomState(() {});
                  },
                  initialValue: categorySearchKey,
                ),

                /* SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allCategories.length,
                    itemBuilder: (context, index) {
                      Map temp = allCategories[index];

                      return (selectedCategory == temp['name'])
                          ? selectedCategoryChip(
                          "${temp['name']}", "${temp['count']}")
                          : InkWell(
                          onTap: () async {
                            selectedCategory = temp['name'];
                            subCategoryList = [];
                            // EasyLoading.show();
                            await getCategoryList();
                            // EasyLoading.dismiss();
                            bottomState(() {});
                          },
                          child: categoryChip(
                              "${temp['name']}", "${temp['count']}"));
                    },
                  ),
                ),*/
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: categoryList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      // String temp = categoryList[index].split(":").last;
                      String title = categoryList[index];

                      return Visibility(
                        visible: searchVisibility(title, categorySearchKey),
                        child: InkWell(
                          onTap: () async {
                            selectedCategory = title;
                            lumpsumPojoList = [];
                            bottomState(() {});
                            EasyLoading.show();
                            await getLumpsumFunds();
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
                                    lumpsumPojoList = [];
                                    bottomState(() {});
                                    EasyLoading.show();
                                    await getLumpsumFunds();
                                    EasyLoading.dismiss();

                                    Get.back();
                                    setState(() {});
                                  }),
                              /* Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: Color(0xffF8DFD5),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Icon(Icons.bar_chart,
                                      color: Colors.red, size: 20)),*/
                              Expanded(
                                child: Text(categoryList[index]),
                              ),
                            ],
                          ),
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
