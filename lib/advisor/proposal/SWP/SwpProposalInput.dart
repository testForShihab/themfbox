import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/advisor/proposal/SWP/SwpProposalOutput.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import '../../../api/ProposalApi.dart';

class SwpProposalInput extends StatefulWidget {
  const SwpProposalInput(
      {super.key, required this.invId, required this.invName});
  final String invName;
  final int invId;
  @override
  State<SwpProposalInput> createState() => _SwpProposalInputState();
}

class _SwpProposalInputState extends State<SwpProposalInput> {
  String client_name = GetStorage().read("client_name");
  int user_id = GetStorage().read("mfd_id");

  num lumpsumAmount = 0;
  num period = 0;
  num expectedReturn = 0;
  String investmentPurpose = "";
  num swpAmount = 0;

  List invTypeList = ["Search and Select Scheme"];
  String invType = "Search and Select Scheme";

  ExpansionTileController typeController = ExpansionTileController();
  ExpansionTileController nameController = ExpansionTileController();
  ExpansionTileController stpFrequencyController = ExpansionTileController();

  ExpansionTileController schemeController = ExpansionTileController();
  String schemeName = "Search and Select Scheme", schemeLogo = "";
  String query = "";
  List schemeSuggestions = [];

  List investorList = [];
  List swpFrequencyList = [
    "weekly",
    "Fortnightly",
    "Monthly",
    "Quarterly",
  ];
  String swpFrequency = "Monthly";

  DateTime? lumpsumDate;
  TextEditingController lumpsumController = TextEditingController();

  DateTime? swpStartDate;
  TextEditingController swpStartController = TextEditingController();

