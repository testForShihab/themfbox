import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/onBoarding/nse/NseOnBoardApi.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  late double devWidth, devHeight;

  int userId = GetStorage().read("user_id");
  String clientName = GetStorage().read("client_name");
  String marketType = GetStorage().read("marketType");
  Map client_code_map = GetStorage().read("client_code_map");
  String investor_code = GetStorage().read("investor_code") ?? '';

  List<dynamic> myOrdersData = [];
  bool isLoading = true;

  String userStr = "";

  @override
  void initState() {
    super.initState();
  }

  Future getMyOrders() async {
    if (myOrdersData.isNotEmpty) return 0;

    Map data;

    /* if (marketType == "nse") {*/
    data = await NseOnBoardApi.getMyOrders(
      user_id: userId,
      client_name: clientName,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      investor_code: investor_code,
    );
    /*} else if (marketType == "bse") {
      data = await NseOnBoardApi.getMyOrders(
        user_id: userId,
        client_name: clientName,
        investor_id: userId,
      );
    } else {
      data = await NseOnBoardApi.getMyOrdersTransaction(
        user_id: userId,
        client_name: clientName,
        investor_id: userId,
      );
    }*/
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return;
    }
    myOrdersData = data['list'];
    return 0;
  }

  Future getDatas() async {
    isLoading = true;
    await getMyOrders();
    isLoading = false;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return SideBar(
            child: Scaffold(
              backgroundColor: Config.appTheme.mainBgColor,
              appBar: invAppBar(title: "My Orders"),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (isLoading)
                        ? Utils.shimmerWidget(devHeight,
                            margin: EdgeInsets.all(16))
                        : myOrdersData.isEmpty
                            ? NoData()
                            : ListView.builder(
                                itemCount: myOrdersData.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  Map data = myOrdersData[index];

                                  return myOrdersTile(data);
                                },
                              ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget myOrdersTile(Map data) {
    String logo = data['logo'] ??"";
    String schemeName = data['scheme_name'] ??"";
    String amountUnits = data['amount_units'] ??"";
    String transactionType = data['transaction_type'] ??"";
    String transactionDate = data['transaction_date'] ??"";
    String folioNo = data['folio_no'] ?? "";
    String transactionStatus = data['transaction_status'] ?? "null";
    String platform = data['transaction_platform'] ?? "";
    String serviceMsg = data["service_msg"] ?? "";
    String uniqueNumber = data["unique_number"] ?? "";

    if (folioNo.isEmpty) {
      folioNo = "New Folio";
    } else {
      folioNo = "Folio: $folioNo";
    }
    num amtUnits;
    try {
      if (amountUnits.isNotEmpty) {
        amtUnits = num.parse(amountUnits);
      } else {
        amtUnits = 0;
      }
    } catch (e) {
      print("Error parsing amount units: $e");
      amtUnits = 0;
    }

    DateTime dateTime = DateTime.parse(transactionDate);
    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);

    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(logo,
                  height: 32,
                  errorBuilder: (context, error, stackTrace) => Text("No Img")),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center texts vertically
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text to the start
                  children: [
                    Text(
                      schemeName,
                      style: AppFonts.f50014Black,
                    ), // Add some space between texts
                    Text(
                      folioNo, // Your additional text here
                      style: AppFonts.f40013,
                    ),

                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$rupee ${Utils.formatNumber(amtUnits, isAmount: false)}",
                style: AppFonts.f50014Black,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lineColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    transactionType,
                    style:
                        AppFonts.f50012.copyWith(color: AppColors.readableGrey),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transaction Date: $formattedDate ',
                style: AppFonts.f40013.copyWith(fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pay Ref No / Unique No : $uniqueNumber',
                style: AppFonts.f40013.copyWith(fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  decoration: BoxDecoration(
                    color: getStatusColor(serviceMsg),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Order Status:",
                            style: AppFonts.f40013.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            serviceMsg,
                            style: AppFonts.f50012
                                .copyWith(color: getStatusTextColor(serviceMsg),fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  decoration: BoxDecoration(
                    color: getStatusColor(transactionStatus),
                    borderRadius: BorderRadius.circular(4),
                  ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Transaction Status:", // Your additional text here
                          style: AppFonts.f40013.copyWith(fontSize: 12),
                        ),

                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          transactionStatus, // Your additional text here
                          style: AppFonts.f50012
                              .copyWith(color: getStatusTextColor(transactionStatus),fontSize: 12),
                        ),

                      ],
                    ),
                  ],
                )
              )
            ],
          ),
        ],
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Success":
        return AppColors.lightGreen;
      case "Failure":
        return AppColors.lightRed;
      default:
        return AppColors.lightOrange;
    }
  }

  Color getStatusTextColor(String status) {
    switch (status) {
      case "Success":
        return AppColors.textGreen;
      case "Failure":
        return AppColors.lossRed;
      default:
        return AppColors.orage;
    }
  }

  String getFirst28(String text) {
    String s = text.split(":").first;
    if (s.length > 28) s = s.substring(0, 28);
    return s;
  }
}
