import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mymfbox2_0/common/calculators/ShareViaEmail.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/Utils.dart';
import 'package:http/http.dart' as http;

class SharedWidgets extends StatelessWidget {
  SharedWidgets({super.key});
  int user_id = getUserId();
  List bottomSheetData = [
    {"type": "download", "title": "Download", "img": "assets/file_save.png"},
    {
      "type": "email",
      "title": "Share via email",
      "img": "assets/forward_to_inbox.png",
    }
  ];

  void shareBottomSheet(BuildContext context, String url) {
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(7),
                    // padding: EdgeInsets.symmetric(horizontal: devWidth * 0.03),
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
                          "   Share",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        listContainer(url),
                      ],
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

  Widget listContainer(String url) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: bottomSheetData.length,
        separatorBuilder: (context, index) {
          return Padding(padding: EdgeInsets.symmetric(horizontal: 16));
        },
        itemBuilder: (context, index) {
          Map data = bottomSheetData[index];
          String title = data['title'];
          String imagePath = data['img'];
          String type = data['type'];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: InkWell(
              onTap: () async {
                String msgUrl = "";

                if (index == 0) {
                  EasyLoading.show();
                  String downloadurl = url + "&user_id=$user_id&type=download";
                  print("downloadurl $downloadurl");
                  http.Response response =
                      await http.post(Uri.parse(downloadurl));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  String resUrl = data['msg'];
                  print("download $downloadurl");
                  rpDownloadFile(url: resUrl, context: context, index: index);
                  EasyLoading.dismiss();
                  Get.back();
                } else if (index == 1) {
                  print("ShareViaEmail = $url");
                  Get.to(
                    () => ShareViaEmail(url: url),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Row(
                  children: [
                    Image.asset(
                      imagePath,
                      color: Config.appTheme.themeColor,
                      width: 32,
                      height: 32,
                    ),
                    SizedBox(
                      width: 220,
                      child: Text(
                        title,
                        style: AppFonts.f50014Black
                            .copyWith(color: Config.appTheme.themeColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> rpDownloadFile(
      {required String url,
        required BuildContext context,
        required int index}) async {
    Dio dio = Dio();
    String dirloc = "";

    if (Platform.isIOS) {
      if (await Permission.storage.request().isGranted)
        dirloc = (await getTemporaryDirectory()).path;
      // else
      //   showError();
    }
    // android
    else if (Platform.isAndroid) {
      // if (await Permission.storage.request().isGranted)
      dirloc = (await getExternalStorageDirectory())?.path ?? "";
    }
    print("Url == $url");
    if (index == 2) {
      Fluttertoast.showToast(
          msg: url,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Config.appTheme.themeColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    try {
      EasyLoading.show(status: 'loading...');
      FileUtils.mkdir([dirloc]);
      String fileName = url.substring(url.lastIndexOf("/") + 1);
      fileName = "/$fileName";
      await dio.download(url, dirloc + fileName,
          onReceiveProgress: (receivedBytes, totalBytes) {});

      EasyLoading.dismiss();
      final _result = await OpenFile.open(dirloc + fileName);
      Fluttertoast.showToast(
          msg: _result.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Config.appTheme.themeColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      print('Error opening PDF: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(); // Placeholder widget
  }
}


/*
Future<void> rpDownloadFile(
    {required String url, required BuildContext context}) async {
  // EasyLoading.show(status: 'loading...');
  Dio dio = Dio();
  String dirloc = "";

  if (Platform.isIOS) {
    if (await Permission.storage.request().isGranted)
      dirloc = (await getTemporaryDirectory()).path;
    else
      showError();
  }
  // android
  else if (Platform.isAndroid) {
    if (await Permission.storage
        .request()
        .isGranted) // Request storage permission instead of photos permission
      dirloc = (await getExternalStorageDirectory())?.path ?? "";
    else
      showError();
  }

  *//*try {
      EasyLoading.show(status: 'loading...');
      FileUtils.mkdir([dirloc]);
      String fileName = url.substring(url.lastIndexOf("/") + 1);
      // Remove the '/' before the fileName
      // fileName = "/$fileName"; // Remove this line
      await dio.download(url, '$dirloc/$fileName', // Concatenate dirloc and fileName without '/'
          onReceiveProgress: (receivedBytes, totalBytes) {});

      EasyLoading.dismiss();
      //OpenFile.open('$dirloc/$fileName');

      final _result = await OpenFile.open('$dirloc/$fileName');
      print("result $_result");

      Fluttertoast.showToast(
          msg: _result.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Config.appTheme.themeColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      Utils.showError(context, e.toString());
    }*//*
  print("Url == $url");
  try {
    final dir = await getExternalStorageDirectory();
    final filename = url.substring(url.lastIndexOf("/") + 1);
    final filePath = '${dir!.path}/$filename';
    final dio = Dio();
    await dio.download(url, filePath);
    final _result = await OpenFile.open(filePath);
    print("Result: $_result");
  } catch (e) {
    print('Error opening PDF: $e');
  }
}

void showError() {
  Fluttertoast.showToast(
      msg: "Download Successfully",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Config.appTheme.themeColor,
      textColor: Colors.white,
      fontSize: 16.0);
}*/