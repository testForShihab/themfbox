import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/api/ResearchApi.dart';
import 'package:mymfbox2_0/research/SchemeInfo.dart';
import 'package:mymfbox2_0/research/benchMarkMonitors/BenchMarkMonitors.dart';
import 'package:mymfbox2_0/research/CategoryReturns.dart';
import 'package:mymfbox2_0/research/ExploreFundsCategoryWise.dart';
import 'package:mymfbox2_0/research/FundsCard.dart';
import 'package:mymfbox2_0/research/MFLumpsumCalculator.dart';
import 'package:mymfbox2_0/research/MFSipCalculator.dart';
import 'package:mymfbox2_0/research/MFStpCalculator.dart';
import 'package:mymfbox2_0/research/MFSwpCalculator.dart';
import 'package:mymfbox2_0/research/NewFundOffering/NewFundOffering.dart';
import 'package:mymfbox2_0/research/ExploreFundsAmcWise.dart';
import 'package:mymfbox2_0/research/rollingReturnVsCategory/RollingReturnsCategory.dart';
import 'package:mymfbox2_0/research/RolllingReturnsBenchMark/RollingReturnsBenchmark.dart';
import 'package:mymfbox2_0/research/annualReturns/AnnualReturns.dart';
import 'package:mymfbox2_0/research/categoryMonitor/CategoryMonitor.dart';
import 'package:mymfbox2_0/research/topConsistent/TopConsistent.dart';
import 'package:mymfbox2_0/research/topLumpsumFund/TopLumpsumFunds.dart';
import 'package:mymfbox2_0/research/topSipFund/TopSipFund.dart';
import 'package:mymfbox2_0/research/trailingReturns/TrailingReturns.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/ViewAllBtn.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import '../api/ApiConfig.dart';
import '../api/ProposalApi.dart';
import '../pojo/aum/AmcWiseAumPojo.dart';
import '../rp_widgets/RpAppBar.dart';
import 'package:http/http.dart' as http;

import '../rp_widgets/RpSmallTf.dart';

class MfResearch extends StatefulWidget {
  const MfResearch({super.key});

  @override
  State<MfResearch> createState() => _MfResearchState();
}

class _MfResearchState extends State<MfResearch> {
  int user_id = getUserId();
  int type_id = GetStorage().read("type_id") ?? 0;
  String client_name = GetStorage().read("client_name");
  late double devHeight, devWidth;

  List<Map<String, dynamic>> schemeSuggestions = [];
  List<Map<String, dynamic>> schemeSuggestionsTemp = [];

  late SearchResponse searchResponse;
  final fieldTextController = TextEditingController();
  ScrollController scrollController = ScrollController(initialScrollOffset: 50.0);
  String query = "";

  List cardData = [
    {
      'name': "VS Category",
      'img': "assets/vsCategory.png",
      'goTo': RollingReturnsCategory(),
    },
    {
      'name': "VS Benchmark",
      'img': "assets/vsBenchmark.png",
      'goTo': RollingReturnsBenchMark(),
    },
    {
      'name': "Category Monitor",
      'img': "assets/categoryMonitor.png",
      'goTo': CategoryMonitor(),
    },
    {
      'name': "Benchmark Monitor",
      'img': "assets/benchMarkMonitor.png",
      'goTo': BenchMarkMonitors(),
    },
    {
      'name': "Category Returns",
      'img': "assets/categoryReturns.png",
      'goTo': CategoryReturns(),
    },
    {
      'name': "SIP Calculators",
      'img': "assets/sipGreenCalc.png",
      'goTo': MFSipCalculator(),
    },
    {
      'name': "Lumpsum Calculators",
      'img': "assets/lumpsumGreenCalc.png",
      'goTo': MFLumpsumCalculator(),
    },
    {
      'name': "STP Calculators",
      'img': "assets/stpCalculator.png",
      'goTo': MfStpCalculator(),
    },
    {
      'name': "SWP Calculators",
      'img': "assets/swpCalculator.png",
      'goTo': MFSwpCalculator(),
    },
  ];

  List trailingReturnsList = [
    "Equity: Mid Cap",
    "Equity: Large Cap",
    "Equity: ELSS",
    "Equity: Flexi Cap",
    "Equity: Large and Mid Cap",
    "Debt: Floater"
  ];

  List tempList = [];
  bool isFirst = true;

  String selectedCategory = "Equity Schemes";
  String selectedTrailingReturns = 'Trailing Returns';
  String selectedSubCategory = "Equity: Large Cap";
  List allCategories = [];
  List subCategoryList = [];

