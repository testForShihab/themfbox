import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/pojo/NewFundOfferingPojo.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';

class NewFundOffering extends StatefulWidget {
  const NewFundOffering({super.key});

  @override
  State<NewFundOffering> createState() => _NewFundOfferingState();
}

class _NewFundOfferingState extends State<NewFundOffering> {
  late double devWidth, devHeight;
  List<NfoFundOffering> nfoFundOfferingPojo = [];
  String selectedSort = "A to Z";
  String client_name = GetStorage().read("client_name");

  List sortList = [
    "Lumpsum",
    "A to Z",
    "SipMinimumAmount (High to Low)",
    "Benchmark (Low to High)"
  ];

  String benchmark = "All";
  bool isLoading = true;

  List nfoDetails = [];

  List amcList = [];
  List selectedAmcList = [];

  Future getDatas() async {
    await getNfoDetails();
    isLoading = false;
    sortOptions();
    return 0;
  }

  Future getNfoDetails() async {
    if (nfoDetails.isNotEmpty) return 0;
    try {
      Map data = await Api.getNfoDetails(client_name: client_name);

      if (data['status'] != 200) {
        Utils.showError(context, data['msg']);
        return -1;
      }

      nfoDetails = data['list'];
      convertListToObj();
    } catch (e) {
      print("exception at = $e");
    }
    return 0;
  }

