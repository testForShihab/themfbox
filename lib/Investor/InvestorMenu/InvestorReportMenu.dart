import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/reports/InvestorAllTransactionReport.dart';
import 'package:mymfbox2_0/Investor/reports/InvestorDateWiseTransactionReport.dart';
import 'package:mymfbox2_0/Investor/reports/InvestorElssStatementReport.dart';
import 'package:mymfbox2_0/Investor/reports/InvestorFolioTransactionReport.dart';
import 'package:mymfbox2_0/Investor/reports/InvestorGainLossReportPage.dart';
import 'package:mymfbox2_0/Investor/reports/InvestorInvestmentSummary.dart';
import 'package:mymfbox2_0/Investor/reports/InvestorTransactionStatement.dart';
import 'package:mymfbox2_0/Investor/reports/LtStHolding.dart';
import 'package:mymfbox2_0/Investor/reports/NotionalGainLossReport.dart';
import 'package:mymfbox2_0/Investor/reports/TaxReport.dart';
import 'package:mymfbox2_0/login/CheckAuth.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../reports/DividentReport.dart';
import '../reports/FolioMaster.dart';
import '../reports/InvestorAssetCategoryBreakup.dart';
import '../reports/InvestorMonthlyTransactionReport.dart';

class InvestorReportMenu extends StatefulWidget {
  const InvestorReportMenu({Key? key}) : super(key: key);

  @override
  State<InvestorReportMenu> createState() => _InvestorReportMenuState();
}

class _InvestorReportMenuState extends State<InvestorReportMenu> {
  late double devHeight, devWidth;

  List data = [
    {
      'title': "Investment Summary",
      'subTitle': "",
      'goTo': InvestorInvestmentSummary(),
      'img': "assets/investorMenu/inv_summary.png"
    },
    {
      'title': "Current Portfolio Asset Category Breakup",
      'subTitle': "",
      'goTo': InvestorAssetCategoryBreakup(),
      'img': "assets/investorMenu/inv_summary.png"
    },
    {
      'title': "Long/Short Term Holding",
      'subTitle': "",
      'goTo': LtStHolding(),
      'img': "assets/investorMenu/long_short.png"
    },
    {
      'title': "Notional Gain/Loss Report",
      'subTitle': "",
      'goTo': NotionalGainLossReport(),
      'img': "assets/investorMenu/long_short.png"
    },
    {
      'title': "ELSS Statement",
      'subTitle': "",
      'goTo': InvestorElssStatementReport(),
      'img': "assets/investorMenu/elss_stmt.png"
    },
    {
      'title': "Folio Master Report",
      'subTitle': "",
      'goTo': FolioMaster(),
      'img': "assets/investorMenu/folio_master_report.png"
    },
    {
      'title': "Monthly Transaction Report",
      'subTitle': "",
      'goTo': InvestorMonthlyTransactionReport(),
      'img': "assets/calendar_month.png"
    },
    {
      'title': "Date Wise Transaction Report",
      'subTitle': "",
      'goTo': InvestorDateWiseTransactionReport(),
      'img': "assets/familyMenu/date_wise_trnx.png"
    },
    {
      'title': "Folio Wise Transaction Report",
      'subTitle': "",
      'goTo': InvestorFolioTransactionReport(),
      'img': "assets/foliowise.png"
    },
    {
      'title': "All Transaction Report",
      'subTitle': "",
      'goTo': InvestorAllTransactionReport(),
      'img': "assets/fact_check.png"
    },
    {
      'title': "Transaction Statement",
      'subTitle': "",
      'goTo': InvestorTransactionStatement(),
      'img': "assets/investorMenu/trnx_stmt.png"
    },
    {
      'title': "Gain/Loss Report",
      'subTitle': "",
      'goTo': InvestorGainLossReportPage(),
      'img': "assets/investorMenu/gl_report.png"
    },
    {
      'title': "Tax Report",
      'subTitle': "",
      'goTo': TaxReport(),
      'img': "assets/investorMenu/tax_report.png"
    },
    {
      'title': "Dividend Report",
      'subTitle': "",
      'goTo': DividendReport(),
      'img': "assets/investorMenu/dividend_report.png"
    },
    /*{
      'title': "FAQ's",
      'subTitle': "Neque porro quisquam",
      'goTo': null,
      'img': "assets/familyMenu/faq.png",
    },*/
    /*{
      'title': "Contact Us",
      'subTitle': "",
      'goTo': InvestorContactUs(),
      'img': "assets/familyMenu/contact_us.png",
    },
    */ /* {
      'title': "Help and Support",
      'subTitle': "",
      'goTo': HelpandSupport(),
      'img': "assets/familyMenu/help_support.png",
    },*/ /*
    {
      'title': "Manage Account",
      'subTitle': "",
      'goTo': DeleteAccount(),
      'img': "assets/familyMenu/manage_account.png",
    },
    {
      'title': "Change Password",
      'subTitle': "",
      'goTo': ChangePassword(),
      'img': "assets/familyMenu/change_password.png",
    },*/
  ];

  @override
  void initState() {
    super.initState();
    loadAppVersion();
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor : p200));
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

    return SideBar(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              listContainer(list: data.getRange(0, 2).toList()),

              listContainer(list: data.getRange(2, 7).toList()),
              listContainer(list: data.getRange(7, 14).toList()),
              //listContainer(list: data.getRange(12, 15).toList()),
              // listContainer(list: data.getRange(15, 18).toList()),
              // listContainer(list: data.getRange(18, 20).toList()),
              SizedBox(height: 16),
              TextButton(
                  onPressed: () {
                    GetStorage().erase();
                    Get.offAll(CheckAuth());
                  },
                  child: Text('Log out',
                      style: TextStyle(
                          color: Config.appTheme.themeColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold))),
              Text(
                'v $appVersion',
                style: TextStyle(color: Color(0xff959595), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isOpen = false;

  Widget listContainer({required List list}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        separatorBuilder: (context, index) {
          return DottedLine(verticalPadding: 2);
        },
        itemBuilder: (context, index) {
          Map map = list[index];

          String img = map['img'];
          String title = map['title'];
          String subTitle = map['subTitle'];
          Widget? goTo = map['goTo'];

          return InkWell(
            onTap: () {
              if (goTo != null) Get.to(goTo);
            },
            child: RpListTile(
              leading: Image.asset(
                img,
                color: Config.appTheme.themeColor,
                height: 32,
              ),
              title: SizedBox(
                width: devWidth * 0.6,
                child: Text(title,
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor)),
              ),
              subTitle: Visibility(
                  visible: subTitle.isNotEmpty,
                  child: Text(subTitle, style: AppFonts.f40013)),
            ),
          );
        },
      ),
    );
  }

  Widget dottedLine() {
    return SizedBox(
      height: 20,
      child: ListView.builder(
        itemCount: 50,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Text(
            '-',
            style: TextStyle(color: Color(0xffDFDFDF)),
          );
        },
      ),
    );
  }
}
