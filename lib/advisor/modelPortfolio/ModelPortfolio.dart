import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/api/AdminApi.dart';
import 'package:mymfbox2_0/api/ApiConfig.dart';
import 'package:mymfbox2_0/api/ProposalApi.dart';
import 'package:mymfbox2_0/research/SchemeInfo.dart';
import 'package:mymfbox2_0/rp_widgets/RatingChip.dart';
import 'package:mymfbox2_0/rp_widgets/RpListTile.dart';
import 'package:mymfbox2_0/rp_widgets/RpSmallTf.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class ModelPortfolio extends StatefulWidget {
  const ModelPortfolio({super.key});

  @override
  State<ModelPortfolio> createState() => _ModelPortfolioState();
}

class _ModelPortfolioState extends State<ModelPortfolio> {
  int mfdId = GetStorage().read("mfd_id");
  String clientName = GetStorage().read("client_name");

  TextStyle underlineText = TextStyle(
      color: Config.appTheme.themeColor,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w500,
      fontSize: 13);

  Map modelPortfolioData = {};

  String amfiCode = "";

  Future getModelPortfolio() async {
    if (modelPortfolioData.isNotEmpty) return 0;

    Map data = await AdminApi.getModelPortfolio(
        user_id: mfdId, client_name: clientName);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    modelPortfolioData = data;

    return 0;
  }

