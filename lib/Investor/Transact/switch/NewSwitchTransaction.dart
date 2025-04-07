import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/switch/SwitchAmountInput.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/rp_widgets/AppBarColumn.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/NoData.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpSmallTf.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import '../../../api/InvestorApi.dart';
import '../../../pojo/transaction/MyLumpsumFundsPojo.dart';
import '../../../rp_widgets/ColumnText.dart';
import '../../../rp_widgets/RpPurchaseListTile.dart';
import '../../../utils/AppFonts.dart';
import '../../../utils/Constants.dart';
import '../../../utils/Utils.dart';

class NewSwitchTransaction extends StatefulWidget {
  const NewSwitchTransaction({
    super.key,
    required this.amcName,
    required this.schemeAmcCode,
    required this.currValue,
    required this.units,
    required this.schemeAmfi,
    required this.schemeAmfiShortName,
    required this.folio,
  });

  final String amcName;
  final String schemeAmcCode;
  final num currValue, units;
  final String schemeAmfi, schemeAmfiShortName;
  final String folio;

  @override
  State<NewSwitchTransaction> createState() => _NewSwitchTransactionState();
}

class _NewSwitchTransactionState extends State<NewSwitchTransaction> {
  late double devWidth, devHeight;
  int user_id = GetStorage().read("user_id") ?? 0;
  String client_name = GetStorage().read("client_name");
  Map client_code_map = GetStorage().read('client_code_map');

  String amcName = "";
  String selectedAmcCode = "";
  String selectedCategory = "All";

  bool isLoading = true;
  bool isFirst = true;
  List<MyLumpsumFundsPojo> switchSchemeList = [];
  List<MyLumpsumFundsPojo> nfoSwitchSchemeList = [];
  ExpansionTileController schemeController = ExpansionTileController();

  // Add this flag to track if initial data is loaded
  bool isInitialDataLoaded = false;

  Future getDatas() async {
    // Only load data if not already loaded
    if (!isInitialDataLoaded) {
      isLoading = true;
      await getLumpsumCategory();
      
      if (client_code_map['bse_nse_mfu_flag'] == "BSE") {
        if (selectedOption == "Existing Scheme") {
          await getBSESwitchExistingSchemes();
        } else {
          await getSwitchToSchemes();
        }
      } else {
        await getSwitchToSchemes();
      }
      
      isInitialDataLoaded = true; // Mark as loaded
      isLoading = false;
    }
    return 0;
  }

  List categoryList = [];
  Future getLumpsumCategory() async {
    if (categoryList.isNotEmpty) return 0;

    String marketType = client_code_map['bse_nse_mfu_flag'];

    Map data = await TransactionApi.getLumpsumCategory(
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      client_name: client_name,
      amc_code: (marketType == 'BSE') ? amcName : widget.schemeAmcCode,
    );
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    categoryList = data['list'];
    categoryList.insert(0, "All");
    return 0;
  }

  //getBSESwitchExistingSchemes

