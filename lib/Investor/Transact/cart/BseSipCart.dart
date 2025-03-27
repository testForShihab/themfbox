import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/ExistingTransaction.dart';
import 'package:mymfbox2_0/Investor/Transact/TransactController.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/MyCart.dart';
import 'package:mymfbox2_0/Investor/Transact/sip/NfoSip.dart';
import 'package:mymfbox2_0/Investor/transact/sip/NewSipTransaction.dart';
import 'package:mymfbox2_0/Investor/transact/sip/SipPayment.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/api/TransactionApi.dart';
import 'package:mymfbox2_0/pojo/CartPojo.dart';
import 'package:mymfbox2_0/pojo/NewCartPojo.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import './rpExports.dart';

class BseSipCart extends StatefulWidget {
  const BseSipCart({super.key});
  @override
  State<BseSipCart> createState() => _BseSipCartState();
}

class _BseSipCartState extends State<BseSipCart> {
  String client_name = GetStorage().read("client_name");
  int user_id = GetStorage().read('user_id');
  String marketType = GetStorage().read("marketType");
  Map client_code_map = GetStorage().read('client_code_map');

  num total = 0;
  late double devWidth, devHeight;

  List<CartPojo> cartItems = [];
  num minAmount = 0;
  bool? nfoFlag = false;

  Future findSipEndDate() async {
    DateTime sipTenureStartDate = transactController.startDate.value;

    Map data = await TransactionApi.findSipEndDate(
      user_id: user_id,
      sip_type: (tenure == "SIP Tenure") ? "Tenure" : "Perpetual",
      install: (tenure == "SIP Tenure" && installment == "") ? "480" :(installment != "") ? installment : "0",
      client_name: client_name,
      bse_nse_mfu_flag: client_code_map['bse_nse_mfu_flag'],
      frequency: frequency,
      start_date: sipTenureStartDate.toString().split(" ")[0],
    );
    if(data['status'] != 200){
      Utils.showError(context, "No data found");
      return -1;
    }
    sipEndDate = DateTime.parse(data['msg']);
    print('SIP selected end date $sipEndDate');

  }

  List folioList = [];
  String folio = "";
  Future getFolioList(SchemeList item) async {
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

    return 0;
  }

  Future getMinAmount(SchemeList item) async {
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

    return 0;
  }

