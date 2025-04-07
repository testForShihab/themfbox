import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/advisor/proposal/STP/StpProposalOutput.dart';
import 'package:mymfbox2_0/api/ProposalApi.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/CalculateButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class StpProposalInput extends StatefulWidget {
  const StpProposalInput(
      {super.key,
      required this.invId,
      required this.invName,
      required this.invType});
  final String invName;
  final String invType;
  final int invId;
  @override
  State<StpProposalInput> createState() => _StpProposalInputState();
}

class _StpProposalInputState extends State<StpProposalInput> {
  String client_name = GetStorage().read("client_name");
  int user_id = GetStorage().read("mfd_id");

  num lumpsumAmt = 50000, stpAmt = 50000;
  num invPeriod = 10, stpPeriod = 10;
  num fromReturn = 12.5, toReturn = 12.5;

  String invName = "";
  String invType = "";
  int invId = 0;
  String invPurpose = "";

  ExpansionTileController fromController = ExpansionTileController();
  ExpansionTileController toController = ExpansionTileController();
  ExpansionTileController stpFrequencyController = ExpansionTileController();

  List investorList = [];
  List stpFrequencyList = [
    "weekly",
    "Fortnightly",
    "Monthly",
    "Quarterly",
  ];
  String stpFrequency = "Monthly";

  int page_id = 1;
  String searchKey = "";
  bool isFirst = true;

