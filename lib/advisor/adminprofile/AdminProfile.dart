import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/advisor/adminprofile/AdminProfile.pojo.dart';
import 'package:mymfbox2_0/advisor/adminprofile/AmcEmpanalled.dart';
import 'package:mymfbox2_0/advisor/adminprofile/BseNseMfuInfo.dart';
import 'package:mymfbox2_0/advisor/adminprofile/MailBackInformation.dart';
import 'package:mymfbox2_0/advisor/adminprofile/UpdateAdminProfile.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  late double devHeight, devWidth;

  int mfd_id = getUserId();
  String client_name = GetStorage().read("client_name");
  List<dynamic> yearData = [];
  String mfd_name = GetStorage().read('mfd_name');

  @override
  void initState() {
    //  implement initState
    super.initState();
  }

  DetailsPojo details = DetailsPojo();

  List activeAmc = [], allAmc = [];
  Future getAdminProfileDetails() async {
    if (allAmc.isNotEmpty) return 0;

    Map data = await AdminApi.getAdminProfileDetails(
        user_id: mfd_id, client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    Map<String, dynamic> temp = data['details'] as Map<String, dynamic>;
    details = DetailsPojo.fromJson(temp);
    activeAmc = data['active_names'];
    allAmc = data['amc_names'];

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: getAdminProfileDetails(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: rpAppBar(
                title: "Admin Profile",
                foregroundColor: Colors.white,
                bgColor: Config.appTheme.themeColor,
                actions: [
                  /*InkWell(
                      onTap: () {
                        shareBottomSheet();
                      },
                      child: Icon(
                        Icons.pending_outlined,
                        color: Colors.white,
                      )),*/
                  SizedBox(
                    width: 16,
                  )
                ]),
            body: SideBar(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  topCard(),
                  SizedBox(
                    height: 30,
                  ),
                  profileCard("Profile", "assets/account_circle.png", UpdateAdminProfile(detailsPojo: details)),
                  profileCard("Mailback Information", "assets/chat_info.png", MailBackInformation(detailsPojo: details)),
                  profileCard("BSE | NSE | MFU Information", "assets/fact_check.png", BseNseMfuInfo(detailsPojo: details)),
                  profileCard("AMC Empanalled", "assets/unknown_document.png", AmcEmpanelled(activeAmc: activeAmc, allAmc: allAmc,)),
                ],
              )),
            ),
          );
        });
  }

  Widget topCard() {
    String companyName = details.companyName ?? " ";

    return Container(
      color: Config.appTheme.themeColor,
      child: Container(
        width: devWidth,
        margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Config.appTheme.themeColor25,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Config.appTheme.themeColor,
                  child: Text(
                    companyName[0],
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    "${details.companyName}",
                    maxLines: 3,
                    style:
                        AppFonts.f40016.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            DottedLine(),
            ColumnText(title: "Mobile", value: "${details.name}"),
            DottedLine(),
            ColumnText(title: "Email", value: "${details.companyMail}"),
          ],
        ),
      ),
    );
  }

  Widget profileCard(String title, String icon, Widget? goTo) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Get.to(goTo)!.then((value) {
            allAmc = [];
            setState(() {});
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Image.asset(
              "$icon",
              color: Config.appTheme.themeColor,
              height: 32,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: AppFonts.f50014Black
                  .copyWith(color: Config.appTheme.themeColor),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Config.appTheme.placeHolderInputTitleAndArrow,
            ),
          ],
        ),
      ),
    );
  }

  Map bottomSheetSData = {
    "Upload New Profile Photo": [
      "",
      "assets/add_photo_alternate.png",
    ],
    "Delete Profile Photo": [
      "",
      "assets/delete.png",
    ],
  };

  shareBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Config.appTheme.mainBgColor,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SizedBox(
              height: devHeight * 0.30,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: devWidth * 0.03),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Admin Profile Actions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        listContainer(),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget listContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: bottomSheetSData.length,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 8,
          );
        },
        itemBuilder: (context, index) {
          String title = bottomSheetSData.keys.elementAt(index);
          List stitle = bottomSheetSData.values.elementAt(index);
          String imagePath = stitle[1];
          print("came here");
          Color itemColor = title == "Delete Profile Photo"
              ? Colors.red
              : Config.appTheme.themeColor;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: RpListTile(
                  title: SizedBox(
                    width: 220,
                    child: Text(
                      title,
                      style: AppFonts.f50014Black.copyWith(color: itemColor),
                    ),
                  ),
                  subTitle: Visibility(
                    visible: stitle[0].isNotEmpty,
                    child: Text(stitle[0], style: AppFonts.f40013),
                  ),
                  leading: Image.asset(
                    imagePath,
                    color: itemColor,
                    width: 32,
                    height: 32,
                  ),
                  showArrow: false,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
