// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:mymfbox2_0/advisor/blogs/Blogs.dart';
// import 'package:mymfbox2_0/advisor/investor/AboutInvestors.dart';
// import 'package:mymfbox2_0/advisor/news/News.dart';
// import 'package:mymfbox2_0/advisor/brokerage/BrokerageDashboard.dart';
// import 'package:mymfbox2_0/advisor/dashboard/AumCard.dart';
// import 'package:mymfbox2_0/advisor/aum/AumDetails.dart';
// import 'package:mymfbox2_0/advisor/dashboard/BrokerageCard.dart';
// import 'package:mymfbox2_0/advisor/dashboard/ResearchCard.dart';
// import 'package:mymfbox2_0/api/AdminApi.dart';
// import 'package:mymfbox2_0/api/Api.dart';
// import 'package:mymfbox2_0/advisor/AdminMenu.dart';
// import 'package:mymfbox2_0/research/Calculators.dart';
// import 'package:mymfbox2_0/advisor/sip/SipDashboard.dart';
// import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
// import 'package:mymfbox2_0/utils/Config.dart';
// import 'package:mymfbox2_0/utils/Constants.dart';
// import 'package:mymfbox2_0/utils/Utils.dart';

// class AdminDashboardOld extends StatefulWidget {
//   const AdminDashboardOld({super.key});

//   @override
//   State<AdminDashboardOld> createState() => _AdminDashboardOldState();
// }

// class _AdminDashboardOldState extends State<AdminDashboardOld> {
//   late double devHeight, devWidth;
//   String mfd_name = GetStorage().read('mfd_name');
//   int mfd_id = GetStorage().read('mfd_id');

//   @override
//   void initState() {
//     //  implement initState
//     super.initState();
//   }

//   Map dashboardData = {};
//   Map get30DayData = {};
//   bool isLoading = true;
//   int selectedPage = 0;

//   Future getDatas() async {
//     await getDashboardData();
//     await getPurchaseRedeemDetail();
//     isLoading = false;
//     return 0;
//   }

//   Future getDashboardData() async {
//     if (dashboardData.isNotEmpty) return 0;
//     try {
//       // String mobile = GetStorage().read("mfd_mobile");
//       String client_name = GetStorage().read("client_name");

//       dashboardData = await AdminApi.getDashboardData(
//           user_id: "$mfd_id", client_name: client_name);
//       print("dashboardData = $dashboardData");
//       if (dashboardData['status'] != 200)
//         EasyLoading.showError(dashboardData['message']);

//       return 0;
//     } catch (e) {
//       print("Exception on read = $e");
//     }
//   }

//   Future getPurchaseRedeemDetail() async {
//     if (get30DayData.isNotEmpty) return 0;
//     try {
//       // String mobile = GetStorage().read("mfd_mobile");
//       String client_name = GetStorage().read("client_name");

//       get30DayData =
//           await Api.getPurchaseAndRedemptionDetails(client_name: client_name);
//       if (get30DayData['status'] != 200)
//         EasyLoading.showError(get30DayData['message']);
//       return 0;
//     } catch (e) {
//       print("Exception on read = $e");
//     }
//   }

//   List pages = [
//     AdminDashboardOld(),
//     AboutInvestors(showAppBar: false),
//     AdminMenu()
//   ];

//   @override
//   Widget build(BuildContext context) {
//     devHeight = MediaQuery.of(context).size.height;
//     devWidth = MediaQuery.of(context).size.width;

