import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymfbox2_0/Investor/Registration/BankInfo/BankInfo.dart';
import 'package:mymfbox2_0/Investor/Registration/ContactInfo/ContactInfo.dart';
import 'package:mymfbox2_0/Investor/Registration/NomineeInfo/NomineeInfo.dart';
import 'package:mymfbox2_0/Investor/Registration/PersonalInfo/PersonalInfo.dart';
import 'package:mymfbox2_0/Investor/Registration/RegistrationSuccessful.dart';
import 'package:mymfbox2_0/Investor/Registration/Signature/Signature.dart';
import 'package:mymfbox2_0/Investor/Transact/cart/rpExports.dart';
import 'package:mymfbox2_0/Investor/Registration/InvestorInfo/InvestorInfo.dart';
import 'package:mymfbox2_0/api/onBoarding/CommonOnBoardApi.dart';
import 'package:mymfbox2_0/login/CheckAuth.dart';
import 'package:mymfbox2_0/login/CheckUserType.dart';
import 'package:mymfbox2_0/pojo/onboarding/OnboardingStatusPojo.dart';
import 'package:mymfbox2_0/rp_widgets/InvAppBar.dart';
import 'package:mymfbox2_0/rp_widgets/RpDivider.dart';
import 'package:mymfbox2_0/rp_widgets/RpRegTile.dart';
import 'package:mymfbox2_0/utils/AppFonts.dart';
import 'package:mymfbox2_0/utils/Config.dart';
import 'package:mymfbox2_0/utils/Utils.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'BSERegistrationSuccessful.dart';
import 'JointHolder/JointHolderInfo.dart';
import 'JointHolder/join_holder_info_page.dart';
import 'NriInfo/NriInfo.dart';
class OnboardingStatus extends StatefulWidget {
  const OnboardingStatus({super.key, required this.bse_nse_mfu});
  final String bse_nse_mfu;
  @override
  State<OnboardingStatus> createState() => _OnboardingStatusState();
}
class _OnboardingStatusState extends State<OnboardingStatus> {
  int user_id = GetStorage().read('user_id');
  String client_name = GetStorage().read("client_name");
  bool checkRequiredOrNot = false;
  Result result = Result();
  List<MenuList> menuList = [];
  Future getOnboardingStatus() async {
    Map<String, dynamic> data = await CommonOnBoardApi.getOnBoardingStatus(
        user_id: user_id,
        client_name: client_name,
        bse_nse_mfu_flag: widget.bse_nse_mfu);
    if (data['status'] != 200) {
      Utils.showError(context, data['msg']);
      return -1;
    }
    OnboardingStatusPojo pojo = OnboardingStatusPojo.fromJson(data);
    result = pojo.result!;
    menuList = result.menuList ?? [];
    return 0;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getOnboardingStatus(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Config.appTheme.mainBgColor,
            appBar:
            invAppBar(showCartIcon: false, title: "Online Registration"),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (result.logo != null)
                          Row(
                            children: [
                              Image.network("${result.logo}", height: 32),
                              SizedBox(width: 16),
                              Text("${result.title}",
                                  style: AppFonts.f50014Theme),
                            ],
                          ),
                        DottedLine(verticalPadding: 8),
                        SizedBox(height: 16),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: menuList.length,
                          itemBuilder: (context, index) {
                            MenuList menu = menuList[index];
                            String title = menu.title ?? "";
                            bool isCompleted = menu.completed ?? false;
                            bool enabled = menu.enabled ?? true;
                            checkRequiredOrNot =
                                menu.checkRequiredOrNot ?? false;
                            return Opacity(
                              opacity: enabled ? 1 : 0.5,
                              child: RpRegTile(
                                  onTap: () {
                                    if (!enabled) return;
                                    Get.to(
                                      pages[title],
                                      arguments: widget.bse_nse_mfu,
                                    )!
                                        .then((value) {
                                      setState(() {});
                                    });
                                  },
                                  title: title,
                                  isCompleted: isCompleted,
                                  leading: Image.asset(getLocalImage(title),
                                      height: 32),
                                  subTitle: (isCompleted)
                                      ? completedText()
                                      : pendingText()),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Row(
                              children: [
                                RpDivider(),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (result.isAllStepsCompleted ?? false)
                    CalculateButton(
                        onPress: () async {
                          EasyLoading.show();

                          if(widget.bse_nse_mfu != "BSE"){
                            Map data = await CommonOnBoardApi.onlineRegistration(
                                user_id: user_id,
                                client_name: client_name,
                                bse_nse_mfu_flag: widget.bse_nse_mfu);
                            if (data['status'] != 200) {
                              Utils.showError(context, data['msg']);
                              return -1;
                            }
                            EasyLoading.dismiss();
                              Get.offAll(() => CheckUserType());
                              Get.to(() => RegistrationSuccessful(msg: data['msg']));

                          }

                          if(widget.bse_nse_mfu == "BSE"){
                            Map data = await CommonOnBoardApi.onlineRegistration(
                                user_id: user_id, client_name: client_name, bse_nse_mfu_flag: widget.bse_nse_mfu);

                            if (data['status'] != 200) {
                              Utils.showError(context, data['msg']);
                              return -1;
                            }
                            EasyLoading.dismiss();
                            Get.offAll(() => CheckUserType());
                            Get.to(() => BSERegistrationSuccessful(msg: data['msg']));

                          }

/*if(widget.bse_nse_mfu == "BSE" && data['status'] == 200){
EasyLoading.show();
Map data = await CommonOnBoardApi.getNomineeAuthenticationLink(
user_id: user_id,
client_name: client_name,
investor_code: '');
if (data['status'] != 200) {
Utils.showError(context, data['msg']);
return -1;
}
Map<String, dynamic> result = data['result'];
String url = result['payment_link'];
await launchUrlString(url);
EasyLoading.dismiss();

EasyLoading.show();
Map uploaddata = await CommonOnBoardApi.uploadBseAOF(
user_id: user_id,
client_name: client_name,
bse_nse_mfu_flag: widget.bse_nse_mfu,
);
if (uploaddata['status'] != 200) {
Utils.showError(context, data['msg']);
return -1;
}
String uploadurl = uploaddata['msg'];
print("uploadurl $uploadurl");
await launchUrlString(url);
EasyLoading.dismiss();
Get.offAll(() => CheckUserType());
Get.to(() => RegistrationSuccessful(msg: uploadurl));
}*/
                          /*if (widget.bse_nse_mfu == "BSE" &&
                              data['status'] == 200) {
                            EasyLoading.show();
                            Map data = await CommonOnBoardApi
                                .getNomineeAuthenticationLink(
                                user_id: user_id,
                                client_name: client_name,
                                investor_code: '');
                            if (data['status'] != 200) {
                              Utils.showError(context, data['msg']);
                              return -1;
                            }
                            Map<String, dynamic> result = data['result'];
                            String url = result['payment_link'];
// Launch the URL
                            bool launched = await launchUrlString(url);
// Ensure that the URL was launched successfully
                            if (!launched) {
                              EasyLoading.dismiss();
                              Utils.showError(
                                  context, 'Failed to launch the URL');
                              return -1;
                            }
// Show a dialog or loading message to inform the user to come back
                            bool userConfirmed =
                            await _showReturnConfirmationDialog();
                            if (!userConfirmed) {
                              EasyLoading.dismiss();
                              return -1; // Handle the case where the user doesn't confirm
                            }
// Once the URL is launched and the user has confirmed or interacted, proceed with uploading BSE AOF
                            EasyLoading.show();
                            Map uploaddata =
                            await CommonOnBoardApi.uploadBseAOF(
                              user_id: user_id,
                              client_name: client_name,
                              bse_nse_mfu_flag: widget.bse_nse_mfu,
                            );
                            if (uploaddata['status'] != 200) {
                              Utils.showError(context, uploaddata['msg']);
                              EasyLoading.dismiss();
                              return -1;
                            }
                            String uploadurl = uploaddata['msg'];
                            print("uploadurl $uploadurl");
// Launch the upload URL if necessary (if this is indeed needed)
// await launchUrlString(uploadurl);
                            EasyLoading.dismiss();
                            Get.offAll(() => CheckUserType());
                            Get.to(
                                    () => RegistrationSuccessful(msg: uploadurl));
                          }*/
// Function to show confirmation dialog after the user has completed the URL action
                        },
                        text: "CONTINUE"),
                ],
              ),
            ),
          );
        });
  }
  Future<bool> _showReturnConfirmationDialog() async {
    return await showDialog(
      context: context,
      barrierDismissible: false, // The user must confirm before proceeding
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Action Completed'),
          content: Text(
              'Please confirm once you have completed the process in the browser.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context,
                    true); // User confirms they have completed the action
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    ) ??
        false;
  }
  Text completedText() {
    return Text("Completed",
        style: AppFonts.f50012.copyWith(color: Config.appTheme.defaultProfit));
  }
  Row pendingText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Pending", style: AppFonts.f50012),
        Icon(Icons.arrow_forward, size: 16)
      ],
    );
  }
  Map pages = {
    "Investor Information": InvestorInfo(),
    "Personal Info": PersonalInfo(),
    "Contact Info": ContactInfo(),
    "Nominee Info": NomineeInfo(),
    "Bank Details": BankInfo(),
    "Joint Holder Info": JointHolderInfoPage(),
    "NRI Info": NriInfo(),
    "Signature Info": Signature(),
  };
  String getLocalImage(String title) {
    title = title.toLowerCase();
    title = title.replaceAll(" ", "_");
    return "assets/registration/$title.png";
  }
}