 // List existingSchemeList = [];
  Future getBSESwitchExistingSchemes() async {
    EasyLoading.show(); // Add loading indicator
    Map data = await TransactionApi.getBSESwitchExistingSchemes(
      client_name: client_name,
      user_id: user_id,
       amc_name: amcName,
      scheme_amfi_short_name: widget.schemeAmfiShortName,
    );
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      EasyLoading.dismiss();
      return -1;
    }
    List list = data['scheme_list'];
    switchSchemeList = convertListToObj(list);
    EasyLoading.dismiss();
    setState(() {}); // Update UI after getting data
    return 0;
  }


  List nfoSchemes = [];
  Future getSwitchToSchemes() async {
    String marketType = client_code_map['bse_nse_mfu_flag'];
    Map data = await TransactionApi.getSwitchToSchemes(
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      client_name: client_name,
      user_id: user_id,
      amc_code: (marketType == "BSE") ? amcName : widget.schemeAmcCode,
      category: selectedCategory,
    );
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    List list = data['scheme_list'];
    List nfoList = data['nfo_scheme_list'];
    switchSchemeList = convertListToObj(list);
    nfoSwitchSchemeList = convertListToObj(nfoList);
    return 0;
  }

  convertListToObj(List list) {
    List<MyLumpsumFundsPojo> temp = [];

    for (var element in list) {
      temp.add(MyLumpsumFundsPojo.fromJson(element));
    }
    return temp;
  }

  @override
  void initState() {
    super.initState();
    amcName = widget.amcName;
    selectedAmcCode = widget.schemeAmcCode;
    selectedOption = "New Scheme"; // Set default option
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;
    devHeight = MediaQuery.sizeOf(context).height;

    // Change to use a normal Scaffold instead of FutureBuilder
    return Scaffold(
      backgroundColor: Config.appTheme.themeColor,
      appBar: invAppBar(
        title: Utils.getFirst13("Select Scheme To Switch", count: 18),
      ),
      body: SideBar(
        child: FutureBuilder(
          future: getDatas(),
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topFilterArea(),
                if (client_code_map['bse_nse_mfu_flag'] != 'BSE')
                  nfoSchemeArea(context),
                schemeArea(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget nfoSchemeArea(BuildContext context) {
    int len = nfoSwitchSchemeList.length;

    return Container(
      decoration: BoxDecoration(color: Colors.white, border: Border.all()),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.white),
        child: ExpansionTile(
          controller: schemeController,
          title: Row(
            children: [
              Image.asset("assets/nfo-switch.png",
                  width: 32, color: Config.appTheme.themeColor),
              SizedBox(width: 10),
              Text("$len NFO Schemes", style: AppFonts.f50014Black),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: len,
              itemBuilder: (BuildContext context, int index) {
                return nfoCard(switchSchemeList[index]);
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget schemeArea() {
    if (isLoading) {
      return Expanded(
        child: Container(
          color: Config.appTheme.mainBgColor,
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Utils.shimmerWidget(100, margin: EdgeInsets.all(16));
            }
          ),
        ),
      );
    }
    
    if (switchSchemeList.isEmpty) {
      print("Empty list found in switchSchemeList in NewSwitchTransaction.dart");
      return Expanded(
        child: Container(
          color: Config.appTheme.mainBgColor,
          child: Column(
            children: [
              (selectedOption == "Existing Scheme") ? NoData( text: "No existing schemes found" ) : NoData( text: "No schemes found"),

            ],
          ),
        ),
      );
    }

    
    return Expanded(
      child: Container(
        color: Config.appTheme.mainBgColor,
        child: ListView.builder(
          itemCount: switchSchemeList.length,
          itemBuilder: (context, index) {
            return fundCard(switchSchemeList[index]);
          }
        ),
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
      padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: AppBarColumn(
                      onTap: () {},
                      enabled: false,
                      title: "AMC",
                      value: Utils.getFirst13(amcName, count: 12),
                      suffix: Icon(
                        Icons.keyboard_arrow_down,
                        color: Config.appTheme.themeColor,
                      ))),
              SizedBox(width: 10),
              Expanded(
                  child: AppBarColumn(
                title: "Category",
                value: Utils.getFirst13(selectedCategory),
                suffix: Icon(
                  Icons.keyboard_arrow_down,
                  color: Config.appTheme.themeColor,
                ),
                onTap: () {
                  showDoubleFilter();
                },
              )),
            ],
          ),
          SizedBox(height: 16),
        if(client_code_map['bse_nse_mfu_flag'] == "BSE")Row(
            children: [
              Expanded(
                  child: AppBarColumn(
                    title: "Select Option",
                    value: selectedOption,
                    suffix: Icon(
                      Icons.keyboard_arrow_down,
                      color: Config.appTheme.themeColor,
                    ),
                    onTap: () {
                      showSelectedOption();
                    },
                  )),
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
    );
  }

  Widget fundCard(MyLumpsumFundsPojo switchFund) {
    String name = "${switchFund.schemeAmfiShortName}";
    if (name.isEmpty) name = "${switchFund.schemeAmfi}";

    return Visibility(
      visible: searchFilter(name),
      child: InkWell(
        onTap: () {
          Get.to(() => SwitchAmountInput(
                fromSchemeAmfiShortName: widget.schemeAmfiShortName,
                fromSchemeAmfi: widget.schemeAmfi,
                toSchemeAmfiShortName: "${switchFund.schemeAmfiShortName}",
                totalAmount: widget.currValue,
                totalUnits: widget.units,
                toSchemeAmfi: "${switchFund.schemeAmfi}",
                folio: widget.folio,
                logo: "${switchFund.amcLogo}",
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
                  switchFund.amcLogo ?? "",
                  height: 32,
                  errorBuilder: (context, error, stackTrace) => Text("null"),
                ),
                l1: name,
                l2: "${switchFund.schemeCategory?.replaceAll(":", " •")}",
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      child: Text("Switch Now",
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

  Widget nfoCard(MyLumpsumFundsPojo switchFund) {
    String name = "${switchFund.schemeAmfiShortName}";
    if (name.isEmpty) name = "${switchFund.schemeAmfi}";

    return Visibility(
      visible: searchFilter(name),
      child: InkWell(
        onTap: () {
          Get.to(() => SwitchAmountInput(
                fromSchemeAmfiShortName: widget.schemeAmfiShortName,
                fromSchemeAmfi: widget.schemeAmfi,
                toSchemeAmfiShortName: "${switchFund.schemeAmfiShortName}",
                totalAmount: widget.currValue,
                totalUnits: widget.units,
                toSchemeAmfi: "${switchFund.schemeAmfi}",
                folio: widget.folio,
                logo: "${switchFund.amcLogo}",
                isNfo: true,
              ));
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              border: Border.all(color: Config.appTheme.themeColor, width: 1),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              //1st row
              RpPurchaseListTile(
                leading: Image.network(
                  switchFund.amcLogo ?? "",
                  height: 32,
                  errorBuilder: (context, error, stackTrace) => Text("null"),
                ),
                l1: name,
                l2: "${switchFund.schemeCategory?.replaceAll(":", " •")}",
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      child: Text("Switch Now",
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

  List optionList = ['New Scheme','Existing Scheme'];
  String selectedOption = "New Scheme";

  showSelectedOption() {
    ExpansionTileController optionController = ExpansionTileController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: cornerBorder),
      builder: (context) {
        return StatefulBuilder(builder: (_, bottomState) {
          return Container(
            height: devHeight * 0.9,
            decoration: BoxDecoration(borderRadius: cornerBorder),
            child: Column(
              children: [
                BottomSheetTitle(title: "Select Option"),
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      controller: optionController,
                      title: Text("Select Option"),
                      subtitle: Text(selectedOption,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Config.appTheme.themeColor
                        )
                      ),
                      children: [
                        SizedBox(
                          height: 400,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: optionList.length,
                            itemBuilder: (context, index) {
                              String name = optionList[index];
                              return InkWell(
                                onTap: () async {
                                  selectedOption = name;
                                  optionController.collapse();
                                  switchSchemeList = []; // Clear existing list
                                  isLoading = true; // Show loading state
                                  setState(() {});
                                  
                                  if (selectedOption == "New Scheme") {
                                    await getSwitchToSchemes();
                                  } else if (selectedOption == "Existing Scheme") {
                                    await getBSESwitchExistingSchemes();
                                  }
                                  
                                  isLoading = false;
                                  bottomState(() {});
                                  setState(() {}); // Update main UI
                                  Get.back();
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 1),
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: name,
                                        groupValue: selectedOption,
                                        onChanged: (val) async {
                                          selectedOption = name;
                                          optionController.collapse();
                                          switchSchemeList = []; // Clear existing list
                                          isLoading = true; // Show loading state
                                          setState(() {});
                                          
                                          if (selectedOption == "New Scheme") {
                                            await getSwitchToSchemes();
                                          } else if (selectedOption == "Existing Scheme") {
                                            await getBSESwitchExistingSchemes();
                                          }
                                          
                                          isLoading = false;
                                          bottomState(() {});
                                          setState(() {}); // Update main UI
                                          Get.back();
                                        }
                                      ),
                                      Expanded(
                                        child: Text(name, style: AppFonts.f50014Grey)
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    )
                  )
                ),
              ]
            ),
          );
        });
      }
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
                      value: widget.amcName,
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
                            switchSchemeList = [];
                            await getSwitchToSchemes();
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
                            switchSchemeList = [];
                            bottomState(() {});
                            EasyLoading.show();
                            await getSwitchToSchemes();
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
                                    switchSchemeList = [];
                                    bottomState(() {});
                                    EasyLoading.show();
                                    await getSwitchToSchemes();
                                    EasyLoading.dismiss();

                                    Get.back();
                                    setState(() {});
                                  }),
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
}

class bseswitchresponse {
  int? status;
  String? statusMsg;
  String? msg;
  Null? result;
  List<String>? schemeList;

  bseswitchresponse(
      {this.status, this.statusMsg, this.msg, this.result, this.schemeList});

  bseswitchresponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    result = json['result'];
    schemeList = json['scheme_list'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_msg'] = this.statusMsg;
    data['msg'] = this.msg;
    data['result'] = this.result;
    data['scheme_list'] = this.schemeList;
    return data;
  }
}
