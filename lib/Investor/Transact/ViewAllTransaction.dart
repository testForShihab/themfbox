import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/pojo/SipPojo.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/SideBar.dart';
import 'package:mymfbox2_0/utils/AppColors.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class ViewAllTransaction extends StatefulWidget {
  const ViewAllTransaction({super.key});

  @override
  State<ViewAllTransaction> createState() => _ViewAllTransactionState();
}


class _ViewAllTransactionState extends State<ViewAllTransaction> {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<SipPojo> transactionList = [];
  bool isLoading = true;
  bool isFirst = true;

  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");

  Future getTransactionList() async {
    if (!isFirst) return 0;
    Map data = await InvestorApi.getTransactionDetails(
        user_id: user_id, client_name: client_name, max_count: 'all');
    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      return 0;
    }
    List list = data['list'];
    list.forEach((element) {
      transactionList.add(SipPojo.fromJson(element));
    });
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getTransactionList(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: invAppBar(title: "All Transaction"),
            body: RefreshIndicator(
              key: refreshIndicatorKey,
              onRefresh: () async {
                isFirst = true;
                setState(() {});
              },
              child: SideBar(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      trnxArea(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget trnxArea() {
    return Container(
      margin: EdgeInsets.all(8),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: transactionList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return trnxCard(transactionList[index]);
          }),
    );
  }

  Widget trnxCard(SipPojo trnx) {
    String amount = Utils.formatNumber((trnx.trnxAmount)!.round());
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.network(
                "${trnx.logo}",
                height: 32,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Text(
                "${trnx.schemeAmfiShortName}",
                style: AppFonts.f50014Black,
              )),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${trnx.trnxDate}",
                style: AppFonts.f40013,
              ),
              Text(
                "Folio: ${trnx.folio}",
                style: AppFonts.f40013,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(
                padding: EdgeInsets.zero,
                label: Text(
                  "${trnx.trnxType}",
                  style: TextStyle(color: Config.appTheme.themeColor),
                ),
                backgroundColor: Color(0XFFECFFFF),
              ),
              Text(
                "$rupee $amount",
                style: AppFonts.f50014Grey.copyWith(color: AppColors.textGreen),
              )
            ],
          ),
        ],
      ),
    );
  }
}
