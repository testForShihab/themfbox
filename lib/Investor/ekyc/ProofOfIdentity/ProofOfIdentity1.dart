import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/Investor/ekyc/ProofOfIdentity/ProofOfIdentity2.dart';
import 'package:mymfbox2_0/api/EkycApi.dart';
import 'package:mymfbox2_0/rp_widgets/AmountInputCard.dart';
import 'package:mymfbox2_0/rp_widgets/RpAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class ProofOfIdentity1 extends StatefulWidget {
  const ProofOfIdentity1({super.key});

  @override
  State<ProofOfIdentity1> createState() => _ProofOfIdentity1State();
}

class _ProofOfIdentity1State extends State<ProofOfIdentity1> {
  int user_id = GetStorage().read("user_id");
  String client_name = GetStorage().read("client_name");
  String pan = GetStorage().read("user_pan");
  String name = GetStorage().read("user_name");
  String ekyc_id = GetStorage().read("ekyc_id");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.appTheme.mainBgColor,
      appBar: rpAppBar(
        title: "Proof Of Identity",
        bgColor: Config.appTheme.themeColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Fetch PAN from Digilocker", style: AppFonts.f50014Grey),
            SizedBox(height: 16),
            AmountInputCard(
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
              ],
              title: "PAN Number",
              suffixText: "",
              hasSuffix: false,
              borderRadius: BorderRadius.circular(20),
              onChange: (val) => pan = val,
              maxLength: 10,
              initialValue: pan,
              readOnly: true,
            ),
            SizedBox(height: 16),
            AmountInputCard(
              title: "Name as on PAN",
              suffixText: "",
              hasSuffix: false,
              borderRadius: BorderRadius.circular(20),
              onChange: (val) => name = val,
              initialValue: name,
              keyboardType: TextInputType.name,
            ),
            SizedBox(height: 16),
            RpFilledButton(
                onPressed: () async {
                  EasyLoading.show();
                  int res = await savePersonalIdentity();
                  EasyLoading.dismiss();
                  if (res != 0) return;

                  Get.to(() => ProofOfIdentity2());
                },
                text: "SUBMIT",
                padding: EdgeInsets.symmetric(vertical: 12))
          ],
        ),
      ),
    );
  }

  Future savePersonalIdentity() async {
    Map data = await EkycApi.savePersonalIdentity(
      user_id: user_id,
      client_name: client_name,
      name: name,
      pan: pan,
      ekyc_id: ekyc_id,
    );

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    return 0;
  }
}
