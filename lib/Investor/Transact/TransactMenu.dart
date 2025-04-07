import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/Investor/Transact/lumpsum/NfoLumpsum.dart';
import 'package:mymfbox2_0/Investor/Transact/sip/NfoSip.dart';
import 'package:mymfbox2_0/Investor/manageSysTransaction/manageSysTrnx.dart';
import 'package:mymfbox2_0/Investor/transact/ExistingTransaction.dart';
import 'package:mymfbox2_0/Investor/transact/MyOrders.dart';
import 'package:mymfbox2_0/Investor/transact/lumpsum/NewLumpsumTransaction.dart';
import 'package:mymfbox2_0/Investor/transact/sip/NewSipTransaction.dart';
import 'package:mymfbox2_0/api/ReportApi.dart';
import 'package:mymfbox2_0/login/CheckAuth.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile1.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../api/InvestorApi.dart';
import '../../pojo/OnlineTransactionRestrictionPojo.dart';
import '../Registration/ChoosePlatform.dart';
import '../nseBank/BanksandMandates.dart';

class TransactMenu extends StatefulWidget {
  const TransactMenu({Key? key}) : super(key: key);

  @override
  State<TransactMenu> createState() => _TransactMenuState();
}

class _TransactMenuState extends State<TransactMenu> {
  int user_id = GetStorage().read('user_id');

  String client_name = GetStorage().read("client_name");
  String mfd_name = GetStorage().read("mfd_name") ?? "null";
  String str_name = "";

  List listData = [
    {
      'title': "Lumpsum in New Scheme",
      'img': "assets/lumpsumMenu.png",
      'goTo': NewLumpsumTransaction(),
      'getClientCode': true,
    },
    {
      'title': "Start SIP in New Scheme",
      'img': "assets/startSIPMenu.png",
      'goTo': NewSipTransaction(),
      'getClientCode': true,
    },
    {
      'title': "Invest in NFO Lumpsum",
      'img': "assets/nfoMenu.png",
      'goTo': NfoLumpsum(),
      'getClientCode': true,
    },
    {
      'title': "Invest in NFO SIP",
      'img': "assets/nfoSIPMenu.png",
      'goTo': NfoSip(),
      'getClientCode': true,
    },
    /*{
      'title': "Cancel SIP / STP / SWP",
      'img': "assets/manageSysTrn.png",
      'goTo': ManageSysTrnx(),
      'getClientCode': true,
    },*/
    {
      'title': "Banks & Mandates",
      'img': "assets/manageBank.png",
      'goTo': BanksandMandates(),
      'getClientCode': true,
    },
    /*{
      'title': "Update Investment Profile",
      'img': "assets/manage_accounts.png",
      'goTo': UpdateProfile(),
      'getClientCode': false,
    },*/
  ];

  @override
  void initState() {
    //  implement initState
    super.initState();
    str_name = mfd_name;
    loadAppVersion();
  }

  String appVersion = "Loading ...";

  Future<void> loadAppVersion() async {
    final versions = await PackageInfo.fromPlatform();

    setState(() {
      appVersion = "${versions.buildNumber}+${versions.version}";
      print("App version $appVersion");
    });
  }

  String getFirst13(String text) {
    if (str_name.length > 13) str_name = str_name.substring(0, 13) + "...";
    return str_name;
  }

  bool isLoading = true;
  List clientCodeList = [];

