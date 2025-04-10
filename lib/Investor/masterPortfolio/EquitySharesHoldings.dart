import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/masterPortfolio/EquitySharesHoldingsDetails.dart';
import 'package:mymfbox2_0/rp_widgets/DottedLine.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import '../../api/InvestorApi.dart';
import '../../pojo/MasterPortfolioPojo.dart';
import '../../rp_widgets/ColumnText.dart';
import '../../rp_widgets/InvAppBar.dart';
import '../../utils/AppColors.dart';
import '../../utils/AppFonts.dart';
import '../../utils/Config.dart';
import '../../utils/Constants.dart';
import '../../utils/Utils.dart';

class EquitySharesHoldings extends StatefulWidget {
  const EquitySharesHoldings({
    super.key,
  });

  @override
  State<EquitySharesHoldings> createState() => _EquitySharesHoldingsState();
}

class _EquitySharesHoldingsState extends State<EquitySharesHoldings> {
  late double devHeight, devWidth;
  MasterPostfolioPojo masterPostfolioPojo = MasterPostfolioPojo();
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  bool isLoading = false;
  Equity equityPojo = Equity();
  bool isFirst = true;
  EquityList eqList = EquityList();
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
    equityPojo = masterPostfolioPojo.equity ?? Equity();
    eqList = equityPojo.equityList as EquityList;
  }

  Future getDatas() async {
    isLoading = true;
    await getMasterPortfolio();
    isLoading = false;
    return 0;
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
          appBar: invAppBar(title: "Equity Shares"),
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
                          itemCount: equityPojo.equityList?.length ?? 0,
                          itemBuilder: (context, index) {
                            EquityList? equitylist =
                                equityPojo.equityList?[index];

                            return equityCard(equitylist!);
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
                          Text(
                            "Current Value",
                            style: TextStyle(
                                color: AppColors.readableGrey,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                          Text(
                            "$rupee ${Utils.formatNumber(equityPojo.equityTotalCurrentValue?.toInt())}",
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
                                    "Invested Value",
                                    style: TextStyle(
                                        color: AppColors.readableGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "$rupee ${Utils.formatNumber(equityPojo.equityTotalCurrentCost?.toInt())}",
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
                                    "Return",
                                    style: TextStyle(
                                        color: AppColors.readableGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "${(equityPojo.equityTotalReturn)}$percentage",
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
                                    "Total Gain / Loss",
                                    style: TextStyle(
                                        color: AppColors.readableGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "$rupee ${Utils.formatNumber(equityPojo.equityTotalUnrealisedProfitLoss?.toInt())}",
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

  Widget equityCard(EquityList equityList) {
    return InkWell(
        onTap: () {
          Get.to(EquitySharesHoldingsDetails(compayName: '${equityList.companyName}',));
        },
        child:Container(
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
                                    child: Text("${equityList.companyName}",
                                       maxLines: 2,
                                       style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                     )),
                               ),
                               Spacer(),
                               Icon(Icons.arrow_forward,
                                   color: Config.appTheme.themeColor)
                                                            ],
                                                          ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Text(
                                    "Avg Share Price",
                                    style: TextStyle(
                                        color: AppColors.readableGrey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                                  ),
                                  Text(
                                      "$rupee ${Utils.formatNumber(equityList.purchasePrice)}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Spacer(),
                                  Text("Number of Shares :",
                                      style: TextStyle(
                                      color: AppColors.readableGrey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12)),
                                  Text(" ${Utils.formatNumber(equityList.positiveUnits)}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              SizedBox(height: 16),
                              rpRow(
                                  lhead: 'Invested Amount',
                                  lSubHead: '${rupee} ${Utils.formatNumber(equityList.totalInflow?.toInt())}',
                                  rhead: 'Current Price',
                                  rSubHead: '$rupee ${Utils.formatNumber(equityList.purchasePrice)}',
                                  chead: 'Current Value',
                                  cSubHead: '$rupee ${Utils.formatNumber(equityList.latestNav)}'),
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
                              rpRow(
                                  lhead: 'Gain/Loss',
                                  lSubHead: Utils.formatNumber(equityList.unReliasedProfitLoss?.toInt()),
                                  rhead: 'Abs Rtn (%)',
                                  rSubHead: '${rupee} ${Utils.formatNumber(equityList.unReliasedProfitLoss?.toInt())}',
                                  chead: 'XIRR (%)',
                                  cSubHead: '${equityList.xirrValue}'),
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
            child: ColumnText(
                title: chead,
                value: cSubHead,
                alignment: CrossAxisAlignment.end)),
      ],
    );
  }
}
