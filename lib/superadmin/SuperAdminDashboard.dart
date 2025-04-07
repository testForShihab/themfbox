import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/advisor/dashboard/AdminDashboard.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/login/CheckAuth.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/BottomSheetTitle.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/InitialCard.dart';
import 'package:mymfbox2_0/rp_widgets/RectButton.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile2.dart';
import 'package:mymfbox2_0/rp_widgets/SearchField.dart';
import 'package:mymfbox2_0/superadmin/OtherUserPage.dart';
import 'package:mymfbox2_0/superadmin/SuperAdminDashboard.types.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class SuperAdminDashboard extends StatefulWidget {
  const SuperAdminDashboard({super.key});

  @override
  State<SuperAdminDashboard> createState() => _SuperAdminDashboardState();
}

class _SuperAdminDashboardState extends State<SuperAdminDashboard> {
  int sAdmin_id = GetStorage().read('sAdmin_id');

  bool isLoading = true;
  int page_id = 1;

  num totalCount = 0, totalAum = 0;
  List clientList = [];

  ScrollController scrollController = ScrollController();
  Future scrollListener() async {
    bool atBottom = scrollController.position.extentAfter < 100;
    bool fullyLoaded = clientList.length == totalCount;

    bool fetchAgain = atBottom && !fullyLoaded && !isLoading;

    if (fetchAgain) await getMoreAdvisors();
  }

