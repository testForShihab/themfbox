import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/advisor/proposal/LumpsumPlusSIPProposal/LumpsumPlusSipProposalOutput.dart';
import 'package:mymfbox2_0/api/ProposalApi.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class LumpsumPlusSipProposalInput extends StatefulWidget {
  const LumpsumPlusSipProposalInput(
      {super.key,
      required this.invId,
      required this.invName,
      required this.invType});
  final String invName;
  final String invType;
  final int invId;
  @override
  State<LumpsumPlusSipProposalInput> createState() =>
      _LumpsumPlusSipProposalInputState();
}

class _LumpsumPlusSipProposalInputState
    extends State<LumpsumPlusSipProposalInput> {
  int user_id = getUserId();
  String client_name = GetStorage().read("client_name");
  num lumpsum_amount = 1000000;
  num period = 20;
  num sipPeriod = 20;
  String invName = "";
  String invType = "";
  int invId = 0;
  List riskList = [
    "Conservative",
    "Moderately Conservative",
    "Moderate",
    "Moderately Aggressive",
    "Aggressive",
  ];
  String risk = "Aggressive";

  List lumpsumSchemeList = [];
  List sipSchemeList = [];

  ExpansionTileController riskController = ExpansionTileController();

  late double devHeight, devWidth;
  @override
  void initState() {
    //  implement initState
    super.initState();
    invName = widget.invName;
    invId = widget.invId;
    invType = widget.invType;
  }

  num sipAmount = 100000;
  String invPurpose = "";

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Lumpsum + SIP Proposal",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  AmountInputCard(
                    title: "Period",
                    initialValue: "20",
                    isTextTheme: true,
                    suffixText: "Years",
                    onChange: (val) => period = num.tryParse(val) ?? 0,
                  ),
                  SizedBox(height: 16),
                  riskExpansionTile(context),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Investment Purpose",
                    suffixText: "",
                    isTextTheme: true,
                    hasSuffix: false,
                    keyboardType: TextInputType.name,
                    borderRadius: BorderRadius.circular(20),
                    onChange: (val) => invPurpose = val,
                  ),
                  SizedBox(height: 16),
                  lumpsumSchemeList.isEmpty
                      ? lumpsumSchemesBtn()
                      : showLumpsumSchemes(),
                  sipSchemeList.isEmpty ? sipSchemesBtn() : showSipSchemes(),
                  SizedBox(height: 16),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    if (lumpsumSchemeList.isEmpty) {
                      EasyLoading.showError("Please Select Lumpsum scheme");
                      return;
                    }
                    if (sipSchemeList.isEmpty) {
                      EasyLoading.showError("Please Select Sip Scheme");
                      return;
                    }
                    bool isValid = validator();
                    if (!isValid) {
                      EasyLoading.showError("Zero not allowed");
                      return;
                    }

                    List schemeCodeList = [];
                    List schemeAmtList = [];
                    for (var element in lumpsumSchemeList) {
                      schemeCodeList.add(element['scheme_amfi_code']);
                      schemeAmtList.add(element['amount'].round());
                      print("element['amount'] ${element['amount']}");
                    }

                    List schemeSipCodeList = [];
                    List schemeSipAmtList = [];
                    for (var element in sipSchemeList) {
                      schemeSipCodeList.add(element['scheme_amfi_code']);
                      schemeSipAmtList.add(element['amount'].round());
                      print("element['amount'] ${element['amount']}");
                    }

                    String schemeCode = schemeCodeList.join(",");
                    String schemeAmt = schemeAmtList.join(",");

                    String schemeSipCode = schemeSipCodeList.join(",");
                    String schemeSipAmt = schemeSipAmtList.join(",");

                    EasyLoading.show();

                    Map data = await PropoaslApi
                        .investmentProposalLumpsumPortfolioAnalysis(
                            user_id: invId,
                            inv_amount: lumpsum_amount,
                            period: period,
                            risk_profile: risk,
                            scheme_code: schemeCode,
                            amount: schemeAmt,
                            client_name: client_name);
                    Map result = data['proposal'];

                    Map summary = result['summary'];
                    List portfolioAllocation = result['portfolio_allocation'];
                    List amcAllocation = result['amc_allocation'];
                    List assetAllocation = result['broad_category_allocation'];
                    List categoryAllocation = result['category_allocation'];

                    Map dataSip = await PropoaslApi
                        .investmentProposalSipPortfolioAnalysis(
                            user_id: invId,
                            inv_amount: lumpsum_amount,
                            period: sipPeriod,
                            risk_profile: risk,
                            client_name: client_name,
                            scheme_code: schemeSipCode,
                            amount: schemeSipAmt);
                    Map resultSip = dataSip['result'];

                    Map sipSummary = resultSip['summary'];
                    List portfolioSipAllocation =
                        resultSip['portfolio_allocation'];
                    List amcSipAllocation = resultSip['amc_allocation'];
                    List assetSipAllocation =
                        resultSip['broad_category_allocation'];
                    List categorySipAllocation =
                        resultSip['category_allocation'];
                    List sipAllocation = resultSip['sip_example'];

                    EasyLoading.dismiss();
                    print("schemeaAmtttt $schemeAmt");
                    Get.to(() => LumpsumPlusSipProposalOutput(
                        lumpsumNoOfSchemeAmt:
                            '${lumpsumSchemeList.length} ${lumpsumSchemeList.length > 1 ? 'Schemes' : 'Scheme'} (${lumpsumCalculateTotal()})',
                        sipNoOfSchemeAmt:
                            '${sipSchemeList.length} ${lumpsumSchemeList.length > 1 ? 'Schemes' : 'Scheme'} ($rupee ${sipCalculateTotal()})',
                        summary: summary,
                        portfolioAllocation: portfolioAllocation,
                        amcAllocation: amcAllocation,
                        assetAllocation: assetAllocation,
                        categoryAllocation: categoryAllocation,
                        clientName: client_name,
                        invName: invName,
                        invId: invId,
                        userId: user_id,
                        amount: lumpsum_amount,
                        horizon: period,
                        risk: risk,
                        schemeCode: schemeCode,
                        schemeaAmt: schemeAmt,
                        invPurpose: invPurpose,
                        invType: invType,
                        totalInvested: lumpsum_amount * period,
                        sipSummary: sipSummary,
                        portfolioSipAllocation: portfolioSipAllocation,
                        assetSipAllocation: assetSipAllocation,
                        amcSipAllocation: amcSipAllocation,
                        categorySipAllocation: categorySipAllocation,
                        sipAllocation: sipAllocation));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Config.appTheme.themeColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    "CONTINUE",
                    style: AppFonts.f50014Black.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validator() {
    List l = [lumpsum_amount, period];
    if (l.contains(0))
      return false;
    else
      return true;
  }

  Widget riskExpansionTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: riskController,
          title: Text("Risk Profile", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(risk,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Config.appTheme.themeColor)),
              // DottedLine(),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemCount: riskList.length,
              itemBuilder: (context, index) {
                String temp = riskList[index];

                return InkWell(
                  onTap: () {
                    risk = temp;
                    riskController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: risk,
                        onChanged: (value) {
                          risk = temp;
                          riskController.collapse();
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

  Widget lumpsumSchemesBtn() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Lumpsum Schemes", style: AppFonts.f50014Black),
          DottedLine(verticalPadding: 8),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 48),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.readableGrey,
                width: 0.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "No Scheme Added",
                  style: AppFonts.f40013
                      .copyWith(color: Config.appTheme.themeColor),
                ),
                SizedBox(height: 8),
                RpFilledButton(
                  text: "ADD LUMPSUM SCHEMES",
                  padding: EdgeInsets.symmetric(vertical: 14),
                  onPressed: () async {
                    bool isValid = validator();
                    if (!isValid) {
                      EasyLoading.showError("Zero not allowed");
                      return;
                    }
                    EasyLoading.show();
                    Map data =
                        await PropoaslApi.investmentProposalRecommendedSchemes(
                            user_id: "$user_id",
                            amount: 0,
                            period: period,
                            risk_profile: risk,
                            client_name: client_name);

                    lumpsumSchemeList = [];
                    //data['list'];
                    EasyLoading.dismiss();
                    lumpsumAddBottomSheet();
                    setState(() {});
                  },
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sipSchemesBtn() {
    return InkWell(
      onTap: () async {
        bool isValid = validator();
        if (!isValid) {
          EasyLoading.showError("Zero not allowed");
          return;
        }
        EasyLoading.show();
        Map data = await PropoaslApi.investmentProposalRecommendedSchemes(
            user_id: "$user_id",
            amount: lumpsum_amount,
            period: period,
            risk_profile: risk,
            client_name: client_name);

        EasyLoading.dismiss();

        lumpsumSchemeList = data['list'];
        setState(() {});
      },
      borderRadius: BorderRadius.circular(8),
      splashColor: Config.appTheme.themeColor,
      child: Container(
        margin: EdgeInsets.only(top: 16),
        width: devWidth,
        padding: EdgeInsets.all(16.0), // Add padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("SIP Schemes", style: AppFonts.f50014Black),
              ],
            ),
            DottedLine(verticalPadding: 8),
            Container(
              width: devWidth,
              padding: EdgeInsets.all(16.0), // Add padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.readableGrey,
                  width: 0.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "No Scheme Added",
                    style: AppFonts.f40013
                        .copyWith(color: Config.appTheme.themeColor),
                  ),
                  SizedBox(height: 8), // Add some space between the texts
                  RpFilledButton(
                    text: "ADD SIP SCHEMES",
                    padding: EdgeInsets.symmetric(vertical: 14),
                    onPressed: () async {
                      bool isValid = validator();
                      if (!isValid) {
                        EasyLoading.showError("Zero not allowed");
                        return;
                      }
                      EasyLoading.show();
                      Map data = await PropoaslApi
                          .investmentProposalRecommendedSchemes(
                              user_id: "$user_id",
                              amount: 0,
                              period: 0,
                              risk_profile: risk,
                              client_name: client_name);

                      sipSchemeList = []; //data['list'];
                      EasyLoading.dismiss();
                      sipAddBottomSheet();
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showLumpsumSchemes() {
    if (lumpsumSchemeList == null) return SizedBox();
    //if (schemeList!.isEmpty) return emptyCard();

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      width: devWidth,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Lumpsum Schemes", style: AppFonts.f50014Black),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${lumpsumSchemeList.length} Schemes ($rupee ${lumpsumCalculateTotal()})",
                style:
                    AppFonts.f50012.copyWith(color: Config.appTheme.themeColor),
              ),
              InkWell(
                onTap: () {
                  lumpsumAddBottomSheet();
                },
                child: Text(
                  "Add",
                  style: AppFonts.f40013.copyWith(
                      decoration: TextDecoration.underline,
                      color: Colors.black),
                ),
              ),
            ],
          ),
          DottedLine(),
          SizedBox(height: 5),
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: lumpsumSchemeList!.length,
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Map data = lumpsumSchemeList![index];
                String amount = Utils.formatNumber(data['amount']);
                String period = Utils.formatNumber(data['period']);

                return Container(
                  width: devWidth,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.lineColor,
                      )),
                  child: Row(
                    children: [
                      //Image.network("${data['logo']}", height: 32),
                      Utils.getImage("${data['logo']}", 32),
                      SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${data['scheme_amfi_short_name']}"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Lumpsum ($rupee $amount)",
                                  style: AppFonts.f50012.copyWith(
                                      color: Config.appTheme.themeColor),
                                ),
                                InkWell(
                                  onTap: () {
                                    lumpsumEditBottomSheet(data);
                                  },
                                  child: Text(
                                    "Edit",
                                    style: AppFonts.f40013.copyWith(
                                        decoration: TextDecoration.underline,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget showSipSchemes() {
    return Container(
      padding: EdgeInsets.all(16),
      width: devWidth,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("SIP Schemes", style: AppFonts.f50014Black),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${sipSchemeList.length} Schemes ($rupee ${sipCalculateTotal()})",
                style:
                    AppFonts.f50012.copyWith(color: Config.appTheme.themeColor),
              ),
              InkWell(
                onTap: () {
                  sipAddBottomSheet();
                },
                child: Text(
                  "Add",
                  style: AppFonts.f40013.copyWith(
                      decoration: TextDecoration.underline,
                      color: Colors.black),
                ),
              ),
            ],
          ),
          DottedLine(),
          SizedBox(height: 5),
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: sipSchemeList.length,
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Map data = sipSchemeList[index];
                String amount = Utils.formatNumber(data['amount']);
                num period = data['period'] ?? 0;
                String invPurpose = data['invPurpose'] ?? "";

                return Container(
                  width: devWidth,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.lineColor,
                      )),
                  child: Row(
                    children: [
                      //Image.network("${data['logo']}", height: 32),
                      Utils.getImage("${data['logo']}", 32),
                      SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${data['scheme_amfi_short_name']}"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Lumpsum ($rupee $amount)",
                                  style: AppFonts.f50012.copyWith(
                                      color: Config.appTheme.themeColor),
                                ),
                                InkWell(
                                  onTap: () {
                                    sipEditBottomSheet(data);
                                  },
                                  child: Text(
                                    "Edit",
                                    style: AppFonts.f40013.copyWith(
                                        decoration: TextDecoration.underline,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  lumpsumCalculateTotal() {
    num total = 0;
    if (lumpsumSchemeList.isEmpty) return 0;

    for (var element in lumpsumSchemeList) {
      total += element['amount'];
    }

    return Utils.formatNumber(total);
  }

  sipCalculateTotal() {
    num total = 0;
    if (sipSchemeList.isEmpty) return 0;

    for (var element in sipSchemeList) {
      total += element['amount'];
    }

    return Utils.formatNumber(total);
  }

  Widget emptyCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recommended Schemes", style: AppFonts.f50014Black),
          DottedLine(),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.lineColor),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Text("No Schemes Added"),
                ElevatedButton(
                    onPressed: () {
                      sipAddBottomSheet();
                    },
                    child: Text("ADD NEW SCHEME"))
              ],
            ),
          ),
        ],
      ),
    );
  }

  sipAddBottomSheet() async {
    Map choosenScheme = {};
    String query = "";
    List suggestions = [];

    bool isExpanded = false;
    ExpansionTileController schemeController = ExpansionTileController();

    EasyLoading.show();
    Map data =
        await PropoaslApi.autoSuggestScheme(user_id: user_id, query: query,client_name: client_name);
    suggestions = data['list'];
    EasyLoading.dismiss();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return Container(
              height: devHeight * 0.8,
              decoration: BoxDecoration(
                color: Config.appTheme.mainBgColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Add/Edit Schemes", style: AppFonts.f50014Black),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(Icons.close),
                          )
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          controller: schemeController,
                          onExpansionChanged: (val) {
                            isExpanded = val;
                            bottomState(() {});
                          },
                          title:
                              Text("Scheme Name", style: AppFonts.f50014Black),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  choosenScheme['scheme_amfi_short_name'] ?? "",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Config.appTheme.themeColor)),
                              // DottedLine(),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
                              child: SizedBox(
                                height: 40,
                                child: TextFormField(
                                  onChanged: (val) async {
                                    query = val;
                                    Map data =
                                        await PropoaslApi.autoSuggestScheme(
                                            user_id: user_id, query: query,client_name: client_name);
                                    suggestions = data['list'];
                                    bottomState(() {});
                                  },
                                  decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.close,
                                          color: Config.appTheme.themeColor),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(10, 2, 12, 2),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 400,
                              child: ListView.builder(
                                shrinkWrap: true,
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: suggestions.length,
                                itemBuilder: (context, index) {
                                  Map temp = suggestions[index];
                                  String name = temp['scheme_amfi_short_name'];

                                  return ListTile(
                                    onTap: () {
                                      choosenScheme = temp;
                                      schemeController.collapse();
                                      bottomState(() {});
                                    },
                                    //leading: Image.network(temp['logo'], height: 32),
                                    leading: Utils.getImage(temp['logo'], 32),
                                    title: Text(name),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    //lumpsum amount
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: AmountInputCard(
                          title: "SIP Amount",
                          initialValue: "100000",
                          suffixText:
                              Utils.formatNumber(sipAmount, isAmount: true),
                          onChange: (val) {
                            sipAmount = num.tryParse(val) ?? 0;
                            bottomState(() {});
                          }),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: AmountInputCard(
                        title: "SIP Period",
                        initialValue: "10",
                        suffixText: "Years",
                        onChange: (val) {
                          sipPeriod = num.tryParse(val) ?? 0;
                          bottomState(() {});
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: AmountInputCard(
                        title: "SIP Investment Purpose",
                        initialValue: "",
                        suffixText: "Home",
                        hasSuffix: false,
                        keyboardType: TextInputType.name,
                        borderRadius: BorderRadius.circular(20),
                        onChange: (val) {
                          print("invPurpose $val");
                          invPurpose = val;
                          bottomState(() {});
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Visibility(
                      visible: !isExpanded,
                      child: CalculateButton(
                        text: "SUBMIT",
                        onPress: () {
                          if (choosenScheme.isEmpty) {
                            Utils.showError(
                                context, "please select the Scheme Name");
                            return;
                          }
                          choosenScheme['amount'] = sipAmount;
                          choosenScheme['period'] = sipPeriod;
                          choosenScheme['invPurpose'] = invPurpose;
                          sipSchemeList.add(choosenScheme);
                          print("sipschemelist $sipSchemeList");
                          Get.back();
                          setState(() {});
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  lumpsumAddBottomSheet() async {
    Map choosenScheme = {};
    String query = "";
    List suggestions = [];
    num lumpsumAmount = 100000;
    bool isExpanded = false;
    ExpansionTileController schemeController = ExpansionTileController();

    EasyLoading.show();
    Map data =
        await PropoaslApi.autoSuggestScheme(user_id: user_id, query: query,client_name: client_name);
    suggestions = data['list'];
    EasyLoading.dismiss();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return Container(
              height: devHeight * 0.6,
              decoration: BoxDecoration(
                color: Config.appTheme.mainBgColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10)),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Add/Edit Schemes",
                                style: AppFonts.f50014Black),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(Icons.close),
                            )
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            controller: schemeController,
                            onExpansionChanged: (val) {
                              isExpanded = val;
                              bottomState(() {});
                            },
                            title: Text("Scheme Name",
                                style: AppFonts.f50014Black),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    choosenScheme['scheme_amfi_short_name'] ??
                                        "",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: Config.appTheme.themeColor)),
                                // DottedLine(),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
                                child: SizedBox(
                                  height: 40,
                                  child: TextFormField(
                                    onChanged: (val) async {
                                      query = val;
                                      Map data =
                                          await PropoaslApi.autoSuggestScheme(
                                              user_id: user_id, query: query,client_name: client_name);
                                      suggestions = data['list'];
                                      bottomState(() {});
                                    },
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.close,
                                            color: Config.appTheme.themeColor),
                                        contentPadding:
                                            EdgeInsets.fromLTRB(10, 2, 12, 2),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 340,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  // physics: NeverScrollableScrollPhysics(),
                                  itemCount: suggestions.length,
                                  itemBuilder: (context, index) {
                                    Map temp = suggestions[index];
                                    String name =
                                        temp['scheme_amfi_short_name'];

                                    return ListTile(
                                      onTap: () {
                                        choosenScheme = temp;
                                        schemeController.collapse();
                                        bottomState(() {});
                                      },
                                      //leading: Image.network(temp['logo'], height: 32),
                                      leading: Utils.getImage(temp['logo'], 32),
                                      title: Text(name),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //lumpsum amount
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: AmountInputCard(
                            title: "Lumpsum Amount",
                            initialValue: "100000",
                            suffixText: Utils.formatNumber(lumpsumAmount,
                                isAmount: true),
                            onChange: (val) {
                              lumpsumAmount = num.tryParse(val) ?? 0;
                              bottomState(() {});
                            }),
                      ),

                      SizedBox(height: 16),

                      // Visibility(
                      //   visible: !isExpanded,
                      //   child: CalculateButton(
                      //     text: "SUBMIT",
                      //     onPress: () {
                      //       if (choosenScheme.isEmpty) {
                      //         Utils.showError(
                      //             context, "please select the Scheme Name");
                      //         return;
                      //       }
                      //       print("choosenScheme $choosenScheme");
                      //       choosenScheme['amount'] = lumpsum_amount;
                      //       schemeList!.add(choosenScheme);
                      //       islumpsumVisible = false;
                      //       Get.back();
                      //       setState(() {});
                      //     },
                      //   ),
                      // )
                      Visibility(
                        visible: !isExpanded,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (choosenScheme.isEmpty) {
                                  Utils.showError(
                                      context, "please select the Scheme Name");
                                  return;
                                }
                                print("choosenScheme $choosenScheme");
                                choosenScheme['amount'] = lumpsumAmount;
                                lumpsumSchemeList!.add(choosenScheme);

                                Get.back();
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: Config.appTheme.themeColor,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                "Submit",
                                style: AppFonts.f50014Black
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  lumpsumEditBottomSheet(Map scheme) async {
    Map choosenScheme = scheme;
    String name = choosenScheme['scheme_amfi_short_name'];
    String query = name;
    TextEditingController queryController = TextEditingController(text: name);
    List suggestions = [];
    num amount = choosenScheme['amount'];
    bool isExpanded = false;
    ExpansionTileController schemeController = ExpansionTileController();

    EasyLoading.show();
    Map data =
        await PropoaslApi.autoSuggestScheme(user_id: user_id, query: query,client_name: client_name);
    suggestions = data['list'];
    EasyLoading.dismiss();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return Container(
              height: devHeight * 0.6,
              decoration: BoxDecoration(
                color: Config.appTheme.mainBgColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //top close button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Add/Edit Schemes", style: AppFonts.f50014Black),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(Icons.close),
                          )
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          controller: schemeController,
                          onExpansionChanged: (val) {
                            isExpanded = val;
                            bottomState(() {});
                          },
                          title:
                              Text("Scheme Name", style: AppFonts.f50014Black),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Config.appTheme.themeColor)),
                              // DottedLine(),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
                              child: SizedBox(
                                height: 40,
                                child: TextFormField(
                                  controller: queryController,
                                  onChanged: (val) async {
                                    query = val;
                                    Map data =
                                        await PropoaslApi.autoSuggestScheme(
                                            user_id: user_id, query: query,client_name: client_name);
                                    suggestions = data['list'];
                                    bottomState(() {});
                                  },
                                  decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                          onTap: () async {
                                            queryController.clear();
                                            query = "";
                                            Map data = await PropoaslApi
                                                .autoSuggestScheme(
                                                    user_id: user_id,
                                                    query: query,client_name: client_name);
                                            suggestions = data['list'];
                                            bottomState(() {});
                                          },
                                          child: Icon(Icons.close,
                                              color:
                                                  Config.appTheme.themeColor)),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(10, 2, 12, 2),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 300,
                              child: ListView.builder(
                                shrinkWrap: true,
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: suggestions.length,
                                itemBuilder: (context, index) {
                                  Map temp = suggestions[index];
                                  String name = temp['scheme_amfi_short_name'];

                                  return ListTile(
                                    onTap: () {
                                      choosenScheme = temp;
                                      schemeController.collapse();
                                      bottomState(() {});
                                    },
                                    // leading: Image.network(temp['logo'], height: 32),
                                    leading: Utils.getImage(temp['logo'], 32),
                                    title: Text(name),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    //lumpsum amount
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: AmountInputCard(
                          title: "Lumpsum Amount",
                          initialValue: "$amount",
                          suffixText:
                              Utils.formatNumber(amount, isAmount: true),
                          onChange: (val) {
                            amount = num.tryParse(val) ?? 0;
                            bottomState(() {});
                          }),
                    ),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        lumpsumSchemeList!.remove(scheme);
                        Get.back();
                        setState(() {});
                      },
                      child: Text(
                        "Delete Scheme",
                        style: AppFonts.f50012.copyWith(
                            color: Colors.red,
                            decoration: TextDecoration.underline),
                      ),
                    ),

                    SizedBox(height: 50),
                    Visibility(
                      visible: !isExpanded,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (choosenScheme.isEmpty) {
                                Utils.showError(
                                    context, "please select the Scheme Name");
                                return;
                              }
                              choosenScheme['amount'] = amount;
                              lumpsumSchemeList!.removeWhere((element) =>
                                  element['scheme_amfi_code'] ==
                                  scheme['scheme_amfi_code']);
                              lumpsumSchemeList!.add(choosenScheme);
                              Get.back();
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: Config.appTheme.themeColor,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              "CONTINUE",
                              style: AppFonts.f50014Black
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  sipEditBottomSheet(Map scheme) async {
    Map choosenScheme = scheme;
    String name = choosenScheme['scheme_amfi_short_name'];
    String query = name;
    TextEditingController queryController = TextEditingController(text: name);
    List suggestions = [];
    num amount = choosenScheme['amount'];
    num period = choosenScheme['period'];
    String invPurpose = choosenScheme['invPurpose'];
    bool isExpanded = false;
    ExpansionTileController schemeController = ExpansionTileController();

    EasyLoading.show();
    Map data =
        await PropoaslApi.autoSuggestScheme(user_id: user_id, query: query,client_name: client_name);
    suggestions = data['list'];
    EasyLoading.dismiss();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return Container(
              height: devHeight * 0.84,
              decoration: BoxDecoration(
                color: Config.appTheme.mainBgColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //top close button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Add/Edit Schemes", style: AppFonts.f50014Black),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(Icons.close),
                          )
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          controller: schemeController,
                          onExpansionChanged: (val) {
                            isExpanded = val;
                            bottomState(() {});
                          },
                          title:
                              Text("Scheme Name", style: AppFonts.f50014Black),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: Config.appTheme.themeColor)),
                              // DottedLine(),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
                              child: SizedBox(
                                height: 40,
                                child: TextFormField(
                                  controller: queryController,
                                  onChanged: (val) async {
                                    query = val;
                                    Map data =
                                        await PropoaslApi.autoSuggestScheme(
                                            user_id: user_id, query: query,client_name: client_name);
                                    suggestions = data['list'];
                                    bottomState(() {});
                                  },
                                  decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                          onTap: () async {
                                            print("test");
                                            queryController.clear();
                                            query = "";
                                            Map data = await PropoaslApi
                                                .autoSuggestScheme(
                                                    user_id: user_id,
                                                    query: query,client_name:client_name);
                                            suggestions = data['list'];
                                            bottomState(() {});
                                          },
                                          child: Icon(Icons.close,
                                              color:
                                                  Config.appTheme.themeColor)),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(10, 2, 12, 2),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 300,
                              child: ListView.builder(
                                shrinkWrap: true,
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: suggestions.length,
                                itemBuilder: (context, index) {
                                  Map temp = suggestions[index];
                                  String name = temp['scheme_amfi_short_name'];

                                  return ListTile(
                                    onTap: () {
                                      choosenScheme = temp;
                                      schemeController.collapse();
                                      bottomState(() {});
                                    },
                                    // leading: Image.network(temp['logo'], height: 32),
                                    leading: Utils.getImage(temp['logo'], 32),
                                    title: Text(name),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: AmountInputCard(
                          title: "Sip Amount",
                          initialValue: "$amount",
                          isTextTheme: true,
                          suffixText:
                              Utils.formatNumber(amount, isAmount: true),
                          onChange: (val) {
                            amount = num.tryParse(val) ?? 0;
                            bottomState(() {});
                          }),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: AmountInputCard(
                        title: "SIP Period",
                        initialValue: "$period",
                        suffixText: "Years",
                        onChange: (val) {
                          sipPeriod = num.tryParse(val) ?? 0;
                          setState(() {});
                          bottomState(() {});
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: AmountInputCard(
                        title: "SIP Investment Purpose",
                        initialValue: invPurpose,
                        suffixText: invPurpose,
                        hasSuffix: false,
                        keyboardType: TextInputType.name,
                        borderRadius: BorderRadius.circular(20),
                        onChange: (val) {
                          invPurpose = val;
                          bottomState(() {});
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        sipSchemeList.remove(scheme);
                        Get.back();
                        setState(() {});
                      },
                      child: Text(
                        "Delete Scheme",
                        style: AppFonts.f50012.copyWith(
                            color: Colors.red,
                            decoration: TextDecoration.underline),
                      ),
                    ),

                    SizedBox(height: 16),
                    Visibility(
                      visible: !isExpanded,
                      child: CalculateButton(
                        text: "SUBMIT",
                        onPress: () {
                          if (choosenScheme.isEmpty) {
                            Utils.showError(
                                context, "please select the Scheme Name");
                            return;
                          }
                          choosenScheme['amount'] = amount;
                          choosenScheme['period'] = sipPeriod;
                          choosenScheme['invPurpose'] = invPurpose;
                          sipSchemeList.removeWhere((element) =>
                              element['scheme_amfi_code'] ==
                              scheme['scheme_amfi_code']);
                          sipSchemeList.add(choosenScheme);
                          Get.back();
                          setState(() {});
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
