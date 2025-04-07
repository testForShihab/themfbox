import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/advisor/ContactUs.dart';
import 'package:mymfbox2_0/advisor/FamilyGroupMail.dart';
import 'package:mymfbox2_0/advisor/HelpandSupport.dart';
import 'package:mymfbox2_0/advisor/Investor/InvestorGroupMail.dart';
import 'package:mymfbox2_0/advisor/Investor/InvestorLoginCredential.dart';
import 'package:mymfbox2_0/advisor/Investor/TaxPackage.dart';
import 'package:mymfbox2_0/advisor/blogs/Blogs.dart';
import 'package:mymfbox2_0/advisor/compreMF/CompareMF.dart';
import 'package:mymfbox2_0/advisor/modelPortfolio/ModelPortfolio.dart';
import 'package:mymfbox2_0/advisor/news/News.dart';
import 'package:mymfbox2_0/advisor/reports/FamilyXirrReport.dart';
import 'package:mymfbox2_0/advisor/reports/IndividualXirrReport.dart';
import 'package:mymfbox2_0/advisor/reports/PositiveandNegativeReturnPortfolios.dart';
import 'package:mymfbox2_0/advisor/reports/SipDueReport.dart';
import 'package:mymfbox2_0/advisor/reports/TansactionReport.dart';
import 'package:mymfbox2_0/advisor/reports/WhatIfReport.dart';
import 'package:mymfbox2_0/advisor/reports/portfolioAnalysisReport/PortfolioAnalysisReport.dart';
import 'package:mymfbox2_0/advisor/proposal/InvestmentProposal.dart';
import 'package:mymfbox2_0/advisor/transactionRestriction/DayChange.dart';
import 'package:mymfbox2_0/advisor/transactionRestriction/TransactionRrestriction.dart';
import 'package:mymfbox2_0/common/ChangePassword.dart';
import 'package:mymfbox2_0/common/DeleteAccount.dart';
import 'package:mymfbox2_0/login/CheckAuth.dart';
import 'package:mymfbox2_0/research/Calculators.dart';
import 'package:mymfbox2_0/research/MfResearch.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../utils/Utils.dart';
import 'adminprofile/AdminProfile.dart';

class AdminMenu extends StatefulWidget {
  const AdminMenu({super.key});

  @override
  State<AdminMenu> createState() => _AdminMenuState();
}

class _AdminMenuState extends State<AdminMenu> {
  late double devHeight, devWidth;
  String mfd_name = GetStorage().read("mfd_name") ?? "";
  int type_id = GetStorage().read("type_id") ?? 0;
  String str_name = "";