  Future getMoreAdvisors() async {
    page_id++;

    print("getting more advisor with page id = $page_id");
    isLoading = true;
    EasyLoading.show();

    Map data = await AdminApi.getAdvisorsList(
      user_id: sAdmin_id,
      page_id: page_id,
      search: searchKey,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    List list = data['list'];
    clientList.addAll(list);
    isLoading = false;
    EasyLoading.dismiss();
    setState(() {});

    return 0;
  }

  Future getInitialAdvisors() async {
    if (clientList.isNotEmpty) return 0;
    page_id = 1;

    Map data = await AdminApi.getAdvisorsList(
      user_id: sAdmin_id,
      page_id: page_id,
      search: searchKey,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    clientList = data['list'];
    totalCount = data['total_count'];

    isLoading = false;
    return 0;
  }

  Timer? searchOnStop;
  String searchKey = "";
  searchHandler(String search) {
    searchKey = search;

    const duration = Duration(milliseconds: 1000);
    if (searchOnStop != null) {
      searchOnStop!.cancel();
    }

    searchOnStop = Timer(duration, () async {
      EasyLoading.show(status: "searching for `$searchKey`");
      clientList = [];
      await getInitialAdvisors();
      EasyLoading.dismiss();

      setState(() {});
    });
  }

  late double devHeight, devWidth;

  @override
  void initState() {
    //  implement initState
    super.initState();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    //  implement dispose
    scrollController.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
        future: getInitialAdvisors(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: adminAppBar(
                title: "All Clients",
                bgColor: Colors.white,
                hasAction: false,
                leading: SizedBox(),
                suffix: IconButton(
                    onPressed: () async {
                      GetStorage().erase();
                      Get.offAll(CheckAuth());
                    },
                    icon: Icon(
                      Icons.power_settings_new_sharp,
                      color: Colors.red,
                    ))),
            body: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SearchField(
                    hintText: "Search Clients",
                    onChange: searchHandler,
                  ),
                ),
                countLine(),
                listArea(),
              ],
            ),
          );
        });
  }

  Widget countLine() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Visibility(
        visible: !isLoading,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${clientList.length} of $totalCount Items",
                style: AppFonts.f40013),
          ],
        ),
      ),
    );
  }

  Widget listArea() {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        child: (isLoading)
            ? Utils.shimmerWidget(devHeight)
            : ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: clientList.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = clientList[index];
                  AdvisorPojo advisor = AdvisorPojo.fromJson(data);
                  String companyName = advisor.companyName!.isEmpty
                      ? "."
                      : "${advisor.companyName}";
                  String logo = "${advisor.logo}";

                  return InkWell(
                    onTap: () {
                      showAdvisorDetails(advisor);
                    },
                    child: RpListTile2(
                        leading: (logo.isEmpty)
                            ? InitialCard(title: companyName)
                            : Image.network(logo, height: 32),
                        l1: "${advisor.companyName}",
                        l2: "${advisor.clientName}",
                        r1: "$rupee ${Utils.formatNumber(advisor.totalAum, isAmount: true)}",
                        r2: "(In Lakhs)"),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: DottedLine(verticalPadding: 8),
                ),
              ),
      ),
    );
  }

  showAdvisorDetails(AdvisorPojo client) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: cornerBorder),
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              BottomSheetTitle(
                  title: "Client Details", padding: EdgeInsets.all(16)),
              infoRow(
                  lHead: "Support Mobile",
                  lSubHead: "${client.supportMobile}",
                  rHead: "Support Email",
                  rSubHead: "${client.supportEmail}"),
              infoRow(
                  lHead: "Web Url",
                  lSubHead: "${client.themfboxUrl}",
                  rHead: "Investor Count",
                  rSubHead: "${client.investorCount}"),
              infoRow(
                  lHead: "App Type",
                  lSubHead: "${client.appType}",
                  rHead: "Broker Code",
                  rSubHead: "${client.brokerCode}"),
              infoRow(
                  lHead: "RM Name",
                  lSubHead: "${client.rmName}",
                  rHead: "Brokerage Flag",
                  rSubHead: "${client.brokerageFlag}"),
              infoRow(
                  lHead: "MF Research Flag",
                  lSubHead: "${client.mfresearchFlag}",
                  rHead: "Calculator Flag",
                  rSubHead: "${client.calculatorFlag}"),
              infoRow(
                  lHead: "Goals Flag",
                  lSubHead: "${client.goalsFlag}",
                  rHead: "Risk Profile Flag",
                  rSubHead: "${client.riskProfileFlag}"),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: RectButton(
                    leading: "assets/bulletList.png",
                    imgSize: 20,
                    title: "View Admin Dashboard",
                    fgColor: Colors.white,
                    onPressed: () async {
                      await GetStorage()
                          .write("mfd_id", client.adminUsers?.userId);
                      await GetStorage().write("type_id", client.adminUsers?.typeId);
                      await GetStorage()
                          .write("mfd_name", "${client.adminUsers?.name}");
                      await GetStorage()
                          .write("mfd_pan", "${client.adminUsers?.pan}");
                      await GetStorage()
                          .write("mfd_mobile", "${client.adminUsers?.mobile}");
                      await GetStorage().write("superAdminAsAdmin", true);
                      await GetStorage().write(
                          "client_name", "${client.adminUsers?.clientName}");
                      ApiConfig.apiKey = "${client.apiKey}";

                      Get.to(() => AdminDashboard());
                    },
                    trailing: Icon(Icons.arrow_forward, color: Colors.white),
                    bgColor: Config.appTheme.themeColor),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    if (client.branchUsers != null &&
                        client.branchUsers!.isNotEmpty)
                      Expanded(
                          child: PlainButton(
                        text: "Branches",
                        padding: EdgeInsets.symmetric(vertical: 8),
                        onPressed: () {
                          Get.to(() => OtherUserPage(
                                subBrokerList: client.branchUsers ?? [],
                                title: "Branch Users",
                              ));
                        },
                      )),
                    SizedBox(width: 8),
                    if (client.rmUsers != null && client.rmUsers!.isNotEmpty)
                      Expanded(
                          child: PlainButton(
                              text: "RMs",
                              padding: EdgeInsets.symmetric(vertical: 8),
                              onPressed: () {
                                Get.to(() => OtherUserPage(
                                      subBrokerList: client.rmUsers ?? [],
                                      title: "RM Users",
                                    ));
                              })),
                    SizedBox(width: 8),
                    if (client.subbrokerUsers != null &&
                        client.subbrokerUsers!.isNotEmpty)
                      Expanded(
                          child: PlainButton(
                              text: "Sub Brokers",
                              padding: EdgeInsets.symmetric(vertical: 8),
                              onPressed: () {
                                Get.to(() => OtherUserPage(
                                      subBrokerList:
                                          client.subbrokerUsers ?? [],
                                      title: "Sub Broker Users",
                                    ));
                              })),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget infoRow({
    required String lHead,
    required String lSubHead,
    TextStyle? lStyle,
    String rHead = "",
    String rSubHead = "",
    TextStyle? rStyle,
    void Function()? onTapRSubHead,
    void Function()? onTaplSubHead,
    String? phoneNumber,
    String? email,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lHead),
              GestureDetector(
                  onTap: onTaplSubHead,
                  child: Text(lSubHead, style: lStyle ?? AppFonts.f50014Black)),
            ],
          )),
          Visibility(
            visible: rHead.isNotEmpty,
            child: Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rHead),
                //Text(rHead),
                GestureDetector(
                    onTap: onTapRSubHead,
                    child:
                        Text(rSubHead, style: rStyle ?? AppFonts.f50014Black)),
                // GestureDetector(
                //     onTap: () {
                //       if (phoneNumber != null && phoneNumber.isNotEmpty) {
                //         _launchPhoneDialer(phoneNumber);
                //       }
                //     },
                //     child:
                //         Text(rSubHead, style: rStyle ?? AppFonts.f50014Black)),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
