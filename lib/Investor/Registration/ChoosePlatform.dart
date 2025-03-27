import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Registration/OnboardingStatus.dart';
import 'package:mymfbox2_0/api/onBoarding/CommonOnBoardApi.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';

class ChoosePlatform extends StatefulWidget {
  const ChoosePlatform({super.key});

  @override
  State<ChoosePlatform> createState() => _ChoosePlatformState();
}

class _ChoosePlatformState extends State<ChoosePlatform> {
  String client_name = GetStorage().read("client_name");

  List vendorList = [];
  Future getVendor() async {
    Map data = await CommonOnBoardApi.getVendor(client_name: client_name);

    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }

    vendorList = data['verdors_list'];
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getVendor(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar: invAppBar(showCartIcon: false, title: "Choose Platform"),
            body: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: vendorList.length,
                    itemBuilder: (context, index) {
                      Map vendor = vendorList[index];
                      String title = vendor['title'];
                      String bse_nse_mfu = vendor['bse_nse_mfu'];

                      return ListTile(
                        onTap: () async {
                          Get.to(
                              () => OnboardingStatus(bse_nse_mfu: bse_nse_mfu));
                        },
                        tileColor: Colors.white,
                        leading: Image.network(vendor['logo'], height: 32),
                        title: Text(title, style: AppFonts.f50014Theme),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Config.appTheme.placeHolderInputTitleAndArrow,
                          size: 20,
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(height: 16),
                  )
                ],
              ),
            ),
          );
        });
  }
}
