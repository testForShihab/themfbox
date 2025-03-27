import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/ExistingTransaction.dart';
import 'package:mymfbox2_0/Investor/Transact/TransactController.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/MyCart.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/Investor/Transact/swp/SwpPayment.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/pojo/CartPojo.dart';
import 'package:mymfbox2_0/pojo/NewCartPojo.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class SwpCart extends StatefulWidget {
  const SwpCart({super.key});

  @override
  State<SwpCart> createState() => _SwpCartState();
}

class _SwpCartState extends State<SwpCart> {
  String client_name = GetStorage().read("client_name");
  int user_id = GetStorage().read('user_id');

  num total = 0;
  late double devWidth, devHeight;
  List<CartPojo> cartItems = [];
  Map? client_code_map = GetStorage().read('client_code_map');
  GetCartByUserIdPojo cart = GetCartByUserIdPojo();

  ExpansionTileController folioController = ExpansionTileController();
  ExpansionTileController frequencyController = ExpansionTileController();
  ExpansionTileController swpDateController = ExpansionTileController();
  ExpansionTileController swpEndDateController = ExpansionTileController();
  String frequency = "";

  Future getCartByUserId() async {
    if (cart.msg != null) return 0;

    Map<String, dynamic> data = await InvestorApi.getCartByUserId(
      user_id: user_id,
      investor_id: user_id,
      client_name: client_name,
      purchase_type: PurchaseType.swp,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    cart = GetCartByUserIdPojo.fromJson(data);

    return 0;
  }

  num minAmount = 0;
  Future getStpMinAmount(SchemeList item) async {
    String folio = "${item.folioNo}";
    Map data = await TransactionApi.getStpMinAmount(
      user_id: user_id,
      client_name: client_name,
      scheme_name: "${item.schemeName}",
      purchase_type: (folio.contains("New")) ? "FP" : "AP",
      amount: "${item.amount}",
      dividend_code: "${item.toSchemeReinvestTag}",
      amc_code: "${item.schemeCompanyCode}",
    );
    if (data['status'] != SUCCESS) {
      minAmount = 0;
      return -1;
    }
    minAmount = data['min_amount'];
    return 0;
  }

  List dateAndFreq = [];
  List dateList = [];
  Future getSwpSchemeFrequency(SchemeList item) async {
    if (dateAndFreq.isNotEmpty) return 0;
    EasyLoading.show();
    Map data = await TransactionApi.getSwpSchemeFrequency(
      user_id: user_id,
      client_name: client_name,
      amc_name: "${item.schemeCompany}",
      scheme_name: "${item.schemeName}",
      bse_nse_mfu_flag: "${item.vendor}",
    );

    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    dateAndFreq = data['list'];
    Map temp = dateAndFreq.first;
    frequency = temp['sip_frequency'];
    frequencyCode = temp['sip_frequency_code'];
    dateList = temp['sip_dates'].split(",");
    EasyLoading.dismiss();
    return 0;
  }

  @override
  void initState() {
    //  implement initState
    super.initState();
  }

  TransactController transactController = Get.put(TransactController());

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;
    return FutureBuilder(
        future: getCartByUserId(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            // appBar: invAppBar(title: "Lumpsum Cart"),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  overallArea(),
                  SizedBox(height: 16),
                ],
              ),
            ),
          );
        });
  }

  Widget overallArea() {
    List? overallList = cart.result;
    if (overallList == null)
      return Utils.shimmerWidget(200, margin: EdgeInsets.all(16));
    if (overallList.isEmpty)
      return Center(
          child: Padding(
        padding: EdgeInsets.only(top: 16),
        child: EmptyCart(),
      ));

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: overallList.length,
      itemBuilder: (context, index) {
        Result result = overallList[index];
        List<SchemeList> schemeList = result.schemeList ?? [];
        String? bsensemfu = result.bseNseMfuFlag ;
        print("bsensemfu $bsensemfu");

        return Container(
          color: Colors.white,
          child: Column(
            children: [
              MarketTypeCard(client_code_map: result.toJson()),
              Divider(height: 0, color: Config.appTheme.lineColor),
              DeleteAllCart(
                carttype: PurchaseType.swp,
                bsensemfu: bsensemfu,
                onDelete: () {
                  Get.back();
                  Get.to(() =>
                      MyCart(defaultTitle: "SWP", defaultPage: SwpCart()));
                },
              ),
              schemeArea(schemeList, result),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    DottedLine(),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Amount (${schemeList.length} scheme)",
                            style: AppFonts.f40013),
                        Text("$rupee ${getTotal(schemeList)}",
                            style:
                                AppFonts.f50012.copyWith(color: Colors.black))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        /*if (client_code_map?['bse_nse_mfu_flag'] == "NSE")
                          Expanded(
                              child: getButton(
                            type: ButtonType.plain,
                            text: "ADD MORE",
                            result: result,
                          )),*/
                        SizedBox(width: 10),
                        Expanded(
                            child: getButton(
                          type: ButtonType.filled,
                          text: "CONTINUE",
                          result: result,
                        ))
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              )
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(height: 16),
    );
  }

  getTotal(List schemeList) {
    num total = 0;
    for (SchemeList element in schemeList) {
      total += num.tryParse(element.amount ?? "0") ?? 0;
    }
    return Utils.formatNumber(total);
  }

  editBottomSheet(SchemeList item, Result result) async {
    Rx<DateTime> swpStartDate = transactController.startDate;
    num amount = num.tryParse(item.amount ?? "0") ?? 0;
    Map client_code_map = result.toJson();
    client_code_map.remove('scheme_list');

    await getStpMinAmount(item);
    await getSwpSchemeFrequency(item);
    // swpDate = "${item.sipDate}";
    swpStartDate.value = convertStrToDt("${item.startDate}");
    frequencyCode = "${item.frequency}";
    print("sip frequency $frequency");
    swpEndType = (item.untilCancel!) ? "Until Cancelled" : "${item.endDate}";
    swpEndDate = convertStrToDt("${item.endDate}");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SizedBox(
              height: devHeight * 0.8,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  BottomSheetTitle(title: "Edit"),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        RupeeCard(
                          title: "SWP Amount",
                          minAmount: minAmount,
                          initialValue: "${item.amount}",
                          hintTitle: "Enter SWP Amount",
                          onChange: (val) {
                            amount = num.tryParse(val) ?? 0;
                          },
                          text: '$frequency SWP :',
                        ),
                        SizedBox(height: 16),
                        frequencyExpansionTile(bottomState),
                        SizedBox(height: 16),
                        transactController.rpDatePicker("SWP Start Date"),
                        // swpDateExpansionTile(bottomState),
                        SizedBox(height: 16),
                        if (client_code_map['bse_nse_mfu_flag'].toUpperCase() != "BSE")
                          swpEndDateExpansionTile(bottomState),
                        if (client_code_map['bse_nse_mfu_flag'].toUpperCase() == "BSE")
                          withdraw(context),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  CalculateButton(
                      onPress: () async {
                        DateTime swpStartDate =
                            transactController.startDate.value;
                        String staryDay =
                            swpStartDate.day.toString().padLeft(2, '0');
                        print("startDay $staryDay");

                        if (!dateList.contains(staryDay)) {
                          Utils.showError(context,
                              "Selected Date Not Allowed. \n Allowed dates are $dateList");
                          return 0;
                        }
                        Get.back();
                        String folio = "${item.folioNo}";
                        EasyLoading.show();
                        Map data = await TransactionApi.saveCartByUserId(
                          user_id: user_id,
                          client_name: client_name,
                          cart_id: "${item.id}",
                          purchase_type: PurchaseType.swp,
                          scheme_name: "${item.schemeName}",
                          to_scheme_name: "${item.toSchemeName}",
                          folio_no: folio,
                          amount: "$amount",
                          units: "",
                          frequency: frequencyCode,
                          sip_date: "${swpStartDate.day}",
                          start_date: convertDtToStr(swpStartDate),
                          end_date: convertDtToStr(swpEndDate),
                          until_cancelled:
                              swpEndType.contains('Until') ? "1" : "0",
                          trnx_type: (folio.contains("New")) ? "FP" : "AP",
                          client_code_map: client_code_map,
                          total_amount: "$amount",
                          total_units: "",
                          scheme_reinvest_tag: "${item.schemeReinvestTag}",
                          to_scheme_reinvest_tag: "${item.toSchemeReinvestTag}",
                          context: context,
                          amount_type: 'amount',
                          stp_type: 'amount',
                          installment: swpwithdrawValue,
                          stp_date: "${swpStartDate.day}",
                        );
                        if (data['status'] != 200) {
                          Utils.showError(context, data['msg']);
                          return -1;
                        }
                        cartItems = [];
                        cart.msg = null;
                        EasyLoading.dismiss();
                        setState(() {});
                      },
                      text: "UPDATE"),
                ],
              )),
            );
          },
        );
      },
    );
  }

  String frequencyCode = "";

  Widget frequencyExpansionTile(Function bottomState) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: frequencyController,
          title: Text("SWP Frequency", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(frequency, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: dateAndFreq.length,
              itemBuilder: (context, index) {
                Map data = dateAndFreq[index];

                String freqCode = data['sip_frequency_code'];
                String freq = data['sip_frequency'];

                return InkWell(
                  onTap: () {
                    frequency = freq;
                    frequencyCode = freqCode;
                    dateList = data['sip_dates'].toString().split(",");
                    frequencyController.collapse();
                    bottomState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: freqCode,
                        groupValue: frequencyCode,
                        onChanged: (value) {
                          frequency = freq;
                          frequencyCode = freqCode;
                          dateList = data['sip_dates'].toString().split(",");
                          frequencyController.collapse();
                          bottomState(() {});
                        },
                      ),
                      Text(freq),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  // String swpDate = "";
  // Widget swpDateExpansionTile(Function bottomState) {
  //   return Container(
  //     decoration: BoxDecoration(
  //         color: Colors.white, borderRadius: BorderRadius.circular(10)),
  //     child: Theme(
  //       data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
  //       child: ExpansionTile(
  //         controller: swpDateController,
  //         title: Text("SWP Date", style: AppFonts.f50014Black),
  //         subtitle: Text(swpDate,
  //             style: TextStyle(
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 13,
  //                 color: Config.appTheme.themeColor)),
  //         expandedCrossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Wrap(
  //             children: [
  //               for (int i = 0; i < dateList.length; i++)
  //                 CircularDateCard(
  //                   dateList[i],
  //                   isSelected: swpDate == dateList[i],
  //                   onTap: () {
  //                     swpDate = dateList[i];
  //                     getStartDate();
  //                     // sipDateController.collapse();
  //                     bottomState(() {});
  //                   },
  //                 ),
  //             ],
  //           ),
  //           Text("Your SWP will start from ${convertDtToStr(swpStartDate)}",
  //               style: AppFonts.f50012
  //                   .copyWith(color: Config.appTheme.readableGreyTitle)),
  //           SizedBox(height: 16),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // getStartDate() {
  //   int date = int.parse(swpDate);
  //   DateTime minStart = DateTime.now().add(Duration(days: 7));

  //   if (minStart.day > date) {
  //     swpStartDate = DateTime(minStart.year, minStart.month + 1, date);
  //   } else
  //     swpStartDate = DateTime(minStart.year, minStart.month, date);
  // }

  List swpEndTypeList = ["Until Cancelled", "Specific Date"];
  String swpEndType = "Until Cancelled";
  DateTime swpEndDate = DateTime.now();

  Widget swpEndDateExpansionTile(Function bottomState) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: swpEndDateController,
          title: Text("SWP End Date", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(swpEndType, style: AppFonts.f50012),
            ],
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              width: devWidth,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: swpEndTypeList.length,
                itemBuilder: (context, index) {
                  String temp = swpEndTypeList[index];

                  return Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: swpEndType,
                        onChanged: (value) {
                          swpEndType = temp;
                          if (swpEndType.contains("Until")) {
                            DateTime now = DateTime.now();
                            swpEndDate =
                                DateTime(now.year + 40, now.month, now.day);
                            swpEndDateController.collapse();
                          }
                          bottomState(() {});
                        },
                      ),
                      Text(temp),
                    ],
                  );
                },
              ),
            ),
            Visibility(
              visible: !swpEndType.contains("Until"),
              child: SizedBox(
                height: 200,
                child: ScrollDatePicker(
                    selectedDate: swpEndDate,
                    minimumDate: DateTime.now().add(Duration(days: 7)),
                    maximumDate: DateTime(2100),
                    onDateTimeChanged: (val) {
                      swpEndDate = val;
                      swpEndType = "${val.day}-${val.month}-${val.year}";
                      bottomState(() {});
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getButton({
    required ButtonType type,
    required String text,
    required Result result,
  }) {
    EdgeInsets padding = EdgeInsets.symmetric(horizontal: 12, vertical: 16);

    if (type == ButtonType.plain) {
      return PlainButton(
        text: text,
        padding: padding,
        onPressed: () {
          Get.to(ExistingTransaction());
        },
      );
    } else {
      return RpFilledButton(
        text: text,
        padding: padding,
        onPressed: () async {
          Map client_code_map = result.toJson();
          client_code_map.remove('scheme_list');
          await GetStorage().write('client_code_map', client_code_map);
          if (result.schemeList!.length > 1)
            return Utils.showError(context,
                "Multiple SWPs are not allowed. Please select only one scheme.");

          Get.to(() => SwpPayment());
        },
      );
    }
  }

  Widget schemeArea(List<SchemeList> schemeList, Result result) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: schemeList.length,
        itemBuilder: (context, index) {
          SchemeList scheme = schemeList[index];

          return schemeCard(scheme, result);
        },
      ),
    );
  }

  Widget schemeCard(SchemeList scheme, Result result) {
    num amount = num.parse(scheme.amount ?? "0");
    return InkWell(
      onTap: () async {
        editBottomSheet(scheme, result);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Config.appTheme.themeColor,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Image.network("${scheme.schemeLogo}", height: 32),
                Utils.getImage("${scheme.schemeLogo}", 32),
                SizedBox(width: 10),
                Expanded(
                  child: ColumnText(
                    title: "${scheme.schemeName}",
                    value: "Folio : ${scheme.folioNo}",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013,
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      await deleteAlert(scheme);
                    },
                    icon: Icon(Icons.delete_forever))
              ],
            ),
            /* SizedBox(height: 10),
            Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                         border: Border.all(color: Config.appTheme.themeColor)),
                    child: Icon(Icons.arrow_forward,
                        color: Config.appTheme.themeColor)),
                SizedBox(width: 10),
                Expanded(child: Text("${scheme.toSchemeAmfiShortName}"))
              ],
            ),*/
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Monthly SWP :$rupee ${Utils.formatNumber(amount)}",
                    style: AppFonts.f50012.copyWith(color: Colors.black)),
                Text("${scheme.startDate}", style: AppFonts.f50012)
              ],
            ),
          ],
        ),
      ),
    );
  }

  deleteAlert(SchemeList item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete"),
          content: Text("Are you sure to delete ?"),
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
                  Map data = await InvestorApi.deleteCartById(
                      user_id: user_id,
                      client_name: client_name,
                      investor_id: user_id,
                      context: context,
                      cart_id: item.id ?? 0);
                  if (data['status'] != 200) {
                    Utils.showError(context, data['msg']);
                    return;
                  }
                  Get.back();
                  EasyLoading.showToast(data['msg'],
                      toastPosition: EasyLoadingToastPosition.bottom);

                  cart.msg = null;

                  Get.back();
                  Get.to(() =>
                      MyCart(defaultTitle: "SWP", defaultPage: SwpCart()));
                },
                child: Text('Delete'))
          ],
        );
      },
    );
  }

  String swpwithdrawValue = '';
  TextEditingController withdrawController = TextEditingController();
  Widget withdraw(BuildContext context) {
    print("transferController $withdrawController");
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
            child:
                Text("Enter Number of Withdrawls", style: AppFonts.f50014Black),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 20, 10),
            child: TextFormField(
              controller: withdrawController,
              keyboardType: TextInputType.numberWithOptions(),
              onChanged: (value) {
                swpwithdrawValue = value;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Config.appTheme.lineColor, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Config.appTheme.lineColor, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                hintText: 'Enter Number of Withdrawls',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
