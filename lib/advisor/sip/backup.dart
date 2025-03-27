// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
// import 'package:mymfbox2_0/pojo/sip/BranchWiseSipPojo.dart';
// import 'package:mymfbox2_0/pojo/sip/RmWiseSipPojo.dart';
// import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
// import 'package:mymfbox2_0/rp_widgets/RpFilterChip.dart';
// import 'package:mymfbox2_0/rp_widgets/RpListTile2.dart';
// import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
// import 'package:mymfbox2_0/utils/Config.dart';
// import '../../api/AdminApi.dart';
// import '../../pojo/sip/AssociateWiseSipPojo.dart';
// import '../../utils/AppFonts.dart';
// import '../../utils/Constants.dart';
// import '../../utils/Utils.dart';
//
// class Backup extends StatefulWidget {
//   const Backup({super.key});
//
//   @override
//   State<Backup> createState() => _BackupState();
// }
//
// class _BackupState extends State<Backup> {
//   int user_id = GetStorage().read("mfd_id");
//   String client_name = GetStorage().read("client_name");
//
//   Map countData = {};
//   String selectedChip = 'Branch';
//
//   bool isLoading = true;
//
//   String selectedFilter = "Sort By";
//   String selectedSort = "Aum";
//   List<String> bottomSheetFilter = ["A-Z", "Aum"];
//
//   List<AssociateWiseSipPojo> associateList = [];
//   List<RmWiseSipPojo> rmList = [];
//   List<BranchWiseSipPojo> branchList = [];
//   bool sortContainer = true;
//   Map<String, num> totalAum = {"Branch": -1, "RM": -1, "Associate": -1};
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Future getDatas() async {
//     isLoading = true;
//     await getBranchWiseAUM();
//     await getRMWiseAUM();
//     await getAssociateWiseSip();
//     isLoading = false;
//     return 0;
//   }
//
//   Future getBranchWiseAUM() async {
//     if (branchList.isNotEmpty) return 0;
//
//     Map data = await AdminApi.getBranchWiseSipDetails(
//         user_id: user_id, client_name: client_name);
//     if (data['status'] != 200) {
//       Utils.showError(context, data['msg']);
//       return 0;
//     }
//     List list = data['list'];
//     countData['Branch'] = list.length;
//     getBranchPojo(list);
//     getBranchTotal();
//
//     return 0;
//   }
//
//   getBranchPojo(List list) {
//     list.forEach((element) {
//       branchList.add(BranchWiseSipPojo.fromJson(element));
//     });
//   }
//
//   String rm_name = "";
//   Future getRMWiseAUM() async {
//     if (rmList.isNotEmpty) return 0;
//
//     Map data = await AdminApi.getRmWiseSipDetails(
//         user_id: user_id, client_name: client_name);
//     if (data['status'] != 200) {
//       Utils.showError(context, data['msg']);
//       return 0;
//     }
//     List list = data['list'];
//     countData['RM'] = list.length;
//
//     getRmPojo(list);
//     getRmTotal();
//
//     return 0;
//   }
//
//   getRmPojo(List list) {
//     for (var element in list) {
//       rmList.add(RmWiseSipPojo.fromJson(element));
//     }
//   }
//
//   getRmTotal() {
//     if (totalAum['RM'] != -1) return;
//
//     num total = 0;
//     rmList.forEach((element) {
//       total += element.currentValue ?? 0;
//     });
//     totalAum['RM'] = total.roundToDouble();
//   }
//
//   Future getAssociateWiseSip() async {
//     if (associateList.isNotEmpty) return 0;
//
//     Map data = await AdminApi.getSubBrokerWiseSipDetails(
//         user_id: user_id, client_name: client_name, rm_name: rm_name);
//     if (data['status'] != 200) {
//       Utils.showError(context, data['msg']);
//       return 0;
//     }
//     List list = data['list'];
//     countData['Associate'] = list.length;
//     getSubBrokerPojo(list);
//     getSubBrokerTotal();
//
//     return 0;
//   }
//
//   getSubBrokerPojo(List list) {
//     list.forEach((element) {
//       associateList.add(AssociateWiseSipPojo.fromJson(element));
//     });
//   }
//
//   getSubBrokerTotal() {
//     if (totalAum['Associate'] != -1) return;
//
//     num total = 0;
//     associateList.forEach((element) {
//       total += element.currentCost ?? 0;
//     });
//     totalAum['Associate'] = total.roundToDouble();
//   }
//
//   getBranchTotal() {
//     if (totalAum['Branch'] != -1) return;
//
//     num total = 0;
//     branchList.forEach((element) {
//       total += element.currentCost ?? 0;
//     });
//     totalAum['Branch'] = total.roundToDouble();
//   }
//
//   late double devHeight, devWidth;
//   @override
//   Widget build(BuildContext context) {
//     devWidth = MediaQuery.sizeOf(context).width;
//     devHeight = MediaQuery.sizeOf(context).height;
//
//     return FutureBuilder(
//       future: getDatas(),
//       builder: (context, snapshot) {
//         return Scaffold(
//           backgroundColor: Colors.white,
//           appBar: adminAppBar(
//               title: "Branch/RM/Associate wise SIP",
//               bgColor: Colors.white,
//               hasAction: false),
//           body: SingleChildScrollView(
//             child: Column(
//               children: [
//                 chipArea(),
//                 sortLine(),
//                 if (!isLoading) countLine(),
//                 if (selectedChip == "Branch") branchWiseAumWidget(),
//                 if (selectedChip == "RM") rmWiseAUM(),
//                 if (selectedChip == "Associate") SubBrokerWiseAUM(),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget branchWiseAumWidget() {
//     if (isLoading)
//       return Utils.shimmerWidget(devHeight, margin: EdgeInsets.all(16));
//
//     if (branchList.isEmpty) return NoData();
//
//     return ListView.builder(
//       itemCount: branchList.length,
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         BranchWiseSipPojo data = branchList[index];
//         String title = "${data.branch}";
//         String amount = Utils.formatNumber(data.currentCost, isAmount: true);
//         return RpListTile2(
//             leading: Container(
//                 padding: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                     color: Config.appTheme.mainBgColor,
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Image.asset("assets/tie_man.png", height: 28)),
//             l1: title,
//             l2: "",
//             r1: amount,
//             r2: "");
//       },
//     );
//   }
//
//   Widget rmWiseAUM() {
//     if (isLoading)
//       return Utils.shimmerWidget(devHeight, margin: EdgeInsets.all(16));
//
//     if (rmList.isEmpty)
//       return Padding(
//           padding: EdgeInsets.only(top: devHeight * 0.2),
//           child: Text("No Data Available"));
//
//     return ListView.builder(
//       itemCount: rmList.length,
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         RmWiseSipPojo rm = rmList[index];
//
//         String title = "${rm.rmName}";
//         String amount = Utils.formatNumber(rm.currentValue, isAmount: true);
//         return RpListTile2(
//             leading: Image.asset("assets/tie_man.png", height: 32),
//             l1: title,
//             l2: "${rm.branch}",
//             r1: amount,
//             r2: "");
//       },
//     );
//   }
//
//   Widget SubBrokerWiseAUM() {
//     if (isLoading)
//       return Utils.shimmerWidget(devHeight, margin: EdgeInsets.all(16));
//     if (associateList.isEmpty)
//       Padding(
//           padding: EdgeInsets.only(top: devHeight * 0.2),
//           child: Text("No Data Available"));
//     print("came here SubBroker ");
//     return ListView.builder(
//         itemCount: associateList.length,
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         itemBuilder: (context, index) {
//           AssociateWiseSipPojo SubBrokerAUM = associateList[index];
//           String title = "${SubBrokerAUM.name}";
//           print("title $title");
//           String amount =
//               Utils.formatNumber(SubBrokerAUM.currentCost, isAmount: true);
//           String branch = "${SubBrokerAUM.name}";
//           String dot = (branch.isEmpty) ? "" : ".";
//           return RpListTile2(
//               leading: Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Config.appTheme.mainBgColor,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Image.asset(
//                   "assets/tie_man.png",
//                   height: 28,
//                 ),
//               ),
//               l1: title,
//               l2: "$branch $dot\n${SubBrokerAUM.branch}",
//               r1: amount,
//               r2: '');
//         });
//   }
//
//   Widget selectedBranchChip(String title) {
//     return Container(
//       padding: EdgeInsets.all(12),
//       margin: EdgeInsets.fromLTRB(0, 2, 16, 2),
//       decoration: BoxDecoration(
//           color: Config.appTheme.themeColor,
//           borderRadius: BorderRadius.circular(8)),
//       child: Text(title, style: TextStyle(color: Colors.white)),
//     );
//   }
//
//   Widget branchChip(String title) {
//     return InkWell(
//       onTap: () {
//         selectedChip = title;
//         setState(() {});
//       },
//       child: Container(
//         padding: EdgeInsets.all(12),
//         margin: EdgeInsets.fromLTRB(0, 2, 16, 2),
//         decoration: BoxDecoration(
//             color: Color(0XFFF1F1F1), borderRadius: BorderRadius.circular(8)),
//         child: Text(title),
//       ),
//     );
//   }
//
//   sortOptions() {
//     if (selectedChip == "Branch") {
//       if (selectedSort == 'Alphabet') {
//         branchList.sort((a, b) => a.branch!.compareTo(b.branch!));
//       }
//       if (selectedSort == "Aum") {
//         branchList.sort((a, b) => b.currentCost!.compareTo(a.currentCost!));
//       }
//     }
//
//     if (selectedChip == "RM") {
//       if (selectedSort == 'Alphabet') {
//         rmList.sort((a, b) => a.rmName!.compareTo(b.rmName!));
//       }
//       if (selectedSort == 'Aum') {
//         rmList.sort((a, b) => b.currentCost!.compareTo(a.currentCost!));
//       }
//     }
//
//     if (selectedChip == "SubBroker") {
//       if (selectedSort == 'Alphabet') {
//         print("SubBroker wise list ${associateList.length} SubBrokerWiseList");
//         associateList.sort((a, b) => a.name!.compareTo(b.name!));
//       }
//       if (selectedSort == 'Aum') {
//         associateList.sort((a, b) => b.currentCost!.compareTo(a.currentCost!));
//       }
//     }
//   }
//
//   void sortBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("  Sort By",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//               IconButton(
//                   onPressed: () {
//                     Get.back();
//                   },
//                   icon: Icon(Icons.close))
//             ],
//           ),
//           Divider(
//             height: 1,
//           ),
//           ListView.builder(
//             shrinkWrap: true,
//             itemCount: bottomSheetFilter.length,
//             itemBuilder: (context, index) {
//               final option = bottomSheetFilter[index];
//               return RadioListTile(
//                 title: Text(option),
//                 value: option,
//                 groupValue: selectedSort,
//                 onChanged: (value) {
//                   // Update the selectedSort value when a radio button is tapped
//                   selectedSort = value as String;
//                   print("selectedSort $selectedSort");
//                   sortContainer = true;
//                   EasyLoading.show();
//                   sortOptions(); // Apply sorting logic
//                   EasyLoading.dismiss();
//                   Get.back(); // Close bottom sheet
//                   setState(() {
//                     selectedFilter = selectedSort;
//                   }); // Update UI
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget bottomLeftBtn({required String title, required Function() onTap}) {
//     return InkWell(
//       onTap: onTap,
//       child: Center(
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 15),
//           child: Text(title),
//         ),
//       ),
//     );
//   }
//
//   Widget bottomLeftSelectedBtn({required String title}) {
//     return Center(
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 15),
//         width: double.maxFinite,
//         color: Colors.white,
//         child: Center(
//             child: Text(title,
//                 style: TextStyle(color: Config.appTheme.themeColor))),
//       ),
//     );
//   }
//
//   Widget chipArea() {
//     return Container(
//       height: 45,
//       width: devWidth,
//       margin: EdgeInsets.only(left: 16, bottom: 16),
//       child: ListView.builder(
//         itemCount: countData.length,
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) {
//           List branchTitle = countData.keys.toList();
//           String title = branchTitle[index];
//           return (selectedChip == title)
//               ? selectedBranchChip(title)
//               : branchChip(title);
//         },
//       ),
//     );
//   }
//
//   Widget sortLine() {
//     return Container(
//       height: 60,
//       width: devWidth,
//       color: Config.appTheme.mainBgColor,
//       padding: EdgeInsets.only(left: 16),
//       child: Row(
//         children: [
//           SortButton(onTap: () {
//             sortBottomSheet(context);
//           }),
//           SizedBox(width: 4),
//           RpFilterChip(selectedSort: selectedSort),
//         ],
//       ),
//     );
//   }
//
//   Widget countLine() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text("${countData[selectedChip] ?? ""} Items",
//               style: AppFonts.f40013),
//           Text(
//               "Total AUM $rupee ${Utils.formatNumber(totalAum[selectedChip], isAmount: true)}",
//               style:
//                   cardHeadingSmall.copyWith(color: Config.appTheme.themeColor)),
//         ],
//       ),
//     );
//   }
// }
