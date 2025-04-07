import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/lumpsum/LumpsumAmountInput.dart';
import 'package:mymfbox2_0/Investor/Transact/redemption/RedemptionAmountInput.dart';
import 'package:mymfbox2_0/Investor/Transact/sip/BseSipAmountInput.dart';
import 'package:mymfbox2_0/Investor/Transact/sip/SipAmountInput.dart';
import 'package:mymfbox2_0/Investor/Transact/stp/NewStpTransaction.dart';
import 'package:mymfbox2_0/Investor/Transact/switch/NewSwitchTransaction.dart';
import 'package:mymfbox2_0/Investor/Transact/swp/BseSwpAmountInput.dart';
import 'package:mymfbox2_0/Investor/Transact/swp/SwpAmountInput.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/pojo/MfSchemeSummaryPojo.dart';
import 'package:mymfbox2_0/pojo/transaction/MyLumpsumFundsPojo.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/NoData.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/RpSmallTf.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';

import '../../pojo/OnlineTransactionRestrictionPojo.dart';
import '../../rp_widgets/RpPurchaseListTile.dart';
import '../../utils/AppFonts.dart';
import '../../utils/Utils.dart';

class ExistingTransaction extends StatefulWidget {

  const ExistingTransaction({super.key,
    this.cameFrom = "",
    this.bse_nse_mfu_flag = "",
    this.investor_code = "",
    this.tax_status_code = "",
    this.holding_nature_code = "",
    this.broker_code = "",

    });
  final String cameFrom;
  final String bse_nse_mfu_flag;
  final String investor_code;
  final String tax_status_code;
  final String holding_nature_code;
  final String broker_code;

  @override
  State<ExistingTransaction> createState() => _ExistingTransactionState();
}

class _ExistingTransactionState extends State<ExistingTransaction> {
  late double devWidth, devHeight;
  int user_id = GetStorage().read("user_id") ?? 0;
  String client_name = GetStorage().read("client_name");
  Map client_code_map = GetStorage().read("client_code_map");
  int type_id = 0;

  String selectedAMC = "All";
  String selectedCategory = "All";
  //String selectedSubCategory = "Equity: Large Cap";

  List amcList = [];
  String selectedAmc = "";
  List categoryList = [];
  List performanceList = [];
  bool isLoading = true;
  MfSchemeSummaryPojo selectedScheme = MfSchemeSummaryPojo();
  MyLumpsumFundsPojo passingPojo = MyLumpsumFundsPojo();

  List bottomSheetData = [
    {"title": "Purchase", "img": "assets/lumpsumMenu.png"},
    {"title": "Start SIP", "img": "assets/startSIPMenu.png"},
    {
      "title": "Redemption",
      "img": "assets/redemption.png",
      "goTo": RedemptionAmountInput(
          currValue: 0,
          units: 0,
          schemeAmfiShortName: "",
          schemeAmfi: "",
          logo: "",
          folio: "")
    },
    {
      "title": "Switch NFO / Switch",
      "img": "assets/switchNFo.png",
      "goTo": null
    },
    {"title": "Start STP", "img": "assets/startSTP.png", "goTo": null},
    {"title": "Start SWP", "img": "assets/startSWP.png", "goTo": null},
  ];

  List<MfSchemeSummaryPojo> schemeList = [];
  /*Future getMutualFundPortfolio() async {
    if (schemeList.isNotEmpty) return 0;
    print("Broker Code ----> ${client_code_map['broker_code']}");
    Map data = await InvestorApi.getMutualFundPortfolio(
      user_id: user_id,
      client_name: client_name,
      folio_type: "",
      selected_date: DateTime.now(),
      broker_code: "",
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    List list = data['mf_scheme_summary'];
    convertListToObj(list);
    return 0;
  }*/

  Future getExistingSchemes() async {
    if (schemeList.isNotEmpty) return 0;
    print("status investor_code ${widget.investor_code}");

    Map data = await InvestorApi.getExistingSchemes(
        user_id: user_id,
        client_name: client_name,
        bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
        investor_code: client_code_map['investor_code'],
        tax_status_code: client_code_map['tax_status_code'],
        holding_nature_code: client_code_map['holding_nature_code'],
        broker_code: client_code_map['broker_code']);

    if (data['status'] != 200) {
      Utils.showError(context, data["msg"]);
      return 0;
    }
    List list = data['list'];
    convertListToObj(list);
    return 0;
  }

  convertListToObj(List list) {
    list.forEach((element) {
      schemeList.add(MfSchemeSummaryPojo.fromJson(element));
    });
  }

  Iterable keys = GetStorage().getKeys();
  Future getDatas() async {
    isLoading = true;
    EasyLoading.show();
    await getExistingSchemes();
    if ((keys.contains("adminAsInvestor")) ||
        (keys.contains("adminAsFamily")) != true)
      await getAllOnlineRestrictions();
    EasyLoading.dismiss();
    isLoading = false;
    return 0;
  }

  List investorList = [];
  late Map<String, dynamic> datas;
  OnlineTransactionRestrictionPojo userData =
      OnlineTransactionRestrictionPojo();