  DateTime? swpEndDate;
  TextEditingController swpEndController = TextEditingController();
  String invName = "";
  int invId = 0;
  String invPurpose = "";
  @override
  void initState() {
    //  implement initState
    super.initState();
    invName = widget.invName;
    invId = widget.invId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "SWP Proposal",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            schemeNameTile(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  AmountInputCard(
                    title: "Lumpsum Amount",
                    isTextTheme: true,
                    suffixText:
                        Utils.formatNumber(lumpsumAmount, isAmount: true),
                    onChange: (val) {
                      lumpsumAmount = num.tryParse(val) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Period",
                    suffixText: "Years",
                    isTextTheme: true,
                    onChange: (val) {
                      period = num.tryParse(val) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  stpFrequencyExpansionTile(context),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "SWP Amount",
                    isTextTheme: true,
                    suffixText: Utils.formatNumber(swpAmount, isAmount: true),
                    onChange: (val) {
                      swpAmount = num.tryParse(val) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Expected Return",
                    isTextTheme: true,
                    suffixText: "%",
                    onChange: (val) {
                      expectedReturn = num.tryParse(val) ?? 0;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  dateInput(
                    title: "Lumpsum Date",
                    controller: lumpsumController,
                    onTap: () async {
                      lumpsumDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1990),
                        lastDate: DateTime.now(),
                      );
                      if (lumpsumDate == null) return;
                      int day = lumpsumDate!.day;
                      int month = lumpsumDate!.month;
                      int year = lumpsumDate!.year;

                      lumpsumController.text = "$day-$month-$year";
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  dateInput(
                    title: "SWP Start Date",
                    controller: swpStartController,
                    onTap: () async {
                      swpStartDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1990),
                        lastDate: DateTime(2100),
                      );
                      if (swpStartDate == null) return;
                      int day = swpStartDate!.day;
                      int month = swpStartDate!.month;
                      int year = swpStartDate!.year;

                      swpStartController.text = "$day-$month-$year";
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  dateInput(
                    title: "SWP End Date",
                    controller: swpEndController,
                    onTap: () async {
                      swpEndDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1990),
                        lastDate: DateTime(2100),
                      );
                      if (swpEndDate == null) return;
                      int day = swpEndDate!.day;
                      int month = swpEndDate!.month;
                      int year = swpEndDate!.year;

                      swpEndController.text = "$day-$month-$year";
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  AmountInputCard(
                    title: "Investment Purpose",
                    suffixText: "",
                    isTextTheme: true,
                    hasSuffix: false,
                    keyboardType: TextInputType.name,
                    borderRadius: BorderRadius.circular(20),
                    onChange: (val) {
                      investmentPurpose = val;
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
                    print("schemeName $schemeName");

                    Map data = await PropoaslApi
                        .investmentProposalSwpPortfolioAnalysis(
                            user_id: invId,
                            client_name: client_name,
                            scheme_amfi: schemeName,
                            period: period,
                            lumpsum_amount: lumpsumAmount,
                            swp_amount: swpAmount,
                            swp_return: expectedReturn,
                            swp_frequency: swpFrequency,
                            lumpsum_date: lumpsumDate.toString(),
                            swp_start_date: swpStartDate.toString(),
                            swp_end_date: swpEndDate.toString(),
                            swp_date: "3");

                    if (data['status'] != 200) {
                      Utils.showError(context, data['msg']);
                      return;
                    }

                    Map result = data['result'];
                    Get.to(() => SwpProposalOutput(
                          swpResult: result,
                          swpSchemeName: schemeName,
                          swpSchemeLogo: schemeLogo,
                          swpAmt: swpAmount,
                          swpExpectedReturn: expectedReturn,
                          swpPeriod: period,
                          lumpsumAmount: lumpsumAmount,
                          swpFrequency: swpFrequency,
                          clientName: client_name,
                          invPurpose: investmentPurpose,
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
      period,
      lumpsumAmount,
      swpAmount,
      expectedReturn,
      swpFrequency,
      schemeName,
    ];

    if (l.contains(null)) {
      EasyLoading.showError("All Fields are mandatory!");
      return false;
    }
    if (l.contains(0)) {
      EasyLoading.showError("Zero Not Allowed");
      return false;
    }
    if (schemeName.isEmpty ||
        schemeName.trim().toLowerCase() ==
            "Search and Select Scheme".toLowerCase()) {
      EasyLoading.showError("Select The Scheme");
      return false;
    }
    if (lumpsumDate == null) {
      EasyLoading.showError("Select The Lumpsum Date");
      return false;
    }
    if (swpStartDate == null) {
      EasyLoading.showError("Select The SWP Start Date");
      return false;
    }
    if (swpEndDate == null) {
      EasyLoading.showError("Select The SWP End Date");
      return false;
    }
    return true;
  }

  OutlineInputBorder borderStyle = OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.lineColor),
      borderRadius: BorderRadius.circular(20));

  Widget dateInput(
      {required String title,
      Function()? onTap,
      TextEditingController? controller}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppFonts.f50014Black),
          SizedBox(height: 5),
          TextFormField(
            readOnly: true,
            onTap: onTap,
            controller: controller,
            style: AppFonts.f50014Black
                .copyWith(color: Config.appTheme.themeColor),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                focusedBorder: borderStyle,
                enabledBorder: borderStyle),
          ),
        ],
      ),
    );
  }

  Widget schemeNameTile(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: schemeController,
          title: Text("Scheme Name", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(schemeName,
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
                    Map data = await PropoaslApi.autoSuggestScheme(
                        user_id: user_id, query: query,client_name: client_name);
                    schemeSuggestions = data['list'];
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
                itemCount: schemeSuggestions.length,
                itemBuilder: (context, index) {
                  Map temp = schemeSuggestions[index];
                  String logo = temp['logo'];
                  String name = temp['scheme_amfi_short_name'];

                  return ListTile(
                    onTap: () {
                      schemeName = name;
                      schemeLogo = logo;
                      schemeController.collapse();
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
          title: Text("SWP Frequency", style: AppFonts.f50014Black),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(swpFrequency,
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
              itemCount: swpFrequencyList.length,
              itemBuilder: (context, index) {
                String temp = swpFrequencyList[index];

                return InkWell(
                  onTap: () {
                    swpFrequency = temp;
                    stpFrequencyController.collapse();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Radio(
                        value: temp,
                        groupValue: swpFrequency,
                        onChanged: (value) {
                          swpFrequency = temp;
                          stpFrequencyController.collapse();
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
}