  Future getInvestorClientCode() async {
    if (clientCodeList.isNotEmpty) return 0;

    Map data = await ReportApi.getInvestorCode(
        user_id: user_id, client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    clientCodeList = data['client_code_list'];
    if ((keys.contains("adminAsInvestor")) ||
        (keys.contains("adminAsFamily")) != true)
      await getAllOnlineRestrictions();
    return 0;
  }

  late double devHeight, devWidth;

  List investorList = [];
  late Map<String, dynamic> datas;
  OnlineTransactionRestrictionPojo userData =
  OnlineTransactionRestrictionPojo();
  Iterable keys = GetStorage().getKeys();
  Future getAllOnlineRestrictions() async {
    if (userData.branch != null) return 0;
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
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: getInvestorClientCode(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            body: SideBar(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            greenCard(
                                img: "assets/myOrders.png",
                                showArnFilter: true,
                                title: "My Orders",
                                goTo: MyOrders()),
                            SizedBox(height: 16),
                            greenCard(
                                img: "assets/existing_trnx.png",
                                showArnFilter: true,
                                title: "Transact in Existing Folios",
                                goTo: ExistingTransaction()),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                      if (userData.purchaseAllowed == 1 ||
                          ((keys.contains("adminAsInvestor")) ||
                              (keys.contains("adminAsFamily")) != false))
                        Text(
                          "Transact in New Schemes",
                          style: AppFonts.f40016,
                          textAlign: TextAlign.start,
                        ),
                      SizedBox(height: 16),
                      if (userData.purchaseAllowed == 1 ||
                          ((keys.contains("adminAsInvestor")) ||
                              (keys.contains("adminAsFamily")) != false))
                        listContainer(listData.getRange(0, 2).toList()),
                      SizedBox(height: 16),
                      if (userData.purchaseAllowed == 1 ||
                          ((keys.contains("adminAsInvestor")) ||
                              (keys.contains("adminAsFamily")) != false))
                        Text(
                          "Transact in NFOs",
                          style: AppFonts.f40016,
                          textAlign: TextAlign.start,
                        ),
                      SizedBox(height: 16),
                      if (userData.purchaseAllowed == 1 ||
                          ((keys.contains("adminAsInvestor")) ||
                              (keys.contains("adminAsFamily")) != false))
                        listContainer(listData.getRange(2, 4).toList()),

                      if((client_name != 'marinawealth') && (userData.purchaseAllowed == 1 || userData.stpAllowed == 1 || userData.swpAllowed == 1 ||
                          ((keys.contains("adminAsInvestor")) || (keys.contains("adminAsFamily")) != false))) ...[
                        SizedBox(height: 16),
                        Text("Others", style: AppFonts.f40016, textAlign: TextAlign.start),
                        SizedBox(height: 16),
                        // if (userData.purchaseAllowed == 1 || userData.stpAllowed == 1 || userData.swpAllowed == 1 ||
                        //     ((keys.contains("adminAsInvestor")) || (keys.contains("adminAsFamily")) != false))
                        listContainer(listData.getRange(4, 5).toList()),

                        // listContainer(listData.getRange(5, 6).toList()),
                      ],

                      if((client_name == 'marinawealth') && ((keys.contains("adminAsInvestor")) ||(keys.contains("adminAsFamily")) )) ...[
                        SizedBox(height: 16),
                        Text("Others", style: AppFonts.f40016, textAlign: TextAlign.start),
                        SizedBox(height: 16),
                        listContainer(listData.getRange(4, 5).toList()),
                        // listContainer(listData.getRange(5, 6).toList()),
                      ],

                      SizedBox(height: 16),
                      Center(
                        child: Column(
                          children: [
                            TextButton(
                                onPressed: () {
                                  GetStorage().erase();
                                  Get.offAll(CheckAuth());
                                },
                                child: Text('Log out',
                                    style: TextStyle(
                                        color: Config.appTheme.themeColor, fontSize: 18,fontWeight: FontWeight.bold))),
                            Text(
                              "V $appVersion",
                              style: TextStyle(
                                  color: Color(0xff959595), fontSize: 12),
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget greenCard(
      {required String img,
        required String title,
        Widget? goTo,
        bool showArnFilter = false}) {
    return InkWell(
      onTap: () {
        if (showArnFilter)
          clientCodeBottomSheet(goTo);
        else if (goTo != null) Get.to(goTo);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Config.appTheme.themeColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(img, height: 28, color: Colors.white),
            SizedBox(width: 10),
            Text(title,
                style: AppFonts.f40016
                    .copyWith(color: Colors.white, fontSize: 17)),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  bool isOpen = false;

  Widget listContainer(List list) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        separatorBuilder: (context, index) {
          return DottedLine();
        },
        itemBuilder: (context, index) {
          Map map = list[index];

          String leading = map['img'];
          Widget? goTo = map['goTo'];
          String title = map['title'];
          bool getClientCode = map['getClientCode'];

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () {
                if (getClientCode)
                  clientCodeBottomSheet(goTo);
                else {
                  if (goTo != null) Get.to(goTo);
                }
              },
              child: RpListTile1(
                leading: Image.asset(leading,
                    height: 32, color: Config.appTheme.themeColor),
                title: SizedBox(
                  width: 220,
                  child: Text(title,
                      style: AppFonts.f50014Black
                          .copyWith(color: Config.appTheme.themeColor)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void clientCodeBottomSheet(Widget? goTo) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: cornerBorder),
      backgroundColor: Config.appTheme.mainBgColor,
      builder: (BuildContext context) {
        return Column(
          children: [
            BottomSheetTitle(
              title: "Select Investor Code",
            ),
            SizedBox(height: 16),
            /*clientCodeList.isEmpty
                ? Center(
                    child: Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "You can't able to do the transaction, please open mutual fund account.",
                            style: AppFonts.f40013,
                          ),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () async {
                              Get.to(() => ChoosePlatform());
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: Config.appTheme.themeColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 38)),
                            child: Text(
                              "Open Now",
                              style: cardHeadingSmall.copyWith(
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                :*/ Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: clientCodeList.length,
                itemBuilder: (BuildContext context, int index) {
                  Map data = clientCodeList[index];

                  String logo = data['logo'];
                  String holdingNature = data['holding_nature'];
                  String arn = data['broker_code'];
                  String investorCode = data['investor_code'];
                  String taxStatus = data['tax_status'];
                  String? inv_name = data['inv_name'];

                  return Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: ListTile(
                      onTap: () async {
                        /*if (arn.isEmpty) {
                                Utils.showError(context,
                                    "ARN not found. Please contact your advisor");
                                return;
                              }*/
                        await GetStorage().write('client_code_map', data);
                        await GetStorage().write('investor_code', investorCode);
                        Get.back();
                        if (goTo != null) Get.to(goTo);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      tileColor: Colors.white,
                      leading: Image.network(logo, height: 32),
                      title: Text(
                        "$inv_name",
                        style: AppFonts.f50014Black,
                      ),
                      subtitle: Text(
                          "$investorCode-$holdingNature-$taxStatus-$arn",
                          style: AppFonts.f50012),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color:
                        Config.appTheme.placeHolderInputTitleAndArrow,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
