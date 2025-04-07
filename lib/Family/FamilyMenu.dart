import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Family/reports/FamilyAllTransactionReport.dart';
import 'package:mymfbox2_0/Family/reports/FamilyDatewiseTransactionReport.dart';
import 'package:mymfbox2_0/Family/reports/FamilyInvestmentSummary/FamilyInvestmentSummary.dart';
import 'package:mymfbox2_0/Family/reports/FamilyMonthlyTransactionReport.dart';
import 'package:mymfbox2_0/Family/reports/FamilySipReport.dart';
import 'package:mymfbox2_0/Investor/InvestorContactUs.dart';
import 'package:mymfbox2_0/Investor/InvestorDashboard.dart';
import 'package:mymfbox2_0/Investor/InvestorMenu/InvestorProfile.dart';
import 'package:mymfbox2_0/common/ChangePassword.dart';
import 'package:mymfbox2_0/common/DeleteAccount.dart';
import 'package:mymfbox2_0/login/CheckAuth.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FamilyMenu extends StatefulWidget {
  const FamilyMenu({super.key, required this.memberList});
  final List memberList;
  @override
  State<FamilyMenu> createState() => _FamilyMenuState();
}

class _FamilyMenuState extends State<FamilyMenu> {
  late double devHeight, devWidth;
  String mfd_name = GetStorage().read("mfd_name") ?? "null";
  String str_name = "";

  List data = [
    {
      'title': "My Profile",
      'subTitle': "Family Head",
      'goTo': InvestorProfile(),
      'img': "assets/familyMenu/my_profile.png",
    },

    /*{
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
    /*{
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
    //  implement initState
    super.initState();
    str_name = mfd_name;
    loadAppVersion();
  }

  String getFirst13(String text) {
    if (str_name.length > 13) str_name = str_name.substring(0, 13) + "...";
    return str_name;
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
              listContainer(list: data.getRange(0, 1).toList()),
              familyMemberContainer(),
              listContainer(list: data.getRange(1, 3).toList()),
              //listContainer(list: data.getRange(6, 8).toList()),
              // listContainer(list: data.getRange(9, 11).toList()),
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
                'V $appVersion',
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
                    softWrap: true,
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

  Widget familyMemberContainer() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.memberList.length,
        separatorBuilder: (context, index) {
          return DottedLine(verticalPadding: 4);
        },
        itemBuilder: (context, index) {
          Map map = widget.memberList[index];

          int id = map['id'];
          String name = map['name'] ?? "";
          String relation = map['relation'] ?? "";
          int length = AppColors.colorPalate.length;
          // int colorIndex = (index > length) ? index % length : index;
          int colorIndex = index % length;

          return InkWell(
            onTap: () async {
              await GetStorage().write("user_id", id);
              await GetStorage().write("user_name", name);
              await GetStorage().write('familyAsInvestor', true);

              Get.off(() => InvestorDashboard());
            },
            child: RpListTile(
              leading: InitialCard(
                title: name[0],
                bgColor: AppColors.colorPalate[colorIndex],
                size: 32,
              ),
              title: SizedBox(
                width: devWidth * 0.5,
                child: Text(name,
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor)),
              ),
              subTitle: Text(relation, style: AppFonts.f40013),
            ),
          );
        },
      ),
    );
  }

/*Widget appBar() {
    return Container(
      margin: EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Config.appTheme.themeColor,
            child: Text(
              "$mfd_name".substring(0, 1),
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Hello ${getFirst13(str_name)}",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              Text("Good Morning",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14)),
            ],
          ),
          Spacer(),
          Image.asset("assets/cake.png", height: 45),
          SizedBox(width: devWidth * 0.02),
          Image.asset("assets/notifications.png", height: 25),
          SizedBox(width: devWidth * 0.04),
        ],
      ),
    );
  }*/
}