  convertListToObj() {
    nfoFundOfferingPojo = [];

    for (var element in nfoDetails) {
      nfoFundOfferingPojo.add(NfoFundOffering.fromJson(element));
    }
    nfoFundOfferingPojo.sort((a, b) => b.benchmark!.compareTo(a.benchmark!));
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return DefaultTabController(
            length: 6,
            child: Scaffold(
                backgroundColor: Config.appTheme.mainBgColor,
                //backgroundColor: Color(0XFFECF0F0),
                appBar: AppBar(
                  backgroundColor: Config.appTheme.themeColor,
                  leadingWidth: 0,
                  toolbarHeight: 60,
                  elevation: 1,
                  leading: SizedBox(),
                  title: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              )),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: (){
                              Get.back();
                            },
                            child: Text(
                              "New Fund Offering (NFO)",
                              style: AppFonts.f50014Black
                                  .copyWith(fontSize: 20, color: Colors.white),
                            ),
                          ),
                          //Spacer(),
                          //MfAboutIcon(context: context),
                        ],
                      ),
                      SizedBox(height: 20),
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showSortFilter();
                            },
                            child: appBarNewColumn(
                                "Sort By",
                                selectedSort,
                                Image.asset(
                                  'assets/mobile_data.png',
                                  color: Config.appTheme.themeColor,
                                  height: 18,
                                )),
                          ),
                        ],
                      ),*/
                    ],
                  ),
                ),
                body: displayPage()),
          );
        });
  }

  String getFirst13(String text) {
    String s = text.split(":").last;
    if (s.length > 13) s = s.substring(0, 13);
    return s;
  }

  Widget appBarNewColumn(String title, String value, Widget suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14, color: Colors.white)),
        Container(
          width: devWidth * 0.90,
          padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Config.appTheme.overlay85,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Row(
              children: [
                Text(value,
                    style: TextStyle(
                        color: Config.appTheme.themeColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Spacer(),
                suffix
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget displayPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${nfoDetails.length} NFOs",
                style: TextStyle(
                    color: Color(0XFFB4B4B4), fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            (isLoading)
                ? Utils.shimmerWidget(devHeight * 0.8,
                    margin: EdgeInsets.all(0))
                : (nfoDetails.isEmpty)
                    ? NoData()
                    : ListView.builder(
                        itemCount: nfoDetails.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          // Map<String, dynamic> data = performanceList[index];
                          // PerformanceReturnsPojo performanceReturns =
                          //     PerformanceReturnsPojo.fromJson(data);

                          return fundCard(nfoFundOfferingPojo[index]);
                        },
                      ),
            SizedBox(
              height: devHeight * 0.05,
            )
          ],
        ),
      ),
    );
  }

  showAboutSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SizedBox(
            height: devHeight * 0.7,
            child: StatefulBuilder(builder: (_, bottomState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("  About",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close))
                    ],
                  ),
                  Divider(),
                  Container(
                    // decoration: BoxDecoration(color: Colors.white),
                    alignment: Alignment.center,
                    child: Text(
                      "\nMost consistent funds consisting of Top 10 Mutual Fund Schemes in each category"
                      " have been chosen based on average rolling returns and consistency with which funds have"
                      " beaten category average returns. \n\nWe have ranked schemes based on these two parameters "
                      "using our proprietary algorithm and are showing the most consistent schemes for each category."
                      " Note that we have ranked schemes which have performance track records of at least 5 years "
                      "(consistency cannot be measured unless a scheme has sufficiently long track record covering"
                      "multiple market cycles e.g. bull market, bear market,sideways market etc.). \n\nAlso note that,"
                      "schemes whose AUMs have not yet reached Rs 500 Crores have been excluded from the ranking.",
                      maxLines: 20,
                      softWrap: true,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              );
            }),
          );
        });
  }

  Widget appBarColumn(String title, String value, Widget suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14, color: Colors.white)),
        Container(
          width: devWidth * 0.42,
          padding: EdgeInsets.fromLTRB(7, 5, 7, 5),
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: Color(0XFFFFFFFF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Row(
              children: [
                Text(value,
                    style: TextStyle(
                        color: Config.appTheme.themeColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Spacer(),
                suffix
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget fundCard(NfoFundOffering nfoFundOffering) {
    num temp = nfoFundOffering.lumpsumMinimumAmount ?? 0;
    String lumpAmt = temp.toStringAsFixed(0);
    final lumpsumMinimumAmount = Utils.formatNumber(num.parse(lumpAmt),
        isAmount: false); //formatter.format(num.parse(lumpAmt));

    num tempMinSipAmt = nfoFundOffering.sipMinimumAmount ?? 0;
    String newFundMinSip = tempMinSipAmt.toStringAsFixed(0);
    final minSipAmount = Utils.formatNumber(num.parse(newFundMinSip),
        isAmount: false); //formatter.format(num.parse(lumpAmt));

    // print(lumpsumMinimumAmount);
    // print("temp $lumpAmt");
    return GestureDetector(
      onTap: () {
        //Get.to(Newfundofferingdetails());
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          children: [
            //1st row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils.getImage(nfoFundOffering.logo ?? "", 32),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Text(nfoFundOffering.schemeAmfi ?? "",
                      style: AppFonts.f50014Black),
                ),

                /* Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0XFFB4B4B4),
                ),*/
              ],
            ),

            SizedBox(height: 8),
            //2nd row
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColumnText(
                      title: "Start Date",
                      value: nfoFundOffering.startDate ?? "",
                      valueStyle: AppFonts.f50014Black,
                    ),
                    ColumnText(
                      title: "End Date",
                      value: nfoFundOffering.endDate ?? "",
                      alignment: CrossAxisAlignment.center,
                      valueStyle: AppFonts.f50014Black,
                    ),

                  ],
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dottedLine() {
    List<Widget> line = [];
    for (int i = 0; i < devWidth * 0.11; i++)
      line.add(Text("-", style: TextStyle(color: Colors.grey[300])));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: line,
    );
  }

  Widget infoColumn(String title, String value,
      {Color? color, CrossAxisAlignment? alignment}) {
    return Column(
      crossAxisAlignment: alignment ?? CrossAxisAlignment.start,
      children: [
        Text(title),
        Text(value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  showSortFilter() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        builder: (context) {
          return StatefulBuilder(builder: (_, bottomState) {
            return SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(7),
                child: Column(
                  children: [
                    BottomSheetTitle(title: "Sort By"),
                    Divider(),
                    ListView.builder(
                      itemCount: sortList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            selectedSort = sortList[index];

                            bottomState(() {});
                            sortOptions();
                            setState(() {});
                            Get.back();
                          },
                          child: Row(
                            children: [
                              Radio(
                                  value: sortList[index],
                                  groupValue: selectedSort,
                                  activeColor: Config.appTheme.themeColor,
                                  onChanged: (val) {
                                    selectedSort = sortList[index];
                                    bottomState(() {});
                                    sortOptions();
                                    setState(() {});
                                    Get.back();
                                  }),
                              Text(sortList[index])
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  sortOptions() {
    if (selectedSort.contains("Lumpsum")) {
      print("if Lumpsum");
      nfoFundOfferingPojo.sort(
          (a, b) => b.lumpsumMinimumAmount!.compareTo(a.lumpsumMinimumAmount!));
    }
    if (selectedSort.contains("SipMinimumAmount")) {
      print("if SipMinimumAmount");
      nfoFundOfferingPojo
          .sort((a, b) => b.sipMinimumAmount!.compareTo(a.sipMinimumAmount!));
    }
    if (selectedSort.contains("BenchMark")) {
      print("if BenchMark");
      nfoFundOfferingPojo.sort((a, b) => a.benchmark!.compareTo(b.benchmark!));
    }
    if (selectedSort == "A to Z") {
      print("if A to Z");
      nfoFundOfferingPojo
          .sort((a, b) => a.schemeAmfi!.compareTo(b.schemeAmfi!));
    }
  }
}
