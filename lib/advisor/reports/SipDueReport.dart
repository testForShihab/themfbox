import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/ReportApi.dart';
import 'package:mymfbox2_0/pojo/SipDueReportReponse.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class SipDueReport extends StatefulWidget {
  const SipDueReport({Key? key}) : super(key: key);

  @override
  State<SipDueReport> createState() => _SipDueReportState();
}

class _SipDueReportState extends State<SipDueReport> {
  late double devWidth, devHeight;
  int user_id = getUserId();
  String client_name = GetStorage().read("client_name");

  int currIndex = 0;

  SipDueList sipDueList = SipDueList();
  SipDueReportResponse sipDueReportResponse = SipDueReportResponse();

  final List<Map<String, dynamic>> dueperiodList = [
    {"text": "1 Week", "option": 7},
    {"text": "2 Weeks", "option": 14},
    {"text": "3 Weeks", "option": 21},
    {"text": "1 Month", "option": 30},
    {"text": "2 Months", "option": 60},
    {"text": "3 Months", "option": 90},
  ];
  Map reportActionData = {
    "Download Excel Report": ["", "", "assets/excel.png"],
  };
  String selectedType = "1 Week";
  String selectedSort = "Current Value";
  String isselected = " ";
  bool isLoading = true;
  List duelist = [];
  String schemename = " ";
  num foliono = 0;
  String startdate = " ";

  Future getDatas() async {
    isLoading = true;
    await getSipDueDetails();
    isLoading = false;
    return 0;
  }

  Future getSipDueDetails() async {
    int selectedoption = getSelectedOption();
    Map<String, dynamic> data = await AdminApi.getSipDueDetails(
      user_id: user_id,
      client_name: client_name,
      due_period: selectedoption,
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    sipDueReportResponse = SipDueReportResponse.fromJson(data);
    return 0;
  }

  int getSelectedOption() {
    for (var map in dueperiodList) {
      if (map["text"] == selectedType) {
        print(map["option"]);
        return map["option"];
      }
    }
    return 0;
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
            appBar: AppBar(
              backgroundColor: Config.appTheme.themeColor,
              leadingWidth: 0,
              toolbarHeight: 140,
              foregroundColor: Colors.white,
              elevation: 0,
              leading: SizedBox(),
              title: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: Icon(Icons.arrow_back),
                        onTap: () {
                          Get.back();
                        },
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          "SIP Due Report",
                          style: AppFonts.f50014Black
                              .copyWith(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                          onTap: () {
                            showReportActionBottomSheet();
                          },
                          child: Icon(Icons.pending_outlined)),
                    ],
                  ),
                  //SizedBox(height: 20),
                  SizedBox(height: 24),
                  dueperiod(),
                ],
              ),
            ),
            body: displayPage(),
          );
        });
  }

  showReportActionBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Config.appTheme.mainBgColor,
      context: context,
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
                  BottomSheetTitle(title: "Report Actions"),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: reportActionContainer(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget displayPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isLoading
              ? Utils.shimmerWidget(devHeight, margin: EdgeInsets.all(16))
              : listCard(),
        ],
      ),
    );
  }