  List<Color> topArcColors = [
    Color.fromRGBO(224, 224, 224, 1),
    Color.fromRGBO(224, 224, 224, 100),
  ];

  List amcList = [];
  List<AmcWiseAumPojo> amcListPojo = [];

  bool isLoading = true;
  String selectedArn = "All";

  bool _isCardVisible = false;

  Future getDatas() async {
    isLoading = true;

    await getBroadCategoryList();
    await getCategoryList();
    await getTopAmc();
    isFirst = false;
    isLoading = false;
    return 0;
  }

  Future getBroadCategoryList() async {
    if (allCategories.isNotEmpty) return 0;
    Map data = await Api.getBroadCategoryList(client_name: client_name);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    allCategories = data['list'];
    return 0;
  }

  Future getCategoryList() async {
    if (subCategoryList.isNotEmpty) return 0;

    Map data = await Api.getCategoryList(
        category: selectedCategory, client_name: client_name);
    if (data['status'] != SUCCESS) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    subCategoryList = data['list'];
    return 0;
  }

  Future getTopAmc() async {
    if (!isFirst) return 0;
    if (amcList.isNotEmpty) return 0;
    try {
      isLoading = true;
      Map data = await ResearchApi.getAllAmc(client_name: client_name);
      if (data['status'] != 200) {
        Utils.showError(context, data['msg']);
        return 0;
      }
      amcList = data['list'];
    } catch (e) {
      print("getTopAmc exception = $e");
    }
    isLoading = false;
    return 0;
  }

  // convertListToObj() {
  //   amcListPojo = [];
  //   for (var element in amcList) {
  //     amcListPojo.add(AmcWiseAumPojo.fromJson(element));
  //   }
  // }



