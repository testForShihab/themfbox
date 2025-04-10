import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/Investor/reports/FolioMasterDetails.dart';
import 'package:mymfbox2_0/api/ReportApi.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class FolioMaster extends StatefulWidget {
  const FolioMaster({super.key});

  @override
  State<FolioMaster> createState() => _FolioMasterState();
}

class _FolioMasterState extends State<FolioMaster> {
  int user_id = getUserId();
  String clientName = GetStorage().read("client_name");

  String selectedFinancialYear = "";
  double startingPoint = 0;

  List financialYearList = [];

  List folio_list = [];

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  String startDate = DateFormat('dd-MM-yyyy')
      .format(DateTime.now().subtract(Duration(days: 30)));
  String endDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  int checkDateDialog = 0;
  num current_value = 0.0;

  Future getFolioMaster() async {
    if (folio_list.isNotEmpty) return 0;

    Map data = await ReportApi.getFolioMasterReport(
      user_id: user_id,
      client_name: clientName,
    );
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    folio_list = data['folio_master_summary'];
    current_value = data['total_current_value'];

    return 0;
  }

  bool isLoading = true;

  Future getDatas() async {
    isLoading = true;
    await getFolioMaster();
    isLoading = false;
    return 0;
  }

  @override
  void initState() {
    super.initState();
  }

  late double devWidth, devHeight;

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Config.appTheme.themeColor,
              leadingWidth: 0,
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
                          "Folio Master Report",
                          style: AppFonts.f50014Black
                              .copyWith(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Spacer(),
                      // Icon(Icons.more_vert),
                      //  RpAboutIcon(context: context,),
                    ],
                  ),
                ],
              ),
            ),
            body: SideBar(
              child: Column(
                children: [
                  investmentCard(),
                  Expanded(
                    child: SingleChildScrollView(child: displayPage()),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget investmentCard() {
    return Container(
      color: Config.appTheme.themeColor,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: (isLoading)
          ? Utils.shimmerWidget(devWidth * 0.30, margin: EdgeInsets.all(8))
          : Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 16),
              decoration: BoxDecoration(
                color: Config.appTheme.overlay85,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Current Value",
                          style: TextStyle(
                              color: Config.appTheme.themeColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: devHeight * 0.02),
                    Text(
                      "$rupee ${Utils.formatNumber(current_value, isAmount: true)}",
                      style: TextStyle(
                          color: Config.appTheme.themeColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 32),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget displayPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          //  isLoading ? Utils.shimmerWidget(300,margin: EdgeInsets.all(16)) : investmentCard(),
          isLoading
              ? Utils.shimmerWidget(devHeight, margin: EdgeInsets.all(16))
              : listCard(),
        ],
      ),
    );
  }

  Widget listCard() {
    if (folio_list.isEmpty) return NoData();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: folio_list.length,
      itemBuilder: (context, index) {
        Map scheme = folio_list[index];
        return trnxCard(scheme);
      },
    );
  }

  GestureDetector trnxCard(Map scheme) {
    num? currValue = scheme['current_value'] ?? 0;
    num balanceUnit = scheme['units'] ?? 0;
    String modeHld = scheme['mod_of_holding'];
    String logo = scheme['amc_logo'];
    // String folio = scheme['folio_number'];

    if (modeHld == 'SI') {
      modeHld = 'SINGLE';
    } else if (modeHld == "AS") {
      modeHld = 'ANYONE / SURVIVOR';
    } else if (modeHld == 'ES') {
      modeHld = 'EITHER / SURVIVOR';
    } else if (modeHld == 'JO') {
      modeHld = 'JOINT';
    }

    return GestureDetector(
      onTap: () {
        Get.to(() => FolioMasterDetails(schemeItem: scheme));
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  logo,
                  height: 32,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ColumnText(
                    title: "${scheme['scheme_amfi_short_name']}",
                    value: "Folio : ${scheme['folio_no']}",
                    titleStyle: AppFonts.f50014Black,
                    valueStyle: AppFonts.f40013,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Config.appTheme.placeHolderInputTitleAndArrow,
                ),
              ],
            ),
            SizedBox(height: 10),
            rpRow(
              lhead: "Current Value",
              lSubHead: "$rupee ${Utils.formatNumber(currValue)}",
              rhead: "Balance Units",
              rSubHead: Utils.formatNumber(balanceUnit),
              chead: "Holding",
              cSubHead: modeHld,
            ),
            SizedBox(height: 16),
            DottedLine(),
          ],
        ),
      ),
    );
  }

  Widget rpRow({
    required String lhead,
    required String lSubHead,
    required String rhead,
    required String rSubHead,
    required String chead,
    required String cSubHead,
    final TextStyle? valueStyle,
    final TextStyle? titleStyle,
  }) {
    return Row(
      children: [
        Expanded(
            child: ColumnText(
                title: lhead,
                value: lSubHead,
                alignment: CrossAxisAlignment.start)),
        Expanded(
            child: ColumnText(
          title: rhead,
          value: rSubHead,
          alignment: CrossAxisAlignment.center,
          valueStyle: valueStyle,
          titleStyle: titleStyle,
        )),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              chead,
              style: AppFonts.f40013,
            ),
            Text(
              cSubHead,
              softWrap: true,
              textAlign: TextAlign.end,
              style: valueStyle ??
                  AppFonts.f50014Grey.copyWith(color: Colors.black),
            ),
          ],
        )),
      ],
    );
  }

  String getFirst13(String text) {
    String s = text.split(":").last;
    if (s.length > 12) s = s.substring(0, 12);
    return s;
  }

  String getFirst24(String text) {
    String s = text.split(":").last;
    if (s.length > 24) s = s.substring(0, 24);
    return s;
  }
}