  Map reportActionData = {
    "Download PDF Report ": ["", "", "assets/pdf.png"],
  };
  late double devHeight, devWidth;

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: getModelPortfolio(),
        builder: (context, snapshot) {
          return Scaffold(
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
                      "Model Portfolio",
                      style: AppFonts.f50014Black
                          .copyWith(fontSize: 18, color: Colors.white),
                    ),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          showReportActionBottomSheet();
                        },
                        child: Icon(Icons.pending_outlined))
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                SizedBox(height: 16),
                titleArea(),
                SizedBox(height: 16),
                middleArea(),
                SizedBox(height: 16),
                bottomArea(),
                SizedBox(height: 8),
              ],
            ),
          );
        });
  }

  Widget middleArea() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "List of Funds",
            style: AppFonts.f50014Grey,
          ),
          InkWell(
            onTap: () {
              addBottomSheet();
            },
            child: Text(
              "Add New Scheme",
              style: AppFonts.f50012.copyWith(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  editBottomSheet({required int index, required String schemeName}) async {
    String choosenScheme = schemeName;
    String query = schemeName;
    List suggestions = [];
    ExpansionTileController schemeController = ExpansionTileController();

    EasyLoading.show();
    Map data = await PropoaslApi.autoSuggestScheme(
        user_id: mfdId, query: query, client_name: clientName);
    suggestions = data['list'];
    EasyLoading.dismiss();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SizedBox(
              height: devHeight * 0.85,
              child: Column(
                children: [
                  BottomSheetTitle(title: "Add/Edit Scheme"),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            controller: schemeController,
                            title: Text("Scheme Name",
                                style: AppFonts.f50014Black),
                            subtitle:
                                Text(choosenScheme, style: AppFonts.f50012),
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
                                child: RpSmallTf(
                                  borderColor: Colors.black,
                                  initialValue: query,
                                  onChange: (val) async {
                                    query = val;
                                    Map data =
                                        await PropoaslApi.autoSuggestScheme(
                                            user_id: mfdId,
                                            query: query,
                                            client_name: clientName);
                                    suggestions = data['list'];
                                    bottomState(() {});
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 380,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: suggestions.length,
                                  itemBuilder: (context, index) {
                                    Map temp = suggestions[index];
                                    String name =
                                        temp['scheme_amfi_short_name'];

                                    return ListTile(
                                      onTap: () {
                                        choosenScheme = name;
                                        schemeController.collapse();
                                        bottomState(() {});
                                      },
                                      leading: Image.network(temp['logo'],
                                          height: 32),
                                      title: Text(name),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  SizedBox(height: 8),
                  InkWell(
                      onTap: () {
                        String currentKey = getCurrentKey();
                        List list = modelPortfolioData[currentKey];
                        list.removeAt(index);

                        Get.back();
                        setState(() {});
                      },
                      child: Stack(
                        children: [
                          Text(
                            "Delete Scheme",
                            style: AppFonts.f50012.copyWith(
                              color: Config.appTheme.defaultLoss,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 1, // Thickness of the underline
                              color: Config.appTheme
                                  .defaultLoss, // Color of the underline
                            ),
                          ),
                        ],
                      )),
                  SizedBox(height: 8),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          Map newScheme = await getNewSchemeForModelPortfolio(
                              choosenScheme);

                          if (newScheme.isEmpty) return;

                          String currentKey = getCurrentKey();

                          List list = modelPortfolioData[currentKey];

                          list[index] = newScheme;
                          Get.back();
                          setState(() {});
                          bottomState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Config.appTheme.buttonColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          "SUBMIT",
                          style: AppFonts.f50014Black
                              .copyWith(color: Colors.white),
                        ),
                      ),
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

  String getCurrentKey() {
    String temp = selectedType.toLowerCase().replaceAll(" ", "_");
    return "${temp}_list";
  }

  addBottomSheet() async {
    String choosenScheme = "";
    String query = "";
    List suggestions = [];
    ExpansionTileController schemeController = ExpansionTileController();

    EasyLoading.show();
    Map data = await PropoaslApi.autoSuggestScheme(
        user_id: mfdId, query: query, client_name: clientName);
    suggestions = data['list'];
    EasyLoading.dismiss();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, bottomState) {
            return SizedBox(
              height: devHeight * 0.90,
              child: Column(
                children: [
                  BottomSheetTitle(title: "Add/Edit Scheme"),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            controller: schemeController,
                            title: Text("Scheme Name",
                                style: AppFonts.f50014Black),
                            subtitle:
                                Text(choosenScheme, style: AppFonts.f50012),
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(12, 0, 12, 10),
                                child: RpSmallTf(
                                  borderColor: Colors.black,
                                  onChange: (val) async {
                                    query = val;
                                    Map data =
                                        await PropoaslApi.autoSuggestScheme(
                                            user_id: mfdId,
                                            query: query,
                                            client_name: clientName);
                                    suggestions = data['list'];
                                    bottomState(() {});
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 380,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: suggestions.length,
                                  itemBuilder: (context, index) {
                                    Map temp = suggestions[index];
                                    String name =
                                        temp['scheme_amfi_short_name'];

                                    return ListTile(
                                      onTap: () {
                                        choosenScheme = name;
                                        schemeController.collapse();
                                        bottomState(() {});
                                      },
                                      leading: Image.network(temp['logo'],
                                          height: 32),
                                      title: Text(name),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          Map newScheme = await getNewSchemeForModelPortfolio(
                              choosenScheme);

                          if (newScheme.isEmpty) return;

                          String finalTitle = getCurrentKey();

                          List list = modelPortfolioData[finalTitle];

                          list.add(newScheme);
                          Get.back();
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor:  Config.appTheme.buttonColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          "SUBMIT",
                          style: AppFonts.f50014Black
                              .copyWith(color: Colors.white),
                        ),
                      ),
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

  Future getNewSchemeForModelPortfolio(String schemeName) async {
    EasyLoading.show();
    Map data = await AdminApi.getNewSchemeForModelPortfolio(
        user_id: mfdId, client_name: clientName, scheme: schemeName);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return {};
    }
    EasyLoading.dismiss();

    return data['result'];
  }

  Widget bottomArea() {
    if (modelPortfolioData.isEmpty)
      return Expanded(child: Utils.shimmerWidget(100));

    String temp = selectedType.toLowerCase().replaceAll(" ", "_");
    String finalTitle = "${temp}_list";
    List list = modelPortfolioData[finalTitle];
    List amfiCodeList = [];
    amfiCode = "";
    for (var element in list!) {
      amfiCodeList.add(element['scheme_amfi_code']);
    }
    amfiCode = amfiCodeList.join(",");
    print("amfiCode $amfiCode");
    return (list.isEmpty)
        ? NoData()
        : Expanded(
            child: SingleChildScrollView(
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  Map scheme = list[index];
                  return schemeCard(scheme, index);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(height: 24),
              ),
            ),
          );
  }

  Widget schemeCard(Map scheme, int index) {
    String? schemeName = scheme['scheme_amfi_short_name'];
    String? schemeFullName = scheme['scheme_amfi'];
    String logo = scheme['scheme_logo'] ?? "";
    num y1Return = scheme['year1_return'] ?? 0;
    num y3Return = scheme['year3_return'] ?? 0;
    num y5Return = scheme['year5_return'] ?? 0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: Config.appTheme.placeHolderInputTitleAndArrow)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(logo, height: 32),
                SizedBox(width: 10),
                Expanded(
                  child: ColumnText(
                    title: "$schemeName",
                    titleStyle: AppFonts.f50014Black,
                    value: "${scheme['scheme_category']}",
                    valueStyle: AppFonts.f40013,
                  ),
                ),
                RatingChip(rating: "${scheme['scheme_rating']} "),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                DottedLine(verticalPadding: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColumnText(
                      title: "1Y Return",
                      value: "${Utils.formatNumber(y1Return)}%",
                    ),
                    ColumnText(
                        title: "3Y Return",
                        value: "${Utils.formatNumber(y3Return)}%",
                        alignment: CrossAxisAlignment.center),
                    ColumnText(
                        title: "5Y Return",
                        value: "${Utils.formatNumber(y5Return)}%",
                        alignment: CrossAxisAlignment.end),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Get.to(SchemeInfo(
                          schemeName: schemeFullName,
                          schemeShortName: schemeName,
                          schemeLogo: logo,
                        ));
                      },
                      child: Text(
                        "View Details",
                        style: underlineText,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        editBottomSheet(
                            index: index, schemeName: "$schemeName");
                      },
                      child: Text(
                        "Edit",
                        style: underlineText,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List modelList = [
    "Aggressive",
    "Moderately Aggressive",
    "Moderate",
    "Conservative",
    "Moderately Conservative",
  ];
  String selectedType = "Aggressive";

  titleArea() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: modelList.length,
        itemBuilder: (context, index) {
          String type = modelList[index];
          if (selectedType == type) {
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
      return PlainButton(
        text: text,
        padding: padding,
        color: Config.appTheme.themeColor,
        onPressed: () {
          selectedType = text;
          setState(() {});
        },
      );
    } else {
      return RpFilledButton(text: selectedType, padding: padding,color: Config.appTheme.themeColor,);
    }
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        reportActionContainer(),
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
                String url =
                    "${ApiConfig.apiUrl}/admin/download/downloadModelPortfolioPDF?key=${ApiConfig.apiKey}&user_id=$mfdId&client_name=$clientName&amfi_code_array=$amfiCode&risk_type=$selectedType";

                http.Response response = await http.post(Uri.parse(url));
                msgUrl = response.body;
                Map data = jsonDecode(msgUrl);
                String resUrl = data['msg'];
                print("download $url");
                rpDownloadFile(url: resUrl, index: index);
                Get.back();

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
}
