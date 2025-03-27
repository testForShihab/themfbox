import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import '../../api/InvestorApi.dart';
import '../../pojo/MasterPortfolioPojo.dart';
import '../../rp_widgets/InvAppBar.dart';
import '../../utils/AppColors.dart';
import '../../utils/AppFonts.dart';
import '../../utils/Config.dart';
import '../../utils/Constants.dart';
import '../../utils/Utils.dart';

class StructuredHoldings extends StatefulWidget {
  const StructuredHoldings({
    super.key,
  });

  @override
  State<StructuredHoldings> createState() => _StructuredHoldingsState();
}

class _StructuredHoldingsState extends State<StructuredHoldings> {
  late double devHeight, devWidth;
  MasterPostfolioPojo masterPostfolioPojo = MasterPostfolioPojo();
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  bool isLoading = false;
  Structured structuredPojo = Structured();
  bool isFirst = true;
  StructuredList structuredList = StructuredList();
  String? issuerName;

  Future getMasterPortfolio() async {
    if (!isFirst) return 0;
    Map<String, dynamic> data = await InvestorApi.getMasterPortfolio(
        user_id: user_id, client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return 0;
    }

    masterPostfolioPojo = MasterPostfolioPojo.fromJson(data);
    structuredPojo = masterPostfolioPojo.structured ?? Structured();
    structuredList = structuredPojo.structuredList as StructuredList;
  }

  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: getMasterPortfolio(),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Config.appTheme.themeColor,
          appBar: invAppBar(title: "Structured Holdings"),
          body: SideBar(
            child: Container(
              color: Config.appTheme.mainBgColor,
              height: devHeight,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    investmentCard(),
                    (isLoading)
                        ? Utils.shimmerWidget(devHeight,
                            margin: EdgeInsets.all(16))
                        : Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    structuredPojo.structuredList?.length ?? 0,
                                itemBuilder: (context, index) {
                                  StructuredList? structured =
                                      structuredPojo.structuredList?[index];

                                  return structuredCard(structured!);
                                },
                              ),
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget investmentCard() {
    return Container(
      color: Config.appTheme.themeColor,
      width: devWidth,
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 10, 16, 16),
        decoration: BoxDecoration(
          color: Config.appTheme.overlay85,
          borderRadius: BorderRadius.circular(10),
        ),
        child: (isLoading)
            ? Utils.shimmerWidget(130, margin: EdgeInsets.zero)
            : Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Current Value",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppColors.readableGrey,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        ),
                        Text(
                          "$rupee ${Utils.formatNumber(structuredPojo.structuredCurrentValue)}",
                          style: TextStyle(
                              color: Config.appTheme.themeColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 32),
                        ),
                      ],
                    ),
                    DottedLine(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Investment",
                              style: TextStyle(
                                  color: AppColors.readableGrey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                            Text(
                              "$rupee ${Utils.formatNumber(structuredPojo.structuredCurrentCost)}",
                              style: TextStyle(
                                  color: Config.appTheme.themeColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Gain/Loss",
                              style: TextStyle(
                                  color: AppColors.readableGrey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                            Text(
                              "$rupee ${Utils.formatNumber(structuredPojo.structuredUnrealised)}",
                              style: TextStyle(
                                  color: Config.appTheme.themeColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Returns",
                              style: TextStyle(
                                  color: AppColors.readableGrey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                            Text(
                              "$rupee ${Utils.formatNumber(structuredPojo.structuredReturn)}",
                              style: TextStyle(
                                  color: Config.appTheme.themeColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget structuredCard(StructuredList structuredList) {
    return InkWell(
        onTap: () {
          //Get.to(goTo);
        },
        child: Container(
          width: devWidth,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: (isLoading)
              ? Utils.shimmerWidget(130, margin: EdgeInsets.zero)
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/masterPortfolio.png",
                              height: 28,
                            ),
                            SizedBox(width: 10),
                            Text("${structuredList.schemeName}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                )),
                            /*Spacer(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                    alignment: Alignment.topRight,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: AppColors.lightGreen,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Text(
                                      "@ ${structuredList.tenure}",
                                      style:
                                          TextStyle(color: AppColors.textGreen),
                                    )),
                              ],
                            )*/
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              "Current Value:",
                              style: TextStyle(
                                  color: AppColors.readableGrey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),
                            ),
                            Text(
                              " $rupee ${Utils.formatNumber(structuredList.currentValue)}",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                columnText("Amount",
                                    "$rupee ${Utils.formatNumber(structuredList.amount)}"),
                                columnText("Gain/Loss",
                                    "$rupee ${Utils.formatNumber(structuredList.gainLossStr as num?)}",
                                    alignment: CrossAxisAlignment.center),
                                columnText(
                                  "Maturity",
                                  "${structuredList.maturityDate/*?.substring(0, 10)*/}",
                                  alignment: CrossAxisAlignment.end,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                              child: ListView.builder(
                                  itemCount: 100,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Text("-",
                                      style:
                                          TextStyle(color: Colors.grey[400]))),
                            ),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: columnText(
                                    "Dividend Value",
                                    " ${structuredList.dividendValue}",
                                  ),
                                ),
                                Expanded(
                                  child: columnText("Tenure Type",
                                      "${structuredList.tenure} ${structuredList.tenureType}",
                                      alignment: CrossAxisAlignment.center),
                                ),
                                Expanded(
                                  child: columnText(
                                    "Maturity Amt",
                                    "$rupee ${Utils.formatNumber(structuredList.maturityValue)}",
                                    alignment: CrossAxisAlignment.end,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ]),
                ),
        ));
  }

  Widget columnText(String title, String value,
      {CrossAxisAlignment? alignment}) {
    return Column(
      crossAxisAlignment: alignment ?? CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.f40013,
        ),
        Text(
          value,
          style: AppFonts.f50014Grey.copyWith(color: Colors.black),
          maxLines: 3,
        )
      ],
    );
  }

  Widget dayChange({num? value, num? percentage}) {
    return Visibility(
      visible: percentage != null,
      child: Row(
        children: [
          Text(
            "Current Value ",
            style: TextStyle(
                color: AppColors.readableGrey,
                fontWeight: FontWeight.w500,
                fontSize: 12),
          ),
          Text(
            "$rupee ${Utils.formatNumber(structuredList.currentValue)}",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          Text(
            " ($percentage%)",
            style: TextStyle(
                color: Color(0xff3CB66D),
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