/*
  Widget reportActionContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: reportActionData.length,
        separatorBuilder: (context, index) {
          return DottedLine(verticalPadding: 4);
        },
        itemBuilder: (context, index) {
          String title = reportActionData.keys.elementAt(index);
          List stitle = reportActionData.values.elementAt(index);
          String imagePath = stitle[2];
          String msgUrl = "";
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () async {
                EasyLoading.show();
                if (index == 0) {
                  String url =
                      "${ApiConfig.apiUrl}/admin/download/getSipDueReport?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";

                  http.Response response = await http.post(Uri.parse(url));
                  msgUrl = response.body;
                  Map data = jsonDecode(msgUrl);
                  String resUrl = data['msg'];
                  print("Excel Download $url");
                  rpDownloadFile(url: resUrl, context: context, index: index);
                  Get.back();
                }
                EasyLoading.dismiss();
              },
              child: RpListTile(
                title: SizedBox(
                  width: 220,
                  child: Text(
                    title,
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor),
                  ),
                ),
                subTitle: Visibility(
                  visible: stitle[0].isNotEmpty,
                  child: Text(stitle[0], style: AppFonts.f40013),
                ),
                leading: Image.asset(
                  imagePath,
                  color: Config.appTheme.themeColor,
                  width: 32,
                  height: 32,
                ),
                showArrow: false,
              ),
            ),
          );
        },
      ),
    );
  }

*/
  List reportActions = [
    {
      'title': "Download Excel Report",
      'img': "assets/excel.png",
      'type': ReportType.EXCEL,
    }
  ];

  Widget reportActionContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: reportActions.length,
        separatorBuilder: (context, index) {
          return DottedLine(verticalPadding: 4);
        },
        itemBuilder: (context, index) {
          Map data = reportActions[index];

          String title = data['title'];
          String img = data['img'];
          String type = data['type'];

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () async {
                EasyLoading.show();
                Map data = await ReportApi.getSipDueReport(
                    user_id: user_id, client_name: client_name);
                if (data['status'] != 200) {
                  Utils.showError(context, data['msg']);
                  return;
                }
                EasyLoading.dismiss();
                Get.back();
                rpDownloadFile(
                    url: data['msg'], context: context, index: index);
              },
              child: RpListTile(
                title: SizedBox(
                  width: 220,
                  child: Text(
                    title,
                    style: AppFonts.f50014Black
                        .copyWith(color: Config.appTheme.themeColor),
                  ),
                ),
                subTitle: SizedBox(),
                leading: Image.asset(
                  img,
                  color: Config.appTheme.themeColor,
                  width: 32,
                  height: 32,
                ),
                showArrow: false,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget listCard() {
    return (sipDueReportResponse.list?.isEmpty ?? true)
        ? NoData()
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: sipDueReportResponse.list?.length ?? 0,
            itemBuilder: (context, index) {
              //  Map scheme = duelist[index];
              SipDueList? scheme = sipDueReportResponse.list?[index];
              return trnxCard(scheme!);
            },
          );
  }

  GestureDetector trnxCard(SipDueList scheme) {
    String? folio = scheme.folio;
    String? investorname = scheme.investorName;
    String? schemename = scheme.schemeName;
    String? duedate = scheme.dueDate;
    num? amount = scheme.amount;
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InitialCard(title: investorname![0]),
                SizedBox(width: 10),
                Expanded(
                    flex: 2,
                    child: Text(
                      investorname ?? "",
                      style: AppFonts.f50014Black,
                    )),
                SizedBox(),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      print('came here');
                      sipduedetails(scheme);
                    },
                    child: Text("View Details",
                        style: TextStyle(
                            fontSize: 16,
                            color: Config.appTheme.themeColor,
                            decoration: TextDecoration.underline,
                            decorationColor: Config.appTheme.themeColor)),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  scheme.logo!,
                  height: 32,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ColumnText(
                    title: schemename ?? "",
                    value: "Folio : $folio",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013.copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Due : $duedate",
                  style: AppFonts.f50014Black,
                ),
                Spacer(),
                Text(
                  "$rupee ${Utils.formatNumber(amount)}",
                  style: AppFonts.f50014Black,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  dueperiod() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dueperiodList.length,
        itemBuilder: (context, index) {
          String type = dueperiodList[index]["text"];
          int option = dueperiodList[index]["option"];
          if (selectedType == type) {
            // print("Selected Option: $type ($option)");
            return getButton(text: type, type: ButtonType.filled);
          } else {
            return getButton(text: type, type: ButtonType.plain);
          }
        },
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(width: 16),
      ),
    );
  }

  Widget getButton({required String text, required ButtonType type}) {
    EdgeInsets padding = EdgeInsets.symmetric(horizontal: 16);
    if (type == ButtonType.plain) {
      return PlainButton1(
        text: text,
        padding: padding,
        onPressed: () {
          selectedType = text;
          selectedSort = "";
          setState(() {});
        },
      );
    } else {
      return RpFilledButton1(text: selectedType, padding: padding);
    }
  }

  sipduedetails(SipDueList scheme) {
    String? name = scheme.investorName;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SizedBox(
              height: devHeight * 0.62,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: cornerBorder, color: Colors.white),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 24),
                          child: Text("SIP Due Details",
                              style: AppFonts.f40016.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
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
                    Divider(
                      color: Colors.grey,
                    ),
                    // SizedBox(height: 15),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InitialCard(title: name![0]),
                              SizedBox(width: 10),
                              Text("${scheme.investorName}",
                                  style: AppFonts.f50014Black),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              ColumnText(title: "PAN", value: "${scheme.pan}"),
                              Spacer(),
                              ColumnText(
                                  title: "Mobile", value: "${scheme.mobile}"),
                              Spacer(),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              ColumnText(
                                  title: "Email", value: "${scheme.email}")
                            ],
                          ),
                          SizedBox(height: 10),
                          DottedLine(),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                scheme.logo!,
                                height: 32,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: ColumnText(
                                  title: "${scheme.schemeName}",
                                  value: "Folio :${scheme.folio} ",
                                  titleStyle: AppFonts.f50014Black,
                                  valueStyle: AppFonts.f40013
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ColumnText(
                                    title: "Amount    ",
                                    value: "$rupee ${scheme.amount}"),
                              ),
                              Expanded(
                                child: ColumnText(
                                    title: "Due Date",
                                    value: "${scheme.dueDate}"),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ColumnText(
                                    title: "Start Date",
                                    value: "${scheme.startDate}"),
                              ),
                              Expanded(
                                child: ColumnText(
                                    title: "End Date",
                                    value: "${scheme.endDate}"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class PlainButton1 extends StatelessWidget {
  const PlainButton1(
      {super.key, required this.text, this.onPressed, this.padding});

  final String text;
  final Function()? onPressed;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.sizeOf(context).width;

    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: padding ??
            EdgeInsets.symmetric(horizontal: devWidth * 0.15, vertical: 2),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppFonts.f50014Black.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

void showError() {
  Fluttertoast.showToast(
      msg: "Success",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Config.appTheme.themeColor,
      textColor: Colors.white,
      fontSize: 16.0);
}

class InvestorDetails {
  String? email;
  int? userId;

  InvestorDetails({this.email, this.userId});

  InvestorDetails.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['user_id'] = this.userId;
    return data;
  }
}

class RpFilledButton1 extends StatelessWidget {
  const RpFilledButton1(
      {super.key, this.onPressed, required this.text, this.padding});

  final Function()? onPressed;
  final EdgeInsets? padding;
  final String text;

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.sizeOf(context).width;

    return InkWell(
      onTap: onPressed,
      child: Container(
          padding: padding ??
              EdgeInsets.symmetric(horizontal: devWidth * 0.15, vertical: 2),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppFonts.f50014Black
                .copyWith(color: Config.appTheme.themeColor),
          ))),
    );
  }
}
