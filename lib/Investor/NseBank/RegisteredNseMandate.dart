import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import '../../api/Api.dart';
import '../../api/TransactionApi.dart';
import '../../api/transaction/NseTransactionApi.dart';
import '../../rp_widgets/ColumnText.dart';
import '../../rp_widgets/InvAppBar.dart';
import '../../utils/AppColors.dart';
import '../../utils/AppFonts.dart';
import '../../utils/Config.dart';
import '../../utils/Utils.dart';

class RegisterNseMandate extends StatefulWidget {

  RegisterNseMandate(
      {super.key,
      required this.bankName,
      required this.bankAccountNumber, required this.ifscCode, required this.bankBranch, required this.acctHolderName,this.accountType});

  String? bankName;
  String? bankAccountNumber;
  String? ifscCode;
  String? bankBranch;
  String? accountType;
   String acctHolderName;

  @override
  State<RegisterNseMandate> createState() => _RegisterNseMandateState();
}

class _RegisterNseMandateState extends State<RegisterNseMandate> {
  late String bankAccountNumber;
  late String ifscCode;
  late String bankBranch;
  late String bankName;
  late String accHolderName;
  late String accountType;
  late double devWidth, devHeight;

  int user_id = GetStorage().read('user_id');
  String client_name = GetStorage().read('client_name');
  String nseIinNumber = GetStorage().read("nseIinNumber");

  bool isLoading = true;
  String text = "";

  ExpansionTileController mandateTypeController = ExpansionTileController();
  ExpansionTileController mandateOptController = ExpansionTileController();
  ExpansionTileController fromDateController = ExpansionTileController();
  ExpansionTileController mandateEndDateController = ExpansionTileController();

  String mandate = "E-Mandate";
  String mandateOpt = "Net Banking";
  String fromDate = "Select SIP Date";
  String mandateEndDate = "Until Cancelled";
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  num amount = 0;
  num minAmount = 0;

  List mandateTypeList = ["E-Mandate", "Physical Mandate"];
  List mandateOptList = ["Net Banking", "Debit Card", "Aadhar"];
  List mandateEndDateList = ["Until Cancelled", "Specific Date"];

  @override
  void initState() {
    bankAccountNumber = widget.bankAccountNumber!;
    ifscCode = widget.ifscCode!;
    bankBranch = widget.bankBranch!;
    bankName = widget.bankName!;
    accHolderName = widget.acctHolderName;

    super.initState();
  }

  ExpansionTileController mandateController = ExpansionTileController();
  Map selectedMandate = {};

  List mandateList = [];

  Future generateNseMandate() async {
    EasyLoading.show();
    Map data = await NseTransactionApi.generateNseMandate(
        user_id: user_id,
        client_name: client_name,
        iin_number: nseIinNumber,
        account_number: bankAccountNumber);

    if (data['status'] != 200) {
      if (EasyLoading.isShow) EasyLoading.dismiss();
      Utils.showError(context, data['msg']);
      return -1;
    }
    EasyLoading.dismiss();
    return 0;
  }

  String arn = "ARN-${Config.appArn}";
  List arnList = [];
  Future getArnList() async {
    if (arnList.isNotEmpty) return 0;
    Map data = await Api.getArnList(client_name: client_name);
    try {
      if (data['status'] != 200) {
        Utils.showError(context, data['msg']);
        return 0;
      }
      arnList = [
        data['broker_code_1'],
        data['broker_code_2'],
        data['broker_code_3']
      ];
      arnList.removeWhere((element) => element.isEmpty);
    } catch (e) {
      print("getArnList exception = $e");
    }
    return 0;
  }

  String euin = "";
  List euinList = [];
  Future getEuinList() async {
    Map data =
        await Api.getEuinList(client_name: client_name, broker_code: arn);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }

    euinList = data['list'];
    euin = euinList.first;
    return 0;
  }

  Future getDatas() async {
    isLoading = true;
    await getArnList();
    await getEuinList();
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
          return Scaffold(
            backgroundColor: Config.appTheme.overlay85,
            appBar: invAppBar(
              title: "Banks & Mandates Details",
            ),
            body: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    topCard(),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.all(16),
                      child: Text("Registered Mandates:",
                          style: AppFonts.f50014Grey),
                    ),
                    if (mandateList.length == "")
                      InkWell(
                        child: Column(
                          children: [
                            Container(
                              width: devWidth,
                              margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Text("No registered mandate found."),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Config.appTheme.themeColor,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        padding: EdgeInsets.all(12),
                                        fixedSize:
                                            Size.fromWidth(devWidth * 0.6),
                                      ),
                                      onPressed: () {
                                        showMandateBottomSheet(context);
                                      },
                                      child: Text("REGISTER NEW MANDATE")),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        child: ListView.builder(
                            itemCount: mandateList.length,
                            shrinkWrap: true,
                            //  physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return registeredMandate(mandateList[index]);
                            }),
                      ),
                  ],
                ),
              ),
            ),
            bottomSheet: Container(
              width: devWidth,
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: SizedBox(
                width: devWidth * 0.76,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Config.appTheme.themeColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    textStyle: AppFonts.f50014Black.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    showMandateBottomSheet(context);
                  },
                  child: Text("REGISTER NEW MANDATE"),
                ),
              ),
            ),
          );
        });
  }

  Container topCard() {
    return Container(
      width: devWidth,
      margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset("assets/icici.png", height: 32),
                SizedBox(width: 10),
                Text(bankName,
                    style: AppFonts.f50014Grey.copyWith(color: Colors.black)),
                Spacer(),
                InkWell(onTap: () {}, child: Icon(Icons.more_vert)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                ColumnText(title: "Account Number", value: bankAccountNumber),
                Spacer(),
                ColumnText(title: "IFSC Code", value: ifscCode),
              ],
            ),
            Row(
              children: [ColumnText(title: "Bank Branch", value: bankBranch)],
            ),
          ],
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "1":
        return AppColors.lightGreen;
      case "0":
        return AppColors.lightRed;
      default:
        return AppColors.lightOrange;
    }
  }

  Color getStatusTextColor(String status) {
    switch (status) {
      case "1":
        return AppColors.textGreen;
      case "0":
        return AppColors.lossRed;
      default:
        return AppColors.orage;
    }
  }

  Widget registeredMandate(mandateList) {
    print("came here -----------");
    String accNo = mandateList['bank_account_number'];
    String umrn = mandateList['mandate_id'];
    String amount = mandateList['mandate_amount'];
    String type = mandateList['mandate_type'];
    String tempAccNo = accNo.substring(0, accNo.length - 4);
    tempAccNo = "**$tempAccNo";
    int mandateApproved = mandateList['mandate_approved'];

    Color color;

    String mandateAmount = amount.toString();

    if (mandateList['mandate_approved'] == 1)
      text = 'Mandate Generated Successfully';
    //color = AppColors.textGreen;

    print("mandate approved ${mandateList['mandate_approved']}");
    print("UMRN $text");
    print("amount $mandateAmount");

    return InkWell(
      child: Column(
        children: [
          Container(
            width: devWidth,
            margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                type,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "UMRN:$umrn",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                            ]),
                        Spacer(),
                        InkWell(onTap: () {}, child: Icon(Icons.more_vert)),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                            padding: EdgeInsets.all(3.5),
                            decoration: BoxDecoration(
                              color: getStatusColor(
                                  mandateList['mandate_approved'].toString()),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Text(
                              text,
                              style: TextStyle(
                                  color: getStatusTextColor(
                                      mandateList['mandate_approved']
                                          .toString())),
                            )),
                        Spacer(),
                        Text('$rupee $mandateAmount'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  showMandateBottomSheet(context) {
    String? number = bankAccountNumber;
    String? mask = number.substring(number.length - 4);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (context, bottomSheet) {
            return Container(
              height: devHeight * 0.8,
              decoration: BoxDecoration(
                  // color: Config.appTheme.themeColor,
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Bank Mandate Registration",
                            style: AppFonts.f40016
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(Icons.close)),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Container(
                            width: devWidth,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset("assets/icici.png", height: 32),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(bankName,
                                        style: AppFonts.f50014Grey
                                            .copyWith(color: Colors.black)),
                                    Text("****$mask | $ifscCode"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          mandateTypeTile(context),
                          SizedBox(
                            height: 10,
                          ),
                          mandateOptionTile(context),
                          SizedBox(
                            height: 10,
                          ),
                          mandateFromDateTile(context),
                          SizedBox(
                            height: 10,
                          ),
                          sipEndDateExpansionTile(context),
                          SizedBox(
                            height: 10,
                          ),
                          mandateAmountTile(),
                          SizedBox(
                            height: 10,
                          ),
                          arnExpansionTile(),
                          SizedBox(
                            height: 10,
                          ),
                          euinExpansionTile(),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: devWidth,
                      padding: EdgeInsets.all(16),
                      color: Colors.white,
                      child: SizedBox(
                        width: devWidth * 0.76,
                        height: 42,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Config.appTheme.themeColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            textStyle: AppFonts.f50014Black.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            List list = [
                              mandateTypeList,
                              bankName,
                            ];
                            if (list.contains("")) {
                              Utils.showError(
                                  context, "All Fields are Mandatory");
                              return;
                            }

                            /* int res = await generateNseMandate();
                                if (res == -1) return;
                                Get.back();*/
                          },
                          child: Text("SUBMIT"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  Widget mandateTypeTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: mandateTypeController,
          title: Text("Mandate Type", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mandate, style: AppFonts.f50012),
            ],
          ),
          children: [
            DottedLine(height: 50),
            ListView.builder(
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: mandateTypeList.length,
              itemBuilder: (context, index) {
                String temp = mandateTypeList[index];

                return InkWell(
                  onTap: () {
                    mandate = temp;
                    mandateTypeController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: mandate,
                        onChanged: (value) {
                          mandate = temp;
                          mandateTypeController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(temp, style: AppFonts.f50014Grey),
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

  Widget mandateOptionTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: mandateOptController,
          title: Text("Mandate Option", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mandateOpt, style: AppFonts.f50012),
            ],
          ),
          children: [
            DottedLine(height: 50),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: mandateOptList.length,
              itemBuilder: (context, index) {
                String temp = mandateOptList[index];

                return InkWell(
                  onTap: () {
                    mandateOpt = temp;
                    mandateOptController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: mandateOpt,
                        onChanged: (value) {
                          mandateOpt = temp;
                          mandateOptController.collapse();
                          setState(() {});
                        },
                      ),
                      Text(temp, style: AppFonts.f50014Grey),
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

  Widget mandateFromDateTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: fromDateController,
          title: Text("Mandate From Date", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fromDate,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Config.appTheme.themeColor)),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: 0,
              itemBuilder: (context, index) {
                String temp = fromDate[index];

                return InkWell(
                  onTap: () {
                    fromDate = temp;
                    fromDateController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: fromDate,
                        onChanged: (value) {
                          fromDate = temp;
                          fromDateController.collapse();
                          setState(() {});
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

  Widget mandateEndDateTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: mandateEndDateController,
          title: Text("Mandate To Date", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mandateEndDate,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Config.appTheme.themeColor)),
              DottedLine(),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: mandateEndDateList.length,
              itemBuilder: (context, index) {
                String temp = mandateEndDateList[index];

                return InkWell(
                  onTap: () {
                    mandateEndDate = temp;
                    mandateEndDateController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: mandateEndDate,
                        onChanged: (value) {
                          mandateEndDate = temp;
                          mandateEndDateController.collapse();
                          setState(() {});
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

  Widget sipEndDateExpansionTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: mandateEndDateController,
          title: Text("Mandate To Date", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mandateEndDate, style: AppFonts.f50012),
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
                itemCount: mandateEndDateList.length,
                itemBuilder: (context, index) {
                  String temp = mandateEndDateList[index];

                  return Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: mandateEndDate,
                        onChanged: (value) {
                          mandateEndDate = temp;
                          if (mandateEndDate.contains("Until")) {
                            DateTime now = DateTime.now();
                            endDate =
                                DateTime(now.year + 40, now.month, now.day);
                            mandateEndDateController.collapse();
                          }
                          setState(() {});
                        },
                      ),
                      Text(temp),
                    ],
                  );
                },
              ),
            ),
            Visibility(
              visible: !mandateEndDate.contains("Until"),
              child: SizedBox(
                height: 200,
                child: ScrollDatePicker(
                    selectedDate: endDate,
                    onDateTimeChanged: (val) {
                      endDate = val;
                      mandateEndDate = "${val.day}-${val.month}-${val.year}";
                      setState(() {});
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  ExpansionTileController arnController = ExpansionTileController();
  Widget arnExpansionTile() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: arnController,
          title: Text("Select ARN Number", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(arn,
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
              itemCount: arnList.length,
              itemBuilder: (context, index) {
                String temp = arnList[index];

                return InkWell(
                  onTap: () async {
                    arn = temp;
                    arnController.collapse();
                    await getEuinList();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: arn,
                        onChanged: (value) async {
                          arn = temp;
                          arnController.collapse();
                          await getEuinList();
                          setState(() {});
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

  ExpansionTileController euinController = ExpansionTileController();
  Widget euinExpansionTile() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: euinController,
          title: Text("Select EUIN", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(euin,
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
              itemCount: euinList.length,
              itemBuilder: (context, index) {
                String temp = euinList[index];

                return InkWell(
                  onTap: () {
                    euin = temp;
                    euinController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: euin,
                        onChanged: (value) {},
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

  Widget mandateAmountTile() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              alignment: Alignment.topLeft,
              child: Text("Mandate Amount",
                  style: AppFonts.f50014Black, textAlign: TextAlign.start)),
          SizedBox(height: 16),
          Row(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11.5),
                  decoration: BoxDecoration(
                    color: Config.appTheme.mainBgColor,
                    border: Border(
                      left: BorderSide(
                          width: 1, color: Config.appTheme.lineColor),
                      top: BorderSide(
                          width: 1, color: Config.appTheme.lineColor),
                      bottom: BorderSide(
                          width: 1, color: Config.appTheme.lineColor),
                    ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        topLeft: Radius.circular(16)),
                  ),
                  child: Text(rupee, style: AppFonts.f50014Grey)),
              Expanded(
                child: TextFormField(
                  maxLength: 10,
                  keyboardType: TextInputType.numberWithOptions(),
                  onChanged: (val) => amount = num.tryParse(val) ?? 0,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Config.appTheme.lineColor, width: 1),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Config.appTheme.lineColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      hintText: 'Enter Mandate Amount'),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          /*Container(
            alignment: Alignment.topLeft,
            child: InkWell(
                onTap: () {
                  showAboutSheet();
                },
                child: Text(
                  "Learn about Mandate Limit ?",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Config.appTheme.themeColor),
                )),
          ),*/
        ],
      ),
    );
  }

  showAboutSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            //color: Config.appTheme.themeColor,
            child: SizedBox(
              height: devHeight * 0.4,
              child: StatefulBuilder(builder: (_, bottomState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Learn about Mandate Limit",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(Icons.close))
                        ],
                      ),
                    ),
                    // Divider(),
                    Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      alignment: Alignment.center,
                      child: Text(
                        "  Mandate Limit: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n"
                        "\n  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                        maxLines: 20,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        });
  }
}