  List dateAndFreq = [];
  Future getSipDatesAndFrequency(SchemeList item) async {
    String schemAmfi = Uri.encodeComponent(item.schemeName!);
    nfoFlag = item.nfoFlag;
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
    Map temp = dateAndFreq.firstWhere(
        (element) => element['sip_frequency_code'] == item.frequency);
    frequency = temp['sip_frequency'];
    frequencyCode = temp['sip_frequency_code'];
    dateList = temp['sip_dates'].split(",");

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
  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;
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
        child: NoData(),
      ));

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: overallList.length,
      itemBuilder: (context, index) {
        Result result = overallList[index];
        List<SchemeList> schemeList = result.schemeList ?? [];
        String? bsensemfu = result.bseNseMfuFlag ;
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
                  Get.to(() => MyCart(
                        defaultTitle: "SIP",
                        defaultPage: BseSipCart(),
                      ));
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
        text: text,
        padding: padding,
        onPressed: () {
          addMoreBottomSheet(result);
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

          Get.to(() => SipPayment());
        },
      );
    }
  }

  DateTime sipEndDate = DateTime.now();
  String installment = "";

  editBottomSheet(SchemeList item, Result result) async {
    num amount = num.tryParse(item.amount ?? "0") ?? 0;
    Map client_code_map = result.toJson();
    client_code_map.remove('scheme_list');

    EasyLoading.show();
    await getFolioList(item);
    await getMinAmount(item);
    await getSipDatesAndFrequency(item);
    await findSipEndDate();
    EasyLoading.dismiss();

    // sipDate = "${item.sipDate}";
    transactController.startDate.value = convertStrToDt("${item.startDate}");

    // sipStartDate = convertStrToDt("${item.startDate}");
    frequency = "${item.frequency}";
    installment = "${item.installment}";
    tenure = "${item.tenure}";
    sipEndDate = convertStrToDt("${item.endDate}");

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
                        frequencyExpansionTile(bottomState),
                        SizedBox(height: 16),
                        InkWell(
                            onTap: () async {
                              DateTime? temp = await showDatePicker(
                                  context: Get.context!,
                                  firstDate: DateTime.now().add(Duration(days: 7)),
                                  initialDate: transactController.startDate.value,
                                  lastDate: DateTime(2030)
                              );
                              if (temp == null) return;

                              // Use the new function instead of directly setting the value
                              transactController.setStartDateWithCallback(temp, () async {
                                await findSipEndDate();
                                bottomState(() {});
                              });

                            },
                            child: transactController.rpDatePicker("SIP Start Date")
                        ),
                       // transactController.rpDatePicker("SIP Start Date"),
                        // sipDateExpansionTile(bottomState),
                        SizedBox(height: 16),
                        tenureExpansionTile(bottomState),
                        if (tenure == "SIP Tenure")
                          Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: AmountInputCard(
                              title: "No. of Installments",
                              suffixText: "Months",
                              initialValue: installment,
                              onChange: (val) async {
                                installment = val;
                                int month = int.tryParse(installment) ?? 0;

                                DateTime now = DateTime.now();
                                await findSipEndDate();
                               // sipEndDate = DateTime(now.year, now.month + month, now.day);
                                bottomState(() {});
                              },
                            ),
                          ),
                        Container(
                            width: devWidth,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("SIP End Date",
                                    style: AppFonts.f50014Black),
                                Text(sipEndDate.toString().split(" ")[0],
                                    style: AppFonts.f50012)
                              ],
                            )),
                      ],
                    ),
                  ),
                  CalculateButton(
                      onPress: () async {
                        DateTime sipStartDate =
                            transactController.startDate.value;
                        String staryDay = sipStartDate.day.toString();

                        if (!dateList.contains(staryDay)) {
                          Utils.showError(context,
                              "Selected Date Not Allowed. \n Allowed dates are $dateList");
                          return 0;
                        }

                        Get.back();
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
                          frequency: frequency,
                          sip_date: sipStartDate.day.toString(),
                          start_date: convertDtToStr(sipStartDate),
                          end_date: convertDtToStr(sipEndDate),
                          trnx_type: (folio.contains("New")) ? "FP" : "AP",
                          until_cancelled: "",
                          total_amount: "$amount",
                          total_units: "",
                          scheme_reinvest_tag: "${item.schemeReinvestTag}",
                          client_code_map: client_code_map,
                          sip_tenure: tenure,
                          context: context,
                          installment: (tenure == "Perpetual")
                              ? getNoOfMonths(frequency)
                              : installment,
                           nfo_flag: (nfoFlag ?? false) ? "Y" : "N",
                        );

                        if (data['status'] != 200) {
                          Utils.showError(context, data['msg']);
                          return -1;
                        }
                        cartItems = [];
                        EasyLoading.dismiss();
                        setState(() {});
                      },
                      text: "UPDATE"),

                  SizedBox(height: 150,),
                ],
              )),
            );
          },
        );
      },
    );
  }

  String getNoOfMonths(String frequency) {
    Map map = {
      "MONTHLY": "360",
      "QUARTERLY": "120",
      "DAILY": "10950",
      "WEEKLY": "1440",
      "SEMI-ANNUALLY": "60",
      "ANNUALLY": "30"
    };
    if (map.keys.contains(frequency))
      return map[frequency];
    else
      return "360";
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
                  setState(() {});
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
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: folioController,
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

  ExpansionTileController frequencyController = ExpansionTileController();
  String frequency = "";
  String frequencyCode = "";
  List dateList = [];
  Widget frequencyExpansionTile(Function bottomState) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
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

                String freqCode = data['sip_frequency_code'];
                String freq = data['sip_frequency'];

                return InkWell(
                  onTap: () async{
                    frequency = freq;
                    frequencyCode = freqCode;
                    dateList = data['sip_dates'].toString().split(",");
                    frequencyController.collapse();
                    await findSipEndDate();
                    bottomState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: freqCode,
                        groupValue: frequencyCode,
                        onChanged: (value) async{
                          frequency = freq;
                          frequencyCode = freqCode;
                          dateList = data['sip_dates'].toString().split(",");
                          frequencyController.collapse();
                          await findSipEndDate();
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

  // ExpansionTileController sipDateController = ExpansionTileController();
  // String sipDate = "";
  // Widget sipDateExpansionTile(Function bottomState) {
  //   return Container(
  //     decoration: BoxDecoration(
  //         color: Colors.white, borderRadius: BorderRadius.circular(10)),
  //     child: Theme(
  //       data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
  //       child: ExpansionTile(
  //         controller: sipDateController,
  //         title: Text("SIP Date", style: AppFonts.f50014Black),
  //         subtitle: Text(sipDate,
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
  //                   isSelected: sipDate == dateList[i],
  //                   onTap: () {
  //                     sipDate = dateList[i];
  //                     getStartDate();
  //                     // sipDateController.collapse();
  //                     bottomState(() {});
  //                   },
  //                 ),
  //             ],
  //           ),
  //           Text("Your SIP will start from ${convertDtToStr(sipStartDate)}",
  //               style: AppFonts.f50012
  //                   .copyWith(color: Config.appTheme.readableGreyTitle)),
  //           SizedBox(height: 16),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // getStartDate() {
  //   int date = int.parse(sipDate);
  //   DateTime minStart = DateTime.now().add(Duration(days: 7));

  //   if (minStart.day > date) {
  //     sipStartDate = DateTime(minStart.year, minStart.month + 1, date);
  //   } else
  //     sipStartDate = DateTime(minStart.year, minStart.month, date);
  // }

  ExpansionTileController tenureController = ExpansionTileController();
  List tenureList = ["Perpetual", "SIP Tenure"];
  String tenure = "Perpetual";

  Widget tenureExpansionTile(bottomState) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: tenureController,
          title: Text("SIP Tenure", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tenure,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Config.appTheme.themeColor)),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: tenureList.length,
              itemBuilder: (context, index) {
                String temp = tenureList[index];

                return InkWell(
                  onTap: () async {
                    tenure = temp;
                    tenureController.collapse();
                    /*if (tenure == "Perpetual") {
                      DateTime now = DateTime.now();
                      sipEndDate = DateTime(now.year + 30, now.month, now.day);
                    }*/
                    await findSipEndDate();
                    bottomState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: tenure,
                        onChanged: (value) async {
                          tenure = temp;
                          tenureController.collapse();
                          /*if (tenure == "Perpetual") {
                            DateTime now = DateTime.now();
                            sipEndDate =
                                DateTime(now.year + 30, now.month, now.day);
                          }*/
                          await findSipEndDate();
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
