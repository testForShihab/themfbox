// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:mymfbox2_0/Investor/FundDetails.dart';
// import 'package:mymfbox2_0/api/ReportApi.dart';
// import 'package:mymfbox2_0/pojo/InvestmentSummaryPojo.dart';
// import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
// import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
// import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
// import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
// import 'package:mymfbox2_0/rp_widgets/PercentageBar.dart';
// import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
// import 'package:mymfbox2_0/rp_widgets/RpAboutIcon.dart';
// import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
// import 'package:mymfbox2_0/utils/AppColors.dart';
// import 'package:mymfbox2_0/utils/AppFonts.dart';
// import 'package:mymfbox2_0/utils/Config.dart';
// import 'package:mymfbox2_0/utils/Constants.dart';
// import 'package:mymfbox2_0/utils/Utils.dart';
// import 'package:scroll_date_picker/scroll_date_picker.dart';

// class IndividualSummary extends StatefulWidget {
//   const IndividualSummary({super.key, required this.user_id});
//   final int user_id;
//   @override
//   State<IndividualSummary> createState() => _IndividualSummaryState();
// }

// class _IndividualSummaryState extends State<IndividualSummary> {
//   late int user_id;
//   String client_name = GetStorage().read("client_name");
//   List<Color> colorList = [
//     Colors.purple,
//     Colors.orange,
//     Colors.green,
//     Colors.blue,
//     Colors.red,
//   ];

//   List summaryView = [
//     {
//       'initial': "C",
//       'title': "Purchase",
//       'color': Color(0xFF5DB25D),
//       'key': "family_purchase"
//     },
//     {
//       'initial': "D",
//       'title': "Switch In",
//       'color': Color(0xFF5DB25D),
//       'key': "family_switch_in"
//     },
//     {
//       'initial': "E",
//       'title': "Switch Out",
//       'color': Color(0xFFE79C23),
//       'key': "family_switch_out"
//     },
//     {
//       'initial': "F",
//       'title': "Redemption",
//       'color': Color(0xFFE79C23),
//       'key': "family_redemption"
//     },
//     {
//       'initial': "G",
//       'title': "Dividends",
//       'color': Color(0xFFE79C23),
//       'key': "family_dividend_payout"
//     },
//   ];

//   Map folioMap = {
//     "Live Folios": "Live",
//     "All Folios": "All",
//     "Non segregated Folios": "NonSegregated",
//   };
//   String selectedFolioType = "Live";
//   DateTime selectedFolioDate = DateTime.now();
//   ExpansionTileController folioController = ExpansionTileController();

//   InvestmentSummaryPojo invSummary = InvestmentSummaryPojo();

//   Future getInvestmentSummary() async {
//     if (invSummary.msg != null) return 0;

//     Map<String, dynamic> data = await ReportApi.getInvestmentSummary(
//         user_id: user_id, client_name: client_name);

//     if (data['status'] != 200) {
//       Utils.showError(context, data['msg']);
//       return -1;
//     }

//     invSummary = InvestmentSummaryPojo.fromJson(data);

//     return 0;
//   }

//   @override
//   void initState() {
//     //  implement initState
//     super.initState();
//     user_id = widget.user_id;
//   }

//   late double devWidth, devHeight;
//   @override
//   Widget build(BuildContext context) {
//     devWidth = MediaQuery.of(context).size.width;
//     devHeight = MediaQuery.of(context).size.height;
//     return FutureBuilder(
//         future: getInvestmentSummary(),
//         builder: (context, snapshot) {
//           return Scaffold(
//             backgroundColor: Config.appTheme.mainBgColor,
//             appBar: AppBar(
//               leading: SizedBox(),
//               leadingWidth: 0,
//               backgroundColor: Config.appTheme.themeColor,
//               foregroundColor: Colors.white,
//               title: GestureDetector(
//                 onTap: () {
//                   Get.back();
//                 },
//                 child: Row(
//                   children: [
//                     Icon(Icons.arrow_back),
//                     SizedBox(width: 10),
//                     Text("Investment Summary", style: AppFonts.appBarTitle),
//                     Spacer(),
//                     GestureDetector(
//                         onTap: () {
//                           showCustomizedSummaryBottomSheet();
//                         },
//                         child: Icon(Icons.filter_alt_outlined)),
//                     SizedBox(width: 12),
//                     RpAboutIcon(context: context),
//                   ],
//                 ),
//               ),
//             ),
//             body: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   topArea(),
//                   SizedBox(height: 26),
//                   middleArea(),
//                   SizedBox(height: 26),
//                   countArea(),
//                   SizedBox(height: 16),
//                   bottomArea(),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   getKeyByValue(Map map, String value) {
//     return map.keys.firstWhere((element) => map[element] == value);
//   }