  List data = [
    {
      'title': "Research Tools",
      "subTitle": "Explore exhaustive MF Research",
      'goTo': MfResearch(),
      'image': "assets/research_Tools.png",
      'allowed': [],
    },
    {
      'title': "Tools and Calculators",
      "subTitle": "Various tools that help plan investments",
      'goTo': Calculators(),
      'image': "assets/tools_Calculators.png",
      'allowed': [],
    },
    {
      'title': "Blogs",
      "subTitle": "Latest articles ",
      'goTo': Blogs(),
      'image': "assets/Blogs.png",
      'allowed': [],
    },
    {
      'title': "News",
      "subTitle": "Latest Industry news and updates",
      'goTo': News(),
      'image': "assets/News.png",
      'allowed': [],
    },
    {
      'title': "SIP Due Report",
      "subTitle": "Check the SIP due dates",
      'goTo': SipDueReport(),
      'image': "assets/sipDue.png",
      'allowed': [UserType.ADMIN],
    },
    {
      'title': "Point to Point Individual XIRR Report",
      "subTitle": "Portfolios for selected from and to dates",
      'goTo': IndividualXirrReport(),
      'image': "assets/Individual_XIRR.png",
      'allowed': [],
    },
    {
      'title': "Point to Point Family XIRR Report",
      "subTitle": "Family Portfolios - selected from and to dates",
      'goTo': FamilyXirrReport(),
      'image': "assets/family_XIRR.png",
      'allowed': [],
    },
    {
      'title': "Portfolio Analysis Report",
      "subTitle": "Compare scheme and Portfolio with Benchmark",
      'goTo': PortfolioAnalysisReport(),
      'image': "assets/portfolio_Analysis.png",
      'allowed': [],
    },
    {
      'title': "Negative & Positive Return Portfolios",
      "subTitle": "Select portfolios based on return range",
      'goTo': PositiveandNegativeReturnPortfolios(),
      'image': "assets/n&p.png",
      'allowed': [],
    },
    {
      'title': "Transaction Report",
      "subTitle": "Exhaustive reports on various transaction types",
      'goTo': TransactionReport(),
      'image': "assets/Individual_XIRR.png",
      'allowed': [],
    },
    {
      'title': "What If Report",
      "subTitle": "Get to know what if had the Investor has not redeemed",
      'goTo': WhatIfReport(),
      'image': "assets/change_password.png",
      'allowed': [],
    },
    {
      'title': "Tax Package",
      "subTitle":
          "All in one report for Capital gain, transactions and FY end portfolio",
      'goTo': TaxPackage(),
      'image': "assets/familyMenu/all_trnx.png",
      'allowed': [],
    },
    {
      'title': "Compare Funds",
      "subTitle": "",
      'goTo': CompareMF(),
      'image': "assets/compare_funds.png",
      'allowed': [],
    },
    {
      'title': "Investment Proposal",
      "subTitle": "",
      'goTo': InvestmentProposal(),
      'image': "assets/investment_proposal.png",
      'allowed': [],
    },
    {
      'title': "Model Portfolio",
      "subTitle": "",
      'goTo': ModelPortfolio(),
      'image': "assets/model_portfolio.png",
      'allowed': [],
    },
    /* {
      'title': "CAS Upload",
      "subTitle": "",
      'goTo': CasUpload(),
      'image': "assets/upload_file.png",
      'allowed': [UserType.ADMIN],
    },*/
    /*{
      'title': "FAQ's",
      "subTitle": "Neque porro quisquam",
      'goTo': null,
      'image': "assets/faq.png",
      'allowed': [UserType.ADMIN],
    },*/
    {
      'title': "Contact Us",
      "subTitle": "",
      'goTo': ContactUs(),
      'image': "assets/contact_us.png",
      'allowed': [UserType.ADMIN],
    },
    {
      'title': "Help and Support",
      "subTitle": "Ask for help from MFBOX team",
      'goTo': HelpandSupport(),
      'image': "assets/help_support.png",
      'allowed': [UserType.ADMIN],
    },
    {
      'title': "Admin Profile",
      "subTitle": "",
      'goTo': AdminProfile(),
      'image': "assets/admin_profile.png",
      'allowed': [UserType.ADMIN],
    },
    {
      'title': "Manage Account",
      "subTitle": "",
      'goTo': DeleteAccount(),
      'image': "assets/manage_accounts.png",
      'allowed': [],
    },
    {
      'title': "Change Password",
      "subTitle": "",
      'goTo': ChangePassword(),
      'image': "assets/change_password.png",
      'allowed': [],
    },
    {
      'title': "Online Transaction Restriction",
      "subTitle": "",
      'goTo': TransactionRestriction(),
      'image': "assets/familyMenu/all_trnx.png",
      'allowed': [UserType.ADMIN, UserType.RM],
    },
    {
      'title': "Mutual Fund Report Transaction",
      "subTitle": "",
      'goTo': DayChange(),
      'image': "assets/familyMenu/all_trnx.png",
      'allowed': [UserType.ADMIN],
    },
    {
      'title': "Group Email - Investor Portfolio",
      "subTitle": "",
      'goTo': InvestorGroupMail(),
      'image': "assets/familyMenu/all_trnx.png",
      'allowed': [],
    },
    {
      'title': "Group Email - Family Portfolio",
      "subTitle": "",
      'goTo': FamilyGroupMail(),
      'image': "assets/familyMenu/all_trnx.png",
      'allowed': [],
    },
    {
      'title': "Investor Login Credential",
      "subTitle": "",
      'goTo': InvestorLoginCredential(),
      'image': "assets/familyMenu/all_trnx.png",
      'allowed': [UserType.ADMIN, UserType.RM],
    },
  ];

  final AdminMenuController adminMenuController =
      Get.put(AdminMenuController());

  String controlName = "";

  @override
  void initState() {
    //  implement initState
    super.initState();
    str_name = mfd_name;
    loadAppVersion();
  }

  Future<Map> getMenu() async {
    Future.delayed(const Duration(milliseconds: 100), () {});

    if (type_id == 5) {
      controlName = "Admin Control";
    } else if (type_id == 7) {
      controlName = "Branch Control";
    } else if (type_id == 2) {
      controlName = "RM Control";
    } else if (type_id == 4) {
      controlName = "Associate Control";
    }
    return convertListToMap(dataItems);
  }