  Future getAllOnlineRestrictions() async {
    isLoading = true;
    EasyLoading.show();
    Map data = await InvestorApi.getOnlineRestrictionsByUserId(
      user_id: user_id,
      client_name: client_name,
    );

    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      return 0;
    }
    investorList = data['list'];
    datas = investorList[0];
    userData = OnlineTransactionRestrictionPojo.fromJson(datas);
    isLoading = false;
    EasyLoading.dismiss();
    return 0;
  }

  String getFirst13(String text) {
    String s = text;
    if (s.length > 13) s = s.substring(0, 13);
    return s;
  }

  @override
  void initState() {
    //  implement initState
    super.initState();
    type_id = GetStorage().read("type_id") ?? 0;
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
            title: "Transact In Existing Folios",
          ),
          body: SideBar(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topFilterArea(),
                (!isLoading && schemeList.isEmpty)
                    ? noSchemes()
                    : Expanded(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 16),
                          color: Config.appTheme.mainBgColor,
                          child: ListView.builder(
                              itemCount: isLoading ? 5 : (schemeList.length),
                              itemBuilder: (context, index) {
                                if (isLoading)
                                  return Utils.shimmerWidget(100,
                                      margin: EdgeInsets.all(16));
                                return fundCard(schemeList[index]);
                              }),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget noSchemes() {
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
  }

  String searchKey = "";
  Widget topFilterArea() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SizedBox(
        height: 50,
        child: RpSmallTf(
          hintText: "Search",
          contentPadding: EdgeInsets.fromLTRB(10, 6, 12, 6),
          onChange: (val) {
            searchKey = val;
            setState(() {});
          },
          filled: true,
          fillColor: Colors.white,
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

  Widget fundCard(MfSchemeSummaryPojo scheme) {
    String shortName = "${scheme.schemeAmfi}";

    return Visibility(
      visible: searchFilter(shortName),
      child: InkWell(
        onTap: () {
          selectedScheme = scheme;
          if (widget.cameFrom.isEmpty) transactBottomSheet();
          if (widget.cameFrom == "Lumpsum") goToLumpsum();
          if(client_code_map['bse_nse_mfu_flag'] == "BSE" && widget.cameFrom == "SIP") goToBseSip();
          if(client_code_map['bse_nse_mfu_flag'] != "BSE" && widget.cameFrom == "SIP") goToSip();

        },
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //1st row
              RpPurchaseListTile(
                leading: Image.network(
                  scheme.schemeAmcLogo ?? "",
                  height: 32,
                  errorBuilder: (context, error, stackTrace) => Text("null"),
                ),
                l1: "${scheme.schemeAmfi}",
                l2: "Folio: ${scheme.folio?.replaceAll(":", " •")}",
              ),

              SizedBox(height: 10),
              Text(
                  "Current Value : $rupee ${Utils.formatNumber(scheme.currValue)}",
                  style: AppFonts.f50012.copyWith(color: Colors.black)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      child: Text("Transact Now",
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

  transactBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: cornerBorder),
      builder: (context) {
        return Container(
          height: 540,
          decoration: BoxDecoration(
              borderRadius: cornerBorder, color: Config.appTheme.mainBgColor),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: cornerBorder, color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("New Transaction",
                        style: AppFonts.f40016
                            .copyWith(fontWeight: FontWeight.w500)),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.close),
                    )
                  ],
                ),
              ),
              Divider(height: 1),
              SizedBox(height: 16),
              if (userData.purchaseAllowed == 1 ||
                  ((keys.contains("adminAsInvestor")) ||
                      (keys.contains("adminAsFamily")) != false))
                listContainer(bottomSheetData.getRange(0, 2).toList()),
              SizedBox(height: 16),
              if (userData.redeemAllowed == 1 ||
                  ((keys.contains("adminAsInvestor")) ||
                      (keys.contains("adminAsFamily")) != false))
                listContainer(bottomSheetData.getRange(2, 3).toList()),
              SizedBox(height: 8),
             if (userData.switchAllowed == 1 ||
                  ((keys.contains("adminAsInvestor")) ||
                      (keys.contains("adminAsFamily")) != false))
                listContainer(bottomSheetData.getRange(3, 4).toList()),
              SizedBox(height: 8),
              /*if (userData.stpAllowed == 1 ||
                  ((keys.contains("adminAsInvestor")) ||
                      (keys.contains("adminAsFamily")) != false))
                listContainer(bottomSheetData.getRange(4, 5).toList()),
              SizedBox(height: 8),
              if (userData.swpAllowed == 1 ||
                  ((keys.contains("adminAsInvestor")) ||
                      (keys.contains("adminAsFamily")) != false))
                listContainer(bottomSheetData.getRange(5, 6).toList()),
              SizedBox(height: 8),*/
            ],
          ),
        );
      },
    );
  }

  goToLumpsum() {
    Get.to(() => LumpsumAmountInput(
          trnx_type: "AP",
          schemeAmfi: "${selectedScheme.schemeAmfi}",
          folio: "${selectedScheme.folio}",
          schemeAmfiShortName: "${selectedScheme.schemeAmfiShortName}",
          logo: "${selectedScheme.schemeAmcLogo}",
          amc: "${selectedScheme.schemeAmc}",
          arn: "${selectedScheme.brokerCode}",
        ));
  }

  goToSip() {
    Get.to(() => SipAmountInput(
          trnx_type: "AP",
          logo: "${selectedScheme.schemeAmcLogo}",
          shortName: "${selectedScheme.schemeAmfiShortName}",
          schemeAmfi: "${selectedScheme.schemeAmfi}",
          folio: "${selectedScheme.folio}",
          amc: "${selectedScheme.schemeAmc}",
        ));
  }

  goToBseSip(){
    Get.to(() => BseSipAmountInput(
      trnx_type: "AP",
      logo: "${selectedScheme.schemeAmcLogo}",
      shortName: "${selectedScheme.schemeAmfiShortName}",
      schemeAmfi: "${selectedScheme.schemeAmfi}",
      folio: "${selectedScheme.folio}",
      amc: "${selectedScheme.schemeAmc}",));
  }

  goToRedemption() {
    print("selectedScheme.currCost ---> ${selectedScheme.currCost}");
    Get.to(() => RedemptionAmountInput(
          logo: "${selectedScheme.schemeAmcLogo}",
          currValue: selectedScheme.currValue ?? 0,
          units: selectedScheme.units ?? 0,
          schemeAmfiShortName: '${selectedScheme.schemeAmfiShortName}',
          schemeAmfi: '${selectedScheme.schemeAmfi}',
          folio: "${selectedScheme.folio}",
        ));
  }

  goToSwitch() {
    Get.to(() => NewSwitchTransaction(
          amcName: '${selectedScheme.schemeAmc}',
          schemeAmcCode: '${selectedScheme.schemeAmcCode}',
          currValue: selectedScheme.currValue ?? 0,
          units: selectedScheme.units ?? 0,
          schemeAmfi: "${selectedScheme.schemeAmfi}",
          folio: "${selectedScheme.folio}",
          schemeAmfiShortName: "${selectedScheme.schemeAmfiShortName}",
        ));
  }

  goToStp() {
    Get.to(() => NewStpTransaction(

          amcName: '${selectedScheme.schemeAmc}',
          amcCode: '${selectedScheme.schemeAmcCode}',
          currValue: selectedScheme.currValue ?? 0,
          units: selectedScheme.units ?? 0,
          schemeAmfi: "${selectedScheme.schemeAmfi}",
          folio: "${selectedScheme.folio}",
          schemeAmfiShortName: "${selectedScheme.schemeAmfiShortName}",
        ));
  }

  goToSwp() {
    if (client_code_map['bse_nse_mfu_flag'].toUpperCase() == "BSE") {
      Get.to(() => BseSwpAmountInput(
            logo: "${selectedScheme.schemeAmcLogo}",
            currValue: selectedScheme.currValue ?? 0,
            units: selectedScheme.units ?? 0,
            schemeAmfiShortName: '${selectedScheme.schemeAmfiShortName}',
            schemeAmfi: '${selectedScheme.schemeAmfi}',
            folio: "${selectedScheme.folio}",
            amcName: '${selectedScheme.schemeAmc}',
            amcCode: '${selectedScheme.schemeAmcCode}',
          ));
    } else {
      Get.to(() => SwpAmountInput(
            logo: "${selectedScheme.schemeAmcLogo}",
            currValue: selectedScheme.currValue ?? 0,
            units: selectedScheme.units ?? 0,
            schemeAmfiShortName: '${selectedScheme.schemeAmfiShortName}',
            schemeAmfi: '${selectedScheme.schemeAmfi}',
            folio: "${selectedScheme.folio}",
            amcName: '${selectedScheme.schemeAmc}',
            amcCode: '${selectedScheme.schemeAmcCode}',
          ));
    }
  }

  Widget listContainer(List list) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          Map data = list[index];
          String title = data['title'];
          String img = data['img'];

          return InkWell(
            onTap: () {
              Get.back();
              if (title == 'Purchase') goToLumpsum();
              if(client_code_map['bse_nse_mfu_flag'] == "BSE" &&  title == 'Start SIP') goToBseSip();
              if(client_code_map['bse_nse_mfu_flag'] != "BSE" && title == "Start SIP") goToSip();
              if (title == 'Redemption') goToRedemption();
              if (title.contains("Switch")) goToSwitch();
              if (title.contains("STP")) goToStp();
              if (title.contains("SWP")) goToSwp();
            },
            child: RpListTile(
              leading: Image.asset(img,
                  height: 34, color: Config.appTheme.themeColor),
              title: Text(title,
                  style: AppFonts.f50014Black.copyWith(
                      color: Config.appTheme.themeColor, fontSize: 18)),
              subTitle: SizedBox(),
              showArrow: false,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            DottedLine(verticalPadding: 8),
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
