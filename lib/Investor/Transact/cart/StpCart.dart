import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/Investor/Transact/ExistingTransaction.dart';
import 'package:mymfbox2_0/Investor/Transact/TransactController.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/MyCart.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/Investor/Transact/stp/StpPayment.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/pojo/CartPojo.dart';
import 'package:mymfbox2_0/pojo/NewCartPojo.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class StpCart extends StatefulWidget {
  const StpCart({super.key});

  @override
  State<StpCart> createState() => _StpCartState();
}

class _StpCartState extends State<StpCart> {
  String client_name = GetStorage().read("client_name");
  int user_id = GetStorage().read('user_id');
  Map? client_code_map = GetStorage().read('client_code_map');

  num total = 0;
  late double devWidth, devHeight;
  List<CartPojo> cartItems = [];

  GetCartByUserIdPojo cart = GetCartByUserIdPojo();

  ExpansionTileController folioController = ExpansionTileController();
  ExpansionTileController frequencyController = ExpansionTileController();
  ExpansionTileController stpDateController = ExpansionTileController();
  ExpansionTileController stpEndDateController = ExpansionTileController();
  final startDateController = Get.put(StartDateController());

  // DateTime stpStartDate = DateTime.now().add(Duration(days: 7));
  String frequency = "";

  Future getCartByUserId() async {
    if (cart.msg != null) return 0;

    Map<String, dynamic> data = await InvestorApi.getCartByUserId(
      user_id: user_id,
      investor_id: user_id,
      client_name: client_name,
      purchase_type: PurchaseType.stp,
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

  Future getStpSchemeFrequency(SchemeList item) async {
    if (dateAndFreq.isNotEmpty) return 0;
    String schemAmfi = Uri.encodeComponent(item.schemeName!);
    EasyLoading.show();
    Map data = await TransactionApi.getStpSchemeFrequency(
      user_id: user_id,
      client_name: client_name,
      amc_name: "${item.schemeCompany}",
      scheme_name: schemAmfi,
      dividend_code: "${item.toSchemeReinvestTag}",
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
        String? bsensemfu = result.bseNseMfuFlag;
        print("bsensemfu $bsensemfu");

        return Container(
          color: Colors.white,
          child: Column(
            children: [
              MarketTypeCard(client_code_map: result.toJson()),
              Divider(height: 0, color: Config.appTheme.lineColor),
              DeleteAllCart(
                carttype: PurchaseType.stp,
                bsensemfu: bsensemfu,
                onDelete: () {
                  Get.back();
                  Get.to(() =>
                      MyCart(defaultTitle: "STP", defaultPage: StpCart()));
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
                        if (client_code_map?['bse_nse_mfu_flag'] == "NSE")
                          Expanded(
                              child: getButton(
                            type: ButtonType.plain,
                            text: "ADD MORE",
                            result: result,
                          )),
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
    Rx<DateTime> stpStartDate = transactController.startDate;
    // DateTime stpStartDate = DateTime.now();
    num amount = num.tryParse(item.amount ?? "0") ?? 0;
    Map client_code_map = result.toJson();
    client_code_map.remove('scheme_list');

    await getStpMinAmount(item);
    await getStpSchemeFrequency(item);
    // stpDate.value = "${item.sipDate}";
    startDateController.startDate.value = convertStrToDt("${item.startDate}");
    frequencyCode = "${item.frequency}";
    stpEndType = (item.untilCancel!) ? "Until Cancelled" : "${item.endDate}";
    stpEndDate = convertStrToDt("${item.endDate}");

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
                          title: "STP Amount",
                          minAmount: minAmount,
                          hintTitle: "Enter STP Amount",
                          initialValue: "${item.amount}",
                          onChange: (val) {
                            amount = num.tryParse(val) ?? 0;
                          },
                          text: 'Min STP :',
                        ),
                        SizedBox(height: 16),
                        frequencyExpansionTile(bottomState),
                        SizedBox(height: 16),
                        // stpDateExpansionTile(bottomState),
                        // transactController.rpDatePicker("STP Start Date"),
                        stpStartDateTile(context, bottomState),
                        // SizedBox(height: 16),
                        // if (frequency == "Weekly") stpDayTile(context),
                        SizedBox(height: 16),
                        stpEndDateExpansionTile(bottomState),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  CalculateButton(
                      onPress: () async {
                        String folio = "${item.folioNo}";

                        // DateTime stpStartDate =
                        //     transactController.startDate.value;

                        if (amount < minAmount) {
                          Utils.showError(context,
                              'Please select a SIP amount greater than $minAmount');
                          return 0;
                        }

                        int startDay = int.tryParse(startDateController
                                .startDate.value.day
                                .toString()) ??
                            01;
                        print("startDay $startDay");
                        print("startDay $dateList");

                        final list = dateList
                            .map((e) => int.tryParse(e ?? '01') ?? 01)
                            .toList();
                        print('list: $list');

                        if (!list.contains(startDay)) {
                          Utils.showError(context,
                              "Selected Date Not Allowed. \n Allowed dates are $dateList");
                          return 0;
                        }
                        EasyLoading.show();
                        Map data = await TransactionApi.saveCartByUserId(
                          user_id: user_id,
                          client_name: client_name,
                          cart_id: "${item.id}",
                          purchase_type: PurchaseType.stp,
                          scheme_name: "${item.schemeName}",
                          to_scheme_name: "${item.toSchemeName}",
                          folio_no: folio,
                          amount: "$amount",
                          units: "",
                          frequency: frequencyCode,
                          sip_date: "",
                          start_date: convertDtToStr(
                              startDateController.startDate.value),
                          end_date: convertDtToStr(stpEndDate),
                          until_cancelled:
                              stpEndType.contains('Until') ? "1" : "0",
                          trnx_type: (folio.contains("New")) ? "FP" : "AP",
                          client_code_map: client_code_map,
                          total_amount: "$amount",
                          total_units: "",
                          scheme_reinvest_tag: "${item.schemeReinvestTag}",
                          to_scheme_reinvest_tag: "${item.toSchemeReinvestTag}",
                          context: context,
                          amount_type: 'amount',
                          stp_type: 'amount',
                          installment: " ${item.installment}",
                          stp_date: startDateController.startDate.value.day
                              .toString(),
                        );
                        if (data['status'] != 200) {
                          Utils.showError(context, data['msg']);
                          return -1;
                        }
                        cartItems = [];
                        cart.msg = null;
                        EasyLoading.dismiss();
                        setState(() {});
                        Get.back();
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
          title: Text("STP Frequency", style: AppFonts.f50014Black),
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

  // String stpDate = "";
  // Widget stpDateExpansionTile(Function bottomState) {
  //   return Container(
  //     decoration: BoxDecoration(
  //         color: Colors.white, borderRadius: BorderRadius.circular(10)),
  //     child: Theme(
  //       data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
  //       child: ExpansionTile(
  //         controller: stpDateController,
  //         title: Text("STP Date", style: AppFonts.f50014Black),
  //         subtitle: Text(stpDate,
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
  //                   isSelected: stpDate == dateList[i],
  //                   onTap: () {
  //                     stpDate = dateList[i];
  //                     getStartDate();
  //                     // sipDateController.collapse();
  //                     bottomState(() {});
  //                   },
  //                 ),
  //             ],
  //           ),
  //           Text(
  //               "Your STP will start from ${convertDtToStr(stpStartDate.value)}",
  //               style: AppFonts.f50012
  //                   .copyWith(color: Config.appTheme.readableGreyTitle)),
  //           SizedBox(height: 16),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // getStartDate() {
  //   int date = int.parse(stpDate);
  //   DateTime minStart = DateTime.now().add(Duration(days: 7));

  //   if (minStart.day > date) {
  //     stpStartDate = DateTime(minStart.year, minStart.month + 1, date);
  //   } else
  //     stpStartDate = DateTime(minStart.year, minStart.month, date);
  // }

  String selectedSTPDay = '';

  showDatePickerDialogue(BuildContext context, bottomState) async {
    final allowedDays =
        dateList.map((e) => int.tryParse(e ?? '1') ?? 1).toList();

    DateTime now = DateTime.now().add(Duration(days: 7));
    DateTime? initialDate;

    if (allowedDays.contains(startDateController.startDate.value.day)) {
      initialDate = startDateController.startDate.value;
    } else {
      for (int i = 0; i < 30; i++) {
        final candidate = now.add(Duration(days: i));
        if (allowedDays.contains(candidate.day)) {
          initialDate = candidate;
          break;
        }
      }

      initialDate ??= now;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().add(Duration(days: 7)),
      lastDate: DateTime(2100),
      selectableDayPredicate: (DateTime day) {
        return allowedDays.contains(day.day);
      },
    );

    if (pickedDate != null) {
      // handle pickedDate
      startDateController.startDate.value = pickedDate;
      String dayName =
          DateFormat('EEEE').format(startDateController.startDate.value);
      selectedSTPDay = dayName;
      bottomState(() {});
      // setState(() {});
    }
  }

  Widget stpStartDateTile(context, bottomState) {
    return InkWell(
      onTap: () {
        showDatePickerDialogue(context, bottomState);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("STP Start Date", style: AppFonts.f50014Black),
                Text(convertDtToStr(startDateController.startDate.value),
                    style: AppFonts.f50012),
                Text(
                  'This scheme allows only these STP days: ${dateList.map((e) => e).join(', ')}',
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget stpDayTile(BuildContext context) {
    return Opacity(
      opacity: 0.56,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("STP Day", style: AppFonts.f50014Black),
                  Text(selectedSTPDay, style: AppFonts.f50012),
                ],
              ),
            )),
      ),
    );
  }

  List stpEndTypeList = ["Until Cancelled", "Specific Date"];
  String stpEndType = "Until Cancelled";
  DateTime stpEndDate = DateTime.now();

  Widget stpEndDateExpansionTile(Function bottomState) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: stpEndDateController,
          title: Text("STP End Date", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(stpEndType, style: AppFonts.f50012),
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
                itemCount: stpEndTypeList.length,
                itemBuilder: (context, index) {
                  String temp = stpEndTypeList[index];

                  return Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: stpEndType,
                        onChanged: (value) {
                          stpEndType = temp;
                          if (stpEndType.contains("Until")) {
                            DateTime now = DateTime.now();
                            stpEndDate =
                                DateTime(now.year + 40, now.month, now.day);
                            stpEndDateController.collapse();
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
              visible: !stpEndType.contains("Until"),
              child: SizedBox(
                height: 200,
                child: ScrollDatePicker(
                    selectedDate: stpEndDate,
                    minimumDate: DateTime.now().add(Duration(days: 7)),
                    maximumDate: DateTime(2100),
                    onDateTimeChanged: (val) {
                      stpEndDate = val;
                      stpEndType = "${val.day}-${val.month}-${val.year}";
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

          if (result.schemeList!.length > 1 &&
              client_code_map['bse_nse_mfu_flag'] != "NSE")
            return Utils.showError(context,
                "Multiple STPs are not allowed. Please select only one scheme.");

          Get.to(() => StpPayment());
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
                  flex: 1,
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
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Config.appTheme.themeColor)),
                    child: Icon(Icons.arrow_forward,
                        color: Config.appTheme.themeColor)),
                SizedBox(width: 10),
                Expanded(child: Text("${scheme.toSchemeName}"))
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("STP :$rupee ${Utils.formatNumber(amount)}",
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
                      MyCart(defaultTitle: "STP", defaultPage: StpCart()));
                },
                child: Text('Delete'))
          ],
        );
      },
    );
  }
}

class StartDateController extends GetxController {
  Rx<DateTime> startDate = DateTime.now().obs;
}