  List<Map<String, dynamic>> dataItems = [
    {
      'title': "Research Tools",
      "subTitle": "Explore exhaustive MF Research",
      'goTo': MfResearch(),
      'image': "assets/research_Tools.png",
    },
    {
      'title': "Tools and Calculators",
      "subTitle": "Various tools that help plan investments",
      'goTo': Calculators(),
      'image': "assets/research_Tools.png",
    },
  ];

  String getFirst13(String text) {
    if (str_name.length > 13) str_name = str_name.substring(0, 13) + "...";
    return str_name;
  }

  Map<String, Map<String, dynamic>> convertListToMap(
      List<Map<String, dynamic>> dataList) {
    return {for (var item in dataList) item['title']: item};
  }

  Map dashboardData = {};
  bool isLoading = true;

  String appVersion = "loading...";

  Future<void> loadAppVersion() async {
    final versions = await PackageInfo.fromPlatform();

    setState(() {
      appVersion = "${versions.buildNumber}+${versions.version}";
      print("App version $appVersion");
    });
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            FutureBuilder<Map>(
              future: getMenu(),
              builder: (context, snapshot) {
                snapshot.data;

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      Utils.shimmerWidget(devHeight,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0)),
                      SizedBox(
                        height: 16,
                      )
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      listContainer(data.getRange(0, 4).toList()),
                      listContainer(data.getRange(4, 12).toList()),
                      listContainer(data.getRange(12, 15).toList()),
                      listContainer(data.getRange(15, 17).toList()),
                      listContainer(data.getRange(17, 20).toList()),
                      Theme(
                        data: ThemeData()
                            .copyWith(dividerColor: Colors.transparent),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 12.0),
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: ExpansionTile(
                            trailing: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey,
                              size: 32,
                            ),
                            tilePadding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                            title: Text(
                              controlName,
                              style: AppFonts.f50014Black
                                  .copyWith(color: Config.appTheme.themeColor),
                            ),
                            children: [
                              Container(
                                child: listContainer(
                                    data.getRange(20, 25).toList()),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextButton(
                          onPressed: () {
                            GetStorage().erase();
                            Get.offAll(CheckAuth());
                          },
                          child: Text('Log out',
                              style: TextStyle(
                                  color: Config.appTheme.themeColor,
                                  fontSize: 18,fontWeight: FontWeight.bold))),
                      Text(
                        'v $appVersion',
                        style:
                            TextStyle(color: Color(0xff959595), fontSize: 12),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget listContainer(List list) {
    List allowedList = [];

    for (var element in list) {
      if (element['allowed'].isEmpty) {
        allowedList.add(true);
        continue;
      }
      allowedList.add(element['allowed'].contains(type_id));
    }

    if (!allowedList.contains(true)) return SizedBox();

    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          Map data = list[index];
          String title = data['title'];
          String subTitle = data['subTitle'];
          Widget? goTo = data['goTo'];
          String image = data['image'];
          List allowed = data['allowed'];

          if (allowed.isEmpty || allowed.contains(type_id))
            return InkWell(
              onTap: () {
                if (goTo != null) Get.to(goTo);
              },
              child: RpListTile(
                title: Text(title,
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor)),
                subTitle: Visibility(
                    visible: subTitle.isNotEmpty,
                    child: Text(
                      subTitle,
                      style: AppFonts.f40013,
                      softWrap: true,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    )),
                leading: Image.asset(
                  image,
                  color: Config.appTheme.themeColor,
                  height: 32,
                ),
              ),
            );
          else
            return SizedBox();
        },
        separatorBuilder: (BuildContext context, int index) {
          Map data = list[index];
          List allowed = data['allowed'];
          if (allowed.isEmpty || allowed.contains(type_id))
            return DottedLine(verticalPadding: 4);
          else
            return SizedBox();
        },
      ),
    );
  }
}

class AdminMenuController extends GetxController {
  var isMenuLoading = false.obs;
  List menuList = [].obs;