  void init(String query) async {
    schemeSuggestionsTemp = [];
    schemeSuggestions = [];
    
    // Update to use new API call
    Map data = await httpAutoSuggestSchemes(
      user_id: user_id,
      query: query,
      client_name: client_name
    );
    
    // Cast the dynamic list to List<Map<String, dynamic>>
    schemeSuggestionsTemp = (data['list'] as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();

    List<String> amcList = Config.getEmpanelledAmcList(client_name);
    if(amcList.isNotEmpty){
      for (Map<String, dynamic> scheme in schemeSuggestionsTemp) {
        // Check if any AMC name matches the scheme name
        if (amcList.any((item) => 
            scheme['scheme_amfi_short_name'].toString().toLowerCase()
            .contains(item.toLowerCase()))) {
          schemeSuggestions.add(scheme);
        }
      }
    } else {
      schemeSuggestions = schemeSuggestionsTemp;
    }

    print(schemeSuggestions.length);
    setState(() {
      schemeSuggestions;
    });
  }

  Future httpAutoSuggestSchemes({
    required int user_id,
    required String query, 
    required String client_name,
  }) async {
    Map data = await PropoaslApi.autoSuggestAllMfSchemes(
      user_id: user_id, 
      query: query,
      client_name: client_name
    );
    
    print("url - $data");
    
    if (data['status'] == 200) {
      // Return the list directly since it's already decoded
      return data;
    } else {
      throw Exception('Failed to load suggestions');
    }
  }
  final FocusNode _searchFocusNode = FocusNode();
  @override
  initState() {
    super.initState();
    init(query);
    scrollController = ScrollController();
    fieldTextController.addListener(() {
      print(fieldTextController.text);
      init(fieldTextController.text);
    });
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus) {
        setState(() {
          _isCardVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
    fieldTextController.dispose();

  }


  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: (type_id == UserType.ADMIN)
                ? adminAppBar(title: "MF Research" ,hasAction: false)
                : rpAppBar(
                    title: "MF Research",
                    bgColor: Config.appTheme.themeColor,
                    foregroundColor: Colors.white),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: devWidth * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    topFilterArea(),
                    //SearchField(bgColor: Colors.white, hintText: "Search"),
                    SizedBox(height: 16),
                    Card(
                      color: Color(0xFFD8D8DF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(researchTitle),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        FundCard(
                          title: "Consistent\nFunds",
                          goTo: TopConsistent(),
                          icon: Image.asset('assets/consistentFund.png'),
                          iconColor: Colors.white,
                        ),
                        FundCard(
                          title: "Lumpsum\nReturns",
                          goTo: TopLumpsumFunds(),
                          icon: Image.asset('assets/lumpsumFund.png'),
                          iconColor: Colors.white,
                        ),
                        FundCard(
                          title: "SIP\nReturns",
                          goTo: TopSipFunds(),
                          icon: Image.asset('assets/sipFund.png'),
                          iconColor: Colors.white,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        FundCard(
                          title: "Annual\nReturns",
                          goTo: AnnualReturns(),
                          icon: Image.asset('assets/annualReturn.png'),
                          iconColor: Colors.white,
                        ),
                        FundCard(
                          title: "Trailing\nReturns",
                          goTo: TrailingReturns(),
                          icon: Image.asset('assets/trailingReturns.png'),
                          iconColor: Colors.white,
                        ),
                        FundCard(
                          title: "New Fund \nOffer (NFO)",
                          goTo: NewFundOffering(),
                          icon: Image.asset('assets/nfoFund.png'),
                          iconColor: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(height: devHeight * 0.02),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
                            child: Text(" Trailing Returns",
                                style: TextStyle(fontSize: 18)),
                          ),
                          SizedBox(
                            height: 70,
                            child: ListView.builder(
                                itemCount: trailingReturnsList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  String title = trailingReturnsList[index];
                                  return (selectedTrailingReturns == title)
                                      ? selectedTRCard(title)
                                      : tRCard(title);
                                }),
                          ),
                          SizedBox(height: 16)
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    returnsCard(
                      title: "Rolling Returns",
                      list: cardData.getRange(0, 2).toList(),
                    ),
                    SizedBox(height: 16),
                    returnsCard(
                      title: "Return Monitors",
                      list: cardData.getRange(2, 5).toList(),
                    ),
                    SizedBox(height: 16),
                    returnsCard(
                      title: "MF Return Calculators",
                      list: cardData.getRange(5, 9).toList(),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Explore Funds Category Wise",
                            style: AppFonts.f40016,
                          ),
                          SizedBox(height: 12),
                          categoryCard(),
                          SizedBox(height: 16),
                          subCategoryCard(),
                          SizedBox(height: 8),
                          ViewAllBtn(
                            onTap: () {
                              Get.to(ExploreFundsCategoryWise());
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                   // if (amcList.length > 3) fundWiseAmc(),
                  ],
                ),
              ),
              
            ),
          );
        });
  }



  Widget topFilterArea() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 50,
              child: TextFormField(
                focusNode: _searchFocusNode,
                controller: fieldTextController,
                textCapitalization: TextCapitalization.none,
                onTap: () {
                  setState(() {
                    _isCardVisible = true;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: fieldTextController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      fieldTextController.clear();
                      setState(() {
                        _isCardVisible = false;
                      });
                    },
                  )
                      : null,
                  hintText: "Search",
                  contentPadding: EdgeInsets.fromLTRB(10, 2, 12, 0),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.transparent)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.transparent)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
        if (_isCardVisible && schemeSuggestions.isNotEmpty)
          Positioned(
            child: Container(
              height: devHeight*0.324,
              margin: EdgeInsets.only(left:0, right: 0, top: 52, bottom: 0),
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 0),
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 2,
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(0),
                child: Stack(
                  children: [
                    Scrollbar(
                      thumbVisibility: true,
                      controller: scrollController,
                      thickness: 6,
                      child:Container(
                        color: Colors.white,
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: schemeSuggestions.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                  title: Text(
                                    schemeSuggestions[index]['scheme_amfi_short_name'] ?? '',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0XFF6F828E),
                                    ),
                                  ),
                                  onTap: () {
                                    final schemeShortName = schemeSuggestions[index]['scheme_amfi_short_name'].toString() ?? '';
                                    final schemeLogo = schemeSuggestions[index]['logo']?.toString() ?? '';
                                    setState(() {
                                      _isCardVisible = false;
                                      fieldTextController.clear();
                                    });
                                    Get.to(() => SchemeInfo(
                                      schemeShortName: schemeShortName,
                                      schemeLogo: schemeLogo,
                                      schemeName: schemeShortName,
                                    ));
                                  },
                                ),
                                if (index < schemeSuggestions.length - 1)
                                  Divider(
                                    endIndent: 12.0,
                                    thickness: 1.0,
                                     indent: 12.0,
                                    height: 1,
                                    color: Colors.grey[300],
                                  ),
                              ],
                            );
                          },
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }


  Widget fundWiseAmc() {
    if (amcList.isEmpty) return Utils.shimmerWidget(200);
    return Container(
      width: devWidth,
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Explore Funds AMC Wise",
            style: AppFonts.f40016,
          ),
          SizedBox(
            height: 15,
          ),
          if (amcList.length > 3) rpFundCard(amcList.getRange(1, 4).toList()),
          if (amcList.length > 4) rpFundCard(amcList.getRange(4, 7).toList()),
          if (amcList.length > 7)
            rpFundCard(amcList.getRange(7, 10).toList(), isLast: true),
        ],
      ),
    );
  }

  Widget rpFundCard(List list, {bool isLast = false}) {
    Map data1 = list[0];
    Map data2 = list[1];
    Map data3 = list[2];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FundCard(
          title:
              data1.isNotEmpty ? getFirst13(data1['amc_name'].toString()) : '',
          icon: data1.isNotEmpty
              ? /*Image.network(data1['amc_logo'])*/ Utils.getImage(
                  data1['amc_logo'], 32)
              : SizedBox(),
          color: Config.appTheme.Bg2Color,
          titleColor: Config.appTheme.themeColor,
          goTo: ExploreFundsAmcWise(
              amc_name: data1['amc_name'], amc_logo: data1['amc_logo']),
          topArcColors: topArcColors,
        ),
        FundCard(
          title: data2.isNotEmpty ? getFirst13(data2['amc_name']) : '',
          icon: data2.isNotEmpty
              ? /*Image.network(data2['amc_logo'])*/ Utils.getImage(
                  data2['amc_logo'], 32)
              : SizedBox(),
          color: Config.appTheme.Bg2Color,
          titleColor: Config.appTheme.themeColor,
          goTo: ExploreFundsAmcWise(
              amc_name: data2['amc_name'], amc_logo: data2['amc_logo']),
          topArcColors: topArcColors,
        ),
        FundCard(
          title: isLast
              ? 'View All AMCs'
              : getFirst13(data3['amc_name'].toString()),
          icon: isLast
              ? Icon(
                  Icons.arrow_forward,
                  color: Config.appTheme.themeColor,
                )
              : /*Image.network(data3['amc_logo']),*/ Utils.getImage(
                  data3['amc_logo'], 32),
          color: Config.appTheme.Bg2Color,
          titleColor: Config.appTheme.themeColor,
          goTo: isLast
              ? ExploreFundsAmcWise(amc_name: "", amc_logo: "")
              : ExploreFundsAmcWise(
                  amc_name: data3['amc_name'], amc_logo: data3['amc_logo']),
          topArcColors: topArcColors,
        ),
      ],
    );
  }

  Widget categoryCard() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allCategories.length,
        itemBuilder: (context, index) {
          Map temp = allCategories[index];

          return (selectedCategory == temp['name'])
              ? selectedCategoryChip("${temp['name']}", "")
              : InkWell(
                  onTap: () async {
                    setState(() {
                      selectedCategory = temp['name'];
                      subCategoryList = [];
                    });
                    await getCategoryList();
                  },
                  child: categoryChip("${temp['name']}", ""));
        },
      ),
    );
  }

  Widget subCategoryCard() {
    int length = subCategoryList.length;
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 16, 8), // Set padding on all sides
      child: SizedBox(
        height: 270,
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: (length > 5) ? 5 : length,
          itemBuilder: (context, index) {
            String temp = subCategoryList[index];
            String subCategory = temp;
            if (temp.contains(":")) {
              List list = subCategoryList[index].split(":");
              // category = list[0];
              subCategory = list[1].trim();
            }

            return InkWell(
              onTap: () async {
                Get.to(TrailingReturns(
                    // defaultCategory: extractBeforeSpace(selectedCategory),
                    defaultSubCategory: temp));
              },
              child: Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Color(0xffF8DFD5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(Icons.bar_chart, color: Colors.red, size: 20),
                  ),
                  SizedBox(width: 8), // Add spacing between icon and text
                  Expanded(
                      child: Text(
                    " $subCategory",
                    style: AppFonts.f50014Black,
                  )),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Config.appTheme.placeHolderInputTitleAndArrow,
                  )
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              DottedLine(verticalPadding: 4),
        ),
      ),
    );
  }

  Widget invBtnchipArea() {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allCategories.length,
        itemBuilder: (context, index) {
          Map temp = allCategories[index];

          return (selectedCategory == temp['name'])
              ? selectedCategoryChip("${temp['name']}", "${temp['count']}")
              : InkWell(
                  onTap: () async {
                    selectedCategory = temp['name'];
                    subCategoryList = [];
                    await getCategoryList();
                    //setState(() {});
                  },
                  child: categoryChip("${temp['name']}", "${temp['count']}"));
        },
      ),
    );
  }

  String extractBeforeSpace(String input) {
    // Find the index of the first space
    int spaceIndex = input.indexOf(' ');

    // If there is a space, extract the substring before it
    if (spaceIndex != -1) {
      return input.substring(0, spaceIndex);
    }

    // If there is no space, return the whole string
    return input;
  }

  Widget selectedCategoryChip(String name, String count) {
    List l = name.split(" ");

    name = "${l[0]}";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          color: Config.appTheme.themeColor,
          borderRadius: BorderRadius.circular(8)),
      child: Text(
        "$name",
        style: AppFonts.f50014Black.copyWith(color: Colors.white),
      ),
    );
  }

  Widget categoryChip(String name, String count) {
    List l = name.split(" ");
    if (l.length > 2)
      name = "${l[0]}";
    else
      name = "${l[0]}";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      margin: EdgeInsets.fromLTRB(0, 2, 12, 2),
      decoration: BoxDecoration(
          color: Color(0XFFF1F1F1), borderRadius: BorderRadius.circular(8)),
      child: Text(
        "$name",
        style: AppFonts.f50014Black,
      ),
    );
  }

  Widget tRCard(String title) {
    List list = title.split(":");
    String category = list[0];
    String subCategory = title;

    return InkWell(
      onTap: () {
        selectedSubCategory = title;
        Get.to(TrailingReturns(
            // defaultCategory: category,
            defaultSubCategory: subCategory));
        // selectedTrailingReturns = title;
       // setState(() {});
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 16, 0, 0),
        height: devHeight * 0.8,
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Color(0XFFF1F1F1), borderRadius: BorderRadius.circular(10)),
        child: Text(
          subCategory.split(":")[1].trim(),
          style: TextStyle(color: Config.appTheme.themeColor, fontSize: 18),
        ),
      ),
    );
  }

  Widget selectedTRCard(title) {
    String showTitle = title.substring(0, title.length - 8);
    print("title $title");
    return InkWell(
      onTap: () {
        print("selected sub category----->  $title");
        selectedSubCategory = title;
        Get.to(TrailingReturns(
            defaultCategory: "Equity Schemes",
            defaultSubCategory: selectedSubCategory));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: devHeight * 0.8,
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Config.appTheme.themeColor,
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          showTitle,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  Widget returnsCard({required String title, required List list}) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppFonts.f40016),
            SizedBox(height: 15),
            ListView.separated(
                itemCount: list.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  Map data = list[index];
                  String name = data['name'];
                  String img = data['img'];
                  Widget goTo = data['goTo'];

                  return InkWell(
                    onTap: () {
                      Get.to(goTo);
                    },
                    child: Container(
                      // color: Config.appTheme.mainBgColor,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Config.appTheme.mainBgColor,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            Container(
                                height: 50,
                                width: 60,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                        'assets/maskRight.png',
                                      ),
                                      fit: BoxFit.fill),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8)),
                                  //color: Color(0XFFF1F1F1),
                                ),
                                child: Container(
                                    margin: EdgeInsets.only(right: 14, left: 0),
                                    child: Image.asset(
                                      img,
                                      fit: BoxFit.fitHeight,
                                      color: Config.appTheme.themeColor,
                                    ))),
                            SizedBox(width: 10),
                            Text(name,
                                style: AppFonts.f50014Grey.copyWith(
                                    color: Config.appTheme.themeColor,
                                    fontSize: 15)),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Color(0XFFB4B4B4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(height: 15)),
          ],
        ),
      ),
    );
  }

  String getFirst13(String text) {
    String s = text.split(":").first;
    if (s.length > 13) s = '${s.substring(0, 13)}...';
    return s;
  }
}

class SearchResponse {
  int? status;
  String? statusMsg;
  String? msg;
  int? pageid;
  int? pageCount;
  int? totalCount;
  List<String>? list;
  bool? validScheme;

  SearchResponse(
      {this.status,
        this.statusMsg,
        this.msg,
        this.pageid,
        this.pageCount,
        this.totalCount,
        this.list,
        this.validScheme});

  SearchResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusMsg = json['status_msg'];
    msg = json['msg'];
    pageid = json['pageid'];
    pageCount = json['pageCount'];
    totalCount = json['totalCount'];
    list = json['list'].cast<String>();
    validScheme = json['validScheme'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_msg'] = this.statusMsg;
    data['msg'] = this.msg;
    data['pageid'] = this.pageid;
    data['pageCount'] = this.pageCount;
    data['totalCount'] = this.totalCount;
    data['list'] = this.list;
    data['validScheme'] = this.validScheme;
    return data;
  }
}
