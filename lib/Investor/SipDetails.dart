import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/api/InvestorApi.dart';
import 'package:mymfbox2_0/pojo/SipPojo.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Constants.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class SipDetails extends StatefulWidget {
  const SipDetails({Key? key}) : super(key: key);

  @override
  State<SipDetails> createState() => _SipDetailsState();
}

class _SipDetailsState extends State<SipDetails> {

  List<SipPojo> sipList = [];
  bool isFirst = true;
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");

  Future getSipList() async {
    if (!isFirst) return 0;

    Map data = await InvestorApi.getSipMasterDetails(
        user_id: user_id, client_name: client_name, max_count: 'All');
    if (data['status'] != 200) {
      Utils.showError(context, "${data['msg']}");
      return 0;
    }
    List list = data['list'];
    list.forEach((element) {
      sipList.add(SipPojo.fromJson(element));
    });

    return 0;
  }
  late double devHeight, devWidth;
  @override
  Widget build(BuildContext context) {
    devHeight = MediaQuery.of(context).size.height;
    devWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: getSipList(),
      builder: (context, snapshot) {
        return Scaffold(
            appBar: rpAppBar(
                title: "SIP's",
                bgColor: Config.appTheme.themeColor,
                foregroundColor: Colors.white),
            body:Padding(
              padding:  EdgeInsets.only(top: 24),
              child: SingleChildScrollView(
                child: sipArea(),
              ),
            )
        );
      },
    );


  }
  Widget sipArea() {
    return ListView.builder(
      itemCount:  sipList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return sipCard(sipList[index]);
      },
    );
  }

  Widget sipCard(SipPojo sip) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            children: [
              Image.network("${sip.logo}", height: 32),
              SizedBox(width: 10),
              SizedBox(
                width: devWidth * 0.4,
                child: Text("${sip.schemeAmfiShortName}",
                    style: AppFonts.f50014Black),
              ),
              Spacer(),
              Text("$rupee ${Utils.formatNumber(sip.sipAmount)}",
                  style: AppFonts.f50014Black),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Folio : ${sip.folio}", style: AppFonts.f40013),
              Text("${sip.sipDateWithFrequency}", style: AppFonts.f40013),
            ],
          ),
          /*SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Start Date : ${Utils.getFormattedDate()}", style: AppFonts.f40013),
              Text("End Date : ${Utils.getFormattedDate()}", style: AppFonts.f40013),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Units : ${sip.sipDate}", style: AppFonts.f40013),
              Text("XIRR : ${sip.sipDate}%", style: AppFonts.f40013),
            ],
          ),*/
        ],
      ),
    );
  }

}