  List data = [
    {
      'title': "Research Tools",
      "subTitle": "Neque porro quisquam",
      'goTo': MfResearch(),
      'image': "assets/research_Tools.png",
    },
    {
      'title': "Tools and Calculators",
      "subTitle": "Neque porro quisquam",
      'goTo': Calculators(),
      'image': "assets/research_Tools.png",
    },
    {
      'title': "Blogs",
      "subTitle": "Neque porro quisquam",
      'goTo': Blogs(),
      'image': "assets/Blogs.png",
    },
    {
      'title': "News",
      "subTitle": "Neque porro quisquam",
      'goTo': News(),
      'image': "assets/News.png",
    },
    {
      'title': "SIP Due Report",
      "subTitle": "Neque porro quisquam",
      'goTo': SipDueReport(),
      'image': "assets/Individual_XIRR.png",
    },
    {
      'title': "Point to Point Individual XIRR Report",
      "subTitle": "Neque porro quisquam",
      'goTo': IndividualXirrReport(),
      'image': "assets/Individual_XIRR.png",
    },
    {
      'title': "Point to Point Family XIRR Report",
      "subTitle": "Neque porro quisquam",
      'goTo': FamilyXirrReport(),
      'image': "assets/family_XIRR.png",
    },
    {
      'title': "Portfolio Analysis Report",
      "subTitle": "Neque porro quisquam",
      'goTo': PortfolioAnalysisReport(),
      'image': "assets/portfolio_Analysis.png",
    },
    {
      'title': "Negative & Positive Return Portfolios",
      "subTitle": "Neque porro quisquam",
      'goTo': PositiveandNegativeReturnPortfolios(),
      'image': "assets/n&p.png",
    },
    {
      'title': "Transaction Report",
      "subTitle": "Neque porro quisquam",
      'goTo': TransactionReport(),
      'image': "assets/Individual_XIRR.png",
    },
    {
      'title': "Compare Funds",
      "subTitle": "",
      'goTo': CompareMF(),
      'image': "assets/compare_funds.png",
    },
    {
      'title': "Investment Proposal",
      "subTitle": "",
      'goTo': InvestmentProposal(),
      'image': "assets/investment_proposal.png",
    },
    {
      'title': "Model Portfolio",
      "subTitle": "",
      'goTo': ModelPortfolio(),
      'image': "assets/model_portfolio.png",
    },
    {
      'title': "CAS Upload",
      "subTitle": "",
      'goTo': null,
      'image': "assets/investment_proposal.png",
    },
    {
      'title': "FAQ's",
      "subTitle": "Neque porro quisquam",
      'goTo': null,
      'image': "assets/faq.png",
    },
    {
      'title': "Contact Us",
      "subTitle": "Neque porro quisquam",
      'goTo': null,
      'image': "assets/contact_us.png",
    },
    {
      'title': "Help and Support",
      "subTitle": "Ask for help from MFBOX team",
      'goTo': HelpandSupport(),
      'image': "assets/help_support.png",
    },
    {
      'title': "Manage Account",
      "subTitle": "Neque porro quisquam",
      'goTo': DeleteAccount(),
      'image': "assets/manage_accounts.png",
    },
    {
      'title': "Change Password",
      "subTitle": "Neque porro quisquam",
      'goTo': ChangePassword(),
      'image': "assets/change_password.png",
    },
  ];

  @override
  void onInit() {
    super.onInit();
    getMenu();
  }

  void getMenu() async {
    isMenuLoading.value = true;
    Future.delayed(const Duration(milliseconds: 500), () {});
    menuList = data;
    isMenuLoading.value = false;
  }
}

/* Obx(() {
              if(adminMenuController.isMenuLoading.value){
                return Column(
                  children: [
                    Utils.shimmerWidget(devHeight,margin: EdgeInsets.fromLTRB(0,0,0,0)),
                    SizedBox(height: 16,)
                  ],
                );
              } else {
                return Column(
                  children: [
                    listContainer(adminMenuController.menuList.getRange(0, 4).toList()),
                    listContainer(adminMenuController.menuList.getRange(4, 10).toList()),
                    listContainer(adminMenuController.menuList.getRange(10, 14).toList()),
                    listContainer(adminMenuController.menuList.getRange(14, 17).toList()),
                    listContainer(adminMenuController.menuList.getRange(17, 19).toList()),
                    TextButton(
                        onPressed: () {
                          GetStorage().erase();
                          Get.offAll(CheckAuth());
                        },
                        child: Text('Log out',
                            style: TextStyle(
                                color: Config.appTheme.themeColor, fontSize: 14))),
                    Text(
                      'v.1.2.3',
                      style: TextStyle(color: Color(0xff959595), fontSize: 12),
                    ),
                  ],
                );
              }
            })*/
