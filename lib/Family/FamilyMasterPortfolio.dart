import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/InvestorDashboard.dart';
import 'package:mymfbox2_0/api/FamilyApi.dart';
import 'package:mymfbox2_0/pojo/MasterPortfolioPojo.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/rp_widgets/SipRoundIcon.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import '../api/ReportApi.dart';

class FamilyMasterPortfolio extends StatefulWidget {
  const FamilyMasterPortfolio({super.key, required this.showAppBar});

  final bool showAppBar;

  @override
  State<FamilyMasterPortfolio> createState() => _FamilyMasterPortfolioState();
}

class _FamilyMasterPortfolioState extends State<FamilyMasterPortfolio> {
  var name = GetStorage().read("family_name");

  int user_id = GetStorage().read("family_id");
  String client_name = GetStorage().read("client_name");
  String mobile = GetStorage().read("family_mobile") ?? "";
  String email = GetStorage().read("family_email") ?? "";
  num total = 0;
  List masterList = [];

  @override
  void initState() {
    super.initState();
    name = Utils.getFirst13(name);
  }

  Future getMasterPortfolio() async {
    if (masterList.isNotEmpty) return 0;

    EasyLoading.show();
    Map data = await FamilyApi.getMasterPortfolio(
        user_id: user_id, client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['status_msg']);
      return -1;
    }
    total = data['total_investments'];
    masterList = data['master_list'];
    EasyLoading.dismiss();
    return 0;
  }

  late double devHeight, devWidth;

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.sizeOf(context).height;
    devWidth = MediaQuery.sizeOf(context).width;

    return FutureBuilder(
        future: getMasterPortfolio(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: (widget.showAppBar)
                ? rpAppBar(
                    title: "Family of $name",
                    bgColor: Config.appTheme.themeColor,
                    foregroundColor: Colors.white,
                    actions: [
                      GestureDetector(
                        onTap: () {
                          showReportActionBottomSheet();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.pending_outlined),
                            SizedBox(width: 16),
                          ],
                        ),
                      ),
                    ],
                  )
                : null,
            /*invAppBar(
                    toolbarHeight: 58,
                    title: "Family of $name",
                  )
                : null,*/
            backgroundColor: Config.appTheme.mainBgColor,
            body: SideBar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    familySummaryCard(),
                    SizedBox(height: 16),
                    ListView.builder(
                      itemCount: masterList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        Map map = masterList[index];
                        return invSummaryCard(map);
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  bool isOpen = false;

  showReportActionBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Config.appTheme.mainBgColor,
      context: context,
      // isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  BottomSheetTitle(title: "Report Actions"),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        reportActionContainer(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

/*
  Widget reportActionContainer() {
    InvestorDetails investorDetails =
        InvestorDetails(userId: user_id, email: email);
    List<InvestorDetails> investorDetailsList = [];
    investorDetailsList.add(investorDetails);

    String investor_details = jsonEncode(investorDetailsList);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: reportActionData.length,
        separatorBuilder: (context, index) {
          return DottedLine(verticalPadding: 4);
        },
        itemBuilder: (context, index) {
          String title = reportActionData.keys.elementAt(index);
          List stitle = reportActionData.values.elementAt(index);
          String imagePath = stitle[2];
          String msgUrl = "";
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () async {
                EasyLoading.show();
                if (index == 0) {
                  String url =
                      "${ApiConfig.apiUrl}/admin/family/getFamilySummary?key=${ApiConfig.apiKey}"
                      "&investor_details=$investor_details&mobile=$mobile&type=Download&client_name=$client_name";

                  http.Response response = await http.post(Uri.parse(url));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  String resUrl = data['msg'];
                  print("download $url");
                  rpDownloadFile(url: resUrl, context: context, index: index);
                  Get.back();
                } else if (index == 1) {
                  String url =
                      "${ApiConfig.apiUrl}/admin/family/getFamilySummary?key=${ApiConfig.apiKey}"
                      "&investor_details=$investor_details&mobile=$mobile&type=Email&client_name=$client_name";
                  http.Response response = await http.post(Uri.parse(url));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  if (data['status'] != 200) {
                    Utils.showError(context, data['msg']);
                    return;
                  }
                  EasyLoading.showInfo("Email Sent Successfully");
                  // String resUrl = data['msg'];
                  // print("email $url");
                  // rpDownloadFile(url: resUrl, context: context, index: index);
                  Get.back();
                }
                EasyLoading.dismiss();
              },
              child: RpListTile(
                title: SizedBox(
                  width: 220,
                  child: Text(
                    title,
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor),
                  ),
                ),
                subTitle: Visibility(
                  visible: stitle[0].isNotEmpty,
                  child: Text(stitle[0], style: AppFonts.f40013),
                ),
                leading: Image.asset(
                  imagePath,
                  color: Config.appTheme.themeColor,
                  width: 32,
                  height: 32,
                ),
                showArrow: false,
              ),
            ),
          );
        },
      ),
    );
  }
*/
  List reportActions = [
    {
      'title': "Download PDF Report",
      'img': "assets/pdf.png",
      'type': ReportType.DOWNLOAD,
    },
    {
      'title': "Email Report",
      'img': "assets/email.png",
      'type': ReportType.EMAIL,
    }
  ];

  Widget reportActionContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: reportActions.length,
        separatorBuilder: (context, index) {
          return DottedLine(verticalPadding: 4);
        },
        itemBuilder: (context, index) {
          Map data = reportActions[index];

          String title = data['title'];
          String img = data['img'];
          String type = data['type'];

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () async {
                EasyLoading.show();
                Map data = await ReportApi.getFamilySummary(
                    user_id: user_id,
                    client_name: client_name,
                    email: email,
                    mobile: mobile,
                    type: type);
                if (data['status'] != 200) {
                  Utils.showError(context, data['msg']);
                  return;
                }
                EasyLoading.dismiss();
                Get.back();

                if (type == ReportType.DOWNLOAD) {
                  rpDownloadFile(url: data['msg'], index: index);
                } else {
                  EasyLoading.showToast("${data['msg']}");
                }
              },
              child: RpListTile(
                title: SizedBox(
                  width: 220,
                  child: Text(
                    title,
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor),
                  ),
                ),
                subTitle: SizedBox(),
                leading: Image.asset(
                  img,
                  color: Config.appTheme.themeColor,
                  width: 32,
                  height: 32,
                ),
                showArrow: false,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget familySummaryCard() {
    return Container(
      color: Config.appTheme.themeColor,
      width: devWidth,
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 10, 16, 16),
        decoration: BoxDecoration(
          color: Config.appTheme.overlay85,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Family Investments",
                style: TextStyle(
                    color: Color(0XFF242424),
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "$rupee ${Utils.formatNumber(total)}",
                style: TextStyle(
                    color: Config.appTheme.themeColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 32),
              ),
              Text(
                "As on ${Utils.getFormattedDate()} ",
                style: TextStyle(
                    color: AppColors.readableGrey,
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget invSummaryCard(Map map) {
    MasterPostfolioPojo masterPostfolioPojo =
        MasterPostfolioPojo.fromJson(map as Map<String, dynamic>);

    MutualFund mutualFund = masterPostfolioPojo.mutualFund ?? MutualFund();
    Equity equity = masterPostfolioPojo.equity ?? Equity();
    Fd fd = masterPostfolioPojo.fd ?? Fd();
    Pms pms = masterPostfolioPojo.pms ?? Pms();
    Structured structured = masterPostfolioPojo.structured ?? Structured();
    Nps nps = masterPostfolioPojo.nps ?? Nps();

    Commodity commodity = masterPostfolioPojo.commodity ?? Commodity();
    Gold gold = masterPostfolioPojo.gold ?? Gold();
    Aif aif = masterPostfolioPojo.aif ?? Aif();
    Realestate realestate = masterPostfolioPojo.realestate ?? Realestate();
    RealestatePms realestatePms =
        masterPostfolioPojo.realestatePms ?? RealestatePms();
    PostOffice postOffice = masterPostfolioPojo.postOffice ?? PostOffice();
    Bond bond = masterPostfolioPojo.bond ?? Bond();
    LifeInsurance lifeInsurance =
        masterPostfolioPojo.lifeInsurance ?? LifeInsurance();
    GeneralInsurance generalInsurance =
        masterPostfolioPojo.generalInsurance ?? GeneralInsurance();
    HealthInsurance healthInsurance =
        masterPostfolioPojo.healthInsurance ?? HealthInsurance();
    Loan loan = masterPostfolioPojo.loan ?? Loan();
    Ncd ncd = masterPostfolioPojo.ncd ?? Ncd();
    Trade trade = masterPostfolioPojo.trade ?? Trade();

    Map rowValue = {};
    rowValue["Mutual Fund"] = mutualFund.mutualFundCurrentValue ?? 0.0;
    rowValue["Equity"] = equity.equityTotalCurrentValue ?? 0.0;
    rowValue["FD"] = fd.fdTotalCurrentValue ?? 0.0;
    rowValue["PMS"] = pms.pmsCurrentValue ?? 0.0;
    rowValue["Structured"] = structured.structuredCurrentValue ?? 0.0;
    rowValue["NPS"] = nps.npsCurrentValue ?? 0.0;
    rowValue["Commodity"] = commodity.commodityCurrentValue ?? 0.0;
    rowValue["Gold"] = gold.goldTotalCurrentValue ?? 0.0;
    rowValue["AIF"] = aif.aifCurrValue ?? 0.0;
    rowValue["Realestate"] = realestate.propertyTotalCurrentValue ?? 0.0;
    rowValue["RealestatePms"] = realestatePms.realEstatePmsCurrentValue ?? 0.0;
    rowValue["PostOffice"] = postOffice.postalTotalCurrentValue ?? 0.0;
    rowValue["Bond"] = bond.bondsTotalCurrentValue ?? 0.0;
    rowValue["LifeInsurance"] = lifeInsurance.totalLifePremiumPaid ?? 0.0;
    rowValue["GeneralInsurance"] =
        generalInsurance.totalGeneralPremiumPaid ?? 0.0;
    rowValue["HealthInsurance"] = healthInsurance.totalHealthPremiumPaid ?? 0.0;
    rowValue["Loan"] = loan.totalLoanAmount ?? 0.0;
    rowValue["Ncd"] = ncd.ncdTotalMaturityValue ?? 0.0;
    rowValue["Trade"] = trade.tradebondsTotalReturn ?? 0.0;

    num total = 0;
    rowValue.values.forEach((element) {
      total += element ?? 0;
    });

    return InkWell(
      onTap: () async {
        int user_id = map['user_id'];
        String name = map['name'];

        print("user_id = $user_id");
        await GetStorage().write('familyAsInvestor', true);
        await GetStorage().write("user_id", user_id);
        await GetStorage().write("user_name", name);

        Get.to(() => InvestorDashboard());
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: InitialCard(),
              title: Text("${map['name']}"),
              subtitle: Text("${map['relation']}"),
              trailing: Icon(Icons.arrow_forward),
            ),
            Text("Total Investment", style: AppFonts.f40013),
            Text("$rupee ${Utils.formatNumber(total)}",
                style: AppFonts.f70024
                    .copyWith(color: Config.appTheme.themeColor, fontSize: 20)),
            DottedLine(),
            investmentRow(rowValue),
          ],
        ),
      ),
    );
  }

  Widget investmentRow(Map rowValue) {
    return Container(
      height: 115,
      padding: EdgeInsets.only(top: 8),
      child: ListView.builder(
        itemCount: rowValue.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          String title = rowValue.keys.elementAt(index);
          num value = rowValue.values.elementAt(index);

          return Visibility(visible: value != 0, child: rowIcon(title, value));
        },
      ),
    );
  }

  Widget rowIcon(String title, num? value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SipRoundIcon(),
          SizedBox(height: 5),
          Text(title, style: AppFonts.f40013),
          Text("$rupee ${Utils.formatNumber(value, isAmount: true)}",
              style: cardHeadingSmall)
        ],
      ),
    );
  }
}
