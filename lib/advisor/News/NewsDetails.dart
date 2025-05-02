import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/pojo/BlogDetailsResponse.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';

import '../../api/AdminApi.dart';
import '../../rp_widgets/RpAppBar.dart';
import '../../utils/Utils.dart';

class NewsDetails extends StatefulWidget {
  const NewsDetails({super.key, required this.id, required this.title});
  final int id;
  final String title;
  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  String client_name = GetStorage().read("client_name");
  int id = 0;
  String title = "";
  String htmlStrings = "";
  BlogDetailsResponse detailsResponse = BlogDetailsResponse();

  int user_id = GetStorage().read('mfd_id');

  @override
  void initState() {
    super.initState();

    id = widget.id;
    title = widget.title;

    Future.delayed(Duration.zero, () {});
  }

  Future getArticlesDetails() async {
    EasyLoading.show();

    Map<String, dynamic> data = await AdminApi.getNewsDetails(
        news_id: id, client_name: client_name, user_id: user_id);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    htmlStrings = data['news']['content'];
    EasyLoading.dismiss();
  }

  Future getData() async {
    await getArticlesDetails();
    return 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Config.appTheme.mainBgColor,
          appBar: rpAppBar(
              title: Utils.getFirst13(title, count: 18),
              bgColor: Config.appTheme.themeColor,
              /*actions: [
              IconButton(onPressed: () {
                EasyLoading.showInfo("Under Development");
              }, icon: Icon(Icons.share)),
            ],*/
              foregroundColor: Colors.white),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8,0 , 8, 0),
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child:  Html(data: htmlStrings)
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
              ],
            ),
          ),
        );
      },
    );
  }
}
