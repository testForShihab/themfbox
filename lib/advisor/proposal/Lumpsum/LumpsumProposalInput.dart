import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/advisor/proposal/Lumpsum/LumpsumProposalOutput.dart';
import 'package:mymfbox2_0/api/ProposalApi.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class LumpsumProposalInput extends StatefulWidget {
  const LumpsumProposalInput(
      {super.key,
      required this.invId,
      required this.invName,
      required this.invType});
  final String invName;
  final String invType;
  final int invId;
  @override
  State<LumpsumProposalInput> createState() => _LumpsumProposalInputState();
}

class _LumpsumProposalInputState extends State<LumpsumProposalInput> {
  int user_id = GetStorage().read("mfd_id");
  String client_name = GetStorage().read("client_name");

  num lumpsum_amount = 1000000;
  num period = 20;
  String invName = "";
  String invType = "";
  String invPurpose = "";
  int invId = 0;

  List riskList = [
    "Conservative",
    "Moderately Conservative",
    "Moderate",
    "Moderately Aggressive",
    "Aggressive",
  ];

  List expectedReturn = [
    "Standard Expected Returns",
    "Custom Expected Returns",
  ];

  String risk = "Aggressive";
  String expReturn = "Custom Expected Returns";

  List? schemeList;

  ExpansionTileController riskController = ExpansionTileController();
  ExpansionTileController expReturnController = ExpansionTileController();

  late double devHeight, devWidth;

