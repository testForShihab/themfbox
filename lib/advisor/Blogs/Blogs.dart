import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/advisor/Blogs/BlogDetails.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/rp_widgets/SearchText.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class Blogs extends StatefulWidget {
  const Blogs({super.key});

  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  late double devWidth, devHeight;
  String selectedCategory = "Category";
  String selectedAuthor = "Author";
  String searchKey = "";
  String blogCategory = "";
  String blogAuthor = "";
  Timer? searchOnStop;
  int userId = getUserId();

  String clientName = GetStorage().read("client_name");
  ScrollController scrollController = ScrollController();
  bool isFirst = true;
  int pageId = 1;
  bool blogsFetching = false;
  bool isLoading = true;
  int totalCount = 0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  Future scrollListener() async {
    double extentAfter = scrollController.position.extentAfter;

    if (extentAfter < 100 &&
        scrollController.position.atEdge &&
        totalCount != articleList.length) {
      pageId++;
      await getArticles(merge: true);
      setState(() {});
    }
  }

  void searchHandler(String search) {
    print("Searchkey $search");

    isSearching = true;
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
        pageId = 1;
        await getArticles();
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Map buttonMap = {
    "Most Recent": "recent",
    "Popular": "popular",
    "Category": "category",
    "Author": "author",
  };
  String selectedType = "Most Recent";
  String selectedValue = "recent";
  List categoryList = [];
  List authorList = [];
  List articleList = [];

  bool isSearching = false;

  Future getCategoryList() async {
    if (categoryList.isNotEmpty) return 0;

    Map data = await AdminApi.getCategoryList(
        user_id: userId, client_name: clientName);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    categoryList = data['category_list'];
    return 0;
  }

  Future getAuthorList() async {
    if (authorList.isNotEmpty) return 0;
    print("user_id Blogs = $userId");
    Map data =
        await AdminApi.getAuthorList(user_id: userId, client_name: clientName);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    authorList = data['author_list'];
    return 0;
  }

  Future getArticles({bool merge = false}) async {
    print("merge = $merge");
    EasyLoading.show();
    // if (!merge) {
    //   if (articleList.isNotEmpty) return 0;
    // }
    Map data = await AdminApi.getArticles(
      user_id: userId,
      client_name: clientName,
      page_id: pageId,
      type: selectedValue,
      category: blogCategory,
      author: blogAuthor,
      search: searchKey,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    totalCount = data['total_count'];
    print('total_count = $totalCount');
    print('articleList length = ${articleList.length}');
    if (merge) {
      List newArticles = data['article_list'];
      articleList.addAll(newArticles);
    } else {
      articleList = data['article_list'];
    }
    print("articleList length ${articleList.length}");
    blogsFetching = false;
    EasyLoading.dismiss();
    return 0;
  }

  Future getDatas() async {
    if (!isFirst) return 0;
    await getCategoryList();
    await getAuthorList();
    await getArticles();
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
                            "Blogs",
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
    String s = text.split(":").first;
    if (s.length > 13) s = s.substring(0, 13);
    return s;
  }

  String getFirst40(String text) {
    String s = text.split(":").first;
    if (s.length > 40) s = '${s.substring(0, 40)}...';
    return s;
  }

  String getFirst80(String text) {
    String s = text.split(":").first;
    if (s.length > 80) s = '${s.substring(0, 80)}';
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
                                articleList = [];
                                await getArticles();
                                setState(() {});
                                if (index == 2) showCategory();
                                if (index == 3) showAuthors();
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
            padding: EdgeInsets.fromLTRB(24, 0, 0, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (!isSearching)
                    ? Expanded(
                        child: Text(
                          "Latest Saving, Investing & Mutual Fund Articles",
                          style: AppFonts.f50014Black
                              .copyWith(color: Config.appTheme.themeColor),
                        ),
                      )
                    : Text(
                        "${articleList.length} Search Items",
                        style: AppFonts.f40013
                            .copyWith(color: AppColors.arrowGrey),
                      ),
              ],
            ),
          ),
          displayPageBlogs(),
          SizedBox(
            height: devHeight * 0.05,
          ),
        ],
      ),
    );
  }

  Widget displayPageBlogs() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (isSearching)
              ? (articleList.isEmpty && !isLoading)
                  ? noBlogsData()
                  : ListView.builder(
                      itemCount: articleList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        Map data = articleList[index];
                        return searchBlogsCard(data);
                      },
                    )
              : (articleList.isEmpty && !isLoading)
                  ? noBlogsData()
                  : ListView.builder(
                      itemCount: articleList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        Map data = articleList[index];
                        return blogsCard(data);
                      },
                    ),
          SizedBox(
            height: devHeight * 0.05,
          ),
        ],
      ),
    );
  }

  Widget noBlogsData() {
    return Center(
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Image.asset("assets/blogs_no_data.png", height: 30),
            // Icon(Icons.close),
            SizedBox(height: 10),
            Text("No blogs found.", style: AppFonts.f40013),
          ],
        ),
      ),
    );
  }

  Widget blogsCard(Map data) {
    return InkWell(
      onTap: () {
        print("blogcard tab");
        print(data['title']);
        print("blogs id = $data['article_id']");
        Get.to(BlogDetails(
          id: data['article_id'],
          title: data['title'],
        ));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 200,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                data['home_image'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Placeholder();
                                },
                              ),
                            ),
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
                            data['title'],
                            style: AppFonts.f70018Black
                                .copyWith(fontSize: 14, color: Colors.black)
                                .copyWith(fontWeight: FontWeight.w700),
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
                            getFirst40(data['short_content']),
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
                            '${data['create_date']} • ${data['viewed_count']} Views • ${data['author_name']}',
                            style: AppFonts.f40013.copyWith(
                                color: Config.appTheme.themeColor,
                                fontSize: 10),
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

  Widget searchBlogsCard(Map data) {
    double screenWidth = MediaQuery.of(context).size.width;
    double aspectRatio = 80.3 / 80.0; // Calculate the aspect ratio

    return InkWell(
      onTap: () {
        print("blogcard tab");
        print(data['title']);
        print("disqus_url blogs = $data['disqus_url']");
        Get.to(BlogDetails(
          id: data['article_id'],
          title: data['title'],
        ));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: screenWidth *
                              0.3, // Set the width to 30% of the screen width, adjust as needed
                          height: screenWidth *
                              0.3 *
                              aspectRatio, // Calculate the height based on the aspect ratio
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                data['home_image'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Placeholder();
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getFirst80(data['title']),
                                style: AppFonts.f50014Black
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 8),
                              Text(
                                data['create_date'],
                                style: AppFonts.f40013
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
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

  showCategory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (_, bottomState) {
            return Container(
              height: devHeight * 0.72,
              padding: EdgeInsets.all(7),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Category",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: categoryList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            selectedCategory = categoryList[index];
                            bottomState(() {});
                            pageId = 1;
                            Get.back(result: selectedCategory);
                            blogCategory = categoryList[index];
                            articleList = [];
                            await getArticles();
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: categoryList[index],
                                groupValue: selectedCategory,
                                activeColor: Config.appTheme.themeColor,
                                onChanged: (val) async {
                                  selectedCategory = categoryList[index];
                                  bottomState(() {});
                                  pageId = 1;
                                  Get.back(result: selectedCategory);
                                  blogCategory = categoryList[index];
                                  articleList = [];
                                  await getArticles();
                                  setState(() {});
                                },
                              ),
                              Text(categoryList[index]),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  showAuthors() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        builder: (context) {
          return StatefulBuilder(builder: (_, bottomState) {
            return Container(
              height: devHeight * 0.72,
              padding: EdgeInsets.all(7),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Select Author",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      IconButton(
                          onPressed: () {
                            pageId = 1;
                            Get.back();
                          },
                          icon: Icon(Icons.close))
                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: authorList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            selectedAuthor = authorList[index];
                            bottomState(() {});
                            pageId = 1;
                            Get.back(result: selectedAuthor);
                            blogAuthor = authorList[index];
                            articleList = [];
                            await getArticles();
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: authorList[index],
                                groupValue: selectedAuthor,
                                activeColor: Config.appTheme.themeColor,
                                onChanged: (val) async {
                                  selectedAuthor = authorList[index];
                                  bottomState(() {});
                                  pageId = 1;
                                  Get.back(result: selectedAuthor);
                                  blogAuthor = authorList[index];
                                  articleList = [];
                                  await getArticles();
                                  setState(() {});
                                },
                              ),
                              Text(authorList[index]),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          });
        });
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
          if (title == "Category" || title == "Author")
            Icon(Icons.keyboard_arrow_down,
                color: isSelected ? Colors.white : Config.appTheme.themeColor),
        ],
      ),
    );
  }
}