  String fromQuery = "", toQuery = "";
  List fromSuggestions = [], toSuggestions = [];
  String fromScheme = "", toScheme = "";
  String fromSchemeLogo = "", toSchemeLogo = "";
  @override
  void initState() {
    //  implement initState
    super.initState();
    invName = widget.invName;
    invId = widget.invId;
    invType = widget.invType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "STP Proposal",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            fromSchemeTile(context),
            toSchemeTile(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  AmountInputCard(
                    title: "Lumpsum Amount",
                    initialValue: "50000",
                    isTextTheme: true,
                    suffixText: Utils.formatNumber(lumpsumAmt, isAmount: true),
                    onChange: (val) {
                      lumpsumAmt = num.tryParse(val) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Investment Period",
                    isTextTheme: true,
                    initialValue: "10",
                    suffixText: "Years",
                    onChange: (val) {
                      invPeriod = num.tryParse(val) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  stpFrequencyExpansionTile(context),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "STP Amount",
                    initialValue: "50000",
                    isTextTheme: true,
                    suffixText: Utils.formatNumber(stpAmt, isAmount: true),
                    onChange: (val) {
                      stpAmt = num.tryParse(val) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "STP Period",
                    initialValue: "10",
                    isTextTheme: true,
                    suffixText: "Months",
                    onChange: (val) {
                      stpPeriod = num.tryParse(val) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "From Scheme Return",
                    initialValue: "12.5",
                    isTextTheme: true,
                    suffixText: "%",
                    onChange: (val) {
                      fromReturn = num.tryParse(val) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "To Scheme Return",
                    initialValue: "12.5",
                    isTextTheme: true,
                    suffixText: "%",
                    onChange: (val) {
                      toReturn = num.tryParse(val) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Investment Purpose",
                    initialValue: "Home",
                    isTextTheme: true,
                    suffixText: "",
                    hasSuffix: false,
                    keyboardType: TextInputType.name,
                    borderRadius: BorderRadius.circular(20),
                    onChange: (val) {
                      invPurpose = val;
                      setState(() {});
                    },
                  ),
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
                    bool isValid = validator();
                    if (!isValid) return;

                    Map data = await PropoaslApi
                        .investmentProposalStpPortfolioAnalysis(
                            user_id: invId,
                            from_scheme_name: fromScheme,
                            to_scheme_name: toScheme,
                            lumpsum_amount: lumpsumAmt,
                            stp_amount: stpAmt,
                            from_return: fromReturn,
                            to_return: toReturn,
                            stp_months: stpPeriod,
                            stp_frequency: stpFrequency,
                            investment_period: invPeriod,
                            client_name: client_name);
                    if (data['status'] != 200) {
                      Utils.showError(context, data['msg']);
                      return;
                    }
                    Map result = data['result'];
                    Get.to(() => StpProposalOutput(
                          result: result,
                          userId: user_id,
                          clientName: client_name,
                          name: client_name,
                          horizon: invPeriod,
                          fromScheme: fromScheme,
                          toscheme: toScheme,
                          fromSchemeLogo: fromSchemeLogo,
                          toschemeLogo: toSchemeLogo,
                          lumpsumAmt: lumpsumAmt,
                          stpAmt: stpAmt,
                          stpFromReturn: fromReturn,
                          stpToReturn: toReturn,
                          stpMonths: stpPeriod,
                          stpFrequency: stpFrequency,
                          invPurpose: invPurpose,
                        ));
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

  validator() {
    List l = [
      lumpsumAmt,
      stpAmt,
      fromReturn,
      toReturn,
      stpPeriod,
      stpFrequency,
      invPeriod,
      fromScheme,
      toScheme,
    ];
    if (l.contains(null)) {
      EasyLoading.showError("All Fields are mandatory!");
      return false;
    }
    if (l.contains(0)) {
      EasyLoading.showError("Zero Not Allowed");
      return false;
    }
    if (l.contains("")) {
      EasyLoading.showError("From/To Scheme Cannot be empty");
      return false;
    }

    return true;
  }

  Widget fromSchemeTile(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: fromController,
          title: Text("From Scheme", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fromScheme,
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
                    fromQuery = val;
                    Map data = await PropoaslApi.autoSuggestScheme(
                        user_id: user_id, query: fromQuery,client_name: client_name);
                    fromSuggestions = data['list'];
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      suffixIcon:
                          Icon(Icons.close, color: Config.appTheme.themeColor),
                      contentPadding: EdgeInsets.fromLTRB(10, 2, 12, 2),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ),
            SizedBox(
              height: 350,
              child: ListView.builder(
                itemCount: fromSuggestions.length,
                itemBuilder: (context, index) {
                  Map temp = fromSuggestions[index];
                  String logo = temp['logo'];
                  String name = temp['scheme_amfi_short_name'];

                  return ListTile(
                    onTap: () {
                      fromScheme = name;
                      fromSchemeLogo = logo;
                      fromController.collapse();
                      setState(() {});
                    },
                    // leading: Image.network(logo,height: 32,),
                    leading: Utils.getImage(logo, 32),
                    title: Text(name),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget toSchemeTile(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: toController,
          title: Text("To Scheme", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(toScheme,
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
                    toQuery = val;
                    Map data = await PropoaslApi.autoSuggestScheme(
                        user_id: user_id, query: toQuery,client_name: client_name);
                    toSuggestions = data['list'];
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      suffixIcon:
                          Icon(Icons.close, color: Config.appTheme.themeColor),
                      contentPadding: EdgeInsets.fromLTRB(10, 2, 12, 2),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ),
            SizedBox(
              height: 350,
              child: ListView.builder(
                itemCount: toSuggestions.length,
                itemBuilder: (context, index) {
                  Map temp = toSuggestions[index];
                  String logo = temp['logo'];
                  String name = temp['scheme_amfi_short_name'];

                  return ListTile(
                    onTap: () {
                      toScheme = name;
                      toSchemeLogo = logo;
                      toController.collapse();
                      setState(() {});
                    },
                    //leading: Image.network(logo),
                    leading: Utils.getImage(logo, 32),
                    title: Text(name),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget stpFrequencyExpansionTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: stpFrequencyController,
          title: Text("STP Frequency", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(stpFrequency, style: AppFonts.f50012),
              // DottedLine(),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemCount: stpFrequencyList.length,
              itemBuilder: (context, index) {
                String temp = stpFrequencyList[index];

                return InkWell(
                  onTap: () {
                    stpFrequency = temp;
                    stpFrequencyController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: stpFrequency,
                        onChanged: (value) {
                          stpFrequency = temp;
                          stpFrequencyController.collapse();
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
}
