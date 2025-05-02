import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/Investor/Transact/ExistingTransaction.dart';
import 'package:mymfbox2_0/Investor/Transact/TransactController.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/BseSipCart.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/MyCart.dart';
import 'package:mymfbox2_0/Investor/Transact/sip/NfoSip.dart';
import 'package:mymfbox2_0/Investor/transact/sip/NewSipTransaction.dart';
import 'package:mymfbox2_0/Investor/transact/sip/SipPayment.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/pojo/CartPojo.dart';
import 'package:mymfbox2_0/pojo/NewCartPojo.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class SipCart extends StatefulWidget {
  const SipCart({super.key});

  @override
  State<SipCart> createState() => _SipCartState();
}

class _SipCartState extends State<SipCart> {
  String client_name = GetStorage().read("client_name");
  int user_id = GetStorage().read('user_id');
  String marketType = GetStorage().read("marketType");
  Map? client_code_map = GetStorage().read('client_code_map');

  num total = 0;
  late double devWidth, devHeight;

  List<CartPojo> cartItems = [];
  num minAmount = 0;
  bool? nfoFlag = false;

  List folioList = [];
  String folio = "";
  List<int> disableWeekdays = [];
  String sipDay = "";
  String sipDayCode = "";
  List sipdayList = [];

  ExpansionTileController frequencyController = ExpansionTileController();
  String frequency = "";
  String frequencyCode = "";
  List dateList = [];
  String getSipDay = '';

  Future<int> getSipDays(SchemeList item) async {
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(transactController.startDate.value);
    if (item.vendor == "MFU") {
      formattedDate =
          transactControllermfu.startDate.value.toString().split(" ").first;
    }

    Map data = await TransactionApi.getSipDays(
      user_id: user_id,
      client_name: client_name,
      bse_nse_mfu_flag: "${item.vendor}",
      start_date: formattedDate,
      frequency: "Weekly",
    );

    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    sipdayList = data['list'];
    if (sipdayList.isNotEmpty) {
      Map temp = sipdayList.first;
      sipDay = temp['desc'];
      sipDayCode = temp['code'];
    } else {
      sipDay = '';
      sipDayCode = '';
    }
    return 0;
  }

