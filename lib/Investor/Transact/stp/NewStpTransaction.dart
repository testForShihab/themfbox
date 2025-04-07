import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/stp/StpAmountInput.dart';
import 'package:mymfbox2_0/pojo/Transaction/MyLumpsumFundsPojo.dart';
import 'package:mymfbox2_0/rp_widgets/AppBarColumn.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpPurchaseListTile.dart';
import 'package:mymfbox2_0/rp_widgets/RpSmallTf.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import '../../../api/TransactionApi.dart';
import '../../../rp_widgets/BottomSheetTitle.dart';
import '../../../rp_widgets/ColumnText.dart';
import '../../../rp_widgets/PlainButton.dart';
import '../../../utils/Constants.dart';

class NewStpTransaction extends StatefulWidget {
  const NewStpTransaction({
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
  State<NewStpTransaction> createState() => _NewStpTransactionState();
}

class _NewStpTransactionState extends State<NewStpTransaction> {
  late double devWidth, devHeight;
  int user_id = GetStorage().read("user_id") ?? 0;
  String client_name = GetStorage().read("client_name");
  Map client_code_map = GetStorage().read('client_code_map');

  String amcName = "";
  String amcCode = "";
  String selectedCategory = "All";
  List categoryList = [];
  List<MyLumpsumFundsPojo> stpSchemeList = [];

  Future getStpCategory() async {
    if (categoryList.isNotEmpty) return 0;
    Map data = await TransactionApi.getStpCategory(
      client_name: client_name,
      amc_name: amcName,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    categoryList = data['list'];
    categoryList.insert(0, "All");

    return 0;
  }

  Future getStpSchemes() async {
    Map data = await TransactionApi.getStpSchemes(
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      client_name: client_name,
      amc_name:  (client_code_map['bse_nse_mfu_flag'] == "MFU")? amcCode :amcName,
      category: selectedCategory,
    );
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    List list = data['scheme_list'];
    convertListToObj(list);
    return 0;
  }

  convertListToObj(List list) {
    stpSchemeList = [];
    for (var element in list) {
      stpSchemeList.add(MyLumpsumFundsPojo.fromJson(element));
    }
  }

  Future getDatas() async {
    await getStpCategory();
    await getStpSchemes();

    return 0;
  }

  @override
  void initState() {
    super.initState();
    amcName = widget.amcName;
    amcCode = widget.amcCode;
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;
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
                          itemCount: stpSchemeList.length,
                          // physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return fundCard(stpSchemeList[index]);
                          }),
                    ),
                  ),
                  SizedBox(height: 16),
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

  Widget fundCard(MyLumpsumFundsPojo stpFund) {
    String name = "${stpFund.schemeAmfiShortName}";
    if (name.isEmpty) name = "${stpFund.schemeAmfi}";
    String schemecategory = "${stpFund.schemeCategory?.replaceAll(":", " •")}";

    return Visibility(
      visible: searchFilter(name) && schemecategory.isNotEmpty,
      child: InkWell(
        onTap: () {
          Get.to(() => StpAmountInput(
                fromSchemeAmfiShortName: widget.schemeAmfiShortName,
                fromSchemeAmfi: widget.schemeAmfi,
                //toSchemeAmfiShortName: "${stpFund.schemeAmfiShortName}",
                toSchemeAmfiShortName: "${stpFund.schemeAmfi}",
                totalAmount: widget.currValue,
                totalUnits: widget.units,
                toSchemeAmfi: "${stpFund.schemeAmfi}",
                folio: widget.folio,
                logo: "${stpFund.amcLogo}",
                amccode: widget.amcCode,
                amcName: amcName,
              ));
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
                  stpFund.amcLogo ?? "",
                  height: 32,
                  errorBuilder: (context, error, stackTrace) => Text("null"),
                ),
                l1: name,
                l2: "${stpFund.schemeCategory?.replaceAll(":", " •")}",
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      child: Text("Transfer Now",
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
                    child: AppBarColumn(
                        enabled: false,
                        title: "AMC",
                        value: Utils.getFirst13(amcName, count: 12),
                        suffix: Icon(Icons.keyboard_arrow_down,
                            color: Config.appTheme.themeColor),
                        onTap: () {})),
                SizedBox(width: 10),
                Expanded(
                  child: AppBarColumn(
                      onTap: () {
                        showDoubleFilter();
                      },
                      title: "Category",
                      value: Utils.getFirst13(selectedCategory),
                      suffix: Icon(Icons.keyboard_arrow_down,
                          color: Config.appTheme.themeColor)),
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

  showDoubleFilter() {
    ExpansionTileController categoryController = ExpansionTileController();

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
                  Container(
                    width: devWidth,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: ColumnText(
                      title: 'AMC Name',
                      value: amcName,
                      titleStyle: AppFonts.f50014Black,
                      valueStyle: AppFonts.f50012,
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
                            stpSchemeList = [];
                            await getStpSchemes();
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
}