//   ExpansionTileController portfolioDateController = ExpansionTileController();
//   showCustomizedSummaryBottomSheet() {
//     bool isToday = true;

//     showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(15),
//             topRight: Radius.circular(15),
//           ),
//         ),
//         builder: (context) {
//           return StatefulBuilder(builder: (context, bottomState) {
//             return Container(
//               height: devHeight * 0.60,
//               decoration: BoxDecoration(
//                 color: Config.appTheme.mainBgColor,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(15),
//                   topRight: Radius.circular(15),
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     BottomSheetTitle(title: "View Customized Summary"),
//                     Divider(height: 0),
//                     SizedBox(height: 8),
//                     Container(
//                       margin: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Theme(
//                         data: Theme.of(context)
//                             .copyWith(dividerColor: Colors.transparent),
//                         child: ExpansionTile(
//                           controller: folioController,
//                           title:
//                               Text("Folio Type", style: AppFonts.f50014Black),
//                           tilePadding: EdgeInsets.fromLTRB(16, 12, 16, 0),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                   "${getKeyByValue(folioMap, selectedFolioType)}",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 12,
//                                       color: Config.appTheme.themeColor)),
//                               DottedLine(),
//                             ],
//                           ),
//                           children: [
//                             ListView.builder(
//                               shrinkWrap: true,
//                               physics: NeverScrollableScrollPhysics(),
//                               itemCount: folioMap.length,
//                               itemBuilder: (context, index) {
//                                 String key = folioMap.keys.elementAt(index);
//                                 String value = folioMap.values.elementAt(index);

