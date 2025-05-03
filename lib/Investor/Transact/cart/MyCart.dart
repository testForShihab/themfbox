import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/LumpsumCart.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/StpCart.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/SwpCart.dart';
import 'package:mymfbox2_0/Investor/transact/cart/RedemptionCart.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/SipCart.dart';
import 'package:mymfbox2_0/Investor/transact/cart/SwitchCart.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/pojo/NewCartPojo.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../../api/InvestorApi.dart';
import '../../../pojo/OnlineTransactionRestrictionPojo.dart';

class MyCart extends StatefulWidget {
  const MyCart(
      {super.key, this.defaultTitle = "Lumpsum", required this.defaultPage});

  final String defaultTitle;
  final Widget defaultPage;

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  int user_id = GetStorage().read("user_id") ?? 0;
  String client_name = GetStorage().read("client_name");
  GetCartByUserIdPojo cart = GetCartByUserIdPojo();

  List pages = [];

  String selectedTitle = "Lumpsum";
  Map result = {};
  Iterable keys = GetStorage().getKeys();

  Future getCartCount({bool updateUi = false}) async {
    Map data =
        await Api.getCartCounts(user_id: user_id, client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    result = data['result'];
    cartCount.value = result['total_count'];
    if ((keys.contains("adminAsInvestor")) ||
        (keys.contains("adminAsFamily")) != true)
      await getAllOnlineRestrictions();
    generatePageList();
    if (updateUi && mounted) setState(() {});
    return 0;
  }

  Widget displayPage = LumpsumCart();

  List investorList = [];
  late Map<String, dynamic> datas;
  OnlineTransactionRestrictionPojo userData =
      OnlineTransactionRestrictionPojo();

  Future getAllOnlineRestrictions() async {
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
  void initState() {
    //  implement initState
    super.initState();
    selectedTitle = widget.defaultTitle;
    displayPage = widget.defaultPage;
  }

  @override
  void dispose() {
    //  implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCartCount(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Config.appTheme.themeColor,
              toolbarHeight: 120,
              leading: SizedBox(),
              foregroundColor: Colors.white,
              leadingWidth: 0,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () => Get.back(),
                          child: Row(
                            children: [
                              Icon(Icons.arrow_back),
                              SizedBox(width: 10),
                              Text("My cart"),
                            ],
                          )),
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 45,
                    child: ListView.builder(
                      itemCount: pages.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        Map cart = pages[index];
                        String title = cart['title'];

                        if (title == selectedTitle)
                          return rpSelectedCard(cart);
                        else
                          return rpCard(cart);
                      },
                    ),
                  )
                ],
              ),
            ),
            body: SideBar(
              child: displayPage,
            ),
          );
        });
  }

  Widget rpCard(Map cart) {
    String title = cart['title'];
    int count = cart['count'] ?? 0;
    Widget display = cart['display'];

    return GestureDetector(
      onTap: () {
        selectedTitle = title;
        displayPage = display;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white)),
        child: Text("$title ($count)",
            style: AppFonts.f50014Black.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget rpSelectedCard(Map cart) {
    String title = cart['title'];
    int count = cart['count'] ?? 0;

    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Config.appTheme.overlay85,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text("$title ($count)", style: AppFonts.f50014Theme),
    );
  }

  generatePageList() {
    pages = [
      if (userData.purchaseAllowed == 1 ||
          (keys.contains("adminAsInvestor")) ||
          (keys.contains("adminAsFamily")) != false)
        {
          'title': "Lumpsum",
          'count': result['lumpsum_count'],
          'display': LumpsumCart()
        },
      if (userData.purchaseAllowed == 1 ||
          (keys.contains("adminAsInvestor")) ||
          (keys.contains("adminAsFamily")) != false)
        {'title': "SIP", 'count': result['sip_count'], 'display': SipCart()},
      if (userData.redeemAllowed == 1 ||
          (keys.contains("adminAsInvestor")) ||
          (keys.contains("adminAsFamily")) != false)
        {
          'title': "Redemption",
          'count': result['redeem_count'],
          'display': RedemptionCart()
        },
      if (userData.switchAllowed == 1 ||
          (keys.contains("adminAsInvestor")) ||
          (keys.contains("adminAsFamily")) != false)
        {
          'title': "Switch",
          'count': result['switch_count'],
          'display': SwitchCart()
        },
      if (userData.stpAllowed == 1 ||
          (keys.contains("adminAsInvestor")) ||
          (keys.contains("adminAsFamily")) != false)
        {'title': "STP", 'count': result['stp_count'], 'display': StpCart()},
      if (userData.swpAllowed == 1 ||
          (keys.contains("adminAsInvestor")) ||
          (keys.contains("adminAsFamily")) != false)
        {'title': "SWP", 'count': result['swp_count'], 'display': SwpCart()},
    ];
  }
}

class DeleteAllCart extends StatefulWidget {
  const DeleteAllCart({
    Key? key,
    required this.carttype,
    this.onDelete,
    this.bsensemfu,
  }) : super(key: key);

  final String carttype;
  final String? bsensemfu;
  final VoidCallback? onDelete;

  @override
  State<DeleteAllCart> createState() => _DeleteAllCartState();
}

class _DeleteAllCartState extends State<DeleteAllCart> {
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  GetCartByUserIdPojo cart = GetCartByUserIdPojo();
  String cart_type = "";
  String bsensemfu = "";
  String bsensemfu_flag = "";
  Map client_code_map = GetStorage().read("client_code_map") ?? {};

  @override
  void initState() {
    super.initState();
    cart_type = widget.carttype;
    bsensemfu = widget.bsensemfu!;
    bsensemfu_flag =
        (bsensemfu.isEmpty) ? client_code_map['bse_nse_mfu_flag'] : bsensemfu;
  }

  Future getCartByUserId() async {
    Map<String, dynamic> data = await InvestorApi.getCartByUserId(
      user_id: user_id,
      investor_id: user_id,
      client_name: client_name,
      purchase_type: cart_type,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    cart = GetCartByUserIdPojo.fromJson(data);
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Delete"),
              content: Text("Are you sure to delete All Schemes?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Cancel')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Config.appTheme.themeColor,
                        foregroundColor: Colors.white),
                    onPressed: () async {
                      EasyLoading.show();
                      Map data = await InvestorApi.deleteAllCart(
                          bse_nse_mfu_flag: bsensemfu_flag,
                          user_id: user_id,
                          client_name: client_name,
                          context: context,
                          cart_type: cart_type);
                      if (data['status'] != 200) {
                        Utils.showError(context, data['msg']);
                        return;
                      }
                      Get.back();
                      EasyLoading.showToast(data['msg'],
                          toastPosition: EasyLoadingToastPosition.bottom);

                      cart.msg = null;
                      if (widget.onDelete != null) {
                        widget.onDelete!();
                      }
                    },
                    child: Text('Delete'))
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 8, 15, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Empty Cart",
                style: AppFonts.f50012
                    .copyWith(fontSize: 16, color: Config.appTheme.themeColor)),
            SizedBox(width: 4),
            Icon(Icons.delete_forever, size: 20)
          ],
        ),
      ),
    );
  }
}
