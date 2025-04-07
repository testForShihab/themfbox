import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class LifeInsuranceHoldings extends StatefulWidget {
  const LifeInsuranceHoldings({
    super.key,
  });

  @override
  State<LifeInsuranceHoldings> createState() => _LifeInsuranceHoldingsState();
}

class _LifeInsuranceHoldingsState extends State<LifeInsuranceHoldings> {
  late double devHeight, devWidth;
  MasterPostfolioPojo masterPostfolioPojo = MasterPostfolioPojo();
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  bool isLoading = false;
  LifeInsurance lifeInsurancePojo = LifeInsurance();
  bool isFirst = true;
  LifeInsuranceList liList = LifeInsuranceList();
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
    lifeInsurancePojo = masterPostfolioPojo.lifeInsurance ?? LifeInsurance();
    liList = lifeInsurancePojo.lifeInsuranceList as LifeInsuranceList;
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
          appBar: invAppBar(title: "Life Insurance"),
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
                          itemCount:
                              lifeInsurancePojo.lifeInsuranceList?.length ?? 0,
                          itemBuilder: (context, index) {
                            LifeInsuranceList? lifeInsurance =
                                lifeInsurancePojo.lifeInsuranceList?[index];

                            return lifeInsuranceCard(lifeInsurance!);
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
                            "Risk Cover	",
                            style: TextStyle(
                                color: AppColors.readableGrey,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                          Text(
                            "$rupee ${Utils.formatNumber(lifeInsurancePojo.totalLifeRiskCover)}",
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
                                    "Total Premium / Year",
                                    style: TextStyle(
                                        color: AppColors.readableGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "$rupee ${Utils.formatNumber(lifeInsurancePojo.totalLifePremiumPerYear)}",
                                    style: TextStyle(
                                        color: Config.appTheme.themeColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              /*  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Return",
                        style: TextStyle(
                            color: AppColors.readableGrey,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      ),
                      Text(
                        "$rupee ${Utils.formatNumber(postOfficePojo.postalTotalReturn)}",
                        style: TextStyle(
                            color: Config.appTheme.themeColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      ),
                    ],
                  ),*/
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Premium paid	",
                                    style: TextStyle(
                                        color: AppColors.readableGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "$rupee ${Utils.formatNumber(lifeInsurancePojo.totalLifePremiumPaid)}",
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

  Widget lifeInsuranceCard(LifeInsuranceList lifeInsuranceList) {
    return InkWell(
        onTap: () {
          //Get.to(goTo);
        },
        child: (isLoading)
            ? Utils.shimmerWidget(130, margin: EdgeInsets.all(16))
            : Container(
                width: devWidth,
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.fromLTRB(10, 16, 10, 0),
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
                                    child:
                                        Text("${lifeInsuranceList.companyName}",
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            )),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Text(
                                    "Product Name : ",
                                    style: TextStyle(
                                        color: AppColors.readableGrey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${(lifeInsuranceList.productName)}",
                                      maxLines: 4,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      columnText("Product Type",
                                          "${(lifeInsuranceList.productType)}"),
                                      columnText("Mode",
                                          " ${(lifeInsuranceList.premiumMode)}",
                                          alignment: CrossAxisAlignment.center),
                                      columnText(
                                        "Policy Number",
                                        "${lifeInsuranceList.policyNumber}",
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
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      columnText("Start Date",
                                          "${(lifeInsuranceList.startDate?.substring(0, 10))}"),
                                      columnText("Maturity Date",
                                          "${(lifeInsuranceList.maturityDate?.substring(0, 10))}",
                                          alignment: CrossAxisAlignment.center),
                                      columnText(
                                        "Due Date",
                                        "${(lifeInsuranceList.transactionDate?.substring(0, 10))}",
                                        alignment: CrossAxisAlignment.end,
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 10),
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
                                          "Policy Term	",
                                          " ${lifeInsuranceList.policyTerm}",
                                        ),
                                      ),
                                      Expanded(
                                        child: columnText("Policy Status",
                                            "${lifeInsuranceList.policyStatus}",
                                            alignment:
                                                CrossAxisAlignment.center),
                                      ),
                                      Expanded(
                                          child: columnText("Risk Coverage",
                                              "${lifeInsuranceList.riskCoverage}",alignment: CrossAxisAlignment.end)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                    child: ListView.builder(
                                        itemCount: 100,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) => Text("-",style: TextStyle(color: Colors.grey[400]),)),
                                  ),
                                  SizedBox(height: 16,),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                          child: columnText("Premium Amount W/O GST", "${lifeInsuranceList.premiumAmount}")),
                                      Expanded(
                                        flex: 1,
                                          child: columnText("Premium Term", "${lifeInsuranceList.premiumTerm}",alignment: CrossAxisAlignment.center)),
                                      Expanded(
                                        flex: 1,
                                          child: columnText("Premium Paid", "${lifeInsuranceList.totalPremiumPaid}", alignment: CrossAxisAlignment.end,)),
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
