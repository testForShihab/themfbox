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

class AlternateInvestmentFunds extends StatefulWidget {
  const AlternateInvestmentFunds({
    super.key,
  });

  @override
  State<AlternateInvestmentFunds> createState() =>
      _AlternateInvestmentFundsState();
}

class _AlternateInvestmentFundsState extends State<AlternateInvestmentFunds> {
  late double devHeight, devWidth;
  MasterPostfolioPojo masterPostfolioPojo = MasterPostfolioPojo();
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  bool isLoading = false;
  Aif aifPojo = Aif();
  bool isFirst = true;
  AifList eqList = AifList();
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
    aifPojo = masterPostfolioPojo.aif ?? Aif();
    eqList = aifPojo.aifList as AifList;
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
          appBar: invAppBar(title: "Alternate Investment Funds"),
          body: SideBar(
            child: Container(
              color: Config.appTheme.mainBgColor,
              height: devHeight,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    investmentCard(),
                    Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: aifPojo.aifList?.length ?? 0,
                          itemBuilder: (context, index) {
                            AifList? aif = aifPojo.aifList?[index];

                            return aifCard(aif!);
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
    return (isLoading)
        ? Utils.shimmerWidget(130, margin: EdgeInsets.all(16))
        : Container(
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
                          Text(
                            "Current Value",
                            style: TextStyle(
                                color: AppColors.readableGrey,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                          Text(
                            "$rupee ${Utils.formatNumber(aifPojo.aifCurrValue)}",
                            style: TextStyle(
                                color: Config.appTheme.themeColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 32),
                          ),
                          DottedLine(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Maturity Value",
                                    style: TextStyle(
                                        color: AppColors.readableGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "$rupee ${Utils.formatNumber(aifPojo.aifMaturityValue)}",
                                    style: TextStyle(
                                        color: Config.appTheme.themeColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Current Cost",
                                    style: TextStyle(
                                        color: AppColors.readableGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "$rupee ${Utils.formatNumber(aifPojo.aifCurrCost)}",
                                    style: TextStyle(
                                        color: Config.appTheme.themeColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Unre Gain /Loss",
                                    style: TextStyle(
                                        color: AppColors.readableGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "$rupee ${Utils.formatNumber(aifPojo.aifUnrealised)}",
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

  Widget aifCard(AifList aifList) {
    return InkWell(
        onTap: () {
          //Get.to(goTo);
        },
        child: (isLoading)
            ? Utils.shimmerWidget(130, margin: EdgeInsets.all(16))
            : Container(
                width: devWidth,
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
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
                                  Expanded(
                                    child: Text("${aifList.fundName}",
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        )),
                                  ),
                                  Spacer(),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 10),
                                          decoration: BoxDecoration(
                                              color: Color(0xffEDFFFF),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              )),
                                          child: Text(
                                            "@ ${aifList.totalUnits}",
                                            style: TextStyle(
                                                color: AppColors.textGreen),
                                          )),
                                    ],
                                  )
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
                                    " $rupee ${Utils.formatNumber(aifList.currentValue)}",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      columnText("Commited\n   Amount",
                                          "$rupee ${Utils.formatNumber(aifList.commitedAmt)}"),
                                      columnText(
                                          "Contributed\n    Amount",
                                          Utils.formatNumber(
                                              aifList.contributedAmt),
                                          alignment: CrossAxisAlignment.center),
                                      columnText(
                                        "Gain/Loss",
                                        "${aifList.realisedGainAmt}",
                                        alignment: CrossAxisAlignment.end,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                    child: ListView.builder(
                                        itemCount: 100,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) => Text(
                                            "-",
                                            style: TextStyle(
                                                color: Colors.grey[400]))),
                                  ),
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: columnText(
                                          "XIRR",
                                          " ${aifList.xirr}",
                                        ),
                                      ),
                                      Expanded(
                                        child: columnText("Distribute Amount",
                                            "${aifList.distributedAmt}",
                                            alignment:
                                                CrossAxisAlignment.center),
                                      ),
                                      Expanded(
                                        child: columnText(
                                          "TDS Amount",
                                          "${aifList.tdsAmt}",
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
}
