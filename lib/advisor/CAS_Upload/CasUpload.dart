import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/advisor/CAS_Upload/TransactionSummary.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:get/get.dart';

class CasUpload extends StatefulWidget {
  const CasUpload({super.key});

  @override
  State<CasUpload> createState() => _CasUploadState();
}

class _CasUploadState extends State<CasUpload> {
  String client_name = GetStorage().read("client_name");
  late double devHeight, devWidth;
  final passwordController = TextEditingController();
  final pdfController = TextEditingController();
  TextStyle underlineText = TextStyle(
      color: Config.appTheme.themeColor,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w500,
      fontSize: 12);
  Future getDatas() async {
    return 0;
  }

  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: rpAppBar(
        title: "CAS Upload",
        bgColor: Config.appTheme.themeColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Config.appTheme.mainBgColor,
        child: Column(
          children: [
            Container(
              width: devWidth,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  noteCard(),
                  SizedBox(height: 16),
                  passwordCard(),
                  SizedBox(height: 16),
                  uploadCard(),
                  SizedBox(height: 16),
                  SizedBox(
                    width: devWidth,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Config.appTheme.themeColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        textStyle: AppFonts.f50014Black.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        uploadBottomSheet();
                      },
                      child: Text(
                        "UPLOAD",
                        style:
                            AppFonts.f50014Black.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget noteCard() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Config.appTheme.lineColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: devWidth * 0.800,
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Note: ",
                            style: AppFonts.f50014Black,
                          ),
                          TextSpan(
                            text:
                                "Please note that Partial CAS Statement (where there is an opening balance of units) and CAS summary, can not be uploaded in the system.",
                            style:
                                AppFonts.f40013.copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Generate CAS from CAMS?",
                      style: underlineText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget passwordCard() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Text(
            "CAS PDF File Extract Password",
            style: AppFonts.f50014Black,
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: TextField(
              keyboardType: TextInputType.visiblePassword,
              controller: passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                hintText: "Enter The Password",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(
                      color: Config.appTheme.placeHolderInputTitleAndArrow,
                      width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide:
                      BorderSide(color: Config.appTheme.themeColor, width: 2.0),
                ),
              ),
              style: TextStyle(fontSize: 18.0),
            ),
          )
        ],
      ),
    );
  }

  Widget uploadCard() {
    return Container(
      width: devWidth,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Text(
            "Upload your CAS PDF File",
            style: AppFonts.f50014Black,
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: TextField(
              keyboardType: TextInputType.visiblePassword,
              controller: pdfController,
              decoration: InputDecoration(
                hintText: "",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(
                    color: Config.appTheme.placeHolderInputTitleAndArrow,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(
                    color: Config.appTheme.themeColor,
                    width: 2.0,
                  ),
                ),
                suffixIcon: Container(
                  decoration: BoxDecoration(
                    color: Config.appTheme.themeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      print("Browse button pressed");
                    },
                    child: Text("Browse",
                        style: AppFonts.f50014Black
                            .copyWith(color: Config.appTheme.themeColor)),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  uploadBottomSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.white,
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
              return Container(
                height: devHeight * 0.70,
                decoration: BoxDecoration(
                  color: Config.appTheme.mainBgColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BottomSheetTitle(title: "Generate CAS from CAMS"),
                      Divider(height: 0),
                      Container(
                        color: Config.appTheme.mainBgColor,
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "You have to upload the Since Inception Consolidated Account Statement - (CAMS + KFINTECH) from 01-01-1993 to Today.",
                                style: AppFonts.f40013
                                    .copyWith(color: Colors.black),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "1. Go to CAMS website.",
                                style: AppFonts.f40013
                                    .copyWith(color: Colors.black),
                              ),
                              SizedBox(height: 8),
                              RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "2. Select Statement Type as  ",
                                      style: AppFonts.f40013
                                          .copyWith(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: "“Detailed”.",
                                      style: AppFonts.f50014Black
                                          .copyWith(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "3.",
                                    style: AppFonts.f40013
                                        .copyWith(color: Colors.black),
                                  ),
                                  SizedBox(width: 2),
                                  Expanded(
                                    child: RichText(
                                      textAlign: TextAlign.justify,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Choose the ",
                                            style: AppFonts.f40013
                                                .copyWith(color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: "“Specific Period” ",
                                            style: AppFonts.f50014Black
                                                .copyWith(fontSize: 13),
                                          ),
                                          TextSpan(
                                            text:
                                                "option and choose the date from ",
                                            style: AppFonts.f40013
                                                .copyWith(color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: "“01-01-1993” ",
                                            style: AppFonts.f50014Black
                                                .copyWith(fontSize: 13),
                                          ),
                                          TextSpan(
                                            text: "to date as ",
                                            style: AppFonts.f40013
                                                .copyWith(color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: "“Today”.",
                                            style: AppFonts.f50014Black
                                                .copyWith(fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "4. Select Folio Listing as ",
                                      style: AppFonts.f40013
                                          .copyWith(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: "“With zero balance folios”.",
                                      style: AppFonts.f50014Black
                                          .copyWith(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "5. Enter email and PAN , the email field is mandatory "
                                // "and PAN field is optional.",
                                ,
                                style: AppFonts.f40013
                                    .copyWith(color: Colors.black),
                              ),
                              Text(
                                "    and PAN field is optional.",
                                style: AppFonts.f40013
                                    .copyWith(color: Colors.black),
                              ),
                              SizedBox(height: 8),
                              RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "6. Enter a secure password and click ",
                                      style: AppFonts.f40013
                                          .copyWith(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: "“Submit”.",
                                      style: AppFonts.f50014Black
                                          .copyWith(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: devWidth,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Config.appTheme.themeColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              textStyle: AppFonts.f50014Black.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              // Get.to(WebviewContent(
                              //   webViewTitle: "Generate CAS from CAMS",
                              //   disqusUrl: "https://www.camsonline.com/",
                              // ));
                              Get.to(() => TransactionSummary());
                            },
                            child: Text(
                              "Go to CAMS website",
                              style: AppFonts.f50014Black
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(16),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Config.appTheme.lineColor,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Note: Investor will receive the statement on their email within 30 minutes from CAMS Mailback Server. ",
                          style: AppFonts.f40013,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