//     return FutureBuilder(
//         future: getDatas(),
//         builder: (context, snapshot) {
//           // if (!snapshot.hasData) return DashboardLoading(child: appBar());
//           return Scaffold(
//             backgroundColor: Config.appTheme.mainBgColor,
//             appBar: adminAppBar(
//               leading: CircleAvatar(
//                 backgroundColor: Config.appTheme.themeColor,
//                 child: Text(
//                   mfd_name[0],
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//               ),
//               title: "Hello $mfd_name 👋",
//               subTitle: "Good Morning",
//             ),
//             bottomNavigationBar: SizedBox(
//               height: 75,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(30),
//                   topLeft: Radius.circular(30),
//                 ),
//                 child: BottomNavigationBar(
//                   selectedItemColor: Config.appTheme.themeColor,
//                   currentIndex: selectedPage,
//                   onTap: (index) {
//                     selectedPage = index;
//                     setState(() {});
//                   },
//                   selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
//                   items: [
//                     BottomNavigationBarItem(
//                         icon: Icon(Icons.home), label: "Dashboard"),
//                     BottomNavigationBarItem(
//                         icon: Icon(Icons.account_circle), label: "Investors"),
//                     BottomNavigationBarItem(
//                         icon: Icon(Icons.more_horiz_rounded), label: "More"),
//                   ],
//                 ),
//               ),
//             ),
//             body: (selectedPage != 0)
//                 ? pages[selectedPage]
//                 : SafeArea(
//                     child: Padding(
//                       padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
//                       child: Column(
//                         children: [
//                           // Expanded(
//                           //   flex: 1,
//                           //   child: appBar(),
//                           // ),
//                           Expanded(
//                             flex: 13,
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 children: [
//                                   SizedBox(height: 20),
//                                   (isLoading)
//                                       ? Utils.shimmerWidget(devHeight * 0.17,
//                                           margin: EdgeInsets.only(right: 16))
//                                       : GestureDetector(
//                                           onTap: () {
//                                             Get.to(() => AumDetails());
//                                           },
//                                           child: AumCard(
//                                               dashboardData: dashboardData)),
//                                   SizedBox(height: 20),
//                                   brokerage(),
//                                   SizedBox(height: 16),
//                                   (isLoading)
//                                       ? Utils.shimmerWidget(devHeight * 0.2,
//                                           margin: EdgeInsets.only(right: 16))
//                                       : InkWell(
//                                           onTap: () {
//                                             Get.to(AboutInvestors());
//                                           },
//                                           child: BrokerageCard(
//                                             title: "Investors",
//                                             lHead: Utils.formatNumber(
//                                                 dashboardData[
//                                                     'total_investors']),
//                                             lSubHead: "Investors",
//                                             rHead:
//                                                 "${dashboardData['total_family_investors']}",
//                                             rSubHead: "Families",
//                                             extraWidgets: [
//                                               SizedBox(
//                                                   height: devHeight * 0.02),
//                                               InkWell(
//                                                 onTap: () {
//                                                   EasyLoading.showInfo(
//                                                       "Under Development");
//                                                 },
//                                                 child: extraButton(
//                                                   image:
//                                                       "assets/add_contact.png",
//                                                   text: "Sign up New Investor",
//                                                   decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10),
//                                                     color: Color(0Xff333333),
//                                                     image: DecorationImage(
//                                                         image: AssetImage(
//                                                             "assets/noise.png")),
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                   height: devHeight * 0.02),
//                                               InkWell(
//                                                 onTap: () {
//                                                   EasyLoading.showInfo(
//                                                       "Under Development");
//                                                 },
//                                                 child: extraButton(
//                                                     image:
//                                                         "assets/contacts.png",
//                                                     text:
//                                                         "Help 15 Investors in KYC",
//                                                     isWhite: false,
//                                                     decoration: BoxDecoration(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10),
//                                                         border: Border.all(
//                                                             color: Color(
//                                                                 0xFFE1E1E1)))),
//                                               ),
//                                               SizedBox(height: 8)
//                                             ],
//                                           ),
//                                         ),
//                                   SizedBox(height: 16),
//                                   sipSummaryCard(),
//                                   SizedBox(height: 16),
//                                   (isLoading)
//                                       ? Utils.shimmerWidget(100,
//                                           margin: EdgeInsets.only(right: 16))
//                                       : InkWell(
//                                           onTap: () {
//                                             EasyLoading.showInfo(
//                                                 "Under Development");
//                                           },
//                                           child: BrokerageCard(
//                                               title: "Last 30 Days",
//                                               lHead:
//                                                   '$rupee ${Utils.formatNumber(get30DayData['total_purchase_amt'], isAmount: true)}',
//                                               lSubHead:
//                                                   "Purchases(${get30DayData['total_no_of_purchase']})",
//                                               rHead:
//                                                   '$rupee ${Utils.formatNumber(get30DayData['total_redemption_amt'], isAmount: true)}',
//                                               rSubHead:
//                                                   "Redemptions(${get30DayData['total_no_of_redemption']})"),
//                                         ),
//                                   SizedBox(height: 16),
//                                   SizedBox(
//                                     height: 222,
//                                     child: ListView(
//                                       scrollDirection: Axis.horizontal,
//                                       children: [
//                                         ResearchCard(
//                                           image: 'assets/research_Tools.png',
//                                           title: "Mutual Fund Research",
//                                           subTitle: "40+ research tools",
//                                           isWhite: true,
//                                           color: Config.appTheme.themeColor,
//                                         ),
//                                         ResearchCard(
//                                           image: 'assets/tools_Calculators.png',
//                                           title: "Tools & Calculators",
//                                           subTitle: "20+ calculators",
//                                           isWhite: false,
//                                           color: Config.appTheme.universalTitle,
//                                           goTo: Calculators(),
//                                         ),
//                                         ResearchCard(
//                                           image: 'assets/Blogs.png',
//                                           title: "Blogs",
//                                           subTitle:
//                                               "Latest saving, investing & mutual fund articles",
//                                           isWhite: true,
//                                           color: Config.appTheme.themeColor,
//                                           goTo: Blogs(),
//                                         ),
//                                         ResearchCard(
//                                           image: 'assets/News.png',
//                                           title: 'News',
//                                           subTitle:
//                                               'Latest news on mutual funds',
//                                           isWhite: false,
//                                           color: Config.appTheme.universalTitle,
//                                           goTo: News(),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(height: 16),
//                                   Text(
//                                     "Copyright Mymfbox 2023. All Rights Reserved",
//                                     style: TextStyle(
//                                         color: Color(0xff959595), fontSize: 12),
//                                   ),
//                                   SizedBox(height: 16),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//           );
//         });
//   }

