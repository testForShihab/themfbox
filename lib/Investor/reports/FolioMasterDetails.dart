import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../../rp_widgets/RpChip.dart';

class FolioMasterDetails extends StatefulWidget {
  const FolioMasterDetails({super.key, required this.schemeItem});
  final Map schemeItem;
  @override
  State<FolioMasterDetails> createState() => _FolioMasterState();
}

class _FolioMasterState extends State<FolioMasterDetails> {
  Map schemeItem = {};
  late double devWidth, devHeight;
  List tranxList = [];

  bool isLoading = true;
  Future getDatas() async {
    isLoading = true;
    isLoading = false;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    schemeItem = widget.schemeItem;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: getDatas(),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Config.appTheme.mainBgColor,
          appBar: AppBar(
            backgroundColor: Config.appTheme.themeColor,
            leadingWidth: 0,
            toolbarHeight: 40,
            foregroundColor: Colors.white,
            elevation: 0,
            leading: SizedBox(),
            title: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      child: Icon(Icons.arrow_back),
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: displayPage(),
        );
      },
    );
  }

  Widget appBarNewColumn(String title, String value, Widget suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14)),
        Container(
          width: devWidth * 0.91,
          padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
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

  Widget displayPage() {
    schemeItem = widget.schemeItem;

    String schemeName = schemeItem['scheme_amfi_short_name'].toString();
    String holdings = schemeItem['mod_of_holding'];
    num currentValue = schemeItem['current_value'] ?? 0.0;
    num balanceUnits = schemeItem['units'] ?? 0.0;
    tranxList = schemeItem['folio_master_details'];
    String logo = schemeItem['amc_logo'];

    if (holdings == 'SI') {
      holdings = 'SINGLE';
    } else if (holdings == "AS") {
      holdings = 'ANYONE / SURVIVOR';
    } else if (holdings == 'ES') {
      holdings = 'EITHER / SURVIVOR';
    } else if (holdings == 'JO') {
      holdings = 'JOINT';
    }

    return SideBar(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              color: Config.appTheme.themeColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        logo,
                        height: 32,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ColumnText(
                          title: schemeName,
                          value: "Folio :${schemeItem['folio_no']}",
                          titleStyle: AppFonts.f50014Black
                              .copyWith(fontSize: 18, color: Colors.white),
                          valueStyle:
                              AppFonts.f40013.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  DottedLine(),
                  // SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: ColumnText(
                            title: "Current Value",
                            titleStyle: AppFonts.f40013
                                .copyWith(color: Config.appTheme.overlay85),
                            value:
                                "$rupee ${Utils.formatNumber(currentValue.round(), isAmount: false)}",
                            valueStyle: AppFonts.f50014Black
                                .copyWith(color: Colors.white),
                            alignment: CrossAxisAlignment.start,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: ColumnText(
                            title: "Balance Units",
                            titleStyle: AppFonts.f40013
                                .copyWith(color: Config.appTheme.overlay85),
                            value: "${balanceUnits.toStringAsFixed(4)} ",
                            valueStyle: AppFonts.f50014Black
                                .copyWith(color: Colors.white),
                            alignment: CrossAxisAlignment.center,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        alignment: Alignment.topRight,
                        child: ColumnText(
                          title: "Holding ",
                          titleStyle: AppFonts.f40013
                              .copyWith(color: Config.appTheme.overlay85),
                          value: holdings,
                          valueStyle:
                              AppFonts.f50014Black.copyWith(color: Colors.white),
                          alignment: CrossAxisAlignment.end,
                        ),
                      ))
                    ],
                  ),

                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isLoading
                      ? Utils.shimmerWidget(devHeight, margin: EdgeInsets.all(16))
                      : listCard(),
                  SizedBox(height: 150),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget noData() {
    return Padding(
      padding: EdgeInsets.only(top: devHeight * 0.02, left: devWidth * 0.34),
      child: Column(
        children: [
          Text("No Data Available"),
          SizedBox(height: devHeight * 0.01),
        ],
      ),
    );
  }


  Widget listCard() {
    if (tranxList.isEmpty) return noData();
    return Container(
      color: Config.appTheme.mainBgColor,
      padding: EdgeInsets.only(top: 8),
      child: ListView.builder(
        itemCount: tranxList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          Map data = tranxList[index];
          return transactionCard(data);
        },
      ),
    );
  }

  Widget transactionCard(Map data) {
    String name = data['holdername'];
    String pan = data['holderpan'];
    String mobile = data['mobile'];
    String mod_holding = data['mod_of_holding'];
    String dob = data['dob'];
    String email = data['email'];
    String address = data['address'] + data['city'] + "-" + data['pincode'];
    String taxStatus = data['tax_status'];
    String arn = data['broker_code'];
    String occupation = data['occupation'];
    String lastUpdated = data['updated_date'];
    String bank = data['bank'];
    String accountNumber = data['acnumber'];
    String ifscCode = data['ifsc'];
    String bankBranch = data['branch'];
    String accType = data['account_type'];
    String gurdianName = data['guard_name'];
    String gurdianPan = data['guard_pan'];
    String nomineeName = data['nom1_name'];
    String nomineeRelation = data['nom1_relation'];
    String nomineePerct = data['nom1_percen'];
    String nomineeName1 = data['nom2_name'];
    String nomineeRelation1 = data['nom2_relation'];
    String nomineePerct1 = data['nom2_percen'];
    String nomineeName2 = data['nom3_name'];
    String nomineeRelation2 = data['nom3_relation'];
    String nomineePerct2 = data['nom3_percen'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(5),
              child: Column(
                children: [
                  Row(
                    children: [
                      ColumnText(
                        title: 'Name',
                        value: name,
                        alignment: CrossAxisAlignment.start,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: ColumnText(
                            title: 'PAN',
                            value: pan,
                            alignment: CrossAxisAlignment.start,
                          )),
                      Expanded(
                          flex: 1,
                          child: ColumnText(
                            title: 'Mobile',
                            value: mobile,
                            alignment: CrossAxisAlignment.start,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ColumnText(
                        title: 'Holding Nature',
                        value: mod_holding,
                        alignment: CrossAxisAlignment.start,
                      )),
                      Expanded(
                          child: ColumnText(
                        title: 'DOB',
                        value: dob,
                        alignment: CrossAxisAlignment.start,
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ColumnText(
                        title: 'Email',
                        value: email,
                        alignment: CrossAxisAlignment.start,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
              width: devWidth,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
              padding: EdgeInsets.all(6),
              margin: EdgeInsets.all(6),
              child: Column(
                children: [
                  ColumnText(
                    title: 'Address',
                    value: address,
                    alignment: CrossAxisAlignment.start,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: ColumnText(
                        title: 'Tax Status',
                        value: taxStatus,
                        alignment: CrossAxisAlignment.start,
                      )),
                      Expanded(
                          child: ColumnText(
                        title: 'Occupation',
                        value: occupation,
                        alignment: CrossAxisAlignment.start,
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ColumnText(
                        title: 'ARN Number',
                        value: arn,
                        alignment: CrossAxisAlignment.start,
                      )),
                      Expanded(
                          child: ColumnText(
                        title: 'Last Updated',
                        value: lastUpdated,
                        alignment: CrossAxisAlignment.start,
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(5),
              child: Column(
                children: [
                  Row(
                    children: [
                      ColumnText(
                        title: 'Bank',
                        value: bank,
                        alignment: CrossAxisAlignment.start,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ColumnText(
                        title: 'Account Number',
                        value: accountNumber,
                        alignment: CrossAxisAlignment.start,
                      )),
                      Expanded(
                          child: ColumnText(
                        title: 'IFSC Code',
                        value: ifscCode,
                        alignment: CrossAxisAlignment.start,
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ColumnText(
                        title: 'Branch',
                        value: bankBranch,
                        alignment: CrossAxisAlignment.start,
                      )),
                      Expanded(
                          child: ColumnText(
                              title: 'Account Type',
                              value: accType,
                              alignment: CrossAxisAlignment.start)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            if (gurdianName.isNotEmpty || gurdianPan.isNotEmpty)
              Card(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ColumnText(
                        title: 'Guardian Name',
                        value: gurdianName,
                        alignment: CrossAxisAlignment.start,
                      ),
                      ColumnText(
                        title: 'Guardian PAN',
                        value: gurdianPan,
                        alignment: CrossAxisAlignment.start,
                      ),
                    ],
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (nomineeName.isNotEmpty)
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text('Nominee Details')),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/nominee.png',
                          height: 35,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ColumnText(
                            title: nomineeName,
                            value: nomineeRelation,
                            titleStyle: AppFonts.f50014Black,
                            valueStyle: AppFonts.f40013,
                            alignment: CrossAxisAlignment.start,
                          ),
                        ),
                        Text(
                          "$nomineePerct %",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  if (nomineeName1.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/nominee.png',
                            height: 35,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ColumnText(
                              title: nomineeName1,
                              value: nomineeRelation1,
                              titleStyle: AppFonts.f50014Black,
                              valueStyle: AppFonts.f40013,
                              alignment: CrossAxisAlignment.start,
                            ),
                          ),
                          Text(
                            "$nomineePerct1 %",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  if (nomineeName2.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/nominee.png',
                            height: 35,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ColumnText(
                              title: nomineeName2,
                              value: nomineeRelation2,
                              titleStyle: AppFonts.f50014Black,
                              valueStyle: AppFonts.f40013,
                              alignment: CrossAxisAlignment.start,
                            ),
                          ),
                          Text(
                            "$nomineePerct2 %",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget blackCard() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("Transaction Summary",
                  style: AppFonts.f50014Grey.copyWith(color: Colors.white)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Inflow",
                value: "$rupee ${Utils.formatNumber(450000, isAmount: false)}",
                titleStyle: AppFonts.f40013.copyWith(
                  color: AppColors.lineColor,
                ),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title: "Outflow",
                value: "$rupee ${Utils.formatNumber(450000, isAmount: false)}",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.lineColor),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "Dividend Paid",
                value: "$rupee ${Utils.formatNumber(450000, isAmount: false)}",
                titleStyle: AppFonts.f40013.copyWith(
                  color: AppColors.lineColor,
                ),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
              ColumnText(
                title: "Dividend Reinvest",
                value: "$rupee ${Utils.formatNumber(450000, isAmount: false)}",
                alignment: CrossAxisAlignment.end,
                titleStyle:
                    AppFonts.f40013.copyWith(color: AppColors.lineColor),
                valueStyle: AppFonts.f50014Black.copyWith(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}
