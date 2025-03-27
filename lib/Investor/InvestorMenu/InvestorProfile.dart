import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/PlainButton.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../../api/ApiConfig.dart';
import '../../api/InvestorApi.dart';
import '../../pojo/UserDataPojo.dart';
import '../../rp_widgets/BottomSheetTitle.dart';
import '../../rp_widgets/CalculateButton.dart';
import '../../utils/Utils.dart';

class InvestorProfile extends StatefulWidget {
  const InvestorProfile({super.key});

  @override
  State<InvestorProfile> createState() => _InvestorProfileState();
}

class _InvestorProfileState extends State<InvestorProfile> {
  late double devHeight, devWidth;

  String? name = "";
  String? mobile = "";
  String? pan = "";
  String? email = "";
  String? dob = "";
  String addr = "";
  String? rmName = "";
  String? branch = "";
  String? subbrokerName = "";
  int user_id = GetStorage().read("user_id") ?? GetStorage().read("family_id");
  String client_name = GetStorage().read("client_name");
  List<dynamic> yearData = [];

  @override
  void initState() {
    //  implement initState
    super.initState();
  }

  UserDataPojo userDataPojo = UserDataPojo();
  Future getUser() async {
    if (userDataPojo.id != null) return 0;
    EasyLoading.show();
    Map data =
        await InvestorApi.getUser(user_id: user_id, client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    Map<String, dynamic> user = data['user'];
    userDataPojo = UserDataPojo.fromJson(user);
    name = userDataPojo.name;
    mobile = userDataPojo.mobile;
    email = userDataPojo.email;
    pan = userDataPojo.pan;
    dob = userDataPojo.dateOfBirth;
    addr = ('${userDataPojo.street1!},') +
        ("${userDataPojo.street2!},") +
        ("${userDataPojo.street3!},") +
        ("${userDataPojo.city!},") +
        (userDataPojo.pincode! + ",") +
        (userDataPojo.state!);
    rmName = userDataPojo.rmName;
    branch = userDataPojo.branch;
    subbrokerName = userDataPojo.subbrokerName;

    EasyLoading.dismiss();

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    print("rm name $rmName");
    print("branch $branch");
    print("mobile $mobile");
    return FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: invAppBar(title: "My Profile"),
            // rpAppBar(title: "My Profile", bgColor: Config.appTheme.mainBgColor),
            body: SideBar(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Personal Details", style: AppFonts.f50014Grey),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ColumnText(title: "Name", value: name ?? ""),
                              ],
                            ),
                            DottedLine(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ColumnText(title: "Mobile", value: mobile ?? ""),
                              ],
                            ),
                            DottedLine(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ColumnText(title: "Email ID", value: email ?? ""),
                              ],
                            ),
                            DottedLine(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ColumnText(title: "PAN", value: pan ?? ""),
                              ],
                            ),
                            DottedLine(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ColumnText(title: "DOB", value: dob ?? ""),
                              ],
                            ),
                            DottedLine(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ColumnText(
                                      title: "Address", value: addr ?? ""),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("RM Details", style: AppFonts.f50014Grey),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(client_name == 'nextfreedom')
                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                ColumnText(
                                    title: "Relationship Manager",
                                    value: subbrokerName ?? ""),
                              ],
                            ),
                            if(client_name != 'nextfreedom')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ColumnText(
                                    title: "Relationship Manager",
                                    value: rmName ?? ""),
                              ],
                            ),
                            DottedLine(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ColumnText(
                                    title: "Branch Name", value: branch ?? ""),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                      SizedBox(
                          height: 50,
                          child: InkWell(
                              onTap: () async {
                                sendMail();
                              },
                              child: PlainButton(text: "Email Login Credential")))
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  sendMail() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              BottomSheetTitle(title: "Confirm"),
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Config.appTheme.themeColor)),
                child: ColumnText(
                  title: "You are about to send the mail",
                  value: "Please check all the details carefully",
                  titleStyle: AppFonts.f50014Black,
                  valueStyle: AppFonts.f40013,
                ),
              ),
              CalculateButton(
                  onPress: () async {
                    Get.back();

                    String msgUrl = "";
                    String url =
                        "${ApiConfig.apiUrl}/sendLoginDetailsToInvestors?key=${ApiConfig.apiKey}"
                        "&user_id=$user_id&client_name=$client_name";

                    http.Response response = await http.post(Uri.parse(url));
                    msgUrl = response.body;
                    Map data = jsonDecode(msgUrl);
                    String resUrl = data['msg'];
                    print("email $url");
                    rpDownloadFile(url: resUrl, context: context);

                    /*showCupertinoDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Success'),
                          content: Text("Mail sent successfully"),
                          actions: [
                            TextButton(
                              child: Text(
                                "Ok",
                              ),
                              onPressed: () async {
                                Get.back();
                              },
                            )
                          ],
                        ));*/
                    Get.back();
                    setState(() {});
                  },
                  text: "Email Login Credential")
            ],
          ),
        );
      },
    );
  }

  Future<void> rpDownloadFile(
      {required String url, required BuildContext context}) async {
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
    print("Url == $url");

    try {
      final dir = await getExternalStorageDirectory();
      final filename = url.substring(url.lastIndexOf("/") + 1);
      final filePath = '${dir!.path}/$filename';
      final dio = Dio();
      await dio.download(url, filePath);
      final _result = await OpenFile.open(filePath);
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

  void showError() {
    Fluttertoast.showToast(
        msg: "Mail sent successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Config.appTheme.themeColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
