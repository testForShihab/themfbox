// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/advisor/Investor/AllFamilies.dart';
import 'package:mymfbox2_0/advisor/Investor/AllInvestor.dart';
import 'package:mymfbox2_0/advisor/Investor/NonElssInvestors.dart';
import 'package:mymfbox2_0/advisor/Investor/NonSipInvestors.dart';
import 'package:mymfbox2_0/advisor/dashboard/BrokerageCard.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

import 'CreateClient.dart';

class AboutInvestors extends StatefulWidget {
  const AboutInvestors(
      {super.key, this.showAppBar = true, this.scrollToFamilies = false});

  final bool showAppBar;
  final bool scrollToFamilies;

  @override
  State<AboutInvestors> createState() => _AboutInvestorsState();
}

class _AboutInvestorsState extends State<AboutInvestors> {
  late double devWidth, devHeight;
  late int user_id;
  late String client_name;
  bool isLoading = true;
  ScrollController _scrollController = ScrollController();
  int type_id = GetStorage().read("type_id");

  Map summary = {};
  late num totalInvestors, totalFamilies;
  List investorsList = [], familiesList = [];

  Future getInvestorsSummaryDetails() async {
    if (summary.isNotEmpty) return 0;

    user_id = GetStorage().read("mfd_id") ?? GetStorage().read("rm_id");
    client_name = GetStorage().read("client_name");

    Map data = await AdminApi.getInvestorsSummaryDetails(
        user_id: user_id, client_name: client_name);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    summary = data['summary'];
    investorsList = summary['top_five_investors'];
    familiesList = summary['top_five_families'];
    totalInvestors = summary['total_investor_count'];
    totalFamilies = summary['total_family_count'];
    isLoading = false;

    if (widget.scrollToFamilies && !isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent / 1,
          duration: Duration(milliseconds: 100),
          curve: Curves.linearToEaseOut,
        );
      });
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
        future: getInvestorsSummaryDetails(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: widget.showAppBar
                ? adminAppBar(
                    title: "Investors and Family", bgColor: Colors.white)
                : null,
            body: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: devWidth * 0.03, vertical: devHeight * 0.02),
                child: Column(
                  children: [
                    (isLoading)
                        ? Utils.shimmerWidget(200, margin: EdgeInsets.zero)
                        : InkWell(
                            onTap: () {},
                            child: BrokerageCard(
                              hasTitle: false,
                              hasArrow: false,
                              title: "",
                              lHead: Utils.formatNumber(totalInvestors),
                              lSubHead: "Investors",
                              lHeadonTap:() {
                                Get.to(() => AllInvestor(totalInvestors: totalInvestors, branch: [], rm: [], associate: [],));
                              },
                              rHead: "${summary['total_family_count']}",
                              rSubHead: "Families",
                              rHeadonTap:(){
                                Get.to(() => AllFamilies(totalFamilies: totalFamilies),);
                              } ,
                              padding: EdgeInsets.zero,
                              extraWidgets: [
                                if (type_id == UserType.ADMIN ||
                                    type_id == UserType.RM ||
                                    type_id == UserType.ASSOCIATE)
                                ...[SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => CreateClient());
                                  },
                                  child: extraButton(
                                    image: "assets/add_contact.png",
                                    text: "Sign up New Investor",
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0Xff333333),
                                      image: DecorationImage(
                                          image:
                                              AssetImage("assets/noise.png")),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                ]
                                /*    extraButton(
                                    image: "assets/contacts.png",
                                    text: "Help 15 Investors in KYC",
                                    isWhite: false,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Color(0xFFE1E1E1))))*/
                              ],
                            ),
                          ),
                    SizedBox(height: 20),
                    (isLoading)
                        ? Utils.shimmerWidget(300, margin: EdgeInsets.zero)
                        : topInvestors(
                            "Top 5 Investors based on AUM",
                            //  AllInvestors(totalInvestors: totalInvestors),
                            AllInvestor(
                              totalInvestors: totalInvestors,
                              branch: [],
                              rm: [],
                              associate: [],
                            ),
                            investorsList),
                    SizedBox(height: 20),
                    (isLoading)
                        ? Utils.shimmerWidget(300, margin: EdgeInsets.zero)
                        : topInvestors(
                            "Top 5 Families based on AUM",
                            // AllFamilies(totalFamilies: totalFamilies),
                            AllFamilies(totalFamilies: totalFamilies),
                            familiesList),
                    SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          sipBlock(
                              count: summary['non_sip_invetors'],
                              title: "Non SIP Investor"),
                          SizedBox(width: 16),
                          elssBlock(
                              count: summary['non_elss_investors'],
                              title: "Non ELSS Investor"),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget sipBlock({required String title, num? count}) {
    return InkWell(
      onTap: () {
        Get.to(NonSipInvestors());
      },
      child: Container(
        width: 260,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                  color: (title.contains('ELSS')
                      ? Config.appTheme.themeColor
                      : Colors.black)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppFonts.f40016.copyWith(color: Colors.white),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Get.to(NonSipInvestors());
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 0.5),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Utils.formatNumber(count),
                          style: AppFonts.f70024.copyWith(color: Colors.white),
                        ),
                        Text(
                          'Investors do not have any SIP running',
                          style: AppFonts.f40013
                              .copyWith(fontSize: 14, color: Color(0xffB1E33D)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  color: Colors.black),
              child: Text(
                "",
                style: AppFonts.f40013.copyWith(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget elssBlock({required String title, num? count}) {
    return InkWell(
      onTap: () {
        Get.to(NonElssInvestors());
      },
      child: Container(
        width: 260,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                  color: (title.contains('ELSS')
                      ? Config.appTheme.themeColor
                      : Colors.black)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppFonts.f40016.copyWith(color: Colors.white),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Get.to(NonElssInvestors());
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 0.5),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Utils.formatNumber(count),
                          style: AppFonts.f70024.copyWith(color: Colors.white),
                        ),
                        Text(
                          'Investors do not have any ELSS running',
                          style: AppFonts.f40013
                              .copyWith(fontSize: 14, color: Color(0xffB1E33D)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  color: Colors.black),
              child: Text(
                "",
                style: AppFonts.f40013.copyWith(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget topInvestors(String title, Widget goTo, List list) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                title,
                style: AppFonts.f40016,
              ),
            ),
            SizedBox(height: 16),
            ListView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Map map = list[index];
                String name = map['name'];
                String aum = Utils.formatNumber(map['aum'], isAmount: true);

                return ListTile(
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Config.appTheme.mainBgColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(name[0],
                            style: TextStyle(
                                color: Config.appTheme.themeColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 16))),
                  ),
                  title: Text(
                    map['name'],
                    style: AppFonts.f50014Black,
                  ),
                  trailing: Text(
                    "$rupee $aum",
                    style: AppFonts.f50014Black,
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: TextButton(
                      onPressed: () {
                        // Get.to(AllInvestors());
                        Get.to(() => goTo);
                      },
                      child: Row(
                        children: [
                          Text("View All ", style: AppFonts.f50014Theme),
                          Icon(Icons.arrow_forward, size: 20)
                        ],
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget extraButton(
      {required String image,
      Decoration? decoration,
      String? text,
      bool isWhite = true}) {
    return Container(
      width: devWidth,
      height: 50,
      decoration: decoration,
      child: Center(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Image.asset(image, height: 30),
            SizedBox(width: 10),
            Text(text ?? "null",
                style: TextStyle(
                    color: (isWhite) ? Colors.white : null,
                    fontWeight: FontWeight.w500)),
            Spacer(),
            Icon(Icons.arrow_forward, color: (isWhite) ? Colors.white : null)
          ],
        ),
      )),
    );
  }
}