//   Widget sipSummaryCard() {
//     if (isLoading)
//       return Utils.shimmerWidget(100, margin: EdgeInsets.only(right: 16));
//     return InkWell(
//       onTap: () {
//         // Get.to(ProductInfo());
//         Get.to(SipDashboard());
//       },
//       child: BrokerageCard(
//         title: "SIP Summary",
//         lHead: Utils.formatNumber(dashboardData['sip_total_count']),
//         lSubHead: "Number of SIPs",
//         rHead:
//             "$rupee ${Utils.formatNumber(dashboardData['sip_total_amount'], isAmount: true)}",
//         rSubHead: "Average $rupee ${dashboardData['sip_avg_amount']}",
//       ),
//     );
//   }

//   Widget brokerage() {
//     if (isLoading)
//       return Utils.shimmerWidget(100, margin: EdgeInsets.only(right: 16));
//     String month = dashboardData['brokerage_month'].replaceAll("-", " ");
//     num monthAmount = dashboardData['brokerage_amount'];
//     num yearAmount = dashboardData['brokerage_cfy_value'];

//     return InkWell(
//       onTap: () async {
//         Get.to(() => BrokerageDashboard(
//               month: month,
//               monthAmount: monthAmount,
//               yearAmount: yearAmount,
//             ));
//       },
//       child: BrokerageCard(
//         title: "Brokerage",
//         lHead: "$rupee ${Utils.formatNumber(monthAmount, isAmount: true)}",
//         rHead: "$rupee ${Utils.formatNumber(yearAmount, isAmount: true)}",
//         lSubHead: "For $month",
//         rSubHead: "Current FY",
//       ),
//     );
//   }

//   Widget extraButton(
//       {required String image,
//       Decoration? decoration,
//       String? text,
//       bool isWhite = true}) {
//     return Container(
//       width: devWidth,
//       height: 50,
//       decoration: decoration,
//       child: Center(
//           child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16),
//         child: Row(
//           children: [
//             Image.asset(image, height: 30),
//             SizedBox(width: 10),
//             Text(text ?? "null",
//                 style: TextStyle(
//                     color: (isWhite) ? Colors.white : null,
//                     fontWeight: FontWeight.w500)),
//             Spacer(),
//             Icon(Icons.arrow_forward,
//                 color: (isWhite) ? Colors.white : Config.appTheme.themeColor)
//           ],
//         ),
//       )),
//     );
//   }
// }
