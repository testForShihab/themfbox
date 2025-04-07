import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/ReportApi.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpChip.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class FamilySipReport extends StatefulWidget {
  const FamilySipReport({super.key});

  @override
  State<FamilySipReport> createState() => _FamilySipReportState();
}

class _FamilySipReportState extends State<FamilySipReport> {
  int user_id = GetStorage().read('family_id');
  String client_name = GetStorage().read("client_name");
  List sipList = [];
  bool isLoading = true;
  Map reportActionData = {
    "Download PDF Report ": ["", "", "assets/pdf.png"],
    /*"Download Excel Report": ["", "", "assets/excel.png"],*/
  };

  Future getSipReport() async {
    if (sipList.isNotEmpty) return 0;

    Map data = await ReportApi.getSipReport(
        user_id: user_id, client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    sipList = data['list'];
    isLoading = false;
    return 0;
  }

  late double devWidth, devHeight;

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: getSipReport(),
        builder: (context, snapshot) {
          return SideBar(
            child: Scaffold(
              backgroundColor: Config.appTheme.mainBgColor,
              appBar: AppBar(
                backgroundColor: Config.appTheme.themeColor,
                leadingWidth: 0,
                foregroundColor: Colors.white,
                elevation: 0,
                leading: SizedBox(),
                title: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back),
                      SizedBox(width: 5),
                      Text(
                        "Family SIP Report",
                        style: AppFonts.f50014Black
                            .copyWith(fontSize: 18, color: Colors.white),
                      ),
                      Spacer(),
                      IconButton(
                          icon: Icon(Icons.pending_outlined),
                          onPressed: () {
                            showReportActionBottomSheet();
                          }),
                    ],
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    (isLoading)
                        ? Utils.shimmerWidget(devHeight,
                            margin: EdgeInsets.all(16))
                        : Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: (sipList.isEmpty)
                                ? NoData()
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: sipList.length,
                                    itemBuilder: (context, index) {
                                      Map member = sipList[index];

                                      return invExpansionTile(member, index);
                                    },
                                  ),
                          )
                  ],
                ),
              ),
            ),
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
                print("investorIddd $user_id");
                if (user_id != 0) {
                  if (index == 0) {
                    String url =
                        "${ApiConfig.apiUrl}/admin/family/downloadFamilySIPReportPdf?key=${ApiConfig.apiKey}&user_id=$user_id&client_name=$client_name";

                    http.Response response = await http.post(Uri.parse(url));
                    msgUrl = response.body;
                    Map data = jsonDecode(msgUrl);
                    String resUrl = data['msg'];
                    print("download $url");
                    rpDownloadFile(url: resUrl, context: context, index: index);
                    EasyLoading.dismiss();
                    Get.back();
                  } else if (index == 1) {
                    //   String url =
                    //       "${ApiConfig.apiUrl}/admin/download/portfolioAnalysisReport?key=${ApiConfig.apiKey}&user_id=$investorId&client_name=$client_name&type=excel&start_date="
                    //       "&end_date="
                    //       "&option=$selectedBenchMarkType"
                    //       "";
                    //   http.Response response = await http.post(Uri.parse(url));
                    //   msgUrl = response.body;
                    //   Map data = jsonDecode(msgUrl);
                    //   String resUrl = data['msg'];
                    //   print("email $url");
                    //   rpDownloadFile(url: resUrl, context: context, index: index);
                    //   Get.back();
                  } else {}
                } else {
                  Utils.showError(context, "Please Select the Investor");
                  return;
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
      'title': "Download PDF Report",
      'img': "assets/pdf.png",
      'type': ReportType.DOWNLOAD,
    },
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
                Map data = await ReportApi.downloadFamilySIPReportPdf(
                    user_id: user_id, client_name: client_name);
                if (data['status'] != 200) {
                  Utils.showError(context, data['msg']);
                  return;
                }
                EasyLoading.dismiss();
                Get.back();

                if (type == ReportType.DOWNLOAD) {
                  rpDownloadFile(url: data['msg'], index: index);
                }
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

  bool isOpen = false;

  Widget invExpansionTile(Map member, int index) {
    String name = member['name'];
    num amount = member['total_sip_amount'];
    List list = member['sip_list'];
    num currCost = member['total_current_cost'];
    num currValue = member['total_current_value'];
    num returns = member['total_return'];
    int colorIndex = index;
    int totalColors = AppColors.colorPalate.length;
    if (index > totalColors) colorIndex = totalColors % index;

    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(2),
      child: SizedBox(
        width: double.infinity,
        child: Theme(
          data: ThemeData(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            title: Column(
              children: [
                Row(
                  children: [
                    InitialCard(
                      title: name,
                      bgColor: AppColors.colorPalate[colorIndex],
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ColumnText(
                        title: name,
                        value:
                            "${list.length} SIPs ($rupee ${Utils.formatNumber(amount)})",
                        titleStyle: AppFonts.f50014Black,
                        valueStyle: AppFonts.f40013,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColumnText(
                      title: "Current Cost",
                      value: "$rupee ${Utils.formatNumber(currCost)}",
                    ),
                    ColumnText(
                      title: "Current Value",
                      value: "$rupee ${Utils.formatNumber(currValue)}",
                      alignment: CrossAxisAlignment.center,
                    ),
                    ColumnText(
                      title: "XIRR(%)",
                      value: "$returns",
                      alignment: CrossAxisAlignment.end,
                    ),
                  ],
                )
              ],
            ),
            children: [
              Container(
                color: Config.appTheme.mainBgColor,
                padding: EdgeInsets.all(16),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    Map scheme = list[index];
                    return schemeCard(scheme);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget schemeCard(Map scheme) {
    String logo = scheme['logo'];
    String name = scheme['scheme_amfi_short_name'];
    String folio = scheme['folio_no'];
    String startDate = scheme['start_date'];
    String endDate = scheme['end_date'];
    String ecs = scheme['ecs_date'];
    num currCost = scheme['current_cost'];
    num currValue = scheme['current_value'];
    num returns = scheme['returns'];
    String frequency = scheme['frequency'] ?? "";
    num sipAmount = scheme['sip_amount'];

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.white),
      child: Column(
        children: [
          Row(
            children: [
              Image.network(logo, height: 32),
              SizedBox(width: 10),
              Expanded(
                child: ColumnText(
                  title: name,
                  value: "Folio : $folio",
                  titleStyle: AppFonts.f50014Black,
                  valueStyle: AppFonts.f40013,
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$rupee ${Utils.formatNumber(sipAmount)}",
                  style: AppFonts.f50014Theme),
              RpChip(label: frequency),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(title: "Start Date", value: startDate),
              ColumnText(
                title: "End Date",
                value: endDate,
                alignment: CrossAxisAlignment.center,
              ),
              ColumnText(
                title: "ECS Date",
                value: ecs,
                alignment: CrossAxisAlignment.end,
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColumnText(
                  title: "Current Cost",
                  value: "$rupee ${Utils.formatNumber(currCost)}"),
              ColumnText(
                title: "Current Value",
                value: "$rupee ${Utils.formatNumber(currValue)}",
                alignment: CrossAxisAlignment.center,
              ),
              ColumnText(
                title: "XIRR(%)",
                value: "$returns",
                alignment: CrossAxisAlignment.end,
              ),
            ],
          )
        ],
      ),
    );
  }
}
