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

class PMSHoldings extends StatefulWidget {
  const PMSHoldings({
    super.key,
  });

  @override
  State<PMSHoldings> createState() => _PMSHoldingsState();
}

class _PMSHoldingsState extends State<PMSHoldings> {
  late double devHeight, devWidth;
  MasterPostfolioPojo masterPostfolioPojo = MasterPostfolioPojo();
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  bool isLoading = false;
  Pms pmsPojo = Pms();
  bool isFirst = true;
  PmsList pmsList = PmsList();
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
    pmsPojo = masterPostfolioPojo.pms ?? Pms();
    pmsList = pmsPojo.pmsList as PmsList;
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
          appBar: invAppBar(title: "PMS Holdings"),
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
                          itemCount: pmsPojo.pmsList?.length ?? 0,
                          itemBuilder: (context, index) {
                            PmsList? pmslist = pmsPojo.pmsList?[index];
                            return postOfficeCard(pmslist!);
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
                "$rupee ${Utils.formatNumber(pmsPojo.pmsCurrentValue)}",
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
                        "Current Cost",
                        style: TextStyle(
                            color: AppColors.readableGrey,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      ),
                      Text(
                        "$rupee ${Utils.formatNumber(pmsPojo.pmsCurrentCost)}",
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
                        "$rupee ${Utils.formatNumber(pmsPojo.pmsUnrealised)}",
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
                        "Dividend",
                        style: TextStyle(
                            color: AppColors.readableGrey,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      ),
                      Text(
                        "$rupee ${Utils.formatNumber(pmsPojo.pmsDividend)}",
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

  Widget postOfficeCard(PmsList pmsList) {
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
                        child: Text("${pmsList.schemeName}",
                            maxLines: 2,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  columnText("Service Provider",
                      "${(pmsList.serviceProviderName)}"),

                  SizedBox(height: 12),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          columnText("Current Value: ",
                            "$rupee ${Utils.formatNumber(pmsList.currentValue)}",),
                          columnText("Amount",
                              "$rupee ${Utils.formatNumber(pmsList.amount)}",
                              alignment: CrossAxisAlignment.center),
                          columnText(
                            "Maturity Value",
                            "$rupee ${Utils.formatNumber(pmsList.maturityValue)}",
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
                        children: [
                          Expanded(
                            flex: 1,
                            child: columnText(
                              "Maturity Date",
                              "${pmsList.maturityDate}",
                            ),
                          ),
                          Expanded(
                            child: columnText("Unrea Gain/Loss", " ${pmsList.unRealisedGain}",
                                alignment: CrossAxisAlignment.center),
                          ),
                          Expanded(
                            child: columnText("Dividend Value",
                                "${pmsList.dividendValue}",
                                alignment: CrossAxisAlignment.end),
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
