import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/pojo/UserDataPojo.dart';
import 'package:mymfbox2_0/rp_widgets/ColumnText.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:mymfbox2_0/advisor/sip/SipDashboard.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import '../../../Investor/sipPortfolioSummary/SipPortfolioSummary.widgets.dart';
import '../../../api/AdminApi.dart';
import '../../../rp_widgets/ShareWidget.dart';

class SipCalculatorOutput extends StatefulWidget {
  const SipCalculatorOutput({
    super.key,
    required this.apiResult,
  });
  final Map apiResult;

  @override
  State<SipCalculatorOutput> createState() => _SipCalculatorOutputState();
}

class _SipCalculatorOutputState extends State<SipCalculatorOutput> {
  late double devHeight, devWidth;
  late Map apiResult;
  int user_id = getUserId();
  String client_name = GetStorage().read("client_name");
  int type_id = GetStorage().read("type_id");
  String type = "";
  UserDataPojo userDataPojo = UserDataPojo();

  Map data = {};
  bool isLoading = true;
  String msgUrl = "";
  Future downloadSIPCalcResult() async {
    isLoading = true;
    data = await AdminApi.downloadSIPCalcResult(
        user_id: user_id,
        client_name: client_name,
        sip_amount: apiResult['sip_amount'],
        interest_rate: apiResult['interest_rate'],
        type: 'download',
        period: apiResult['period']);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }
    msgUrl = data['msg'];

    print("downloadSIPCalcResult exception = ${data["msg"]}");

    isLoading = false;

    return 0;
  }

  @override
  void initState() {
    //  implement initState
    super.initState();
    apiResult = widget.apiResult;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;
    int futureValue = 0;
    futureValue = apiResult['invested_amount'] + apiResult['growth_value'];
    print("futureValue $futureValue");
    double year = apiResult['period'] / 12;
    print("Year $year");
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
          title: "SIP Calculator",
          bgColor: Config.appTheme.themeColor,
          foregroundColor: Colors.white,
          actions: [
            if ((type_id == UserType.ADMIN) &&
                (!keys.contains("adminAsInvestor")))
              GestureDetector(
                  onTap: () {
                    String url =
                        "${ApiConfig.apiUrl}/download/downloadSIPCalcResult?key=${ApiConfig.apiKey}&"
                        "sip_amount=${apiResult['sip_amount']}&"
                        "interest_rate=${apiResult['interest_rate']}&period=${apiResult['period']}&client_name=$client_name";
                    SharedWidgets().shareBottomSheet(context, url);
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Icon(Icons.share))),
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Config.appTheme.themeColor,
              width: devWidth,
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                        ColumnText(
                            title: "Monthly SIP",
                            valueStyle: AppFonts.f50014Black,
                            value: rupee +
                                Utils.formatNumber(apiResult['sip_amount'],
                                    isAmount: false)),
                        ColumnText(
                          title: "Period",
                          value: "${apiResult['period']} Months",
                          valueStyle: AppFonts.f50014Black,
                          alignment: CrossAxisAlignment.center,
                        ),
                        ColumnText(
                          title: "Exp Return",
                          value:
                              "${apiResult['interest_rate'].toStringAsFixed(2)}%",
                          valueStyle: AppFonts.f50014Black,
                          alignment: CrossAxisAlignment.end,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: devWidth,
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(4.0), // Add padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [getBroadCategory()],
              ),
            ),
            Container(
              width: devWidth,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: EdgeInsets.all(16.0), // Add padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Future Value",
                      style: AppFonts.f50014Black,
                    ),
                  ),
                  Text(
                    "$rupee ${Utils.formatNumber(futureValue, isAmount: false)}",
                    style: AppFonts.f70018Green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getBroadCategory() {
    List<SipData> chartData = [];

    chartData.add(SipData(
      category: 'Invested Amount',
      percentage: apiResult['invested_amount'].toDouble(),
    ));

    chartData.add(SipData(
      category: 'Growth Amount',
      percentage: apiResult['growth_value'].toDouble(),
    ));

    print("chartData $chartData");

    List<Color> colorPalate = [
      Color(0XFF4155B9),
      Color(0XFF67C587),
      Color(0xFFE79C23),
      Color(0xFF5DB25D),
      Color(0xFFDE5E2F),
      Colors.redAccent,
      Colors.greenAccent,
      Colors.deepPurple,
      Colors.black,
      Colors.teal
    ];

    return Column(
      children: [
        SfCircularChart(
          series: <CircularSeries>[
            PieSeries<SipData, String>(
              dataSource: chartData,
              xValueMapper: (data, _) => data.category,
              yValueMapper: (data, _) => data.percentage,
            ),
          ],
          palette: colorPalate,
          legend: Legend(
              isVisible: false,
              overflowMode: LegendItemOverflowMode.scroll,
              position: LegendPosition.bottom),
        ),
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: chartData.length,
          itemBuilder: (BuildContext context, int index) {
            SipData sipData = chartData.elementAt(index);

            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: colorPalate[index], radius: 6),
                  SizedBox(
                      width: 200,
                      child: Text(
                        "  ${sipData.category}",
                        style: AppFonts.f50014Black,
                      )),
                  Expanded(
                      child: Text(
                    "$rupee ${Utils.formatNumber(sipData.percentage, isAmount: false)}",
                    style: AppFonts.f50014Black,
                    textAlign: TextAlign.end,
                  )),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return DottedLine();
          },
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  /*void shareBottomSheett(BuildContext context) {
    final double devHeight = MediaQuery.of(context).size.height;
    final double devWidth = MediaQuery.of(context).size.width;

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
            return SizedBox(
              height: devHeight * 0.290,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Share",
                            style: AppFonts.f50014Theme.copyWith(fontSize: 16,color: Colors.black)
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close,color: Colors.grey,),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        listContainer(),
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
  Widget listContainer() {
    return FutureBuilder(
      future: downloadSIPCalcResult(),
      builder: (context, snapshot){

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: bottomSheetSData.length,
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 8,
            );
          },
          itemBuilder: (context, index) {
            String title = bottomSheetSData.keys.elementAt(index);
            List stitle = bottomSheetSData.values.elementAt(index);
            String imagePath = stitle[1];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: InkWell(
                onTap: () {
                  if (index == 0) {
                    rpDownloadFile (url: msgUrl, context: context);
                  } else if (index == 1) {
                   // Get.to(() => ShareViaEmail());
                    ();
                  } else if (stitle[1] != null) {
                    Get.to(stitle[1]);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: RpListTile(
                    title: SizedBox(
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
              ),
            );
          },
        ),
      );},
    );
  }

  Future<void> rpDownloadFile({required String url, required BuildContext context}) async {
    EasyLoading.show(status: 'loading...');
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
      if (await Permission.storage.request().isGranted) // Request storage permission instead of photos permission
        dirloc = (await getExternalStorageDirectory())?.path ?? "";
      else
        showError();
    }

    try {
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
    }
  }


  void showError() {
    Fluttertoast.showToast(
        msg: "Please allow permission to download the file.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Config.appTheme.themeColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }*/
}
