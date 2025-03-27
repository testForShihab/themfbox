import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/advisor/sip/SchemeWiseSip.dart';
import 'package:mymfbox2_0/api/Api.dart';
import 'package:mymfbox2_0/rp_widgets/AdminAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/RpFilterChip.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile2.dart';
import 'package:mymfbox2_0/rp_widgets/SortButton.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class TopAmc extends StatefulWidget {
  const TopAmc({Key? key}) : super(key: key);

  @override
  State<TopAmc> createState() => _TopAmcState();
}

class _TopAmcState extends State<TopAmc> {
  late double devHeight, devWidth;
  int user_id = GetStorage().read("mfd_id");
  String client_name = GetStorage().read("client_name");
  bool isLoading = true;
  List amcList = [];
  List arnList = [];
  String selectedLeft = "Sort by";
  String selectedSort = "SIP";
  String arn = "All";
  Map bottomSheetFilter = {
    "Sort by": ['Alphabet', 'SIP'],
    "ARN": [],
  };

  bool sortArn = true;

  @override
  void initState() {
    super.initState();
  }

  Future getAmcWiseSip() async {
    if (amcList.isNotEmpty) return;

    isLoading = true;
    Map data = await Api.getAmcWiseSipDetails(
      user_id: user_id,
      client_name: client_name,
      maxCount: "All",
      broker_code: arn,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return;
    }
    setState(() {
      amcList = data['list'];
      isLoading = false;
    });
  }

  Future getArnList() async {
    if (arnList.isNotEmpty) return 0;
    Map data = await Api.getArnList(client_name: client_name);
    try {
      if (data['status'] != 200) {
        Utils.showError(context, data['msg']);
        return 0;
      }
      arnList = [
        "All",
        data['broker_code_1'],
        data['broker_code_2'],
        data['broker_code_3']
      ];
      arnList.removeWhere((element) => element.isEmpty);
      bottomSheetFilter['ARN'] = arnList;
    } catch (e) {
      print("getArnList exception = $e");
    }
    return 0;
  }

  Future getDatas() async {
    isLoading = true;

    await getArnList();
    await getAmcWiseSip();

    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    devWidth = MediaQuery.of(context).size.width;
    devHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
        future: getDatas(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: adminAppBar(title: "Top AMCs", bgColor: Colors.white),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sortLine(),
                countLine(),
                listArea(),
              ],
            ),
          );
        });
  }

  bool showSortChip = true;
  Widget sortLine() {
    return Container(
      height: 60,
      width: devWidth,
      color: Config.appTheme.mainBgColor,
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SortButton(onTap: () {
            sortFilter();
          }),
          SizedBox(width: 16),
          if (showSortChip)
            RpFilterChip(
              selectedSort: selectedSort,
              onClose: () {
                showSortChip = false;
                selectedSort = "Alphabet";
                applySort();
                setState(() {});
              },
            ),
          if (arn != "All")
            RpFilterChip(
              selectedSort: arn,
              onClose: () {
                arn = "All";
                amcList = [];
                setState(() {});
              },
            )
        ],
      ),
    );
  }

  Widget countLine() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Visibility(
        visible: !isLoading,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${amcList.length} Items", style: AppFonts.f40013),
          ],
        ),
      ),
    );
  }

  Widget listArea() {
    return Expanded(
      child: SingleChildScrollView(
        child: (isLoading)
            ? Utils.shimmerWidget(devHeight,
                margin: EdgeInsets.fromLTRB(16, 0, 16, 16))
            : ListView.separated(
                shrinkWrap: true,
                itemCount: amcList.length,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: DottedLine(),
                  );
                },
                itemBuilder: (context, index) {
                  Map<String, dynamic> amcData = amcList[index];
                  num percentage = amcData["percentage"];
                  num amount = amcData['total_sip_amount'];

                  return InkWell(
                    splashColor: Colors.white,
                    onTap: () {
                      Get.to(SchemeWiseSip(amc: amcData['amc_name']));
                    },
                    child: RpListTile2(
                      key: Key(amcData['amc_logo']),
                     // leading: Image.network(amcData['amc_logo'], height: 32),
                      leading:  Utils.getImage(amcData['amc_logo'],32),
                      l1: "${amcData['amc_short_name']}",
                      l2: "(${amcData['total_sip']} SIPs)",
                      r1: Utils.formatNumber(amount, isAmount: true),
                      r2: "(${percentage.toStringAsFixed(2)}%)",
                    ),
                  );
                },
              ),
      ),
    );
  }

  sortFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SizedBox(
              height: devHeight * 0.4,
              child: Column(
                children: [
                  BottomSheetTitle(title: "Sort & Filter"),
                  Divider(height: 1),
                  Expanded(
                    child: Row(
                      children: [
                        leftContent(bottomState),
                        Expanded(child: rightContent())
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

  Widget bottomLeftBtn({required String title, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(title),
        ),
      ),
    );
  }

  Widget bottomLeftSelectedBtn({required String title}) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        width: double.maxFinite,
        color: Colors.white,
        child: Center(
            child: Text(title,
                style: TextStyle(color: Config.appTheme.themeColor))),
      ),
    );
  }

  Widget leftContent(void Function(void Function() Function) bottomState) {
    return Container(
      width: devWidth * 0.35,
      color: Config.appTheme.mainBgColor,
      child: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          List list = bottomSheetFilter.keys.toList();
          String title = list[index];
          return (selectedLeft == title)
              ? bottomLeftSelectedBtn(title: title)
              : bottomLeftBtn(
                  title: title,
                  onTap: () {
                    selectedLeft = title;
                    bottomState(() {});
                  });
        },
      ),
    );
  }

  Widget rightContent() {
    if (selectedLeft == 'Sort by') return sortView();
    if (selectedLeft == 'ARN') return arnView();
    return Text("Invalid left");
  }

  Widget arnView() {
    return ListView.builder(
      itemCount: bottomSheetFilter['ARN'].length,
      itemBuilder: (context, index) {
        List list = bottomSheetFilter['ARN'];
        String title = list[index];

        return InkWell(
          onTap: () {
            arn = title;
            sortArn = true;
            amcList = [];
            Get.back();
            setState(() {});
          },
          child: Row(
            children: [
              Radio(
                  value: title,
                  groupValue: arn,
                  onChanged: (val) {
                    arn = title;
                    sortArn = true;
                    amcList = [];
                    Get.back();
                    setState(() {});
                  }),
              Text(title),
            ],
          ),
        );
      },
    );
  }

  Widget sortView() {
    List list = bottomSheetFilter['Sort by'];

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        String title = list[index];
        return InkWell(
          onTap: () {
            selectSortAction(title);
          },
          child: Row(
            children: [
              Radio(
                  value: title,
                  groupValue: selectedSort,
                  onChanged: (val) {
                    selectSortAction(title);
                  }),
              Text(list[index]),
            ],
          ),
        );
      },
    );
  }

  selectSortAction(String title) {
    selectedSort = title;
    showSortChip = true;
    Get.back();
    Future.delayed(Duration(milliseconds: 200), () {
      applySort();
      setState(() {});
    });
  }

  applySort() {
    if (selectedSort == 'Alphabet') {
      amcList
          .sort((a, b) => a['amc_short_name'].compareTo(b['amc_short_name']));
    } else if (selectedSort == 'SIP') {
      amcList.sort(
          (a, b) => b['total_sip_amount'].compareTo(a['total_sip_amount']));
    }
  }
}
