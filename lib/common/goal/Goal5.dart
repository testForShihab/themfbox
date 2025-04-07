import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Registration/ChoosePlatform.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/MyCart.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/SipCart.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/Investor/Transact/lumpsum/NewLumpsumTransaction.dart';
import 'package:mymfbox2_0/api/GoalsApi.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/api/ReportApi.dart';
import 'package:mymfbox2_0/common/goal/Goal5.types.dart';
import 'package:mymfbox2_0/pojo/UserDataPojo.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class Goal5 extends StatefulWidget {
  const Goal5({
    super.key,
    required this.sipAmount,
    required this.risk,
    required this.years,
    required this.mobile,
    required this.age,
    required this.targetAmount,
  });

  final num sipAmount;
  final String risk;
  final String years;
  final String mobile;
  final String age;
  final double targetAmount;

  @override
  State<Goal5> createState() => _Goal5State();
}

class _Goal5State extends State<Goal5> {
  late double devHeight, devWidth;
  String client_name = GetStorage().read("client_name");
  int user_id = GetStorage().read("user_id");

  List suggestedSchemes = [], selectedSchemeNames = [];
  bool isFirst = true;
  UserDataPojo userDataPojo = UserDataPojo();
  bool isLoading = true, selectAll = true;

  Future getUser() async {
    Map data =
        await InvestorApi.getUser(user_id: user_id, client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    Map<String, dynamic> user = data['user'];
    userDataPojo = UserDataPojo.fromJson(user);

    return 0;
  }

  Future getGoalSuggestedScheme() async {
    isLoading = true;
    Map data = await GoalsApi.getGoalSuggestedSchemes(
        sip_amount: widget.sipAmount,
        risk: widget.risk,
        years: widget.years,
        mobile: widget.mobile,
        age: widget.age,
        client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      isLoading = false;
      return -1;
    }

    suggestedSchemes = data['goal_scheme_list'];
    suggestedSchemes.forEach((element) {
      element['sip_date'] = DateTime.now().add(Duration(days: 7));
    });
    isLoading = false;
    selectAllSchemes();

    return 0;
  }

  List clientCodeList = [];
  Future getInvestorClientCode() async {
    if (clientCodeList.isNotEmpty) return 0;

    EasyLoading.show();

    Map data = await ReportApi.getInvestorCode(
        user_id: user_id, client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    clientCodeList = data['client_code_list'];

    EasyLoading.dismiss();

    return 0;
  }

  Future getDatas() async {
    if (!isFirst) return 0;

    await getUser();
    await getGoalSuggestedScheme();

    isFirst = false;

    return 0;
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
            appBar: invAppBar(title: "Recommended Funds"),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  color: Config.appTheme.themeColor25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ColumnText(
                          title: "Target Amount",
                          value:
                              "$rupee ${Utils.formatNumber(widget.targetAmount)}",
                          alignment: CrossAxisAlignment.start),
                      ColumnText(
                        title: "Total Schemes",
                        value: "${suggestedSchemes.length}",
                        alignment: CrossAxisAlignment.end,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 16),
                  child: Row(
                    children: [
                      Checkbox(
                          value: selectAll,
                          onChanged: (val) {
                            selectAll = val!;
                            if (val) {
                              selectedSchemeNames.clear();
                              selectAllSchemes();
                            } else {
                              selectedSchemeNames.clear();
                            }
                            setState(() {});
                          }),
                      Expanded(
                          child:
                              Text("Select All", style: AppFonts.f50014Theme)),
                      Text("Selected Schemes : ${selectedSchemeNames.length}",
                          style: AppFonts.f50014Theme),
                    ],
                  ),
                ),
                Expanded(
                  child: (isLoading)
                      ? Utils.shimmerWidget(devHeight)
                      : ListView.builder(
                          itemCount: suggestedSchemes.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> temp = suggestedSchemes[index];
                            SchemePojo scheme = SchemePojo.fromJson(temp);
                            return schemeCard(scheme, index);
                          },
                        ),
                ),
                CalculateButton(
                    onPress: () async {
                      if (selectedSchemeNames.isEmpty) {
                        Utils.showError(
                            context, "Please select at least one scheme");
                        return;
                      }
                      List cartList = [];
                      selectedSchemeNames.forEach((e1) {
                        Map temp = suggestedSchemes.firstWhere(
                          (element) => element['scheme_name'] == e1,
                        );
                        DateTime startDate = temp['sip_date'];

                        DateTime now = DateTime.now();
                        DateTime endDate =
                            DateTime(now.year + 30, now.month, now.day);
                        String marketType =
                            userDataPojo.bseNseMfu ?? "api null";

                        CartSchemePojo pojo = CartSchemePojo(
                          schemeName: temp['scheme_name'],
                          schemeReinvestTag:
                              (marketType.contains('mfu')) ? 'N' : 'Z',
                          amount: temp['allocation_amount'],
                          sipDate: temp['sip_date'].day.toString(),
                          startDate: convertDtToStr(startDate),
                          endDate: convertDtToStr(endDate),
                          installment: marketType == "bse" ? "360" : "",
                          sipTenure: marketType == "bse" ? "Perpetual" : "",
                        );
                        cartList.add(pojo);
                      });
                      List temp = [];
                      cartList.forEach((element) {
                        temp.add(element.toJson());
                      });
                      Map reqBody = {"list": temp};

                      await getInvestorClientCode();
                      clientCodeBottomSheet(reqBody, context);
                    },
                    text: "START INVESTING"),
              ],
            ),
          );
        });
  }

  void selectAllSchemes() {
    for (var element in suggestedSchemes) {
      selectedSchemeNames.add(element['scheme_name']);
    }
  }

  void clientCodeBottomSheet(Map reqBody, BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: cornerBorder),
      backgroundColor: Config.appTheme.mainBgColor,
      builder: (BuildContext bottomContext) {
        return Column(
          children: [
            BottomSheetTitle(
              title: "Select Investor Code",
            ),
            SizedBox(height: 16),
            clientCodeList.isEmpty
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
                : Expanded(
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
                              if (arn.isEmpty) {
                                Utils.showError(context,
                                    "ARN not found. Please contact your advisor");
                                return;
                              }
                              await GetStorage().write('client_code_map', data);
                              Get.back();

                              Map res = await GoalsApi.saveSipCartByUserId(
                                  client_code_map: data,
                                  user_id: user_id,
                                  client_name: client_name,
                                  body: reqBody);

                              if (res['status'] != 200) {
                                Utils.showError(Get.context, "${res['msg']}");
                                return;
                              }
                              Get.to(() => MyCart(
                                    defaultPage: SipCart(),
                                    defaultTitle: "SIP",
                                  ));
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

  Widget schemeCard(SchemePojo scheme, int index) {
    DateTime sipDate = scheme.sip_date;
    double bottomMargin = index == suggestedSchemes.length - 1 ? 16.0 : 0.0;
    double topMargin = index == 0 ? 0 : 16;

    return Container(
      margin: EdgeInsets.only(
          left: 16, right: 16, top: topMargin, bottom: bottomMargin),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 18,
                width: 18,
                child: Checkbox(
                    value: selectedSchemeNames.contains(scheme.scheme_name),
                    onChanged: (val) {
                      if (val!) {
                        selectedSchemeNames.add(scheme.scheme_name);
                      } else {
                        selectAll = false;
                        selectedSchemeNames.remove(scheme.scheme_name);
                      }
                      setState(() {});
                    }),
              ),
              SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (selectedSchemeNames.contains(scheme.scheme_name)) {
                      selectedSchemeNames.remove(scheme.scheme_name);
                    } else {
                      selectedSchemeNames.add(scheme.scheme_name);
                    }
                    setState(() {});
                  },
                  child: Text(
                    scheme.scheme_name,
                    style: AppFonts.f50014Black,
                  ),
                ),
              ),
              PopupMenuButton<int>(
                onSelected: (value) async {
                  if (value == 1) {
                    // Handle Amount
                    String amount = "";
                    Get.defaultDialog(
                      title: "Edit Amount",
                      content: Column(
                        children: [
                          TextFormField(
                            initialValue: scheme.allocation_amount.toString(),
                            onChanged: (val) => amount = val,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Amount",
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (num.parse(amount) < scheme.minAmount) {
                                Utils.showError(context,
                                    "Minimum amount should be ${scheme.minAmount}");
                                return;
                              }
                              Get.back();
                              suggestedSchemes[index]['allocation_amount'] =
                                  num.parse(amount);
                            },
                            child: Text("Save"),
                          )
                        ],
                      ),
                    );
                  } else if (value == 2) {
                    // Handle Date
                    DateTime? res = await showDatePicker(
                      context: context,
                      initialDate: scheme.sip_date,
                      firstDate: DateTime.now().add(Duration(days: 7)),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (res != null) {
                      if (!scheme.availableDates.contains("${res.day}")) {
                        Utils.showError(context,
                            "Allowed dates are ${scheme.availableDates}");
                        return;
                      }
                      suggestedSchemes[index]['sip_date'] = res;
                      setState(() {});
                    }
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text("Edit Amount"),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text("Edit Date"),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                title: "SIP Amount",
                value: "$rupee ${Utils.formatNumber(scheme.allocation_amount)}",
              ),
              ColumnText(
                title: "SIP Date",
                value: "${sipDate.day}/${sipDate.month}/${sipDate.year}",
                alignment: CrossAxisAlignment.end,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SchemePojo {
  String scheme_name;
  num allocation_amount;
  DateTime sip_date;
  num minAmount;
  List availableDates;

  SchemePojo({
    required this.scheme_name,
    required this.allocation_amount,
    required this.sip_date,
    required this.minAmount,
    required this.availableDates,
  });

  factory SchemePojo.fromJson(Map<String, dynamic> json) {
    return SchemePojo(
      scheme_name: json['scheme_name'],
      allocation_amount: json['allocation_amount'],
      sip_date: json['sip_date'],
      minAmount: json['sip_min_amount'],
      availableDates: json['sip_dates'].split(","),
    );
  }

  toJson() {
    return {
      'scheme_name': scheme_name,
      'allocation_amount': allocation_amount,
      'sip_date': sip_date,
      'sip_min_amount': minAmount,
      'sip_dates': availableDates.join(","),
    };
  }
}