  Future getFolioList(SchemeList item) async {
    EasyLoading.show();

    Map data = await TransactionApi.getUserFolio(
      user_id: user_id,
      client_name: client_name,
      bse_nse_mfu_flag: "${item.vendor}",
      amc: "${item.schemeCompany}",
      investor_code: "${item.investorCode}",
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    folioList = data['list'];
    folioList.insert(0, {"folio_no": "New Folio"});
    folio = "${item.folioNo}";
    EasyLoading.dismiss();
    return 0;
  }

  Future getMinAmount(SchemeList item) async {
    EasyLoading.show();

    Map data = await TransactionApi.getSipMinAmount(
      scheme_name: "${item.schemeName}",
      purchase_type: (folio.contains('New')) ? "FP" : "AP",
      frequency: "${item.frequency}",
      amount: "${item.amount}",
      bse_nse_mfu_flag: "${item.vendor}",
      client_name: client_name,
      dividend_code: "${item.schemeReinvestTag}",
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    minAmount = data['min_amount'];

    EasyLoading.dismiss();
    return 0;
  }

  List dateAndFreq = [];

  Future getSipDatesAndFrequency(SchemeList item) async {
    if (dateAndFreq.isNotEmpty) return 0;
    nfoFlag = item.nfoFlag;
    EasyLoading.show();
    String schemAmfi = Uri.encodeComponent(item.schemeName!);
    Map data = await TransactionApi.getSipDatesAndFrequency(
      scheme: schemAmfi,
      bse_nse_mfu_flag: "${item.vendor}",
      client_name: client_name,
      nfo_flag: (nfoFlag ?? false) ? "Y" : "N",
    );
    if (data['status'] != 200) {
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

  GetCartByUserIdPojo cart = GetCartByUserIdPojo();

  Future getCartByUserId() async {
    if (cartItems.isNotEmpty) return 0;

    Map<String, dynamic> data = await InvestorApi.getCartByUserId(
      user_id: user_id,
      investor_id: user_id,
      client_name: client_name,
      purchase_type: "SIP Purchase",
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    cart = GetCartByUserIdPojo.fromJson(data);

    return 0;
  }

  @override
  void initState() {
    //  implement initState
    super.initState();
  }

  TransactController transactController = Get.put(TransactController());
  TransactControllerMfu transactControllermfu =
      Get.put(TransactControllerMfu());

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;
    if (client_code_map?['bse_nse_mfu_flag'] == "BSE") return BseSipCart();

    return FutureBuilder(
        future: getCartByUserId(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
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

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: overallList.length,
      itemBuilder: (context, index) {
        Result result = overallList[index];
        List<SchemeList> schemeList = result.schemeList ?? [];
        String? bsensemfu = result.bseNseMfuFlag;
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              MarketTypeCard(client_code_map: result.toJson()),
              Divider(height: 0, color: Config.appTheme.lineColor),
              DeleteAllCart(
                carttype: PurchaseType.sip,
                bsensemfu: bsensemfu,
                onDelete: () {
                  Get.back();
                  Get.to(() =>
                      MyCart(defaultTitle: "SIP", defaultPage: SipCart()));
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
                        Text(
                          "Total Amount (${schemeList.length} Schemes)",
                          style: AppFonts.f40013.copyWith(fontSize: 16),
                        ),
                        Text("$rupee ${getTotal(schemeList)}",
                            style: AppFonts.f50014Black),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
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
    );
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
        folioList = [];
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
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("SIP : $rupee ${Utils.formatNumber(amount)}",
                    style: AppFonts.f50012.copyWith(color: Colors.black)),
                Text("${scheme.startDate}", style: AppFonts.f50012)
              ],
            ),
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
        color: Config.appTheme.buttonColor,
        text: text,
        padding: padding,
        onPressed: () {
          addMoreBottomSheet(result);
        },
      );
    } else {
      return RpFilledButton(
        color: Config.appTheme.buttonColor,
        text: text,
        padding: padding,
        onPressed: () async {
          Map client_code_map = result.toJson();
          client_code_map.remove('scheme_list');
          await GetStorage().write('client_code_map', client_code_map);

          Get.to(() => SipPayment());
        },
      );
    }
  }

  Map<String, String> frequencyMap = {};

  editBottomSheet(SchemeList item, Result result) async {
    num amount = num.tryParse(item.amount ?? "0") ?? 0;
    Map client_code_map = result.toJson();
    client_code_map.remove('scheme_list');

    // this is only for show the name of frequency
    if (item.vendor == 'NSE') {
      frequencyMap = {
        "Monthly": "OM",
        "Quarterly": "Q",
        "Weekly": "OW",
        "Week Days": "WD",
        "Fortnightly": "TM",
        "Business Days": "BZ",
        "Daily": "D",
        "Yearly": "Y",
        "Half Yearly": "H",
        "Once in a week": "OW"
      };
    }
    if (item.vendor == 'MFU') {
      frequencyMap = {
        "Monthly": "M",
        "Quarterly": "Q",
        "Weekly": "W",
        "Fortnightly": "F",
        "Business Days": "B",
        "Daily": "D",
        "Yearly": "Y",
        "Half Yearly": "H",
        "Annual": "A",
        "Semi Annual": "S",
      };
    }

    await getFolioList(item);
    await getMinAmount(item);
    await getSipDatesAndFrequency(item);
    if (client_code_map['bse_nse_mfu_flag'].toUpperCase() == "NSE")
      await getSipDays(item);
    // sipDate = "${item.sipDate}";
    transactController.startDate.value = convertStrToDt("${item.startDate}");
    if (item.vendor == 'MFU') {
      transactControllermfu.startDate.value =
          convertStrToDt("${item.startDate}");
    }

    frequencyCode = "${item.frequency}";
    final trnxType = "${item.trnxType}";
    // frequency = Utils.getKeyByValue(frequencyMap, frequencyCode) ?? "";
    print("sipEndDate---- $sipEndDate");
    sipEndDate = convertStrToDt("${item.endDate}");
    sipEndType = (item.untilCancel!)
        ? "Until Cancelled"
        : DateFormat("yyyy-MM-dd").format(sipEndDate);
    sipDay = "${item.sipDate}";
    frequency = "${item.frequency}";
    print("sipEndDate ${DateFormat("yyyy-MM-dd").format(sipEndDate)}");
    print("frequency  $frequency");
    String getfrequency = "${item.frequency}";

    /* frequency = frequencyMap.keys.firstWhere(
          (key) => frequencyMap[key]?.startsWith(getfrequency[0]) == true,);*/

    frequency = frequencyMap.keys.firstWhere(
      (key) => frequencyMap[key] == getfrequency,
    );

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
                          title: "SIP Amount",
                          minAmount: minAmount,
                          initialValue: "${item.amount}",
                          hintTitle: "Enter SIP Amount",
                          onChange: (val) {
                            amount = num.tryParse(val) ?? 0;
                          },
                          text: 'Min Investment',
                          showText: (minAmount != 0),
                        ),
                        SizedBox(height: 16),
                        folioExpansionTile(bottomState, item),
                        SizedBox(height: 16),
                        frequencyExpansionTile(bottomState, item),
                        SizedBox(height: 16),
                        if (client_code_map['bse_nse_mfu_flag'].toUpperCase() ==
                            "NSE")
                          InkWell(
                            onTap: () async {
                              print(
                                  "bse_nse_mfu_flag-- ${client_code_map['bse_nse_mfu_flag']}");

                              // Update disableWeekdays based on frequency only for NSE
                              if (frequency.toLowerCase() == "weekly") {
                                disableWeekdays = [
                                  DateTime.sunday,
                                  DateTime.saturday
                                ];
                              } else {
                                disableWeekdays = [];
                              }

                              DateTime initialDate =
                                  transactController.startDate.value;

                              // Adjust initial date if it falls on a weekend (only for NSE weekly)
                              if (frequency.toLowerCase() == "weekly" &&
                                  [DateTime.saturday, DateTime.sunday]
                                      .contains(initialDate.weekday)) {
                                do {
                                  initialDate =
                                      initialDate.add(Duration(days: 1));
                                } while ([DateTime.saturday, DateTime.sunday]
                                    .contains(initialDate.weekday));

                                await transactController
                                    .setStartDateWithCallback(initialDate, () {
                                  setState(() {});
                                });
                              }

                              // Show DatePicker
                              DateTime? temp = await showDatePicker(
                                selectableDayPredicate: (DateTime dateTime) =>
                                    !disableWeekdays.contains(dateTime.weekday),
                                context: Get.context!,
                                firstDate:
                                    DateTime.now().add(Duration(days: 7)),
                                initialDate: initialDate,
                                lastDate: DateTime(2030),
                              );

                              if (temp == null) return;

                              await transactController
                                  .setStartDateWithCallback(temp, () {
                                if (frequency.toLowerCase() == "weekly")
                                  sipdayList = [];
                                setState(() {});
                              });
                            },
                            child: transactController
                                .rpDatePicker("SIP Start Date"),
                          ),
                        if (client_code_map['bse_nse_mfu_flag'].toUpperCase() ==
                            "MFU")
                          InkWell(
                              onTap: () async {
                                print(
                                    "bse_nse_mfu_flag-- ${client_code_map['bse_nse_mfu_flag']}");

                                // No weekend restrictions for MFU
                                disableWeekdays = [];

                                DateTime? temp = await showDatePicker(
                                    context: Get.context!,
                                    firstDate:
                                        DateTime.now().add(Duration(days: 1)),
                                    initialDate:
                                        transactControllermfu.startDate.value,
                                    lastDate: DateTime(2030));
                                if (temp == null) return;

                                transactControllermfu
                                    .setStartDateWithCallback(temp, () async {
                                  //if(frequency.toLowerCase() == "weekly") sipdayList = [];
                                  setState(() {});
                                });
                              },
                              child: transactControllermfu
                                  .rpDatePicker("SIP Start Date")),
                        Visibility(
                          visible: frequency.toLowerCase() == "weekly",
                          child: Column(
                            children: [
                              /* SizedBox(height: 16),
                              sipDaysExpansionTile(bottomState),*/
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        sipEndDateExpansionTile(bottomState),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                  CalculateButton(
                      onPress: () async {
                        DateTime sipStartDate =
                            transactController.startDate.value;
                        if (client_code_map['bse_nse_mfu_flag'] == "MFU") {
                          sipStartDate = transactControllermfu.startDate.value;
                        }

                        String staryDay = sipStartDate.day.toString();

                        if (!availableDates
                            .contains(sipStartDate.day.toString())) {
                          Utils.showError(context,
                              "Please select the sip start date with in the following - ${availableDates.join(',')} dates");
                          return;
                        }

                        if (!dateList.contains(staryDay)) {
                          Utils.showError(context,
                              "Selected Date Not Allowed. \n Allowed dates are $dateList");
                          return;
                        }

                        EasyLoading.show();
                        Map data = await TransactionApi.saveCartByUserId(
                          user_id: user_id,
                          client_name: client_name,
                          cart_id: "${item.id}",
                          purchase_type: "${item.purchaseType}",
                          scheme_name: "${item.schemeName}",
                          to_scheme_name: "",
                          folio_no: folio,
                          amount: "$amount",
                          units: "",
                          frequency: frequencyCode,
                          sip_date: (frequency == "Weekly") ? sipDayCode : "",
                          start_date: convertDtToStr(sipStartDate),
                          end_date: convertDtToStr(sipEndDate),
                          trnx_type: (folio.contains("New")) ? "FP" : "AP",
                          until_cancelled:
                              sipEndType.contains('Until') ? "1" : "0",
                          total_amount: "$amount",
                          total_units: "",
                          scheme_reinvest_tag: "${item.schemeReinvestTag}",
                          client_code_map: client_code_map,
                          context: context,
                          nfo_flag: (nfoFlag ?? false) ? "Y" : "N",
                        );

                        if (data['status'] != 200) {
                          Utils.showError(context, data['msg']);
                          return;
                        }

                        EasyLoading.dismiss();
                        Get.back();
                        cartItems = [];
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

  addMoreBottomSheet(Result result) {
    List list = [
      {
        'img': "assets/existing_trnx.png",
        'title': "Select from Existing Folios",
      },
      {
        'img': "assets/lumpsumFund.png",
        'title': "Select New Scheme",
      },
      {
        'img': "assets/nfoFund.png",
        'title': "Select NFOs",
      },
    ];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: 350,
          child: Column(
            children: [
              BottomSheetTitle(title: "Add more funds to SIP"),
              SizedBox(height: 16),
              ListView.builder(
                itemCount: list.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  Map data = list[index];
                  String title = data['title'];

                  return Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: ListTile(
                      onTap: () async {
                        Map client_code_map = result.toJson();
                        client_code_map.remove('scheme_list');
                        await GetStorage()
                            .write('client_code_map', client_code_map);

                        if (title.contains("Existing"))
                          Get.to(() => ExistingTransaction(cameFrom: "SIP"));
                        if (title.contains("New"))
                          Get.to(() => NewSipTransaction());
                        if (title.contains("NFO")) Get.to(() => NfoSip());
                      },
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      leading: Image.asset(
                        data['img'],
                        height: 32,
                        color: Config.appTheme.themeColor,
                      ),
                      title: Text(title, style: AppFonts.f50014Theme),
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
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
                      MyCart(defaultTitle: "SIP", defaultPage: SipCart()));
                },
                child: Text('Delete'))
          ],
        );
      },
    );
  }

  showEditFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return Column(
              children: [],
            );
          },
        );
      },
    );
  }

  getTotal(List schemeList) {
    num total = 0;
    for (SchemeList element in schemeList) {
      total += num.tryParse(element.amount ?? "0") ?? 0;
    }
    return Utils.formatNumber(total);
  }

  ExpansionTileController folioController = ExpansionTileController();

  Widget folioExpansionTile(bottomState, SchemeList item) {
    final trnxType = "${item.trnxType}";
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: folioController,
          enabled: trnxType != "AP",
          title: Text("Folio Number", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(folio,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Config.appTheme.themeColor)),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemCount: folioList.length,
              itemBuilder: (context, index) {
                Map map = folioList[index];
                String tempFolio = map['folio_no'];

                return InkWell(
                  onTap: () async {
                    folio = tempFolio;
                    folioController.collapse();
                    await getMinAmount(item);
                    bottomState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: tempFolio,
                        groupValue: folio,
                        onChanged: (value) async {
                          folio = tempFolio;
                          folioController.collapse();
                          await getMinAmount(item);
                          bottomState(() {});
                        },
                      ),
                      Text(tempFolio),
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

  var availableDates = <String>[];

  Widget frequencyExpansionTile(bottomState, SchemeList item) {
    if (frequency.toLowerCase() == "weekly") {
      disableWeekdays = [DateTime.sunday, DateTime.saturday];
    } else {
      disableWeekdays = [];
    }

    final tempSipList = dateAndFreq.map((e) => SIPDetails.fromJson(e)).toList();
    final selectedDate = tempSipList
        .firstWhereOrNull((e) => e.sipFrequencyCode == frequencyCode)
        ?.sipDates;
    availableDates =
        (selectedDate ?? '').split(',').toList().map((e) => e).toList();

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExpansionTile(
              controller: frequencyController,
              title: Text("SIP Frequency", style: AppFonts.f50014Black),
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
                    String tempCode = data['sip_frequency_code'];
                    String temp = data['sip_frequency'];

                    return InkWell(
                      onTap: () async {
                        frequency = temp;
                        frequencyCode = tempCode;
                        frequencyController.collapse();

                        // Reset SIP day
                        sipDay = '';
                        sipDayCode = '';

                        // Reset and update start date
                        /* DateTime newStartDate = DateTime.now().add(Duration(days: 7));
                                        while (disableWeekdays.contains(newStartDate.weekday)) {
                                            newStartDate = newStartDate.add(Duration(days: 1));
                                        }
                                        transactController.startDate.value = newStartDate;

                                        // Clear and refresh SIP days list if weekly frequency
                                        if((client_code_map?['bse_nse_mfu_flag'].toUpperCase() == "NSE") && frequency.toLowerCase() == "weekly") {
                                            sipdayList = [];
                                            await getSipDays(item); // Make sure to pass the correct SchemeList item
                                        }*/

                        if (temp.toLowerCase() == "weekly") {
                          disableWeekdays = [
                            DateTime.sunday,
                            DateTime.saturday
                          ];

                          // Get current start date
                          DateTime currentDate =
                              client_code_map?['bse_nse_mfu_flag'] == "MFU"
                                  ? transactControllermfu.startDate.value
                                  : transactController.startDate.value;

                          // Check if it's a weekend
                          if ([DateTime.saturday, DateTime.sunday]
                              .contains(currentDate.weekday)) {
                            // Find next valid weekday
                            DateTime adjustedDate = currentDate;
                            while ([DateTime.saturday, DateTime.sunday]
                                .contains(adjustedDate.weekday)) {
                              adjustedDate =
                                  adjustedDate.add(Duration(days: 1));
                            }

                            // Update the date in the appropriate controller
                            if (client_code_map?['bse_nse_mfu_flag'] == "NSE") {
                              sipdayList = [];
                              await getSipDays(item);
                              await transactController
                                  .setStartDateWithCallback(adjustedDate, () {
                                if (mounted) setState(() {});
                              });
                            }
                            /* else {
                                               await transactController.setStartDateWithCallback(adjustedDate, () {
                                               if (mounted) setState(() {});
                                               });
                                             }*/
                          }
                        } else {
                          disableWeekdays = [];
                        }

                        bottomState(() {});
                      },
                      child: Row(
                        children: [
                          Radio(
                            value: tempCode,
                            groupValue: frequencyCode,
                            onChanged: (value) async {
                              frequency = temp;
                              frequencyCode = tempCode;
                              frequencyController.collapse();

                              // Reset SIP day
                              sipDay = '';
                              sipDayCode = '';

                              // Reset and update start date
                              DateTime newStartDate =
                                  DateTime.now().add(Duration(days: 7));
                              while (disableWeekdays
                                  .contains(newStartDate.weekday)) {
                                newStartDate =
                                    newStartDate.add(Duration(days: 1));
                              }
                              transactController.startDate.value = newStartDate;

                              // Clear and refresh SIP days list if weekly frequency
                              if ((client_code_map?['bse_nse_mfu_flag']
                                          .toUpperCase() ==
                                      "NSE") &&
                                  frequency.toLowerCase() == "weekly") {
                                sipdayList = [];
                                await getSipDays(
                                    item); // Make sure to pass the correct SchemeList item
                              }

                              bottomState(() {});
                            },
                          ),
                          Text(temp),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20)
                  .copyWith(bottom: 8),
              child: Text(
                'This scheme allows only these SIP dates: ${selectedDate ?? ''}',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ExpansionTileController sipEndDateController = ExpansionTileController();
  List sipEndTypeList = ["Until Cancelled", "Specific Date"];
  String sipEndType = "Until Cancelled";
  DateTime sipEndDate = DateTime.now();

  Widget sipEndDateExpansionTile(Function bottomState) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: sipEndDateController,
          title: Text("SIP End Date", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sipEndType, style: AppFonts.f50012),
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
                itemCount: sipEndTypeList.length,
                itemBuilder: (context, index) {
                  String temp = sipEndTypeList[index];

                  return Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: sipEndType,
                        onChanged: (value) {
                          sipEndType = temp;
                          if (sipEndType.contains("Until")) {
                            DateTime now = DateTime.now();
                            sipEndDate =
                                DateTime(now.year + 40, now.month, now.day);
                            sipEndDateController.collapse();
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
              visible: !sipEndType.contains("Until"),
              child: SizedBox(
                height: 200,
                child: ScrollDatePicker(
                    selectedDate: sipEndDate,
                    minimumDate: DateTime.now().add(Duration(days: 7)),
                    maximumDate: DateTime(2100),
                    onDateTimeChanged: (val) {
                      sipEndDate = val;
                      //sipEndType = "${val.day}-${val.month}-${val.year}";
                      sipEndType = DateFormat('yyyy-MM-dd').format(val);
                      bottomState(() {});
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  ExpansionTileController sipDaysController = ExpansionTileController();

  Widget sipDaysExpansionTile(bottomState) {
    String title = sipDay;

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: sipDaysController,
          title: Text("SIP Day", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppFonts.f50012),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: sipdayList.length,
              itemBuilder: (context, index) {
                Map data = sipdayList[index];

                String tempCode = data['code'];
                String temp = data['desc'];

                return InkWell(
                  onTap: () async {
                    sipDay = temp;
                    sipDayCode = tempCode;
                    sipDaysController.collapse();
                    bottomState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: tempCode,
                        groupValue: sipDayCode,
                        onChanged: (value) async {
                          sipDay = temp;
                          sipDayCode = tempCode;
                          sipDaysController.collapse();
                          bottomState(() {});
                        },
                      ),
                      Text(temp),
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
}

class SIPDetails {
  String? sipFrequency;
  String? sipFrequencyCode;
  String? sipDates;

  SIPDetails({
    this.sipFrequency,
    this.sipFrequencyCode,
    this.sipDates,
  });

  factory SIPDetails.fromJson(Map<String, dynamic> json) => SIPDetails(
        sipFrequency: json["sip_frequency"],
        sipFrequencyCode: json["sip_frequency_code"],
        sipDates: json["sip_dates"],
      );

  Map<String, dynamic> toJson() => {
        "sip_frequency": sipFrequency,
        "sip_frequency_code": sipFrequencyCode,
        "sip_dates": sipDates,
      };
}
