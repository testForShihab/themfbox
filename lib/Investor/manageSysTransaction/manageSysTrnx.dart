import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/manageSysTransaction/SipSysTrnx.dart';
import 'package:mymfbox2_0/Investor/manageSysTransaction/StpSysTrnx.dart';
import 'package:mymfbox2_0/Investor/manageSysTransaction/SwpSysTrnx.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/pojo/NewCartPojo.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import '../../pojo/OnlineTransactionRestrictionPojo.dart';
import '../../utils/AppFonts.dart';
import '../../utils/Utils.dart';

class ManageSysTrnx extends StatefulWidget {
  const ManageSysTrnx({super.key});

  @override
  State<ManageSysTrnx> createState() => _ManageSysTrnxState();
}

class _ManageSysTrnxState extends State<ManageSysTrnx> {
  int user_id = GetStorage().read('user_id');
  String client_name = GetStorage().read('client_name');
  Map client_code_map = GetStorage().read('client_code_map');

  int? type_id = GetStorage().read('type_id');

  List typeList = [];
  String selectedType = "SIP";

  bool isPageLoad = true;
  GetCartByUserIdPojo cartByUserIdPojo = GetCartByUserIdPojo();

  Future getCartByUserId() async {
    if (cartByUserIdPojo.msg != null) return 0;

    Map<String, dynamic> data = await InvestorApi.getCartByUserId(
        user_id: user_id,
        investor_id: user_id,
        client_name: client_name,
        purchase_type: 'SIP Purchase');
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    cartByUserIdPojo = GetCartByUserIdPojo.fromJson(data);
  }

  Future getSipStpSwpCancelSchemes() async {
    Map data = await TransactionApi.getSipStpSwpCancelSchemes(
        client_name: client_name,
        user_id: user_id,
        bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
        sys_option: selectedType);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    return 0;
  }

  OnlineTransactionRestrictionPojo userData = OnlineTransactionRestrictionPojo();
  List investorList = [];
  late Map<String, dynamic> datas;
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

  Future getDatas() async {
    isPageLoad = true;
    await getCartByUserId();
    await getSipStpSwpCancelSchemes();
    isPageLoad = false;
  }

  late double devWidth, devHeight;
  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.sizeOf(context).width;
    devHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: invAppBar(
          title: "Cancel SIP / STP / SWP",
          showCartIcon: false,
          showNotiIcon: false),
      body: SideBar(
        child: Column(
          children: [
            topArea(),
            if (selectedType == "SIP") SipSysTrnx(),
            if (selectedType == "STP") StpSysTrnx(),
            if (selectedType == "SWP") SwpSysTrnx(),
          ],
        ),
      ),
    );
  }

  Widget topArea() {
    return FutureBuilder(
      future: getAllOnlineRestrictions(),
      builder: (context, snapshot) {
          print('type_id: $type_id');
          print('purchaseAllowed: ${userData.purchaseAllowed}');
          print('stpAllowed: ${userData.stpAllowed}');
          print('swpAllowed: ${userData.swpAllowed}');
          typeList.clear();
          if (type_id == UserType.INVESTOR || type_id == UserType.FAMILY) {
            if (userData.purchaseAllowed == 1) {
              typeList.add('SIP');
            }if (userData.stpAllowed == 1) {
              typeList.add('STP');
            }if (userData.swpAllowed == 1) {
              typeList.add('SWP');
            }
          } else {
            typeList = ["SIP", "STP", "SWP"];
          }

          return Container(
            color: Config.appTheme.themeColor,
            padding: EdgeInsets.only(left: 16, bottom: 16),
            child: Row(
              children: List.generate(
                typeList.length,
                    (index) => Expanded(
                  child: rpButon(
                    title: typeList[index],
                    isSelected: selectedType == typeList[index],
                  ),
                ),
              ),
            ),
          );
      },
    );
  }


  Widget rpButon({required String title, required bool isSelected}) {
    Color fgColor =
        (isSelected) ? Config.appTheme.themeColor : Config.appTheme.overlay85;
    Color bgColor =
        (isSelected) ? Config.appTheme.overlay85 : Config.appTheme.themeColor;

    return GestureDetector(
      onTap: () {
        selectedType = title;
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: bgColor,
            border: Border.all(color: Config.appTheme.overlay85)),
        child: Center(
            child: Text(
          title,
          style: AppFonts.f50014Black.copyWith(color: fgColor),
        )),
      ),
    );
  }

  cancelAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Cancel SIP?"),
            content: Text(
                'Cancelling will stop all your upcoming investments in this SIP. Proceed to cancel.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'No',
                    style: TextStyle(color: Config.appTheme.themeColor),
                  )),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  "YES,CANCEL",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
  }

  Widget nothingCard() {
    String typeCode;

    if (selectedType == "SIP") {
      typeCode = 'assets/sipFund.png';
    } else if (selectedType == "STP") {
      typeCode = "assets/stp_cancellation.png";
    } else {
      typeCode = "assets/swp_cancellation.png";
    }
    return Container(
      width: devWidth,
      margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Image.asset(typeCode, color: Colors.grey[400], height: 50),
          SizedBox(height: 16),
          Text("You Currently have No $selectedType.",
              textAlign: TextAlign.center, style: AppFonts.f40013)
        ],
      ),
    );
  }
}