  @override
  void initState() {
    //  implement initState
    super.initState();
    invName = widget.invName;
    invType = widget.invType;
    invId = widget.invId;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "Lumpsum Proposal",
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
                    title: "Lumpsum Amount",
                    initialValue: "1000000",
                    isTextTheme: true,
                    suffixText:
                        Utils.formatNumber(lumpsum_amount, isAmount: true),
                    onChange: (val) async {
                      lumpsum_amount = num.tryParse(val) ?? 0;
                      schemeList = [];

                      EasyLoading.show();

                      Map data = await PropoaslApi
                          .investmentProposalRecommendedSchemes(
                              user_id: "$user_id",
                              amount: lumpsum_amount,
                              period: period,
                              client_name: client_name,
                              risk_profile: risk);

                      EasyLoading.dismiss();

                      schemeList = data['list'];

                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Period",
                    initialValue: "20",
                    isTextTheme: true,
                    suffixText: "Years",
                    onChange: (val) {
                      period = num.tryParse(val) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  riskExpansionTile(context),
                  SizedBox(height: 16),
                  expectedReturnTile(context),
                  SizedBox(height: 16,),
                  AmountInputCard(
                    title: "Investment Purpose",
                    suffixText: "",
                    isTextTheme: true,
                    hasSuffix: false,
                    keyboardType: TextInputType.name,
                    borderRadius: BorderRadius.circular(20),
                    onChange: (val) {
                      invPurpose = val;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  recommendBtn(),
                  SizedBox(height: 16),
                  // emptyCard(),
                  schemeArea(),
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
                    if (schemeList == null) {
                      EasyLoading.showError("No schemes selected");
                      return;
                    }
                    bool isValid = validator();
                    if (!isValid) {
                      EasyLoading.showError("Zero not allowed");
                      return;
                    }

                    List schemeCodeList = [];
                    List schemeAmtList = [];
                    for (var element in schemeList!) {
                      schemeCodeList.add(element['scheme_amfi_code']);
                      double amount =
                          double.parse(element['amount'].toString());
                      num roundedAmount = amount.round();
                      schemeAmtList.add(roundedAmount);
                    }
                    String schemeCode = schemeCodeList.join(",");
                    String schemeaAmt = schemeAmtList.join(",");

                    Map data = await PropoaslApi
                        .investmentProposalLumpsumPortfolioAnalysis(
                            user_id: invId,
                            inv_amount: lumpsum_amount,
                            period: period,
                            risk_profile: risk,
                            scheme_code: schemeCode,
                            amount: schemeaAmt,
                            client_name: client_name);

                    Map result = data['proposal'] ?? {};
                    Map summary = {};
                    List portfolioAllocation = [];
                    List amcAllocation = [];
                    List assetAllocation = [];
                    List categoryAllocation = [];
                    print("result $result");
                    if (result.isNotEmpty) {
                      summary = result['summary'];
                      portfolioAllocation = result['portfolio_allocation'];
                      amcAllocation = result['amc_allocation'];
                      assetAllocation = result['broad_category_allocation'];
                      categoryAllocation = result['category_allocation'];
                    }
                    EasyLoading.dismiss();

                    Get.to(() => LumpsumProposalOutput(
                        noOfSchemeAmt:
                            "${schemeList!.length} Schemes ($rupee ${calculateTotal()})",
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
                        schemeaAmt: schemeaAmt,
                        invPurpose: invPurpose,
                        invType: invType));
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
          title: Text("Select Investment Options", style: AppFonts.f50014Black),
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

  Widget expectedReturnTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: expReturnController,
          title: Text("Select Expected Returns", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(expReturn,
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
              itemCount: expectedReturn.length,
              itemBuilder: (context, index) {
                String temp = expectedReturn[index];

                return InkWell(
                  onTap: () {
                    expReturn = temp;
                    expReturnController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: expReturn,
                        onChanged: (value) {
                          expReturn = temp;
                          expReturnController.collapse();
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

  Widget recommendBtn() {
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
            client_name: client_name,
            risk_profile: risk);

        EasyLoading.dismiss();

        schemeList = data['list'];

        setState(() {});
      },
      borderRadius: BorderRadius.circular(8),
      splashColor: Config.appTheme.themeColor,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            border: Border.all(color: Config.appTheme.themeColor),
            borderRadius: BorderRadius.circular(8)),
        child: Text(
          "GET RECOMMENDED SCHEMES",
          style:
              AppFonts.f50014Grey.copyWith(color: Config.appTheme.themeColor),
        ),
      ),
    );
  }

  Widget schemeArea() {
    if (schemeList == null) return SizedBox();
    if (schemeList!.isEmpty) return emptyCard();

    return Container(
      padding: EdgeInsets.all(16),
      width: devWidth,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recommended Schemes", style: AppFonts.f50014Black),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${schemeList!.length} Schemes ($rupee ${calculateTotal()})",
                style:
                    AppFonts.f50012.copyWith(color: Config.appTheme.themeColor),
              ),
              InkWell(
                onTap: () {
                  addBottomSheet();
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
              itemCount: schemeList!.length,
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              // physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Map data = schemeList![index];
                String amount = Utils.formatNumber(data['amount']);

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
                      // Image.network("${data['logo']}", height: 32),
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
                                  "Lumpsum ($rupee $amount) (${data['percentage']}%)",
                                  style: AppFonts.f50012.copyWith(
                                      color: Config.appTheme.themeColor),
                                ),
                                InkWell(
                                  onTap: () {
                                    editBottomSheet(data);
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

  calculateTotal() {
    num total = 0;
    if (schemeList == null) return 0;

    schemeList!.forEach((element) {
      total += element['amount'];
    });

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
                ElevatedButton(onPressed: () {}, child: Text("ADD NEW SCHEME"))
              ],
            ),
          ),
        ],
      ),
    );
  }

  addBottomSheet() async {
    Map choosenScheme = {};
    String query = "";
    List suggestions = [];
    num lumpsum_amount = 0;
    bool isExpanded = false;
    ExpansionTileController schemeController = ExpansionTileController();

    TextEditingController queryController = TextEditingController();
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
              height: devHeight * 0.9,
              decoration: BoxDecoration(
                color: Config.appTheme.mainBgColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Column(
                children: [
                  //top close button
                  BottomSheetTitle(title: "Add/Edit Scheme"),

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
                        title: Text("Scheme Name", style: AppFonts.f50014Black),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(choosenScheme['scheme_amfi_short_name'] ?? "",
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
                                        onTap: () {
                                          queryController.clear();
                                          query = "";
                                        },
                                        child: Icon(Icons.close,
                                            color: Config.appTheme.themeColor)),
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
                        title: "Lumpsum Amount",
                        isTextTheme: true,
                        suffixText:
                            Utils.formatNumber(lumpsum_amount, isAmount: true),
                        onChange: (val) {
                          lumpsum_amount = num.tryParse(val) ?? 0;

                          bottomState(() {});
                        }),
                  ),

                  Spacer(),

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
                            choosenScheme['amount'] = lumpsum_amount;
                            schemeList!.add(choosenScheme);
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
                            "SUBMIT",
                            style: AppFonts.f50014Black
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  editBottomSheet(Map scheme) async {
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
              height: devHeight * 0.9,
              decoration: BoxDecoration(
                color: Config.appTheme.mainBgColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
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
                        title: Text("Scheme Name", style: AppFonts.f50014Black),
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
                                        onTap: () {
                                          queryController.clear();
                                          query = "";
                                        },
                                        child: Icon(Icons.close,
                                            color: Config.appTheme.themeColor)),
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
                        title: "Lumpsum Amount",
                        isTextTheme: true,
                        initialValue: "$amount",
                        suffixText: Utils.formatNumber(amount, isAmount: true),
                        onChange: (val) {
                          amount = num.tryParse(val) ?? 0;

                          bottomState(() {});
                        }),
                  ),
                  SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      schemeList!.remove(scheme);
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

                  Spacer(),

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
                            choosenScheme['amount'] = amount;
                            schemeList!.removeWhere((element) =>
                                element['scheme_amfi_code'] ==
                                scheme['scheme_amfi_code']);
                            schemeList!.add(choosenScheme);
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
                            "SUBMIT",
                            style: AppFonts.f50014Black
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
