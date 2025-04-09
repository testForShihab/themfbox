import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/InvestorContactUs.dart';
import 'package:mymfbox2_0/Investor/InvestorMenu/RiskProfile/RiskProfile.dart';
import 'package:mymfbox2_0/Investor/investorMenu/InvestorProfile.dart';
import 'package:mymfbox2_0/Investor/reports/InvestorAllTransactionReport.dart';
import 'package:mymfbox2_0/Investor/reports/InvestorDateWiseTransactionReport.dart';
import 'package:mymfbox2_0/Investor/reports/InvestorElssStatementReport.dart';
import 'package:mymfbox2_0/Investor/reports/InvestorFolioTransactionReport.dart';
import 'package:mymfbox2_0/Investor/reports/InvestorGainLossReport.dart';
import 'package:mymfbox2_0/Investor/reports/InvestorInvestmentSummary.dart';
import 'package:mymfbox2_0/Investor/reports/InvestorTransactionStatement.dart';
import 'package:mymfbox2_0/Investor/reports/LtStHolding.dart';
import 'package:mymfbox2_0/Investor/reports/NotionalGainLossReport.dart';
import 'package:mymfbox2_0/Investor/reports/TaxReport.dart';
import 'package:mymfbox2_0/advisor/HelpandSupport.dart';
import 'package:mymfbox2_0/common/ChangePassword.dart';
import 'package:mymfbox2_0/common/DeleteAccount.dart';
import 'package:mymfbox2_0/login/CheckAuth.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../login/Biometric.dart';
import '../reports/DividentReport.dart';
import '../reports/FolioMaster.dart';
import '../reports/InvestorMonthlyTransactionReport.dart';

class InvestorMenu extends StatefulWidget {
  const InvestorMenu({Key? key}) : super(key: key);

  @override
  State<InvestorMenu> createState() => _InvestorMenuState();
}

class _InvestorMenuState extends State<InvestorMenu> {
  late double devHeight, devWidth;

  List data = [
    {
      'title': "My Profile",
      'subTitle': "",
      'goTo': InvestorProfile(),
      'img': "assets/familyMenu/my_profile.png"
    },
    {
      'title': "Create Risk Profile",
      'subTitle': "",
      'goTo': RiskProfile(),
      'img': "assets/risk_profile.png"
    },
    /*  {
      'title': "FAQ's",
      'subTitle': "Neque porro quisquam",
      'goTo': null,
      'img': "assets/familyMenu/faq.png",
    },*/
    {
      'title': "Contact Us",
      'subTitle': "",
      'goTo': InvestorContactUs(),
      'img': "assets/familyMenu/contact_us.png",
    },
    /* {
      'title': "Help and Support",
      'subTitle': "",
      'goTo': HelpandSupport(),
      'img': "assets/familyMenu/help_support.png",
    },*/
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
    },
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

  Future<void> loadAppVersion()async{
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
            listContainer(list: data.getRange(0, 2).toList()),
            listContainer(list: data.getRange(2, 5).toList()),
            SizedBox(height: 16),
            TextButton(
                onPressed: () {
                  GetStorage().erase();
                  Get.offAll(CheckAuth());
                },
                child: Text('Log out',
                    style: TextStyle(
                        color: Config.appTheme.themeColor, fontSize: 18,fontWeight: FontWeight.bold))),
            Text(
              'v $appVersion',
              style: TextStyle(color: Color(0xff959595), fontSize: 12),
            ),
          ],
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