//                                 return InkWell(
//                                   onTap: () {
//                                     selectedFolioType = value;
//                                     folioController.collapse();
//                                     bottomState(() {});
//                                   },
//                                   child: Row(
//                                     children: [
//                                       Radio(
//                                         value: value,
//                                         groupValue: selectedFolioType,
//                                         onChanged: (temp) {
//                                           selectedFolioType = value;
//                                           folioController.collapse();
//                                           bottomState(() {});
//                                         },
//                                       ),
//                                       Text(key),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Theme(
//                           data: Theme.of(context)
//                               .copyWith(dividerColor: Colors.transparent),
//                           child: ExpansionTile(
//                             controller: portfolioDateController,
//                             title: Text("Portfolio Date",
//                                 style: AppFonts.f50014Black),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                     (isToday)
//                                         ? "Today"
//                                         : selectedFolioDate
//                                             .toString()
//                                             .split(" ")[0],
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 12,
//                                         color: Config.appTheme.themeColor)),
//                                 DottedLine(),
//                               ],
//                             ),
//                             children: [
//                               InkWell(
//                                 onTap: () {
//                                   isToday = true;
//                                   bottomState(() {});
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Radio(
//                                       value: true,
//                                       groupValue: isToday,
//                                       onChanged: (value) {
//                                         isToday = true;
//                                         bottomState(() {});
//                                       },
//                                     ),
//                                     Text("Today"),
//                                   ],
//                                 ),
//                               ),
//                               InkWell(
//                                 onTap: () {
//                                   isToday = false;
//                                   bottomState(() {});
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Radio(
//                                       value: false,
//                                       groupValue: isToday,
//                                       onChanged: (value) {
//                                         isToday = false;
//                                         bottomState(() {});
//                                       },
//                                     ),
//                                     Text("Select Specific Date"),
//                                   ],
//                                 ),
//                               ),
//                               Visibility(
//                                 visible: !isToday,
//                                 child: SizedBox(
//                                   height: 200,
//                                   child: ScrollDatePicker(
//                                     selectedDate: selectedFolioDate,
//                                     onDateTimeChanged: (value) {
//                                       selectedFolioDate = value;
//                                       bottomState(() {});
//                                     },
//                                   ),
//                                 ),
//                               )
//                             ],
//                           )),
//                     ),
//                     Container(
//                       height: 75,
//                       padding: EdgeInsets.all(16),
//                       color: Colors.white,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                               child: getCancelApplyButton(ButtonType.plain)),
//                           SizedBox(width: 16),
//                           Expanded(
//                               child: getCancelApplyButton(ButtonType.filled)),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               //),
//             );
//           });
//         });
//   }

//   Widget getCancelApplyButton(ButtonType type) {
//     if (type == ButtonType.plain)
//       return PlainButton(
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
//         text: "CLEAR ALL",
//         onPressed: () {},
//       );
//     else
//       return RpFilledButton(
//         text: "APPLY",
//         onPressed: () {
//           Get.back();
//           setState(() {});
//         },
//       );
//   }

//   int length = 0;
//   Widget countArea() {
//     List schemeList = invSummary.schemeList ?? [];
//     if (selectedType == "Schemes") length = schemeList.length;

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         children: [
//           Text("$length items"),
//           Spacer(),
//           SortButton(
//             onTap: () {
//               sortBottomSheet();
//             },
//             title: " Sort By",
//             icon: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 2),
//               child: Image.asset("assets/mobile_data.png", height: 14),
//             ),
//           ),
//           SizedBox(width: 16),
//           SortButton(
//             onTap: () {
//               if (xirrType == 'xirr')
//                 xirrType = 'absolute_return';
//               else
//                 xirrType = 'xirr';
//               setState(() {});
//             },
//             title: xirrMap[xirrType],
//             icon: Padding(
//               padding: EdgeInsets.only(left: 2),
//               child: Image.asset("assets/mobile_sort.png", height: 10),
//             ),
//             padding: EdgeInsets.symmetric(vertical: 3, horizontal: 4),
//           )
//         ],
//       ),
//     );
//   }

//   List sortOptions = ["Current Value", "Current Cost", "A to Z", "XIRR"];
//   String selectedSort = "Current Value";

//   sortBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(builder: (context, bottomState) {
//           return Column(
//             children: [
//               BottomSheetTitle(title: "Sort & Filter"),
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: sortOptions.length,
//                 itemBuilder: (context, index) {
//                   String option = sortOptions[index];

//                   return InkWell(
//                     onTap: () {
//                       selectedSort = option;
//                       bottomState(() {});
//                       applySort();
//                     },
//                     child: Row(
//                       children: [
//                         Radio(
//                           value: option,
//                           groupValue: selectedSort,
//                           onChanged: (value) {
//                             selectedSort = option;
//                             bottomState(() {});
//                             applySort();
//                           },
//                         ),
//                         Text(option),
//                       ],
//                     ),
//                   );
//                 },
//               )
//             ],
//           );
//         });
//       },
//     );
//   }

//   applySort() {
//     if (selectedType == "Schemes") schemeSort();
//     if (selectedType == "AMC") amcSort();
//     if (selectedType == "Category") categorySort();
//     Get.back();
//     setState(() {});
//   }

//   schemeSort() {
//     if (selectedSort == 'Current Value')
//       schemeList.sort((a, b) => b.marketValue!.compareTo(a.marketValue!));
//     if (selectedSort == 'Current Cost')
//       schemeList.sort((a, b) => b.purchaseCost!.compareTo(a.purchaseCost!));
//     if (selectedSort == 'A to Z')
//       schemeList.sort(
//           (a, b) => a.schemeAmfiShortName!.compareTo(b.schemeAmfiShortName!));
//     if (selectedSort == "XIRR")
//       schemeList.sort((a, b) => b.xirr!.compareTo(a.xirr!));
//   }

//   amcSort() {
//     if (selectedSort == 'Current Value')
//       amcList.sort((a, b) => b.marketValue!.compareTo(a.marketValue!));
//     if (selectedSort == 'Current Cost')
//       amcList.sort((a, b) => b.purchaseCost!.compareTo(a.purchaseCost!));
//     if (selectedSort == 'A to Z')
//       amcList.sort((a, b) => a.amc!.compareTo(b.amc!));
//     if (selectedSort == "XIRR")
//       amcList.sort((a, b) => b.xirr!.compareTo(a.xirr!));
//   }

//   categorySort() {
//     if (selectedSort == 'Current Value')
//       categoryList.sort((a, b) => b.marketValue!.compareTo(a.marketValue!));
//     if (selectedSort == 'Current Cost')
//       categoryList.sort((a, b) => b.purchaseCost!.compareTo(a.purchaseCost!));
//     if (selectedSort == 'A to Z')
//       categoryList.sort((a, b) => a.allocation!.compareTo(b.allocation!));
//     if (selectedSort == "XIRR")
//       categoryList.sort((a, b) => b.xirr!.compareTo(a.xirr!));
//   }

//   Widget bottomArea() {
//     if (selectedType == "Members") return investorArea();
//     if (selectedType == "Schemes") return schemeArea();
//     if (selectedType == "AMC") return amcArea();
//     if (selectedType == "Asset Class") return assetArea();
//     if (selectedType == "Category") return categoryArea();
//     return Text("Invalid Option");
//   }

//   List<SchemeList> schemeList = [];
//   Widget schemeArea() {
//     if (invSummary.msg == null) return Utils.shimmerWidget(400);
//     schemeList = invSummary.schemeList ?? [];
//     length = schemeList.length;

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: schemeList.length,
//       itemBuilder: (context, index) {
//         SchemeList scheme = schemeList[index];

//         return schemeCard(scheme);
//       },
//     );
//   }

//   List<InvestorList> investorList = [];
//   Widget investorArea() {
//     if (invSummary.msg == null) return Utils.shimmerWidget(400);
//     investorList = invSummary.investorList ?? [];
//     length = investorList.length;

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: investorList.length,
//       itemBuilder: (context, index) {
//         InvestorList investor = investorList[index];

//         return investorCard(investor, index);
//       },
//     );
//   }

//   List<AmcList> amcList = [];
//   Widget amcArea() {
//     if (invSummary.msg == null) return Utils.shimmerWidget(200);
//     amcList = invSummary.amcList ?? [];
//     length = amcList.length;

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: amcList.length,
//       itemBuilder: (context, index) {
//         AmcList scheme = amcList[index];

//         return amcCard(scheme);
//       },
//     );
//   }

//   List<BroadCategoryList> broadCategoryList = [];
//   Widget assetArea() {
//     if (invSummary.msg == null) return Utils.shimmerWidget(400);
//     broadCategoryList = invSummary.broadCategoryList ?? [];
//     length = broadCategoryList.length;

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: broadCategoryList.length,
//       itemBuilder: (context, index) {
//         BroadCategoryList scheme = broadCategoryList[index];
//         int totalColors = AppColors.colorPalate.length;
//         int colorIndex = index;
//         if (index > totalColors) colorIndex = index % totalColors;

//         return assetCard(scheme, colorIndex);
//       },
//     );
//   }

//   List<CategoryList> categoryList = [];
//   Widget categoryArea() {
//     if (invSummary.msg == null) return Utils.shimmerWidget(400);
//     categoryList = invSummary.categoryList ?? [];
//     length = categoryList.length;

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: categoryList.length,
//       itemBuilder: (context, index) {
//         CategoryList scheme = categoryList[index];
//         int totalColors = AppColors.colorPalate.length;
//         int colorIndex = index;
//         if (index > totalColors) colorIndex = index % totalColors;

//         return categoryCard(scheme, colorIndex);
//       },
//     );
//   }

//   Widget middleArea() {
//     return Container(
//       height: 50,
//       margin: EdgeInsets.only(left: 16),
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: typeList.length,
//         itemBuilder: (context, index) {
//           String type = typeList[index];

//           if (selectedType == type)
//             return getButton(text: type, type: ButtonType.filled);
//           return getButton(text: type, type: ButtonType.plain);
//         },
//         separatorBuilder: (BuildContext context, int index) =>
//             SizedBox(width: 16),
//       ),
//     );
//   }

//   Map xirrMap = {'xirr': "XIRR", 'absolute_return': "Abs Return"};
//   String xirrType = "xirr";
//   Widget schemeCard(SchemeList scheme) {
//     num allocation = scheme.allocation ?? 0;
//     Map map = scheme.toJson();

//     return InkWell(
//       onTap: () {
//         Get.to(() => FundDetails(
//               schemeName: "${scheme.schemeAmfiShortName}",
//               schemeCategory: "${scheme.category}",
//               schemeAmfiCode: "${scheme.schemeAmfiCode}",
//               currCost: scheme.purchaseCost ?? 0,
//               currValue: scheme.marketValue ?? 0,
//               xirr: "${scheme.xirr}",
//               schemeAmcLogo: "${scheme.amcLogo}",
//               folio: "${scheme.folioNo}",
//             ));
//         // Get.to(() => FamilyInvestmentSummaryDetails());
//       },
//       child: Container(
//         padding: EdgeInsets.all(16),
//         margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
//         decoration: BoxDecoration(
//             color: Colors.white, borderRadius: BorderRadius.circular(8)),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Image.network("${scheme.amcLogo}", height: 32),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: ColumnText(
//                     title: "${scheme.schemeAmfiShortName}",
//                     value: "Folio : ${scheme.folioNo}",
//                     titleStyle: AppFonts.f50014Black,
//                     valueStyle: AppFonts.f40013,
//                   ),
//                 ),
//                 Icon(
//                   Icons.arrow_forward_ios,
//                   size: 20,
//                   color: Config.appTheme.placeHolderInputTitleAndArrow,
//                 )
//               ],
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 PercentageBar(allocation.toDouble()),
//                 Text("($allocation %)",
//                     style: AppFonts.f40013.copyWith(fontSize: 12)),
//               ],
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ColumnText(
//                     title: "Current Cost",
//                     value: "$rupee ${Utils.formatNumber(scheme.purchaseCost)}"),
//                 ColumnText(
//                   title: "Current Value",
//                   value: "$rupee ${Utils.formatNumber(scheme.marketValue)}",
//                   alignment: CrossAxisAlignment.center,
//                 ),
//                 ColumnText(
//                   title: "${xirrMap[xirrType]}",
//                   value: "${map[xirrType]} %",
//                   alignment: CrossAxisAlignment.end,
//                   valueStyle: AppFonts.f50014Black
//                       .copyWith(color: Config.appTheme.defaultProfit),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget investorCard(InvestorList investor, int index) {
//     int colorIndex = index;
//     if (index >= colorList.length) colorIndex = index % colorIndex;
//     String invName = investor.invName.toString();
//     num allocation = investor.allocation ?? 0;
//     Map map = investor.toJson();

//     return InkWell(
//       onTap: () {},
//       child: Container(
//         padding: EdgeInsets.all(16),
//         margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
//         decoration: BoxDecoration(
//             color: Colors.white, borderRadius: BorderRadius.circular(8)),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 InitialCard(title: invName, bgColor: colorList[colorIndex]),
//                 SizedBox(width: 8),
//                 SizedBox(
//                     width: devWidth * 0.6,
//                     child: Text(invName, style: AppFonts.f50014Black)),
//                 Spacer(),
//                 Icon(
//                   Icons.arrow_forward_ios,
//                   size: 16,
//                   color: Config.appTheme.placeHolderInputTitleAndArrow,
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 PercentageBar(allocation.toDouble()),
//                 Text("($allocation %)",
//                     style: AppFonts.f40013.copyWith(fontSize: 12)),
//               ],
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ColumnText(
//                     title: "Current Cost",
//                     value:
//                         "$rupee ${Utils.formatNumber(investor.purchaseCost)}"),
//                 ColumnText(
//                   title: "Current Value",
//                   value: "$rupee ${Utils.formatNumber(investor.marketValue)}",
//                   alignment: CrossAxisAlignment.center,
//                 ),
//                 ColumnText(
//                   title: "${xirrMap[xirrType]}",
//                   value: "${map[xirrType]} %",
//                   alignment: CrossAxisAlignment.end,
//                   valueStyle: AppFonts.f50014Black
//                       .copyWith(color: Config.appTheme.defaultProfit),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget amcCard(AmcList scheme) {
//     Map map = scheme.toJson();

//     return Container(
//       padding: EdgeInsets.all(16),
//       margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(8)),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Image.network("${scheme.amcLogo}", height: 32),
//               SizedBox(width: 10),
//               Text("${scheme.amc}", style: AppFonts.f50014Black),
//             ],
//           ),
//           SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               PercentageBar(scheme.allocation!.toDouble()),
//               Text("(${scheme.allocation} %)",
//                   style: AppFonts.f40013.copyWith(fontSize: 12)),
//             ],
//           ),
//           SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ColumnText(
//                   title: "Current Cost",
//                   value: "$rupee ${Utils.formatNumber(scheme.purchaseCost)}"),
//               ColumnText(
//                 title: "Current Value",
//                 value: "$rupee ${Utils.formatNumber(scheme.marketValue)}",
//                 alignment: CrossAxisAlignment.center,
//               ),
//               ColumnText(
//                 title: "${xirrMap[xirrType]}",
//                 value: "${map[xirrType]} %",
//                 alignment: CrossAxisAlignment.end,
//                 valueStyle: AppFonts.f50014Black
//                     .copyWith(color: Config.appTheme.defaultProfit),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget assetCard(BroadCategoryList scheme, int colorIndex) {
//     Color color = AppColors.colorPalate[colorIndex];
//     Map map = scheme.toJson();

//     return Container(
//       padding: EdgeInsets.all(16),
//       margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(8)),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 height: 32,
//                 width: 32,
//                 decoration: BoxDecoration(
//                     color: color.withOpacity(0.4),
//                     borderRadius: BorderRadius.circular(5)),
//                 child: Icon(Icons.bar_chart_rounded, color: color),
//               ),
//               SizedBox(width: 10),
//               Text("${scheme.category}", style: AppFonts.f50014Black),
//             ],
//           ),
//           SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               PercentageBar(scheme.allocation!.toDouble()),
//               Text("(${scheme.allocation} %)",
//                   style: AppFonts.f40013.copyWith(fontSize: 12)),
//             ],
//           ),
//           SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ColumnText(
//                   title: "Current Cost",
//                   value: "$rupee ${Utils.formatNumber(scheme.purchaseCost)}"),
//               ColumnText(
//                 title: "Current Value",
//                 value: "$rupee ${Utils.formatNumber(scheme.marketValue)}",
//                 alignment: CrossAxisAlignment.center,
//               ),
//               ColumnText(
//                 title: xirrMap[xirrType],
//                 value: "${map[xirrType]} %",
//                 alignment: CrossAxisAlignment.end,
//                 valueStyle: AppFonts.f50014Black
//                     .copyWith(color: Config.appTheme.defaultProfit),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget categoryCard(CategoryList scheme, int colorIndex) {
//     Color color = AppColors.colorPalate[colorIndex];
//     Map map = scheme.toJson();

//     return Container(
//       padding: EdgeInsets.all(16),
//       margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(8)),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 height: 32,
//                 width: 32,
//                 decoration: BoxDecoration(
//                     color: color.withOpacity(0.4),
//                     borderRadius: BorderRadius.circular(5)),
//                 child: Icon(Icons.bar_chart_rounded, color: color),
//               ),
//               SizedBox(width: 10),
//               Text("${scheme.category}", style: AppFonts.f50014Black),
//             ],
//           ),
//           SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               PercentageBar(scheme.allocation!.toDouble()),
//               Text("(${scheme.allocation} %)",
//                   style: AppFonts.f40013.copyWith(fontSize: 12)),
//             ],
//           ),
//           SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ColumnText(
//                   title: "Current Cost",
//                   value: "$rupee ${Utils.formatNumber(scheme.purchaseCost)}"),
//               ColumnText(
//                 title: "Current Value",
//                 value: "$rupee ${Utils.formatNumber(scheme.marketValue)}",
//                 alignment: CrossAxisAlignment.center,
//               ),
//               ColumnText(
//                 title: xirrMap[xirrType],
//                 value: "${map[xirrType]} %",
//                 alignment: CrossAxisAlignment.end,
//                 valueStyle: AppFonts.f50014Black
//                     .copyWith(color: Config.appTheme.defaultProfit),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget getButton({required String text, required ButtonType type}) {
//     EdgeInsets padding = EdgeInsets.symmetric(horizontal: 16);
//     if (type == ButtonType.plain) {
//       return PlainButton(
//         text: text,
//         padding: padding,
//         onPressed: () {
//           selectedType = text;
//           selectedSort = "";
//           setState(() {});
//         },
//       );
//     } else {
//       return RpFilledButton(text: text, padding: padding);
//     }
//   }

//   bool showDetails = false;
//   Widget topArea() {
//     Summary summary = invSummary.summary ?? Summary();
//     num? currValue = summary.totalCurrentValue;
//     num? netInv = summary.familyNetAmount;
//     Map summaryMap = summary.toJson();

//     return Container(
//       color: Config.appTheme.themeColor,
//       padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "As on ${Utils.getFormattedDate()}",
//             style: AppFonts.f40016.copyWith(color: Colors.white),
//           ),
//           SizedBox(height: 10),
//           Row(
//             children: [
//               InitialCard(bgColor: Color(0xFF4155B9)),
//               SizedBox(width: 10),
//               whiteText("Current Value"),
//               Spacer(),
//               whiteText("$rupee ${Utils.formatNumber(currValue)}")
//             ],
//           ),

//           SizedBox(height: 16),
//           // #region initialCard
//           Row(
//             children: [
//               InitialCard(bgColor: Color(0xFF3C9AB6)),
//               SizedBox(width: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   whiteText("Net Investment"),
//                   Text(
//                     "(C+D-E-F-G)",
//                     style: AppFonts.f40013.copyWith(color: Colors.white),
//                   )
//                 ],
//               ),
//               Spacer(),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   whiteText("$rupee ${Utils.formatNumber(netInv)}"),
//                   GestureDetector(
//                     onTap: () {
//                       showDetails = !showDetails;
//                       setState(() {});
//                     },
//                     child: Text(
//                       "${(showDetails) ? "Hide" : "View"} details",
//                       style: AppFonts.f40013.copyWith(
//                           color: Colors.white,
//                           decorationColor: Colors.white,
//                           decoration: TextDecoration.underline),
//                     ),
//                   )
//                 ],
//               )
//             ],
//           ),
//           // #endregion,
//           SizedBox(height: 16),
//           Visibility(
//             visible: showDetails,
//             child: ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: summaryView.length,
//               itemBuilder: (context, index) {
//                 Map data = summaryView[index];

//                 String initial = data['initial'];
//                 Color color = data['color'];
//                 String title = data['title'];
//                 String key = data['key'];

//                 return summaryRow(
//                     initial: initial,
//                     bgColor: color,
//                     title: title,
//                     value: Utils.formatNumber(summaryMap[key]));
//               },
//             ),
//           ),
//           DottedLine(),
//           SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ColumnText(
//                 title: "Overall Gain",
//                 value: "$rupee ${Utils.formatNumber(summary.familyGain)}",
//                 titleStyle: AppFonts.f40013.copyWith(color: Colors.white),
//                 valueStyle: AppFonts.f50014Black
//                     .copyWith(color: Config.appTheme.defaultProfit),
//               ),
//               ColumnText(
//                 title: "Absolute Return",
//                 value: "${summary.absoluteReturn ?? 0} %",
//                 alignment: CrossAxisAlignment.center,
//                 titleStyle: AppFonts.f40013.copyWith(color: Colors.white),
//                 valueStyle: AppFonts.f50014Black
//                     .copyWith(color: Config.appTheme.defaultProfit),
//               ),
//               ColumnText(
//                 title: "XIRR",
//                 value: "${summary.portfolioReturn ?? 0} %",
//                 alignment: CrossAxisAlignment.end,
//                 titleStyle: AppFonts.f40013.copyWith(color: Colors.white),
//                 valueStyle: AppFonts.f50014Black
//                     .copyWith(color: Config.appTheme.defaultProfit),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//         ],
//       ),
//     );
//   }

//   Widget summaryRow({
//     required String initial,
//     required Color bgColor,
//     required String title,
//     required String value,
//   }) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 16),
//       child: Row(
//         children: [
//           InitialCard(title: initial, bgColor: bgColor),
//           SizedBox(width: 10),
//           whiteText(title),
//           Spacer(),
//           whiteText("$rupee $value")
//         ],
//       ),
//     );
//   }

//   Widget whiteText(String text) {
//     return Text(
//       text,
//       style: AppFonts.f50014Black.copyWith(color: Colors.white),
//     );
//   }
// }

// enum ButtonType {
//   plain,
//   filled,
// }
