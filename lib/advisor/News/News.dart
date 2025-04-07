import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/advisor/News/NewsDetails.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/rp_widgets/SearchText.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  late double devWidth, devHeight;
  String selectedCategory = "Mutual Fund";
  String searchKey = "";
  Timer? searchOnStop;
  int userId = getUserId();
  String clientName = GetStorage().read("client_name");

  //String selectedType = "Mutual Fund";
  //String selectedValue = "mutual fund";
  String selectedType = " ";
  String selectedValue = " ";
  int total_count = 0;

  bool isSearching = false;

  ScrollController scrollController = ScrollController();
  int page_id = 1;
  bool isFirst = true;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  Future scrollListener() async {
    double extentAfter = scrollController.position.extentAfter;
    if (searchKey.isNotEmpty) return;
    if (extentAfter < 100 &&
        scrollController.position.atEdge &&
        total_count != newsList.length) {
      page_id++;
      await getNews(merge: true);
      setState(() {});
    }
  }

  void searchHandler(String search) {
    isSearching = true;
    print("news searchKey = $searchKey");
    setState(() {
      searchKey = search;
      isSearching = searchKey.isEmpty ? false : true;
    });

    const duration = Duration(milliseconds: 1000);
    if (searchOnStop != null) {
      searchOnStop!.cancel();
    }

    setState(() {
      searchOnStop = Timer(duration, () async {
        page_id = 1;
        await getNews();
        setState(() {});
      });
    });
  }

  Map buttonMap = {
    "Mutual Fund": "mutual fund",
    "BFSI Industry": "bfsi industry",
    "General": "general",
  };

  final List catList = [
    "Asset Allocation",
    "Balance Funds",
    "Debt Funds",
    "Cash Flow Planning",
    "Education Planning",
    "General Insurance",
    "IncomeTax",
    "Life Insurance",
  ];
  List newsList = [];

  Future getNews({bool merge = false}) async {
    EasyLoading.show();
    // if (!merge) {
    //   if (newsList.isNotEmpty) return 0;
    // }

    Map data = await AdminApi.getNews(
        user_id: userId,
        client_name: clientName,
        category: selectedValue,
        search: searchKey,
        page_id: page_id);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    total_count = data['total_count'];
    print('total_count = $total_count');
    print('articleList length = ${newsList.length}');
    if (merge) {
      List newArticles = data['news_list'];
      newsList.addAll(newArticles);
    } else {
      newsList = data['news_list'];
    }
    EasyLoading.dismiss();
    return 0;
  }

  Future getDatas() async {
    if (!isFirst) return 0;
    await getNews();
    isFirst = false;
    isLoading = false;
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
              appBar: AppBar(
                backgroundColor: Config.appTheme.themeColor,
                leadingWidth: 0,
                toolbarHeight: 120,
                elevation: 1,
                leading: SizedBox(),
                title: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "News",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SearchText(
                          hintText: "Search",
                          onChange: (val) => searchHandler(val),
                        ),
                      ],
                    ),
                    SizedBox(height: 16)
                  ],
                ),
              ),
              body: displayPage(),
            ),
          );
        });
  }

  String getFirst13(String text) {
    String s = text.split(":").last;
    if (s.length > 13) s = s.substring(0, 13);
    return s;
  }

  String getFirst40(String text) {
    String s = text.split(":").last;
    if (s.length > 40) s = '${s.substring(0, 40)}...';
    return s;
  }

  Widget displayPage() {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 10, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: !isSearching,
                  child: Expanded(
                    child: SizedBox(
                      height: 60,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: buttonMap.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          String title = buttonMap.keys.elementAt(index);
                          bool isSelected = selectedType == title;
                          buttonMap[selectedType];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MyButton(
                              title: title,
                              index: index,
                              isSelected: isSelected,
                              onPressed: () async {
                                selectedType = title;
                                selectedValue = buttonMap[selectedType];
                                print("Selected value: $selectedValue");
                                page_id = 1;
                                newsList = [];
                                await getNews();
                                setState(() {});
                                print('Button $title pressed');
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (!isSearching)
                    ? Text(
                        "Latest News on Mutual Fund",
                        style: AppFonts.f50014Black.copyWith(
                            fontSize: 16, color: Config.appTheme.themeColor),
                      )
                    : Text(
                        "${newsList.length} Search Items",
                        style: AppFonts.f40013
                            .copyWith(color: AppColors.arrowGrey),
                      ),
                Text(
                  " ",
                  style: AppFonts.f50012.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
          displayPageNews(),
          SizedBox(
            height: devHeight * 0.05,
          ),
        ],
      ),
    );
  }

  Widget displayPageNews() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (isSearching)
              ? (newsList.isEmpty && !isLoading)
                  ? noNewsData()
                  : ListView.builder(
                      itemCount: newsList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        Map data = newsList[index];
                        return searchNewsCard(data);
                      },
                    )
              : (newsList.isEmpty && !isLoading)
                  ? noNewsData()
                  : ListView.builder(
                      itemCount: newsList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        Map data = newsList[index];
                        return newsCard(data);
                      },
                    ),
          SizedBox(
            height: devHeight * 0.05,
          ),
        ],
      ),
    );
  }

  Widget newsCard(Map data) {
    return InkWell(
      onTap: () {
        print("blogcard tab");
        print(data['title']);
        print("disqus_url blogs = $data['disqus_url']");
        Get.to(NewsDetails(
          id: data['news_id'],
          title: data['title'],
        ));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Card(
          elevation: 0,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            data['title'],
                            style: AppFonts.f70018Black.copyWith(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            getFirst40(data['small_content']),
                            style: AppFonts.f40013,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${data['create_date']} • ${data['source_name']}',
                            style: AppFonts.f40013.copyWith(
                                fontSize: 10,
                                color: Config.appTheme.themeColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget noNewsData() {
    return Center(
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Image.asset("assets/news_no_data.png", height: 30),
            //Icon(Icons.close),
            SizedBox(height: 10),
            Text("No news found.", style: AppFonts.f40013),
          ],
        ),
      ),
    );
  }

  Widget searchNewsCard(Map data) {
    return InkWell(
      onTap: () {
        print(data['title']);
        print("disqus_url blogs = $data['disqus_url']");
        Get.to(NewsDetails(
          id: data['news_id'],
          title: data['title'],
        ));

        /*Get.to(WebviewContent(
          webViewTitle: data['title'],
          disqusUrl: data['disqus_url'],
        ));*/
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Card(
          elevation: 0,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            data['title'],
                            style: AppFonts.f50014Black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${data['create_date']}',
                            style: AppFonts.f40013,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String title;
  final int index;
  final bool isSelected;
  final VoidCallback onPressed;

  const MyButton({
    Key? key,
    required this.title,
    required this.index,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          isSelected ? Config.appTheme.themeColor : Colors.white,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          isSelected ? Colors.white : Config.appTheme.themeColor,
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: isSelected
                  ? Config.appTheme.themeColor
                  : Config.appTheme.themeColor,
            ),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          if (title == "Category")
            Icon(Icons.keyboard_arrow_down,
                color: isSelected ? Colors.white : Config.appTheme.themeColor),
        ],
      ),
    );
  }
}
